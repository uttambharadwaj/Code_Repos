public class BOCAtoProspectTrackingController {

    public String weFormId { 
        get {
            return ApexPages.currentPage().getParameters().get('customer');
        }
    }
    
    public String action { 
        get {
            return ApexPages.currentPage().getParameters().get('action');
        }
    }
    
    public BOCAtoProspectTrackingController() {
        
    }
    
    public PageReference logVisit() {
     
        PageReference redirect = null;
        
        try {
        	if(weFormId != null) {
            	BOCA_To_Prospect__c bocaToProspect = [SELECT Id, Read_By_Recipient__c FROM BOCA_To_Prospect__c WHERE WeFormObject__c = :weFormId];
            	bocaToProspect.Read_By_Recipient__c = true;
                bocaToProspect.Last_Read_Date__c = Date.Today();
            	upsert bocaToProspect;
        	}
            
            if(weFormId != null && action != null) {
                if(action.equalsIgnoreCase('learnmore')) {
                    WeFormObject__c weForm = [SELECT Id, Program__c FROM WeFormObject__c WHERE Id =: weFormId];
                    
                    System.debug(weForm.Program__c);
                    
                    Program__c program = [SELECT Id, BOCA_Sell_Sheet__c FROM Program__c WHERE Id =: weForm.Program__c];
                    
                    redirect = new PageReference(program.BOCA_Sell_Sheet__c);
                    
                    BOCA_To_Prospect__c bocaToProspect = [SELECT Id, Read_Sell_Sheet__c FROM BOCA_To_Prospect__c WHERE WeFormObject__c = :weFormId];
        	    	bocaToProspect.Read_Sell_Sheet__c = true;
	            	upsert bocaToProspect;
                }
            }
        }
        catch(Exception e) {
            
        }
        
        return redirect;
    }
    
}