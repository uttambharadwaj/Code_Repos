@isTest
public class TestMVFScheduledEmails {

    
    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }
    
    static testMethod void test24HourEmails() {
        
        User integrationUser = [SELECT Id FROM User WHERe Alias = 'sinte'];
        
        System.runAs(integrationUser) {
            
            Campaign campaign = new Campaign();
            
            //create campaign test data
            campaign.Coupon_Code__c = 'QBW';
            campaign.Name = 'TestCampaign';
            campaign.Type = 'Online Form';
            campaign.Status = 'In Progress';
            campaign.Drop_Date__c = date.today();
            campaign.EndDate = date.today();
            campaign.CurrencyIsoCode = 'USD';
            campaign.IsActive = true;
            
            insert campaign;
            
            // Setup Program
            Program__c program = new Program__c();
            
            program.Name = 'Sunoco Fleet' ;         
            program.Brand_Short_Name__c = 'sunoco';
            program.Brand_Long_Name__c = 'Sunoco Fleet';
            
            insert program;
            
            Campaign_Program__c campaignProgram = new Campaign_Program__c();
            //create campaign program test data
            campaignProgram.Name = 'Flex Test';
            campaignProgram.Campaign__c = campaign.Id;
            campaignProgram.Program__c = program.Id;
            campaignProgram.Terms_and_Conditions__c = 'Test T&C';
            campaignProgram.Default__c = true;
            
            insert campaignProgram;
            
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            
            Profile prof = [SELECT Id,Name FROM Profile where name = 'IS Sales'];
                
			UserRole userRole = [SELECT Id FROM UserRole WHERE Name = 'IS Sales Rep'];
            
            //for(Integer i = 0; i < 5; i++) {
                
                Lead lead = new Lead(LastName='Doe',FirstName='John',Company='Test',Status='Qualified');
                
                insert lead;                
                
                Database.LeadConvert lc = new database.LeadConvert();
                lc.setLeadId(lead.id);
                lc.setDoNotCreateOpportunity(false);
                
                lc.setConvertedStatus(convertStatus.MasterLabel);
                
                Database.LeadConvertResult lcr = Database.convertLead(lc);
                System.assert(lcr.isSuccess());
                
                Lead convertedLead = [SELECT Id, ConvertedOpportunityId FROM Lead WHERE Id =: lead.Id LIMIT 1];
                
                Datetime yesterday = Datetime.now().addDays(-1);
                Test.setCreatedDate(convertedLead.ConvertedOpportunityId, yesterday);            

                Opportunity oppty = [SELECT Id, CreatedDate, Campaign__c FROM Opportunity WHERE Id =: convertedLead.ConvertedOpportunityId];
                
                oppty.CampaignId = campaign.Id;
                upsert oppty;
                
                System.debug(oppty);
                
            //}
            
            List<Opportunity> opportunities = [SELECT Id, OwnerId, CreatedDate, CampaignId, StageName, Coupon_Code2__c FROM Opportunity WHERE DAY_ONLY(CreatedDate) = YESTERDAY];
            
            System.debug(opportunities);
            
            Test.startTest();
            
            TestUtils.enable_isRunningTest = true;
            
            MVFScheduledEmails mvfEmailer = new MVFScheduledEmails();
            
            mvfEmailer.sendMVF2Emails();
            
            Test.stopTest();
            
        }
        
    }
    
    static testMethod void test24HourLeadEmails() {
        
        User integrationUser = [SELECT Id FROM User WHERe Alias = 'sinte'];
        
        System.runAs(integrationUser) {
                
            Lead lead = new Lead(LastName='Doe',FirstName='John',Company='Test',Status='Qualified',Coupon_Code__c='WQM');
                
            insert lead;
            
			Datetime yesterday = Datetime.now().addDays(-1);
            Test.setCreatedDate(lead.Id, yesterday);
            
            Test.startTest();
            
            TestUtils.enable_isRunningTest = true;
            
            MVFScheduledEmails mvfEmailer = new MVFScheduledEmails();
            
            mvfEmailer.sendMVFLead2Emails();
            
            Test.stopTest();
            
        }
        
    }
    
    static testMethod void test7DayLeadEmails() {
        
        User integrationUser = [SELECT Id FROM User WHERe Alias = 'sinte'];
        
        System.runAs(integrationUser) {
                
            Lead lead = new Lead(LastName='Doe',FirstName='John',Company='Test',Status='Qualified',Coupon_Code__c='WQM');
                
            insert lead;
            
			Date pastDate = Date.Today()-8;
            Test.setCreatedDate(lead.Id, pastDate);
            
            Test.startTest();
            
            TestUtils.enable_isRunningTest = true;
            
            MVFScheduledEmails mvfEmailer = new MVFScheduledEmails();
            
            mvfEmailer.sendMVFLead3Emails();
            
            Test.stopTest();
            
        }
        
    }
    
    
    static testMethod void test7DayEmails() {
        
        User integrationUser = [SELECT Id FROM User WHERe Alias = 'sinte'];
        
        System.runAs(integrationUser) {
            
            Campaign campaign = new Campaign();
            
            //create campaign test data
            campaign.Coupon_Code__c = 'QBW';
            campaign.Name = 'TestCampaign';
            campaign.Type = 'Online Form';
            campaign.Status = 'In Progress';
            campaign.Drop_Date__c = date.today();
            campaign.EndDate = date.today();
            campaign.CurrencyIsoCode = 'USD';
            campaign.IsActive = true;
            
            insert campaign;
            
            // Setup Program
            Program__c program = new Program__c();
            
            program.Name = 'Sunoco Fleet' ;         
            program.Brand_Short_Name__c = 'sunoco';
            program.Brand_Long_Name__c = 'Sunoco Fleet';
            
            insert program;
            
            Campaign_Program__c campaignProgram = new Campaign_Program__c();
            //create campaign program test data
            campaignProgram.Name = 'Flex Test';
            campaignProgram.Campaign__c = campaign.Id;
            campaignProgram.Program__c = program.Id;
            campaignProgram.Terms_and_Conditions__c = 'Test T&C';
            campaignProgram.Default__c = true;
            
            insert campaignProgram;
            
            Lead lead = new Lead(LastName='Doe',FirstName='John',Company='Test',Status='Qualified');
            
            insert lead;                
            
            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(lead.id);
            lc.setDoNotCreateOpportunity(false);
            
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());
            
            Lead convertedLead = [SELECT Id, ConvertedOpportunityId FROM Lead WHERE Id =: lead.Id LIMIT 1];
            
            Date pastDate = Date.Today()-8;
            Test.setCreatedDate(convertedLead.ConvertedOpportunityId, pastDate);            
            
            Opportunity oppty = [SELECT Id, CreatedDate, Campaign__c FROM Opportunity WHERE Id =: convertedLead.ConvertedOpportunityId];
            
            oppty.CampaignId = campaign.Id;
            
            upsert oppty;
            
            System.debug(oppty);
            
            List<Opportunity> opportunities = [SELECT Id, CreatedDate FROM Opportunity WHERE DAY_ONLY(CreatedDate) = :pastDate and Coupon_Code2__c in ('QBW', 'T2Y') and StageName in ('1) Qualified', '2) Engaged', '3) Evaluating', '4) Negotiating', 'Stalled')];
            
            System.debug(opportunities);
            
            Test.startTest();
            
            TestUtils.enable_isRunningTest = true;
            
            MVFScheduledEmails mvfEmailer = new MVFScheduledEmails();
            
            mvfEmailer.sendMVF3Emails();
            
            Test.stopTest();
            
        }
        
    }
    
}