trigger Credit_InsuranceTrigger on Credit_Insurance__c (before insert, before update,after insert, after update) {

    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        for(Credit_Insurance__c ins:Trigger.new){
            if(ins.Expiration_Date__c != null && (ins.Expiration_Date__c < date.today())){
                ins.isExpired__c = true;
            }else{
                ins.isExpired__c = false;
            }
        }
    }
    
//    if(Trigger.isInsert && Trigger.isBefore){
//        CreditInsuranceTriggerHandler.validateInsuranceInsert(Trigger.new);
//    } else if(Trigger.isUpdate && Trigger.isBefore) {
//        CreditInsuranceTriggerHandler.validateInsuranceUpdate(Trigger.new,Trigger.oldMap);
//    } else 
    
    if(Trigger.isInsert && Trigger.isAfter){
        CreditInsuranceTriggerHandler.onInsert(Trigger.new);
    } else if (Trigger.isUpdate && Trigger.isAfter){
        CreditInsuranceTriggerHandler.onUpdate(Trigger.new, Trigger.oldMap);
    }
    
}