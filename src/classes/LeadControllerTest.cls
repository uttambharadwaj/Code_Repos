public class LeadControllerTest{
    /*
    //identified as deletable in technicaldebtz spreadsheet
    static testMethod void testLeadController(){

        PageReference pageRef = Page.LeadMobileForm;
        Test.setCurrentPage(pageRef);

        List<String> AU_Lead_RTs = new List<String>{'AU_Fuel_Application_Individual','AU_Fuel_Business','AU_Fuel_Merchant','AU_Fuel_Prepaid','AU_VCC'};

        Id leadRT = [select Id from RecordType where sObjectType = 'Lead' and DeveloperName NOT IN :AU_Lead_RTs limit 1].Id;

        Lead lead = new Lead();
        lead.RecordTypeId = leadRT;
        lead.Company = 'acme';
        lead.LastName = 'lastname';
        lead.FirstName = 'firstname';
        lead.Email = 'firstlast@acme.com';
        lead.Phone = '1234567894';
        lead.State__c = 'ME';
        lead.Fleet_Size__c = 100;
        lead.Fueling_Expenditure__c = '1200';
        lead.LeadSource = 'Mobile';
        lead.Primary_Campaign__c = '70170000000gbFM';

        LeadController controller = new LeadController();
        controller.Lead = lead;

        controller.save();

        Lead[] leads = [select id, email from lead where Company = 'acme'];
        System.assertEquals('firstlast@acme.com', leads[0].email);
    }

    static testMethod void testStates(){
        LeadController controller = new LeadController();
        List<SelectOption> options = controller.getStates();
        SelectOption option = options[0];
        System.assert(options.size() > 0, 'option list was empty');
    }

    static testMethod void testLead(){
       PageReference pageRef = Page.LeadMobileForm;
        Test.setCurrentPage(pageRef);

        List<String> AU_Lead_RTs = new List<String>{'AU_Fuel_Application_Individual','AU_Fuel_Business','AU_Fuel_Merchant','AU_Fuel_Prepaid','AU_VCC'};

        Id leadRT = [select Id from RecordType where sObjectType = 'Lead' and DeveloperName NOT IN :AU_Lead_RTs limit 1].Id;

        Lead lead = new Lead();
        lead.RecordTypeId = leadRT;
        lead.Company = 'acme';
        lead.LastName = 'lastname';
        lead.FirstName = 'firstname';
        lead.Email = 'firstlast@acme.com';
        lead.Phone = '1234567894';
        lead.State__c = 'ME';
        lead.Fleet_Size__c = 100;
        lead.Fueling_Expenditure__c = '1200';
        lead.LeadSource = 'Mobile';
        lead.Primary_Campaign__c = '70170000000gbFM';

        LeadController controller = new LeadController();
        controller.Lead = lead;

        Lead result = controller.getLead();

        System.assertEquals('firstlast@acme.com', result.email);
    }
 */
}