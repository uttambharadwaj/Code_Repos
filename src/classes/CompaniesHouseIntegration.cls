public with sharing class CompaniesHouseIntegration {
    public static final Integer BATCH_SIZE = 4;
    public static Set<Id> processedIds = new Set<Id> ();


    public static void getNameAddress(Set<Id> acctIds) {
        String authorization;
        List<Companies_House_Integration__mdt> authList = [SELECT Value__c FROM Companies_House_Integration__mdt WHERE DeveloperName = 'Authorization'];
        if (!authList.isEmpty()) {
            authorization = authList[0].Value__c;
        }

        List<Id> records = new List<Id>(acctIds);
        for (Integer i = 0; i<(records.size() / BATCH_SIZE) + 1; i++) {
            Set<Id> batchIds = new Set<Id> ();
            for (Integer j = i * BATCH_SIZE; (j<(i * BATCH_SIZE) + BATCH_SIZE) && (j<records.size()); j++) {
                batchIds.add(records.get(j));
            }

            if (!batchIds.isEmpty()) {
                doCallouts(batchIds, authorization);
            }
        }
    }

    @future(callout = true)
    public static void doCallouts(Set<Id> batchIds, String authorization) {
        List<Account> acctList = new List<Account> ();

        for (Account acct : [SELECT Company_registration_number__c FROM Account WHERE Id IN :batchIds]) {
            if (acct.Company_registration_number__c!=null) {
                getNameAddress(acct, authorization);
                acctList.add(acct);
            }
        }

        //perform DML after callouts
        if (!acctList.isEmpty()) {
            update acctList;
        }
    }

    private static void getNameAddress(Account acct, String authorization) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:CompaniesHouse' + '/' + acct.Company_registration_number__c);

        req.setHeader('Authorization', authorization);

        req.setMethod('GET');
        Http http = new Http();
        try {
            HTTPResponse res = http.send(req);
            CompaniesHouseResponse companiesResponse = CompaniesHouseResponse.parse(res.getBody());
            acct.WES_CompaniesHouseInfo__c = companiesResponse.company_name + ', ' +
                                             companiesResponse.registered_office_address.address_line_1 + ', ' +
                                             companiesResponse.registered_office_address.address_line_2 + ', ' +
                                             companiesResponse.registered_office_address.locality + ', ' +
                                             companiesResponse.registered_office_address.region + ', ' +
                                             companiesResponse.registered_office_address.postal_code;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }
}