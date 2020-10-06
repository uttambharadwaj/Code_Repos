/*
    Type:       Web Service Callout
    Purpose:    Methods to callout to WEX AU WSS2 to update Application status and send EDM.
                
    Used By:    AccountAndCardsToGenesis_ExCon.cls
    ---------------------------------------------------------------
    History:
    2016-04-10 B. Sotoudeh (WEX AU)    Created
*/
public with sharing class WSUtil_WSS2_CreditDecisionService {
    
    
    public WS_WSS2_CreditDecisionService.UpdateApplicationStatusResponse UpdateApplicationStatus(AU_Application_Request__c appRequest, List<AU_Card_Details__c> appCards,String genesisAccountNumber) {
        
        WS_WSS2_CreditDecisionService.UpdateApplicationStatusResponse response = null;
                
        try
        {
            //  Prepare Credential and Application
            WS_WSS2_CreditDecisionService.Credential credential = GetCredential();  
            WS_WSS2_CreditDecisionService.SalesforceApplication salesforceApplication = GetApplication(appRequest, appCards, genesisAccountNumber);   

            String requestId = GenerateUniqueId();

            System.debug(System.LoggingLevel.DEBUG, '##DEBUG: salesforceApplication:  ' + salesforceApplication );
            System.debug(System.LoggingLevel.DEBUG, '##DEBUG: requestId :  ' + requestId );            
            
            //  Call Web Service
            WS_WSS2_CreditDecisionService.SalesforceCreditDecisionServiceSoap myService = new WS_WSS2_CreditDecisionService.SalesforceCreditDecisionServiceSoap();
            
            myService.endpoint_x = GlobalSettings__c.getInstance('Settings').AU_WSS2_CreditDecision_Services_Endpoint__c;                              
            myService.timeout_x = integer.valueof(GlobalSettings__c.getInstance('Settings').AU_WSS2_CreditDecision_Services_Timeout__c);                                          

            System.debug(System.LoggingLevel.DEBUG, '##DEBUG: callout timoue :  ' + myService.timeout_x);            
            
            response = myService.UpdateApplicationStatus(credential, requestId, salesforceApplication, false); 
            
            
        } catch (Exception ex) {
            // Handle any errors
            System.debug(System.LoggingLevel.ERROR, '##DEBUG: ex: ' + ex);
            
            String errMessage = ex.getMessage();
            if (errMessage == 'IO Exception: Read timed out') 
                errMessage = 'Unable to contact WSS, please try again later';

            WS_WSS2_CreditDecisionService.Error error = new WS_WSS2_CreditDecisionService.Error();
            error.Description = 'Problem with web service - please contact system administrator. Error message: ' + errMessage ;
            response = new  WS_WSS2_CreditDecisionService.UpdateApplicationStatusResponse();
            response.DataObject = new WS_WSS2_CreditDecisionService.ArrayOfError();
            response.DataObject.Error = new List<WS_WSS2_CreditDecisionService.Error>();
            
            response.Result = False;
            response.DataObject.Error.Add(error);

            
        }

        System.debug(System.LoggingLevel.DEBUG, '##DEBUG: response:  ' + response);                                    

        return response;
    }
    
    private WS_WSS2_CreditDecisionService.Credential GetCredential(){
            
        WS_WSS2_CreditDecisionService.Credential credential = new WS_WSS2_CreditDecisionService.Credential();
        
        credential.Username = GlobalSettings__c.getInstance('Settings').AU_WSS2_CreditDecision_Services_Username__c;
        credential.Password = GlobalSettings__c.getInstance('Settings').AU_WSS2_CreditDecision_Services_Password__c;
        
        return credential;
            
    }
    
    private WS_WSS2_CreditDecisionService.SalesforceApplication GetApplication(AU_Application_Request__c appRequest,List<AU_Card_Details__c> appCards,String genesisAccountNumber){
        
        WS_WSS2_CreditDecisionService.SalesforceApplication app = new WS_WSS2_CreditDecisionService.SalesforceApplication();
                    
        //  Get AU_Application_Request from system
        appRequest = [  SELECT  Id,
                                Opportunity__r.Primary_Contact__r.FirstName,
                                Opportunity__r.Primary_Contact__r.Email,
                                WSS2_Application_Id__c,
                                Opportunity__r.Genesis_Account_Number__c,           
                                Credit_Limit__c
                        FROM AU_Application_Request__c
                        WHERE Id = :appRequest.Id   ];
        
        app.Wss2ApplicationId = appRequest.WSS2_Application_Id__c;
        app.FirstName = appRequest.Opportunity__r.Primary_Contact__r.FirstName;
        app.EmailAddress = appRequest.Opportunity__r.Primary_Contact__r.Email;
        app.GenesisAccountNumber = appRequest.Opportunity__r.Genesis_Account_Number__c;
        If (genesisAccountNumber != null && genesisAccountNumber <> '')
        {
            app.GenesisAccountNumber = genesisAccountNumber ;
        }
        app.CreditLimit = string.valueof(appRequest.Credit_Limit__c);
        app.ApplicationStatus = 'APPROVED';
        app.Cards = GetCards(appCards);
                                                        
        return app;
        
    }
    
   
    private WS_WSS2_CreditDecisionService.ArrayOfSalesforceCard GetCards(List<AU_Card_Details__c> providedCards){
        
         System.debug(System.LoggingLevel.DEBUG, '##DEBUG: preparing cards:  ' + providedCards);     
         
        List<WS_WSS2_CreditDecisionService.SalesforceCard> sfCards = new List<WS_WSS2_CreditDecisionService.SalesforceCard>();
        for (AU_Card_Details__c auCard : [SELECT    Id,
                                                    Name,
                                                    AU_Additional_Card_Text__c,
                                                    Card_Controls__c,
                                                    AU_card_PIN_setting__c,
                                                    Card_Type__c,
                                                    AU_Drivers_Name__c,
                                                    Odometer_Required__c,
                                                    Product_Restriction_Groups__c,
                                                    AU_Vehicle_Registration__c,
                                                    AU_Cardholder_Mobile_Phone_Number__c,
                                                    AU_Card_Holder_email_address__c
                                            FROM AU_Card_Details__c
                                            WHERE Id IN :providedCards]) 
        {
                                            
            WS_WSS2_CreditDecisionService.SalesforceCard cardElement = new WS_WSS2_CreditDecisionService.SalesforceCard();

            cardElement.Id = auCard.Name;
            cardElement.CardLevelPINSetting = splitOnColon(auCard.AU_card_PIN_setting__c);
            cardElement.CardType = splitOnColon(auCard.Card_Type__c);
            if (auCard.AU_Vehicle_Registration__c != null) {
                cardElement.VehicleRegistration = String.valueOf(auCard.AU_Vehicle_Registration__c);
            }
            cardElement.VehicleOdometerRequired = booleanToTrueFalse(auCard.Odometer_Required__c);
            cardElement.NameOnCard = auCard.AU_Drivers_Name__c;
            
            if (auCard.Card_Controls__c != null) {
                
                List<String> productRestrictionCategories = new List<String>();
                
                if (auCard.Card_Controls__c == 'Fuel & Oil Only') {
                    //Fuel & Oil Only = F, O                   
                    productRestrictionCategories.add('F');
                    productRestrictionCategories.add('O');
                    
                }
                if (auCard.Card_Controls__c == 'All Vehicle Expenses') {
                    //All Vehicle Expenses = F, V, O
                    productRestrictionCategories.add('F');
                    productRestrictionCategories.add('V');
                    productRestrictionCategories.add('O');
                    
                }
                if (auCard.Card_Controls__c == 'All Products') {
                    //All Products= F, V, O, X
                    productRestrictionCategories.add('F');
                    productRestrictionCategories.add('V');
                    productRestrictionCategories.add('O');
                    productRestrictionCategories.add('X');
                }
                System.debug(System.LoggingLevel.DEBUG, '##DEBUG: productRestrictionCategories: ' + productRestrictionCategories);
                cardElement.ProductRestrictionCategories = ToArrayOfString(productRestrictionCategories);
            }
            
            if (auCard.Product_Restriction_Groups__c != null) {
                List<String> productRestrictionGroups = new List<String>();
                for (String productRestrictionGroup : auCard.Product_Restriction_Groups__c.split(';', 0)) {
                    productRestrictionGroups.add(splitOnColon(productRestrictionGroup));
                }
                System.debug(System.LoggingLevel.DEBUG, '##DEBUG: productRestrictionGroups: ' + productRestrictionGroups);
                cardElement.ProductRestrictionGroups = ToArrayOfString(productRestrictionGroups);
            }
            
            if (auCard.AU_Cardholder_Mobile_Phone_Number__c != null) {
                cardElement.MobileNumber = String.valueOf(auCard.AU_Cardholder_Mobile_Phone_Number__c);
            }
            
            if (auCard.AU_Card_Holder_email_address__c != null) {
                cardElement.EmailAddress = String.valueOf(auCard.AU_Card_Holder_email_address__c);
            }
            
            // Add the Card to the collection
            sfCards.add(cardElement);
        } // for
        
        WS_WSS2_CreditDecisionService.ArrayOfSalesforceCard ret = new WS_WSS2_CreditDecisionService.ArrayOfSalesforceCard();
        ret.SalesforceCard = sfCArds;
        Return ret;
    }


    private WS_WSS2_CreditDecisionService.ArrayOfString ToArrayOfString(List<String> input){
        WS_WSS2_CreditDecisionService.ArrayOfString ret = new WS_WSS2_CreditDecisionService.ArrayOfString();
        ret.string_x = input;
        return ret;
    }
    private String booleanToTrueFalse(Boolean theBoolean) {
        String returnString = 'false';
        if (theBoolean) {
            returnString = 'true';
        }
        return returnString;
    }
        
    private String GenerateUniqueId() {
        Blob aes = Crypto.generateAesKey(128);
        String hex = EncodingUtil.convertToHex(aes);
        return hex;
    }
    
    private String splitOnColon(String inputString) {
        String returnString = null;
        if (inputString != null) {
            returnString = inputString.split(':', 0)[0];
        }
        return returnString;
    }
}