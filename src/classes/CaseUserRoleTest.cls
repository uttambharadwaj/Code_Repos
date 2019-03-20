public class CaseUserRoleTest{
    static testMethod void verifyValidCaseUserRole(){
    
        User testUser = [select id from user where name = 'Paul MacDonald'];
        
        RecordType recType = new RecordType(Name = 'WEX Salesforce Support Request');
        
        Case newCase = new Case(
            Subject = 'test run',
            RecordType = recType,
            User__c=testUser.id);
            
            
        test.startTest();
        insert newCase;
        test.stopTest();

        List<case> cases = [select Requestors_Profile__c from case where subject = 'test run'];

        System.assertEquals(cases[0].Requestors_Profile__c , 'Relationship Manager');
    }
}