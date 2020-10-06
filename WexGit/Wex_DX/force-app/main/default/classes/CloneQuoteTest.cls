@isTest(SeeAllData=true)
public class CloneQuoteTest {
	public static testmethod void testCloneQuote(){
        zqu__Quote__c quote = createQuote();
        
        insert quote;
        
        Shipment__c shipment = addShippingAddress(quote);
        insert shipment;
        
        Shipment__c shipment2 = addShippingAddress(quote);
        insert shipment2;
        
        zqu__ZProduct__c product = addZProduct(quote, 'Harnesses & Cables', 'Test Product', '100');
        insert product;
        
        zqu__ProductRatePlan__c prp = addZRatePlan(product, '100');
        insert prp;
        
        zqu__ProductRatePlanCharge__c prpc = addZRatePlanCharge(prp, '100', 'One-Time');
        insert prpc;
        
        zqu__ZProduct__c productService = addZProduct(quote, 'Monthly Service', 'Test Product', '300');
        insert productService;
        
        zqu__ProductRatePlan__c prpService = addZRatePlan(product, '300');
        insert prpService;
        
        zqu__ProductRatePlanCharge__c prpcService = addZRatePlanCharge(prp, '300', 'Recurring');
        insert prpcService;
        
        zqu__ZProduct__c productShip = addZShippingProduct(quote, 'Shipping', 'Shipping Product', '200');
        insert productShip;
		zqu__ProductRatePlan__c prpShip = addZShippingRatePlan(productShip, '200');
        insert prpShip;        
        zqu__ProductRatePlanCharge__c prpcShip = addZShippingRatePlanCharge(prpShip, '200', 'Shipping');
        insert prpcShip;
        
        Shipment_Charge_Group__c scg01 = addShipmentChargeGroup(quote, 'One-Time', '1', shipment, 'Harnesses & Cables', product, prp, prpc, prpShip, prpcShip);
        Shipment_Charge_Group__c scg02 = addShipmentChargeGroup(quote, 'Recurring', '12', shipment2, 'Monthly Service', productService, prpService, prpcService, null, null);
        Shipment_Charge_Group__c[] lscg = new List<Shipment_Charge_Group__c>{scg01,scg02};
        insert lscg;
        
        Shipment_Charge__c sc01 = addShipmentCharge(quote, 'One-Time',2, '1', shipment, 'Harnesses & Cables', product, prp, prpc, prpShip, prpcShip);
        Shipment_Charge__c sc02 = addShipmentCharge(quote, 'Recurring',1, '12', shipment2, 'Monthly Service', productService, prpService, prpcService, null, null);
        Shipment_Charge__c sc03 = addShipmentCharge(quote, 'Recurring',1, '12', shipment2, 'Monthly Service', productService, prpService, prpcService, null, null);
        Shipment_Charge__c[] lsc = new List<Shipment_Charge__c>{sc01,sc02,sc03};
        insert lsc;
        
        Test.startTest();
        
        Z_CloneQuote clone = new Z_CloneQuote(quote.Id);
        
        clone.autoRun();
        
        /*clone = new Z_CloneQuote(quote.Id);
        
        clone.autoRunPending();*/
        
        Test.stopTest();
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
    
    public static zqu__ProductRatePlanCharge__c addZShippingRatePlanCharge(zqu__ProductRatePlan__c prp, String iden, String chargeType){
        zqu__ProductRatePlanCharge__c prpc = new zqu__ProductRatePlanCharge__c();
        
        prpc.zqu__Deleted__c = false;
        prpc.zqu__ListPrice__c = Decimal.valueOf('100.00');
        prpc.WEXMinPrice__c = '50.00';
        prpc.zqu__ZuoraId__c = iden;
        prpc.zqu__ProductRatePlan__c = prp.Id;
        prpc.zqu__Type__c = chargeType;
        
        return prpc;
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
    
    public static Shipment_Charge_Group__c addShipmentChargeGroup(zqu__Quote__c q, String chargeType, String term, Shipment__c shipment, String productCategory, zqu__ZProduct__c product, zqu__ProductRatePlan__c ratePlan, zqu__ProductRatePlanCharge__c ratePlanCharge, zqu__ProductRatePlan__c shippingRatePlan, zqu__ProductRatePlanCharge__c shippingRatePlanCharge){
        Shipment_Charge_Group__c charge = new Shipment_Charge_Group__c();
        charge.ChargeType__c = chargeType; 
        charge.Discount__c = '10%';
        charge.Effective_Price__c = Decimal.valueOf('10.00');
        charge.List_Price__c = Decimal.valueOf('10.00');
        charge.List_Total__c = Decimal.valueOf('100.00');
        charge.ProductCategory__c = productCategory;
        charge.Product_Name__c = 'Test Product';
        charge.Quantity__c = Integer.valueOf('2');
        charge.ProductRatePlanCharge__c = ratePlanCharge.Id;
        charge.RatePlanId__c = ratePlan.Id;
        charge.Rate_Plan_Name__c = 'Test Rate Plan';
        charge.Recurring_Monthly_Expense__c = Decimal.valueOf('100.00');
        charge.ServiceTerm__c = Integer.valueOf(term);
        charge.PaymentTerm__c = term;
        charge.Shipment__c = shipment.Id;
        charge.Shipment_Cost__c = Decimal.valueOf('15.00');
        if(productCategory != 'Monthly Service'){
            charge.Shipping_Carrier_Zuora_Id__c = shippingRatePlan.zqu__ZuoraId__c;
        	charge.Shipping_Service_Zuora_Id__c = shippingRatePlanCharge.zqu__ZuoraId__c;
        }
        charge.Total__c = Decimal.valueOf('100.00');
        charge.Quote__c = q.Id;
        
        return charge;
    }
    
    public static Shipment_Charge__c addShipmentCharge(zqu__Quote__c q, String chargeType, Integer Quantity, String term, Shipment__c shipment, String productCategory, zqu__ZProduct__c product, zqu__ProductRatePlan__c ratePlan, zqu__ProductRatePlanCharge__c ratePlanCharge, zqu__ProductRatePlan__c shippingRatePlan, zqu__ProductRatePlanCharge__c shippingRatePlanCharge){
        Shipment_Charge__c charge = new Shipment_Charge__c();
        charge.ChargeType__c = chargeType; 
        charge.Discount__c = '10%';
        charge.Effective_Price__c = Decimal.valueOf('10.00');
        charge.List_Price__c = Decimal.valueOf('10.00');
        charge.List_Total__c = Decimal.valueOf('100.00');
        charge.ProductCategory__c = productCategory;
        charge.Product_Name__c = 'Test Product';
        charge.Quantity__c = quantity;
        charge.ProductRatePlanCharge__c = ratePlanCharge.Id;
        charge.RatePlanId__c = ratePlan.Id;
        charge.Rate_Plan_Name__c = 'Test Rate Plan';
        charge.Recurring_Monthly_Expense__c = Decimal.valueOf('100.00');
        charge.ServiceTerm__c = Integer.valueOf(term);
        charge.Shipment__c = shipment.Id;
        charge.Shipment_Cost__c = Decimal.valueOf('15.00');
        charge.Total__c = Decimal.valueOf('100.00');
        charge.QuoteLookup__c = q.Id;
        
        return charge;
    }
}