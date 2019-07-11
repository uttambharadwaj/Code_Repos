public class VirtualOpportunityTriggerHandler {
    //
    //public static Map<Integer,String> monthIntegerToNameMap {
    //get {
    //Map<Integer,String> monthIntegerToNameMap = new Map<Integer,String>{1 => 'January',
    //2 => 'February',
    //3 => 'March',
    //4 => 'April',
    //5 => 'May',
    //6 => 'June',
    //7 => 'July',
    //8 => 'August',
    //9 => 'September',
    //10 => 'October',
    //11 => 'November',
    //12 => 'December'};
    //return monthIntegerToNameMap;
    //}
    //}
    //
    //public static Set<Id> virtualRecordTypeIds {
    //get {
    //
    //Set<Id> virtualRecordTypeIds = new Set<Id>();
    //if(Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('Virtual Credit MC') != null) {
    //virtualRecordTypeIds.add(Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('Virtual Credit MC').getRecordTypeId());
    //}
    //if(Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('MasterCard') != null) {
    //virtualRecordTypeIds.add(Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('MasterCard').getRecordTypeId());
    //}
    //if(Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('CP Virtual Partnership') != null) {
    //virtualRecordTypeIds.add(Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('CP Virtual Partnership').getRecordTypeId());
    //}
    //if(Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('WEX Payables') != null) {
    //virtualRecordTypeIds.add(Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('WEX Payables').getRecordTypeId());
    //}
    //if(Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('CP Virtual Credit') != null) {
    //virtualRecordTypeIds.add(Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('CP Virtual Credit').getRecordTypeId());
    //}
    //
    //return virtualRecordTypeIds;
    //}
    //}
    //
    //public VirtualOpportunityTriggerHandler() {
    //
    //}
    //
    //// For on insert.. We'll refactor later..
    //public static void setRamp(Opportunity newOpportunity) {
    //
    //if(virtualRecordTypeIds.contains(newOpportunity.RecordTypeId)) {
    //
    //Date closeDate = newOpportunity.CloseDate;
    //
    //if(newOpportunity.Ramp_Profile__c == 'Immediate') {
    //
    //newOpportunity.Implementation_Revenue__c = closeDate.addDays(15);
    //newOpportunity.Revenue_Commencement__c = newOpportunity.Implementation_Revenue__c.addMonths(1).toStartOfMonth();
    //newOpportunity.Forecast_Full_Service_Revenue_Date__c = newOpportunity.Revenue_Commencement__c.addMonths(3);
    //newOpportunity.Implementation_Revenue_as_a_of_FSR__c = 37.5;
    //
    //if (newOpportunity.Annual_Settlement_Value__c == null){
    //newOpportunity.Annual_Settlement_Value__c = 0;
    //}
    //
    //} else if(newOpportunity.Ramp_Profile__c == 'Standard') {
    //
    //newOpportunity.Implementation_Revenue__c = closeDate.addMonths(3);
    //newOpportunity.Revenue_Commencement__c = newOpportunity.Implementation_Revenue__c.addMonths(1).toStartOfMonth();
    //newOpportunity.Forecast_Full_Service_Revenue_Date__c = newOpportunity.Revenue_Commencement__c.addMonths(3);
    //newOpportunity.Implementation_Revenue_as_a_of_FSR__c = 37.5;
    //
    //} else if(newOpportunity.Ramp_Profile__c == 'Medium') {
    //
    //newOpportunity.Implementation_Revenue__c = closeDate.addMonths(3);
    //newOpportunity.Revenue_Commencement__c = newOpportunity.Implementation_Revenue__c.addMonths(1).toStartOfMonth();
    //newOpportunity.Forecast_Full_Service_Revenue_Date__c = newOpportunity.Revenue_Commencement__c.addMonths(6);
    //newOpportunity.Implementation_Revenue_as_a_of_FSR__c = 25;
    //
    //} else {
    //
    //newOpportunity.Implementation_Revenue__c = closeDate.addMonths(3);
    //newOpportunity.Revenue_Commencement__c = newOpportunity.Implementation_Revenue__c.addMonths(1).toStartOfMonth();
    //newOpportunity.Forecast_Full_Service_Revenue_Date__c = newOpportunity.Revenue_Commencement__c.addMonths(12);
    //newOpportunity.Implementation_Revenue_as_a_of_FSR__c = 20;
    //
    //}
    //
    //}
    //
    //}
    //
    //public static void updateRamp(Opportunity oldOpportunity, Opportunity updatedOpportunity) {
    //
    //if(virtualRecordTypeIds.contains(updatedOpportunity.RecordTypeId))
    //{
    //Date closeDate = updatedOpportunity.CloseDate;
    //
    //if(oldOpportunity.CloseDate != updatedOpportunity.CloseDate || oldOpportunity.Ramp_Profile__c != updatedOpportunity.Ramp_Profile__c){
    //if(updatedOpportunity.Ramp_Profile__c == 'Immediate'){
    //
    //updatedOpportunity.Implementation_Revenue__c = closeDate.addDays(15);
    //
    //if(updatedOpportunity.Implementation_Revenue__c.month() != oldOpportunity.Implementation_Revenue__c.month() || updatedOpportunity.Implementation_Revenue__c.year() != oldOpportunity.Implementation_Revenue__c.year() || oldOpportunity.Implementation_Revenue__c == null){
    //updatedOpportunity.Revenue_Commencement__c = updatedOpportunity.Implementation_Revenue__c.addMonths(1).toStartOfMonth();
    //updatedOpportunity.Forecast_Full_Service_Revenue_Date__c = updatedOpportunity.Revenue_Commencement__c.addMonths(3);
    //updatedOpportunity.Implementation_Revenue_as_a_of_FSR__c = 90/2;
    //}
    //
    //} else if(updatedOpportunity.Ramp_Profile__c == 'Standard') {
    //updatedOpportunity.Implementation_Revenue__c = closeDate.addMonths(3);
    //updatedOpportunity.Revenue_Commencement__c = updatedOpportunity.Implementation_Revenue__c.addMonths(1).toStartOfMonth();
    //updatedOpportunity.Forecast_Full_Service_Revenue_Date__c = updatedOpportunity.Revenue_Commencement__c.addMonths(3);
    //updatedOpportunity.Implementation_Revenue_as_a_of_FSR__c = 90/2;//1st MRF month set to 10%
    //
    //} else if(updatedOpportunity.Ramp_Profile__c == 'Medium') {
    //updatedOpportunity.Implementation_Revenue__c = closeDate.addMonths(3);
    //updatedOpportunity.Revenue_Commencement__c = updatedOpportunity.Implementation_Revenue__c.addMonths(1).toStartOfMonth();
    //updatedOpportunity.Forecast_Full_Service_Revenue_Date__c = updatedOpportunity.Revenue_Commencement__c.addMonths(6);
    //updatedOpportunity.Implementation_Revenue_as_a_of_FSR__c = 90/5;
    //
    //} else {
    //
    //updatedOpportunity.Implementation_Revenue__c = closeDate.addMonths(3);
    //updatedOpportunity.Revenue_Commencement__c = updatedOpportunity.Implementation_Revenue__c.addMonths(1).toStartOfMonth();
    //updatedOpportunity.Forecast_Full_Service_Revenue_Date__c = updatedOpportunity.Revenue_Commencement__c.addMonths(12);
    //updatedOpportunity.Implementation_Revenue_as_a_of_FSR__c = 90/11;
    //
    //}
    //
    //} else if((oldOpportunity.Implementation_Revenue__c != null && updatedOpportunity.Implementation_Revenue__c != null) && (oldOpportunity.Implementation_Revenue__c.month() != updatedOpportunity.Implementation_Revenue__c.month() || oldOpportunity.Implementation_Revenue__c.year() != updatedOpportunity.Implementation_Revenue__c.year())) {
    //
    //updatedOpportunity.Revenue_Commencement__c = updatedOpportunity.Implementation_Revenue__c.addMonths(1).toStartOfMonth();
    //
    //if(updatedOpportunity.Ramp_Profile__c == 'Immediate' || updatedOpportunity.Ramp_Profile__c == 'Standard') {
    //updatedOpportunity.Forecast_Full_Service_Revenue_Date__c = updatedOpportunity.Revenue_Commencement__c.addMonths(3);
    //} else if(updatedOpportunity.Ramp_Profile__c == 'Medium') {
    //updatedOpportunity.Forecast_Full_Service_Revenue_Date__c = updatedOpportunity.Revenue_Commencement__c.addMonths(6);
    //} else {
    //updatedOpportunity.Forecast_Full_Service_Revenue_Date__c = updatedOpportunity.Revenue_Commencement__c.addMonths(12);
    //}
    //}
    //}
    //
    //}
    //
    //public static void generateMonthlyRevenueForecast(Opportunity oldOpportunity, Opportunity updatedOpportunity) {
    //
    //// Only want to flex this code for the given record types
    //System.debug('### Record Type Ids: ' + virtualRecordTypeIds + ', Current Record Type Id: ' + updatedOpportunity.RecordTypeId);
    //
    //// If our opportunity is of the correct record type and the annual settlement is filled in, we're good to go!
    //if(virtualRecordTypeIds.contains(updatedOpportunity.RecordTypeId) && updatedOpportunity.Annual_Settlement_Value__c != null && updatedOpportunity.Annual_Settlement_Value__c > 0.00) {
    //
    //System.debug('### Starting calculation logic..');
    //
    //if (oldOpportunity.CloseDate != updatedOpportunity.CloseDate || oldOpportunity.Ramp_Profile__c != updatedOpportunity.Ramp_Profile__c ||
    //oldOpportunity.Annual_Settlement_Value__c != updatedOpportunity.Annual_Settlement_Value__c || oldOpportunity.Implementation_Revenue__c != updatedOpportunity.Implementation_Revenue__c ||
    //oldOpportunity.Implementation_Revenue_as_a_of_FSR__c != updatedOpportunity.Implementation_Revenue_as_a_of_FSR__c || oldOpportunity.Revenue_Commencement__c != updatedOpportunity.Revenue_Commencement__c ||
    //oldOpportunity.FSR_End_Date__c != updatedOpportunity.FSR_End_Date__c || oldOpportunity.Monthly_Txn_Revenue_POS__c != updatedOpportunity.Monthly_Txn_Revenue_POS__c ||
    //oldOpportunity.Annual_transaction_volume__c != updatedOpportunity.Annual_transaction_volume__c || oldOpportunity.Forecast_Adjustment__c != updatedOpportunity.Forecast_Adjustment__c ||
    //oldOpportunity.OwnerId != updatedOpportunity.OwnerId)
    //{
    //
    //System.debug('### Changes detected.. Removing old forecasts..');
    //
    //// First, we want to remove any existing forecasts for the opportunity
    //List<Monthly_Revenue_Forecast__c> existingMonthlyRevenueForecasts = new List<Monthly_Revenue_Forecast__c>();
    //
    //for(Opportunity opportunity : [SELECT Id, (SELECT Id FROM Monthly_Revenue_Forecasts__r) FROM Opportunity WHERE Id = :updatedOpportunity.Id])
    //{
    //if (opportunity.Monthly_Revenue_Forecasts__r.size() > 0) {
    //existingMonthlyRevenueForecasts.addAll(opportunity.Monthly_Revenue_Forecasts__r);
    //}
    //}
    //
    //delete existingMonthlyRevenueForecasts;
    //
    //List<Monthly_Revenue_Forecast__c> newMonthlyRevenueForecasts = new List<Monthly_Revenue_Forecast__c>();
    //
    //Integer forecastDuration = 12;
    //
    //if (updatedOpportunity.FSR_End_Date__c != null) {
    //forecastDuration = (updatedOpportunity.Revenue_Commencement__c).monthsBetween(updatedOpportunity.FSR_End_Date__c);
    //}
    //
    //if (forecastDuration > 0) {
    //
    //Decimal forecastAdjustment = updatedOpportunity.Forecast_Adjustment__c;
    //
    //Decimal adjustedAnnualSettlementValue = updatedOpportunity.Annual_Settlement_Value__c;
    //
    //Decimal annualTransactionVolume = updatedOpportunity.Annual_transaction_volume__c;
    //
    //Decimal monthlyFeesPerTransaction = updatedOpportunity.Monthly_Txn_Revenue_POS__c;
    //
    //Decimal monthlyTransactionVolume, annualTransactionVolumeRevenue, monthlyTransactionVolumeRevenue = 0.0;
    //
    //if (forecastAdjustment != null) {
    //adjustedAnnualSettlementValue = (adjustedAnnualSettlementValue) * (forecastAdjustment / 100);
    //}
    //
    //Decimal monthlySettlementValue = adjustedAnnualSettlementValue / forecastDuration;
    //
    //if (annualTransactionVolume != null) {
    //
    //if (forecastAdjustment != null) {
    //annualTransactionVolume = (updatedOpportunity.Annual_transaction_volume__c) * (forecastAdjustment / 100);
    //}
    //
    //monthlyTransactionVolume = annualTransactionVolume / forecastDuration;
    //annualTransactionVolumeRevenue = annualTransactionVolume * updatedOpportunity.Monthly_Txn_Revenue_POS__c;
    //monthlyTransactionVolumeRevenue = annualTransactionVolumeRevenue / forecastDuration;
    //}
    //
    //System.debug('### Implementation blah blah blah: ' + updatedOpportunity.Implementation_Revenue_as_a_of_FSR__c);
    //
    //Decimal rampIncrement = updatedOpportunity.Implementation_Revenue_as_a_of_FSR__c / 100;
    //Integer rampDuration = (updatedOpportunity.Revenue_Commencement__c).monthsBetween(updatedOpportunity.Forecast_Full_Service_Revenue_Date__c);
    //
    //Integer fullServiceRevenueDuration = forecastDuration - rampDuration;
    //
    //Date revenueCommencementDate = updatedOpportunity.Revenue_Commencement__c;
    //
    //Integer closeDateYear = updatedOpportunity.CloseDate.Year();
    //
    //VProfileId__c userSetting = VProfileId__c.getInstance(updatedOpportunity.OwnerId);
    //
    ////opportunityTeamsById.put(updatedOpportunity.Id, userSetting.Team_Name__c);
    //
    //for(Integer month = 0; month < rampDuration; month++) {
    //
    //Decimal ramp = 0.0;
    //
    //if (rampIncrement * (month) >= 0.1) {
    //ramp = rampIncrement * (month);
    //}
    //else {
    //ramp = 0.1;
    //}
    //
    //Decimal currentMonthSettlementValue = monthlySettlementValue * ramp;
    //
    //if(updatedOpportunity.Annual_transaction_volume__c != null) {
    //monthlyTransactionVolume = monthlyTransactionVolume * ramp;
    //monthlyTransactionVolumeRevenue = monthlyTransactionVolumeRevenue * ramp;
    //}
    //
    //Monthly_Revenue_Forecast__c monthlyRevenueForecast = new Monthly_Revenue_Forecast__c();
    //
    //monthlyRevenueForecast.Opportunity__c = updatedOpportunity.Id;
    //monthlyRevenueForecast.Account__c = updatedOpportunity.AccountId;
    //monthlyRevenueForecast.CurrencyIsoCode = updatedOpportunity.CurrencyIsoCode;
    //monthlyRevenueForecast.Name = monthIntegerToNameMap.get(revenueCommencementDate.addMonths(month).month()) +' '+ revenueCommencementDate.addMonths(month).year();
    //monthlyRevenueForecast.Revenue_Date__c = revenueCommencementDate.addMonths(month + 1).toStartOfMonth() - 1;
    //monthlyRevenueForecast.Monthly_Settlement1__c = currentMonthSettlementValue;
    //
    //if (updatedOpportunity.Annual_transaction_volume__c != null) {
    //monthlyRevenueForecast.Transactions__c = monthlyTransactionVolume;
    //monthlyRevenueForecast.Transaction_Revenue__c = monthlyTransactionVolumeRevenue;
    //}
    //
    //newMonthlyRevenueForecasts.add(monthlyRevenueForecast);
    //
    //}
    //
    //for(Integer month = rampDuration; month < rampDuration + fullServiceRevenueDuration; month++) {
    //
    //Monthly_Revenue_Forecast__c monthlyRevenueForecast = new Monthly_Revenue_Forecast__c();
    //
    //monthlyRevenueForecast.Opportunity__c = updatedOpportunity.Id;
    //monthlyRevenueForecast.Account__c = updatedOpportunity.AccountId;
    //monthlyRevenueForecast.CurrencyIsoCode = updatedOpportunity.CurrencyIsoCode;
    //monthlyRevenueForecast.Name = monthIntegerToNameMap.get(revenueCommencementDate.addMonths(month).month()) +' '+ revenueCommencementDate.addMonths(month).year();
    //monthlyRevenueForecast.Revenue_Date__c = revenueCommencementDate.addMonths(month + 1).toStartOfMonth() - 1;
    //monthlyRevenueForecast.Monthly_Settlement1__c = monthlySettlementValue;
    //
    //if (updatedOpportunity.Annual_transaction_volume__c != null) {
    //monthlyRevenueForecast.Transactions__c = monthlyTransactionVolume;
    //monthlyRevenueForecast.Transaction_Revenue__c = monthlyTransactionVolumeRevenue;
    //}
    //
    //newMonthlyRevenueForecasts.add(monthlyRevenueForecast);
    //
    //}
    //
    //// Database Class Method (DML operation)
    //Database.SaveResult[] srList = Database.insert(newMonthlyRevenueForecasts, false);
    //
    //// Iterate through each returned result
    //for (Database.SaveResult sr : srList) {
    //if (sr.isSuccess()) {
    //// Operation was successful, so get the ID of the record that was processed
    //system.debug('Successfully inserted MRF record. MRF ID: ' + sr.getId());
    //}
    //else {
    //// Operation failed, so get all errors
    //for(Database.Error err : sr.getErrors()) {
    //system.debug('The following error has occurred.');
    //system.debug(err.getStatusCode() + ': ' + err.getMessage());
    //system.debug('MRF fields that affected this error: ' + err.getFields());
    //}
    //}
    //}
    //
    //}
    //
    //}
    //
    //}
    //
    ////if(virtualRecordTypeIds.contains(updatedOpportunity.RecordTypeId) && (updatedOpportunity.Annual_Settlement_Value__c == null || updatedOpportunity.Annual_Settlement_Value__c == 0.00) && updatedOpportunity.StageName != '1) Qualified' && updatedOpportunity.StageName != 'Closed/Lost') {
    ////updatedOpportunity.addError('Please enter an annual settlement value!');
    ////}
    //
    //}
    //
}