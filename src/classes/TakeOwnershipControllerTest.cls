@istest
private class TakeOwnershipControllerTest {
    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testmethod void testController() {
        Profile prof = [SELECT id FROM Profile WHERE name = 'Standard User' LIMIT 1];


        User u1 = new User(Alias = 'tstusr', Email = 'testuser1@test.com',
                           EmailEncodingKey = 'UTF-8', LastName = 'tstLastName', LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US', ProfileId = prof.Id,
                           TimeZoneSidKey = 'America/Los_Angeles', UserName = Math.random() + '@' + Math.random());
        insert u1;

        Case c;
        System.runAs(u1) {
            c = new Case(Subject = 'test', Status = 'New', Description = 'test desc');
            insert c;
        }

        Test.startTest();
        Boolean valid = TakeOwnershipController.changeOwnerServ(c.Id);
        Test.stopTest();

        c = [SELECT OwnerId FROM Case WHERE Id = : c.Id];

        System.assertEquals(true, valid);
        System.assertEquals(UserInfo.getUserId(), c.OwnerId);
    }
}