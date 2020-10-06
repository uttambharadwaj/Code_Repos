public class FindDupOnlineAppsController {
        
    public String applicationId {
        get {
            if(ApexPages.currentPage().getParameters().get('id') != null) {
         		return ApexPages.currentPage().getParameters().get('id');
            }
            return null;
        }
    }
    
    public OnlineApplication__c originalApplication { get; set; }
    
    public List<OnlineApplication__c> duplicateApplications { get; set; }
    
    public List<FSC_Existing_Exposure__c> duplicateAccounts { get; set; }
    
    public boolean hasNoRecords {get;set;}
    
    public FindDupOnlineAppsController(){
               
    }

    public void init() {
        
        originalApplication = [SELECT Id, Name, Legal_Business_Name__c, Business_Street_Address__c, City__c, State__c, Zip_Code__c FROM OnlineApplication__c WHERE Id =: applicationId];
        
        if(originalApplication != null) {
            
            //duplicateApplications = CreditUtil_ExistingExposure.getOnlineApplications(originalApplication.Id);
            
            //duplicateAccounts = CreditUtil_ExistingExposure.getExistingAccounts(originalApplication.Id);
            
        }
            
    }
    
}