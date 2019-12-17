public class MergeServiceContactsBatch implements Schedulable, Database.Batchable<SObject>, Database.Stateful {
    Id rectypeid;
    String[] phoneFields;
    String[] emailFields;
    Set<String> excludedPhoneEmails;
    String startingWithChars;
    List<String> contactNames;
    Integer processDays;
    List<MergeServiceContactsLog__c> errLogs;

    public void execute(SchedulableContext sc) {
        Database.executeBatch(this);
    }

    public MergeServiceContactsBatch() {
        rectypeid = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Service_Operations' LIMIT 1].Id;
        phoneFields = new String[] {'Phone', 'Phone2__c', 'Phone3__c', 'Phone4__c', 'Phone5__c', 'HomePhone', 'MobilePhone', 'OtherPhone'};
        emailFields = new String[] {'Email', 'Email_Address_2__c', 'Email_Address_3__c', 'Email_Address_4__c', 'Email_Address_5__c'};

        excludedPhoneEmails = new Set<String>();
        for (Bad_Contact_Merge_Values__mdt cmdt : [SELECT MasterLabel FROM Bad_Contact_Merge_Values__mdt]) {
            excludedPhoneEmails.add(cmdt.MasterLabel.toUpperCase());
        }

        errLogs = new List<MergeServiceContactsLog__c>();
    }

    public MergeServiceContactsBatch(String startingWithChars) {
        this();
        this.startingWithChars = startingWithChars;
    }

    public MergeServiceContactsBatch(List<String> contactNames) {
        this();
        this.contactNames = contactNames;
    }

    public MergeServiceContactsBatch(Integer processDays) {
        this();
        this.processDays = processDays;
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        String query = 'SELECT Id, Name FROM Contact WHERE RecordTypeId = :rectypeid';

        Set<String> topCtNames = new Set<String>();

        for (AggregateResult ar : [SELECT Name, COUNT(Id) FROM Contact WHERE RecordTypeId = :rectypeid GROUP BY Name ORDER BY COUNT(Id) DESC LIMIT 200]) {
            if (Integer.valueOf(ar.get('expr0')) > 200) {
                topCtNames.add(String.valueOf(ar.get('Name')));
            }
        }
        if (!topCtNames.isEmpty()) {
            query += ' AND Name NOT IN : topCtNames';
        }

        if (String.isNotEmpty(startingWithChars)) {
            List<String> startingWith = new List<String>();
            Integer start = 0;
            if (startingWithChars.startsWith('^')) {
                query += ' AND (NOT Name LIKE :startingWith)';
                start = 1;
            } else {
                query += ' AND Name LIKE :startingWith';
            }

            for (Integer i=start; i<startingWithChars.length(); i++) {
                startingWith.add(startingWithChars.substring(i, i+1) + '%');
            }
        }

        if (contactNames!=null && !contactNames.isEmpty()) {
            query += ' AND Name IN :contactNames';
        }

        if (processDays!=null) {
            Datetime dt = Datetime.now().addDays(-processDays);
            query += ' AND LastModifiedDate > :dt';
        }

        query += ' ORDER BY Name ASC';
        System.debug('query - ' + query);

        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext context, List<Contact> scope) {
        Set<String> ctNames = new Set<String>();
        for (Contact ct : scope) {
            ctNames.add(ct.Name.toUpperCase());
        }

        Map<Id, Contact> contacts = new Map<Id, Contact>(
            [SELECT Id, Name, Phone, HomePhone, MobilePhone, OtherPhone, Phone2__c, Phone3__c, Phone4__c, Phone5__c,
             Email, Email_Address_2__c, Email_Address_3__c, Email_Address_4__c, Email_Address_5__c, SourceLastModifiedDate__c,
             (SELECT Id, Account__c, Contact_Type__c, Phone__c, Mobile_Phone__c, Email__c FROM Integration_Record__r)
             FROM Contact WHERE RecordTypeId = :rectypeid AND AccountId != null AND Name IN : ctNames]);

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
            Map<String, Integer> intSizeMap = new Map<String, Integer>();
            if (ctMap.get(key).size() > 1) {//duplicates exist
                for (Id ctId : ctMap.get(key)) {
                    Contact ct = contacts.get(ctId);
                    Integer size = 0;
                    for (IntegrationRecord__c ir : ct.Integration_Record__r)  {
                        size++;
                    }
                    if (intSizeMap.get(key) != null) {
                        if (intSizeMap.get(key) < size) {
                            intSizeMap.put(key, size);
                            winningCtMap.put(key, ct);
                        } else if (intSizeMap.get(key) == size) {
                            if (winningCtMap.get(key).SourceLastModifiedDate__c < ct.SourceLastModifiedDate__c) {
                                winningCtMap.put(key, ct);
                            }
                        }
                    } else {
                        intSizeMap.put(key, size);
                        winningCtMap.put(key, ct);
                    }
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

                Set<String> phones = new Set<String>();
                Set<String> mobilePhones = new Set<String>();
                Set<String> emails = new Set<String>();
                Set<String> existingPhones = getPhones(winningContact);
                Set<String> existingEmails = getEmails(winningContact);

                for (Id ctId : ctMap.get(key)) {
                    Contact ct = contacts.get(ctId);
                    if (ctId != winningContact.Id) {
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
        Set<String> phones = new Set<String>();
        for (String s : phoneFields) {
            if (ct.get(s) != null) {
                phones.add((String) ct.get(s));
            }
        }
        return phones;
    }

    private Set<String> getEmails(Contact ct) {
        Set<String> emails = new Set<String>();
        for (String s : emailFields) {
            if (ct.get(s) != null) {
                emails.add((String) ct.get(s));
            }
        }
        return emails;
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
    }
}