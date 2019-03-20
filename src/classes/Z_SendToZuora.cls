public class Z_SendToZuora {
    
    @future(callout=true)
    public static void sendToZuora(Id quoteId){
        QuoteTriggerHandler.isRunning = true;
        
        Zuora.zApi zapi = new Zuora.zApi();
        
        String zoql = 'SELECT Id, Name from Account Where AccountNumber =\''+ quoteId +'\'';
        
        if(!test.isRunningTest()){
            zapi.zlogin();
            List<Zuora.zObject> zobjs = zapi.zquery(zoql);
            
            if (!zobjs.isEmpty())
                return;
        }
        
        zqu__Quote__c quote = [
            SELECT
            	Id,
            	zqu__Number__c,
            	zqu__Account__c,
            	zqu__Account__r.Id,
            	PrimaryAccountNumber__c,
            	PrimaryAccountName__c,
            	PrimarySource__c,
            	PrimaryCreditLimit__c,
            	PrimaryAddress1__c,
            	PrimaryAddress2__c,
            	PrimaryCity__c,
            	PrimaryState__c,
            	PrimaryZip__c,
            	PrimaryContact__c,
            	PrimaryPhone__c,
            	PrimaryEmail__c,
            	zqu__Tax_Exempt__c,
            	zqu__Certificate_Id__c,
            	SecondaryAccountNumber__c,
            	SecondaryAccountName__c,
            	SecondarySource__c,
            	SecondaryCreditLimit__c,
            	SecondaryAddress1__c,
            	SecondaryAddress2__c,
            	SecondaryCity__c,
            	SecondaryState__c,
            	SecondaryZip__c,
            	SecondaryContact__c,
            	SecondaryPhone__c,
            	SecondaryEmail__c,
            	SecondaryTaxExempt__c,
            	SecondaryCertificateId__c,
            	zqu__Opportunity__r.Name,
                RecordTypeId,
                zqu__Status__c,
                QuoteNumber__c,
            	zqu__ZuoraAccountID__c
            FROM
				zqu__Quote__c
            WHERE
            	Id = :quoteId
        ];
        Account account = 
            [
                SELECT
                    Id,
                	Name,
                	BillingContactName__c
                FROM
                    Account
                WHERE
                    Id = :quote.zqu__Account__r.Id
            ];
        List<Shipment__c> shipments = 
            [
                SELECT
                	Id,
                	Address_Line_1__c,
                	Address_Line_2__c,
                	City__c,
                	State__c,
                	Zip__c
                FROM
                	Shipment__c
                Where
                	Quote__r.Id = :quote.Id
            ];
        List<Shipment_Charge_Group__c> chargeGroups = 
            [
                SELECT
                	Id,
                	Shipment__c,
                	Shipment__r.Id,
                	Shipment__r.Address_Line_1__c,
                	Shipment__r.Address_Line_2__c,
                	Shipment__r.City__c,
                	Shipment__r.State__c,
                	Shipment__r.Zip__c,
                	Shipment__r.Shipping_Contact__c,
                	Effective_Price__c,
                	Quantity__c,
                	RatePlanChargeId__c,
                	RatePlanId__c,
                    ProductCategory__c,
                	ChargeType__c,
                	ServiceTerm__c,
                	ProductRatePlanCharge__r.zqu__ProductRatePlan__r.NonRecurringPaymentTerm__c,
                	Shipment_Cost__c,
                	Shipping_Carrier__c,
                	Shipping_Carrier_Zuora_Id__c,
                	Shipping_Service__c,
                	Shipping_Service_Zuora_Id__c
                FROM
                	Shipment_Charge_Group__c
                WHERE
                	Shipment__r.Quote__r.Id = :quote.Id
            ];
        List<Shipment_Charge__c> charges = 
            [
                SELECT
                	Id,
                	Shipment__c,
                	Shipment__r.Id,
                	Shipment__r.Address_Line_1__c,
                	Shipment__r.Address_Line_2__c,
                	Shipment__r.City__c,
                	Shipment__r.State__c,
                	Shipment__r.Zip__c,
                	Shipment__r.Shipping_Contact__c,
                	Effective_Price__c,
                	Quantity__c,
                	RatePlanChargeId__c,
                	RatePlanId__c,
                    ProductCategory__c,
                	Product_Name__c,
                	ChargeType__c,
                	ServiceTerm__c,
                	ProductRatePlanCharge__r.zqu__ProductRatePlan__r.NonRecurringPaymentTerm__c,
                	Shipment_Cost__c,
                	ShipmentChargeGroup__r.Shipping_Carrier__c,
                	ShipmentChargeGroup__r.Shipping_Carrier_Id__c,
                	ShipmentChargeGroup__r.Shipping_Service__c,
                	ShipmentChargeGroup__r.Shipping_Service_Id__c
                FROM
                	Shipment_Charge__c
                WHERE
                	Shipment__r.Quote__r.Id = :quote.Id
            ];
        System.debug(charges);
        Shipment_Charge__c firstShipmentCharge = charges.remove(0);
        String accountResult = createFullAccount(zapi, quote, account, shipments[0], firstShipmentCharge);
        
        if (accountResult.startsWith('ERROR:')){
            return;
        }
        
        String subscriptionResult = createSubscriptions(zapi, accountResult, quote, charges);
        
        String subscriptionShippingResult = createShippingSubscriptions(zapi, accountResult, quote, chargeGroups);

        if (subscriptionResult == '' && subscriptionShippingResult == ''){
            quote.zqu__Status__c = 'Customer Approved';
            quote.RecordTypeId  = [select Id from RecordType where Name = 'Customer Approved' and SobjectType = 'zqu__Quote__c' limit 1].Id;
            quote.zqu__ZuoraAccountID__c = accountResult;
            quote.zqu__Customer_Acceptance_Date__c = Date.today();
            update quote;
        } else{
            quote.zqu__ZuoraAccountID__c = null;
            quote.zqu__Customer_Acceptance_Date__c = Date.today();
            update quote;
        }
    }
    
    public static string createFullAccount(Zuora.zApi zapi, zqu__Quote__c quote, Account account, Shipment__c shipment, Shipment_Charge__c charge){
        Zuora.zApi.SubscribeRequest subRequest = new Zuora.zApi.SubscribeRequest();
        
        subRequest.zAccount = createZAccount(quote, account);
        subRequest.BillToContact = createZContact(account, shipment);
        subRequest.SubscriptionData = createZSubscriptionData(quote, charge);
        
        Zuora.zApi.SubscribeOptions so = new Zuora.zApi.SubscribeOptions();
        so.GenerateInvoice = false;
        so.ProcessPayments = false;
        
        subRequest.SubscribeOptions = so;
        
        list<Zuora.zApi.SubscribeRequest> subReqList = new List<Zuora.zApi.SubscribeRequest>();
        subReqList.add(subRequest);
        
        system.debug(subReqList);
        
        if(!test.isRunningTest()){
            try{
                zapi.zlogin();
                List<Zuora.zApi.SubscribeResult> results = zapi.zSubscribe(subReqList);
                System.debug('Account creation result ' + results);
                for (Zuora.zApi.SubscribeResult result : results){
                    if(result.success){
                        return result.AccountId;
                    } else {
                        for (Zuora.zObject error : result.errors) {
                            system.debug('ERROR: ' + (String)error.getValue('Code') + ': ' + (String)error.getValue('Message'));
                        }
                        return 'ERROR: ';
                    }
                }
            } catch (Zuora.zRemoteException e){
                system.debug('ERROR: ' + e.code + ': ' + e.message);
                return 'ERROR: ' + e.code + ': ' + e.message;
            }
        }
        
        return '';
    }
    
    public static string createSubscriptions(Zuora.zApi zapi, String accountId, zqu__Quote__c quote, Shipment_Charge__c[] charges){
        Zuora.zObject zuoraAccount = createExistingZAccount(accountId);
        
        Zuora.zApi.SubscribeOptions so= new Zuora.zApi.SubscribeOptions();
        
        so.GenerateInvoice = false;
        so.ProcessPayments = false;
        
        while (!charges.isEmpty()){
            list<Zuora.zApi.SubscribeRequest> subReqList = new List<Zuora.zApi.SubscribeRequest>();
            
            Integer i;
            Integer maxReqs = 50;
            if (maxReqs > charges.size())
                maxReqs = charges.size();
            for (i = 0; i<maxReqs; i++){
                Zuora.zApi.SubscribeRequest subRequest = new Zuora.zApi.SubscribeRequest();
                
                subRequest.zAccount = zuoraAccount;
                
                subRequest.SubscriptionData = createZSubscriptionData(quote, charges.remove(0));
                subRequest.SubscribeOptions = so;
                
                subReqList.add(subRequest);
            }
            System.debug(subReqList);
            
            if(!test.isRunningTest()){
                try{
                    zapi.zlogin();
                    List<Zuora.zApi.SubscribeResult> results = zapi.zSubscribe(subReqList);
                    System.debug('Subscription results ' + results);
                } catch (Zuora.zRemoteException e){
                    system.debug('ERROR: ' + e.code + ': ' + e.message);
                    return 'ERROR: ' + e.code + ': ' + e.message;
                }
            }
        }
        
        return '';
    }
    
    public static string createShippingSubscriptions(Zuora.zApi zapi, String accountId, zqu__Quote__c quote, Shipment_Charge_Group__c[] chargeGroups){
        
        Zuora.zObject zuoraAccount = createExistingZAccount(accountId);
        
        Zuora.zApi.SubscribeOptions so= new Zuora.zApi.SubscribeOptions();
        
        so.GenerateInvoice = false;
        so.ProcessPayments = false;
		
        while (!chargeGroups.isEmpty()){
            list<Zuora.zApi.SubscribeRequest> subReqList = new List<Zuora.zApi.SubscribeRequest>();
            
            Integer i;
            Integer maxReqs = 50;
            if (maxReqs > chargeGroups.size())
                maxReqs = chargeGroups.size();
            for (i = 0; i<maxReqs; i++){
                Zuora.zApi.SubscribeRequest subRequest = new Zuora.zApi.SubscribeRequest();
                
                subRequest.zAccount = zuoraAccount;
                
                if (((chargeGroups.get(0)).ProductCategory__c).contains('Hardware') || ((chargeGroups.get(0)).ProductCategory__c).contains('Harnesses')){
                    System.debug('Charges: ' + chargeGroups.get(0));
                	
                    subRequest.SubscriptionData = createZShippingSubscriptionData(quote, chargeGroups.remove(0));
                    subRequest.SubscribeOptions = so;
                    subReqList.add(subRequest);
                    
                }else{
                    chargeGroups.remove(0);
                }
                
            }
            System.debug(subReqList);
            if(subReqList.isEmpty()){
                return 'No Shipment Cost Charge Line Items';
            }
            if(!test.isRunningTest()){
                try{
                    zapi.zlogin();
                    List<Zuora.zApi.SubscribeResult> results = zapi.zSubscribe(subReqList);
                    
                    System.debug('Subscription results ' + results);
                } catch (Zuora.zRemoteException e){
                    system.debug('ERROR: ' + e.code + ': ' + e.message);
                    return 'ERROR: ' + e.code + ': ' + e.message;
                }
            }
        }
        
        return '';
    }
    
    public static Zuora.zObject createZAccount(zqu__Quote__c quote, Account account){
        Zuora.zObject zAccount = new Zuora.zObject('Account');
        
        zAccount.setValue('BcdSettingOption', 'ManualSet');
        zAccount.setValue('BillCycleDay', Date.today().day());
        zAccount.setValue('Name', account.Name);
        zAccount.setValue('Currency', 'USD');
        zAccount.setValue('PaymentTerm', 'Net 30');
        zAccount.setValue('Batch', 'Batch1');
        zAccount.setValue('CrmId', account.Id);
        zAccount.setValue('QuoteID__c', quote.Id);
        zAccount.setValue('QuoteNumber__c', quote.QuoteNumber__c);
        zAccount.setValue('AccountNumber', quote.Id);
        
        return zAccount;
    }
    
    public static Zuora.zObject createExistingZAccount(String id){
        Zuora.zObject zAccount = new Zuora.zObject('Account');
        
        zAccount.setValue('Id', id);
        
        return zAccount;
    }
    
    public static Zuora.zObject createZContact(Account account, Shipment__c shipment){
        Zuora.zObject zContact = new Zuora.zObject('Contact');
        
        //String[] names = account.BillingContactName__c.split(' ', 2);
        String[] names = new String[]{'Test', 'Name'};
        
        
	    zContact.setValue('FirstName', names[0]);
        if (names.size() > 2){
	        zContact.setValue('LastName', names[0]);
        } else{
            zContact.setValue('LastName', names[1]);
        }
        
        zContact.setValue('Country', 'Us');
        zContact.setValue('State', 'ME');
        zContact.setValue('WorkEmail', 'test@wex.com');
        
        
        return zContact;
    }
    
    public static Zuora.zApi.SubscriptionData createZSubscriptionData(zqu__Quote__c quote, Shipment_Charge__c charge){
        Zuora.zApi.SubscriptionData zSubscriptionData = new Zuora.zApi.SubscriptionData();
        
        zSubscriptionData.Subscription = createZSubscription(quote, charge);
        zSubscriptionData.RatePlanData = createZRatePlanData(charge);
        
        return zSubscriptionData;
    }
    
    public static Zuora.zApi.SubscriptionData createZShippingSubscriptionData(zqu__Quote__c quote, Shipment_Charge_Group__c chargeGroup){
        Zuora.zApi.SubscriptionData zSubscriptionData = new Zuora.zApi.SubscriptionData();
        
        zSubscriptionData.Subscription = createZShippingSubscription(quote, chargeGroup);
        zSubscriptionData.RatePlanData = createZShippingRatePlanData(chargeGroup);
        
        return zSubscriptionData;
    }
    
    public static Zuora.zObject createZSubscription(zqu__Quote__c quote, Shipment_Charge__c charge){
        Zuora.zObject zSubscription = new Zuora.zObject('Subscription');
        
        String fulldatetime = Zuora.zUtil.getZuoraDate(Date.today());
        String formatedDate = fullDateTime.substring(0, 10);
        String futureDateTime = Zuora.zUtil.getZuoraDate(Date.today().addDays(5));
        String futureDate = futureDateTime.substring(0,10);
        
        zSubscription.setValue('WEXBillingAccountName__c', quote.PrimaryAccountName__c);
        zSubscription.setValue('WEXAccountNumber__c', quote.PrimaryAccountNumber__c);
        zSubscription.setValue('WEXAccountTaxExemptStatus__c', quote.zqu__Tax_Exempt__c);
        zSubscription.setValue('WEXAccountTaxExemptCertificateID__c',quote.zqu__Certificate_Id__c);
               
        if ((charge.ProductCategory__c == 'Monthly Service' || charge.ProductCategory__c == 'ELD / HOS Software') && !(charge.Product_Name__c).contains('BSM - Monthly Service')){
            zSubscription.setValue('ContractEffectiveDate', formatedDate);
            if(quote.SecondaryAccountNumber__c != null && quote.SecondaryAccountNumber__c != ''){
                zSubscription.setValue('WEXBillingAccountName__c', quote.SecondaryAccountName__c);
                zSubscription.setValue('WEXAccountNumber__c', quote.SecondaryAccountNumber__c);
                zSubscription.setValue('WEXAccountTaxExemptStatus__c', quote.SecondaryTaxExempt__c);
                zSubscription.setValue('WEXAccountTaxExemptCertificateID__c',quote.SecondaryCertificateId__c);
            }
        } else {
            zSubscription.setValue('ContractEffectiveDate', futureDate);
            zSubscription.setValue('ServiceActivationDate', futureDate);
            zSubscription.setValue('ContractAcceptanceDate', futureDate);
        }
        
        if((charge.ChargeType__c).equalsignorecase('Recurring')){
            //Recurring Evergreen
            if(charge.ServiceTerm__c == 1){
            	zSubscription.setValue('TermType', 'EVERGREEN');
            //Recurring Until End of Term
            }else{
                zSubscription.setValue('TermType', 'TERMED');
                zSubscription.setValue('InitialTerm', charge.ServiceTerm__c);
                zSubscription.setValue('RenewalSetting', 'RENEW_WITH_SPECIFIC_TERM');
                zSubscription.setValue('RenewalTerm', Integer.valueOf('0'));
            }
        }else{
            //Recurring Evergreen
            if(charge.ProductRatePlanCharge__r.zqu__ProductRatePlan__r.NonRecurringPaymentTerm__c == 'NOT'){
            	zSubscription.setValue('TermType', 'EVERGREEN');
            //Non Recurring
            }else if(charge.ServiceTerm__c == 1){
                zSubscription.setValue('TermType', 'TERMED');
                zSubscription.setValue('InitialTerm', charge.ServiceTerm__c);
                zSubscription.setValue('RenewalSetting', 'RENEW_WITH_SPECIFIC_TERM');
                zSubscription.setValue('RenewalTerm', Integer.valueOf('0'));
            //Recurring Until End of Term
            }else{
                zSubscription.setValue('TermType', 'TERMED');
                zSubscription.setValue('InitialTerm', charge.ServiceTerm__c);
                zSubscription.setValue('RenewalSetting', 'RENEW_WITH_SPECIFIC_TERM');
                zSubscription.setValue('RenewalTerm', Integer.valueOf('0'));
            }
        }

        zSubscription.setValue('QuoteLineItemID__c', charge.Id);
        zSubscription.setValue('ShippingAddressLine1__c',charge.Shipment__r.Address_Line_1__c);
        zSubscription.setValue('ShippingAddressLine2__c',charge.Shipment__r.Address_Line_2__c);
        zSubscription.setValue('ShippingCity__c',charge.Shipment__r.City__c);
        zSubscription.setValue('ShippingState__c',charge.Shipment__r.State__c);
        zSubscription.setValue('ShippingPostalCode__c',charge.Shipment__r.Zip__c);
        zSubscription.setValue('ShippingContact__c',charge.Shipment__r.Shipping_Contact__c);
        zSubscription.setValue('ShippingCountry__c','USA');
        zSubscription.setValue('QuoteNumber__QT',quote.QuoteNumber__c);
        zSubscription.setValue('QuoteType__QT', 'New Subscription');
        zSubscription.setValue('QuoteBusinessType__QT', 'New');
        zSubscription.setValue('OpportunityName__QT', quote.zqu__Opportunity__r.Name);
        zSubscription.setValue('OpportunityCloseDate__QT', formatedDate);
        
        return zSubscription;
    }
    
    public static Zuora.zObject createZShippingSubscription(zqu__Quote__c quote, Shipment_Charge_Group__c chargeGroup){
        Zuora.zObject zSubscription = new Zuora.zObject('Subscription');
        
        String fulldatetime = Zuora.zUtil.getZuoraDate(Date.today());
        String formatedDate = fullDateTime.substring(0, 10);
        String futureDateTime = Zuora.zUtil.getZuoraDate(Date.today().addDays(5));
        String futureDate = futureDateTime.substring(0,10);
        
        zSubscription.setValue('WEXBillingAccountName__c', quote.PrimaryAccountName__c);
        zSubscription.setValue('WEXAccountNumber__c', quote.PrimaryAccountNumber__c);
        zSubscription.setValue('WEXAccountTaxExemptStatus__c', quote.zqu__Tax_Exempt__c);
        zSubscription.setValue('WEXAccountTaxExemptCertificateID__c',quote.zqu__Certificate_Id__c);
        
        
        zSubscription.setValue('ContractEffectiveDate', futureDate);
        zSubscription.setValue('ServiceActivationDate', futureDate);
        zSubscription.setValue('ContractAcceptanceDate', futureDate);
        
        
        zSubscription.setValue('TermType', 'TERMED');
        zSubscription.setValue('InitialTerm', 1);
        zSubscription.setValue('RenewalSetting', 'RENEW_WITH_SPECIFIC_TERM');
        zSubscription.setValue('RenewalTerm', Integer.valueOf('0'));
            

        zSubscription.setValue('QuoteLineItemID__c', chargeGroup.Id);
        zSubscription.setValue('ShippingAddressLine1__c',chargeGroup.Shipment__r.Address_Line_1__c);
        zSubscription.setValue('ShippingAddressLine2__c',chargeGroup.Shipment__r.Address_Line_2__c);
        zSubscription.setValue('ShippingCity__c',chargeGroup.Shipment__r.City__c);
        zSubscription.setValue('ShippingState__c',chargeGroup.Shipment__r.State__c);
        zSubscription.setValue('ShippingPostalCode__c',chargeGroup.Shipment__r.Zip__c);
        zSubscription.setValue('ShippingContact__c',chargeGroup.Shipment__r.Shipping_Contact__c);
        zSubscription.setValue('ShippingCountry__c','USA');
        zSubscription.setValue('QuoteNumber__QT',quote.QuoteNumber__c);
        zSubscription.setValue('QuoteType__QT', 'New Subscription');
        zSubscription.setValue('QuoteBusinessType__QT', 'New');
        zSubscription.setValue('OpportunityName__QT', quote.zqu__Opportunity__r.Name);
        zSubscription.setValue('OpportunityCloseDate__QT', formatedDate);
        
        return zSubscription;
    }
    
    public static List<Zuora.zObject> createZRatePlanData(Shipment_Charge__c charge){
        List<Zuora.zObject> zRatePlanDataList = new List<Zuora.zObject>();
        
        Zuora.zObject zRatePlanData = new Zuora.zObject('RatePlanData');
        
        zRatePlanData.setValue('RatePlan', createZRatePlan(charge));
        zRatePlanData.setValue('RatePlanChargeData', createZRatePlanChargeData(charge));
        
        zRatePlanDataList.add(zRatePlanData);
        
        return zRatePlanDataList;
    }
    
    public static List<Zuora.zObject> createZShippingRatePlanData(Shipment_Charge_Group__c chargeGroup){
        List<Zuora.zObject> zRatePlanDataList = new List<Zuora.zObject>();
        
        Zuora.zObject zRatePlanData = new Zuora.zObject('RatePlanData');
        
        zRatePlanData.setValue('RatePlan', createZShippingRatePlan(chargeGroup));
        zRatePlanData.setValue('RatePlanChargeData', createZShippingRatePlanChargeData(chargeGroup));
        
        zRatePlanDataList.add(zRatePlanData);
        
        
        return zRatePlanDataList;
    }
    
    public static Zuora.zObject createZRatePlan(Shipment_Charge__c charge){
        Zuora.zObject zRatePlan = new Zuora.zObject('RatePlan');
        
        zRatePlan.setValue('ProductRatePlanId', charge.RatePlanId__c);
        
        return zRatePlan;
    }
    
    public static Zuora.zObject createZShippingRatePlan(Shipment_Charge_Group__c chargeGroup){
        Zuora.zObject zRatePlan = new Zuora.zObject('RatePlan');
        
        zRatePlan.setValue('ProductRatePlanId', chargeGroup.Shipping_Carrier_Zuora_Id__c);
        
        return zRatePlan;
    }
    
    public static List<Zuora.zObject> createZRatePlanChargeData(Shipment_Charge__c charge){
        List<Zuora.zObject> zRatePlanChargeDataList = new List<Zuora.zObject>();
        
        Zuora.zObject zRatePlanChargeData = new Zuora.zObject('RatePlanChargeData');
        
        zRatePlanChargeData.setValue('RatePlanCharge', createZRatePlanCharge(charge));
        
        zRatePlanChargeDataList.add(zRatePlanChargeData);
        
        return zRatePlanChargeDataList;
    }
    
    public static List<Zuora.zObject> createZShippingRatePlanChargeData(Shipment_Charge_Group__c chargeGroup){
        List<Zuora.zObject> zRatePlanChargeDataList = new List<Zuora.zObject>();
        
        Zuora.zObject zRatePlanChargeData = new Zuora.zObject('RatePlanChargeData');
        
        zRatePlanChargeData.setValue('RatePlanCharge', createZShippingRatePlanCharge(chargeGroup));
        
        zRatePlanChargeDataList.add(zRatePlanChargeData);
        
        return zRatePlanChargeDataList;
    }
    
    public static Zuora.zObject createZRatePlanCharge(Shipment_Charge__c charge){
        Zuora.zObject zRatePlanCharge = new Zuora.zObject('RatePlanCharge');
        
        zRatePlanCharge.setValue('ProductRatePlanChargeId', charge.RatePlanChargeId__c);
        zRatePlanCharge.setValue('Price', charge.Effective_Price__c);
        zRatePlanCharge.setValue('Quantity', charge.Quantity__c);
        
        return zRatePlanCharge;
    }
    
    public static Zuora.zObject createZShippingRatePlanCharge(Shipment_Charge_Group__c chargeGroup){
        Zuora.zObject zRatePlanCharge = new Zuora.zObject('RatePlanCharge');
        
        zRatePlanCharge.setValue('ProductRatePlanChargeId', chargeGroup.Shipping_Service_Zuora_Id__c);
        //zRatePlanCharge.setValue('Price', chargeGroup.Shipment_Cost__c);
        zRatePlanCharge.setValue('Quantity', chargeGroup.Quantity__c);
        System.debug('zRatePlanCharge ' + zRatePlanCharge);
        return zRatePlanCharge;
    }
}