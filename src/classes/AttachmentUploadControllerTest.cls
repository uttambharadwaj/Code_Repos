@isTest
public class AttachmentUploadControllerTest {

    public static void testGoodUpload(){

        Program__c myProgram = [SELECT Id,Name FROM Program__c LIMIT 1];
        Id myID = myProgram.Id;
        String myName = myProgram.Name;
        Integer initialCount = [SELECT count() FROM Attachment WHERE ParentId = :myID];
        
        //set up the page
        PageReference auPage = Page.AttachmentUpload;
        auPage.getParameters().put('parentRecordId',myID);
        Test.setCurrentPage(auPage);

        //create the controller
        AttachmentUploadController auc = new AttachmentUploadController();
        
        //the items that will be created/referenced by controller methods
        PageReference mySuccess;
        
        Test.startTest();

        auc.init(); 
        auc.attachmentName = 'AttachThis';
        auc.attachmentBody = Blob.valueOf('Blob of Blobolonia');
        mySuccess = auc.uploadFile();

        Test.setCurrentPage(mySuccess);
        auc.init();

        Test.stopTest();

        Integer finalCount = [SELECT count() FROM Attachment WHERE ParentId = :myID];
        List<ApexPages.Message> msgList = ApexPages.getMessages();

        system.assertEquals(initialCount+1,finalCount,'It did not attach the expected number of attachments');
        system.assertEquals('Program',auc.parentRecordType,'Hmmm it found the wrong label');
        system.assertEquals('true',auc.confirmUpload,'It did not set the parameter as expected');
        system.assertEquals(myName,auc.recordName,'It did not set the name as expected');
        system.assert(auc.hasError,'It did not provide a message');
        system.assertEquals(1,msgList.size(),'It has the wrong number of messages');
        system.assertEquals(ApexPages.Severity.CONFIRM,msgList[0].getSeverity(),'It has the wrong severity level');
        system.assertEquals('Attachment Uploaded!',msgList[0].getSummary(),'It has the wrong message');
    }

    public static void testFailUpload(){
        
        //set up the page
        PageReference auPage = Page.AttachmentUpload;
        Test.setCurrentPage(auPage);

        //create the controller
        AttachmentUploadController auc = new AttachmentUploadController();
        
        //the items that will be created/referenced by controller methods
        PageReference myFailure;
        
        Test.startTest();

        auc.init();
        auc.attachmentName = 'AttachThis';
        auc.attachmentBody = Blob.valueOf('Blob of Blobolonia');
        myFailure = auc.uploadFile(); //should fail bc we don't have a parent record id

        Test.setCurrentPage(myFailure);
        auc.init();

        Test.stopTest();
        
        List<ApexPages.Message> msgList = ApexPages.getMessages();
        system.debug(msgList);
        String s = myFailure.getParameters().get('errorCode');
        List<Internal_Application_Error__c> myErrors = [SELECT Id,Error_Message__c FROM Internal_Application_Error__c WHERE Name = :s];
        Integer i = myErrors.size();
        String myMessage = myErrors[0].Error_Message__c;
        String allMessages = '';
        for(ApexPages.Message am : msgList)
            allMessages += am.getSummary();

        system.assertEquals('false',auc.confirmUpload,'It did not error');
        system.assert(auc.hasError,'It did not provide a message');
        system.assertEquals(2,msgList.size(),'It has the wrong number of messages');
        system.assertEquals(ApexPages.Severity.ERROR,msgList[0].getSeverity(),'It has the wrong severity level');
        system.assert(allMessages.contains(myMessage),'It has the wrong message');
        system.assertEquals(1,i,'It created the wrong number of errors');
    }

    public static void testNoUpload(){
        
        //set up the page
        PageReference auPage = Page.AttachmentUpload;
        Test.setCurrentPage(auPage);

        //create the controller
        AttachmentUploadController auc = new AttachmentUploadController();
        
        //the items that will be created/referenced by controller methods
        PageReference myNonPage;
        
        Test.startTest();

        auc.init();
        
        myNonPage = auc.uploadFile(); //should return null bc we don't have any values in the controller
        
        Test.stopTest();
        
        system.assertEquals(null,myNonPage,'Somehow it made a page');
        system.assert(!auc.hasError,'It has an error');
        system.assertEquals(null,auc.recordName,'It found a record name');
        system.assertEquals(null,auc.parentRecordType,'It found a record type');
    }

}