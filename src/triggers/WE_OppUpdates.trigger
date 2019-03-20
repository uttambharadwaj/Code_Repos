trigger WE_OppUpdates on Opportunity (before insert, before update){
    
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
    
    If(Trigger.isInsert){
        
        for(Opportunity o : Trigger.new){
            if(validRecordTypeIds.contains(o.RecordTypeId))
            {
                Date cd = o.CloseDate;
                
                if(o.Ramp_Profile__c == 'Immediate'){
                    o.Implementation_Revenue__c = cd.addDays(15);
                    o.Revenue_Commencement__c = o.Implementation_Revenue__c.addMonths(1).toStartOfMonth();
                    o.Forecast_Full_Service_Revenue_Date__c = o.Revenue_Commencement__c.addMonths(3);
                    o.Implementation_Revenue_as_a_of_FSR__c = 37.5;
                    if (o.Annual_Settlement_Value__c == null){
                        o.Annual_Settlement_Value__c = 0; //cover Lead Conversion when default value not populated
                    }
                        
                }else if(o.Ramp_Profile__c == 'Standard'){
                    o.Implementation_Revenue__c = cd.addMonths(3);
                    o.Revenue_Commencement__c = o.Implementation_Revenue__c.addMonths(1).toStartOfMonth();
                    o.Forecast_Full_Service_Revenue_Date__c = o.Revenue_Commencement__c.addMonths(3);
                    o.Implementation_Revenue_as_a_of_FSR__c = 37.5;
                    
                }else if(o.Ramp_Profile__c == 'Medium'){
                    o.Implementation_Revenue__c = cd.addMonths(3);
                    o.Revenue_Commencement__c = o.Implementation_Revenue__c.addMonths(1).toStartOfMonth();
                    o.Forecast_Full_Service_Revenue_Date__c = o.Revenue_Commencement__c.addMonths(6);
                    o.Implementation_Revenue_as_a_of_FSR__c = 25;
                    
                }else{//'Extended' Ramp Profile
                    o.Implementation_Revenue__c = cd.addMonths(3);
                    o.Revenue_Commencement__c = o.Implementation_Revenue__c.addMonths(1).toStartOfMonth();
                    o.Forecast_Full_Service_Revenue_Date__c = o.Revenue_Commencement__c.addMonths(12);
                    o.Implementation_Revenue_as_a_of_FSR__c = 20;
                }
            }
        }
    }
    
    If(Trigger.isUpdate){
                for(Opportunity o : Trigger.new){
                    if(validRecordTypeIds.contains(o.RecordTypeId))
                    {
                        Date cd = o.CloseDate;
                        
                        Opportunity oldOpp = Trigger.oldMap.get(o.Id);
                        
                        if(oldOpp.CloseDate != o.CloseDate
                           ||
                           oldOpp.Ramp_Profile__c != o.Ramp_Profile__c){
                               if(o.Ramp_Profile__c == 'Immediate'){
                                   o.Implementation_Revenue__c = cd.addDays(15);
                                   if(o.Implementation_Revenue__c.month() != oldOpp.Implementation_Revenue__c.month()
                                      ||
                                      o.Implementation_Revenue__c.year() != oldOpp.Implementation_Revenue__c.year()
                                      || 
                                      oldOpp.Implementation_Revenue__c == null){
                                          o.Revenue_Commencement__c = o.Implementation_Revenue__c.addMonths(1).toStartOfMonth();
                                          o.Forecast_Full_Service_Revenue_Date__c = o.Revenue_Commencement__c.addMonths(3);
                                          o.Implementation_Revenue_as_a_of_FSR__c = 90/2;
                                      }
                               }else if(o.Ramp_Profile__c == 'Standard'){
                                   o.Implementation_Revenue__c = cd.addMonths(3);
                                   o.Revenue_Commencement__c = o.Implementation_Revenue__c.addMonths(1).toStartOfMonth();
                                   o.Forecast_Full_Service_Revenue_Date__c = o.Revenue_Commencement__c.addMonths(3);
                                   o.Implementation_Revenue_as_a_of_FSR__c = 90/2;//1st MRF month set to 10%
                                   
                               }else if(o.Ramp_Profile__c == 'Medium'){
                                   o.Implementation_Revenue__c = cd.addMonths(3);
                                   o.Revenue_Commencement__c = o.Implementation_Revenue__c.addMonths(1).toStartOfMonth();
                                   o.Forecast_Full_Service_Revenue_Date__c = o.Revenue_Commencement__c.addMonths(6);
                                   o.Implementation_Revenue_as_a_of_FSR__c = 90/5;
                                   
                               }else{//'Extended' Ramp Profile
                                   o.Implementation_Revenue__c = cd.addMonths(3);
                                   o.Revenue_Commencement__c = o.Implementation_Revenue__c.addMonths(1).toStartOfMonth();
                                   o.Forecast_Full_Service_Revenue_Date__c = o.Revenue_Commencement__c.addMonths(12);
                                   o.Implementation_Revenue_as_a_of_FSR__c = 90/11;
                               }
                           }else if(oldOpp.Implementation_Revenue__c.month() != o.Implementation_Revenue__c.month()
                                    || 
                                    oldOpp.Implementation_Revenue__c.year() != o.Implementation_Revenue__c.year()){
                                        o.Revenue_Commencement__c = o.Implementation_Revenue__c.addMonths(1).toStartOfMonth();
                                        
                                        if(o.Ramp_Profile__c == 'Immediate' || o.Ramp_Profile__c == 'Standard'){
                                            o.Forecast_Full_Service_Revenue_Date__c = o.Revenue_Commencement__c.addMonths(3);
                                            
                                        }else if(o.Ramp_Profile__c == 'Medium'){
                                            o.Forecast_Full_Service_Revenue_Date__c = o.Revenue_Commencement__c.addMonths(6);
                                            
                                        }else{//'Extended' Ramp Profile
                                            o.Forecast_Full_Service_Revenue_Date__c = o.Revenue_Commencement__c.addMonths(12);
                                        }
                                    }
                    }
                }
    }
    
}