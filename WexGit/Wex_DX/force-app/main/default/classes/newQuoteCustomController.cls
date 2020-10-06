/**
 * Controller for NewQuotePage
 * 
 * @authors Tan Pham , Marie Bradford
 * */
public class newQuoteCustomController {
    
    private Zuora.zApi api = new Zuora.zApi();
    public Opportunity opp                                      {get;set;}
    public String accId                                         {get;set;}
    public String billToId                                      {get;set;}
    
    public  zqu__ZProduct__c product                            {get;set;}
    public  String chosenProduct                                {get;set;}
    public  String chosenCategory                               {get;set;}
    public String adjustedUnitCost                              {get;set;}
    
    public  String quoteId                                      {get;set;}
    public List<SelectOption> billingAccountList                {get;set;}
    public zqu__Quote__c quote                                  {get;set;}
    public Contact contact                                      {get;set;}
    public List<Shipment__c> shipment                           {get;set;}
    public List<ProductInfo> productWithAddDate                 {get;set;}
    public List<String> shipProducts                            {get;set;}
    public List<zqu__QuoteRatePlan__c> quoteRatePlans           {get;set;}
    public Boolean isEditingLocation                            {get;set;}
    
    public String chosenShipping                                {get;set;}
    public String chosenShippingService                         {get;set;}
    public String chosenShippingServiceName                     {get;set;}
    public String chosencourier                                 {get;set;}
    private Map<String,Id> courierMap = new Map<String,Id>();
    
    public boolean discountChange                               {get;set;}
    public Map<String,List<ProductInfo>> productsForEachShipment{get;set;}
    public Map<String,Shipment__c> shippingsInMap               {get;set;}
    public String opportunityId                                 {get;set;}
    
    public boolean isEditingProduct                             {get;set;}
    public String productId                                     {get;set;}
    public String productToDeleteId                             {get;set;}
    
    public String shipmentId                                    {get;set;}
    public Boolean shipmentEdit 								{get;set;}
    public String editShipmentId 								{get;set;}
    public String shipmentToDeleteId                            {get;set;}
    
    public  String quantity                                     {get;set;}
    public  List<String> shippingCostsList                      {get;set;}
    public  String chosenProdRatePlan                           {get;set;}
    public String shippingMinPrice                              {get;set;}
    public boolean shippingProductChosen                        {get;set;}
    
    public zqu.NotificationOptions notificationOptions  		{get;set;}
    private Boolean editProductFirstSet = false;
    private CCH_Transaction.ResolveAddressResult correctedAddressResult {get;set;}
    
    public String priceUpdateParam								{get;set;}
    public Boolean productMapSize 								{get;set;}
    public Map<String,List<Decimal>> shipmentMetrics 			{get;set;}
    
    public Integer localChargeId{get;set;}
    public Integer localChargeIdToDelete{get;set;}
    
    private Integer TotalQuoteHardware = 0;
    private Integer TotalQuoteServices = 0;
    public Integer productCounter;
    Map<String, Boolean> shippingMapping = new Map<String, Boolean>();
    
								  
			 
																												
							
		 
	 
	
    /**
     * Variables which require computation in the backend to either be filled in when page loads
     * or if based on other variables values
     */
    
    public String monthlyPayment {get{return 'monthlyPayment';}set{monthlyPayment = 'monthlyPayment';}}
    
    // Goes through products and aggregates the Shipping Cost
    public  Decimal QuoteshippingHandling{
        get{
            List<List<ProductInfo>> productList = productsForEachShipment.values();
            Decimal shippingCost = Decimal.valueOf('0.00');
            if(productList != null){
                 for(List<ProductInfo> products: productList){
                     for(ProductInfo prod: products){
                         if(prod.ShipCost != null){
                            shippingCost = shippingCost + prod.ShipCost;
                        }
                     }
                }
            }
            //QuoteshippingHandling = String.valueOf(shippingCost);
            QuoteshippingHandling = shippingCost;
            
            return QuoteshippingHandling;
            
        }set;}
    
    //Goes through products and aggregates the Total Price
    public  Decimal QuoteoneTimeExpense{
        get{
            List<List<ProductInfo>> productList = productsForEachShipment.values();
            Decimal onTimeEx = Decimal.valueOf('0.00');
            if(productList != null){
                 for(List<ProductInfo> products: productList){
                     for(ProductInfo prod: products){
                         //Charge cannot be recurring
                         if(prod.TotalPrice != null && !prod.ChargeType.equalsignorecase('Recurring')){
                             onTimeEx = onTimeEx + prod.TotalPrice;
                         }
                     }
                }
            }
            //QuoteoneTimeExpense = String.valueOf(onTimeEx);
            QuoteoneTimeExpense = onTimeEx;
            
            return QuoteoneTimeExpense;
            
        }set;}
    
    //Goes through products and aggregates the Monthly Expense
    public Decimal QuoterecurringMonthlyExpense{
        get{
            List<List<ProductInfo>> productList = productsForEachShipment.values();
            Decimal moPayment = Decimal.valueOf('0.00');
            if(productList != null){
                 for(List<ProductInfo> products: productList){
                     for(ProductInfo prod: products){
                         //charge must be recurring
                         if(prod.TotalMOPayment != null && prod.ChargeType.equalsignorecase('Recurring')){
                             moPayment = moPayment + prod.TotalMOPayment;
                         }
                     }
                }
            }
            //QuoterecurringMonthlyExpense = String.valueOf(moPayment);
            QuoterecurringMonthlyExpense = moPayment;
            
            return QuoterecurringMonthlyExpense;
            
        }set;}
    
    //Populates vendor from Quote, selected on Quote Page 1
    public  String vendor{
        get{
            List<zqu__Quote__c> quoteV=[SELECT Id,Vendor__c from zqu__Quote__c where Id=:quoteId];
            String v = quoteV.get(0).Vendor__c;
            return v;
        }
        set;}
    
    //Grabs set values for product categories and creates a Select Option List
    public  List<SelectOption> productCategories{
        get{
            List<SelectOption> prodCatOptions = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult =
                zqu__ZProduct__c.WEXProductCategory__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            prodCatOptions.add(new SelectOption('--None--', '--None--'));
            List<ProductCategoryComparable> pCatComparables = new List<ProductCategoryComparable>();
            for (Schema.PicklistEntry p :ple) {
                pCatComparables.add(new ProductCategoryComparable(p));
            }
            pCatComparables.sort();

            for (ProductCategoryComparable pcc :pCatComparables) {
                if (pcc.ple.getLabel() != 'TO BE DETERMINED' && pcc.ple.getLabel().toUpperCase() != 'NOT APPLICABLE' && pcc.ple.getLabel().toUpperCase() != 'SHIPPING') {
                    prodCatOptions.add(new SelectOption(pcc.ple.getValue(), pcc.ple.getLabel()));
                }
            }

            return prodCatOptions;
        }
        set;
    }
    
    //Queries for Products based on chosenCategory
    public  List<SelectOption> products{
        get{
            if(chosenCategory!=null && chosenCategory!='--None--'){
                List<zqu__ZProduct__c> chosenProducts = [SELECT Id, Name, WEXProductCategory__c,zqu__Deleted__c,zqu__EffectiveEndDate__c,zqu__EffectiveStartDate__c, IsShipping__c
                                                         FROM zqu__ZProduct__c WHERE WEXProductCategory__c =:chosenCategory AND Vendor__c =:vendor
                                                         ORDER BY Name DESC];
                List<SelectOption> productOptions=new List<SelectOption>();
                productOptions.add(new SelectOption('--None--','--None--'));
                Date todayDay= date.today();
                for(zqu__ZProduct__c prod:chosenProducts){
                    if(prod.zqu__Deleted__c==FALSE && prod.zqu__EffectiveEndDate__c >= todayDay && prod.zqu__EffectiveStartDate__c <= todayDay){
                        productOptions.add(new SelectOption(prod.Id,prod.Name));
                    }
                    
                }
                return productOptions;
            } else {return null;}
            
        }
        set;
    }
    
    //Queries for Product Rate Plans based on chosenProduct
    public List<SelectOption> prodRatePlan{
        get{
            if(chosenProduct!=null && chosenProduct!='--None--'){
                List<SelectOption> ratePlans = new List<SelectOption>();
                List<zqu__ProductRatePlan__c> prps = [SELECT Id, zqu__EffectiveStartDate__c,zqu__Deleted__c,Name,zqu__ZProduct__c,zqu__EffectiveEndDate__c 
                                                      FROM zqu__ProductRatePlan__c WHERE zqu__ZProduct__c =:chosenProduct AND zqu__Deleted__c = false
                                                      ORDER BY Name DESC];

                ratePlans.add(new SelectOption('--None--','--None--'));
                Date todayDay= date.today();
                for( zqu__ProductRatePlan__c prp : prps){
                    if(todayDay>=prp.zqu__EffectiveStartDate__c && todayDay<=prp.zqu__EffectiveEndDate__c && prp.zqu__Deleted__c==FALSE){
                        
                        ratePlans.add(new SelectOption(prp.Id,prp.Name));
                    }    
                }
                
                return ratePlans;
            }else {
                List<SelectOption> ratePlans = new List<SelectOption>();
                return ratePlans;
            }
        }
        set;
    }
    
    //Term grabbed from chosenProdRatePlan
    public  String paymentTerm{
        get{
            if(chosenProdRatePlan!=null && chosenProdRatePlan!='--None--'){
                List<zqu__ProductRatePlan__c> prp = [SELECT Id,NonRecurringPaymentTerm__c from zqu__ProductRatePlan__c where Id=:chosenProdRatePlan];
                if(prp!=null && !prp.isEmpty()){
                    //String payTerm=prp.get(0).NonRecurringPaymentTerm__c;
                    if(prp.get(0).NonRecurringPaymentTerm__c=='NOT'){
                        String payTerm='1';
                        return payTerm;
                    } else {
                        String payTerm=prp.get(0).NonRecurringPaymentTerm__c;
                        return payTerm;
                    }
                    return null;
                } else{
                    //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please specify a Product Rate Plan!');
                    //ApexPages.addMessage(myMsg); 
                    return null;
                }
            } else {
                return null;
            }
            
        }set;}
    
    //List Price grabbed from chosenProdRatePlan
    public  Decimal listUnitCost{
        get{
            if(chosenProdRatePlan!=null && chosenProdRatePlan!='--None--'){
                List<zqu__ProductRatePlanCharge__c> charges = [Select Id,zqu__ProductRatePlan__c,zqu__ListPrice__c FROM zqu__ProductRatePlanCharge__c where zqu__Deleted__c = false and zqu__ProductRatePlan__c=:chosenProdRatePlan];
                Decimal chosenProdRatePlanCost = Decimal.valueOf('0');
                for(zqu__ProductRatePlanCharge__c prpch:charges){
                    if(prpch.zqu__ListPrice__c>chosenProdRatePlanCost){
                        chosenProdRatePlanCost=prpch.zqu__ListPrice__c;
                    }
                }
                if(chosenProdRatePlanCost==0){
                    return 0;
                }
                chosenProdRatePlanCost=chosenProdRatePlanCost.setScale(2);
                return chosenProdRatePlanCost;
            } else {
                return null;
            }
        }
        
        
        set;}
    
    //Discount is both set by user and calculated 
    //Calculated by the Percentage difference between listUnitCost and AdjustedUnitCost
	public  String discount{
        get{
            //A check to see if the discount was manually changed
            if(!discountChange ){
                if(adjustedUnitCost!=null && listUnitCost!=null && listUnitCost!=Decimal.valueOf('0.00') && adjustedUnitCost!=''){
                    Decimal adjustedCost = decimal.valueOf(adjustedUnitCost);
                    Decimal listCost = listUnitCost;
                    Decimal totalDiscount=((listCost-adjustedCost)/listCost)*100;
                    Decimal totalDiscountRounded=totalDiscount.setScale(2);
                    
                    if(totalDiscountRounded>0){ 
                        String totald=totalDiscountRounded.toPlainString()+'%';
                        return totald;
                    } else {
                        String totald = '0';
                        return totald;
                    }
                    
                } else {
                    return '0';
                }
            }else{
                return discount;
            }
        }
        set;
    }
    
    //Calculated by AdjustedUnitCost * Quantity * PaymentTerm
    public Decimal totalPrice{
        get{
            if(quantity!=null && adjustedUnitCost!=null && adjustedUnitCost!='0' && adjustedUnitCost!='' && quantity!='' && quantity!='0'){
                Decimal price = decimal.valueOf(adjustedUnitCost);
                Decimal amount = Integer.valueOf(quantity);
                Decimal term = Integer.valueOf(paymentTerm);
                Decimal totalP=price*amount*term;
                
                return totalP;
            } else {return 0;}
        }
        set;
    }
    
    //Calculated by TotalPrice divided by the term
    public  String TotalMoPayment{
        get{
            if(totalPrice!=null && paymentTerm!=null && paymentTerm!='0' && paymentTerm!=''){
                
                //TotalMoPayment can be updated by the user, then the adjustedUnitCost and totalPrice needs to be updated
                if(priceUpdateParam == null || priceUpdateParam.equals('monthlyPayment')){
                    if(TotalMoPayment != null && TotalMoPayment != ''){
                        System.debug('TotalMoPayment ' + TotalMoPayment);
                        Decimal totalMO = decimal.valueOf(TotalMoPayment);
                        Decimal term = decimal.valueOf(paymentTerm);
                        Decimal q = decimal.valueOf(quantity);
                        adjustedUnitCost = String.valueOf(totalMO/q);
                        totalPrice = totalMo * term;
                        discountChange=FALSE;
                        return TotalMoPayment;
                    }
                }
                
                Decimal totalPr = totalPrice;
                Decimal term = decimal.valueOf(paymentTerm);
                Decimal totalMoPay=totalPr/term;
                //Decimal totalMoPay=totalPr;
                Decimal totalMoPayRounded=totalMoPay.setScale(2);
                String totalpay=totalMoPayRounded.toPlainString();
                
                return totalpay;
                
            } else {
                return null;}
        }
        set;
    }
    
    //Refreshes variables as the fields update one another and can be updated themselves
    public void refreshUnitCost(){
        discountChange=TRUE;
        System.debug('discount ' + discount);
        String discount1 = discount.remove('%');
        Decimal discountDec = decimal.valueOf('0');
        if(discount1 == null || discount1  == '' ){
            discountDec = decimal.valueOf('0');
        }else{
            discountDec = decimal.valueOf(discount1);
        }
        
        Decimal listCost = listUnitCost;
        
        Decimal adjustedCost=listCost-(listCost*discountDec/100);
        Decimal totalAdjustedCOst=adjustedCost.setScale(2);
        adjustedUnitCost=String.valueOf(totalAdjustedCOst);
        System.debug('adjustedUnitCost ' + adjustedUnitCost);
    }
    
    //Populated from the shipments create in Quote Page 1
    public List<SelectOption> ShippingLocations{
        get{
            if(shipment!=null && !shipment.isEmpty()){
                List<SelectOption> shipping = new List<SelectOption>();
                Map<String,Shipment__c> shippingsForMap = new Map<String,Shipment__c>();
                shipping.add(new SelectOption('--None--','--None--'));
                for(Shipment__c s:shipment){
                    shipping.add(new SelectOption(s.Id,s.Address_Line_1__c+','+s.City__c+','+s.Zip__c));
                    shippingsForMap.put(s.Id,s);
                }
                shippingsInMap=shippingsForMap;
                return shipping;
            } else {
                return  null;
            }
        }
        set;
    }
    
    //Queries For Zuora Shipping Product Rate Plans
    public List<zqu__ProductRatePlan__c> shippingRatePlans{
        get{
            List<zqu__ProductRatePlan__c> prps = new List<zqu__ProductRatePlan__c>();
            if(chosenProduct!=null && chosenProduct!='--None--'){
                prps = [SELECT Id, ShippingVendor__c, zqu__EffectiveStartDate__c,zqu__Deleted__c,Name,zqu__ZProduct__c,zqu__EffectiveEndDate__c FROM zqu__ProductRatePlan__c WHERE zqu__Deleted__c = false and zqu__ZProduct__r.Vendor__c =:vendor and zqu__ZProduct__r.WEXProductCategory__c='Shipping'];
            }
            return prps;
        }
        set;
    }

    //Goes through shippingRatePlans and creates a Select Option List
    public List<SelectOption> courier{
        get{
            if(chosenProduct!=null && chosenProduct!='--None--'){
                Set<SelectOption> couriers = new Set<SelectOption>();
                couriers.add(new SelectOption('--None--','--None--'));
                Date todayDay= date.today();
                for( zqu__ProductRatePlan__c prp : shippingRatePlans){
                    if(todayDay>=prp.zqu__EffectiveStartDate__c && todayDay<=prp.zqu__EffectiveEndDate__c && prp.zqu__Deleted__c==FALSE){
                        if (prp.ShippingVendor__c != null){
                            String courier = prp.ShippingVendor__c;
                            couriers.add(new SelectOption(courier,courier));
                            //Select Option List does not store the rate plan id which is needed later so a map stors the information
                            courierMap.put(courier,prp.Id);
                        }
                    }    
                }
                List<SelectOption> couriersList = new List<SelectOption>(couriers);
                return couriersList;
            }else {return null;}
        }
        set;
    }
	
    //Based on the courier chosen the rate plans are further filtered and the filterd list is returned
    public List<SelectOption> shippingService{
        get{
            if(chosencourier!=null && chosencourier!='--None--'){
                List<SelectOption> shippingServices = new List<SelectOption>();
                shippingServices.add(new SelectOption('--None--','--None--'));
                Date todayDay= date.today();
                for( zqu__ProductRatePlan__c prp : shippingRatePlans){
                    if(todayDay>=prp.zqu__EffectiveStartDate__c && todayDay<=prp.zqu__EffectiveEndDate__c && prp.zqu__Deleted__c==FALSE){
                        //Take first name from rate plan
                        String courier = prp.ShippingVendor__c;
                        if(chosencourier.equalsIgnoreCase(courier)){
                            shippingServices.add(new SelectOption(prp.Id,prp.Name));
                        }
                    }    
                }
                return shippingServices;
            }else {return null;}
        }
        set;
    }

	//Queries for the Charge based on the shipping Service chosen
	//Pricing is tiered
    public Decimal listShippingCost  {
        get{
            if(chosenShippingService!=null && chosenShippingService!='--None--'  && paymentTerm!=null && quantity!=null && quantity!=''){
                List<zqu__ProductRatePlanCharge__c> prps = [SELECT Id,zqu__Deleted__c,Name,zqu__ListPrice__c,WEXMinPrice__c,zqu__Model__c FROM zqu__ProductRatePlanCharge__c WHERE zqu__Deleted__c = false and zqu__ProductRatePlan__c=:chosenShippingService];
                
                
                if(prps!=null && !prps.isEmpty()){
                    System.debug('Model' + prps[0].zqu__Model__c);
                    
                    if((prps[0].zqu__Model__c).contains('Tiered') || (prps[0].zqu__Model__c).contains('Volume')){
                        
                        List<zqu__ProductRatePlanChargeTier__c> tiers = [Select Id, zqu__Price__c, zqu__Tier__c, zqu__StartingUnit__c, zqu__EndingUnit__c FROM zqu__ProductRatePlanChargeTier__c WHERE zqu__ProductRatePlanCharge__c = :prps[0].Id ORDER BY zqu__Tier__c];
                    
                        //Pricing must be calculated manually
                        if(tiers != null && !tiers.isEmpty()){
                            //Pricing is tiered
                            if((prps[0].zqu__Model__c).contains('Tiered')){
                                Integer numberOfUnits = Integer.valueOf(quantity);
                                Decimal totalShippingCost = Decimal.valueOf('0.00');
                                //cycles through tiers in Zuora
                                for(zqu__ProductRatePlanChargeTier__c t: tiers){
                                    system.debug(t);
                                    system.debug(numberOfUnits);
                                    //checks if this is not the last tier
                                    if(t.zqu__EndingUnit__c != null){
                                        Integer unitsInThisTier = Integer.valueOf(t.zqu__EndingUnit__c - t.zqu__StartingUnit__c) + 1;
                                        //checks if the quantity falls within this tier
                                        if (t.zqu__EndingUnit__c > numberOfUnits){
                                             unitsInThisTier = Integer.valueOf(numberOfUnits - t.zqu__StartingUnit__c) + 1;
                                        }
                                        system.debug(totalShippingCost + (unitsInThisTier * t.zqu__Price__c) + ' = ' + totalShippingCost + ' + {' + unitsInThisTier + ' * ' + t.zqu__Price__c + ');');
                                        totalShippingCost = totalShippingCost + (unitsInThisTier * t.zqu__Price__c);
                                        //Quantity of items is less than the tier, done with the calculation
                                        if(t.zqu__EndingUnit__c >= numberOfUnits){
                                            break;
                                        }
                                     //last tier, calculate for tier, add to total end for loop 
                                    }else{
                                        Integer unitsInThisTier = numberOfUnits - Integer.valueOf(t.zqu__StartingUnit__c) + 1;
                                        system.debug(totalShippingCost + (unitsInThisTier * t.zqu__Price__c) + ' = ' + totalShippingCost + ' + {' + unitsInThisTier + ' * ' + t.zqu__Price__c + ');');
                                        totalShippingCost = totalShippingCost + (unitsInThisTier * t.zqu__Price__c);
                                        
                                        break;
                                    }
                                }
                                
                                editProductFirstSet = false;
                                return (totalShippingCost);
                            //pricing is Volume
                            }else{
                                
                                Integer numberOfUnits = Integer.valueOf(quantity);
                                
                                for(zqu__ProductRatePlanChargeTier__c t: tiers){
                                    system.debug(t);
                                    system.debug(numberOfUnits);
                                    
                                    //checks if this is the last tier
                                    if(t.zqu__EndingUnit__c == null){
                                        
                                       return (numberOfUnits * t.zqu__Price__c);
                                        
                                    }else if (t.zqu__EndingUnit__c >= numberOfUnits && t.zqu__StartingUnit__c <= numberOfUnits){
                                        
                                        return (numberOfUnits * t.zqu__Price__c);
                                    }
                                }
                                
                                return Decimal.valueOf('0.00');
                                
                            }
                            
                        }
                    }
                    
                    
                    shippingMinPrice = prps[0].WEXMinPrice__c;
                    
                    if (prps[0].zqu__ListPrice__c == null){
                        prps[0].zqu__ListPrice__c = 0;
                    }
                    
                    editProductFirstSet = false;
                    return (prps[0].zqu__ListPrice__c.setScale(2));
                }else{
                    shippingMinPrice = null;
                    return null;
                }
            }else {
                shippingMinPrice = null; 
                return null;
            }
        }
        set;
    }
    
    /*
     * Controller Initialization
     */
    public newQuoteCustomController(ApexPages.StandardController controller){
        
        isEditingProduct=FALSE;
        shipmentEdit=false;
        zqu.NotificationOptions notOpt = new zqu.NotificationOptions();
        notOpt.isPopup = true;
        notOpt.continueAction = 'stayOnCurrentPage();';
        notOpt.continueLabel = 'OK';
        notificationOptions = notOpt;
        shippingCostsList=new List<String>();
        
        final String qId=ApexPages.currentPage().getParameters().get('quoteid');
        final String oppId=ApexPages.currentPage().getParameters().get('oppid');
        opportunityId=oppId;
        quoteId=qId;
        discountChange=FALSE;
        shippingProductChosen=true;
        
        final List<zqu__Quote__c> quoteList = [SELECT Id,Vendor__c,zqu__BillToContact__c,zqu__Opportunity__c,zqu__Account__c,zqu__PaymentTerm__c, Chosen_PDF_Template__c FROM zqu__Quote__c WHERE Id = :qId limit 1];
        
        paymentTerm = quoteList.get(0).zqu__PaymentTerm__c;
        accId=quoteList.get(0).zqu__Account__c;
        billToId=quoteList.get(0).zqu__BillToContact__c;
        quote=quoteList.get(0);
        
        //Shipments Are Queried From Quote and their children Shipment Charge Groups
        List<Shipment__c> shipments = [SELECT Id,Address_Line_1__c,Address_Line_2__c,City__c,Shipping_Contact__c,Shipping_Contact_Email__c,Shipping_Contact_Phone__c,State__c,Zip__c,
                                       (Select Id, ChargeType__c, Discount__c, Effective_Price__c, List_Price__c, 
                                         List_Total__c, PaymentTerm__c, ProductCategory__c, Product_Id__c,
                                         Product_Name__c, ProductRatePlanCharge__c, Quantity__c,
                                         RatePlanChargeId__c, RatePlanId__c, Rate_Plan_Name__c,
                                         Recurring_Monthly_Expense__c, ServiceTerm__c, Shipment__c,
                                         Shipment_Cost__c, Total__c, 
                                         Shipping_Carrier__c, Shipping_Carrier_Id__c, Shipping_Carrier_Zuora_Id__c,
                                         Shipping_Service_Id__c, Shipping_Service__c, Shipping_Service_Zuora_Id__c
                                         from Shipment_Charge_Groups__r)
                                       FROM Shipment__c where Quote__c=:quoteId];
        
        shipment=shipments;
        
        shipmentMetrics = new Map<String, List<Decimal>>();
        
        System.Debug('shipment'+shipment);
        System.debug('shipmentcharges '+shipments[0].Shipment_Charge_Groups__r);
        
        productCounter = 0;
        TotalQuoteHardware = 0;
        TotalQuoteServices = 0;
        
        //If there are existing Shipment Group Charges, the Product List must be created and updated
        if(shipments != null && !shipments.isEmpty() && shipments[0].Shipment_Charge_Groups__r != null && !(shipments[0].Shipment_Charge_Groups__r).isEmpty()){
            recreateProductsForEachShipment(shipments);
            //Show Bottom Section
            productMapSize = true;
        } else {
            productsForEachShipment = new Map<String,List<ProductInfo>>();
            //Bottom Section is hidden
            productMapSize = false;
        }
    }
    
    //Controller Helper Method Recreates the products shown in the product list
    public void recreateProductsForEachShipment(List<Shipment__c> shipment){
        Map<String,List<ProductInfo>> productsAndLocationsMap = new Map<String,List<ProductInfo>>();
        productsForEachShipment=productsAndLocationsMap;
        
        for(Shipment__c s: shipment){
            List<ProductInfo> prodinfoList = new List<ProductInfo>();
            
            if(s.Shipment_Charge_Groups__r == null || (s.Shipment_Charge_Groups__r).isEmpty()){
                continue;
            }
            
            List<Decimal> shipmentmet = new List<Decimal>{Decimal.valueOf('0.00'), Decimal.valueOf('0.00'), Decimal.valueOf('0.00')};
            
            for(Shipment_Charge_Group__c sc: s.Shipment_Charge_Groups__r){
                ProductInfo prodInfo = new ProductInfo();
                prodInfo.chargeID=sc.Id;
                prodInfo.localId=productCounter++;
                prodInfo.ProductCategory=sc.ProductCategory__c;
                prodInfo.Product=sc.Product_Name__c;
                prodInfo.ProductId=sc.Product_Id__c;
                prodInfo.ProdRatePlan = sc.Rate_Plan_Name__c;
                if(sc.PaymentTerm__c == null)
                    prodInfo.PaymentTerm=String.valueOf('1');
                else
                    prodInfo.PaymentTerm=sc.PaymentTerm__c;
                    prodInfo.Quantity=String.valueOf(sc.Quantity__c);
                    String discountString = (sc.Discount__c).split('%')[0];
                    prodInfo.ListUnitCost=(sc.Total__c/(sc.Quantity__c * Integer.valueOf(sc.PaymentTerm__c)))/((100-Decimal.valueOf(discountString))/100);
                    prodInfo.Discount=sc.Discount__c;
                    prodInfo.AdjustedUnitCost=sc.Total__c/(sc.Quantity__c * Integer.valueOf(sc.PaymentTerm__c));
                if(sc.Recurring_Monthly_Expense__c != null){
                    prodInfo.TotalMOPaymentEU=sc.Recurring_Monthly_Expense__c/sc.Quantity__c;
                    prodInfo.TotalMOPayment=sc.Recurring_Monthly_Expense__c;
                }else{
                    prodInfo.TotalMOPaymentEU=(sc.Total__c/sc.Quantity__c)/Integer.valueOf(sc.PaymentTerm__c);
                    prodInfo.TotalMOPayment=sc.Total__c/Integer.valueOf(sc.PaymentTerm__c);
                }
                prodInfo.TotalPrice=sc.Total__c;
                
                prodInfo.ShipContactPhone=s.Shipping_Contact_Phone__c;
                prodInfo.ShipContactMail=s.Shipping_Contact_Email__c;
                prodInfo.ShipContact=s.Shipping_Contact__c;
                prodInfo.ShipZip=s.Zip__c;
                prodInfo.ShipState=s.State__c;
                prodInfo.ShipCity=s.City__c;
                
                prodInfo.ShipAdressLine2=s.Address_Line_2__c;
                prodInfo.ShipAdressLine1=s.Address_Line_1__c;
                prodInfo.shipmentId=String.valueOf(sc.Shipment__c);
                prodInfo.ShipCost=sc.Shipment_Cost__c;
                prodInfo.ProductRateplanId = sc.RatePlanId__c;
                prodInfo.ProductRatePlanChargeZuoraId = sc.RatePlanChargeId__c;
                prodInfo.ProductRatePlanChargeId = sc.ProductRatePlanCharge__c; 
                prodInfo.ChargeType = sc.ChargeType__c;
                prodInfo.shipmentEdit = false;
                prodInfo.ShipCarrier = sc.Shipping_Carrier__c;
                prodInfo.ShipCarrierId = sc.Shipping_Carrier_Id__c;
                prodInfo.ShipCarrierZuoraId = sc.Shipping_Carrier_Zuora_Id__c;
                prodInfo.ShipService = sc.Shipping_Service__c;
                prodInfo.ShipServiceId = sc.Shipping_Service_Id__c;
                prodInfo.ShipServiceZuoraId = sc.Shipping_Service_Zuora_Id__c;
                
                prodinfoList.add(prodInfo);
                
                //Shipping & Handling
                shipmentmet.set(0, prodInfo.ShipCost + shipmentmet.get(0));
                //Applicable One-Time Expense:
                if(prodInfo.TotalPrice != null && !prodInfo.ChargeType.equalsignorecase('Recurring')){
                    shipmentmet.set(1, prodInfo.TotalPrice + shipmentmet.get(1));
                }
                //Recurring Monthly Expense
                if(prodInfo.TotalMOPayment != null && prodInfo.ChargeType.equalsignorecase('Recurring')){
                   shipmentmet.set(2, prodInfo.TotalMOPayment + shipmentmet.get(2));
                }
                
																												
																																															  
                if(sc.Quantity__c != null && sc.ProductCategory__c == 'Telematics Hardware'){
                   TotalQuoteHardware = TotalQuoteHardware + Integer.valueOf(sc.Quantity__c);
                }
																																			  
                if(sc.Quantity__c != null && sc.ProductCategory__c == 'Monthly Service'){
                   TotalQuoteServices = TotalQuoteServices + Integer.valueOf(sc.Quantity__c);
                }
            }
            System.debug('prodinfoList ' + prodinfoList);
            productsForEachShipment.put(s.Id,prodinfoList);
            shipmentMetrics.put(s.Id, shipmentmet);
        }
    }
    
    public void defaultValues(){
        quantity='1';
        adjustedUnitCost=String.valueOf(listUnitCost);
    }
    
    public void confirmError(){
        ApexPages.getMessages().clear();
    }
    
    //Refreshes the values in the Product Selector
    //Refreshes based on which fields where edited
    public void panelrefresh(){
        System.Debug('Panel refresh ' + priceUpdateParam);   
        
        if(totalPrice!=null && paymentTerm!=null && paymentTerm!='0' && paymentTerm!='' && (priceUpdateParam == null || priceUpdateParam.equals('monthlyPayment'))){
                system.debug('updated TotalMoPayment: ' + TotalMoPayment);

                Decimal totalMO = decimal.valueOf(TotalMoPayment);
                Integer q = Integer.valueOf(quantity);
                adjustedUnitCost = String.valueOf(totalMo/q);
                system.debug('Final AdjustedUnitCost: ' + adjustedUnitCost);
        }

        //Note(Jeff) - Empty out fields on product changes
        if(priceUpdateParam.equals('adjustProductCategory')){
            quantity='';                      
            listUnitCost=null;                     
            chosenProduct='--None--';                     
            adjustedUnitCost='';                    
            chosenProdRatePlan='';                             
            discount='';                         
            TotalMoPayment='';
            paymentTerm='';
            totalPrice=null;
            chosenShippingService=null;
            listShippingCost=null;
        }else if(priceUpdateParam.equals('adjustProduct')){
            quantity='';                    
            listUnitCost=null;                               
            adjustedUnitCost='';   
            chosenProdRatePlan='--None--';                               
            discount='';                         
            TotalMoPayment='';
            paymentTerm='';
            totalPrice=null;
            chosenShippingService=null;
            listShippingCost=null;
        }

        //Note(Jeff) - Hide Shipping fields if service product chosen
        //Tan - Change to use IsShipping field
        //shippingProductChosen = shippingMapping.get(chosenProduct);
        if (chosenCategory.contains('Hardware') || chosenCategory.contains('Harnesses')){
            shippingProductChosen = true;
        } else {
            shippingProductChosen = false;
            listShippingCost = Decimal.valueOf('0.00');
        }
    }
    
    public static void findPRP(){
    }
    
    //Inner class creates instance of product
    public class ProductInfo{
        
        public String Product {get;set;}
        public String ProductCategory {get;set;}
        public String quoteRatePlanId {get;set;}
        public String ProdRatePlan {get;set;}
        
        public String PaymentTerm {get;set;}
        public String Quantity {get;set;}
        public Decimal ListUnitCost {get;set;}
        public String Discount {get;set;}
        public Decimal AdjustedUnitCost {get;set;}
        public Decimal TotalMOPayment { get; set; }
        public Decimal TotalMOPaymentEU {get;set;}
        public Decimal TotalPrice {get;set;}
        
        public Decimal ShipCost {get;set;}
        public String ShipCarrier {get;set;}
        public String ShipCarrierId {get;set;}
        public String ShipCarrierZuoraId {get;set;}
        public String ShipService {get;set;}
        public String ShipServiceId {get;set;}
        public String ShipServiceZuoraId {get;set;}
        public String shipmentId {get;set;}
        
        public String ShipAdressLine1 {get;set;}
        public String ShipAdressLine2 {get;set;}
        public String ShipCity {get;set;}
        public String ShipState {get;set;}
        public String ShipZip {get;set;}
        public String ShipContact {get;set;}
        public String ShipContactMail {get;set;}
        public String ShipContactPhone {get;set;}
        
        public String ProductId {get;set;}
        public String ProductRatePlanId {get;set;}
        public String ProductRatePlanChargeId {get;set;}
        public String ProductRatePlanChargeZuoraId {get;set;}
        
        public String ChargeType {get;set;}
        public Integer localId {get;set;}
        public Boolean shipmentEdit {get;set;}
        
        private Id chargeID {get;set;}
        
    }
    
    //Method used when adding and editing a product
    //Validates if required fields are filled
    //Called by Add Item button
    public PageReference addProduct(){
        
        if(chosenCategory==null || chosenCategory=='--None--'){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Product Category is a required field.');
            ApexPages.addMessage(myMsg);
            return null;
        }else if(chosenProduct==null || chosenProduct=='--None--'){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Product Name is a required field.');
            ApexPages.addMessage(myMsg);
            return null;
        }else if(chosenProdRatePlan==null || chosenProdRatePlan=='--None--'){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Product Rate Plan is a required field.');
            ApexPages.addMessage(myMsg); 
            return null;
        }else if(adjustedUnitCost==null || adjustedUnitCost==''){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Adjusted Unit Cost is a required field.');
            ApexPages.addMessage(myMsg); 
            return null;
        }else if(quantity==null || quantity==''){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Quantity is a required field.');
            ApexPages.addMessage(myMsg); 
            return null;
        }else if(chosenShipping==null || chosenShipping=='--None--'){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please specify a Shipping Location!');
            ApexPages.addMessage(myMsg); 
            return null;
        }else if((chosenCategory.contains('Hardware') || chosenCategory.contains('Harnesses')) && (chosencourier==null || chosencourier=='--None--')){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Shipping Carrier is a required field');
            ApexPages.addMessage(myMsg); 
            return null;
        }else if((chosenCategory.contains('Hardware') || chosenCategory.contains('Harnesses')) && (chosenShippingService==null || chosenShippingService=='--None--')){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Shipping Service is a required field');
            ApexPages.addMessage(myMsg); 
            return null;
        }
        
        if(!shippingProductChosen){
            listShippingCost = Decimal.valueOf('0.00');
        }
        //Functionality if the product is being edited
        //Product is removed and readded to the product list with its updates values
        Id shipmentChargeEditingId;
        if(isEditingProduct){
            System.debug('addProduct isEditingProduct');
            for(Integer counter=0;counter<productsForEachShipment.get(shipmentId).size();counter++){
                
                if(productsForEachShipment.get(shipmentId).get(counter).localId==localChargeId){
                    
                    ProductInfo p = productsForEachShipment.get(shipmentId).get(counter);
                    
                    if(productsForEachShipment.get(shipmentId).get(counter).chargeID != null || (productsForEachShipment.get(shipmentId).get(counter)).chargeID != ''){
                        Id scId = (productsForEachShipment.get(shipmentId).get(counter)).chargeID;
                        shipmentChargeEditingId = scId;
                    }
                
                    //Shipping & Handling
                    (shipmentMetrics.get(shipmentId)).set(0, (shipmentMetrics.get(shipmentId)).get(0) - p.ShipCost);
                    //Applicable One-Time Expense:
                    if(p.TotalPrice != null && !p.ChargeType.equalsignorecase('Recurring')){
                        (shipmentMetrics.get(shipmentId)).set(1, (shipmentMetrics.get(shipmentId)).get(1) - p.TotalPrice);
                    }
                    //Recurring Monthly Expense
                    if(p.TotalMOPayment != null && p.ChargeType.equalsignorecase('Recurring')){
                       (shipmentMetrics.get(shipmentId)).set(2, (shipmentMetrics.get(shipmentId)).get(2) - p.TotalMOPayment);
                    }
                    
                    if(p.Quantity != null && p.Quantity != '' && p.ProductCategory == 'Telematics Hardware'){
                        TotalQuoteHardware = TotalQuoteHardware - Integer.valueOf(p.Quantity);
                    }
                    if(p.Quantity != null && p.Quantity != '' && p.ProductCategory == 'Monthly Service'){
                        TotalQuoteServices = TotalQuoteServices - Integer.valueOf(p.Quantity);
                    }
                    System.debug('addProduct removing product');
                    productsForEachShipment.get(shipmentId).remove(counter);
                    
                    break;
                }
                
            }
            
            List<ProductInfo> productsToEdit=productsForEachShipment.get(shipmentId);
        
            if(productsToEdit == null || productsToEdit.isEmpty()){
                productsForEachShipment.remove(shipmentId);
            }
            
            if(productsForEachShipment.values() == null || (productsForEachShipment.values()).isEmpty()){
                System.debug('empty products');
                Map<String,List<ProductInfo>> productsAndLocationsMap = new Map<String,List<ProductInfo>>();
                productsForEachShipment=productsAndLocationsMap;
                productMapSize = false;
            }
            
        }
        
        //Creates new Product
        ProductInfo prodInfo = new ProductInfo();
        //Queries for product information that could not be set in the top drop down menus
        List<zqu__ZProduct__c> product = [SELECT Id,Name,WexProductCategory__c from zqu__ZProduct__c WHERE Id=:chosenProduct Limit 1];
        List<zqu__ProductRatePlan__c> productRatePlan =  [SELECT Id, Name,zqu__ZuoraId__c FROM zqu__ProductRatePlan__c WHERE zqu__ZProduct__c =:chosenProduct AND Id=:chosenProdRatePlan ];
        List<zqu__ProductRatePlanCharge__c> productRatePlanCharge = [Select Id, Name,zqu__ZuoraId__c,zqu__Type__c,WEXMinPrice__c FROM zqu__ProductRatePlanCharge__c WHERE zqu__ProductRatePlan__c = :chosenProdRatePlan AND zqu__Deleted__c = false];
        //Queries for shipping information that could not be set in the top drop down menus
        List<zqu__ProductRatePlanCharge__c> shipRatePlanCharge = [Select Id,zqu__ZuoraId__c, Name, zqu__ProductRatePlan__r.Id, zqu__ProductRatePlan__r.Name, zqu__ProductRatePlan__r.zqu__ZuoraId__c FROM zqu__ProductRatePlanCharge__c WHERE zqu__ProductRatePlan__c = :chosenShippingService AND zqu__Deleted__c = false];
        
        Shipment__c s = shippingsInMap.get(chosenShipping);
        if(isEditingProduct==true){
            prodInfo.chargeID = shipmentChargeEditingId;
            isEditingProduct=False;
        }
        prodInfo.ProductCategory=chosenCategory;
        prodInfo.localId=productCounter++;
        prodInfo.ProductId=product.get(0).Id;
        prodInfo.Product=product.get(0).Name;
        prodInfo.ProdRatePlan = productRatePlan.get(0).Name;
        prodInfo.PaymentTerm=paymentTerm;
        prodInfo.Quantity=quantity;
        prodInfo.ListUnitCost=listUnitCost;
        prodInfo.Discount=discount;
        prodInfo.AdjustedUnitCost=Decimal.valueOf(adjustedUnitCost);
        prodInfo.TotalPrice=totalPrice;
        prodInfo.ShipContactPhone=s.Shipping_Contact_Phone__c;
        prodInfo.ShipContactMail=s.Shipping_Contact_Email__c;
        prodInfo.ShipContact=s.Shipping_Contact__c;
        prodInfo.ShipZip=s.Zip__c;
        prodInfo.ShipState=s.State__c;
        prodInfo.ShipCity=s.City__c;
        prodInfo.ShipAdressLine2=s.Address_Line_2__c;
        prodInfo.ShipAdressLine1=s.Address_Line_1__c;
        prodInfo.shipmentId=s.Id;
        prodInfo.ShipCost=listShippingCost;
        if(listShippingCost == null){
            prodInfo.ShipCost=Decimal.valueof('0.00');
        }
        
        if(chosenCategory.contains('Hardware') || chosenCategory.contains('Harnesses')){
            prodInfo.ShipCarrier=chosencourier;
            prodInfo.ShipCarrierId = shipRatePlanCharge[0].zqu__ProductRatePlan__r.Id;
            prodInfo.ShipCarrierZuoraId = shipRatePlanCharge[0].zqu__ProductRatePlan__r.zqu__ZuoraId__c;
            prodInfo.ShipService=shipRatePlanCharge[0].zqu__ProductRatePlan__r.Name;
            prodInfo.ShipServiceId=chosenShippingService;
            prodInfo.ShipServiceZuoraId = shipRatePlanCharge[0].zqu__ZuoraId__c;
        }
        
        prodInfo.ProductRateplanId = productRatePlan[0].zqu__ZuoraId__c;
        prodInfo.ProductRatePlanChargeZuoraId = productRatePlanCharge[productRatePlanCharge.size()-1].zqu__ZuoraId__c;
        prodInfo.ProductRatePlanChargeId = productRatePlanCharge[productRatePlanCharge.size()-1].Id; 
        prodInfo.ChargeType = productRatePlanCharge[productRatePlanCharge.size()-1].zqu__Type__c;
        prodInfo.shipmentEdit = false;
        prodInfo.TotalMOPaymentEU=Decimal.valueOf(TotalMOPayment)/Integer.valueOf(quantity);
        prodInfo.TotalMOPayment = Decimal.valueOf(TotalMOPayment); 
        if(listShippingCost!=null){
            shippingCostsList.add(String.valueof(listShippingCost));
        }
        System.debug('prodInfo ' + prodInfo);
        
        //Quote TotalQuoteHardware and TotalQuoteServices values are Updated
        if(prodInfo.Quantity != null && prodInfo.Quantity != '' && prodInfo.ProductCategory == 'Telematics Hardware'){
            TotalQuoteHardware = TotalQuoteHardware + Integer.valueOf(prodInfo.Quantity);
        }
        if(prodInfo.Quantity != null && prodInfo.Quantity != '' && prodInfo.ProductCategory == 'Monthly Service'){
            TotalQuoteServices = TotalQuoteServices + Integer.valueOf(prodInfo.Quantity);
        }
        
        //Product is added to List
        //If checks if list has been created
        if(productsForEachShipment!=null && !productsForEachShipment.isEmpty()){
            
            System.Debug('First - productsForEachShipment'+productsForEachShipment);
            //If checks if a product has been added to this shipment
            if(productsForEachShipment.containsKey(chosenShipping)){
                productsForEachShipment.get(chosenShipping).add(prodInfo);
                System.Debug('Second - productsForEachShipment'+productsForEachShipment);
                
                //Shipping & Handling
                (shipmentMetrics.get(chosenShipping)).set(0, prodInfo.ShipCost + (shipmentMetrics.get(chosenShipping)).get(0));
                //Applicable One-Time Expense:
                if(prodInfo.TotalPrice != null && !prodInfo.ChargeType.equalsignorecase('Recurring')){
                    (shipmentMetrics.get(chosenShipping)).set(1, prodInfo.TotalPrice + (shipmentMetrics.get(chosenShipping)).get(1));
                }
                //Recurring Monthly Expense
                if(prodInfo.TotalMOPayment != null && prodInfo.ChargeType.equalsignorecase('Recurring')){
                   (shipmentMetrics.get(chosenShipping)).set(2, prodInfo.TotalMOPayment + (shipmentMetrics.get(chosenShipping)).get(2));
                }
            }
            //Creates new product list mapped to this shipment
            else{
                List<ProductInfo> prodinfoList = new List<ProductInfo>();
                prodinfoList.add(prodInfo);
                productsForEachShipment.put(chosenShipping,prodinfoList);
                System.Debug('Third - productsForEachShipment'+productsForEachShipment);
                
                List<Decimal> shipmentmet = new List<Decimal>();
                shipmentmet.add(prodInfo.ShipCost);
                if(prodInfo.TotalPrice != null && !prodInfo.ChargeType.equalsignorecase('Recurring')){
                    shipmentmet.add(prodInfo.TotalPrice);
                }else{
                    shipmentmet.add(Decimal.valueOf('0.00'));
                }
                if(prodInfo.TotalMOPayment != null && prodInfo.ChargeType.equalsignorecase('Recurring')){
                    shipmentmet.add(prodInfo.TotalMOPayment);
                }else{
                    shipmentmet.add(Decimal.valueOf('0.00'));
                }
                shipmentMetrics.put(chosenShipping, shipmentmet);
            }
        //No previous products added, ProductList must be instantiated
        } else {
            Map<String,List<ProductInfo>> productsAndLocationsMap = new Map<String,List<ProductInfo>>();
            productsForEachShipment=productsAndLocationsMap;
            
            List<ProductInfo> prodinfoList = new List<ProductInfo>();
            prodinfoList.add(prodInfo);
            
            productsForEachShipment.put(chosenShipping,prodinfoList);
            System.Debug('Fourth - productsForEachShipment'+productsForEachShipment);
            
            List<Decimal> shipmentmet = new List<Decimal>();
            shipmentmet.add(prodInfo.ShipCost);
            if(prodInfo.TotalPrice != null && !prodInfo.ChargeType.equalsignorecase('Recurring')){
                shipmentmet.add(prodInfo.TotalPrice);
            }else{
                shipmentmet.add(Decimal.valueOf('0.00'));
            }
            if(prodInfo.TotalMOPayment != null && prodInfo.ChargeType.equalsignorecase('Recurring')){
                shipmentmet.add(prodInfo.TotalMOPayment);
            }else{
                shipmentmet.add(Decimal.valueOf('0.00'));
            }
            shipmentMetrics.put(chosenShipping, shipmentmet);
            System.debug('shipmentMetrics ' + shipmentMetrics);
        }

        //Note(Jeff) - 47721: Display warning on adjusted unit cost below min price
        if(!String.isBlank(productRatePlanCharge[productRatePlanCharge.size()-1].WEXMinPrice__c) && !String.isBlank(adjustedUnitCost)){
            Decimal wexMinPriceDecimal = decimal.valueOf(productRatePlanCharge[productRatePlanCharge.size()-1].WEXMinPrice__c);
            Decimal adjustedUnitCostDecimal = decimal.valueOf(adjustedUnitCost) * Integer.valueof(paymentTerm);
            if (adjustedUnitCostDecimal < wexMinPriceDecimal){
                notificationOptions.backLabel = 'OK';
                notificationOptions.continueAction = '';
                notificationOptions.backAction = 'stayOnCurrentPage();';
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'This cost is below the minimum price in the WEX product catalog so this quote will not generate without approval.');
                ApexPages.addMessage(myMsg);
            }            
        }
        //Checks if price of product is below the Minimum Price
        if(!String.isBlank(shippingMinPrice) && listShippingCost != null && (chosenCategory.contains('Hardware') || chosenCategory.contains('Harnesses'))){
            Decimal wexMinPriceShippingDecimal = decimal.valueOf(shippingMinPrice);
            Decimal shippingCostDecimal = listShippingCost;
            if (shippingCostDecimal < wexMinPriceShippingDecimal){
                notificationOptions.backLabel = 'OK';
                notificationOptions.continueAction = '';
                notificationOptions.backAction = 'stayOnCurrentPage();';
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'The shipping cost is below the minimum price in the WEX product catalog so this quote will not generate without approval.');
                ApexPages.addMessage(myMsg);
            }            
        }
        //Checks if the shipping cost is 0
        /*if(listShippingCost != null && (chosenCategory.contains('Hardware') || chosenCategory.contains('Harnesses'))){
            Decimal shippingCostDecimal = listShippingCost;
            if (shippingCostDecimal == Decimal.valueOf('0.00') ){
                notificationOptions.backLabel = 'OK';
                notificationOptions.continueAction = '';
                notificationOptions.backAction = 'stayOnCurrentPage();';
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'The shipping cost is listed as $0.00 so this quote will not generate without approval.');
                ApexPages.addMessage(myMsg);
            }            
        }*/
        
        //Bottom Section is rendered
        productMapSize = true;
        
        System.debug('productsForEachShipment ' + productsForEachShipment);
        
        return null;
        
    }
    
    //Method handles edit functionality
    //Called by Edit button by shipments in bottom section
    //Functions like edit Shipment on Quote Page 1
    public void editShipment(){ 
       
       Integer errorCounter = 0;
       List<ProductInfo> pInfo = productsForEachShipment.get(editShipmentId);
       Boolean localShipEdit = pInfo.get(0).shipmentEdit;
       
        //Validates Required are filled in 
        if(localShipEdit){
            
            if(pInfo[0].ShipAdressLine1==''){
                errorCounter++;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING,  'Shipping Address Line 1 is a required field. No shipping locations have been provided. Please add a shipping location.'));
            }if(pInfo[0].ShipCity==''){
                errorCounter++;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'Shipping City is a required field.'));
            }if(pInfo[0].ShipState==''){
                 errorCounter++;
                 ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'Shipping State is a required field.'));
            }if(pInfo[0].ShipZip==''){
                 errorCounter++;
                 ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'Shipping Zip Code is a required field.'));
            }if(pInfo[0].shipContact==''){
                 errorCounter++;
                 ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'Shipping Contact Name is a required field.'));
            }if(pInfo[0].shipContactPhone==''){
                 errorCounter++;
                 ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'Shipping Contact Phone is a required field.'));
            }if(pInfo[0].ShipContactMail==''){
                 errorCounter++;
                 ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'Shipping Contact Email is a required field.'));
            }
            
            if(errorCounter == 0){
                
                validateEditedAddress(pInfo[0]);
                
                 //update shipment in shipment list
            }else{
                notificationOptions.backLabel = 'OK';
                notificationOptions.continueAction = '';
                notificationOptions.backAction = 'stayOnCurrentPage();';
            }
        }else{
            pInfo.get(0).shipmentEdit =  !localShipEdit;
            shipmentEdit = !shipmentEdit;
        }
            
    }
    
    //Cancels the edit made to Shipment and rolls back any changes
    public void cancelEditShipment(){
        
        List<ProductInfo> pInfo = productsForEachShipment.get(editShipmentId);
        
        for(Shipment__c s: shipment){
            if(editShipmentId.equals(s.Id)){
                pInfo[0].ShipAdressLine1 = s.Address_Line_1__c;
                pInfo[0].ShipAdressLine2 = s.Address_Line_2__c;
                pInfo[0].ShipCity = s.City__c;
                pInfo[0].ShipState = s.State__c;
                pInfo[0].shipZip = s.Zip__c;
                
                pInfo[0].shipContact= s.Shipping_Contact__c;
                pInfo[0].shipContactPhone = s.Shipping_Contact_Phone__c;
                pInfo[0].ShipContactMail= s.Shipping_Contact_Email__c;
                
                break;
            }
        }
            
        pInfo.get(0).shipmentEdit = false;
    }
    
    //Validates Edited Shipment Address
    //Functions like validateAdress in Quote Page 1
    private void validateEditedAddress(ProductInfo p){
         List<ProductInfo> pInfo = productsForEachShipment.get(editShipmentId);
        //Note(Jeff Tan): Begin code for address verification
            CCH_Transaction.ResolveAddressRequest address = new CCH_Transaction.ResolveAddressRequest();
            address.Address1 = p.ShipAdressLine1;
            address.Address2 = p.ShipAdressLine2;
            address.City = p.ShipCity;
            address.State = p.ShipState;
            address.Zip = p.shipZip;
            CCH__c cchSetting = [Select API_Password__c, API_Username__c, API_Endpoint__c, Message_Address_Invalid__c, Message_Address_Correction__c from CCH__c limit 1];
            CCH_Transaction.STxTransactionServiceEndpointPort cchService = new CCH_Transaction.STxTransactionServiceEndpointPort(cchSetting.API_Username__c, cchSetting.API_Password__c, cchSetting.API_Endpoint__c);       
            CCH_Transaction.ResolveAddressResult addressResult = cchService.ResolveAddress(address);
            String addressResultType = addressResult.ResultType;
        
            if (!addressResultType.equalsIgnoreCase('FULL')){
                //Address must be valid, only option to cancel
                notificationOptions.backLabel = 'OK';
                notificationOptions.backAction = 'stayOnCurrentPage();';
                notificationOptions.continueAction = '';
                System.Debug('Address Invalid');
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, cchSetting.Message_Address_Invalid__c));
            }else if (!addressResult.ResolvedAddress.Address1.equalsIgnoreCase(p.ShipAdressLine1) || 
               !addressResult.ResolvedAddress.Address2.equalsIgnoreCase(p.ShipAdressLine2) || 
               !addressResult.ResolvedAddress.City.equalsIgnoreCase(p.ShipCity) || 
               !addressResult.ResolvedAddress.State.equalsIgnoreCase(p.ShipState) || 
               !addressResult.ResolvedAddress.Zip.equalsIgnoreCase(p.shipZip)){
                //Only take corrected address or cancel
                correctedAddressResult = addressResult;
                notificationOptions.continueAction = 'takeCorrectedAddress();';
                notificationOptions.backAction = 'stayOnCurrentPage();';
                notificationOptions.backLabel = 'Cancel';
                
                System.Debug('Corrected Address');
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, cchSetting.Message_Address_Correction__c));
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, addressResult.ResolvedAddress.Address1));
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, addressResult.ResolvedAddress.Address2));
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, addressResult.ResolvedAddress.City + ', ' + addressResult.ResolvedAddress.State + ' ' + addressResult.ResolvedAddress.Zip));
               }else{
                   System.Debug('Result is good');
                   updateShippingContact();
                    pInfo.get(0).shipmentEdit = false;
                   ApexPages.getMessages().clear();
               }
    }
    
    //Updates Shipment Information in the UI
    public void takeCorrectedAddress(){
        List<ProductInfo> pInfo = productsForEachShipment.get(editShipmentId);
        if(!Test.isRunningTest()){
            pInfo[0].ShipAdressLine1 = correctedAddressResult.ResolvedAddress.Address1;
            pInfo[0].ShipAdressLine2 = correctedAddressResult.ResolvedAddress.Address2;
            pInfo[0].ShipCity = correctedAddressResult.ResolvedAddress.City;
            pInfo[0].ShipState = correctedAddressResult.ResolvedAddress.State;
            pInfo[0].ShipZip = correctedAddressResult.ResolvedAddress.Zip;
            
        }
        
        updateShippingContact();
        pInfo.get(0).shipmentEdit = false;
        ApexPages.getMessages().clear();
    }
    
    //Updates Shipping Information in the backend
    private void updateShippingContact(){
        System.debug('Updating Shipping Contact');
        List<ProductInfo> pInfo = productsForEachShipment.get(editShipmentId);
        
        for(Shipment__c s: shipment){
            if(editShipmentId.equals(s.Id)){
                s.Address_Line_1__c = pInfo[0].ShipAdressLine1; 
                s.Address_Line_2__c = pInfo[0].ShipAdressLine2;
                s.City__c = pInfo[0].ShipCity;
                s.State__c = pInfo[0].ShipState;
                s.Zip__c = pInfo[0].shipZip ;
                
                s.Shipping_Contact__c = pInfo[0].shipContact;
                s.Shipping_Contact_Phone__c = pInfo[0].shipContactPhone;
                s.Shipping_Contact_Email__c = pInfo[0].ShipContactMail;
                
                break;
            }
        }
        
        update shipment;
    }
    
    //Method require confirmation from the user
    //Called by Cancel button at the bottom of the page
    public void cancelConfirm(){
        
        notificationOptions.continueAction = 'continueToCancelPage();';
        notificationOptions.backAction = 'stayOnCurrentPage();';
        notificationOptions.backLabel = 'Cancel';
        
        //Add a page message prompting the user for input
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'Are you sure you want to cancel this quote?  (This will delete the current quote)'));
    
    }
    
    
    //Throws check if the field in the top section have values and if the products have not been inserted
    //Called by back button on the bottom of the page
    public PageReference back(){
        
        List<zqu__Quote__c> shipmentSize = [Select Id,(Select Id, Name from Shipments__r) from zqu__Quote__c where Id = :quoteId];
        System.debug('shipmentSize ' + (shipmentSize[0].Shipments__r).size());
        
        List<Shipment_Charge_Group__c> shipmentChargesSize = [Select Id from Shipment_Charge_Group__c WHERE Quote__c = :quoteId];
        System.debug('shipmentChargesSize ' + shipmentChargesSize);
        
        if((chosenCategory != '--None--' || quantity != '' || adjustedUnitCost != '' || totalPrice != Decimal.valueOf('0.00') || discount != '0' || TotalMoPayment != null)
          || (chosenShipping != '--None--' || listShippingCost != null)
          || (productsForEachShipment != null && productsForEachShipment.size() > (shipmentSize[0].Shipments__r).size())
          || (productsForEachShipment != null && (productsForEachShipment.values()).size() > shipmentChargesSize.size())){
            notificationOptions.continueAction = 'backConfirmed();';
            notificationOptions.continueLabel = 'Continue to First Page';
            notificationOptions.backAction = 'stayOnCurrentPage();';
            notificationOptions.backLabel = 'Cancel';
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING,'An unfinished line item has not been saved.  Are you sure you want to navigate away from the page?'));
        }else{
            return returnToPreQuote();
        }
        
        return null;
    }
    
    //changes the page reference to the Quote Page 1
    public PageReference returnToPreQuote(){
        
        PageReference  newQuotePage = Page.PrepareNewQuote;
        System.Debug('quote: '+quote);
        newQuotePage.getParameters().put('quoteid', quoteid);
        newQuotePage.getParameters().put('oppid', String.valueOf(opportunityId).substring(0,15));//String.valueOf(this.opp.Id).substring(0,15)
        newQuotePage.setRedirect(true);      
        
        return newQuotePage;
        
    }
    
    //Requires Confirmation from User to submit Quote
    //Cannot submit if there are no products
    public void preSubmitCheck(){

        if (productsForEachShipment!=null & !productsForEachShipment.isEmpty()){
            notificationOptions.continueAction = 'continueToSubmitPage();';
            notificationOptions.continueLabel = 'Confirm Submit';
            notificationOptions.backAction = 'stayOnCurrentPage();';
            notificationOptions.backLabel = 'Cancel';
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'Are you sure you wish to submit this quote for approval?'));
        } else {
            notificationOptions.continueAction = null;
            notificationOptions.continueLabel = null;
            notificationOptions.backAction = 'stayOnCurrentPage();';
            notificationOptions.backLabel = 'OK';
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'There are no products on this quote.  Please add products before submitting this quote.'));
        }
    }
    
    //Creates Shipment Charge Groups for Each Product and inserts into the database
    private void insertShipmentGroupCharges(){
        if(productsForEachShipment!=null & !productsForEachShipment.isEmpty()){
            Map<Id,Shipment__c> shipmentUpdates = new Map<Id,Shipment__c>();
            Map<Id,String> shipmentCarrier = new Map<Id,String>();
            Map<Id,Set<String>> shipmentServices = new Map<Id,Set<String>>();
            List<Shipment_Charge_Group__c> chargeGroups = new List<Shipment_Charge_Group__c>();
            for (List<ProductInfo> productList : productsForEachShipment.values()){
                for (ProductInfo product : productList){
                    Shipment_Charge_Group__c chargeGroup = new Shipment_Charge_Group__c();
                    
                    if(product.chargeID != null){
                       chargeGroup = new Shipment_Charge_Group__c(Id = Id.valueOf(product.chargeID));
                    }
                    
                    chargeGroup.ProductCategory__c = product.productCategory;
                    chargeGroup.ChargeType__c = product.chargeType;
                    chargeGroup.RatePlanId__c = product.productRatePlanId;
                    chargeGroup.Effective_Price__c = product.adjustedUnitCost;
                    chargeGroup.RatePlanChargeId__c = product.productRatePlanChargeZuoraId;
                    chargeGroup.ProductRatePlanCharge__c = product.productRatePlanChargeId;
                    chargeGroup.Quantity__c = Decimal.valueOf(product.quantity);
                    if (product.chargeID == null)
                        chargeGroup.Shipment__c = product.shipmentId;
                    chargeGroup.Quote__c = quoteId;
                    chargeGroup.Discount__c = product.discount;
                    chargeGroup.List_Price__c = product.ListUnitCost;
                    chargeGroup.MRR_EU__c = product.TotalMOPaymentEU;
                    chargeGroup.MRR__c = product.TotalMOPayment;
                    chargeGroup.List_Total__c = chargeGroup.Quantity__c * chargeGroup.List_Price__c;
                    chargeGroup.Total__c = product.TotalPrice;
                    chargeGroup.Name = product.ProdRatePlan;
                    chargeGroup.Product_Name__c = product.Product;
                    chargeGroup.Rate_Plan_Name__c = product.ProdRatePlan;
                    chargeGroup.Shipment_Cost__c = product.ShipCost;
                    chargeGroup.PaymentTerm__c = product.PaymentTerm;
                    chargeGroup.ServiceTerm__c = Integer.valueOf(product.PaymentTerm);
                    chargeGroup.Shipping_Carrier__c = product.ShipCarrier;
                    chargeGroup.Shipping_Carrier_Id__c = product.ShipCarrierId;
                    chargeGroup.Shipping_Carrier_Zuora_Id__c = product.ShipCarrierZuoraId;
                    chargeGroup.Shipping_Service__c = product.ShipService;
                    chargeGroup.Shipping_Service_Id__c = product.ShipServiceId;
                    chargeGroup.Shipping_Service_Zuora_Id__c = product.ShipServiceZuoraId;
                    if(product.ChargeType.equalsignorecase('Recurring')){
                          chargeGroup.Recurring_Monthly_Expense__c =product.TotalMOPayment;
                    }

                    chargeGroups.add(chargeGroup);
                    System.debug('ChargeGroup: ' + chargeGroup); 
                    System.debug('product.ShipCarrier ' + product.ShipCarrier);
                    if(product.ShipCarrier != null){
                    	shipmentCarrier.put(product.shipmentId,product.ShipCarrier);
                    }
                    System.debug('Line 1388 Shipping Service ' + product.ShipService);
                    if(product.ShipService != null && product.ShipService != ''){
                        if(shipmentServices == null || shipmentServices.isEmpty()){
                            Set<String> services = new Set<String>();
                            services.add(product.ShipService);
                            shipmentServices.put(product.shipmentId, services);
                        }else{
                            if((shipmentServices.keySet()).contains(product.shipmentId)){
                                shipmentServices.get(product.shipmentId).add(product.ShipService);
                            }else{
                                Set<String> services = new Set<String>();
                                services.add(product.ShipService);
                                shipmentServices.put(product.shipmentId, services);
                            }
                        }
                    }
                }
            }
			System.debug('shipmentCarrier ' + shipmentCarrier);
            if(shipmentServices != null && !shipmentServices.isEmpty()){
                for(Id shipmentId: shipmentServices.keySet()){
                    Shipment__c updateShipment = new Shipment__c();
                    updateShipment.Id = shipmentId;
                    updateShipment.ShippingCarrier__c = shipmentCarrier.get(shipmentId);
                    
                    for(String service: shipmentServices.get(shipmentId)){
                        
                        if(updateShipment.ShippingService__c == null || updateShipment.ShippingService__c == ''){
                            updateShipment.ShippingService__c = service;
                        }else if(Integer.valueOf((updateShipment.ShippingService__c).length()) + Integer.valueOf(service.length()) <= 255){
                            updateShipment.ShippingService__c = updateShipment.ShippingService__c + ', ' + service;
                        }	
                    }
                    shipmentUpdates.put(shipmentId,updateShipment);
                }
            }
                
            upsert chargeGroups;
            if(shipmentUpdates != null && !shipmentUpdates.isEmpty()){
                System.debug('Updated Shipments ' + shipmentUpdates.values());
                update shipmentUpdates.values();
            }
            
            //Add ids created from the insert onto the related product
            Integer counter = 0;
            for(List<ProductInfo> productList : productsForEachShipment.values()){
                for(ProductInfo product : productList){
                    
                    if(product.chargeId != null){
                        counter++;
                        continue;
                    }
                    product.chargeID = (chargeGroups.get(counter)).ID;
                    counter++;
                    
                }
            }
        }
        
        System.debug('insertShipmentGroupCharges productsForEachShipment ' + productsForEachShipment);
    }
    
    //Creates Shipment Charge for Each Shipment Charge and inserts into the database
    private void insertQuoteCharges(){
        
        if(productsForEachShipment!=null & !productsForEachShipment.isEmpty()){
            insertShipmentGroupCharges();
            
            List<Shipment_Charge__c> existingCharges = [Select Id from Shipment_Charge__c where QuoteLookup__c = :quoteId];
            
            if(existingCharges != null && !existingCharges.isEmpty())
                delete existingCharges;
            
            List<Shipment_Charge__c> subsCharges = new  List<Shipment_Charge__c>();
            for(List<ProductInfo> ips : productsForEachShipment.values()){
                for(ProductInfo ip : ips){
                    System.debug('Product info is: ' + ip); 
                    //Check for shipping cost
                    if(((ip.ProductCategory).contains('Hardware') || (ip.ProductCategory).contains('Harnesses')) && Integer.valueOf(ip.ShipCost) == Integer.valueOf('0')){
                         quote.Shipping_Cost_flag__c = true;
                    }
                    //Check for termination fee
                    if((ip.ProductCategory).contains('Transfer and Admin Fees')){
                         quote.Termination_Fee_Flag__c = true;
                    }
                    
                    //If criteria is met a charge is create for each quantity.
                    //Shipment Group Charge has quantity 5, 5 Shipment Charges are created
                    if(ip.ProductCategory.equalsignorecase('ELD / HOS Software') ||																
                       ip.ProductCategory.equalsignorecase('Monthly Service') ||
                       ip.ProductCategory.equalsignorecase('Telematics Hardware') ||
                       ip.ProductCategory.equalsignorecase('GPS BUNDLE') ||
                       ip.ProductCategory.equalsignorecase('GPS RENTAL') ||
                       (ip.ProductCategory.equalsignorecase('Misc Service') && ip.ChargeType.equalsignorecase('Recurring') )
                      ){
                        Integer qtyCount;
                        for (qtyCount=0;qtyCount<Integer.valueOf(ip.Quantity);qtyCount++){
                            Shipment_Charge__c subscrProdCharge = new Shipment_Charge__c();
                        
                            subscrProdCharge.RatePlanId__c=ip.ProductRatePlanId;
                            subscrProdCharge.Effective_Price__c=ip.adjustedUnitCost; // Or Total price?
                            subscrProdCharge.RatePlanChargeId__c=ip.ProductRatePlanChargeZuoraId; 
                            subscrProdCharge.ProductRatePlanCharge__c = ip.ProductRatePlanChargeId; 
                            subscrProdCharge.Quantity__c=1.0;
                            subscrProdCharge.Shipment__c=ip.ShipmentId; // Product Rate plan or Quote RP?
                            subscrProdCharge.Quote__c = (string)quote.id;
                            subscrProdCharge.ProductCategory__c = ip.ProductCategory;
                            subscrProdCharge.ChargeType__c = ip.ChargeType; 
                            subscrProdCharge.Discount__c = ip.Discount; 
                            subscrProdCharge.List_Price__c = ip.ListUnitCost; 
                            subscrProdCharge.MRR_EU__c = ip.TotalMOPaymentEU; 
                            subscrProdCharge.MRR__c = ip.TotalMOPayment; 
                            subscrProdCharge.List_Total__c = ip.ListUnitCost;
                            Decimal t = ip.TotalPrice / Decimal.valueOf(ip.Quantity); 
                            subscrProdCharge.Total__c = t.setScale(2); 
                            //Marie adding additional fields
                            //Sets the name of the Shipment charge to the rate plan, and sets the other values
                            subscrProdCharge.Name = ip.ProdRatePlan;
                            subscrProdCharge.Product_Name__c = ip.Product;
                            subscrProdCharge.Rate_Plan_Name__c = ip.ProdRatePlan;
                            subscrProdCharge.Shipment_Cost__c = ip.ShipCost;
                            subscrProdCharge.QuoteLookup__c = quoteId;
                            subscrProdCharge.ServiceTerm__c = Integer.valueOf(ip.PaymentTerm);
                            subscrProdCharge.Rate_Plan_Name__c = ip.ProdRatePlan;
                            subscrProdCharge.ShipmentChargeGroup__c = ip.chargeID;
                            if(ip.ChargeType.equalsignorecase('Recurring')){
                                subscrProdCharge.Recurring_Monthly_Expense__c = ip.TotalMOPaymentEU;
                            }else{
                               subscrProdCharge.One_Time_Expense__c = t.setScale(2);
                            }
                                                        
																														   
																			
							 
							
                            subsCharges.add(subscrProdCharge);
                        }
                    }else if(ip.ProductCategory.equalsignorecase('Misc Hardware') ||
					   ip.ProductCategory.equalsignorecase('Driver Training') ||
                       ip.ProductCategory.equalsignorecase('Harnesses & Cables') ||
                       ip.ProductCategory.equalsignorecase('Transfer and Admin Fees') ||
                       ip.ProductCategory.equalsignorecase('Installation') ||
                       ip.ProductCategory.equalsignorecase('GPS FINANCE CHRG') ||
                       ip.ProductCategory.equalsignorecase('Shipping') ||
                       (ip.ProductCategory.equalsignorecase('Misc Service') && !ip.ChargeType.equalsignorecase('Recurring') )
                      ){
                        Shipment_Charge__c subscrProdCharge = new Shipment_Charge__c();
                          
                        subscrProdCharge.RatePlanId__c=ip.ProductRatePlanId;
                        subscrProdCharge.Effective_Price__c=ip.adjustedUnitCost; // Or Total price?
                        subscrProdCharge.RatePlanChargeId__c=ip.ProductRatePlanChargeZuoraId;
                        subscrProdCharge.ProductRatePlanCharge__c = ip.ProductRatePlanChargeId; 
                        subscrProdCharge.Quantity__c=Decimal.valueOf(ip.Quantity);
                        subscrProdCharge.Shipment__c=ip.ShipmentId; // Product Rate plan or Quote RP?
                        subscrProdCharge.Quote__c = (string)quote.id;
                        subscrProdCharge.ProductCategory__c = ip.ProductCategory;
                        subscrProdCharge.ChargeType__c = ip.ChargeType;
                        subscrProdCharge.Discount__c = ip.Discount; 
                        subscrProdCharge.List_Price__c = ip.ListUnitCost; 
                        subscrProdCharge.MRR_EU__c =ip.TotalMOPaymentEU; 
                        subscrProdCharge.MRR__c =ip.TotalMOPayment; 
                        subscrProdCharge.List_Total__c = Decimal.valueOf(ip.Quantity) * ip.ListUnitCost;
                        subscrProdCharge.Total__c =ip.TotalPrice;
                        //Marie adding additional fields
                        //Sets the name of the Shipment charge to the rate plan, and sets the other values
                        subscrProdCharge.Name = ip.ProdRatePlan;
                        subscrProdCharge.Product_Name__c = ip.Product;
                        subscrProdCharge.Rate_Plan_Name__c = ip.ProdRatePlan;
                        subscrProdCharge.Shipment_Cost__c =ip.ShipCost;
                        subscrProdCharge.QuoteLookup__c = quoteId;
                        subscrProdCharge.ServiceTerm__c = Integer.valueOf(ip.PaymentTerm);
                        subscrProdCharge.Rate_Plan_Name__c = ip.ProdRatePlan;
                        subscrProdCharge.ShipmentChargeGroup__c = ip.chargeID;
                        if(ip.ChargeType.equalsignorecase('Recurring')){
                          subscrProdCharge.Recurring_Monthly_Expense__c =ip.TotalMOPayment;
                        }else{
                          subscrProdCharge.One_Time_Expense__c =ip.TotalPrice;
                        }
                          
																													   
																	 
	   
						  
                        subsCharges.add(subscrProdCharge);
                      }
                    //subscrProdCharge.Zuora__Subscription__c=newSubscription.Id;
                    //subscrProdCharge.Zuora__TotalContractValue__c=Decimal.valueOf(ip.TotalPrice);
                    
                }
            }
            upsert subsCharges;
            update quote;
        }
    
    }
    
    //Checks if the hardware and service items are equal
    //Checks if the quote total is over the credit limit
    //Checks if the quote total is over or equal to 60% of the credit limit
    public void checkHardwareServiceonSubmit(){
        
        Decimal primaryCreditLimit; 
        Decimal quoteTotalOneTime; 
        Decimal quoteTotalRecurring; 
        Decimal quoteTotalShipping; 
								 
        String message; 
        
        //Inserting charges used to be here
        //These charges should be inserted when the quote is created
        //User can insert and not continue through submitting flow which is causing problems down stream
        
        zqu__Quote__c pcl = [Select PrimaryCreditLimit__c from zqu__Quote__c where Id = :quoteId LIMIT 1]; 
        
        primaryCreditLimit = Decimal.valueOf(pcl.PrimaryCreditLimit__c);
															 
        
        quoteTotalOneTime = QuoteoneTimeExpense; 
        quoteTotalRecurring = QuoterecurringMonthlyExpense; 
        quoteTotalShipping = QuoteshippingHandling; 
        
        System.debug('60% over credit limit: ' + ((0.6 * primaryCreditLimit) <= (quoteTotalOneTime + 
            quoteTotalRecurring + quoteTotalShipping))); 
        System.debug('Over credit limit: ' + (primaryCreditLimit < (quoteTotalOneTime + 
            quoteTotalRecurring + quoteTotalShipping))); 
        
        message = ''; 
        
        if(TotalQuoteHardware != TotalQuoteServices || 
            (0.6 * primaryCreditLimit) <= (quoteTotalOneTime + quoteTotalRecurring + quoteTotalShipping) || 
            primaryCreditLimit < (quoteTotalOneTime + quoteTotalRecurring + quoteTotalShipping)){
            
            notificationOptions.continueAction = 'continueToCheckProductMatching();';
            notificationOptions.continueLabel = 'Continue';
            notificationOptions.backAction = 'stayOnCurrentPage();';
            notificationOptions.backLabel = 'Cancel'; 
            
            if (TotalQuoteHardware != TotalQuoteServices) {
                System.Debug('Number of Hardware items do not equal number of services.'); 
                //message += 'Number of service items does not equal the number of telematics hardware items.'; 
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'Number of service items does not equal the number of telematics hardware items.')); 
            }    
																												
            if (primaryCreditLimit < (quoteTotalOneTime + 
                quoteTotalRecurring + quoteTotalShipping)) {
                System.Debug('Quote total is over the credit limit.'); 
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'The quote total is over the credit limit.')); 
            } else if ((0.6 * primaryCreditLimit) <= (quoteTotalOneTime + 
                quoteTotalRecurring + quoteTotalShipping) ) { 
                    //Keeping this because I believe this should restrict this approval and it may need to be added back
                    //&& (quoteTotalOneTime + quoteTotalRecurring + quoteTotalShipping) != 0 
                System.Debug('primaryCreditLimit ' + primaryCreditLimit + ' quoteTotalOneTime ' + quoteTotalOneTime + ' quoteTotalRecurring ' + quoteTotalRecurring + ' quoteTotalShipping ' + quoteTotalShipping);
                System.Debug('Quote total is over or equal to 60% of the credit limit.'); 
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'The quote total is over or equal to 60% of the credit limit.')); 
				 
            } 
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, message));            
        } else {
            preSubmitCheck();
        }
        
    }
    
    //Inserts Shipment Charges and Shipment Group Charges, Fires approval process, changes page reference to the newly created quote
    //Called by Submit button at bottom of the page
    public PageReference submitQuote(){
        
        insertQuoteCharges();   
        submitForApproval();
        
        return new PageReference('/'+quote.id);
    }
    
    //Inserts Shipment Group Charges
    //Called by Save button at the bottom of the page
    public void saveQuote(){
        System.debug('Saving quote...');
        
        insertShipmentGroupCharges();
        
        /*KEEPING IN CASE THEY WANT THIS BACK
         * zqu__Quote__c hardwareServiceSame = [Select Hardware_and_Services_are_Equal__c, Number_of_Hardware_Items__c, Number_of_Service_Items__c from zqu__Quote__c where Id = :quoteId];
        if(hardwareServiceSame.Number_of_Hardware_Items__c != hardwareServiceSame.Number_of_Service_Items__c){
            notificationOptions.backLabel = 'OK';
            notificationOptions.backAction = 'stayOnCurrentPage();';
            notificationOptions.continueAction = '';
            System.Debug('Number of Hardware items do not equal number of services.');
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'The number of hardware products does not equal the number of service products'));
        }
        System.debug('Hardware different than Services ' + hardwareServiceSame);*/
    }
    
    //Submits the quote to the approval process 
    public void submitForApproval(){
        Approval.ProcessSubmitRequest approve = new Approval.ProcessSubmitRequest();
        
        approve.setComments('Automated submit for approval');
        approve.setObjectId(quoteid);
        approve.setSubmitterId(UserInfo.getUserId());
        
        try{
            Approval.ProcessResult result = Approval.process(approve);
        } catch (Exception e){
            
        }
    }
    
    //Cancels the quote process, deletes the quote from the database and exits the window
    public PageReference cancelQuote(){
        if(quoteId!=null && quoteId!=''){
            zqu__Quote__c quoteTodelete = new zqu__Quote__c();
            //ID id= new ID();
            quoteTodelete.Id=quoteId;
            if(!shipment.isEmpty()){
                delete shipment;
            }
            delete quoteTodelete;
        }
        return new PageReference('javascript:window.close()');
    }    
    
    //Populates the top section with the values from the chosen product
    //Add Item becomes Save in top Section
    public void editProductOnShipping(){
        isEditingProduct=TRUE;
        List<ProductInfo>productsToEdit=productsForEachShipment.get(shipmentId);
        for(ProductInfo p:productsToEdit){
            if(p.localId==localChargeId){
                String productIdentity = p.ProductId;
                List<zqu__ZProduct__c> product = [SELECT Id,Name from zqu__ZProduct__c WHERE Id=:productIdentity Limit 1];
                System.debug('Product ' + product);
                List<zqu__ProductRatePlan__c> productRatePlan =  [SELECT Id, Name FROM zqu__ProductRatePlan__c WHERE zqu__ZProduct__c =:productIdentity AND Name = :p.ProdRatePlan Limit 1];
                adjustedUnitCost=String.valueOf(p.AdjustedUnitCost);
                chosenCategory=p.ProductCategory;
                chosenProduct=(product.get(0)).Id;
                chosenProdRatePlan=productRatePlan.get(0).Id;
                // Add to ProductInfo Product Category and change it here !
                //hosenCategory=p. 
                quantity=p.Quantity;
                discount=p.discount;
                
                chosenShipping=shipmentId;
                chosencourier=p.ShipCarrier;
                chosenShippingService=p.ShipServiceId;
                listShippingCost=p.ShipCost;
               
                if (chosenCategory.contains('Hardware') || chosenCategory.contains('Harnesses')){
                    shippingProductChosen = true;
                    editProductFirstSet = true;
                } else {
                    shippingProductChosen = false;
                }
        
                break;
            }
        }
    }
    
    //User confirms deleting the product from the shipment
    public void deleteProductCheck(){
        notificationOptions.continueAction = 'continueProductDeletion();';
        notificationOptions.continueLabel = 'Continue';
        notificationOptions.backAction = 'stayOnCurrentPage();';
        notificationOptions.backLabel = 'Cancel'; 
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'Are you sure you want to delete this line?'));
    }
    
    //Removes Product from Product List and deletes from the database
    public PageReference deleteProductOnShipping(){
        System.debug('Begin deleting');
        
        confirmError();
        
        //isEditingProduct=TRUE;
        List<ProductInfo> productsToEdit=productsForEachShipment.get(shipmentToDeleteId);
        
        for(Integer counter=0; counter<productsForEachShipment.get(shipmentToDeleteId).size(); counter++){
            if(productsForEachShipment.get(shipmentToDeleteId).get(counter).localId==localChargeIdToDelete){
                System.debug('Removing this product ' + productsForEachShipment.get(shipmentToDeleteId).get(counter));
                
                ProductInfo p = productsForEachShipment.get(shipmentToDeleteId).get(counter);
                
                if(productsForEachShipment.get(shipmentToDeleteId).get(counter).chargeID != null || (productsForEachShipment.get(shipmentToDeleteId).get(counter)).chargeID != ''){
                    Id scId = (productsForEachShipment.get(shipmentToDeleteId).get(counter)).chargeID;
                    List<Shipment_Charge_Group__c> sc = [SELECT Id from Shipment_Charge_Group__c WHERE Id = :scId];
                    delete sc;
                }
                
                //Shipping & Handling
                (shipmentMetrics.get(shipmentToDeleteId)).set(0, (shipmentMetrics.get(shipmentToDeleteId)).get(0) - p.ShipCost);
                //Applicable One-Time Expense:
                if(p.TotalPrice != null && !p.ChargeType.equalsignorecase('Recurring')){
                    (shipmentMetrics.get(shipmentToDeleteId)).set(1, (shipmentMetrics.get(shipmentToDeleteId)).get(1) - p.TotalPrice);
                }
                //Recurring Monthly Expense
                if(p.TotalMOPayment != null && p.ChargeType.equalsignorecase('Recurring')){
                   (shipmentMetrics.get(shipmentToDeleteId)).set(2, (shipmentMetrics.get(shipmentToDeleteId)).get(2) - p.TotalMOPayment);
                }
                
                if(p.Quantity != null && p.Quantity != '' && p.ProductCategory == 'Telematics Hardware'){
                    TotalQuoteHardware = TotalQuoteHardware - Integer.valueOf(p.Quantity);
                }
                if(p.Quantity != null && p.Quantity != '' && p.ProductCategory == 'Monthly Service'){
                    TotalQuoteServices = TotalQuoteServices - Integer.valueOf(p.Quantity);
                }
                
                productsForEachShipment.get(shipmentToDeleteId).remove(counter);
                
                break;
            }
            //counter++;
        }
        
        productsToEdit=productsForEachShipment.get(shipmentToDeleteId);
        
        //Checks if all products were removed from the shipment
        if(productsToEdit == null || productsToEdit.isEmpty()){
            productsForEachShipment.remove(shipmentToDeleteId);
        }
        
        //Checks if all products were removed
        if(productsForEachShipment.values() == null || (productsForEachShipment.values()).isEmpty()){
            System.debug('empty products');
            Map<String,List<ProductInfo>> productsAndLocationsMap = new Map<String,List<ProductInfo>>();
            productsForEachShipment=productsAndLocationsMap;
            productMapSize = false;
        }
        return null;
    }
    
    //Clears values in the top sections
    //Called by Clear Button
    public void clear(){
        isEditingLocation = false;
        quantity='';
        chosenCategory='--None--';                         
        listUnitCost=null;                     
        chosenProduct=null;                     
        adjustedUnitCost='';                    
        chosenProdRatePlan=null;                             
        discount='';                         
        TotalMoPayment='';
        paymentTerm='';
        totalPrice=null;
        //TotalMoPaymentEachUnit=null;
        chosenShipping='--None--';
        chosencourier=null;
        chosenShippingService=null;
        //ShippingCost='';
        listShippingCost=null;
    }
    
    // Sets the shipping service name 
    // as the selected shipping service is changed
    public void setShippingServiceName() {
        chosenShippingServiceName = ''; 
        for (SelectOption s : ShippingService) {
            if (s.getValue().equals(chosenShippingService)) {
                chosenShippingServiceName = s.getLabel(); 
                System.debug('New Shipping Service is: ' + chosenShippingServiceName); 
                break; 
            }
        }
    }
	
    //Inner class implements comparable
    public class ProductCategoryComparable implements Comparable{

        public Schema.PicklistEntry ple;

        public ProductCategoryComparable(Schema.PicklistEntry ple) {
            this.ple = ple;
        }


        public Integer compareTo(Object compareTo) {
            // Cast argument to OpportunityWrapper
            ProductCategoryComparable that = (ProductCategoryComparable)compareTo;
            
            List<String> orderedWhiteList = new List<String>{
                '--NONE--',
                'TELEMATICS HARDWARE',
                'MONTHLY SERVICE',
                'HARNESSES & CABLES',
                'HARNESSES AND CABLES'
            };
            
            // First check is each item is in whitelist
            // First and second? Check order between the two
            // First, not second? Return -1
            // Second, not first? Return 1
            // Neither? Proceed as normal

            // The return value of 0 indicates that both elements are equal.
            Integer returnValue = 0;
            Boolean thisIsWhitelist = false;
            Integer thisWLorder = 0;
            Boolean thatIsWhitelist = false;
            Integer thatWLorder = 0;
            for (Integer i = 0; i < orderedWhitelist.size(); i++) {
                if (!thisIsWhitelist && orderedWhitelist.get(i) == this.ple.getLabel().toUpperCase()) {
                    thisIsWhitelist = true;
                    thisWLorder = i;
                }
                if (!thatIsWhitelist && orderedWhitelist.get(i) == that.ple.getLabel().toUpperCase()) {
                    thatIsWhitelist = true;
                    thatWLorder = i;
                }
            }

            if (thisIsWhitelist && thatIsWhitelist) {
                if (thisWLorder > thatWLorder) {
                    returnValue = 1;
                } else if (thisWLorder < thatWLorder) {
                    returnValue = -1;
                }
            } else if (thisIsWhitelist && !thatIsWhitelist) {
                returnValue = -1;
            } else if (!thisIsWhitelist && thatIsWhitelist) {
                returnValue = 1;
            } else {
                if (this.ple.getLabel().toUpperCase() > that.ple.getLabel().toUpperCase()) {
                    // Set return value to a positive value.
                    returnValue = 1;
                } else if (this.ple.getLabel().toUpperCase() < that.ple.getLabel().toUpperCase()) {
                    // Set return value to a negative value.
                    returnValue = -1;
                }
            }

            return returnValue;  
        }
    }
    
    
    
    
}