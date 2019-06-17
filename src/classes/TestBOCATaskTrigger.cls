@isTest
public class TestBOCATaskTrigger {
    
    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testMethod void testUnsolicitedBOCA() {
        
        BOCA_Settings__c bocaSettings = new BOCA_Settings__c();
        
        bocaSettings.Enable_BOCA_Task_Trigger__c = true;
        
        insert bocaSettings;
        
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
        
        Test.startTest();
        
        try {
            
            User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
            Application_Request__c applicationRequest = new Application_Request__c(); 
            
            System.runAs(integrationUser) {

                Opportunity opportunity = new Opportunity(name= 'TestOpp',closedate= Date.today() ,stagename='5) Signed', fleet_size__c = 10, sourcesystem__c = 'BOCA');
                opportunity.Fueling_Methos__c = 'BP';
                opportunity.CampaignId = campaign.Id;
                opportunity.Campaign_Program__c = campaignProgram.Id;
                
                insert opportunity;
                
                System.debug('### DEBUG Opportunity: ' + opportunity.Id);
                
                applicationRequest.Sales_Person__c = integrationUser.Id;
                applicationRequest.Sales_Stage__c = '04 - Application Received';
                applicationRequest.Opportunity__c = opportunity.Id;        
                
                insert applicationRequest;
                
                System.debug('### DEBUG Application Request: ' + applicationRequest.Id);
                
                applicationRequest.Siebel_Oppty__c = '1-ABCDE';
                
                System.debug('### ' + applicationRequest);
                
                upsert applicationRequest;
                
            }
            
            Application_Request__c updatedAppRequest = [SELECT Id, Solicited_Activity_Sent__c FROM Application_Request__c WHERE Id =: applicationRequest.Id];
            
            System.debug('### DEBUG App Request' + updatedAppRequest.Id + ', Solicited Flag: ' + updatedAppRequest.Solicited_Activity_Sent__c);
            
            System.assertEquals(false, updatedAppRequest.Solicited_Activity_Sent__c);
            
        }
        
        catch(Exception e)
        {
            System.debug('Error...' + String.valueOf(e));
        }
        
        Test.stopTest();
        
    }
    
    static testMethod void testSolicitedTask() {
        
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'IS Sales']; 
        
        User salesRep = new User(Alias = 'tUse', Email='stanTestuser@wexinc.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = profile.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='stanarduser@wexinc.com');
        
        insert salesRep;
        
        BOCA_Settings__c bocaSettings = new BOCA_Settings__c();
        
        bocaSettings.Enable_BOCA_Task_Trigger__c = true;
        
        insert bocaSettings;
        
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
        
        Test.startTest();
        
        try {
            
            User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
            Application_Request__c applicationRequest = new Application_Request__c(); 
            
            System.runAs(integrationUser) {

                Opportunity opportunity = new Opportunity(name= 'TestOpp',closedate= Date.today() ,stagename='5) Signed', fleet_size__c = 10, sourcesystem__c = 'BOCA');
                opportunity.Fueling_Methos__c = 'BP';
                opportunity.CampaignId = campaign.Id;
                opportunity.Campaign_Program__c = campaignProgram.Id;
                
                insert opportunity;
                
                System.debug('### DEBUG Opportunity: ' + opportunity.Id);
                
                applicationRequest.Sales_Person__c = salesRep.Id;
                applicationRequest.Sales_Stage__c = '04 - Application Received';
                applicationRequest.Opportunity__c = opportunity.Id;        
                
                insert applicationRequest;
                
                System.debug('### DEBUG Application Request: ' + applicationRequest.Id);
                
                applicationRequest.Siebel_Oppty__c = '1-ABCDE';
                
                System.debug('### ' + applicationRequest);
                
                upsert applicationRequest;
                
            }
            
            Application_Request__c updatedAppRequest = [SELECT Id, Solicited_Activity_Sent__c FROM Application_Request__c WHERE Id =: applicationRequest.Id];
            
            System.debug('### DEBUG App Request' + updatedAppRequest.Id + ', Solicited Flag: ' + updatedAppRequest.Solicited_Activity_Sent__c);
            
            System.assertEquals(true, updatedAppRequest.Solicited_Activity_Sent__c);
            
        }
        
        catch(Exception e)
        {
            System.debug('Error...' + String.valueOf(e));
        }
        
        Test.stopTest();
        
    }
    
}