@isTest(SeeAllData=true)
public class QuotePageTwoTestClass {
	
    //Method tests the instantiation of the controller. no other class functionality
    public static testMethod void testController(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
        
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
        
        System.assert(newQuoteController.quote != null);
        System.assert(newQuoteController.productCounter == 0);
        System.assert((newQuoteController.productsForEachShipment).isEmpty());
        System.assert(newQuoteController.productMapSize == false);
        
        Test.stopTest();
            
        }
    }
    
	//test previously added charges
    public static testMethod void testRecreateProductsForEachShipment(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
            
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        Shipment_Charge_Group__c charge = addShipmentChargeGroup(shipment);
        insert charge;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
        
        System.assert(newQuoteController.quote != null);
        System.assert(newQuoteController.productCounter > 0);
        System.assert(!(newQuoteController.productsForEachShipment).isEmpty());
        System.assert(newQuoteController.productMapSize == true);
        
        System.assert(Integer.valueOf(newQuoteController.QuoteshippingHandling) > 10);
        System.assert(Integer.valueOf(newQuoteController.QuoteoneTimeExpense) == 0);
        System.assert(Integer.valueOf(newQuoteController.QuoterecurringMonthlyExpense) > 0);
        
        Test.stopTest();
            
        }
    }
    
    //test Panelrefresh method
    public static testMethod void testPanelrefresh(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
            
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
        
        newQuoteController.totalPrice = Decimal.valueOf('100.00');
        newQuoteController.paymentTerm = '10';
        newQuoteController.priceUpdateParam = 'monthlyPayment';
        newQuoteController.chosenCategory = 'Hardware';
        
        newQuoteController.panelrefresh();
        
        newQuoteController.priceUpdateParam = 'adjustProductCategory';
        
        newQuoteController.panelrefresh();
        
        newQuoteController.priceUpdateParam = 'adjustProduct';
        
        newQuoteController.panelrefresh();
        
        newQuoteController.chosenCategory = 'Services';
        
        newQuoteController.panelrefresh();
        
        System.assert(newQuoteController.shippingProductChosen == false);
        
        Test.stopTest();
            
        }
    }
    
    //test AddProduct method
    public static testMethod void testAddProductThrowErros(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
            
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        Shipment__c shipment2 = addShippingAddress(quote);
        insert shipment2;
        
        zqu__ZProduct__c product = addZProduct(quote, 'Hardware Category', 'Test Product', '100');
        insert product;
        
        zqu__ProductRatePlan__c prp = addZRatePlan(product, '100');
        insert prp;
        
        zqu__ProductRatePlanCharge__c prpc = addZRatePlanCharge(prp, '100', 'One-Time');
        insert prpc;
        
        zqu__ZProduct__c productShip = addZShippingProduct(quote, 'Shipping', 'Shipping Product', '200');
        insert productShip;
		zqu__ProductRatePlan__c prpShip = addZShippingRatePlan(productShip, '200');
        insert prpShip;        
        zqu__ProductRatePlanCharge__c prpcShip = addZShippingRatePlanCharge(prpShip, '200', 'Shipping', 'One-Time');
        insert prpcShip;
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
        
        Test.startTest();
		
        newQuoteController.addProduct();
        newQuoteController.chosenCategory = 'Hardware Category';
        
        newQuoteController.addProduct();
        newQuoteController.chosenProduct = product.Id;
        
        newQuoteController.addProduct();
        newQuoteController.chosenProdRatePlan = prp.Id;
        
        newQuoteController.addProduct();
        newQuoteController.adjustedUnitCost = '90.00';
        
        newQuoteController.addProduct();
        newQuoteController.quantity = '5';
		
        newQuoteController.addProduct();
        newQuoteController.chosenShipping = (newQuoteController.shippingLocations).get(2).getValue();
        
        newQuoteController.addProduct();
        newQuoteController.chosencourier = prpShip.Name;
        
        newQuoteController.addProduct();
        newQuoteController.chosenShippingService = prpShip.Id;
        
        Test.stopTest();
            
        }
        
    }
    
    //test AddProduct method
    public static testMethod void testAddProduct(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
            
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        Shipment__c shipment2 = addShippingAddress(quote);
        insert shipment2;
        
        zqu__ZProduct__c product = addZProduct(quote, 'Hardware Category', 'Test Product', '100');
        insert product;
        
        zqu__ProductRatePlan__c prp = addZRatePlan(product, '100');
        insert prp;
        
        zqu__ProductRatePlanCharge__c prpc = addZRatePlanCharge(prp, '100', 'One-Time');
        insert prpc;
        
        zqu__ZProduct__c productShip = addZShippingProduct(quote, 'Shipping', 'Shipping Product', '200');
        insert productShip;
		zqu__ProductRatePlan__c prpShip = addZShippingRatePlan(productShip, '200');
        insert prpShip;        
        zqu__ProductRatePlanCharge__c prpcShip = addZShippingRatePlanCharge(prpShip, '200', 'Shipping', 'One-Time');
        insert prpcShip;
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
		
        List<SelectOption> pCategories = newQuoteController.productCategories;
        newQuoteController.chosenCategory = 'Hardware Category';
        
        List<SelectOption> products = newQuoteController.products;
        newQuoteController.chosenProduct = product.Id;
        
        List<SelectOption> ratePlans = newQuoteController.prodRatePlan;
        newQuoteController.chosenProdRatePlan = prp.Id;
        
        newQuoteController.adjustedUnitCost = '90.00';
        newQuoteController.quantity = '5';
		
        Test.startTest();
        
		System.assert(Integer.valueOf(newQuoteController.listUnitCost) == 100);        
        System.assert(Integer.valueOf(newQuoteController.TotalMoPayment) < 500);
        
        System.assert(newQuoteController.discount != null);
        System.assert(newQuoteController.discount != '');
        System.assert(Integer.valueOf(newQuoteController.totalPrice) == 450);
        System.assert(newQuoteController.paymentTerm == '1');
        
        newQuoteController.chosenShipping = (newQuoteController.shippingLocations).get(2).getValue();
        List<zqu__ProductRatePlan__c> shippingRatePlans = newQuoteController.shippingRatePlans;
        List<SelectOption> courier = newQuoteController.courier;
        newQuoteController.chosencourier = prpShip.Name;
        List<SelectOption> shippingService = newQuoteController.shippingService;
        newQuoteController.chosenShippingService = prpShip.Id;
        
        
        
        newQuoteController.addProduct();
        
        System.assert(Integer.valueOf(newQuoteController.QuoteshippingHandling) > 0);
        System.assert(Integer.valueOf(newQuoteController.QuoteoneTimeExpense) > 0);
        System.assert(Integer.valueOf(newQuoteController.QuoterecurringMonthlyExpense) == 0);
        
        Test.stopTest();
        
        //quickAddHardwareProduct(quote,newQuoteController);
        newQuoteController.discount = '20%';
        newQuoteController.refreshUnitCost();
        
        newQuoteController.addProduct();
            
        }
        
    }
    
    //test AddProduct method
    public static testMethod void testAddProduct2(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
            
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        Shipment__c shipment2 = addShippingAddress(quote);
        insert shipment2;
        
        zqu__ZProduct__c product = addZProduct(quote, 'Hardware Category', 'Test Product', '100');
        insert product;
        
        zqu__ProductRatePlan__c prp = addZRatePlan(product, '100');
        insert prp;
        
        zqu__ProductRatePlanCharge__c prpc = addZRatePlanCharge(prp, '100', 'One-Time');
        insert prpc;
        
        zqu__ZProduct__c productShip = addZShippingProduct(quote, 'Shipping', 'Shipping Product', '200');
        insert productShip;
		zqu__ProductRatePlan__c prpShip = addZShippingRatePlan(productShip, '200');
        insert prpShip;        
        zqu__ProductRatePlanCharge__c prpcShip = addZShippingRatePlanCharge(prpShip, '200', 'Shipping', 'One-Time');
        insert prpcShip;
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
		
        List<SelectOption> pCategories = newQuoteController.productCategories;
        newQuoteController.chosenCategory = 'Hardware Category';
        
        List<SelectOption> products = newQuoteController.products;
        newQuoteController.chosenProduct = product.Id;
        
        List<SelectOption> ratePlans = newQuoteController.prodRatePlan;
        newQuoteController.chosenProdRatePlan = prp.Id;
        
        newQuoteController.adjustedUnitCost = '90.00';
        newQuoteController.quantity = '5';
		
        Test.startTest();
        
		System.assert(Integer.valueOf(newQuoteController.listUnitCost) == 100);        
        System.assert(Integer.valueOf(newQuoteController.TotalMoPayment) < 500);
        
        System.assert(newQuoteController.discount != null);
        System.assert(newQuoteController.discount != '');
        System.assert(Integer.valueOf(newQuoteController.totalPrice) == 450);
        System.assert(newQuoteController.paymentTerm == '1');
        
        newQuoteController.chosenShipping = (newQuoteController.shippingLocations).get(2).getValue();
        List<zqu__ProductRatePlan__c> shippingRatePlans = newQuoteController.shippingRatePlans;
        List<SelectOption> courier = newQuoteController.courier;
        newQuoteController.chosencourier = prpShip.Name;
        List<SelectOption> shippingService = newQuoteController.shippingService;
        newQuoteController.chosenShippingService = prpShip.Id;
        
        newQuoteController.addProduct();
        
        Test.stopTest();
        
        newQuoteController.discount = '20%';
        newQuoteController.refreshUnitCost();
        
        newQuoteController.chosenShipping = (newQuoteController.shippingLocations).get(1).getValue();
        newQuoteController.chosencourier = prpShip.Name;
        newQuoteController.chosenShippingService = prpShip.Id;
        
        newQuoteController.addProduct();
            
        }
        
    }
    
    public static testMethod void testEditShipment(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
            
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
        
        quickAddHardwareProduct(quote, newQuoteController);
         
        newQuoteController.editShipmentId = newQuoteController.shipment.get(0).Id;
        newQuoteController.editShipment();
        
        (newQuoteController.productsForEachShipment.get(newQuoteController.editShipmentId))[0].ShipAdressLine1='';
        (newQuoteController.productsForEachShipment.get(newQuoteController.editShipmentId))[0].ShipCity='';
        (newQuoteController.productsForEachShipment.get(newQuoteController.editShipmentId))[0].ShipState='';
        (newQuoteController.productsForEachShipment.get(newQuoteController.editShipmentId))[0].ShipZip='';
        (newQuoteController.productsForEachShipment.get(newQuoteController.editShipmentId))[0].shipContact='';
        (newQuoteController.productsForEachShipment.get(newQuoteController.editShipmentId))[0].shipContactPhone='';
        (newQuoteController.productsForEachShipment.get(newQuoteController.editShipmentId))[0].ShipContactMail='';
         
         //toggle fail
        newQuoteController.editShipment();
        Test.stopTest();
            
        }
    }

    public static testMethod void testCancelEditShipment(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
            
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
        
        quickAddHardwareProduct(quote, newQuoteController);
         
        newQuoteController.editShipmentId = newQuoteController.shipment.get(0).Id;
        newQuoteController.editShipment();
        
        (newQuoteController.productsForEachShipment.get(newQuoteController.editShipmentId))[0].ShipAdressLine1='';
        (newQuoteController.productsForEachShipment.get(newQuoteController.editShipmentId))[0].ShipCity='';
        (newQuoteController.productsForEachShipment.get(newQuoteController.editShipmentId))[0].ShipState='';
        (newQuoteController.productsForEachShipment.get(newQuoteController.editShipmentId))[0].ShipZip='';
        (newQuoteController.productsForEachShipment.get(newQuoteController.editShipmentId))[0].shipContact='';
        (newQuoteController.productsForEachShipment.get(newQuoteController.editShipmentId))[0].shipContactPhone='';
        (newQuoteController.productsForEachShipment.get(newQuoteController.editShipmentId))[0].ShipContactMail='';
         
        newQuoteController.cancelEditShipment();
        Test.stopTest();
            
        }
    }
    
    public static testMethod void testUpdateShippingContact(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
        
        //and 'takeCorrectedAddress'
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
        
        quickAddHardwareProduct(quote, newQuoteController);
         
        newQuoteController.editShipmentId = newQuoteController.shipment.get(0).Id;
        newQuoteController.editShipment();
        
        (newQuoteController.productsForEachShipment.get(newQuoteController.editShipmentId))[0].ShipAdressLine1='b';
        (newQuoteController.productsForEachShipment.get(newQuoteController.editShipmentId))[0].ShipCity='b';
        (newQuoteController.productsForEachShipment.get(newQuoteController.editShipmentId))[0].ShipState='b';
        (newQuoteController.productsForEachShipment.get(newQuoteController.editShipmentId))[0].ShipZip='30000';
        (newQuoteController.productsForEachShipment.get(newQuoteController.editShipmentId))[0].shipContact='b';
        (newQuoteController.productsForEachShipment.get(newQuoteController.editShipmentId))[0].shipContactPhone='0';
        (newQuoteController.productsForEachShipment.get(newQuoteController.editShipmentId))[0].ShipContactMail='b@gmail.com';
            
        newQuoteController.takeCorrectedAddress();
        Test.stopTest();
            
        }
    }
    
    public static testMethod void testCancelConfirm(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
        
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
        
        quickAddHardwareProduct(quote, newQuoteController);
        
        newQuoteController.cancelConfirm();
        Test.stopTest();
            
        }
    }
    
    public static testMethod void testBack(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
            
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
        
        quickAddHardwareProduct(quote, newQuoteController);
        
        newQuoteController.back();
        Test.stopTest();    
            
        }
    }
    
    public static testMethod void testReturnToPreQuote(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
        
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
                
        newQuoteController.returnToPreQuote();
        Test.stopTest();   
            
        }
    }
    
    public static testMethod void testPreSubmitCheck(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
        
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
                
        newQuoteController.preSubmitCheck();
          
        quickAddHardwareProduct(quote, newQuoteController);
          
        newQuoteController.preSubmitCheck();
        Test.stopTest();  
            
        }
    }
    
    public static testMethod void testInsertShipmentGroupCharges(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
        
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
                
        newQuoteController.preSubmitCheck();
          
        quickAddHardwareProduct(quote, newQuoteController);
          
        newQuoteController.saveQuote();
        Test.stopTest();    
            
        }
    }
    
    public static testMethod void testSubmitQuoteHarness(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
        
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
                
        newQuoteController.preSubmitCheck();
          
        quickAddHardwareProduct(quote, newQuoteController);
          
        newQuoteController.saveQuote();
        //InsertQuotecharges should be tested here
        newQuoteController.submitQuote();
        Test.stopTest();    
            
        }
    }
    
    public static testMethod void testSubmitQuoteService(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
        
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
                
        newQuoteController.preSubmitCheck();
          
        quickAddServiceProduct(quote, newQuoteController);
          
        newQuoteController.saveQuote();
        //InsertQuotecharges should be tested here
        newQuoteController.submitQuote();
        Test.stopTest();    
            
        }
    }
    
    public static testMethod void testCheckHardwareServiceonSubmit(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
        
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
                
        newQuoteController.preSubmitCheck();
          
        quickAddHardwareProduct(quote, newQuoteController);
          
        newQuoteController.checkHardwareServiceonSubmit();
        Test.stopTest();   
            
        }
    }
    
    public static testMethod void testSubmitForApproval(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
        
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
                
        newQuoteController.preSubmitCheck();
          
        quickAddHardwareProduct(quote, newQuoteController);
          
        newQuoteController.saveQuote();
        
        newQuoteController.submitForApproval();
        Test.stopTest();    
            
        }
    }
    
    public static testMethod void testCancelQuote(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
        
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
                
        newQuoteController.preSubmitCheck();
          
        quickAddHardwareProduct(quote, newQuoteController);
          
        newQuoteController.saveQuote();
        
        newQuoteController.cancelQuote();
            
        }
            
    }
    
    public static testMethod void testEditProductOnShipping(){
        
		User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
        
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
                
        newQuoteController.preSubmitCheck();
          
        quickAddHardwareProduct(quote, newQuoteController);
        
        Test.startTest();  
        
        newQuoteController.saveQuote();
        
        newQuoteController.shipmentId = newQuoteController.shipment.get(0).Id;
        
        newQuoteController.localChargeId = (newQuoteController.productsForEachShipment.get(newQuoteController.shipmentId)).get(0).localId;
        
        newQuoteController.editProductOnShipping();
        
        newQuoteController.quantity = '20';
        System.assert(newQuoteController.isEditingProduct == true);
        //test edit product funtionality in addProduct functionality;
        newQuoteController.addProduct();
            
        Test.stopTest();  
            
        }
    }
    
    public static testMethod void testDeleteProductCheck(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
        
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
        
        newQuoteController.deleteProductCheck();
        Test.stopTest();
            
        }
    }
    
    public static testMethod void testDeleteProductOnShipping(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
        
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
                
        newQuoteController.preSubmitCheck();
          
        quickAddHardwareProduct(quote, newQuoteController);
          
        newQuoteController.saveQuote();
        
        newQuoteController.shipmentToDeleteId = newQuoteController.shipment.get(0).Id;
        
        newQuoteController.localChargeIdToDelete = (newQuoteController.productsForEachShipment.get(newQuoteController.shipmentToDeleteId)).get(0).localId;
        
        newQuoteController.deleteProductOnShipping();
        Test.stopTest();
        
        System.assert(newQuoteController.productsForEachShipment.isEmpty());
        System.assert(newQuoteController.productMapSize == false);
            
        }
        
    }
    
    public static testMethod void testClear(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
        
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
                
        newQuoteController.preSubmitCheck();
          
        quickAddHardwareProduct(quote, newQuoteController);
          
        newQuoteController.clear();
        Test.stopTest();
            
        }
    }
    
    public static testMethod void testSetShippingServiceName(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
        
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
                
        newQuoteController.preSubmitCheck();
          
        quickAddHardwareProduct(quote, newQuoteController);
          
        newQuoteController.setShippingServiceName();
        Test.stopTest();
            
        }
    }
    
    public static testMethod void testQuoteTriggerHandler(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
        
        
        Test.startTest();
        
        zqu__Quote__c quote = createQuote();
        quote.CustomerApprovalOverride__c = true;
        insert quote;
        quote.Approved__c = false;
        update quote;
        
        
        quote = createQuote();
        quote.isPending__c = true;
        insert quote;
        quote.Approved__c = false;
        update quote;
        
        
        quote.Approved__c = true;
        update quote;
        
        quote.CustomerApproval__c = true;
        update quote;
        
        Test.stopTest();
            
        }
    }
    
    public static testMethod void testListShippingCostTieredPricing(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
        
		PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        Shipment__c shipment2 = addShippingAddress(quote);
        insert shipment2;
        
        zqu__ZProduct__c product = addZProduct(quote, 'Hardware Category', 'Test Product', '100');
        insert product;
        
        zqu__ProductRatePlan__c prp = addZRatePlan(product, '100');
        insert prp;
        
        zqu__ProductRatePlanCharge__c prpc = addZRatePlanCharge(prp, '100', 'One-Time');
        insert prpc;
        
        zqu__ZProduct__c productShip = addZShippingProduct(quote, 'Shipping', 'Shipping Product', '200');
        insert productShip;
		zqu__ProductRatePlan__c prpShip = addZShippingRatePlan(productShip, '200');
        insert prpShip;        
        zqu__ProductRatePlanCharge__c prpcShip = addZShippingRatePlanCharge(prpShip, '200', 'Shipping', 'Tiered Pricing');
        insert prpcShip;
        
        List<zqu__ProductRatePlanChargeTier__c> tierList = new List<zqu__ProductRatePlanChargeTier__c>();
        
        zqu__ProductRatePlanChargeTier__c prpctShip = addZShippingChargeTier(prpcShip, 1, '10.00', '200', 1, 1);
        tierList.add(prpctShip);
        prpctShip = addZShippingChargeTier(prpcShip, 2, '5.00', '201', 2, null);
        tierList.add(prpctShip);
        insert tierList;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
		
        List<SelectOption> pCategories = newQuoteController.productCategories;
        newQuoteController.chosenCategory = 'Hardware Category';
        
        List<SelectOption> products = newQuoteController.products;
        newQuoteController.chosenProduct = product.Id;
        
        List<SelectOption> ratePlans = newQuoteController.prodRatePlan;
        newQuoteController.chosenProdRatePlan = prp.Id;
        
        newQuoteController.adjustedUnitCost = '90.00';
        newQuoteController.quantity = '5';
		
        Test.startTest();
        
		newQuoteController.chosenShipping = (newQuoteController.shippingLocations).get(2).getValue();
        List<zqu__ProductRatePlan__c> shippingRatePlans = newQuoteController.shippingRatePlans;
        List<SelectOption> courier = newQuoteController.courier;
        newQuoteController.chosencourier = prpShip.Name;
        List<SelectOption> shippingService = newQuoteController.shippingService;
        newQuoteController.chosenShippingService = prpShip.Id;
        
        System.assert(newQuoteController.listShippingCost == Decimal.valueOf('30.00'));
        
        Test.stopTest();
            
        }
    }
    
    public static testMethod void testListShippingCostVolumePricing(){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
        
		PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        insert opp;
        
        zqu__Quote__c quote = createQuote();
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        Shipment__c shipment2 = addShippingAddress(quote);
        insert shipment2;
        
        zqu__ZProduct__c product = addZProduct(quote, 'Hardware Category', 'Test Product', '100');
        insert product;
        
        zqu__ProductRatePlan__c prp = addZRatePlan(product, '100');
        insert prp;
        
        zqu__ProductRatePlanCharge__c prpc = addZRatePlanCharge(prp, '100', 'One-Time');
        insert prpc;
        
        zqu__ZProduct__c productShip = addZShippingProduct(quote, 'Shipping', 'Shipping Product', '200');
        insert productShip;
		zqu__ProductRatePlan__c prpShip = addZShippingRatePlan(productShip, '200');
        insert prpShip;        
        zqu__ProductRatePlanCharge__c prpcShip = addZShippingRatePlanCharge(prpShip, '200', 'Shipping', 'Volume Pricing');
        insert prpcShip;
        
        List<zqu__ProductRatePlanChargeTier__c> tierList = new List<zqu__ProductRatePlanChargeTier__c>();
        
        zqu__ProductRatePlanChargeTier__c prpctShip = addZShippingChargeTier(prpcShip, 1, '10.00', '200', 1, 1);
        tierList.add(prpctShip);
        prpctShip = addZShippingChargeTier(prpcShip, 2, '5.00', '201', 2, null);
        tierList.add(prpctShip);
        insert tierList;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        ApexPages.currentPage().getParameters().put('quoteid', quote.Id);
        
        newQuoteCustomController newQuoteController = new newQuoteCustomController(sc);
		
        List<SelectOption> pCategories = newQuoteController.productCategories;
        newQuoteController.chosenCategory = 'Hardware Category';
        
        List<SelectOption> products = newQuoteController.products;
        newQuoteController.chosenProduct = product.Id;
        
        List<SelectOption> ratePlans = newQuoteController.prodRatePlan;
        newQuoteController.chosenProdRatePlan = prp.Id;
        
        newQuoteController.adjustedUnitCost = '90.00';
        newQuoteController.quantity = '5';
		
        Test.startTest();
        
		newQuoteController.chosenShipping = (newQuoteController.shippingLocations).get(2).getValue();
        List<zqu__ProductRatePlan__c> shippingRatePlans = newQuoteController.shippingRatePlans;
        List<SelectOption> courier = newQuoteController.courier;
        newQuoteController.chosencourier = prpShip.Name;
        List<SelectOption> shippingService = newQuoteController.shippingService;
        newQuoteController.chosenShippingService = prpShip.Id;
        
        System.assert(newQuoteController.listShippingCost == Decimal.valueOf('25.00'));
        
        Test.stopTest();
            
        }
    }
    
    public static void quickAddServiceProduct(zqu__Quote__c quote, newQuoteCustomController newQuoteController){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
        
        zqu__ZProduct__c product = addZProduct(quote, 'Monthly Service', 'Test Product', '001');
        insert product;
        
        zqu__ProductRatePlan__c prp = addZRatePlan(product, '001');
        insert prp;
        
        zqu__ProductRatePlanCharge__c prpc = addZRatePlanCharge(prp, '0001', 'Recurring');
        insert prpc;
        
        zqu__ZProduct__c productShip = addZShippingProduct(quote, 'Shipping', 'Shipping Product', '002');
        insert productShip;
		zqu__ProductRatePlan__c prpShip = addZShippingRatePlan(productShip, '002');
        insert prpShip;        
        zqu__ProductRatePlanCharge__c prpcShip = addZShippingRatePlanCharge(prpShip, '002', 'Shipping', 'One-Time');
        insert prpcShip;
        
        List<SelectOption> pCategories = newQuoteController.productCategories;
        newQuoteController.chosenCategory = 'Monthly Service';
        
        List<SelectOption> products = newQuoteController.products;
        newQuoteController.chosenProduct = product.Id;
        
        List<SelectOption> ratePlans = newQuoteController.prodRatePlan;
        newQuoteController.chosenProdRatePlan = prp.Id;
        
        System.assert(newQuoteController.listUnitCost != null);
        
        newQuoteController.adjustedUnitCost = '90.00';
        newQuoteController.quantity = '5';
        
        System.assert(Integer.valueOf(newQuoteController.TotalMoPayment) < 500);
        
        newQuoteController.chosenShipping = (newQuoteController.shippingLocations).get(1).getValue();
        List<zqu__ProductRatePlan__c> shippingRatePlans = newQuoteController.shippingRatePlans;
        List<SelectOption> courier = newQuoteController.courier;
        newQuoteController.chosencourier = prpShip.Id;
        List<SelectOption> shippingService = newQuoteController.shippingService;
        newQuoteController.chosenShippingService = prpShip.Id;
        
        newQuoteController.addProduct();
            
        }
    }
    
    public static void quickAddHardwareProduct(zqu__Quote__c quote, newQuoteCustomController newQuoteController){
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
        
        zqu__ZProduct__c product = addZProduct(quote, 'Harnesses & Cables', 'Test Product', '002');
        insert product;
        
        zqu__ProductRatePlan__c prp = addZRatePlan(product, '002');
        insert prp;
        
        zqu__ProductRatePlanCharge__c prpc = addZRatePlanCharge(prp, '0002', 'One-Time');
        insert prpc;
        
        zqu__ZProduct__c productShip = addZShippingProduct(quote, 'Shipping', 'Shipping Product', '004');
        insert productShip;
		zqu__ProductRatePlan__c prpShip = addZShippingRatePlan(productShip, '004');
        insert prpShip;        
        zqu__ProductRatePlanCharge__c prpcShip = addZShippingRatePlanCharge(prpShip, '004', 'Shipping', 'One-Time');
        insert prpcShip;
        
        List<SelectOption> pCategories = newQuoteController.productCategories;
        newQuoteController.chosenCategory = 'Harnesses & Cables';
        
        List<SelectOption> products = newQuoteController.products;
        newQuoteController.chosenProduct = product.Id;
        
        List<SelectOption> ratePlans = newQuoteController.prodRatePlan;
        newQuoteController.chosenProdRatePlan = prp.Id;
        
        System.assert(newQuoteController.listUnitCost != null);
        
        newQuoteController.adjustedUnitCost = '90.00';
        newQuoteController.quantity = '5';
        
        System.assert(Integer.valueOf(newQuoteController.TotalMoPayment) < 500);
        
        newQuoteController.chosenShipping = (newQuoteController.shippingLocations).get(1).getValue();
        List<zqu__ProductRatePlan__c> shippingRatePlans = newQuoteController.shippingRatePlans;
        List<SelectOption> courier = newQuoteController.courier;
        newQuoteController.chosencourier = prpShip.Id;
        List<SelectOption> shippingService = newQuoteController.shippingService;
        newQuoteController.chosenShippingService = prpShip.Id;
        
        newQuoteController.addProduct();
            
        }
    }
    
    public static zqu__Quote__c createQuote(){
        
        List<Account> vendorAccounts = [Select Id, Name, Vendor_Name__c from Account WHERE Is_Vendor__c = true AND Name = 'Networkfleet'];
        List<User> users = [Select Id from User];
        List<Account> account = [Select Id from Account WHERE Status__c != 'Terminated' limit 5];
        Account acc = account.get(0);
        List<Zuora__CustomerAccount__c> billingAccount = [Select Id from Zuora__CustomerAccount__c WHERE Zuora__Account__c = :acc.Id];
        
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
                    zqu__PaymentTerm__c = '1',
                    Vendor_Account__c = vendorAccounts.get(0).Id,
                    SalesRep1__c = users.get(0).Id,
                    zqu__Account__c = acc.Id);
        
        return quote;

    }
    
    public static Shipment__c addShippingAddress(zqu__Quote__c Quote){

        
        Shipment__c shippingData = new Shipment__c();
        shippingData.Address_Line_1__c='a';
        shippingData.Address_Line_2__c='shipAddress2';                        
        shippingData.Shipping_Contact__c= 'shipContactName';                    
        shippingData.Shipping_Contact_Phone__c= 'shipContactPhone';                      
        shippingData.Shipping_Contact_Email__c= 'g@gmail.com';                    
        shippingData.City__c= 'shipCity';                             
        shippingData.State__c= 'shipState';                         
        shippingData.Zip__c= '0';
        shippingData.Quote__c = Quote.Id;
        
        return shippingData;
            
    }
    
    public static Shipment_Charge_Group__c addShipmentChargeGroup(Shipment__c shipment){
        
        
        Shipment_Charge_Group__c charge = new Shipment_Charge_Group__c();
        charge.ChargeType__c = 'Recurring'; 
        charge.Discount__c = '10%';
        charge.List_Price__c = Decimal.valueOf('10.00');
        charge.List_Total__c = Decimal.valueOf('100.00');
        charge.ProductCategory__c = 'Test Product';
        charge.Product_Name__c = 'Test Product';
        charge.Quantity__c = Integer.valueOf('10');
        charge.Rate_Plan_Name__c = 'Test Rate Plan';
        charge.Recurring_Monthly_Expense__c = Decimal.valueOf('100.00');
        charge.ServiceTerm__c = 1;
        charge.PaymentTerm__c = '1';
        charge.Shipment__c = shipment.Id;
        charge.Shipment_Cost__c = Decimal.valueOf('15.00');
        charge.Total__c = Decimal.valueOf('100.00');
        
        return charge;

    }
    
    public static zqu__ZProduct__c addZProduct(zqu__Quote__c quote, String category, String name, String iden){
        
        
        zqu__ZProduct__c product = new zqu__ZProduct__c();
        
        product.Name = name;
        product.zqu__SKU__c = 'ak001';
        product.zqu__ZuoraId__c = iden;
        product.IsShipping__c = 'false';
        product.WEXProductCategory__c = category;
        product.zqu__Deleted__c = false;
        product.zqu__EffectiveEndDate__c = System.today();
        product.zqu__EffectiveStartDate__c= System.today();
        product.Vendor__c = quote.Vendor_Account__c;
            
        return product;
            

    }
    
    public static zqu__ZProduct__c addZShippingProduct(zqu__Quote__c quote, String category, String name, String iden){
        

        
        zqu__ZProduct__c product = new zqu__ZProduct__c();
        
        product.Name = name;
        product.zqu__SKU__c = 'ak002';
        product.zqu__ZuoraId__c = iden;
        product.IsShipping__c = 'false';
        product.WEXProductCategory__c = category;
        product.zqu__Deleted__c = false;
        product.zqu__EffectiveEndDate__c = System.today();
        product.zqu__EffectiveStartDate__c= System.today();
        product.Vendor__c = quote.Vendor_Account__c;
            
        return product;
            

    }
    
    public static zqu__ProductRatePlan__c addZRatePlan(zqu__ZProduct__c product, String iden){
        

        
        zqu__ProductRatePlan__c prp = new zqu__ProductRatePlan__c();
        
        prp.zqu__EffectiveStartDate__c = System.today();
        prp.zqu__EffectiveEndDate__c = System.today();
        prp.zqu__Deleted__c = false;
        prp.Name = 'Test Rate Plan';
        prp.zqu__ZuoraId__c = iden;
        prp.zqu__ZProduct__c = product.Id;
        prp.NonRecurringPaymentTerm__c = 'NOT';
        
        return prp;

    }
    
    public static zqu__ProductRatePlan__c addZShippingRatePlan(zqu__ZProduct__c product, String iden){
        

        
        zqu__ProductRatePlan__c prp = new zqu__ProductRatePlan__c();
        
        prp.zqu__EffectiveStartDate__c = System.today();
        prp.zqu__EffectiveEndDate__c = System.today();
        prp.zqu__Deleted__c = false;
        prp.Name = 'Shipping Test Rate Plan';
        prp.zqu__ZuoraId__c = iden;
        prp.zqu__ZProduct__c = product.Id;
        prp.NonRecurringPaymentTerm__c = '12';
        
        return prp;

    }
    
    public static zqu__ProductRatePlanCharge__c addZRatePlanCharge(zqu__ProductRatePlan__c prp, String iden, String chargeType){
        

        
        zqu__ProductRatePlanCharge__c prpc = new zqu__ProductRatePlanCharge__c();
        
        prpc.zqu__Deleted__c = false;
        prpc.zqu__ListPrice__c = Decimal.valueOf('100.00');
        prpc.WEXMinPrice__c = '50.00';
        prpc.zqu__ZuoraId__c = iden;
        prpc.zqu__ProductRatePlan__c = prp.Id;
        prpc.zqu__Type__c = chargeType;
        
        return prpc;

    }
    
    public static zqu__ProductRatePlanCharge__c addZShippingRatePlanCharge(zqu__ProductRatePlan__c prp, String iden, String chargeType, String chargeModel){

        
        zqu__ProductRatePlanCharge__c prpc = new zqu__ProductRatePlanCharge__c();
        
        prpc.zqu__Deleted__c = false;
        prpc.zqu__ListPrice__c = Decimal.valueOf('100.00');
        prpc.WEXMinPrice__c = '50.00';
        prpc.zqu__ZuoraId__c = iden;
        prpc.zqu__ProductRatePlan__c = prp.Id;
        prpc.zqu__Type__c = chargeType;
        prpc.zqu__Model__c = chargeModel;
        
        return prpc;

    }
    
    public static zqu__ProductRatePlanChargeTier__c addZShippingChargeTier(zqu__ProductRatePlanCharge__c prpc, Integer tier, String price, String iden, Integer startingUnit, Integer endingUnit){
 
        
        zqu__ProductRatePlanChargeTier__c prpct = new zqu__ProductRatePlanChargeTier__c();
        
        prpct.zqu__Deleted__c = false;
        prpct.zqu__Price__c = Decimal.valueOf(price);
        prpct.zqu__ZuoraId__c = iden;
        prpct.zqu__ProductRatePlanCharge__c = prpc.Id;
        prpct.zqu__StartingUnit__c = startingUnit;
        prpct.zqu__EndingUnit__c = endingUnit;
        prpct.zqu__Tier__c = tier;
        
        return prpct;

    }
    
    public class CustomHttpCalloutMock implements HttpCalloutMock
    {
        public HTTPResponse respond(HTTPRequest req)
        {
            HTTPResponse retVal = new HTTPResponse();
            retVal.setStatusCode(200);
            return retVal;
        }
    }
}