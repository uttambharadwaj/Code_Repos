trigger CorporatePaymentsConvert on Opportunity (after insert) {

    if(Trigger.isAfter && Trigger.isInsert) {
        
        // If BOCA, we're skipping over this validation
        if(UserInfo.getSessionId() == null || (UserInfo.getName()).equalsIgnoreCase('CreditApplication Site Guest User') || (UserInfo.getName()).equalsIgnoreCase('Salesforce Integration')) {
            return;
        }
        
        Set<Id> corporatePayRecordTypeIds = new Set<Id>();
        
        if(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('EU Corporate Payments') != null) {
            corporatePayRecordTypeIds.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('EU Corporate Payments').getRecordTypeId());
        }
        
        if(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('ASIA Corporate Payments') != null) {
            corporatePayRecordTypeIds.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('ASIA Corporate Payments').getRecordTypeId());
        }
        
        if(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('AU Corporate Payments') != null) {
            corporatePayRecordTypeIds.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('AU Corporate Payments').getRecordTypeId());
        }
        
        if(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NA Corporate Payments') != null) {
            corporatePayRecordTypeIds.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NA Corporate Payments').getRecordTypeId());
        }
            
        if(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('WEX Payables') != null) {
            corporatePayRecordTypeIds.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('WEX Payables').getRecordTypeId());
        }
            
        for(Opportunity o : Trigger.new) {
            
            if(corporatePayRecordTypeIds.contains(o.RecordTypeId)) {
            
                if(o.Product_Interest__c == null || o.Street__c == null || o.City__c == null || o.State__c == null || o.Zip_Code__c == null) {
                
                    o.addError('You can\'t create this Opportunity because some required fields are missing data. Please go back and fill out the data before you convert. Product Interest (Opportunity) and Billing Street/Billing City/Billing State/Billing Zip (Account).');
              
                }
                
            }
            
        }
        
    }

}