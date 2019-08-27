/**
 * Created by W083158 on 7/12/2019.
 */

global with sharing class GetRefundAdjustmentTotals {
    @InvocableMethod(Label='GetTotals' Description='Param 0 is wexAcctNbr, param 1 is record type')
    global static List<RefundAdjustmentTotals> getTotals(List<RefundAdjustmentSummaryRequestParams> params) {
        if (!(params == null || params.isEmpty()))
            return RefundAdjustmentGenerator.getRefundsOrAdjustmentsAggregates(params.get(0).wexAcctNbr, params.get(0).recordType);
        else {
            RefundAdjustmentTotals nullTotals = new RefundAdjustmentTotals();
            nullTotals.errorMsg = 'Invalid request';
            List<RefundAdjustmentTotals> nullResult = new List<RefundAdjustmentTotals>();
            nullResult.add(nullTotals);
            return nullResult;
        }


    }
}