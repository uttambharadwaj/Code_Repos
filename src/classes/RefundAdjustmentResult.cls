/**
 * Created by W083158 on 5/22/2019.
 */

global with sharing class RefundAdjustmentResult {
    @InvocableVariable
    @AuraEnabled
    global RefundAdjustmentRequest request;
    @InvocableVariable
    @AuraEnabled
    global List<RefundAdjustment> refundAdjustments;
}