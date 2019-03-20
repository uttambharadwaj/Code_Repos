/**
* Forseva online application code.
*/
public with sharing class OnlineApplicationConversionController extends ForsevaControllerBase {

    //-------------------
    // public constants
    //-------------------

    public static final String LEAD = 'lead';
    public static final String NEW_ACCOUNT = 'newAccount';
    public static final String EXISTING_ACCOUNT = 'existingAccount';
    public static final String APPLICATION_ID = 'applicationId';
    public static final String CONVERSION_TYPE = 'conversionType';
    
    //-------------------
    // action methods
    //-------------------
    
    // this method is called in ApplicationConversion page "page action"
    public ApexPages.PageReference performConversion() {
    
        String applicationId = ApexPages.currentPage().getParameters().get(APPLICATION_ID);
        String typeOfConversion = ApexPages.currentPage().getParameters().get(CONVERSION_TYPE);
 
        try {
        
            OnlineApplication oa = new OnlineApplication(OnlineApplication.getSObjectWithAllFields(Id.valueOf(applicationId)));
        
            if(LEAD == typeOfConversion) {
            	
                if(oa.getSO().Lead__c != null) {
                    return new ApexPages.PageReference('/' + oa.getSO().Lead__c);
                }
                else {
                    Id leadId = oa.convertApplicationToLead();
                    return new ApexPages.PageReference('/' + leadId);
                }
            }
    
            else if(NEW_ACCOUNT == typeOfConversion) {
                Id accountId = oa.convertApplicationToAccountContactOpportunity(null);
                return new ApexPages.PageReference('/' + accountId);
            }

            else if(EXISTING_ACCOUNT == typeOfConversion) {
                Id accountId = oa.convertApplicationToAccountContactOpportunity(oa.getSO().Account__c);
                return new ApexPages.PageReference('/' + accountId);
            }
            
            return new ApexPages.PageReference('/' + applicationId);
        }
        catch(Exception e) {
            return new ApexPages.PageReference('/' + applicationId);
        }
    }
    
}

// EOF