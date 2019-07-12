/**
 * Created by W083158 on 5/23/2019.
 */

public with sharing class RefundAdjustmentGenerator {



    public static List<RefundAdjustment> getRefundsOrAdjustments(String wexAccountNbr, String recordTypeName) {
        //todo: make this make a web service call to the new database
        //return getTestData(wexAccountNbr, recordTypeName);
        RecordType recordType = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Refund_Adjustment__c' AND DeveloperName =: recordTypeName];
        CustomerDetailsWSUtilv2.RefundAdjustmentDTO dto;
        List<RefundAdjustment> result = new List<RefundAdjustment>();
        if ('Refund'.equals(recordTypeName)) {
            dto = CustomerDetailsController.getRefunds(wexAccountNbr);

        } else {
            dto = CustomerDetailsController.getAdjustments(wexAccountNbr);
        }

        if (dto.refundAdjustments != null && dto.refundAdjustments.size()>0) {
        for (CustomerDetailsWSUtilv2.refundAdjustment x : dto.refundAdjustments) {
            result.add(convertDtoRefadjToApexRefadj(x, recordType.Id));
        }
        }
        return result;

    }

    private static RefundAdjustment convertDtoRefadjToApexRefadj (CustomerDetailsWSUtilv2.refundAdjustment ra, Id recordTypeId) {
        RefundAdjustment result = new RefundAdjustment();
        System.debug(ra);
        result.ID = ((Integer) ra.id);
        System.debug(result.ID);
        result.wexAccountNbr = ra.accountNumber;
        System.debug(result.wexAccountNbr);
        if (ra.amountRequested != null)
            result.amountRequested = (ra.amountRequested).setScale(2);
        System.debug(result.amountRequested);
        if (ra.amountWaived != null)
            result.amount = (ra.amountWaived).setScale(2);
        System.debug(result.amount);
        result.approvalStatus = ra.approvalStatus;
        System.debug(result.approvalStatus);
        result.approverName = ra.approver;
        System.debug(result.approverName);
        result.department = ra.department;
        System.debug(result.department);
        if (ra.decisionDt != null)
            result.decisionDate = ra.decisionDt.format();
        System.debug(result.decisionDate);
        if (ra.requestDt != null)
            result.createdDate = ra.requestDt.format();
        System.debug(result.createdDate);
        result.createdBy = ra.requestor;
        System.debug(result.createdBy);
        result.recordTypeId = recordTypeId;
        System.debug(result.recordTypeId);
        result.reasonComment = ra.reasonComment;
        System.debug(result.reasonComment);

        return result;
    }

    /*
    private static List<RefundAdjustment> getTestData(String wexAccountNbr, String recordTypeName) {
        RecordType recordType = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Refund_Adjustment__c' AND DeveloperName =: recordTypeName];

        List<RefundAdjustment> result = new List<RefundAdjustment>();
        for (Integer i=1; i<= 1; i++) {
            RefundAdjustment newRefAdj = new RefundAdjustment();
            newRefAdj.wexAccountNbr = wexAccountNbr;
            newRefAdj.amount = ((Decimal)((i*100)+25)).setScale(2);
            newRefAdj.amountRequested = ((Decimal)(i*100)).setScale(2);
            newRefAdj.approvalStatus = (i<5 ? 'Approved' : 'Pending');
            newRefAdj.approverName = 'Tester Tester';
            newRefAdj.decisionDate = '01/'+i+'/2019 12:00 AM';
            newRefAdj.createdDate = '01/'+(i+1)+'/2019 12:00 AM';
            newRefAdj.Name = 'Test Data';
            newRefAdj.recordTypeId = recordType.Id;
            newRefAdj.department = 'CS';
            newRefAdj.reasonComment = 'Test Reason';
            result.add(newRefAdj);
        }
        return result;
    } */

}