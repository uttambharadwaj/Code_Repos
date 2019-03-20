@isTest(seealldata=true)
private class updateAppStatusTriggerTest2 {

    static testMethod void updateAppStatusApprovedTest() {
    try{
        Application_Request__c arq = new Application_Request__c();          
        
        test.startTest();
        arq.Sales_Stage__c = '06 - Approved';
        arq.SF_Opp__c='O-00194468';
        insert arq;
        //update arq;
        

        WeFormObject__c bocaOpty = [Select Id, Application_Number__c from WeFormObject__c WHERE Application_Number__c = :arq.SF_Opp__c];
        Online_Application_Status__c status=new Online_Application_Status__c();
        status = [select id from Online_Application_Status__c where id='a1Y700000001FkXEAU'];
        //status = [select id from Online_Application_Status__c where id='a1bS00000002CaBIAU'];
        system.assertEquals('06 - Approved', bocaOpty.Online_Application_Status__c);

        test.stopTest();
        }
        catch(Exception ex){
        
        }        
    }    
}