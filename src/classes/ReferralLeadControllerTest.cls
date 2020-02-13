@isTest
private class ReferralLeadControllerTest {
    static testmethod void testController() {
        Id rectypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Wright_Leads').getRecordTypeId();
        ReferringOppSetting__c cs = new ReferringOppSetting__c();
        cs.Name = 'Branded Fuel Card';
        cs.API_Field_Name_1__c = 'Fleet_Size__c';
        cs.API_Field_Name_2__c = 'Current_Fueling_Method__c';
        cs.API_Field_Name_3__c = 'Company';
        cs.API_Field_Name_4__c = 'Name';
        cs.LeadRecordTypeID__c = rectypeId;
        cs.SameAccountonConvert__c = false;
        insert cs;

        Contact con = new Contact(FirstName='John', LastName='Doe');
        insert con;

        Opportunity opp = new Opportunity(Name='Test Opp', Billing_Contact__c = con.Id, StageName='Proposal', CloseDate = System.today());
        insert opp;

        Test.startTest();
        Test.setCurrentPage(Page.ReferralLead);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        ReferralLeadController ctl = new ReferralLeadController(sc);
        ctl.selProduct = 'Branded Fuel Card';
        ctl.getLeadFields();
        ctl.refLead.Fleet_Size__c = 100;
        ctl.refLead.Current_Fueling_Method__c = 'MasterCard';
        ctl.refLead.Company = 'ABC Inc.';
        ctl.saveLead();
        Test.stopTest();

        Lead l = [SELECT Name, RecordTypeId, Fleet_Size__c, Current_Fueling_Method__c, Company, Referred_Opportunity__c FROM Lead WHERE Id = :ctl.refLead.Id];
        System.assertEquals('John Doe', l.Name);
        System.assertEquals(rectypeId, l.RecordTypeId);
        System.assertEquals(100, l.Fleet_Size__c);
        System.assertEquals('MasterCard', l.Current_Fueling_Method__c);
        System.assertEquals('ABC Inc.', l.Company);
        System.assertEquals(opp.Id, l.Referred_Opportunity__c);

        opp = [SELECT Referred_Product__c, Referred_Lead_ID__c FROM Opportunity WHERE Id =: opp.Id];
        System.assertEquals('Branded Fuel Card', opp.Referred_Product__c);
        System.assertEquals(l.Id, opp.Referred_Lead_ID__c);
    }
}