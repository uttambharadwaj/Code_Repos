/**
 * Created by W083158 on 5/22/2019.
 */

global with sharing class RefundAdjustmentOldDataPuller {
    public static List<RefundAdjustmentResult> getPriorRefundAdjustments(List<RefundAdjustmentRequest> requestList ) {
        //todo connect this to the web service and database
        List<RefundAdjustmentResult> finalResult = new List<RefundAdjustmentResult>();
        for (RefundAdjustmentRequest request: requestList) {
            RefundAdjustmentResult result = new RefundAdjustmentResult();
            result.request = request;
            result.refundAdjustments = RefundAdjustmentGenerator.getRefundsOrAdjustments(request.wexAccountNbr, request.recordTypeName);
            finalResult.add(result);
        }
        System.debug('End RefundAdjustmentOldDataPuller.getPriorRefundAdjustments');
        System.debug(finalResult);
        return finalResult;
    }

}