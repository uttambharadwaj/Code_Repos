/**
 * Created by W083158 on 5/22/2019.
 */

global with sharing class RefundAdjustment {
    @InvocableVariable
    @AuraEnabled
    global Integer ID;

    @InvocableVariable
    @AuraEnabled
    global String wexAccountNbr;

    @InvocableVariable
    @AuraEnabled
    global String caseNumber;

    @InvocableVariable
    @AuraEnabled
    global Decimal amount;

    @InvocableVariable
    @AuraEnabled
    global String approvalStatus;

    @InvocableVariable
    @AuraEnabled
    global String approverName;

    @InvocableVariable
    @AuraEnabled
    global Datetime decisionDate;

    @InvocableVariable
    @AuraEnabled
    global Datetime createdDate;

    @InvocableVariable
    @AuraEnabled
    global String Name;

    @InvocableVariable
    @AuraEnabled
    global String recordTypeId;

    @InvocableVariable
    @AuraEnabled
    global String department;

    @InvocableVariable
    @AuraEnabled
    global String createdBy;

    @InvocableVariable
    @AuraEnabled
    global String reasonComment;
}