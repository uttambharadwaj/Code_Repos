public with sharing class AULeadAccountSearchController {

    public List<Account> accounts { get; set; }
    public AULeadAccountSearchController(ApexPages.StandardController page) {

        List<String> fields = new List<String>{
                'Id', 'Name'
        };
        page.addFields(fields);
        Lead lead = (Lead) page.getRecord();

        if (Lead.Name != null) {
            String leadName = '%' + Lead.Name.replace(' ', '%') + '%';
            leadName = leadName.replace(' ', '%');
            this.accounts = [
                    SELECT Id, Name, ShippingCity, ShippingState, RecordType.Name
                    FROM Account
                    WHERE Name LIKE :leadName AND RecordType.Name LIKE 'AU %'
                    LIMIT 1000
            ];
        }
    }
}