//revision history https://gist.github.com/aplssf/1ecf170c0393f9a10504/revisions
@isTest
public class WE_ProjxOppUpTest {
//
//        @testSetup
//        static void dataSetup() {
//
//            UtilityTestLoader.setAutomation(false);
//
//            // create User
//            User u = WE_TestDataUtility.createStandardUser();
//
//            System.runas(u) {
//
//                // create Custom Setting
//                List<VRTN__c> rtCsToInsert = new List<VRTN__c>();
//
//                rtCsToInsert.add(WE_TestDataUtility.createRecTypeNameCustSett(
//                    'CP Virtual Prepaid MC',  // rtName
//                    'EU Opps'));              // csField
//                rtCsToInsert.add(WE_TestDataUtility.createRecTypeNameCustSett(
//                    'MasterCard',             // rtName
//                    'NA Opps'));              // csField
//                insert rtCsToInsert;
//
//                /**
//                 * !!! delete once Budget Manager Custom Setting can be used to disable code
//                 **/
//                VProfileId__c profCS = WE_TestDataUtility.createProfileIdCustSett(
//                    u.Id,					// user Id
//                    'Profile',              // locationRef
//                    'EuNaSalesRm Profile',  // fieldRef
//                    true);                  // settingStatus
//                insert profCS;
//
//                profCS.Team_Name__c = 'Virtual Admin';
//                update profCS;
//
//                for(VRTN__c cs : rtCsToInsert) {
//                    if (cs.Name == 'CP Virtual Prepaid MC') {
//                        cs.NAEUOpps__c = 'CP Virtual Prepaid MC';
//                        cs.Product_Name__c = 'Virtual Prepaid MasterCard';
//                    }
//                    else if (cs.Name == 'MasterCard') {
//                        cs.NAEUOpps__c = 'MasterCard';
//                        cs.Product_Name__c = 'Virtual Credit MasterCard';
//                    }
//                }
//                update rtCsToInsert;
//
//                // create Budgets
//                List<Budget__c> budgets = new List<Budget__c>();
//
//                for(integer i = 0; i < 30; i++) {
//                    budgets.add(new Budget__c(
//                        Name = 'Test Budget ' + i,
//                        Date__c = date.today().addDays(90).addMonths(i),
//                        Team__c = 'Virtual Admin',
//                        Budget__c = 1));
//                }
//                for(integer i = 0; i < 30; i++) {
//                    budgets.add(new Budget__c(
//                        Name = 'Test Budget ' + i,
//                        Date__c = date.today().addDays(90).addMonths(i),
//                        Team__c = 'Virtual Admin',
//                        Budget__c = 1));
//                }
//                insert budgets;
//                /**
//                 * end of temporary section
//                 **/
//
//                //create Target records
//                List<Target__c> targetsToInsert = new List<Target__c>();
//
//                targetsToInsert.addAll(WE_TestDataUtility.createTargets(
//                5,                                  // noMonths
//                u.Id,                               // salespersonId
//                date.today().year(),                // firstYear
//                date.today().month(),               // firstMonth
//                'Virtual Sales EU',                 // team
//                'Close Date',                       // dateType
//                100000));                           // target
//
//                targetsToInsert.addAll(WE_TestDataUtility.createTargets(
//                1,                                  // noMonths
//                u.Id,                               // salespersonId
//                date.today().year(),                // firstYear
//                date.today().month(),               // firstMonth
//                'Virtual Sales EU',                 // team
//                'Created Date',                     // dateType
//                100000));                           // target
//
//                insert targetsToInsert;
//
//                List<MPM4_BASE__Milestone1_Project__c> testProjs = new List<MPM4_BASE__Milestone1_Project__c>();
//
//                for (Integer i = 0; i < 100; i++) {
//
//                    MPM4_BASE__Milestone1_Project__c p = new MPM4_BASE__Milestone1_Project__c();
//                    p.Name = 'Test Project <*>' + i;
//                    p.RecordTypeId = '012700000005wcK';
//                    p.OwnerId = u.Id;
//
//                    p.MPM4_BASE__Kickoff__c = date.newInstance(2015,02,1);
//                    p.MPM4_BASE__Deadline__c = date.newInstance(2015,08,1);
//
//                    testProjs.add(p);
//                }
//                insert testProjs;
//
//                List<Opportunity> testOpps = new List<Opportunity>();
//
//                testOpps.addAll(WE_TestDataUtility.createOpportunities(
//                    'EU Opps',                      // oppRef
//                    1,                             // noOpps
//                    'CP Virtual Prepaid MC',        // recordTypeName
//                    'EU <*>',                       // identifier
//                    '1) Qualified',                   // stageName
//                    date.today().addDays(3),        // closeDate
//                    'Standard',                     // rampProfile
//                    100.00));                       // settlement
//
//                testOpps.addAll(WE_TestDataUtility.createOpportunities(
//                    'NA Opps',                      // oppRef
//                    1,                             // noOpps
//                    'MasterCard',                   // recordTypeName
//                    'NA <*>',                       // identifier
//                    '1) Qualified',                   // stageName
//                    date.today().addDays(3),        // closeDate
//                    'Standard',                     // rampProfile
//                    100.00));                       // settlement
//
//                insert testOpps;
//
//                List<ProjectxOpp__c> testJuncs = new List<ProjectxOpp__c>();
//                Integer i = 0;
//
//                for(Opportunity o : testOpps) {
//                    ProjectxOpp__c j = new ProjectxOpp__c();
//                    j.Project__c = testProjs[i].Id;
//                    j.Opportunity__c = o.Id;
//                    testJuncs.add(j);
//                    i++;
//                }
//                insert testJuncs;
//
//            }//runas
//        }//testSetup
//
//    static testMethod void testOpps() {
//
//        User u = [SELECT Id FROM User WHERE Username = 'astest@wexeurope.com'];
//
//        //retrieve projects from @testSetup
//        List <Opportunity> EuOpportunities = [SELECT Id, Name from Opportunity WHERE Name LIKE '%EU <*>%'];
//
//        System.runAs(u){
//
//            test.startTest();
//
//            List <Opportunity> upEUOpps = new List<Opportunity>();
//
//            for(Opportunity o : EuOpportunities) {
//                o.CloseDate = date.today().adddays(100);
//                o.Implementation_Revenue__c = date.today().addDays(130);
//                o.Annual_Settlement_Value__c = 200;
//                o.Average_transaction_Value_POS__c = 10;
//                upEUOpps.add(o);
//            }
//            update upEUOpps;
//
//
//            //assert results
//            List <ProjectxOpp__c> EUjuncs = [SELECT Id, Name, Opportunity_Close_Date__c, Opportunity_Imp_Revenue_Com_Date__c, Opportunity_Net_FSR__c from ProjectxOpp__c WHERE Opportunity__c IN :upEUOpps];
//
//            for(ProjectxOpp__c j : EUjuncs){
//                system.assertEquals(date.today().adddays(100), j.Opportunity_Close_Date__c);
//            }
//
//            List <Opportunity> NAopportunities = [SELECT Id, Name from Opportunity WHERE Name LIKE '%NA <*>%'];
//
//            List <Opportunity> upNAOpps = new List<Opportunity>();
//
//            for(Opportunity o : NAopportunities){
//                o.CloseDate = date.today().addDays(110);
//                o.Annual_Settlement_Value__c = 20000;
//                upNAOpps.add(o);
//            }
//            update upNAOpps;
//
//
//            //assert results
//            List <ProjectxOpp__c> NAjuncs = [SELECT Id, Name, Opportunity_Close_Date__c from ProjectxOpp__c WHERE Opportunity__c IN :upNAOpps];
//
//            for(ProjectxOpp__c j : NAjuncs){
//                system.assertEquals(date.today().adddays(110), j.Opportunity_Close_Date__c);
//            }
//
//            test.stopTest();
//        }
//    }
}