@isTest public class LeadSplitTriggerTest {
    
    @isTest public static void LSTTest(){
        
        UserRole userRole = [SELECT Id FROM UserRole WHERE Name = 'Lead Development Role'];
        
        Profile p = [SELECT id FROM Profile WHERE Name = 'IS Sales'];
        
        User usr = new User(
            FirstName = 'Test',
            LastName = 'Test',
            Email = 'test@wexinc.com',
            Alias = 'testl',
            Username = 'test@wexinc.com',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = p.id,
            CompanyName = 'Test', 
            UserRoleId = userRole.Id
        );
        
        insert usr;
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
            
            System.Test.startTest();
            
            System.Test.setMock(HttpCalloutMock.class, new CustomHttpCalloutMock());
            
            Lead_Development_Splits__c testLDS = new Lead_Development_Splits__c();
            testLDS.Name = 'Test Setting';
            testLDS.Role_Name__c = 'Lead Development Role';
            testLDS.Opportunity_Split_Type__c = 'Other';
            testLDS.Commission_Type__c = 'Lead Qualification';
            testLDS.Role_ID__c = userRole.Id;
            insert testLDS;
            
            Campaign campaign = new Campaign();
            
            //create campaign test data
            campaign.Coupon_Code__c = 'TEST1';
            campaign.Name = 'TestCampaign';
            campaign.Type = 'Online Form';
            campaign.Status = 'In Progress';
            campaign.Drop_Date__c = date.today();
            campaign.EndDate = date.today();
            campaign.CurrencyIsoCode = 'USD';
            campaign.IsActive = true;
            
            insert campaign;
            
            Program__c program = new Program__c();
            
            program.Name = 'TestBOCA';
            program.Peoplesoft_rel_code__c = '012011';
            program.Form_Template__c = 'WexBOCA';
            program.Brand_Short_Name__c = 'TestBOCA';
            program.Preferred_Language_Indicator__c = 'ENU';
            program.Custom_Email_Header_URL__c = 'http://www.wexhosted.com/email/revolver/header_wexRevolver.jpg';
            program.Brand_Heading__c = 'Time is money. Use WEX and save both.';
            program.Brand_Long_Name__c = 'Test BOCA';
            program.Upload_Pricing_Data_Flag__c = false;
            program.Auto_Send_BOCA_to_Siebel__c = false;
            program.T_C__c = 'WEX_BOCA_TNC';
            program.Analytics_Body_Block__c = '';
            program.Analytics_Head_Block__c = '';
            program.Brand_Color_1__c = '#ccc';
            program.Brand_Color_2__c = '#fff';
            
            insert program;
            
            Campaign_Program__c campaignProgram = new Campaign_Program__c();
        	campaignProgram.Name = 'Flex Test';
        	campaignProgram.Campaign__c = campaign.Id;
        	campaignProgram.Program__c = program.Id;
        	campaignProgram.Terms_and_Conditions__c = 'Test T&C';
        	campaignProgram.Default__c = true;
        
        	insert campaignProgram;
            
            Lead testLead = new Lead( 
                Company = 'wex',
                FirstName = 'Test',
                LastName = 'Test',
                Email = 'abigail.andrews@wexinc.com',
                Fleet_Size__c = 111, 
                Years_in_Business__c = 100, 
                Status = 'Qualified',
                LeadSource = 'Advertisement', 
                Primary_Campaign__c = campaign.Id,
                Campaign_Program__c = campaignProgram.Id,
                Campaign_Response_Methods__c = 'Email'
            );
            
            insert testLead;
            
            System.debug('### ' + usr);
            
            testLead.OwnerId = usr.Id;
            update testLead;
            
            System.debug('###' + testLead);
            
            testLead.OwnerId = integrationUser.Id;
            update testLead;
            
            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(testLead.id);
            lc.setDoNotCreateOpportunity(false);
            
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE isConverted = True LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.debug('########### is converted?' + convertStatus);
            System.debug('########### is success? ' + lcr.isSuccess());
            System.assert(lcr.isSuccess());
            
            System.Test.stopTest();
        }
    }
    
    public class CustomHttpCalloutMock implements HttpCalloutMock{
        
        public HTTPResponse respond(HTTPRequest req){
            HTTPResponse retVal = new HttpResponse();
            return retVal;
        }
    }
    
    
}