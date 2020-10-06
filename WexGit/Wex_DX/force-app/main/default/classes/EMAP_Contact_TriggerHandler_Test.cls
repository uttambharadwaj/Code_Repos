@isTest
public with sharing class EMAP_Contact_TriggerHandler_Test {
    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }
    static testMethod void testEMAP_Contact_Trigger(){
        
        User user= TestDatatUtility.createUser();
        //insert user;
        
        Account acc = TestDatatUtility.getAccount();
        acc.Temporary_Credit_Expire_Date__c = system.today();
        acc.Temporary_Credit_Limit__c = 123;
        acc.Temporary_Credit_Reason__c = 'ABC';
        //insert acc;
        
        Account acc2 = TestDatatUtility.getAccount();
        acc2.Temporary_Credit_Expire_Date__c = system.today();
        acc2.Temporary_Credit_Limit__c = 124;
        acc2.Temporary_Credit_Reason__c = 'ABD';
        //insert acc2;
        
        List<Account> accList = new List<Account>();
        accList.add(acc);
        accList.add(acc2);
        insert accList;
        
        Contact con = TestDatatUtility.getContact();
        con.ownerId = user.id;
        con.AccountId = acc.Id;
        
        Contact con1 = TestDatatUtility.getContact();
        con1.ownerId = user.id;
        con1.AccountId = acc2.Id;
        
        List<Contact> conList = new List<Contact>();
        conList.add(con);
        conList.add(con1);
        insert conList;
        
        AU_Application_Request__c auAppReq = TestDatatUtility.getAUAppReq();
        auAppReq.Account__c = acc.Id;
        auAppReq.Primary_Contact__c = con.Id;
        auAppReq.Application_Status__c = 'RPS Pending';
        insert auAppReq;
        
        AU_Application_Request__c auAppReq1 = TestDatatUtility.getAUAppReq();
        auAppReq1.Account__c = acc2.Id;
        //auAppReq1.Primary_Contact__c = con1.Id;
        auAppReq.Application_Status__c = 'RPS Pending';
        insert auAppReq1;
        
        acc2.AU_Application_Request__c = auAppReq1.id;
        update acc2;
        
        Test.startTest();
        
        auAppReq.Application_Status__c = 'In Progress';
        update auAppReq;
                
        System.runAs(user){
        
            con.firstName = 'Test';
            update con;
            
            con1.firstName = 'Test';
            update con1;
        }
        
        Test.stopTest();
        
        //EMAP_Contact_TriggerHandler.populateContToAuAppReq(conList);
        //EMAP_Contact_TriggerHandler.propagateAUAppReqToContact(auAppReqList);
}
}