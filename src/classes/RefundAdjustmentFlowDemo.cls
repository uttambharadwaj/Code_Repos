/**
 * Created by W083158 on 5/22/2019.
 */

global with sharing class RefundAdjustmentFlowDemo {
    @InvocableMethod(Label='GetPriorRefundAdjustments' Description='Get Prior Refunds and Adjustments formerly in Access')
    global static List<RefundAdjustmentResult> getPriorRefundAdjustments(List<RefundAdjustmentRequest> requestList ) {
        //todo connect this to the web service and database
       /* List<RefundAdjustmentResult> resultList = new List<RefundAdjustmentResult>();
        for (RefundAdjustmentRequest request:requestList) {
            RefundAdjustmentResult resultvar = new RefundAdjustmentResult();
            resultvar.request = request;
            resultList.add(resultvar);
        }
        return resultList;*/
       return RefundAdjustmentOldDataPuller.getPriorRefundAdjustments(requestList);
    }
}