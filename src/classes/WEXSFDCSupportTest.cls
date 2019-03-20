/**
 * Created by lhowland on 12/12/2018.
 */
@isTest (SeeAllData = true)
public with sharing class WEXSFDCSupportTest {

    public static Account setupAccount() {

        Account account = new Account();
        account.Name ='TestAccount-01';

        insert account;

        return account;
    }

    public static Contact setupContact() {

        Contact contact = new Contact();

        contact.FirstName = 'Tester';
        contact.LastName = 'Tester Last';
        contact.Email = 'Tester@UnitTest.com';

        insert contact;

        return contact;
    }

    static testMethod void WEXSFDCSupportTest() {

        Account account = setupAccount();

        Contact contact = setupContact();

        Test.startTest();

        PageReference wexSDFCSupport = Page.WEXSFDCSupport;

        // TEST NEW CASE

        wexSDFCSupport.getParameters().put('action','newCase');
        Test.setCurrentPage(wexSDFCSupport);

        SFDCSupportWebToCaseController controller = new SFDCSupportWebToCaseController();
        controller.init();

        System.assert(controller.caseIdParameter == null);
        System.assert(controller.caseTypes == null);
        System.assert(controller.departments == null);
        System.assert(controller.natureOfCaseOptions == null);
        System.assert(controller.browser == null);
        System.assert(controller.nextStep != null);
        System.assert(controller.caseAttachmentsSize == 0);
        System.assert(controller.offset != null);
        
        controller.caseRequest.Account = account;
        controller.caseRequest.Contact = contact;

        controller.caseRequest.Department__c = 'Corporate Development';
        controller.caseRequest.Nature_of_Case__c = 'Issue';
        controller.caseRequest.Functional_Area__c = 'Data Issue';
        controller.caseRequest.Subject = 'Ninjas are invading my SF account';
        controller.caseRequest.Description = 'I swear little gnome ninjas are mucking with my data in the night!';
        controller.caseRequest.Error_Message__c = 'Warning: You have stage 4 gnome ninjas in your environment. Precede with server (get it...) caution.';
        controller.caseRequest.Steps_to_Reproduce__c = '1. Log into SF. 2. View gnome ninja data destruction.';
        controller.caseRequest.Browser_Used__c = 'Chrome';
        controller.caseRequest.Number_of_Users_Affected__c = '1';
        controller.caseRequest.Workaround__c = 'No';
        
        controller.previousStep();
        controller.beginningStep();
        controller.nextStep();

        controller.submitCase();

        controller.fileCount = '1';
        PageReference changeFileCount = controller.ChangeCount();
        System.assert(changeFileCount == null);
        Attachment attachment = new Attachment(ParentId = controller.caseRequest.Id, Name = 'TestName', Body = Blob.valueOf('Blob of Strings'));
        insert attachment;

        System.assert(controller.caseRequest.Id != null);
        System.assert(controller.caseRequest.OwnerId != null);
        System.assert(controller.caseRequest.Status.equals('New'));
        System.assert(controller.caseRequest.Priority.equals('Normal'));
        System.assert(controller.caseRequest.Origin.equals('Web'));
        System.assert(controller.caseRequest.SuppliedName != null);
        System.assert(controller.caseRequest.SuppliedEmail != null);
        //System.assert(controller.caseRequest.EntitlementId != null);
        System.assert(!controller.hasError);
        System.assert(controller.previousStep);
        System.assert(controller.isIssue);

        wexSDFCSupport.getParameters().put('action','home');
        Test.setCurrentPage(wexSDFCSupport);

        controller.init();

        // TEST VIEW OPEN CASE

        wexSDFCSupport.getParameters().put('action','viewCase');
        wexSDFCSupport.getParameters().put('caseNumber', controller.caseRequest.Id);
        Test.setCurrentPage(wexSDFCSupport);

        controller.init();

        System.assert(controller.currentCase != null);
        System.assert(controller.sizeOfOpenCases > 0);
        System.assert(controller.sizeOfClosedCases == 0);

        // TEST POST COMMENT

        controller.comment = 'I have a new Sensei who is going to train me in the martial arts in order to defeat the gnome ninjas.';
        PageReference errorPage = controller.postFeed();
        System.assert(errorPage == null);

        // TEST ERROR SECTIONS

        controller.currentCase.Id = null;
        errorPage = controller.postFeed();
        System.assert(errorPage != null);

        wexSDFCSupport.getParameters().put('action','viewCase');
        Test.setCurrentPage(wexSDFCSupport);

        controller.init();

        System.assert(controller.hasError);

        controller.caseRequest = null;
        errorPage = controller.submitCase();
        String errorCode = errorPage.getParameters().get('errorCode');
        System.assert(errorCode != null);

        Test.stopTest();
    }

}