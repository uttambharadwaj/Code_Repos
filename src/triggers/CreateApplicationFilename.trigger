trigger CreateApplicationFilename on ENZ__FTPAttachment__c (after insert, after update) {
    for (ENZ__FTPAttachment__c attach : Trigger.new) {
        String opportunityId = attach.ENZ__Opportunity__c;// ENZ__FTPAttachment__c.ENZ__Opportunity__c.get;
        if (opportunityId != null) {
            Opportunity opportunity = [select Id, Application_Filename__c from Opportunity where Id = :opportunityId];
            Integer version = attach.ENZ__LastVersionID__c.intValue();
            opportunity.Application_Filename__c = attach.Id + '~' + version + '~' + attach.name;
            update opportunity;
        }
    } 
}