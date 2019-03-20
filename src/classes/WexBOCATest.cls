// This is the main test class for the WexBOCA Application.
// 
// This test class covers the following classes:
// - WexBOCAController
// - WexBOCAErrorController
// - WexBOCAConfirmationController
// - WexBOCALanguageExtension

@isTest
public class WexBOCATest {

    public static Program__c setupProgram() {
   
        // Revisit this later..
        BOCA_IDS__C bocaId = BOCAtestDataUtility.getBOCAids();
        insert bocaId;

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
        
        Campaign_Pricing__c campaignPricing = new Campaign_Pricing__c();
        campaignPricing.Name = 'test';
        campaignPricing.contract_margin__c = 'Y';
        campaignPricing.penalty_margin__c = 'Y';
        campaignPricing.days_to_pay__c = 21;
        campaignPricing.prime_rate__c = 3.25;
        campaignPricing.prime_rate_effective_date__c = Date.today();
        campaignPricing.late_fee_type__c = 'P';
        campaignPricing.return_payment_fee__c = 49.99;
        campaignPricing.over_limit_fee__c = 39.99;
        campaignPricing.paper_delivery_fee__c = 5.00;
        campaignPricing.penalty_rate_ceiling__c = 999.99;
        campaignPricing.minimum_payment_percentage__c = 29.99;
        campaignPricing.Peoplesoft_rel_code__c = '012011';
        campaignPricing.coup_code__c = 'TEST1';
        campaignPricing.is_Active__c = true;
        campaignPricing.Coupon_Status__c = 'valid';
        campaignPricing.risk_code__c = 'No';
        campaignPricing.nbr_billing_cyles__c = '1';
        campaignPricing.contract_rate_pct__c = 10.15;
        campaignPricing.fixed_late_fee__c = 0.00;
        campaignPricing.pct_late_fee__c = 2.49;
        campaignPricing.pen_rate_pct__c = 27.34;
        campaignPricing.promo_periods__c = 1.0;
        campaignPricing.promotional_rate__c = 8.17;
        campaignPricing.CurrencyIsoCode = 'USD';
        
        insert campaignPricing;


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
        program.Consumer_Application_Enabled__c = true;
        
        insert program;
        
        // Setup Attachments
        Attachment cardImage = new Attachment();
        cardImage.Name = 'ui-credit-card.png';
        Blob cardImageBlob = Blob.valueOf('Unit Test Attachment Body');
        cardImage.body = cardImageBlob;
        cardImage.parentId = program.Id;
        upsert cardImage;
        
        Attachment logo = new Attachment();
        logo.Name = 'ui-logo.png';
        Blob logoBlob = Blob.valueOf('Unit Test Attachment Body');
        logo.body = logoBlob;
        logo.parentId = program.Id;
        upsert logo;
        
        Campaign_Program__c campaignProgram = new Campaign_Program__c();
        //create campaign program test data
        campaignProgram.Name = 'Flex Test';
        campaignProgram.Campaign__c = campaign.Id;
        campaignProgram.Program__c = program.Id;
        campaignProgram.Terms_and_Conditions__c = 'Test T&C';
        campaignProgram.Default__c = true;
        
        insert campaignProgram;
        
        Boca_Res__c brandingUtility = new Boca_Res__c();
        brandingUtility.Email_Template_ID__c = '00X70000001EfPG';
        brandingUtility.Brand_Heading__c = 'Test Heading';
        brandingUtility.Brand_Tagline__c = 'Test Tagline';
        brandingUtility.ISO_code__c = 'en_us';
        brandingUtility.Program__c = program.id;
        brandingUtility.Side_Panel_Title__c = 'Test Sidebar Title';
        brandingUtility.SideBar__c = 'Test Sidebar';
        brandingUtility.Program_Name__c = program.Name;
        brandingUtility.Name = 'test';
        brandingUtility.Program_Sell_Sheets__c = 'www.sellsheet.com';
        
        insert brandingUtility;

        WexProgramUtility wpu = new WexProgramUtility();
        
        System.assert(wpu.hasAnotherDefaultTermsAndConditionsSet(campaignProgram) == false);
        System.assert(wpu.isDefault(campaignProgram) == true);
        System.assert(wpu.hasDefaultTermsAndConditions(program.Id) == true);
        
        return program;
        
    }
    
    static testMethod void BOCATest() {

        User CreditUser = [SELECT Id FROM User WHERE Name = 'CreditApplication Site Guest User'];
        
        System.debug('Found Credit User: ' + CreditUser.Id);
        
        System.runAs(CreditUser) {

        	Program__c program = setupProgram();
            
	        Test.startTest();
    	    
            // Test with no program passed in
		    PageReference wexBOCA = Page.WexBOCA;
        	
        	TestUtils.enable_isRunningTest = true;
        
        	Test.setCurrentPage(wexBOCA);
        
        	WexBOCAController wbc = new WexBOCAController();
        
        	PageReference errorPage = wbc.init();
        
        	System.assert(errorPage != null);
            
            // Test with non-existent program passed in
		    wexBOCA = Page.WexBOCA;
            wexBOCA.getParameters().put('pgm', 'someProgram');
        
        	Test.setCurrentPage(wexBOCA);
            
        	errorPage = wbc.init();
        
        	System.assert(errorPage != null);
	
            // Test with a non-published program passed in
            wexBOCA = Page.WexBOCA;
        	wexBOCA.getParameters().put('pgm', program.Brand_Short_Name__c);
            
            Test.setCurrentPage(wexBOCA);
            
            errorPage = wbc.init();
            
            System.assert(errorPage != null);
            
            // Publish the BOCA
            program.BOCA_Type__c = 'Fuel Card';
            program.Publish_BOCA__c = true;
        	upsert program;
            
            WexProgramUtility wpu = new WexProgramUtility();
            System.assert(wpu.isPublished(program.Id) == true);
            
            // Test with non-existant BOCA to Prospect
            wexBOCA = Page.WexBOCA;
        	wexBOCA.getParameters().put('pgm', program.Brand_Short_Name__c);
            wexBOCA.getParameters().put('priority', 'true');
            wexBOCA.getParameters().put('customer', '0000');
            
            Test.setCurrentPage(wexBOCA);
            
            errorPage = wbc.init();
            
            System.assert(errorPage != null);
            
            // Test with a published BOCA
            wexBOCA = Page.WexBOCA;
        	wexBOCA.getParameters().put('pgm', program.Brand_Short_Name__c);
        	wexBOCA.getParameters().put('pg', 'a');
        	wexBOCA.getParameters().put('cc', 'TEST1');
            wexBOCA.getParameters().put('lang', 'en_us');
            wexBOCA.getParameters().put('salescode', 'TEST1');
            wexBOCA.getParameters().put('leadId', '0');
            
            Test.setCurrentPage(wexBOCA);
            
            wbc.init();

            System.assert(wbc.isPartial == false);
        	System.assert(wbc.isPreview == false);
        	System.assert(wbc.isPG == true);
        	System.assert(wbc.partialCustomer == null);
			System.assert(wbc.brandingLogo != null);
			System.assert(wbc.brandingCard != null);
            System.assert(wbc.leadIdParameter != null);
            System.assert(wbc.passedInLead == null);
            System.assert(wbc.disclaimer != null);
            System.assert(wbc.termsAndConditions != null);
            
    	    wbc.creditApp.Email__c = 'testBoca@wexinc.com';
			wbc.creditApp.First_Name__c = 'Test';
			wbc.creditApp.Last_Name__c = 'Test';
			wbc.creditApp.Business_Phone__c = '207555555';
			wbc.creditApp.Company_Name__c = 'Test Company';
			wbc.creditApp.Doing_Business_As__c = 'Test Company';
			wbc.creditApp.Fleet_Size__c = 20;
			wbc.creditApp.Years_in_Business__c = 'Years';
            
            wbc.createLead();
            
            System.assert(wbc.currentStep == 1);
            
            wbc.creditApp.Years_in_Business__c = '1';
	        
	        wbc.createLead();
	
    	    System.assert(wbc.currentStep == 2);
        	
			wbc.creditApp.Business_Street_Address__c = '123 Darling Ave';
			wbc.creditApp.Address_Line_2__c = 'Suite 2';
			wbc.creditApp.City__c = 'South Portland';
			wbc.creditApp.State__c = 'ME';
			wbc.creditApp.Zip_code__c = '04106';

			wbc.creditApp.Legal_Structure__c = 'Corporation';
			wbc.creditApp.Taxpayer_ID__c = '000000000';
			wbc.creditApp.Avg_Monthly_Fuel_Service_Expenses__c = 22222.00;
			wbc.creditApp.Is_business_exempt_from_Motor_Fuels_Tax__c = 'Yes';
			wbc.creditApp.Fiscal_Year_Starts__c = 'January';

			wbc.creditApp.PG_SSN__c = '000-00-0000';
			wbc.creditApp.Date_of_Birth__c = '1/1/1986';
			wbc.creditApp.Guarantor_Annual_Income__c = 22222.00;
			wbc.creditApp.PG_Residential_Phone__c = '2075555555';
			wbc.creditApp.PG_Residential_Street_Address__c = '123 Darling Ave';
			wbc.creditApp.PG_Residential_City__c = 'South Portand';
			wbc.creditApp.PG_Residential_State__c = 'ME';
			wbc.creditApp.PG_Residential_Zip__c = '04106';
        
	        wbc.submitApplication();
        
			System.assert(wbc.creditApp.Id != null);
            
            wexBOCA = Page.WexBOCA;
        	wexBOCA.getParameters().put('pgm', program.Brand_Short_Name__c);
        	wexBOCA.getParameters().put('customer', wbc.creditApp.Id);
            wexBOCA.getParameters().put('priority', 'true');
        	
            Test.setCurrentPage(wexBOCA);
            
			errorPage = wbc.init();
            
            System.assert(errorPage != null);

        	PageReference WexBOCAConfirmation = Page.WexBOCAConfirmation;
        	WexBOCAConfirmation.getParameters().put('pgm', program.Brand_Short_Name__c);
        	WexBOCAConfirmation.getParameters().put('id', wbc.creditApp.Id);
        	WexBOCAConfirmation.getParameters().put('lang', 'en_us');
	
			Test.setCurrentPage(WexBOCAConfirmation);  
	        
    	    WexBOCAConfirmationController wbcc = new WexBOCAConfirmationController();
        	
        	wbcc.init();
        
        	System.assert(wbcc.brandingLogo != null);
        	System.assert(wbcc.brandingCard != null);
        
        	PageReference WexBOCAError = Page.WexBOCAError;
        	WexBOCAError.getParameters().put('errorCode', '1');
            WexBOCAError.getParameters().put('errorReferenceNumber', '1');
            WexBOCAError.getParameters().put('pgm', program.Brand_Short_Name__c);
	        
    	    Test.setCurrentPage(WexBOCAError); 

        	WexBOCAErrorController wbec = new WexBOCAErrorController();
        
    	    System.assert(wbec.languageCode != null);
            System.assert(wbec.errorCode != null);
            System.assert(wbec.errorReferenceNumber != null);
            System.assert(wbec.programParameter != null);
            System.assert(wbec.program != null);
        
	        // Test error forwarding from confirmation page
    	    PageReference wexBOCAConfirmationError = Page.WexBOCAConfirmation;
        	
        	Test.setCurrentPage(wexBOCAConfirmationError);
        
        	wbcc = new WexBOCAConfirmationController();
        
	        wbcc.init();
        
    	    Test.stopTest();
            
        }
        
    }

    static testMethod void IndividualBOCATest() {

        User CreditUser = [SELECT Id FROM User WHERE Name = 'CreditApplication Site Guest User'];

        System.debug('Found Credit User: ' + CreditUser.Id);

        System.runAs(CreditUser) {

            Program__c program = setupProgram();

            Test.startTest();

            // Test with no program passed in
            PageReference individualBOCA = Page.IndividualBOCA;

            TestUtils.enable_isRunningTest = true;

            Test.setCurrentPage(individualBOCA);

            WexConsumerController wexConsumerController = new WexConsumerController();

            PageReference errorPage = wexConsumerController.init();

            System.assert(errorPage != null);

            // Test with non-existent program passed in
            individualBOCA = Page.WexBOCA;
            individualBOCA.getParameters().put('pgm', 'someProgram');

            Test.setCurrentPage(individualBOCA);

            errorPage = wexConsumerController.init();

            System.assert(errorPage != null);

            // Test with a non-published program passed in
            individualBOCA = Page.WexBOCA;
            individualBOCA.getParameters().put('pgm', program.Brand_Short_Name__c);

            Test.setCurrentPage(individualBOCA);

            errorPage = wexConsumerController.init();

            System.assert(errorPage != null);

            // Publish the BOCA
            program.BOCA_Type__c = 'Fuel Card';
            program.Publish_BOCA__c = true;
            upsert program;

            // Test with non-existant BOCA to Prospect
            individualBOCA = Page.WexBOCA;
            individualBOCA.getParameters().put('pgm', program.Brand_Short_Name__c);
            individualBOCA.getParameters().put('priority', 'true');
            individualBOCA.getParameters().put('customer', '0000');

            Test.setCurrentPage(individualBOCA);

            errorPage = wexConsumerController.init();

            System.assert(errorPage != null);

            // Test with a published BOCA
            individualBOCA = Page.WexBOCA;
            individualBOCA.getParameters().put('pgm', program.Brand_Short_Name__c);
            individualBOCA.getParameters().put('pg', 'a');
            individualBOCA.getParameters().put('cc', 'TEST1');
            individualBOCA.getParameters().put('lang', 'en_us');
            individualBOCA.getParameters().put('salescode', 'TEST1');
            individualBOCA.getParameters().put('leadId', '0');

            Test.setCurrentPage(individualBOCA);

            wexConsumerController.init();

            System.assert(wexConsumerController.isPartial == false);
            System.assert(wexConsumerController.isPreview == false);
            System.assert(wexConsumerController.partialCustomer == null);
            System.assert(wexConsumerController.brandingLogo != null);
            System.assert(wexConsumerController.brandingCard != null);
            System.assert(wexConsumerController.disclaimer != null);
            System.assert(wexConsumerController.termsAndConditions != null);

            wexConsumerController.creditApp.Email__c = 'testBoca@wexinc.com';
            wexConsumerController.creditApp.First_Name__c = 'Test';
            wexConsumerController.creditApp.Last_Name__c = 'Test';
            wexConsumerController.creditApp.Business_Phone__c = '207555555';
            wexConsumerController.creditApp.Company_Name__c = 'Test Company';
            wexConsumerController.creditApp.Doing_Business_As__c = 'Test Company';
            wexConsumerController.creditApp.Fleet_Size__c = 20;
            wexConsumerController.creditApp.Years_in_Business__c = 'Years';
            wexConsumerController.creditApp.Years_in_Business__c = '1';
            wexConsumerController.creditApp.Business_Street_Address__c = '123 Darling Ave';
            wexConsumerController.creditApp.Address_Line_2__c = 'Suite 2';
            wexConsumerController.creditApp.City__c = 'South Portland';
            wexConsumerController.creditApp.State__c = 'ME';
            wexConsumerController.creditApp.Zip_code__c = '04106';

            wexConsumerController.creditApp.Legal_Structure__c = 'Corporation';
            wexConsumerController.creditApp.Taxpayer_ID__c = '000000000';
            wexConsumerController.creditApp.Avg_Monthly_Fuel_Service_Expenses__c = 22222.00;
            wexConsumerController.creditApp.Is_business_exempt_from_Motor_Fuels_Tax__c = 'Yes';
            wexConsumerController.creditApp.Fiscal_Year_Starts__c = 'January';

            wexConsumerController.creditApp.PG_SSN__c = '000-00-0000';
            wexConsumerController.creditApp.Date_of_Birth__c = '1/1/1986';
            wexConsumerController.creditApp.Guarantor_Annual_Income__c = 22222.00;
            wexConsumerController.creditApp.PG_Residential_Phone__c = '2075555555';
            wexConsumerController.creditApp.PG_Residential_Street_Address__c = '123 Darling Ave';
            wexConsumerController.creditApp.PG_Residential_City__c = 'South Portand';
            wexConsumerController.creditApp.PG_Residential_State__c = 'ME';
            wexConsumerController.creditApp.PG_Residential_Zip__c = '04106';

            wexConsumerController.submitApplication();

            System.assert(wexConsumerController.creditApp.Id != null);

            individualBOCA = Page.WexBOCA;
            individualBOCA.getParameters().put('pgm', program.Brand_Short_Name__c);
            individualBOCA.getParameters().put('customer', wexConsumerController.creditApp.Id);
            individualBOCA.getParameters().put('priority', 'true');

            Test.setCurrentPage(individualBOCA);

            errorPage = wexConsumerController.init();

            System.assert(errorPage != null);

            PageReference WexBOCAConfirmation = Page.WexBOCAConfirmation;
            WexBOCAConfirmation.getParameters().put('pgm', program.Brand_Short_Name__c);
            WexBOCAConfirmation.getParameters().put('id', wexConsumerController.creditApp.Id);
            WexBOCAConfirmation.getParameters().put('lang', 'en_us');

            Test.setCurrentPage(WexBOCAConfirmation);

            WexBOCAConfirmationController wexBOCAConfirmationController = new WexBOCAConfirmationController();

            wexBOCAConfirmationController.init();

            System.assert(wexBOCAConfirmationController.brandingLogo != null);
            System.assert(wexBOCAConfirmationController.brandingCard != null);
            
            wexBOCAConfirmationController.checkStatusOfApplication();

            Test.stopTest();

        }

    }

	static testMethod void RevolverBOCATest() {

        User CreditUser = [SELECT Id FROM User WHERE Name = 'CreditApplication Site Guest User'];
        
        System.debug('Found Credit User: ' + CreditUser.Id);
        
        System.runAs(CreditUser) {

        	Program__c program = setupProgram();
            
            program.Upload_Pricing_Data_Flag__c = true;
            program.Publish_BOCA__c = true;
            program.BOCA_Type__c = 'Revolver Card';
            
            upsert program;
            
	        Test.startTest();
        	
        	TestUtils.enable_isRunningTest = true;
        
        	WexBOCAController wbc = new WexBOCAController();

            // Test with a published BOCA
            PageReference wexBOCA = Page.WexBOCA;
        	wexBOCA.getParameters().put('pgm', program.Brand_Short_Name__c);
        	wexBOCA.getParameters().put('cc', 'TEST1');
            wexBOCA.getParameters().put('lang', 'en_us');
            wexBOCA.getParameters().put('salescode', 'TEST1');
            wexBOCA.getParameters().put('leadId', '0');
            
            Test.setCurrentPage(wexBOCA);
            
            wbc.init();

            System.assert(wbc.isPartial == false);
        	System.assert(wbc.isPreview == false);
        	System.assert(wbc.isPG == true);
        	System.assert(wbc.partialCustomer == null);
			System.assert(wbc.brandingLogo != null);
			System.assert(wbc.brandingCard != null);
            System.assert(wbc.leadIdParameter != null);
            System.assert(wbc.passedInLead == null);
            System.assert(wbc.statementAndReportDeliveryOptions != null);
            
    	    wbc.creditApp.Email__c = 'testBoca@wexinc.com';
			wbc.creditApp.First_Name__c = 'Test';
			wbc.creditApp.Last_Name__c = 'Test';
			wbc.creditApp.Business_Phone__c = '207555555';
			wbc.creditApp.Company_Name__c = 'Test Company';
			wbc.creditApp.Doing_Business_As__c = 'Test Company';
			wbc.creditApp.Fleet_Size__c = 20;
			wbc.creditApp.Years_in_Business__c = 'Years';
            
            wbc.createLead();
            
            System.assert(wbc.currentStep == 1);
            
            wbc.creditApp.Years_in_Business__c = '1';
	        
	        wbc.createLead();
	
    	    System.assert(wbc.currentStep == 2);
        	
			wbc.creditApp.Business_Street_Address__c = '123 Darling Ave';
			wbc.creditApp.Address_Line_2__c = 'Suite 2';
			wbc.creditApp.City__c = 'South Portland';
			wbc.creditApp.State__c = 'ME';
			wbc.creditApp.Zip_code__c = '04106';

			wbc.creditApp.Legal_Structure__c = 'Corporation';
			wbc.creditApp.Taxpayer_ID__c = '000000000';
			wbc.creditApp.Avg_Monthly_Fuel_Service_Expenses__c = 22222.00;
			wbc.creditApp.Is_business_exempt_from_Motor_Fuels_Tax__c = 'Yes';
			wbc.creditApp.Fiscal_Year_Starts__c = 'January';
            wbc.creditApp.Paperless_Flag__c = 'Yes';
            wbc.creditApp.Annual_Gross_Revenue__c = 22222.00;
            wbc.creditApp.DUNS_Number__c = '123456789';

			wbc.creditApp.PG_SSN__c = '000-00-0000';
			wbc.creditApp.Date_of_Birth__c = '1/1/1986';
			wbc.creditApp.Guarantor_Annual_Income__c = 22222.00;
			wbc.creditApp.PG_Residential_Phone__c = '2075555555';
			wbc.creditApp.PG_Residential_Street_Address__c = '123 Darling Ave';
			wbc.creditApp.PG_Residential_City__c = 'South Portand';
			wbc.creditApp.PG_Residential_State__c = 'ME';
			wbc.creditApp.PG_Residential_Zip__c = '04106';
        
	        wbc.submitApplication();
        
			System.assert(wbc.creditApp.Id != null);
        
    	    Test.stopTest();
            
        }
        
    }
    
}