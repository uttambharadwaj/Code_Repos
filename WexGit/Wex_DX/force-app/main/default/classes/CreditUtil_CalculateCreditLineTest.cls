/**
 * Created by lhowland on 6/24/2020.
 */
@isTest
public with sharing class CreditUtil_CalculateCreditLineTest {

    public static void testOTRCreditLineCalculation() {

        List<OnlineApplication__c> onlineApplications = [
                SELECT Id,Credit_Line_Recommendation__c,DNB_Credit_Line_Recommendation__c,Credit_Line_Requested__c,Risk_Grade__c,DNB_CSAD_High_Credit__c,Team_Drivers_Slip_Seat__c,Number_of_Trucks__c,PG_Required__c,PG_High_Credit_Amount__c,PG_Score__c
                FROM OnlineApplication__c
                WHERE AO_Name__c = 'Sterling Archer'
        ];

        if (onlineApplications.size() > 0) {
            CreditUtil_CalculateCreditLine cuccl = new CreditUtil_CalculateCreditLine();

            /** TEST COMMERCIAL  */
            // Risk Grade 1 and 2
            // requesting under 10k
            onlineApplications[0].Risk_Grade__c = '1';
            onlineApplications[0].Credit_Line_Requested__c = 9000;
            onlineApplications[0].DNB_Credit_Line_Recommendation__c = 9000;
            onlineApplications[0].DNB_CSAD_High_Credit__c = 15000;
            onlineApplications[0].Number_of_Trucks__c = 20;
            upsert onlineApplications[0];

            Decimal oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(9000, oa);

            // Risk Grade 1 and 2
            // requesting great than 10k and less than 150k
            // has high credit amount to cover
            onlineApplications[0].Risk_Grade__c = '2';
            onlineApplications[0].Credit_Line_Requested__c = 11000;
            onlineApplications[0].DNB_Credit_Line_Recommendation__c = 11000;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(11000, oa);

            // Risk Grade 1 and 2
            // requesting great than 10k and less than 150k
            // does NOT have high credit amount to cover
            onlineApplications[0].Risk_Grade__c = '1';
            onlineApplications[0].Credit_Line_Requested__c = 20000;
            onlineApplications[0].DNB_Credit_Line_Recommendation__c = 20000;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(20000, oa);

            // Risk Grade 1 and 2
            // requesting less than high credit
            onlineApplications[0].Risk_Grade__c = '2';
            onlineApplications[0].Credit_Line_Requested__c = 20000;
            onlineApplications[0].DNB_Credit_Line_Recommendation__c = 25000;
            onlineApplications[0].DNB_CSAD_High_Credit__c = 30000;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(20000, oa);

            // Risk Grade 1 and 2
            // DNB_SBFE_High_Credit__c = 99999999999.00
            onlineApplications[0].Risk_Grade__c = '2';
            onlineApplications[0].Credit_Line_Requested__c = 40000;
            onlineApplications[0].DNB_Credit_Line_Recommendation__c = 35000;
            onlineApplications[0].DNB_CSAD_High_Credit__c = 30000;
            onlineApplications[0].DNB_SBFE_High_Credit__c = 99999999999.00;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(35000, oa);

            // Risk Grade 3
            // requesting less than 150k
            // has high credit amount to cover
            onlineApplications[0].Risk_Grade__c = '3';
            onlineApplications[0].Credit_Line_Requested__c = 20000;
            onlineApplications[0].DNB_Credit_Line_Recommendation__c = 20000;
            onlineApplications[0].DNB_CSAD_High_Credit__c = 25000;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(20000, oa);

            // Risk Grade 3
            // requesting less than 150k
            // does NOT have high credit amount to cover
            onlineApplications[0].Risk_Grade__c = '3';
            onlineApplications[0].Credit_Line_Requested__c = 20000;
            onlineApplications[0].DNB_Credit_Line_Recommendation__c = 10000;
            onlineApplications[0].DNB_CSAD_High_Credit__c = 10000;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(10000, oa);


            /** TEST CONSUMER */
            // FICO 750+
            // High credit covers requested
            onlineApplications[0].DNB_Credit_Line_Recommendation__c = null;
            onlineApplications[0].PG_Required__c = true;
            onlineApplications[0].PG_Score__c = 760;
            onlineApplications[0].Credit_Line_Requested__c = 5000;
            onlineApplications[0].PG_High_Credit_Amount__c = 11000;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(5000, oa);

            // FICO >= 720 and <= 750
            // High credit covers requested
            onlineApplications[0].PG_Score__c = 740;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(5000, oa);

            // FICO >= 680 and <= 719
            // High credit covers requested
            onlineApplications[0].PG_Score__c = 700;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(5000, oa);

            // FICO >= 660 and <= 679
            // High credit covers requested
            onlineApplications[0].PG_Score__c = 670;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(5000, oa);

            // High credit doesn't cover requested, capped off at high credit amount, approved for high credit
            onlineApplications[0].Credit_Line_Requested__c = 10000;
            onlineApplications[0].PG_High_Credit_Amount__c = 11000;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(5000, oa);

            // Number of trucks affect credit recommendation
            onlineApplications[0].PG_Score__c = 751;
            onlineApplications[0].Number_of_Trucks__c = 1;  // resulting in reducing "requested" credit to 2500
            onlineApplications[0].Credit_Line_Requested__c = 5000;
            onlineApplications[0].PG_High_Credit_Amount__c = 11000;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(2500, oa);

            // Number of trucks affect credit recommendation and is a slip seat (offering them more than they requested)
            onlineApplications[0].Team_Drivers_Slip_Seat__c = true; // resulting in upping "requested" credit 3500
            onlineApplications[0].Credit_Line_Requested__c = 5000;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(3500, oa);

            /** TEST FOR BOTH COMMERCIAL AND CONSUMER */

            // Didn't have a credit line recommendation higher than the minimum amount of $2500
            onlineApplications[0].Risk_Grade__c = '1';
            onlineApplications[0].PG_Required__c = false;
            onlineApplications[0].DNB_Credit_Line_Recommendation__c = 2000;
            onlineApplications[0].Team_Drivers_Slip_Seat__c = false;
            onlineApplications[0].Credit_Line_Requested__c = 2000;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(2500, oa);

            // Didn't have a credit line recommendation higher than the minimum slip seat amount of $3500
            onlineApplications[0].Team_Drivers_Slip_Seat__c = true;
            onlineApplications[0].Credit_Line_Requested__c = 3000;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(3500, oa);

            cuccl.postProcess();

            cuccl.preProcess(onlineApplications, 'Test', 'Test');

        }
    }

    public static void testNACreditLineCalculation() {

        List<Application_Request__c> appRequest = [
                SELECT Id,Credit_Line_Recommendation__c,DNB_Credit_Line_Recommendation__c,Requested_Credit_Limit__c,Risk_Grade__c,DNB_CSAD_High_Credit__c,PG_Required__c,PG_High_Credit_Amount__c,PG_FICO_Score__c, Stock_Symbol__c
                FROM Application_Request__c
                WHERE Stock_Symbol__c = 'NYC'
        ];

        if (appRequest.size() > 0) {
            CreditUtil_CalculateCreditLine cuccl = new CreditUtil_CalculateCreditLine();

            /** TEST COMMERCIAL  */
            // Risk Grade 1 and 2
            // requesting under 10k
            appRequest[0].Risk_Grade__c = '1';
            appRequest[0].Requested_Credit_Limit__c = '9000';
            appRequest[0].DNB_Credit_Line_Recommendation__c = 9000;
            appRequest[0].DNB_CSAD_High_Credit__c = 15000;
            upsert appRequest[0];

            Decimal oa = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = appRequest[0].Id), 'String', 'String', 'String', appRequest[0].Id);
            System.assertEquals(9000, oa);

            // Risk Grade 1 and 2
            // requesting great than 10k and less than 150k
            // has high credit amount to cover
            appRequest[0].Risk_Grade__c = '2';
            appRequest[0].Requested_Credit_Limit__c = '11000';
            appRequest[0].DNB_Credit_Line_Recommendation__c = 11000;
            upsert appRequest[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = appRequest[0].Id), 'String', 'String', 'String', appRequest[0].Id);
            System.assertEquals(11000, oa);

            // Risk Grade 1 and 2
            // requesting great than 10k and less than 150k
            // does NOT have high credit amount to cover
            appRequest[0].Risk_Grade__c = '1';
            appRequest[0].Requested_Credit_Limit__c = '20000';
            appRequest[0].DNB_Credit_Line_Recommendation__c = 20000;
            upsert appRequest[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = appRequest[0].Id), 'String', 'String', 'String', appRequest[0].Id);
            System.assertEquals(20000, oa);

            // Risk Grade 1 and 2
            // requesting less than high credit
            appRequest[0].Risk_Grade__c = '2';
            appRequest[0].Requested_Credit_Limit__c = '20000';
            appRequest[0].DNB_Credit_Line_Recommendation__c = 25000;
            appRequest[0].DNB_CSAD_High_Credit__c = 30000;
            upsert appRequest[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = appRequest[0].Id), 'String', 'String', 'String', appRequest[0].Id);
            System.assertEquals(20000, oa);

            // Risk Grade 1 and 2
            // DNB_SBFE_High_Credit__c = 99999999999.00
            appRequest[0].Risk_Grade__c = '2';
            appRequest[0].Requested_Credit_Limit__c = '40000';
            appRequest[0].DNB_Credit_Line_Recommendation__c = 35000;
            appRequest[0].DNB_CSAD_High_Credit__c = 30000;
            appRequest[0].DNB_SBFE_High_Credit__c = 99999999999.00;
            upsert appRequest[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = appRequest[0].Id), 'String', 'String', 'String', appRequest[0].Id);
            System.assertEquals(35000, oa);

            // Risk Grade 3
            // requesting less than 150k
            // has high credit amount to cover
            appRequest[0].Risk_Grade__c = '3';
            appRequest[0].Requested_Credit_Limit__c = '20000';
            appRequest[0].DNB_Credit_Line_Recommendation__c = 20000;
            appRequest[0].DNB_CSAD_High_Credit__c = 25000;
            upsert appRequest[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = appRequest[0].Id), 'String', 'String', 'String', appRequest[0].Id);
            System.assertEquals(20000, oa);

            // Risk Grade 3
            // requesting less than 150k
            // does NOT have high credit amount to cover
            appRequest[0].Risk_Grade__c = '3';
            appRequest[0].Requested_Credit_Limit__c = '20000';
            appRequest[0].DNB_Credit_Line_Recommendation__c = 10000;
            appRequest[0].DNB_CSAD_High_Credit__c = 10000;
            upsert appRequest[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = appRequest[0].Id), 'String', 'String', 'String', appRequest[0].Id);
            System.assertEquals(10000, oa);


            /** TEST CONSUMER */
            // Risk Grade 1/2 range
            // High credit covers requested
            appRequest[0].DNB_Credit_Line_Recommendation__c = null;
            appRequest[0].PG_Required__c = true;
            appRequest[0].Risk_Grade__c = '1';
            appRequest[0].Requested_Credit_Limit__c = '5000';
            appRequest[0].PG_High_Credit_Amount__c = 11000;
            upsert appRequest[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = appRequest[0].Id), 'String', 'String', 'String', appRequest[0].Id);
            System.assertEquals(5000, oa);

            // Risk Grade 3/4 range
            // High credit covers requested
            appRequest[0].Risk_Grade__c = '3';
            upsert appRequest[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = appRequest[0].Id), 'String', 'String', 'String', appRequest[0].Id);
            System.assertEquals(5000, oa);

            // High credit doesn't cover requested, capped off at high credit amount, approved for high credit
            appRequest[0].Requested_Credit_Limit__c = '15000';
            appRequest[0].PG_High_Credit_Amount__c = 11000;
            upsert appRequest[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = appRequest[0].Id), 'String', 'String', 'String', appRequest[0].Id);
            System.assertEquals(11000, oa);

            /** TEST FOR REVOLVER CARD */
            //todo need to create new App Request record in test data  that is using a Revolver Card Program. Query for that record here before running the following tests, then remove revolver test from CreditDecisionEngineNATest
//            // Revolver Card Table 1/2 matrix
//            appRequest[0].Risk_Grade__c = '1';
//            appRequest[0].PG_Required__c = false;
//            appRequest[0].BOCA_Type__c = 'Revolver Card';
//            appRequest[0].Years_In_Business__c = 0.5;
//            appRequest[0].Annual_Gross_Revenue__c = 30000;
//            appRequest[0].Requested_Credit_Limit__c = '3000';
//            upsert appRequest[0];
//
//            oa = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = appRequest[0].Id), 'String', 'String', 'String', appRequest[0].Id);
//            System.assertEquals(2000, oa);
//
//            // Revolver Card Table 3 matrix
//            appRequest[0].Risk_Grade__c = '1';
//            appRequest[0].PG_Required__c = false;
//            appRequest[0].BOCA_Type__c = 'Revolver Card';
//            appRequest[0].Years_In_Business__c = 2;
//            appRequest[0].Annual_Gross_Revenue__c = 30000;
//            appRequest[0].Requested_Credit_Limit__c = '4000';
//            upsert appRequest[0];
//
//            oa = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = appRequest[0].Id), 'String', 'String', 'String', appRequest[0].Id);
//            System.assertEquals(3000, oa);
//
//            // Revolver Card Table 4 matrix
//            appRequest[0].Risk_Grade__c = '1';
//            appRequest[0].PG_Required__c = false;
//            appRequest[0].BOCA_Type__c = 'Revolver Card';
//            appRequest[0].Years_In_Business__c = 4;
//            appRequest[0].Annual_Gross_Revenue__c = 30000;
//            appRequest[0].Requested_Credit_Limit__c = '6000';
//            upsert appRequest[0];
//
//            oa = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = appRequest[0].Id), 'String', 'String', 'String', appRequest[0].Id);
//            System.assertEquals(5000, oa);
//
//            // Asking for more than 25k, which exceeds any Revolver request
//            appRequest[0].Risk_Grade__c = '1';
//            appRequest[0].PG_Required__c = false;
//            appRequest[0].BOCA_Type__c = 'Revolver Card';
//            appRequest[0].Years_In_Business__c = 2;
//            appRequest[0].Annual_Gross_Revenue__c = 30000;
//            appRequest[0].Requested_Credit_Limit__c = '30000';
//            upsert appRequest[0];
//
//            oa = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = appRequest[0].Id), 'String', 'String', 'String', appRequest[0].Id);
//            System.assertEquals(0, oa);

            cuccl.postProcess();

            cuccl.preProcess(appRequest, 'Test', 'Test');

        }
    }

    public static void testCPCreditLineCalculation() {

        List<CP_Application_Request__c> cpAppRequest = [
                SELECT Id,Credit_Line_Recommendation__c,DNB_Credit_Line_Recommendation__c,Credit_Line_Requested__c,Risk_Grade__c,DNB_CSAD_High_Credit__c,PG_Required__c,PG_High_Credit_Amount__c,PG_FICO_Score__c, Stock_Symbol__c
                FROM CP_Application_Request__c
                WHERE Company_Legal_Name__c = 'Amazing Company 3'
        ];

        if (cpAppRequest.size() > 0) {
            CreditUtil_CalculateCreditLine cuccl = new CreditUtil_CalculateCreditLine();

            /** TEST COMMERCIAL  */
            // Risk Grade 1 and 2
            // requesting under 10k
            cpAppRequest[0].Risk_Grade__c = '1';
            cpAppRequest[0].Credit_Line_Requested__c = 9000;
            cpAppRequest[0].DNB_Credit_Line_Recommendation__c = 9000;
            cpAppRequest[0].DNB_CSAD_High_Credit__c = 15000;
            upsert cpAppRequest[0];

            Decimal oa = (Decimal) cuccl.getFunctionValue(null, new CP_Application_Request__c(Id = cpAppRequest[0].Id), 'String', 'String', 'String', cpAppRequest[0].Id);
            System.assertEquals(9000, oa);

            // Risk Grade 1 and 2
            // requesting great than 10k and less than 150k
            // has high credit amount to cover
            cpAppRequest[0].Risk_Grade__c = '2';
            cpAppRequest[0].Credit_Line_Requested__c = 11000;
            cpAppRequest[0].DNB_Credit_Line_Recommendation__c = 11000;
            upsert cpAppRequest[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new CP_Application_Request__c(Id = cpAppRequest[0].Id), 'String', 'String', 'String', cpAppRequest[0].Id);
            System.assertEquals(11000, oa);

            // Risk Grade 1 and 2
            // requesting great than 10k and less than 150k
            // does NOT have high credit amount to cover
            cpAppRequest[0].Risk_Grade__c = '1';
            cpAppRequest[0].Credit_Line_Requested__c = 20000;
            cpAppRequest[0].DNB_Credit_Line_Recommendation__c = 20000;
            upsert cpAppRequest[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new CP_Application_Request__c(Id = cpAppRequest[0].Id), 'String', 'String', 'String', cpAppRequest[0].Id);
            System.assertEquals(20000, oa);

            // Risk Grade 1 and 2
            // requesting less than high credit
            cpAppRequest[0].Risk_Grade__c = '2';
            cpAppRequest[0].Credit_Line_Requested__c = 20000;
            cpAppRequest[0].DNB_Credit_Line_Recommendation__c = 25000;
            cpAppRequest[0].DNB_CSAD_High_Credit__c = 30000;
            upsert cpAppRequest[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new CP_Application_Request__c(Id = cpAppRequest[0].Id), 'String', 'String', 'String', cpAppRequest[0].Id);
            System.assertEquals(20000, oa);

            // Risk Grade 1 and 2
            // DNB_SBFE_High_Credit__c = 99999999999.00
            cpAppRequest[0].Risk_Grade__c = '2';
            cpAppRequest[0].Credit_Line_Requested__c = 40000;
            cpAppRequest[0].DNB_Credit_Line_Recommendation__c = 35000;
            cpAppRequest[0].DNB_CSAD_High_Credit__c = 30000;
            cpAppRequest[0].DNB_SBFE_High_Credit__c = 99999999999.00;
            upsert cpAppRequest[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new CP_Application_Request__c(Id = cpAppRequest[0].Id), 'String', 'String', 'String', cpAppRequest[0].Id);
            System.assertEquals(35000, oa);

            // Risk Grade 3
            // requesting less than 150k
            // has high credit amount to cover
            cpAppRequest[0].Risk_Grade__c = '3';
            cpAppRequest[0].Credit_Line_Requested__c = 20000;
            cpAppRequest[0].DNB_Credit_Line_Recommendation__c = 20000;
            cpAppRequest[0].DNB_CSAD_High_Credit__c = 25000;
            upsert cpAppRequest[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new CP_Application_Request__c(Id = cpAppRequest[0].Id), 'String', 'String', 'String', cpAppRequest[0].Id);
            System.assertEquals(20000, oa);

            // Risk Grade 3
            // requesting less than 150k
            // does NOT have high credit amount to cover
            cpAppRequest[0].Risk_Grade__c = '3';
            cpAppRequest[0].Credit_Line_Requested__c = 20000;
            cpAppRequest[0].DNB_Credit_Line_Recommendation__c = 10000;
            cpAppRequest[0].DNB_CSAD_High_Credit__c = 10000;
            upsert cpAppRequest[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new CP_Application_Request__c(Id = cpAppRequest[0].Id), 'String', 'String', 'String', cpAppRequest[0].Id);
            System.assertEquals(10000, oa);


            /** TEST CONSUMER */
            // Risk Grade 1/2 range
            // High credit covers requested
            cpAppRequest[0].DNB_Credit_Line_Recommendation__c = null;
            cpAppRequest[0].PG_Required__c = true;
            cpAppRequest[0].Risk_Grade__c = '1';
            cpAppRequest[0].Credit_Line_Requested__c = 5000;
            cpAppRequest[0].PG_High_Credit_Amount__c = 11000;
            upsert cpAppRequest[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new CP_Application_Request__c(Id = cpAppRequest[0].Id), 'String', 'String', 'String', cpAppRequest[0].Id);
            System.assertEquals(5000, oa);

            // Risk Grade 3/4 range
            // High credit covers requested
            cpAppRequest[0].Risk_Grade__c = '3';
            upsert cpAppRequest[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new CP_Application_Request__c(Id = cpAppRequest[0].Id), 'String', 'String', 'String', cpAppRequest[0].Id);
            System.assertEquals(5000, oa);

            // High credit doesn't cover requested, capped off at high credit amount, approved for high credit
            cpAppRequest[0].Credit_Line_Requested__c = 15000;
            cpAppRequest[0].PG_High_Credit_Amount__c = 11000;
            upsert cpAppRequest[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new CP_Application_Request__c(Id = cpAppRequest[0].Id), 'String', 'String', 'String', cpAppRequest[0].Id);
            System.assertEquals(11000, oa);

            cuccl.postProcess();

            cuccl.preProcess(cpAppRequest, 'Test', 'Test');

        }

    }
}