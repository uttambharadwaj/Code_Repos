@isTest
private class LiveAgentPostChatFormControllerTest {
    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testmethod void testController() {
        Contact ct = new Contact();
        ct.LastName = 'test';
        insert ct;
        Case c = new Case();
        c.Subject = 'test';
        c.ContactId = ct.Id;
        insert c;

        Test.startTest();
        PageReference pageRef = Page.LiveAgentPostChatForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('attachedRecords', '{"CaseId":"' + c.Id + '"}');
        ApexPages.currentPage().getParameters().put('startTime', 'test');
        LiveAgentPostChatFormController ctl = new LiveAgentPostChatFormController();
        ctl.updateCase();
        Test.stopTest();

        c = [SELECT Service_Program_Survey_Sent__c FROM Case WHERE Id = :c.Id];

        System.assertEquals(c.Id, ctl.CaseId);
        System.assertEquals(ct.Id, ctl.ContactId);
        System.assertEquals(true, c.Service_Program_Survey_Sent__c);
    }
}