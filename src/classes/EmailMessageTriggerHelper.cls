/**
 * Created by mbickford on 10/11/2018.
 */

public with sharing class EmailMessageTriggerHelper {

    private static final String Sent = '3';

    public static void updateSurveySentField(List<EmailMessage> messages, Map<Id, EmailMessage> oldMap) {

        RecordType caseRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Case' AND RecordType.DeveloperName = 'Service_Operations'];

        List<Case> caseList = new List<Case>();
        Set<Id> caseIds = new Set<Id>();

        for (EmailMessage message : messages) {
            //EmailMessage oldMessage = oldMap.get(message.Id);

            if (message.Incoming == false && (message.Status.equals(Sent)) && message.ParentId != null) {
                caseIds.add(message.ParentId);
            }
        }

        Map<Id, Case> cases = new Map<Id, Case>([SELECT Id, RecordTypeId, Service_Survey_Transactional_link__c, Service_Program_Survey_Sent__c FROM Case WHERE Id IN :caseIds]);

        for (EmailMessage message : messages) {
            if (cases.containsKey(message.ParentId)) {
                Case parentCase = cases.get(message.ParentId);
                if (parentCase != null) {
                    if (parentCase.RecordTypeId == caseRecordType.Id && parentCase.Service_Program_Survey_Sent__c == false) {
                        String surveyLink = parentCase.Service_Survey_Transactional_link__c.escapeHtml4();
                        if (message.HtmlBody.contains(surveyLink)) {
                            parentCase.Service_Program_Survey_Sent__c = true;
                            caseList.add(parentCase);
                        }
                    }
                }
            }

        }
        if (caseList.size() > 0)  {
            System.debug('EmailMessageTriggerHelper: Updating case count: '+caseList.size());
            update caseList;
        }
    }
}