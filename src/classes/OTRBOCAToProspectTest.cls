@isTest
public class OTRBOCAToProspectTest {
    
    @testSetup 
    static void setupData(){
        
        // Revisit this later..
        BOCA_IDS__C bocaId = BOCAtestDataUtility.getBOCAids();
        insert bocaId;
        
        Account offerAccount = new Account();
        offerAccount.Name ='TestAccount-01';
        
        insert offerAccount;
        
        OnlineApplicationOffer__c onlineApplicationOffer = new OnlineApplicationOffer__c();
        onlineApplicationOffer.Name = 'TestOffer-01';
        onlineApplicationOffer.Application_Title__c = 'TestTitle';
        onlineApplicationOffer.Complete_Later_Text__c = 'Test';
        onlineApplicationOffer.EchoSign_User_Email__c = 'test@test.com';
        onlineApplicationOffer.Terms_and_Conditions_Version__c = 'TestVersion-01';
        onlineApplicationOffer.BOCA_Default_Offer__c = true;
        onlineApplicationOffer.Disclosure__c = 'Test';
        
        insert onlineApplicationOffer;
        
        Program__c program = new Program__c();
        
        program.Name = 'OTRTestBOCA';
        program.Form_Template__c = 'OTRBOCA';
        program.Brand_Short_Name__c = 'OTR';
        program.Preferred_Language_Indicator__c = 'ENU';
        program.Custom_Email_Header_URL__c = 'http://www.wexhosted.com/email/revolver/header_wexRevolver.jpg';
        program.Brand_Heading__c = 'Time is money. Use WEX and save both.';
        program.Brand_Long_Name__c = 'OTR Test BOCA';
        program.Upload_Pricing_Data_Flag__c = false;
        program.Auto_Send_BOCA_to_Siebel__c = false;
        program.T_C__c = 'WEX_BOCA_TNC';
        program.Analytics_Body_Block__c = '';
        program.Analytics_Head_Block__c = '';
        program.Brand_Color_1__c = '#ccc';
        program.Brand_Color_2__c = '#fff';
        program.BOCA_Type__c = 'OTR';
        
        insert program;
        
        onlineApplicationOffer.Program__c = program.Id;
        
        upsert onlineApplicationOffer;
        
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
        
        Boca_Res__c brandingUtility = new Boca_Res__c();
        brandingUtility.Email_Template_ID__c = '00X70000001EfPG';
        brandingUtility.Brand_Heading__c = 'OTR Test Heading';
        brandingUtility.Brand_Tagline__c = 'OTR Test Tagline';
        brandingUtility.ISO_code__c = 'en_us';
        brandingUtility.Program__c = program.id;
        brandingUtility.Side_Panel_Title__c = 'OTR Test Sidebar Title';
        brandingUtility.SideBar__c = 'OTR Test Sidebar';
        brandingUtility.Program_Name__c = program.Name;
        brandingUtility.Name = 'OTRTest';
        brandingUtility.Program_Sell_Sheets__c = 'www.sellsheet.com';
        
        insert brandingUtility;
        
        PostCode__c postalCode = new PostCode__c();
        postalCode.State__c = 'ME';
        postalCode.Postcode__c = '4106';
        insert postalCode;
        
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'IS Sales']; 
        
        User user = new User(Alias = 'tUse', Email='stanTestuser@wexinc.com', 
                             EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', ProfileId = profile.Id, 
                             TimeZoneSidKey='America/Los_Angeles', UserName='stanarduser@wexinc.com');
        
        insert user;
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(user) {
            
            Id recordTypeId = Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('Fleet Card').getRecordTypeId();
            
            Opportunity opportunity = new Opportunity();
            
            opportunity.Name = 'TestOpp';
            opportunity.CloseDate = Date.newinstance(2099,1,1);
            opportunity.StageName = '1) Qualified';
            opportunity.Fleet_Size__c = 10;
            opportunity.OwnerId = user.Id;
            opportunity.SourceSystem__c = 'test';
            opportunity.RecordTypeId = recordTypeId;
            opportunity.Fueling_Methos__c = 'BP';
            opportunity.Number_of_18_Wheelers__c = 10;
            opportunity.F1_Account__c = '123456';
            
            insert opportunity;
            
            Contact contact = new Contact();
            
            contact.FirstName = 'Tester';
            contact.LastName = 'Tester Last';
            contact.Email = 'Tester@UnitTest.com';
            
            insert contact;
            
            OpportunityContactRole opportunityContact = new OpportunityContactRole(contactId = contact.id, isPrimary = true, OpportunityId = opportunity.id);
            
            insert opportunityContact;
            
        }
        
    }
    
    @isTest
    static void testBOCAToProspectErrorHandler() {
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
            
            Test.startTest();
            
            TestUtils.enable_isRunningTest = true;
            
            Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'TestOpp'];
            
            // Test without opportunity to test error handling
            PageReference otrBocaToProspectPage = Page.OTRBOCAToProspect;
            otrBocaToProspectPage.getParameters().put('id', '');
            Test.setCurrentPage(otrBocaToProspectPage);
            
            Apexpages.StandardController standardController = new ApexPages.StandardController(opportunity);
            OTRBOCAToProspectController otrBocaToProspectController = new OTRBOCAToProspectController(standardController);
            
            otrBocaToProspectController.init();
            
            System.assertEquals(true, otrBocaToProspectController.hasError);
            
            Test.stopTest();
            
        }
        
    }
    
    @isTest
    static void testBOCAToProspect() {
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
            
            Test.startTest();
            
            TestUtils.enable_isRunningTest = true;
            
            Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'TestOpp'];
            
            // Test with opportunity
            PageReference otrBocaToProspectPage = Page.OTRBOCAToProspect;
            otrBocaToProspectPage.getParameters().put('id', opportunity.Id);
            Test.setCurrentPage(otrBocaToProspectPage);
            
            Apexpages.StandardController standardController = new ApexPages.StandardController(opportunity);
            OTRBOCAToProspectController otrBocaToProspectController = new OTRBOCAToProspectController(standardController);
            
            otrBocaToProspectController.init();
            
            System.assert(otrBocaToProspectController.availablePrograms != null);
            System.assert(otrBocaToProspectController.availableOffers != null);
            
            Program__c program = [SELECT Id FROM Program__c LIMIT 1];
            
            OnlineApplicationOffer__c offer = [SELECT Id FROM OnlineApplicationOffer__c WHERE Program__c =: program.Id LIMIT 1];
            
            otrBOCAToProspectController.selectedProgram = program.Id;
            otrBOCAToProspectController.selectedOffer = offer.Id;
            
            URLgenAttachmentLookupController ugalc = new URLgenAttachmentLookupController();
            System.assert(ugalc.folders != null);
            ugalc.displayDocuments();
            ugalc.clearSearch();
            
            Document tempDocument = new Document();
            tempDocument.Name = 'info.pdf';
            Blob tempDocumentBlob = Blob.valueOf('Unit Test Attachment Body');
            tempDocument.body = tempDocumentBlob;
            tempDocument.FolderId = UserInfo.getUserId();
            insert tempDocument;
            
            otrBocaToProspectController.attachments = '["' + tempDocument.Id + '"]';

            PageReference otrBocaToProspectRedirect = otrBocaToProspectController.bocaToProspect();

            System.assertNotEquals(null, otrBocaToProspectController.salesRepName);
            System.assertNotEquals(null, otrBocaToProspectController.resend);

            otrBocaToProspectController.resendBOCAToProspect(); 
            
            // Test the components
            OTRBOCAToProspectComponentController otrBocaToProspectComponentController = new OTRBOCAToProspectComponentController();
            
            otrBocaToProspectComponentController.bocaToProspectId = otrBocaToProspectController.bocaToProspect.Id;
            
            //System.assertNotEquals(null, otrBocaToProspectComponentController.bocaToProspect);
            //System.assertNotEquals(null, otrBocaToProspectComponentController.primaryBrandingCard);
            //System.assertNotEquals(null, otrBocaToProspectComponentController.pgValue);
            //System.assertNotEquals(null, otrBocaToProspectComponentController.primaryBrandingUtility);
            
            // Test the reminder function
            otrBocaToProspectPage = Page.OTRBOCAToProspect;
            otrBocaToProspectPage.getParameters().put('bocaToProspectId', otrBocaToProspectController.bocaToProspect.Id);
            Test.setCurrentPage(otrBocaToProspectPage);
            
            otrBocaToProspectController.init();
            
            otrBocaToProspectRedirect = otrBocaToProspectController.bocaToProspectReminder();
            
            Test.stopTest();
            
        }
        
    }
    
}