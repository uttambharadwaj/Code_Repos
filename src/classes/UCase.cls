/*  Created byL GearsCRM
 *   Date: 12/10/2014
 *   Summary: Case trigger utility.
 *   Modified by   : Raja Y(Gears)
 *   Modified Date : 01/12/2015
 *   Description   : Set SLA Date with Business Hours (updateBusinessHours method)
*/
public class UCase
{
    private static final Map<String, String> contactTypePriorities = new Map<String, String>{
            'COLLECTIONS' => 'A',
            'PRIMARY' => 'B',
            'BILLING' => 'C',
            'SHIPPING' => 'D',
            'ACCOUNTS PAYABLE' => 'E',
            'CONTACT' => 'F',

            'NONE' => 'Z'
    };
    private static final String SHELL_SLA = 'Shell SLA';
    //private static final String SHELL_SLA_WEEKEND = 'Shell SLA Weekend';
    private static Boolean hasRunOnceUpdate = false;
    private static List<String> wexEmailAddressDomains = new List<String>{'wexinc.com','wrightexpress.com','wexaustralia.com','wexeurope.com'};
    private static Id genericEmailAddressId;

    public static void associateWithEntitlement(List<Case> newRecords){
        // First, filter out the Cases that do not have "shell" as the Supplied Email's domain.
        if((Trigger.isUpdate && hasRunOnceUpdate) || System.isFuture() || (System.isBatch() && Trigger.isUpdate)){
            return;
        }else{
            hasRunOnceUpdate = true;
        }

        List<Id> idsToProcess = new List<Id>();
        for(Case auxCase : newRecords){
            if (auxCase.Program_Email__c != null && auxCase.Program_Email__c.equalsIgnoreCase('Shellfleethelp@wexinc.com')) {
                idsToProcess.add(auxCase.ID);
            }
        }

        if (idsToProcess.size() > 0) {
            processRecords(idsToProcess);
        }

    }

    @future
    public static void processRecords(List<ID> recordIds){
        List<Case> newRecords = [SELECT ID, Program_Email__c, CreatedDate FROM Case WHERE ID in :recordIds];

        List<Entitlement> auxEntitlementsList = [SELECT Name, Id
        FROM Entitlement];
        System.debug(LoggingLevel.INFO, '#debug: auxEntitlementsList: ' + auxEntitlementsList);
        ID weekEntitlementID;

        for(Entitlement auxEntitlement : auxEntitlementsList){
            if(auxEntitlement.Name == SHELL_SLA){
                weekEntitlementID = auxEntitlement.ID;
            }

        }

        List<Case> casesToUpdate = new List<Case>();
        for(Case auxCase : newRecords){
            Case auxCaseNew = new Case();
            auxCaseNew.ID = auxCase.ID;
            if(auxCase.Program_Email__c != null){

                if((auxCase.Program_Email__c).equalsIgnoreCase('Shellfleethelp@wexinc.com')){

                    Datetime thisDT = auxCase.CreatedDate;
                    String myDate = thisDT.format('yyyy-MM-dd HH:mm:ss', 'EST');
                    Datetime convertedDate = Datetime.valueOf(myDate);

                    auxCaseNew.EntitlementId = weekEntitlementID;

                    casesToUpdate.add(auxCaseNew);
                }
            }
        }
        update casesToUpdate;
    }


    public static void setNotificationFromBatch(List<Case> records)
    {
        List<Case> casesToUpdate = new List<Case> ();

        for (Case c : records)
        {
            c.Notification_Sent__c = TRUE;
            casesToUpdate.add(c);
        }

        if (casestoUpdate.size() == 0)
        {
            return;
        }

        update casesToUpdate;
    }


    public static void EmailToCaseOwernshipAssignment(List<Case> records, Map<Id, Case> oldmap) {
//        system.debug('-----');
//        system.debug('-----EmailToCaseOwernshipAssignment');
//        system.debug('-----');
//
//
//        boolean isinsert = (oldmap == null);
//        GlobalSettings__c gs = GlobalSettings__c.getorgdefaults();
//
//
//        Set<Id> accountIds = new Set<Id> ();
//        for (Case scope : records) {
//            system.debug('**gs: ' + gs + ' ' + gs.Virtual_Card_Queue_ID__c);
//            system.debug('**scope.ownerid: ' + scope.OwnerId);
//            system.debug('**scope.No_Account_Manager__c: ' + scope.No_Account_Manager__c);
//            if (scope.OwnerId == gs.Virtual_Card_Queue_ID__c && scope.No_Account_Manager__c == false) {
//                accountIds.add(scope.AccountId);
//            }
//        }
//        System.debug('** accountids: ' + accountIds);
//
//        if (accountIds.isEmpty()) return;
//
//        Map<Id, Id> teamMemberByAccountId = new Map<Id, Id> ();
//
//        //pull by member role, sort by last created to use most recent, req change.
//        //changed back to account manager, keep sort.
//        for (AccountTeamMember atm :[Select Id, UserId, AccountId from AccountTeamMember Where AccountId IN :accountIds AND TeamMemberRole = 'Account Manager' Order by CreatedDate ASC]) {
//            teamMemberByAccountId.put(atm.accountId, atm.userid);
//        }
//
//        System.debug('**atm: ' + teamMemberByAccountId);
//
//        List<Case> toupdate = new List<case> ();
//        Map<Id, Id> caseToOwnerMap = new Map<Id, Id> ();
//        for (Case c : records) {
//            if (c.OwnerId == gs.Virtual_Card_Queue_ID__c && c.No_Account_Manager__c == false) {
//                if (teamMemberByAccountId.containsKey(c.AccountId)) {
//                    caseToOwnerMap.put(c.Id, teamMemberByAccountId.get(c.AccountId));
//                } else {
//                    // case 20659
//                    Case updateC = new Case(id = c.Id);
//                    updateC.No_Account_Manager__c = true;
//
//                    toupdate.add(updateC);
//                }
//            }
//        }
//
//        System.debug('** toupdate: ' + toupdate);
//
//        if (!toupdate.isEmpty()) {
//            update(toupdate);
//        }
//
//        if (!caseToOwnerMap.isEmpty()) {
//            System.debug('** caseToOwnerMap: ' + caseToOwnerMap);
//            sendOwnerUpdateEmail(caseToOwnerMap);
//        }
    }

    public static void sendCaseCloseSurveyEmail(List<Case> records, Map<Id, Case> oldMap) {
        //Enable switch
        EmailMessageSettings__c EMS = EmailMessageSettings__c.getOrgDefaults();

        if(EMS.ActivateSendSurveyEmailonCaseClose__c == false) {
            return;
        }

        Id recordTypeId = UtilityClass.getRecTypeByDevName('Case','Service_Operations');
        Id templateId = null;

        for(EmailTemplate et : [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'CS_Survey_Request']) {
            templateId = et.Id;
        }

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage> ();
        Map<String,Id> orgWideEmailAddresses = new Map<String,Id>();

        for (OrgWideEmailAddress owea : [SELECT Id, Address FROM OrgWideEmailAddress]) {
            orgWideEmailAddresses.put(owea.Address, owea.Id);
        }

        if (genericEmailAddressId == null) {
            if (orgWideEmailAddresses.get('surveys@fleetservicesonline.com') != null) {    //This will always hit
                genericEmailAddressId = orgWideEmailAddresses.get('surveys@fleetservicesonline.com');
            }
        }


        for (Case c : records) {
            if(c.ContactId != null && String.isNotBlank(c.ContactEmail)) {

                if(c.IsClosed && c.IsClosed != oldMap.get(c.Id).IsClosed     //Case newly closed
                        && c.RecordTypeId == recordTypeId                    //Service Operations record type
                        && String.isNotBlank(c.SurveyInclusionHTML__c)       //This field is blank for programs we don't send surveys to
                        && !(c.Service_Program_Survey_Sent__c)               //Don't send more than once on a single case even if it reopens
                        && checkForWexEmailAddress(c.ContactEmail)           // Don't send to contacts with a Wex email address
                        // 26Jul2020 MFarrell - changed from || to && inside below !() block as OR statements would return true for anything that isn't corp payments on the first line and the rest are ignored.
                        && (!c.Department__c.toLowerCase().startsWith('corporate payments') //Don't send to Corporate Payments cases
                            && !c.Department__c.toLowerCase().startsWith('receivables') //Don't send to Receivables cases
                            && !c.Department__c.toLowerCase().startsWith('otr ')//Don't send to OTR / EFS cases - EAPT-1211 , EAPT-680 (Dept list)
                            && !c.Department__c.toLowerCase().startsWith('project resource')//OTR - EAPT-1211 , EAPT-680 (Dept list)
                            && !c.Department__c.toLowerCase().startsWith('quality assurance')//OTR  - EAPT-1211 , EAPT-680 (Dept list)
                            && !c.Department__c.toLowerCase().startsWith('training')//OTR - EAPT-1211 , EAPT-680 (Dept list)
                        )
                ) //End IF parameters
                {
                    Id programEmailId;
                    if (c.Program_Email__c != null && c.Program_Email__c != '' && orgWideEmailAddresses.containsKey(c.Program_Email__c)) {
                        programEmailId = orgWideEmailAddresses.get(c.Program_Email__c);
                    } else if (programEmailId == null ) { //use generic
                        programEmailId = genericEmailAddressId;
                    }

                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    if (programEmailId != null) {
                        email.setOrgWideEmailAddressId(programEmailId);
                    }

                    email.setTargetObjectId(c.ContactId);
                    email.setTreatTargetObjectAsRecipient(true);
                    email.setUseSignature(false);
                    email.setSaveAsActivity(true);

                    // Case's surveySent flag will be set by outbound email trigger
                    email.setWhatId(c.Id);

                    Messaging.SingleEmailMessage renderBody = Messaging.renderStoredEmailTemplate(templateId, c.OwnerId, c.Id);
                    email.setSubject(renderBody.getSubject());
                    email.setHtmlBody(renderBody.getHtmlBody());
                    email.setPlainTextBody(renderBody.getPlainTextBody());
                    emails.add(email);
                }
            }
        }

        //26Jul2020 MFarrell moved email try/catch inside if statement as an empty list of emails still reserves email capacity and we were hitting limits.
        if (!emails.isEmpty()) {
            try {
                Messaging.reserveSingleEmailCapacity(emails.size());
                List<Messaging.SendEmailResult> results = Messaging.sendEmail(emails);

                for (Messaging.SendEmailResult res : results)
                {
                    for (Messaging.SendEmailError err : res.getErrors())
                    {
                        System.debug('UCase.sendCaseCloseSurveyEmail send mail error: ' + err.getMessage());
                    }
                }
            }
            catch (Exception e) {
                System.debug('Unable to send email');
            }
        }

    }

    /**
     * Checks provided email address against a list of Wex employee domains
     *
     * @param emailAddress
     *
     * @return True if the email address does NOT match a Wex email domain, False if it does
     */
    private static Boolean checkForWexEmailAddress(String emailAddress) {
        Boolean result = true;
        Integer domainsSize = wexEmailAddressDomains.size();
        Integer i = 0;
        while (result && i < domainsSize) {
            result = !(emailAddress.toLowerCase().endsWith(wexEmailAddressDomains.get(i)));
            i++;
        }
        return result;
    }


    @future
    public static void sendOwnerUpdateEmail(Map<Id, Id> caseToOwnerMap)
    {
        Database.DMLOptions dlo = new Database.DMLOptions();
        dlo.EmailHeader.triggerUserEmail = true;

        List<Case> toUpdate = new List<Case> ();

        for (Id id : caseToOwnerMap.keySet())
        {
            toUpdate.add(new Case(Id = id, OwnerId = caseToOwnerMap.get(id)));
        }

        Database.update(toUpdate, dlo);
    }

    public static void updateBusinessHours(List<Case> records, Map<Id, Case> oldmap) {
        GlobalSettings__c gs = GlobalSettings__c.getOrgDefaults();
        System.debug('___gs___ Virtual Card RecTypeID ' + gs.Virtual_Card_RecType_ID__c);

        List<Case> casesToProcess = new List<Case>();

        for (Case c : records) {
            if (c.RecordTypeId == gs.Virtual_Card_RecType_ID__c) {
                casesToProcess.add(c);
            }
        }

        if (!casesToProcess.isEmpty()) {
            List<BusinessHours> bhours = [SELECT Id FROM BusinessHours WHERE Name = 'Virtual Payments' LIMIT 1];

            if (bhours.size() == 0) return;

            BusinessHours bh = bhours[0];

            for (Case c : casesToProcess) {
                c.BusinessHoursId = bh.Id;
                Datetime CreateDate = System.now();
                Datetime updBusinessHours = BusinessHours.addGmt(bh.Id, CreateDate, 1000 * 60 * 60 * 8);
                c.SLA_Response_Due__c = updBusinessHours;
            }
        }

    }

    public static void accountDomainMatch(List<Case> records, Map<Id, Case> oldMap) {
//
//        if (WE_ApexUtility.apxCntrlrTargetManagerStatusAssessed == false) {
//            WE_ApexUtility.checkApexControllerStatus('Domain Match');
//        }
//        if (!WE_ApexUtility.domainMatchDisabled.contains(true)) {
//
//            Schema.DescribeSObjectResult caseSobject = Case.SObjectType.getDescribe();
//            Map<String, Schema.RecordTypeInfo> caseRtMapByName = caseSobject.getRecordTypeInfosByName();
//
//            Schema.DescribeSObjectResult contactSobject = Contact.SObjectType.getDescribe();
//            Map<String, Schema.RecordTypeInfo> contactRtMapByName = contactSobject.getRecordTypeInfosByName();
//            Id cpId = contactRtMapByName.get('Corporate_Pay').getRecordTypeId();
//
//            Schema.DescribeSObjectResult accountSobject = Account.SObjectType.getDescribe();
//            Map<String, Schema.RecordTypeInfo> accountRtMapByName = accountSobject.getRecordTypeInfosByName();
//
////            List<Contact> newContacts = new List<Contact> (); // not used?
//            Set<String> caseRecordsToInclude = new Set<String> ();
//            Set<Id> accountRecordsTypeMatch = new Set<Id> ();
//            List<Contact> contactsToUpdate = new List<Contact> ();
//            List<Contact> contactsToInsert = new List<Contact> ();
//
//            system.debug('the accout map-----' + accountRtMapByName);
//            system.debug('the case map-----' + caseRtMapByName);
//
//            for (VRTN__c vrt : VRTN__c.getAll().values()) {
//                system.debug('the types------' + vrt);
//
//                if (vrt.EUAccts__c != null) {
//                    accountRecordsTypeMatch.add(accountRtMapByName.get(vrt.EUAccts__c).getRecordTypeId());
//                }
//                if (vrt.EUServiceCases__c != null) {
//                    caseRecordsToInclude.add(caseRtMapByName.get(vrt.EUServiceCases__c).getRecordTypeId());
//                }
//            }
//
//            system.debug('the accountTypes-----' + accountRecordsTypeMatch);
//            system.debug('the caseTypes------' + caseRecordsToInclude);
//
//            Set<String> caseEmails = new Set<String> ();
//            for (Case c : records) {
//                if (c.SuppliedEmail != null) {
//                    caseEmails.add(c.SuppliedEmail);
//                }
//            }
//
//            List<Account> accountsToMatch = [SELECT Id, Name, Website, (SELECT Id, FirstName, LastName, LastModifiedDate FROM Contacts WHERE Email IN :caseEmails ORDER BY LastModifiedDate LIMIT 1) FROM Account WHERE RecordTypeID IN :accountRecordsTypeMatch];
//
//            for (Case c : records) {
//
//                if (caseRecordsToInclude.contains(c.RecordTypeID) &&
//                        c.Origin == 'Email') {
//
//                    String domain = null;
//
//                    if (c.SuppliedEmail != null) {
//                        domain = c.SuppliedEmail.subStringAfter('@');
//                    }
//
//                    Contact co = new Contact();
//
//                    for (Account a : accountsToMatch) {
//                        String accountWebsite;
//                        if (a.Website != null) {
//                            accountWebsite = a.Website.subStringAfter('www.');
//                        }
//                        system.debug('the Website----------' + a.Website);
//                        system.debug('the accountWebsite-----' + accountWebsite);
//                        system.debug('the domain-----------' + domain);
//                        system.debug('the SuppliedName---------' + c.SuppliedName);
//                        if (accountWebsite != null && domain == accountWebsite) {
//
//                            c.AccountId = a.Id;
//
//                            co.recordTypeId = cpId;
//                            co.Email = c.SuppliedEmail;
//                            Co.AccountId = a.Id;
//                            if (String.isNotBlank(c.SuppliedName))
//                            {
//                                if (c.SuppliedName.subStringAfter(' ') == '') {
//                                    co.LastName = c.SuppliedName.subStringBefore(' ');
//                                }
//                                else {
//                                    co.FirstName = c.SuppliedName.substringBefore(' ');
//                                    co.LastName = c.SuppliedName.subStringAfter(' ');
//                                }
//                            }
//                            if (a.Contacts.isEmpty()) {
//
//                                contactsToInsert.add(co);
//                            }
//                            else {
//                                co.Id = a.Contacts[0].Id;
//                                contactsToUpdate.add(co);
//                            }
//                        }
//                    }
//                    system.debug('the case after assignment-----' + c);
//                }
//            }
//
//            if (contactsToUpdate.size() != null || contactsToUpdate.size() > 1) {
//                update contactsToUpdate;
//                for (Contact co : contactsToUpdate) {
//                    for (Case c : records) {
//                        if (co.AccountId == c.AccountId) {
//                            c.ContactId = co.Id;
//                        }
//                    }
//                }
//            }
//
//            if (contactsToInsert.size() != null || contactsToInsert.size() > 1) {
//                insert contactsToInsert;
//                for (Contact co : contactsToInsert) {
//                    for (Case c : records) {
//                        if (co.AccountId == c.AccountId) {
//                            c.ContactId = co.Id;
//                        }
//                    }
//                }
//
//            }
//        }

    }

    public static void sendCaseCloseEmailToOpportunityOwner(List<Case> records, Map<Id, Case> oldMap) {
        Boolean isUpdate = oldMap != null;
        Set<Id> toProcess = new Set<Id> ();
        Id templateId = null;
        Id recordTypeId = UtilityClass.getRecTypeByDevName('Case','Fleet_Implementation');

        for (GlobalSettings__c setting :[SELECT CaseCloseEmailAlert__c FROM GlobalSettings__c LIMIT 1]) {
            templateId = setting.CaseCloseEmailAlert__c;
        }

        if (templateId == null) {
            System.debug('GlobalSettings__c.CaseCloseEmailAlert__c not specified; skipping UCase.sendCaseCloseEmailToOpportunityOwner()');
            return;
        }

        if (recordTypeId == null) {
            System.debug('RecordType with Developer Name "Fleet_Implementation" cannot be found; skipping UCase.sendCaseCloseEmailToOpportunityOwner()');
            return;
        }

        for (Case c : records) {
            if (isUpdate
                    && c.RecordTypeId == recordTypeId
                    && c.Cards__c > 0
                    && c.Opportunity__c != null
                    && (c.Type == 'Data Entry' || c.Type == 'Expedited' || c.Type == 'PreCard Call' || c.Type == 'Standard')
                    && (c.IsClosed && c.IsClosed != oldMap.get(c.Id).IsClosed))
            {
                toProcess.add(c.Id);
            }
        }

        if (toProcess.isEmpty()) {
            return;
        }

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage> ();

        for (Case c : [SELECT Id, Opportunity__c, Opportunity__r.OwnerId FROM Case WHERE Id IN :toProcess]) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTargetObjectId(c.Opportunity__r.OwnerId);
            email.setTreatTargetObjectAsRecipient(false);
            email.setToAddresses(new String[] { c.Opportunity__r.OwnerId });
            email.setSaveAsActivity(false);
            email.setUseSignature(false);

            // Using this to get around Who/WhatId restrictions when sending email to users.
            Messaging.SingleEmailMessage renderBody = Messaging.renderStoredEmailTemplate(templateId, c.Opportunity__r.OwnerId, c.Id);
            email.setSubject(renderBody.getSubject());
            email.setHtmlBody(renderBody.getHtmlBody());
            email.setPlainTextBody(renderBody.getPlainTextBody());
            emails.add(email);
        }

        try {
            Messaging.reserveSingleEmailCapacity(emails.size());
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(emails);

            for (Messaging.SendEmailResult res : results)
            {
                for (Messaging.SendEmailError err : res.getErrors())
                {
                    System.debug('UCase.sendCaseCloseEmailToOpportunityOwner send mail error: ' + err.getMessage());
                }
            }
        }
        catch (Exception e) {
            System.debug('Unable to send email');
        }
    }

    // Set default entitlement for Service Operations
    public static void setDefaultEntitlement(List<Case> records, Map<Id, Case> oldMap) {
//        Set<Id> queueBypassIds = new Set<Id>(); // this is never populated anywhere

        Boolean isUpdate = oldMap != null;

        List<Case> toUpdate = new List<Case> ();
        List<Case> toProcess = new List<Case> ();
        Set<Id> accountIds = new Set<Id> ();

        Id serviceOperationsRecordType = null;

        // Add Record Type Check
        if (Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Operations') != null) {
            serviceOperationsRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();
        }

        Support_Operation_Settings__c sos = Support_Operation_Settings__c.getOrgDefaults();

        for (Case c : records) {
            // We only want this to run for Service Operations..
            if(serviceOperationsRecordType != null && c.RecordTypeId != serviceOperationsRecordType) {
                continue;
            }

            // Added check to ensure Entitlement isn't already set.. DDG 3/18/2019
            if ((!isUpdate || c.AccountId != oldMap.get(c.Id).AccountId)) {
                if (c.AccountId == null) {
                    c.EntitlementId = sos.DefaultEntitlementID__c;
                    toUpdate.add(c);
                } else {
                    accountIds.add(c.AccountId);
                    toProcess.add(c);
                }
            }
        }

        if (toProcess.isEmpty() && toUpdate.isEmpty()) {
            return;
        }

        Map<Id, Id> entitlementMap = new Map<Id, Id> ();

        if (toProcess.size() > 0) {
            Set<Id> reprocessIds = new Set<Id> ();
            for (Entitlement e :[SELECT Id, AccountId FROM Entitlement WHERE Active_Flag__c = TRUE AND AccountId in :accountIds]) {
                if (entitlementMap.containsKey(e.AccountId)) {
                    reprocessIds.add(e.AccountId);
                    entitlementMap.put(e.AccountId, sos.DefaultEntitlementID__c);
                } else {
                    entitlementMap.put(e.AccountId, e.Id);
                }
            }

            if (reprocessIds.size() > 0) {
                Map<Id, Id> parentEntitlements = new Map<Id, Id> ();
                Map<Id, Id> parentAccounts = new Map<Id, Id> ();

                for (Account a :[SELECT Id, ParentId FROM Account WHERE Id in :reprocessIds AND ParentId != null]) {
                    parentAccounts.put(a.ParentId, a.Id);
                }

                for (Entitlement e :[SELECT Id, AccountId FROM Entitlement WHERE AccountId in :parentAccounts.keySet()]) {
                    if (parentEntitlements.containsKey(e.AccountId)) {
                        parentEntitlements.put(e.AccountId, sos.DefaultEntitlementID__c);
                    } else {
                        parentEntitlements.put(e.AccountId, e.Id);
                    }
                }

                for (String parentId : parentAccounts.keySet()) {
                    String childId = parentAccounts.get(parentId);
                    entitlementMap.put(childId, parentEntitlements.get(parentId));
                }
            }

            for (Case c : toProcess) {
                if (entitlementMap.containsKey(c.AccountId)) {
                    c.EntitlementId = entitlementMap.get(c.AccountId);
                    toUpdate.add(c);
                }
            }
        }
    }

    public static void associateContact(List<Case> records, Map<Id, Case> oldMap) {
        if (oldMap == null) {
			Set<Id> primaryContactEnabledRecordTypes = UtilityClass.getRecTypeByDevName('Case', new List<String>{'Service_Operations', 'Credit'});

			Set<Id> contactIds = new Set<Id> ();
            Set<Id> accountIds = new Set<Id>();
            Map<Id, Map<String, Id>> accountToContacts = new Map<Id, Map<String,Id>>();

            for (Case c : records) {
                if (c.SuppliedEmail != null && c.ContactId != null) {
                    contactIds.add(c.ContactId);
                }
                if (c.AccountId != null) {
                    accountIds.add(c.AccountId);
                }
            }

			// ============ Collections Primary Contact ============
			for (Contact contact : [ SELECT Id,AccountId,Contact_Type__c FROM Contact WHERE AccountId IN :accountIds ]) {

				String contactType = contact.Contact_Type__c != null && contactTypePriorities.get(contact.Contact_Type__c.toUpperCase()) != null ? contact.Contact_Type__c.toUpperCase() : 'NONE';
				contactType = contactTypePriorities.get(contactType) + contactType;

				if (accountToContacts.get(contact.AccountId) == null) accountToContacts.put(contact.AccountId, new Map<String,Id>());
				accountToContacts.get(contact.AccountId).put(contactType, contact.Id);

			}

			// ============

            Map<Id, Contact> nonPilotCtMap = new Map<Id, Contact> ([SELECT Id FROM Contact WHERE Id IN :contactIds AND Pilot_Flag__c = false]);

            Set<String> emails = new Set<String> ();

            for (Case c : records) {
                if (c.SuppliedEmail != null && nonPilotCtMap.containsKey(c.ContactId)) {
                    emails.add(c.SuppliedEmail);
                }
            }

            Map<String, Contact> emailCtMap = new Map<String, Contact> ();

            for (Contact ct : [SELECT Id, AccountId, Email FROM Contact WHERE Pilot_Flag__c = true AND Email IN :emails]) {
                emailCtMap.put(ct.Email, ct);
            }

            for (Case c : records) {

                // ============ Collections & Credit Primary Contact ============
                Boolean isEnabledCase = (c.RecordTypeId != null && primaryContactEnabledRecordTypes.contains(c.RecordTypeId) && UserInfo.getName() == 'Credit Monitoring');
                if (isEnabledCase) {
                    if (c.AccountId != null && accountToContacts.get(c.AccountId) != null) {
						Map<String, Id> relatedContacts = accountToContacts.get(c.AccountId);

						// Primary needs to be selected using priority(If a PRIMARY contact, use it. If not use the SHIPPING... etc. See contactTypePriorities)
						List<String> priortizedContacts = new List<String>(relatedContacts.keySet());
						priortizedContacts.sort();

						c.ContactId = relatedContacts.get(priortizedContacts[0]);
                    }
                }
                // ============
                else {
                    if (c.SuppliedEmail != null && nonPilotCtMap.containsKey(c.ContactId)) {
                        Contact foundContact = emailCtMap.get(c.SuppliedEmail);
                        if (foundContact == null) {
                            c.ContactId = null;
                            c.AccountId = null;
                        } else {
                            c.ContactId = foundContact.Id;
                            c.AccountId = foundContact.AccountId;
                        }
                    }
                }
            }
        }
    }
}