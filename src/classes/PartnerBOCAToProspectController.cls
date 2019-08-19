/*
* PartnerBOCAToProspectController Class
* Description: controller for PartnerBOCAToProspect page
* Revision History: 5/24/2019   PSOBACKLOG-65 & IADJUDICAT-1186 build out for NAF and CP
*
*
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

    // Get all program information
    public Partner__c partner { get; set; }

    // Branding logo related to the program
    public Id brandingLogo { get; set; }

    public Id selectedProgram { get; set; }

    public Id selectedOffer { get; set; }

    //IADJUDICAT-1186 build out for NAF and CP...which don't have offer selection
    public String bocaType {get{
        if(selectedProgram == null) return null;
        return [select boca_type__c from program__c where id=:selectedProgram limit 1].BOCA_Type__c;
    }}

    public List<SelectOption> additionalPrograms {
        get {
            List<SelectOption> additionalPrograms = new List<SelectOption>();

            if (partner != null) {

                List<Program__c> partnerPrograms = [SELECT Id, Name, BOCA_Type__c FROM Program__c WHERE Partner__c = :partner.Id AND Publish_BOCA__c = TRUE];

                if (partnerPrograms.size() > 0) {
                    additionalPrograms.add(new SelectOption('', '-- Choose One --'));
                    for (Program__c partnerProgram : partnerPrograms) {
                        additionalPrograms.add(new SelectOption(partnerProgram.Id, partnerProgram.Name));
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

            if (partnerParameter != null) {
                List<Partner__c> partners = [SELECT Id, Name, Partner_Key__c, External_Sales_Code__c FROM Partner__c WHERE Partner_Key__c = :partnerParameter];

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

                            if (!String.isEmpty(ApexPages.currentPage().getParameters().get('partnerDataField1'))) {
                                partnerBOCAtoProspect.Partner_Data_Field_1__c = ApexPages.currentPage().getParameters().get('partnerDataField1');
                            }

                            if (!String.isEmpty(ApexPages.currentPage().getParameters().get('partnerDataField2'))) {
                                partnerBOCAtoProspect.Partner_Data_Field_2__c = ApexPages.currentPage().getParameters().get('partnerDataField2');
                            }
                            if (!String.isEmpty(ApexPages.currentPage().getParameters().get('partnerDataField3'))) {
                                partnerBOCAtoProspect.Partner_Data_Field_3__c= ApexPages.currentPage().getParameters().get('partnerDataField3');
                            }

                            if (!String.isEmpty(ApexPages.currentPage().getParameters().get('partnerDataField4'))) {
                                partnerBOCAtoProspect.Partner_Data_Field_4__c = ApexPages.currentPage().getParameters().get('partnerDataField4');
                            }

                            if (!String.isEmpty(ApexPages.currentPage().getParameters().get('partnerDataField5'))) {
                                partnerBOCAtoProspect.Partner_Data_Field_5__c = ApexPages.currentPage().getParameters().get('partnerDataField5');
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
        PageReference nextPage;
        try {
            //validate the partner sales code
            if(partnerBOCAtoProspect.Partner_Sales_Code__c != partner.External_Sales_Code__c) throw new partnerBOCAToProspectException('Verification Code does not match our records.');

            //IADJUDICAT-1186 turn that partner boca into a wrapper, since we will map it to one of three boca types. mapping is prettier that way. plus there are values we have to build
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
                partnerBOCAtoProspect.External_Application_URL__c = keyMaster.theURL;
                upsert partnerBOCAtoProspect;

                System.debug('### DEBUG - PartnerBOCAToProspect ID: ' + partnerBOCAtoProspect);

                BOCA_To_Prospect_Settings__c bocaToProspectSettings = BOCA_To_Prospect_Settings__c.getOrgDefaults();

                String emailTemplateId = bocaToProspectSettings.Partner_BOCA_To_Prospect_Template__c;

                Id myRecType = UtilityClass.getRecTypeByDevName('Contact', 'F1_Contact');

                Contact temporaryContact = new Contact();

                temporaryContact.FirstName = myWrapper.ContactFirstName;
                temporaryContact.LastName = myWrapper.ContactLastName;
                temporaryContact.Email = myWrapper.Email;
                temporaryContact.RecordTypeId = myRecType;

                insert temporaryContact;

                if(!Test.isRunningTest()) Messaging.reserveSingleEmailCapacity(1);
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

                nextPage = Page.PartnerBOCAToProspect;
                nextPage.getParameters().put('action', 'confirm');
                nextPage.getParameters().put('appId', myAppRecord.Id);
                nextPage.getParameters().put('partner', partnerParameter);
                nextPage.setRedirect(true);

            }

        } catch (Exception e) {

            System.debug('Exception Encountered Sending Application: ' + e.getStackTraceString() + ' ' + e);

            String errorNumber = WEXDEVErrorReporting.reportExternalError(APPLICATION_NAME, ApexPages.currentPage().getUrl(), e);

            nextPage = Page.ExternalApplicationError;
            nextPage.getParameters().put('errorCode', errorNumber);

        }

        return nextPage;

    }

    //IADJUDICAT-1186 use field mapping to go from wrapper to whichever object we need
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

    //IADJUDICAT-1186 create a useful sobject out of a meaningless wrapper
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

    //IADJUDICAT-1186 using a wrapper class thingy specifically for this controller
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
        public String RepFirstName;
        public String RepLastName;
        public String RepEmail;
        public String RepCode;
        public String RepPhone;
        public String OtherId;
        public String PartnerDataField1;
        public String PartnerDataField2;
        public String PartnerDataField3;
        public String PartnerDataField4;
        public String PartnerDataField5;

        //constructor stuffs
        public ParAppTheWrapper(Partner_BOCA_To_Prospect__c myPBTP, PartnerBOCAToProspectController thisController){
            this.Stage = 'Application';
            this.Status = 'App-Incomplete';
            this.ContactFirstName = myPBTP.First_Name__c;
            this.ContactLastName = myPBTP.Last_Name__c;
            this.Email = myPBTP.Email__c;
            this.PhoneNumber = myPBTP.Phone__c;
            this.LegalBusinessName = myPBTP.Company_Name__c;
            this.Program = thisController.selectedprogram;
            this.Offer = thisController.selectedoffer;
            this.RepFirstName = myPBTP.Sales_Rep_First_Name__c;
            this.RepLastName = myPBTP.Sales_Rep_Last_Name__c;
            this.RepEmail = myPBTP.Sales_Rep_Email__c;
            this.RepCode = myPBTP.Sales_Rep_Code__c;
            this.RepPhone = myPBTP.Sales_Rep_Phone__c;
            this.OtherId = myPBTP.Partner_Opportunity_ID__c;

            // https://jira.devtools.wexinc.com/browse/PSOBACKLOG-247
            this.PartnerDataField1 = myPBTP.Partner_Data_Field_1__c;
            this.PartnerDataField2 = myPBTP.Partner_Data_Field_2__c;
            this.PartnerDataField3 = myPBTP.Partner_Data_Field_3__c;
            this.PartnerDataField4 = myPBTP.Partner_Data_Field_4__c;
            this.PartnerDataField5 = myPBTP.Partner_Data_Field_5__c;

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
                this.Status = 'Sent to Prospect';
            } else if(nafTypes.contains(BOCAType)){
                this.AppObjectType = 'WeFormObject__c';
                this.LookupField = 'WeFormObject__c';
                this.Status = 'App - Incomplete';
            } else if(otrTypes.contains(BOCAType)){
                this.AppObjectType = 'OnlineApplication__c';
                this.LookupField = 'Online_Application__c';
            }
        }

    }

    //IADJUDICAT-1186 generated key and url for future use
    public class KeyURLWrapper{
        public String theKey;
        public String theURL;

        public KeyURLWrapper(ParAppTheWrapper myWrapper, String myId){
            this.theKey = UtilityClass.generateAppKey();
            String offer = myWrapper.Offer;
            Program__c myProgram = WexBrandingController.getProgram(myWrapper.Program);
            String myURL = 'https://' + Label.External_Instance_URL + '/creditapplication/' + myProgram.Form_Template__c;
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