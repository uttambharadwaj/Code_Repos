/**
 * Created by mfarrell on 9/24/20.
 *
 * Revision History:
 *      25Sept2020  mfarrell    updatePaymentPlans created for EAPT-2678
 */

public class CollectionsBeforeUpdateTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        updatePaymentPlans(tp.newList, (Map<Id, Collections__c>) tp.oldMap);

    }

    private static void updatePaymentPlans(List<Collections__c> records, Map<Id, Collections__c> oldMap) {
        Map<Id, Collections__c> collectionRecordsToProcess = new Map<Id, Collections__c>();
        Map<Collections__c, List<Collections_Payment_Plan__c>> paymentPlanToCollectionMap = new Map<Collections__c, List<Collections_Payment_Plan__c>>();

        Boolean paymentAmountChanged = false;
        Boolean paymentDateChanged = false;
        // get collections records with a payment plan where the last payment amount was updated
        for (Collections__c c : records) {
            paymentAmountChanged = c.Last_Payment_Amount__c != oldMap.get(c.Id).Last_Payment_Amount__c ? true : false;
            paymentDateChanged = c.Last_Payment_Date__c != oldMap.get(c.Id).Last_Payment_Date__c ? true : false;
            if (c.Promise_To_Pay__c && c.Last_Payment_Amount__c != null && (paymentAmountChanged || paymentDateChanged)) {
                collectionRecordsToProcess.put(c.Id, c);
            }
        }

        // if no records then GTFO!
        if (collectionRecordsToProcess.isEmpty()) return;

        // get the payment plan records without a remitted payment for the collection records
        List<Collections_Payment_Plan__c> paymentPlans = [
                SELECT Id, Collections__c, Payment_Amount__c, Payment_Date__c, Payment_Remitted__c, Partial_Payment_Applied__c
                FROM Collections_Payment_Plan__c
                WHERE Collections__c =: collectionRecordsToProcess.keySet()
                AND Payment_Remitted__c = FALSE
                ORDER BY Payment_Date__c ASC
        ];

        // if no records then GTFO!
        if (paymentPlans.isEmpty()) return;

        // map the payment plans to their related collection record
        for (Collections_Payment_Plan__c pay : paymentPlans) {
            List<Collections_Payment_Plan__c> paymentPlanListForMap = new List<Collections_Payment_Plan__c>();
            if (paymentPlanToCollectionMap.containsKey(collectionRecordsToProcess.get(pay.Collections__c))){
                paymentPlanListForMap = paymentPlanToCollectionMap.get(collectionRecordsToProcess.get(pay.Collections__c));
            }
            paymentPlanListForMap.add(pay);
            paymentPlanToCollectionMap.put(collectionRecordsToProcess.get(pay.Collections__c), paymentPlanListForMap);
        }

        // if no records then GTFO!
        if (paymentPlanToCollectionMap.isEmpty()) return;

        // set up variables for payment plan updates
        List<Collections_Payment_Plan__c> paymentPlansToUpdate = new List<Collections_Payment_Plan__c>();
        List<Collections_Payment_Plan__c> paymentPlansToProcess = new List<Collections_Payment_Plan__c>();
        Double lastPaymentAmount = 0;
        Double combinedPaymentAmount = 0;

        // iterate over collection records so we can apply the payment amount from the collection record to the payment plan records
        for (Collections__c c : paymentPlanToCollectionMap.keySet()) {
            paymentPlansToProcess = paymentPlanToCollectionMap.get(c);
            lastPaymentAmount = c.Last_Payment_Amount__c; // null checked at start of method

            for (Collections_Payment_Plan__c pay : paymentPlansToProcess) {

                // check if a partial payment was previously made
                if (pay.Partial_Payment_Applied__c != null) {

                    // add past partial payment to last payment amount
                    combinedPaymentAmount = lastPaymentAmount + pay.Partial_Payment_Applied__c;

                    if (combinedPaymentAmount >= pay.Payment_Amount__c) {
                        pay.Payment_Remitted__c = true;
                        lastPaymentAmount = combinedPaymentAmount - pay.Payment_Amount__c;
                        pay.Partial_Payment_Applied__c = null;
                        paymentPlansToUpdate.add(pay);
                    } else if (combinedPaymentAmount > 0) {
                        pay.Partial_Payment_Applied__c = combinedPaymentAmount;
                        paymentPlansToUpdate.add(pay);
                        break;
                    }
                // no previously made partial payment
                } else {

                    if (lastPaymentAmount >= pay.Payment_Amount__c) {
                        pay.Payment_Remitted__c = true;
                        lastPaymentAmount = lastPaymentAmount - pay.Payment_Amount__c;
                        paymentPlansToUpdate.add(pay);
                    } else if (lastPaymentAmount > 0) {
                        pay.Partial_Payment_Applied__c = lastPaymentAmount;
                        paymentPlansToUpdate.add(pay);
                        break;
                    }

                }

            }

        }

        update paymentPlansToUpdate;

    }

}

