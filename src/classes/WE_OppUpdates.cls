public class WE_OppUpdates {
    
    // constructor
    public static void recursiveInsert(Opportunity[] records)
    {
        // if list is outside constructor, causes error 'variable does not exist'
        Opportunity[] oppsToClone = new Opportunity[]{};
        
        if(WE_ApexUtility.apxCntrlrOppMrfStatusAssessed == false)
        {
            WE_ApexUtility.checkApexControllerStatus('Opportunity MRF');
        }
        if (!WE_ApexUtility.forecastDisabled.contains(true))
        {
            // deactivate validation rules before cloning - only affects Opportunities created from Lead conversion
            // when Before Insert context is skipped
            Id userId = userinfo.getUserId();
            WE_VRC__c setting = WE_VRC__c.getInstance(userId);
            setting.All_Opportunity_Disabled__c = True;
            upsert setting;
            
            // create object from Class
            WE_ApexUtility apxUtil = new WE_ApexUtility();
            apxUtil.retrieveValidRecordTypes('EU NA Opps');
            
            for(Opportunity o : records){
                if (WE_ApexUtility.validEuNaRecordTypeIds.contains(o.RecordTypeId) )
                {
                    oppsToClone.add(o);
                }
            }
            if (oppsToClone.size() > 0)
            {
                WE_ApexUtility.recursiveOppUpdate(oppsToClone,true);
            }
            // !!! check that this is executed at right time
            setting.All_Opportunity_Disabled__c = False;
            upsert setting;
        }
    }

    // method adapted from this solution http://salesforce.stackexchange.com/a/103035/10720
    public static void updateOpportunities(Opportunity[] oldRecords, Opportunity[] newRecords)
    {
        if(WE_ApexUtility.apxCntrlrOppMrfStatusAssessed == false)
        {
            WE_ApexUtility.checkApexControllerStatus('Opportunity MRF');
        }
        if (!WE_ApexUtility.forecastDisabled.contains(true))
        {
            // create object from Class
            WE_ApexUtility apxUtil = new WE_ApexUtility();
            apxUtil.retrieveValidRecordTypes('EU NA Opps');
            
            for(Integer index = 0, size = newRecords.size(); index < size; index++) {
                Opportunity oldRecord = oldRecords[index], newRecord = newRecords[index];
                
                if (WE_ApexUtility.validEuNaRecordTypeIds.contains(newRecord.RecordTypeId) )
                {

                    Date cd = newRecord.CloseDate;
                    
                    system.debug('WE_OppUpdates: recursiveOppUpdate is ' + WE_ApexUtility.recursiveOppUpdate);
                    
                    if (WE_ApexUtility.recursiveOppUpdate ||// is only set to True on Insert, in constructor
                        oldRecord.CloseDate != newRecord.CloseDate || 
                        oldRecord.Ramp_Profile__c != newRecord.Ramp_Profile__c) 
                    {
                            if (newRecord.Ramp_Profile__c == 'Immediate') 
                            {
                                newRecord.Implementation_Revenue__c = cd.addDays(15);
                                
                                if (oldRecord.Implementation_Revenue__c == null || // this field will be null after insert but exception will not be hit if testing for null first
                                    oldRecord.Implementation_Revenue__c.month() != newRecord.Implementation_Revenue__c.month() ||
                                    oldRecord.Implementation_Revenue__c.year() != newRecord.Implementation_Revenue__c.year())
                                {
                                    newRecord.Revenue_Commencement__c = newRecord.Implementation_Revenue__c.addMonths(1).toStartOfMonth();
                                    newRecord.Forecast_Full_Service_Revenue_Date__c = newRecord.Revenue_Commencement__c.addMonths(3);
                                    newRecord.Implementation_Revenue_as_a_of_FSR__c = 90/2;
                                }
                            }
                        else if (newRecord.Ramp_Profile__c == 'Standard') 
                        {
                            newRecord.Implementation_Revenue__c = cd.addMonths(3);
                            newRecord.Revenue_Commencement__c = newRecord.Implementation_Revenue__c.addMonths(1).toStartOfMonth();
                            newRecord.Forecast_Full_Service_Revenue_Date__c = newRecord.Revenue_Commencement__c.addMonths(3);
                            newRecord.Implementation_Revenue_as_a_of_FSR__c = 90/2;//1st MRF month set to 10%
                        } 
                        else if (newRecord.Ramp_Profile__c == 'Medium') 
                        {
                            newRecord.Implementation_Revenue__c = cd.addMonths(3);
                            newRecord.Revenue_Commencement__c = newRecord.Implementation_Revenue__c.addMonths(1).toStartOfMonth();
                            newRecord.Forecast_Full_Service_Revenue_Date__c = newRecord.Revenue_Commencement__c.addMonths(6);
                            newRecord.Implementation_Revenue_as_a_of_FSR__c = 90/5;
                        } 
                        else 
                        {//'Extended' Ramp Profile
                            newRecord.Implementation_Revenue__c = cd.addMonths(3);
                            newRecord.Revenue_Commencement__c = newRecord.Implementation_Revenue__c.addMonths(1).toStartOfMonth();
                            newRecord.Forecast_Full_Service_Revenue_Date__c = newRecord.Revenue_Commencement__c.addMonths(12);
                            newRecord.Implementation_Revenue_as_a_of_FSR__c = 90/11;
                        }
                    }
                    else if (oldRecord.Implementation_Revenue__c.month() != newRecord.Implementation_Revenue__c.month() || 
                             oldRecord.Implementation_Revenue__c.year() != newRecord.Implementation_Revenue__c.year())
                    {
                        newRecord.Revenue_Commencement__c = newRecord.Implementation_Revenue__c.addMonths(1).toStartOfMonth();
                              
                              if (newRecord.Ramp_Profile__c == 'Immediate' || newRecord.Ramp_Profile__c == 'Standard')
                              {
                                  newRecord.Forecast_Full_Service_Revenue_Date__c = newRecord.Revenue_Commencement__c.addMonths(3);
                              } 
                        else if (newRecord.Ramp_Profile__c == 'Medium')
                        {
                            newRecord.Forecast_Full_Service_Revenue_Date__c = newRecord.Revenue_Commencement__c.addMonths(6);
                        } 
                        else 
                        {//'Extended' Ramp Profile
                            newRecord.Forecast_Full_Service_Revenue_Date__c = newRecord.Revenue_Commencement__c.addMonths(12);
                        }
                    }
                }
            }
        }
    }
}