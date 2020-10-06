public without sharing class CreditInsuranceTriggerHandler {

    public static final String APPROVED = 'Approved';
    public static boolean hasExecutedOncePolicy = false;


    public static void validateInsuranceInsert(List<Credit_Insurance__c> insurances) {
        List<Id> accountsOfApprovedInsurances = new List<Id>();
        for (Credit_Insurance__c insurance : insurances) {
            if (insurance.Status__c == APPROVED) {
                accountsOfApprovedInsurances.add(insurance.Account__c);
            }
        }

        validateInsuranceUniqueness(insurances, accountsOfApprovedInsurances);
    }

    public static void validateInsuranceUpdate(List<Credit_Insurance__c> insurances, Map<Id, Credit_Insurance__c> oldMap) {
        List<Id> accountsOfApprovedInsurances = new List<Id>();
        for (Credit_Insurance__c insurance : insurances) {
            if (insurance.Status__c == APPROVED && oldMap.get(insurance.id).Status__c != APPROVED) {
                accountsOfApprovedInsurances.add(insurance.Account__c);
            }
        }
        validateInsuranceUniqueness(insurances, accountsOfApprovedInsurances);
    }

    public static void onInsert(List<Credit_Insurance__c> policies) {

        addCurrency(policies);

        Map<Id, Date> accountIdExpirationDateMap = new Map<Id, Date>();
        for (Credit_Insurance__c policy : policies) {
            if (policy.Expiration_Date__c != null) {
                accountIdExpirationDateMap.put(policy.Account__c, policy.Expiration_Date__c);
            }
        }
        updateAccountsInsuranceExpirationDate(accountIdExpirationDateMap);
    }

    public static void onUpdate(List<Credit_Insurance__c> policies, Map<Id, Credit_Insurance__c> oldMap) {
        Map<Id, Date> accountIdExpirationDateMap = new Map<Id, Date>();
        for (Credit_Insurance__c policy : policies) {
            if (policy.Expiration_Date__c != null && oldMap.get(policy.id).Expiration_Date__c != policy.Expiration_Date__c) {
                accountIdExpirationDateMap.put(policy.Account__c, policy.Expiration_Date__c);
            }
        }
        updateAccountsInsuranceExpirationDate(accountIdExpirationDateMap);
    }

    private static void updateAccountsInsuranceExpirationDate(Map<Id, Date> accountIdExpirationDateMap) {
        List<Account> accounts = [select id, Insurance_Expiration_Date__c from Account where id in : accountIdExpirationDateMap.keySet()];
        for (Account acc : accounts) {
            acc.Insurance_Expiration_Date__c = accountIdExpirationDateMap.get(acc.id);
        }
        update accounts;
    }

    private static void validateInsuranceUniqueness(List<Credit_Insurance__c> insurances, List<Id> accountsOfApprovedInsurances) {
        List<Credit_Insurance__c> accountsApprovedInsurances = [select id, Account__c from Credit_Insurance__c where Account__c in : accountsOfApprovedInsurances and status__c = : APPROVED];
        Set<Id> accIdsWithApprovedInsurance = new Set<Id>();
        for (Credit_Insurance__c ins : accountsApprovedInsurances) {
            accIdsWithApprovedInsurance.add(ins.Account__c);
        }

        for (Credit_Insurance__c insurance : insurances) {
            if (insurance.Status__c == APPROVED && accIdsWithApprovedInsurance.contains(insurance.Account__c)) {
                insurance.addError(Label.ExistingApprovedCreditInsurance);
            }
        }
    }

    public static void addCurrency(List<Credit_Insurance__c> policies) {

        /*if (hasExecutedOncePolicy == true) {
            return;
        }

        hasExecutedOncePolicy = true; */

        List<Credit_Insurance__c> toupdatePolicies = new List<Credit_Insurance__c>();
        Set<Id> setPolicyIds = new Set<Id>();

        for (Credit_Insurance__c s : policies) {
            setPolicyIds.add(s.Id);
        }

        List<Credit_Insurance__c> creditInsuranceList = [select Id, Account__c, Account__r.Currency__c, Insured_limit__c from Credit_Insurance__c where id in : setPolicyIds];


        for (Credit_Insurance__c sec : creditInsuranceList) {
            if (!String.isBlank(sec.Account__c) && !String.isBlank(sec.Account__r.Currency__c)) {
                sec.CurrencyIsoCode = sec.Account__r.Currency__c;
                sec.Insured_limit__c = sec.Insured_limit__c;
                toupdatePolicies.add(sec);
            }
        }

        if (!toupdatePolicies.isEmpty()) {
            Database.SaveResult[] lsr = Database.update(toupdatePolicies, false);
        }
    }


}