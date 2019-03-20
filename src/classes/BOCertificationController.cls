public class BOCertificationController {

    public String preview {
        get {
            if(ApexPages.CurrentPage().getParameters().get('preview') != null) { return ApexPages.CurrentPage().getParameters().get('preview'); }
            return null;
        }
    }

    public String applicationId {
        get {
            if(ApexPages.CurrentPage().getParameters().get('customer') != null) { return ApexPages.CurrentPage().getParameters().get('customer'); }
            return null;
        }
    }

    public String applicationType {
        get {
            if(applicationId != null) {
                return (Id.valueOf(applicationId)).getSobjectType().getDescribe().getName();
            }
            return null;
        }
    }

    public String weFormId {
        get {
            if(ApexPages.CurrentPage().getParameters().get('weFormId') != null) { return ApexPages.CurrentPage().getParameters().get('weFormId'); }
            return null;
        }
    }

    public String eappId {
        get {
            if(ApexPages.CurrentPage().getParameters().get('eappId') != null) { return ApexPages.CurrentPage().getParameters().get('eappId'); }
            return null;
        }
    }

    public String cpAppId {
        get {
            if(ApexPages.CurrentPage().getParameters().get('cpAppId') != null) { return ApexPages.CurrentPage().getParameters().get('cpAppId'); }
            return null;
        }
    }

    public String formkey {
        get {
            if(ApexPages.CurrentPage().getParameters().get('formkey') != null) { return ApexPages.CurrentPage().getParameters().get('formkey'); }
            return null;
        }
    }

    public String boEntityId {
        get {
            if(ApexPages.CurrentPage().getParameters().get('entityId') != null) { return ApexPages.CurrentPage().getParameters().get('entityId'); }
            return null;
        }
    }

    public String programParameter {
        get {
            if(ApexPages.CurrentPage().getParameters().get('pgm') != null) { return ApexPages.CurrentPage().getParameters().get('pgm'); }
            return null;
        }
    }

    public String confirmationId {
        get {
            if(ApexPages.CurrentPage().getParameters().get('confirmationId') != null) { return ApexPages.CurrentPage().getParameters().get('confirmationId'); }
            return null;
        }
    }

    public String saved {
        get {
            if(ApexPages.CurrentPage().getParameters().get('saved') != null) { return ApexPages.CurrentPage().getParameters().get('saved'); }
            return null;
        }
    }

    public String couponCode { get; set; }

    public String locationCode { get; set; }

    public WeFormObject__c weFormObject { get; set; }

    public OnlineApplication__c onlineApplication { get; set; }

    public CP_Application_Request__c cpApplicationRequest { get; set; }

    public Boolean formKeyExpired { get; set; }

    public Boolean alreadySubmitted {
        get {

            if(weFormId != null) {
                List<WeFormObject__c> weFormObjects = [SELECT Id FROM WeFormObject__c WHERE Id =: weFormId and (Status__c = 'bo-needed' or (Status__c = 'complete' and BOCA_Type__c = 'OTR'))];

                if(weFormObjects.size() == 0) { return true; }
            }

            return false;

        }
    }

    public Boolean saveForLater { get; set; }

    public Beneficial_Owner_Entity__c boEntity { get; set; }

    public Boolean noOwnerProngs { get; set; }

    public Boolean exemptFromOwnerProngs { get; set; }

    public Boolean isOwnerAController {
        get {

            Boolean isOwnerAController = false;

            if(boOwners != null && boOwners.size() > 0) {
                for(OwnerProng owner : boOwners) { if(owner.isController != null && owner.isController == true) { isOwnerAController = true; } }
            }

            return isOwnerAController;
        }
    }

    // Disclaimer related to the program
    public String overrideCSS {
        get {
            StaticResource sr = null;

            // A lot of this will be able to be removed after we're
            // not having to support backwards compatability.. Path
            // of least resistance..
            if(program != null && !String.isEmpty(program.Brand_CSS_Overrides__c)) {
                sr = [SELECT Body FROM StaticResource WHERE Name = :program.Brand_CSS_Overrides__c];

                return sr.Body.toString();
            }

            return null;
        }
    }

    // Up to 4 owners, so list
    public List<OwnerProng> boOwners { get; set; }

    // One controller
    public ControlProng boController { get; set; }

    public Map<String, Schema.RecordTypeInfo> boEntityRecordTypes {
        get {
            Map<String, Schema.RecordTypeInfo> boEntityRecordTypes = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName();
            return boEntityRecordTypes;
        }
    }

    public Id beneficialOwnerRecordTypeId {
        get {
            if(Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Beneficial Owner') != null) { return Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Beneficial Owner').getRecordTypeId(); }
            return null;
        }
    }

    public Id controlPersonRecordTypeId {
        get {
            if(Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Control Person') != null) { return Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Control Person').getRecordTypeId(); }
            return null;
        }
    }

    public List<SelectOption> countriesList {
        get {
            List<SelectOption> countryOfResidenceOptions = new List<SelectOption>();

            countryOfResidenceOptions.add(new SelectOption('#', '--Choose One--'));

            Schema.DescribeFieldResult countryDescription = Beneficial_Owner_Prong__c.Country__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = countryDescription.getPicklistValues();
            for(Schema.PicklistEntry picklistValue : picklistEntries){ countryOfResidenceOptions.add(new SelectOption(picklistValue.getLabel(), picklistValue.getLabel())); }
            return countryOfResidenceOptions;
        }
    }

    public List<SelectOption> stateList {
        get {

            Set<String> states = new Set<String>{'AK','AL','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY'};

            List<SelectOption> statesList = new List<SelectOption>();

            statesList.add(new SelectOption('', '--Choose One--'));

            for(String state : states) { statesList.add(new SelectOption(state, state)); }

            return statesList;

        }
    }



    public List<SelectOption> provinceList {
        get {

            Set<String> provinces = new Set<String>{'AB', 'BC', 'MB', 'NB', 'NL', 'NS', 'ON', 'PE', 'QC', 'SK'};

            List<SelectOption> provinceList = new List<SelectOption>();

            provinceList.add(new SelectOption('', '--Choose One--'));

            for(String province : provinces) { provinceList.add(new SelectOption(province, province)); }

            return provinceList;

        }
    }

    public Integer boOwnersSize {
        get { return boOwners.size(); }
    }

    public Integer selectedBoOwnerIndex { get; set; }

    public Boolean ownersNotApplicable { get; set; }

    public String languageCode {
        get { if(ApexPages.CurrentPage().getParameters().get('lang') != null) { return ApexPages.CurrentPage().getParameters().get('lang'); } return 'en_us';
        }
    }

    // Branding logo related to the program
    public Id brandingLogo { get; set; }

    // Branding card related to the program
    public Id brandingCard { get; set; }

    public Program__c program { get; set; }

    public BOCA_res__c brandingUtility { get; set; }

    public Campaign campaign { get; set; }

    public OnlineApplicationOffer__c onlineApplicationOffer { get; set; }

    // Sales rep information if BOCA to Prospect
    public User salesRep { get; set; }

    // Get the Sales Code if BOCA to Prospect
    public String salesCode {
        get { return ApexPages.CurrentPage().getParameters().get('salescode'); }
    }

    public String confirmationNumber { get; set; }

    public class bocddException extends Exception {}

    public Boolean hasError {
        get { if(!String.isEmpty(errorMessage)) { return true; } return false; }
    }

    public String errorMessage { get; set; }

    // Get the full URL for the page
    private String applicationURL {
        get {
            String hostVal  = ApexPages.currentPage().getHeaders().get('Host');
            String urlVal = Apexpages.currentPage().getUrl();
            urlVal = EncodingUtil.urlEncode(urlVal, 'UTF-8');
            string[] urlValExtra = urlVal.split('%3F',0);
            urlVal = urlValExtra[0];
            urlVal = EncodingUtil.urlDecode(urlVal, 'UTF-8');
            return 'https://' + hostVal + urlVal;
        }
    }

    public BOCertificationController() {

        exemptFromOwnerProngs = false;
        ownersNotApplicable = false;
        saveForLater = false;
        formKeyExpired = false;
    }

    public void init() {

        try {

            if(!String.isEmpty(programParameter)) {

                Id programId = WexBrandingController.getProgramIdByBrandShortName(programParameter);

                if (programId != null) {

                    program = WexBrandingController.getProgram(programId);

                    Id brandingUtilityId = WexBrandingController.getBrandingUtilityByProgramId(programId, languageCode);

                    if (brandingUtilityId != null) {

                        brandingUtility = WexBrandingController.getBrandingUtility(brandingUtilityId);

                    }

                    brandingLogo = WexBrandingController.getLogoId(programId);

                    brandingCard = WexBrandingController.getCreditCardImageId(programId);

                }

            }

            if(String.isEmpty(confirmationId)) {

                if(!String.isEmpty(weFormId) || (applicationId != null && (applicationType).equalsIgnoreCase('WeFormObject__c'))) {

                    List<WeFormObject__c> weFormObjects = [SELECT Id, Campaign_Program_ID__c, Location_Code__c, Opportunity__c, Opportunity__r.AccountId, Online_Application__c, BOCA_Type__c, First_Name__c, Last_Name__c, Email__c, Sales_Id__c, Legal_Structure__c, Beneficial_Owner_Information__c, Status__c, Program__r.Brand_Short_Name__c  FROM WeFormObject__c WHERE Id =: weFormId and (Status__c = 'bo-needed' or (Status__c = 'complete' and BOCA_Type__c = 'OTR'))];

                    if(weFormObjects.size() > 0) {

                        weFormObject = weFormObjects[0];

                        locationCode = weFormObject.Location_Code__c;

                        if(weFormObject != null & (weFormObject.Legal_Structure__c).equalsIgnoreCase('Non-Profit')) { exemptFromOwnerProngs = true; }

                        if(weFormObject.Sales_Id__c != null) {
                            List<User> u = new List<User>();

                            try { u = [SELECT Name, Id, email, phone, Sales_Code__c, fax FROM USER WHERE Id =: weFormObject.Sales_Id__c LIMIT 1]; }
                            catch(SYSTEM.DmlException ex) { SYSTEM.debug('Exception during Sales Rep lookup: ' + ex); }

                            salesRep = (u.size() != 0) ? u.get(0) : null;
                        }

                        List<Campaign_Program__c> campaignPrograms = [SELECT Id, Campaign__r.Coupon_Code__c FROM Campaign_Program__c WHERE Id =: weFormObject.Campaign_Program_ID__c];

                        if(campaignPrograms.size() > 0) {
                            couponCode = campaignPrograms[0].Campaign__r.Coupon_Code__c;
                        }
                    }
                    else { throw new bocddException('Your information has already been submitted.'); }

                }

                if(!String.isEmpty(eappId) || (applicationId != null && (applicationType).equalsIgnoreCase('OnlineApplication__c'))) {

                    List<OnlineApplication__c> onlineApplicationRecords = new List<OnlineApplication__c>();

                    if(!String.isEmpty(eappId)) {
                        onlineApplicationRecords  = [SELECT Id, Opportunity__c, Opportunity__r.AccountId, Type_of_Business__c, Beneficial_Owner_Information__c, Contact_Name__c, Email__c, Offer__c, Application_Key__c FROM OnlineApplication__c WHERE Id = :eappId and Beneficial_Owner_Information__c = null];
                    }
                    else {
                        onlineApplicationRecords  = [SELECT Id, Opportunity__c, Opportunity__r.AccountId, Type_of_Business__c, Beneficial_Owner_Information__c, Contact_Name__c, Email__c, Offer__c, Application_Key__c FROM OnlineApplication__c WHERE Id = :applicationId];
                    }

                    if(onlineApplicationRecords.size() > 0) {

                        onlineApplication = onlineApplicationRecords[0];

                        if(onlineApplication != null & (onlineApplication.Type_of_Business__c).equalsIgnoreCase('Non-Profit')) { exemptFromOwnerProngs = true; }

                        if(onlineApplication.Offer__c != null) {

                            List<OnlineApplicationOffer__c> onlineApplicationOffers = [SELECT Id, EchoSign_Header_Image__c FROM OnlineApplicationOffer__c WHERE Id =: onlineApplication.Offer__c];

                            if(onlineApplicationOffers.size() > 0) { onlineApplicationOffer = onlineApplicationOffers[0]; }

                        }
                    }
                    else { throw new bocddException('Your information has already been submitted.'); }

                }

                if(!String.isEmpty(cpAppId) || (applicationId != null && (applicationType).equalsIgnoreCase('CP_Application_Request__c'))) {

                    List<CP_Application_Request__c> cpApplicationRequests = [SELECT Id, Opportunity__c, Account__c, Legal_Structure__c, Beneficial_Owner_Entity__c, First_Name__c, Last_Name__c, Email__c FROM CP_Application_Request__c WHERE Id =: cpAppId and Beneficial_Owner_Entity__c = null];

                    if(cpApplicationRequests.size() > 0) {

                        cpApplicationRequest = cpApplicationRequests[0];

                        if(cpApplicationRequest != null & (cpApplicationRequest.Legal_Structure__c).equalsIgnoreCase('Non-Profit')) { exemptFromOwnerProngs = true; }

                    }
                    else { throw new bocddException('Your information has already been submitted.'); }

                }

                if(!String.isEmpty(boEntityId) && !String.isEmpty(formKey)) {

                    List<Beneficial_Owner_Entity__c> boEntities = [SELECT Id, Save_For_Later_Key__c, Save_For_Later_Date__c, Certified_By__c, Certified_Date__c, Legal_Structure__c, Correspondence_Contact__c, No_Beneficial_Owners__c, Program__c, Program_Long_Name__c, Program_Short_Name__c, RecordTypeId FROM Beneficial_Owner_Entity__c WHERE Id =: boEntityId and Record_Status__c = 'Awaiting Customer' and Save_For_Later_Key__c =: formkey  and Save_For_Later_Date__c = LAST_N_DAYS:30];

                    if(boEntities.size() > 0) {

                        // Set the entity
                        boEntity = new Beneficial_Owner_Entity__c();
                        boEntity.Id = boEntities[0].Id;
                        boEntity.Correspondence_Contact__c = boEntities[0].Correspondence_Contact__c;
                        boEntity.Save_For_Later_Key__c = boEntities[0].Save_For_Later_Key__c;
                        boEntity.RecordTypeId = boEntities[0].RecordTypeId;
                        boEntity.Certified_By__c = boEntities[0].Certified_By__c;
                        boEntity.Certified_Date__c = boEntities[0].Certified_Date__c;

                        if(boEntities[0].Legal_Structure__c != null && (boEntities[0].Legal_Structure__c).equalsIgnoreCase('Non-profit')) { exemptFromOwnerProngs = true; boEntity.No_Beneficial_Owners__c = true; }

                        if(boEntities[0].No_Beneficial_Owners__c == true) { ownersNotApplicable = true; }

                        List<Beneficial_Owner_Prong__c> beneficialOwners = [SELECT Id, First_Name__c, Last_Name__c, Address_Line_1__c, Address_Line_2__c, City__c, State__c, Country__c, Postal_Code__c FROM Beneficial_Owner_Prong__c WHERE Beneficial_Owner_Entity__c =: boEntity.Id and RecordTypeId = :beneficialOwnerRecordTypeId];

                        if(beneficialOwners.size() > 0 && ownersNotApplicable == false && exemptFromOwnerProngs == false) {

                            boOwners = new List<OwnerProng>();

                            for(Beneficial_Owner_Prong__c beneficialOwner : beneficialOwners) {

                                OwnerProng owner = new OwnerProng();

                                owner.ownerId = beneficialOwner.Id;
                                owner.firstName = beneficialOwner.First_Name__c;
                                owner.lastName = beneficialOwner.Last_Name__c;
                                owner.addressLine1 = beneficialOwner.Address_Line_1__c;
                                owner.addressLine2 = beneficialOwner.Address_Line_2__c;
                                owner.city = beneficialOwner.City__c;
                                owner.state = beneficialOwner.State__c;
                                owner.countryOfResidence = beneficialOwner.Country__c;
                                owner.postalCode = beneficialOwner.Postal_Code__c;

                                boOwners.add(owner);

                            }

                        }

                        List<Beneficial_Owner_Prong__c> beneficialController = [SELECT Id, Title__c, First_Name__c, Last_Name__c, Address_Line_1__c, Address_Line_2__c, City__c, State__c, Country__c, Postal_Code__c FROM Beneficial_Owner_Prong__c WHERE Beneficial_Owner_Entity__c =: boEntity.Id and RecordTypeId = :controlPersonRecordTypeId];

                        if(beneficialController.size() > 0) {

                            boController = new ControlProng();

                            boController.controllerId = beneficialController[0].Id;
                            boController.firstName = beneficialController[0].First_Name__c;
                            boController.lastName = beneficialController[0].Last_Name__c;
                            boController.title = beneficialController[0].Title__c;
                            boController.addressLine1 = beneficialController[0].Address_Line_1__c;
                            boController.addressLine2 = beneficialController[0].Address_Line_2__c;
                            boController.city = beneficialController[0].City__c;
                            boController.state = beneficialController[0].State__c;
                            boController.countryOfResidence = beneficialController[0].Country__c;
                            boController.postalCode = beneficialController[0].Postal_Code__c;

                        }

                    }
                    else { formKeyExpired = true; }

                }

                if(boEntity == null) {

                    // Initiate the parent record and set appropriate record type
                    boEntity = new Beneficial_Owner_Entity__c();

                    if(weFormObject != null) {

                        // TODO - We can remove the BOCA Type later on..
                        if(weFormObject.BOCA_Type__c == 'Fuel Card') { boEntity.RecordTypeId = boEntityRecordTypes.get('Fuel Card').getRecordTypeId(); }
                        else if(weFormObject.BOCA_Type__c == 'OTR') {
                            boEntity.Account__c = weFormObject.Opportunity__r.AccountId;
                            boEntity.Opportunity__c = weFormObject.Opportunity__c;
                            boEntity.Online_Application__c = weFormObject.Online_Application__c;
                            boEntity.RecordTypeId = boEntityRecordTypes.get('Fleet Card').getRecordTypeId();
                        }

                    }
                    else if(onlineApplication != null) {
                        boEntity.Online_Application__c = onlineApplication.Id;
                        boEntity.Opportunity__c = onlineApplication.Opportunity__c;
                        boEntity.Account__c = onlineApplication.Opportunity__r.AccountId;
                        boEntity.Legal_Structure__c = onlineApplication.Type_of_Business__c;
                        boEntity.RecordTypeId = boEntityRecordTypes.get('Fleet Card').getRecordTypeId();
                    }
                    else if(cpApplicationRequest != null) {
                        boEntity.Account__c = cpApplicationRequest.Account__c;
                        boEntity.Opportunity__c = cpApplicationRequest.Opportunity__c;
                        boEntity.CorporatePayments_Application_Request__c = cpApplicationRequest.Id;
                        boEntity.RecordTypeId = boEntityRecordTypes.get('CorporatePayments').getRecordTypeId();
                    }

                }

                if(boOwners == null) { boOwners = new List<OwnerProng>(); addOwner(); }

                if(boController == null) {

                    // Initiate a controller with the correct record type
                    boController = new ControlProng();
                    if((languageCode).equalsIgnoreCase('en_us')) {
                        boController.countryOfResidence = 'United States';
                    }
                    else if((languageCode).equalsIgnoreCase('en_ca') || (languageCode).equalsIgnoreCase('fr_ca')) { boController.countryOfResidence = 'Canada'; }

                }
            }
            else {

            }

        }
        catch(Exception e) {

            String errorNumber = logError(e);

            errorMessage = e.getMessage() + '<br/><br/>Our support organization has been notified. Your error tracking code is: ' + errorNumber + '.';

        }

    }

    public void addOwner() {

        if(boOwnersSize < 4) {

            OwnerProng boOwner = new OwnerProng();

            if((languageCode).equalsIgnoreCase('en_us')) { boOwner.countryOfResidence = 'United States'; }
            else if((languageCode).equalsIgnoreCase('en_ca') || (languageCode).equalsIgnoreCase('fr_ca')) { boOwner.countryOfResidence = 'Canada'; }

            boOwners.add(boOwner);

        }

    }

    public void removeOwner() {

        if(boOwners[selectedBoOwnerIndex].ownerId != null) {

            Beneficial_Owner_Prong__c[] boOwnerToRemove = [SELECT Id FROM Beneficial_Owner_Prong__c WHERE Id =: boOwners[selectedBoOwnerIndex].ownerId];

            delete boOwnerToRemove;

        }

        boOwners.remove(selectedBoOwnerIndex);

    }

    // Executes if they fill out the BO Owner boxes, but then click "Not Applicable"
    public void removeOwners() {

        for(OwnerProng prong : boOwners) {

            if(prong.ownerId != null) {

                Beneficial_Owner_Prong__c[] boOwnerToRemove = [SELECT Id FROM Beneficial_Owner_Prong__c WHERE Id =: prong.ownerId];

                delete boOwnerToRemove;

            }

        }

        boOwners = new List<OwnerProng>();
        addOwner();

    }

    public void setOwnerSameAsController() {

        if(isOwnerAController == true && boController != null && selectedBoOwnerIndex != null) {
            boController.firstName = boOwners[selectedBoOwnerIndex].firstName;
            boController.lastName = boOwners[selectedBoOwnerIndex].lastName;
            boController.addressLine1 = boOwners[selectedBoOwnerIndex].addressLine1;
            boController.addressLine2 = boOwners[selectedBoOwnerIndex].addressLine2;
            boController.city = boOwners[selectedBoOwnerIndex].city;
            boController.state = boOwners[selectedBoOwnerIndex].state;
            boController.postalCode = boOwners[selectedBoOwnerIndex].postalCode;
            boController.countryOfResidence = boOwners[selectedBoOwnerIndex].countryOfResidence;
            boController.dateOfBirth = boOwners[selectedBoOwnerIndex].dateOfBirth;
            boController.socialSecurityNumber = boOwners[selectedBoOwnerIndex].socialSecurityNumber;
            boController.passportNumber = boOwners[selectedBoOwnerIndex].passportNumber;
            boController.countryOfIssue = boOwners[selectedBoOwnerIndex].countryOfIssue;
        }
        else {
            boController.firstName = '';
            boController.lastName = '';
            boController.addressLine1 = '';
            boController.addressLine2 = '';
            boController.city = '';
            boController.state = '';
            boController.postalCode = '';
            boController.countryOfResidence = '';
            boController.dateOfBirth = '';
            boController.socialSecurityNumber = '';
            boController.passportNumber = '';
            boController.countryOfIssue = '';
        }


    }

    public void clearAddressFieldsOnCountryChange() {

        if(selectedBoOwnerIndex != null && selectedBoOwnerIndex != -1) {
            boOwners[selectedBoOwnerIndex].addressLine1 = '';
            boOwners[selectedBoOwnerIndex].addressLine2 = '';
            boOwners[selectedBoOwnerIndex].city = '';
            boOwners[selectedBoOwnerIndex].state = '';
            boOwners[selectedBoOwnerIndex].postalCode = '';
            if(!(boOwners[selectedBoOwnerIndex].countryOfResidence).equalsIgnoreCase('United States')) { boOwners[selectedBoOwnerIndex].socialSecurityNumber = ''; }
        }
        else if(selectedBoOwnerIndex == -1) {
            boController.addressLine1 = '';
            boController.addressLine2 = '';
            boController.city = '';
            boController.state = '';
            boController.postalCode = '';
            if(!(boController.countryOfResidence).equalsIgnoreCase('United States')) { boController.socialSecurityNumber = ''; }
        }
    }

    public PageReference submitForm() {

        try {

            if(!alreadySubmitted || saveForLater) {

                // Upsert the BO Entity
                boEntity.No_Beneficial_Owners__c = (ownersNotApplicable || exemptFromOwnerProngs) ? true : false;

                if(saveForLater) {

                    boEntity.Record_Status__c = 'Awaiting Customer';

                    String salt = EncodingUtil.convertToHex(crypto.generateAesKey(128));

                    if(formKey == null) {
                        boEntity.Save_For_Later_Key__c = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(salt.substring(0, 25))));
                        boEntity.Save_For_Later_Date__c = Date.today();
                    }

                }
                else { boEntity.Record_Status__c = 'Active'; }

                boEntity.Verification_Status__c = 'Pending Lexis/Nexis';

                if(languageCode.equalsIgnoreCase('fr_ca')) { boEntity.Language_Preference__c = 'French'; }

                Database.upsertResult result = Database.upsert(boEntity);
                if(result.isSuccess()){

                    String cacheControl = String.valueOf(DateTime.Now().format('yyyyMMddHHmmssFFF'));

                    if(saveForLater && weFormObject != null) {

                        boEntity.Save_For_Later_URL__c = 'https://' + Label.External_Instance_URL + '/creditapplication/BOCertification?pgm=' + programParameter + '&lang=' + languageCode + '&weFormId=' + weFormObject.Id + '&formKey=' + boEntity.Save_For_Later_Key__c + '&entityId=' + boEntity.Id  + '&cacheControl=' + cacheControl;

                        if(boEntity.Correspondence_Contact__c == null) {

                            Contact correspodenceContact = new Contact(FirstName = weFormObject.First_Name__c, LastName = weFormObject.Last_Name__c, Email = weFormObject.Email__c);

                            insert correspodenceContact;

                            boEntity.Correspondence_Contact__c = correspodenceContact.Id;

                        }

                        boEntity.WeFormObject__c = weFormObject.Id;

                    }
                    else if(saveForLater && onlineApplication != null) {

                        // TODO - We can remove after eApp is gone
                        if(applicationId != null) {
                            boEntity.Save_For_Later_URL__c = 'https://' + Label.External_Instance_URL + '/appl/BOCertification?lang=' + languageCode + '&customer=' + onlineApplication.Id + '&formKey=' + boEntity.Save_For_Later_Key__c + '&entityId=' + boEntity.Id  + '&cacheControl=' + cacheControl;
                        }
                        else {
                            boEntity.Save_For_Later_URL__c = 'https://' + Label.External_Instance_URL + '/appl/BOCertification?lang=' + languageCode + '&eappId=' + onlineApplication.Id + '&formKey=' + boEntity.Save_For_Later_Key__c + '&entityId=' + boEntity.Id + '&cacheControl=' + cacheControl;
                        }

                        if(boEntity.Correspondence_Contact__c == null) {

                            String[] name = onlineApplication.Contact_Name__c.split(' ');

                            Contact correspodenceContact = new Contact(FirstName = name[0], LastName = name[1], Email = onlineApplication.Email__c);

                            insert correspodenceContact;

                            boEntity.Correspondence_Contact__c = correspodenceContact.Id;

                        }

                        boEntity.Online_Application__c = onlineApplication.Id;

                    }
                    else if(saveForLater && cpApplicationRequest != null) {

                        boEntity.Save_For_Later_URL__c = 'https://' + Label.External_Instance_URL + '/appl/BOCertification?lang=' + languageCode + '&cpAppId=' + cpApplicationRequest.Id + '&formKey=' + boEntity.Save_For_Later_Key__c + '&entityId=' + boEntity.Id  + '&cacheControl=' + cacheControl;

                        if(boEntity.Correspondence_Contact__c == null) {

                            Contact correspodenceContact = new Contact(FirstName = cpApplicationRequest.First_Name__c, LastName = cpApplicationRequest.Last_Name__c, Email = onlineApplication.Email__c);

                            insert correspodenceContact;

                            boEntity.Correspondence_Contact__c = correspodenceContact.Id;

                        }

                        boEntity.CorporatePayments_Application_Request__c = cpApplicationRequest.Id;

                    }
                    else if(saveForLater && formKey != null) { boEntity.Save_For_Later_URL__c = 'https://' + Label.External_Instance_URL + '/creditapplication/BOCertification?pgm=' + programParameter + '&lang=' + languageCode + '&entityId=' + boEntity.Id + '&formKey=' + formKey + '&cacheControl=' + cacheControl; }

                    result = Database.upsert(boEntity);
                    if(result.isSuccess()){

                        confirmationNumber = [SELECT Id, Name FROM Beneficial_Owner_Entity__c WHERE Id =: result.getId()].Name;

                        if(ownersNotApplicable == false && exemptFromOwnerProngs == false) {

                            // Upsert the BO Owner
                            for(OwnerProng boOwner : boOwners) {

                                Beneficial_Owner_Prong__c boOwnerProng = new Beneficial_Owner_Prong__c();

                                if(boOwner.ownerId != null) { boOwnerProng.Id = boOwner.ownerId; }

                                boOwnerProng.RecordTypeId = beneficialOwnerRecordTypeId;

                                if(boOwner.ownerId == null) { boOwnerProng.Beneficial_Owner_Entity__c = boEntity.Id; }

                                if(saveForLater) { boOwnerProng.Verification_Status__c = 'Saved'; }
                                else { boOwnerProng.Verification_Status__c = 'Pending Lexis/Nexis'; }

                                boOwnerProng.First_Name__c = boOwner.firstName;
                                boOwnerProng.Last_Name__c = boOwner.lastName;
                                boOwnerProng.Address_Line_1__c = boOwner.addressLine1;
                                boOwnerProng.Address_Line_2__c = boOwner.addressLine2;
                                boOwnerProng.City__c = boOwner.city;
                                boOwnerProng.State__c = boOwner.state;
                                boOwnerProng.Postal_Code__c = boOwner.postalCode;
                                boOwnerProng.Country__c = boOwner.countryOfResidence;

                                if(!saveForLater) {

                                    boOwnerProng.Date_Of_Birth__c = Date.parse(boOwner.dateOfBirth);
                                    if(boOwner.socialSecurityNumber != null) { boOwnerProng.Social_Security_Number__c = boOwner.socialSecurityNumber; }
                                    if(boOwner.passportNumber != null) { boOwnerProng.Passport_Number_Other_Government_ID__c = boOwner.passportNumber; }
                                    if(boOwner.countryOfIssue != null && !(boOwner.countryOfIssue).equalsIgnoreCase('#')) { boOwnerProng.Country_Of_Issue__c = boOwner.countryOfIssue; }

                                }

                                result = Database.upsert(boOwnerProng);
                                if(!result.isSuccess()){ throw new bocddException(String.valueOf(result.getErrors())); }

                            }

                        }

                        Beneficial_Owner_Prong__c boControllerProng = new Beneficial_Owner_Prong__c();

                        boControllerProng.RecordTypeId = controlPersonRecordTypeId;

                        if(boController.controllerId != null) { boControllerProng.Id = boController.controllerId; }
                        else { boControllerProng.Beneficial_Owner_Entity__c = boEntity.Id; }

                        if(saveForLater) { boControllerProng.Verification_Status__c = 'Saved'; }
                        else { boControllerProng.Verification_Status__c = 'Pending Lexis/Nexis'; }

                        boControllerProng.First_Name__c = boController.firstName;
                        boControllerProng.Last_Name__c = boController.lastName;
                        boControllerProng.Title__c = boController.title;
                        boControllerProng.Address_Line_1__c = boController.addressLine1;
                        boControllerProng.Address_Line_2__c = boController.addressLine2;
                        boControllerProng.City__c = boController.city;
                        boControllerProng.State__c = boController.state;
                        boControllerProng.Postal_Code__c = boController.postalCode;
                        boControllerProng.Country__c = boController.countryOfResidence;

                        // We don't want to save this information
                        // per higher level direction
                        if(!saveForLater) {

                            boControllerProng.Date_Of_Birth__c = Date.parse(boController.dateOfBirth);

                            if(boController.socialSecurityNumber != null) { boControllerProng.Social_Security_Number__c = boController.socialSecurityNumber; }
                            if(boController.passportNumber != null) { boControllerProng.Passport_Number_Other_Government_ID__c = boController.passportNumber; }
                            if(boController.countryOfIssue != null && !(boController.countryOfIssue).equalsIgnoreCase('#')) { boControllerProng.Country_Of_Issue__c = boController.countryOfIssue; }

                        }

                        result = Database.upsert(boControllerProng);

                        if(!result.isSuccess()){ throw new bocddException(String.valueOf(result.getErrors())); }

                        if(saveForLater) {
                            PageReference beneficialOwner = Page.BOCertification;
                            beneficialOwner.getParameters().put('pgm', programParameter);
                            beneficialOwner.getParameters().put('lang', languageCode);
                            beneficialOwner.getParameters().put('saved', 'true');
                            beneficialOwner.setRedirect(true);
                            return beneficialOwner;
                        }

                    }
                    else { throw new bocddException(String.valueOf(result.getErrors())); }

                }
                else { throw new bocddException(String.valueOf(result.getErrors())); }

            }
            else if(alreadySubmitted && weFormId != null) {
                PageReference beneficialOwner = Page.BOCertification;
                beneficialOwner.getParameters().put('weFormId', weFormId);
                beneficialOwner.getParameters().put('pgm', programParameter);
                beneficialOwner.getParameters().put('lang', languageCode);
                beneficialOwner.getParameters().put('1', '1');
                beneficialOwner.setRedirect(true);
                return beneficialOwner;
            }
            else {
                PageReference beneficialOwner = Page.BOCertification;
                beneficialOwner.getParameters().put('pgm', programParameter);
                beneficialOwner.getParameters().put('lang', languageCode);
                beneficialOwner.setRedirect(true);
                return beneficialOwner;
            }


        }
        catch(Exception e) {

            String errorCode = logError(e);

            PageReference wexBOCAError = Page.WexBOCAError;
            wexBOCAError.getParameters().put('errorCode', '2');
            wexBOCAError.getParameters().put('errorReferenceNumber', errorCode);
            wexBOCAError.setRedirect(true);
            return wexBOCAError;

        }

        return null;

    }

    public PageReference submitCreditApp() {

        try {

            // Run das lexis nexis check!
            CreditWS_LexisNexis.beneficialOwnerVerification(boEntity.Id);

            // Finish the application process for Fuel Card
            if(weFormObject != null) {

                weFormObject.Beneficial_Owner_Information__c = boEntity.Id;
                weFormObject.Status__c = 'complete';

                upsert weFormObject;

                if((weFormObject.BOCA_Type__c).equalsIgnoreCase('OTR')) {

                    PageReference redirect = Page.OTRSetup;
                    redirect.getParameters().put('pgm', program.Brand_Short_Name__c);
                    redirect.getParameters().put('customer', weFormObject.Id);
                    return redirect;

                }
                else {

                    PageReference wexBOCAConfirmation = Page.WexBOCAConfirmation;
                    WexBOCAConfirmation.getParameters().put('id', weFormObject.Id);
                    WexBOCAConfirmation.getParameters().put('pgm', weFormObject.Program__r.Brand_Short_Name__c );
                    WexBOCAConfirmation.getParameters().put('lang', languageCode);
                    WexBOCAConfirmation.setRedirect(true);
                    return WexBOCAConfirmation;

                }


            }
            else if(onlineApplication != null && applicationId != null) {

                onlineApplication.Beneficial_Owner_Information__c = boEntity.Id;
                onlineApplication.Status__c = 'App-Incomplete';
                upsert onlineApplication;

                PageReference redirect = Page.OTRSetup;
                redirect.getParameters().put('pgm', program.Brand_Short_Name__c);
                redirect.getParameters().put('customer', onlineApplication.Id);
                return redirect;

            }
            else if(onlineApplication != null) {

                onlineApplication.Beneficial_Owner_Information__c = boEntity.Id;
                upsert onlineApplication;

                PageReference eAppReviewPage = Page.ApplicationReview;
                eAppReviewPage.getParameters().put('id', onlineApplication.Id);
                eAppReviewPage.getParameters().put('ak', onlineApplication.Application_Key__c);
                eAppReviewPage.getParameters().put('noframe', 'true');
                eAppReviewPage.setRedirect(true);
                return eAppReviewPage;

            }
            else if(cpApplicationRequest != null) {

                cpApplicationRequest.Beneficial_Owner_Entity__c = boEntity.Id;
                cpApplicationRequest.Application_Stage__c = 'Adjudication';
                cpApplicationRequest.Status__c = 'Pending Decision';
                upsert cpApplicationRequest;

                PageReference cpConfirmation = Page.CPBOCAConfirmation;
                cpConfirmation.getParameters().put('id', cpApplicationRequest.Id);
                cpConfirmation.getParameters().put('pgm', programParameter);
                cpConfirmation.getParameters().put('lang', languageCode);
                cpConfirmation.setRedirect(true);
                return cpConfirmation;

            }
            else {

                PageReference beneficialOwner = Page.BOCertification;
                beneficialOwner.getParameters().put('confirmationId', confirmationNumber);
                beneficialOwner.getParameters().put('pgm', programParameter);
                beneficialOwner.getParameters().put('lang', languageCode);
                beneficialOwner.setRedirect(true);
                return beneficialOwner;

            }

        }
        catch(Exception e) {

            String errorCode = logError(e);

            PageReference wexBOCAError = Page.WexBOCAError;
            wexBOCAError.getParameters().put('errorCode', '2');
            wexBOCAError.getParameters().put('errorReferenceNumber', errorCode);
            wexBOCAError.setRedirect(true);
            return wexBOCAError;

        }

    }

    public void doNothing() { }

    private String logError(Exception e) {
        try {
            External_Application_Error__c error = new External_Application_Error__c();

            error.Error_Message__c = String.valueOf(e);
            error.Error_Location__c = String.valueOf(e.getStackTraceString());
            error.Application__c = 'BOCDD';
            error.Application_URL__c = applicationURL;

            insert error;

            List<External_Application_Error__c> errors = [SELECT Id, Name FROM External_Application_Error__c WHERE Id = :error.Id];

            if(!errors.isEmpty()) {
                return errors[0].Name;
            }
            else { return ''; }
        }
        catch(Exception f) { return ''; }
    }

    public class OwnerProng {

        public String ownerId { get; set; }
        public String firstName { get; set; }
        public String lastName { get; set; }
        public String countryOfResidence { get; set; }
        public String addressLine1 { get; set; }
        public String addressLine2 { get; set; }
        public String city { get; set; }
        public String state { get; set; }
        public String postalCode { get; set; }
        public String dateOfBirth { get; set; }
        public String socialSecurityNumber { get; set; }
        public String passportNumber { get; set; }
        public String countryOfIssue { get; set; }
        public Boolean isController { get; set; }

        public OwnerProng() {
            isController = false;
        }

    }

    public class ControlProng {

        public String controllerId { get; set; }
        public String firstName { get; set; }
        public String lastName { get; set; }
        public String title { get; set; }
        public String countryOfResidence { get; set; }
        public String addressLine1 { get; set; }
        public String addressLine2 { get; set; }
        public String city { get; set; }
        public String state { get; set; }
        public String postalCode { get; set; }
        public String dateOfBirth { get; set; }
        public String socialSecurityNumber { get; set; }
        public String passportNumber { get; set; }
        public String countryOfIssue { get; set; }

    }

}