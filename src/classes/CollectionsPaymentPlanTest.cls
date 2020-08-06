/**
 * Created by jharrell on 6/29/20.
 */

public class CollectionsPaymentPlanTest {

	public static void test_generatePaymentPlan() {

		List<Collections_Promise__c> promiseToPays = [ SELECT Id,Payment_Type__c,Collections__r.Total_Owed__c FROM Collections_Promise__c ];
		List<CollectionsPaymentPlanInvocable.Request> paymentPlanRequests = new List<CollectionsPaymentPlanInvocable.Request>();
		Map<Id, Double> collectionsAmountPastDue = new Map<Id, Double>();
		Map<Id, Double> payments = new Map<Id, Double>();

		for (Collections_Promise__c promiseToPay : promiseToPays) {
			CollectionsPaymentPlanInvocable.Request paymentPlanRequest = new CollectionsPaymentPlanInvocable.Request();
			paymentPlanRequest.recordId = promiseToPay.Id;
			paymentPlanRequests.add(paymentPlanRequest);

			if (collectionsAmountPastDue.get(promiseToPay.Collections__c) == null) {
				collectionsAmountPastDue.put(promiseToPay.Collections__c, promiseToPay.Collections__r.Total_Owed__c);
			}
		}

		Test.startTest();
		CollectionsPaymentPlanInvocable.doAction(paymentPlanRequests);
		Test.stopTest();

		for (Collections_Payment_Plan__c paymentPlan : [ SELECT Id,Payment_Amount__c,Collections__c FROM Collections_Payment_Plan__c ]) {

			if (payments.get(paymentPlan.Collections__c) == null) {
				payments.put(paymentPlan.Collections__c, 0);
			}
			payments.put(paymentPlan.Collections__c, payments.get(paymentPlan.Collections__c) + paymentPlan.Payment_Amount__c);
		}

		for (Id collectionId : payments.keySet()) {
			// Assert that the payments add up to the total amount due
			System.assertEquals(collectionsAmountPastDue.get(collectionId), payments.get(collectionId));
		}
	}
}