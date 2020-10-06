@isTest
public with sharing class WEXCTIAdapterControllerTest {

    @testSetup
    static void setupTest() {

        UtilityTestLoader.setAutomation(false);
        
        Profile profile = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];

        insert new User(
                isActive = true,
                profileId = profile.Id,
                alias = 'ctite',
                firstName = 'CTI',
                lastName = 'Tester',
                email = 'ctitest@wexinc.com',
                username = 'ctitest@wexinc.com',
                emailEncodingKey = 'UTF-8',
                languageLocaleKey = 'en_US',
                localeSidKey = 'en_US',
                timeZoneSidKey = 'America/Los_Angeles',
                country = 'United States',
                ACD_Id__c = 'test2'
        );
     
        insert new Customer_Dashboard_Services__c(Customer_Details_EndPoint__c = 'http://test.wexlocal.com', API_Timeout_ms__c = 20000);

        if (profile != null && profile.Id != null) {
            
            insert new CTI_POP_Settings__c(SetupOwnerId = profile.Id, Gadget_Enabled__c = false);

        }

    }

    static testMethod void testWEXCTIAdapterController() {

        Test.startTest();

        TestUtils.enable_isRunningTest = true;

        Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());

        User runAsUser = [SELECT Id, ACD_Id__c FROM User WHERE Alias = 'ctite'];

        System.runAs(runAsUser) {

            WEXCTIAdapterController.CustomerSearchResult customerDetails = WEXCTIAdapterController.accountAndContactSearch('9100000000000', null, '1234567890');

            System.assertEquals('9100000000000', customerDetails.wexAccountNumber);
            
            customerDetails = WEXCTIAdapterController.accountAndContactSearch(null, null, '1234567890');
            
            System.assertEquals(customerDetails.companyName, 'Test');

            User ctiUser = WEXCTIAdapterController.getUserInformation();

            System.assert(ctiUser.ACD_Id__c == runAsUser.ACD_Id__c);
            
            CTI_POP_Settings__c ctiPopSettings = WEXCTIAdapterController.getCTIPOPSettings();
            
            System.assertEquals(ctiPopSettings.Gadget_Enabled__c, false);

        }

        Test.stopTest();

    }

}