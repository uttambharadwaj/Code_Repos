/**
 * Created by W083158 on 5/22/2019.
 */

global with sharing class RefundAdjustmentOldDataPuller {
    @InvocableMethod(Label='get Prior Refunds and Adjustments' Description='Get Prior Refunds and Adjustments formerly in Access')
    global static List<List<RefundAdjustment>> getPriorRefundAdjustments(List<RefundAdjustmentRequest> requestList ) {
        //todo connect this to the web service and database
        List<RefundAdjustment> results = new List<RefundAdjustment>();
        for (RefundAdjustmentRequest request: requestList) {
            RefundAdjustmentResult result = new RefundAdjustmentResult();
            result.refundAdjustments = RefundAdjustmentGenerator.getRefundsOrAdjustments(request.wexAccountNbr, request.recordTypeName);
            results.addAll(result.refundAdjustments);
        }
        List<List<RefundAdjustment>> finalResult = new List<List<RefundAdjustment>>();
        finalResult.add(results);
        System.debug(results);
        return finalResult;
    }

}