@isTest
public class WE_ApexUtilityTest {

//    @testSetup
//    static void dataSetup() {
//
//        List<VRTN__c> custSettFields = new List<VRTN__c>();
//
//        User u = WE_TestDataUtility.createStandardUser();
//
//        System.runas(u) {
//
//            VApexC__c apxCntrlr0 = WE_TestDataUtility.createApexControllerCustSett(
//                'Opportunity MRF',  // fieldRef
//                false);       		// fcstDisabledStatus
//
//            VApexC__c apxCntrlr1 = WE_TestDataUtility.createApexControllerCustSett(
//                'Budget Manager',  // fieldRef
//                false);       	   // fcstDisabledStatus
//
//            VApexC__c apxCntrlr2 = WE_TestDataUtility.createApexControllerCustSett(
//                'Target Manager',  // fieldRef
//                false);       	   // fcstDisabledStatus
//
//            VApexC__c apxCntrlr3 = WE_TestDataUtility.createApexControllerCustSett(
//                'Domain Match',    // fieldRef
//                false);       	   // fcstDisabledStatus
//
//            VApexC__c apxCntrlr4 = WE_TestDataUtility.createApexControllerCustSett(
//                'Net FSR',    // fieldRef
//                false);       	   // fcstDisabledStatus
//
//            VApexC__c apxCntrlr5 = WE_TestDataUtility.createApexControllerCustSett(
//                'Automatic Project Creation',    // fieldRef
//                false);       	   // fcstDisabledStatus
//
//            // Record Type Name checks
//
//            VRTN__c rtCS1 = WE_TestDataUtility.createRecTypeNameCustSett(
//                'CP Virtual Prepaid MC', // rtName
//                'EU Opps');         	 // csField
//            custSettFields.add(rtCS1);
//
//            VRTN__c rtCS2 = WE_TestDataUtility.createRecTypeNameCustSett(
//                'MasterCard', // rtName
//                'NA Opps');         	 // csField
//            custSettFields.add(rtCS2);
//
//            VRTN__c rtCS3 = WE_TestDataUtility.createRecTypeNameCustSett(
//                'MasterCard1',  // rtName
//                'NAEU Opps');  // csField
//            custSettFields.add(rtCS3);
//
//            VRTN__c rtCS4 = WE_TestDataUtility.createRecTypeNameCustSett(
//                'Virtual Credit MC',  // rtName
//                'Virtual AU Opps');  // csField
//            custSettFields.add(rtCS4);
//
//            VRTN__c rtCS5 = WE_TestDataUtility.createRecTypeNameCustSett(
//                'CP Virtual Partnership',  // rtName
//                'Virtual Partner Opps');  // csField
//            custSettFields.add(rtCS5);
//
//            VRTN__c rtCS6 = WE_TestDataUtility.createRecTypeNameCustSett(
//                'CorporatePay Accounts',  	// rtName
//                'EU Accts');        		// csField
//            custSettFields.add(rtCS6);
//
//            VRTN__c rtCS7 = WE_TestDataUtility.createRecTypeNameCustSett(
//                'Virtual Credit CS',  		// rtName
//                'Virtual EU Service Cases');    // csField
//            custSettFields.add(rtCS7);
//
//            //VRTN__c rtCS8 = WE_TestDataUtility.createRecTypeNameCustSett(
//                //'',  		// rtName
//                //'Virtual AU Projects');    // csField
//            //custSettFields.add(rtCS8);
//
//            VRTN__c rtCS9 = WE_TestDataUtility.createRecTypeNameCustSett(
//                'Implementation',  		// rtName
//                'Virtual EU Projects');    // csField
//            custSettFields.add(rtCS9);
//
//            VRTN__c rtCS10 = WE_TestDataUtility.createRecTypeNameCustSett(
//                'Project',  		// rtName
//                'Virtual NA Projects');    // csField
//            custSettFields.add(rtCS10);
//
//            insert custSettFields;
//        }
//
//    }
//
//    public static List<Opportunity> createOpportunities(
//        string oppRef,
//        integer noOpps,
//        string   recordTypeName,
//        string   identifier,
//        string   stageName,
//        date   closeDate,
//        string   rampProfile,
//        decimal settlement) {
//
//            RecordType rt = [SELECT Id FROM RecordType
//                              WHERE SObjectType = 'Opportunity' AND RecordType.Name = :recordTypeName
//                              LIMIT 1];
//
//            User u = [SELECT Id FROM User WHERE Username = 'astest@wexeurope.com'];
//
//            // create Opportunities
//            Opportunity[] opportunities = new Opportunity[]{};
//                for(integer i = 0; i < noOpps; i++) {
//
//                    if (oppRef == 'EU Opps') {
//                    opportunities.add(new Opportunity(
//                        Name                 = 'Test EU Opp ' + i + ' ' + identifier,
//                        RecordTypeId             = rt.Id,
//                        OwnerId               = u.Id,
//                        StageName               = stageName,
//                        CloseDate               = closeDate,
//                        Ramp_Profile__c            = rampProfile,
//                        LeadSource              = 'Cold Call',
//                        Rebate_Not_Offered__c        = true,
//                        Type                = 'New Customer',
//                        // cover Forecast validation rules
//                        Monthly_Txn_Revenue_POS__c       = 0,
//                        // cover Credit Agreement Details Required validation rule
//                        Credit_Limit__c            = 100,
//                        Date_Credit_Limit_Approved__c     = date.newInstance(1901,1,1),
//                        Payment_Terms_Days__c         = 5,
//                        Billing_Cycle__c           = 'Daily',
//                        //cover Revenue Values Required validation rule
//                        Annual_Settlement_Value__c       = settlement,
//                        Average_transaction_Value_POS__c   = 1.00
//                        //Implementation_Revenue__c      = date.today().addMonths(3)
//                    ));
//                }
//                if (oppRef == 'NA Opps') {
//                    opportunities.add(new Opportunity(
//                        Name                 = 'Test NA Opp ' + i + ' ' + identifier,
//                        RecordTypeId             = rt.Id,
//                        OwnerId               = u.Id,
//                        StageName               = stageName,
//                        CloseDate               = closeDate,
//                        Ramp_Profile__c            = rampProfile,
//                        Annual_Settlement_Value__c      = settlement,
//                        Type                = 'Contract',
//                        LeadSource              = 'Internal Referral',
//                        Revenue_Measure__c          = 'Monthly',
//                        Product_Interest__c          = 'Virtual',
//                        MC_Product__c            = 'Virtual'
//                    ));
//                }
//            }
//            return opportunities;
//        }
//
//    static testMethod void testUtilityClass() {
//
//        List <Opportunity> oppsToClone = [SELECT Id FROM Opportunity WHERE Name LIKE '%id1%'];
//
//        test.startTest();
//
//        WE_ApexUtility.checkApexControllerStatus('Opportunity MRF');
//        WE_ApexUtility.checkApexControllerStatus('Budget Manager');
//        WE_ApexUtility.checkApexControllerStatus('Target Manager');
//        WE_ApexUtility.checkApexControllerStatus('Domain Match');
//        WE_ApexUtility.checkApexControllerStatus('Lost Deal Survey');
//        WE_ApexUtility.checkApexControllerStatus('Net FSR');
//        WE_ApexUtility.checkApexControllerStatus('Automatic Project Creation');
//
//        WE_ApexUtility apxUtil = new WE_ApexUtility();
//        apxUtil.retrieveValidRecordTypes(
//            'EU Opps');
//
//        WE_ApexUtility apxUtil0 = new WE_ApexUtility();
//        apxUtil0.retrieveValidRecordTypes(
//            'NA Opps');
//
//         WE_ApexUtility apxUtil1 = new WE_ApexUtility();
//        apxUtil1.retrieveValidRecordTypes(
//            'Virtual AU Opps');
//
//        WE_ApexUtility apxUtil2 = new WE_ApexUtility();
//        apxUtil2.retrieveValidRecordTypes(
//            'EU NA Opps'); // fieldRef
//
//        WE_ApexUtility apxUtil3 = new WE_ApexUtility();
//        apxUtil3.retrieveValidRecordTypes(
//            'EU Accts'); // fieldRef
//
//        WE_ApexUtility apxUtil4 = new WE_ApexUtility();
//        apxUtil4.retrieveValidRecordTypes(
//            'Virtual EU Cases'); // fieldRef
//
//        WE_ApexUtility apxUtil5 = new WE_ApexUtility();
//        apxUtil5.retrieveValidRecordTypes(
//            'Virtual Partner Opps'); // fieldRef
//
//        WE_ApexUtility apxUtil6 = new WE_ApexUtility();
//        apxUtil6.retrieveValidRecordTypes(
//            'Virtual EU Service Cases'); // fieldRef
//
//        WE_ApexUtility apxUtil7 = new WE_ApexUtility();
//        apxUtil7.retrieveValidRecordTypes(
//            'Virtual EU Projects'); // fieldRef
//
//        WE_ApexUtility apxUtil8 = new WE_ApexUtility();
//        apxUtil8.retrieveValidRecordTypes(
//            'Virtual NA Projects'); // fieldRef
//
//        WE_ApexUtility apxUtil9 = new WE_ApexUtility();
//        apxUtil9.retrieveValidRecordTypes(
//            'Virtual AU Opps'); // fieldRef
//
//        WE_ApexUtility apxUtil10 = new WE_ApexUtility();
//        apxUtil10.retrieveValidRecordTypes(
//            'Virtual NA Projects'); // fieldRef
//
//        WE_ApexUtility apxUtil11 = new WE_ApexUtility();
//        apxUtil11.retrieveValidRecordTypes(
//            'Virtual NA Projects'); // fieldRef
//
//        WE_ApexUtility.recursiveOppUpdate(oppsToClone,true);
//
//        test.stopTest();
//    }
}