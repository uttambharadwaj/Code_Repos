@istest
public class QuickLinksControllerTest {
    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }
    static testmethod void testController()
    {
        Account acc = new Account(Name = 'newAcc1', Platform__c = 'SIEBEL');
        insert acc;

        Case c = new Case(Subject = 'test', Status = 'New', AccountId = acc.Id);
        insert c;

        Test.startTest();
        List<QuickLinksController.QuickLinkWrapper> links = QuickLinksController.getQuickLinksServ(c.Id);
        Test.stopTest();

        System.assert(links.size() > 0);
    }
}