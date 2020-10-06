/**
    ClassName  : UOnlineApplicationHomePgComp 
    Case Number :00022578
    Description : Retrive the Online Applications owned by the logged in user
*/

public with sharing class UOnlineApplicationHomePgComp {
    
    public String applicationFilter { get; set; }
    
    public List<OnlineApplication__c> lstOnlineApplication { get;set; }
    
    public UOnlineApplicationHomePgComp() {
        
        applicationFilter = 'completed';
        
        getApplications();
        
    }
    
    public void getApplications() {
        
        System.debug(applicationFilter);
        
        if(applicationFilter.equalsIgnoreCase('completed')) {
            lstOnlineApplication = new List<OnlineApplication__c>();
        	lstOnlineApplication = [ Select Name, eSignature_Status__c, Status__c, Legal_Business_Name__c, Id, Application_Title__c 
                                 From OnlineApplication__c 
                                 where OwnerId =: UserInfo.getUserId() and (NOT Status__c LIKE '%Incomplete%')
                                 ORDER BY CreatedDate DESC ];
        }
        else {
            lstOnlineApplication = new List<OnlineApplication__c>();
        	lstOnlineApplication = [ Select Name, eSignature_Status__c, Status__c, Legal_Business_Name__c, Id, Application_Title__c 
                                 From OnlineApplication__c 
                                 where OwnerId =: UserInfo.getUserId() and (Status__c LIKE '%Incomplete%')
                                 ORDER BY CreatedDate DESC ];
        }
        
    }
}