/*
Description:        Test class for InvocableSendEmailTemplate
Revision History:   3/29/2019 Jason Arbegast IADJUDICAT-746 create test class
*/
@isTest
public class InvocableSendEmailTemplateTest {

    @testSetup
    static void setup(){

        UtilityTestLoader.setAutomation(false);

        Account acc = new Account(Name='Entirely Vindictive Industries, LLC', TickerSymbol='EVIL');
        insert acc;

        Contact con = new Contact(LastName='Commander', FirstName='Cobra', AccountId=acc.Id);
        insert con;

        //for this test, attachment name will be matched with account tickersymbol
        Attachment att = new Attachment(Name='EVIL', ParentId=acc.Id);
        Blob blobby = Blob.valueOf('Cat General Says War On String May Be Unwinnable');
        att.body = blobby;
        insert att;

        //need to run as different user to avoid mixed dml error with email template. curses!
        User adminUser = [SELECT Id FROM User WHERE Profile.Name='System Administrator' AND isActive=true LIMIT 1];
        System.runAs(adminUser){
            EmailTemplate template = new EmailTemplate(Name='BasicEmailTemplate', IsActive=true, TemplateType='text');
            template.DeveloperName = 'BasicEmailTemplate';
            template.FolderId = UserInfo.getUserId();
            insert template;
        }

    }

    static testMethod void testSendEmailTemplate() {

        Integer initialEmailCount = Limits.getEmailInvocations();

        Contact myContact = [SELECT Id, AccountId FROM Contact WHERE LastName='Commander' LIMIT 1];
        EmailTemplate myTemplate = [SELECT Id FROM EmailTemplate WHERE Name='BasicEmailTemplate' LIMIT 1];

        InvocableSendEmailTemplate.EmailWrapper eminem= new InvocableSendEmailTemplate.EmailWrapper();
        eminem.templateId = myTemplate.Id;
        eminem.toRecipients = UserInfo.getUserEmail();
        eminem.ccRecipients = UserInfo.getUserEmail();
        eminem.whatId = myContact.AccountId;
        eminem.targetObjId = myContact.Id;
        eminem.saveAsActivity = false;
        eminem.attachmentParentId = myContact.AccountId;
        eminem.attachmentParentField = 'TickerSymbol';

        Test.startTest();
        InvocableSendEmailTemplate.sendEmailTemplate(new List<InvocableSendEmailTemplate.EmailWrapper>{eminem});
        Integer postEmailCount = Limits.getEmailInvocations();
        Test.stopTest();

        //verify an email was sent as expected
        system.assertEquals(1, postEmailCount - initialEmailCount);

    }

    static testMethod void testGetAttachmentMap() {

        EmailTemplate myTemplate = [SELECT Id FROM EmailTemplate WHERE Name='BasicEmailTemplate' LIMIT 1];
        Attachment myAttache = [SELECT Id, ParentId FROM Attachment WHERE Name='EVIL' LIMIT 1];
        Account myAccount = [SELECT Id FROM Account WHERE TickerSymbol = 'EVIL' LIMIT 1];
        Contact myContact = [SELECT Id, AccountId FROM Contact WHERE LastName='Commander' LIMIT 1];

        InvocableSendEmailTemplate.EmailWrapper eminem= new InvocableSendEmailTemplate.EmailWrapper();
        eminem.attachmentParentId = myAccount.Id;
        eminem.attachmentParentField = 'TickerSymbol';
        eminem.attachmentName = 'EVIL';
        eminem.templateId = myTemplate.Id;
        eminem.toRecipients = UserInfo.getUserEmail();
        eminem.whatId = myContact.AccountId;
        eminem.targetObjId = myContact.Id;
        eminem.saveAsActivity = false;

        Test.startTest();
        Map<Id,String> myAttachmentMap = InvocableSendEmailTemplate.getAttachmentMap(new List<InvocableSendEmailTemplate.EmailWrapper>{eminem});
        Test.stopTest();

        //myAttachmentMap should make a map of parentId (in this case, account id) to attachment id
        system.assertEquals(myAttache.Id, myAttachmentMap.get(myAccount.Id));

    }

}