/**
 * Created by lhowland on 5/22/2019.
 */
@isTest
public class PaperAppSubmissionExtensionTest {

    @testSetup
    static void setup() {

        UtilityTestLoader.setAutomation(false);

        Campaign campaign = new Campaign();

        //create campaign test data
        campaign.Coupon_Code__c = 'TESTCOUPONX';
        campaign.Name = 'OTRTestCampaign';
        campaign.Type = 'Online Form';
        campaign.Status = 'In Progress';
        campaign.Drop_Date__c = date.today();
        campaign.EndDate = date.today();
        campaign.CurrencyIsoCode = 'USD';
        campaign.IsActive = true;

        insert campaign;

        Program__c program = new Program__c();

        program.Name = 'OTRTestBOCAX';
        program.Form_Template__c = 'OTRBOCA';
        program.Brand_Short_Name__c = 'OTRTESTX';
        program.Preferred_Language_Indicator__c = 'ENU';
        program.Custom_Email_Header_URL__c = 'http://www.wexhosted.com/email/revolver/header_wexRevolver.jpg';
        program.Brand_Heading__c = 'Time is money. Use WEX and save both.';
        program.Brand_Long_Name__c = 'Test Paper App BOCA';
        program.Upload_Pricing_Data_Flag__c = false;
        program.Auto_Send_BOCA_to_Siebel__c = false;
        program.T_C__c = 'WEX_BOCA_TNC';
        program.Analytics_Body_Block__c = '';
        program.Analytics_Head_Block__c = '';
        program.Brand_Color_1__c = '#ccc';
        program.Brand_Color_2__c = '#fff';

        insert program;

        Campaign_Program__c campaignProgram = new Campaign_Program__c();
        //create campaign program test data
        campaignProgram.Name = 'OTR Test';
        campaignProgram.Campaign__c = campaign.Id;
        campaignProgram.Program__c = program.Id;
        campaignProgram.Terms_and_Conditions__c = 'Test T&C';
        campaignProgram.Default__c = true;

        insert campaignProgram;

        Account account = new Account(Name = 'Test Account ' + Math.random());
        account.BillingStreet = '123 Popcorn Lane';
        account.BillingCity = 'Portland';
        account.BillingState = 'ME';
        account.BillingPostalCode = '04106';
        account.Phone = '3123334444';

        insert account;

        OnlineApplicationOffer__c offer = new OnlineApplicationOffer__c( Name = 'test offer',
                Application_Title__c = 'test applications',
                EchoSign_User_Email__c = 'test@gmail.com',
                Terms_and_Conditions_Version__c = 'test',
                Complete_Later_Text__c = 'test later',
                Complete_Later_Email_Title__c = 'test',
                Complete_Later_Email_From__c = 'Fleet One',
                Complete_Later_Email__c = 'Thanks',
                Program__c = program.Id);

        insert offer;

        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];

        System.runAs(integrationUser) {

            Opportunity opportunity = new Opportunity();
            opportunity.Name = 'Testopp';
            opportunity.Offer__c = offer.Id;
            opportunity.CloseDate = date.newInstance(2099, 1, 1);
            opportunity.StageName = '1';
            opportunity.Fleet_Size__c = 10;
            opportunity.OwnerId = integrationUser.Id;
            opportunity.SourceSystem__c = 'test';
            opportunity.Legal_Structure__c = 'Corporation';
            opportunity.LeadSource = 'Referral';
            opportunity.Type = 'New Customer';
            opportunity.AccountId = account.Id;
            opportunity.CampaignId = campaign.Id;
            opportunity.Fueling_Methos__c = '76';
            opportunity.Campaign_Program__c = campaignProgram.Id;

            insert opportunity;
        }
    }

    @isTest
    static void buildURLTest() {

        Test.startTest();

        List<Opportunity> opptys = [SELECT Id, Offer__c, Offer__r.Program__c from Opportunity LIMIT 1];
        Id optyId = opptys[0].Id;

        PageReference paperBOCA = Page.PaperAppButton;
        paperBOCA.getParameters().put('id', optyId);
        Test.setCurrentPage(paperBOCA);

        PaperAppSubmissionExtension controller = new PaperAppSubmissionExtension();
        controller.selectedOffer = opptys[0].Offer__c;
        controller.selectedProgram = opptys[0].Offer__r.Program__c;
        paperBOCA = controller.buildURL();

        String programParam = paperBOCA.getParameters().get('pgm');
        System.assertEquals('OTRTESTX', programParam);
    }
}