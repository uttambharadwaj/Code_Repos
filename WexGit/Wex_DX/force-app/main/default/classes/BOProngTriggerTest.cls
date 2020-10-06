@isTest
public class BOProngTriggerTest {

    public static void testValidateNumberOfRecords() {
      
        String highlanderError = 'Only one Control Person record is allowed.'; //error message for too many control persons
        String tooCrowdedError = 'Only four Beneficial Owner records are allowed.'; //error message for too many beneficial owners

        //control person record
        Beneficial_Owner_Prong__c bop1 = [SELECT Id, Beneficial_Owner_Entity__c, RecordTypeId FROM Beneficial_Owner_Prong__c WHERE RecordType.Name='Control Person' LIMIT 1];
        //beneficial owner record
        Beneficial_Owner_Prong__c bop2 = [SELECT Id, Beneficial_Owner_Entity__c, RecordTypeId FROM Beneficial_Owner_Prong__c WHERE RecordType.Name='Beneficial Owner' LIMIT 1];
        //beneficial owner entity with no children; used for successful insert test
        Beneficial_Owner_Entity__c boe = [SELECT Id, RecordTypeId FROM Beneficial_Owner_Entity__c WHERE Record_Status__c = 'Active' LIMIT 1];

        //new records for control person fail, beneficial owners fail, and successful insert
        Beneficial_Owner_Prong__c mmmmmmmBop = new Beneficial_Owner_Prong__c(RecordTypeId=bop1.RecordTypeId,Verification_Status__c='Saved',Beneficial_Owner_Entity__c=bop1.Beneficial_Owner_Entity__c);
        Beneficial_Owner_Prong__c dooooooBop = new Beneficial_Owner_Prong__c(RecordTypeId=bop2.RecordTypeId,Verification_Status__c='Saved',Beneficial_Owner_Entity__c=bop2.Beneficial_Owner_Entity__c);
        Beneficial_Owner_Prong__c yeahEyeahA = new Beneficial_Owner_Prong__c(RecordTypeId=bop1.RecordTypeId,Verification_Status__c='Saved',Beneficial_Owner_Entity__c=boe.Id);

        String errorTheFirst ='';
        String errorTheSecond='';
        String errorTheThird ='';

        //this is a test. this is only a test.
        Test.startTest();
        Database.saveResult[] srList = Database.insert(new List<Beneficial_Owner_Prong__c>{mmmmmmmBop, dooooooBop, yeahEyeahA}, false);
        Test.stopTest();

        for(Database.saveResult sr : srList){
            if(!sr.isSuccess()){
                if(errorTheFirst == ''){
                    for(Database.error er : sr.getErrors())
                        errorTheFirst += er.getMessage();
                } else if(errorTheSecond == ''){
                    for(Database.error er : sr.getErrors())
                        errorTheSecond += er.getMessage();
                } else {
                    for(Database.error er : sr.getErrors())
                        errorTheThird += er.getMessage();
                }
            }
        }

        //verify some things failed and other things did not. 
        system.assertEquals(highlanderError,errorTheFirst);
        system.assertEquals(tooCrowdedError,errorTheSecond);
        system.assertEquals('',errorTheThird);
        system.assertNotEquals(null,yeahEyeahA.Id);
    }

}