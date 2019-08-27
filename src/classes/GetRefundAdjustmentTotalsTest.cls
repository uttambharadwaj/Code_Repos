/**
 * Created by W083158 on 7/12/2019.
 */
@IsTest
public with sharing class GetRefundAdjustmentTotalsTest {
    @IsTest
    static void testGetTotals() {
        Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());
        List<RefundAdjustmentSummaryRequestParams> paramsList = new List<RefundAdjustmentSummaryRequestParams>();
        RefundAdjustmentSummaryRequestParams params = new RefundAdjustmentSummaryRequestParams();
        params.wexAcctNbr = '9100000000000';
        params.recordType = 'Adjustment';
        paramsList.add(params);
        Test.startTest();
        List<RefundAdjustmentTotals> result = GetRefundAdjustmentTotals.getTotals(paramsList);
        System.assert(result != null);
        System.assert(result.size() == 1);
        RefundAdjustmentTotals totals = result.get(0);
        System.assert(totals.errorMsg.equals('Generated demo data'));
    }

    @IsTest
    static void testGetBadTotals() {
        Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());
        List<RefundAdjustmentSummaryRequestParams> paramsList = new List<RefundAdjustmentSummaryRequestParams>();
        RefundAdjustmentSummaryRequestParams params = new RefundAdjustmentSummaryRequestParams();
        params.wexAcctNbr = '9100000000001';
        params.recordType = 'Adjustment';
        paramsList.add(params);
        Test.startTest();
        List<RefundAdjustmentTotals> result = GetRefundAdjustmentTotals.getTotals(paramsList);
        System.assert(result != null);
        System.assert(result.size() == 1);
        RefundAdjustmentTotals totals = result.get(0);
        System.assert(!(totals.errorMsg.equals('')));
    }

    @IsTest
    static void testGetNullTotals() {
        Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());
        List<RefundAdjustmentSummaryRequestParams> paramsList = new List<RefundAdjustmentSummaryRequestParams>();

        Test.startTest();
        List<RefundAdjustmentTotals> result = GetRefundAdjustmentTotals.getTotals(paramsList);
        System.assert(result != null);
        System.assert(result.size() == 1);
        RefundAdjustmentTotals totals = result.get(0);
        System.assertEquals(totals.errorMsg, 'Invalid request');
    }
}