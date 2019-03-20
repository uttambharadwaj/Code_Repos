@isTest
private class Test_LeadEloquaPass
{
    /*
    @isTest static void eloquaPass()
    {
        //*************load data

           list<EloquaPassThroughFields__c> csinsert = new list<EloquaPassThroughFields__c>();
           csinsert.add(new EloquaPassThroughFields__c(name='test',Object__c='lead',Parent_API_Name__c='Most_Recent_Response__c',Destination_Field_API_Name__c='Most_Recent_Response__c'));
           csinsert.add(new EloquaPassThroughFields__c(name='test1',Object__c='opportunity',Parent_API_Name__c='Most_Recent_Response__c',Destination_Field_API_Name__c='Most_Recent_Response__c'));
           insert csinsert;

        Program__c program = new Program__c(name='test');

        insert program;

        Map<string,campaign> campaigns = new map<string,campaign>();
        List<string> couponcodes = new List<string>{'test1','test2','test3','test4','test5','test6'};
        for(string s : couponcodes)
        {
            Campaign c = new Campaign(name='test',coupon_code__c=s);
            campaigns.put(s,c);
        }

        insert campaigns.values();

        List<Campaign_Program__c> campaignprograms = new List<Campaign_Program__c>();
        for(Campaign cc : campaigns.values())
        {
            Campaign_Program__c cp = new Campaign_Program__c();
            cp.campaign__c = cc.id;
            cp.program__c = program.id;
            campaignprograms.add(cp);
        }
        insert campaignprograms;

        List<Account> accounts = utestdata.getAccounts(1);
        insert accounts;

        List<Contact> contacts = utestdata.getContacts(accounts,1);
        contacts[0].i2i_Id__c = '1';
        insert contacts;

        List<Opportunity> opportunities = utestdata.getOpportunities(accounts);
        //opportunities[0].Campaign__c = campaigns.get('test1').Id;
        opportunities[0].CampaignId = campaigns.get('test1').Id;
        opportunities[0].Most_Recent_Response__c = 'test';
        opportunities[0].Most_Recent_Response_Date__c = system.now().date();
        insert opportunities;



        List<OpportunityContactRole> ocrs = new List<OpportunityContactRole>();
        for(Contact cc : contacts)
        {
            OpportunityContactRole ocr = new OpportunityContactRole(opportunityid=opportunities[0].id,contactid=cc.id);
            ocrs.add(ocr);
        }
        insert ocrs;

        CampaignMember cm = new CampaignMember(contactid=contacts[0].Id, campaignid=campaigns.get('test1').Id, status='Sent');
        insert cm;

        Id rectId = [Select Id from RecordType Where sobjectType='Lead' AND Name = 'Parent Lead' LIMIT 1].Id;
        GlobalSettings__c gs = new GlobalSettings__c(name='test');
        gs.Parent_Lead_Record_Type_Id__c = rectId;
        insert gs;

        Id rectId2 = [Select Id from RecordType Where sobjecttype='Lead' And Id != :rectId And isActive=true LIMIT 1].id;
        Lead_record_Type__c lrt = new Lead_record_Type__c();
        lrt.name='test';
        lrt.Lead_Record_Type_ID__c = rectId2;
        lrt.ProgramID__c = program.Id;
        insert lrt;

        Id profileID = [Select Id from Profile Where Name = 'System Administrator'].Id;
        User u = utestdata.getUserRecord((string)profileId);
        insert u;

        Sales_Activity_by_Profile__c sabp = new Sales_Activity_by_Profile__c();
        sabp.name='test';
        sabp.ProfileID__c = profileid;
        insert sabp;

        List<Lead> leads = utestdata.getLeads(2);
        leads[0].RecordTypeId = rectId;
        leads[0].i2i_Id__c = '4';
        leads[0].i2i_Coupon_Code_Pass__c = 'test4';
        leads[1].RecordTypeId = rectId;
        leads[1].i2i_Id__c = '1';
        leads[1].i2i_Coupon_Code_Pass__c = 'test1';
        leads[1].Related_Contact__c = contacts[0].Id;

        insert leads;

        Lead childlead = [Select id from Lead Where Parent_Lead__c = :leads[0].id];

        Task t = new task(status='Completed',whoid=childlead.Id,OwnerId=u.Id, ActivityDate=system.now().date());
        insert t;

        test.startTest();


        leads[0].Most_Recent_Response__c = 'test update';
        leads[0].Most_Recent_Response_Date__c = system.now().date();

        leads[1].Most_Recent_Response__c = 'test update';
        leads[1].Most_Recent_Response_Date__c = system.now().date();

        update leads;

        test.stoptest();

    }
    */

    @isTest static void testEloquaPassOpportunity()
    {
        //*************load data

        list<EloquaPassThroughFields__c> csinsert = new list<EloquaPassThroughFields__c>();
        csinsert.add(new EloquaPassThroughFields__c(name='test1',Object__c='opportunity',Parent_API_Name__c='Most_Recent_Response__c',Destination_Field_API_Name__c='Most_Recent_Response__c'));
        insert csinsert;

        Program__c program = new Program__c(name='test');

        insert program;

        /*
        Map<string,campaign> campaigns = new map<string,campaign>();
        List<string> couponcodes = new List<string>{'test1','test2','test3','test4','test5','test6'};
        for(string s : couponcodes)
        {
            Campaign c = new Campaign(name='test',coupon_code__c=s);
            campaigns.put(s,c);
        }

        insert campaigns.values();
        */

        Campaign c = new Campaign(name='test',coupon_code__c='test1');
        insert c;
        Campaign c2 = new Campaign(name='test',coupon_code__c='test2');
        insert c2;

        /*
        List<Campaign_Program__c> campaignprograms = new List<Campaign_Program__c>();
        for(Campaign cc : campaigns.values())
        {
            Campaign_Program__c cp = new Campaign_Program__c();
            cp.campaign__c = cc.id;
            cp.program__c = program.id;
            campaignprograms.add(cp);
        }
        insert campaignprograms;
        */
        Campaign_Program__c cp1 = new Campaign_Program__c();
        cp1.Campaign__c = c.Id;
        cp1.Program__c = program.id;
        insert cp1;

        Campaign_Program__c cp2 = new Campaign_Program__c();
        cp2.Campaign__c = c2.Id;
        cp2.Program__c = program.id;
        insert cp2;



        List<Account> accounts = utestdata.getAccounts(1);
        insert accounts;

        List<Contact> contacts = utestdata.getContacts(accounts,1);
        contacts[0].i2i_Id__c = '1';
        insert contacts;

        List<Opportunity> opportunities = utestdata.getOpportunities(accounts);
        opportunities[0].CampaignId = c.Id; //campaigns.get('test1').Id;
        opportunities[0].Most_Recent_Response__c = 'test';
        opportunities[0].Most_Recent_Response_Date__c = system.now().date();
        insert opportunities;

        //List<OpportunityContactRole> ocrs = new List<OpportunityContactRole>();
        //for(Contact cc : contacts)
        //{
           // OpportunityContactRole ocr = new OpportunityContactRole(opportunityid=opportunities[0].id,contactid=cc.id);
        //    ocrs.add(ocr);
        //}
        //insert ocrs;

        //CampaignMember cm = new CampaignMember(contactid=contacts[0].Id, campaignid = c.Id, status='Sent'); //campaignid=campaigns.get('test1').Id, status='Sent');
        //insert cm;

        Id rectId = [Select Id from RecordType Where sobjectType='Lead' AND Name = 'Parent Lead' LIMIT 1].Id;
        GlobalSettings__c gs = new GlobalSettings__c(name='test');
        gs.Parent_Lead_Record_Type_Id__c = rectId;
        insert gs;

        Id rectId2 = [Select Id from RecordType Where sobjecttype='Lead' And Id != :rectId And isActive=true LIMIT 1].id;
        Lead_record_Type__c lrt = new Lead_record_Type__c();
        lrt.name='test';
        lrt.Lead_Record_Type_ID__c = rectId2;
        lrt.ProgramID__c = program.Id;
        insert lrt;

        //Id profileID = [Select Id from Profile Where Name = 'System Administrator'].Id;
        //User u = utestdata.getUserRecord((string)profileId);
        //insert u;

        //Sales_Activity_by_Profile__c sabp = new Sales_Activity_by_Profile__c();
        //sabp.name='test';
        //sabp.ProfileID__c = profileid;
        //insert sabp;

        List<Lead> l = UTestData.getLeads(1);
        l[0].RecordTypeId = rectId;
        l[0].i2i_ID__c ='1';
        l[0].i2i_Coupon_Code_Pass__c='test1';
        l[0].Related_Contact__c = contacts[0].Id;
        insert l;

        /*
        List<Lead> leads = utestdata.getLeads(2);
        leads[0].RecordTypeId = rectId;
        leads[0].i2i_Id__c = '4';
        leads[0].i2i_Coupon_Code_Pass__c = 'test4';
        leads[1].RecordTypeId = rectId;
        leads[1].i2i_Id__c = '1';
        leads[1].i2i_Coupon_Code_Pass__c = 'test1';
        leads[1].Related_Contact__c = contacts[0].Id;

        insert leads;
        */


        /*
        Lead childlead = [Select id from Lead Where Parent_Lead__c = :leads[0].id];

        Task t = new task(status='Completed',whoid=childlead.Id,OwnerId=u.Id, ActivityDate=system.now().date());
        insert t;
        */

        test.startTest();


        /*
        leads[0].Most_Recent_Response__c = 'test update';
        leads[0].Most_Recent_Response_Date__c = system.now().date();

        leads[1].Most_Recent_Response__c = 'test update';
        leads[1].Most_Recent_Response_Date__c = system.now().date();
        update leads;

        */

        l[0].Most_Recent_Response__c = 'test update';
        l[0].Most_Recent_Response_Date__c = system.now().date();
        update l;


        test.stoptest();
    }

    @istest static void testEloquaPassLeads()
    {
        //*************load data

        list<EloquaPassThroughFields__c> csinsert = new list<EloquaPassThroughFields__c>();
        csinsert.add(new EloquaPassThroughFields__c(name='test',Object__c='lead',Parent_API_Name__c='Most_Recent_Response__c',Destination_Field_API_Name__c='Most_Recent_Response__c'));
        insert csinsert;

        Program__c program = new Program__c(name='test');

        insert program;


        Campaign c = new Campaign(name='test',coupon_code__c='test1');
        insert c;
        Campaign c2 = new Campaign(name='test',coupon_code__c='test2');
        insert c2;

        Campaign_Program__c cp1 = new Campaign_Program__c();
        cp1.Campaign__c = c.Id;
        cp1.Program__c = program.id;
        insert cp1;

        Campaign_Program__c cp2 = new Campaign_Program__c();
        cp2.Campaign__c = c2.Id;
        cp2.Program__c = program.id;
        insert cp2;


        Id rectId = [Select Id from RecordType Where sobjectType='Lead' AND Name = 'Parent Lead' LIMIT 1].Id;
        GlobalSettings__c gs = new GlobalSettings__c(name='test');
        gs.Parent_Lead_Record_Type_Id__c = rectId;
        insert gs;

        Id rectId2 = [Select Id from RecordType Where sobjecttype='Lead' And Id != :rectId And isActive=true LIMIT 1].id;
        Lead_record_Type__c lrt = new Lead_record_Type__c();
        lrt.name='test';
        lrt.Lead_Record_Type_ID__c = rectId2;
        lrt.ProgramID__c = program.Id;
        insert lrt;

        Id profileID = [Select Id from Profile Where Name = 'System Administrator'].Id;
        User u = utestdata.getUserRecord((string)profileId);
        insert u;

        Sales_Activity_by_Profile__c sabp = new Sales_Activity_by_Profile__c();
        sabp.name='test';
        sabp.ProfileID__c = profileid;
        insert sabp;

        List<Lead> l = utestdata.getleads(1);

        l[0].RecordTypeId = rectId;
        l[0].i2i_Id__c = '1';
        l[0].i2i_Coupon_Code_Pass__c = 'test1';
        insert l;


        Lead childlead = [Select id from Lead Where Parent_Lead__c = :l[0].id];

        Task t = new task(status='Completed',type='test',whoid=childlead.Id,OwnerId=u.Id, ActivityDate=system.now().date());
        insert t;

        test.startTest();


        l[0].Most_Recent_Response__c = 'test update';
        l[0].Most_Recent_Response_Date__c = system.now().date();


        update l;

        delete childlead;

        l[0].Most_Recent_Response__c = 'test update new';
        l[0].Most_Recent_Response_Date__c = system.now().date();


        update l;

        test.stoptest();
    }
}