/* ************************************************************
 * Created By  : Phillip Southern (GearsCRM)
 * Created Date: 06/17/2013 
 * Description : Class UAccountAsset
 * 
 * Modified By   : Raja Yeccherla(GearsCRM)
 * Modified Date : 02/17/2015
 * Description   :
 * 
 * ************************************************************/

public class UAccountAsset 
{
    public static void opportunityPopulation(List<Account_Asset__c> records, Map<ID,Account_Asset__c> oldMap)
    {
        boolean isInsert = (oldMap == null);
        GlobalSettings__c gc = GlobalSettings__c.getorgdefaults();
        
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        for(Account_Asset__c aac : records)
        {
            if(aac.Opportunity__c!=null 
               && aac.RecordTypeID == gc.AccountAssetRecordTypeID__c
               &&
               (isInsert == true 
                || 
               (isInsert == false 
                 && oldMap.get(aac.Id).Opportunity__c != aac.Opportunity__c 
                 )))
            {
                Opportunity o = new Opportunity(id=aac.Opportunity__c);
                o.Account_Asset__c = aac.Id;
                opportunitiesToUpdate.add(o);
                //system.debug('-- filtered: ' + o);
            }
        }
        
        if(opportunitiesToUpdate.size()>0)
        {
            update opportunitiesToUpdate;
        }
    }
    
    public static void setAccountAssetStoppedPumping(Set<Id> recordIds)
    {   
        List<Account_Asset__c> recordsToUpdate = new List<Account_Asset__c>();
        
        DateTime now = DateTime.now();
        
        Date currentMonth = Date.newInstance(now.year(), now.month(), 1); //Set to the first of the month
        Date currentMonthMinus1 = Date.newInstance(now.year(), now.addMonths(-1).month(), 1);
        Date currentMonthMinus2 = Date.newInstance(now.year(), now.addMonths(-2).month(), 1);
        Date currentMonthMinus3 = Date.newInstance(now.year(), now.addMonths(-3).month(), 1);
        
        for(Account_Asset__c record : [select 
                                            Id,
                                            Stopped_Pumping__c,
                                            (select
                                                    Id,
                                                    Gallon_Month__c
                                                from
                                                    Gallons_Data__r
                                                where
                                                    (Gallon_Month__c <= :currentMonth and
                                                    Gallon_Month__c > :currentMonthMinus3)
                                                order by 
                                                    Gallon_Month__c desc)
                                        from
                                            Account_Asset__c
                                        where 
                                            Id in :recordIds])
        {
            UGears.UDebug.printDebug('GALLONS DATA: ' + record.Gallons_Data__r);
            
            Boolean stoppedPumping = false;
            Boolean hasCurrentMonthData = false;
            Boolean hasCurrentMonthMinus1Data = false;
            Boolean hasCurrentMonthMinus2Data = false;
            
            for(Gallons_Data__c gallonsData : record.Gallons_Data__r)
            {
                if(gallonsData.Gallon_Month__c != null)
                {
                    if(gallonsData.Gallon_Month__c.month() == currentMonth.month())
                    {
                        //We have a record for this month
                        stoppedPumping = false;
                        hasCurrentMonthData = true;
                        
                        break;
                    }
                    else if(gallonsData.Gallon_Month__c.month() == currentMonthMinus1.month())
                    {
                        hasCurrentMonthMinus1Data = true;
                    }
                    else if(gallonsData.Gallon_Month__c.month() == currentMonthMinus2.month())
                    {
                        hasCurrentMonthMinus2Data = true;
                    }       
                }
            }
            
            if(hasCurrentMonthData == false)
            {
                if(hasCurrentMonthMinus1Data == true && hasCurrentMonthMinus2Data == true)
                {
                    stoppedPumping = true;
                }
            }
            
            record.Stopped_Pumping__c = stoppedPumping; 
            
            recordsToUpdate.add(record);                    
        }       
        
        UGears.UDebug.printDebug('RECORDS TO UPDATE: ' + recordsToUpdate);                      
        
        try
        {
            update recordsToUpdate;
        }   
        catch(DmlException e)
        {
            System.debug('EXCEPTION: ' + e);
        }   
    }
    
    public static void setAccountAssetsSignedButNotActivated(Set<Id> recordIds)
    {
        List<Account_Asset__c> recordsToUpdate = new List<Account_Asset__c>();
        
        for(Account_Asset__c record : [select 
                                            Id,
                                            Signed_But_Not_Activated__c,
                                            Core_Card_Created__c                                            
                                        from
                                            Account_Asset__c
                                        where 
                                            Id in :recordIds and
                                            Activated__c = null and 
                                            Core_Card_Created__c != null and 
                                            IsDeleted = false])
        {
            if(record.Core_Card_Created__c < Date.today().addDays(-15))
            {
                record.Signed_But_Not_Activated__c = true;
            }
            else
            {
                record.Signed_But_Not_Activated__c = false;
            }
            
            recordsToUpdate.add(record);
        }
        
        try
        {
            update recordsToUpdate;
        }
        catch(DmlException e)
        {
            System.debug('EXCEPTION: ' + e);
        }
    }
    
    public static void setAccountAssetsActivatedButNotPumped(Set<Id> recordIds)
    {
        List<Account_Asset__c> recordsToUpdate = new List<Account_Asset__c>();
        
        for(Account_Asset__c record : [select 
                                            Id,
                                            Activated__c,
                                            Last_Activity__c                                            
                                        from
                                            Account_Asset__c
                                        where 
                                            Id in :recordIds and                                            
                                            Status_N__c = 'Active' and 
                                            IsDeleted = false])
        {
            if(record.Last_Activity__c == null && record.Activated__c < Date.today().addDays(-30))
            {
                record.Activated_Not_Pumped__c = true;
            }
            else
            {
                record.Activated_Not_Pumped__c = false;
            }
            
            recordsToUpdate.add(record);
        }
        
        UGears.UDebug.printDebug('RECORDS TO UPDATE: ' + recordsToUpdate);
        
        try
        {
            update recordsToUpdate;
        }
        catch(DmlException e)
        {
            System.debug('EXCEPTION: ' + e);
        }
    }
}