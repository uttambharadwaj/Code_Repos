/* ************************************************************
 * Created By  : Phillip Southern (GearsCRM)
 * Created Date: 06/05/2013 
 * Description : Schedulable/Batchable Class UgallonsDataBatch
 * 
 * Modified By   : Phillip Southern
 * Modified Date : 12/11/13
 * Description   : aggregates moved to execute
 * 
 * ************************************************************/
global class UgallonsDataBatch implements Schedulable, Database.Batchable<SObject>   
{
    private final boolean isTest;
	private static Date currentDate = date.newinstance(system.now().year(),system.now().month(), system.now().day());
	private static Date yearcompare = date.newInstance(system.now().year(),1,1);
	private static Date movedMonth = currentdate.adddays(-60);
	private static Date monthCompare = date.newInstance(movedMonth.year(),movedMonth.month(),1);
	private GlobalSettings__c gs;	
    
    global UgallonsDataBatch(Boolean isTest)
    {
        this.isTest = isTest;
    }
    
    global UgallonsDataBatch()
    {
        this(false);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(GetQueryLocatorString());
    }

    private string GetQueryLocatorString()
    {
		gs = GlobalSettings__c.getOrgDefaults();
		

		/*string query = 'Select Id, Name, Gallons_MTD__c, Gallons_YTD__c, Gallons_Last_Three_Months__c from Account_Asset__c Where Id IN :monthlyAggKeySet ' +
						'OR Id IN :yearlyAggKeySet OR Gallons_MTD__c != null OR Gallons_YTD__c !=null OR Gallons_Last_Three_Months__c !=null';
		*/
		string query = 'Select Id, Name, Gallons_MTD__c, Gallons_YTD__c, Gallons_Last_Three_Months__c from Account_Asset__c ';
		query += ' where recordTypeId = \'' + gs.AccountAssetRecordTypeID__c + '\'';
		
		system.debug('-----' + query);

        if(isTest == true)
        {
            query += 'LIMIT 200'; //The size of one batch, since only one batch job can be run in a unit test
        }
        
        return query;
    }

    global void execute(Database.BatchableContext BC, List<SObject> records) 
    {
    	List<Account_Asset__c> accountAssetToUpdate = new List<Account_Asset__c>();
    	Set<Id> accountassetscope = new Set<Id>();
    	for(sobject s1 : records)
    	{
    		accountassetscope.add(s1.Id);
    	}
    	
    	Map<Id,AggregateResult> accountAssetMonthlyAgg = new Map<Id, AggregateResult>([Select Account_Asset__c Id, Sum(Gallons_Amount__c) sumAmt 
    																from Gallons_Data__c 
    																Where Account_Asset__c IN :accountassetscope AND
    																Gallon_Month__c >= :monthCompare Group By Account_Asset__c]);
		Map<Id,AggregateResult> accountAssetYearlyAgg = new Map<Id,AggregateResult>([Select Account_Asset__c Id, Sum(Gallons_Amount__c) sumAmt 
																	from Gallons_Data__c 
																	Where Account_Asset__c IN :accountassetscope AND
																	Gallon_Month__c >= :yearcompare Group By Account_Asset__c]);
																	
		for(sobject s: records)
		{
			Account_Asset__c aa = (Account_Asset__c)s;
			
			if(accountAssetYearlyAgg.containskey(aa.Id))
			{
				aa.Gallons_YTD__c = (aa.Gallons_MTD__c==null) ? (Double)((accountAssetYearlyAgg.get(aa.Id)).get('sumAmt')) : aa.Gallons_MTD__c + (Double)((accountAssetYearlyAgg.get(aa.Id)).get('sumAmt'));
			}else if(aa.Gallons_MTD__c!=null)
			{
				aa.Gallons_YTD__c = aa.Gallons_MTD__c;
			}else
			{
				aa.Gallons_YTD__c = 0;
			}
			
			if(accountAssetMonthlyAgg.containskey(aa.Id))
			{
				aa.Gallons_Last_Three_Months__c = (aa.Gallons_MTD__c==null) ? (double)((accountAssetMonthlyAgg.get(aa.Id)).get('sumAmt')) : aa.Gallons_MTD__c + (double)((accountAssetMonthlyAgg.get(aa.Id)).get('sumAmt'));
			}else if(aa.Gallons_MTD__c!=null)
    		{
    			aa.Gallons_Last_Three_Months__c = aa.Gallons_MTD__c;
    		}else
    		{
    			aa.Gallons_Last_Three_Months__c = 0;
    		}

			
			accountAssetToUpdate.add(aa);
		}

    	if(accountAssetToUpdate.size()> 0)
    	{
    		update accountAssetToUpdate;
    	}      
    }

    global void finish(Database.BatchableContext BC) 
    {
        //After this batch completes, call the account batch to send data up to account.
        ID batchprocessid = Database.executeBatch(new UgallonsDataAccountBatch()); 
    } 
    
    global void execute(SchedulableContext SC) 
    {
        ID batchprocessid = Database.executeBatch(new UgallonsDataBatch());
    }
    
    /*public static void schedule()
    {
        schedule(null);
    }
    
    public static void schedule(string jobSchedule)
    {
        if(jobSchedule == null || jobSchedule.trim().length() == 0)
        {
            jobSchedule = '0 0 1 * * ?'; //Run the class at 1:00 AM every day
        }
                
        System.schedule('UgallonsDataBatch Nightly Batch Processing', jobSchedule, new UgallonsDataBatch());
    }*/
}