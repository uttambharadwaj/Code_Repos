/**
 * Created by W083158 on 5/22/2019.
 */
@IsTest
public with sharing class RefundAdjustmentOldDataPullerTest {

    @IsTest
    static void testBehavior() { 
        Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());
        Test.startTest();
        RefundAdjustmentRequest request = new RefundAdjustmentRequest();
        request.recordTypeName = 'Adjustment';
        request.wexAccountNbr = '7000000003988';
        List<RefundAdjustmentRequest> requests = new List<RefundAdjustmentRequest>();
        requests.add(request);
        List<RefundAdjustmentResult> results = RefundAdjustmentFlowDemo.getPriorRefundAdjustments(requests);
        System.assert(results != null);
        System.assert(results.size()==1);
        RefundAdjustmentResult result = results.get(0);
        System.assert(result != null);
        if (result.refundAdjustments != null && result.refundAdjustments.size() > 0) {
            responsePrinter(result);
        }
        Test.stopTest();
    }

    @IsTest
    static void testDemoClass() {
        Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());
        Test.startTest();
        RefundAdjustmentRequest request = new RefundAdjustmentRequest();
        request.recordTypeName = 'Adjustment';
        request.wexAccountNbr = '9100001234567';
        List<RefundAdjustmentRequest> requests = new List<RefundAdjustmentRequest>();
        requests.add(request);
        List<RefundAdjustmentResult> results = RefundAdjustmentFlowDemo.getPriorRefundAdjustments(requests);
        System.assert(results != null);
        Test.stopTest();
    }
    
    static private void responsePrinter(RefundAdjustmentResult result) {

        for (RefundAdjustment refadj : result.refundAdjustments ) {
            System.debug('      Id: '+refadj.ID);

            System.debug('      wexAccountNbr  : '+refadj.wexAccountNbr);
            System.debug('      caseNumber     : '+refadj.caseNumber);
            System.debug('      amount         : '+refadj.amount);
            System.debug('      approvalStatus : '+refadj.approvalStatus);
            System.debug('      approverName   : '+refadj.approverName);
            System.debug('      decisionDate   : '+refadj.decisionDate);
            System.debug('      createdDate    : '+refadj.createdDate);
            System.debug('      Name           : '+refadj.Name);
            System.debug('      recordTypeId   : '+refadj.recordTypeId);
            System.debug('      department     : '+refadj.department);
            System.debug('      createdBy      : '+refadj.createdBy);
            System.debug('      reasonComment  : '+refadj.reasonComment);
            System.debug('---------------------------------------------');
        }
        System.debug('=============================================');
    }
}