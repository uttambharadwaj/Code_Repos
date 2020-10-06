global class StageIdBatch implements Database.Batchable<sObject> {

	global final String query;
	global final boolean isTest;
	global final Date dt;

	public StageIdBatch(Boolean isTest)
	{
	 
	 	 GlobalSettings__c g = GlobalSettings__c.getOrgDefaults();
	 	 integer numDays = integer.valueOf(g.Number_of_Days__c);
	 	 
	 	 
	 	 integer days = 0 - numDays;
	 	 
	 	 dt = system.today().addDays(days);
	 
	 
		 string lquery;
		 
		 lquery = 'Select Sales_Stage_Id__c, stagename, id from Opportunity';
		 lquery += ' where lastModifiedDate > :dt';
		 
		 if(isTest == true)
		 {
		 	lquery +=' LIMIT 1';
		 }
		 
		 query = lquery;
	}
	
     global Database.QueryLocator start(Database.BatchableContext BC){   
         
          return Database.getQueryLocator(query);
     }
     
     global void execute(Database.BatchableContext BC, List<sObject> scope)
     {  
     	
     	Map <string, OpportunityStage> stageMap = new Map <string, OpportunityStage>();
		for(OpportunityStage os : [SELECT Id, Masterlabel FROM OpportunityStage])
		{
			stageMap.put(os.Masterlabel.toLowerCase(), os);
		} 
         
        List <Opportunity> opps = new List <Opportunity>(); 
         
        for(sObject so : scope)
   		{
   		   	Opportunity o  = (Opportunity)so;       
   		   	if(o.sales_stage_id__c == null || o.sales_stage_id__c != stageMap.get(o.stageName.toLowerCase()).id)
   		   	{
   		   		o.sales_stage_id__c = stageMap.get(o.stageName.toLowerCase()).id;	
   		   		opps.add(o);
   		   	}
   		}
   		
   		if(opps.size() > 0)
   		{
   			update opps;
   		}

     } 
	
	global void finish(Database.BatchableContext BC)
	{
	}

	public static testMethod void testBatch1() 
   	{
   		
   		 GlobalSettings__c g = new GlobalSettings__c();
   		 g.name = 'test';
	 	 g.Number_of_Days__c = 500;
	 	 insert g;
   		
   		StageIdBatch batchApex = new StageIdBatch(true);
      	ID batchprocessid = Database.executeBatch(batchApex); 
   	}	
}