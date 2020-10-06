global class MVFScheduledEmails implements Schedulable {
    
    global void execute(SchedulableContext sc)
    {
        
        CronTrigger ct = [SELECT TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :SC.getTriggerId()];
        SYSTEM.debug(ct);
        
        // Sent within 24 hours of creation
        sendMVF2Emails();
        sendMVFLead2Emails();
            
        // Sent within 7 days of creation
        sendMVF3Emails();
        sendMVFLead3Emails();

    }
    
    public MVFScheduledEmails() {
        
    }
    
    public void sendMVF2Emails()
    {
        
        try {
            
            MVF_Email_Settings__c mvfEmailSettings = MVF_Email_Settings__c.getOrgDefaults();
            
            List<Opportunity> opportunities = [SELECT Id, OwnerId, CreatedDate FROM Opportunity WHERE DAY_ONLY(CreatedDate) = YESTERDAY and Coupon_Code2__c in ('QBW', 'Q7E') and StageName in ('1) Qualified', '2) Engaged', '3) Evaluating', '4) Negotiating', 'Stalled')];
            
            List<Lead> convertedLeads = [SELECT Id, Owner.Name, Owner.Email FROM Lead WHERE ConvertedOpportunityId in :opportunities and HasOptedOutOfEmail = false];
            
            List<Messaging.SingleEmailMessage> lstmail = new List<Messaging.SingleEmailMessage>();
            
            for(Lead convertedLead : convertedLeads) {
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                mail.setTemplateId(mvfEmailSettings.MVF_QBW_Q7E_Personalized_Series_2__c);
                mail.setWhatId(convertedLead.Id);
                mail.setTargetObjectId(convertedLead.Id);
                mail.SetSaveAsActivity(false);         	
                mail.setReplyTo(convertedLead.Owner.Email);
                mail.setSenderDisplayName(convertedLead.Owner.Name);
                
                lstmail.add(mail);
                
            }
            
            if(lstmail.size() > 0 && !Test.isRunningTest()) {
                Messaging.sendEmail(lstmail);
            }
            
        } 
        catch(Exception e) {
            System.debug('Unable to dispatch emails: ' + String.valueOf(e));
        }
    }
    
	public void sendMVFLead2Emails()
    {
        
        try {
            
            MVF_Email_Settings__c mvfEmailSettings = MVF_Email_Settings__c.getOrgDefaults();

            List<Lead> leads = [SELECT Id, Owner.Name, Owner.Email FROM Lead WHERE DAY_ONLY(CreatedDate) = YESTERDAY and Coupon_Code__c = 'WQM' and HasOptedOutOfEmail = false];
            
            List<Messaging.SingleEmailMessage> lstmail = new List<Messaging.SingleEmailMessage>();
            
            for(Lead lead : leads) {
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                mail.setTemplateId(mvfEmailSettings.MVF_WQM_Generic_Series_2__c);
                mail.setWhatId(lead.Id);
                mail.setTargetObjectId(lead.Id);
                mail.SetSaveAsActivity(false);         	
                mail.setReplyTo(lead.Owner.Email);
                mail.setSenderDisplayName(lead.Owner.Name);
                
                lstmail.add(mail);
                
            }
            
            if(lstmail.size() > 0 && !Test.isRunningTest()) {
                Messaging.sendEmail(lstmail);
            }
            
        } 
        catch(Exception e) {
            System.debug('Unable to dispatch emails: ' + String.valueOf(e));
        }
    }
    
    public void sendMVF3Emails()
    {
        try {
            
            MVF_Email_Settings__c mvfEmailSettings = MVF_Email_Settings__c.getOrgDefaults();
            
            Date pastDate = Date.Today()-8;
            
            List<Opportunity> opportunities = [SELECT Id, CreatedDate, OwnerId FROM Opportunity WHERE DAY_ONLY(CreatedDate) = :pastDate and Coupon_Code2__c in ('QBW', 'Q7E') and StageName in ('1) Qualified', '2) Engaged', '3) Evaluating', '4) Negotiating', 'Stalled')];
            
            List<Lead> convertedLeads = [SELECT Id, Owner.Name, Owner.Email FROM Lead WHERE ConvertedOpportunityId in :opportunities and HasOptedOutOfEmail = false];
            
            List<Messaging.SingleEmailMessage> lstmail = new List<Messaging.SingleEmailMessage>();
            
            for(Lead convertedLead : convertedLeads) {
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                mail.setTemplateId(mvfEmailSettings.MVF_QBW_Q7E_Personalized_Series_3__c);
                mail.setWhatId(convertedLead.Id);
                mail.setTargetObjectId(convertedLead.Id);
                mail.SetSaveAsActivity(false);         	
                mail.setReplyTo(convertedLead.Owner.Email);
                mail.setSenderDisplayName(convertedLead.Owner.Name);
                
                lstmail.add(mail);
                
            }
            
            if(lstmail.size() > 0 && !Test.isRunningTest()) {
                Messaging.sendEmail(lstmail);
            }
            
        } 
        catch(Exception e) {
            System.debug('Unable to dispatch emails: ' + String.valueOf(e));
        }
        
    }
    
    public void sendMVFLead3Emails()
    {
        
        try {
            
            MVF_Email_Settings__c mvfEmailSettings = MVF_Email_Settings__c.getOrgDefaults();
            
            Date pastDate = Date.Today()-8;

            List<Lead> leads = [SELECT Id, Owner.Name, Owner.Email FROM Lead WHERE DAY_ONLY(CreatedDate) = :pastDate and Coupon_Code__c = 'WQM' and HasOptedOutOfEmail = false];
            
            List<Messaging.SingleEmailMessage> lstmail = new List<Messaging.SingleEmailMessage>();
            
            for(Lead lead : leads) {
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                mail.setTemplateId(mvfEmailSettings.MVF_WQM_Generic_Series_3__c);
                mail.setWhatId(lead.Id);
                mail.setTargetObjectId(lead.Id);
                mail.SetSaveAsActivity(false);         	
                mail.setReplyTo(lead.Owner.Email);
                mail.setSenderDisplayName(lead.Owner.Name);
                
                lstmail.add(mail);
                
            }
            
            if(lstmail.size() > 0 && !Test.isRunningTest()) {
                Messaging.sendEmail(lstmail);
            }
            
        } 
        catch(Exception e) {
            System.debug('Unable to dispatch emails: ' + String.valueOf(e));
        }
    }
    
}