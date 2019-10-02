trigger CreditAssesmentInsertTrigger on Account ( after update) {
                list<ID> accountids = new list<ID>();
                 Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WES Accounts').getRecordTypeId();
                for(account acct :trigger.new)
                {
                     if(acct.recordtypeid == rtId)
                    {
                        accountids.add(acct.id);
                    }
                }
                //DnB
                //update CreditAssesment picklist fields with the account picklist fields
                //look for most recent credti assesment object
                List<Credit_Assessment__c> recordsToUpdate = [SELECT Id, Account__r.Risk_Grade_UK__c,Risk_Grade_UK__c,Payment_history_validation__c, Account__r.Payment_History_Status__c,
                Risk_Grade_Criteria__c,Account__r.Risk_Grade_Criteria__c
                FROM Credit_Assessment__c 
                WHERE Account__c IN :accountids 
                //ORDER BY Credit_Assessment__c.LastModifiedDate DESC];
                ORDER BY Credit_Assessment__c.CreatedDate DESC];
                
                
                Set<ID> s1 = new Set<ID>();
              
                for (Credit_Assessment__c existingRecord : recordsToUpdate) {
                                
                                if(!s1.contains(existingrecord.account__c))
                                {
                                existingRecord.Risk_Grade_UK__c = existingRecord.account__r.Risk_Grade_UK__c;
                                existingRecord.Payment_history_validation__c = existingRecord.account__r.Payment_History_Status__c;
                                existingRecord.Risk_Grade_Criteria__c = existingRecord.account__r.Risk_Grade_Criteria__c;
                            
                                s1.add(existingrecord.account__c);
                                }
                           
                }

                update recordsToUpdate;
                
                
    
}