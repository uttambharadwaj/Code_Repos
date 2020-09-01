/**
 *   Created by: GearsCRM
 */
public class UAccount {

    /**
     * Automatically adds the new owner to the Account Team
     * if the owner is not already a member and is currently active.
     */
    public static void assignAccountTeamMembers( List<Account> accounts, Map<ID, Account> oldMap ) {

        Set<ID> accountIds = new Set<ID>();

        for ( Account newAccount : accounts ) {

            // old map will be null when inserting new accounts but non-null when updating accounts
            Account oldAccount = ( oldMap != null ) ? oldMap.get( newAccount.id ) : null;

            // if inserting new account or the owner changed to new person
            Boolean ownerChanged = ( oldAccount == null || oldAccount.ownerId != newAccount.ownerId );

            if ( ownerChanged ) {
                accountIds.add( newAccount.id );
            }

        }

        List<AccountTeamMember> teamMembersToInsert = new List<AccountTeamMember>();

        List<Account> accountsWithTeamMembers = new List<Account>([
                SELECT
                        id, ownerId,
                (
                        SELECT
                                id, userId
                        FROM
                                AccountTeamMembers
                )
                FROM
                        Account
                WHERE
                id IN :accountIds
                AND
                owner.isActive = true
        ]);

        for ( Account acct : accountsWithTeamMembers ) {

            Boolean isOwnerMember = false;

            System.debug( 'accountTeamMembers: ' + acct.accountTeamMembers );

            for ( AccountTeamMember member : acct.accountTeamMembers ) {
                if ( member.userId == acct.ownerId ) {
                    isOwnerMember = true;
                    break;
                }
            }

            System.debug( 'isOwnerMember: ' + isOwnerMember );

            if ( !isOwnerMember ) {

                teamMembersToInsert.add( new AccountTeamMember(
                        accountId = acct.id,
                        userId = acct.ownerId,
                        teamMemberRole = 'Account Team Member'
                ));

            }

        }

        if ( teamMembersToInsert.size() > 0 ) {
            insert teamMembersToInsert;
        }

    }
    public static void associateOTRPrograms(List<Account> accounts, Map<ID, Account> oldMap){
        List<Account> toProcess = new List<Account>();
        Id acctRecordTypeId = UtilityClass.getRecTypeByDevName('Account','Service_Operations');

        for(Account a : accounts)
        {
            //check to see if it's a service ops record and the Platform LOB is OTR
            if(a.RecordTypeId == acctRecordTypeId && a.Platform_LOB__c == 'OTR')
            {
                toProcess.add(a);
            }
        }

        if(toProcess.isEmpty()){
            return;
        }

        Id programRecordTypeId = UtilityClass.getRecTypeByDevName('Program__c','Service_Operations');

        //do we have a more efficient way of looking this up?
        List<Program__c> programs = [SELECT Id, Name
        FROM Program__c
        WHERE RecordTypeId = :programRecordTypeId AND
        Name IN ('EFSLLC', 'TCHEK', 'TCHEK_MC', 'IRVING', 'EFSTS', 'Shell', 'IMPERIAL OIL', 'PINNACLE', 'FLEETONE')];

        Map<String, String> programsMap = new Map<String, String>();

        for(Program__c p : programs){
            programsMap.put(p.Name, p.Id);
        }

        for(Account a : toProcess) {
            System.debug('***** Account Platform: ' + a.Platform__c);
            switch on a.Platform__c {
                when 'EFSLLC', 'EFS LLC' {
                    a.Program__c = programsMap.get('EFSLLC');
                }
                when 'IMPERIAL' {
                    a.Program__c = programsMap.get('IMPERIAL OIL');
                }
                when 'SHELL_NAV', 'SFJ_SHELL' {
                    a.Program__c = programsMap.get('Shell');
                }
                when 'TChek', 'TCHEK_MC', 'IRVING', 'EFSTS', 'PINNACLE', 'FLEETONE' {
                    a.Program__c = programsMap.get(a.Platform__c);
                }
                when else {
                    System.debug('***** Program match not found for Account Platform: ' + a.Platform__c);
                }
            }
        }
    }

    public static void truckersGenerateMemIdAndPassword( List<Account> accounts, Map<ID, Account> oldMap )
    {
        List<Account> toProcess = new List<Account>();
        GlobalSettings__c setting = GlobalSettings__c.getOrgDefaults();

        for(Account a : accounts)
        {
            if(a.Status__c == 'Member' && a.RecordTypeId == setting.Truckers_Account_Record_Type__c)
            {
                if(a.Member_Id__c == NULL || a.Web_Password__c == NULL)
                {
                    toProcess.add(a);
                }
            }
        }

        if(!toProcess.isEmpty())
        {
            // AggregateResult[] ar = [SELECT MAX(a.Member_ID__c)MaxMemberID FROM Account a WHERE a.recordTypeId= :setting.Truckers_Account_Record_Type__c and a.Member_ID__c LIKE '700%'];
            // Integer NextMemberID = Integer.valueof(ar[0].get('MaxMemberID'));
            Integer NextMemberID;
            List<Account> acctList = [SELECT Member_ID__c FROM Account WHERE RecordTypeId= :setting.Truckers_Account_Record_Type__c AND Member_ID__c LIKE '700%' ORDER BY Member_ID__c DESC LIMIT 1];
            if (!acctList.isEmpty()) {
                NextMemberID = Integer.valueof(acctList[0].Member_ID__c);
            }

            if(NextMemberID==NUll)
                NextMemberID=0;

            System.debug('NextMemberID : ' + NextMemberID);
            for(Account a: toProcess)
            {
                if (a.Member_ID__c == NULL)
                {
                    a.Member_ID__c= string.valueof(++NextMemberID);
                }

                if(a.Web_Password__c==Null)
                {
                    a.Web_Password__c = assignPassword();
                }

            }
        }
    }

    public static void checkCompaniesHouseIntegration(List<Account> records, Map<Id, Account> oldMap) {

        if (!System.isFuture()) {
            Id rectypeid = UtilityClass.getRecTypeByDevName('Account','WES_Accounts');
            Set<Id> accIds = new Set<Id> ();
            Boolean isInsert = oldMap == null;
            for (Account acct : records) {
                if ( !CompaniesHouseIntegration.processedIds.contains(acct.Id)
                        && acct.RecordTypeId == rectypeid
                        && acct.Company_registration_number__c != null
                        && (
                        isInsert
                                || acct.Company_registration_number__c != oldMap.get(acct.Id).Company_registration_number__c
                )) {
                    accIds.add(acct.Id);
                    CompaniesHouseIntegration.processedIds.add(acct.Id);
                }
            }
            if (!accIds.isEmpty()) {
                CompaniesHouseIntegration.getNameAddress(accIds);
            }
        }
    }

    public static void checkVATRegNumber(List<Account> records, Map<Id, Account> oldMap) {
        if (!System.isFuture()) {
            //Id rectypeid = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'WES_Accounts' LIMIT 1].Id;
            Set<Id> acctIds = new Set<Id> ();
            Boolean isInsert = oldMap == null;
            for (Account acct : records) {
                if ( !VATIntegration.processedIds.contains(acct.Id)
                        && acct.WES_VAT_Reg_Num__c != null
                        && acct.WES_ISO_Country_Code__c != null
                        && (
                        isInsert
                                || acct.WES_VAT_Reg_Num__c != oldMap.get(acct.Id).WES_VAT_Reg_Num__c
                                || acct.WES_ISO_Country_Code__c != oldMap.get(acct.Id).WES_ISO_Country_Code__c
                )) {
                    acctIds.add(acct.Id);
                    VATIntegration.processedIds.add(acct.Id);
                }
            }
            if (!acctIds.isEmpty()) {
                VATIntegration.validateVAT(acctIds);
            }
        }
    }

    private static string assignPassword()
    {
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        return key.substring(0, 8);
    }

    public static void parentSalesAccounts(List<Account> records, Map<Id, Account> oldMap) {
        Id cpsRecTypeId = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('CPS_Accounts').getRecordTypeId();
        List<Account> qualifiedRecords = new List<Account>();
        for (Account rec: records) {
            if(rec.RecordTypeId == cpsRecTypeId
                    && rec.Program__c!=null) {
                qualifiedRecords.add(rec);
            }
        }

        if (!qualifiedRecords.isEmpty()) {
            Set<String> dunsNumbers = new Set<String>();
            Set<String> acctNames = new Set<String>();
            Set<String> phoneNumbers = new Set<String>();

            for (Account rec: qualifiedRecords) {
                if (rec.DUNS__c!=null) {
                    dunsNumbers.add(rec.DUNS__c);
                }
                if (rec.Name!=null) {
                    acctNames.add(rec.Name);
                }
                if (rec.phone!=null) {
                    phoneNumbers.add(rec.phone);
                }
            }

            Set<Id> parentAccIds = new Set<Id>();
            Set<Id> programIds = new Set<Id>();
            Map<String, Id> parentAcctMap = new Map<String, Id>();
            for (Account acc : [SELECT Id, ParentId, DUNS__c FROM Account WHERE RecordTypeId =:cpsRecTypeId
            AND Is_Program_Account__c = false
            AND DUNS__c IN : dunsNumbers
            AND Id NOT IN : qualifiedRecords
            ORDER BY LastModifiedDate DESC]) {
                if (acc.ParentId==null && parentAcctMap.get(acc.DUNS__c)==null) {
                    parentAcctMap.put(acc.DUNS__c,acc.Id);
                }
            }

            for (Account rec: qualifiedRecords) {
                if (rec.ParentId == null && parentAcctMap.get(rec.DUNS__c)!=null) {
                    rec.ParentId = parentAcctMap.get(rec.DUNS__c);
                    parentAccIds.add(rec.ParentId);
                    programIds.add(rec.Program__c);
                }
            }

            Boolean secondPass = false;
            for (Account rec: qualifiedRecords) {
                if (rec.ParentId==null) {
                    secondPass = true;
                    break;
                }
            }

            if (secondPass==true) {
                for (Account acc : [SELECT Id, ParentId, Name, Phone FROM Account WHERE RecordTypeId =:cpsRecTypeId
                AND Is_Program_Account__c = false
                AND Name IN : acctNames
                AND Phone IN : phoneNumbers
                AND Id NOT IN : qualifiedRecords
                ORDER BY LastModifiedDate DESC]) {
                    if (acc.ParentId==null) {
                        for (Account rec: qualifiedRecords) {
                            if (rec.ParentId == null) {
                                if (rec.Name == acc.Name && rec.Phone == acc.Phone) {
                                    rec.ParentId = acc.Id;
                                    parentAccIds.add(acc.Id);
                                    programIds.add(rec.Program__c);
                                }
                            }
                        }
                    }
                }
            }

            //look for existing accounts with the same parent and program - report an error if one exists
            if (!parentAccIds.isEmpty() && !programIds.isEmpty()) {
                Map<String, Account> existingProgramAcctMap = new Map<String, Account>();
                for (Account acc : [SELECT Id, Name, ParentId, Program__c FROM Account WHERE ParentId IN : parentAccIds AND Program__c IN : programIds]) {
                    existingProgramAcctMap.put(acc.ParentId + '_' + acc.Program__c, acc);
                }
                for (Account rec: qualifiedRecords) {
                    if (rec.ParentId!=null) {
                        String key = rec.ParentId + '_' + rec.Program__c;
                        if (existingProgramAcctMap.get(key)!=null) {
                            rec.addError('An Account already exists for that Program - <a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + existingProgramAcctMap.get(key).Id
                                    + '">' + existingProgramAcctMap.get(key).Name + '</a>', false);
                        }
                    }
                }
            }

            List<User> parentAccOwners = [SELECT Id FROM User WHERE Name = 'Data Lake Integration' AND Profile.Name = 'System Administrator' LIMIT 1];
            Map<String, Account> newParentAcctMap = new Map<String, Account>();
            List<Account> parentAccList = new List<Account>();
            for (Account rec: qualifiedRecords) {
                if(rec.ParentId==null && newParentAcctMap.get(rec.Name)==null) {
                    programIds.add(rec.Program__c);
                    Account parentAcc = new Account();
                    parentAcc.Name = rec.Name;
                    parentAcc.RecordTypeId = cpsRecTypeId;
                    parentAcc.Is_Program_Account__c = false;
                    if (!parentAccOwners.isEmpty()) {
                        parentAcc.OwnerId = parentAccOwners[0].Id;
                    }
                    newParentAcctMap.put(rec.Name, parentAcc);
                }
            }

            insert newParentAcctMap.values();

            if (!programIds.isEmpty()) {
                Map<Id, Program__c> pgmMap = new Map<Id, Program__c>([SELECT Partner__c FROM Program__c WHERE Id IN : programIds]);
                for (Account rec: qualifiedRecords) {
                    rec.Partner_Name__c = pgmMap.get(rec.Program__c).Partner__c;
                    rec.Is_Program_Account__c = true;
                }
            }

            for (Account rec: qualifiedRecords) {
                if(rec.ParentId==null) {
                    rec.ParentId = newParentAcctMap.get(rec.Name).Id;
                }
            }
        }
    }

    public static void executeBREeze(List<Account> records, Map<Id, Account> oldMap) {
        BREeze.processRules.ruleDataSet rds = new BREeze.processRules.ruleDataSet();
        rds.records = records;
        rds.oldMap = oldMap;
        BREeze.ProcessRules.processRuleLogic('MC_Accounts_Sync_to_Marketing_Cloud', false, rds);
    }
}