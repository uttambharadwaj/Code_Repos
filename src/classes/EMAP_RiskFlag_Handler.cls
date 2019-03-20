public class EMAP_RiskFlag_Handler {
    
    public static final Map<String, Schema.SObjectType> globalDesc = Schema.getGlobalDescribe(); 

    final private static String STATUS_ON_INSERT = 'Initiated';
    final private static String STATUS_CLOSED = 'Closed';
    final private static String STATUS_ACTIVE = '1 - Active';
    final private static String STATUS_3STOPPEDBLOCKED = '3 - Stopped (blocked)';
    final private static String SUBSTATUS_R_DELINQUENT = 'R - Delinquent (man.)';
    final private static String SUBSTATUS_PAYMNT_DISH = 'P - Payment Dishonour';
    final private static String STATUS_TEMPORARILY_LOCKED = '9 - Temporary Locked';
    final private static String STATUS_STOPPED = '3 - Stopped (blocked)';
    final private static String GU_STAFF_ACCOUNT_TYPE = 'ExxonMobil Guam Staff';
    final private static String HK_STAFF_ACCOUNT_TYPE = 'ExxonMobil Hong Kong Staff';
    final private static String SP_STAFF_ACCOUNT_TYPE = 'ExxonMobil Saipan Staff';
    final private static String SG_STAFF_ACCOUNT_TYPE = 'ExxonMobil Singapore Staff';
    
    
    // Date Type
    public final static String RISK_FLAG_SECE = 'Security expiring';
    public final static String RISK_FLAG_SUBQUERY_SECE = 'select Id, Account__c from Risk_Flags__r where Risk_Flag_Value__c = \'' + RISK_FLAG_SECE + '\' and Status__c <> \'' + STATUS_CLOSED + '\'';
    public final static String QUERY_SECE = 'select Id, Security_Expiry__c, Nird__c, Business_Expiry_Date__c, (' + RISK_FLAG_SUBQUERY_SECE + ') from Account where IsDeleted = false and Status__c in (\'' + STATUS_ACTIVE + '\', \'' + STATUS_TEMPORARILY_LOCKED + '\', \'' + STATUS_STOPPED + '\') and Security_Expiry__c <= NEXT_90_DAYS';
    
    // Date Type
    public final static String RISK_FLAG_CRVW = 'NIRD Expiry';
    public final static String RISK_FLAG_SUBQUERY_CRVW = 'select Id from Risk_Flags__r where Risk_Flag_Value__c = \'' + RISK_FLAG_CRVW + '\' and Status__c <> \'' + STATUS_CLOSED + '\'';
    public final static String QUERY_CRVW = 'select Id, Security_Expiry__c, Nird__c, Business_Expiry_Date__c, (' + RISK_FLAG_SUBQUERY_CRVW + ') from Account where IsDeleted = false and Status__c in (\'' + STATUS_ACTIVE + '\', \'' + STATUS_TEMPORARILY_LOCKED + '\', \'' + STATUS_STOPPED + '\') and NIRD__c <= NEXT_90_DAYS';

    // Date Type
    public final static String RISK_FLAG_BEXP = 'Business expiry';
    public final static String QUERY_BEXP = 'select Id, Security_Expiry__c, Nird__c, Business_Expiry_Date__c from Account where IsDeleted = false and Status__c in (\'' + STATUS_ACTIVE + '\', \'' + STATUS_TEMPORARILY_LOCKED + '\', \'' + STATUS_STOPPED + '\') and Business_Expiry_Date__c <= NEXT_N_DAYS:90 and Id not in (select Account__c from Risk_Flag__c where Risk_Flag_Value__c = \'' + RISK_FLAG_BEXP + '\' and Status__c <> \'' + STATUS_CLOSED + '\')';

    // Date Type
    public final static String RISK_FLAG_OVERRIDE = 'Override Expiry';
    public final static String QUERY_OVERRIDE = 'select Id, Security_Expiry__c, Nird__c, Business_Expiry_Date__c, (select Id, Expiry_Date__c from Credit_Overrides__r where IsDeleted = false and Expiry_Date__c = NEXT_N_DAYS:7 and Override_Status__c = \'Active\' order by CreatedDate desc limit 1) from Account where IsDeleted = false and Status__c in (\'' + STATUS_ACTIVE + '\', \'' + STATUS_TEMPORARILY_LOCKED + '\', \'' + STATUS_STOPPED + '\') and Id in (select Account__c from Credit_Override__c where IsDeleted = false and Account__c <> null and Expiry_Date__c = NEXT_N_DAYS:7 and Override_Status__c = \'Active\') and Id not in (select Account__c from Risk_Flag__c where Risk_Flag_Value__c = \'' + RISK_FLAG_OVERRIDE + '\' and Status__c <> \'' + STATUS_CLOSED + '\')';

    //Exclude Accounts having below Credit Overrides
    public final static String CREDIT_OVERRIDE_QUERY = ' (Select Account__c From Credit_Override__c Where Override_Type__c IN (\'Overdue (AOT) Override\', \'Dishonoured Payment Override\') AND Effective_Date__c <= TODAY AND Expiry_Date__c  >= TODAY) ';

    //Exclude Accounts having below Credit Override Security Exception
    public final static String CREDIT_OVERRIDE_SECURITY_EXCEPTION_QUERY = ' Select Account__c From Credit_Override__c Where Override_Type__c = \'Security Exception\' AND Override_Status__c = \'Active\' ';
    
    // Data Type
    public final static String RISK_FLAG_LPYR = 'Late payer';
    //public final static String QUERY_LPYR = 'select Id, Security_Expiry__c, Nird__c, Business_Expiry_Date__c from Account where IsDeleted = false and Status__c in (\'' + STATUS_ACTIVE + '\',\'' + STATUS_3STOPPEDBLOCKED + '\') and Account_Sub_Status__c in (\'' + SUBSTATUS_R_DELINQUENT + '\') and Customer_Type__c not in (\'0 - VIP/Government\',\'1 - General Exclusion\') and AOT_Threshold_Exceeded__c = false and Percent_Secured__c < 100 and Number_of_Late_Payments_Last_3_Months__c >= 2 and Id not in (select Account__c from Risk_Flag__c where Risk_Flag_Value__c = \'' + RISK_FLAG_LPYR + '\' and Status__c <> \'' + STATUS_CLOSED + '\') and Id not in ' + CREDIT_OVERRIDE_QUERY ;
    public final static String QUERY_LPYR = 'select Id, Security_Expiry__c, Nird__c, Business_Expiry_Date__c from Account where IsDeleted = false and (Status__c in (\'' + STATUS_ACTIVE + '\') OR Account_Sub_Status__c in (\'' + SUBSTATUS_R_DELINQUENT + '\')) and Customer_Type__c not in (\'0 - VIP/Government\',\'1 - General Exclusion\') and AOT_Threshold_Exceeded__c = false and Percent_Secured__c < 100 and Number_of_Late_Payments_Last_3_Months__c >= 2 and Id not in (select Account__c from Risk_Flag__c where Risk_Flag_Value__c = \'' + RISK_FLAG_LPYR + '\' and Status__c <> \'' + STATUS_CLOSED + '\') and Id not in ' + CREDIT_OVERRIDE_QUERY ;
    // Data Type
    public final static String RISK_FLAG_SVHR = 'Re-Instatement – Security Very High Risk';
    public final static String QUERY_SVHR = 'select Id, Security_Expiry__c, Nird__c, Business_Expiry_Date__c from Account where IsDeleted = false and (Status__c in (\'' + STATUS_STOPPED + '\') and Account_Sub_Status__c in (\'' + SUBSTATUS_R_DELINQUENT + '\')) and AOT_Threshold_Exceeded__c = false and Risk_Grade__c = \'6 - Very High\' and Percent_Secured__c < 100 and Id not in (select Account__c from Risk_Flag__c where Risk_Flag_Value__c = \'' + RISK_FLAG_SVHR + '\' and Status__c <> \'' + STATUS_CLOSED + '\')';

    // Data Type
    public final static String RISK_FLAG_SHR = 'Re-Instatement – Security High Risk';
    public final static String QUERY_SHR = 'select Id, Security_Expiry__c, Nird__c, Business_Expiry_Date__c from Account where IsDeleted = false and (Status__c in (\'' + STATUS_STOPPED + '\') and Account_Sub_Status__c in (\'' + SUBSTATUS_R_DELINQUENT + '\')) and AOT_Threshold_Exceeded__c = false and Risk_Grade__c = \'5 - High\' and Percent_Secured__c < 50 and Id not in (select Account__c from Risk_Flag__c where Risk_Flag_Value__c = \'' + RISK_FLAG_SHR + '\' and Status__c <> \'' + STATUS_CLOSED + '\')';

    // Data Type
    public final static String RISK_FLAG_SDSH = 'Re-Instatement – Payment Dishonours';
    public final static String QUERY_SDSH = 'select Id, Security_Expiry__c, Nird__c, Business_Expiry_Date__c from Account where IsDeleted = false and Status__c in (\'' + STATUS_STOPPED + '\') and Account_Sub_Status__c in (\'' + SUBSTATUS_PAYMNT_DISH + '\') and Percent_Secured__c < 100 and Number_of_Dishonours_in_Last_3_Months__c >= 2 and Id not in (select Account__c from Risk_Flag__c where Risk_Flag_Value__c = \'' + RISK_FLAG_SDSH + '\' and Status__c <> \'' + STATUS_CLOSED + '\')';

    // Data Type
    public final static String RISK_FLAG_HLA = 'HLA Review';
    public final static String QUERY_HLA = 'select Id, Security_Expiry__c, Nird__c, Business_Expiry_Date__c, Percent_Credit_Utilization__c, Group_Balance__c, Group_Balance_utilisation__c from Account where IsDeleted = false and Status__c in (\'' + STATUS_ACTIVE + '\') and ( Percent_Credit_Utilization__c >= 80 OR Group_Balance_utilisation__c >= 80 ) and Credit_Limit_Lcy__c >= 0 and Type not in (\'' + GU_STAFF_ACCOUNT_TYPE + '\', \'' + HK_STAFF_ACCOUNT_TYPE + '\', \'' + SP_STAFF_ACCOUNT_TYPE + '\', \'' + SG_STAFF_ACCOUNT_TYPE + '\') and Id not in (select Account__c from Risk_Flag__c where Risk_Flag_Value__c = \'' + RISK_FLAG_HLA + '\' and Status__c <> \'' + STATUS_CLOSED + '\')';

    // Data Type
    //public final static String RISK_FLAG_RFEM = 'EMTC Referral';
    //public final static String QUERY_RFEM = 'select Id, Security_Expiry__c, Nird__c, Business_Expiry_Date__c from Account where IsDeleted = false and Status__c in (\'' + STATUS_ACTIVE + '\', \'' + STATUS_TEMPORARILY_LOCKED + '\', \'' + STATUS_STOPPED + '\') and Account_Controller__c = \'WEX\' and Id not in (select Account__c from Risk_Flag__c where Status__c <> \'' + STATUS_CLOSED + '\')';

    //map of Risk flag label and associated query
    public final static Map<String, String> DATA_SOQL_MAP = new Map<String, String> {
        RISK_FLAG_LPYR  => QUERY_LPYR
        ,RISK_FLAG_SVHR => QUERY_SVHR
        ,RISK_FLAG_SHR  => QUERY_SHR
        ,RISK_FLAG_SDSH => QUERY_SDSH
        ,RISK_FLAG_HLA  => QUERY_HLA
        //,RISK_FLAG_RFEM => QUERY_RFEM
    };
    
    //Only EMAP Fuel Accounts records
    public static Schema.RecordTypeInfo accountRecType = getRecordTypeInfo('Account', 'EMAP Fuel Accounts');

    /* used to get Record Type info on any object
    *  Parameters: Object name and Record Type name
    */
    public static Schema.RecordTypeInfo getRecordTypeInfo(String objectName, String recordTypeName){
                
        if(globalDesc.containsKey(objectName)){
                Schema.SObjectType d = globalDesc.get(ObjectName);
                Schema.DescribeSObjectResult r = d.getDescribe();
                Map<String,Schema.RecordTypeInfo> rtMapByName = r.getRecordTypeInfosByName();
                
                return rtMapByName.get(recordTypeName);                 
        }
        else {
            return null;
        }    
    }

    public static void updateClosedFields(List<Risk_Flag__c> newRiskFlags, Map<Id, Risk_Flag__c> oldMap) {
        for(Risk_Flag__c riskFlagNew : newRiskFlags) {

            // status is considered updated if this is: 
            // 1) an INSERT 
            // 2) or the new status is different from the old status
            Boolean isStatusUpdated = (
                oldMap == null 
                || oldMap.get(riskFlagNew.Id) == null 
                || oldMap.get(riskFlagNew.Id).Status__c != riskFlagNew.Status__c
            );
            
            // if the new status is closed and the status was not closed before
            // then treat this as an update to the closed status
            if(isStatusUpdated && riskFlagNew.Status__c == STATUS_CLOSED) {
                riskFlagNew.Closed_Date__c = Date.today();
                riskFlagNew.Closed_By_User__c = UserInfo.getUserId();
            }
        }
    }

    public static void addRiskFlags(Map<Id, Account> newAccountsMap) {
        System.debug('@@@@@@@@@@@@@@@@');
        List<Risk_Flag__c> riskFlagsToInsert = new List<Risk_Flag__c>();

        List<Account> newAccList = newAccountsMap.values();

        Set<ID> accountIds = new Set<ID>();
        
        for(Account newacc: newAccList ){
            if(newAcc.recordTypeId == accountRecType.getRecordTypeId()){
                accountIds.add(newAcc.id);
            }
        }
        
        if(accountIds.size() > 0){
            for(String riskFlagValue : DATA_SOQL_MAP.keySet()) {

                //prepare query for non date based Risk flags like, late payer, HLA Review etc.
                String soql = DATA_SOQL_MAP.get(riskFlagValue) + ' and Id in :accountIds ';

                //Exclude Credit override Security Exception for Late Payer Risk Flag
                if(riskFlagValue == RISK_FLAG_LPYR){
                    //get list of active credit overrides having SECURITY_EXCEPTION
                    List<Credit_Override__c> credit_overrideList = Database.query(CREDIT_OVERRIDE_SECURITY_EXCEPTION_QUERY);
                    
                    //get list of account Ids related to above Credit Overrides
                    List<Id> accIds = new List<Id>();
                    for(Credit_Override__c creditOverride: credit_overrideList){
                        accIds.add(creditOverride.Account__c);
                    }
                    
                    //appending condition to exclude accounts having CREDIT_OVERRIDE_SECURITY_EXCEPTION
                    soql += ' and Id not IN: accIds';
                }

                List<Account> affectedAccounts = Database.query(soql);

                riskFlagsToInsert.addAll(buildRiskFlagsToInsert(affectedAccounts, riskFlagValue));
            }
    
            insert riskFlagsToInsert;
        }
    }

    public static List<Risk_Flag__c> buildRiskFlagsToInsert(List<Account> accounts, String riskFlagValue) {
        List<Risk_Flag__c> riskFlagsToInsert = new List<Risk_Flag__c>();
        for(Account acct : accounts) {

            if(isAccountWithRiskFlag(acct) == false) {
                Risk_Flag__c riskFlag = new Risk_Flag__c();
                riskFlag.Risk_Flag_Value__c = riskFlagValue;
                riskFlag.Account__c = acct.Id;
                riskFlag.Status__c = STATUS_ON_INSERT;
                riskFlag.Auto_Generated_Flag__c = true;
                
                if(riskFlagValue == RISK_FLAG_HLA){
                
                    if(acct.Group_Balance__c == null){
                        riskFlag.HLA_Level__c = acct.Percent_Credit_Utilization__c;
                    } else {
                        riskFlag.HLA_Level__c = acct.Group_Balance_utilisation__c;
                    }
                } else {
                    riskFlag.HLA_Level__c = 0;
                }
                
                riskFlag.Schedule_Date__c = getScheduleDate(riskFlagValue, acct);
                riskFlagsToInsert.add(riskFlag);
                
/*
                riskFlagsToInsert.add(new Risk_Flag__c(
                    Risk_Flag_Value__c = riskFlagValue
                    ,Account__c = acct.Id
                    ,Status__c = STATUS_ON_INSERT
                    ,Auto_Generated_Flag__c = true
                    ,HLA_Level__c = ((riskFlagValue == RISK_FLAG_HLA) ? acct.Percent_Credit_Utilization__c : null)
                    ,Schedule_Date__c = getScheduleDate(riskFlagValue, acct)
                ));
*/
            }
        }
        
        return riskFlagsToInsert;
    }

    private static Boolean isAccountWithRiskFlag(Account acct) {
        return ((acct == null || acct.Risk_Flags__r == null) ? false : (acct.Risk_Flags__r.size() > 0));
    }

    //
    // For Date Driven Risk falgs the Schedule Date should be set to the Expiry Date on the record triggering the flag
    // For all other risk flags it should be set to today's date
    //
    private static Date getScheduleDate(String riskFlagValue, Account acct) {
        if(riskFlagValue == RISK_FLAG_BEXP) {
            return acct.Business_Expiry_Date__c;
        }
        else if(riskFlagValue == RISK_FLAG_CRVW) {
            return acct.Nird__c;
        }
        else if(riskFlagValue == RISK_FLAG_SECE) {
            return acct.Security_Expiry__c;
        }
        else if(riskFlagValue == RISK_FLAG_OVERRIDE) {
            return (acct.Credit_Overrides__r != null && acct.Credit_Overrides__r.isEmpty() == false ? acct.Credit_Overrides__r[0].Expiry_Date__c : null);
        }

        //return Date.today() + 3;
        return EMAP_DateTime_Handler.AddBusinessDays(Date.today(), 3);
    }

}