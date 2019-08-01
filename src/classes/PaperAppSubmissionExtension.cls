/**
 * Created by lhowland on 5/22/2019.
 */

public class PaperAppSubmissionExtension {

    public Id optyId { //get; set; }
        get {
            if (ApexPages.currentPage().getParameters().get('id') != null) {
                return ApexPages.currentPage().getParameters().get('id');
            }
            return null;
        }
    }

    public PaperAppSubmissionExtension() {

    }
    public PaperAppSubmissionExtension(ApexPages.StandardController controller) {

    }

    public void doNothing() {

    }

    public Boolean hasError {
        get {
            if (ApexPages.hasMessages()) return true;
            return false;
        }
    }

    public Id selectedProgram { get; set; }
    public Id selectedOffer { get; set; }
    public Id partnerId = null;
    public Id uid = null;
    public User u = null;
    public Boolean isPartner { get; set; }
    public List<Opportunity> oppties = [
            SELECT Offer__c, Offer__r.Program__c, Offer__r.Program__r.Brand_Short_Name__c,
                    Offer__r.Program__r.Form_Template__c, Campaign_Program__c, AccountId
            FROM Opportunity
            WHERE Id = :optyId
            LIMIT 1
    ];

    public PageReference init() {

        //get user info
        uid = UserInfo.getUserId();

        //from user get contact then account then program then partner
        u = [SELECT profile.UserLicense.name, Contact.Account.Program__r.Partner__c FROM User WHERE Id = :uid LIMIT 1];
        isPartner = (u.profile.UserLicense.name == 'Partner Community') ? true : false;
        if (isPartner) {
            partnerId = u.Contact.Account.Program__r.Partner__c;
        }
        return null;
    }

    public PageReference buildURL() {

        //Update offer
        try {
            oppties[0].offer__c = selectedOffer;

            upsert oppties;

            // Attempt to build the URL
            if (oppties.size() > 0) {

                String campaignProgram = oppties[0].Campaign_Program__c;
                String accountId = oppties[0].AccountId;
                Id otrProgram = null;
                if ( oppties[0].Offer__c != null && oppties[0].Offer__r.Program__c != null) {
                    otrProgram = oppties[0].Offer__r.Program__c;
                } else if ( selectedProgram != null ) {
                    otrProgram = selectedProgram;
                }

                system.debug('OTR Program: ' + otrProgram);
                system.debug('OTR Offer: ' + oppties[0].Offer__c);
                system.debug('selectedOffer: ' + selectedOffer);
                system.debug('selectedProgram: ' + selectedProgram);
                System.debug('campaignProgram: ' + campaignProgram);

                if (campaignProgram != null) {
                    List<Campaign_Program__c> campaignPrograms = [SELECT Program__c FROM Campaign_Program__c WHERE Id = :campaignProgram LIMIT 1];

                    if (campaignPrograms.size() > 0) {
                        List<Program__c> programs = [SELECT Form_Template__c, Brand_Short_Name__C FROM Program__c WHERE Id = :campaignPrograms[0].Program__c LIMIT 1];

                        if (programs.size() > 0) {
                            String brandShortName = programs[0].Brand_Short_Name__c;

                            PageReference paperAppSubmission = new PageReference('/partners/apex/' + programs[0].Form_Template__c + '?pgm=' + brandShortName + '&optyId=' + optyId + '&accntId=' + accountId);
                            paperAppSubmission.setRedirect(true);
                            return paperAppSubmission;
                        }
                    }
                } else if (otrProgram != null) {
                    List<OnlineApplicationOffer__c> offers = [SELECT Id, Program__c FROM OnlineApplicationOffer__c WHERE Id = :oppties[0].Offer__c];

                    if (offers.size() > 0) {

                        List<Program__c> programs = [SELECT Id, Brand_Short_Name__c, Form_Template__c FROM Program__c WHERE Id = :offers[0].Program__c];
                        if (programs.size() > 0) {
                            String brandShortName = programs[0].Brand_Short_Name__c;
                            System.debug('TEMP inside otr brand short name: ' + brandShortName);
                            String formTemplate = programs[0].Form_Template__c;

                            if (formTemplate != null && brandShortName != null) {
                                PageReference paperAppSubmission = new PageReference('/partners/apex/' + formTemplate + '?pgm=' + brandShortName + '&optyId=' + optyId + '&accntId=' + accountId);
                                System.debug('TEMP page ref: ' + paperAppSubmission);
                                paperAppSubmission.setRedirect(true);
                                return paperAppSubmission;
                            }
                        }
                    }
                } else {
                    System.debug('Missing Information on the Opty (' + optyId + ')');
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Missing Program or Offer on the Opportunity (' + optyId + ')');
                    ApexPages.addMessage(myMsg);
                }
            }
        } catch (Exception e) {
            //TODO
            //     String errorNumber = WEXDEVErrorReporting.reportExternalError('OTRBOCA', ApexPages.currentPage(), e, true);

            //     PageReference externalApplicationError = Page.ExternalApplicationError;
            //    externalApplicationError.getParameters().put('errorCode', errorNumber);
            //    externalApplicationError.getParameters().put('pgm', programParameter);
            //    externalApplicationError.setRedirect(true);
            //    return externalApplicationError;
        }
        return null;

    }

    // Dear Jason Arbegast, Thank you for the below method, amen.
    public List<SelectOption> AvailablePrograms {
        get {

            List<SelectOption> availablePrograms = new List<SelectOption>();
            availablePrograms.add(new SelectOption('', '-- Choose One--'));

            //assemble the query for possible programs.
            String myQuery = 'SELECT Id, Name FROM Program__c WHERE BOCA_Type__c = \'OTR\' and Publish_BOCA__c = true';
            if(isPartner || (!isPartner && partnerId != null))
                myQuery += ' AND Partner__c = :partnerId';
            myQuery += ' ORDER BY Name ASC';
            //if we have inside sales rep, or we have a partner AND a partnerid, add programs to drop down. if partner user but no partnerid, don't show anything
            if(!isPartner || (isPartner && partnerId != null)){
                for (Program__c program : database.query(myQuery)) {
                    availablePrograms.add(new SelectOption(program.Id, program.Name));
                }
            }

            return availablePrograms;
        }
    }

    public List<SelectOption> availableOffers {
        get {
            List<SelectOption> availableOffers = new List<SelectOption>();

            availableOffers.add(new SelectOption('', '-- Choose One --'));
            if(selectedProgram != null){
                for (OnlineApplicationOffer__c offer : [SELECT Id, Name FROM OnlineApplicationOffer__c WHERE Program__c = :selectedProgram ORDER BY Name ASC]) {
                    availableOffers.add(new SelectOption(offer.Id, offer.Name));
                }
            }
            return availableOffers;
        }
    }
}