public class MergeServiceContactsBatchHighVolume implements Schedulable, Database.Batchable<SObject>, Database.Stateful {
    Id rectypeid;
    String[] phoneFields;
    String[] emailFields;
    Set<String> excludedPhoneEmails;
    List<String> topCtNames;
    List<MergeServiceContactsLog__c> errLogs;
    Set<Id> winningContactIds;
    Integer batchSize;
    String startingWithChars;
    Boolean carryOver;
    String sortBy;

    public void execute(SchedulableContext sc) {
        Database.executeBatch(this);
    }

    public MergeServiceContactsBatchHighVolume() {
        this.carryOver = true;
        this.batchSize = 200;
        rectypeid = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Service_Operations' LIMIT 1].Id;
        phoneFields = new String[] {'Phone', 'Phone2__c', 'Phone3__c', 'Phone4__c', 'Phone5__c', 'HomePhone', 'MobilePhone', 'OtherPhone'};
        emailFields = new String[] {'Email', 'Email_Address_2__c', 'Email_Address_3__c', 'Email_Address_4__c', 'Email_Address_5__c'};

        excludedPhoneEmails = new Set<String>();
        for (Bad_Contact_Merge_Values__mdt cmdt : [SELECT MasterLabel FROM Bad_Contact_Merge_Values__mdt]) {
            excludedPhoneEmails.add(cmdt.MasterLabel.toUpperCase());
        }

        winningContactIds = new Set<Id>();
        errLogs = new List<MergeServiceContactsLog__c>();
    }

    public MergeServiceContactsBatchHighVolume(String startingWithChars, Boolean carryOver, Integer batchSize) {
        this();
        this.startingWithChars = startingWithChars;
        this.carryOver = carryOver;
        this.batchSize = batchSize;
    }

    public MergeServiceContactsBatchHighVolume(List<String> topCtNames, Boolean carryOver, Integer batchSize) {
        this();
        this.topCtNames = topCtNames;
        this.carryOver = carryOver;
        this.batchSize = batchSize;
    }

    public MergeServiceContactsBatchHighVolume(List<String> topCtNames, Boolean carryOver, String sortBy, Integer batchSize) {
        this(topCtNames, carryOver, batchSize);
        this.sortBy = sortBy;
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        if (topCtNames==null) {
            String topCtQuery = 'SELECT Name, COUNT(Id) FROM Contact WHERE RecordTypeId = :rectypeid';

            if (String.isNotEmpty(startingWithChars)) {
                List<String> startingWith = new List<String>();
                Integer start = 0;
                if (startingWithChars.startsWith('^')) {
                    topCtQuery += ' AND (NOT Name LIKE :startingWith)';
                    start = 1;
                } else {
                    topCtQuery += ' AND Name LIKE :startingWith';
                }

                for (Integer i=start; i<startingWithChars.length(); i++) {
                    startingWith.add(startingWithChars.substring(i, i+1) + '%');
                }
            }

            topCtQuery += ' GROUP BY Name ORDER BY COUNT(Id) DESC LIMIT 200';

            topCtNames = new List<String>();
            for (AggregateResult ar : Database.query(topCtQuery)) {
                if (Integer.valueOf(ar.get('expr0')) > 200) {
                    topCtNames.add(String.valueOf(ar.get('Name')));
                }
            }
        }

        if (!topCtNames.isEmpty()) {
            String ctName = topCtNames[0];
            String query = 'SELECT Id, Name FROM Contact WHERE RecordTypeId = :rectypeid AND AccountId != null AND Name = :ctName'; 
            if (sortBy=='Email') {
                query += ' ORDER BY Email ASC, Phone ASC';
            } else {
                query += ' ORDER BY Phone ASC, Email ASC';
            }
            return Database.getQueryLocator(query);
        } else {
            return null;
        }
    }

    public void execute(Database.BatchableContext context, List<Contact> scope) {
        Set<Id> ctIds = new Set<Id>();
        for (Contact ct : scope) {
            ctIds.add(ct.Id);
        }

        if (carryOver==true) {
            ctIds.addAll(winningContactIds);//add id's from previous execution
        }

        Map<Id, Contact> contacts = new Map<Id, Contact>(
            [SELECT Id, Name, Phone, HomePhone, MobilePhone, OtherPhone, Phone2__c, Phone3__c, Phone4__c, Phone5__c,
             Email, Email_Address_2__c, Email_Address_3__c, Email_Address_4__c, Email_Address_5__c, SourceLastModifiedDate__c,
             (SELECT Id, Account__c, Contact_Type__c, Phone__c, Mobile_Phone__c, Email__c FROM Integration_Record__r)
             FROM Contact WHERE RecordTypeId = :rectypeid AND Id IN : ctIds ORDER BY SourceLastModifiedDate__c ASC]);

        Map<String, Set<Id>> ctMap = new Map<String, Set<Id>>();

        String[] phoneEmailFields = new List<String>(phoneFields);
        phoneEmailFields.addAll(emailFields);

        //build a map with name and phone/email keys
        for (Contact ct : contacts.values()) {
            ctMap = addPhoneEmailsToMap(ctMap, ct, phoneEmailFields);
        }

        //merge sets if the same id exists in two places
        for (String key1 : ctMap.keySet()) {
            for (String key2 : ctMap.keySet()) {
                if (key1 != key2) {
                    Set<Id> st1 = ctMap.get(key1);
                    Set<Id> st2 = ctMap.get(key2);
                    Set<Id> st3 = new Set<Id>(st1);
                    st3.addAll(st2);
                    if (st3.size() < st1.size() + st2.size()) {
                        ctMap.put(key1, st3);
                        ctMap.put(key2, new Set<Id>());
                    }
                }
            }
        }

        Map<String, Contact> winningCtMap = new Map<String, Contact>();

        for (String key : ctMap.keySet()) {
            if (ctMap.get(key).size() > 1) {
                for (Id ctId : ctMap.get(key)) {
                    Contact ct = contacts.get(ctId);
                    if (winningCtMap.get(key) != null) {
                        if (winningCtMap.get(key).SourceLastModifiedDate__c < ct.SourceLastModifiedDate__c) {
                            winningCtMap.put(key, ct);
                        }
                    } else {
                        winningCtMap.put(key, ct);
                    }
                }
            } else { //size 1 - add for subsequent batches
                if (carryOver==true) {
                    winningContactIds.addAll(ctMap.get(key));
                }
            }
        }

        Map<Id, Set<Id>> winningAccountMap = new Map<Id, Set<Id>>();
        if (!winningCtMap.isEmpty()) {
            for (AccountContactRelation acr : [SELECT ContactId, AccountId FROM AccountContactRelation WHERE ContactId IN : winningCtMap.values()]) {
                if (winningAccountMap.get(acr.ContactId) != null) {
                    Set<Id> st = winningAccountMap.get(acr.ContactId);
                    st.add(acr.AccountId);
                    winningAccountMap.put(acr.ContactId, st);
                } else {
                    Set<Id> st = new Set<Id>();
                    st.add(acr.AccountId);
                    winningAccountMap.put(acr.ContactId, st);
                }
            }
        }

        Map<Id, Contact> losingCtMap = new Map<Id, Contact>();
        Map<Id, Set<Id>> relatedCtMap = new Map<Id, Set<Id>>();
        List<AccountContactRelation> acrList = new List<AccountContactRelation>();

        for (String key : ctMap.keySet()) {
            if (winningCtMap.get(key) != null) {
                Contact winningContact = winningCtMap.get(key);
                Set<Id> losingContactIds = new Set<Id>();
                Set<Id> losingAccountIds = new Set<Id>();
                winningContactIds.add(winningContact.Id);

                Set<String> phones = new Set<String>();
                Set<String> mobilePhones = new Set<String>();
                Set<String> emails = new Set<String>();
                Set<String> existingPhones = getPhones(winningContact);
                Set<String> existingEmails = getEmails(winningContact);

                for (Id ctId : ctMap.get(key)) {
                    Contact ct = contacts.get(ctId);
                    if (ctId != winningContact.Id) {
                        if (winningContactIds.contains(ctId)) {
                            winningContactIds.remove(ctId);
                        }
                        losingCtMap.put(ctId, ct);
                        losingContactIds.add(ctId);
                        DeletedRecordsStageClass.deletedRecordsReasons.put(ctId, 'Duplicate Service Operations Contact');

                        Set<String> losingCtPhones = getPhones(ct);
                        Set<String> losingCtEmails = getEmails(ct);
                        for (String phone : losingCtPhones) {
                            if (!existingPhones.contains(phone)) {
                                phones.add(phone);
                            }
                        }
                        for (String email : losingCtEmails) {
                            if (!existingEmails.contains(email.toLowerCase())) {
                                emails.add(email);
                            }
                        }
                    }

                    for (IntegrationRecord__c ir : ct.Integration_Record__r)  {
                        if (ctId != winningContact.Id && ir.Account__c != null) {
                            losingAccountIds.add(ir.Account__c);
                        }
                        if (ir.Phone__c != null && !existingPhones.contains(ir.Phone__c)) {
                            phones.add(ir.Phone__c);
                        }
                        if (ir.Mobile_Phone__c != null && !existingPhones.contains(ir.Mobile_Phone__c)) {
                            mobilePhones.add(ir.Mobile_Phone__c);
                        }
                        if (ir.Email__c != null && !existingEmails.contains(ir.Email__c.toLowerCase())) {
                            emails.add(ir.Email__c);
                        }
                    }
                }

                Set<Id> winningAccountIds = winningAccountMap.get(winningContact.Id);
                for (Id acctId : losingAccountIds) {
                    if (winningAccountIds!=null && !winningAccountIds.contains(acctId)) {
                        AccountContactRelation acr = new AccountContactRelation();
                        acr.AccountId = acctId;
                        acr.ContactId = winningContact.Id;
                        acr.IsActive = true;
                        acr.Roles = 'Shared Contact';
                        acrList.add(acr);
                    }
                }

                winningContact = copyPhones(phones, winningContact);
                winningContact = copyPhones(mobilePhones, winningContact);
                winningContact = copyEmails(emails, winningContact);

                if (!losingContactIds.isEmpty()) {
                    relatedCtMap.put(winningContact.Id, losingContactIds);
                }
            }
        }

        try {
            if (!winningCtMap.isEmpty()) {
                update winningCtMap.values();
            }

            if (!acrList.isEmpty()) {
                insert acrList;
            }

            if (!relatedCtMap.isEmpty()) {
                Usobject.mergeContactRelatedItems(relatedCtMap);
            }

            if (!losingCtMap.isEmpty()) {
                delete losingCtMap.values();
            }
        } catch (Exception e) {
            System.debug('Error occurred - ' + e.getMessage());
            errLogs.add(new MergeServiceContactsLog__c(Error__c = e.getMessage() + '---' + e.getStackTraceString()));
            throw e;
        }

        insert errLogs;
        errLogs.clear();
    }

    private Map<String, Set<Id>> addPhoneEmailsToMap(Map<String, Set<Id>> ctMap, Contact ct, String[] fields) {
        for (String s : fields) {
            if (ct.get(s) != null) {
                String val = ((String) ct.get(s)).toUpperCase();
                if (!excludedPhoneEmails.contains(val)) {
                    String key = ct.Name.toUpperCase() + '$' + val;
                    if (ctMap.get(key) != null) {
                        Set<Id> st = ctMap.get(key);
                        st.add(ct.Id);
                        ctMap.put(key, st);
                    } else {
                        Set<Id> st = new Set<Id>();
                        st.add(ct.Id);
                        ctMap.put(key, st);
                    }
                }
            }
        }
        return ctMap;
    }

    private Set<String> getPhones(Contact ct) {
        Set<String> existingPhones = new Set<String>();
        for (String s : phoneFields) {
            if (ct.get(s) != null) {
                existingPhones.add((String) ct.get(s));
            }
        }
        return existingPhones;
    }

    private Set<String> getEmails(Contact ct) {
        Set<String> existingEmails = new Set<String>();
        for (String s : emailFields) {
            if (ct.get(s) != null) {
                existingEmails.add((String) ct.get(s));
            }
        }
        return existingEmails;
    }

    private Contact copyPhones (Set<String> phones, Contact ct) {
        for (String ph : phones) {
            for (String s : phoneFields) {
                if (ct.get(s) == null) {
                    ct.put(s, ph);
                    break;
                }
            }
        }
        return ct;
    }

    private Contact copyEmails (Set<String> emails, Contact ct) {
        for (String em : emails) {
            for (String s : emailFields) {
                if (ct.get(s) == null) {
                    ct.put(s, em);
                    break;
                }
            }
        }
        return ct;
    }

    public void finish(Database.BatchableContext context) {
        insert errLogs;

        if (!Test.isRunningTest()) {
            topCtNames.remove(0);
            if (!topCtNames.isEmpty()) {
                Database.executeBatch(new MergeServiceContactsBatchHighVolume(topCtNames, carryOver, batchSize), batchSize);
            }
        }
    }
}