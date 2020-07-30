/**
 * Created by mfarrell on 2019-12-13.
 */
@IsTest
public class CreditWS_CreditLensTest {

    /**
     * Positive authentication test. Method being tested should return a generated token.
     */
    public static void creditLensAuthenticationPositiveTest() {

        Credit_Decision_Engine_Endpoints__mdt CLAuthSettings = CreditWS_CreditLens.CLAuthSettings;
        Credit_Decision_Engine_Endpoints__mdt CLCreateEntitySettings = CreditWS_CreditLens.CLCreateOrGetEntitySettings;
        Moodys_CreditLens_Mapping__mdt CLStockExchange = CreditWS_CreditLens.CLStockExchange('NASDAQ');

        //Metadata Asserts
        System.assert(CLStockExchange != null, 'Expected CLStockExchange Metadata, but didn\'t find any');
        System.assert(CLAuthSettings != null, 'Expected CLAuthSettings Metadata, but didn\'t find any');
        System.assert(CLCreateEntitySettings != null, 'Expected CLCreateEntitySettings Metadata, but didn\'t find any');

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator(new Set<String>{'creditLensAuthGood','creditLensAuthLogin'}));
        String token = CreditWS_CreditLens.creditLensAuthentication();
        Test.stopTest();

        //Callout Asserts
        System.assert(token != null, 'Expected token to be returned.');
    }

    /**
    * Positive Entity edit for Case
    */
    public static void creditLensEditEntityTest() {

        Case caseId = [SELECT Id, Entity_ID__c, On_List__c FROM Case WHERE Entity_ID__c = '123' LIMIT 1];

        //sanity check before starting test.
        System.assert(caseId.Entity_ID__c != null, 'Expected a credit lens entity ID, why don\'t we have one?');

        Set<Id> myIds = new Set<Id>{caseId.Id};

        Test.startTest();
        TestUtils.enable_isRunningTest = true;

        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator(new Set<String>{'creditLensGetEntity','creditLensEditEntity','creditLensAuthLogin'}));
        for (Id id : myIds) {
            CreditWS_CreditLens.creditLensCreateEntityButton(id);
        }

        Test.stopTest();

        Case casePostUpdate = [SELECT Id, Entity_ID__c, On_List__c, Credit_Lens_Response__c FROM Case WHERE Entity_ID__c = '123' LIMIT 1];
        System.debug('In test casePostUpdate.Credit_Lens_Response__c: ' + casePostUpdate.Credit_Lens_Response__c);
        System.assert(casePostUpdate.Credit_Lens_Response__c.equalsIgnoreCase('Entity 123 updated in Credit Lens!'), 'Expected a credit lens response.');
    }

    /**
    * Positive Entity creation for Corporate Payments
    */
    public static void creditLensCreateEntityPositiveCPTest() {

        CP_Application_Request__c cpAppNoEntityId = [
                SELECT  Id, Name, Company_Legal_Name__c, Doing_Business_As__c, Physical_Country__c, Physical_Address_Line_1__c, Physical_City__c, Physical_State_Province__c, Physical_Postal_Code__c, SIC_Code__c,
                        Legal_Structure__c, CurrencyIsoCode, Taxpayer_ID__c, DNB_Resolved_DUNS__c, Stock_Symbol__c, Stock_Exchange__c, CreditLens_EntityID__c, Opportunity__r.OwnerId, Risk_Grade__c
                FROM CP_Application_Request__c
                WHERE Company_Legal_Name__c = 'Amazing Company 2' AND CreditLens_EntityID__c = NULL
                LIMIT 1];

        //sanity checks before we start testing
        System.assert(cpAppNoEntityId.CreditLens_EntityID__c == null, 'Expected Credit Lens Entity ID field to be null.');

        Set<Id> myIds = new Set<Id>{cpAppNoEntityId.Id};

        //to the test mobile!
        Test.startTest();
        TestUtils.enable_isRunningTest = true;

        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator(new Set<String>{'creditLensCreateGood','creditLensAuthLogin'}));
        for (Id id : myIds) {
            CreditWS_CreditLens.creditLensCreateEntityButton(id);
        }

        Test.stopTest();

        CP_Application_Request__c cpAppNewEntId = [
                SELECT  Id, CreditLens_EntityID__c
                FROM CP_Application_Request__c
                WHERE Id =: cpAppNoEntityId.Id
                LIMIT 1];

        System.assert(cpAppNewEntId.CreditLens_EntityID__c != null, 'Expected a credit lens entity ID, why don\'t we have one?');

    }

    /**
    * Negative Entity creation for CP. Missing required field.
    */
    public static void createLensCreateEntityNegativeTest() {

        CP_Application_Request__c cpAppNoEntityId = [
                SELECT  Id, Name, Company_Legal_Name__c, Doing_Business_As__c, Physical_Country__c, Physical_Address_Line_1__c, Physical_City__c, Physical_State_Province__c, Physical_Postal_Code__c, SIC_Code__c,
                        Legal_Structure__c, CurrencyIsoCode, Taxpayer_ID__c, DNB_Resolved_DUNS__c, Stock_Symbol__c, Stock_Exchange__c, CreditLens_EntityID__c, Opportunity__r.OwnerId, Risk_Grade__c
                FROM CP_Application_Request__c
                WHERE Company_Legal_Name__c = 'Amazing Company 2' AND CreditLens_EntityID__c = NULL
                LIMIT 1];

        //sanity checks before we start testing
        System.assert(cpAppNoEntityId.CreditLens_EntityID__c == null, 'Expected Credit Lens Entity ID field to be null.');

        Set<Id> myIds = new Set<Id>{cpAppNoEntityId.Id};

        //to the test mobile!
        Test.startTest();
        TestUtils.enable_isRunningTest = true;

        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator(new Set<String>{'creditLensCreateBad','creditLensAuthLogin'}));
        for (Id id : myIds) {
            CreditWS_CreditLens.creditLensCreateEntityButton(id);
        }

        Test.stopTest();

        CP_Application_Request__c cpAppNewEntId = [
                SELECT  Id, CreditLens_EntityID__c, Credit_Lens_Response__c
                FROM CP_Application_Request__c
                WHERE Id =: cpAppNoEntityId.Id
                LIMIT 1];

        System.assert(cpAppNewEntId.CreditLens_EntityID__c == null, 'Expected credit lens entity ID to be null, you failed to fail?');
        System.assert(cpAppNewEntId.Credit_Lens_Response__c.equalsIgnoreCase('Error creating entity in Credit Lens: Expected List<CreditWS_CLCreateEntityResponse.PayLoad> but found { at [line:1, column:6] Error: {    "payLoad": {        "_validationErrors": [            {                "Error_": "Entity.required.viewModel.EntityEdit.BillingCycle",                "ModelId_": "Entity"            }        ]    },    "status": {        "error": [            {                "ResourceId": "Core.message.validation.errors"            }        ]    }}'), 'Expected error message for missing required field');
    }

    /**
    * Positive Entity creation for NA Fleet
    */
    public static void creditLensCreateEntityPositiveNATest() {

        Application_Request__c naAppNoEntityId = [
                SELECT  Id, Name, Opportunity_Name_Text__c, Doing_Business_As__c, Physical_Country__c, Physical_Street__c, Physical_Street_Line_2__c, Physical_City__c, Physical_State__c, Physical_Zip_Postal_Code__c, SIC_Code__c,
                        Legal_Structure__c, CurrencyIsoCode, Tax_Payer_ID_number__c, DNB_Resolved_DUNS__c, Stock_Symbol__c, Stock_Exchange__c, Credit_Lens_Entity_ID__c, Opportunity__r.OwnerId, Risk_Grade__c
                FROM Application_Request__c
                WHERE Stock_Symbol__c = 'NYC' AND Credit_Lens_Entity_ID__c = NULL
                LIMIT 1];

        //sanity checks before we start testing
        System.assert(naAppNoEntityId.Credit_Lens_Entity_ID__c == null, 'Expected Credit Lens Entity ID field to be null.');

        Set<Id> myIds = new Set<Id>{naAppNoEntityId.Id};

        //to the test mobile!
        Test.startTest();
        TestUtils.enable_isRunningTest = true;

        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator(new Set<String>{'creditLensCreateGood','creditLensAuthLogin'}));
        for (Id id : myIds) {
            CreditWS_CreditLens.creditLensCreateEntityButton(id);
        }

        Test.stopTest();

        Application_Request__c naAppNewEntId = [
                SELECT  Id, Credit_Lens_Entity_ID__c
                FROM Application_Request__c
                WHERE Id =: naAppNoEntityId.Id
                LIMIT 1];

        System.assert(naAppNewEntId.Credit_Lens_Entity_ID__c != null, 'Expected a credit lens entity ID, why don\'t we have one?');

    }


    /**
   * Positive Entity creation for OTR
   */
    public static void creditLensCreateEntityPositiveOTRTest() {

        OnlineApplication__c otrAppNoEntityId = [
                SELECT  Id, Name, Legal_Business_Name__c, Trade_Name__c, Country__c, Business_Street_Address__c, Business_Address_Line_2__c, City__c, State__c, Zip_Code__c, SIC_Code__c,
                        Type_of_Business__c, CurrencyIsoCode, Federal_Tax_ID__c, DNB_Resolved_DUNS__c, Stock_Symbol__c, Stock_Exchange__c, Credit_Lens_Entity_ID__c, Opportunity__r.OwnerId, Risk_Grade__c
                FROM OnlineApplication__c
                WHERE Stock_Symbol__c = 'NYC' AND Credit_Lens_Entity_ID__c = NULL
                LIMIT 1];

        //sanity checks before we start testing
        System.assert(otrAppNoEntityId.Credit_Lens_Entity_ID__c == null, 'Expected Credit Lens Entity ID field to be null.');

        Set<Id> myIds = new Set<Id>{
                otrAppNoEntityId.Id};

        //to the test mobile!
        Test.startTest();
        TestUtils.enable_isRunningTest = true;

        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator(new Set<String>{'creditLensCreateGood','creditLensAuthLogin'}));
        for (Id id : myIds) {
            CreditWS_CreditLens.creditLensCreateEntityButton(id);
        }

        Test.stopTest();

        OnlineApplication__c naAppNewEntId = [
                SELECT  Id, Credit_Lens_Entity_ID__c
                FROM OnlineApplication__c
                WHERE Id =: otrAppNoEntityId.Id
                LIMIT 1];

        System.assert(naAppNewEntId.Credit_Lens_Entity_ID__c != null, 'Expected a credit lens entity ID, why don\'t we have one?');

    }

    public static void creditLensUploadDocumentTest() {

        CP_Application_Request__c cpApp = [
                SELECT  Id, Name, Company_Legal_Name__c, Doing_Business_As__c, Physical_Country__c, Physical_Address_Line_1__c, Physical_City__c, Physical_State_Province__c, Physical_Postal_Code__c, SIC_Code__c,
                        Legal_Structure__c, CurrencyIsoCode, Taxpayer_ID__c, DNB_Resolved_DUNS__c, Stock_Symbol__c, Stock_Exchange__c, CreditLens_EntityID__c, Opportunity__r.OwnerId
                FROM CP_Application_Request__c
                WHERE Company_Legal_Name__c = 'Amazing Company 1' AND CreditLens_EntityID__c != NULL
                LIMIT 1];

        //sanity checks before we start testing
        System.assert(cpApp != null, 'Expected an app with an entity Id, didn\'t find one');

        Attachment selectedFile = [SELECT Id, Name, Body, ParentId, ContentType FROM Attachment WHERE Name =: 'TestFinancials.txt' LIMIT 1];
        selectedFile.ContentType = 'TEXT';

        Test.startTest();

        PageReference uploadDocumetPage = Page.UploadDocToCreditLensCP;
        uploadDocumetPage.getParameters().put('id', cpApp.Id);
        Test.setCurrentPage(uploadDocumetPage);

        UploadDocToCreditLensController uploadDocController = new UploadDocToCreditLensController();
        uploadDocController.setSelectedFile(selectedFile.Id);
        uploadDocController.init();

        System.assert(uploadDocController.appId.equals(cpApp.Id));

        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator('creditLensUploadDoc'));

        PageReference uploadPageReference = uploadDocController.uploadDocuments();

        System.assert(uploadPageReference.getParameters().get('errorMessage') == null, 'Received an error message while uploading document.');

        Test.stopTest();

    }

    public static void creditLensLinkDocToEntityTest() {

        CP_Application_Request__c cpApp = [
                SELECT  Id, Name, Company_Legal_Name__c, Doing_Business_As__c, Physical_Country__c, Physical_Address_Line_1__c, Physical_City__c, Physical_State_Province__c, Physical_Postal_Code__c, SIC_Code__c,
                        Legal_Structure__c, CurrencyIsoCode, Taxpayer_ID__c, DNB_Resolved_DUNS__c, Stock_Symbol__c, Stock_Exchange__c, CreditLens_EntityID__c, Opportunity__r.OwnerId
                FROM CP_Application_Request__c
                WHERE Company_Legal_Name__c = 'Amazing Company 1' AND CreditLens_EntityID__c != NULL
                LIMIT 1];

        //sanity checks before we start testing
        System.assert(cpApp != null, 'Expected an app with an entity Id, didn\'t find one');

        List<String> docIds = new List<String>();
        String docId = '7c81409d-e093-4bfc-9e87-b2aec8d0d2bc';
        docIds.add(docId);

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator('creditLensLinkDocToEntity'));

        Boolean success = CreditWS_CreditLens.linkDocToEntity(cpApp.Id, docIds, (cpApp.Id).getSobjectType().getDescribe().getName());

        System.assert(success, 'Expected great success and only received failure.');

        Test.stopTest();
    }

}