@isTest
private class V2SA_Test_OwnerChange{

    static testMethod void verifyV2SA_OwnerChangeTrigger(){
    
                  test.startTest();
	List<String> AU_Acc_RTs = new List<String>{'AU_Fuel_Customer'};
  		
  	Id accRT = [select Id from RecordType where sObjectType = 'Account' and DeveloperName NOT IN :AU_Acc_RTs limit 1].Id;
  		
    Account acc = new Account(Name='Account 1',Industry='what',Type='hello', RecordTypeId = accRT);
    insert acc;
    
    Campaign cam = new Campaign(Name='Cam 1',Coupon_Code__c='what',Type='Acquire',Status='Planned',Drop_Date__c=date.today());
    insert cam;
    
    List <User> UserList1 = new List <User> ([Select Id from User where Id != '00570000001Lkjs' and isActive = true LIMIT 1]);
    
    List<String> AU_Opp_RTs = new List<String>{'AU_Fuel_Card_Business','AU_Fuel_Card_Individual','AU_Fuel_Merchant'};
	
	Id oppRT = [select Id from RecordType where sObjectType = 'Opportunity' and DeveloperName NOT IN :AU_Opp_RTs limit 1].Id;

    Opportunity opp = new Opportunity(RecordTypeId = oppRT, Name='Opp 1',AccountId=acc.Id,closedate=date.today(),StageName='1) Qualified',CampaignID=cam.Id, OwnerID=UserList1[0].Id);
    insert opp;
    
   //Salesforce Integration Id in Sandbox = 00570000001Lkjs
//Salesforce Integration Id in Live Org = 00570000001Lkjs

   List <User> UserList2 = new List <User> ([Select Id from User where Id = '00570000001Lkjs']);
  
    
    Task tas1 = new Task(OwnerId='00570000001Lkjs', Subject='Call', Activity_Type__c='Email', ActivityDate=date.today(), Status='Not Started', Priority='3-Medium',WhatID=opp.Id);
    insert tas1;
    
    Task tas2 = new Task(Subject='Call', Activity_Type__c='Email', ActivityDate=date.today(), Status='Not Started', Priority='3-Medium',WhatID=opp.Id);
    insert tas2;
    
    tas2.OwnerId='00570000001Lkjs';
    update tas2;
              
              test.stopTest();
              
             }
}