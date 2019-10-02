/*
Description:        Test class for Beneficial Owner Entity Trigger
Revision History:
*/
@isTest
public class BOEntityTriggerTest {

    public static void testBOEOpptyInfoOnInsert() {
        //opportunity should get updated to reflect boe id. also BOE should get legal structure
        Opportunity o = [SELECT Id, Legal_Structure__c FROM Opportunity WHERE Name='Test Oppty' LIMIT 1];
        
        Beneficial_Owner_Entity__c boe = new Beneficial_Owner_Entity__c();
        boe.Opportunity__c=o.Id;
        boe.Certified_Date__c=Date.today();
        boe.Certified_By__c='Test';
        boe.Record_Status__c='Active';

        Test.startTest();
        insert boe;
        Test.stopTest();

        //Asserts for Before Insert logic on mapping parents
        Beneficial_Owner_Entity__c myBOE = [SELECT Id, Legal_Structure__c FROM Beneficial_Owner_Entity__c WHERE Id =:boe.Id];
        system.assertEquals(o.Legal_Structure__c, myBOE.Legal_Structure__c);

        //Asserts for After Insert logic on update opportunity
        Opportunity myOppty = [SELECT Id, Beneficial_Owner_Entity__c FROM Opportunity WHERE Id=:o.Id];
        system.assertEquals(boe.Id, myOppty.Beneficial_Owner_Entity__c);

    }

    public static void testUpdateExemptionStatusBeforeInsert() {
        //before insert, some BOEs need to have status and record types updated.
        //TODO: add 2 BOEs that do not get changed (one bc legal structure, one bc recordtype). assert that these do not change.
        Opportunity o = [SELECT Id, Legal_Structure__c FROM Opportunity WHERE Name='Test Oppty' LIMIT 1];
        Opportunity o2 = [SELECT Id, Legal_Structure__c FROM Opportunity WHERE Name='Test Oppty 2' LIMIT 1];
        Opportunity o3 = [SELECT Id, Legal_Structure__c FROM Opportunity WHERE Name='Test Oppty 3' LIMIT 1];

        Beneficial_Owner_Entity__c boe = new Beneficial_Owner_Entity__c();
        boe.Opportunity__c=o.Id;
        boe.Verification_Status__c='Pending Lexis/Nexis';
        boe.Country_Code__c='US';
        boe.Certified_Date__c=Date.today();
        boe.Certified_By__c='Test';
        boe.RecordTypeId = UtilityClass.getRecordTypeByName(Beneficial_Owner_Entity__c.sObjectType,'Fuel Card');

        Beneficial_Owner_Entity__c boe2 = new Beneficial_Owner_Entity__c();
        boe2.Opportunity__c=o2.Id;
        boe2.Verification_Status__c='Pending Lexis/Nexis';
        boe2.Country_Code__c='US';
        boe2.Certified_Date__c=Date.today();
        boe2.Certified_By__c='Test';
        boe2.RecordTypeId = UtilityClass.getRecordTypeByName(Beneficial_Owner_Entity__c.sObjectType,'Fleet Card');

        Beneficial_Owner_Entity__c boe3 = new Beneficial_Owner_Entity__c();
        boe3.Opportunity__c=o3.Id;
        boe3.Verification_Status__c='Pending Lexis/Nexis';
        boe3.Country_Code__c='US';
        boe3.Certified_Date__c=Date.today();
        boe3.Certified_By__c='Test';
        boe3.RecordTypeId = UtilityClass.getRecordTypeByName(Beneficial_Owner_Entity__c.sObjectType,'Factoring');

        Test.startTest();
        insert new List<Beneficial_Owner_Entity__c>{boe,boe2,boe3};
        Test.stopTest();

        Beneficial_Owner_Entity__c myBOE = [SELECT Id, Verification_Status__c, Legal_Structure__c, RecordType.Name FROM Beneficial_Owner_Entity__c WHERE Id =:boe.Id];
        Beneficial_Owner_Entity__c myBOE2 = [SELECT Id, Verification_Status__c, Legal_Structure__c, RecordType.Name FROM Beneficial_Owner_Entity__c WHERE Id =:boe2.Id];
        Beneficial_Owner_Entity__c myBOE3 = [SELECT Id, Verification_Status__c, Legal_Structure__c, RecordType.Name FROM Beneficial_Owner_Entity__c WHERE Id =:boe3.Id];
        
        system.assertEquals('Exempted', myBOE.Verification_Status__c);
        system.assertEquals('Exempted', myBOE2.Verification_Status__c);
        system.assertEquals('Exempted', myBOE3.Verification_Status__c);
        system.assertEquals('Fuel Card - Locked', myBOE.RecordType.Name);
        system.assertEquals('Fleet Card - Locked', myBOE2.RecordType.Name);
        system.assertEquals('Factoring - Locked', myBOE3.RecordType.Name);
    }

    public static void testLegalStructureBeforeInsertFail(){
        //if an oppty doesn't have legal structure the BOE insert should fail
        String parentFail = 'Please ensure you have selected a Legal Structure on the Opportunity, then try again!';
        Opportunity o = [SELECT Id FROM Opportunity WHERE Name='Test Oppty 5' LIMIT 1];
        
        //this one will fail because Test Oppty 5 has no legal structure
        Beneficial_Owner_Entity__c boe = new Beneficial_Owner_Entity__c();
        boe.Certified_Date__c=Date.today();
        boe.Certified_By__c='Test';
        boe.Opportunity__c=o.Id;

        String myError = '\'sall good, man';
        
        Test.startTest();
        try{
            insert boe;
        } catch(Exception e){
            myError = e.getMessage();
        }
        Test.stopTest();
        
        System.Assert(myError.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        System.Assert(myError.contains(parentFail));        
    }

    public static void testUpdateExemptionStatusBeforeUpdate() {
        //before update, some BOEs need to have status and record types updated.
        //TODO: add 2 BOEs that do not get changed (one bc legal structure, one bc recordtype). assert that these do not change
        Opportunity o2 = [SELECT Id, Legal_Structure__c FROM Opportunity WHERE Name='Test Oppty 2' LIMIT 1];
        Opportunity o3 = [SELECT Id, Legal_Structure__c FROM Opportunity WHERE Name='Test Oppty 3' LIMIT 1];
        Opportunity o4 = [SELECT Id, Legal_Structure__c FROM Opportunity WHERE Name='Test Oppty 4' LIMIT 1];

        Beneficial_Owner_Entity__c boe2 = [SELECT Id, Verification_Status__c, Certified_Date__c, Certified_By__c, RecordType.Name FROM Beneficial_Owner_Entity__c WHERE Opportunity__c =:o2.Id];
        Beneficial_Owner_Entity__c boe3 = [SELECT Id, Verification_Status__c, Certified_Date__c, Certified_By__c, RecordType.Name FROM Beneficial_Owner_Entity__c WHERE Opportunity__c =:o3.Id];
        Beneficial_Owner_Entity__c boe4 = [SELECT Id, Verification_Status__c, Certified_Date__c, Certified_By__c, RecordType.Name FROM Beneficial_Owner_Entity__c WHERE Opportunity__c =:o4.Id];
        
        boe2.Verification_Status__c='Pending Lexis/Nexis';
        boe3.Verification_Status__c='Pending Lexis/Nexis';
        boe4.Verification_Status__c='Pending Lexis/Nexis';
        boe2.Certified_Date__c=Date.today();
        boe3.Certified_Date__c=Date.today();
        boe4.Certified_Date__c=Date.today();
        boe2.Certified_By__c='Test';
        boe3.Certified_By__c='Test';
        boe4.Certified_By__c='Test';
        
        system.assertNotEquals('Exempted', boe2.Verification_Status__c);
        system.assertNotEquals('Exempted', boe3.Verification_Status__c);
        system.assertNotEquals('Exempted', boe4.Verification_Status__c);
        system.assertNotEquals('Fuel Card - Locked', boe2.RecordType.Name);
        system.assertNotEquals('Fleet Card - Locked', boe3.RecordType.Name);
        system.assertNotEquals('Factoring - Locked', boe4.RecordType.Name);

        Test.startTest();
        update new List<Beneficial_Owner_Entity__c>{boe2,boe3,boe4};
        Test.stopTest();

        Beneficial_Owner_Entity__c myBOE2 = [SELECT Id, Verification_Status__c, RecordType.Name FROM Beneficial_Owner_Entity__c WHERE Id =:boe2.Id];
        Beneficial_Owner_Entity__c myBOE3 = [SELECT Id, Verification_Status__c, RecordType.Name FROM Beneficial_Owner_Entity__c WHERE Id =:boe3.Id];
        Beneficial_Owner_Entity__c myBOE4 = [SELECT Id, Verification_Status__c, RecordType.Name FROM Beneficial_Owner_Entity__c WHERE Id =:boe4.Id];
        
        system.assertEquals('Exempted', myBOE2.Verification_Status__c);
        system.assertEquals('Exempted', myBOE3.Verification_Status__c);
        system.assertEquals('Exempted', myBOE4.Verification_Status__c);
        system.assertEquals('Fuel Card - Locked', myBOE2.RecordType.Name);
        system.assertEquals('Fleet Card - Locked', myBOE3.RecordType.Name);
        system.assertEquals('Factoring - Locked', myBOE4.RecordType.Name);
    }

    public static void testCheckOpptyChangesAfterUpdate() {
        //if oppty changes, update the oppty lookup
        Opportunity o = [SELECT Id, Beneficial_Owner_Entity__c FROM Opportunity WHERE Name='Test Oppty' LIMIT 1];
        Opportunity o2 = [SELECT Id, Beneficial_Owner_Entity__c FROM Opportunity WHERE Name='Test Oppty 2' LIMIT 1];
        Beneficial_Owner_Entity__c boe = [SELECT Id, Opportunity__c FROM Beneficial_Owner_Entity__c WHERE Opportunity__c =:o.Id];
        
        boe.Opportunity__c=o2.Id;
        
        Test.startTest();
        update boe;
        Test.stopTest();

        Opportunity myOpp = [SELECT Id, Beneficial_Owner_Entity__c FROM Opportunity WHERE Id =:o2.Id LIMIT 1];
        
        system.assertEquals(boe.Id, myOpp.Beneficial_Owner_Entity__c);
    }
    
    //this test is for business processes converted FROM a trigger but now being processed outside of Apex (Process Builder). no code coverage value.
    public static void testBusinessProcesses(){
        //need to check account language preference, and also check archive siblings
        Account a = [SELECT Id, Preferred_Language__c FROM Account WHERE Name = 'Test' LIMIT 1];
        Opportunity o = [SELECT Id FROM Opportunity WHERE Name = 'Test Oppty' LIMIT 1];
        Beneficial_Owner_Entity__c boInit = [SELECT Id, Record_Status__c FROM Beneficial_Owner_Entity__c WHERE Opportunity__c = :o.Id LIMIT 1];
        system.assertEquals(boInit.Record_Status__c, 'Active');

        Beneficial_Owner_Entity__c boe = new Beneficial_Owner_Entity__c();
        boe.Account__c=a.Id;
        boe.Opportunity__c=o.Id;
        boe.Certified_Date__c=Date.today();
        boe.Certified_By__c='Test';
        boe.Record_Status__c='Active';

        test.startTest();
        insert boe;
        test.stopTest();

        boe = [SELECT Id, Language_Preference__c, Record_Status__c FROM Beneficial_Owner_Entity__c WHERE Id = :boe.Id LIMIT 1];
        system.assertEquals(boe.Language_Preference__c, a.Preferred_Language__c);
        system.assertEquals(boe.Record_Status__c, 'Active');
        
        boInit = [SELECT Id, Record_Status__c FROM Beneficial_Owner_Entity__c WHERE Id = :boInit.Id LIMIT 1];
        system.assertEquals(boInit.Record_Status__c, 'Archived');

    }

}