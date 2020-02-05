/*
*
* Account Setup Integration
* Module: EFS App Manager
* Author: Derek Gilbert
* Initial Date: 3/20/2018
*
* Revision History: 04/Jun/2019 MFarrell    OTRONBOARD-35   New Fields added to contract section
*                   24/Jun/2019 MFarrell    OTRONBOARD-30   Moar Fields added to contract section
*                   25/Jun/2019 JArbegast   OTRONBOARD-44   Still not enough fields
*                   03/Jul/2019 MFarrell    OTRONBOARD-57   moving fields from program -> offer... because why not
*                   31/Jul/2019 CJackson    OTRONBOARD-78   Update ShipToCountry to CA for EFS
*                   30/Aug/2019 CJackson    OTRONBOARD-71   Added Parent Funded Only Flag
*                   04/Sep/2019 CJackson    OTRONBOARD-55   Payload Fees: Shipping and Embossing
*                   26/Sep/2019 MFarrell    OTRONBOARD-32   Online_Pay__c field on OnlineApplicationOffer__c now sets ach_allowed
*                                           OTRONBOARD-93   if Credit_Line_Approved__c or Credit_Line_Requested__c are null, and the offer is parent funded, send 0 instead of null.
*                                                           moved these fields to the contract section of the payload.
*                   29/10/2019 MFarrell     EFS             moved fees to custom metadata... because we all know it's going to change eventually.
*
*/

global class AccountWS_EFSAppManager {

    public final static String APPLICATION_NAME = 'EFS LLC Account Integration';

    public static Boolean integrationRunning { get; set; }

    public static EFS_App_Manager_Integration__c settings {
        get {
            return EFS_App_Manager_Integration__c.getOrgDefaults();
        }
    }

    public AccountWS_EFSAppManager() {

    }

    // Future method for Callout #1
    @future(callout=true)
    public static void integrateOnlineApplication_Future(Id onlineApplicationId) {
        String myQuery = onlineAppQuery(onlineApplicationId);
        // return generic list of sobjects or typecast to expected type
        List<OnlineApplication__c> records = Database.query(myQuery);
        if(records.size() > 0) {
            integrateOnlineApplication(records[0]);
        }
    }
    webservice static void testIntegrationFromButton(Id onlineApplicationId) {
        String myQuery = onlineAppQuery(onlineApplicationId);
        // return generic list of sobjects or typecast to expected type
        List<OnlineApplication__c> records = Database.query(myQuery);
        integrateOnlineApplication(records[0]);
    }
    public static String onlineAppQuery(Id onlineApplicationId){
        ID recordId = onlineApplicationId;
        DescribeSObjectResult describeResult = recordId.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        fieldNames.add('Opportunity__r.SBQQ__PrimaryQuote__c');
        String query = ' SELECT ' + String.join( fieldNames, ',' ) + ' FROM ' + describeResult.getName() + ' WHERE ' + ' id = \'' + recordId + '\' LIMIT 1 ';
        return query;
    }

    public class appManagerException extends Exception {}

    public static void integrateOnlineApplication(OnlineApplication__c onlineApplication) {

        integrationRunning = true;

        try {

            // Login Payload
            JSONGenerator loginPayload = JSON.createGenerator(true);

            loginPayload.writeStartObject();
            loginPayload.writeStringField('serviceId', settings.Username__c);
            loginPayload.writeStringField('servicePw', settings.Password__c);
            loginPayload.writeEndObject();

            Http http = new Http();

            HttpRequest httpRequest = new HttpRequest();

            httpRequest.setBody(loginPayload.getAsString());
            httpRequest.setEndpoint(settings.Endpoint__c + '/ogden-platform-ws/api/login');
            httpRequest.setTimeout(120000);
            httpRequest.setMethod('POST');
            httpRequest.setHeader('Accept', 'application/json');
            httpRequest.setHeader('Content-Type', 'application/json');

            HTTPResponse httpResponse = http.send(httpRequest);

            OgdenLoginResponse loginResponse = (OgdenLoginResponse) json.deserialize(httpResponse.getBody(), OgdenLoginResponse.class);

            if(httpResponse.getStatusCode() != 200 || (loginResponse != null && (loginResponse.status).equalsIgnoreCase('ERROR')) || (loginResponse != null && loginResponse.clientId == null)) {

                onlineApplication.Error_Log__c = 'integrateOnlineApplication: Error during LOGIN: ' + String.valueOf(httpResponse.getBody());

            } else {

                //here we do our for loop on contracts
                List<Contract__c> myContracts = new List<Contract__c>{null};
                if (onlineApplication.Carrier_ID_Number__c != null) {
                    myContracts = [SELECT Id, Funding_Option__c FROM Contract__c WHERE Online_Application__c = :onlineApplication.Id];
                }
                if (myContracts.size()==0) myContracts.add(null);
                System.debug('Contract List: ' + myContracts);

                List<Attachment> attachList = new List<Attachment>();
                List<HttpRequest> myPayloads = new List<HttpRequest>();

                for(Integer i = 0; i < myContracts.size(); i++) {

                    Contract__c oneContract = (myContracts[i]);
                    String firstPayload = buildPayload_callout1(onlineApplication, loginResponse.clientId, oneContract);

                    if(firstPayload != null) {

                        DateTime today = DateTime.now();
                        String dateStr =  today.format('MM-dd-yyyy_hh-mm-ss');

                        Blob myBlob = Blob.valueof(firstPayload);
                        Attachment a;
                        if(oneContract != null) a = new Attachment(parentid=oneContract.Id, Name = 'json_payload' + dateStr + '.txt' , Body = myBlob );
                        else a = new Attachment(parentid=onlineApplication.Id, Name = 'json_payload' + dateStr + '.txt' , Body = myBlob );
                        attachList.add(a);

                        // Send the payload to Ogden LLC
                        http = new Http();

                        httpRequest = new HttpRequest();

                        httpRequest.setBody(firstPayload);

                        // If child, then contract
                        // else, then carrier
                        if(onlineApplication.Carrier_ID_Number__c != null) {
                            httpRequest.setEndpoint(settings.Endpoint__c + '/ogden-platform-ws/api/salesforce/v3/provision/contract');
                        }
                        else {
                            httpRequest.setEndpoint(settings.Endpoint__c + '/ogden-platform-ws/api/salesforce/v3/provision/carrier');
                        }
                        httpRequest.setTimeout(120000);
                        httpRequest.setMethod('POST');
                        httpRequest.setHeader('Accept', 'application/json');
                        httpRequest.setHeader('Content-Type', 'application/json');

                        myPayloads.add(httpRequest);
                    }
                }

                List<HttpResponse> myResponses = new List<HttpResponse>();
                for(HttpRequest hr : myPayloads)
                    myResponses.add(http.send(httpRequest));

                for(HttpResponse hr : myResponses){

                    if(httpResponse.getStatusCode() == 200) {

                        System.debug(httpResponse.getBody());

                        Map<String, Object> payloadResponse = (Map<String, Object>) JSON.deserializeUntyped(httpResponse.getBody());

                        //OgdenPayloadResponse payload = (OgdenPayloadResponse) json.deserialize(httpResponse.getBody(), OgdenPayloadResponse.class);

                        if(payloadResponse != null && payloadResponse.get('status') == 'success') {
                            onlineApplication.Sent_To_Application_Manager__c = true;
                        }

                        onlineApplication.Error_Log__c = 'integrateOnlineApplication: Payload sent to Ogden LLC: ' + httpResponse.getBody();

                        // Logout.. for some reason
                        JSONGenerator logoutPayload = JSON.createGenerator(true);

                        logoutPayload.writeStartObject();
                        logoutPayload.writeStringField('clientId', loginResponse.clientId);
                        logoutPayload.writeEndObject();

                        http = new Http();

                        httpRequest = new HttpRequest();

                        httpRequest.setBody(logoutPayload.getAsString());
                        httpRequest.setEndpoint(settings.Endpoint__c + '/ogden-platform-ws/api/logout');
                        httpRequest.setTimeout(120000);
                        httpRequest.setMethod('POST');
                        httpRequest.setHeader('Accept', 'application/json');
                        httpRequest.setHeader('Content-Type', 'application/json');

                        httpResponse = http.send(httpRequest);

                    }
                    else {
                        throw new appManagerException('integrateOnlineApplication: Error connecting to App Manager: ' + httpResponse.getBody());
                    }

                }
                insert attachList;
            }

        }
        catch(Exception e) {
            String errorCode = WEXDEVErrorReporting.reportInternalError(APPLICATION_NAME, null, UserInfo.getUserId(), e);

            onlineApplication.Error_Log__c = 'Error Sending To LLC: ' + e.getMessage() + '(Error Code: ' + errorCode + ')';
        }

        upsert onlineApplication;

    }

    // Callout #1 - Integrate Contract/Carrier payloads to Application Manager
    public static String buildPayload_callout1(OnlineApplication__c onlineApplication, String clientId, Contract__c myContract) {

        Account onlineApplicationAccount = null;
        Account onlineApplicationParentAccount = null;
        Program__c onlineApplicationProgram = null;
        OnlineApplicationOffer__c onlineApplicationOffer = null;
        Boolean hasSmartfunds = false;
        Boolean hasMastercard = false;
        Boolean hasATM = false;
        Set<String> selectedOtherServices = new Set<String>();

        // Grabbing additional data
        if(onlineApplication.Account__c != null) {
            onlineApplicationAccount = [SELECT Id, Name, CurrencyIsoCode, Preferred_Language__c, Physical_Country__c, Parent.Id FROM Account WHERE Id =: onlineApplication.Account__c];

            if(onlineApplicationAccount.Parent.Id != null) {
                onlineApplicationParentAccount = [SELECT Id, Carrier_ID__c FROM Account WHERE Id =: onlineApplicationAccount.Parent.Id];
            }
        }

        if(onlineApplication.Offer__c != null) {
            onlineApplicationOffer = [SELECT Id, ATM_Use__c, Cash_Limit__c, Daily_Cash_Limit__c, Daily_MC_Limit__c,
                    Funding__c, Limit_Method__c, PSR_ATM_Limit__c, PSR_Card_Fee__c, PSR_Fuel_Cash__c, PSR_Marketing_Fee__c, PSR_Money_Code__c,
                    PSR_Scales__c, MC_Limit__c, Setup_Fee__c, Trans_Limit__c, Tier_ID__c, Approval_Type__c, Primary_Contact_Email_Address__c, Available_Funding_Options__c,
                    Create_Letter__c, Notice_Delivery__c, Online_Pay__c,Card_Style__c,Cards_per_1_Requested__c,Card_Shipping_Method__c,Card_Type__c,Account_Descriptor__c,
                    Child_Funded_Issuer_ID__c, Parent_Funded_Issuer_ID__c, Issuer_Group__c, Parent_Carrier_ID__c, Card_Order_Type__c, Statement_Type__c, Customer_Type__c, Product_Type__c
            FROM OnlineApplicationOffer__c
            WHERE Id =: onlineApplication.Offer__c LIMIT 1];
        }
        if(onlineApplication.Other_Services__c != null) {
            for(String product : (onlineApplication.Other_Services__c).split(';')) {
                selectedOtherServices.add(product.toLowerCase());
                if(product.containsIgnoreCase('smartfunds')) hasSmartfunds = true;
                if(product.containsIgnoreCase('mastercard')) hasMastercard = true;
                if(product.containsIgnoreCase('atm')) hasATM = true;
            }
        }
        if(hasMastercard != true && onlineApplicationOffer.Product_Type__c.containsIgnoreCase('mastercard')) {
            hasMastercard = true;
        }
        if(hasSmartfunds != true && onlineApplicationOffer.Product_Type__c.containsIgnoreCase('smartfunds')) {
            hasSmartfunds = true;
        }

        if(onlineApplication.Program__c != null) {
            onlineApplicationProgram = [SELECT Id,  Card_Press_ID__c, Lockbox_Value__c, Partner_Territory__r.Name
            FROM Program__c
            WHERE Id =: onlineApplication.Program__c LIMIT 1];
        }

        CardFees myFees = new CardFees(onlineApplication);

        //if parent & secondary, and carrier id not blank, we treat as child funded
        Boolean treatAsParent = false;
        Boolean treatAsAChild = false;
        if(onlineApplicationOffer.Funding__c.containsIgnoreCase('Parent')){
            if(onlineApplicationOffer.Funding__c.containsIgnoreCase('Secondary')){
                if(onlineApplication.Carrier_ID_Number__c == null) treatAsParent = true;
                else {
                    //now to see if this is a parent/secondary for an existing carrier
                    if(isInitialPayload(onlineApplication)) treatAsParent = true; //already sent this application once
                    else treatAsAChild = true; //haven't sent this application yet
                }
            } else {
                treatAsParent = true;
            }
        }

        List<OnlineApplicationDriverSetup__c> onlineApplicationDriverSetups = [SELECT Id, Driver_Name__c, Driver_ID__c FROM OnlineApplicationDriverSetup__c WHERE Online_Application__c =: onlineApplication.Id];

        List<OnlineApplicationUnitNumber__c> onlineApplicationUnitNumbers = [SELECT Id, Name FROM OnlineApplicationUnitNumber__c WHERE Online_Application__c =: onlineApplication.Id];

        // Build DAS package!
        JSONGenerator jsonPayload = JSON.createGenerator(true);

        // Start of payload
        jsonPayload.writeStartObject();

        jsonPayload.writeStringField('client_id', clientId);
        jsonPayload.writeFieldName('payload');
        jsonPayload.writeStartObject();

        if(onlineApplication.Carrier_ID_Number__c != null) jsonPayload.writeStringField('carrier_id', onlineApplication.Carrier_ID_Number__c);
        if(onlineApplicationOffer != null && onlineApplicationOffer.Parent_Carrier_ID__c != null) jsonPayload.writeStringField('original_parent_carrier_id', onlineApplicationOffer.Parent_Carrier_ID__c);
        if(onlineApplication.Application_Manager_ID__c != null) jsonPayload.writeStringField('app_id', onlineApplication.Application_Manager_ID__c);

        if(onlineApplication.Carrier_ID_Number__c == null) {
            // Start of "cardOrder"
            jsonPayload.writeFieldName('cardOrder');
            jsonPayload.writeStartObject();

            jsonPayload.writeNumberField('policyNumber', 1);
            if(onlineApplicationOffer.Card_Order_Type__c != null) jsonPayload.writeNumberField('orderType', Integer.valueOf(onlineApplicationOffer.Card_Order_Type__c));
            if(onlineApplicationOffer.Card_Style__c != null) jsonPayload.writeNumberField('cardStyle', Integer.valueOf(onlineApplicationOffer.Card_Style__c));
            // Certain Programs send additional cards to the customer.
            if(onlineApplication.Number_of_Cards_Needed__c != null && onlineApplicationOffer.Cards_per_1_Requested__c == null) jsonPayload.writeNumberField('orderQty', Integer.valueOf(onlineApplication.Number_of_Cards_Needed__c));
            if(onlineApplication.Number_of_Cards_Needed__c != null && onlineApplicationOffer.Cards_per_1_Requested__c != null) jsonPayload.writeNumberField('orderQty', Integer.valueOf(onlineApplication.Number_of_Cards_Needed__c * onlineApplicationOffer.Cards_per_1_Requested__c));
            if((onlineApplication.Card_Shipping_Country__c).equalsIgnoreCase('US')) {
                jsonPayload.writeStringField('shipToCountry', 'USA');
            }
            if((onlineApplication.Card_Shipping_Country__c).equalsIgnoreCase('CA')) {
                jsonPayload.writeStringField('shipToCountry', 'CA');
            }
            if(onlineApplicationOffer.Card_Shipping_Method__c != null) jsonPayload.writeStringField('shippingMethod', onlineApplicationOffer.Card_Shipping_Method__c);
            if(onlineApplication.Embossing_Line_1_Company_Name__c != null) jsonPayload.writeStringField('embossedName', onlineApplication.Embossing_Line_1_Company_Name__c.replaceAll('[^a-zA-Z0-9 -]', ''));
            if(onlineApplication.Card_Shipping_First_Name__c != null) jsonPayload.writeStringField('shipToFirst', onlineApplication.Card_Shipping_First_Name__c.replaceAll('[^a-zA-Z0-9 -]', ''));
            if(onlineApplication.Card_Shipping_City__c != null) jsonPayload.writeStringField('shipToCity', onlineApplication.Card_Shipping_City__c.replaceAll('[^a-zA-Z0-9 -]', ''));
            if(onlineApplication.Card_Shipping_Postal_Code__c != null) jsonPayload.writeStringField('shipToZip', onlineApplication.Card_Shipping_Postal_Code__c);
            if(onlineApplication.Card_Shipping_Address_Line_1__c != null) jsonPayload.writeStringField('shipToAddress1', onlineApplication.Card_Shipping_Address_Line_1__c.replaceAll('[^a-zA-Z0-9 -]', ''));
            if(onlineApplication.Card_Shipping_Address_Line_2__c != null) jsonPayload.writeStringField('shipToAddress2', onlineApplication.Card_Shipping_Address_Line_2__c.replaceAll('[^a-zA-Z0-9 -]', ''));
            if(onlineApplication.Card_Shipping_Last_Name__c != null) jsonPayload.writeStringField('shipToLast', onlineApplication.Card_Shipping_Last_Name__c.replaceAll('[^a-zA-Z0-9 -]', ''));
            jsonPayload.writeStringField('rushProcessing', 'Y');
            if(onlineApplication.Card_Shipping_State__c != null) jsonPayload.writeStringField('shipToState', onlineApplication.Card_Shipping_State__c);
            jsonPayload.writeStringField('cardCarrier', 'N');

            // Start of "cards"
            Integer cardIndex = 1;

            jsonPayload.writeFieldName('cards');
            jsonPayload.writeStartArray();

            for(OnlineApplicationDriverSetup__c onlineApplicationDriverSetup : onlineApplicationDriverSetups) {

                if(onlineApplicationDriverSetup.Driver_ID__c != null && onlineApplicationDriverSetup.Driver_Name__c != null) {

                    jsonPayload.writeStartObject();

                    jsonPayload.writeNumberField('idx', cardIndex);
                    jsonPayload.writeFieldName('cardProps');
                    jsonPayload.writeStartArray();

                    jsonPayload.writeStartObject();
                    jsonPayload.writeStringField('key', 'drid');
                    jsonPayload.writeStringField('value', onlineApplicationDriverSetup.Driver_ID__c);
                    jsonPayload.writeEndObject();

                    jsonPayload.writeStartObject();
                    jsonPayload.writeStringField('key', 'name');
                    jsonPayload.writeStringField('value', onlineApplicationDriverSetup.Driver_Name__c);
                    jsonPayload.writeEndObject();

                    jsonPayload.writeStartObject();
                    jsonPayload.writeStringField('key', 'defCardStatus');
                    jsonPayload.writeStringField('value', 'A');
                    jsonPayload.writeEndObject();

                    jsonPayload.writeEndArray();

                    jsonPayload.writeEndObject();

                    cardIndex++;

                }

            }

            jsonPayload.writeEndArray();

            jsonPayload.writeEndObject();

            // Left here...

            // Start of "carrier"
            jsonPayload.writeFieldName('carrier');
            jsonPayload.writeStartObject();

            if(onlineApplicationAccount.Name != null) jsonPayload.writeStringField('carrier_name', onlineApplicationAccount.Name);
            if(onlineApplication.Business_Street_Address__c != null) jsonPayload.writeStringField('mailing_address1', onlineApplication.Business_Street_Address__c.replaceAll('[^a-zA-Z0-9 -]', ''));
            if(onlineApplication.City__c != null) jsonPayload.writeStringField('mailing_city', onlineApplication.City__c.replaceAll('[^a-zA-Z0-9 -]', ''));
            if(onlineApplication.State__c != null) jsonPayload.writeStringField('mailing_state', onlineApplication.State__c);
            if(onlineApplication.Country__c != null) jsonPayload.writeStringField('mailing_country', onlineApplication.Country__c);
            if(onlineApplication.Zip_Code__c != null) jsonPayload.writeStringField('mailing_zip', onlineApplication.Zip_Code__c);
            if(onlineApplication.Date_Decisioned__c != null) jsonPayload.writeStringField('approved_date', String.valueOf(onlineApplication.Date_Decisioned__c.format('yyyy-MM-dd')));
            if(onlineApplication.Phone_Number__c != null) jsonPayload.writeStringField('phone', onlineApplication.Phone_Number__c);
            if(onlineApplication.Fax_Number__c != null) jsonPayload.writeStringField('fax', onlineApplication.Fax_Number__c);
            if(onlineApplication.Email__c != null) jsonPayload.writeStringField('email', onlineApplication.Email__c);
            if(onlineApplication.Contact_First_Name__c != null && onlineApplication.Contact_Last_Name__c != null) jsonPayload.writeStringField('contact_name', onlineApplication.Contact_First_Name__c.replaceAll('[^a-zA-Z0-9 -]', '') + ' ' + onlineApplication.Contact_Last_Name__c.replaceAll('[^a-zA-Z0-9 -]', ''));
            if(onlineApplication.AO_Title__c != null) jsonPayload.writeStringField('contact_position', onlineApplication.AO_Title__c);
            jsonPayload.writeStringField('status', 'A');
            if(onlineApplication.Number_of_Trucks__c != null) jsonPayload.writeNumberField('company_vehicles', onlineApplication.Number_of_Trucks__c);
            if(onlineApplication.Number_of_Trucks__c != null) jsonPayload.writeNumberField('owner_op_vehicles', onlineApplication.Number_of_Trucks__c);
            // If Online App Territory Code is present, always send that
            if(onlineApplication.Territory_Code__c != null) jsonPayload.writeStringField('sales_territory', onlineApplication.Territory_Code__c);
            //If Online App Territory Code is null, send territory from the program.
            if(onlineApplicationProgram.Partner_Territory__r.Name != null && onlineApplication.Territory_Code__c == null) jsonPayload.writeStringField('sales_territory', onlineApplicationProgram.Partner_Territory__r.Name);
            //If Online App and Program are null, send default.
            if(onlineApplicationProgram.Partner_Territory__r.Name == null && onlineApplication.Territory_Code__c == null) jsonPayload.writeStringField('sales_territory', 'UN');
            if(onlineApplicationOffer.Issuer_Group__c != null) jsonPayload.writeStringField('credit_group_id', onlineApplicationOffer.Issuer_Group__c);
            if(onlineApplication.Card_Shipping_Address_Line_1__c != null) jsonPayload.writeStringField('shipping_address1', onlineApplication.Card_Shipping_Address_Line_1__c.replaceAll('[^a-zA-Z0-9 -]', ''));
            if(onlineApplication.Card_Shipping_City__c != null) jsonPayload.writeStringField('shipping_city', onlineApplication.Card_Shipping_City__c.replaceAll('[^a-zA-Z0-9 -]', ''));
            if(onlineApplication.Card_Shipping_State__c != null) jsonPayload.writeStringField('shipping_state', onlineApplication.Card_Shipping_State__c);
            if(onlineApplication.Card_Shipping_Country__c != null) jsonPayload.writeStringField('shipping_country', onlineApplication.Card_Shipping_Country__c);
            if(onlineApplication.Card_Shipping_Postal_Code__c != null) jsonPayload.writeStringField('shipping_zip', onlineApplication.Card_Shipping_Postal_Code__c);
            if(onlineApplication.Federal_Tax_ID__c != null) jsonPayload.writeStringField('tax_id', onlineApplication.Federal_Tax_ID__c);
            if(onlineApplicationOffer != null && onlineApplicationOffer.Parent_Carrier_ID__c != null) jsonPayload.writeStringField('original_parent_carrier_id', onlineApplicationOffer.Parent_Carrier_ID__c);
                //else jsonPayload.writeNullField('original_parent_carrier_id');
            jsonPayload.writeStringField('parent_type', 'group');
            if(onlineApplicationOffer.Customer_Type__c != null) jsonPayload.writeStringField('customer_type', onlineApplicationOffer.Customer_Type__c);
            if(onlineApplicationOffer.Funding__c != null) jsonPayload.writeStringField('relationship_type', onlineApplicationOffer.Funding__c);

            // End of "carrier"
            jsonPayload.writeEndObject();

        }

        // Start of "contract"
        jsonPayload.writeFieldName('contract');

        if(onlineApplication.Carrier_ID_Number__c == null) {
            jsonPayload.writeStartArray();
        }
        jsonPayload.writeStartObject();

        if(myContract != null) {
            jsonPayload.writeStringField('application_id', myContract.Id);
        } else {
            jsonPayload.writeStringField('application_id', onlineApplication.Id);
        }
        //otronboard-59
        if(onlineApplication.Carrier_ID_Number__c != null) {
            jsonPayload.writeNumberField('link_secondary_threshold', 100);
            jsonPayload.writeStringField('link_as_secondary', 'Y');
        }

        if(treatAsParent)jsonPayload.writeStringField('dont_do_oracle', 'Y');

        // Start of "policy"
        jsonPayload.writeFieldName('policy');
        jsonPayload.writeStartObject();

        Integer polNumber = onlineApplication.Carrier_ID_Number__c == null ? 1 : 2;
        jsonPayload.writeNumberField('policyNumber', polNumber);

        jsonPayload.writeFieldName('header');
        jsonPayload.writeStartObject();
        if(onlineApplication.Carrier_ID_Number__c != null){
            jsonPayload.writeStringField('description', 'New Policy');
        } else {
            jsonPayload.writeStringField('description', 'Default Policy');
        }
        jsonPayload.writeBooleanField('handEnter', false);
        jsonPayload.writeNumberField('payrollContractId', 0);

        if(selectedOtherServices != null){

            if(selectedOtherServices.contains('fleet mastercard')) jsonPayload.writeStringField('mc_fleet','Y');

            Boolean payroll = false;
            if(hasSmartfunds) {
                if (selectedOtherServices.contains('ach transfer')) jsonPayload.writeBooleanField('payrollAch', true);
                if (selectedOtherServices.contains('debit use')) jsonPayload.writeBooleanField('payrollDebit', true);
                payroll = true;
            }
            jsonPayload.writeBooleanField('payrollAtm', payroll);
            jsonPayload.writeBooleanField('payrollChk', payroll);
            jsonPayload.writeBooleanField('payrollWire', payroll);

        }

        jsonPayload.writeBooleanField('defCardMgdFuel', false);
        jsonPayload.writeBooleanField('defCardMgdNonFuel', false);
        jsonPayload.writeEndObject();

        // Start of "limits"
        jsonPayload.writeFieldName('limits');
        jsonPayload.writeStartArray();

        if (onlineApplication.Daily_Fuel_Gallons__c != null) {
            jsonPayload.writeStartObject();
            jsonPayload.writeStringField('limitId', 'DSL');
            jsonPayload.writeNumberField('limit', onlineApplication.Daily_Fuel_Gallons__c);
            jsonPayload.writeNumberField('hours', 0);
            jsonPayload.writeNumberField('minHours', 0);
            jsonPayload.writeNumberField('autoRollMax', 0);
            jsonPayload.writeNumberField('autoRollMap', 127);
            jsonPayload.writeEndObject();
        }

        if (onlineApplication.Daily_Cash_Limit__c != null) {
            jsonPayload.writeStartObject();
            jsonPayload.writeStringField('limitId', 'CADV');
            jsonPayload.writeNumberField('limit', onlineApplication.Daily_Cash_Limit__c);
            jsonPayload.writeNumberField('hours', 24);
            jsonPayload.writeNumberField('minHours', 0);
            jsonPayload.writeEndObject();
        }

        if (onlineApplication.Daily_DEF_Limit__c != null) {
            jsonPayload.writeStartObject();
            jsonPayload.writeStringField('limitId', 'DEF');
            jsonPayload.writeNumberField('limit', onlineApplication.Daily_DEF_Limit__c);
            jsonPayload.writeNumberField('hours', 0);
            jsonPayload.writeNumberField('minHours', 0);
            jsonPayload.writeNumberField('autoRollMax', 0);
            jsonPayload.writeNumberField('autoRollMap', 127);
            jsonPayload.writeEndObject();
        }

        if (onlineApplication.Daily_Fuel_Gallons__c != null) {
            jsonPayload.writeStartObject();
            jsonPayload.writeStringField('limitId', 'ULSD');
            jsonPayload.writeNumberField('limit', onlineApplication.Daily_Fuel_Gallons__c);
            jsonPayload.writeNumberField('hours', 0);
            jsonPayload.writeNumberField('minHours', 0);
            jsonPayload.writeNumberField('autoRollMax', 0);
            jsonPayload.writeNumberField('autoRollMap', 127);
            jsonPayload.writeEndObject();
        }

        jsonPayload.writeEndArray();
        // End of "limits"

        // Start of "infos"
        jsonPayload.writeFieldName('infos');
        jsonPayload.writeStartArray();

        if (onlineApplication.Odometer__c == true) {
            jsonPayload.writeStartObject();
            jsonPayload.writeStringField('infoId', 'ODRD');
            jsonPayload.writeStringField('validationType', 'NUMERIC');
            jsonPayload.writeEndObject();
        }

        if (onlineApplication.Trip__c == true) {
            jsonPayload.writeStartObject();
            jsonPayload.writeStringField('infoId', 'TRIP');
            jsonPayload.writeStringField('validationType', 'ALPHANUMERIC');
            jsonPayload.writeEndObject();
        }

        if (onlineApplication.Unit__c == true && onlineApplicationUnitNumbers.size() > 0) {
            jsonPayload.writeStartObject();
            jsonPayload.writeStringField('infoId', 'UNIT');
            jsonPayload.writeStringField('validationType', 'INFO_POOL');
            jsonPayload.writeFieldName('poolValues');
            jsonPayload.writeStartArray();

            for (OnlineApplicationUnitNumber__c unitNumber : onlineApplicationUnitNumbers) {

                jsonPayload.writeString(unitNumber.Name);

            }

            jsonPayload.writeEndArray();
            jsonPayload.writeEndObject();
        }

        jsonPayload.writeEndArray();
        // End of "infos"

        // Start of refresh limits
        if(hasMastercard) {
            jsonPayload.writeFieldName('refreshLimits');
            jsonPayload.writeStartObject();
            if (onlineApplication.Daily_Amount_Requested__c != null) jsonPayload.writeNumberField('dailyAmount', onlineApplication.Daily_Amount_Requested__c);
            if (onlineApplication.Daily_Transactions__c != null) jsonPayload.writeNumberField('dailyCount', onlineApplication.Daily_Transactions__c);
            if (onlineApplication.Monthly_Amount_Requested__c != null) jsonPayload.writeNumberField('monthlyAmount', onlineApplication.Monthly_Amount_Requested__c);
            if (onlineApplication.Monthly_Transactions__c != null) jsonPayload.writeNumberField('monthlyCount', onlineApplication.Monthly_Transactions__c);
            if (onlineApplication.Weekly_Amount_Requested__c != null) jsonPayload.writeNumberField('weeklyAmount', onlineApplication.Weekly_Amount_Requested__c);
            if (onlineApplication.Weekly_Transactions__c != null) jsonPayload.writeNumberField('weeklyCount', onlineApplication.Weekly_Transactions__c);
            jsonPayload.writeEndObject();
        }
        // End of "refresh limits"

        //start merchant category codes
        //if all merchants is selected, send true and 999999
        if (onlineApplication.Allowed_Merchant_Categories__c != null && onlineApplication.Allowed_Merchant_Categories__c.contains('All Merchants')) {
            jsonPayload.writeBooleanField('allowAllMerchantCategoryCodes', true);
            jsonPayload.writeFieldName('merchantCategoryCodes');
            jsonPayload.writeStartArray();
                jsonPayload.writeNumber(999999);
            jsonPayload.writeEndArray();
            //if select merchants are selected, send false and each merchant code.
        } else if (onlineApplication.Allowed_Merchant_Categories__c != null) {
            jsonPayload.writeBooleanField('allowAllMerchantCategoryCodes', false);
            jsonPayload.writeFieldName('merchantCategoryCodes');
            jsonPayload.writeStartArray();
                for (String s : onlineApplication.Allowed_Merchant_Categories__c.split(';')) {
                    if (s.isNumeric()) {
                        jsonPayload.writeNumber(Integer.valueOf(s));
                    }
                }
            jsonPayload.writeEndArray();
        }
        //end merchant category codes

        jsonPayload.writeEndObject();
        // End of "policy"

        // Start of carrier fees
        jsonPayload.writeFieldName('carrier_fees');

        jsonPayload.writeStartArray();

        if(myFees.mcLocationFee != null && myFees.mcLocationFee != '') {
            jsonPayload.writeStartObject();

                jsonPayload.writeStringField('loc_type', 'MCLO');
                jsonPayload.writeStringField('carr_fee', myFees.mcLocationFee);

            jsonPayload.writeEndObject();
        }

        jsonPayload.writeEndArray();
        // End of carrier fees

        // Start driver fees
        jsonPayload.writeFieldName('driver_fees');

        jsonPayload.writeStartArray();

        if(myFees.monthlyFee != null && myFees.monthlyFee != '') {
            jsonPayload.writeStartObject();

                jsonPayload.writeStringField('description', 'Monthly Usage Card Fee');
                jsonPayload.writeStringField('fee_id', myFees.monthlyPC);
                jsonPayload.writeStringField('fee_amt', myFees.monthlyFee);
                jsonPayload.writeStringField('fee_level', '2');
                jsonPayload.writeStringField('fee_type', '1');
                jsonPayload.writeStringField('fee_max_times_per', '4');
                jsonPayload.writeStringField('fee_max_times', '0');
                jsonPayload.writeStringField('fee_min_start_per', '4');
                jsonPayload.writeStringField('fee_min_start', '0');

            jsonPayload.writeEndObject();
        }

        if(onlineApplication.Other_Services__c != null && (onlineApplication.Other_Services__c).contains('SmartFunds')) {

            jsonPayload.writeStartObject();

                jsonPayload.writeStringField('description', 'D FEE REGULAR CHECK');
                jsonPayload.writeStringField('fee_id', '112');
                jsonPayload.writeStringField('fee_amt', '2.50');
                jsonPayload.writeStringField('fee_level', '1');
                jsonPayload.writeStringField('fee_type', '1');
                jsonPayload.writeStringField('fee_max_times_per', '4');
                jsonPayload.writeStringField('fee_max_times', '0');
                jsonPayload.writeStringField('fee_min_times_per', '4');
                jsonPayload.writeStringField('fee_min_times', '0');

            jsonPayload.writeEndObject();

        }

        if(myFees.mcOvernightShippingFee != null && myFees.mcOvernightShippingFee != '') {
            jsonPayload.writeStartObject();

                jsonPayload.writeStringField('description', 'MC FEE OVERNIGHT CARD SHIPMENT');
                jsonPayload.writeStringField('fee_id', myFees.mcOvernightShippingPC);
                jsonPayload.writeStringField('fee_amt', myFees.mcOvernightShippingFee);
                jsonPayload.writeStringField('fee_level', '3');
                jsonPayload.writeStringField('fee_type', '1');
                jsonPayload.writeStringField('fee_max_times_per', '4');
                jsonPayload.writeStringField('fee_min_start_per', '4');

            jsonPayload.writeEndObject();
        }

        if(myFees.mcEmbossingFee != null && myFees.mcEmbossingFee != '') {
            jsonPayload.writeStartObject();

                jsonPayload.writeStringField('description', 'MC FEE SAME DAY EMBOSSING');
                jsonPayload.writeStringField('fee_id', myFees.mcEmbossingPC);
                jsonPayload.writeStringField('fee_amt', myFees.mcEmbossingFee);
                jsonPayload.writeStringField('fee_level', '3');
                jsonPayload.writeStringField('fee_type', '1');
                jsonPayload.writeStringField('fee_max_times_per', '4');
                jsonPayload.writeStringField('fee_min_start_per', '4');

            jsonPayload.writeEndObject();
        }


        jsonPayload.writeEndArray();
        // End driver fees

        if(hasMastercard) jsonPayload.writeStringField('velocity_enable', 'Y');
        if(onlineApplicationAccount.Name != null) jsonPayload.writeStringField('contract_name', onlineApplicationAccount.Name);
        if(onlineApplicationOffer.Tier_ID__c != null) jsonPayload.writeStringField('tier_id', onlineApplicationOffer.Tier_ID__c);
        jsonPayload.writeStringField('is_master', 'N');
        if(onlineApplicationOffer.Card_Type__c != null) jsonPayload.writeStringField('card_type', onlineApplicationOffer.Card_Type__c);
        if(onlineApplicationOffer.Card_Style__c != null) jsonPayload.writeStringField('card_style', onlineApplicationOffer.Card_Style__c);
        if(onlineApplication.Prompt_Type__c != null) jsonPayload.writeStringField('PromptCode', onlineApplication.Prompt_Type__c);
        if(onlineApplication.Prompt_Type__c != null) jsonPayload.writeStringField('PromptCode', onlineApplication.Prompt_Type__c);
        // Certain Programs send additional cards to the customer
        if(onlineApplication.Number_of_Cards_Needed__c != null && onlineApplicationOffer.Cards_per_1_Requested__c == null) jsonPayload.writeNumberField('num_of_cards_to_create', Integer.valueOf(onlineApplication.Number_of_Cards_Needed__c));
        if(onlineApplication.Number_of_Cards_Needed__c != null && onlineApplicationOffer.Cards_per_1_Requested__c != null) jsonPayload.writeNumberField('num_of_cards_to_create', Integer.valueOf(onlineApplication.Number_of_Cards_Needed__c * onlineApplicationOffer.Cards_per_1_Requested__c));
        if(onlineApplication.Date_Decisioned__c != null) jsonPayload.writeStringField('approved_date', String.valueOf(onlineApplication.Date_Decisioned__c.format('yyyy-MM-dd')));
        if(onlineApplication.Direct_Bill_Only__c != null && onlineApplication.Direct_Bill_Only__c == false) jsonPayload.writeStringField('direct_bill', 'N');
        if(onlineApplication.Direct_Bill_Only__c != null && onlineApplication.Direct_Bill_Only__c == true) jsonPayload.writeStringField('direct_bill', 'Y');
        if(onlineApplicationAccount.Preferred_Language__c != null && (onlineApplicationAccount.Preferred_Language__c).equalsIgnoreCase('ENG')) { jsonPayload.writeStringField('language', '1'); }
        if(onlineApplicationAccount.Preferred_Language__c != null &&  (onlineApplicationAccount.Preferred_Language__c).equalsIgnoreCase('FRE')) { jsonPayload.writeStringField('language', '2'); }
        if(onlineApplicationAccount.Preferred_Language__c == null) { jsonPayload.writeStringField('language', '1'); }
        if(onlineApplication.Terms_ID__c != null) jsonPayload.writeStringField('terms', onlineApplication.Terms_ID__c);
        if(onlineApplication.Cycle_ID__c != null) jsonPayload.writeStringField('cycle_code', onlineApplication.Cycle_ID__c);

        if(onlineApplication.Carrier_ID_Number__c != null && onlineApplicationOffer.Child_Funded_Issuer_ID__c != null) {
            jsonPayload.writeStringField('issuer_id', onlineApplicationOffer.Child_Funded_Issuer_ID__c);
        } else {
            if(treatAsParent && onlineApplicationOffer.Parent_Funded_Issuer_ID__c != null) jsonPayload.writeStringField('issuer_id', onlineApplicationOffer.Parent_Funded_Issuer_ID__c);
            else if(onlineApplicationOffer.Child_Funded_Issuer_ID__c != null) jsonPayload.writeStringField('issuer_id', onlineApplicationOffer.Child_Funded_Issuer_ID__c);
        }

        if(onlineApplicationProgram.Lockbox_Value__c != null) jsonPayload.writeStringField('lockbox', onlineApplicationProgram.Lockbox_Value__c);

        if(onlineApplication.Prepaid__c == true) {
            jsonPayload.writeStringField('mgr_code', '1DRW');
        }
        else {
            if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Internet Pay')) {
                jsonPayload.writeStringField('mgr_code', '1MAN');
            }
            else if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Auto Draft')) {
                jsonPayload.writeStringField('mgr_code', '1PAD');
            }
            else if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Wire')) {
                jsonPayload.writeStringField('mgr_code', '1WIR');
            }
            else if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Customer Initiated ACH')) {
                jsonPayload.writeStringField('mgr_code', '1WIR');
            }
            else if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Faxed Electronichek')) {
                jsonPayload.writeStringField('mgr_code', '1CHK');
            }
        }

        if(onlineApplicationOffer.Online_Pay__c != null && onlineApplicationOffer.Online_Pay__c == true) {
            jsonPayload.writeStringField('ach_allowed', 'Y');
        } else {
            jsonPayload.writeStringField('ach_allowed', 'N');
        }
        if(treatAsParent) jsonPayload.writeStringField('mgr_code', 'wire');
        else if(onlineApplicationOffer.Account_Descriptor__c != null) jsonPayload.writeStringField('mgr_code', onlineApplicationOffer.Account_Descriptor__c);

        jsonPayload.writeStringField('service_charge', 'Y');
        jsonPayload.writeStringField('late_payment', 'Y');
        jsonPayload.writeStringField('invoice_close_method', 'Y');
        if(onlineApplicationOffer.Statement_Type__c != null) jsonPayload.writeStringField('stmt_format', onlineApplicationOffer.Statement_Type__c);
        jsonPayload.writeStringField('print_statement', 'N');
        if((onlineApplication.Invoice_Delivery_Method__c).equals('Internet')) jsonPayload.writeStringField('statement_dist_type', 'R');
        if(!(onlineApplication.Invoice_Delivery_Method__c).equals('Internet')) jsonPayload.writeStringField('statement_dist_type', 'E');
        if(onlineApplication.Invoice_Delivery_Method_Email__c != null) jsonPayload.writeStringField('statement_email', onlineApplication.Invoice_Delivery_Method_Email__c);
        if(!treatAsParent && onlineApplication.ABA_Routing_Number__c != null) jsonPayload.writeStringField('bank_routing_number', onlineApplication.ABA_Routing_Number__c);
        if(!treatAsParent && onlineApplication.Checking_Account_Number__c != null) jsonPayload.writeStringField('bank_account_number', onlineApplication.Checking_Account_Number__c);
        jsonPayload.writeStringField('bank_account_type', 'D');
        if(onlineApplicationAccount.CurrencyIsoCode != null) jsonPayload.writeStringField('currency', onlineApplicationAccount.CurrencyIsoCode);
        jsonPayload.writeStringField('unit_of_measure', 'G');
        if(treatAsParent) jsonPayload.writeStringField('credit_line_type','None');
        else if(onlineApplication.Prepaid__c == true) jsonPayload.writeStringField('credit_line_type', 'Draw Down');
        else if(onlineApplication.Prepaid__c == false) jsonPayload.writeStringField('credit_line_type', 'Open Line');
        if(treatAsParent){
            jsonPayload.writeStringField('payment_method', 'wire');
            jsonPayload.writeStringField('payment_frequency', 'DAILY');
        } else {
            if (onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Auto Draft')) jsonPayload.writeStringField('payment_method', 'ACH Draft');
            if (onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Online Payment')) jsonPayload.writeStringField('payment_method', 'None');
            if (onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Internet Pay')) jsonPayload.writeStringField('payment_method', 'None');
            if (onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Customer Initiated ACH')) jsonPayload.writeStringField('payment_method', 'Wire');
            if (onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Customer ACH')) jsonPayload.writeStringField('payment_method', 'Wire');
            if (onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Wire')) jsonPayload.writeStringField('payment_method', 'Wire');
            if (onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Western Union')) jsonPayload.writeStringField('payment_method', 'Wire');
            if (onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Faxed Electronichek')) jsonPayload.writeStringField('payment_method', 'Check');
            if(onlineApplication.Payment_Frequency__c != null) jsonPayload.writeStringField('payment_frequency', onlineApplication.Payment_Frequency__c);
        }

        if(treatAsParent){
            jsonPayload.writeStringField('billing_cycle', 'daily');
            jsonPayload.writeStringField('payment_terms', 'net10');
        } else {
            if(onlineApplication.Billing_Cycle__c != null) jsonPayload.writeStringField('billing_cycle', onlineApplication.Billing_Cycle__c);
            if(onlineApplication.Payment_Terms__c != null) jsonPayload.writeStringField('payment_terms', onlineApplication.Payment_Terms__c);
        }

        if(onlineApplication.Prepaid__c == true) jsonPayload.writeStringField('req_credit_line_type', 'Draw Down');
        if(onlineApplication.Prepaid__c == false) jsonPayload.writeStringField('req_credit_line_type', 'Open Line');
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Auto Draft')) jsonPayload.writeStringField('req_payment_method', 'ACH Draft');
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Online Payment')) jsonPayload.writeStringField('req_payment_method', 'None');
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Internet Pay')) jsonPayload.writeStringField('req_payment_method', 'None');
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Customer Initiated ACH')) jsonPayload.writeStringField('req_payment_method', 'Wire');
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Customer ACH')) jsonPayload.writeStringField('payment_method', 'Wire');
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Wire')) jsonPayload.writeStringField('req_payment_method', 'Wire');
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Western Union')) jsonPayload.writeStringField('req_payment_method', 'Wire');
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Faxed Electronichek')) jsonPayload.writeStringField('req_payment_method', 'Check');
        if(onlineApplication.Payment_Frequency__c != null) jsonPayload.writeStringField('req_payment_frequency', onlineApplication.Payment_Frequency__c);

        if(myFees.accountSetUpFee != null) jsonPayload.writeNumberField('setup_fee', Integer.valueOf(myFees.accountSetUpFee));

        jsonPayload.writeStringField('products', 'ALL');
        jsonPayload.writeStringField('cash_apply_type', 'INVOICE MATCH');
        jsonPayload.writeStringField('received_via', 'SFORCE');
        if(onlineApplication.Business_Street_Address__c != null) jsonPayload.writeStringField('billing_address1', onlineApplication.Business_Street_Address__c.replaceAll('[^a-zA-Z0-9 -]', ''));
        if(onlineApplication.City__c != null) jsonPayload.writeStringField('billing_city', onlineApplication.City__c.replaceAll('[^a-zA-Z0-9 -]', ''));
        if(onlineApplication.State__c != null) jsonPayload.writeStringField('billing_state', onlineApplication.State__c);
        if(onlineApplicationAccount.Physical_Country__c == null || (onlineApplicationAccount.Physical_Country__c != null && (onlineApplicationAccount.Physical_Country__c).equalsIgnoreCase('US'))) {
            jsonPayload.writeStringField('billing_country', 'U');
        }
        if(onlineApplicationAccount.Physical_Country__c != null && (onlineApplicationAccount.Physical_Country__c).equalsIgnoreCase('CA')) {
            jsonPayload.writeStringField('billing_country', 'C');
        }
        if(onlineApplication.Zip_Code__c != null) jsonPayload.writeStringField('billing_zip', onlineApplication.Zip_Code__c);
        if(onlineApplication.Phone_Number__c != null) jsonPayload.writeStringField('billing_phone', onlineApplication.Phone_Number__c);
        if(onlineApplication.Cell_Number__c != null) jsonPayload.writeStringField('billing_cell', onlineApplication.Cell_Number__c);
        if(onlineApplication.Fax_Number__c != null) jsonPayload.writeStringField('billing_fax', onlineApplication.Fax_Number__c);
        if(onlineApplication.Email__c != null) jsonPayload.writeStringField('billing_email', onlineApplication.Email__c);
        if(onlineApplication.Card_Shipping_Address_Line_1__c != null) jsonPayload.writeStringField('shipping_address1', onlineApplication.Card_Shipping_Address_Line_1__c.replaceAll('[^a-zA-Z0-9 -]', ''));
        if(onlineApplication.Card_Shipping_City__c != null) jsonPayload.writeStringField('shipping_city', onlineApplication.Card_Shipping_City__c.replaceAll('[^a-zA-Z0-9 -]', ''));
        if(onlineApplication.Card_Shipping_State__c != null) jsonPayload.writeStringField('shipping_state', onlineApplication.Card_Shipping_State__c);
        if(onlineApplication.Card_Shipping_Country__c.equalsIgnoreCase('US')) jsonPayload.writeStringField('shipToCountry', 'U');
        if((onlineApplication.Card_Shipping_Country__c).equalsIgnoreCase('CA')) jsonPayload.writeStringField('shipToCountry', 'C');
        if(onlineApplication.Card_Shipping_Postal_Code__c != null) jsonPayload.writeStringField('shipping_zip', onlineApplication.Card_Shipping_Postal_Code__c);
        if(onlineApplication.Contact_Name__c != null) jsonPayload.writeStringField('contract_contact_name', onlineApplication.Contact_First_Name__c + ' ' + onlineApplication.Contact_Last_Name__c);
        if(onlineApplication.Contact_First_Name__c != null) jsonPayload.writeStringField('bill_to_fname', onlineApplication.Contact_First_Name__c);
        if(onlineApplication.Contact_Last_Name__c != null) jsonPayload.writeStringField('bill_to_lname', onlineApplication.Contact_Last_Name__c);
        if(onlineApplication.Card_Shipping_First_Name__c != null) jsonPayload.writeStringField('ship_to_fname', onlineApplication.Card_Shipping_First_Name__c);
        if(onlineApplication.Card_Shipping_Last_Name__c != null) jsonPayload.writeStringField('ship_to_lname', onlineApplication.Card_Shipping_Last_Name__c);
        if(onlineApplicationAccount.Physical_Country__c == null || (onlineApplicationAccount.Physical_Country__c != null && (onlineApplicationAccount.Physical_Country__c).equalsIgnoreCase('US'))) {
            jsonPayload.writeStringField('transacting_country', 'U');
        }
        if(onlineApplicationAccount.Physical_Country__c != null && (onlineApplicationAccount.Physical_Country__c).equalsIgnoreCase('CA')) {
            jsonPayload.writeStringField('transacting_country', 'C');
        }
        if(onlineApplication.Prepaid__c == true) jsonPayload.writeStringField('payment_credit_hold', 'Y');
        if(onlineApplication.Prepaid__c != true) jsonPayload.writeStringField('payment_credit_hold', 'N');
        if(onlineApplication.Phone_Number__c != null) jsonPayload.writeStringField('shipping_phone', onlineApplication.Phone_Number__c);
        if(onlineApplication.Fax_Number__c != null) jsonPayload.writeStringField('shipping_fax', onlineApplication.Fax_Number__c);
        // OTRONBOARD-35 If Offer is Parent Funded, send these fields.
        if(treatAsParent) {
            if (onlineApplicationOffer.Limit_Method__c != null) jsonPayload.writeStringField('limit_method', onlineApplicationOffer.Limit_Method__c);
            if (onlineApplicationOffer.Daily_Cash_Limit__c != null) jsonPayload.writeNumberField('daily_cash_limit', Integer.valueOf(onlineApplicationOffer.Daily_Cash_Limit__c));
            if (onlineApplicationOffer.Daily_MC_Limit__c != null) jsonPayload.writeNumberField('daily_mc_limit', Integer.valueOf(onlineApplicationOffer.Daily_MC_Limit__c));
            if (onlineApplicationOffer.Cash_Limit__c != null) jsonPayload.writeNumberField('cash_limit', Integer.valueOf(onlineApplicationOffer.Cash_Limit__c));
            if (onlineApplicationOffer.MC_Limit__c != null) jsonPayload.writeNumberField('mc_limit', Integer.valueOf(onlineApplicationOffer.MC_Limit__c));
            if (onlineApplicationOffer.Trans_Limit__c != null) jsonPayload.writeNumberField('trans_limit', Integer.valueOf(onlineApplicationOffer.Trans_Limit__c));
        }

        if(treatAsParent){
            jsonPayload.writeNumberField('credit_line_amount', 0);
        } else if(onlineApplication.Credit_Line_Approved__c != null) {
            jsonPayload.writeNumberField('credit_line_amount', onlineApplication.Credit_Line_Approved__c);
        }

        if(onlineApplication.Credit_Line_Requested__c != null) {
            jsonPayload.writeNumberField('req_credit_line_amt', onlineApplication.Credit_Line_Requested__c);
            //if offer is parent funded, and credit line requested is null, then we send 0.
        } else if (treatAsParent && onlineApplication.Credit_Line_Requested__c == null) {
            jsonPayload.writeNumberField('req_credit_line_amt', 0);
        }

        // OTRONBOARD-30
        if(onlineApplicationOffer.Approval_Type__c != null) jsonPayload.writeStringField('approval_type', onlineApplicationOffer.Approval_Type__c);
        if(onlineApplicationOffer.Primary_Contact_Email_Address__c != null) jsonPayload.writeStringField('email_address', onlineApplicationOffer.Primary_Contact_Email_Address__c);
        if(onlineApplicationOffer.Create_Letter__c != null) jsonPayload.writeStringField('create_letter', onlineApplicationOffer.Create_Letter__c);
        if(onlineApplicationOffer.Notice_Delivery__c != null) jsonPayload.writeStringField('notice_delivery', onlineApplicationOffer.Notice_Delivery__c);

        // Per Gaylon and Justine - we're always going to send this.
        if(onlineApplication.Number_of_Cards_Needed__c != null) jsonPayload.writeNumberField('fuel_and_cash', Integer.valueOf(onlineApplication.Number_of_Cards_Needed__c * onlineApplicationOffer.PSR_Fuel_Cash__c));

        if(selectedOtherServices != null && hasATM && onlineApplicationOffer.PSR_ATM_Limit__c != null) {
            if (onlineApplication.Number_of_Cards_Needed__c != null){
                if(onlineApplication.Carrier_ID_Number__c != null){
                    jsonPayload.writeNumberField('atm_limit', Integer.valueOf(onlineApplication.Number_of_Cards_Needed__c * onlineApplicationOffer.PSR_ATM_Limit__c));
                } else {
                    jsonPayload.writeNumberField('atm_limit', Integer.valueOf(onlineApplication.Number_of_Cards_Needed__c * onlineApplicationOffer.PSR_ATM_Limit__c));
                }

            }
        }

        if(selectedOtherServices != null && selectedOtherServices.contains('money codes and atm') && onlineApplicationOffer.PSR_Money_Code__c != null) {
            if (onlineApplication.Number_of_Cards_Needed__c != null) jsonPayload.writeNumberField('money_codes', Integer.valueOf(onlineApplication.Number_of_Cards_Needed__c * onlineApplicationOffer.PSR_Money_Code__c));
        }

        if(selectedOtherServices != null && selectedOtherServices.contains('scales') && onlineApplicationOffer.PSR_Scales__c != null) {
            if (onlineApplication.Number_of_Cards_Needed__c != null) jsonPayload.writeNumberField('scales', Integer.valueOf(onlineApplication.Number_of_Cards_Needed__c * onlineApplicationOffer.PSR_Scales__c));
        }

        if(treatAsParent && myFees.atmWithdrawalFee != null) jsonPayload.writeNumberField('ATM-DENIAL-FEE', Integer.valueOf(myFees.atmWithdrawalFee));
        if(selectedOtherServices != null && selectedOtherServices.contains('Register Check')) jsonPayload.writeStringField('reg_check_flag', 'Y');
        else jsonPayload.writeStringField('reg_check_flag', 'N');

        //per Katey/Tiana we always want to send Y
        jsonPayload.writeStringField('atm_allowed', 'Y');

        // End of "contract"
        jsonPayload.writeEndObject();

        if(onlineApplication.Carrier_ID_Number__c == null) {
            jsonPayload.writeEndArray();
        }

        // End of payload
        jsonPayload.writeEndObject();

        jsonPayload.writeEndObject();

        System.debug(jsonPayload.getAsString());

        return jsonPayload.getAsString();

    }

    public class OgdenLoginResponse {

        public String status { get; set; }
        public String clientId { get; set; }

    }

    //take in the online application if this is parent/secondary funded. determine if this application has been sent to efs (treat it as a child) or not (treat it as a parent)
    private static Boolean isInitialPayload(OnlineApplication__c onlineApp){
        Set<Id> mySet =new Set<Id>{onlineApp.Id};
        mySet.addAll(new Map<Id,Contract__c>([SELECT Id FROM Contract__c WHERE Online_Application__c = :onlineApp.Id]).keySet());
        Integer myCount = [SELECT count() FROM Attachment WHERE ParentId IN :mySet AND Name LIKE 'json_payload%'];
        if(myCount > 0) return false;
        return true;
    }

    public class CardFees {

        List<OTR_App_Manager_Payload_Fees__mdt> productCodes = [
                SELECT Id, DeveloperName, Product_Code__c
                FROM OTR_App_Manager_Payload_Fees__mdt
        ];

        //product code variables pulled from custom meta data
        public String achAccountTransferPC;
        public String atmWithdrawalPC;
        public String smartFundsATMDeclinePC;
        public String smartFundsPointofSalePC;
        public String smartFundsATMBalanceInquiryPC;
        public String checkPC;
        public String smartFundsEFSNetworkDebitPC;
        public String loadPC;
        public String smartFundsMasterCardNetworkDebitPC;
        public String monthlyPC;
        public String scalesInNetworkPC;
        public String mcOvernightShippingPC;
        public String mcEmbossingPC;
        public String mcLocationPC;
        public String accountSetUpFeePC;

        //fee variables which are pulled from either the quote or the opportunity line item using the product code variables
        public String achAccountTransferFee;
        public String atmWithdrawalFee;
        public String smartFundsATMDeclineFee;
        public String smartFundsPointofSaleFee;
        public String smartFundsATMBalanceInquiryFee;
        public String checkFee;
        public String smartFundsEFSNetworkDebitFee;
        public String loadFee;
        public String smartFundsMasterCardNetworkDebitFee;
        public String monthlyFee;
        public String scalesInNetworkFee;
        public String mcOvernightShippingFee;
        public String mcEmbossingFee;
        public String mcLocationFee;
        public String accountSetUpFee;

        public Set<String> feeSet = new Set<String>{achAccountTransferFee, atmWithdrawalFee, smartFundsATMDeclineFee, smartFundsPointofSaleFee,
                smartFundsATMBalanceInquiryFee, checkFee, smartFundsEFSNetworkDebitFee, loadFee, smartFundsMasterCardNetworkDebitFee, monthlyFee,
                scalesInNetworkFee, mcOvernightShippingFee, mcEmbossingFee, mcLocationFee, accountSetUpFee};

        public CardFees(OnlineApplication__c onlineApplication) {
            if(onlineApplication.Opportunity__c != null) {
                Map<String,Decimal> productOptionMap = new Map<String,Decimal>();
                Map<String,Decimal> productStndrdMap = new Map<String,Decimal>();

                if(onlineApplication.Opportunity__r.SBQQ__PrimaryQuote__c != null) {
                    //get the fees based on quotelines. ideal.
                    for (SBQQ__QuoteLine__c ql : [  SELECT Id,
                    (   SELECT Id, Requested_Price__c, SBQQ__ProductCode__c
                        FROM SBQQ__LineItems__r)
                        FROM SBQQ__Quote__c
                        WHERE Id = :onlineApplication.Opportunity__r.SBQQ__PrimaryQuote__c LIMIT 1].SBQQ__LineItems__r) {
                        if (ql.Requested_Price__c != null) {
                            productOptionMap.put(ql.SBQQ__ProductCode__c, ql.Requested_Price__c);
                        }
                    }
                }

                setFees(productOptionMap);

                if (this.feeSet.contains(null)) {
                    //get the fees based on OLI. not ideal.
                    Set<Id> productIds = new Set<Id>();
                    Set<Id> productIds2 = new Set<Id>();
                    //get the product bundles
                    for (OpportunityLineItem oli : [    SELECT Product2Id
                                                        FROM OpportunityLineItem
                                                        WHERE OpportunityId = :onlineApplication.Opportunity__c]) {
                        productIds.add(oli.Product2Id);
                    }
                    //for each bundle, get the options and create a map of product code to unitprice
                    for (SBQQ__ProductOption__c po : [  SELECT Id, SBQQ__UnitPrice__c, SBQQ__ProductCode__c, SBQQ__OptionalSKU__c, SBQQ__ConfiguredSKU__c
                                                        FROM SBQQ__ProductOption__c
                                                        WHERE SBQQ__ConfiguredSKU__c IN :productIds AND SBQQ__Feature__r.Name = 'Fees']) {
                        if (!productOptionMap.containsKey(po.SBQQ__ProductCode__c)) {
                            if (po.SBQQ__UnitPrice__c != null && po.SBQQ__UnitPrice__c > 0) {
                                productOptionMap.put(po.SBQQ__ProductCode__c, po.SBQQ__UnitPrice__c);
                            } else {
                                productIds2.add(po.SBQQ__OptionalSKU__c);
                            }
                        }
                    }
                    if(productIds2.size() > 0) {
                        //get the base level product price. this will be the default if no option override exists
                        for (PricebookEntry pbe : [ SELECT Id, UnitPrice, ProductCode, Pricebook2.IsStandard
                                                    FROM PricebookEntry
                                                    WHERE Product2Id IN :productIds2 AND Pricebook2.IsStandard = TRUE]) {
                            if (!productOptionMap.containsKey(pbe.ProductCode)) {
                                productOptionMap.put(pbe.ProductCode, pbe.UnitPrice);
                            }
                        }
                    }
                }

                setFees(productOptionMap);
            }
        }

        private void setFees(Map<String,Decimal> poMap) {

            //set the Product Code variables
            if(productCodes.size() > 0) {
                for (OTR_App_Manager_Payload_Fees__mdt fees : productCodes) {
                    if (fees.DeveloperName.equalsIgnoreCase('ACH_Account_Transfer_Fee')) achAccountTransferPC = fees.Product_Code__c;
                    if (fees.DeveloperName.equalsIgnoreCase('ATM_Withdrawl_Fee')) atmWithdrawalPC = fees.Product_Code__c;
                    if (fees.DeveloperName.equalsIgnoreCase('SmartFunds_ATM_Decline_Fee')) smartFundsATMDeclinePC = fees.Product_Code__c;
                    if (fees.DeveloperName.equalsIgnoreCase('SmartFunds_Point_of_Sale_Fee')) smartFundsPointofSalePC = fees.Product_Code__c;
                    if (fees.DeveloperName.equalsIgnoreCase('SmartFunds_ATM_Balance_Inquiry_Fee')) smartFundsATMBalanceInquiryPC = fees.Product_Code__c;
                    if (fees.DeveloperName.equalsIgnoreCase('Check_Fee')) checkPC = fees.Product_Code__c;
                    if (fees.DeveloperName.equalsIgnoreCase('SmartFunds_EFS_Network_Debit_Fee')) smartFundsEFSNetworkDebitPC = fees.Product_Code__c;
                    if (fees.DeveloperName.equalsIgnoreCase('Load_Fee')) loadPC = fees.Product_Code__c;
                    if (fees.DeveloperName.equalsIgnoreCase('SmartFunds_MasterCard_Network_Debit_Fee')) smartFundsMasterCardNetworkDebitPC = fees.Product_Code__c;
                    if (fees.DeveloperName.equalsIgnoreCase('Monthly_Fee')) monthlyPC = fees.Product_Code__c;
                    if (fees.DeveloperName.equalsIgnoreCase('Scales_In_Network_Fee')) scalesInNetworkPC = fees.Product_Code__c;
                    if (fees.DeveloperName.equalsIgnoreCase('MC_Overnight_Shipping_Fee')) mcOvernightShippingPC = fees.Product_Code__c;
                    if (fees.DeveloperName.equalsIgnoreCase('MC_Embossing_Fee')) mcEmbossingPC = fees.Product_Code__c;
                    if (fees.DeveloperName.equalsIgnoreCase('MC_Location_Fee')) mcLocationPC = fees.Product_Code__c;
                    if (fees.DeveloperName.equalsIgnoreCase('Account_Set_Up_Fee')) accountSetUpFeePC = fees.Product_Code__c;
                }

            }

            //set the fee variables using the product code and a map
            if(poMap.size()>0) {
                if(this.monthlyFee == null && poMap.containsKey(monthlyPC)) this.monthlyFee = String.valueOf(poMap.get(monthlyPC));
                if(this.mcOvernightShippingFee == null && poMap.containsKey(mcOvernightShippingPC)) this.mcOvernightShippingFee = String.valueOf(poMap.get(mcOvernightShippingPC));
                if(this.mcEmbossingFee == null && poMap.containsKey(mcEmbossingPC)) this.mcEmbossingFee = String.valueOf(poMap.get(mcEmbossingPC));
                if(this.atmWithdrawalFee == null && poMap.containsKey(atmWithdrawalPC)) this.atmWithdrawalFee = String.valueOf(poMap.get(atmWithdrawalPC));
                if(this.achAccountTransferFee == null && poMap.containsKey(achAccountTransferPC)) this.achAccountTransferFee = String.valueOf(poMap.get(achAccountTransferPC));
                if(this.smartFundsATMDeclineFee == null && poMap.containsKey(smartFundsATMDeclinePC)) this.smartFundsATMDeclineFee = String.valueOf(poMap.get(smartFundsATMDeclinePC));
                if(this.smartFundsPointofSaleFee == null && poMap.containsKey(smartFundsPointofSalePC)) this.smartFundsPointofSaleFee = String.valueOf(poMap.get(smartFundsPointofSalePC));
                if(this.smartFundsATMBalanceInquiryFee == null && poMap.containsKey(smartFundsATMBalanceInquiryPC)) this.smartFundsATMBalanceInquiryFee = String.valueOf(poMap.get(smartFundsATMBalanceInquiryPC));
                if(this.checkFee == null && poMap.containsKey(checkPC)) this.checkFee = String.valueOf(poMap.get(checkPC));
                if(this.smartFundsEFSNetworkDebitFee == null && poMap.containsKey(smartFundsEFSNetworkDebitPC)) this.smartFundsEFSNetworkDebitFee = String.valueOf(poMap.get(smartFundsEFSNetworkDebitPC));
                if(this.loadFee == null && poMap.containsKey(loadPC)) this.loadFee = String.valueOf(poMap.get(loadPC));
                if(this.smartFundsMasterCardNetworkDebitFee == null && poMap.containsKey(smartFundsMasterCardNetworkDebitPC)) this.smartFundsMasterCardNetworkDebitFee = String.valueOf(poMap.get(smartFundsMasterCardNetworkDebitPC));
                if(this.scalesInNetworkFee == null && poMap.containsKey(scalesInNetworkPC)) this.scalesInNetworkFee = String.valueOf(poMap.get(scalesInNetworkPC));
                if(this.mcLocationFee == null && poMap.containsKey(mcLocationPC)) this.mcLocationFee = String.valueOf(poMap.get(mcLocationPC));
                if (this.accountSetUpFee == null && poMap.containsKey(accountSetUpFeePC)) this.accountSetUpFee = String.valueOf(poMap.get(accountSetUpFeePC));

            }

        }
    }
}