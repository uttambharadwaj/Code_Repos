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
*
*/

global class AccountWS_EFSAppManager {

    public final static String APPLICATION_NAME = 'EFS LLC Account Integration';
    public final static String MONTHLY_FEE = '118'; //Active Card Fee/Monthly Membership Fee
    public final static String SHIPPING_FEE = 'TBD_JUSTINE'; //Replace this text with the actual code when EFS provides it
    public final static String EMBOSSING_FEE = 'TBD_JUSTINE'; //Replace this text with the actual code when EFS provides it

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

            }
            else {

                //here we do our for loop on contracts
                List<Contract__c> myContracts = new List<Contract__c>{null};
                if(onlineApplication.Carrier_ID_Number__c != null)
                    myContracts = [SELECT Id, Funding_Option__c FROM Contract__c WHERE Online_Application__c = :onlineApplication.Id];

                List<Attachment> attachList = new List<Attachment>();
                List<HttpRequest> myPayloads = new List<HttpRequest>();
                if(myContracts.size()==0) myContracts.add(new Contract__c());

                for(Integer i=0;i<myContracts.size();i++){

                    Contract__c oneContract = (myContracts[i].Id == null) ? null : myContracts[i];

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

                        if(payloadResponse != null && payloadResponse.get('success') != null) {
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

        Set<String> selectedOtherServices = new Set<String>();
        if(onlineApplication.Other_Services__c != null) {
            for(String product : (onlineApplication.Other_Services__c).split(';')) {
                selectedOtherServices.add(product);
            }
        }

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
                    PSR_Scales__c, MC_Limit__c, Setup_Fee__c, Trans_Limit__c, Tier_ID__c, Approval_Type__c, Primary_Contact_Email_Address__c,
                    Create_Letter__c, Notice_Delivery__c, Online_Pay__c,Card_Style__c,Cards_per_1_Requested__c,Card_Shipping_Method__c,Card_Type__c,Account_Descriptor__c,
                    Child_Funded_Issuer_ID__c, Parent_Funded_Issuer_ID__c, Issuer_Group__c, Parent_Carrier_ID__c, Card_Order_Type__c, Statement_Type__c, Customer_Type__c
            //Notice_Type_1__c, Notice_Type_1_Value__c, Notice_Type_2__c, Notice_Type_2_Value__c, Mcode_Monthly_Account_Fee__c, Mcode_Monthly_Account_Fee_Value__c, Monthly_Account_Fee__c, Monthly_Account_Fee_Value__c
            FROM OnlineApplicationOffer__c
            WHERE Id =: onlineApplication.Offer__c LIMIT 1];
        }

        if(onlineApplication.Program__c != null) {
            [SELECT Id,  Card_Press_ID__c, Lockbox_Value__c, Partner_Territory__r.Name
            FROM Program__c
            WHERE Id =: onlineapplication.Program__c];
        }

        CardFees myFees = new CardFees(onlineApplication);

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
            //if(onlineApplicationProgram.Card_Press_ID__c != null) jsonPayload.writeNumberField('cardpressId', Integer.valueOf(onlineApplicationProgram.Card_Press_ID__c));
            // Certain Programs send additional cards to the customer.
            if(onlineApplication.Number_of_Cards_Needed__c != null && onlineApplicationOffer.Cards_per_1_Requested__c == null) jsonPayload.writeNumberField('orderQty', Integer.valueOf(onlineApplication.Number_of_Cards_Needed__c));
            if(onlineApplication.Number_of_Cards_Needed__c != null && onlineApplicationOffer.Cards_per_1_Requested__c != null) jsonPayload.writeNumberField('orderQty', Integer.valueOf(onlineApplication.Number_of_Cards_Needed__c * onlineApplicationOffer.Cards_per_1_Requested__c));
            // if(onlineApplicationAccount.Physical_Country__c == null || (onlineApplicationAccount.Physical_Country__c != null && (onlineApplicationAccount.Physical_Country__c).equalsIgnoreCase('US'))) {
            //    jsonPayload.writeStringField('shipToCountry', 'USA');
            // }
            // if(onlineApplicationAccount.Physical_Country__c != null && (onlineApplicationAccount.Physical_Country__c).equalsIgnoreCase('CA')) {
            //     jsonPayload.writeStringField('shipToCountry', 'CAN');
            // }
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
            //if(onlineApplicationAccount.Physical_Country__c == null || (onlineApplicationAccount.Physical_Country__c != null && (onlineApplicationAccount.Physical_Country__c).equalsIgnoreCase('US'))) {
            //    jsonPayload.writeStringField('mailing_country', 'US');
            //}
            //if(onlineApplicationAccount.Physical_Country__c != null && (onlineApplicationAccount.Physical_Country__c).equalsIgnoreCase('CA')) {
            //    jsonPayload.writeStringField('mailing_country', 'CA');
            //}
            if(onlineApplication.Country__c != null) jsonPayload.writeStringField('mailing_country', onlineApplication.Country__c);
            if(onlineApplication.Zip_Code__c != null) jsonPayload.writeStringField('mailing_zip', onlineApplication.Zip_Code__c);
            if(onlineApplication.Date_Decisioned__c != null) jsonPayload.writeStringField('approved_date', String.valueOf(onlineApplication.Date_Decisioned__c.format('yyyy-MM-dd')));
            if(onlineApplication.Phone_Number__c != null) jsonPayload.writeStringField('phone', onlineApplication.Phone_Number__c);
            if(onlineApplication.Fax_Number__c != null) jsonPayload.writeStringField('fax', onlineApplication.Fax_Number__c);
            if(onlineApplication.Email__c != null) jsonPayload.writeStringField('email', onlineApplication.Email__c);
            // if(onlineApplication.Contact_Name__c != null) jsonPayload.writeStringField('contact_name', onlineApplication.Contact_Name__c);
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
            //if(onlineApplicationAccount.Physical_Country__c == null || (onlineApplicationAccount.Physical_Country__c != null && (onlineApplicationAccount.Physical_Country__c).equalsIgnoreCase('US'))) {
            //    jsonPayload.writeStringField('shipping_country', 'US');
            //}
            //if(onlineApplicationAccount.Physical_Country__c != null && (onlineApplicationAccount.Physical_Country__c).equalsIgnoreCase('CA')) {
            //    jsonPayload.writeStringField('shipping_country', 'CA');
            //}
            if(onlineApplication.Card_Shipping_Country__c != null) jsonPayload.writeStringField('shipping_country', onlineApplication.Card_Shipping_Country__c);
            if(onlineApplication.Card_Shipping_Postal_Code__c != null) jsonPayload.writeStringField('shipping_zip', onlineApplication.Card_Shipping_Postal_Code__c);
            if(onlineApplication.Federal_Tax_ID__c != null) jsonPayload.writeStringField('tax_id', onlineApplication.Federal_Tax_ID__c);
            if(onlineApplicationOffer != null && onlineApplicationOffer.Parent_Carrier_ID__c != null) jsonPayload.writeStringField('original_parent_carrier_id', onlineApplicationOffer.Parent_Carrier_ID__c);

//            else jsonPayload.writeNullField('original_parent_carrier_id');
            jsonPayload.writeStringField('parent_type', 'group');
            if(onlineApplicationOffer.Customer_Type__c != null) jsonPayload.writeStringField('customer_type', onlineApplicationOffer.Customer_Type__c);
            if(onlineApplicationOffer.Funding__c != null) jsonPayload.writeStringField('relationship_type', onlineApplicationOffer.Funding__c);
            //OTRONBOARD-55 Shipping and Embossing Fees
            if(myFees.mcShippingFee != null) jsonPayload.writeStringField('shipping_fee', myFees.mcShippingFee);
            if(myFees.mcEmbossingFee != null) jsonPayload.writeStringField('mcfee', myFees.mcEmbossingFee);

            // End of "carrier"
            jsonPayload.writeEndObject();

        }

        // Start of "contract"
        jsonPayload.writeFieldName('contract');

        if(onlineApplication.Carrier_ID_Number__c == null) {
            jsonPayload.writeStartArray();
        }
        jsonPayload.writeStartObject();

        if(myContract != null) jsonPayload.writeStringField('application_id',myContract.Id);
        else jsonPayload.writeStringField('application_id', onlineApplication.ID);
        //otronboard-59
        if(onlineApplication.Carrier_ID_Number__c != null)
            jsonPayload.writeNumberField('linkSecondaryThreshold', 100);

        if(onlineApplication.Funding__c == 'Parent Funded')jsonPayload.writeStringField('dont_do_oracle', 'Y');

        // Start of "policy"
        jsonPayload.writeFieldName('policy');
        jsonPayload.writeStartObject();

        jsonPayload.writeNumberField('policyNumber', 1);

        jsonPayload.writeFieldName('header');
        jsonPayload.writeStartObject();
        if(onlineApplication.Carrier_ID_Number__c != null){
            jsonPayload.writeStringField('description', 'New Policy');
        } else {
            jsonPayload.writeStringField('description', 'Default Policy');
        }
        jsonPayload.writeBooleanField('handEnter', false);
        jsonPayload.writeNumberField('payrollContractId', 0);
        // todo replace these falses with the value of OnlineApplication__c.Funding_Options__c
        /*jsonPayload.writeBooleanField('payrollAtm', false);
        jsonPayload.writeBooleanField('payrollChk', false);
        jsonPayload.writeBooleanField('payrollAch', false);

        if (onlineApplication.Funding_Options__c != null) {
            if (onlineApplication.Funding_Options__c.contains('ATM')) jsonPayload.writeStringField('payrollAtm', 'ATM');
            if (onlineApplication.Funding_Options__c.contains('Register Check')) jsonPayload.writeStringField('payrollChk', 'Register Check');
            if (onlineApplication.Funding_Options__c.contains('ACH Transfer')) jsonPayload.writeStringField('payrollAch', 'ACH Transfer');
            if (onlineApplication.Funding_Options__c.contains('Debit Use')) jsonPayload.writeStringField('payrollDebit', 'Debit Use');
        }
        */
        //who knows what values to send to EFS? nobody!
        if(myContract != null && myContract.Funding_Option__c != null){
            switch on myContract.Funding_Option__c{
                when 'ATM'{
                    jsonPayload.writeBooleanField('payrollAtm', true);
                }
                when 'Register Check'{
                    jsonPayload.writeBooleanField('payrollChk', true);
                }
                when 'ACH Transfer'{
                    jsonPayload.writeBooleanField('payrollAch', true);
                }
                when 'Debit Use'{
                    jsonPayload.writeBooleanField('payrollDebit', true);
                }
            }
        }
        /*
        //this can be deleted after secondary stuff is verified...not sure if we need to send 'false'
        if (onlineApplication.Funding_Options__c != null) {
            if (onlineApplication.Funding_Options__c.contains('ATM')){
                jsonPayload.writeBooleanField('payrollAtm', true);
            } else {
                jsonPayload.writeBooleanField('payrollAtm', false);
            }
            if (onlineApplication.Funding_Options__c.contains('Register Check')){
                jsonPayload.writeBooleanField('payrollChk', true);
            } else {
                jsonPayload.writeBooleanField('payrollChk', false);
            }
            if (onlineApplication.Funding_Options__c.contains('ACH Transfer')){
                jsonPayload.writeBooleanField('payrollAch', true);
            } else {
                jsonPayload.writeBooleanField('payrollAch', false);
            }
            if (onlineApplication.Funding_Options__c.contains('Debit Use')){
                jsonPayload.writeBooleanField('payrollDebit', true);
            } else {
                jsonPayload.writeBooleanField('payrollDebit', false);
            }

        }
*/
        jsonPayload.writeBooleanField('payrollWire', false);
        jsonPayload.writeBooleanField('payrollDebit', false);
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
        jsonPayload.writeFieldName('refreshLimits');
        jsonPayload.writeStartObject();
        if (onlineApplication.Daily_Amount_Requested__c != null) jsonPayload.writeNumberField('dailyAmount', onlineApplication.Daily_Amount_Requested__c);
        if (onlineApplication.Daily_Transactions__c != null) jsonPayload.writeNumberField('dailyCount', onlineApplication.Daily_Transactions__c);
        if (onlineApplication.Monthly_Amount_Requested__c != null) jsonPayload.writeNumberField('monthlyAmount', onlineApplication.Monthly_Amount_Requested__c);
        if (onlineApplication.Monthly_Transactions__c != null) jsonPayload.writeNumberField('monthlyCount', onlineApplication.Monthly_Transactions__c);
        if (onlineApplication.Weekly_Amount_Requested__c != null) jsonPayload.writeNumberField('weeklyAmount', onlineApplication.Weekly_Amount_Requested__c);
        if (onlineApplication.Weekly_Transactions__c != null) jsonPayload.writeNumberField('weeklyCount', onlineApplication.Weekly_Transactions__c);
        jsonPayload.writeEndObject();
        // End of "refresh limits"

        //start merchant category codes
        if (onlineApplication.Allowed_Merchant_Categories__c != null) {
            jsonPayload.writeBooleanField('allowAllMerchantCategoryCodes', onlineApplication.Allowed_Merchant_Categories__c.contains('All Merchants'));
            jsonPayload.writeFieldName('merchantCategoryCodes');
            jsonPayload.writeStartArray();
            for (String s : onlineApplication.Allowed_Merchant_Categories__c.split(';')) {
                if (s.isNumeric())
                    jsonPayload.writeNumber(Integer.valueOf(s));
            }
            jsonPayload.writeEndArray();
        } else {
            jsonPayload.writeBooleanField('allowAllMerchantCategoryCodes', false);
        }
        //end merchant category codes

        //if(onlineApplication.Scales_Limit__c != null) jsonPayload.writeNumberField('scalesLimit', onlineApplication.Scales_Limit__c);

        jsonPayload.writeEndObject();
        // End of "policy"

        // Start driver fees
        jsonPayload.writeFieldName('driver_fees');

        jsonPayload.writeStartArray();

        jsonPayload.writeStartObject();

        jsonPayload.writeStringField('description', 'Monthly Usage Card Fee');
        jsonPayload.writeStringField('fee_id', MONTHLY_FEE);
        if(myFees.monthlyFee != null) jsonPayload.writeStringField('fee_amt', myFees.monthlyFee);
        jsonPayload.writeStringField('fee_level', '2');
        jsonPayload.writeStringField('fee_type', '1');
        jsonPayload.writeStringField('fee_max_times_per', '4');
        jsonPayload.writeStringField('fee_max_times', '0');
        jsonPayload.writeStringField('fee_min_start_per','4');
        jsonPayload.writeStringField('fee_min_start','0');
//        if (onlineApplicationOffer.Mcode_Monthly_Account_Fee__c && onlineApplicationOffer.Mcode_Monthly_Account_Fee_Value__c != null)  jsonPayload.writeNumberField('ZZZMCODE_FEE_VALUE', onlineApplicationOffer.Mcode_Monthly_Account_Fee_Value__c);
//        if (onlineApplicationOffer.Monthly_Account_Fee__c && onlineApplicationOffer.Monthly_Account_Fee_Value__c != null) jsonPayload.writeNumberField('ZZZMONHTLY_FEE_VALUE', onlineApplicationOffer.Monthly_Account_Fee_Value__c);

        jsonPayload.writeEndObject();

        // TODO need to ask Regina or Tiana if this section should be updated to say 'Smartfunds Payroll' or 'Smartfunds Non-payroll' because there is no product called just 'Smartfunds' -lhowland
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

        jsonPayload.writeEndArray();
        // End driver fees


        if(onlineApplicationAccount.Name != null) jsonPayload.writeStringField('contract_name', onlineApplicationAccount.Name);
        if(onlineApplicationOffer.Tier_ID__c != null) jsonPayload.writeStringField('tier_id', onlineApplicationOffer.Tier_ID__c);
        jsonPayload.writeStringField('is_master', 'N');
        if(onlineApplicationOffer.Card_Type__c != null) jsonPayload.writeStringField('card_type', onlineApplicationOffer.Card_Type__c);
        if(onlineApplicationOffer.Card_Style__c != null) jsonPayload.writeStringField('card_style', onlineApplicationOffer.Card_Style__c);
        if(onlineApplication.Prompt_Type__c != null) jsonPayload.writeStringField('PromptCode', onlineApplication.Prompt_Type__c);
        if(onlineApplication.Prompt_Type__c != null) jsonPayload.writeStringField('PromptCode', onlineApplication.Prompt_Type__c);
        // Certain Programs send additional cards to the customer.carefu
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
            if(onlineApplicationOffer.Child_Funded_Issuer_ID__c != null) jsonPayload.writeStringField('contract.issuer_id', onlineApplicationOffer.Child_Funded_Issuer_ID__c);
            if(onlineApplicationOffer.Parent_Funded_Issuer_ID__c != null) jsonPayload.writeStringField('issuer_id', onlineApplicationOffer.Parent_Funded_Issuer_ID__c);
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

        if(onlineApplicationOffer.Account_Descriptor__c != null) jsonPayload.writeStringField('mgr_code', onlineApplicationOffer.Account_Descriptor__c);

        jsonPayload.writeStringField('service_charge', 'Y');
        jsonPayload.writeStringField('late_payment', 'Y');
        jsonPayload.writeStringField('invoice_close_method', 'Y');
        if(onlineApplicationOffer.Statement_Type__c != null) jsonPayload.writeStringField('stmt_format', onlineApplicationOffer.Statement_Type__c);
        jsonPayload.writeStringField('print_statement', 'N');
        if((onlineApplication.Invoice_Delivery_Method__c).equals('Internet')) jsonPayload.writeStringField('statement_dist_type', 'R');
        if(!(onlineApplication.Invoice_Delivery_Method__c).equals('Internet')) jsonPayload.writeStringField('statement_dist_type', 'E');
        if(onlineApplication.Invoice_Delivery_Method_Email__c != null) jsonPayload.writeStringField('statement_email', onlineApplication.Invoice_Delivery_Method_Email__c);
        if(onlineApplication.ABA_Routing_Number__c != null) jsonPayload.writeStringField('bank_routing_number', onlineApplication.ABA_Routing_Number__c);
        if(onlineApplication.Checking_Account_Number__c != null) jsonPayload.writeStringField('bank_account_number', onlineApplication.Checking_Account_Number__c);
        jsonPayload.writeStringField('bank_account_type', 'D');
        if(onlineApplicationAccount.CurrencyIsoCode != null) jsonPayload.writeStringField('currency', onlineApplicationAccount.CurrencyIsoCode);
        jsonPayload.writeStringField('unit_of_measure', 'G');
        if(onlineApplication.Prepaid__c == true) jsonPayload.writeStringField('credit_line_type', 'Draw Down');
        if(onlineApplication.Prepaid__c == false) jsonPayload.writeStringField('credit_line_type', 'Open Line');
        if(onlineApplication.Credit_Line_Approved__c != null) jsonPayload.writeNumberField('credit_line_amount', onlineApplication.Credit_Line_Approved__c);
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Auto Draft')) jsonPayload.writeStringField('payment_method', 'ACH Draft');
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Online Payment')) jsonPayload.writeStringField('payment_method', 'None');
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Internet Pay')) jsonPayload.writeStringField('payment_method', 'None');
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Customer Initiated ACH')) jsonPayload.writeStringField('payment_method', 'Wire');
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Customer ACH')) jsonPayload.writeStringField('payment_method', 'Wire');
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Wire')) jsonPayload.writeStringField('payment_method', 'Wire');
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Western Union')) jsonPayload.writeStringField('payment_method', 'Wire');
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Faxed Electronichek')) jsonPayload.writeStringField('payment_method', 'Check');
        if(onlineApplication.Payment_Frequency__c != null) jsonPayload.writeStringField('payment_frequency', onlineApplication.Payment_Frequency__c);
/*
        if(onlineApplication.Payment_Terms__c != null) jsonPayload.writeStringField('ZZZREQUESTED_TERMS', onlineApplication.Payment_Terms__c);
        if(onlineApplication.Billing_Cycle__c != null) jsonPayload.writeStringField('ZZZBILLING_CYCLE', onlineApplication.Billing_Cycle__c);
        if(onlineApplication.Payment_Method_Approved__c != null) jsonPayload.writeStringField('ZZZPAY_METHOD_APPROVED', onlineApplication.Payment_Method_Approved__c);
        if(onlineApplication.Payment_Frequency_Approved__c != null) jsonPayload.writeStringField('ZZZPAY_FREQUENCY_APPROVED', onlineApplication.Payment_Frequency_Approved__c);
        if(onlineApplication.Terms_Approved__c != null) jsonPayload.writeStringField('ZZZTERMS_APPROVED', onlineApplication.Terms_Approved__c);
        if(onlineApplication.Billing_Cycle_Approved__c != null) jsonPayload.writeStringField('ZZZBILLING_CYCLE_APPROVED', onlineApplication.Billing_Cycle_Approved__c   );
*/
        if(onlineApplication.Prepaid__c == true) jsonPayload.writeStringField('req_credit_line_type', 'Draw Down');
        if(onlineApplication.Prepaid__c == false) jsonPayload.writeStringField('req_credit_line_type', 'Open Line');
        if(onlineApplication.Credit_Line_Requested__c != null) jsonPayload.writeNumberField('req_credit_line_amt', onlineApplication.Credit_Line_Requested__c);
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Auto Draft')) jsonPayload.writeStringField('req_payment_method', 'ACH Draft');
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Online Payment')) jsonPayload.writeStringField('req_payment_method', 'None');
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Internet Pay')) jsonPayload.writeStringField('req_payment_method', 'None');
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Customer Initiated ACH')) jsonPayload.writeStringField('req_payment_method', 'Wire');
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Customer ACH')) jsonPayload.writeStringField('payment_method', 'Wire');
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Wire')) jsonPayload.writeStringField('req_payment_method', 'Wire');
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Western Union')) jsonPayload.writeStringField('req_payment_method', 'Wire');
        if(onlineApplication.Payment_Method__c != null && (onlineApplication.Payment_Method__c).equalsIgnoreCase('Faxed Electronichek')) jsonPayload.writeStringField('req_payment_method', 'Check');
        if(onlineApplication.Payment_Frequency__c != null) jsonPayload.writeStringField('req_payment_frequency', onlineApplication.Payment_Frequency__c);

        if(onlineApplicationOffer != null && onlineApplicationOffer.Setup_Fee__c != null) jsonPayload.writeNumberField('setup_fee', Integer.valueOf(onlineApplicationOffer.Setup_Fee__c));

        jsonPayload.writeStringField('products', 'ALL');
        jsonPayload.writeStringField('cash_apply_type', 'INVOICE MATCH');
        if(onlineApplicationOffer.Online_Pay__c != null && onlineApplicationOffer.Online_Pay__c == true) {
            jsonPayload.writeStringField('ach_allowed', 'Y');
        } else {
            jsonPayload.writeStringField('ach_allowed', 'N');
        }
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
        // ?? if(onlineApplication.Country__c != null) jsonPayload.writeStringField('billing_country', onlineApplication.Country__c);
        if(onlineApplication.Zip_Code__c != null) jsonPayload.writeStringField('billing_zip', onlineApplication.Zip_Code__c);
        if(onlineApplication.Phone_Number__c != null) jsonPayload.writeStringField('billing_phone', onlineApplication.Phone_Number__c);
        if(onlineApplication.Cell_Number__c != null) jsonPayload.writeStringField('billing_cell', onlineApplication.Cell_Number__c);
        if(onlineApplication.Fax_Number__c != null) jsonPayload.writeStringField('billing_fax', onlineApplication.Fax_Number__c);
        if(onlineApplication.Email__c != null) jsonPayload.writeStringField('billing_email', onlineApplication.Email__c);
        if(onlineApplication.Card_Shipping_Address_Line_1__c != null) jsonPayload.writeStringField('shipping_address1', onlineApplication.Card_Shipping_Address_Line_1__c.replaceAll('[^a-zA-Z0-9 -]', ''));
        if(onlineApplication.Card_Shipping_City__c != null) jsonPayload.writeStringField('shipping_city', onlineApplication.Card_Shipping_City__c.replaceAll('[^a-zA-Z0-9 -]', ''));
        if(onlineApplication.Card_Shipping_State__c != null) jsonPayload.writeStringField('shipping_state', onlineApplication.Card_Shipping_State__c);
        //if(onlineApplicationAccount.Physical_Country__c == null || (onlineApplicationAccount.Physical_Country__c != null && (onlineApplicationAccount.Physical_Country__c).equalsIgnoreCase('US'))) {
        //  jsonPayload.writeStringField('shipping_country', 'U');
        //}
        //if(onlineApplicationAccount.Physical_Country__c != null && (onlineApplicationAccount.Physical_Country__c).equalsIgnoreCase('CA')) {
        //  jsonPayload.writeStringField('shipping_country', 'C');
        //}
        if(onlineApplication.Card_Shipping_Country__c.equalsIgnoreCase('US')) jsonPayload.writeStringField('shipToCountry', 'U');
        if((onlineApplication.Card_Shipping_Country__c).equalsIgnoreCase('CA')) jsonPayload.writeStringField('shipToCountry', 'C');
        if(onlineApplication.Card_Shipping_Postal_Code__c != null) jsonPayload.writeStringField('shipping_zip', onlineApplication.Card_Shipping_Postal_Code__c);
        // if(onlineApplication.Contact_Name__c != null) jsonPayload.writeStringField('contract_contact_name', onlineApplication.Contact_Name__c);
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
        if(onlineApplicationOffer.Funding__c != null && onlineApplicationOffer.Funding__c == 'Parent Funded') {
            if (onlineApplicationOffer.Limit_Method__c != null) jsonPayload.writeStringField('limit_method', onlineApplicationOffer.Limit_Method__c);
            if (onlineApplicationOffer.Daily_Cash_Limit__c != null) jsonPayload.writeNumberField('daily_cash_limit', Integer.valueOf(onlineApplicationOffer.Daily_Cash_Limit__c));
            if (onlineApplicationOffer.Daily_MC_Limit__c != null) jsonPayload.writeNumberField('daily_mc_limit', Integer.valueOf(onlineApplicationOffer.Daily_MC_Limit__c));
            if (onlineApplicationOffer.Cash_Limit__c != null) jsonPayload.WriteNumberField('cash_limit', Integer.valueOf(onlineApplicationOffer.Cash_Limit__c));
            if (onlineApplicationOffer.MC_Limit__c != null) jsonPayload.writeNumberField('mc_limit', Integer.valueOf(onlineApplicationOffer.MC_Limit__c));
            if (onlineApplicationOffer.Trans_Limit__c != null) jsonPayload.writeNumberField('trans_limit', Integer.valueOf(onlineApplicationOffer.Trans_Limit__c));
            if (onlineApplicationOffer.ATM_Use__c == true) jsonPayload.writeStringField('atm_use', 'Y');
            if (onlineApplicationOffer.ATM_Use__c == false) jsonPayload.writeStringField('atm_use', 'N');
        }

        // OTRONBOARD-30
        if(onlineApplicationOffer.approval_type__c != null) jsonPayload.writeStringField('approval_type', onlineApplicationOffer.Approval_Type__c);
        if(onlineApplicationOffer.primary_contact_email_address__c != null) jsonPayload.writeStringField('email_address', onlineApplicationOffer.Primary_Contact_Email_Address__c);
        if(onlineApplicationOffer.create_letter__c != null) jsonPayload.writeStringField('create_letter', onlineApplicationOffer.Create_Letter__c);
        if(onlineApplicationOffer.notice_delivery__c != null) jsonPayload.writeStringField('notice_delivery', onlineApplicationOffer.Notice_Delivery__c);

        // Per Gaylon and Justine - we're always going to send this.
        if(onlineApplication.Number_of_Cards_Needed__c != null) jsonPayload.writeNumberField('fuel_and_cash', Integer.valueOf(onlineApplication.Number_of_Cards_Needed__c * onlineApplicationOffer.PSR_Fuel_Cash__c));

        if(selectedOtherServices != null && selectedOtherServices.contains('ATM') && onlineApplicationOffer.PSR_ATM_Limit__c != null) {
            if (onlineApplication.Number_of_Cards_Needed__c != null){
                if(onlineApplication.Carrier_ID_Number__c != null){
                    jsonPayload.writeNumberField('atm_limit', integer.valueof(onlineApplication.Number_of_Cards_Needed__c * onlineApplicationOffer.PSR_ATM_Limit__c));
                } else {
                    jsonPayload.writeNumberField('atm_limit', (onlineApplication.Number_of_Cards_Needed__c * onlineApplicationOffer.PSR_ATM_Limit__c));
                }

            }
        }

        if(selectedOtherServices != null && selectedOtherServices.contains('Money Codes and ATM') && onlineApplicationOffer.PSR_Money_Code__c != null) {
            if (onlineApplication.Number_of_Cards_Needed__c != null) jsonPayload.writeNumberField('money_codes', (onlineApplication.Number_of_Cards_Needed__c * onlineApplicationOffer.PSR_Money_Code__c));
        }

        if(selectedOtherServices != null && selectedOtherServices.contains('Scales') && onlineApplicationOffer.PSR_Scales__c != null) {
            if (onlineApplication.Number_of_Cards_Needed__c != null) jsonPayload.writeNumberField('scales', Integer.valueOf(onlineApplication.Number_of_Cards_Needed__c * onlineApplicationOffer.PSR_Scales__c));
        }

        // End of "contract"
        jsonPayload.writeEndObject();

        // Start of offer"
        //jsonPayload.writeFieldName('offer');
        //jsonPayload.writeStartObject();

        //if(onlineApplicationOffer.Notice_Type_1__c != null) jsonPayload.writeStringField('ZZZNOTICE_TYPE_1_VALUE', onlineApplicationOffer.Notice_Type_1__c);
        //if(onlineApplicationOffer.Notice_Type_1_Value__c != null) jsonPayload.writeNumberField('ZZZNOTICE_TYPE_1_VALUE', onlineApplicationOffer.Notice_Type_1_Value__c);
        //if(onlineApplicationOffer.Notice_Type_2__c != null) jsonPayload.writeStringField('ZZZNOTICE_TYPE_2', onlineApplicationOffer.Notice_Type_2__c);
        //if(onlineApplicationOffer.Notice_Type_2_Value__c != null) jsonPayload.writeNumberField('ZZZNOTICE_TYPE_2_VALUE', onlineApplicationOffer.Notice_Type_2_Value__c);

        // End of "offer"
        //jsonPayload.writeEndObject();

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

    public class CardFees{
        public String monthlyFee;
        public String mcShippingFee;
        public String mcEmbossingFee;

        public CardFees(OnlineApplication__c onlineApplication){
            if(onlineApplication.Opportunity__c != null) {
                Map<String,Decimal> productOptionMap = new Map<String,Decimal>();
                if(onlineApplication.Opportunity__r.SBQQ__PrimaryQuote__c != null){
                    //get the fees based on quotelines. ideal.
                    for(SBQQ__QuoteLine__c ql : [SELECT Id, (SELECT Id,Requested_Price__c, SBQQ__ProductCode__c FROM SBQQ__LineItems__r) FROM SBQQ__Quote__c WHERE Id = :onlineApplication.Opportunity__r.SBQQ__PrimaryQuote__c LIMIT 1].SBQQ__LineItems__r)
                        if(ql.Requested_Price__c != null) productOptionMap.put(ql.SBQQ__ProductCode__c,ql.Requested_Price__c);
                }
                if(this.monthlyFee == null || this.mcShippingFee == null || this.mcEmbossingFee == null){
                    //get the fees based on OLI. not ideal.
                    List<Id> productIds = new List<Id>();
                    //get the product bundles
                    for(OpportunityLineItem oli : [SELECT Product2Id FROM OpportunityLineItem WHERE OpportunityId = :onlineApplication.Opportunity__c])
                        productIds.add(oli.Product2Id);
                    //for each bundle, get the options and create a map of product code to unitprice
                    for(SBQQ__ProductOption__c po : [SELECT Id, SBQQ__UnitPrice__c, SBQQ__ProductCode__c FROM SBQQ__ProductOption__c WHERE SBQQ__ConfiguredSKU__c IN :productIds AND SBQQ__Feature__r.Name = 'Fees'])
                        if(!productOptionMap.containsKey(po.SBQQ__ProductCode__c) && po.SBQQ__UnitPrice__c != null) productOptionMap.put(po.SBQQ__ProductCode__c, po.SBQQ__UnitPrice__c); //bundles should not be reusing product codes so this way will work. for now.
                }
                setFees(productOptionMap);
            }
        }

        private void setFees(Map<String,Decimal> poMap){
            if(poMap.size()>0){
                if(this.monthlyFee == null && poMap.containsKey(MONTHLY_FEE)) this.monthlyFee = String.valueOf(poMap.get(MONTHLY_FEE));
                if(this.mcShippingFee == null && poMap.containsKey(SHIPPING_FEE)) this.mcShippingFee = String.valueOf(poMap.get(SHIPPING_FEE));
                if(this.mcEmbossingFee == null && poMap.containsKey(EMBOSSING_FEE)) this.mcEmbossingFee = String.valueOf(poMap.get(EMBOSSING_FEE));
            }
        }
    }

}