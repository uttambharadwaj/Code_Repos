/**
 * Created by mfarrell on 9/25/20.
 */
@IsTest
public class CollectionsTest {

    public static void test_paymentPlanUpdate() {

        List<Collections__c> collectionRecords = [SELECT Id, Total_Owed__c, Past_Due_Amount__c, Promise_To_Pay__c, Last_Payment_Amount__c FROM Collections__c LIMIT 1];
        List<Collections_Promise__c> promiseToPays = [ SELECT Id,Payment_Type__c,Collections__r.Total_Owed__c FROM Collections_Promise__c WHERE Collections__c =: collectionRecords];
        List<Collections_Payment_Plan__c> paymentPlans = [
                SELECT Id, Payment_Remitted__c, Payment_Amount__c, Payment_Date__c
                FROM Collections_Payment_Plan__c
                WHERE Collections__c =: collectionRecords
                AND Promise_To_Pay__c =: promiseToPays
        ];

        System.assert(!collectionRecords.isEmpty(), 'we did not find collection records');
        System.assert(!promiseToPays.isEmpty(), 'we did not find promise to pay records');
        System.assert(!paymentPlans.isEmpty(), 'we did not find payment plan records');

        test.startTest();
        collectionRecords[0].Last_Payment_Amount__c = 1010;
        update collectionRecords;
        test.stopTest();

        List<Collections_Payment_Plan__c> remittedPaymentPlans = [
                SELECT Id, Payment_Remitted__c
                FROM Collections_Payment_Plan__c
                WHERE Collections__c =: collectionRecords
                AND Promise_To_Pay__c =: promiseToPays
                AND Payment_Remitted__c = TRUE
                AND Partial_Payment_Applied__c = NULL
        ];
        List<Collections_Payment_Plan__c> partialPaymentPlans = [
                SELECT Id, Payment_Remitted__c, Partial_Payment_Applied__c
                FROM Collections_Payment_Plan__c
                WHERE Collections__c =: collectionRecords
                AND Promise_To_Pay__c =: promiseToPays
                AND Payment_Remitted__c = FALSE
                AND Partial_Payment_Applied__c != NULL
        ];

        // static resource for collections: Total_Owed__c = 5000
        // static resource for promise to pay: Installment, Payment Amount = 100
        // there are 11 payment plan records, one has a partial payment of 95 to satisfy all of the logic testing criteria.
        System.assertEquals(11, remittedPaymentPlans.size(), 'incorrect number of remitted payments');
        // we should have 1 partial payment of $5
        System.assertEquals(1, partialPaymentPlans.size(), 'incorrect number of partial payments');
        System.assertEquals(5, partialPaymentPlans[0].Partial_Payment_Applied__c, 'partial payment amount is not correct');

    }

}