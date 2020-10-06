@isTest
private class CampaignProgramcStatsTriggerTest {

    static testMethod void testTrigger() {
        //   try {
        //       Campaign_Program__c o = new Campaign_Program__c();
        //       insert o;

        //       System.assertNotEquals(null, o);
        //   }
        //   catch(Exception e) {
        //       List<Campaign_Program__c> l = [SELECT Id from Campaign_Program__c LIMIT 1];
        //       update l;
        //       System.assertNotEquals(null, l);
        //   }

        UtilityTestLoader.setAutomation(false);

        Partner__c part1 = new Partner__c(Name = 'partner1');
        insert part1;

        Program__c program1 = new Program__c();
        program1.Name = 'test prog1' ;
        program1.Brand_Short_Name__c = 'test1';
        program1.Partner__c = part1.Id;

        insert program1;

        Campaign campaign = new Campaign();
        campaign.Coupon_Code__c = 'TEST1';
        campaign.Name = 'TestCampaign';
        campaign.Type = 'Online Form';
        campaign.Status = 'In Progress';
        campaign.Drop_Date__c = date.today();
        campaign.EndDate = date.today();
        campaign.CurrencyIsoCode = 'USD';
        campaign.IsActive = true;

        insert campaign;

        Campaign_Program__c campaignProgram1 = new Campaign_Program__c();
        campaignProgram1.Name = 'test campaign program1';
        campaignProgram1.Campaign__c = campaign.Id;
        campaignProgram1.Program__c = program1.Id;
        campaignProgram1.Terms_and_Conditions__c = 'Test T&C';
        campaignProgram1.Default__c = true;

        insert campaignProgram1;

        List<Campaign_Program__c> cpList = [SELECT Id FROM Campaign_Program__c WHERE Id =: campaignProgram1.Id];

        System.assertEquals(1, cpList.size());

        campaignProgram1.Name = 'test campaign program2';
        update campaignProgram1;

        cpList = [SELECT Id FROM Campaign_Program__c WHERE Name = 'test campaign program2'];

        System.assertEquals(1, cpList.size());
    }
}