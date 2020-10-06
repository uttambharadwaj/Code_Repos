@isTest
private class DailyTransactionMonitoringTest {

    @isTest
    static void test_report_more() {

        Account acct1 = new Account(
            recordTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Fleet Account').getRecordTypeId(),
            name = 'Test Account 1',
            carrier_id__c = '456',
            billingState = null,
            corporate_issuer__c = null
        );

        insert acct1;

        Account acct2 = new Account(
            recordTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Fleet Account').getRecordTypeId(),
            name = 'Test Account2',
            carrier_id__c = '123',
            billingState = 'KY',
            corporate_issuer__c = 'SHELL'
        );

        insert acct2;

        List<Transaction_Summary__c> summaries = new List<Transaction_Summary__c>();

        for ( Integer i = 0; i < 4; i++ ) {
            summaries.add( new Transaction_Summary__c(
                account__c = acct2.id,
                last_processed_date__c = Date.today().addDays( i * 7 * -1 )
            ));
        }

        insert summaries;

        List<Transaction_Summary_Detail__c> details = new List<Transaction_Summary_Detail__c>();

        for ( Integer i = 0; i < summaries.size(); i++ ) {
            details.add( new Transaction_Summary_Detail__c(
                transaction_summary__c = summaries[i].id,
                transaction__c = 100 * i + 100
            ));
        }

        insert details;

        summaries = [ SELECT id, account__c, last_processed_date__c FROM Transaction_Summary__c ];
        details = [ SELECT id, transaction_summary__c, transaction__c FROM Transaction_Summary_Detail__c ];

        System.debug( 'test tx summaries: ' + summaries );
        System.debug( 'text tx details: ' + details );

        Test.startTest();

        DailyTransactionMonitoring dtm = new DailyTransactionMonitoring();

        dtm.moreOrLess = 'more';
        dtm.RefreshValues();

        List<DailyTransactionMonitoring.AccountItem> items = dtm.getItems();
        System.debug( items );

        PageReference excelPage = dtm.Export();
        System.debug( excelPage );

        List<SelectOption> picklistValues = dtm.getMoLValues();
        System.debug( picklistValues );

        Test.stopTest();

    }

    @isTest
    static void test_report_less() {

        List<Account> accounts = new List<Account>();

        Account acct1 = new Account(
            recordTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Fleet Account').getRecordTypeId(),
            name = 'Test Account 1',
            carrier_id__c = '456',
            billingState = null,
            corporate_issuer__c = null
        );

        accounts.add( acct1 );

        Account acct2 = new Account(
            recordTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Fleet Account').getRecordTypeId(),
            name = 'Test Account2',
            carrier_id__c = '123',
            billingState = 'KY',
            corporate_issuer__c = 'SHELL'
        );

        accounts.add( acct2 );

        insert accounts;

        Map<String, Account> carrierIdToAccountMap = new Map<String, Account>();
        for ( Account acct : accounts ) {
            carrierIdToAccountMap.put( acct.carrier_id__c, acct );
        }

        List<Transaction_Summary__c> summaries = new List<Transaction_Summary__c>();

        for ( Integer i = 0; i < 4; i++ ) {
            summaries.add( new Transaction_Summary__c(
                account__c = acct2.id,
                last_processed_date__c = Date.today().addDays( i * 7 * -1 )
            ));
        }

        insert summaries;

        List<Transaction_Summary_Detail__c> details = new List<Transaction_Summary_Detail__c>();

        for ( Integer i = 0; i < summaries.size(); i++ ) {
            details.add( new Transaction_Summary_Detail__c(
                transaction_summary__c = summaries[i].id,
                transaction__c = 100 * i + 100
            ));
        }

        insert details;

        summaries = [ SELECT id, account__c, last_processed_date__c FROM Transaction_Summary__c ];
        details = [ SELECT id, transaction_summary__c, transaction__c FROM Transaction_Summary_Detail__c ];

        System.debug( 'test tx summaries: ' + summaries );
        System.debug( 'text tx details: ' + details );

        Test.startTest();

        DailyTransactionMonitoring dtm = new DailyTransactionMonitoring();

        dtm.moreOrLess = 'less';
        dtm.RefreshValues();

        List<DailyTransactionMonitoring.AccountItem> items = dtm.getItems();
        System.debug( items );

        PageReference excelPage = dtm.Export();
        System.debug( excelPage );
        System.debug( dtm.dataModel );

        List<SelectOption> picklistValues = dtm.getMoLValues();
        System.debug( picklistValues );

        Test.stopTest();

    }

}