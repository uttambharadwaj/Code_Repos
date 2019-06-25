/**
 * Created by W083158 on 5/23/2019.
 */

public with sharing class RefundAdjustmentGenerator {

    public static List<RefundAdjustment> getRefundsOrAdjustments(String wexAccountNbr, String recordTypeName) {
        //todo: make this make a web service call to the new database
        return getTestData(wexAccountNbr, recordTypeName);
    }

    private static List<RefundAdjustment> getTestData(String wexAccountNbr, String recordTypeName) {
        RecordType recordType = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Refund_Adjustment__c' AND DeveloperName =: recordTypeName];

        List<RefundAdjustment> result = new List<RefundAdjustment>();
        for (Integer i=1; i<= 1; i++) {
            RefundAdjustment newRefAdj = new RefundAdjustment();
            newRefAdj.wexAccountNbr = wexAccountNbr;
            newRefAdj.amount = i*100;
            newRefAdj.approvalStatus = (i<5 ? 'Approved' : 'Pending');
            newRefAdj.approverName = 'Tester Tester';
            newRefAdj.decisionDate = Datetime.parse('01/'+i+'/2019 12:00 AM');
            newRefAdj.createdDate = newRefAdj.decisionDate = Datetime.parse('01/'+(i+1)+'/2019 12:00 AM');
            newRefAdj.Name = 'Test Data';
            newRefAdj.recordTypeId = recordType.Id;
            newRefAdj.department = 'CS';
            newRefAdj.reasonComment = 'Test Reason';
            result.add(newRefAdj);
        }
        return result;
    }

}