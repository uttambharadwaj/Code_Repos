/**
 * Created by lhowland on 6/5/2020.
 */
@IsTest
public with sharing class CreditWS_GiactTest {

    public static void giactVerify() {

        CP_Application_Request__c cpApp = [
                SELECT  Id, Name, Company_Legal_Name__c, Physical_Country__c, ABA_Routing_Number__c, Checking_Account_Number__c, Taxpayer_ID__c,
                        Guarantor_Social_Security_Number__c, Guarantor_First_Name__c, Guarantor_Last_Name__c
                FROM CP_Application_Request__c
                WHERE Company_Legal_Name__c = 'Amazing Company 2'
                LIMIT 1];

        //sanity checks before we start testing
        System.assert(cpApp.Checking_Account_Number__c == '390032794', 'Expected checking account number to be 390032794.');

        Set<Id> myIds = new Set<Id>{
                cpApp.Id};

        //to the test mobile!
        Test.startTest();
        TestUtils.enable_isRunningTest = true;

        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator(new Set<String>{'giactVerify'}));

        CreditWS_Giact.GiactVerifyRequest giactVerifyRequest = new CreditWS_Giact.GiactVerifyRequest();

        giactVerifyRequest.UniqueId = String.valueOf(cpApp.Id);
        giactVerifyRequest.RoutingNumber = cpApp.ABA_Routing_Number__c;
        giactVerifyRequest.AccountNumber = cpApp.Checking_Account_Number__c;
        giactVerifyRequest.BusinessName = String.escapeSingleQuotes(cpApp.Company_Legal_Name__c);
        giactVerifyRequest.FederalTaxId = cpApp.Taxpayer_ID__c;

        CreditWS_Giact.GiactVerifyResponse giactVerifyResponse = CreditWS_Giact.giactVerify(giactVerifyRequest);

        Test.stopTest();

        System.assert(giactVerifyResponse.AccountResponseCode != null, 'Expected a response from GIACT.');

    }
}