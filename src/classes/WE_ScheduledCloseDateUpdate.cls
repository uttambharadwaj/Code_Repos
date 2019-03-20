// revision history https://gist.github.com/aplssf/85e039f8a4e56ebe4d0a/revisions
global class WE_ScheduledCloseDateUpdate implements Schedulable {

    global void execute(SchedulableContext SC) {
        updOpportunityCloseDates();
    }

    global void updOpportunityCloseDates() {

        //disable validation rules for running user
        //(assumption is that this is administrator & that job is being run at night)
        Id profileId = userinfo.getProfileId();

        WE_VRC__c validationRuleSetting = WE_VRC__c.getInstance(profileId);
        System.debug('WE_ScheduledCloseDateUpdate: validationRuleSetting1 contains ' + validationRuleSetting);
        validationRuleSetting.Non_Fcst_Disabled__c = true;
        upsert validationRuleSetting;
        System.debug('WE_ScheduledCloseDateUpdate: validationRuleSetting2 contains ' + validationRuleSetting);

        VProfileId__c profileSetting = VProfileId__c.getInstance(profileId);
        System.debug('WE_ScheduledCloseDateUpdate: profileSetting1 contains ' + profileSetting);
        profileSetting.Virtual_EU_NA_Sales_RM__c = true;
        upsert profileSetting;
        System.debug('WE_ScheduledCloseDateUpdate: profileSetting2 contains ' + profileSetting);

        WE_ApexUtility apxUtil = new WE_ApexUtility();
        apxUtil.retrieveValidRecordTypes('EU NA Opps');

        List<Opportunity> updatedOpps = new List<Opportunity>();

        // reference to find Opportunities with a Close Date that's up to 7 days away
        Date d = system.today().addDays(6);

        List<Opportunity> oppsToUp = [SELECT Id, CloseDate
                                        FROM Opportunity
                                       WHERE CloseDate <= :d AND RecordTypeId IN :WE_ApexUtility.validEuNaRecordTypeIds AND Probability > 0 AND Probability < 100];

        // bump Close Date to 21 days away
        for(Opportunity o : oppsToUp){
            o.CloseDate = system.today().addDays(20);
            updatedOpps.add(o);
        }

        // DML statement
        Database.SaveResult[] srList = Database.update(updatedOpps, false);

        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('WE_ScheduledCloseDateUpdate: Successfully updated Opportunity. Opportunity ID: ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors
                for(Database.Error err : sr.getErrors()) {
                    System.debug('WE_ScheduledCloseDateUpdate: The following error has occurred.');
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Opportunity fields that affected this error: ' + err.getFields());
                }
            }
        }
        //reactivate validation rules
        validationRuleSetting.Non_Fcst_Disabled__c = false;
        upsert validationRuleSetting;
        profileSetting.Virtual_EU_NA_Sales_RM__c = false;
        upsert profileSetting;
    }

}