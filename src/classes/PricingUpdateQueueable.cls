/**
 * Created by dgilbert on 2019-03-07.
 */

public class PricingUpdateQueueable implements Queueable, Database.AllowsCallouts {

    private Id programId;

    public PricingUpdateQueueable(Id programId) {

        this.programId = programId;

    }

    public void execute(QueueableContext context) {

        Set <Program__c> programs = new Set<Program__c>([SELECT Peoplesoft_rel_code__c, Upload_Pricing_Data_Flag__c FROM Program__c WHERE Upload_Pricing_Data_Flag__c = TRUE AND Id =: programId]);

        Map <String, String> programIds = new Map<String, String>();

        for(Program__c program : programs){
            programIds.put(program.Peoplesoft_rel_code__c, '');
        }

        if(programs.size() > 0){

            Set<Campaign_Pricing__c> updatedPricing = PricingController.pricingController(programIds);

            if(updatedPricing.size() > 0){

                List<Campaign_Pricing__c> duplicatesToDelete = new List<Campaign_Pricing__c>();

                List<String> names = new List<String>();
                for(Campaign_Pricing__c c : updatedPricing){
                    names.add(c.Name);
                }

                duplicatesToDelete.addAll([SELECT Id, Name, is_Active__c FROM Campaign_Pricing__c WHERE Name IN: names OR is_Active__c = FALSE]);

                List <Campaign_Pricing__c> newPricings = new List<Campaign_Pricing__c>();
                newPricings.addAll(updatedPricing);

                try{

                    delete duplicatesToDelete;

                    insert newPricings;

                }
                catch(DmlException ex){
                    System.debug('Insert failed '+ ex);
                }
            }

        }

    }

}