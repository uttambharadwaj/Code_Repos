public with sharing class TestDataFactory {
    // Account
    public static Account createAccount(Boolean isInsert) {
        Account acct = new Account();
        acct.Name = 'test';

        if (isInsert) insert acct;
        return acct;
    }

    // Campaign
    public static Campaign createCampaign(Boolean isInsert, String campaignName, String couponCode) {
        Campaign camp = new Campaign();
        camp.Name = campaignName;
        camp.Coupon_Code__c = couponCode;

        if (isInsert) insert camp;
        return camp;
    }

    // Campaign Member
    public static CampaignMember createCampaignMember(Boolean isInsert, Id campaignId, Id contactId) {
        CampaignMember cm = new CampaignMember();
        cm.CampaignId = campaignId;
        cm.ContactId = contactId;
        cm.Status = 'Sent';

        if (isInsert) insert cm;
        return cm;
    }

    // Campaign Program
    public static Campaign_Program__c createCampaignProgram(Boolean isInsert, Id campaignId, Id programId) {
        Campaign_Program__c cp = new Campaign_Program__c();
        cp.Campaign__c = campaignId;
        cp.Program__c = programId;

        if (isInsert) insert cp;
        return cp;
    }

    // Contact
    public static Contact createContact(Boolean isInsert, Id acctId, String i2iID, String leadNumber) {
        Contact c = new Contact();
        c.AccountId = acctId;
        c.LastName = 'test';
        c.i2i_id__c = i2iID;
        c.Lead_Number__c = leadNumber;

        if (isInsert) insert c;
        return c;
    }

    // Global Settings
    public static GlobalSettings__c createGlobalSettings(String objectType, String recordTypeName, Id ownerId) {
        Id parentRT = [SELECT Id FROM RecordType WHERE sObjectType = :objectType AND Name = :recordTypeName].Id;
        Id defaultRT = [SELECT Id FROM RecordType WHERE SObjectType = :objectType AND Name != :recordTypeName LIMIT 1].Id;

		GlobalSettings__c gs = new GlobalSettings__c();
		gs.Name = 'test';
		gs.Parent_Lead_Record_Type_Id__c = parentRT;
        gs.Parent_Lead_Queue__c = ownerId;
        gs.Default_Lead_Record_Type__c = defaultRT;

		insert gs;
        return gs;
    }

    // Lead
    public static Lead createLead(Boolean isInsert, Id parentId, String idNumber) {
        Lead l = new Lead();
        l.LastName = 'Lead';
        l.Company = 'THE TEST COMPANY';
        l.i2i_ID__c = idNumber;
        l.i2i_Coupon_Code_Pass__c = 'test' + idNumber;
        
        // Child Lead
        if (parentId != null) {
            l.Parent_Lead__c = parentId;
        }
        // Parent Lead
        else {
            l.RecordTypeId = [Select Id from RecordType Where SObjectType = 'Lead' AND Name = 'Parent Lead' LIMIT 1].Id;
        }

        if (isInsert) insert l;
        return l;
    }

    // Lead Record Type
    public static Lead_Record_Type__c createLeadRecordType(Boolean isInsert, String lrtName, Id programId) {
        Lead_Record_Type__c lrt = new Lead_Record_Type__c();
        lrt.Name = lrtName;
        lrt.Lead_Record_Type_ID__c = [SELECT Id FROM RecordType WHERE SObjectType = 'Lead' And Name != 'Parent Lead' And isActive = true LIMIT 1].Id;
        lrt.ProgramID__c= programId;

        if (isInsert) insert lrt;
        return lrt;
    }

    // Opportunity
    public static Opportunity createOpportunity(Boolean isInsert, Id acctId, Id campaignId) {
        Opportunity opp = new Opportunity();
        opp.AccountId = acctId;
        opp.Name = 'Test Opportunity';
        opp.CloseDate = Date.today();
        opp.StageName = '1) Qualified';
        opp.Fueling_Methos__c = 'test';
        opp.CampaignId = campaignId;

        if (isInsert) insert opp;
        return opp;
    }

    // Opportunity Contact Role
    public static OpportunityContactRole createOpportunityContactRole(Boolean isInsert, Id oppId, Id contactId) {
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.OpportunityId = oppId;
        ocr.ContactId = contactId;

        if (isInsert) insert ocr;
        return ocr;
    }

    // Program
    public static Program__c createProgram(Boolean isInsert, String programName) {
        Program__c program = new Program__c();
        program.Name = programName;

        if (isInsert) insert program;
        return program;
    }

    // Sales Activity by Profile
    public static Sales_Activity_by_Profile__c createSalesActivityByProfile(Boolean isInsert) {
        Sales_Activity_by_Profile__c sabp = new Sales_Activity_by_Profile__c();
        sabp.ProfileID__c = [Select Id from Profile Where Name = 'System Administrator'].Id;
        sabp.Name = 'Testing';

        if (isInsert) insert sabp;
        return sabp;
    }

    // Task
    public static Task createTask(Boolean isInsert, Id whoId, Id ownerId) {
        Task t = new Task();
        t.Status = 'Completed';
        t.Type = 'Test';
        t.WhoId = whoId;
        t.OwnerId = ownerId;
        t.ActivityDate = System.now().date();

        if (isInsert) insert t;
        return t;
    }
    
    // Program
    public static Partner__c createPartner(Boolean isInsert, String partName) {
        Partner__c p = new Partner__c();
        p.Name = partName;

        if (isInsert) insert p;
        return p;
    }

    // User - System Administrator
    public static User createUserSysAdmin(Boolean isInsert) {
        User u = new User();
        u.ProfileId = [Select Id from Profile Where Name = 'System Administrator'].Id;
        u.Alias = 'sysadmin';
        u.Username = u.Username + Integer.valueof((Math.random() * 100000)) + '@testwex.com'; 
        u.Email = u.Username;
        u.EmailEncodingKey = 'UTF-8';
        u.FirstName = 'test';
        u.LastName = 'test';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'America/Los_Angeles';

        if (isInsert) insert u;     
        return u;
    }
}