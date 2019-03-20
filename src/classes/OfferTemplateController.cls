/**
* Forseva online application code.
*/
public with sharing class OfferTemplateController extends ForsevaControllerBase {

    public OfferTemplateController(ApexPages.StandardController sc) {
        m_offer = (OnlineApplicationOffer__c)sc.getRecord();
    }

    public OnlineApplicationOffer__c getOffer() {
        return m_offer;
    }

    public List<SelectOption> getTemplates() {
    	
    	List<SelectOption> choices = new List<SelectOption>{new SelectOption('','--'+Label.NONE+'--')};
        for(EmailTemplate temp : [select Id, Name, Subject from EmailTemplate where IsActive = true order by Name]) {                                  	
            if(temp.Subject.contains('OnlineApplication__c')) {
                choices.add(new SelectOption(temp.Id, temp.Name));
            }
        }    	
    	return choices;
    }

    public ApexPages.PageReference doSave() {    	        
        update m_offer;
        ApexPages.PageReference p = new ApexPages.PageReference('/' + m_offer.Id);
        return p;
    }

    public ApexPages.PageReference doCancel() {               
        ApexPages.PageReference p = new ApexPages.PageReference('/' + m_offer.Id);
        return p;
    }
 
    //------------------
    // private
    //------------------
    
    private OnlineApplicationOffer__c m_offer;
}

// EOF