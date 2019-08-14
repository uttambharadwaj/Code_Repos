/**
 * Created by dgilbert on 2018-12-31.
 */

public without sharing class ContactUnsubscribeController {

    public String recordId {
        get {
            return ApexPages.currentPage().getParameters().get('id');
        }
    }

    public String programParamater {
        get {
            return ApexPages.currentPage().getParameters().get('pgm');
        }
    }

    public Id brandingLogo { get; set; }

    public String emailAddress { get; set; }

    public ContactUnsubscribeController() {

    }

    public void init() {

        if(programParamater != null) {

            Id programId = WexBrandingController.getProgramIdByBrandShortName(programParamater);

            if(programId != null) {

                brandingLogo = WexBrandingController.getLogoId(programId);

            }

        }

        if(recordId != null) {

            if(((Id.valueOf(recordId)).getSobjectType().getDescribe().getName()).equalsIgnoreCase('Contact')) {

                List<Contact> contacts = [SELECT Id, Email, HasOptedOutOfEmail FROM Contact WHERE Id =: recordId];

                if(contacts.size() > 0) {
                    emailAddress = contacts[0].Email;

                    contacts[0].HasOptedOutOfEmail = true;

                    upsert contacts[0];
                }

            }
            else if(((Id.valueOf(recordId)).getSobjectType().getDescribe().getName()).equalsIgnoreCase('Lead')) {

                List<Lead> leads = [SELECT Id, Email, HasOptedOutOfEmail FROM Lead WHERE Id =: recordId];

                if(leads.size() > 0) {
                    emailAddress = leads[0].Email;

                    leads[0].HasOptedOutOfEmail = true;

                    upsert leads[0];
                }

            }

        }

    }

}