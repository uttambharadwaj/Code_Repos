/**
* Forseva consumer credit check code.
*/
public with sharing class CreditForwardingController extends ForsevaControllerBase {

    public CreditForwardingController() {}

    public ApexPages.PageReference forwardToPage() {
    
        String idStr = ApexPages.currentPage().getParameters().get('id');
        String processStr = ApexPages.currentPage().getParameters().get('process');
        ApexPages.PageReference p;
        
        forseva1__CreditPolicy__c corteraPolicy = [select Id from forseva1__CreditPolicy__c where Name = 'Cortera'];
        forseva1__CreditPolicy__c dnbPolicy = [select Id from forseva1__CreditPolicy__c where Name = 'D&B'];
        
        Account a = new Account(id = Id.valueOf(idStr));
        
        if(processStr == CORTERA) {
        	a.forseva1__Credit_Policy__c = corteraPolicy.Id;
        	update a;
            p = Page.forseva1__AccountVerificationList;
        }
        else if(processStr == DNB_VERIFY) {
        	a.forseva1__Credit_Policy__c = dnbPolicy.Id;
        	update a;
            p = Page.forseva1__AccountVerificationList; 
        }
        else if(processStr == DNB_REVIEW) {
        	a.forseva1__Credit_Policy__c = dnbPolicy.Id;
        	update a;
            p = Page.forseva1__CreditReview;
        }
        else {
            return ApexPages.currentPage();
        }
    
        p.getParameters().put('id', idStr);    
        return p;
    }

    //------------------------
    // private
    //------------------------
    
    private final static String CORTERA = 'cortera';
    private final static String DNB_VERIFY = 'dnbverify';
    private final static String DNB_REVIEW = 'dnbreview';

}

// EOF