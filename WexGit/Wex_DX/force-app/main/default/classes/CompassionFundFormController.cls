public with sharing class CompassionFundFormController {

    @AuraEnabled 
    public static Compassion_Fund__c saveCompassionFundForm(Compassion_Fund__c newCompassionFundForm) {
        try { 
          upsert newCompassionFundForm;
        } catch (Exception ex) {
            AuraHandledException e = new AuraHandledException('Unable to save form: ' + ex.getMessage());
            e.setMessage('Unable to save form');
            throw e;
        }
          return newCompassionFundForm;      
    }
}