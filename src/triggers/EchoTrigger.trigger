trigger EchoTrigger on Opportunity (before update, after update) {

   /* if(trigger.isBefore){
        
        for (Opportunity opty : Trigger.new){
                    
                    if(opty.SourceSystem__c == 'Echosign'){
                       //Create a contact
                       Contact con1 = new Contact();
                       con1.AccountId = opty.AccountId;
                       
                        con1.FirstName = opty.es_Billing_Contact_First_Name__c;
                        con1.LastName = opty.es_Billing_Contact_Last_Name__c;
                        con1.Email = opty.es_Billing_Contact_Email__c;
                        con1.Phone = opty.es_Billing_Contact_Phone__c;
                       
                       
                       //con1.Fax = opty.es_Billing_Contact_Fax__c;
                       //con1.MailingStreet = opty.es_Billing_Street__c;
                       //con1.MailingCity = opty.es_Billing_City__c;
                       //con1.MailingState = opty.es_Billing_State__c;
                       //con1.MailingPostalCode = opty.es_Billing_Zip_Postal_Code__c; 
                       
                       insert con1;
                       opty.Billing_Contact__c = con1.Id;
                    //}  
                    //if(opty.SourceSystem__c == 'Echosign'){
                       //Create a contact
                       Contact con2 = new Contact();
                       con2.AccountId = opty.AccountId;
                       con2.FirstName = opty.Application_Signer_First_Name__c;
                       con2.LastName = opty.Application_Signer_Last_Name__c;
                       con2.Email = opty.Application_Signer_Email_Address__c;
                        
                        con2.MailingStreet = opty.Application_Signer_Address__c;
                        con2.MailingCity = opty.Application_Signer_City__c;
                        con2.MailingState = opty.Application_Signer_State__c;
                        con2.MailingPostalCode = opty.Application_Signer_Zip_Code__c;
                        
                       con2.Phone = opty.Application_Signer_Phone__c;
                       con2.SSN__c = opty.Application_Signer_SSN__c;
                       con2.Birthdate = opty.Application_Signer_DOB__c;
                       insert con2;
                       
                       opty.Application_Signer__c = con2.Id;
                       
                    }
                    
         
        }
    } 
    
    

    if(trigger.isAfter){
        if (!EchoHelper.hasAlreadyCreatedFollowUpTasks()) {        
        
            List<Application_Request__c> appRequest = new List<Application_Request__c>();            
            for (Opportunity opty : Trigger.new)
            {
                          
                if(opty.SourceSystem__c == 'Echosign'){
                    Application_Request__c arq = new Application_Request__c();       
                    arq.Account_Name__c = opty.AccountId;
                    arq.Opportunity__c = opty.Id;
                                       
                    Opportunity opp = [SELECT Id, Billing_Contact__c, Billing_Contact__r.Id, Application_Signer__c, Application_Signer__r.Id FROM Opportunity WHERE Id = :opty.Id];
                                        
                    arq.Billing_Contact__c = opp.Billing_Contact__r.Id;
                    arq.App_Signer__c = opp.Application_Signer__r.Id;
                    
                    appRequest.add(arq); 
                }
            }
            try {
                 EchoHelper.setAlreadyCreatedFollowUpTasks();
                 insert appRequest;
            }
            catch(Exception ex){
                 System.debug('ERROR ADDING THE APP REQUEST: ' + ex.getStackTraceString() );
            }
        }

    } */
}