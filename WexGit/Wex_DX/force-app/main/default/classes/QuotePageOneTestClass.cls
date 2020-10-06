@isTest(SeeAllData=true)
public class QuotePageOneTestClass {
    
    
    //Null opp and quote
    //Test instantiate controller
    public static testMethod void testnoOppnoQuoteQuote(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        ApexPages.currentPage().getParameters().put('quoteid', null);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
    }
    
    //Null quote
    //Test instantiate controller
    public static testMethod void testNewOppNoQuote(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        insert opp;
        //Testing if ID is on controller
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        ApexPages.currentPage().getParameters().put('quoteid', null);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', 'Y');
        
        prepQuoteController = new PrepareNewQuoteController(sc);
    }
    
    //Test instantiate controller with previously created quote
    public static testMethod void testPreviouslyMadeQuote(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias='testU', Email='standarduser@testorg.com', LastName='Testing', ProfileId=p.Id, UserName='standarduser@test.org.com',
                         TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey='en_US',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US');
        insert u;
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today(),Owner=u);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        
        insert quote;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', 'Y');
        
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
    }
    
    //Test goNewQuote method
    public static testMethod void testGoNewQuote(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
        
        prepQuoteController.shipAddress1='3525 Piedmont Rd NE';
        prepQuoteController.shipAddress2='';
        prepQuoteController.shipCity='Atlanta';
        prepQuoteController.shipState='GA';
        prepQuoteController.shipZipCode='30305';
        prepQuoteController.shipContactName='A';
        prepQuoteController.shipContactPhone='0';
        prepQuoteController.shipContactEmail='g@gmail.com';
        
        prepQuoteController.addShippingAddress();
        
        prepQuoteController.goNewQuote();
        
        System.assert(prepQuoteController.quoteId != null);
        
        insert quote;
        
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        prepQuoteController = new PrepareNewQuoteController(sc);
        
        prepQuoteController.shipAddress1='3525 Piedmont Rd NE';
        prepQuoteController.shipAddress2='';
        prepQuoteController.shipCity='Atlanta';
        prepQuoteController.shipState='GA';
        prepQuoteController.shipZipCode='30305';
        prepQuoteController.shipContactName='A';
        prepQuoteController.shipContactPhone='0';
        prepQuoteController.shipContactEmail='g@gmail.com';
        
        prepQuoteController.addShippingAddress();
        
        prepQuoteController.goNewQuote();
    }
    
    //Test createAccount method
    public static testMethod void testCreateAccount(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
        
        System.assert(prepQuoteController.createAccount() == null);
    }
    
    //TODO testing case
    public static testMethod void testAddAndValidateShippingAddress(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        insert opp;
        
        zqu__Quote__c quote = createQuote();
            
        insert quote;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
        
        prepQuoteController.shipAddress1='';
        prepQuoteController.shipCity='';
        prepQuoteController.shipState='';
        prepQuoteController.shipZipCode='';
        prepQuoteController.shipContactName='';
        prepQuoteController.shipContactPhone='';
        prepQuoteController.shipContactEmail='';
        
        prepQuoteController.addAndValidateShippingAddress();
        
        prepQuoteController.shipAddress1='3525 Piedmont Rd NE';
        prepQuoteController.shipAddress2='';
        prepQuoteController.shipCity='Atlanta';
        prepQuoteController.shipState='GA';
        prepQuoteController.shipZipCode='30305';
        prepQuoteController.shipContactName='A';
        prepQuoteController.shipContactPhone='0';
        prepQuoteController.shipContactEmail='g';
        
        prepQuoteController.addAndValidateShippingAddress();
        
        prepQuoteController.shipAddress1='PO BOX 3';
        prepQuoteController.shipAddress2='';
        prepQuoteController.shipCity='Atlanta';
        prepQuoteController.shipState='GA';
        prepQuoteController.shipZipCode='30305';
        prepQuoteController.shipContactName='A';
        prepQuoteController.shipContactPhone='0';
        prepQuoteController.shipContactEmail='g@gmail.com';
        
        prepQuoteController.addAndValidateShippingAddress();
        
        /*Have not validated this case requires some set up //TODO
         * prepQuoteController.shipAddress1='3525 Piedmont Rd NE';
        prepQuoteController.shipAddress2='';
        prepQuoteController.shipCity='Atlanta';
        prepQuoteController.shipState='GA';
        prepQuoteController.shipZipCode='30305';
        prepQuoteController.shipContactName='A';
        prepQuoteController.shipContactPhone='0';
        prepQuoteController.shipContactEmail='g@gmail.com';
        
        prepQuoteController.addAndValidateShippingAddress();*/
        
    }
    
    public static testMethod void testAddShippingAddress(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        
        insert quote;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
        
        prepQuoteController.shipAddress1='3525 Piedmont Rd NE';
        prepQuoteController.shipAddress2='';
        prepQuoteController.shipCity='Atlanta';
        prepQuoteController.shipState='GA';
        prepQuoteController.shipZipCode='30305';
        prepQuoteController.shipContactName='A';
        prepQuoteController.shipContactPhone='0';
        prepQuoteController.shipContactEmail='g@gmail.com';
        
        prepQuoteController.addShippingAddress();
        
        prepQuoteController.shipAddress1='3526 Piedmont Rd NE';
        prepQuoteController.shipAddress2='';
        prepQuoteController.shipCity='Atlanta';
        prepQuoteController.shipState='GA';
        prepQuoteController.shipZipCode='30306';
        prepQuoteController.shipContactName='B';
        prepQuoteController.shipContactPhone='1';
        prepQuoteController.shipContactEmail='h@gmail.com';
        
        prepQuoteController.addShippingAddress();
    }
    
    public static testMethod void testGetIndexes(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        
        insert quote;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
        
        prepQuoteController.getIndexes();
        
        prepQuoteController.shipAddress1='3525 Piedmont Rd NE';
        prepQuoteController.shipAddress2='';
        prepQuoteController.shipCity='Atlanta';
        prepQuoteController.shipState='GA';
        prepQuoteController.shipZipCode='30305';
        prepQuoteController.shipContactName='A';
        prepQuoteController.shipContactPhone='0';
        prepQuoteController.shipContactEmail='g@gmail.com';
        
        prepQuoteController.addShippingAddress();
        
        prepQuoteController.getIndexes();
    }
    
    public static testMethod void testClear(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        
        insert quote;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
        
        prepQuoteController.shipAddress1='3525 Piedmont Rd NE';
        prepQuoteController.shipAddress2='';
        prepQuoteController.shipCity='Atlanta';
        prepQuoteController.shipState='GA';
        prepQuoteController.shipZipCode='30305';
        prepQuoteController.shipContactName='A';
        prepQuoteController.shipContactPhone='0';
        prepQuoteController.shipContactEmail='g@gmail.com';
        
        prepQuoteController.addShippingAddress();
        
        prepQuoteController.clear();
    }
    
    public static testMethod void testGoNextPage(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        
        insert quote;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
        
        prepQuoteController.goNextPage();
        
        prepQuoteController.shipAddress1='3525 Piedmont Rd NE';
        prepQuoteController.shipAddress2='';
        prepQuoteController.shipCity='Atlanta';
        prepQuoteController.shipState='GA';
        prepQuoteController.shipZipCode='30305';
        prepQuoteController.shipContactName='A';
        prepQuoteController.shipContactPhone='0';
        prepQuoteController.shipContactEmail='g@gmail.com';
        
        prepQuoteController.addShippingAddress();
        
         //Need test case were able to continue
        
        
        prepQuoteController.goNextPage();
         
        
    }
    
    public static testMethod void testSave(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        
        insert quote;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
        
        prepQuoteController.save();
        
        prepQuoteController.shipAddress1='3525 Piedmont Rd NE';
        prepQuoteController.shipAddress2='';
        prepQuoteController.shipCity='Atlanta';
        prepQuoteController.shipState='GA';
        prepQuoteController.shipZipCode='30305';
        prepQuoteController.shipContactName='A';
        prepQuoteController.shipContactPhone='0';
        prepQuoteController.shipContactEmail='g@gmail.com';
        
        prepQuoteController.addShippingAddress();
        
        prepQuoteController.save();
         
        //Need test case were able to continue
    }
    
    public static testMethod void testRequestForCheck(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        
        insert quote;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
        
        prepQuoteController.requestForCheck();
        
        prepQuoteController.shipAddress1='3525 Piedmont Rd NE';
        prepQuoteController.shipAddress2='';
        prepQuoteController.shipCity='Atlanta';
        prepQuoteController.shipState='GA';
        prepQuoteController.shipZipCode='30305';
        prepQuoteController.shipContactName='A';
        prepQuoteController.shipContactPhone='0';
        prepQuoteController.shipContactEmail='g@gmail.com';
        
        prepQuoteController.addShippingAddress();
        
        prepQuoteController.requestForCheck();
        
        prepQuoteController.useSecondaryAccount = true;
        
        prepQuoteController.requestForCheck();
        
        prepQuoteController.isEditingLocation = true;
        
        prepQuoteController.requestForCheck();
    }
    
    public static testMethod void testConfirmShippingDeletion(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        
        insert quote;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
                
        prepQuoteController.confirmShippingDeletion();
         
    }
    
    public static testMethod void testEditShippingLocation(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        
        insert quote;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
         
        prepQuoteController.shipAddress1='3525 Piedmont Rd NE';
        prepQuoteController.shipAddress2='';
        prepQuoteController.shipCity='Atlanta';
        prepQuoteController.shipState='GA';
        prepQuoteController.shipZipCode='30305';
        prepQuoteController.shipContactName='A';
        prepQuoteController.shipContactPhone='0';
        prepQuoteController.shipContactEmail='g@gmail.com';
        
        prepQuoteController.addShippingAddress();
         
        prepQuoteController.shipmentIndex = 0;
                
        prepQuoteController.editShippingLocation();
         
    }
    
    public static testMethod void testValidUntilNotification(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        
        insert quote;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
         
        prepQuoteController.validUntilNotification();
         
    }
    
    public static testMethod void testCancelConfirm(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        
        insert quote;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
         
        prepQuoteController.cancelConfirm();
         
    }
    
    public static testMethod void testCancelQuote(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        
        insert quote;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
         
        prepQuoteController.cancelQuote();
         
    }
    
    public static testMethod void testDeleteShippingLocation(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        
        insert quote;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
         
        prepQuoteController.shipAddress1='3525 Piedmont Rd NE';
        prepQuoteController.shipAddress2='';
        prepQuoteController.shipCity='Atlanta';
        prepQuoteController.shipState='GA';
        prepQuoteController.shipZipCode='30305';
        prepQuoteController.shipContactName='A';
        prepQuoteController.shipContactPhone='0';
        prepQuoteController.shipContactEmail='g@gmail.com';
        
        prepQuoteController.addShippingAddress();
         
        prepQuoteController.shipmentIndex = 0;
                
        prepQuoteController.deleteShippingLocation();
         
    }
    
    public static testMethod void testCheckFields(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        
        insert quote;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
         
        prepQuoteController.checkFields();
          
    }
    
    public static testMethod void testCreateWarning(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        
        insert quote;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
         
        prepQuoteController.createWarning();
          
    }
    
    public static testMethod void testShowFuelTaxWarningForPrimary(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        
        insert quote;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
         
        prepQuoteController.primaryFuelTaxExempt = 'Qualified';
         
        prepQuoteController.showFuelTaxWarningForPrimary();
          
    }
    
    public static testMethod void testShowFuelTaxWarningForSecondary(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        
        insert quote;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
         
        prepQuoteController.secondaryFuelTaxExempt = 'Qualified';
         
        prepQuoteController.showFuelTaxWarningForSecondary();
          
    }
    
    public static testMethod void testClearAccount(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        
        insert quote;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
         
        prepQuoteController.clearAccount();
          
    }
    
    public static testMethod void testClearSecondaryAccount(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        
        insert quote;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
         
        prepQuoteController.clearSecondaryAccount();
          
    }
    
    public static testMethod void testConfirmError(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        
        insert quote;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
         
        prepQuoteController.confirmError();
          
    }
    
    public static testMethod void testQuotePage01Variables(){
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        
        insert quote;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        PrepareNewQuoteController prepQuoteController = new PrepareNewQuoteController(sc);
        
        prepQuoteController.shipAddress1='3525 Piedmont Rd NE';
        prepQuoteController.shipAddress2='';
        prepQuoteController.shipCity='Atlanta';
        prepQuoteController.shipState='GA';
        prepQuoteController.shipZipCode='30305';
        prepQuoteController.shipContactName='A';
        prepQuoteController.shipContactPhone='0';
        prepQuoteController.shipContactEmail='g@gmail.com';
        
        prepQuoteController.addShippingAddress();
        
        System.assert(prepQuoteController.opp != null);
        System.assert(prepQuoteController.acc != null);
        System.assert(prepQuoteController.quote != null);
        System.assert(prepQuoteController.quoteId != null);
        System.assert(prepQuoteController.shipAddress1 != null);
        System.assert(prepQuoteController.shipAddress2 != null);
        System.assert(prepQuoteController.shipContactName != null);
        System.assert(prepQuoteController.shipContactPhone != null);
        System.assert(prepQuoteController.shipContactEmail != null);
        System.assert(prepQuoteController.shipCity != null);
        System.assert(prepQuoteController.shipState != null);
        System.assert(prepQuoteController.shipZipCode != null);
        System.assert(prepQuoteController.shipCity != null);
        System.assert(prepQuoteController.shipCity != null);
        
        System.assert((prepQuoteController.salesRep1).size() > 0);
        System.assert((prepQuoteController.salesRep2).size() > 0);
          
        
        System.assert(prepQuoteController.shipments != null);
        System.assert(prepQuoteController.quoteStatus != null);
        DateTime datePrep = DateTime.now();
        System.assertEquals(prepQuoteController.datePrepared, datePrep.format('MM/dd/yy'));
       // System.assert((prepQuoteController.pdfTemplate).isEmpty());
        System.assert((prepQuoteController.promoCode).size() > 0);
        System.assert((prepQuoteController.firstTimeOrderList).size() > 0);
        System.assert((prepQuoteController.TaxExemptTelematics).size() > 0);
        System.assert((prepQuoteController.TelematicsVendor).size() > 0);
    }
    
    public static zqu__Quote__c createQuote(){
        List<Account> vendorAccounts = [Select Id, Name, Vendor_Name__c from Account WHERE Is_Vendor__c = true];
        List<User> users = [Select Id from User];
        zqu__Quote__c quote = new zqu__Quote__c(Name = 'New Quote',
                    isPending__c = false,
                    QuoteNumber__c = '1',
                    zqu__Status__c = 'New',
                    zqu__ValidUntil__c = System.Today(),
                    FirstTimeOrder__c = 'No',
                    DatePrepared__c = System.Today(),
                    PrimaryAccountNumber__c = '1',
                    PrimarySponsor__c = 'a',
                    PrimaryAccountName__c = 'a',
                    PrimarySource__c = 'a',
                    PrimaryCreditLimit__c = '0.00',
                    PrimaryAddress1__c = 'a',
                    PrimaryAddress2__c = 'a',
                    PrimaryCity__c = 'a',
                    PrimaryState__c = 'a',
                    PrimaryZip__c = 'a',
                    PrimaryContact__c = 'a',
                    PrimaryPhone__c = '0',
                    PrimaryEmail__c = 'g@gmail.com',
                    zqu__Tax_Exempt__c = 'No',
                    zqu__Certificate_Id__c = '0',
                    SecondaryAccountNumber__c = 'a',
                    SecondarySponsor__c = 'a',
                    SecondaryAccountName__c = 'a',
                    SecondarySource__c = 'a',
                    SecondaryCreditLimit__c = Decimal.valueOf('0.00'),
                    SecondaryAddress1__c = 'a',
                    SecondaryAddress2__c = 'a',
                    SecondaryCity__c = 'a',
                    SecondaryState__c = 'a',
                    SecondaryZip__c = 'a',
                    SecondaryContact__c = 'a',
                    SecondaryPhone__c = 'a',
                    SecondaryEmail__c = 'g@gmail.com',
                    SecondaryTaxExempt__c = 'No',
                    SecondaryCertificateId__c = 'a',
                    Vendor_Order_Instructions__c = 'a',
                    Internal_Sales_Comments__c = 'a',
                    Vendor_Account__c = vendorAccounts.get(0).Id,
                    SalesRep1__c = users.get(0).Id);
        
        return quote;
    }

}