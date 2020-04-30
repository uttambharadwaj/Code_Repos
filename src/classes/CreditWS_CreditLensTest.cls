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
        Credit_Decision_Engine_Endpoints__mdt CLCreateEntitySettings = CreditWS_CreditLens.CLCreateEntitySettings;
        Moodys_CreditLens_Mapping__mdt CLStockExchange = CreditWS_CreditLens.CLStockExchange('NASDAQ');

        //Metadata Asserts
        System.assert(CLStockExchange != null, 'Expected CLStockExchange Metadata, but didn\'t find any');
        System.assert(CLAuthSettings != null, 'Expected CLAuthSettings Metadata, but didn\'t find any');
        System.assert(CLCreateEntitySettings != null, 'Expected CLCreateEntitySettings Metadata, but didn\'t find any');

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator(new Set<String>{'creditLensAuthGood','creditLensAuthLogin'})); //set mock
        String token = CreditWS_CreditLens.creditLensAuthentication();
        Test.stopTest();

        //Callout Asserts
        System.assert(token != null, 'Expected token to be returned.');
    }

    /**
    * Positive Entity creation for Corporate Payments
    */
    public static void creditLensCreateEntityPostiveCPTest() {

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

        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator(new Set<String>{'creditLensCreateGood','creditLensAuthLogin'})); //set mock
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
    * Positive Entity creation for NA Fleet
    */
    public static void creditLensCreateEntityPostiveNATest() {

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

        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator(new Set<String>{'creditLensCreateGood','creditLensAuthLogin'})); //set mock
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

        PageReference uploadDocumetPage = Page.UploadDocToCreditLens;
        uploadDocumetPage.getParameters().put('id', cpApp.Id);
        Test.setCurrentPage(uploadDocumetPage);

        UploadDocToCreditLensController uploadDocController = new UploadDocToCreditLensController();
        uploadDocController.setSelectedFile(selectedFile.Id);
        uploadDocController.init();

        System.assert(uploadDocController.appId.equals(cpApp.Id));

        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator('creditLensUploadDoc')); //set mock

        //todo assert something from the response

        uploadDocController.uploadDocuments();

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

        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator('creditLensLinkDocToEntity')); //set mock

        //todo assert something from the response

        CreditWS_CreditLens.linkDocToEntity(cpApp.Id, docIds);

        Test.stopTest();

    }


}