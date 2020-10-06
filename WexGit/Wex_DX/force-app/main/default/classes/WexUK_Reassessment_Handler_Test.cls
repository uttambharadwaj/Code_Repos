@isTest
Private class WexUK_Reassessment_Handler_Test {
@testSetup
static void setup(){
   UtilityTestLoader.setAutomation(false);
}

    static  testmethod void mytestClassMethod() {

        Schema.RecordTypeInfo accRecordType = TestDatatUtility.getRecordTypeInfo('Account', 'WES Accounts');

        Account acc = new Account(Account_Id__c = '100034nnhyhg', RecordTypeId = accRecordType.getRecordTypeId(), Name = 'Test account', Account_Type__c = 'Prospect',  Credit_Utilization__c = 76, Nird__c = System.Today());
        insert acc;

        Wex_UK_Configurable__c configVals = new Wex_UK_Configurable__c(Account_Dates__c = -90 , Confidence_Threshold_DNB__c = -1 , Confidence_Threshold_EFX__c = -1 , Credit_Limit_Threshold__c = 12500    , Credit_Util_threshold__c = 75    , CurrencyIsoCode = 'USD'   , Expiry_date_lower__c = 24    , Expiry_Date_upper__c = 12    , High_Cred_Util_limit__c = 50 , HLA_Threshold__c = 80        , Name = 'Wex UK'    , Nird_Review__c = 30  , Overall_Cred_Lmt_threshold__c = 10000    , Pre_HLA_Lower__c = 75    , Pre_HLA_Upper__c = 80);
        insert configVals ;

        Credit_Assessment__c creditAss = new Credit_Assessment__c();
        creditAss.Account__c = acc.id;
        creditAss.Review_Type__c = 'HLA';

        insert creditAss;

        map<id, id> accutidAssmtidMap = new   map<id, id>();
        accutidAssmtidMap.put(acc.id, creditAss.id);

        list<Account> acctlist = new list<account>();
        acctlist.add(acc);

        WexUK_DnBCalloutProcess DnBCall = new WexUK_DnBCalloutProcess();
        //DnBCall.DnBScenarioForTest = 'HIT';

        DnBCall.preformDnB_WF(acctlist, accutidAssmtidMap);

        // DnBCall.DnBScenarioForTest = 'HIT';


    }

    static  testmethod void createCreditAsmtTest() {

        Schema.RecordTypeInfo accRecordType = TestDatatUtility.getRecordTypeInfo('Account', 'WES Accounts');

        Account acc = new Account(Account_Id__c = '100034nnhyhg', RecordTypeId = accRecordType.getRecordTypeId(), Name = 'Test account', Account_Type__c = 'Prospect',  Credit_Utilization__c = 76, Nird__c = System.Today());
        insert acc;

        Wex_UK_Configurable__c configVals = new Wex_UK_Configurable__c(Account_Dates__c = -90 , Confidence_Threshold_DNB__c = -1 , Confidence_Threshold_EFX__c = -1 , Credit_Limit_Threshold__c = 12500    , Credit_Util_threshold__c = 75    , CurrencyIsoCode = 'USD'   , Expiry_date_lower__c = 24    , Expiry_Date_upper__c = 12    , High_Cred_Util_limit__c = 50 , HLA_Threshold__c = 80        , Name = 'Wex UK'    , Nird_Review__c = 30  , Overall_Cred_Lmt_threshold__c = 10000    , Pre_HLA_Lower__c = 75    , Pre_HLA_Upper__c = 80);
        insert configVals ;

        list<Account> acctlist = new list<account>();
        acctlist.add(acc);

        WexUK_Reassessment_Handler.createCreditAsmt(acctlist);

        acc.Credit_Utilization__c = 85;
        WexUK_Reassessment_Handler.createCreditAsmt(acctlist);

        acc.Credit_Utilization__c = 20;
        acc.Nird__c = system.today() - 100;

        WexUK_Reassessment_Handler.createCreditAsmt(acctlist);

    }

    static  testmethod void calculateExpiryDateTest() {


        Schema.RecordTypeInfo accRecordType = TestDatatUtility.getRecordTypeInfo('Account', 'WES Accounts');

        Account acc = new Account(Account_Id__c = '100034nnhyhg', RecordTypeId = accRecordType.getRecordTypeId(), Name = 'Test account', Risk_Grade_UK__c = '3 - Medium', Account_Type__c = 'Prospect',  Credit_Utilization__c = 76, Nird__c = System.Today());
        insert acc;

        Wex_UK_Configurable__c configVals = new Wex_UK_Configurable__c(Account_Dates__c = -90 , Confidence_Threshold_DNB__c = -1 , Confidence_Threshold_EFX__c = -1 , Credit_Limit_Threshold__c = 12500    , Credit_Util_threshold__c = 75    , CurrencyIsoCode = 'USD'   , Expiry_date_lower__c = 24    , Expiry_Date_upper__c = 12    , High_Cred_Util_limit__c = 50 , HLA_Threshold__c = 80        , Name = 'Wex UK'    , Nird_Review__c = 30  , Overall_Cred_Lmt_threshold__c = 10000    , Pre_HLA_Lower__c = 75    , Pre_HLA_Upper__c = 80);
        insert configVals ;

        Credit_Assessment__c creditAss = new Credit_Assessment__c();
        creditAss.Account__c = acc.id;
        creditAss.Review_Type__c = 'HLA';

        insert creditAss;

        map<id, id> accutidAssmtidMap = new   map<id, id>();
        accutidAssmtidMap.put(acc.id, creditAss.id);

        list<Account> acctlist = new list<account>();
        acctlist.add(acc);

        WexUK_Reassessment_Handler.calculateExpiryDate(acc, creditAss);

        acc.Risk_Grade_UK__c = '4 - High';
        update acc;
        WexUK_Reassessment_Handler.calculateExpiryDate(acc, creditAss);




    }

    static  testmethod void  calculateCreditUtilizationTest() {

        Schema.RecordTypeInfo accRecordType = TestDatatUtility.getRecordTypeInfo('Account', 'WES Accounts');

        Account acc = new Account(Account_Id__c = '100034nnhyhg', RecordTypeId = accRecordType.getRecordTypeId(), Name = 'Test account', Account_Type__c = 'Prospect',  Credit_Utilization__c = 76, Nird__c = System.Today());
        insert acc;

        Wex_UK_Configurable__c configVals = new Wex_UK_Configurable__c(Account_Dates__c = -90 , Confidence_Threshold_DNB__c = -1 , Confidence_Threshold_EFX__c = -1 , Credit_Limit_Threshold__c = 12500    , Credit_Util_threshold__c = 75    , CurrencyIsoCode = 'USD'   , Expiry_date_lower__c = 24    , Expiry_Date_upper__c = 12    , High_Cred_Util_limit__c = 50 , HLA_Threshold__c = 80        , Name = 'Wex UK'    , Nird_Review__c = 30  , Overall_Cred_Lmt_threshold__c = 10000    , Pre_HLA_Lower__c = 75    , Pre_HLA_Upper__c = 80);
        insert configVals ;

        Credit_Assessment__c creditAss = new Credit_Assessment__c();
        creditAss.Account__c = acc.id;
        creditAss.Review_Type__c = 'HLA';

        insert creditAss;

        map<id, id> accutidAssmtidMap = new   map<id, id>();
        accutidAssmtidMap.put(acc.id, creditAss.id);

        list<Account> acctlist = new list<account>();
        acctlist.add(acc);


        WexUK_Reassessment_Handler.calculateCreditUtilization(acc, creditAss);


        Credit_Utilization_History__c cuh = new Credit_Utilization_History__c(Overall_balance__c = 20, Overall_Credit_limit__c = 2,  account__c = acc.id);
        insert cuh;

        WexUK_Reassessment_Handler.calculateCreditUtilization(acc, creditAss);

        creditAss.Review_Type__c = 'NIRD';

        WexUK_Reassessment_Handler.calculateCreditUtilization(acc, creditAss);

    }

    static  testmethod void  calculateAutolimitIncreaseTest() {

        Schema.RecordTypeInfo accRecordType = TestDatatUtility.getRecordTypeInfo('Account', 'WES Accounts');

        Account acc = new Account(RecordTypeId = accRecordType.getRecordTypeId(), Name = 'Test account', Account_Type__c = 'Prospect',  Credit_Utilization__c = 76, Nird__c = System.Today());
        insert acc;

        Wex_UK_Configurable__c configVals = new Wex_UK_Configurable__c(Account_Dates__c = -90 , Confidence_Threshold_DNB__c = -1 , Confidence_Threshold_EFX__c = -1 , Credit_Limit_Threshold__c = 12500    , Credit_Util_threshold__c = 75    , CurrencyIsoCode = 'USD'   , Expiry_date_lower__c = 24    , Expiry_Date_upper__c = 12    , High_Cred_Util_limit__c = 50 , HLA_Threshold__c = 80        , Name = 'Wex UK'    , Nird_Review__c = 30  , Overall_Cred_Lmt_threshold__c = 10000    , Pre_HLA_Lower__c = 75    , Pre_HLA_Upper__c = 80);
        insert configVals ;

        Account_Status_History__c history = new Account_Status_History__c(Account__c = acc.Id, Auto_Limit_Increased__c = true);

        insert history ;

        WexUK_Reassessment_Handler.calculateAutolimitIncrease(acc);

    }

    static  testmethod void performCurrencyConversionTest() {

        Schema.RecordTypeInfo accRecordType = TestDatatUtility.getRecordTypeInfo('Account', 'WES Accounts');

        Account acc = new Account(Account_Id__c = '100034nnhyhg', RecordTypeId = accRecordType.getRecordTypeId(), Name = 'Test account', Account_Type__c = 'Prospect', billingcountry = 'GB',   Credit_Utilization__c = 76, Nird__c = System.Today());
        insert acc;

        Wex_UK_Configurable__c configVals = new Wex_UK_Configurable__c(Account_Dates__c = -90 , Confidence_Threshold_DNB__c = -1 , Confidence_Threshold_EFX__c = -1 , Credit_Limit_Threshold__c = 12500    , Credit_Util_threshold__c = 75    , CurrencyIsoCode = 'USD'   , Expiry_date_lower__c = 24    , Expiry_Date_upper__c = 12    , High_Cred_Util_limit__c = 50 , HLA_Threshold__c = 80        , Name = 'Wex UK'    , Nird_Review__c = 30  , Overall_Cred_Lmt_threshold__c = 10000    , Pre_HLA_Lower__c = 75    , Pre_HLA_Upper__c = 80);
        insert configVals ;

        Currency_Conversion__c cc = new Currency_Conversion__c(Currency_Value_Euro__c = 100, Client_Id__c = '100');
        insert cc;



        WexUK_Reassessment_Handler.performCurrencyConversion(acc.Account_Id__c , 1000);

        delete cc;

        WexUK_Reassessment_Handler.performCurrencyConversion(acc.Account_Id__c , 1000);

    }

    static  testmethod void WexUK_EquifaxCalloutProcessTest() {

        Schema.RecordTypeInfo accRecordType = TestDatatUtility.getRecordTypeInfo('Account', 'WES Accounts');

        Account acc = new Account(Account_Id__c = '100034nnhyhg', RecordTypeId = accRecordType.getRecordTypeId(), Name = 'Test account', Account_Type__c = 'Prospect',  Credit_Utilization__c = 76, Nird__c = System.Today());
        insert acc;

        Wex_UK_Configurable__c configVals = new Wex_UK_Configurable__c(Account_Dates__c = -90 , Confidence_Threshold_DNB__c = -1 , Confidence_Threshold_EFX__c = -1 , Credit_Limit_Threshold__c = 12500    , Credit_Util_threshold__c = 75    , CurrencyIsoCode = 'USD'   , Expiry_date_lower__c = 24    , Expiry_Date_upper__c = 12    , High_Cred_Util_limit__c = 50 , HLA_Threshold__c = 80        , Name = 'Wex UK'    , Nird_Review__c = 30  , Overall_Cred_Lmt_threshold__c = 10000    , Pre_HLA_Lower__c = 75    , Pre_HLA_Upper__c = 80);
        insert configVals ;

        Credit_Assessment__c creditAss = new Credit_Assessment__c();
        creditAss.Account__c = acc.id;
        creditAss.Review_Type__c = 'HLA';

        insert creditAss;

        map<id, id> accutidAssmtidMap = new   map<id, id>();
        accutidAssmtidMap.put(acc.id, creditAss.id);

        list<Account> acctlist = new list<account>();
        acctlist.add(acc);

        WexUK_EquifaxCalloutProcess EfxCall = new WexUK_EquifaxCalloutProcess();
        //DnBCall.DnBScenarioForTest = 'HIT';

        EfxCall.preformEfx_WF(acctlist, accutidAssmtidMap);

        // DnBCall.DnBScenarioForTest = 'HIT';


    }

    static  testmethod void ValidateAccountsTest() {
        Schema.RecordTypeInfo accRecordType = TestDatatUtility.getRecordTypeInfo('Account', 'WES Accounts');

        Account acc = new Account(Account_Id__c = '100034nnhyhg', RecordTypeId = accRecordType.getRecordTypeId(), Name = 'Test account', Account_Type__c = 'Prospect',  Credit_Utilization__c = 76, Nird__c = System.Today());
        insert acc;

        Wex_UK_Configurable__c configVals = new Wex_UK_Configurable__c(Account_Dates__c = -90 , Confidence_Threshold_DNB__c = -1 , Confidence_Threshold_EFX__c = -1 , Credit_Limit_Threshold__c = 12500    , Credit_Util_threshold__c = 75    , CurrencyIsoCode = 'USD'   , Expiry_date_lower__c = 24    , Expiry_Date_upper__c = 12    , High_Cred_Util_limit__c = 50 , HLA_Threshold__c = 80        , Name = 'Wex UK'    , Nird_Review__c = 30  , Overall_Cred_Lmt_threshold__c = 10000    , Pre_HLA_Lower__c = 75    , Pre_HLA_Upper__c = 80);
        insert configVals ;

        Credit_Assessment__c creditAss = new Credit_Assessment__c();
        creditAss.Account__c = acc.id;
        creditAss.Review_Type__c = 'HLA';

        insert creditAss;

        WexUK_Reassessment_Handler.ValidateAccounts(new Account[] {acc}, new Map<Id, Credit_Assessment__c> {acc.id => creditAss} );

        Credit_Insurance__c insurance = new Credit_Insurance__c(Expiration_Date__c = Date.Today() + 10 , Insured_limit__c = 20, Account__c = acc.Id);
        insert insurance;

        WexUK_Reassessment_Handler.ValidateAccounts(new Account[] {acc}, new Map<Id, Credit_Assessment__c> {acc.id => creditAss} );


    }

    static  testmethod void updateIsParentOverdueTest() {
        Schema.RecordTypeInfo accRecordType = TestDatatUtility.getRecordTypeInfo('Account', 'WES Accounts');
        Account acc = new Account(Account_Id__c = '100034nnhyhg', RecordTypeId = accRecordType.getRecordTypeId(), Name = 'Test account', Account_Type__c = 'Prospect',  Credit_Utilization__c = 76, Nird__c = System.Today());
        insert acc;

        Account acc1 = new Account(parentId = acc.Id, Account_Id__c = '100035nnhyhg', RecordTypeId = accRecordType.getRecordTypeId(), Name = 'Test account', Account_Type__c = 'Prospect',  Credit_Utilization__c = 76, Nird__c = System.Today());
        insert acc1;

        Wes_Accounts_Receivable__c rec = new Wes_Accounts_Receivable__c(Account__c = acc1.Id );

        insert rec;

        WexUK_Reassessment_Handler.updateIsParentOverdue(new Wes_Accounts_Receivable__c [] {rec});


    }


}