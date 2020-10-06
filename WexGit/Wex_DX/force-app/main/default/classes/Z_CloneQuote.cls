public without sharing class Z_CloneQuote {

    private ApexPages.StandardController controller;
    private Boolean isPending;

    private zqu__Quote__c sourceQuote;
    private List<Shipment__c> sourceShipments;
    private List<Shipment_Charge_Group__c> sourceShipmentChargeGroups;
    private List<Shipment_Charge__c> sourceShipmentCharges;
    private List<zqu__QuoteAmendment__c> sourceQuoteAmendments;
    private List<zqu__QuoteRatePlan__c> sourceQuoteRatePlans;
    private List<zqu__QuoteRatePlanCharge__c> sourceQuoteRatePlanCharges;

    private zqu__Quote__c clonedQuote;
    private List<Shipment__c> clonedShipments;
    private List<Shipment_Charge_Group__c> clonedShipmentChargeGroups;
    private List<Shipment_Charge__c> clonedShipmentCharges;
    private List<zqu__QuoteAmendment__c> clonedQuoteAmendments;
    private List<zqu__QuoteRatePlan__c> clonedQuoteRatePlans;
    private List<zqu__QuoteRatePlanCharge__c> clonedQuoteRatePlanCharges;

    private ReferenceMirror referenceMirror; // internal class; see below!!

    static private Set<String> quoteFieldsToCopy = new Set<String>{
        'zqu__Opportunity__c',
        'FirstTimeOrder__c',
        'PrimaryAccountName__c',
        'PrimaryAccountNumber__c',
        'PrimarySponsor__c',
        'PrimaryAddress1__c',
        'PrimaryAddress2__c',
        'PrimaryCity__c',
        'PrimaryContact__c',
        'PrimaryCreditLimit__c',
        'PrimaryEmail__c',
        'PrimaryPhone__c',
        'PrimarySource__c',
        'PrimaryState__c',
        'PrimaryZip__c',
        'PromoCode__c',
        'Chosen_PDF_Template__c',
        'Sales_Rep_1__c',
        'SalesRep1__c',
        'Sales_Rep_2__c',
        'SalesRep2__c',
        'SecondaryAccountName__c',
        'SecondaryAccountNumber__c',
        'SecondarySponsor__c',
        'SecondaryAddress1__c',
        'SecondaryAddress2__c',
        'SecondaryCertificateId__c',
        'SecondaryCity__c',
        'SecondaryContact__c',
        'SecondaryCreditLimit__c',
        'SecondaryEmail__c',
        'SecondaryPhone__c',
        'SecondarySource__c',
        'SecondaryTaxExempt__c',
        'SecondaryZip__c',
        'SecondaryState__c',
        'UsingSecondaryAccount__c',
        'Vendor__c',
        'Vendor_Account__c',
        'zqu__Certificate_ID__c',
        'zqu__Tax_Exempt__c'
    };
    static private Set<String> quoteReferences = new Set<String>{
    };

    static private Set<String> shipmentFieldsToCopy = new Set<String>{
        'Address_Line_1__c',
        'Address_Line_2__c',
        'Address_Validated__c',
        'City__c',
        'ShippingCarrier__c',
        'Shipping_Contact__c',
        'Shipping_Contact_Email__c',
        'Shipping_Contact_Phone__c',
        'ShippingService__c',
        'State__c',
        'Tax_Certificate_Number__c',
        'Tax_Exempt_Address__c',
        'Zip__c'
    };
    static private Set<String> shipmentReferences = new Set<String>{
        'Quote__c'
        //  
    };

    static private Set<String> shipmentChargeGroupFieldsToCopy = new Set<String>{
        'ChargeType__c',
        'Discount__c',
        'Effective_Price__c',
        'List_Price__c',
        'List_Total__c',
        'MRR__c',
        'MRR_EU__c',
        'PaymentTerm__c',
        'ProductCategory__c',
        'Product_Name__c',
        'Quantity__c',
        'Recurring_Monthly_Expense__c',
        'RatePlanChargeId__c',
        'RatePlanId__c',
        'Rate_Plan_Name__c',
        'Shipment_Cost__c',
        'Shipping_Carrier__c',
        'Shipping_Carrier_Id__c',
        'Shipping_Carrier_Zuora_Id__c',
        'Shipping_Service__c',
        'Shipping_Service_Id__c',
        'Shipping_Service_Zuora_Id__c',
        'Total__c'

    };
    static private Set<String> shipmentChargeGroupReferences = new Set<String>{
        'ProductRatePlanCharge__c',
        'Quote__c',
        'Shipment__c'
    };

    static private Set<String> shipmentChargeFieldsToCopy = new Set<String>{
        'Charge_Type__c',
        'ChargeType__c',
        'Currency__c',
        'Description__c',
        'Discount__c',
        'Effective_Price__c',
        'LineGroupingId__c',
        'List_Price__c',
        'List_Total__c',
        'Min_Price_Check__c',
        'Model__c',
        'MRR__c',
        'MRR_EU__c',
        'One_Time_Expense__c',
        'ProductCategory__c',
        'Product_Name__c',
        'Quantity__c',
        'Quote__c',
        'Rate_Plan_Charge__c',
        'RatePlanChargeId__c',
        'RatePlanId__c',
        'Rate_Plan_Name__c',
        'Recurring_Monthly_Expense__c',
        'ServiceTerm__c',
        'Shipment_Cost__c',
        'TCV__c',
        'Total__c',
        'Trigger_Date__c',
        'Trigger_Event__c',
        'Type__c',
        'UniqueRollUpValue__c',
        'UOM__c'
    };
    static private Set<String> shipmentChargeReferences = new Set<String>{
        'ProductRatePlanCharge__c',
        'QuoteLookup__c',
        'Shipment__c',
        'ShipmentChargeGroup__c'
    };

    static private Set<String> quoteAmendmentFieldsToCopy = new Set<String>{
        'zqu__AutoRenew__c',
        'zqu__DeltaMRR__c',
        'zqu__DeltaTCV__c',
        'zqu__Description__c',
        'zqu__InitialTerm__c',
        'zqu__RenewalSetting__c',
        'zqu__RenewalTerm__c',
        'zqu__Status__c',
        'zqu__TermStartDate__c',
        'zqu__TermType__c',
        'zqu__TotalAmount__c',
        'zqu__Type__c'
    };
    static private Set<String> quoteAmendmentReferences = new Set<String>{
        'zqu__Quote__c',
        'zqu__QuoteAmendmentZuoraId__c'
    };

    static private Set<String> quoteRatePlanFieldsToCopy = new Set<String>{
        'zqu__AmendmentType__c',
        'zqu__ProductRatePlanZuoraId__c',
        'zqu__QuoteProductName__c',
        'zqu__QuoteRatePlanZuoraId__c',
        'zqu__SubscriptionRatePlanZuoraId__c',
        'zqu__Time_Product_Added__c'
    };
    static private Set<String> quoteRatePlanReferences = new Set<String>{
        'zqu__ProductRatePlan__c',
        'zqu__Quote__c',
        'zqu__QuoteAmendment__c'
    };

    static private Set<String> qrpcFieldsToCopy = new Set<String>{
        'zqu__Apply_Discount_To_One_Time_Charges__c',
        'zqu__Apply_Discount_To_Recurring_Charges__c',
        'zqu__Apply_Discount_To_Usage_Charges__c',
        'zqu__BillCycleDay__c',
        'zqu__BillCycleType__c',
        'zqu__BillingPeriodAlignment__c',
        'zqu__ChargeType__c',
        'zqu__Currency__c',
        'zqu__Description__c',
        'zqu__Discount__c',
        'zqu__Discount_Level__c',
        'zqu__EffectivePrice__c',
        'zqu__FeeType__c',
        'zqu__IncludedUnits__c',
        'zqu__ListPrice__c',
        'zqu__ListPriceBase__c',
        'zqu__ListTotal__c',
        'zqu__Model__c',
        'zqu__MRR__c',
        'zqu__PreviewedMRR__c',
        'zqu__Period__c',
        'zqu__PriceChangeOption__c',
        'zqu__PriceIncreasePercentage__c',
        'zqu__ProductRatePlanChargeZuoraId__c',
        'zqu__Quantity__c',
        'zqu__SpecificBillingPeriod__c',
        'zqu__SubscriptionRatePlanChargeZuoraId__c',
        'zqu__TCV__c',
        'zqu__PreviewedTCV__c',
        'zqu__Total__c',
        'zqu__TriggerDate__c',
        'zqu__TriggerEvent__c',
        'zqu__UOM__c',
        'zqu__Upto_How_Many_Periods__c'
    };
    static private Set<String> qrpcReferences = new Set<String>{
        'zqu__ProductRatePlanCharge__c',
        'zqu__QuoteRatePlan__c',
        'zqu__QuoteRatePlanChargeZuoraId__c'
    };

    // Logic:
    // 
    // 1. Copy quote object. Copy ... fields.
    // 2. Copy Shipment objects.  Make sure to retain referential integrity.
    //    - Integrity checks
    //        . Quote__c (Quote)
    // 3. Copy Shipment Charge Group objects.
    //    - Integrity checks
    //        . Quote__c (Quote)
    //        . Shipment__c (Shipment)
    //        x ProductRatePlanCharge__c (Product Rate Plan Charge)
    // 4. Copy Shipment Charge objects.
    //        x ProductRatePlanCharge__c (Product Rate Plan Charge)
    //        . QuoteLookup__c (Quote)
    //        . Shipment__c (Shipment)
    //        . Shipment_Charge_Group__c (Shipmnet Charge Group)
    // 5. Copy Quote Amendment objects.
    // 6. Copy Quote Rate Plan objects.
    // 7. Copy Quote Rate Plan Charge objects.
    //        . zqu__Quote__c (Quote)
    //        x zqu__ProductRatePlanCharge__c (Product Rate Plan Charge)
    //        . Shipment__c (Shipment)
    //
    // 8. (only needed if circular references force ref-integrity to break)
    //        . iterate through collections of broken reference objects calling referenceMirror.updateReferences

    // TODO: Can replace the 

    public Z_CloneQuote(String quoteId) {
        init(quoteId);
    }

    public Z_CloneQuote(ApexPages.StandardController stdCont) {
        controller = stdCont;
        Id quoteId = controller.getRecord().Id;

        init(quoteId);
    }

    public void init(Id quoteId) {

        //referenceMirror = new ReferenceMirror();

        //controller = stdCont;
        //Id quoteId = controller.getRecord().Id;

        // 1. Get quote with all required information
        String quoteQuery = 'SELECT Id';
        for (String s :quoteReferences) {
            quoteQuery += ', ' + s;
        }
        for (String s :quoteFieldsToCopy) {
            quoteQuery += ', ' + s;
        }
        quoteQuery += ' FROM zqu__Quote__c WHERE Id = \'' + quoteId + '\' LIMIT 1';
        System.Debug('quoteQuery: ' + quoteQuery);
        sourceQuote = Database.query(quoteQuery);


        // 2. Get shipments belonging to quote
        String shipmentsQuery = 'SELECT Id';
        for (String s :shipmentReferences) {
            shipmentsQuery += ', ' + s;
        }
        for (String s :shipmentFieldsToCopy) {
            shipmentsQuery += ', ' + s;
        }
        shipmentsQuery += ' FROM Shipment__c WHERE Quote__c = \'' + sourceQuote.id + '\'';
        System.Debug('shipmentsQuery: ' + shipmentsQuery);
        sourceShipments = Database.query(shipmentsQuery);
        System.Debug('[' + sourceShipments.size() + '] Shipments returned...');

        //return;

        // 3. Get Shipment Charge Groups
        String shipmentChargeGroupsQuery = 'SELECT Id';
        for (String s :shipmentChargeGroupFieldsToCopy) {
            shipmentChargeGroupsQuery += ', ' + s;
        }
        for (String s :shipmentChargeGroupReferences) {
            shipmentChargeGroupsQuery += ', ' + s;
        }
        shipmentChargeGroupsQuery += ' FROM Shipment_Charge_Group__c WHERE Quote__c = \'' + sourceQuote.id + '\'';
        System.Debug('shipmentChargeGroupsQuery: ' + shipmentChargeGroupsQuery);
        sourceShipmentChargeGroups = Database.query(shipmentChargeGroupsQuery);
        System.Debug('[' + sourceShipmentChargeGroups.size() + '] Shipment Charge Groups returned...');
        //return;

        // 4. Get ShipmentCharges
        String shipmentChargesQuery = 'SELECT Id';
        for (String s :shipmentChargeReferences) {
            shipmentChargesQuery += ', ' + s;
        }
        for (String s :shipmentChargeFieldsToCopy) {
            shipmentChargesQuery += ', ' + s;
        }
        shipmentChargesQuery += ' FROM Shipment_Charge__c WHERE QuoteLookup__c = \'' + sourceQuote.id + '\'';
        System.Debug('shipmentChargesQuery: ' + shipmentChargesQuery);
        sourceShipmentCharges = Database.query(shipmentChargesQuery);
        System.Debug('[' + sourceShipmentCharges.size() + '] Shipment Charges returned...');
        //return;

        // 5. Get Quote Amendments
        String quoteAmendmentsQuery = 'SELECT Id';
        for (String s :quoteAmendmentReferences) {
            quoteAmendmentsQuery += ', ' + s;
        }
        for (String s :quoteAmendmentFieldsToCopy) {
            quoteAmendmentsQuery += ', ' + s;
        }
        quoteAmendmentsQuery += ' FROM zqu__QuoteAmendment__c WHERE zqu__Quote__c = \'' + sourceQuote.id + '\'';
        System.Debug('quoteAmendmentsQuery: ' + quoteAmendmentsQuery);
        sourceQuoteAmendments = Database.query(quoteAmendmentsQuery);
        System.Debug('[' + sourceQuoteAmendments.size() + '] Quote Amendments returned...');

        // 6. Get Quote Rate Plans
        String quoteRatePlansQuery = 'SELECT Id';
        for (String s :quoteRatePlanReferences) {
            quoteRatePlansQuery += ', ' + s;
        }
        for (String s :quoteRatePlanFieldsToCopy) {
            quoteRatePlansQuery += ', ' + s;
        }
        quoteRatePlansQuery += ' FROM zqu__QuoteRatePlan__c WHERE zqu__Quote__c = \'' + sourceQuote.id + '\'';
        System.Debug('quoteRatePlansQuery: ' + quoteRatePlansQuery);
        sourceQuoteRatePlans = Database.query(quoteRatePlansQuery);
        System.Debug('[' + sourceQuoteRatePlans.size() + '] Quote Rate Plans returned...');

        Set<Id> quoteRatePlanIds = new Set<Id>();
        for (zqu__QuoteRatePlan__c qrp :sourceQuoteRatePlans) {
            quoteRatePlanIds.add(qrp.Id);
        }



        // 7. Get QuoteRatePlanCharges
        if (quoteRatePlanIds.size() > 0) {
            String qrpcQuery = 'SELECT Id';
            for (String s :qrpcReferences) {
                qrpcQuery += ', ' + s;
            }
            for (String s :qrpcFieldsToCopy) {
                qrpcQuery += ', ' + s;
            }
            qrpcQuery += ' FROM zqu__QuoteRatePlanCharge__c WHERE zqu__QuoteRatePlan__c IN (';

            Boolean isFirst = true;
            for (Id qrpId :quoteRatePlanIds) {
                if (!isFirst) { qrpcQuery += ', '; }
                qrpcQuery += '\'' + qrpId + '\'';
                isFirst = false;
            }
            qrpcQuery += ')';

            System.Debug('qrpcQuery: ' + qrpcQuery);
            sourceQuoteRatePlanCharges = Database.query(qrpcQuery);
            System.Debug('[' + sourceQuoteRatePlans.size() + '] Quote Rate Plan Charges returned...');
        } else {
            System.Debug('No Quote Rate Plans. Skipping QRPC query...');
            sourceQuoteRatePlanCharges = new List<zqu__QuoteRatePlanCharge__c>();
        }

    }
    
    public PageReference autoRunPending() {
        isPending = true;
        return process();
    }

    public PageReference autoRun() {
        isPending = false;
        return process();
    }
    
    public PageReference process() {

        referenceMirror = new ReferenceMirror();


        // 1. Clone Quote
        clonedQuote = new zqu__Quote__c();

        copyFields(sourceQuote, clonedQuote, quoteFieldsToCopy, quoteReferences);

        // Handle anything which isn't directly copied over down here.
        // ...
        clonedQuote.DatePrepared__c = Date.today();
        clonedQuote.zqu__ValidUntil__c = Date.today().addDays(60);
        clonedQuote.isPending__c = isPending;


        insert clonedQuote;
        referenceMirror.putReference(sourceQuote.Id, clonedQuote.Id);

        // 2. Clone Shipments
        clonedShipments = new List<Shipment__c>();

        for (Shipment__c sourceShipment :sourceShipments) {
            Shipment__c clonedShipment = new Shipment__c();

            copyFields(sourceShipment, clonedShipment, shipmentFieldsToCopy, shipmentReferences);

            clonedShipments.add(clonedShipment);
        }

        insert clonedShipments;
        for (Integer i = 0; i < sourceShipments.size(); i++) {
            referenceMirror.putReference(sourceShipments.get(i).Id, clonedShipments.get(i).Id);
        }

        // 3. Clone Shipment Charge Groups
        clonedShipmentChargeGroups = new List<Shipment_Charge_Group__c>();

        for (Shipment_Charge_Group__c sourceScg : sourceShipmentChargeGroups) {
            Shipment_Charge_Group__c clonedScg = new Shipment_Charge_Group__c();

            copyFields(sourceScg, clonedScg, shipmentChargeGroupFieldsToCopy, shipmentChargeGroupReferences);

            clonedShipmentChargeGroups.add(clonedScg);
        }

        insert clonedShipmentChargeGroups;
        for (Integer i = 0; i < sourceShipmentChargeGroups.size(); i++) {
            referenceMirror.putReference(sourceShipmentChargeGroups.get(i).Id, clonedShipmentChargeGroups.get(i).Id);
        }

        // 4. Clone Shipment Charges
        clonedShipmentCharges = new List<Shipment_Charge__c>();

        for (Shipment_Charge__c sourceSc :sourceShipmentCharges) {
            Shipment_Charge__c clonedSc = new Shipment_Charge__c();

            copyFields(sourceSc, clonedSc, shipmentChargeFieldsToCopy, shipmentChargeReferences);

            clonedShipmentCharges.add(clonedSc);
        }

        System.debug('clonedShipmentCharges: ' + clonedShipmentCharges);
        insert clonedShipmentCharges;
        for (Integer i = 0; i < sourceShipmentCharges.size(); i++) {
            referenceMirror.putReference(sourceShipmentCharges.get(i).Id, clonedShipmentCharges.get(i).Id);
        }

        // 5. Clone Quote Amendments
        clonedQuoteAmendments = new List<zqu__QuoteAmendment__c>();

        for (zqu__QuoteAmendment__c sourceQuoteAmendment :sourceQuoteAmendments) {
            zqu__QuoteAmendment__c clonedQuoteAmendment = new zqu__QuoteAmendment__c();

            copyFields(sourceQuoteAmendment, clonedQuoteAmendment, quoteAmendmentFieldsToCopy, quoteAmendmentReferences);

            clonedQuoteAmendments.add(clonedQuoteAmendment);
        }

        insert clonedQuoteAmendments;
        for (Integer i = 0; i < sourceQuoteAmendments.size(); i++) {
            referenceMirror.putReference(sourceQuoteAmendments.get(i).Id, clonedQuoteAmendments.get(i).Id);
        }

        // 6. Clone Quote Rate Plans
        clonedQuoteRatePlans = new List<zqu__QuoteRatePlan__c>();

        for (zqu__QuoteRatePlan__c sourceQrp :sourceQuoteRatePlans) {
            zqu__QuoteRatePlan__c clonedQrp = new zqu__QuoteRatePlan__c();

            copyFields(sourceQrp, clonedQrp, quoteRatePlanFieldsToCopy, quoteRatePlanReferences);

            clonedQuoteRatePlans.add(clonedQrp);
        }

        insert clonedQuoteRatePlans;
        for (Integer i = 0; i < sourceQuoteAmendments.size(); i++) {
            referenceMirror.putReference(sourceQuoteRatePlans.get(i).Id, clonedQuoteRatePlans.get(i).Id);
        }

        // 7. Clone Quote Rate Plan Charges
        clonedQuoteRatePlanCharges = new List<zqu__QuoteRatePlanCharge__c>();

        for (zqu__QuoteRatePlanCharge__c sourceQrpc :sourceQuoteRatePlanCharges) {
            zqu__QuoteRatePlanCharge__c clonedQrpc = new zqu__QuoteRatePlanCharge__c();

            copyFields(sourceQrpc, clonedQrpc, qrpcFieldsToCopy, qrpcReferences);

            clonedQuoteRatePlanCharges.add(clonedQrpc);
        }

        insert clonedQuoteRatePlanCharges;
        for (Integer i = 0; i < sourceQuoteRatePlanCharges.size(); i++) {
            referenceMirror.putReference(sourceQuoteRatePlanCharges.get(i).Id, clonedQuoteRatePlanCharges.get(i).Id);
        }


        // Cloning process is now complete.  Build and return page reference.
        PageReference pageRef = new PageReference('/apex/PrepareNewQuote?oppid=' + clonedQuote.zqu__Opportunity__c + '&quoteid=' + clonedQuote.Id);
        pageRef.setRedirect(true);

        System.debug('pageRef: ' + pageRef);

        return pageRef;


    }

    private void copyFields(sObject source, sObject destination, Set<String> fields, Set<String> references) {
        for (String s :references) {
            destination.put(s, referenceMirror.getReference((Id)source.get(s)));
        }
        for (String s :fields) {
            destination.put(s, source.get(s));
        }
    }

    public class ReferenceMirror{

        private Map<Id,Id> referencesById;

        public ReferenceMirror() {
            referencesById = new Map<Id, Id>();
        }

        public void putReference(Id source, Id destination) {
            referencesById.put(source, destination);
        }

        // Returns the equivalent id of the cloned sObject
        // or returns the same id if there is no mapping
        // (which indicates the object referenced is not part of cloning)
        public Id getReference(Id source) {
            Id temp = referencesById.get(source);

            if (temp == null) {
                temp = source;
            } else {
                // do nothing...
            }

            return temp;
        }

        public void updateReferences(List<sObject> sObjects, Set<String> references) {
            for (sObject obj :sObjects) {
                for (String reference :references) {
                    obj.put(reference, getReference((Id)obj.get(reference)));
                }
            }
        }

    }

    public class GenericException extends Exception{
    }



}