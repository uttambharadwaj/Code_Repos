@isTest
private class WE_ScheduledDeadlineUpdateTest {

    @testSetup
    static void dataSetup() {

        Profile p1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator - Wex Europe'];

        // create User
        User[] userList = new User[]{};
            User u = new User();

        u.FirstName 		= 'Alex';
        u.LastName 			= 'Sherwood';
        u.Email 			= 'test@wexeurope.com';
        u.Username 			= 'astest@wexeurope.com';
        u.Alias 			= 'astest';
        u.ProfileId 		= p1.Id;
        u.TimeZoneSidKey    = 'America/Denver';
        u.LocaleSidKey      = 'en_US';
        u.EmailEncodingKey  = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        userList.add(u);

        insert userList;

        System.runas(u){

            // create Custom Setting
            VRTN__c[] csList = new VRTN__c[]{};
                VRTN__c cs = New VRTN__c();
            cs.Name = 'Project';
            cs.NAEUProjs__c = 'Project';

            csList.add(cs);

            upsert csList;

            List<MPM4_BASE__Milestone1_Project__c> testProjs = new List<MPM4_BASE__Milestone1_Project__c>();

            List<RecordType> rtId = new List<RecordType> ([SELECT Id FROM RecordType
                                                           	WHERE SObjectType = 'MPM4_BASE__Milestone1_Project__c' AND RecordType.Name = 'Project'
                                                           	LIMIT 1]);

            for (Integer i = 0; i < 25; i++) {

                MPM4_BASE__Milestone1_Project__c p = new MPM4_BASE__Milestone1_Project__c();
                p.Name = 'Test Project ' + i;
                p.MPM4_BASE__Deadline__c = date.today().addDays(3);
                p.Stage__c = 'Stage 1 – Requirements';
                p.RecordTypeId = rtId[0].Id;

                testProjs.add(p);
            }
            insert testProjs;
        }
    }
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    static testmethod void test() {

      Test.startTest();

        String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP,
                        new WE_ScheduledDeadlineUpdate());

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                            FROM CronTrigger WHERE id = :jobId];

        System.assertEquals(CRON_EXP, ct.CronExpression);

        System.assertEquals(0, ct.TimesTriggered);

        System.assertEquals('2022-03-15 00:00:00',
         String.valueOf(ct.NextFireTime));

        Test.stopTest();

        List <MPM4_BASE__Milestone1_Project__c> projects = [SELECT Id, MPM4_BASE__Deadline__c FROM MPM4_BASE__Milestone1_Project__c WHERE Name LIKE '%Test Project%'];

        for(MPM4_BASE__Milestone1_Project__c p : projects){
            system.assertEquals(date.today().addDays(21), p.MPM4_BASE__Deadline__c);
        }
    }
}