@isTest
public class AutoCaseStatusControllerTest {
	static testmethod void testControllerStatusClosed()
	{
		Case c = new Case(Subject = 'test', Status = 'Unread', Description = 'test desc', Previously_Closed__c = true);
		insert c;

		Test.startTest();
		Boolean response = AutoCaseStatusController.checkCaseStatusServ(c.Id);
		Test.stopTest();

		c = [SELECT Status FROM Case WHERE Id = :c.Id];
		System.assertEquals(true, response);
		System.assertEquals('Closed', c.Status);
	}

	static testmethod void testControllerStatusOpen()
	{
		Case c = new Case(Subject = 'test', Status = 'Unread', Description = 'test desc', Previously_Closed__c = false);
		insert c;

		Test.startTest();
		Boolean response = AutoCaseStatusController.checkCaseStatusServ(c.Id);
		Test.stopTest();

		c = [SELECT Status FROM Case WHERE Id = :c.Id];
		System.assertEquals(true, response);
		System.assertEquals('Working', c.Status);
	}
}