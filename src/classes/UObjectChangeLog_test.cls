@isTest  
private class UObjectChangeLog_test{
  @testSetup
static void setup(){
   UtilityTestLoader.setAutomation(false);
}

    static testmethod void testupdateOwner()
    {
        Id leadRecordTypeId = Sobjecttype.Lead.getRecordTypeInfosByName().get('Fleet Lead').getRecordTypeId();
        Id acctRecordTypeId = Sobjecttype.account.getRecordTypeInfosByName().get('CorporatePay Accounts').getRecordTypeId();
        
        Id leadRecordTypeId1 = Sobjecttype.Lead.getRecordTypeInfosByName().get('AU Fuel').getRecordTypeId();
        Id acctRecordTypeId1 = Sobjecttype.account.getRecordTypeInfosByName().get('CM Partners').getRecordTypeId();
        
        UserLicense UL =[select id,LicenseDefinitionKey,name from userlicense where name='Salesforce' limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator' and  UserLicense.id = :UL.id  LIMIT 1]; 
      
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
               
        User newUser1 = new User(
         
                profileId = p.id, 
                username = uniqueName + '@test' + orgId + '.org',
                email = uniqueName + '@test' + orgId + '.org',
                emailencodingkey = 'UTF-8', 
                localesidkey = 'en_US', 
                languagelocalekey = 'en_US', 
                timezonesidkey = 'America/Los_Angeles', 
                alias='nuser', 
                isActive = true,
                lastname='lastname');        
            
            insert newUser1;
        
        Pardot_User_Sync_Mapping__c pusm = new Pardot_User_Sync_Mapping__c();
        pusm.name = 'Fleet Acct';
        pusm.RecordType_ID__c = leadRecordTypeId;
        pusm.User_ID__c = newUser1.id;
        insert pusm;
        
        Pardot_User_Sync_Mapping__c pusm1 = new Pardot_User_Sync_Mapping__c();
        pusm1.name = 'CorporatePay Accounts';
        pusm1.RecordType_ID__c = acctRecordTypeId;
        pusm1.User_ID__c = newUser1.id;
        insert pusm1;
        
        list<lead> leadList = new list<lead>();
        
        Lead l = new lead();
        l.recordtypeId = leadRecordTypeId;
        l.LastName = 'test';
        l.Company = 'test company';
        l.Status = 'Qualified';
        leadList.add(l);
        
        Lead l1 = new lead();
        l1.recordtypeId = leadRecordTypeId1;
        l1.LastName = 'test1';
        l1.Company = 'test company';
        l1.Status = 'Qualified';
        leadList.add(l1);
        
        insert leadList;
        
        List<account> acctList = new list<account>();
        Account a = new Account();
        a.name = 'test account';
        a.recordtypeId = acctRecordTypeId;
        acctList.add(a);
        
        Account a1 = new Account();
        a1.name = 'test account1';
        a1.recordtypeId = acctRecordTypeId1;
        acctList.add(a1);
        
        insert acctList;
        
        list<contact> conList = new list<Contact>();
        contact con = new contact();
        con.LastName='Test';
        con.AccountId=a.id;
        conList.add(con);
        
        contact con1 = new contact();
        con1.LastName='Test1';
        con1.AccountId=a1.id;
        conList.add(con1);
        
        insert conList;
         
        list<pi__ObjectChangeLog__c> objchngList = new list<pi__ObjectChangeLog__c>();
         
        pi__ObjectChangeLog__c objchng = new pi__ObjectChangeLog__c();
        objchng.pi__ObjectEmail__c = 'test@test.com';
        objchng.pi__ObjectFid__c = l.id;
        objchng.pi__ObjectMasterRecordId__c = l.id;
        objchng.pi__ObjectState__c = 1;
        objchng.pi__ObjectType__c = 2;
        objchngList.add(objchng);
        
        pi__ObjectChangeLog__c objchng1 = new pi__ObjectChangeLog__c();
        objchng1.pi__ObjectEmail__c = 'test2@test.com';
        objchng1.pi__ObjectFid__c = con.id;
        objchng1.pi__ObjectMasterRecordId__c = con.id;
        objchng1.pi__ObjectState__c = 1;
        objchng1.pi__ObjectType__c = 2;
        objchngList.add(objchng1);
        
        pi__ObjectChangeLog__c objchng2 = new pi__ObjectChangeLog__c();
        objchng2.pi__ObjectEmail__c = 'test@test.com';
        objchng2.pi__ObjectFid__c = l1.id;
        objchng2.pi__ObjectMasterRecordId__c = l1.id;
        objchng2.pi__ObjectState__c = 1;
        objchng2.pi__ObjectType__c = 2;
        objchngList.add(objchng2);
        
        pi__ObjectChangeLog__c objchng3 = new pi__ObjectChangeLog__c();
        objchng3.pi__ObjectEmail__c = 'test@test.com';
        objchng3.pi__ObjectFid__c = con1.id;
        objchng3.pi__ObjectMasterRecordId__c = con1.id;
        objchng3.pi__ObjectState__c = 1;
        objchng3.pi__ObjectType__c = 2;
        objchngList.add(objchng3);
        
        insert objchngList;
     }
}