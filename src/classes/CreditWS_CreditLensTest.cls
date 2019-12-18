/**
 * Created by mfarrell on 2019-12-13.
 */
@IsTest
public class CreditWS_CreditLensTest {

    //
    // Positive Tests
    //
    public static void creditLensAuthenticationPositiveTest() {

        Credit_Decision_Engine_Endpoints__mdt CLAuthSettings = CreditWS_CreditLens.CLAuthSettings;
        Credit_Decision_Engine_Endpoints__mdt CLCreateEntitySettings = CreditWS_CreditLens.CLCreateEntitySettings;
        Moodys_CreditLens_Mapping__mdt CLStockExchange = CreditWS_CreditLens.CLStockExchange('NASDAQ');

        //Metadata Asserts
        System.assert(CLStockExchange != null, 'Expected CLStockExchange Metadata, but didn\'t find any');
        System.assert(CLAuthSettings != null, 'Expected CLAuthSettings Metadata, but didn\'t find any');
        System.assert(CLCreateEntitySettings != null, 'Expected CLCreateEntitySettings Metadata, but didn\'t find any');

        Test.startTest();
        //TODO: not receiving a response in the mock, need to fix.
        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator(new Set<String>{'creditLensAuthGood','creditLensAuthLogin'})); //set mock
        CreditWS_CreditLens.creditLensAuthentication();
        Test.stopTest();

        //Callout Asserts
        //TODO: need asserts for response body!  I think just confirming a token is returned would work.

    }

    public static void creditLensCreateEntityPostiveTest() {

        CP_Application_Request__c cpAppWithEntityId = [
                SELECT  Id, Name, Company_Legal_Name__c, Doing_Business_As__c, Physical_Country__c, Physical_Address_Line_1__c, Physical_City__c, Physical_State_Province__c, Physical_Postal_Code__c, SIC_Code__c,
                        Legal_Structure__c, CurrencyIsoCode, Taxpayer_ID__c, DNB_Resolved_DUNS__c, Stock_Symbol__c, Stock_Exchange__c, CreditLens_EntityID__c, Opportunity__r.OwnerId
                FROM CP_Application_Request__c
                WHERE Company_Legal_Name__c = 'Amazing Company 1' AND CreditLens_EntityID__c != NULL
                LIMIT 1];

        CP_Application_Request__c cpAppNoEntityId = [
                SELECT  Id, Name, Company_Legal_Name__c, Doing_Business_As__c, Physical_Country__c, Physical_Address_Line_1__c, Physical_City__c, Physical_State_Province__c, Physical_Postal_Code__c, SIC_Code__c,
                        Legal_Structure__c, CurrencyIsoCode, Taxpayer_ID__c, DNB_Resolved_DUNS__c, Stock_Symbol__c, Stock_Exchange__c, CreditLens_EntityID__c, Opportunity__r.OwnerId
                FROM CP_Application_Request__c
                WHERE Company_Legal_Name__c = 'Amazing Company 2' AND CreditLens_EntityID__c = NULL
                LIMIT 1];

        //sanity checks before we start testing
        System.assert(cpAppNoEntityId != null, 'Expected an app without an entity Id, didn\'t find one');
        System.assert(cpAppWithEntityId != null, 'Expected an app with an entity Id, didn\'t find one');

        //set so we can pass multiple apps through the process.
        Set<Id> appIds = new Set<Id>{cpAppWithEntityId.Id, cpAppNoEntityId.Id};

        //to the test mobile!
        Test.startTest();

        //TODO: not receiving a response in the mock, need to fix.
        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator(new Set<String>{'creditLensCreateGood','creditLensCreateLogin'})); //set mock
        for(Id i : appIds) {
            CreditWS_CreditLens.creditLensCreateEntityButton(i);
        }

        Test.stopTest();

        CP_Application_Request__c cpAppNewEntId = [
                SELECT  Id, CreditLens_EntityID__c
                FROM CP_Application_Request__c
                WHERE Id =: cpAppNoEntityId.Id
                LIMIT 1];

        //TODO: after mock callout is down, make sure we get an entity id back.
        //System.assert(cpAppNewEntId.CreditLens_EntityID__c != null, 'Expected a credit lens entity ID, why don\'t we have one?');

    }


}