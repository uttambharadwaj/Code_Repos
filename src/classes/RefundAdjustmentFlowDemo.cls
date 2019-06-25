/**
 * Created by W083158 on 5/22/2019.
 */

global with sharing class RefundAdjustmentFlowDemo {
    @InvocableMethod(Label='Demo' Description='Demo')
    global static List<RefundAdjustmentResult> getPriorRefundAdjustments(List<RefundAdjustmentRequest> requestList ) {
        //todo connect this to the web service and database
       return null;
    }
}