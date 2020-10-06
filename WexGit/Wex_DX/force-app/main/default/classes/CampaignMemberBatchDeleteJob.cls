global class CampaignMemberBatchDeleteJob implements Schedulable{

   global void execute(SchedulableContext SC) {

        String query = 'SELECT ID FROM CampaignMember WHERE CreatedBy.alias = \'gwild\' and CreatedDate < last_N_DAYS:180';  
        BatchDelete campaignMemberBatch = new BatchDelete (query );
        Database.executeBatch(campaignMemberBatch);  
                           
   }
}