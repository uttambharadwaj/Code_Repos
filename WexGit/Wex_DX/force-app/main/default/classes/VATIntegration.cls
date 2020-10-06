public with sharing class VATIntegration {
    public static final Integer BATCH_SIZE = 4;
    public static Set<Id> processedIds = new Set<Id> ();

    public static void validateVAT(Set<Id> reqIds) {
        List<Id> records = new List<Id>(reqIds);
        for (Integer i = 0; i<(records.size() / BATCH_SIZE) + 1; i++) {
            Set<Id> batchIds = new Set<Id> ();
            for (Integer j = i * BATCH_SIZE; (j<(i * BATCH_SIZE) + BATCH_SIZE) && (j<records.size()); j++) {
                batchIds.add(records.get(j));
            }

            if (!batchIds.isEmpty()) {
                doCallouts(batchIds);
            }
        }
    }

    @future(callout = true)
    public static void doCallouts(Set<Id> batchIds) {
        List<Account> acctList = [SELECT WES_VAT_Reg_Num__c,
                                         WES_ISO_Country_Code__c
                                         FROM
                                         Account
                                         WHERE
                                         Id IN :batchIds];

        for (Account acct : acctList) {
            validateVAT(acct);
        }

        //perform DML after callouts
        if (!acctList.isEmpty()) {
            update acctList;
        }
    }

    public static void validateVAT(Account acct) {
        try {
            VATCheckStub.checkVatPort client = new VATCheckStub.checkVatPort();
            client.endpoint_x = 'callout:VATCheck';
            VATCheckTypes.checkVatResponse_element response = client.checkVat(acct.WES_ISO_Country_Code__c, acct.WES_VAT_Reg_Num__c);
            if (response.valid==true) {
                acct.VAT_Check__c = 'Pass';
            } else {
                acct.VAT_Check__c = 'Fail';
            }
        } catch(Exception e) {
            System.debug('Error - ' + e.getMessage());
        }
    }
}