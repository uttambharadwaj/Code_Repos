@istest
private class LiveAgentPreChatControllerTest {
    static testmethod void testController() {

        Id pilotRectypeId;
        List<RecordType> ctRectypes = [SELECT Id FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName = 'Service_Operations' LIMIT 1];
        if (!ctRectypes.isEmpty()) {
            pilotRectypeId = ctRectypes[0].Id;
        }

        Support_Operation_Settings__c settings = new Support_Operation_Settings__c(SetupOwnerId = UserInfo.getOrganizationId(), PilotContactRecordTypeID__c = String.valueOf(pilotRectypeId).substring(0, 15));
        insert settings;

        Account acc = new Account(
            Name = 'testAcc',
            Wex_Account__c = 'test123'
        );
        insert acc;
        
        Contact con = new Contact(
            AccountId = acc.Id,
            FirstName = 'testFirstName',
            LastName = 'testLastName',
            Email = 'testuser@test.com',
            RecordTypeId = pilotRectypeId
        );
        insert con;

        Test.startTest();
        LiveAgentPreChatController ctl = new LiveAgentPreChatController();
        Contact ctFound = LiveAgentPreChatController.lookupContact('testFirstName','testLastName','testuser@test.com');
        Account acctFound = LiveAgentPreChatController.lookupAccount('test123');
        Test.stopTest();

        System.assert(ctFound!=null);
        System.assert(acctFound!=null);
    }
}