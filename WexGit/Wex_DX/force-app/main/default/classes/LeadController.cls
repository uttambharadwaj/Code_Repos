public class LeadController{

    
    public Lead lead{get; set;}
        
    public LeadController(){
        lead = new Lead();
    }
    public PageReference save() {

        lead.LeadSource = 'Mobile';
        lead.Primary_Campaign__c = '70170000000gbFM';
        upsert(lead);
        
        PageReference p = Page.LeadMobileConfirm;
        return p.setRedirect(true);
       
    }
    public Lead getLead(){
        return lead;
    }
    
    public List<SelectOption> getStates() {
        return WEXHelper.getStatesWithNames();
    }
   
    
   
}