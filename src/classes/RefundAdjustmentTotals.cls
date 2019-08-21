/**
 * Created by W083158 on 7/12/2019.
 */

global with sharing class RefundAdjustmentTotals {
    @InvocableVariable
    @AuraEnabled
    global String errorMsg;

    @InvocableVariable
    @AuraEnabled
    global Decimal mostRecentAmount;

    @InvocableVariable
    @AuraEnabled
    global String mostRecentApprovalStatus;

    @InvocableVariable
    @AuraEnabled
    global String mostRecentCodeDescription;

    @InvocableVariable
    @AuraEnabled
    global String mostRecentCreatedDate;

    @InvocableVariable
    @AuraEnabled
    global String mostRecentDepartment;

    @InvocableVariable
    @AuraEnabled
    global String mostRecentReason;

    @InvocableVariable
    @AuraEnabled
    global String mostRecentSubmitter;

    @InvocableVariable
    @AuraEnabled
    global Decimal totalFeesRefunded;

    @InvocableVariable
    @AuraEnabled
    global Decimal totalFeesRequested;

    @InvocableVariable
    @AuraEnabled
    global Long totalRequests;

    @InvocableVariable
    @AuraEnabled
    global Long totalRequestsApproved;

    @InvocableVariable
    @AuraEnabled
    global Decimal totalRequestsPending;
}