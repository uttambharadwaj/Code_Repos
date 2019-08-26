/**
 * Created by W083158 on 7/15/2019.
 */

global with sharing class RefundAdjustmentSummaryRequestParams {
    @AuraEnabled
    @InvocableVariable
    global String wexAcctNbr;

    @AuraEnabled
    @InvocableVariable
    global String recordType;

}