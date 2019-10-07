public virtual class FleetEnrollmentController {

    // Defining the main form object
    public FleetEnrollment__c fleetEnrollment { get; set; }

    public final static String APPLICATION_NAME = 'FleetEnrollment';

    public String confirmationNumber { get; set; }
    public String printToken { get; set; }
    public Map<String, String> cardControlOptionDisplayMap { get; set; }
    public String languageCode {
        get {
            return ApexPages.CurrentPage().getParameters().get('lang');
        }
    }

    // URL Parameters to fetch
    public String opportunityParameter {
        get {
            return ApexPages.currentPage().getParameters().get('opty');
        }
    }

    public Boolean checkOpportunityParameter {
        get {
            try {
                Schema.SObjectType objectType = (Id.valueOf(opportunityParameter)).getSobjectType();

                if((String.valueOf(objectType)).equalsIgnoreCase('Opportunity')) {
                    return true;
                }

            }
            catch(Exception e) {
                System.debug('### Not a valid ID..');
            }

            return false;
        }
    }

    public Boolean showPreview {get;set;}

    public String currentPage {
        get {
            return ApexPages.currentPage().getParameters().get('currentPage');
        }
    }

    public String programParameter {
        get {
            return ApexPages.currentPage().getParameters().get('program');
        }
    }

    public String applicationRequestParameter {
        get {
            return ApexPages.currentPage().getParameters().get('appId');
        }
    }

    public Integer creditLineAmount {
        get {
            String creditLineAmountParameter = ApexPages.currentPage().getParameters().get('crd');
            if(creditLineAmountParameter != null && creditLineAmountParameter.isNumeric()) {
                return Integer.valueOf(creditLineAmountParameter);
            }
            return null;
        }
    }

    public String emailVersionTracking {
        get {
            return ApexPages.currentPage().getParameters().get('ver');
        }
    }

    // Branding - Elements from the specified program
    public Program__c program { get; set; }

    public BOCA_Res__c brandingUtility { get; set; }

    public Program_Template_Account__c programTemplateAccount { get; set; }

    public String configuredDIDLength {
        get {
            if(program != null && program.DID_Length__c != null) {
                return program.DID_Length__c;
            }
            return '4';
        }
    }

    public String selectedDIDLength {
        get {
            if(selectedDIDLength == null && configuredDIDLength != '4 OR 6') {
                return configuredDIDLength;
            }
            else if(selectedDIDLength == null && configuredDIDLength == '4 OR 6') {
                return '4';
            }
            return selectedDIDLength;
        }
        set;
    }

    // Branding - Card image from the chosen program
    public Id brandingCard { get; set; }

    public Id brandingCard1to1 { get; set; }

    // Dynamic Card Image
    public Id dynamicCard { get; set; }

    public Boolean cardShippingSameAsBillingAddress { get; set; }

    public List<SelectOption> availableStateSelectOptions {
        get {
            List<SelectOption> picklistValues = new List<SelectOption>();
            picklistValues.add(new SelectOption('#', Label.Billing_State));

            if (languageCode != null && languageCode.contains('_ca')) { // Canada

                for (String province : UtilityClass.getProvinces('canada')) {
                    picklistValues.add(new SelectOption(province, province));
                }

            } else { // United States

                for (String picklistValue : UtilityClass.getPicklistMap('WeFormObject__c', 'Billing_State__c').keySet()) {
                    picklistValues.add(new SelectOption(picklistValue, picklistValue));
                }
            }
            return picklistValues;
        }
    }

    // Local picklists
    public List<SelectOption> embossingOptions {
        get {
            List<SelectOption> embossingOptions = new List<SelectOption>();
            embossingOptions.add(new SelectOption('#', Label.Optional_printing, true));
            embossingOptions.add(new SelectOption('None', Label.No_Printing));
            embossingOptions.add(new SelectOption('License Plate', Label.License_Plate));
            embossingOptions.add(new SelectOption('Vehicle Description', Label.Vehicle_Description));
            embossingOptions.add(new SelectOption('Company Vehicle ID', Label.Company_Vehicle_ID));

            return embossingOptions;
        }
    }

    public String selectedEmbossingOption { get; set; }

    public List<SelectOption> acceptanceOptions {
        get {
            List<SelectOption> acceptanceOptions = new List<SelectOption>();
            acceptanceOptions.add(new SelectOption('#', Label.Fleet_Acceptance, true));
            acceptanceOptions.add(new SelectOption('Private Label', Label.Fleet_Private_Label));
            acceptanceOptions.add(new SelectOption('Universal', Label.Fleet_Universal));

            return acceptanceOptions;
        }
    }

    public List<SelectOption> cardControlOptions {
        get {
            List<SelectOption> cardControlOptions = new List<SelectOption>();
            cardControlOptions.add(new SelectOption('#', Label.Card_Controls, true));

            if(program != null && program.Available_Card_Controls__c !=  null) {

                // Allows salesforce to handle picklist translations
                cardControlOptionDisplayMap = UtilityClass.getPicklistMap('Program__c', 'Available_Card_Controls__c');

                String[] availableOptions = program.Available_Card_Controls__c.split(';');

                for (String option : availableOptions) {
                    cardControlOptions.add(new SelectOption(option, cardControlOptionDisplayMap.get(option)));

                }

            }
            else {

                cardControlOptions.add(new SelectOption('Custom Controls', Label.Custom_Controls));

                if (program != null && program.Fleet_Enrollment_Enable_Fuel_Oil__c) {
                    cardControlOptions.add(new SelectOption('Fuel and Oil', Label.Fuel_and_Oil));
                }

                cardControlOptions.add(new SelectOption('Fuel Only', Label.Fuel_Only));

            }

            return cardControlOptions;
        }
    }

    public List<SelectOption> promptOptions {
        get {
            List<SelectOption> promptOptions = new List<SelectOption>();
            promptOptions.add(new SelectOption('#', Label.Fleet_Prompt_Options, true));
            promptOptions.add(new SelectOption('Driver ID & Odometer', Label.Fleet_Driver_ID_Odometer));
            promptOptions.add(new SelectOption('Driver ID Only', Label.Fleet_Driver_ID_Only));

            return promptOptions;
        }
    }

    public List<SelectOption> promptOptions1to1 {
        get {
            List<SelectOption> promptOptions = new List<SelectOption>();
            promptOptions.add(new SelectOption('#', Label.Fleet_Prompt_Options, true));
            promptOptions.add(new SelectOption('Vehicle ID & Odometer', Label.Fleet_Driver_ID_Odometer));
            promptOptions.add(new SelectOption('Vehicle ID Only', Label.Fleet_Driver_ID_Only));

            return promptOptions;
        }
    }

    public List<SelectOption> driverIdOptions {
        get {
            List<SelectOption> driverIdOptions = new List<SelectOption>();
            driverIdOptions.add(new SelectOption('custom', Label.Fleet_Custom_Driver_IDs));
            driverIdOptions.add(new SelectOption('random', Label.Fleet_Randomly_Generated_IDs));
            return driverIdOptions;
        }
    }

    // Local FleetContact object
    public class FleetContact {
        public Integer Id { get; set; }
        public String FirstName { get; set; }
        public String LastName { get; set; }
        public String Email { get; set; }
        public String Phone { get; set; }
        public Boolean isNotRemovable { get; set; }
    }

    // List of FleetContact objects
    public List<FleetContact> fleetContacts { get; set; }

    public Integer sizeOfFleetContacts {
        get {
            return fleetContacts.size();
        }
    }

    // Various variables used for maintaining
    // the FleetContact collection
    public Integer selectedFleetContact { get; set; }
    public Integer nextFleetContactId { get; set; }

    // Local FleetVehicle object
    public class FleetVehicle {
        public Integer Id { get; set; }
        public String companyVehicleId { get; set; }
        public String selectedCardControlOption;
        public String selectedPromptOption { get; set; }
        public String selectedAcceptanceOption { get; set; }
        public String vehicleDepartment { get; set; }
        public String vehicleDescription { get; set; }
        public String licensePlate { get; set; }
        public Boolean isNotRemovable { get; set; }


        public String getSelectedCardControlOption() {
            return selectedCardControlOption;
        }

        public void setSelectedCardControlOption(String selectedCardControlOption) {
            this.selectedCardControlOption = selectedCardControlOption;
        }

        public FleetVehicle() {
            selectedCardControlOption = '#';
            selectedPromptOption = '#';
            selectedAcceptanceOption = '#';
        }

    }

    // Various variables used for maintaining
    // the FleetVehicle collection
    public List<FleetVehicle> fleetVehicles { get; set; }
    public Integer selectedFleetVehicle { get; set; }
    public Integer nextFleetVehicleId { get; set; }

    // Local FleetDriver object
    public class FleetDriver {
        public Integer Id { get; set; }
        public String firstName { get; set; }
        public String lastName { get; set; }
        public String driverId { get; set; }
        public Boolean isNotRemovable { get; set; }
        public String selectedCardControlOption;
        public String selectedPromptOption { get; set; }
        public String selectedAcceptanceOption { get; set; }

        public String getSelectedCardControlOption() {
            return selectedCardControlOption;
        }

        public void setSelectedCardControlOption(String selectedCardControlOption) {
            this.selectedCardControlOption = selectedCardControlOption;
        }

        public FleetDriver() {
            selectedCardControlOption = '#';
            selectedPromptOption = '#';
            selectedAcceptanceOption = '#';
        }
    }

    // Various variables used for maintaining
    // the FleetDriver collection
    public String selectedDriverIdOption { get; set; }
    public List<FleetDriver> fleetDrivers { get; set; }
    public Integer selectedFleetDriver { get; set; }
    public Integer nextFleetDriverId { get; set; }

    // Pagination variables for tracking the steps
    public Integer currentStep { get; set; }
    public Integer minStep  { get; set; }
    public Integer maxStep  { get; set; }

    // Determines if the "Previous/Back" button is rendered
    public boolean previousStep {
        get {
            if(currentStep > minStep) {
                return false;
            } else {
                return true;
            }
        }
    }

    // Determines if the "Next" button is rendered
    public boolean nextStep {
        get {
            if(currentStep < maxStep) {
                return false;
            } else {
                return true;
            }
        }
    }

    public class fleetEnrollmentException extends Exception {}

    // Controller constructor
    public FleetEnrollmentController() {

        // Setup for the pagination
        minStep = 1;
        maxStep = 5;
        currentStep = 1;
        showPreview = false;

        cardShippingSameAsBillingAddress = true;

        if(currentPage != null) {
            currentStep = Integer.valueOf(currentPage);
        }

        // Initialize the FleetEnrollment__c record
        fleetEnrollment = new FleetEnrollment__c();

        // Default to custom Drive ID's
        selectedDriverIdOption = 'custom';

        // Set the default embossing option
        fleetEnrollment.Embossing_Second_Line__c = '#';

        // Initialize the local FleetContacts collection
        fleetContacts = new List<FleetContact>();
        nextFleetContactId = 0;

        for(Integer i = 0; i < 1; i++) {
            addNewContact();
        }

        // Initialize the local FleetVehicles collection
        fleetVehicles = new List<FleetVehicle>();
        nextFleetVehicleId = 0;

        // Initialize the local FleetDrivers collection
        fleetDrivers = new List<FleetDriver>();
        nextFleetDriverId = 0;

        for(Integer i = 0; i < 2; i++) {
            addNewFleetDriver();
        }

    }

    // Initialization of the form
    public PageReference init() {

        PageReference redirect = null;

        try {

            //if this comes through BOCA there is an app request parameter
            if (!String.isEmpty(applicationRequestParameter)) {

                List<FleetEnrollment__c> fleetEnrollments = [
                        SELECT Id, Has_Fleet_Enrollment_Data__c
                        FROM FleetEnrollment__c
                        WHERE Application_Request__c = :applicationRequestParameter];

                if (fleetEnrollments.size() > 0) {

                    List<FleetEnrollment__c> feWithFleetData = new List<FleetEnrollment__c>();
                    List<FleetEnrollment__c> feWithoutFleetData = new List<FleetEnrollment__c>();

                    for (FleetEnrollment__c fe : fleetEnrollments) {
                        if (fe.Has_Fleet_Enrollment_Data__c == true) {
                            feWithFleetData.add(fe);
                        } else {
                            feWithoutFleetData.add(fe);
                        }
                    }

                    if (feWithFleetData.size() > 0) {
                        throw new fleetEnrollmentException('Your information has already been submitted.');
                    }

                    // find existing FleetEnrollment record from when opportunity was created
                    // but without pre-filling any of the existing information!

                    if (feWithoutFleetData.size() > 0) {

                        fleetEnrollment.Id = feWithoutFleetData[0].Id;

                    }
                }
            }

            //if this comes from an external marketing database it may have a siebel ID in the oppty parameter, and no app req parameter
            if (String.isEmpty(applicationRequestParameter) && !String.isEmpty(opportunityParameter)) {


                List<FleetEnrollment__c> fleetEnrollments = [
                        SELECT Id, Has_Fleet_Enrollment_Data__c
                        FROM FleetEnrollment__c
                        WHERE Opportunity_Number__c = :opportunityParameter];

                if (fleetEnrollments.size() > 0) {

                    List<FleetEnrollment__c> feWithFleetData = new List<FleetEnrollment__c>();
                    List<FleetEnrollment__c> feWithoutFleetData = new List<FleetEnrollment__c>();

                    for (FleetEnrollment__c fe : fleetEnrollments) {
                        if (fe.Has_Fleet_Enrollment_Data__c == true) {
                            feWithFleetData.add(fe);
                        } else {
                            feWithoutFleetData.add(fe);
                        }
                    }

                    if (feWithFleetData.size() > 0) {
                        throw new fleetEnrollmentException('Your information has already been submitted.');
                    }

                    // find existing FleetEnrollment record from when opportunity was created
                    // but without pre-filling any of the existing information!

                    if (feWithoutFleetData.size() > 0) {

                        fleetEnrollment.Id = feWithoutFleetData[0].Id;

                    }
                }
            }

            Id programId = WexBrandingController.getProgramIdByBrandShortName(programParameter);

            System.debug('### ' + programId);

            if(programId != null) {

                program = WexBrandingController.getProgram(programId);
                brandingUtility = WexBrandingController.getBrandingUtilRecordByProgramId(programId, languageCode);
                System.debug('### ' + program);

                if(program != null && (program.Publish_Fleet_Data_Capture_Form__c != false || program.Publish_Fleet_Data_Capture_Form_1_1__c != false)) {

                    brandingCard = WexBrandingController.getCreditCardImageId(program.Id);

                    dynamicCard = WexBrandingController.getCreditCardNotTextImageId(program.Id);

                    brandingCard1to1 = WexBrandingController.getCreditCardOneToOne(program.Id);

                    programTemplateAccount = WexBrandingController.getProgramTemplateAccount(WexBrandingController.getDefaultAccountTemplateByProgram(program.Id));

                }
                else {
                    throw new fleetEnrollmentException('Program not configured for Fleet Enrollment (Program: ' + programParameter + ')');
                }

            }
            else {
                throw new fleetEnrollmentException('Cannot find Program: ' + programParameter);
            }

        }
        catch(Exception e) {
            String errorCode = WEXDEVErrorReporting.reportExternalError(APPLICATION_NAME, ApexPages.currentPage(), e, true);

            redirect = Page.ExternalApplicationError;
            redirect.getParameters().put('errorCode', errorCode);
            redirect.getParameters().put('pgm', programParameter);
            redirect.getParameters().put('lang', languageCode);
            return redirect;

        }

        return null;

    }

    public void setCardShippingSame() {

        if(cardShippingSameAsBillingAddress) {
            fleetEnrollment.Card_Shipping_Address_Line_1__c = fleetEnrollment.Billing_Address_Line_1__c;
            fleetEnrollment.Card_Shipping_Address_Line_2__c = fleetEnrollment.Billing_Address_Line_2__c;
            fleetEnrollment.Card_Shipping_City__c = fleetEnrollment.Billing_City__c;
            fleetEnrollment.Card_Shipping_State__c = fleetEnrollment.Billing_State__c;
            fleetEnrollment.Card_Shipping_Postal_Code__c = fleetEnrollment.Billing_Postal_Code__c;
        }
        else {
            fleetEnrollment.Card_Shipping_Address_Line_1__c = '';
            fleetEnrollment.Card_Shipping_Address_Line_2__c = '';
            fleetEnrollment.Card_Shipping_City__c = '';
            fleetEnrollment.Card_Shipping_State__c = '';
            fleetEnrollment.Card_Shipping_Postal_Code__c = '';
        }

    }


    // Add a new contact to FleetContacts collection
    public void addNewContact() {
        FleetContact fleetContact = new FleetContact();
        fleetContact.Id = nextFleetContactId;
        fleetContacts.add(fleetContact);
        nextFleetContactId++;
    }

    // Remove a contact from the FleetContacts collection
    public void removeContact() {
        for(Integer i = 0; i < fleetContacts.size(); i++) {
            if(fleetContacts.get(i).Id == selectedFleetContact) {
                fleetContacts.remove(i);
            }
        }
    }

    // Initialize the FleetVehicles collection to
    // be the size of the fleet noted on page 2
    public void setupFleetVehicles() {
        Integer numberOfVehiclesToAdd = Integer.valueOf(fleetEnrollment.Number_Of_Vehicles__c);

        for(Integer i = fleetVehicles.size(); i < numberOfVehiclesToAdd; i++) {
            addNewFleetVehicle();
        }
    }

    // Add a new vehicle to FleetVehicles collection
    public void addNewFleetVehicle() {
        FleetVehicle fleetVehicle = new FleetVehicle();

        fleetVehicle.Id = nextFleetVehicleId;
        if(fleetVehicles.size() > 0) {
            fleetVehicle.selectedCardControlOption = fleetVehicles.get(0).selectedCardControlOption;
        }

        fleetVehicles.add(fleetVehicle);

        nextFleetVehicleId++;

        if(fleetVehicles.size() == 1) {
            fleetVehicles.get(0).isNotRemovable = true;
        }
        else {
            fleetVehicles.get(0).isNotRemovable = false;
        }

        fleetEnrollment.Number_Of_Vehicles__c = fleetVehicles.size();
    }

    // Remove a vehicle from the FleetVehicles collection
    public void removeFleetVehicle() {
        for(Integer i = 0; i < fleetVehicles.size(); i++) {
            if(fleetVehicles.get(i).Id == selectedFleetVehicle) {
                fleetVehicles.remove(i);
            }
        }

        if(fleetVehicles.size() == 1) {
            fleetVehicles.get(0).isNotRemovable = true;
        }

        fleetEnrollment.Number_Of_Vehicles__c = fleetVehicles.size();
    }

    // If the first vehicle changes its card control option, change it for the rest
    public void changeSelectedCardControlOption() {
        for(Integer i = 1; i < fleetVehicles.size(); i++) {
            if(fleetVehicles.get(i).selectedCardControlOption == '#') {
                fleetVehicles.get(i).selectedCardControlOption = fleetVehicles.get(0).selectedCardControlOption;
            }
        }
    }

    // Add a new Driver to FleetDrivers collection
    public void addNewFleetDriver() {
        FleetDriver fleetDriver = new FleetDriver();
        fleetDriver.Id = nextFleetDriverId;
        fleetDrivers.add(fleetDriver);
        nextFleetDriverId++;

        if(fleetDrivers.size() > 1) {
            fleetDrivers.get(0).isNotRemovable = false;
        }
    }

    // Remove a Driver from the FleetDrivers collection
    public void removeFleetDriver() {
        for(Integer i = 0; i < fleetDrivers.size(); i++) {
            if(fleetDrivers.get(i).Id == selectedFleetDriver) {
                fleetDrivers.remove(i);
            }
        }

        if(fleetDrivers.size() == 1) {
            fleetDrivers.get(0).isNotRemovable = true;
        }
    }

    // Set the driver ID option for each driver in
    // the collection when it is changed
    public void changeDriverIdOption() {
        for(Integer i = 0; i < fleetDrivers.size(); i++) {
            if(selectedDriverIdOption == 'random') {
                fleetDrivers.get(i).driverId = 'Random';
            } else {
                fleetDrivers.get(i).driverId = null;
            }
        }
    }

    public PageReference setDIDLength() {

        System.debug('### DID Length: ' + selectedDIDLength);

        return null;

    }

    // Step functions
    public void previousStep() {
        currentStep = currentStep - 1;
    }

    public virtual void nextStep() {

        if(currentStep == 1) {
            setCardShippingSame();
        }

        if(currentStep == 3 && program.Fleet_Enrollment_Disable_Driver_Page__c == true) {
            currentStep = currentStep + 2;
        }
        else {
            currentStep = currentStep + 1;
        }

        if(currentStep == 3) {
            setupFleetVehicles();
        }

    }

    // Exactly.
    public void doNothing() {

    }

    public PageReference submitApplication() {

        PageReference applicationRedirect = null;

        try {

            fleetEnrollment.Status__c = 'New';

            if (programTemplateAccount != null) {
                fleetEnrollment.Program_Template_Account__c = programTemplateAccount.Id;
                fleetEnrollment.Billing_Cycle__c = programTemplateAccount.Billing_Cycle__c;
            }

            // Set some fields for the FleetEnrollment record
            if(program != null) {
                fleetEnrollment.Program__c = program.Id;
            }

            if(creditLineAmount != null) {
                fleetEnrollment.Credit_Approved__c = true;
                fleetEnrollment.Credit_Line_Amount__c = creditLineAmount;
            }

            if(!String.isEmpty(emailVersionTracking)) {
                fleetEnrollment.Email_Version__c = emailVersionTracking;
            }

            String key = EncodingUtil.convertToHex(crypto.generateAesKey(128));
            fleetEnrollment.Print_Token__c = key.substring(0, 25);

            if(!String.isEmpty(opportunityParameter)) {
                if(checkOpportunityParameter == false) {
                    fleetEnrollment.Opportunity_Number__c = opportunityParameter;
                } else {
                    fleetEnrollment.Debug_Opportunity_Parameter__c = opportunityParameter;
                    fleetEnrollment.Opportunity__c = opportunityParameter;
                }
            }

            if(selectedDriverIdOption.equalsIgnoreCase('random')) {
                fleetEnrollment.Driver_ID_Random__c = true;
            }

            if(!String.isEmpty(applicationRequestParameter)) {
                fleetEnrollment.Application_Request__c = applicationRequestParameter;
                fleetEnrollment.Debug_Application_Parameter__c = applicationRequestParameter;
            }

            upsert fleetEnrollment;

            // Insert contacts
            List<FleetEnrollment_Contact__c> newFleetContacts = new List<FleetEnrollment_Contact__c>();

            // The first contact is always the billing contact
            FleetEnrollment_Contact__c primaryFleetContact = new FleetEnrollment_Contact__c();

            primaryFleetContact.Fleet_Enrollment__c = fleetEnrollment.Id;
            primaryFleetContact.First_Name__c = fleetEnrollment.Billing_Contact_First_Name__c;
            primaryFleetContact.Last_Name__c = fleetEnrollment.Billing_Contact_Last_Name__c;
            primaryFleetContact.Email__c = fleetEnrollment.Billing_Email__c;
            primaryFleetContact.Phone__c = fleetEnrollment.Billing_Phone__c;

            newFleetContacts.add(primaryFleetContact);

            // Add additional contacts
            if(fleetContacts.size() > 0) {

                for(Integer i = 0; i < fleetContacts.size(); i++) {

                    // Only insert contacts that have all the information
                    if(!String.isEmpty(fleetContacts.get(i).FirstName) && !String.isEmpty(fleetContacts.get(i).LastName) && !String.isEmpty(fleetContacts.get(i).Email) && !String.isEmpty(fleetContacts.get(i).Phone)) {

                        FleetEnrollment_Contact__c newFleetContact = new FleetEnrollment_Contact__c();

                        newFleetContact.Fleet_Enrollment__c = fleetEnrollment.Id;
                        newFleetContact.First_Name__c = fleetContacts.get(i).FirstName;
                        newFleetContact.Last_Name__c = fleetContacts.get(i).LastName;
                        newFleetContact.Email__c = fleetContacts.get(i).Email;
                        newFleetContact.Phone__c = fleetContacts.get(i).Phone;

                        newFleetContacts.add(newFleetContact);

                    }

                }
            }
            insert newFleetContacts;

            // Insert vehicles
            if(fleetVehicles.size() > 0) {
                List<FleetEnrollment_Vehicle__c> newFleetVehicles = new List<FleetEnrollment_Vehicle__c>();
                for(Integer i = 0; i < fleetVehicles.size(); i++) {

                    FleetEnrollment_Vehicle__c newFleetVehicle = new FleetEnrollment_Vehicle__c();

                    newFleetVehicle.Fleet_Enrollment__c = fleetEnrollment.Id;
                    newFleetVehicle.Customer_Vehicle_ID__c = fleetVehicles.get(i).companyVehicleId;
                    newFleetVehicle.Card_Control_Type__c = fleetVehicles.get(i).selectedCardControlOption;
                    newFleetVehicle.Department__c = fleetVehicles.get(i).vehicleDepartment;
                    newFleetVehicle.Vehicle_Description__c = fleetVehicles.get(i).vehicleDescription;
                    newFleetVehicle.License_Plate__c = fleetVehicles.get(i).licensePlate;

                    if(program.Fleet_Enrollment_Enable_Prompt_Options__c == true && fleetVehicles.get(i).selectedPromptOption != '#') {
                        newFleetVehicle.Prompt_Options__c = fleetVehicles.get(i).selectedPromptOption;
                    }

                    if(program.Fleet_Enrollment_Enable_Universal_PL__c == true && fleetVehicles.get(i).selectedAcceptanceOption != '#') {
                        newFleetVehicle.Acceptance__c = fleetVehicles.get(i).selectedAcceptanceOption;
                    }
                    newFleetVehicles.add(newFleetVehicle);

                }
                insert newFleetVehicles;
            }

            if(program.Fleet_Enrollment_Disable_Driver_Page__c == false) {

                // Insert drivers
                if(fleetDrivers.size() > 0) {
                    List<FleetEnrollment_Driver__c> newFleetDrivers = new List<FleetEnrollment_Driver__c>();
                    for(Integer i = 0; i < fleetDrivers.size(); i++) {

                        if(!String.isEmpty(fleetDrivers.get(i).firstName) && !String.isEmpty(fleetDrivers.get(i).lastName)) {

                            FleetEnrollment_Driver__c newFleetDriver = new FleetEnrollment_Driver__c();

                            newFleetDriver.Fleet_Enrollment__c = fleetEnrollment.Id;
                            newFleetDriver.First_Name__c = fleetDrivers.get(i).firstName;
                            newFleetDriver.Last_Name__c = fleetDrivers.get(i).lastName;
                            newFleetDriver.Driver_ID__c = fleetDrivers.get(i).driverId;

                            newFleetDriver.Card_Control_Type__c = fleetDrivers.get(i).selectedCardControlOption;

                            if(program.Fleet_Enrollment_Enable_Prompt_Options__c == true && fleetDrivers.get(i).selectedPromptOption != '#') {
                                newFleetDriver.Prompt_Options__c = fleetDrivers.get(i).selectedPromptOption;
                            }

                            if(program.Fleet_Enrollment_Enable_Universal_PL__c == true && fleetDrivers.get(i).selectedAcceptanceOption != '#') {
                                newFleetDriver.Acceptance__c = fleetDrivers.get(i).selectedAcceptanceOption;
                            }

                            if(fleetEnrollment.Driver_ID_Random__c == true) {
                                newFleetDriver.Driver_ID__c = 'Random';
                            }
                            newFleetDrivers.add(newFleetDriver);
                        }

                    }
                    insert newFleetDrivers;

                }

            }

            // Get the confirmation number
            FleetEnrollment__c fleetEnrollmentConfirmed = [SELECT Id, Confirmation_Number__c, Print_Token__c FROM FleetEnrollment__c WHERE Id = :fleetEnrollment.Id];

            confirmationNumber = fleetEnrollmentConfirmed.Confirmation_Number__c;
            printToken = fleetEnrollmentConfirmed.Print_Token__c;


            sendEmail();

            applicationRedirect = Page.FleetEnrollmentConfirmation;
            applicationRedirect.getParameters().put('applicant', fleetEnrollmentConfirmed.Id);
            applicationRedirect.getParameters().put('token', fleetEnrollmentConfirmed.Print_Token__c);
            applicationRedirect.getParameters().put('lang', languageCode);
            applicationRedirect.setRedirect(true);
            return applicationRedirect;

        }
        catch (Exception e) {
            String errorNumber = WEXDEVErrorReporting.reportExternalError(APPLICATION_NAME, ApexPages.currentPage().getUrl(), e);

            PageReference errorPage = Page.ExternalApplicationError;
            errorPage.getParameters().put('errorCode', errorNumber);
            errorPage.getParameters().put('pgm', programParameter);
            errorPage.getParameters().put('lang', languageCode);
            return errorPage;
        }

    }

    public void sendEmail(){

        Contact temporaryContact = new Contact();

        temporaryContact.FirstName = fleetEnrollment.Billing_Contact_First_Name__c;
        temporaryContact.LastName = fleetEnrollment.Billing_Contact_Last_Name__c;
        temporaryContact.Email = fleetEnrollment.Billing_Email__c;
        temporaryContact.RecordTypeId = UtilityClass.getRecTypeByDevName('Contact','F1_Contact');

        insert temporaryContact;

        Messaging.reserveSingleEmailCapacity(1);
        Messaging.SingleEmailMessage confirmation = new Messaging.SingleEmailMessage();

        confirmation.setTemplateId(program.Fleet_Data_Capture_Email_Template__c);
        confirmation.setWhatId(fleetEnrollment.Id);
        confirmation.setTargetObjectId(temporaryContact.id);
        confirmation.setSaveAsActivity(false);
        confirmation.setReplyTo('noreply@wexinc.com');

        for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress])
        {
            if(owa.Address.contains('noreply@wexinc.com')) {
                confirmation.setOrgWideEmailAddressId(owa.id);
            }
        }

        UtilityClass.sendEmail(confirmation);

        delete temporaryContact;

    }

    public void myShowPreviewMethod(){
        showPreview=true;
    }

}