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
            AggregateResult[] ar = [SELECT MAX(a.Member_ID__c)MaxMemberID FROM Account a WHERE a.recordTypeId= :setting.Truckers_Account_Record_Type__c and a.Member_ID__c LIKE '700%'];
            Integer NextMemberID = Integer.valueof(ar[0].get('MaxMemberID'));
            if(NextMemberID==NUll)
                NextMemberID=0;

            system.debug('NextMemberID : ' + NextMemberID);
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
            Id rectypeid = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'WES_Accounts' LIMIT 1].Id;
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

}