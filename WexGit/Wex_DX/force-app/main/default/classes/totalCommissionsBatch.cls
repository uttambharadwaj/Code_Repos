/* ************************************************************
 * Created By  : Phillip Southern (GearsCRM)
 * Created Date: 07/09/2013 
 * Description : Schedulable/Batchable Class totalCommissionsBatch
 * 
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/
global class totalCommissionsBatch implements Schedulable, Database.Batchable<SObject>   
{
    private final boolean isTest;
    
    //Set<Id> accountAssetIds = new Set<Id>();
    //Set<Date> commReportDates = new Set<Date>();
    //Map<Id,Map<Date,Gallons_Data__c>> accountAssetsandGallonsData = new Map<Id,Map<Date,Gallons_Data__c>>();
    //List<Commission__c> commissions = new List<Commission__c>([Select Id, Commission_Report_Date__c, Opportunity__r.Account_Asset__c, 
    //			Total_Commissionable_Gallons__c From Commission__c Where Commission_Report_Date__c != null AND Total_Commissionable_Gallons__c = null AND Opportunity__c != null AND Opportunity__r.Account_Asset__c != null]);

    global totalCommissionsBatch(Boolean isTest)
    {
        this.isTest = isTest;
        //system.debug('-- constructor boolean hit');
    }
    
    global totalCommissionsBatch()
    {
        this(false);
        //buildData();
        //system.debug('-- constructor');
    }
    
    /*global void buildData()
    {
    	if(accountAssetsandGallonsData.size()==0)
    	{
	    	for(Commission__c c : [Select Id, Commission_Report_Date__c, Opportunity__r.Account_Asset__c, Total_Commissionable_Gallons__c From Commission__c 
	    	                  Where Commission_Report_Date__c != null AND Total_Commissionable_Gallons__c = null AND Opportunity__c != null AND Opportunity__r.Account_Asset__c != null])
	        {
	        	accountAssetIds.add(c.Opportunity__r.Account_Asset__c);
	    		commReportDates.add(c.Commission_Report_Date__c);
	        }
	        
	        //List<Gallons_Data__c> gallons = new List<Gallons_Data__c>([Select Id, Gallon_Month__c, Gallons_Amount__c, Account_Asset__c from Gallons_Data__c
			//								 Where Account_Asset__c IN :accountAssetIds AND Gallon_Month__c IN :commReportDates]);
			
			for(Gallons_Data__c g : [Select Id, Gallon_Month__c, Gallons_Amount__c, Account_Asset__c from Gallons_Data__c
											 Where Account_Asset__c IN :accountAssetIds AND Gallon_Month__c IN :commReportDates])
			{
				if(accountAssetsandGallonsData.containskey(g.Account_Asset__c))
				{	//account asset is already in map
					
					Map<Date,Gallons_Data__c> gmap = accountAssetsandGallonsData.get(g.Account_Asset__c);
					gmap.put(g.Gallon_Month__c,g);
					
					accountAssetsandGallonsData.put(g.Account_Asset__c,gmap);
				}else
				{	//account asset is not in map yet, will be new.
					
					Map<Date,Gallons_Data__c> gmap = new Map<Date,Gallons_Data__c>();
					gmap.put(g.Gallon_Month__c,g);
					
					accountAssetsandGallonsData.put(g.Account_Asset__c,gmap);
				}
			}
    	}    
    }*/
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(GetQueryLocatorString());
    }
    
    private string GetQueryLocatorString()
    {
        /*string query = 'Select Id, Commission_Report_Date__c, Opportunity__r.Account_Asset__c, Total_Commissionable_Gallons__c ' + 
        				'from Commission__c Where Opportunity__r.Account_Asset__c IN :accountAssetIds AND Total_Commissionable_Gallons__c = null'; 
		*/
		
		string query = 'Select Id, Commission_Report_Date__c, Opportunity__r.Account_Asset__c, Total_Commissionable_Gallons__c From Commission__c ' +
	    	           'Where Commission_Report_Date__c != null AND Total_Commissionable_Gallons__c = null AND Opportunity__c != null AND Opportunity__r.Account_Asset__c != null ';

        if(isTest == true)
        {
            query += 'LIMIT 200'; //The size of one batch, since only one batch job can be run in a unit test
        }
        
        return query;
    }

    global void execute(Database.BatchableContext BC, List<SObject> records) 
    {
    	List<Commission__c> commsToUpdate = new List<Commission__c>();
    	
    	Set<Id> accountAssetIds = new Set<Id>();
    	Set<Date> commReportDates = new Set<Date>();
    	Map<Id,Map<Date,Gallons_Data__c>> accountAssetsandGallonsData = new Map<Id,Map<Date,Gallons_Data__c>>();
    	
    	for(sobject scope : records)
    	{
    		Commission__c c2 = (Commission__c)scope;
    		accountAssetIds.add(c2.Opportunity__r.Account_Asset__c);
    		commReportDates.add(c2.Commission_Report_date__c);
    	}
    	
    	for(Gallons_Data__c g : [Select Id, Gallon_Month__c, Gallons_Amount__c, Account_Asset__c from Gallons_Data__c
											 Where Account_Asset__c IN :accountAssetIds AND Gallon_Month__c IN :commReportDates])
			{
				if(accountAssetsandGallonsData.containskey(g.Account_Asset__c))
				{	//account asset is already in map
					
					Map<Date,Gallons_Data__c> gmap = accountAssetsandGallonsData.get(g.Account_Asset__c);
					gmap.put(g.Gallon_Month__c,g);
					
					accountAssetsandGallonsData.put(g.Account_Asset__c,gmap);
				}else
				{	//account asset is not in map yet, will be new.
					
					Map<Date,Gallons_Data__c> gmap = new Map<Date,Gallons_Data__c>();
					gmap.put(g.Gallon_Month__c,g);
					
					accountAssetsandGallonsData.put(g.Account_Asset__c,gmap);
				}
			}
    	
 		//original, down
    	for(sobject s : records)
    	{
    		Commission__c c = (Commission__c)s;
    		
    		if(accountAssetsandGallonsData.containskey(c.Opportunity__r.Account_Asset__c))
			{
				Map<Date,Gallons_Data__c> gallons = accountAssetsandGallonsData.get(c.Opportunity__r.Account_Asset__c);
				if(gallons.containskey(c.Commission_Report_Date__c))
				{
					c.Total_Commissionable_Gallons__c = gallons.get(c.Commission_Report_Date__c).Gallons_Amount__c;
					commsToUpdate.add(c);
				}
			}
    	} 	

    	
    	if(commsToUpdate.size()>0)
    	{
    		update commsToUpdate;
    	}               
    }

    global void finish(Database.BatchableContext BC) 
    {
        //nothing to do... 
    } 
    
    global void execute(SchedulableContext SC) 
    {
        ID batchprocessid = Database.executeBatch(new totalCommissionsBatch());
    }
    
    /*public static void schedule()
    {
        schedule(null);
    }*/
    
    /*public static void schedule(string jobSchedule)
    {
        if(jobSchedule == null || jobSchedule.trim().length() == 0)
        {
            jobSchedule = '0 0 1 * * ?'; //Run the class at 1:00 AM every day
        }
                
        System.schedule('totalCommissionsBatch Nightly Batch Processing', jobSchedule, new totalCommissionsBatch());
    }*/
}