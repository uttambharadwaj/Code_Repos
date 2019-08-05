//// revision history https://gist.github.com/aplssf/07e15849ea3ecbd97142/revisions
public class WE_MRFv3 {
//
//    /**
//     * WIP - adding Net FSR In Year calculation
//     **/
//
//    // variables
//    Boolean isInsert = false;
//    Map<Id,Opportunity> oldOpps;
//    Map<Id,Opportunity> newOpps;
//    Set<Id> oppIds = new Set<Id>();
//    Map<Id,Opportunity> oppsByOppId = new Map<Id,Opportunity>();
//    List<Opportunity> upOpps = new List<Opportunity>();
//    Map<Id,Integer> forecastDuration = new Map<Id,Integer>();
//    // populate in Method?
//    Map<Integer,String> monthName = new Map<Integer,String>{1 => 'January', 2 => 'February', 3 => 'March', 4 => 'April', 5 => 'May', 6 => 'June', 7 => 'July', 8 => 'August', 9 => 'September', 10 => 'October', 11 => 'November', 12 => 'December'};
//    List<Monthly_Revenue_Forecast__c> existMRFs = new List<Monthly_Revenue_Forecast__c>();
//    Map<String, Schema.RecordTypeInfo> rts = new Map<String, Schema.RecordTypeInfo>();
//    List<VRTN__c> weRts = new List<VRTN__c>();
//    String rtName;
//    Id rtId;
//    Id ownerId;
//    VProfileId__c userSetting;
//    String teamName;
//    Map<Id,String> teamByOppId = new Map<Id,String>();
//    Set<String> budgetIdentifiers = new Set<String>();
//    List<Monthly_Revenue_Forecast__c> newMRFs = new List<Monthly_Revenue_Forecast__c>();
//    Map<String,Budget__c> budgetByIdentifier = new Map<String,Budget__c>();
//    Id mrfOppId;
//    String mrfTeamName;
//    String mrfRevDateMonth;
//    Id budgetId;
//    String existingMessage;
//    Map<Id,String> errorMessagebyOppId = new Map<Id,String>();
//    String errorMessage;
//
//    Integer fcstDuration;
//    Decimal fcstAdjst;
//    Decimal asv;
//    Decimal sett;
//    Decimal monthlySett;
//    Decimal txns;
//    Decimal annualTxns;
//    Decimal monthlyTxns;
//    Decimal annualTxnRev;
//    Decimal monthlyTxnRev;
//    Decimal increment;
//    Integer rDur;
//    Integer fsrDur;
//    Date rc;
//    Integer closeDateYear;
//    Decimal ramp;
//    Decimal rampPer;
//    Decimal monthTxns;
//    Decimal monthSett;
//    Decimal monthTxnRev;
//    Boolean txnsNull;
//    Decimal settlementInYear;
//    Public Static Map<Id,Opportunity> oppsWithFcstSettInYear = new Map<Id,Opportunity>();
//    Public Static Map<Id,Decimal> oppsFcstSettlementInYear = new Map<Id,Decimal>();
//
//    // after insert constructor
//    public WE_MRFv3(
//        Boolean triggerIsInsert,
//        Map<Id, Opportunity> newTriggerOpps) {
//            isInsert = triggerIsInsert;
//            newOpps = newTriggerOpps;
//        }
//
//    // after update constructor
//    public WE_MRFv3(
//        Map<Id, Opportunity> oldTriggerOpps,
//        Map<Id, Opportunity> newTriggerOpps) {
//            oldOpps = oldTriggerOpps;
//            newOpps = newTriggerOpps;
//        }
//
//    // method
//    public void generateMRF() {
//
//        if (WE_ApexUtility.apxCntrlrOppMrfStatusAssessed == false) {
//            WE_ApexUtility.checkApexControllerStatus('Opportunity MRF');
//        }
//        if (!WE_ApexUtility.forecastDisabled.contains(true)) {
//            // create Object from Class
//            WE_ApexUtility apxUtil = new WE_ApexUtility();
//            apxUtil.retrieveValidRecordTypes(
//                'EU NA Opps');
//
//            if (isInsert == true) { // after insert
//                for(Opportunity o : newOpps.values()) {
//                    if (WE_ApexUtility.validEuNaRecordTypeIds.contains(o.RecordTypeId)
//                        && o.Type != 'Existing Customer - Administration')
//                    {
//                        oppIds.add(o.Id);
//                        oppsByOppId.put(o.Id, o);
//                    }
//                }
//            } else { // after update
//                for(Opportunity o : newOpps.values()) {
//                    if (WE_ApexUtility.validEuNaRecordTypeIds.contains(o.RecordTypeId) &&
//                        o.Type != 'Existing Customer - Administration' &&
//                        // skip existing Opps with missing values in mass updates (validation rules will prompt updates for single records)
//                        o.Annual_Settlement_Value__c != null)
//                    {
//                        Opportunity oldO = oldOpps.get(o.Id);
//
//                        if (oldO.CloseDate != o.CloseDate ||
//                            oldO.Ramp_Profile__c != o.Ramp_Profile__c ||
//                            oldO.Annual_Settlement_Value__c != o.Annual_Settlement_Value__c ||
//                            oldO.Implementation_Revenue__c != o.Implementation_Revenue__c ||
//                            oldO.Implementation_Revenue_as_a_of_FSR__c != o.Implementation_Revenue_as_a_of_FSR__c ||
//                            oldO.Revenue_Commencement__c != o.Revenue_Commencement__c ||
//                            oldO.FSR_End_Date__c != o.FSR_End_Date__c ||
//                            oldO.Monthly_Txn_Revenue_POS__c != o.Monthly_Txn_Revenue_POS__c ||
//                            oldO.Annual_transaction_volume__c != o.Annual_transaction_volume__c ||
//                            oldO.Forecast_Adjustment__c != o.Forecast_Adjustment__c ||
//                            // needed for Budget management
//                            oldO.OwnerId != o.OwnerId)
//                        {
//                            upOpps.add(o);
//                            oppIds.add(o.Id);
//                            oppsByOppId.put(o.Id, o);
//                        }
//                    }
//                }
//            }
//
//            if (upOpps.size() > 0) {
//
//                for(Opportunity o : [SELECT Id,
//                                    (SELECT Id
//                                       FROM Monthly_Revenue_Forecasts__r)
//                                       FROM Opportunity
//                                      WHERE Id = :upOpps])
//                {
//                    if (o.Monthly_Revenue_Forecasts__r.size() > 0) {
//                        existMRFs.addAll(o.Monthly_Revenue_Forecasts__r);
//                    }
//                }
//                delete existMRFs;
//            }
//
//            if (oppIds.size() > 0) {
//                if (WE_ApexUtility.apxCntrlrBudgetManagerStatusAssessed == false) {
//                    WE_ApexUtility.checkApexControllerStatus('Budget Manager');
//                }
//                if (!WE_ApexUtility.budgetManagerDisabled.contains(true)) {
//                    rts = Opportunity.SObjectType.getDescribe().getRecordTypeInfosByName();
//                    weRts = VRTN__c.getall().values();
//                    for(VRTN__c weRt : weRts) {
//                        rtName = weRt.NaEuOpps__c;
//                        if (rtName != null) {
//                            rtId = rts.get(rtName).getRecordTypeId();
//                        }
//                    }
//                }
//
//                // query to fetch opps as will need values set by OppUpdates Class
//                for(Opportunity o : [SELECT Id, RecordTypeId, OwnerId, Forecast_Adjustment__c, Annual_Settlement_Value__c, Annual_transaction_volume__c, Monthly_Txn_Revenue_POS__c, Implementation_Revenue_as_a_of_FSR__c, Revenue_Commencement__c, Forecast_Full_Service_Revenue_Date__c, AccountId, CurrencyIsoCode, FSR_End_Date__c, CloseDate
//                                       FROM Opportunity
//                                      WHERE Id IN :oppIds])
//                {
//                    if (o.FSR_End_Date__c == null) {
//                        forecastDuration.put(o.Id,12);
//                    }
//                    else {
//                        forecastDuration.put(o.Id, o.Revenue_Commencement__c.monthsBetween(o.FSR_End_Date__c));
//                    }
//
//                    fcstDuration = forecastDuration.get(o.Id);
//                    if (fcstDuration > 0) {
//                        // store result of check in boolean as it's used more than once
//                        if (o.Annual_transaction_volume__c != null) {
//                            txnsNull = false;
//                        }
//                        else {
//                            txnsNull = true;
//                        }
//                        fcstAdjst = o.Forecast_Adjustment__c;
//
//                        // adjust Annual Settlement - cannot multiply by null
//                        if (fcstAdjst != null) {
//                            sett = o.Annual_Settlement_Value__c;
//                            asv = sett * (fcstAdjst / 100);
//                        }
//                        else {
//                            asv = o.Annual_Settlement_Value__c;
//                        }
//                        monthlySett = asv / fcstDuration;
//
//                        if (txnsNull == false) {
//                            // adjust Annual Transaction Volume
//                            annualTxns = null;
//                            if (fcstAdjst != null) {
//                                txns = o.Annual_transaction_volume__c;
//                                annualTxns = txns * (fcstAdjst / 100);
//                            }
//                            else {
//                                annualTxns = o.Annual_transaction_volume__c;
//                            }
//                            monthlyTxns = annualTxns / fcstDuration;
//                            annualTxnRev = annualTxns * o.Monthly_Txn_Revenue_POS__c;
//                            monthlyTxnRev = annualTxnRev / fcstDuration;
//                        }
//
//                        // Ramp calculations
//                        increment = o.Implementation_Revenue_as_a_of_FSR__c / 100;
//                        rDur = o.Revenue_Commencement__c.monthsBetween(o.Forecast_Full_Service_Revenue_Date__c);
//
//                        // FSR calculations
//                        fsrDur = forecastDuration.get(o.Id) - rDur;
//
//                        rc = o.Revenue_Commencement__c;
//                        closeDateYear = o.CloseDate.Year();
//
//                        ownerId = o.OwnerId;
//                        userSetting = VProfileId__c.getInstance(ownerId);
//                        teamName = userSetting.Team_Name__c;
//                        teambyOppId.put(o.Id, teamName);
//
//                        // add Monthly Forecast records for 'ramp' months
//                        for(Integer m = 0; m < rDur; m++) {
//                            ramp = 0;
//
//                            if (m == 0) {
//                                rampPer = 0.1;
//                                ramp = rampPer;
//                            }
//                            else if (increment * (m) >= 0.1) {
//                                rampPer = increment * (m);
//                                ramp = rampPer;
//                            }
//                            else {
//                                rampPer = 0.1;
//                                ramp = rampPer;
//                            }
//
//                            monthSett = monthlySett * ramp;
//                            if(txnsNull == false) {
//                                monthTxns = monthlyTxns * ramp;
//                                monthTxnRev = monthlyTxnRev * ramp;
//                            }
//
//                            // !!! check whether not setting MRF's CurrencyISO Code, to match Opportunity's, is impacting forecasts
//                            // add Monthly Forecast Records for ramp Months
//                            Monthly_Revenue_Forecast__c fm = new Monthly_Revenue_Forecast__c();
//                            fm.Opportunity__c = o.Id;
//                            fm.Account__c = o.AccountId;
//                            fm.CurrencyIsoCode = o.CurrencyIsoCode;
//                            fm.Name = monthName.get(rc.addMonths(m).month()) +' '+ rc.addMonths(m).year();
//                            fm.Revenue_Date__c = rc.addMonths(m + 1).toStartOfMonth() - 1;
//                            fm.Monthly_Settlement1__c = monthSett;
//                            if (txnsNull == false) {
//                                fm.Transactions__c = monthTxns;
//                                fm.Transaction_Revenue__c = monthTxnRev;
//                            }
///*
//                            if (fm.Revenue_Date__c.year() == closeDateYear &&
//                                monthSett > 0)
//                            {
//                                settlementInYear = oppsFcstSettlementInYear.get(o.Id) + monthSett;
//                                oppsFcstSettlementInYear.put(o.Id, settlementInYear);
//                                oppsWithFcstSettInYear.put(o.Id, newOpps.get(o.Id));
//                            }
//*/
//                            if (!WE_ApexUtility.budgetManagerDisabled.contains(true)) {
//                                budgetIdentifiers.add(teamName + '-' + fm.Revenue_Date__c.month() + '-' + fm.Revenue_Date__c.year());
//                            }
//                            newMRFs.add(fm);
//                        }
//
//                        // add Monthly Forecast Records for rFSR Months
//                        for(Integer m = rDur; m < rDur + fsrDur; m++) {
//                            Monthly_Revenue_Forecast__c fm = new Monthly_Revenue_Forecast__c();
//                            fm.Opportunity__c = o.Id;
//                            fm.Account__c = o.AccountId;
//                            fm.CurrencyIsoCode = o.CurrencyIsoCode;
//                            fm.Name = monthName.get(rc.addMonths(m).month()) +' '+ rc.addMonths(m).year();
//                            fm.Revenue_Date__c = rc.addMonths(m + 1).toStartOfMonth() - 1;
//                            fm.Monthly_Settlement1__c = monthlySett;
//                            budgetIdentifiers.add(teamName + '-' + '-' + fm.Revenue_Date__c.month() + '-' + fm.Revenue_Date__c.year());
//                            if (txnsNull == false) {
//                                fm.Transactions__c = monthlyTxns;
//                                fm.Transaction_Revenue__c = monthlyTxnRev;
//                            }
///*
//                            if (fm.Revenue_Date__c.year() == closeDateYear &&
//                                monthSett > 0)
//                            {
//                                settlementInYear = oppsFcstSettlementInYear.get(o.Id) + monthSett;
//                                oppsFcstSettlementInYear.put(o.Id, settlementInYear);
//                                oppsWithFcstSettInYear.put(o.Id, newOpps.get(o.Id));
//                            }
//*/
//                            if (!WE_ApexUtility.budgetManagerDisabled.contains(true)) {
//                                budgetIdentifiers.add(teamName + '-' + fm.Revenue_Date__c.month() + '-' + fm.Revenue_Date__c.year());
//                            }
//                            newMRFs.add(fm);
//                        }
//                    }
//                }
//
//                if (!WE_ApexUtility.budgetManagerDisabled.contains(true)) {
//                    for(Budget__c b : [SELECT Identifier__c, Id
//                                         FROM Budget__c
//                                        WHERE Identifier__c IN :budgetIdentifiers])
//                    {
//                        budgetByIdentifier.put(b.Identifier__c, b);
//                    }
//                    for(Monthly_Revenue_Forecast__c mrf : newMRFs) {
//                        mrfOppId = mrf.Opportunity__c;
//                        mrfTeamName = teamByOppId.get(mrfOppId);
//                        mrfRevDateMonth = String.valueOf(mrf.Revenue_Date__c.month());
//                        // format date to improve error message readability
//                        if (mrfRevDateMonth.length() < 2) {
//                            mrfRevDateMonth = '0' + mrfRevDateMonth;
//                        }
//                        try {
//                            budgetId = budgetByIdentifier.get(mrfTeamName + '-' + mrf.Revenue_Date__c.month() + '-' + mrf.Revenue_Date__c.year() ).Id;
//                            mrf.Budget__c = budgetId;
//                        } catch(NullPointerException e) {
//                            // build list of all MRF records with no matching Budget record
//                            existingMessage = errorMessagebyOppId.get(mrfOppId);
//                            if (existingMessage != null) {
//                                errorMessagebyOppId.put(mrfOppId, existingMessage +  ' Team Name: ' + mrfTeamName + ' & Revenue MM-YYYY: ' + mrfRevDateMonth + '-' + mrf.Revenue_Date__c.year() + '<br/>');
//                            }
//                            else {
//                                errorMessagebyOppId.put(mrfOppId, ' Team Name: ' + mrfTeamName + ' & Revenue MM-YYYY: ' + mrfRevDateMonth + '-' + mrf.Revenue_Date__c.year() + '<br/>');
//                            }
//                        }
//                    }
//
//                    for(Monthly_Revenue_Forecast__c mrf : newMRFs) {
//                        errorMessage = errorMessagebyOppId.get(mrf.Opportunity__c);
//                        if (errorMessage != null) {
//                            oppsByOppId.get(mrf.Opportunity__c).addError(' No Budget record was found for MRF record(s) with<br/>' + errorMessage + ' [WE_MRFv3]', false);
//                        }
//                    }
//                }
//            }
//
//            // Database Class Method (DML operation)
//            Database.SaveResult[] srList = Database.insert(newMRFs, false);
//
//            // Iterate through each returned result
//            for (Database.SaveResult sr : srList) {
//                if (sr.isSuccess()) {
//                    // Operation was successful, so get the ID of the record that was processed
//                    system.debug('Successfully inserted MRF record. MRF ID: ' + sr.getId());
//                }
//                else {
//                    // Operation failed, so get all errors
//                    for(Database.Error err : sr.getErrors()) {
//                        system.debug('The following error has occurred.');
//                        system.debug(err.getStatusCode() + ': ' + err.getMessage());
//                        system.debug('MRF fields that affected this error: ' + err.getFields());
//                    }
//                }
//            }
//            // !!! update Opportunity's Net FSR In Year field?
//        }// method
//    }
}