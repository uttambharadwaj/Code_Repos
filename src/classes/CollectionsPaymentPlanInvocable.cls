/**
 * Created by dgilbert on 2019-12-05.
 *
 * Revision History:
 *      25Sept2020  mfarrell    EAPT-2678   Added collectionsRecordsToUpdate and logic to set Promise To Pay Boolean on Collection Record.
 */

public with sharing class CollectionsPaymentPlanInvocable {

    @InvocableMethod(label='Generate Payment Plan')
    public static void doAction(Request[] requests) {

        Set<Id> promiseToPayIds = new Set<Id>();

        for(Request request : requests) {
            promiseToPayIds.add(request.recordId);
        }

        List<Collections_Payment_Plan__c> paymentPlanIdsToDelete = [SELECT Id FROM Collections_Payment_Plan__c WHERE Promise_To_Pay__c in :promiseToPayIds];
        delete paymentPlanIdsToDelete;

        List<Collections_Payment_Plan__c> collectionsPaymentPlans = new List<Collections_Payment_Plan__c>();
        List<Collections_Promise__c> collectionsPromises = [
                SELECT Id, Collections__c, Collections__r.Total_Owed__c, Payment_Type__c, Payment_Frequency__c, First_Payment_Date__c, Payment_Amount__c
                FROM Collections_Promise__c
                WHERE Id =: promiseToPayIds
        ];
        Set<Id> collectionIds = new Set<Id>();

        for(Collections_Promise__c collectionsPromise : collectionsPromises) {
            collectionIds.add(collectionsPromise.Collections__c);

            if((collectionsPromise.Payment_Type__c).equalsIgnoreCase('One Time')) {
                Collections_Payment_Plan__c collectionsPaymentPlan = new Collections_Payment_Plan__c();
                collectionsPaymentPlan.Promise_To_Pay__c = collectionsPromise.Id;
                collectionsPaymentPlan.Payment_Date__c = collectionsPromise.First_Payment_Date__c;
                collectionsPaymentPlan.Payment_Amount__c = collectionsPromise.Payment_Amount__c;
                collectionsPaymentPlan.Collections__c = collectionsPromise.Collections__c;
                collectionsPaymentPlans.add(collectionsPaymentPlan);
            }
            else {

                Double leftoverBalance = collectionsPromise.Collections__r.Total_Owed__c;
                Date currentPaymentDate = collectionsPromise.First_Payment_Date__c;
                while(leftoverBalance > 0) {

                    Collections_Payment_Plan__c collectionsPaymentPlan = new Collections_Payment_Plan__c();

                    collectionsPaymentPlan.Promise_To_Pay__c = collectionsPromise.Id;
                    collectionsPaymentPlan.Collections__c = collectionsPromise.Collections__c;
                    if(collectionsPromise.Payment_Amount__c > leftoverBalance) {
                        collectionsPaymentPlan.Payment_Amount__c = leftoverBalance;
                    }
                    else {
                        collectionsPaymentPlan.Payment_Amount__c = collectionsPromise.Payment_Amount__c;
                    }
                    collectionsPaymentPlan.Payment_Date__c = currentPaymentDate;

                    collectionsPaymentPlans.add(collectionsPaymentPlan);

                    leftoverBalance = (leftoverBalance - collectionsPromise.Payment_Amount__c);
                    if((collectionsPromise.Payment_Frequency__c).equalsIgnoreCase('Weekly')) {
                        currentPaymentDate = (currentPaymentDate.addDays(7));
                    }
                    else if((collectionsPromise.Payment_Frequency__c).equalsIgnoreCase('Bi-weekly')) {
                        currentPaymentDate = (currentPaymentDate.addDays(14));
                    }
                    else if((collectionsPromise.Payment_Frequency__c).equalsIgnoreCase('Monthly')) {
                        currentPaymentDate = (currentPaymentDate.addMonths(1));
                    }
                    else if((collectionsPromise.Payment_Frequency__c).equalsIgnoreCase('Yearly')) {
                        currentPaymentDate = (currentPaymentDate.addYears(1));
                    }

                }

            }

        }

        upsert collectionsPaymentPlans;

        List<Collections__c> collectionsRecordsToUpdate = [SELECT Id, Promise_To_Pay__c FROM Collections__c WHERE Id =: collectionIds];
        for (Collections__c c : collectionsRecordsToUpdate) {
            c.Promise_To_Pay__c = true;
        }
        update collectionsRecordsToUpdate;

    }

    public with sharing class Request {

        @InvocableVariable(label='Record ID' required=true)
        public Id recordId;

    }

}