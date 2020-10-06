/**
 * Created by mbickford on 10/11/2018.
 */

@IsTest
private class EmailMessageTriggerTest {

    private static final String caseWithSurveySummary = 'EmailMessageTriggerTest Test Case';
    private static final String caseWithoutSurveySummary = 'EmailMessageTriggerTest Test Case Without Survey';

    @TestSetup
    static void testSetup() {

        UtilityTestLoader.setAutomation(false);
    
        RecordType caseRecordType = [SELECT Id FROM RecordType WHERE (SobjectType = 'Case' AND RecordType.DeveloperName = 'Service_Operations')];
        RecordType acctRecordType = [SELECT Id FROM RecordType WHERE (SobjectType = 'Account' AND RecordType.DeveloperName = 'Service_Operations')];
        RecordType contactRecordType = [SELECT Id FROM RecordType WHERE (SobjectType = 'Contact' AND RecordType.DeveloperName = 'Service_Operations')];
        
        insert new ServiceOperationsSurveySettings__c (Survey_Text__c='>>>> Your satisfaction is important to us. We would appreciate it if you could take the time to complete a short survey.',Survey_Text_Plaintext_Extension__c=' Please share your feedback by clicking the following link: ');
        
        Program__c wexProgram = new Program__c();
            wexProgram.Name = 'Test WEX Program';
            wexProgram.Send_CS_Satisfaction_Surveys__c = true;

            insert wexProgram;

        System.debug('wexProgram ID: '+wexProgram.Id);


        Account wexAccount = new Account();
        wexAccount.RecordType = acctRecordType;
        wexAccount.Wex_Account__c = '9100000000000';
        wexAccount.Acct_Row_Id__c = '12-AAAA-345';
        wexAccount.Name = 'Test Wex Account';
        wexAccount.Status__c = 'Active';
        wexAccount.Program__c = wexProgram.Id;


        insert wexAccount;

        System.debug('wexAccount ID: '+wexAccount.Id);

        Contact contact = new Contact();
        contact.RecordType = contactRecordType;
        contact.FirstName = 'Mark';
        contact.LastName = 'Bickford';
        contact.Email = 'mark.bickford@wexinc.com';
        contact.Account = wexAccount;
        contact.Status__c = 'Active';

        insert contact;

        System.debug('contact ID: '+contact.Id);

        Case caseWithSurvey;

        caseWithSurvey = new Case();
        caseWithSurvey.RecordTypeId = caseRecordType.Id;
        caseWithSurvey.AccountId = wexAccount.Id;
        caseWithSurvey.Subject = caseWithSurveySummary;
        caseWithSurvey.ContactId = contact.Id;
        caseWithSurvey.Service_Program_Survey_Sent__c = false;

        insert caseWithSurvey;

        System.debug('caseWithSurvey ID: '+caseWithSurvey.Id);
        System.debug('caseRecordType ID: '+caseRecordType.Id);

        Case caseWithoutSurvey;

        caseWithoutSurvey = new Case();
        caseWithoutSurvey.RecordTypeId = caseRecordType.Id;
        caseWithoutSurvey.AccountId = wexAccount.Id;
        caseWithoutSurvey.Subject = caseWithoutSurveySummary;
        caseWithoutSurvey.ContactId = contact.Id;
        caseWithoutSurvey.Service_Program_Survey_Sent__c = false;

        insert caseWithoutSurvey;

        System.debug('caseWithoutSurvey ID: '+caseWithoutSurvey.Id);
        System.debug('caseRecordType ID: '+caseRecordType.Id);
        
    }

    @IsTest
    static void testBehavior() {
        insert new EmailMessageSettings__c(ActivateEmailMessageInsertTrigger__c = true);
        EmailMessage message = new EmailMessage();

        Case caseWithSurvey = [SELECT Id, RecordTypeId, AccountId , Subject, ContactId, Service_Program_Survey_Sent__c, Service_Survey_Transactional_link__c, SurveyInclusionText__c, SurveyInclusionHTML__c FROM Case WHERE Subject = :caseWithSurveySummary];

        Contact caseContact =[SELECT Id, Email FROM Contact WHERE Id = :caseWithSurvey.ContactId];
        
        EmailMessageSettings__c EMS = EmailMessageSettings__c.getOrgDefaults();
        
        if(EMS.ActivateEmailMessageInsertTrigger__c == false) {
        	System.debug('ActivateEmailMessageInsertTrigger__c = false');
        } else {
			System.debug('ActivateEmailMessageInsertTrigger__c = true');            
        }

        System.debug('Case ID = '+caseWithSurvey.Id);
        System.debug('CaseRecordType ID = '+caseWithSurvey.RecordTypeId);
        System.debug('Case survey link='+caseWithSurvey.Service_Survey_Transactional_link__c);
        System.debug('Case inclusion HTML='+caseWithSurvey.SurveyInclusionHTML__c);

        System.assert(caseWithSurvey.SurveyInclusionText__c != null, 'Null survey inclusion text');

        message.FromAddress = 'mark_bickford@wrightexpress.com';
        message.ParentId = caseWithSurvey.Id;
        message.Subject = 'Test message';
        message.ToAddress = caseContact.Email;
        message.HtmlBody = 'This is a test message.<br/><br/>'+caseWithSurvey.SurveyInclusionHTML__c;
        message.TextBody = 'This is a test message.\n\n'+caseWithSurvey.SurveyInclusionText__c;
        message.Status = '3';

        insert message;

        List<Case> results = [SELECT Id, Service_Program_Survey_Sent__c FROM Case WHERE Id= :caseWithSurvey.Id];

        Case resultCase = results[0];

        System.debug('Survey was marked as sent: '+resultCase.Service_Program_Survey_Sent__c);

        System.assert(resultCase.Service_Program_Survey_Sent__c == true, 'Survey was not marked as sent');

    }

    @IsTest
    static void testNoTriggerBehavior() {

        insert new EmailMessageSettings__c(ActivateEmailMessageInsertTrigger__c = false);

        EmailMessage message = new EmailMessage();

        Case caseWithoutSurvey = [SELECT Id, RecordTypeId, AccountId , Subject, ContactId, Service_Program_Survey_Sent__c, Service_Survey_Transactional_link__c, SurveyInclusionText__c, SurveyInclusionHTML__c FROM Case WHERE Subject = :caseWithoutSurveySummary];

        Contact caseContact =[SELECT Id, Email FROM Contact WHERE Id = :caseWithoutSurvey.ContactId];

        EmailMessageSettings__c EMS = EmailMessageSettings__c.getOrgDefaults();

        if(EMS.ActivateEmailMessageInsertTrigger__c == false) {
            System.debug('ActivateEmailMessageInsertTrigger__c = false');
        } else {
            System.debug('ActivateEmailMessageInsertTrigger__c = true');
        }

        System.debug('Case ID = '+ caseWithoutSurvey.Id);
        System.debug('CaseRecordType ID = '+ caseWithoutSurvey.RecordTypeId);
        System.debug('Case survey link='+ caseWithoutSurvey.Service_Survey_Transactional_link__c);
        System.debug('Case inclusion HTML='+ caseWithoutSurvey.SurveyInclusionHTML__c);

        System.assert(caseWithoutSurvey.SurveyInclusionText__c != null, 'Null survey inclusion text');

        message.FromAddress = 'mark_bickford@wrightexpress.com';
        message.ParentId = caseWithoutSurvey.Id;
        message.Subject = 'Test message';
        message.ToAddress = caseContact.Email;
        message.HtmlBody = 'This is a test message.<br/><br/>'+ caseWithoutSurvey.SurveyInclusionHTML__c;
        message.TextBody = 'This is a test message.\n\n'+ caseWithoutSurvey.SurveyInclusionText__c;
        message.Status = '3';

        insert message;

        List<Case> results = [SELECT Id, Service_Program_Survey_Sent__c FROM Case WHERE Id= :caseWithoutSurvey.Id];

        Case resultCase = results[0];

        System.debug('Survey was marked as sent: '+resultCase.Service_Program_Survey_Sent__c);

        System.assert(resultCase.Service_Program_Survey_Sent__c == false, 'Survey was marked as sent');

    }
}