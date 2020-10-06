public without sharing class SecurityTriggerHandler {

    /*
    public static void onAfterUpdate(List<Security__c> newSecurities,Map<Id,Security__c> oldSecurities){

    List<Id> accountsConverted = new List<Id>();
    List<Id> accountsunConverted = new List<Id>();

    for(Security__c sec : newSecurities){
        if(sec.Security_Type__c == 'Bank Guarantee' && oldSecurities.get(sec.id).Security_Type__c == 'Cash Deposit'){
            accountsConverted.add(sec.Account__c);
        }
        if(sec.Security_Type__c == 'Cash Deposit' && oldSecurities.get(sec.id).Security_Type__c != 'Cash Deposit'){
            accountsunConverted.add(sec.Account__c);
        }
    }

    convert(accountsConverted);
    unconvert(accountsunConverted);

    }*/

    public static boolean hasExecutedOnceSecurity = false;

    public static void onAfterUpdate(List<Security__c> newSecurities, Map<Id, Security__c> oldSecurities) {

        List<Id> accountsConverted = new List<Id>();
        List<Id> accountsunConverted = new List<Id>();
        Set<Id> accountsSecurityType = new Set<Id>();

        for (Security__c sec : newSecurities) {

            accountsSecurityType.add(sec.Account__c);

            if (sec.Security_Type__c == 'Bank Guarantee' && oldSecurities.get(sec.id).Security_Type__c == 'Cash Deposit') {
                accountsConverted.add(sec.Account__c);
            }
            if (sec.Security_Type__c == 'Cash Deposit' && oldSecurities.get(sec.id).Security_Type__c != 'Cash Deposit') {
                accountsunConverted.add(sec.Account__c);
            }
        }

        convert(accountsConverted);
        unconvert(accountsunConverted);
        updateAccountSecurityType(accountsSecurityType);

    }

    public static void onAfterInsert(List<Security__c> newSecurities) {

        addCurrency(newSecurities);        

        Set<Id> accountsSecurityType = new Set<Id>();

        for (Security__c sec : newSecurities) {
            accountsSecurityType.add(sec.Account__c);
        }

        updateAccountSecurityType(accountsSecurityType);

    }

    public static void onBeforeUpdate(List<Security__c> newSecurities) {
        updateSecurityExpiredFlag(newSecurities);
    }

    public static void onBeforeInsert(List<Security__c> newSecurities) {
        //addCurrency(newSecurities);
        updateSecurityExpiredFlag(newSecurities);
    }


    public static void onAfterDelete(List<Security__c> oldSecurities) {

        Set<Id> accountsSecurityType = new Set<Id>();

        for (Security__c sec : oldSecurities) {
            accountsSecurityType.add(sec.Account__c);
        }

        updateAccountSecurityType(accountsSecurityType);

    }

    public static void onAfterUndelete(List<Security__c> newSecurities) {

        Set<Id> accountsSecurityType = new Set<Id>();

        for (Security__c sec : newSecurities) {
            accountsSecurityType.add(sec.Account__c);
        }

        updateAccountSecurityType(accountsSecurityType);

    }


    private static void convert(List<Id> accountIds) {
        List<Account> accounts = [select Deposit_Guarantee_Conversion__c , Deposit_Guarantee_Conversion_Date__c, Deposit_Guarantee_Converter_Name__c from Account where id in : accountIds];
        for (Account acc : accounts) {
            acc.Deposit_Guarantee_Conversion__c = true;
            acc.Deposit_Guarantee_Conversion_Date__c = date.today();
            acc.Deposit_Guarantee_Converter_Name__c = UserInfo.getName();
        }
        update accounts;
    }

    private static void unconvert(List<Id> accountIds) {
        List<Account> accounts = [select Deposit_Guarantee_Conversion__c , Deposit_Guarantee_Conversion_Date__c, Deposit_Guarantee_Converter_Name__c from Account where id in : accountIds];
        for (Account acc : accounts) {
            acc.Deposit_Guarantee_Conversion__c = false;
            acc.Deposit_Guarantee_Conversion_Date__c = null;
            acc.Deposit_Guarantee_Converter_Name__c = null;
        }
        update accounts;
    }

    public static void updateSecurityExpiredFlag(List<Security__c> newSecurities) {
        for (Security__c sec : newSecurities) {
            if (sec.Security_Expiry_Date__c != null && (sec.Security_Expiry_Date__c < date.today())) {
                sec.isExpired__c = true;
            } else {
                sec.isExpired__c = false;
            }
        }
    }

    private static void updateAccountSecurityType(Set<id> accountIds) {
        List<Account> accountsWithSecurities = [select id, Security_Type__c, (select id, Security_Type__c from Securities__r) from Account where id in : accountIds];
        List<Account> accountToUpdate = new List<Account>();

        for ( Account a : accountsWithSecurities) {

            set<String> setSecurityType = new set<String>();

            for (Security__c s : a.Securities__r) {
                //if(!String.isBlank(s.Security_Type__c)){
                setSecurityType.add(s.Security_Type__c);
                //}
            }

            if (!setSecurityType.isEmpty() && setSecurityType.size() == 1) {

                string securityTypeValue =  (new list<string>(setSecurityType)[0]);

                if ((String.isBlank(a.Security_Type__c) || a.Security_Type__c != securityTypeValue)) {
                    if (!String.isBlank(securityTypeValue)) {
                        system.debug('Account Security Type    ' +  a.Security_Type__c );
                        system.debug('Update Security Type with \'' + securityTypeValue + '\' value on Account ' + a.id + ' and has SecurityType(s) as:  ' + setSecurityType);
                        a.Security_Type__c = securityTypeValue;
                        accountToUpdate.add(a);
                    } else {
                        system.debug('Account Security Type    ' +  a.Security_Type__c );
                        system.debug('Update Security Type with NULL value on Account ' + a.id + ' and has SecurityType(s) NULL values');
                        a.Security_Type__c = '';
                        accountToUpdate.add(a);
                    }

                }

            } else if (!setSecurityType.isEmpty() && setSecurityType.size() > 1) {
                if (String.isBlank(a.Security_Type__c) || a.Security_Type__c != 'Mixed Security') {
                    system.debug('Account Security Type    ' +  a.Security_Type__c );
                    system.debug('Update Security Type with \'Mixed\'  value on Account  ' + a.id + + ' and has SecurityType(s) as:  ' + setSecurityType);
                    a.Security_Type__c = 'Mixed Security';
                    accountToUpdate.add(a);
                }
            } else if (setSecurityType.isEmpty() && !String.isBlank(a.Security_Type__c)) {
                system.debug('Account Security Type    ' +  a.Security_Type__c );
                system.debug('Update Security Type with \'NULL\'  value on Account  ' + a.id + + ' and has no security types');
                a.Security_Type__c = null;
                accountToUpdate.add(a);
            }

        }
        if (!accountToUpdate.isEmpty()) {
            update accountToUpdate;
        }
    }

    public static void addCurrency(List<Security__c> newSecurities) {
       
        List<Security__c> toupdateSecurities = new List<Security__c>();
        Set<Id> setSecurityIds = new Set<Id>();

        for(Security__c s: newSecurities){
            setSecurityIds.add(s.Id);
        }

        List<Security__c> securityList = [select Id, Account__c, Account__r.Currency__c, Security_Limit__c from Security__c where id in : setSecurityIds];

        
        for (Security__c sec : securityList) {
            if (!String.isBlank(sec.Account__c) && !String.isBlank(sec.Account__r.Currency__c)) {
                sec.CurrencyIsoCode = sec.Account__r.Currency__c;
                sec.Security_Limit__c = sec.Security_Limit__c;
                toupdateSecurities.add(sec);
            }
        }

        if(!toupdateSecurities.isEmpty()){
            Database.SaveResult[] lsr = Database.update(toupdateSecurities, false);
        }
    }

}