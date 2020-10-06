global class LeadBatchDeleteJob implements Schedulable{

   global void execute(SchedulableContext SC) {
   	
   		List<String> AU_Lead_RTs = new List<String>{'AU_Fuel_Application_Individual','AU_Fuel_Business','AU_Fuel_Merchant','AU_Fuel_Prepaid','AU_VCC'};
   		
        String query = 'SELECT ID FROM Lead WHERE createdby.alias = \'gwild\' and lead.CreatedDate < last_N_DAYS:180 and RecordType.DeveloperName NOT IN :AU_Lead_RTs';  
        BatchDelete leadBatch = new BatchDelete (query );
        Database.executeBatch(leadBatch);  
                   
   }
}