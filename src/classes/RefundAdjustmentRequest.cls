/**
 * Created by W083158 on 5/22/2019.
 */

global with sharing class RefundAdjustmentRequest {
    @AuraEnabled
    @InvocableVariable(Required=true)
    global String wexAccountNbr;
    @AuraEnabled
    @InvocableVariable(Required=true)
    global String recordTypeName;
}