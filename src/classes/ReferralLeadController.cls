public with sharing class ReferralLeadController {
    public Id oppId { get; set; }
    public Opportunity opty { get; set; }
    public List<SelectOption> productsList { get; set; }
    public String selProduct { get; set; }
    public Lead refLead { get; set; }
    public List<String> apiFields { get; set; }
    public Id rectypeId { get; set; }
    public Boolean sameAcctConvert { get; set; }
    public Boolean leadCreated { get; set; }

    public ReferralLeadController(ApexPages.StandardController standardController) {
        oppId = standardController.getRecord().Id;
        opty = [SELECT Id, AccountId, Account.Name, Billing_Contact__r.Name, Referred_Date_Time__c, Referred_Product__c, Referred_Lead_ID__c FROM Opportunity WHERE Id = :oppId];
        List<ReferringOppSetting__c> settings = ReferringOppSetting__c.getall().values();
        settings.sort();

        productsList = new List<SelectOption> ();
        productsList.add(new SelectOption('', ''));
        for (ReferringOppSetting__c cs : settings) {
            productsList.add(new SelectOption(cs.Name, cs.Name));
        }
    }

    public PageReference getLeadFields() {
        if (String.isNotEmpty(selProduct)) {
            refLead = new Lead();
            refLead.LastName = opty.Billing_Contact__r.Name;
            refLead.Company = opty.Account.Name;
            apiFields = new List<String> ();
            ReferringOppSetting__c product = ReferringOppSetting__c.getInstance(selProduct);
            if (product.API_Field_Name_1__c != null) {
                apiFields.add(product.API_Field_Name_1__c);
            }
            if (product.API_Field_Name_2__c != null) {
                apiFields.add(product.API_Field_Name_2__c);
            }
            if (product.API_Field_Name_3__c != null) {
                apiFields.add(product.API_Field_Name_3__c);
            }
            if (product.API_Field_Name_4__c != null) {
                apiFields.add(product.API_Field_Name_4__c);
            }
            rectypeId = product.LeadRecordTypeID__c;
            sameAcctConvert = product.SameAccountonConvert__c;
        } else {
            refLead = null;
        }
        return null;
    }

    public PageReference saveLead() {
        refLead.RecordTypeId = rectypeId;
        if (sameAcctConvert == true) {
            refLead.Referring_Account_ID__c = opty.AccountId;
        }
        refLead.Referred_Opportunity__c = opty.Id;
        refLead.Referred_by_Internal__c = UserInfo.getUserId();
        insert refLead;

        opty.Referred_Date_Time__c = Datetime.now();
        opty.Referred_Product__c = selProduct;
        opty.Referred_Lead_ID__c = refLead.Id;
        update opty;

        leadCreated = true;
        return null;
    }
}