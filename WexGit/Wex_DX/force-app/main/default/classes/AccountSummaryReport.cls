public with sharing class AccountSummaryReport {

    private Id accountId;

    public AccountSummaryReport(ApexPages.StandardController contr) {

        accountId = contr.getId();

        Contracts = [SELECT Id, Last_Transaction__c, Requested_Payment_Frequency__c, Credit_Limit__c,
                        Check__c, Cards_Active__c, Funded_Fuel_Card_Fee__c, Payment_Method__c
                     FROM Contract__c WHERE Account__c = :accountId];

        TotalCreditLine = 0;
        TotalFuelFee = 0;
        TotalTransCheckFee = 0;
        TotalActiveControlCards = 0;

        for (Contract__c contract : Contracts) {
            if (contract.Credit_Limit__c != null)
                TotalCreditLine += contract.Credit_Limit__c;
            if (contract.Funded_Fuel_Card_Fee__c != null)
                TotalFuelFee += contract.Funded_Fuel_Card_Fee__c;
            if (contract.Check__c != null)
                TotalTransCheckFee += contract.Check__c;
            if (contract.Cards_Active__c != null)
                TotalActiveControlCards += contract.Cards_Active__c;
        }

        Date firstDate = date.today().toStartOfMonth().addMonths(-13);
        List<Transaction_Summary_Detail__c> details = [SELECT Id, Chain__c, Transaction__c, Gallons__c, Amount_Transferred__c, Revenue__c,
                                                            Transaction_Summary__r.Last_Processed_Date__c, Product__c
                                                        FROM Transaction_Summary_Detail__c WHERE Transaction_Summary__r.Account__c = :accountId AND Transaction_Summary__r.Last_Processed_Date__c >= :firstDate];

        Map<String, TransactionsByChain> TransactionsByChainMap = new Map<String, TransactionsByChain>();
        TransactionsByChainTotal = new TransactionsByChain('Total');
        Map<String, TransactionsByChain> TransactionsByProductMap = new Map<String, TransactionsByChain>();
        TransactionsByProductTotal = new TransactionsByChain('Total');
        Map<Date, TransactionsLastYear> TransactionsLastYearMap = new Map<Date, TransactionsLastYear>();
        TransactionsLastYearTotal = new TransactionsLastYear(Date.today());
        Map<Date, TransactionsLastYear> TransactionsDaysMap = new Map<Date, TransactionsLastYear>();
        TransactionsDaysTotal = new TransactionsLastYear(Date.today());

        for (Transaction_Summary_Detail__c detail : details) {
            string chain = detail.Chain__c;
            string product = detail.Product__c;
            date month1 = detail.Transaction_Summary__r.Last_Processed_Date__c.toStartOfMonth();
            date month2 = detail.Transaction_Summary__r.Last_Processed_Date__c;

            if (month2 >= date.today().addDays(-30)) {
                // Chain
                if (chain == null || chain == '')
                    chain = '--';
                if (!TransactionsByChainMap.containskey(chain))
                    TransactionsByChainMap.put(chain, new TransactionsByChain(chain));
                TransactionsByChainMap.get(chain).Transactions += detail.Transaction__c == null ? 0 : detail.Transaction__c;
                TransactionsByChainMap.get(chain).Gallons += detail.Gallons__c == null ? 0 : detail.Gallons__c;
                TransactionsByChainMap.get(chain).Amount += detail.Amount_Transferred__c == null ? 0 : detail.Amount_Transferred__c;
                TransactionsByChainMap.get(chain).Discount += 0;
                TransactionsByChainMap.get(chain).TotalRevenue += detail.Revenue__c == null ? 0 : detail.Revenue__c;
                TransactionsByChainTotal.Transactions += detail.Transaction__c == null ? 0 : detail.Transaction__c;
                TransactionsByChainTotal.Gallons += detail.Gallons__c == null ? 0 : detail.Gallons__c;
                TransactionsByChainTotal.Amount += detail.Amount_Transferred__c == null ? 0 : detail.Amount_Transferred__c;
                TransactionsByChainTotal.Discount += 0;
                TransactionsByChainTotal.TotalRevenue += detail.Revenue__c == null ? 0 : detail.Revenue__c;

                // Product
                if (product == null || product == '')
                    product = '--';
                if (!TransactionsByProductMap.containskey(product))
                    TransactionsByProductMap.put(product, new TransactionsByChain(product));
                TransactionsByProductMap.get(product).Transactions += detail.Transaction__c == null ? 0 : detail.Transaction__c;
                TransactionsByProductMap.get(product).Gallons += detail.Gallons__c == null ? 0 : detail.Gallons__c;
                TransactionsByProductMap.get(product).Amount += detail.Amount_Transferred__c == null ? 0 : detail.Amount_Transferred__c;
                TransactionsByProductMap.get(product).Discount += 0;
                TransactionsByProductMap.get(product).TotalRevenue += detail.Revenue__c == null ? 0 : detail.Revenue__c;
                TransactionsByProductTotal.Transactions += detail.Transaction__c == null ? 0 : detail.Transaction__c;
                TransactionsByProductTotal.Gallons += detail.Gallons__c == null ? 0 : detail.Gallons__c;
                TransactionsByProductTotal.Amount += detail.Amount_Transferred__c == null ? 0 : detail.Amount_Transferred__c;
                TransactionsByProductTotal.Discount += 0;
                TransactionsByProductTotal.TotalRevenue += detail.Revenue__c == null ? 0 : detail.Revenue__c;
            }

            if (month1 >= date.today().toStartOfMonth().addmonths(-13)) {
                if (!TransactionsLastYearMap.containskey(month1))
                    TransactionsLastYearMap.put(month1, new TransactionsLastYear(month1));
                TransactionsLastYearMap.get(month1).Transactions += detail.Transaction__c == null ? 0 : detail.Transaction__c;
                TransactionsLastYearMap.get(month1).Amount += detail.Amount_Transferred__c == null ? 0 : detail.Amount_Transferred__c;
                TransactionsLastYearMap.get(month1).Revenue += detail.Revenue__c == null ? 0 : detail.Revenue__c;
                TransactionsLastYearTotal.Transactions += detail.Transaction__c == null ? 0 : detail.Transaction__c;
                TransactionsLastYearTotal.Amount += detail.Amount_Transferred__c == null ? 0 : detail.Amount_Transferred__c;
                TransactionsLastYearTotal.Revenue += detail.Revenue__c == null ? 0 : detail.Revenue__c;
            }

            if (month2 >= date.today().addDays(-30)) {
                if (!TransactionsDaysMap.containskey(month2))
                    TransactionsDaysMap.put(month2, new TransactionsLastYear(month2));
                TransactionsDaysMap.get(month2).Transactions += detail.Transaction__c == null ? 0 : detail.Transaction__c;
                TransactionsDaysMap.get(month2).Amount += detail.Amount_Transferred__c == null ? 0 : detail.Amount_Transferred__c;
                TransactionsDaysMap.get(month2).Revenue += detail.Revenue__c == null ? 0 : detail.Revenue__c;
                TransactionsDaysTotal.Transactions += detail.Transaction__c == null ? 0 : detail.Transaction__c;
                TransactionsDaysTotal.Amount += detail.Amount_Transferred__c == null ? 0 : detail.Amount_Transferred__c;
                TransactionsDaysTotal.Revenue += detail.Revenue__c == null ? 0 : detail.Revenue__c;
            }
        }

        TransactionsByChainList = TransactionsByChainMap.values();
        for (TransactionsByChain tbc : TransactionsByChainList)
            if (TransactionsByChainTotal.Gallons != 0)
                tbc.PercentOfTotalGallons = tbc.Gallons / TransactionsByChainTotal.Gallons;
        TransactionsByChainTotal.PercentOfTotalGallons = 1;

        TransactionsByProductList = TransactionsByProductMap.values();
        for (TransactionsByChain tbc : TransactionsByProductList)
            if (TransactionsByProductTotal.TotalRevenue != 0)
                tbc.PercentOfTotalRevenue = tbc.TotalRevenue / TransactionsByProductTotal.TotalRevenue;
        TransactionsByProductTotal.PercentOfTotalRevenue = 1;

        TransactionsLastYearList = new List<TransactionsLastYear>();
        for (integer i = -13; i <= 0; i++) {
            Date month = Date.today().toStartOfMonth().addMonths(i);
            if (TransactionsLastYearMap.containskey(month))
                TransactionsLastYearList.add(TransactionsLastYearMap.get(month));
            else
                TransactionsLastYearList.add(new TransactionsLastYear(month));
        }
        TransactionsLastYearAvg = new TransactionsLastYear(Date.today());
        TransactionsLastYearAvg.Transactions = TransactionsLastYearTotal.Transactions / 13;
        TransactionsLastYearAvg.Revenue = TransactionsLastYearTotal.Revenue / 13;
        TransactionsLastYearAvg.Amount = TransactionsLastYearTotal.Amount / 13;

        TransactionsDaysList = new List<TransactionsLastYear>();
        for (integer i = -30; i <= 0; i++) {
            Date month = Date.today().addDays(i);
            if (TransactionsDaysMap.containskey(month))
                TransactionsDaysList.add(TransactionsDaysMap.get(month));
            else
                TransactionsDaysList.add(new TransactionsLastYear(month));
        }
        TransactionsDaysAvg = new TransactionsLastYear(Date.today());
        TransactionsDaysAvg.Transactions = TransactionsDaysTotal.Transactions / 30;
        TransactionsDaysAvg.Revenue = TransactionsDaysTotal.Revenue / 30;
        TransactionsDaysAvg.Amount = TransactionsDaysTotal.Amount / 30;

    }

    public List<Contract__c> Contracts { get; set; }

    public decimal TotalCreditLine { get; set; }
    public decimal TotalFuelFee { get; set; }
    public decimal TotalTransCheckFee { get; set; }
    public decimal TotalActiveControlCards { get; set; }

    public List<TransactionsByChain> TransactionsByChainList { get; set; }
    public TransactionsByChain TransactionsByChainTotal { get; set; }

    public List<TransactionsByChain> TransactionsByProductList { get; set; }
    public TransactionsByChain TransactionsByProductTotal { get; set; }

    public List<TransactionsLastYear> TransactionsLastYearList { get; set; }
    public TransactionsLastYear TransactionsLastYearTotal { get; set; }
    public TransactionsLastYear TransactionsLastYearAvg { get; set; }

    public List<TransactionsLastYear> TransactionsDaysList { get; set; }
    public TransactionsLastYear TransactionsDaysTotal { get; set; }
    public TransactionsLastYear TransactionsDaysAvg { get; set; }

    public class TransactionsByChain {
        public string Chain { get; set; }
        public decimal Transactions { get; set; }
        public decimal Gallons { get; set; }
        public decimal PercentOfTotalGallons { get; set; }
        public decimal Amount { get; set; }
        public decimal Discount { get; set; }
        public decimal TotalRevenue { get; set; }
        public decimal PercentOfTotalRevenue { get; set; }

        public TransactionsByChain(string chn) {
            Chain = chn;
            Transactions = 0;
            Gallons = 0;
            PercentOfTotalGallons = 0;
            Amount = 0;
            Discount = 0;
            TotalRevenue = 0;
            PercentOfTotalRevenue = 0;
        }
    }

    public class TransactionsLastYear {
        public date Month { get; set; }
        public decimal Transactions { get; set; }
        public decimal Amount { get; set; }
        public decimal Revenue { get; set; }

        public TransactionsLastYear(Date mn) {
            Month = mn;
            Transactions = 0;
            Amount = 0;
            Revenue = 0;
        }
    }

    public static testMethod void test1() {

        Account a = new Account();
        a.Name = 'Lucian664755';
        insert a;

        Contract__c c = new Contract__c();
        c.Account__c = a.Id;
        insert c;

        Transaction_Summary__c tr = new Transaction_Summary__c();
        tr.Last_Processed_Date__c = date.today().addDays(-7);
        tr.Account__c = a.Id;
        insert tr;

        Transaction_Summary_Detail__c td = new Transaction_Summary_Detail__c();
        td.Transaction_Summary__c = tr.Id;
        insert td;

        AccountSummaryReport asr = new AccountSummaryReport(new ApexPages.StandardController(a));

    }

}