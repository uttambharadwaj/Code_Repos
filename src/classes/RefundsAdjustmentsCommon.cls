/**
 * Created by W083158 on 6/25/2019.
 */

public with sharing class RefundsAdjustmentsCommon {
    private static String dateString = System.now().format('MMddYY')+ ' ';

    private static Support_Operation_Settings__c sos;

    public static String getItemId(Refund_Adjustment__c refadj) {
        String result = 'REFUND';
        if ('Adjustment' == refadj.RecordType.DeveloperName) {
            result = dateString + refadj.Department__c;
        }
        return result;
    }

    public static String getAdjustmentsPageRef() {
        getSupportOperationsSettings();
        return makeReportPageRef(sos.Adjustments_for_Finance_Approval_Rpt_ID__c);
    }

    public static String getRefundsPageRef() {
        getSupportOperationsSettings();
        return makeReportPageRef(sos.RefundsForFinanceApprovalReportId__c);
    }

    private static void getSupportOperationsSettings() {
        if (sos == null) {
            sos = Support_Operation_Settings__c.getInstance();
        }
    }

    private static String makeReportPageRef(String reportId) {
        return '/lightning/r/Report/' + reportId + '/view';
    }

}