global class PricingUpdateScheduler implements Schedulable {

    global void execute(SchedulableContext SC){
        if(SC != null) {
            CronTrigger ct = [SELECT TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :SC.getTriggerId()];
        }

        // Moved to a queueable context - DDG 3-7-2019
        //CampaignPricingController.RefreshCampaignPricingDataForProgram();

        List<Program__c> programs = [SELECT Id FROM Program__c WHERE Upload_Pricing_Data_Flag__c = true];

        for(Program__c program : programs) {

            System.enqueueJob(new PricingUpdateQueueable(program.Id));

        }

    }

}