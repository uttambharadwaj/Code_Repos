public class EMAP_AccountAutoSusReact_Handler {
    
    //************ Queries will not be used any more ***************************************************//
    public final static String QUERY_HongKong_OVERDUE_SUSPENSION = 'select Id from Account where Client_Id__c = \'32\' AND Status__c = \'1 - Active\' AND Customer_Type__c = \'3 - Standard\' AND Overdue_Days__c >= 6 AND AOT_Threshold_Exceeded__c = true';
    
    public final static String QUERY_GMSPSG_OVERDUE_SUSPENSION = 'select Id from Account where Client_Id__c in (\'30\',\'31\',\'33\') AND Status__c = \'1 - Active\' AND Customer_Type__c = \'3 - Standard\' AND Overdue_Days__c >= 6 AND AOT_Threshold_Exceeded__c = true';
    
    public final static String QUERY_HongKong_REACTIVATION = '' + 
        ' select Id ' +
        ' from Account ' +
        ' where Client_Id__c = \'32\' ' +
        ' AND Status__c = \'9 - Temporary Locked\' ' +
        ' AND Account_Sub_Status__c = \'J - AutoStop Delinquent\'' +
        ' AND Customer_Type__c = \'3 - Standard\' ' +
        ' AND AOT_Threshold_Exceeded__c = false ' +
        ' AND ( ' +
        '   ( ' +
        '       (Number_of_Late_Payments_Last_3_Months__c = null OR Number_of_Late_Payments_Last_3_Months__c < 2) ' +
        '       AND (Number_of_Dishonours_in_Last_3_Months__c = null OR Number_of_Dishonours_in_Last_3_Months__c < 2) ' +
        '       AND Risk_Grade__c in (\'0 - Limited Assessment\',\'2 - Very Low\',\'3 - Low\',\'4 - Medium\') ' +
        '   ) ' +
        '   OR ' +
        '   ( ' +
        '       (Number_of_Late_Payments_Last_3_Months__c = null OR Number_of_Late_Payments_Last_3_Months__c < 2) ' +
        '       AND (Number_of_Dishonours_in_Last_3_Months__c = null OR Number_of_Dishonours_in_Last_3_Months__c < 2) ' +
        '       AND Risk_Grade__c = \'5 - High\' ' +
        '       AND Percent_Secured__c >= 50 ' +
        '   ) ' +
        '   OR ' +
        '   ( ' +
        '   Percent_Secured__c >= 100 ' +
        '   ) ' +
        ' )';
        
    public final static String QUERY_GMSPSG_REACTIVATION = '' + 
        ' select Id ' +
        ' from Account ' +
        ' where Client_Id__c in (\'30\',\'31\',\'33\') ' +
        ' AND Status__c = \'9 - Temporary Locked\' ' +
        ' AND Account_Sub_Status__c = \'J - AutoStop Delinquent\'' +
        ' AND Customer_Type__c = \'3 - Standard\' ' +
        ' AND AOT_Threshold_Exceeded__c = false ' +
        ' AND ( ' +
        '   ( ' +
        '       (Number_of_Late_Payments_Last_3_Months__c = null OR Number_of_Late_Payments_Last_3_Months__c < 2) ' +
        '       AND (Number_of_Dishonours_in_Last_3_Months__c = null OR Number_of_Dishonours_in_Last_3_Months__c < 2) ' +
        '       AND Risk_Grade__c in (\'0 - Limited Assessment\',\'2 - Very Low\',\'3 - Low\',\'4 - Medium\') ' +
        '   ) ' +
        '   OR ' +
        '   ( ' +
        '       (Number_of_Late_Payments_Last_3_Months__c = null OR Number_of_Late_Payments_Last_3_Months__c < 2) ' +
        '       AND (Number_of_Dishonours_in_Last_3_Months__c = null OR Number_of_Dishonours_in_Last_3_Months__c < 2) ' +
        '       AND Risk_Grade__c = \'5 - High\' ' +
        '       AND Percent_Secured__c >= 50 ' +
        '   ) ' +
        '   OR ' +
        '   ( ' +
        '   Percent_Secured__c >= 100 ' +
        '   ) ' +
        ' )';
    //************ Queries will not be used any more ***************************************************//

        
    //Added Updated Queries here. Above queries will not be used any more
    
    //Exclude Accounts having below Credit Overrides
    public final static String CREDIT_OVERRIDE_QUERY = ' (Select Account__c From Credit_Override__c Where Override_Type__c IN (\'Overdue (AOT) Override\', \'Dishonoured Payment Override\') AND Effective_Date__c <= TODAY AND Expiry_Date__c  >= TODAY) ';    
    public final static Decimal Late_Payer_Days = [Select Late_Payer_Days__c From Program__c Where Client_Id__c ='30' OR Client_Id__c ='31' LIMIT 1].Late_Payer_Days__c;
    public final static Decimal Late_Payer_Days_HK = [Select Late_Payer_Days__c From Program__c Where Client_Id__c ='32' LIMIT 1].Late_Payer_Days__c;    
    public final static Decimal Late_Payer_Days_SG = [Select Late_Payer_Days__c From Program__c Where Client_Id__c ='33' LIMIT 1].Late_Payer_Days__c;        
    
    //Query to Auto Suspend GMSP Accounts automatically through Batch
    public final static String QUERY_GMSP_OVERDUE_SUSPENSION = '' +
        ' Select Id From Account ' + 
        ' Where RecordType.name = \'EMAP Fuel Accounts\' ' +
        ' AND Id NOT IN ' + CREDIT_OVERRIDE_QUERY +
        ' AND Client_Id__c in (\'30\',\'31\') ' +
        ' AND Status__c = \'1 - Active\' ' +
        ' AND Customer_Type__c = \'3 - Standard\' ' +
        ' AND Overdue_Days__c >=' + Integer.valueOf(Late_Payer_Days) +
        ' AND AOT_Threshold_Exceeded__c = true';
    
    //Query to Auto Suspend HK Accounts automatically through Batch
    public final static String QUERY_HK_OVERDUE_SUSPENSION = '' +
        ' Select Id From Account ' + 
        ' Where RecordType.name = \'EMAP Fuel Accounts\' ' +
        ' AND Id NOT IN ' + CREDIT_OVERRIDE_QUERY +
        ' AND Client_Id__c in (\'32\') ' +
        ' AND Status__c = \'1 - Active\' ' +
        ' AND Customer_Type__c = \'3 - Standard\' ' +
        ' AND Overdue_Days__c >=' + Integer.valueOf(Late_Payer_Days_HK) +
        ' AND AOT_Threshold_Exceeded__c = true';

        //Query to Auto Suspend SG Accounts automatically through Batch
    public final static String QUERY_SG_OVERDUE_SUSPENSION = '' +
        ' Select Id From Account ' + 
        ' Where RecordType.name = \'EMAP Fuel Accounts\' ' +
        ' AND Id NOT IN ' + CREDIT_OVERRIDE_QUERY +
        ' AND Client_Id__c in (\'33\') ' +
        ' AND Status__c = \'1 - Active\' ' +
        ' AND Customer_Type__c = \'3 - Standard\' ' +
        ' AND Overdue_Days__c >='+ Integer.valueOf(Late_Payer_Days_SG) +
        ' AND AOT_Threshold_Exceeded__c = true';

    //Query to Re-instate GMSP Accounts automatically through Batch
    public final static String QUERY_GMSP_REACTIVATION = '' + 
        ' Select Id ' +
        ' From Account ' +
        ' Where RecordType.name = \'EMAP Fuel Accounts\' ' +
        ' AND Id NOT IN ' + CREDIT_OVERRIDE_QUERY +
        ' AND Client_Id__c in (\'30\',\'31\') ' +
        ' AND Status__c = \'3 - Stopped (blocked)\' ' +
        ' AND Account_Sub_Status__c = \'R - Delinquent (man.)\'' +
        ' AND Customer_Type__c = \'3 - Standard\' ' +
        ' AND AOT_Threshold_Exceeded__c = false ' +
        ' AND ( ' +
        '   ( ' +
        '       (Number_of_Late_Payments_Last_3_Months__c = null OR Number_of_Late_Payments_Last_3_Months__c < 2) ' +
        '       AND (Number_of_Dishonours_in_Last_3_Months__c = null OR Number_of_Dishonours_in_Last_3_Months__c < 2) ' +
        '       AND Risk_Grade__c in (\'0 - Limited Assessment\',\'2 - Very Low\',\'3 - Low\',\'4 - Medium\') ' +
        '   ) ' +
        '   OR ' +
        '   ( ' +
        '       (Number_of_Late_Payments_Last_3_Months__c = null OR Number_of_Late_Payments_Last_3_Months__c < 2) ' +
        '       AND (Number_of_Dishonours_in_Last_3_Months__c = null OR Number_of_Dishonours_in_Last_3_Months__c < 2) ' +
        '       AND Risk_Grade__c = \'5 - High\' ' +
        '       AND Percent_Secured__c >= 50 ' +
        '   ) ' +
        '   OR ' +
        '   ( ' +
        '   Percent_Secured__c >= 100 ' +
        '   ) ' +
        '   OR ' +
        '   ( ' +
        '       (Number_of_Late_Payments_Last_3_Months__c = null OR Number_of_Late_Payments_Last_3_Months__c < 2) ' +
        '       AND (Number_of_Dishonours_in_Last_3_Months__c = null OR Number_of_Dishonours_in_Last_3_Months__c < 2) ' +
        '       AND Hierarchy_Level__c = \'03\' AND ParentId <> null ' +
        '       AND Parent.Risk_Grade__c in (\'0 - Limited Assessment\',\'2 - Very Low\',\'3 - Low\',\'4 - Medium\') ' +
        '   ) ' +
        '   OR ' +
        '   ( ' +
        '       (Number_of_Late_Payments_Last_3_Months__c = null OR Number_of_Late_Payments_Last_3_Months__c < 2) ' +
        '       AND (Number_of_Dishonours_in_Last_3_Months__c = null OR Number_of_Dishonours_in_Last_3_Months__c < 2) ' +
        '       AND Hierarchy_Level__c = \'03\' AND ParentId <> null ' +
        '       AND Parent.Risk_Grade__c = \'5 - High\' ' +
        '       AND Parent.Percent_Secured__c >= 50 ' +
        '   ) ' +
        ' )';

    //Query to Re-instate HK Accounts automatically through Batch
    public final static String QUERY_HK_REACTIVATION = '' + 
        ' Select Id ' +
        ' From Account ' +
        ' Where RecordType.name = \'EMAP Fuel Accounts\' ' +
        ' AND Id NOT IN ' + CREDIT_OVERRIDE_QUERY +
        ' AND Client_Id__c in (\'32\') ' +
        ' AND Status__c = \'3 - Stopped (blocked)\' ' +
        ' AND Account_Sub_Status__c = \'R - Delinquent (man.)\'' +
        ' AND Customer_Type__c = \'3 - Standard\' ' +
        ' AND AOT_Threshold_Exceeded__c = false ' +
        ' AND ( ' +
        '   ( ' +
        '       (Number_of_Late_Payments_Last_3_Months__c = null OR Number_of_Late_Payments_Last_3_Months__c < 2) ' +
        '       AND (Number_of_Dishonours_in_Last_3_Months__c = null OR Number_of_Dishonours_in_Last_3_Months__c < 2) ' +
        '       AND Risk_Grade__c in (\'0 - Limited Assessment\',\'2 - Very Low\',\'3 - Low\',\'4 - Medium\') ' +
        '   ) ' +
        '   OR ' +
        '   ( ' +
        '       (Number_of_Late_Payments_Last_3_Months__c = null OR Number_of_Late_Payments_Last_3_Months__c < 2) ' +
        '       AND (Number_of_Dishonours_in_Last_3_Months__c = null OR Number_of_Dishonours_in_Last_3_Months__c < 2) ' +
        '       AND Risk_Grade__c = \'5 - High\' ' +
        '       AND Percent_Secured__c >= 50 ' +
        '   ) ' +
        '   OR ' +
        '   ( ' +
        '   Percent_Secured__c >= 100 ' +
        '   ) ' +
        '   OR ' +
        '   ( ' +
        '       (Number_of_Late_Payments_Last_3_Months__c = null OR Number_of_Late_Payments_Last_3_Months__c < 2) ' +
        '       AND (Number_of_Dishonours_in_Last_3_Months__c = null OR Number_of_Dishonours_in_Last_3_Months__c < 2) ' +
        '       AND Hierarchy_Level__c = \'03\' AND ParentId <> null ' +
        '       AND Parent.Risk_Grade__c in (\'0 - Limited Assessment\',\'2 - Very Low\',\'3 - Low\',\'4 - Medium\') ' +
        '   ) ' +
        '   OR ' +
        '   ( ' +
        '       (Number_of_Late_Payments_Last_3_Months__c = null OR Number_of_Late_Payments_Last_3_Months__c < 2) ' +
        '       AND (Number_of_Dishonours_in_Last_3_Months__c = null OR Number_of_Dishonours_in_Last_3_Months__c < 2) ' +
        '       AND Hierarchy_Level__c = \'03\' AND ParentId <> null ' +
        '       AND Parent.Risk_Grade__c = \'5 - High\' ' +
        '       AND Parent.Percent_Secured__c >= 50 ' +
        '   ) ' +
        ' )';

    //Query to Re-instate SG Accounts automatically through Batch
    public final static String QUERY_SG_REACTIVATION = '' + 
        ' Select Id ' +
        ' From Account ' +
        ' Where RecordType.name = \'EMAP Fuel Accounts\' ' +
        ' AND Id NOT IN ' + CREDIT_OVERRIDE_QUERY +
        ' AND Client_Id__c in (\'33\') ' +
        ' AND Status__c = \'3 - Stopped (blocked)\' ' +
        ' AND Account_Sub_Status__c = \'R - Delinquent (man.)\'' +
        ' AND Customer_Type__c = \'3 - Standard\' ' +
        ' AND AOT_Threshold_Exceeded__c = false ' +
        ' AND ( ' +
        '   ( ' +
        '       (Number_of_Late_Payments_Last_3_Months__c = null OR Number_of_Late_Payments_Last_3_Months__c < 2) ' +
        '       AND (Number_of_Dishonours_in_Last_3_Months__c = null OR Number_of_Dishonours_in_Last_3_Months__c < 2) ' +
        '       AND Risk_Grade__c in (\'0 - Limited Assessment\',\'2 - Very Low\',\'3 - Low\',\'4 - Medium\') ' +
        '   ) ' +
        '   OR ' +
        '   ( ' +
        '       (Number_of_Late_Payments_Last_3_Months__c = null OR Number_of_Late_Payments_Last_3_Months__c < 2) ' +
        '       AND (Number_of_Dishonours_in_Last_3_Months__c = null OR Number_of_Dishonours_in_Last_3_Months__c < 2) ' +
        '       AND Risk_Grade__c = \'5 - High\' ' +
        '       AND Percent_Secured__c >= 50 ' +
        '   ) ' +
        '   OR ' +
        '   ( ' +
        '   Percent_Secured__c >= 100 ' +
        '   ) ' +
        '   OR ' +
        '   ( ' +
        '       (Number_of_Late_Payments_Last_3_Months__c = null OR Number_of_Late_Payments_Last_3_Months__c < 2) ' +
        '       AND (Number_of_Dishonours_in_Last_3_Months__c = null OR Number_of_Dishonours_in_Last_3_Months__c < 2) ' +
        '       AND Hierarchy_Level__c = \'03\' AND ParentId <> null ' +
        '       AND Parent.Risk_Grade__c in (\'0 - Limited Assessment\',\'2 - Very Low\',\'3 - Low\',\'4 - Medium\') ' +
        '   ) ' +
        '   OR ' +
        '   ( ' +
        '       (Number_of_Late_Payments_Last_3_Months__c = null OR Number_of_Late_Payments_Last_3_Months__c < 2) ' +
        '       AND (Number_of_Dishonours_in_Last_3_Months__c = null OR Number_of_Dishonours_in_Last_3_Months__c < 2) ' +
        '       AND Hierarchy_Level__c = \'03\' AND ParentId <> null ' +
        '       AND Parent.Risk_Grade__c = \'5 - High\' ' +
        '       AND Parent.Percent_Secured__c >= 50 ' +
        '   ) ' +
        ' )';
        
}