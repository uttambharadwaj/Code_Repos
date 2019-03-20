@isTest(seealldata=true)
private class EchoTriggerTest {

	static testMethod void EchoTriggerTester() {
    try{
          
         //cretae Account...
          Account acc = new Account();
          acc.F1_Account_Status__c = 'Active Prospect' ;
          acc.Name = 'TestAcc112';
          insert acc;
        
        //Create Contact..
          Contact con = new Contact();  
          con.LastName= 'TestCon112';  
          con.AccountId = acc.Id;
          insert con;
        
	    Opportunity opty  = new Opportunity();
		opty.name = 'wex test Oppt';
		opty.AccountId = acc.id;
		opty.StageName = '1) Qualified';
		opty.closedate = date.today().addDays(10);
		opty.LeadSource = 'Partner' ;
		opty.Fueling_Methos__c = 'test';
		
		insert opty;
        //Opportunity opty = [SELECT Id FROM Opportunity WHERE Id = '0067000000LBKDQAA5'];
       // Opportunity opty = [SELECT Id, AccountId, Billing_Contact__c, Billing_Contact__r.Id, Application_Signer__c, Application_Signer__r.Id FROM Opportunity WHERE Id = '0067000000LBKDQAA5'];
        List<Account> acct = [SELECT Id FROM Account WHERE Id = : opty.AccountId];
        List<Contact> contactList = UTestData.getContacts(acct, 2);
        contactList[0].Email = 'json@wexinc.com';
        contactList[0].LastName = 'Hanley';
        contactList[1].Email = 'rbeat@wexinc.com';
        contactList[1].LastName = 'Beattie';
        
        insert contactList;
        
        test.startTest();
        
        opty.SourceSystem__c = 'Echosign';
        opty.es_Billing_Contact_First_Name__c = 'Jason';
        opty.es_Billing_Contact_Last_Name__c = 'Hanley';
        opty.es_Billing_Contact_Email__c = 'json@wexinc.com';
        //opty.es_Billing_Contact_Phone__c = 207-523-1111;
        
        opty.Application_Signer_First_Name__c = 'Rob';
        opty.Application_Signer_Last_Name__c = 'Beattie';
        opty.Application_Signer_Email_Address__c = 'rbeat@wexinc.com';
        
        opty.Application_Signer_Address__c = '101 A1 Street';
        opty.Application_Signer_City__c = 'Malibu';
        opty.Application_Signer_State__c = 'CA';
        opty.Application_Signer_Zip_Code__c = '44444';
        
        //opty.Application_Signer_Phone__c = 201-444-9999;
        opty.Application_Signer_SSN__c = '111111111';
        //opty.Application_Signer_DOB__c = 10/10/1975;
        
        update opty;

        test.stopTest();
        
     }
     catch(Exception ex){
        
     } 
       
    }

    static testMethod void EchoTriggerTest2() {
        
        //cretae Account...
          Account acc = new Account();
          acc.F1_Account_Status__c = 'Active Prospect' ;
          acc.Name = 'TestAcc112';
          insert acc;
        
        //Create Contact..
          Contact con = new Contact();  
          con.LastName= 'TestCon112';  
          con.AccountId = acc.Id;
          insert con;
        
	    Opportunity opty2  = new Opportunity();
		opty2.name = 'wex test Oppt';
		opty2.AccountId = acc.id;
		opty2.StageName = '5) Signed';
    opty2.Fleet_Size__c = 10;
		opty2.closedate = date.today().addDays(10);
		opty2.LeadSource = 'Partner' ;
		opty2.Fueling_Methos__c = 'test';
		
		insert opty2;
        
        Application_Request__c areq = new Application_Request__c();
        areq.Account_Name__c = acc.id;
        areq.Opportunity__c = opty2.id;
        insert areq;
       // Opportunity opty2 = [SELECT Id, AccountId, Billing_Contact__c, Billing_Contact__r.Id, Application_Signer__c, Application_Signer__r.Id FROM Opportunity WHERE Id = '0067000000LBKDQAA5'];
       //  Application_Request__c areq = [SELECT Id, Account_Name__c FROM Application_Request__c WHERE Account_Name__c = : opty2.AccountId];
        delete areq;
        
        test.startTest();
        
        opty2.SourceSystem__c = 'Echosign';
        opty2.es_Billing_Contact_Last_Name__c = 'Hanley22222';
        opty2.es_Billing_Contact_Email__c = 'json2222@wexinc.com';
        opty2.Application_Signer_Last_Name__c = 'Beattie2222';
        opty2.Application_Signer_Email_Address__c = 'rbeat2222@wexinc.com';
        
        update opty2;
        
        test.stopTest();
    }    
    
}