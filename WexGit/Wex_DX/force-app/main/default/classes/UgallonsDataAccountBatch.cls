/* ************************************************************
 * Created By  : Phillip Southern (GearsCRM)
 * Created Date: 06/11/2013
 * Description : Schedulable/Batchable Class UgallonsDataAccountBatch
 * 
 * Modified By   : Phillip Southern (GearsCRM)
 * Modified Date : 12/12/2013
 * Description   : Move aggregates to execute
 * 
 * ************************************************************/
global class UgallonsDataAccountBatch implements Schedulable, Database.Batchable<SObject>   
{
    private final boolean isTest;

    /*
    Map<Id,AggregateResult> accountAssetMonthlyAgg = new Map<Id, AggregateResult>([Select Account__c Id, Sum(Gallons_Last_Three_Months__c) sumAmt from Account_Asset__c 
    																				Where Account__c != null Group By Account__c]);
    Map<Id,AggregateResult> accountAssetYearlyAgg = new Map<Id,AggregateResult>([Select Account__c Id, Sum(Gallons_YTD__c) sumAmt from Account_Asset__c 
    																			Where Account__c != null Group By Account__c]);
    Map<Id,AggregateResult> accountMinAgg = new Map<Id,AggregateResult>([Select Account_Asset__r.Account__c Id, MIN(Gallon_Month__c)minDate from Gallons_Data__c 
    																	Where Account_Asset__r.Account__c != null Group by Account_Asset__r.Account__c]);
    Set<Id> monthlyAggKeySet = accountAssetMonthlyAgg.keySet();
    Set<Id> yearlyAggKeySet = accountAssetYearlyAgg.keySet();
    Set<Id> minAggKeySet = accountAssetMonthlyAgg.keySet();
	*/
    
    global UgallonsDataAccountBatch(Boolean isTest)
    {
        this.isTest = isTest;
    }
    
    global UgallonsDataAccountBatch()
    {
        this(false);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(GetQueryLocatorString());
    }
    
    private string GetQueryLocatorString()
    {
        //string query = 'Select Account_Asset__r.Account__c Id, MIN(CreatedDate)minDate from Gallons_Data__c Where Account_Asset__r.Account__c != null Group by Account_Asset__r.Account__c'; 
		//scope needs to be all accounts with an account asset that has summary data or gallons data below it.
		//-account asset could exist with mtd but no gallons data.
		//-gallon data could exist but account asset has no summaries.  False because first batch job will run before this.
    	
    	//so scope could be account asset with any of the three fields populated?
    	
    	/*string query = 'Select Id, First_Gallon_Pumped_Month__c, Gallons_YTD__c, Gallons_Last_Three_Months__c from Account Where Id IN :monthlyAggKeySet OR Id IN :yearlyAggKeySet ' +
    					'OR Id IN :minAggKeySet';
    					
    	*/
    	
    	string query = 'Select Id, First_Gallon_Pumped_Month__c, Gallons_YTD__c, Gallons_Last_Three_Months__c from Account Where Id IN (Select Account__c from Account_Asset__c)';

        if(isTest == true)
        {
            query += 'LIMIT 200'; //The size of one batch, since only one batch job can be run in a unit test
        }
        
        return query;
    }

    global void execute(Database.BatchableContext BC, List<SObject> records) 
    {
		List<Account> accountsToUpdate = new List<Account>();
		
		Set<Id> aScope = new Set<Id>();
		for(sobject s1 : records)
		{
			aScope.add(s1.Id);
		}
		
		/*Map<Id,AggregateResult> accountAssetMonthlyAgg = new Map<Id, AggregateResult>([Select Account__c Id, Sum(Gallons_Last_Three_Months__c) sumAmt from Account_Asset__c 
    																				Where Account__c IN :aScope Group By Account__c]);
    	Map<Id,AggregateResult> accountAssetYearlyAgg = new Map<Id,AggregateResult>([Select Account__c Id, Sum(Gallons_YTD__c) sumAmt from Account_Asset__c 
    																			Where Account__c IN :aScope Group By Account__c]);
    	*/
    	Map<Id,AggregateResult> accountMinAgg = new Map<Id,AggregateResult>([Select Account_Asset__r.Account__c Id, MIN(Gallon_Month__c) minDate from Gallons_Data__c 
    																	Where Account_Asset__r.Account__c IN :aScope Group by Account_Asset__r.Account__c]);
    	Map<Id,AggregateResult> accountAssetAgg = new Map<Id,AggregateResult>([Select Account__c Id, Sum(Gallons_Last_Three_Months__c) monthSum, Sum(Gallons_YTD__c) yearSum, Sum(Gallons_MTD__c) mtdSum 
    																		from Account_Asset__c Where Account__c IN :aScope Group By Account__c]);
    																	
    																	/*
    																	[added 12/4/2013]
6.    Populate Account.Total_Gallons_MTD__c with Sum(Account_Asset.Gallons_MTD).
    																	*/
		
		for(sobject s : records)
		{
			boolean updatehit = false;

			Account a = (Account)s;

			if(accountMinAgg.containskey(a.Id))
			{
				a.First_Gallon_Pumped_Month__c = date.valueOf((accountMinAgg.get(a.Id)).get('minDate'));
				updatehit = true;
			}
			
			if(accountAssetAgg.containskey(a.Id))
			{
				a.Gallons_Last_Three_Months__c = (double)((accountAssetAgg.get(a.Id)).get('monthSum'));
				a.Gallons_YTD__c = (double)((accountAssetAgg.get(a.Id)).get('yearSum'));
				a.Total_Gallons_MTD__c = (double)((accountAssetAgg.get(a.Id)).get('mtdSum'));
			}
			/*if(accountAssetMonthlyAgg.containskey(a.Id))
			{
				a.Gallons_Last_Three_Months__c = (double)((accountAssetMonthlyAgg.get(a.Id)).get('sumAmt')); 
				updatehit = true;
			}
			if(accountAssetYearlyAgg.containskey(a.Id))
			{
				a.Gallons_YTD__c = (double)((accountAssetYearlyAgg.get(a.Id)).get('sumAmt'));
				updatehit = true;
			}
			*/
			if(updatehit==true)
			{
				accountsToUpdate.add(a);	
			}
			
		}
		
		if(accountsToUpdate.size()>0)
		{
			update accountstoupdate;
		}
		              
    }

    global void finish(Database.BatchableContext BC) 
    {
        //nothing to do... 
    } 
    
    global void execute(SchedulableContext SC) 
    {
        ID batchprocessid = Database.executeBatch(new UgallonsDataAccountBatch());
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
                
        System.schedule('UgallonsDataAccountBatch Nightly Batch Processing', jobSchedule, new UgallonsDataAccountBatch());
    }*/
}