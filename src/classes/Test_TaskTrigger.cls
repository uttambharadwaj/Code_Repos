/**
 * Created by W446944 on 7/17/2020.
 */

@IsTest
private class Test_TaskTrigger {

    @IsTest
    static void testInsertCollectionsTask(){

        Task t = new Task();
        t.Subject = 'Collections';
        t.RecordTypeId = UtilityClass.getRecordTypeByName(Task.sObjectType,'Collections');

        Test.startTest();
        insert t;
        Test.stopTest();

        Task myTask = [SELECT Id, RecordType.Name FROM Task WHERE Id =:t.Id];
        system.assert(String.isNotEmpty(myTask.Id));
    }
}