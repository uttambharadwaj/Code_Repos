public with sharing class DailyTransactionMonitoring {

    public DailyTransactionMonitoring() {
        moreOrLess = 'more';
        dummyContact = new Contact();
        dummyContact.Birthdate = Date.today();
        RefreshValues();
    }

    public void RefreshValues() {
        List<Account> accounts = [SELECT Name, Carrier_ID__c, BillingState, Corporate_Issuer__c FROM Account WHERE Carrier_ID__c != null LIMIT 1000];
        System.debug( 'accounts=' + accounts );

        items = new List<AccountItem>();

        Map<Id, AggregateResult> todayTs = new Map<Id, AggregateResult>([SELECT Account__c Id, SUM(Total_Transaction__c) Sum FROM Transaction_Summary__c WHERE Account__c in :accounts AND Last_Processed_Date__c = :dummyContact.Birthdate GROUP BY Account__c]);
        Map<Id, AggregateResult> week1Ts = new Map<Id, AggregateResult>([SELECT Account__c Id, SUM(Total_Transaction__c) Sum FROM Transaction_Summary__c WHERE Account__c in :accounts AND Last_Processed_Date__c = :dummyContact.Birthdate.adddays(-7) GROUP BY Account__c]);
        Map<Id, AggregateResult> week2Ts = new Map<Id, AggregateResult>([SELECT Account__c Id, SUM(Total_Transaction__c) Sum FROM Transaction_Summary__c WHERE Account__c in :accounts AND Last_Processed_Date__c = :dummyContact.Birthdate.adddays(-14) GROUP BY Account__c]);
        Map<Id, AggregateResult> week3Ts = new Map<Id, AggregateResult>([SELECT Account__c Id, SUM(Total_Transaction__c) Sum FROM Transaction_Summary__c WHERE Account__c in :accounts AND Last_Processed_Date__c = :dummyContact.Birthdate.adddays(-21) GROUP BY Account__c]);

        System.debug( 'todayTs=' + todayTs );
        System.debug( 'week1Ts=' + week1Ts );
        System.debug( 'week2Ts=' + week2Ts );
        System.debug( 'week3Ts=' + week3Ts );

        for (Account account :accounts) {
            AccountItem newAI = new AccountItem(account);
            if (todayTs.containsKey(account.Id))
                newAI.current = Integer.valueOf((decimal)todayTs.get(account.Id).get('Sum'));
            Integer avg = 0;
            if (week1Ts.containsKey(account.Id))
                avg += Integer.valueOf((decimal)week1Ts.get(account.Id).get('Sum'));
            if (week2Ts.containsKey(account.Id))
                avg += Integer.valueOf((decimal)week2Ts.get(account.Id).get('Sum'));
            if (week3Ts.containsKey(account.Id))
                avg += Integer.valueOf((decimal)week3Ts.get(account.Id).get('Sum'));
            avg /= 3;
            newAI.average = avg;
            if (moreOrLess == 'more' && newAI.percent >= 15)
                items.add(newAI);
            if (moreOrLess == 'less' && newAI.percent <= 15)
                items.add(newAI);
        }
    }

    private List<AccountItem> items;

    public List<AccountItem> getItems() {
        return items;
    }

    public Contact dummyContact { get; set; }

    public String moreOrLess { get; set; }

    public List<SelectOption> getMoLValues() {
        List<SelectOption> sos = new List<SelectOption>();
        sos.add(new SelectOption('more', '> 15%'));
        sos.add(new SelectOption('less', '< 15%'));
        return sos;
    }

    public PageReference Export() {
        dataModel = new ExcelDataModel();
        dataModel.data = new list<ExcelDataModel.SingleDataModel>();

        ExcelDataModel.SingleDataModel model = new ExcelDataModel.SingleDataModel();
        model.sheetname = 'Transactions';
        model.headers = new list<string>{'Carrier ID','Issuer ID','Carrier Name','ST','Ave.','Curr.','Diff.' ,'%'};
        model.data = new list<map<string,string>>();

        for (AccountItem item : items){

            Map<string,string> rowdata = new Map<String,String>();

            rowdata.put('Carrier ID', getDefaultIfBlank( item.account.Carrier_ID__c ) );
            rowdata.put('Issuer ID', getDefaultIfBlank( item.account.Corporate_Issuer__c ) );
            rowdata.put('Carrier Name', getDefaultIfBlank( item.account.Name ) );
            rowdata.put('ST', getDefaultIfBlank( item.account.BillingState ) );
            rowdata.put('Ave.', getDefaultFormatIfBlank( item.average ) );
            rowdata.put('Curr.', getDefaultFormatIfBlank( item.current ) );
            rowdata.put('Diff.', getDefaultFormatIfBlank( item.diff ) );
            rowdata.put('%', getDefaultFormatIfBlank( item.percent ) );

            model.data.add(rowdata);
        }
        dataModel.data.add(model);

        PageReference acctPage = Page.ExcelGenerate;
        acctPage.setRedirect(false);
        return acctPage;
    }

    public String getDefaultIfBlank( String value ) {
        return getDefaultIfBlank( value, '' );
    }

    public String getDefaultIfBlank( String value, String defaultValue ) {
        return String.isBlank( value ) ? defaultValue : value;
    }

    public String getDefaultFormatIfBlank( Integer value ) {
        return getDefaultFormatIfBlank( value, '' );
    }

    public String getDefaultFormatIfBlank( Integer value, String defaultValue ) {
        return ( value == null ) ? defaultValue : value.format();
    }

    public ExcelDataModel dataModel { get; set; }

    public class AccountItem {
        public Account account { get; set; }
        public Integer average { get; set; }
        public Integer current { get; set; }
        public Integer diff {
            get {
                if (average == null || current == null)
                    return null;
                return average - current;
            }
        }
        public Integer percent {
            get {
                if (diff == null)
                    return null;
                if (average == 0)
                    return 0;
                return diff * 100 / average;
            }
        }

        public AccountItem(Account acc) {
            account = acc;
            average = 0;
            current = 0;
        }
    }

}