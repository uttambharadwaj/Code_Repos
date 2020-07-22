@IsTest
private class UEmailMessageTest {

	@TestSetup
	private static void setupData(){
	    UtilityTestLoader.setAutomation(false);
    
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

    @isTest
    private static void testDeleteCollectionsEmail() {
        Case collectionsCase = new Case();
        collectionsCase.Type = 'Collections';
        insert collectionsCase;

        EmailMessage tmpEmailMessage = new EmailMessage();
        tmpEmailMessage.Subject = 'Collections email';
        tmpEmailMessage.TextBody = 'Test';
        tmpEmailMessage.ParentId = collectionsCase.Id;
        insert tmpEmailMessage;

        EmailMessage em = [Select id FROM EmailMessage where id = :tmpEmailMessage.id];
        system.assert(String.isNotEmpty(em.Id));

        Test.startTest();
        String error;
        try {
            delete em;
        }catch(System.DmlException ex){
            error = ex.getMessage();
        }

        Test.stopTest();

        system.assert(error.Contains('Unable to delete Email for Collections Cases'));

    }
    @isTest
    private static void testDeleteNonCollectionsEmail() {
        Case nullCaseType = new Case();
        nullCaseType.Type = null;
        insert nullCaseType;

        EmailMessage tmpEmailMessage = new EmailMessage();
        tmpEmailMessage.Subject = 'Test email';
        tmpEmailMessage.TextBody = 'Test';
        tmpEmailMessage.ParentId = nullCaseType.Id;
        insert tmpEmailMessage;

        EmailMessage em = [Select id FROM EmailMessage where id = :tmpEmailMessage.id];
        system.assert(String.isNotEmpty(em.Id));

        Test.startTest();
        delete em;
        Test.stopTest();

    }
}