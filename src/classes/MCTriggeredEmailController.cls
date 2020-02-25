public class MCTriggeredEmailController { // extension for MarketingTriggeredEmail.page

    public String toEmail { get; set; }
    private String ogEmailValue { get; set; }
    public Boolean emailSent { get; set; }
    public Boolean showForm { get; set; }
    private String recordTypeId { get; set; }
    public Case currentCase;


    public String selectedMCTriggeredEmailKey { get; set; }
    public List<SelectOption> mcTriggeredEmailKeys { get; set; }

    public Map<String, Object> subscriberAttributes;

    public MCTriggeredEmailController(ApexPages.StandardController stdController) {

        sObject sobj;
        this.subscriberAttributes = new Map<String, Object>();
        this.emailSent = false;
        this.showForm = true;
        this.mcTriggeredEmailKeys = new List<SelectOption>();

        Map<String, SObjectType> globalDescribe = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> validCaseFields = globalDescribe.get('Case').getDescribe().fields.getMap();
        Map<String, Schema.SObjectField> mfields = globalDescribe.get('MC_Triggered_Email_Key__mdt').getDescribe().fields.getMap();


        List<String> caseFields = new List<String>{
                'recordTypeId', 'Id', 'ContactId'
        };

        List<String> commonFields = new List<String>();
        if (!Test.isRunningTest()) stdController.addFields(caseFields);

        this.currentCase = (Case) stdController.getRecord();
        if (currentCase.recordTypeId != null) this.recordTypeId = currentCase.recordTypeId;

        String fields = String.join(new List<String>(mfields.keySet()), ',');
        String query = 'SELECT ' + fields + ' FROM MC_Triggered_Email_Key__mdt WHERE RecordType__c IN (SELECT Id FROM MC_Triggered_Email__mdt WHERE RecordTypeId__c = :recordTypeId)';
        System.debug(query);
        try {
            sobj = Database.query(query);
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'This record type has not been configured to use this function.'));
            this.showForm = false;
            return;
        }

        // Add valid case fields to list
        for (String field : mfields.keySet()) {

            if (sobj.get(field) != null) {

                String fieldValue = (String) sobj.get(field);
                if (validCaseFields.get(fieldValue) != null || fieldValue.contains('.')) {
                    caseFields.add(fieldValue);
                    commonFields.add(field);
                }
            }

        }

        caseFields.add('Contact.Email');
        Id caseId = (Id) currentCase.get('Id');

        try {
            // We don't know what all fields we need until after we have the custom metadata records but we do need the record type before getting the custom metadata.
            this.currentCase = (Case) Database.query('SELECT ' + String.join(caseFields, ',') + ' FROM Case WHERE Id = :caseId');
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            this.showForm = false;
            return;

        }

        // Set default email - field is user editable
        if (currentCase.Contact != null && currentCase.Contact.Email != null) {
            this.toEmail = currentCase.Contact.Email;
            this.ogEmailValue = toEmail; // toEmail is user editable
        }

        // Add subscriberAttributes - This object will be serialized and sent to MC
        for (String field : commonFields) {
            // Field should match the name of the field in MC after removing __c
            this.subscriberAttributes.put(field.remove('__c'), UtilityClass.getSobjectField(currentCase, (String) sobj.get(field)));
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


    public void sendMCTriggeredEmail() {

        if (sendMCTriggeredEmailValidation()) {
            try {

                MCData mcData = new MCData();
                mcData.subscriberAttributes = subscriberAttributes;
                mcData.toAddress = toEmail;
                mcData.subscriberKey = currentCase.ContactId != null ? currentCase.ContactId : toEmail;

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

        else if (currentCase.ContactId == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'A contact must be associated to the case to perform this function.'));
            this.showForm = false;
        }

        else validationSuccessful = true;

        return validationSuccessful;
    }
}