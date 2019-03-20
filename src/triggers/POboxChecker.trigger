trigger POboxChecker on WeFormObject__c (before insert) {
    
    List<po_box_validation__c> codes = [SELECT id, po_box_formats__c FROM po_box_validation__c];
    
    for (WeFormObject__c form: Trigger.new){  
        if(form.status__c != 'partial' && form.status__c != 'lead' && form.status__c != 'saved'){
        String address = form.Business_Street_Address__c;
         for(po_box_validation__c codeMap : codes){
            if(address.containsIgnoreCase(codeMap.po_box_formats__c)){
                form.Business_Street_Address__c.addError('You cannot enter a P.O. Box for the business physical address.');
            }
             
             else{
                 break;
             }
        }
        }
    }
    
    
    
}