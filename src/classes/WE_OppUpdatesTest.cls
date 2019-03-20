@isTest
public class WE_OppUpdatesTest{

    @testSetup
    static void dataSetup() {

        User u = WE_TestDataUtility.createStandardUser();

        System.runas(u){

            VApexC__c acCS = WE_TestDataUtility.createApexControllerCustSett(
                'Opportunity MRF',  // fieldRef
                false);             // fcstDisabledStatus

            VRTN__c rtCS = WE_TestDataUtility.createRecTypeNameCustSett(
                'CP Virtual Prepaid MC',  // rtName
                'NAEU Opps');             // csField
            insert rtCS;

            /**
             * !!! delete once Budget Manager Custom Setting can be used to disable code
            **/
            VProfileId__c profCS = WE_TestDataUtility.createProfileIdCustSett(
                u.Id,
                'Profile',              // locationRef
                'EuNaSalesRm Profile',  // fieldRef
                true);                  // settingStatus
            insert profCS;

            profCS.Team_Name__c = 'Virtual Admin';
            update profCS;
            rtCS.Product_Name__c = 'Virtual Prepaid MasterCard';
            update rtCS;

            // create Budgets
            List<Budget__c> budgets = new List<Budget__c>();

            for(integer i = 0; i < 30; i++) {
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
            List<Target__c> targets1 = WE_TestDataUtility.createTargets(
                2,                                  // noMonths
                u.Id,                               // salespersonId
                date.today().addMonths(1).year(),   // firstYear
                date.today().addMonths(1).month(),  // firstMonth
                'Virtual Sales EU',                 // team
                'Close Date',                       // dateType
                100000);                            // target
            insert targets1;

            List<Target__c> targets2 = WE_TestDataUtility.createTargets(
                1,                                              // noMonths
                u.Id,                                            // salespersonId
                date.today().addMonths(1).addYears(1).year(),   // firstYear
                date.today().addMonths(1).month(),              // firstMonth
                'Virtual Sales EU',                             // team
                'Close Date',                                   // dateType
                100000);                                        // target
            insert targets2;

            List<Opportunity> oppsToInsert = new List<Opportunity>();

            List<Opportunity> opportunities1 = WE_TestDataUtility.createOpportunities(
                'EU Opps',                          // oppRef
                1,                                 // noOpps
                'CP Virtual Prepaid MC',            // recordTypeName
                'id1',                              // identifier
                '1) Suspect',                       // stageName
                date.today().addMonths(1),          // closeDate
                'Standard',                         // rampProfile
                100.00);                            // settlement

            for(Opportunity o : opportunities1) {
                oppsToInsert.add(o);
            }

            List<Opportunity> opportunities2 = WE_TestDataUtility.createOpportunities(
                'EU Opps',                          // oppRef
                1,                                 // noOpps
                'CP Virtual Prepaid MC',            // recordTypeName
                'id2',                              // identifier
                '1) Suspect',                       // stageName
                date.today().addmonths(1),          // closeDate
                'Medium',                           // rampProfile
                100.00);                            // settlement

            for(Opportunity o : opportunities2) {
                oppsToInsert.add(o);
            }

            List<Opportunity> opportunities3 = WE_TestDataUtility.createOpportunities(
                'EU Opps',                          // oppRef
                1,                                 // noOpps
                'CP Virtual Prepaid MC',            // recordTypeName
                'id3',                              // identifier
                '1) Suspect',                       // stageName
                date.today().addmonths(1),          // closeDate
                'Extended',                         // rampProfile
                100.00);                            // settlement

            for(Opportunity o : opportunities3) {
                oppsToInsert.add(o);
            }
            insert oppsToInsert;

        }// runas
    }// @testSetup


    static testMethod void testOppInserts() {

        User u = [SELECT Id FROM User WHERE Username = 'astest@wexeurope.com'];

        System.runAs(u){

            // TEST INSERTS
            test.startTest();

            List<Opportunity> oppsToInsert = new List<Opportunity>();

            // insert new Opportunities with Immediate Ramp Profile
            // !!! console code coverage error prevents first Ramp Profile showing as true in test?
            List<Opportunity> opportunities0 = WE_TestDataUtility.createOpportunities(
            'EU Opps',                          // oppRef
            1,                                 // noOpps
            'CP Virtual Prepaid MC',            // recordTypeName
            'noId',                             // identifier
            '1) Suspect',                       // stageName
            date.today().addMonths(1),          // closeDate
            'Immediate',                        // rampProfile
            100.00);                            // settlement

            for(Opportunity o : opportunities0) {
                oppsToInsert.add(o);
            }

            // insert new Opportunities with Standard Ramp Profile
            List<Opportunity> opportunities1 = WE_TestDataUtility.createOpportunities(
            'EU Opps',                          // oppRef
            1,                                 // noOpps
            'CP Virtual Prepaid MC',            // recordTypeName
            'noId',                             // identifier
            '1) Suspect',                       // stageName
            date.today().addMonths(1),          // closeDate
            'Standard',                         // rampProfile
            100.00);                            // settlement

            for(Opportunity o : opportunities1) {
                oppsToInsert.add(o);
            }

            // insert new Opportunities with Medium Ramp Profile
            List<Opportunity> opportunities2 = WE_TestDataUtility.createOpportunities(
            'EU Opps',                          // oppRef
            1,                                 // noOpps
            'CP Virtual Prepaid MC',            // recordTypeName
            'noId',                             // identifier
            '1) Suspect',                       // stageName
            date.today().addMonths(1),          // closeDate
            'Medium',                           // rampProfile
            100.00);                            // settlement

            for(Opportunity o : opportunities2) {
                oppsToInsert.add(o);
            }

            // insert new Opportunities with Extended Ramp Profile
            List<Opportunity> opportunities3 = WE_TestDataUtility.createOpportunities(
            'EU Opps',                          // oppRef
            1,                                 // noOpps
            'CP Virtual Prepaid MC',            // recordTypeName
            'noId',                             // identifier
            '1) Suspect',                       // stageName
            date.today().addMonths(1),          // closeDate
            'Extended',                         // rampProfile
            100.00);                            // settlement

            for(Opportunity o : opportunities3) {
                oppsToInsert.add(o);
            }
            insert oppsToInsert;

            test.stopTest();

        }
    }// test method

    static testMethod void testOppUpdates() {

        List <Opportunity> opportunities = [SELECT Id,RecordTypeId,Name,CloseDate,Ramp_Profile__c FROM Opportunity WHERE Name LIKE '%id1%'];
        User u = [SELECT Id FROM User WHERE Username = 'astest@wexeurope.com'];

        // TEST UPDATES
        System.runAs(u){
            test.startTest();

            for(Opportunity o : opportunities){
                // test change of Close Date month
                o.CloseDate = o.CloseDate.addmonths(1);
                // test change of Ramp Profile
                o.Ramp_Profile__c = 'Immediate';
                // test change of Implementation Completion Month
                o.Implementation_Revenue__c = o.CloseDate.addMonths(2);
            }
            update opportunities;

            for(Opportunity o : opportunities) {
                // test change of Ramp Profile
                o.Ramp_Profile__c = 'Medium';
            }
            update opportunities;

            for(Opportunity o : opportunities) {
                // test change of Ramp Profile
                o.Ramp_Profile__c = 'Extended';
            }
            update opportunities;
            test.stopTest();
        }
    }// test method

}