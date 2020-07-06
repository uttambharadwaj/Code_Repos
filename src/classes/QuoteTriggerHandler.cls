public class QuoteTriggerHandler {

    private static final Id approvedPendingCustomerRecordTypeId = Schema.SObjectType.zqu__Quote__c.getRecordTypeInfosByName().get('Approved Pending Customer').getRecordTypeId();
    private static final Id customerApprovedRecordTypeId = Schema.SObjectType.zqu__Quote__c.getRecordTypeInfosByName().get('Customer Approved').getRecordTypeId();
    private static final Id outForSignatureRecordTypeId = Schema.SObjectType.zqu__Quote__c.getRecordTypeInfosByName().get('Out for Signature').getRecordTypeId();
    private static final Id pendingApprovalPendingCustomerRecordTypeId = Schema.SObjectType.zqu__Quote__c.getRecordTypeInfosByName().get('Pending Approval Pending Customer').getRecordTypeId();
    private static final Id customerApprovalOverrideRecordTypeId = Schema.SObjectType.zqu__Quote__c.getRecordTypeInfosByName().get('Customer Approval Override').getRecordTypeId();
    private static final Id issuedOrderRecordTypeId = Schema.SObjectType.zqu__Quote__c.getRecordTypeInfosByName().get('Issued Order').getRecordTypeId();

    public static Boolean isRunning = false;

    public QuoteTriggerHandler(){
        /**
         * I believe there has been functional errors with this class because of the use of pending as two fold
         * Pending for the type of customer and pending used as a waiting stage in the flows
         * Below is documented the Quote Status and Record types 
         * 
         * Quote Status:
         * New: Default OOTB
         * Approved Pending Customer: The quote has been approved internally but is a pending customer
         * Out for Signature: Set once the quote is internally approved until the an agreement from the quote is signed through echosign
         * Customer Approved: Echosign agreement returned signed
         * Issued Order: Order was sent to vendor
         * 
         * 
         * Record Types:
         * Approved Pending Customer: correlates to Approved Pending Customer status; Approved Quote for a Pending Customer
         * Customer Approval Override: Set as the initial record type for a quote with customer approval override flag set.
         * Customer Approved: correlates to Customer approved status;Should be use for non pending accounts
         * Default: Initial record type once a Quote is created
         * Issued Order: correlates to Issued Order status
         * Out for Signature: correlates to Out for Signature status
         * Pending Approval: Submitted for internal WEX approval; wait stage
         * Pending Order To Vendor: correlates to Pending Order to Vendor status; wait stage
         * Pending Approval Pending Customer: Quote is waiting internal approval, a pending customer
         */
    }
    
    public void beforeInsert(List<zqu__Quote__c> newQs) {
        
        for (zqu__Quote__c q : newQs) {
            if (q.CustomerApprovalOverride__c) {
                q.RecordTypeId  = customerApprovalOverrideRecordTypeId;
            }
            if (q.isPending__c) {
                q.RecordTypeId  = pendingApprovalPendingCustomerRecordTypeId;
            }
        }
            
    }
    
    public void runSend(zqu__Quote__c[] updatedQuotes, Map<Id, zqu__Quote__c> oldQuotes){
        if (QuoteTriggerHandler.isRunning){
            return;
        }
        for (zqu__Quote__c quote : updatedQuotes){
            system.debug('Old Custmer Approved: ' + oldQuotes.get(quote.Id).CustomerApproval__c + ' | New Customer Approved: ' + quote.CustomerApproval__c);
            if ((quote.zqu__ZuoraAccountID__c == null || quote.zqu__ZuoraAccountID__c == '') && quote.Approved__c == true && quote.CustomerApproval__c == true){
                QuoteTriggerHandler.isRunning = true;
                //generateShipmentCharges(quote);
                Z_SendToZuora.sendToZuora(quote.Id);
            }
        }
    }

    public void updateStatus(zqu__Quote__c[] updatedQuotes, Map<Id, zqu__Quote__c> oldQuotes){
        for (zqu__Quote__c quote : updatedQuotes){
            if (quote.Approved__c == false && quote.CustomerApprovalOverride__c) {
                quote.RecordTypeId  = customerApprovalOverrideRecordTypeId;
            }
            if (quote.Approved__c == false && quote.isPending__c) {
                quote.RecordTypeId  = pendingApprovalPendingCustomerRecordTypeId;
            }
            if (oldQuotes.get(quote.Id).Approved__c == false && quote.Approved__c == true && 
                quote.CustomerApproval__c == false) {
                quote.zqu__Status__c = 'Out for Signature';
                quote.RecordTypeId  = outForSignatureRecordTypeId;
            }
            if ((oldQuotes.get(quote.Id).Approved__c == false || oldQuotes.get(quote.Id).CustomerApproval__c == false) && quote.Approved__c == true && quote.CustomerApproval__c == true && (!(issuedOrderRecordTypeId == oldQuotes.get(quote.Id).RecordTypeId ))){
                if (!quote.CustomerApprovalOverride__c){
                    quote.zqu__Status__c = 'Customer Approved';
                    quote.RecordTypeId  = customerApprovedRecordTypeId;
                } 
                else {
                    quote.zqu__Status__c = 'Customer Approved';
                    quote.RecordTypeId  = customerApprovedRecordTypeId;
                }
            }
            if (oldQuotes.get(quote.Id).Approved__c == false && quote.Approved__c == true && (quote.Vendor__c != null && !(quote.Vendor__c).equalsIgnoreCase('Alertdriving'))
                    && (!(issuedOrderRecordTypeId == oldQuotes.get(quote.Id).RecordTypeId ))
                    &&
                (quote.CustomerApprovalOverride__c == true ||  
                quote.Recurring_Charge_Count__c == 0 && 
                quote.Quote_Count_Shipment_Charges__c > 0 &&
                quote.Termination_Fee_Flag__c == false)) {
                quote.zqu__Status__c = 'Customer Approved';
                quote.RecordTypeId  = customerApprovedRecordTypeId;
            }
            if (oldQuotes.get(quote.Id).Approved__c == false && quote.Approved__c == true && quote.isPending__c == true) {
               quote.zqu__Status__c = 'Approved Pending Customer';
               quote.RecordTypeId  = approvedPendingCustomerRecordTypeId;
            }
        }
    }
    
}