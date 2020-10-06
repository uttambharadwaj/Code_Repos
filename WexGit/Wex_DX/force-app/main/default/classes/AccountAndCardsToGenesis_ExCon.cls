public without sharing class AccountAndCardsToGenesis_ExCon {
/* *************************
    Purpose:
        VF Extension controller to obtain Account (and related Cards) information and send to Genesis via the WSUtil_Genesis_AccountServices.
        
    ASSUMPTIONS:
        - XX
        
    Used By:
        AccountAndCardToGenesis.page
    
    History:
        01-May-2014 M.Erwin (Salesforce.com)    Created
        28-May-2014 M.Erwin (Salesforce.com)    Closes requirement #173: The Genesis "Application" really should map to the Salesforce Opportunity
        14-Apr-2016 B.Sotoudeh (WEX AU)         PS200 - Sprint 3B - Call to WSS2AUCreditDecisionService        
************************* */

    /* CONSTANTS */
    private static final String ACCOUNT_CREATION_SUCCESS = 'Account Creation Success';
    private static final String ACCOUNT_CREATION_ERROR = 'Account Creation Error';
    private static final String ADD_CARDS_SUCCESS = 'Add Cards Success';
    private static final String ADD_CARDS_ERROR = 'Add Cards Error';
    private static final String ADD_VEHICLES_SUCCESS = 'Add Vehicles Success';
    private static final String ADD_VEHICLES_ERROR = 'Add Vehicles Error';
    private static final String GENESIS_ERROR = 'Genesis Error';
    private static final String COMPLETE = 'Complete';

    /* PRIVATE VARIABLES AND METHODS */
    private AU_Application_Request__c appRequest { get; set; }
    private Opportunity appOpportunity {
        get {
            if (appOpportunity == null) {
                appOpportunity = [SELECT Id, Name, LeadSource, AU_Sales_Channel__c, Record_Type_Name__c FROM Opportunity WHERE Id = :appRequest.Opportunity__c];
            }
            return appOpportunity;
        }
        set;
    }
    private List<AU_Card_Details__c> appCards {
        get {
            if (appCards == null) {
                appCards = [SELECT Id, Name, Card_Number__c FROM AU_Card_Details__c WHERE Opportunity__c = :appRequest.Opportunity__c AND Card_Number__c = ''];
            }
            return appCards;
        }
        set;
    }
    private List<AU_Card_Details__c> appCardsAll {
        get {
            if (appCardsAll == null) {
                appCardsAll = [SELECT Id, Name, Card_Number__c FROM AU_Card_Details__c WHERE Opportunity__c = :appRequest.Opportunity__c];
            }
            return appCardsAll;
        }
        set;
    }
    private List<AU_Vehicle__c> appVehicles {
        get {
            if (appVehicles == null) {
                appVehicles = [SELECT Id FROM AU_Vehicle__c WHERE Opportunity__c = :appRequest.Opportunity__c];
            }
            return appVehicles;
        }
        set;
    }
    private Boolean canSendToGenesis {
        get {
            if (canSendToGenesis == null) {
                canSendToGenesis = (appRequest.Can_Send_To_Genesis__c);
                if (Test.isRunningTest()) {
                    canSendToGenesis = true;
                }
            }
            return canSendToGenesis;
        }
        set;
    }
    private Boolean sendToWSS2Failed {
        get {
            if (sendToWSS2Failed == null) {
                sendToWSS2Failed = appRequest.Send_To_WSS2_Failed__c;
                if (Test.isRunningTest()) {
                    sendToWSS2Failed = true;
                }
            }
            return sendToWSS2Failed ;
        }
        set {
            appRequest.Send_To_WSS2_Failed__c = value;
        }
    }
    private Map<String, IntegrationErrorMessage__c> integrationErrorIdToErrors {
        get {
            if (integrationErrorIdToErrors == null) {
                integrationErrorIdToErrors = IntegrationErrorMessage__c.getAll();
            }
            return integrationErrorIdToErrors;
        }
        set;
    }
    private Boolean updateOppty { get; set; }
    private Boolean updateCards { get; set; }

    private Boolean isWSS2Application { get; set; }

    private void sendCardToWSS2(String genesisAccountNumber) {

        //  Initialize WSS2 Service
        WSUtil_WSS2_CreditDecisionService wss2UpdateServices = new WSUtil_WSS2_CreditDecisionService();
        WS_WSS2_CreditDecisionService.UpdateApplicationStatusResponse updateApplicationResponse = null;

        updateApplicationResponse = wss2UpdateServices.UpdateApplicationStatus(appRequest, appCardsAll, genesisAccountNumber);
        System.debug(System.LoggingLevel.DEBUG, '##DEBUG:updateApplicationResponse : ' + updateApplicationResponse);

        //    Handle Business Errors
        if (!updateApplicationResponse.Result) {

            sendToWSS2Failed = true;

            System.debug(System.LoggingLevel.ERROR, '##DEBUG: WSS2 Update Errors exist!');

            List<WS_WSS2_CreditDecisionService.Error> updateErrors = updateApplicationResponse.DataObject.Error;
            List<String> errorMessages = new List<String>();
            String errorMessageForApplication = '';

            for (WS_WSS2_CreditDecisionService.Error updateError : updateErrors) {

                String errorMessage = 'Opportunity "' + appOpportunity.Name + '".  WSS2 Application update was not successful. ' + updateError.Description;
                errorMessages.add(errorMessage);
                errorMessageForApplication += errorMessage;
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));

            }

        } else {
            sendToWSS2Failed = false;
        }

    }


    /* CONSTRUCTOR */
    public AccountAndCardsToGenesis_ExCon(ApexPages.StandardController stdController) {
        AU_Application_Request__c tempAppRequest = (AU_Application_Request__c) stdController.getRecord();
        appRequest = [
                SELECT Id, Opportunity__c, Can_Send_To_Genesis__c, Account__c, Send_To_WSS2_Failed__c, WSS2_Application_Id__c
                FROM AU_Application_Request__c
                WHERE Id = :tempAppRequest.Id
        ];
    }

    /* PUBLIC VARIABLES AND METHODS */
    public PageReference submitAccountAndCards() {
        return submitAccountAndCardsAll(appRequest.WSS2_Application_Id__c != null);
    }

    /* PUBLIC VARIABLES AND METHODS */
    public PageReference submitAccountAndCardsAll(Boolean isWSS2) {

        isWSS2Application = isWSS2;
        WSUtil_Genesis_AccountServices genesisAccountServices = new WSUtil_Genesis_AccountServices();
        WS_Genesis_AccountServices.CreateAccountResponse_element createAccountResponse = new WS_Genesis_AccountServices.CreateAccountResponse_element();

        PageReference pageReturn;

        updateOppty = false;
        updateCards = false;

        if (canSendToGenesis) {
            System.debug(System.LoggingLevel.DEBUG, '##DEBUG:canSendToGenesis: ' + canSendToGenesis);
            try {
                appRequest.Integration_Status__c = 'In Progress';
                appRequest.Integration_Status_Detail__c = '';
                appOpportunity.Integration_Status__c = 'In Progress';
                appOpportunity.Integration_Status_Detail__c = '';
                createAccountResponse = genesisAccountServices.createAccount(appRequest);
                System.debug(System.LoggingLevel.DEBUG, '##DEBUG:createAccountResponse: ' + createAccountResponse);
                String createAccountResponseUid = createAccountResponse.UID;
                System.debug(System.LoggingLevel.DEBUG, '##DEBUG:createAccountResponseUid: ' + createAccountResponseUid);

                if (genesisAccountServices.createAccountUid == createAccountResponseUid) {
                    System.debug(System.LoggingLevel.DEBUG, '##DEBUG: Sent and received transactions match - proceed');
                    String existingGenesisAccountNumber = genesisAccountServices.genesisAccountNumber;
                    System.debug(System.LoggingLevel.DEBUG, '##DEBUG:existingGenesisAccountNumber: ' + existingGenesisAccountNumber);
                    String genesisAccountNumber = createAccountResponse.AccountNumber;
                    System.debug(System.LoggingLevel.DEBUG, '##DEBUG:genesisAccountNumber: ' + genesisAccountNumber);
                    String genesisAccountCreationStatus = createAccountResponse.Status;
                    System.debug(System.LoggingLevel.DEBUG, '##DEBUG:genesisAccountCreationStatus: ' + genesisAccountCreationStatus);
                    String genesisReferredReason = createAccountResponse.ReferredReason;
                    System.debug(System.LoggingLevel.DEBUG, '##DEBUG:genesisReferredReason: ' + genesisReferredReason);
                    WS_Genesis_AccountServices.ErrorBlock_element accountErrorBlock = createAccountResponse.ErrorBlock;
                    System.debug(System.LoggingLevel.DEBUG, '##DEBUG:accountErrorBlock: ' + accountErrorBlock);

                    updateOppty = true;

                    if (accountErrorBlock != null) {
                        System.debug(System.LoggingLevel.ERROR, '##DEBUG: Account Errors exist!');
                        List<WS_Genesis_AccountServices.Error_element> accountErrorElements = accountErrorBlock.Error;

                        List<String> errorMessages = new List<String>();
                        String errorMessageForApplication;
                        for (WS_Genesis_AccountServices.Error_element accountErrorElement : accountErrorElements) {
                            String accountErrorId = accountErrorElement.ErrorId;
                            System.debug(System.LoggingLevel.DEBUG, '##DEBUG:accountErrorId: ' + accountErrorId);
                            String accountErrorMessage = accountErrorElement.ErrorMessage;
                            System.debug(System.LoggingLevel.DEBUG, '##DEBUG:accountErrorMessage: ' + accountErrorMessage);
                            System.debug(System.LoggingLevel.DEBUG, '##DEBUG:integrationErrorIdToErrors: ' + integrationErrorIdToErrors);
                            String csErrorMessage = integrationErrorIdToErrors.get(accountErrorId).Error_Message__c;
                            System.debug(System.LoggingLevel.DEBUG, '##DEBUG:csErrorMessage: ' + csErrorMessage);
                            String csErrorComment = integrationErrorIdToErrors.get(accountErrorId).Error_Comment__c;
                            System.debug(System.LoggingLevel.DEBUG, '##DEBUG:csErrorComment: ' + csErrorComment);
                            String errorMessage = 'Opportunity "' + appOpportunity.Name + '": Integration Transaction ' + createAccountResponseUid + ': Genesis Account insert not successful: ' +
                                    accountErrorId + ': ' + csErrorMessage + ' ' + accountErrorMessage;
                            errorMessages.add(errorMessage);
                            errorMessageForApplication += errorMessage;
                            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
                        }
                        appRequest.Application_Status__c = GENESIS_ERROR;
                        appRequest.Integration_Status__c = ACCOUNT_CREATION_ERROR;
                        appRequest.Integration_Status_Detail__c = errorMessageForApplication;
                        appOpportunity.Integration_Status__c = ACCOUNT_CREATION_ERROR;
                        appOpportunity.Integration_Status_Detail__c = errorMessageForApplication;
                    } else {
                        System.debug(System.LoggingLevel.INFO, '##DEBUG: No account creation errors - proceed');

                        String appRequestSuccessMessage = 'Opportunity "' + appOpportunity.Name + '": Integration Transaction ' + createAccountResponseUid + ': Genesis Account ' + genesisAccountNumber;
                        if (existingGenesisAccountNumber == null) {
                            // Only show the user the insert success message the first time around
                            appRequestSuccessMessage += ' insert successful.\n';
                        }
                        appRequest.Application_Status__c = COMPLETE;
                        appOpportunity.Genesis_Account_Number__c = genesisAccountNumber;
                        appRequest.Integration_Status__c = ACCOUNT_CREATION_SUCCESS;
                        appRequest.Integration_Status_Detail__c = appRequestSuccessMessage;
                        appOpportunity.Integration_Status__c = ACCOUNT_CREATION_SUCCESS;
                        appOpportunity.Integration_Status_Detail__c = appRequestSuccessMessage;
                        ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO, appRequestSuccessMessage));

                        if (isWSS2Application) {
                            sendCardToWSS2(genesisAccountNumber);

                        } else {
                            // Now try creating the Cards (if any exist)
                            System.debug(System.LoggingLevel.DEBUG, '##DEBUG:appCards: ' + appCards);
                            Map<String, AU_Card_Details__c> cardNameToCard = new Map<String, AU_Card_Details__c>();

                            if (!appCards.isEmpty()) {
                                System.debug(System.LoggingLevel.DEBUG, '##DEBUG:appCards exist - proceed: ' + appCards);
                                for (AU_Card_Details__c card : appCards) {
                                    cardNameToCard.put(card.Name, card);
                                }

                                WS_Genesis_AccountServices.AddCardResponse_element addCardResponse = new WS_Genesis_AccountServices.AddCardResponse_element();
                                addCardResponse = genesisAccountServices.addCards(genesisAccountNumber, appCards);
                                System.debug(System.LoggingLevel.DEBUG, '##DEBUG:addCardResponse: ' + addCardResponse);
                                String addCardsResponseUid = addCardResponse.UID;
                                System.debug(System.LoggingLevel.DEBUG, '##DEBUG:addCardsResponseUid: ' + addCardsResponseUid);
                                System.debug(System.LoggingLevel.DEBUG, '##DEBUG:genesisAccountServices.addCardsUid: ' + genesisAccountServices.addCardsUid);

                                if (genesisAccountServices.addCardsUid == addCardsResponseUid) {

                                    WS_Genesis_AccountServices.CardErrorBlock_element cardErrorBlock = addCardResponse.CardErrorBlock;
                                    WS_Genesis_AccountServices.CardsOutput_element cardsOutput = addCardResponse.CardsOutput;

                                    updateCards = true;

                                    if (cardErrorBlock != null) {
                                        System.debug(System.LoggingLevel.ERROR, '##DEBUG: Card Errors exist!');
                                        List<WS_Genesis_AccountServices.CardError_element> cardErrorElements = cardErrorBlock.CardError;
                                        List<String> errorMessages = new List<String>();
                                        String errorMessageForApplication;
                                        for (WS_Genesis_AccountServices.CardError_element cardErrorElement : cardErrorElements) {
                                            String cardErrorId = cardErrorElement.ErrorId;
                                            System.debug(System.LoggingLevel.DEBUG, '##DEBUG:cardErrorId: ' + cardErrorId);
                                            String cardErrorMessage = cardErrorElement.ErrorMessage;
                                            System.debug(System.LoggingLevel.DEBUG, '##DEBUG:cardErrorMessage: ' + cardErrorMessage);
                                            String cardIdentifier = cardErrorElement.CardIdentifier;
                                            System.debug(System.LoggingLevel.DEBUG, '##DEBUG:cardIdentifier: ' + cardIdentifier);

                                            System.debug(System.LoggingLevel.DEBUG, '##DEBUG:integrationErrorIdToErrors: ' + integrationErrorIdToErrors);
                                            String csErrorMessage = integrationErrorIdToErrors.get(cardErrorId).Error_Message__c;
                                            System.debug(System.LoggingLevel.DEBUG, '##DEBUG:csErrorMessage: ' + csErrorMessage);
                                            String csErrorComment = integrationErrorIdToErrors.get(cardErrorId).Error_Comment__c;
                                            System.debug(System.LoggingLevel.DEBUG, '##DEBUG:csErrorComment: ' + csErrorComment);
                                            String errorMessage = 'Card "' + cardIdentifier + '": Integration Transaction ' + addCardsResponseUid + ': Genesis Add Cards not successful: ' +
                                                    cardErrorId + ': ' + csErrorMessage + ' ' + cardErrorMessage;
                                            errorMessages.add(errorMessage);
                                            errorMessageForApplication += errorMessage;
                                            if (cardIdentifier != null && cardIdentifier != '' && cardIdentifier != ' ') {
                                                AU_Card_Details__c auCard = cardNameToCard.get(cardIdentifier);
                                                auCard.Integration_Status__c = ADD_CARDS_ERROR;
                                                auCard.Integration_Status_Detail__c = errorMessage;
                                            }
                                            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
                                        }
                                        appRequest.Application_Status__c = GENESIS_ERROR;
                                        appRequest.Integration_Status__c = ADD_CARDS_ERROR;
                                        appRequest.Integration_Status_Detail__c += errorMessageForApplication;
                                    } else {
                                        System.debug(System.LoggingLevel.INFO, '##DEBUG: No errors - proceed');
                                        System.debug(System.LoggingLevel.INFO, '##DEBUG: cardsOutput: ' + cardsOutput);
                                        List<WS_Genesis_AccountServices.CardResult_element> cardResultElements = cardsOutput.CardResult;
                                        for (WS_Genesis_AccountServices.CardResult_element cardResultElement : cardResultElements) {
                                            System.debug(System.LoggingLevel.INFO, '##DEBUG: cardResultElement.CardAdded: ' + cardResultElement.CardAdded);
                                            String cardIdentifier = cardResultElement.CardIdentifier;
                                            String cardNumber = cardResultElement.CardNumber;
                                            AU_Card_Details__c auCard = cardNameToCard.get(cardIdentifier);
                                            aucard.Card_Number__c = cardNumber;
                                            auCard.Integration_Status__c = ADD_CARDS_SUCCESS;
                                            String cardSuccessMessage = 'Card "' + cardIdentifier + '": Integration Transaction ' + addCardsResponseUid + ': Genesis ' + cardNumber + ' added.\n';
                                            auCard.Integration_Status_Detail__c = cardSuccessMessage;
                                            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO, cardSuccessMessage));
                                            appRequestSuccessMessage += cardSuccessMessage;
                                        }
                                        appRequest.Application_Status__c = COMPLETE;
                                        appRequest.Integration_Status__c = ADD_CARDS_SUCCESS;
                                        appRequest.Integration_Status_Detail__c = appRequestSuccessMessage;
                                        updateCards = true;
                                    }
                                } else {
                                    System.debug(System.LoggingLevel.ERROR, '##DEBUG: Error - the Add Cards response is NOT for this transaction');
                                    String addCardsMismatchErrorMessage = 'Integration Transaction mismatch for Add Cards! Sent transaction ' +
                                            genesisAccountServices.addCardsUid + ' does not match returned transaction ' + addCardsResponseUid;
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, addCardsMismatchErrorMessage));
                                    appRequest.Integration_Status__c = ADD_CARDS_ERROR;
                                    appRequest.Integration_Status_Detail__c = addCardsMismatchErrorMessage;
                                }
                            }

                        }

                        if (appVehicles != null && appVehicles.size() > 0) {

                            try {

                                WS_Genesis_AccountServices.AddVehicleResponse_element addVehicleResponse = new WS_Genesis_AccountServices.AddVehicleResponse_element();
                                addVehicleResponse = genesisAccountServices.addVehicles(genesisAccountNumber, appVehicles);

                                System.debug(System.LoggingLevel.DEBUG, '##DEBUG:addVehicleResponse: ' + addVehicleResponse);

                                WS_Genesis_AccountServices.VehicleErrorBlock_element vehicleErrorBlockElement = addVehicleResponse.VehicleErrorBlock;
                                WS_Genesis_AccountServices.VehiclesOutput_element vehiclesOutputElement = addVehicleResponse.VehiclesOutput;

                                if (vehicleErrorBlockElement != null) {
                                    System.debug(System.LoggingLevel.ERROR, '##DEBUG: Card Errors exist!');
                                    List<WS_Genesis_AccountServices.VehicleError_element> vehicleErrorElements = vehicleErrorBlockElement.VehicleError;
                                    List<String> errorMessages = new List<String>();
                                    String errorMessageForApplication;
                                    for (WS_Genesis_AccountServices.VehicleError_element vehicleErrorElement : vehicleErrorElements) {
                                        String vehicleErrorId = vehicleErrorElement.ErrorId;
                                        System.debug(System.LoggingLevel.DEBUG, '##DEBUG:cardErrorId: ' + vehicleErrorId);
                                        String vehicleErrorMessage = vehicleErrorElement.ErrorMessage;
                                        System.debug(System.LoggingLevel.DEBUG, '##DEBUG:cardErrorMessage: ' + vehicleErrorMessage);
                                        String vehicleIdentifier = vehicleErrorElement.VehicleIdentifier;
                                        System.debug(System.LoggingLevel.DEBUG, '##DEBUG:cardIdentifier: ' + vehicleIdentifier);

                                        System.debug(System.LoggingLevel.DEBUG, '##DEBUG:integrationErrorIdToErrors: ' + integrationErrorIdToErrors);
                                        String csErrorMessage = integrationErrorIdToErrors.get(vehicleErrorId).Error_Message__c;
                                        System.debug(System.LoggingLevel.DEBUG, '##DEBUG:csErrorMessage: ' + csErrorMessage);
                                        String csErrorComment = integrationErrorIdToErrors.get(vehicleErrorId).Error_Comment__c;
                                        System.debug(System.LoggingLevel.DEBUG, '##DEBUG:csErrorComment: ' + csErrorComment);
                                        String errorMessage = 'Vehicle "' + vehicleErrorId + '": Integration Transaction ' + +': Genesis Add Cards not successful: ' +
                                                vehicleErrorId + ': ' + csErrorMessage + ' ' + vehicleErrorMessage;
                                        errorMessages.add(errorMessage);
                                        errorMessageForApplication += errorMessage;

                                        ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
                                    }
                                    appRequest.Application_Status__c = GENESIS_ERROR;
                                    appRequest.Integration_Status__c = ADD_VEHICLES_ERROR;
                                    appRequest.Integration_Status_Detail__c += errorMessageForApplication;
                                } else {
                                    System.debug(System.LoggingLevel.INFO, '##DEBUG: No errors - proceed');
                                    System.debug(System.LoggingLevel.INFO, '##DEBUG: vehiclesOutput: ' + vehiclesOutputElement);
                                    List<WS_Genesis_AccountServices.VehicleResult_element> vehicleResultElements = vehiclesOutputElement.VehicleResult;
                                    for (WS_Genesis_AccountServices.VehicleResult_element vehicleResultElement : vehicleResultElements) {
                                        System.debug(System.LoggingLevel.INFO, '##DEBUG: vehicleResultElement.VehicleAdded: ' + vehicleResultElement.VehicleAdded);
                                        String vehicleIdentifier = vehicleResultElement.VehicleIdentifier;

                                        String vehicleSuccessMessage = 'Vehicle "' + vehicleIdentifier + '": Integration Transaction ' + addVehicleResponse.UID + ': Genesis ' + vehicleIdentifier + ' added.\n';

                                        ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO, vehicleSuccessMessage));
                                        appRequestSuccessMessage += vehicleSuccessMessage;
                                    }
                                    appRequest.Application_Status__c = COMPLETE;
                                    appRequest.Integration_Status__c = ADD_CARDS_SUCCESS;
                                    appRequest.Integration_Status_Detail__c = appRequestSuccessMessage;
                                    updateCards = true;
                                }

                            }
                            catch(System.CalloutException ce) {
                                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO, 'We have submitted the request to add ' + appVehicles.size() + ' vehicles to Genesis which will complete in a short period of time'));
                            }
                            catch(Exception e) {
                                System.debug(System.LoggingLevel.DEBUG, '##DEBUG:GenesisCallout-Vehicle: ' + e.getMessage() + '(' + e.getLineNumber() + ')');
                            }

                        }
                        appRequest.Approval_Status__c = genesisAccountCreationStatus;
                    }
                } else {
                    System.debug(System.LoggingLevel.ERROR, '##DEBUG: Error - the Create Account response is NOT for this transaction');
                    String accountCreationMismatchErrorMessage = 'Integration Transaction mismatch for Create Account! Sent transaction ' +
                            genesisAccountServices.createAccountUid + ' does not match returned transaction ' + createAccountResponseUid;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, accountCreationMismatchErrorMessage));
                    appRequest.Integration_Status__c = ACCOUNT_CREATION_ERROR;
                    appRequest.Integration_Status_Detail__c = accountCreationMismatchErrorMessage;
                }
            } catch (NullPointerException nullEx) {
                System.debug(System.LoggingLevel.ERROR, '##DEBUG: nullEx: ' + nullEx);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Problem with referencing an empty value - please take a screenshot of this page and advise your System Administrator: ' + nullEx.getMessage()));
                appRequest.Integration_Status_Detail__c += ':Problem with referencing an empty value: ' + nullEx.getMessage();
            } catch (DmlException dmlEx) {
                System.debug(System.LoggingLevel.ERROR, '##DEBUG: dmlEx: ' + dmlEx);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Problem with updating a record - please take a screenshot of this page and advise your System Administrator: ' + dmlEx.getMessage()));
                appRequest.Integration_Status_Detail__c += ':Problem with updating a record: ' + dmlEx.getMessage();
            } catch (Exception ex) {
                System.debug(System.LoggingLevel.ERROR, '##DEBUG: ex: ' + ex);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'An error has occurred, please take a screenshot of this page and advise your System Administrator: ' + ex.getMessage()));
                appRequest.Integration_Status_Detail__c += ':An error has occurred: ' + ex.getMessage();
            }
            // Always update records after errors if possible
            update appRequest;
            if (updateOppty) update appOpportunity;
            System.debug(System.LoggingLevel.ERROR, '##DEBUG: account update complete');
            if (updateCards) update appCards;
            System.debug(System.LoggingLevel.ERROR, '##DEBUG: cards update complete');

        } else if (isWSS2Application && sendToWSS2Failed) {
            //  In case of previous failure.
            sendCardToWSS2('');
            update appRequest;

        } else {
            System.debug(System.LoggingLevel.DEBUG, '##DEBUG:canSendToGenesis: ' + canSendToGenesis);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Unable to send to Genesis until required fields populated. See "Can Send To Genesis" field help text for more information.'));
        }
        return pageReturn;
    }
}