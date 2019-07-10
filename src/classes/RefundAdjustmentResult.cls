/**
 * Created by W083158 on 5/22/2019.
 */

global with sharing class RefundAdjustmentResult {
    @AuraEnabled
    @InvocableVariable
    global RefundAdjustmentRequest request;
    @AuraEnabled
    @InvocableVariable
    global List<RefundAdjustment> refundAdjustments;
}