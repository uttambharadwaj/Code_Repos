public class CPQQuoteApprovalEmailController {
    public Id quoteID { get; set; }
    
    public SBQQ__Quote__c getQuote(){
            SBQQ__Quote__c q = new SBQQ__Quote__c();
            List<SBQQ__Quote__c>  qs = [SELECT Id, SBQQ__BillingStreet__c, SBQQ__BillingName__c, SBQQ__BillingCity__c, SBQQ__BillingState__c,
                                        SBQQ__BillingPostalCode__c, SBQQ__Opportunity2__r.Name, SBQQ__Opportunity2__c, Name, SBQQ__SalesRep__r.Name,
                                        Approval_Notes__c, Program_Name__c, Fleet_Size__c, Vehicle_Type__c, Monthly_Gallons__c,Diesel__c, Unleaded__c, Tier_1__c,
                                        From_1__c, To_1__c, Rebate_Factor_1__c, From_2__c, To_2__c, Rebate_Factor_2__c, From_3__c, To_3__c, Rebate_Factor_3__c,
                                        From_4__c, To_4__c, Rebate_Factor_4__c,
                                        (Select Id, SBQQ__ListPrice__c, Requested_Price__c, Discount_Amount__c, SBQQ__Product__r.Name, Discount_percent__c From SBQQ__LineItems__r)
                                         FROM  SBQQ__Quote__c where id =: quoteID limit 1];
        if(qs.size() >0)
             q = qs[0];

        return q;
        }
}