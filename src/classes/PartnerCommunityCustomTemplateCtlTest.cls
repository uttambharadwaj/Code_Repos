@isTest
private class PartnerCommunityCustomTemplateCtlTest {
    static testmethod void testController() {
        PartnersCommunityLogos__c settings = new PartnersCommunityLogos__c();
        settings.SetupOwnerId = UserInfo.getProfileId();
        settings.FileName__c = 'test.png';
        insert settings;

        Test.startTest();
        String logo = PartnerCommunityCustomTemplateController.getLogoServ();
        Test.stopTest();
        
        System.assertEquals('test.png', logo);
    }
}