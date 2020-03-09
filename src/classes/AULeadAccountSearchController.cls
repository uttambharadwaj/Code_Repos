public with sharing class AULeadAccountSearchController {

    public List<Account> accounts { get; set; }
    public AULeadAccountSearchController(ApexPages.StandardController page) {

        List<String> fields = new List<String>{
                'Id', 'Company'
        };
        page.addFields(fields);
        Lead lead = (Lead) page.getRecord();

        if (Lead.Company != null) {
            String leadCompany = '%' + Lead.Company.replace(' ', '%') + '%';
            leadCompany = leadCompany.replace(' ', '%');
            this.accounts = [
                    SELECT Id, Name, ShippingCity, ShippingState, RecordType.Name
                    FROM Account
                    WHERE Name LIKE :leadCompany AND RecordType.Name LIKE 'AU %'
                    LIMIT 1000
            ];
        }
    }
}