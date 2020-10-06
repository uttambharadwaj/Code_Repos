public class ServiceAccountsBatch implements Schedulable, Database.Batchable<SObject>, Database.Stateful {
    List<String> acctNames;
    List<ServiceAccountsBatchLog__c> errLogs;

    public void execute(SchedulableContext sc) {
        Database.executeBatch(this);
    }

    public ServiceAccountsBatch() {
        errLogs = new List<ServiceAccountsBatchLog__c>();
    }

    public ServiceAccountsBatch(List<String> acctNames) {
        this();
        this.acctNames = acctNames;
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        Datetime dt = Datetime.now().addHours(-24);
        Id accRectypeid = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Service_Operations').getRecordTypeId();
        String query = 'SELECT Id, Primary_Contact_TXT__c, Billing_Contact_TXT__c,' +
                       ' Admin_Contact_TXT__c, Mailing_Contact_TXT__c, Shipping_Contact_TXT__c, Siebel_Fleet_Contact_TXT__c' +
                       ' FROM Account WHERE RecordTypeId = :accRectypeid' +
                       ' AND (SO_Role_Batch_Last_Run__c = null OR (LastModifiedDate > :dt AND SO_Role_Batch_Last_Run__c < :dt))';

        if (acctNames!=null && !acctNames.isEmpty()) {
            query += ' AND Name IN :acctNames';
        }

        query += ' ORDER BY Name ASC';
        System.debug('query - ' + query);

        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext context, List<Account> scope) {
        try {
            Set<String> ctRowIds = new Set<String>();
            Set<Id> accIds = new Set<Id>();
            for (Account acc : scope) {
                if (acc.Primary_Contact_TXT__c!=null) {
                    ctRowIds.add(acc.Primary_Contact_TXT__c);
                }
                if (acc.Billing_Contact_TXT__c!=null) {
                    ctRowIds.add(acc.Billing_Contact_TXT__c);
                }
                if (acc.Admin_Contact_TXT__c!=null) {
                    ctRowIds.add(acc.Admin_Contact_TXT__c);
                }
                if (acc.Mailing_Contact_TXT__c!=null) {
                    ctRowIds.add(acc.Mailing_Contact_TXT__c);
                }
                if (acc.Shipping_Contact_TXT__c!=null) {
                    ctRowIds.add(acc.Shipping_Contact_TXT__c);
                }
                if (acc.Siebel_Fleet_Contact_TXT__c!=null) {
                    ctRowIds.add(acc.Siebel_Fleet_Contact_TXT__c);
                }

                accIds.add(acc.Id);
                acc.SO_Role_Batch_Last_Run__c = Datetime.now();
            }

            Map<String, Id> rowIdCtMap = new Map<String, Id>();
            if (!ctRowIds.isEmpty()) {
                for (IntegrationRecord__c ir : [SELECT Contact_Row_Id__c, Contact__c, Contact__r.AccountId FROM IntegrationRecord__c WHERE Contact_Row_Id__c IN : ctRowIds]) {
                    if (ir.Contact__c!=null && ir.Contact__r.AccountId!=null) {
                        rowIdCtMap.put(ir.Contact_Row_Id__c, ir.Contact__c);
                    }
                }
            }

            List<AccountContactRelation> directRelnList = new List<AccountContactRelation>();
            Map<Id, Id> directRelnCtAccMap = new Map<Id, Id>();
            Map<Id, Id> directRelnCtACRMap = new Map<Id, Id>();
            List<AccountContactRelation> indirectRelnList = new List<AccountContactRelation>();
            Map<Id, Set<Id>> acctSharedContactsMap = new Map<Id, Set<Id>>();

            for (Account acc : [SELECT Id,  (SELECT Id, ContactId, IsDirect, Roles FROM AccountContactRelations) FROM Account WHERE Id IN : accIds]) {
                for (AccountContactRelation acr : acc.AccountContactRelations) {
                    if (acr.IsDirect==true) {
                        acr.Roles = null;
                        directRelnList.add(acr);
                        directRelnCtAccMap.put(acr.ContactId, acc.Id);
                        directRelnCtACRMap.put(acr.ContactId, acr.Id);
                    } else {
                        indirectRelnList.add(acr);
                    }

                    if (!String.isEmpty(acr.Roles) && acr.Roles.contains('Shared Contact')) {
                        if (acctSharedContactsMap.get(acc.Id) != null) {
                            Set<Id> st = acctSharedContactsMap.get(acc.Id);
                            st.add(acr.ContactId);
                            acctSharedContactsMap.put(acc.Id, st);
                        } else {
                            Set<Id> st = new Set<Id>();
                            st.add(acr.ContactId);
                            acctSharedContactsMap.put(acc.Id, st);
                        }
                    }
                }
            }

            update directRelnList;
            delete indirectRelnList;

            List<AccountContactRelation> acrList = new List<AccountContactRelation>();
            for (Account acc : scope) {
                Map<Id, Set<String>> ctRoleMap = new Map<Id, Set<String>>();

                if (acc.Primary_Contact_TXT__c!=null) {
                    ctRoleMap = addContactRoles(rowIdCtMap, ctRoleMap, acc.Primary_Contact_TXT__c, 'Primary Contact');
                }
                if (acc.Billing_Contact_TXT__c!=null) {
                    ctRoleMap = addContactRoles(rowIdCtMap, ctRoleMap, acc.Billing_Contact_TXT__c, 'Billing Contact');
                }
                if (acc.Admin_Contact_TXT__c!=null) {
                    ctRoleMap = addContactRoles(rowIdCtMap, ctRoleMap, acc.Admin_Contact_TXT__c, 'Admin Contact');
                }
                if (acc.Mailing_Contact_TXT__c!=null) {
                    ctRoleMap = addContactRoles(rowIdCtMap, ctRoleMap, acc.Mailing_Contact_TXT__c, 'Mailing Contact');
                }
                if (acc.Shipping_Contact_TXT__c!=null) {
                    ctRoleMap = addContactRoles(rowIdCtMap, ctRoleMap, acc.Shipping_Contact_TXT__c, 'Shipping Contact');
                }
                if (acc.Siebel_Fleet_Contact_TXT__c!=null) {
                    ctRoleMap = addContactRoles(rowIdCtMap, ctRoleMap, acc.Siebel_Fleet_Contact_TXT__c, 'Fleet Contact');
                }

                Set<Id> sharedContactIds = acctSharedContactsMap.get(acc.Id);

                for (Id ctId : ctRoleMap.keySet()) {
                    AccountContactRelation acr;
                    if (directRelnCtAccMap.get(ctId) == acc.Id) {
                        acr = new AccountContactRelation(Id = directRelnCtACRMap.get(ctId));
                    } else {
                        acr = new AccountContactRelation();
                        acr.AccountId = acc.Id;
                        acr.ContactId = ctId;
                    }
                    acr.IsActive = true;
                    Set<String> roles = ctRoleMap.get(ctId);
                    if (sharedContactIds!=null && sharedContactIds.contains(ctId)) {
                        roles.add('Shared Contact');
                        sharedContactIds.remove(ctId);
                    }
                    acr.Roles = String.join(new List<String>(roles), ';');
                    acrList.add(acr);
                }

                if (sharedContactIds!=null) {
                    for (Id ctId : sharedContactIds) {
                        AccountContactRelation acr = new AccountContactRelation();
                        acr.AccountId = acc.Id;
                        acr.ContactId = ctId;
                        acr.IsActive = true;
                        acr.Roles = 'Shared Contact';
                        acrList.add(acr);
                    }
                }
            }

            upsert acrList;
            System.enqueueJob(new ServiceAccountsBatchHelper(scope));
        } catch (Exception e) {
            System.debug('Error occurred - ' + e.getMessage());
            errLogs.add(new ServiceAccountsBatchLog__c(Error__c = e.getMessage() + '---' + e.getStackTraceString()));
            throw e;
        }

        insert errLogs;
        errLogs.clear();
    }

    private Map<Id, Set<String>> addContactRoles(Map<String, Id> rowIdCtMap, Map<Id, Set<String>> ctRoleMap, String rowId, String role) {
        if (rowIdCtMap.get(rowId)!=null) {
            Id ctId = rowIdCtMap.get(rowId);
            Set<String> roles;
            if (ctRoleMap.get(ctId) != null) {
                roles = ctRoleMap.get(ctId);
            } else {
                roles = new Set<String>();
            }
            roles.add(role);
            ctRoleMap.put(ctId, roles);
        } else {
            //report error
        }
        return ctRoleMap;
    }

    public void finish(Database.BatchableContext context) {
        insert errLogs;
    }

    public class ServiceAccountsBatchHelper implements Queueable {
        List<Account> accList;

        public ServiceAccountsBatchHelper(List<Account> accList) {
            this.accList = accList;
        }

        public void execute(QueueableContext qc) {
            try {
                update accList;
            } catch (Exception e) {
                System.debug('Error occurred - ' + e.getMessage());
                insert new ServiceAccountsBatchLog__c(Error__c = e.getMessage() + '---' + e.getStackTraceString());
            }
        }
    }
}