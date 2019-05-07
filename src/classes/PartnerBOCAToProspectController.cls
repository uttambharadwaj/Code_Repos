/*
* Revision History: 5/1/2019 IADJUDICAT-1186 expand functionality for CP and NAF; utilize field mapping metadata
*/
public class PartnerBOCAToProspectController {

    public final static String APPLICATION_NAME = 'Partner BOCA To Prospect';

    public String action {
        get {
            return ApexPages.currentPage().getParameters().get('action');
        }
    }

    // Applicant Information
    public Partner_BOCA_To_Prospect__c partnerBOCAtoProspect { get; set; }

    // Get the program passed in
    public String partnerParameter {
        get {
            return ApexPages.currentPage().getParameters().get('partner');
        }
    }

    // Get the program passed in
    public String externalSalesCodeParameter {
        get {
            return ApexPages.currentPage().getParameters().get('salesCode');
        }
    }

    // Get all program information
    public Partner__c partner { get; set; }

    // Branding logo related to the program
    public Id brandingLogo { get; set; }

    public Id selectedProgram { get; set; }

    public Id selectedOffer { get; set; }

    public List<SelectOption> additionalPrograms {
        get {
            List<SelectOption> additionalPrograms = new List<SelectOption>();

            if (partner != null) {

                List<Program__c> partnerPrograms = [SELECT Id, Brand_Long_Name__c FROM Program__c WHERE Partner__c = :partner.Id AND Publish_BOCA__c = TRUE];

                if (partnerPrograms.size() > 0) {
                    additionalPrograms.add(new SelectOption('', '-- Choose One --'));
                    for (Program__c partnerProgram : partnerPrograms) {
                        additionalPrograms.add(new SelectOption(partnerProgram.Id, partnerProgram.Brand_Long_Name__c));
                    }
                }

            }

            if (additionalPrograms.size() > 0) {
                return additionalPrograms;
            }
            return null;
        }
    }

    public List<SelectOption> additionalOffers {
        get {
            List<SelectOption> additionalOffers = new List<SelectOption>();

            if (partner != null && selectedProgram != null) {

                List<OnlineApplicationOffer__c> partnerOffers = [SELECT Id, Name FROM OnlineApplicationOffer__c WHERE Program__c = :selectedProgram];

                if (partnerOffers.size() > 0) {
                    additionalOffers.add(new SelectOption('', '-- Choose One --'));
                    for (OnlineApplicationOffer__c partnerOffer : partnerOffers) {
                        additionalOffers.add(new SelectOption(partnerOffer.Id, partnerOffer.Name));
                    }
                }

            }

            if (additionalOffers.size() > 0) {
                return additionalOffers;
            }
            return null;
        }
    }

    public PartnerBOCAToProspectController() {

    }

    public class partnerBOCAToProspectException extends Exception {
    }

    public PageReference init() {

        try {

            if (partnerParameter != null && externalSalesCodeParameter != null) {
                List<Partner__c> partners = [SELECT Id, Name, Partner_Key__c FROM Partner__c WHERE Partner_Key__c = :partnerParameter AND External_Sales_Code__c = :externalSalesCodeParameter];

                // If we have a program, then set it, otherwise, redirect to error page
                if (partners.size() > 0) {

                    partner = partners[0];

                    // Setup branding logo
                    brandingLogo = WexBrandingController.getPartnerLogoId(WexBrandingController.getPartnerByPartnerKey(partner.Partner_Key__c));

                    if (partner != null && action == null) {

                        partnerBOCAtoProspect = new Partner_BOCA_To_Prospect__c();

                        partnerBOCAtoProspect.Partner__c = partner.Id;

                        if (action == null) {

                            // If we have any of the parameters - fill'em in!
                            if (!String.isEmpty(ApexPages.currentPage().getParameters().get('firstName'))) {
                                partnerBOCAtoProspect.First_Name__c = ApexPages.currentPage().getParameters().get('firstName');
                            }

                            if (!String.isEmpty(ApexPages.currentPage().getParameters().get('lastName'))) {
                                partnerBOCAtoProspect.Last_Name__c = ApexPages.currentPage().getParameters().get('lastName');
                            }

                            if (!String.isEmpty(ApexPages.currentPage().getParameters().get('email'))) {
                                partnerBOCAtoProspect.Email__c = ApexPages.currentPage().getParameters().get('email');
                            }

                            if (!String.isEmpty(ApexPages.currentPage().getParameters().get('phone'))) {
                                partnerBOCAtoProspect.Phone__c = ApexPages.currentPage().getParameters().get('phone');
                            }

                            if (!String.isEmpty(ApexPages.currentPage().getParameters().get('companyName'))) {
                                partnerBOCAtoProspect.Company_Name__c = ApexPages.currentPage().getParameters().get('companyName');
                            }

                            if (!String.isEmpty(ApexPages.currentPage().getParameters().get('opportunityId'))) {
                                partnerBOCAtoProspect.Partner_Opportunity_ID__c = ApexPages.currentPage().getParameters().get('opportunityId');
                            }

                            if (!String.isEmpty(ApexPages.currentPage().getParameters().get('partnerSalesCode'))) {
                                partnerBOCAtoProspect.Partner_Sales_Code__c = ApexPages.currentPage().getParameters().get('partnerSalesCode');
                            }

                            if (!String.isEmpty(ApexPages.currentPage().getParameters().get('repFirstName'))) {
                                partnerBOCAtoProspect.Sales_Rep_First_Name__c = ApexPages.currentPage().getParameters().get('repFirstName');
                            }

                            if (!String.isEmpty(ApexPages.currentPage().getParameters().get('repLastName'))) {
                                partnerBOCAtoProspect.Sales_Rep_First_Name__c = ApexPages.currentPage().getParameters().get('repLastName');
                            }

                            if (!String.isEmpty(ApexPages.currentPage().getParameters().get('repEmail'))) {
                                partnerBOCAtoProspect.Sales_Rep_Email__c = ApexPages.currentPage().getParameters().get('repEmail');
                            }

                            if (!String.isEmpty(ApexPages.currentPage().getParameters().get('repPhone'))) {
                                partnerBOCAtoProspect.Sales_Rep_Phone__c = ApexPages.currentPage().getParameters().get('repPhone');
                            }

                        }

                    } else if (action != null && action.equalsIgnoreCase('confirm')){

                        return null;

                    } else {
                        throw new partnerBOCAToProspectException('Unable to find partner specified via URL parameters.');
                    }
                } else {
                    throw new partnerBOCAToProspectException('Unable to find partner specified via URL parameters.');
                }

            }

        } catch (Exception e) {

            System.debug('### ERROR - Line: ' + e.getLineNumber() + ' - ' + e.getMessage());

            PageReference errorPage = Page.ExternalApplicationError;
            if (partnerParameter != null) {
                errorPage.getParameters().put('partner', partnerParameter);
            }

            return errorPage;

        }

        return null;

    }

    public PageReference sendApplication() {

        try {

            //turn that partner boca into a wrapper. mapping is prettier that way. plus there are values we have to build
            ParAppTheWrapper myWrapper = new ParAppTheWrapper(partnerBOCAtoProspect, this);

            //turn that wrapper into our sobject for insertion
            SObject myAppRecord = convertWrapper(myWrapper);

            //insert that object!
            Database.UpsertResult result = Database.upsert(myAppRecord, false);

            if (result.isSuccess()) {

                System.debug('### DEBUG - CreditApp ID: ' + myAppRecord);

                Set<SObject> mySet = new Set<SObject>{myAppRecord};

                // Generating a security key and URL - need the resulting ID first..
                KeyURLWrapper keyMaster = new KeyURLWrapper(myWrapper, myAppRecord.Id);
                myAppRecord = convertWrapper(myAppRecord, keyMaster);
                mySet.add(myAppRecord);
                //under set of objects, if one object has a field not on the other(s), it's a new entry in the set. so if key/url was added, our set is now larger and we should update stuff
                if(mySet.size()>1) update myAppRecord;

                partnerBOCAtoProspect.put(myWrapper.LookupField, myAppRecord.Id);
                partnerBOCAtoProspect.Program__c = selectedProgram;
                partnerBOCAtoProspect.Online_Application_Offer__c = selectedOffer;
                upsert partnerBOCAtoProspect;

                System.debug('### DEBUG - PartnerBOCAToProspect ID: ' + partnerBOCAtoProspect);

                BOCA_To_Prospect_Settings__c bocaToProspectSettings = BOCA_To_Prospect_Settings__c.getOrgDefaults();

                String emailTemplateId = bocaToProspectSettings.Partner_BOCA_To_Prospect_Template__c;

                List<RecordType> contactRecordTypes = [SELECT Id FROM RecordType WHERE SobjectType = 'Contact' AND DeveloperName IN ('F1_Contact')];

                Contact temporaryContact = new Contact();

                temporaryContact.FirstName = myWrapper.ContactFirstName;
                temporaryContact.LastName = myWrapper.ContactLastName;
                temporaryContact.Email = myWrapper.Email;
                temporaryContact.RecordTypeId = contactRecordTypes[0].Id;

                insert temporaryContact;

                Messaging.reserveSingleEmailCapacity(1);
                Messaging.SingleEmailMessage bocaEmail = new Messaging.SingleEmailMessage();

                bocaEmail.setTemplateId(emailTemplateId);
                bocaEmail.setWhatId(partnerBOCAtoProspect.Id);
                bocaEmail.setTargetObjectId(temporaryContact.Id);
                bocaEmail.setSaveAsActivity(false);
                bocaEmail.setReplyTo(bocaToProspectSettings.No_Reply_Email__c);

                for (OrgWideEmailAddress owa : [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress]) {
                    if (owa.Address.contains(bocaToProspectSettings.No_Reply_Email__c)) {
                        bocaEmail.setOrgWideEmailAddressId(owa.Id);
                    }
                }

                //utility class to send an email. complete with test.isrunningtest check
                UtilityClass.sendEmail(bocaEmail);

                delete temporaryContact;

                PageReference redirect = Page.PartnerBOCAToProspect;
                redirect.getParameters().put('action', 'confirm');
                redirect.getParameters().put('appId', myAppRecord.Id);
                redirect.getParameters().put('partner', partnerParameter);
                redirect.getParameters().put('salesCode', externalSalesCodeParameter);
                redirect.setRedirect(true);

                return redirect;

            }

        } catch (Exception e) {

            System.debug('Exception Encountered Sending Application: ' + e.getStackTraceString() + ' ' + e);

            String errorNumber = WEXDEVErrorReporting.reportExternalError(APPLICATION_NAME, ApexPages.currentPage().getUrl(), e);

            PageReference errorPage = Page.ExternalApplicationError;
            errorPage.getParameters().put('errorCode', errorNumber);
            errorPage.getParameters().put('partner', partner.Partner_Key__c);

            return errorPage;

        }

        return null;

    }

    private SObject convertWrapper(SObject myApp, KeyURLWrapper myWrapper){
        //get field mapping metadata for the object type and for this class/wrapper combination.
        Field_Mapping_Parent__mdt myMapping = UtilityClass.getFieldMapping(myApp.Id.getSObjectType().getDescribe().getName(), 'PartnerBOCAToProspectController', 'KeyURLWrapper');

        if(myMapping != null){
            //iterate over field mapping metadata, creating the fields needed
            for(Field_Mapping_Child__mdt f : myMapping.Field_Mapping_Children__r){
                myApp.put(f.Destination_Field_API_Name__c, myWrapper.get(f.Source_Field_API_Name__c));
            }
        }

        return myApp;
    }

    //create a useful sobject out of a meaningless wrapper
    private SObject convertWrapper(ParAppTheWrapper myWrapper){
        //start with a new sobject
        SObject myApp = Schema.getGlobalDescribe().get(myWrapper.AppObjectType).newSObject();

        //get field mapping metadata for the object type and for this class/wrapper combination.
        Field_Mapping_Parent__mdt myMapping = UtilityClass.getFieldMapping(myWrapper.AppObjectType, 'PartnerBOCAToProspectController', 'ParAppTheWrapper');

        if(myMapping != null){
            //iterate over field mapping metadata, creating the fields needed
            for(Field_Mapping_Child__mdt f : myMapping.Field_Mapping_Children__r){
                myApp.put(f.Destination_Field_API_Name__c, myWrapper.get(f.Source_Field_API_Name__c));
            }
        }

        return myApp;
    }

    //using a wrapper class thingy specifically for this controller
    public class ParAppTheWrapper {
        public String Stage;
        public String Status;
        public String Program;
        public String Offer;
        public String ContactFirstName;
        public String ContactLastName;
        public String Email;
        public String PhoneNumber;
        public String LegalBusinessName;
        public String AppObjectType;
        public String LookupField;
        public String BOCAType;

        //constructor stuffs
        public ParAppTheWrapper(Partner_BOCA_To_Prospect__c myPBTP, PartnerBOCAToProspectController thisController){
            this.Stage = 'Application';
            this.Status = 'App - Incomplete';
            this.ContactFirstName = myPBTP.First_Name__c;
            this.ContactLastName = myPBTP.Last_Name__c;
            this.Email = myPBTP.Email__c;
            this.PhoneNumber = myPBTP.Phone__c;
            this.LegalBusinessName = myPBTP.Company_Name__c;
            this.Program = thisController.selectedprogram;
            this.Offer = thisController.selectedoffer;
            setObjectType();
        }

        //custom get method bc inner classes don't support standard get. boo!
        private Object get(String myVariable){
            return UtilityClass.get(myVariable, (Object)this);
        }

        //the gross hardcoded stuff goes here. what object type are we working with?
        private void setObjectType(){
            Set<String> cpbTypes = new Set<String>{'CPBOCA','TAG'};
            Set<String> nafTypes = new Set<String>{'Fuel Card','Revolver Card'};
            Set<String> otrTypes = new Set<String>{'OTR'};
            BOCAType = [SELECT BOCA_Type__c FROM Program__c WHERE Id = :Program LIMIT 1].BOCA_Type__c;
            if(cpbTypes.contains(BOCAType)){
                this.AppObjectType = 'CP_Application_Request__c';
                this.LookupField = 'CP_Application_Request__c';
                this.Status = 'App-Incomplete';
            } else if(nafTypes.contains(BOCAType)){
                this.AppObjectType = 'WeFormObject__c';
                this.LookupField = 'WeFormObject__c';
            } else if(otrTypes.contains(BOCAType)){
                this.AppObjectType = 'OnlineApplication__c';
                this.LookupField = 'Online_Application__c';
            }
        }

    }

    public class KeyURLWrapper{
        public String theKey;
        public String theURL;

        public KeyURLWrapper(ParAppTheWrapper myWrapper, String myId){
            this.theKey = UtilityClass.generateAppKey();
            String offer = myWrapper.Offer;
            Program__c myProgram = WexBrandingController.getProgram(myWrapper.Program);
            String myURL = 'https://' + Label.External_Instance_URL + '/creditapplication' + myProgram.Form_Template__c;
            myURL += '?pgm=' + myProgram.Brand_Short_Name__c; //program parameter. that's a big one. might want to hold on to that one.
            if(offer != null)
                myURL += '&offer=' + offer; //offer parameter. limited to OTR
            myURL += '&customer=' + myId; //id parameter. ids are useful
            myURL += '&key=' + theKey; //generated key. also useful
            this.theURL =  myURL;
        }

        //custom get method bc inner classes don't support standard get. boo!
        private Object get(String myVariable){
            return UtilityClass.get(myVariable, (Object)this);
        }

    }

}