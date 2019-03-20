@isTest
private class Test_PartnersHomePageComponents {
	
	@isTest static void testCommonReports() {
		

		CommHomePageSettings__c ch = new CommHomePageSettings__c();
		ch.common_reports_title__c='test';
        ch.common_reports_height__c=200;
        ch.common_reports_width__c=200;
        insert ch;

        CommonReports__c cr = new CommonReports__c();
        cr.Active__c = true;
        cr.name = 'test';
        cr.Report_Title__c = 'test';
        cr.Report_URL__c = 'www.yahoo.com';
        cr.Sort__c = 1;
        insert cr;

        test.starttest();
        CommonReportsController crc = new CommonReportsController();
        test.stoptest();

	}
	
	@isTest static void testTopOpportunities() {
		

		CommHomePageSettings__c ch = new CommHomePageSettings__c();
		ch.name='test';
		ch.top_opportunities_title__c = 'test';
        ch.top_opportunities_height__c = 200;
        ch.top_opportunities_width__c=200;
        insert ch;

        List<Account> a = UTestData.getAccounts(1);
        insert a;

        Opportunity o = UTestData.getOpportunities(a)[0];
        insert o;

        TopOpportunities__c topp = new TopOpportunities__c();
        topp.name = 'test';
        topp.Opportunity_Id__c = o.Id;
        topp.Sort__c = 1;
        insert topp;

        test.starttest();

        TopOpportunityController topc = new TopOpportunityController();

        test.stoptest();




	}
	
}