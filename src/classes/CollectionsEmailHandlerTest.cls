/**
 * Created by jharrell on 6/25/20.
 */
@IsTest
public class CollectionsEmailHandlerTest {

	public static void test_CollectionsEmailSuccess() {

		Collections_Email_Configuration__mdt emailConfig = [ SELECT Id FROM Collections_Email_Configuration__mdt WHERE DeveloperName = 'Test_Class_Config'];

		Case cases = [ SELECT Id,Contact.Email,ContactId,AccountId,Account.Territory_Code__c,Account.National_Account_OTR__c
		FROM Case LIMIT 1 ];

		InvocableSendEmailTemplate.EmailWrapper emailWrapper = new InvocableSendEmailTemplate.EmailWrapper();
		emailWrapper.whatId = cases.Id;
		emailWrapper.attachmentParentId = cases.Id;
		emailWrapper.targetObjId = cases.ContactId;
		emailWrapper.toRecipients = 'nomail@wexinc.com';


		Test.startTest();
		CollectionsEmailHandler.sendEmailTemplate(new List<InvocableSendEmailTemplate.EmailWrapper>{emailWrapper});
		Test.stopTest();

		cases = [ SELECT Id,ContactId,Collections_No_Connect_Tasks__c,Processed_Email_Configs__c FROM Case LIMIT 1 ];
		System.debug(cases.Collections_No_Connect_Tasks__c);

		System.assertEquals(true, cases.Processed_Email_Configs__c.contains(emailConfig.Id));



	}

	public static void test_CollectionsEmailFail() {

		Collections_Email_Configuration__mdt emailConfig = [ SELECT Id FROM Collections_Email_Configuration__mdt WHERE DeveloperName = 'Test_Class_Config'];

		Case cases = [ SELECT Id,ContactId,Collections_No_Connect_Tasks__c,Processed_Email_Configs__c FROM Case LIMIT 1 ];
		cases.Collections_No_Connect_Tasks__c = 1; // make the rules not pass
		update cases;

		InvocableSendEmailTemplate.EmailWrapper emailWrapper = new InvocableSendEmailTemplate.EmailWrapper();
		emailWrapper.whatId = cases.Id;
		emailWrapper.attachmentParentId = cases.Id;
		emailWrapper.targetObjId = cases.ContactId;
		emailWrapper.toRecipients = 'nomail@wexinc.com';


		Test.startTest();
		CollectionsEmailHandler.sendEmailTemplate(new List<InvocableSendEmailTemplate.EmailWrapper>{emailWrapper});
		Test.stopTest();

		cases = [ SELECT Id,ContactId,Collections_No_Connect_Tasks__c,Processed_Email_Configs__c
		FROM Case LIMIT 1 ];

		if (cases.Processed_Email_Configs__c == null) cases.Processed_Email_Configs__c = '';
		System.assertEquals(false, cases.Processed_Email_Configs__c.contains(emailConfig.Id));

	}

	public static void test_CollectionsEmailPreviouslySent() {

		Collections_Email_Configuration__mdt emailConfig = [ SELECT Id FROM Collections_Email_Configuration__mdt WHERE DeveloperName = 'Test_Class_Config'];

		Case cases = [ SELECT Id,ContactId,Collections_No_Connect_Tasks__c,Processed_Email_Configs__c FROM Case LIMIT 1 ];
		cases.Processed_Email_Configs__c = emailConfig.Id;
		update cases;

		Test.startTest();
		List<Id> matchedConfigs = CollectionsEmailHandler.runRuleEval(new List<sObject>{cases}).get(cases.Id);
		Test.stopTest();

		System.assertEquals(false, matchedConfigs.contains(emailConfig.Id));

	}
}