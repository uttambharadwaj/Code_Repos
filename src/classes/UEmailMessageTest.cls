@IsTest
private class UEmailMessageTest {

	@TestSetup
	private static void setupData(){
	      insert new EmailMessageSettings__c(SetupOwnerId = UserInfo.getOrganizationId(), ActivateEmailMessageInsertTrigger__c = true);
	}

    @IsTest
    private static void testSubject() {
        EmailMessage tmpEmailMessage = new EmailMessage();
        tmpEmailMessage.Subject = 'failure notice';
        tmpEmailMessage.TextBody = 'Test';
        tmpEmailMessage.Incoming = true;

        Test.startTest();
        insert tmpEmailMessage;
        Test.stopTest();

        EmailMessage em = [Select id, Discard__c FROM EmailMessage where id = :tmpEmailMessage.id];

        System.assertEquals(true, em.Discard__c);
    }

    @isTest
    private static void testNullSubject() {
        EmailMessage tmpEmailMessage = new EmailMessage();
        tmpEmailMessage.Subject = '';
        tmpEmailMessage.TextBody = 'Test';
        tmpEmailMessage.Incoming = true;

        Test.startTest();
        insert tmpEmailMessage;
        Test.stopTest();

        EmailMessage em = [Select id, Discard__c FROM EmailMessage where id = :tmpEmailMessage.id];

        System.assertEquals(false, em.Discard__c);
    }

    @isTest
    private static void testBody() {
        EmailMessage tmpEmailMessage = new EmailMessage();
        tmpEmailMessage.Subject = 'Test';
        tmpEmailMessage.TextBody = 'undelivered mail returned to sender';
        tmpEmailMessage.Incoming = true;

        Test.startTest();
        insert tmpEmailMessage;
        Test.stopTest();

        EmailMessage em = [Select id, Discard__c FROM EmailMessage where id = :tmpEmailMessage.id];

        System.assertEquals(true, em.Discard__c);
    }

    @isTest
    private static void testHeaders() {
        EmailMessage tmpEmailMessage = new EmailMessage();
        tmpEmailMessage.Subject = 'Test';
        tmpEmailMessage.TextBody = 'Test';
        tmpEmailMessage.Headers = 'mailer-daemon';
        tmpEmailMessage.Incoming = true;

        Test.startTest();
        insert tmpEmailMessage;
        Test.stopTest();

        EmailMessage em = [Select id, Discard__c FROM EmailMessage where id = :tmpEmailMessage.id];

        System.assertEquals(true, em.Discard__c);
    }
}