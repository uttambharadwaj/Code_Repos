//revision history https://gist.github.com/aplssf/d542bde2095be928e088/revisions
trigger WE_MRFv2 on Opportunity (after insert, after update){
    
    //check whether code has been deactivated for user / profile via Custom Setting
    Id profileId = userinfo.getProfileId();
    VApexC__c profileTriggerController = VApexC__c.getInstance(profileId); 
    boolean profileSetting = profileTriggerController.Opportunity_Forecast_Disabled__c;
    system.debug('profileSetting status is ' + profileSetting);
    
    Id userId = userinfo.getUserId();
    VApexC__c userTriggerController = VApexC__c.getInstance(userId); 
    boolean userSetting = userTriggerController.Opportunity_Forecast_Disabled__c;
    system.debug('userSetting status is ' + userSetting);
    
    if(profileSetting == false && userSetting == false){
        
        //retrieve all Record Types (names & Ids) from org
        Map<String, Schema.RecordTypeInfo> RT = Opportunity.SObjectType.getDescribe().getRecordTypeInfosByName();
        //retrieve all values from list Custom Setting
        List<VRTN__c> weRTs = VRTN__c.getall().values();
        
        List<String> weRTNames = new List<String>();
        Set<Id> validRecordTypeIds = new Set<Id>();
        
        // add Opportunity Record Type Ids from Custom Setting to list of valid Ids      
        for(VRTN__c weRT : weRTs) {
            try {
                //retrieve Record Types from Custom Setting field
                weRTNames.add(weRT.EUOpps__c);
            } catch (System.StringException e) {
                System.debug(System.LoggingLevel.ERROR,'Invalid Record Type Name ' + weRT.NAEUOpps__c);
            }
        }
        system.debug('weRTNames contains ' + weRTNames);
        
        for(String weRTN : weRTNames) {
            //checks whether the RT is included in the list retrieved from the Custom Setting field
            if(RT.get(weRTN) != null){
                SYSTEM.debug(RT.get(weRTN).getRecordTypeId());
                //add the RT ids to the list of valid Ids for your trigger logic
                validRecordTypeIds.add(RT.get(weRTN).getRecordTypeId());
            }
        }
        system.debug('validRecordTypeIds contains ' + validRecordTypeIds);
        
        List<Opportunity> insOpps = new List<Opportunity>();
        List<Opportunity> upOpps = new List<Opportunity>();
        Map<Id,Integer> forecastDuration = new Map<Id,Integer>();
        Map<Integer,String> monthName = new Map<Integer,String>{1 => 'January', 2 => 'February', 3 => 'March', 4 => 'April', 5 => 'May', 6 => 'June', 7 => 'July', 8 => 'August', 9 => 'September', 10 => 'October', 11 => 'November', 12 => 'December'};
        List<Monthly_Revenue_Forecast__c> existMRFs = new List<Monthly_Revenue_Forecast__c>();
        List<Monthly_Revenue_Forecast__c> newMRFs = new List<Monthly_Revenue_Forecast__c>();
        Map<Id,Decimal> oppsRampPer = new Map<Id,Decimal>();
        
        
        If(Trigger.isInsert){
            for(Opportunity o : Trigger.New){
                if(validRecordTypeIds.contains(o.RecordTypeId) && o.Type != 'Existing Customer - Administration')
                {
                    if(o.FSR_End_Date__c == null){
                        forecastDuration.put(o.Id,12);
                    }else{
                        forecastDuration.put(o.Id, o.Revenue_Commencement__c.monthsBetween(o.FSR_End_Date__c));
                    }
                    insOpps.add(o);
                }
            }
        }
        
        If(Trigger.isUpdate){
            for(Opportunity o : Trigger.New){
                
                if(validRecordTypeIds.contains(o.RecordTypeId) && o.Type != 'Existing Customer - Administration')
                {
                    Opportunity oldO = Trigger.OldMap.get(o.Id);
                    
                    if(oldO.CloseDate != o.CloseDate
                       ||
                       oldO.Ramp_Profile__c != o.Ramp_Profile__c
                       ||
                       oldO.Annual_Settlement_Value__c != o.Annual_Settlement_Value__c
                       ||
                       oldO.Implementation_Revenue__c != o.Implementation_Revenue__c
                       ||
                       oldO.Implementation_Revenue_as_a_of_FSR__c != oldO.Implementation_Revenue_as_a_of_FSR__c
                       ||
                       oldO.FSR_End_Date__c != o.FSR_End_Date__c
                       ||
                       oldO.Monthly_Txn_Revenue_POS__c != o.Monthly_Txn_Revenue_POS__c
                       ||
                       oldO.Annual_transaction_volume__c != o.Annual_transaction_volume__c
                       ||
                       oldo.Forecast_Adjustment__c != o.Forecast_Adjustment__c)
                    {
                        if(o.FSR_End_Date__c == null){
                            forecastDuration.put(o.Id,12);
                        }else{
                            forecastDuration.put(o.Id, o.Revenue_Commencement__c.monthsBetween(o.FSR_End_Date__c));
                        }
                        upOpps.add(o);
                    }
                }
            }
        }
        
        if(insOpps.size() > 0){
            
            for(Opportunity o : insOpps){
                
                Integer fcstDuration = forecastDuration.get(o.Id);
                if(fcstDuration > 0){
                    
                    Decimal fcstAdjst = o.Forecast_Adjustment__c;
                    
                    //adjust Annual Settlement
                    Decimal asv = null;
                    //cannot multiply by null
                    if(fcstAdjst != null){
                        Decimal sett = o.Annual_Settlement_Value__c;
                        asv = sett*(fcstAdjst/100);
                    } else {
                        asv = o.Annual_Settlement_Value__c;
                    }
                    Decimal monthlySett = asv/fcstDuration;
                    
                    //adjust Annual Transaction Volume
                    Decimal annualTxns = null;
                    if(fcstAdjst != null){
                        Decimal txns = o.Annual_transaction_volume__c;
                        annualTxns = txns*(fcstAdjst/100);
                    } else {
                        annualTxns = o.Annual_transaction_volume__c;
                    }
                    Decimal monthlyTxns = annualTxns/fcstDuration;
                    Decimal annualTxnRev = annualTxns*o.Monthly_Txn_Revenue_POS__c;
                    Decimal monthlyTxnRev = annualTxnRev/fcstDuration;
                    
                    //Ramp calculations
                    Decimal increment = o.Implementation_Revenue_as_a_of_FSR__c/100;
                    Integer rDur = o.Revenue_Commencement__c.monthsBetween(o.Forecast_Full_Service_Revenue_Date__c);
                    
                    //FSR calculations
                    Integer fsrDur = forecastDuration.get(o.Id) - rDur;
                    
                    Date rc = o.Revenue_Commencement__c;
                    
                    //add Monthly Forecast records for 'ramp' months
                    for(Integer m = 0; m < rDur; m++){
                        
                        Decimal ramp = 0;
                        
                        if(m == 0){
                            Decimal rampPer = 0.1;
                            ramp = rampPer;
                        }else if(increment*(m) >= 0.1){
                            Decimal rampPer = increment*(m);
                            ramp = rampPer;
                        }else{
                            Decimal rampPer = 0.1;
                            ramp = rampPer;
                        }
                        
                        Decimal monthTxns = monthlyTxns*ramp;
                        Decimal monthSett = monthlySett*ramp;
                        Decimal monthTxnRev = monthlyTxnRev*ramp;
                        
                        Monthly_Revenue_Forecast__c fm = new Monthly_Revenue_Forecast__c();
                        fm.Opportunity__c = o.Id;
                        fm.Account__c = o.AccountId;
                        fm.CurrencyIsoCode = o.CurrencyIsoCode;
                        fm.Name = monthName.get(rc.addMonths(m).month()) +' '+ rc.addMonths(m).year();
                        fm.Revenue_Date__c = rc.addMonths(m+1).toStartOfMonth()-1;
                        fm.Transactions__c = monthTxns;
                        fm.Monthly_Settlement1__c = monthSett;
                        fm.Transaction_Revenue__c = monthTxnRev;
                        
                        newMRFs.add(fm);
                    }
                    
                    //add Monthly Forecast Records for rFSR Months
                    for(Integer m = rDur; m < rDur + fsrDur; m++){
                        
                        Monthly_Revenue_Forecast__c fm = new Monthly_Revenue_Forecast__c();
                        fm.Opportunity__c = o.Id;
                        fm.Account__c = o.AccountId;
                        fm.CurrencyIsoCode = o.CurrencyIsoCode;
                        fm.Name = monthName.get(rc.addMonths(m).month()) +' '+ rc.addMonths(m).year();
                        fm.Revenue_Date__c = rc.addMonths(m+1).toStartOfMonth()-1;
                        fm.Transactions__c = monthlyTxns;
                        fm.Monthly_Settlement1__c = monthlySett;
                        fm.Transaction_Revenue__c = monthlyTxnRev;
                        
                        newMRFs.add(fm);
                    }
                }
            }
        }
        
        if(upOpps.size() > 0){
            
            for(Opportunity o : [SELECT Id,
                                (SELECT Id FROM Monthly_Revenue_Forecasts__r) FROM Opportunity
                                  WHERE Id = :upOpps])
            {               
                if(o.Monthly_Revenue_Forecasts__r.size()> 0){
                    existMRFs.addAll(o.Monthly_Revenue_Forecasts__r);
                }
            }
            delete existMRFs;
            
            for(Opportunity o : upOpps){
                
                Integer fcstDuration = forecastDuration.get(o.Id);
                if(fcstDuration > 0){
                    
                    Decimal fcstAdjst = o.Forecast_Adjustment__c;
                    
                    //adjust Annual Settlement
                    Decimal asv = null;
                    //cannot multiply by null
                    if(fcstAdjst != null){
                        Decimal sett = o.Annual_Settlement_Value__c;
                        asv = sett*(fcstAdjst/100);
                    } else {
                        asv = o.Annual_Settlement_Value__c;
                    }
                    Decimal monthlySett = asv/fcstDuration;
                    
                    //adjust Annual Transaction Volume
                    Decimal annualTxns = null;
                    if(fcstAdjst != null){
                        Decimal txns = o.Annual_transaction_volume__c;
                        annualTxns = txns*(fcstAdjst/100);
                    } else {
                        annualTxns = o.Annual_transaction_volume__c;
                    }
                    Decimal monthlyTxns = annualTxns/fcstDuration;
                    Decimal annualTxnRev = annualTxns*o.Monthly_Txn_Revenue_POS__c;
                    Decimal monthlyTxnRev = annualTxnRev/fcstDuration;
                    
                    //Ramp calculations
                    Decimal increment = o.Implementation_Revenue_as_a_of_FSR__c/100;
                    Integer rDur = o.Revenue_Commencement__c.monthsBetween(o.Forecast_Full_Service_Revenue_Date__c);
                    
                    //FSR calculations
                    Integer fsrDur = forecastDuration.get(o.Id) - rDur;
                    
                    Date rc = o.Revenue_Commencement__c;
                    
                    //add Monthly Forecast records for 'ramp' months
                    for(Integer m = 0; m < rDur; m++){
                        
                        Decimal ramp = 0;
                        
                        if(m == 0){
                            Decimal rampPer = 0.1;
                            ramp = rampPer;
                        }else if(increment*(m) >= 0.1){
                            Decimal rampPer = increment*(m);
                            ramp = rampPer;
                        }else{
                            Decimal rampPer = 0.1;
                            ramp = rampPer;
                        }
                        
                        Decimal monthTxns = monthlyTxns*ramp;
                        Decimal monthSett = monthlySett*ramp;
                        Decimal monthTxnRev = monthlyTxnRev*ramp;
                        
                        Monthly_Revenue_Forecast__c fm = new Monthly_Revenue_Forecast__c();
                        fm.Opportunity__c = o.Id;
                        fm.Account__c = o.AccountId;
                        fm.CurrencyIsoCode = o.CurrencyIsoCode;
                        fm.Name = monthName.get(rc.addMonths(m).month()) +' '+ rc.addMonths(m).year();
                        fm.Revenue_Date__c = rc.addMonths(m+1).toStartOfMonth()-1;
                        fm.Transactions__c = monthTxns;
                        fm.Monthly_Settlement1__c = monthSett;
                        fm.Transaction_Revenue__c = monthTxnRev;
                        
                        newMRFs.add(fm);
                    }
                    
                    //add Monthly Forecast Records for rFSR Months
                    for(Integer m = rDur; m < rDur + fsrDur; m++){
                        
                        Monthly_Revenue_Forecast__c fm = new Monthly_Revenue_Forecast__c();
                        fm.Opportunity__c = o.Id;
                        fm.Account__c = o.AccountId;
                        fm.CurrencyIsoCode = o.CurrencyIsoCode;
                        fm.Name = monthName.get(rc.addMonths(m).month()) +' '+ rc.addMonths(m).year();
                        fm.Revenue_Date__c = rc.addMonths(m+1).toStartOfMonth()-1;
                        fm.Transactions__c = monthlyTxns;
                        fm.Monthly_Settlement1__c = monthlySett;
                        fm.Transaction_Revenue__c = monthlyTxnRev;
                        
                        newMRFs.add(fm);
                    }
                }
            }
        }
        // Database Class Method (DML operation)
        Database.SaveResult[] srList = Database.insert(newMRFs, false);
        
        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted MRF record. MRF ID: ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('MRF fields that affected this error: ' + err.getFields());
                }
            }
        }
    }
}