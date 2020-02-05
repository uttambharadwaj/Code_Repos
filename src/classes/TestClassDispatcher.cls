/*
Description:        Test class dispatcher. A one-stop shop for test execution.
Revision History:   7/23/2019 add apprequest tests

*/

@isTest
public class TestClassDispatcher {

    @testSetup
    static void setup(){
        //create all the things!
        UtilityTestLoader.loadTestData();
    }

    @isTest static void testPartnerBOCAToProspectControllerSend(){
        PartnerBOCAToProspectControllerTest.testPBPSend();
    }

    @isTest static void testPartnerBOCAToProspectControllerInit(){
        PartnerBOCAToProspectControllerTest.testInits();
    }

    @isTest static void testOpportunityTriggerAfterInsert() {
        OpportunityTriggerTest.testFleetEnrollmentOpptyInfoOnInsert();
    }

    @isTest static void testOpportunityTriggerBeforeUpdate() {
        OpportunityTriggerTest.testFleetEnrollmentOpptyInfoOnUpdate();
    }

    @isTest static void testOpptyTriggerInsert(){
        OpportunityTriggerTest.testOpportunityInsert();
    }

    @isTest static void testOpptyTriggerDelete(){
        OpportunityTriggerTest.testOpportunityDelete();
    }

    @isTest static void testBOEntityTriggerBeforeInsert1() {
        BOEntityTriggerTest.testLegalStructureBeforeInsertFail();
    }

    @isTest static void testBOEntityTriggerBeforeInsert2() {
        BOEntityTriggerTest.testUpdateExemptionStatusBeforeInsert();
    }

    @isTest static void testBOEntityTriggerAfterInsert1() {
        BOEntityTriggerTest.testBOEOpptyInfoOnInsert();
    }

    @isTest static void testBOEntityTriggerBeforeUpdate1() {
        BOEntityTriggerTest.testUpdateExemptionStatusBeforeUpdate();
    }

    @isTest static void testBOEntityTriggerAfterUpdate1() {
        BOEntityTriggerTest.testCheckOpptyChangesAfterUpdate();
    }

    @isTest static void testBOEntityBusinessProcesses(){
        BOEntityTriggerTest.testBusinessProcesses();
    }

    @isTest static void testAppRequestTriggerInserts() {
        AppRequestTriggerTest.testInsert();
    }

    @isTest static void testAppRequestTriggerUpdates(){
        AppRequestTriggerTest.testUpdate();
    }

    @isTest static void testZuoraQuoteInserts(){
        ZQUQuoteTriggerTest.testZQUQuoteOnInsert();
    }

    @isTest static void testZuoraQuoteUpdates(){
        ZQUQuoteTriggerTest.testZQUQuoteOnUpdate();
    }

    @isTest static void testBOProngTriggerValidations(){
        BOProngTriggerTest.testValidateNumberOfRecords();
    }

    @isTest static void testCreateCampaignCode() {
        CampaignCodeGeneratorTest.test_createCampaignCode();
    }

    @isTest static void testCampaignCodeGenerate() {
        CampaignCodeGeneratorTest.test_generateCode();
    }

    @isTest static void testCampaignProgramDelete(){
        CmpgnProgramTriggerTest.testCampaignProgramDelete();
    }

    @isTest static void testAttachmentUploadPass(){
        AttachmentUploadControllerTest.testGoodUpload();
    }

    @isTest static void testAttachmentUploadFail(){
        AttachmentUploadControllerTest.testFailUpload();
    }

    @isTest static void testAttachmentUploadBlah(){
        AttachmentUploadControllerTest.testNoUpload();
    }

    @isTest static void testFleetEnrollmentOneToOne(){
        FleetEnrollmentController2Test.testFleetEnrollmentOneToOne();
    }

    @isTest static void testContactUnsubscribeContact(){
        ContactUnsubscribeControllerTest.testContactUnsubscribe();
    }

    @isTest static void testContactUnsubscribeLead(){
        ContactUnsubscribeControllerTest.testLeadUnsubscribe();
    }

    @isTest static void testExperianPGQueuableGood(){
        //CreditUtilQueueable_ExperianPGTest.testGoodRequests();
    }

    @isTest static void testExperianPGQueuableBad(){
        //CreditUtilQueueable_ExperianPGTest.testBadRequests();
    }

    @isTest static void testCreditDecisionServiceGood(){
        WSUtil_WSS2_CreditDecisionServiceTest.testGoodUpdate();
    }

    @isTest static void testCreditDecisionServiceBad(){
        WSUtil_WSS2_CreditDecisionServiceTest.testBadUpdate();
    }

    @isTest static void testOpportunityAutoAssignment(){
        OpportunityAssignmentTest.test_opportunityAutoAssignment();
    }

    @isTest static void testOpptyUpdatePrimaryContact(){
        OpportunityContactRoleQueueableTest.updateOpportunityPrimaryContactTest();
    }

    @isTest static void testClassicOutOfOfficeController(){
        ClassicOutOfOfficeControllerTest.testSaveOutOfOffice();
    }

    @isTest static void testCreditLensWSAuth() {
        CreditWS_CreditLensTest.creditLensAuthenticationPositiveTest();
    }

    @isTest static void testCreditLensWSCreate() {
        CreditWS_CreditLensTest.creditLensCreateEntityPostiveTest();
    }

    @isTest static void testCreditLensDocumentUpload() {
        CreditWS_CreditLensTest.creditLensUploadDocumentTest();
    }

    @isTest static void testCreditLensLinkDocToEntity() {
        CreditWS_CreditLensTest.creditLensLinkDocToEntityTest();
    }

    @IsTest static void testWexBOCAFinancials() {
        WexBOCAFinancialsControllerTest.WexBOCAFinancialsTest();
    }

    @isTest static void testWebDAMSyncGenerateFileName() {
        WebDAMSyncTest.test_generateFileName();
    }

    @isTest static void testWebDAMSyncSavingAsset() {
        WebDAMSyncTest.test_savingAsset();
    }

    @isTest static void testWebDAMConnectorAuth() {
        WebDAMConnectorTest.test_webDAMAuth();
    }

    @isTest static void testWebDAMConnectorSearch() {
        WebDAMConnectorTest.test_webDAMSearch();
    }

    @isTest static void testWebDAMConnectorDownload() {
        WebDAMConnectorTest.test_webDAMDownload();
    }

    @IsTest static void testPaperAppExtension() {
        PaperAppSubmissionExtensionTest.buildURLTest();
    }

}