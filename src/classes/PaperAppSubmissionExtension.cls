/**
 * Created by lhowland on 5/22/2019.
 */

public class PaperAppSubmissionExtension {

    public PaperAppSubmissionExtension() {}

    public Id optyId { //get; set; }
        get {
            if (ApexPages.currentPage().getParameters().get('id') != null) {
                return ApexPages.currentPage().getParameters().get('id');
            }
            return null;
        }
    }

    public PaperAppSubmissionExtension(ApexPages.StandardController controller) {
    }

    public PageReference buildURL() {

        System.debug('TEMP opty Id in controller: ' + optyId);

        List<Opportunity> oppties = [SELECT Campaign_Program__c from Opportunity where Id = :optyId LIMIT 1];

        if (oppties.size() > 0) {

            String campaignProgram = oppties[0].Campaign_Program__c;

            if (campaignProgram != null) {
                List<Campaign_Program__c> campaignPrograms = [SELECT Program__c from Campaign_Program__c where Id = :campaignProgram LIMIT 1];

                if (campaignPrograms.size() > 0) {
                    List<Program__c> programs = [SELECT Form_Template__c, Brand_Short_Name__C from Program__c where Id = :campaignPrograms[0].Program__c LIMIT 1];

                    System.debug('TEMP form template: ' + programs[0].Form_Template__c);
                    System.debug('TEMP program: ' + programs[0].Brand_Short_Name__c);

                    if (programs.size() > 0) {
                        String brandShortName = programs[0].Brand_Short_Name__c;

                        PageReference paperAppSubmission = new PageReference('/apex/' + programs[0].Form_Template__c + '?pgm=' + brandShortName);
                        paperAppSubmission.setRedirect(true);
                        return paperAppSubmission;
                    }
                }
            }
            System.debug('Missing Campaign Program on the Opty (' + optyId + ')');
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Missing Campaign Program on the Opportunity (' + optyId + ')');
            ApexPages.addMessage(myMsg);
        }
        return null;
    }

}