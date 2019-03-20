trigger SalesCodeValidation on Sales_Code__c (before update, before insert) {
    
    List<Sales_Code__c> codes =[SELECT ID, Program_Name__c, Name FROM Sales_Code__c where Program__c=: trigger.new[0].Program__c and Name =: trigger.new[0].Name];
    
   
    //This means we're updating an existing sales code
    if (trigger.old != null){
    
        if(codes.size()>1){
           system.debug('DUP ON UPDATE HAS BEEN FOUND');
           Sales_Code__c tempCode = codes[0];
           Trigger.new[0].addError('The Sales Code already exists under that program.');
        }
    
        String newStatus = trigger.new[0].Status__c;
        String oldStatus = trigger.old[0].Status__c;
    
        if (trigger.new[0].Status__c != trigger.old[0].Status__c){
            trigger.new[0].Status_Change_Date__c = System.now();
        }
    //This means we're inserting a new one.
    }else{    
        if(codes.size()>0){
           system.debug('DUP ON INSERT HAS BEEN FOUND');
           Sales_Code__c tempCode = codes[0];
           Trigger.new[0].addError('The Sales Code already exists under that program.');
        }
        
        trigger.new[0].Status_Change_Date__c = System.now();
        
    }
    
}