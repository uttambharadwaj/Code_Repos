/*
*
* Credit Decisioning Process
* Module: LexisNexis Bridger
* Author: Derek Gilbert
* Initial Date: 3/18/2018
*
*/
public with sharing class CreditWS_LexisNexisBridger {
    
    public static String lexisNexisBridgerEndpointURL { get; set; }
    
    public static Credit_Decision_Engine_Endpoints__mdt lexisNexisBridgerSettings {
        get {
            
            try {
                UtilityClass Utility = new UtilityClass();
                if (Utility.runningInASandbox == true){
                    Credit_Decision_Engine_Endpoints__mdt lexisNexisBridgerSettings = [SELECT Id, Username__c, Password__c, Client_ID__c, Endpoint_URL__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'LexisNexis_Bridger_Sandbox'];
                }
                else {
                    Credit_Decision_Engine_Endpoints__mdt lexisNexisBridgerSettings = [SELECT Id, Username__c, Password__c, Client_ID__c, Endpoint_URL__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'LexisNexis_Bridger'];
                }
                return lexisNexisBridgerSettings;
                
            }
            catch(Exception e) {
                
                System.debug('### ERROR: Error getting Lexis Nexis Bridger connection settings.');
                
            }
            
            return null;
            
        }
    }
    
    public CreditWS_LexisNexisBridger() {
        
    }

    public static Integer checkPasswordExpiration() {

        try {

            if (lexisNexisBridgerSettings != null) {

                // Client Context w/ credentials/etc
                CreditWSUtil_LexisNexisBridger.ClientContext clientContext = new CreditWSUtil_LexisNexisBridger.ClientContext();

                clientContext.ClientID = lexisNexisBridgerSettings.Client_ID__c;
                clientContext.UserId = lexisNexisBridgerSettings.Username__c;
                clientContext.Password = lexisNexisBridgerSettings.Password__c;

                CreditWSUtil_LexisNexisBridger.BasicHttpBinding_ISearch accountClient = new CreditWSUtil_LexisNexisBridger.BasicHttpBinding_ISearch();

                accountClient.endpoint_x = 'https://' + lexisNexisBridgerSettings.Endpoint_URL__c + '/WebServicesAPI/10.1/XGServices.svc/Account';

                if(!TestUtils.isRunningTest()) {

                    return accountClient.GetDaysUntilPasswordExpires(clientContext);

                }

            }

        }
        catch(Exception e) {

            System.debug('### ERROR');

        }

        return -1;

    }

    public static LexisNexisBridgerBusinessResponse bridgerSearchBusiness(LexisNexisBridgerBusinessRequest request) {

        // Testing
        LexisNexisBridgerBusinessResponse lexisNexisBridgerBusinessResponse = new LexisNexisBridgerBusinessResponse();

        try {

            if(lexisNexisBridgerSettings != null) {

                // Client Context w/ credentials/etc
                CreditWSUtil_LexisNexisBridger.ClientContext clientContext = new CreditWSUtil_LexisNexisBridger.ClientContext();

                clientContext.ClientID = lexisNexisBridgerSettings.Client_ID__c;
                clientContext.UserId = lexisNexisBridgerSettings.Username__c;
                clientContext.Password = lexisNexisBridgerSettings.Password__c;
                clientContext.ClientReference = request.clientReferenceId;

                // Search Configuration
                CreditWSUtil_LexisNexisBridger.SearchConfiguration searchConfiguration = new CreditWSUtil_LexisNexisBridger.SearchConfiguration();

                searchConfiguration.AssignResultTo = new CreditWSUtil_LexisNexisBridger.AssignmentInfo();

                searchConfiguration.AssignResultTo.Division = 'Default Division';

                CreditWSUtil_LexisNexisBridger.ArrayofString rolesOrUsers = new CreditWSUtil_LexisNexisBridger.ArrayofString();
                rolesOrUsers.string_x = new String[]{'Administrator'};
                searchConfiguration.AssignResultTo.RolesOrUsers = rolesOrUsers;

                searchConfiguration.AssignResultTo.Type_x = 'Role';
                searchConfiguration.PredefinedSearchName = 'Business Screening';
                searchConfiguration.WriteResultsToDatabase = true;

                // Search Inputs
                CreditWSUtil_LexisNexisBridger.SearchInput searchInput = new CreditWSUtil_LexisNexisBridger.SearchInput();

                CreditWSUtil_LexisNexisBridger.InputRecord[] inputRecords = new CreditWSUtil_LexisNexisBridger.InputRecord[]{};

                CreditWSUtil_LexisNexisBridger.InputRecord inputRecord = new CreditWSUtil_LexisNexisBridger.InputRecord();
                inputRecord.Entity = new CreditWSUtil_LexisNexisBridger.InputEntity();
                inputRecord.Entity.EntityType = 'Business';

                // Name setup
                inputRecord.Entity.Name = new CreditWSUtil_LexisNexisBridger.InputName();
                inputRecord.Entity.Name.Full = request.companyName;

                // Address setup
                CreditWSUtil_LexisNexisBridger.InputAddress[] inputAddresses = new CreditWSUtil_LexisNexisBridger.InputAddress[]{};

                CreditWSUtil_LexisNexisBridger.InputAddress inputAddress = new CreditWSUtil_LexisNexisBridger.InputAddress();
                inputAddress.Street1 = request.addressLine1;
                inputAddress.City = request.city;
                inputAddress.StateProvinceDistrict = request.state;
                inputAddress.PostalCode = request.postalCode;
                inputAddress.Type_x = 'Current';
                inputAddresses.add(inputAddress);

                inputRecord.Entity.Addresses = new CreditWSUtil_LexisNexisBridger.ArrayOfInputAddress();
                inputRecord.Entity.Addresses.InputAddress = inputAddresses;

                inputRecords.add(inputRecord);

                searchInput.Records = new CreditWSUtil_LexisNexisBridger.ArrayOfInputRecord();
                searchInput.Records.InputRecord = inputRecords;

                CreditWSUtil_LexisNexisBridger.BasicHttpBinding_ISearch searchClient = new CreditWSUtil_LexisNexisBridger.BasicHttpBinding_ISearch();

                searchClient.endpoint_x = 'https://' + lexisNexisBridgerSettings.Endpoint_URL__c + '/WebServicesAPI/10.1/XGServices.svc/Search';

                if(!TestUtils.isRunningTest()) {

                    CreditWSUtil_LexisNexisBridger.SearchResults results = searchClient.Search_x(clientContext, searchConfiguration, searchInput);

                    if (results != null && results.Records != null && results.Records.ResultRecord != null) {
                        if (results.Records.ResultRecord.size() > 0) {
                            lexisNexisBridgerBusinessResponse.businessPassed = false;
                            lexisNexisBridgerBusinessResponse.sanctionsResultId = String.valueOf(results.Records.ResultRecord[0].ResultID);
                        }
                    } else if (results != null && results.Records == null) {
                        lexisNexisBridgerBusinessResponse.businessPassed = true;
                    }

                }

            }

        }
        catch(Exception e) {

            System.debug('### ERROR');

            lexisNexisBridgerBusinessResponse.calloutFailed = true;

        }

        System.debug('### ' + lexisNexisBridgerBusinessResponse);

        return lexisNexisBridgerBusinessResponse;

    }

    public static LexisNexisBridgerIndividualResponse bridgerSearchIndividual(LexisNexisBridgerIndividualRequest request) {
        
        // Testing
        LexisNexisBridgerIndividualResponse lexisNexisBridgerResponse = new LexisNexisBridgerIndividualResponse();
        
        try {
            
            if(lexisNexisBridgerSettings != null) {

                // Client Context w/ credentials/etc
                CreditWSUtil_LexisNexisBridger.ClientContext clientContext = new CreditWSUtil_LexisNexisBridger.ClientContext();
                
                clientContext.ClientID = lexisNexisBridgerSettings.Client_ID__c;
                clientContext.UserId = lexisNexisBridgerSettings.Username__c;
                clientContext.Password = lexisNexisBridgerSettings.Password__c;
                clientContext.ClientReference = request.clientReferenceId;
                
                // Search Configuration
                CreditWSUtil_LexisNexisBridger.SearchConfiguration searchConfiguration = new CreditWSUtil_LexisNexisBridger.SearchConfiguration();
                
                searchConfiguration.AssignResultTo = new CreditWSUtil_LexisNexisBridger.AssignmentInfo();
                
                searchConfiguration.AssignResultTo.Division = 'Default Division';
                
                CreditWSUtil_LexisNexisBridger.ArrayofString rolesOrUsers = new CreditWSUtil_LexisNexisBridger.ArrayofString();
                rolesOrUsers.string_x = new String[]{'Administrator'};
                searchConfiguration.AssignResultTo.RolesOrUsers = rolesOrUsers;
                
                searchConfiguration.AssignResultTo.Type_x = 'Role';
                searchConfiguration.PredefinedSearchName = 'Individual Screening';
                searchConfiguration.WriteResultsToDatabase = true;
                
                // Search Inputs
                CreditWSUtil_LexisNexisBridger.SearchInput searchInput = new CreditWSUtil_LexisNexisBridger.SearchInput();
                
                CreditWSUtil_LexisNexisBridger.InputRecord[] inputRecords = new CreditWSUtil_LexisNexisBridger.InputRecord[]{};

                CreditWSUtil_LexisNexisBridger.InputRecord inputRecord = new CreditWSUtil_LexisNexisBridger.InputRecord();
                inputRecord.Entity = new CreditWSUtil_LexisNexisBridger.InputEntity();
                inputRecord.Entity.EntityType = 'Individual';
                
                // Name setup
                inputRecord.Entity.Name = new CreditWSUtil_LexisNexisBridger.InputName();
                inputRecord.Entity.Name.First = request.firstName;
                inputRecord.Entity.Name.Last = request.lastName;
                
                // Address setup
                CreditWSUtil_LexisNexisBridger.InputAddress[] inputAddresses = new CreditWSUtil_LexisNexisBridger.InputAddress[]{};

                CreditWSUtil_LexisNexisBridger.InputAddress inputAddress = new CreditWSUtil_LexisNexisBridger.InputAddress();
                inputAddress.Street1 = request.addressLine1;
                inputAddress.City = request.city;
                inputAddress.StateProvinceDistrict = request.state;
                inputAddress.PostalCode = request.postalCode;
                inputAddress.Type_x = 'Current';
                inputAddresses.add(inputAddress);

                inputRecord.Entity.Addresses = new CreditWSUtil_LexisNexisBridger.ArrayOfInputAddress();
                inputRecord.Entity.Addresses.InputAddress = inputAddresses;

                // Phone Number Setup
                CreditWSUtil_LexisNexisBridger.InputPhone[] inputPhones = new CreditWSUtil_LexisNexisBridger.InputPhone[]{};

                CreditWSUtil_LexisNexisBridger.InputPhone inputPhone = new CreditWSUtil_LexisNexisBridger.InputPhone();

                inputPhone.Type_x = 'Home';
                inputPhone.Number_x = request.phoneNumber;

                inputPhones.add(inputPhone);

                inputRecord.Entity.Phones = new CreditWSUtil_LexisNexisBridger.ArrayOfInputPhone();
                inputRecord.Entity.Phones.InputPhone = inputPhones;

                // DOB Setup
                CreditWSUtil_LexisNexisBridger.InputAdditionalInfo[] additionalInfos = new CreditWSUtil_LexisNexisBridger.InputAdditionalInfo[]{};

                Date inputDate = request.dateOfBirth;
                Datetime inputDateTime = Datetime.newInstance(inputDate.year(), inputDate.month(),inputDate.day());

                CreditWSUtil_LexisNexisBridger.InputAdditionalInfo additionalInfo = new CreditWSUtil_LexisNexisBridger.InputAdditionalInfo();
                additionalInfo.Type_x = 'DOB';
                additionalInfo.Date_x = new CreditWSUtil_LexisNexisBridger.Date_x();
                additionalInfo.Date_x.Unparsed = inputDateTime.format('yyyy/MM/dd');

                additionalInfos.add(additionalInfo);
                
                inputRecord.Entity.AdditionalInfo = new CreditWSUtil_LexisNexisBridger.ArrayOfInputAdditionalInfo();
                inputRecord.Entity.AdditionalInfo.InputAdditionalInfo = additionalInfos;
                
                // SSN Setup
                CreditWSUtil_LexisNexisBridger.InputID[] ids = new CreditWSUtil_LexisNexisBridger.InputID[]{};
                    
                CreditWSUtil_LexisNexisBridger.InputID inputID = new CreditWSUtil_LexisNexisBridger.InputID();
                inputID.Type_x = 'SSN';
                inputID.Number_x = request.socialSecurityNumber;
                
                ids.add(inputID);
                
                inputRecord.Entity.IDs = new CreditWSUtil_LexisNexisBridger.ArrayOfInputID();
                inputRecord.Entity.IDs.InputID = ids;
                
                inputRecords.add(inputRecord);
                
                searchInput.Records = new CreditWSUtil_LexisNexisBridger.ArrayOfInputRecord();
                searchInput.Records.InputRecord = inputRecords;
                
                CreditWSUtil_LexisNexisBridger.BasicHttpBinding_ISearch searchClient = new CreditWSUtil_LexisNexisBridger.BasicHttpBinding_ISearch();
                
                searchClient.endpoint_x = 'https://' + lexisNexisBridgerSettings.Endpoint_URL__c + '/WebServicesAPI/10.1/XGServices.svc/Search';

                System.debug(searchConfiguration);
                
                CreditWSUtil_LexisNexisBridger.SearchResults results = searchClient.Search_x(clientContext, searchConfiguration, searchInput);
                
                if(results != null && results.Records != null && results.Records.ResultRecord != null) {
                    if(results.Records.ResultRecord.size() > 0) {
                        lexisNexisBridgerResponse.individualPassed = false;
                        lexisNexisBridgerResponse.sanctionsResultId = String.valueOf(results.Records.ResultRecord[0].ResultID);
                    }
                }
                else if(results != null && results.Records == null) {
                    lexisNexisBridgerResponse.individualPassed = true;
                }

            }
            
        }
        catch(Exception e) {
            
            System.debug('### ERROR');
            
            lexisNexisBridgerResponse.calloutFailed = true;
            
        }

        System.debug('### ' + lexisNexisBridgerResponse);

        return lexisNexisBridgerResponse;
        
    }
    
    public class LexisNexisBridgerIndividualRequest {

        public String clientReferenceId;

        public String firstName;
        public String lastName;
        public Date dateOfBirth;
        public String socialSecurityNumber;
        public String addressLine1;
        public String city;
        public String state;
        public String postalCode;
        public String phoneNumber;

    }

    public class LexisNexisBridgerIndividualResponse {

        public Boolean calloutFailed { get; set; }
        public Boolean individualPassed { get; set; }
        public String sanctionsResultId { get; set; }

        public LexisNexisBridgerIndividualResponse() {

            calloutFailed = false;

        }

    }

    public class LexisNexisBridgerBusinessRequest {

        public String clientReferenceId;

        public String companyName;
        public String ein;
        public String addressLine1;
        public String city;
        public String state;
        public String postalCode;

    }

    public class LexisNexisBridgerBusinessResponse {

        public Boolean calloutFailed { get; set; }
        public Boolean businessPassed { get; set; }
        public String sanctionsResultId { get; set; }

        public LexisNexisBridgerBusinessResponse() {

            calloutFailed = false;

        }

    }
}