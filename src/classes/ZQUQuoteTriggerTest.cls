/*
Description:        Test class for ZQU Quote
Revision History:
*/
@isTest
public class ZQUQuoteTriggerTest {

    public static void testZQUQuoteOnInsert() {
        //for before insert, need one with CustomerApprovalOverride__c and one with isPending__c
        //query any records needed for lookups
        Account acct = [Select Id, Name, Vendor_Name__c from Account WHERE Name = 'Networkfleet' LIMIT 1];
        zqu__Quote__c myQuote = [SELECT Name, isPending__c, CustomerApprovalOverride__c, DatePrepared__c FROM zqu__Quote__c WHERE Name = 'New Quote 1' LIMIT 1];
        
        zqu__Quote__c newQuote1 = myQuote.clone(false,true,false,false);
        newQuote1.CustomerApprovalOverride__c = true;
        
        zqu__Quote__c newQuote2 = myQuote.clone(false,true,false,false);
        newQuote2.isPending__c = true;
        
        //our test is inserting the quotes
        Test.startTest();
        insert new List<zqu__Quote__c>{newQuote1,newQuote2};
        Test.stopTest();

        //query the first quote, customer approval override
        newQuote1 = [SELECT Id, RecordType.DeveloperName FROM zqu__Quote__c WHERE Id = :newQuote1.Id LIMIT 1];
        system.assertEquals('Customer_Approval_Override', newQuote1.RecordType.DeveloperName);

        //query the second quote, is pending
        newQuote2 = [SELECT Id, RecordType.DeveloperName FROM zqu__Quote__c WHERE Id = :newQuote2.Id LIMIT 1];
        system.assertEquals('Pending_Approval_Pending_Customer', newQuote2.RecordType.DeveloperName);

    }

    public static void testZQUQuoteOnUpdate() {
        /*for before update statuses, need:
                1not approved, customer approval override 
                2not approved, pending
                3change to approved, no customer approval
                4change to approved, customer approval true, no customer approval override
                5change to approved, customer approval true, yes customer approval override
                6approved, customer approval changed to true, no customer approval override
                7approved, customer approval changed to true, yes customer approval override
                8change to approved, vendor is not alertdriving, customer approval override, quote count shipment charges >0, no termination fee flag
                9change to approved, vendor is not alertdriving, recurring charge count 0, quote count shipment charges >0, no termination fee flag
                10 change to approved, pending
        */
        zqu__Quote__c myQuote1 = [SELECT Name, isPending__c, CustomerApprovalOverride__c FROM zqu__Quote__c WHERE Name = 'New Quote 1' LIMIT 1];
        zqu__Quote__c myQuote2 = [SELECT Name, isPending__c, CustomerApprovalOverride__c FROM zqu__Quote__c WHERE Name = 'New Quote 2' LIMIT 1];
        zqu__Quote__c myQuote3 = [SELECT Name, isPending__c, CustomerApprovalOverride__c FROM zqu__Quote__c WHERE Name = 'New Quote 3' LIMIT 1];
        zqu__Quote__c myQuote4 = [SELECT Name, isPending__c, CustomerApprovalOverride__c FROM zqu__Quote__c WHERE Name = 'New Quote 4' LIMIT 1];
        zqu__Quote__c myQuote5 = [SELECT Name, isPending__c, CustomerApprovalOverride__c FROM zqu__Quote__c WHERE Name = 'New Quote 5' LIMIT 1];
        zqu__Quote__c myQuote6 = [SELECT Name, isPending__c, CustomerApprovalOverride__c FROM zqu__Quote__c WHERE Name = 'New Quote 6' LIMIT 1];
        zqu__Quote__c myQuote7 = [SELECT Name, isPending__c, CustomerApprovalOverride__c FROM zqu__Quote__c WHERE Name = 'New Quote 7' LIMIT 1];
        zqu__Quote__c myQuote8 = [SELECT Name, isPending__c, CustomerApprovalOverride__c FROM zqu__Quote__c WHERE Name = 'New Quote 8' LIMIT 1];
        zqu__Quote__c myQuote9 = [SELECT Name, isPending__c, CustomerApprovalOverride__c FROM zqu__Quote__c WHERE Name = 'New Quote 9' LIMIT 1];
        zqu__Quote__c myQuote10 = [SELECT Approved__c, isPending__c, CustomerApprovalOverride__c FROM zqu__Quote__c WHERE Name = 'New Quote 10' LIMIT 1];
        
        myQuote1.Approved__c = false;
        myQuote1.CustomerApprovalOverride__c = true;

        myQuote2.Approved__c = false;
        myQuote2.isPending__c = true;

        myQuote3.Approved__c = true;
        myQuote3.CustomerApproval__c = false;

        //old quote was not approved but did have customer approval
        myQuote4.Approved__c = true;
        myQuote4.CustomerApproval__c = true;
        myQuote4.CustomerApprovalOverride__c = false;

        //old quote was not approved but did have customer approval
        myQuote5.Approved__c = true;
        myQuote5.CustomerApproval__c = true;
        myQuote5.CustomerApprovalOverride__c = true;

        //old quote was approved but did not have customer approval
        myQuote6.Approved__c = true;
        myQuote6.CustomerApproval__c = true;
        myQuote6.CustomerApprovalOverride__c = false;

        //old quote was approved but did not have customer approval
        myQuote7.Approved__c = true;
        myQuote7.CustomerApproval__c = true;
        myQuote7.CustomerApprovalOverride__c = true;

        myQuote8.Approved__c = true;
        myQuote8.Vendor__c = 'Geotab';
        myQuote8.CustomerApprovalOverride__c = true;
        myQuote8.Termination_Fee_Flag__c = false;
        
        myQuote9.Approved__c = true;
        myQuote9.Vendor__c = 'Geotab';
        myQuote9.CustomerApprovalOverride__c = false;
        myQuote9.Termination_Fee_Flag__c = false;
        
        myQuote10.Approved__c = true;
        myQuote10.isPending__c = true;
        
        //our test is updating some quotes
        Test.startTest();
        QuoteTriggerHandler.isRunning = true;
        update new List<zqu__Quote__c>{myQuote1,myQuote2,myQuote3,myQuote4,myQuote5,myQuote6,myQuote7,myQuote8,myQuote9,myQuote10};
        Test.stopTest();

        //requery the quotes and verify the results
        myQuote1 = [SELECT RecordType.DeveloperName  FROM zqu__Quote__c WHERE Id = :myQuote1.Id LIMIT 1];
        myQuote2 = [SELECT RecordType.DeveloperName  FROM zqu__Quote__c WHERE Id = :myQuote2.Id LIMIT 1];
        myQuote3 = [SELECT RecordType.DeveloperName, zqu__Status__c  FROM zqu__Quote__c WHERE Id = :myQuote3.Id LIMIT 1];
        myQuote4 = [SELECT RecordType.DeveloperName, zqu__Status__c  FROM zqu__Quote__c WHERE Id = :myQuote4.Id LIMIT 1];
        myQuote5 = [SELECT RecordType.DeveloperName, zqu__Status__c  FROM zqu__Quote__c WHERE Id = :myQuote5.Id LIMIT 1];
        myQuote6 = [SELECT RecordType.DeveloperName, zqu__Status__c  FROM zqu__Quote__c WHERE Id = :myQuote6.Id LIMIT 1];
        myQuote7 = [SELECT RecordType.DeveloperName, zqu__Status__c  FROM zqu__Quote__c WHERE Id = :myQuote7.Id LIMIT 1];
        myQuote8 = [SELECT RecordType.DeveloperName, zqu__Status__c  FROM zqu__Quote__c WHERE Id = :myQuote8.Id LIMIT 1];
        myQuote9 = [SELECT RecordType.DeveloperName, zqu__Status__c,Approved__c,Vendor__c,CustomerApprovalOverride__c,Recurring_Charge_Count__c,Quote_Count_Shipment_Charges__c,Termination_Fee_Flag__c FROM zqu__Quote__c WHERE Id = :myQuote9.Id LIMIT 1];
        myQuote10 = [SELECT RecordType.DeveloperName  FROM zqu__Quote__c WHERE Id = :myQuote10.Id LIMIT 1];
        
        system.assertEquals('Customer_Approval_Override',myQuote1.RecordType.DeveloperName);
        system.assertEquals('Pending_Approval_Pending_Customer',myQuote2.RecordType.DeveloperName);
        system.assertEquals('OutforSignature',myQuote3.RecordType.DeveloperName);
        system.assertEquals('Out for Signature',myQuote3.zqu__Status__c);
        system.assertEquals('CustomerApproved',myQuote4.RecordType.DeveloperName);
        system.assertEquals('Customer Approved',myQuote4.zqu__Status__c);
        system.assertEquals('CustomerApproved',myQuote5.RecordType.DeveloperName);
        system.assertEquals('Customer Approved',myQuote5.zqu__Status__c);
        system.assertEquals('CustomerApproved',myQuote6.RecordType.DeveloperName);
        system.assertEquals('Customer Approved',myQuote6.zqu__Status__c);
        system.assertEquals('CustomerApproved',myQuote7.RecordType.DeveloperName);
        system.assertEquals('Customer Approved',myQuote7.zqu__Status__c);
        system.assertEquals('CustomerApproved',myQuote8.RecordType.DeveloperName);
        system.assertEquals('Customer Approved',myQuote8.zqu__Status__c);
        system.debug(myQuote9);
        system.assertEquals('CustomerApproved',myQuote9.RecordType.DeveloperName);
        system.assertEquals('Customer Approved',myQuote9.zqu__Status__c);
        system.assertEquals('Approved_Pending_Customer',myQuote10.RecordType.DeveloperName);
        
    }
/*
    public static void testSendToZuoraOnUpdate(){
        zqu__Quote__c myQuote11 = [SELECT zqu__ZuoraAccountID__c, Approved__c, CustomerApproval__c FROM zqu__Quote__c WHERE Name = 'New Quote 11' LIMIT 1];
        //for after update, need zqu__ZuoraAccountID__c to be null or blank and Approved__c and CustomerApproval__c
        myQuote11.zqu__ZuoraAccountID__c = null;
        myQuote11.Approved__c = true;
        myQuote11.CustomerApproval__c = true;

        test.startTest();
        update myQuote11;
        test.stopTest();

        myQuote11 = [SELECT RecordType.DeveloperName  FROM zqu__Quote__c WHERE Id = :myQuote11 LIMIT 1];
        system.assert('',myQuote11.RecordType.DeveloperName); //actually tests send to zuora
    }
*/
}