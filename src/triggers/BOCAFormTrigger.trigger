trigger BOCAFormTrigger on WeFormObject__c (before insert, before update) {

    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {

        for (WeFormObject__c f : Trigger.new) {

            if (Trigger.isUpdate) {

                WeFormObject__c old = Trigger.oldMap.get(f.Id);

                if ((old.status__c).equalsIgnoreCase('complete') && (f.status__c).equalsIgnoreCase('complete')) {
                    continue;
                }

            }

            if (f.status__c != null && (f.status__c).equalsIgnoreCase('complete')) {

                BOCAFormTriggerHandler.triageWexBOCA(f);

            }


        }
    }

}