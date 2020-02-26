public class MCTriggeredEmailController { // extension for MarketingTriggeredEmail.page

    public String toEmail { get; set; }
    private String ogEmailValue { get; set; }
    public Boolean emailSent { get; set; }
    public Boolean showForm { get; set; }
    private String recordTypeId { get; set; }
    private String subscriberKey;
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

    public Map<String, Object> subscriberAttributes;

    public void init() {


        sObject triggeredEmailKeyObj;
        MC_Triggered_Email__mdt triggeredEmailConfig;
        String objectName = (String) UtilityClass.getObjName((Id)pageObj.get('Id'));

        this.subscriberAttributes = new Map<String, Object>();
        this.emailSent = false;
        this.showForm = true;
        this.mcTriggeredEmailKeys = new List<SelectOption>();

        Map<String, SObjectType> globalDescribe = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> validPageObjFields = globalDescribe.get(objectName).getDescribe().fields.getMap();
        Map<String, Schema.SObjectField> triggeredEmailKeyFields = globalDescribe.get('MC_Triggered_Email_Key__mdt').getDescribe().fields.getMap();


        List<String> pageObjFields = new List<String>{
                'recordTypeId', 'Id'
        };
        List<String> commonFields = new List<String>();

        if (pageObj.get('RecordTypeId') != null) this.recordTypeId = (String) pageObj.get('RecordTypeId');

        try {
            triggeredEmailConfig = [SELECT Id, Default_Email__c, Subscriber_Key__c FROM MC_Triggered_Email__mdt WHERE RecordTypeId__c = :recordTypeId];
        } catch (Exception e) {
            System.debug(e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'This record type has not been configured to use this function.'));
            this.showForm = false;
            return;
        }

        if (triggeredEmailConfig.Default_Email__c != null) pageObjFields.add(triggeredEmailConfig.Default_Email__c);
        if (triggeredEmailConfig.Subscriber_Key__c != null) pageObjFields.add(triggeredEmailConfig.Subscriber_Key__c);


        String fields = String.join(new List<String>(triggeredEmailKeyFields.keySet()), ',');
        Id triggeredEmailId = triggeredEmailConfig.Id;
        String query = 'SELECT ' + fields + ' FROM MC_Triggered_Email_Key__mdt WHERE RecordType__c = :triggeredEmailId';
        try {
            triggeredEmailKeyObj = Database.query(query);
        } catch (Exception e) {
            System.debug(e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'This record type does not have any triggered emails configured.'));
            this.showForm = false;
            return;
        }

        // Add valid fields to list
        for (String field : triggeredEmailKeyFields.keySet()) {

            if (triggeredEmailKeyObj.get(field) != null) {

                String fieldValue = (String) triggeredEmailKeyObj.get(field);
                if (validPageObjFields.get(fieldValue) != null || fieldValue.contains('.')) {
                    pageObjFields.add(fieldValue);
                    commonFields.add(field);
                }
            }

        }
        Id objId = (Id) pageObj.get('Id');

        try {
            // We don't know what all fields we need until after we have the custom metadata records but we do need the record type before getting the custom metadata.
            this.pageObj = Database.query('SELECT ' + String.join(pageObjFields, ',') + ' FROM '+ objectName +' WHERE Id = :objId');
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
            this.subscriberAttributes.put(field.remove('__c'), UtilityClass.getSobjectField(pageObj, (String) triggeredEmailKeyObj.get(field)));
        }


        // Get all triggered email keys by record type. This is populating the picklist on the VFP
        for (MC_Triggered_Email_Key__mdt mcTriggeredEmailKey : [
                SELECT MasterLabel
                FROM MC_Triggered_Email_Key__mdt
                WHERE RecordType__c IN (SELECT Id FROM MC_Triggered_Email__mdt WHERE RecordTypeId__c = :recordTypeId)
        ]) {
            this.mcTriggeredEmailKeys.add(new SelectOption(mcTriggeredEmailKey.MasterLabel, mcTriggeredEmailKey.MasterLabel));
        }
    }

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


    public void sendMCTriggeredEmail() {

        if (sendMCTriggeredEmailValidation()) {
            try {

                MCData mcData = new MCData();
                mcData.subscriberAttributes = subscriberAttributes;
                mcData.toAddress = toEmail;
                mcData.subscriberKey = this.subscriberKey;

                MCConnector mcConnector = new MCConnector();
                mcConnector.mcData = mcData;

                if (mcConnector.sendTriggeredEmail(selectedMCTriggeredEmailKey)) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Sent. You may now close this window.'));
                    this.emailSent = true;
                } else {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Failed to send email. MC declined the sent data.')); // probably not a valid triggered email, or missing required fields
                }

            } catch (Exception e) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            }
            this.showForm = false;
        }
    }

    private Boolean sendMCTriggeredEmailValidation() {

        Boolean validationSuccessful = false;
        Pattern regexEmailPattern = Pattern.compile('([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})'); // https://developer.salesforce.com/forums/?id=906F000000092GXIAY

        if (emailSent) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'The email has already been sent.'));
        }

        else if (String.isEmpty(toEmail)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter a valid email address.'));
        }

        else if (!regexEmailPattern.matcher(toEmail).matches()) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'A invalid email address was entered.'));

        }

        else if (this.subscriberKey == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'A subscriber key was not specified.'));
            this.showForm = false;
        }

        else validationSuccessful = true;

        return validationSuccessful;
    }
}