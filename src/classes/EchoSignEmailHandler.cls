/**
* Forseva online application code.
*/
global class EchoSignEmailHandler implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {

        String debuggingEmailBody = email.subject + ' --> ' + email.toAddresses + ' --> ';
        List<String> toAddresses = email.toAddresses;
        List<String> fixedAddresses = new List<String>();

        try {

            for(String addr : toAddresses) {
            	if(addr.contains('<')) {
                    fixedAddresses.add(addr.substring(addr.indexOf('<')+1,addr.indexOf('>')));
            	}
            	else {
            	    fixedAddresses.add(addr);
            	} 
            }
        
            List<Messaging.InboundEmail.BinaryAttachment> attachments = email.binaryAttachments;
            debuggingEmailBody += 'Number of attachments: ' + attachments.size() + ' --> ';

            List<OnlineApplication__c> oaList = [select    Id, Account__c, Name, AO_Name__c, AO_Work_Email__c, Email__c, eSignature_Status__c 
                                                 from      OnlineApplication__c 
                                                 where     AO_Work_Email__c in :fixedAddresses
                                                 //and       eSignature_Status__c = :OnlineApplication.EXECUTED
                                                 order by  LastModifiedDate DESC limit 1];

            debuggingEmailBody += 'Number of matching applications: ' + oaList.size() + ' --> ';

            if(oaList.size() > 0 && attachments != null) {
            	
                for(Messaging.InboundEmail.BinaryAttachment att : attachments) {

                    OnlineApplication__c oa = oaList[0];
                
                    // example EchoSign email subject line:
                    // "The Test UAT Local Offer (between Marla Moop and forseva) is Signed and Filed!"
                
                    String compareString = ('between ' + oa.AO_Name__c + ' and').toLowerCase();
                    if(email.subject != null && email.subject.toLowerCase().contains(compareString)) {
                        oa.eSignature_Status__c = OnlineApplication.EXECUTED_AND_RECEIVED;
                        if(oa.Account__c != null) {
                            List<Contact> cList = [select Id, FirstName, LastName, Last_Valid_Authorized_Signer__c 
                                                   from   Contact 
                                                   where  AccountId = :oa.Account__c];
                            for(Contact c : cList) {
                                if(oa.AO_Name__c.startsWith(c.FirstName + ' ') && oa.AO_Name__c.endsWith(' ' + c.LastName)) {
                                    c.Last_Valid_Authorized_Signer__c = true;
                                }
                                else {
                                    c.Last_Valid_Authorized_Signer__c = false;
                                }
                            }
                            if(cList.size() > 0) {
                                update cList;
                            }
                        }
                    }
                    else {
                        oa.eSignature_Status__c = OnlineApplication.EXECUTED_AND_INVALID_SIGNER;
                    }

                    debuggingEmailBody += 'Attempt to insert Attachment --> ';

                    if(att.fileName.contains('.pdf')) {
                        Attachment a = new Attachment();
                        a.Body = att.Body;
                        a.Name = att.fileName;
                        a.ParentId = oaList[0].Id;
                        insert a;
                        debuggingEmailBody += 'Attachment Inserted Successfully --> ';
                    }
                
                    update oa;
                }
            }
        }
        catch(Exception e) {
            debuggingEmailBody += 'Exception: ' + e.getMessage() + ':' + e.getLineNumber() + ' --> ';
        }

        try {
            // TEST EMAIL FOR DEBUGGING             
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] booAddresses = new String[] {'dcraigmile@forseva.com'};
            mail.setToAddresses(booAddresses);
            mail.setReplyTo('noreply@fleetone.com');
            mail.setSenderDisplayName('EMAIL SERVICE');
            mail.setSubject('EMAIL SERVICE - ' + email.subject);
            mail.setPlainTextBody(debuggingEmailBody);
            //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        catch(Exception e) {}

        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        return result;
    }
    
}
 
// EOF