@isTest(seeAllData=true)
private class DiscountSchedulePrintControllerShellTest {
    static testmethod void testController() {
        Account a  = new Account(Name = 'Test Account');
        insert a;

        List<Product2> prods = new List<Product2>();
        prods.add(new Product2(Name = 'Asset 1', IsActive = true, SBQQ__SubscriptionType__c = 'One-time'));
        insert prods;


        Opportunity opp = new Opportunity(AccountId = a.Id, StageName = '2 - Quotation',
                Name = 'Test Opportunity', CloseDate = Date.today());
        insert opp;

        // SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = opp.Id,
        //         SBQQ__SubscriptionTerm__c = 12, SBQQ__Account__c = a.Id, SBQQ__Primary__c = true);
        // insert quote;
        SBQQ__Quote__c quote = [select id from SBQQ__Quote__c limit 1];

        SBQQ__DiscountSchedule__c sched = new SBQQ__DiscountSchedule__c();
        sched.Name = 'test';
        insert sched;

        SBQQ__DiscountTier__c tier = new SBQQ__DiscountTier__c();
        tier.Name = 'Tier1';
        tier.SBQQ__Schedule__c = sched.Id;
        tier.SBQQ__LowerBound__c = 10000;
        tier.SBQQ__UpperBound__c = 20000;
        tier.SBQQ__Discount__c = 5;
        tier.Basis_Points__c = 15;
        insert tier;

        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
        quoteLines.add(new SBQQ__QuoteLine__c(sbqq__discountschedule__c=sched.Id, SBQQ__Quote__c = quote.Id, SBQQ__Product__c = prods[0].Id, SBQQ__Quantity__c = 1, SBQQ__NetPrice__c = 100));
        insert quoteLines;

        PageReference pageRef = Page.DiscountSchedulePrint;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('qid', quote.Id);

        Test.startTest();
        DiscountSchedulePrintController ctl = new DiscountSchedulePrintController();
        Test.stopTest();

        System.assertEquals(1, ctl.linesWithTiers.size());
    }
}