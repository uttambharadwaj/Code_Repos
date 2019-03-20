public class BOCATaskTriggerHandler {
    
    public BOCATaskTriggerHandler() {
        
    }
    
    public void sendSolicitedTask(Application_Request__c[] applicationRequests) {
        
        try {
            
            User sinte = [SELECT Id FROM User WHERE Alias = 'sinte'];
            
            User taskOwner = [SELECT Id FROM User WHERE Alias = 'dcred'];
            
            // Itterate over the trigger map
            for (Application_Request__c applicationRequest : applicationRequests) {
                
                System.debug('### DEBUG - Got Application Request: ' + applicationRequest.Id);
                
                System.debug('### DEBUG: ' + applicationRequest.Opportunity__r.OwnerId + ', ' + sinte.Id);
                
                if(applicationRequest.Sales_Person__c != sinte.Id && applicationRequest.Solicited_Activity_Sent__c == false && !String.isEmpty(applicationRequest.Siebel_Oppty__c)) {
                    
                    System.debug('### DEBUG - Application Request (' + applicationRequest.Id + ') has a solicited coupon code: ' + applicationRequest.Coupon_Code__c);
                    
                    Task creditTask = new Task();
                    
                    creditTask.RecordTypeId = [SELECT Id, SobjectType, Name FROM RecordType WHERE Name = 'General' and SobjectType = 'Task' LIMIT 1].Id;
                    creditTask.Subject = 'Solicited Application';
                    creditTask.WhatId = applicationRequest.Opportunity__c;
                    creditTask.Description = 'Solicited Application';
                    creditTask.Status = 'In Progress';
                    creditTask.Priority = '3-Medium';
                    creditTask.Activity_Type__c = 'Solicited';
                    creditTask.Type = 'Solicited';
                    creditTask.ActivityDate = Date.today();
                    creditTask.OwnerId = taskOwner.Id;
                    
                    insert creditTask;
                    
                    System.debug('### DEBUG - Application Request (' + applicationRequest.Id + ') has created a new solicited activity:' + creditTask.Id);
                    
                    applicationRequest.Solicited_Activity_Sent__c = true;
                    
                    System.debug('### DEBUG - Application Request (' + applicationRequest.Id + ') has sent a solicited activity:' + applicationRequest.Solicited_Activity_Sent__c);
                    
                }
                
            }
            
        } catch (Exception e) {
            
            System.debug('An error occured creating the task.. Failing gracefully..');
            
        }
        
    }

}