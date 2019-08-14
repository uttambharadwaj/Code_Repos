@isTest
private class WE_ScheduledCloseDateUpdateTest {

    @testSetup
    static void dataSetup() {

        // create User
        User u = WE_TestDataUtility.createStandardUser();

        System.runas(u) {

            VRTN__c rtCS = WE_TestDataUtility.createRecTypeNameCustSett(
                'CP Virtual Prepaid MC',  // rtName
                'NAEU Opps');             // csField
            insert rtCS;

            /**
             * !!! delete once Budget Manager Custom Setting can be used to disable code
            **/
            VProfileId__c profCS = WE_TestDataUtility.createProfileIdCustSett(
                u.Id,					// user Id
                'Profile',              // locationRef
                'EuNaSalesRm Profile',  // fieldRef
                true);                  // settingStatus
            insert profCS;

            rtCS.Product_Name__c = 'Virtual Prepaid MasterCard';
            update rtCS;
            profCS.Team_Name__c = 'Virtual Admin';
            update profCS;

            // create Budgets
            List<Budget__c> budgets = new List<Budget__c>();

            for(integer i = 0; i < 17; i++) {
                budgets.add(new Budget__c(
                    Name = 'Test Budget ' + i,
                    Date__c = date.today().addMonths(i),
                    Team__c = 'Virtual Admin',
                    Budget__c = 1));
            }
            insert budgets;
            /**
             * end of temporary section
             **/

            // create Targets

            List<Target__c> targetsToInsert = new List<Target__c>();

            targetsToInsert.addAll(WE_TestDataUtility.createTargets(
                3,                                  // noMonths
                u.Id,                               // salespersonId
                date.today().year(),           // firstYear
                date.today().month(),          // firstMonth
                'Virtual Sales EU',                 // team
                'Close Date',                       // dateType
                100000));                            // target

            targetsToInsert.addAll(WE_TestDataUtility.createTargets(
                1,                                  // noMonths
                u.Id,                               // salespersonId
                date.today().year(),           // firstYear
                date.today().month(),          // firstMonth
                'Virtual Sales EU',                 // team
                'Created Date',                       // dateType
                100000));                            // target

            insert targetsToInsert;

            List<Opportunity> testOpps = new List<Opportunity>();

            testOpps.addAll(WE_TestDataUtility.createOpportunities(
                'EU Opps',            // oppRef
                1,                      // noOpps
                'CP Virtual Prepaid MC',      // recordTypeName
                'Update <*>',                  // identifier
                '1) Suspect',                // stageName
                date.today().addDays(3),      // closeDate
                'Standard',                  // rampProfile
                100.00));                  // settlement

            testOpps.addAll(WE_TestDataUtility.createOpportunities(
                'EU Opps',            // oppRef
                1,                      // noOpps
                'CP Virtual Prepaid MC',      // recordTypeName
                'Skip <*>',                  // identifier
                '1) Suspect',                // stageName
                date.today().addDays(8),      // closeDate
                'Standard',                  // rampProfile
                100.00));                  // settlement

            List<Opportunity> opps = (WE_TestDataUtility.createOpportunities(
                'EU Opps',            // oppRef
                1,                      // noOpps
                'CP Virtual Prepaid MC',      // recordTypeName
                'Skip1 <*>',                  // identifier
                '1) Suspect',                // stageName
                date.today().addDays(3),      // closeDate
                'Standard',                  // rampProfile
                100.00));                  // settlement

            for(Opportunity o : opps) {
                o.Probability = 100;
            }
            testOpps.addAll(opps);

            insert testOpps;

/*        don't set stage name to Signed, to avoid validation rules, insert of Currency Detail records uses more SOQL queries

        for(Opportunity o : opps) {
          o.StageName = '5) Signed';
                    insert new Currency_Detail__c(
                        Opportunity__c = o.Id,
                        CurrencyISOCode = 'GBP',
                        Of_Total_Spend__c = 100);
        }
        update opps;
*/
        }

    }

    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    static testmethod void test() {

        Test.startTest();

        String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP,
                        new WE_ScheduledCloseDateUpdate());

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                            FROM CronTrigger WHERE id = :jobId];

        System.assertEquals(CRON_EXP, ct.CronExpression);

        System.assertEquals(0, ct.TimesTriggered);

        System.assertEquals('2022-03-15 00:00:00',
         String.valueOf(ct.NextFireTime));

        Test.stopTest();

        Integer updateCount = 0;
        Integer skipCount   = 0;
        Integer skip1Count   = 0;

        List <Opportunity> opportunitys = [SELECT Id, Name, CloseDate FROM Opportunity WHERE Name LIKE '%<*>%'];

        // make sure that code set's the Custom Setting field to true
        Id profileId = userinfo.getProfileId();
        VProfileId__c profileSetting = VProfileId__c.getInstance(profileId);
        profileSetting.Virtual_EU_NA_Sales_RM__c = false;
        upsert profileSetting;

        for(Opportunity o : opportunitys) {
            if (o.Name.contains('Update <*>') &&
                updateCount == 0)
            {
                system.assertEquals(date.today().addDays(20), o.CloseDate, 'Opportunity\'s Close Date should have been updated as it was less than 7 days away');
                updateCount = 1;
            }
            if (o.Name.contains('Skip <*>') &&
                skipCount == 0)
            {
                //system.assertEquals(date.today().addDays(8), o.CloseDate, 'Opportunity should not have been updated as it\'s Close Date is more than 7 days away');
                skipCount = 1;
            }
            if (o.Name.contains('Skip1 <*>') &&
                skip1Count == 0)
            {
                //system.assertEquals(date.today().addDays(3), o.CloseDate, 'Opportunity should not have been updated as it\'s Probability is 100 - they\'re closed');
                skip1Count = 1;
            }
        }
        system.assertEquals(3, updateCount + skipCount + skip1Count, 'Count should be 3 once all assertions have been executed');

    }

}