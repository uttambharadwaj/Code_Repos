public class MCTriggeredEmailController { // extension for MarketingTriggeredEmail.page

    public MCConnector mcConnector;
    public String mcTriggeredEmailConfirmationId;
    public String toEmail { get; set; }
    public String ogEmailValue { get; set; }
    public Boolean emailSent { get; set; }
    public Boolean showForm { get; set; }
    private String recordTypeId { get; set; }
    private String subscriberKey;
    public String firstName { get; set; }
    public Integer currentPage { get; set; }
    public sObject pageObj {
        get;
        set {
            if (this.pageObj == null) {
                this.pageObj = value;
                init();
            } else
                this.pageObj = value;
        }
    }
    public sObject pageObj2 { get; set; }
    public String selectedMCTriggeredEmailKey { get; set; }
    public List<SelectOption> mcTriggeredEmailKeys { get; set; }
    private List<sObject> triggeredEmailKeyObj { get; set; }
    private MC_Triggered_Email__mdt triggeredEmailConfig;
    private sObject selectedEmailKeyObj;
    public Map<String, Object> subscriberAttributes;

    private Map<String, Schema.SObjectField> triggeredEmailKeyFields { get; set; }
    private Map<String, Schema.SObjectField> validPageObjFields { get; set; }

    private Map<String, SObjectType> globalDescribe { get; set; }

    private String objectName {
        get {
            return (String) UtilityClass.getObjName((Id) pageObj.get('Id'));
        }
    }
    public String triggeredEmailStatus { get; set; }
    public void updateTriggeredEmailStatus() {
        if (selectedMCTriggeredEmailKey != null && mcTriggeredEmailConfirmationId != null) {
            triggeredEmailStatus = mcConnector.getTriggeredEmailStatus(selectedMCTriggeredEmailKey, mcTriggeredEmailConfirmationId);
        }
    }
    private Map<String, sObject> emailKeyLabelToObject { get; set; }


    // ------------------------------------------------------------------------------------------------------------------------------


    // Constructor for component
    public MCTriggeredEmailController() {
        this.showForm = false;
    }

    // Constructor for page
    public MCTriggeredEmailController(ApexPages.StandardController stdController) {

        List<String> pageObjFields = new List<String>{
                'recordTypeId', 'Id'
        };

        if (!Test.isRunningTest()) stdController.addFields(pageObjFields);
        this.pageObj2 = stdController.getRecord();
    }

    public void init() {

        this.currentPage = 1;

        this.subscriberAttributes = new Map<String, Object>();
        this.emailSent = false;
        this.showForm = true;
        this.mcTriggeredEmailKeys = new List<SelectOption>();

        this.globalDescribe = Schema.getGlobalDescribe();
        this.triggeredEmailKeyFields = globalDescribe.get('MC_Triggered_Email_Key__mdt').getDescribe().fields.getMap();
        this.validPageObjFields = globalDescribe.get(objectName).getDescribe().fields.getMap();

        if (pageObj.get('RecordTypeId') != null) this.recordTypeId = (String) pageObj.get('RecordTypeId');

        try {
            triggeredEmailConfig = [SELECT Id, Default_Email__c, Subscriber_Key__c FROM MC_Triggered_Email__mdt WHERE RecordTypeId__c = :recordTypeId];
        } catch (Exception e) {
            System.debug(e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'This record type has not been configured to use this function.'));
            this.showForm = false;
            return;
        }


        String fields = String.join(new List<String>(triggeredEmailKeyFields.keySet()), ',');
        Id triggeredEmailId = triggeredEmailConfig.Id;
        emailKeyLabelToObject = new Map<String, sObject>();
        String query = 'SELECT ' + fields + ' FROM MC_Triggered_Email_Key__mdt WHERE RecordType__c = :triggeredEmailId order by MasterLabel';
        try {
            triggeredEmailKeyObj = Database.query(query);
            for (sObject obj : triggeredEmailKeyObj) {
                String objMasterLabel = (String) obj.get('MasterLabel');
                emailKeyLabelToObject.put(objMasterLabel, obj);
                this.mcTriggeredEmailKeys.add(new SelectOption(objMasterLabel, objMasterLabel)); // This is populating the picklist on the VFP

            }
        } catch (Exception e) {
            System.debug(e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'This record type does not have any triggered emails configured.'));
            this.showForm = false;
            return;
        }
        selectedMCTriggeredEmailKey = mcTriggeredEmailKeys.get(0).getLabel();

        mcConnector = new MCConnector();
        updateSubscriberKey();
    }

    // Called when user changes between email keys. Different keys have different fields etc.
    public void updateSubscriberKey() {

        List<String> commonFields = new List<String>();
        Set<String> pageObjFields = new Set<String>{
                'recordTypeId', 'Id'
        };
        if (triggeredEmailConfig.Default_Email__c != null) pageObjFields.add(triggeredEmailConfig.Default_Email__c);
        if (triggeredEmailConfig.Subscriber_Key__c != null) pageObjFields.add(triggeredEmailConfig.Subscriber_Key__c);

        selectedEmailKeyObj = emailKeyLabelToObject.get(selectedMCTriggeredEmailKey);
        // Add valid fields to list
        for (String field : triggeredEmailKeyFields.keySet()) {

            if (selectedEmailKeyObj.get(field) != null) {

                String fieldValue = (String) selectedEmailKeyObj.get(field);
                if (validPageObjFields.get(fieldValue) != null || fieldValue.contains('.')) {
                    pageObjFields.add(fieldValue);
                    commonFields.add(field);
                }
            }
        }
        Id objId = (Id) pageObj.get('Id');

        try {
            // We don't know what all fields we need until after we have the custom metadata records but we do need the record type before getting the custom metadata.
            this.pageObj = Database.query('SELECT ' + String.join(new List<String>(pageObjFields), ',') + ' FROM ' + objectName + ' WHERE Id = :objId');
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            this.showForm = false;
            return;

        }

        // Set default email - field is user editable
        if (triggeredEmailConfig.Default_Email__c != null) {
            this.toEmail = (String) UtilityClass.getSObjectField(pageObj, triggeredEmailConfig.Default_Email__c);
            this.ogEmailValue = toEmail; // toEmail is user editable
        }

        if (triggeredEmailConfig.Subscriber_Key__c != null) {
            this.subscriberKey = (String) UtilityClass.getSObjectField(pageObj, triggeredEmailConfig.Subscriber_Key__c);
        }

        // Add subscriberAttributes - This object will be serialized and sent to MC
        for (String field : commonFields) {
            // Field should match the name of the field in MC after removing __c
            this.subscriberAttributes.put(field.remove('__c'), UtilityClass.getSobjectField(pageObj, (String) selectedEmailKeyObj.get(field)));
        }
    }

    public void sendMCTriggeredEmail() {

        if (sendMCTriggeredEmailValidation()) {
            try {

                if (this.firstName != null) subscriberAttributes.put('firstname', this.firstName);
                MCData mcData = new MCData();
                mcData.subscriberAttributes = subscriberAttributes;
                mcData.toAddress = toEmail;
                mcData.subscriberKey = this.subscriberKey;

                mcConnector.mcData = mcData;
                System.debug(mcData);
                mcTriggeredEmailConfirmationId = mcConnector.sendTriggeredEmail(selectedMCTriggeredEmailKey); // throws exception and logs error
                emailSent = true;
                triggeredEmailStatus = 'Queued'; // maybe someday the REST api will accept the SYNC parameter. It currently ignores it and does the operation async.... until then we can periodically retrieve the status in mc.....

            } catch (Exception e) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            }
            this.showForm = false;
        }
    }

    private Boolean sendMCTriggeredEmailValidation() {

        Boolean validationSuccessful = true;

        List<String> requiredMCFields = new List<String>();
        if (selectedEmailKeyObj.get('required_fields__c') != null) {
            String requiredMCFieldsString = (String) selectedEmailKeyObj.get('required_fields__c');
            requiredMCFields = requiredMCFieldsString.toLowerCase().split(',');
        }

        // ------------------------------------- Page 1 -------------------------------------
        if (this.currentPage == 1) {
            Pattern regexEmailPattern = Pattern.compile('([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})'); // https://developer.salesforce.com/forums/?id=906F000000092GXIAY

            if (emailSent) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'The email has already been sent.'));
                validationSuccessful = false;
            }

            else if (String.isEmpty(toEmail)) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter a valid email address.'));
                validationSuccessful = false;
            }

            else if (!regexEmailPattern.matcher(toEmail).matches()) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'A invalid email address was entered.'));
                validationSuccessful = false;
            }

            else if (this.subscriberKey == null) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'A subscriber key was not specified.'));
                this.showForm = false;
                validationSuccessful = false;
            }

            // Any page changing validaiton needs to be at the end of currentpage validation
            else if (this.toEmail != this.ogEmailValue) {
                // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Additional information is required.'));
                this.currentPage = 2;
                validationSuccessful = false;
            }
            System.debug(subscriberAttributes.get('sfprogramid'));
        }

        // ------------------------------------- Page 2 -------------------------------------
        else if (this.currentPage == 2) {

            if (this.firstName == '') {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'A first name to be used in the email body must be entered.'));
                validationSuccessful = false;
            }

        }

        //  ---------------------------------------------------------------------------------

        // Validate that required fields from metadata have values
        for (String field : requiredMCFields) {

            if (subscriberAttributes.get(field) == null && !Test.isRunningTest()) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Missing required value: ' + field));
                this.showForm = false;
                validationSuccessful = false;
            }
        }
        // ======

        return validationSuccessful;
    }
}