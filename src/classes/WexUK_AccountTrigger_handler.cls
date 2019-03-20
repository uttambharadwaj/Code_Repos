public with sharing class WexUK_AccountTrigger_handler {

  /* public static Decimal temp1=0;
   public static Decimal temp2=0;
   public static Decimal temp3=0;
   public static Decimal temp5=0;
   public static Decimal temp6=0;*/

  public static boolean hasExecutedOnce = false;
  public static boolean hasExecutedOnceCredUtil = false;


  public static void  handleApprovalProcess(List<Account> acctlist, List<Account> oldAcctList) {
    User currentUser = null;
    system.debug('acctlist ' + acctlist);

    //list<RecordType> rtList = [SELECT Id, recordtype.name from RecordType WHERE sObjectType = 'Account' and recordtype.name = 'WES Accounts'];
  
  Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WES Accounts').getRecordTypeId();

    //list<account> tbuAccount = new List<account>();
    Map<id, account> oldAcctmap = new Map<id, account>();

    for (Account acctold : oldAcctList) {

      oldAcctmap.put(acctold.id, acctold);
    }

  currentUser = [select ManagerID, WES_Approval_Threshold__c from user where id = :UserInfo.getUserId() limit 1 ];
  
    for (Account acct : acctlist) {

      //system.debug('acct.recordtype.name ' + acct.recordtype.name);
      //system.debug('acct.Auth_Node_Indicator__c '  + acct.Auth_Node_Indicator__c);

      //if (rtList != null && !rtList.isEmpty() && acct.recordtypeid == rtList[0].id && acct.Auth_Node_Indicator__c == 'Y' && acct.Credit_Limit_Status__c != oldAcctmap.get(acct.id).Credit_Limit_Status__c ) {
      if (acct.recordtypeid == rtId && acct.Auth_Node_Indicator__c == 'Y' && acct.Credit_Limit_Status__c != oldAcctmap.get(acct.id).Credit_Limit_Status__c ) {
      
        system.debug('UserInfo.getUserId() ' + UserInfo.getUserId());

        
        //add condition to check if the user is not dataloader or API user
        if (acct.Credit_Limit_Status__c == 'Approved' &&  acct.Recommended_credit_limit__c > currentUser.WES_Approval_Threshold__c && currentUser.WES_Approval_Threshold__c != 0 ) {
          acct.Credit_Limit_Status__c = 'Referred to higher authority';
          if (currentUser.ManagerID != null) {
            acct.Assigned_to__c = currentUser.ManagerID; //[select name from user where id = :currentUser.ManagerID].name;
          } else {
            //throw some error to user
          }

        } else if (acct.Credit_Limit_Status__c == 'Approved' &&  (currentUser.WES_Approval_Threshold__c == 0 || acct.Recommended_credit_limit__c <= currentUser.WES_Approval_Threshold__c ) ) {

          acct.Credit_authorised_limit__c = acct.Recommended_credit_limit__c;
        }
        //tbuAccount.add(acct);
      }

    }

    //update tbuAccount;
  }

  public static void sendWesToIFCS(List<Account> acctNewlist) {

    for (Account Acct : acctNewlist) {
      Acct.Send_WES_to_IFCS__c = true;
    }

  }

  public static void createCreditUtilizationHistory(Map<Id, Account> oldAccMap, Map<Id, Account> newAccMap) {

    //list<RecordType> rtList = [SELECT Id, recordtype.name from RecordType WHERE sObjectType = 'Account' and recordtype.name = 'WES Accounts'];
  
  Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WES Accounts').getRecordTypeId();

    List<Credit_Utilization_History__c> toInsertCreditUtilizationHistories = new List<Credit_Utilization_History__c>();

    Credit_Utilization_History__c credutil;

    for (Account ultParAcc : newAccMap.values()) {

      //if (rtList != null && !rtList.isEmpty() && ultParAcc.recordtypeid == rtList[0].id && ultParAcc.Auth_Node_Indicator__c == 'Y' && ultParAcc.parentid == null && (oldAccMap == null || (oldAccMap != null && (ultParAcc.Overall_Balance__c != oldAccMap.get(ultParAcc.id).Overall_Balance__c || ultParAcc.Overall_Credit_limit_WES__c != oldAccMap.get(ultParAcc.id).Overall_Credit_limit_WES__c) ))) {
      if (rtId != null &&  ultParAcc.recordtypeid == rtId && ultParAcc.Auth_Node_Indicator__c == 'Y' && ultParAcc.parentid == null && (oldAccMap == null || (oldAccMap != null && (ultParAcc.Overall_Balance__c != oldAccMap.get(ultParAcc.id).Overall_Balance__c || ultParAcc.Overall_Credit_limit_WES__c != oldAccMap.get(ultParAcc.id).Overall_Credit_limit_WES__c) ))) {
          credutil = new Credit_Utilization_History__c(Account__c = ultParAcc.id,
              Overall_Balance__c = ultParAcc.Overall_Balance__c,
              CurrencyIsoCode = ultParAcc.CurrencyIsoCode,
              Overall_Credit_limit__c = ultParAcc.Overall_Credit_limit_WES__c == NULL ? 0 : ultParAcc.Overall_Credit_limit_WES__c);

          toInsertCreditUtilizationHistories.add(credutil);
        
      }
    }

    if (!toInsertCreditUtilizationHistories.isEmpty()) {
      insert toInsertCreditUtilizationHistories;
    }

  }


//Also updates the Credit Utilization
  public static void updateAccounthistoryAndCreditUtil(List<Account> acctlist, List<Account> oldAcctList, map<id, account> oldAccMap) {

    //if (hasExecutedOnce == true)
    // return;

    hasExecutedOnce = true;
    //list<RecordType> rtList = [SELECT Id, recordtype.name from RecordType WHERE sObjectType = 'Account' and recordtype.name = 'WES Accounts'];
  Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WES Accounts').getRecordTypeId();

    Account_Status_History__c history = null;
    list<Account_Status_History__c> historyList = new list<Account_Status_History__c>();

    Map<id, account> oldAcctmap = new Map<id, account>();

    if (oldAcctList != null) {
      for (Account acctold : oldAcctList) {

        oldAcctmap.put(acctold.id, acctold);

      }
    }

    for (Account acct : acctlist) {
      //if(rtList != null && !rtList.isEmpty() && acct.recordtypeid == rtList[0].id){

      //if (rtList != null && !rtList.isEmpty() && acct.recordtypeid == rtList[0].id && ( oldAcctmap.get(acct.id) == null || oldAcctmap.get(acct.id).Status__c !=  acct.Status__c )) {
    if (rtId != null &&   acct.recordtypeid == rtId && ( oldAcctmap.get(acct.id) == null || oldAcctmap.get(acct.id).Status__c !=  acct.Status__c )) {  
        history = new Account_Status_History__c();
        history.Account__c = acct.id;
        //history.Account_Blocked__c = true;
        history.Account_Status__c = acct.Status__c;
        historyList.add(history);
      }

      //update Credit Utilization
      //if (rtList != null && !rtList.isEmpty() && acct.recordtypeid == rtList[0].id && acct.parentid == null && acct.Overall_Credit_limit_WES__c != null && acct.Overall_Credit_limit_WES__c != 0 && acct.Overall_Balance__c != null  &&
    
    if (rtId != null &&  acct.recordtypeid == rtId && acct.parentid == null && acct.Overall_Credit_limit_WES__c != null && acct.Overall_Credit_limit_WES__c != 0 && acct.Overall_Balance__c != null  &&
          (oldAccMap == null || (acct.Overall_Balance__c != oldAccMap.get(acct.id).Overall_Balance__c) || (acct.Overall_Credit_limit_WES__c != oldAccMap.get(acct.id).Overall_Credit_limit_WES__c) )) {
        Decimal toRound =  (acct.Overall_Balance__c / acct.Overall_Credit_limit_WES__c) * 100;
        acct.Credit_Utilization__c =  toRound.setScale(2);
      }

    }

    insert historyList;
    updateAutolimitIncCount(acctlist);
  }


  public static void updateAutolimitIncCount(List<Account> acctlist) {



    AggregateResult[] autolimitCheck = [Select  count(id) autoInc, account__c from Account_Status_History__c  where Auto_Limit_Increased__c = true and account__c = :acctlist  group by account__c];

    Map<id, Integer> accountMap = new  Map<id, Integer>();

    for (AggregateResult ar : autolimitCheck) {
      accountMap.put((id)ar.get('account__c'), (Integer) ar.get('autoInc'));
    }

    for (Account acc : acctlist) {
      acc.AutoIncreaseCount3months__c = accountMap.get(acc.id) == null ? 0 : accountMap.get(acc.id);
    }

  }


  /*public static void addCreditPolicy(List<Account> acctlist) {

    List<forseva1__CreditPolicy__c> cpDNB = [select id, forseva1__First_Lookup_Confidence_Threshold__c from forseva1__CreditPolicy__c where name = 'Dun And Bradstreet'];

    List<forseva1__CreditPolicy__c> cpEfx = [select id, forseva1__First_Lookup_Confidence_Threshold__c from forseva1__CreditPolicy__c where name = 'Equifax'];

    list<RecordType> rtList = [SELECT Id, recordtype.name from RecordType WHERE sObjectType = 'Account' and recordtype.name = 'WES Accounts'];


    for (Account acct : acctlist) {

      if (rtList != null && !rtList.isEmpty() && acct.recordtypeid == rtList[0].id) {
        if (acct.billingCountry == 'GB') {

          acct.forseva1__Credit_Policy__c = cpEfx[0].id;

        } else {
          acct.forseva1__Credit_Policy__c = cpDNB[0].id;
        }

      }
    }

  }*/


  public static void addCreditPolicy(List<Account> acctlist) 
  {
  
  Id equifaxId;
  Id dnbId;
  String dnb = Label.Wes_UK_DnBCredit_policy;
  
  String equifax = Label.Wes_UK_Equifax_Credit_policy;
  
  String[] policies = new String[]{dnb, equifax};
  
  for(forseva1__CreditPolicy__c rec :  [select id, Name, forseva1__First_Lookup_Confidence_Threshold__c from forseva1__CreditPolicy__c where name IN : policies])
  {
    if(rec.Name == equifax)
    {
      equifaxId = rec.Id;
    }
    else if(rec.Name == dnb)
    {
      dnbId = rec.Id;
    }
  }

    

    Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WES Accounts').getRecordTypeId();


    for (Account acct : acctlist) 
  {

      if (rtId != null && acct.recordtypeid == rtId) 
    {
        if (acct.billingCountry == 'GB') 
    {

          acct.forseva1__Credit_Policy__c = equifaxId;

        } else {
          acct.forseva1__Credit_Policy__c = dnbId;
        }

      }
    }

  }


  /*
  public static void doReviewAudit(List<Account> oldAccountList, List<account> newAccountList, map<id, account> oldIdAccountMap) {

    list<RecordType> rtList = [SELECT Id, recordtype.name from RecordType WHERE sObjectType = 'Account' and recordtype.name = 'WES Accounts'];

    User currentUser = [select Username, ProfileId , name , id from user where id = :UserInfo.getUserId()];

    Profile userProfile = [select name from Profile where id = :currentUser.ProfileId];

    Account oldAccount = null;
    Review_Status_Audit__c audit = null;
    list<Review_Status_Audit__c> latestStatusList = null;
    Review_Status_Audit__c previousLatesStatus = null;
    list<Review_Status_Audit__c> auditList = new list<Review_Status_Audit__c>();

    for (Account newAccount : newAccountList) {
      oldAccount = oldIdAccountMap.get(newAccount.id);
      previousLatesStatus = null;
      if (rtList != null && !rtList.isEmpty() && newAccount.recordtypeid == rtList[0].id &&
          ( newAccount.Credit_Limit_Status__c != oldAccount.Credit_Limit_Status__c || newAccount.Assigned_to__c != oldAccount.Assigned_to__c)) {

        latestStatusList = [select id, Review_End_Date_Time__c, IsLatest__c, Account__c from Review_Status_Audit__c where Account__c = :newAccount.id and IsLatest__c = true limit 1 ];

        if (latestStatusList != null && !latestStatusList.Isempty()) {
          previousLatesStatus = latestStatusList[0];
        }


        audit = new Review_Status_Audit__c();
        audit.Account__c = newAccount.id;
        audit.Wes_Review_Id__c = newAccount.Wes_Review_Id__c;
        audit.IsLatest__c = true;
        audit.Account_Status_Before_Review__c = oldAccount.Status__c;
        audit.Account_Status_After_Review__c = newAccount.Status__c;
        audit.Account_Sub_Status_After_Review__c = newAccount.Account_Sub_Status__c;
        audit.Account_Sub_Status_Before_Review__c = oldAccount.Account_Sub_Status__c;
        audit.Billing_Frequency_After_Review__c = newAccount.Billing_Frequency__c;
        audit.Billing_Frequency_Before_Review__c = oldAccount.Billing_Frequency__c;
        audit.Credit_Expiration_Date_After_Review__c = String.valueOf(newAccount.Nird__c);
        audit.Credit_Expiration_Date_Before_Review__c = String.valueOf(oldAccount.Nird__c);
        audit.Current_Risk_Grade_After_Review__c = newAccount.Risk_Grade_UK__c;
        audit.Current_Risk_Grade_Before_Review__c = oldAccount.Risk_Grade_UK__c;
        //  audit.Insurance_Expiry_Date__c =
        // audit.Insurance_Policy_Name__c
        //audit.Insurance_Start_Date__c
        audit.Credit_Utilisation__c = newAccount.Credit_Utilization__c;
        audit.Insured_Limit_After_Review__c = String.valueOf(newAccount.Insured_limit__c);
        audit.Insured_Limit_Before_Review__c = String.valueOf(oldAccount.Insured_limit__c);
        audit.Overall_Credit_Limit_After_Review__c = String.valueOf(newAccount.Overall_Credit_limit_WES__c);
        audit.Overall_Credit_Limit_Before_Review__c = String.valueOf(oldAccount.Overall_Credit_limit_WES__c);
        audit.Billing_Plan_After_Review__c = newAccount.Billing_Plan__c;
        audit.Billing_Plan_Before_Review__c = oldAccount.Billing_Plan__c;
        audit.Previous_Risk_Grade__c = newAccount.Previous_Risk_Grade__c;
        audit.Review_Date__c = System.Today();
        audit.Review_End_Date_Time__c = System.now();
        if (previousLatesStatus != null) {
          audit.Review_Start_Date_Time__c = previousLatesStatus.Review_End_Date_Time__c;
        } else {
          audit.Review_Start_Date_Time__c =    System.now();
        }//Current time in GMT

        audit.Duration_Ex_holidays__c = calculateDurationExHolidays(audit.Review_Start_Date_Time__c, audit.Review_End_Date_Time__c, newAccount.Account_Id__c.substring(0, 3));
        audit.Review_Status__c = newAccount.Credit_Limit_Status__c;
        audit.Review_Type__c = newAccount.Review_Type__c;
        // audit.Security_Date_Received__c =
        // audit.Security_Date_Requested__c
        //audit.Security_Limit_After_Review__c
        //audit.Security_Limit_Before_Review__c
        //audit.Security_Type_After_Review__c
        //audit.Security_Type_Before_Review__c
        audit.User_Name__c = currentUser.name;
        audit.User_Role__c = userProfile.name;
        audit.User__c = currentUser.id;
        auditList.add(audit);

        if (previousLatesStatus != null) {
          previousLatesStatus.IsLatest__c = false;
          auditList.add(previousLatesStatus);
        }


      }
    }

    //Database.upsert(auditList, false);
    system.debug('auditList ' +  auditList);
    upsert auditList;

  }
  */
  
  
  public static void doReviewAudit(List<Account> oldAccountList, List<account> newAccountList, map<id, account> oldIdAccountMap) {

    Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WES Accounts').getRecordTypeId();

    Profile userProfile = [select name from Profile where id = :UserInfo.getProfileId()];

    Account oldAccount = null;
    Review_Status_Audit__c audit = null;
    list<Review_Status_Audit__c> latestStatusList = null;
    Review_Status_Audit__c previousLatesStatus = null;
    list<Review_Status_Audit__c> auditList = new list<Review_Status_Audit__c>();

    Account[] eligibleAccountForReviewStatusAudit = new Account[]{};
    String[] clientIdList = new String[]{};
    for (Account newAccount : newAccountList) 
    {
        oldAccount = oldIdAccountMap.get(newAccount.Id);
        if (rtId != null && newAccount.recordtypeid == rtId && oldAccount != null && 
          ( newAccount.Credit_Limit_Status__c != oldAccount.Credit_Limit_Status__c || newAccount.Assigned_to__c != oldAccount.Assigned_to__c)) 
          {
             eligibleAccountForReviewStatusAudit.add(newAccount); 
             
             if(String.isNotBlank(newAccount.Account_Id__c))
             {
                clientIdList.add(newAccount.Account_Id__c.substring(0, 3));
             }
          }
              
    }
    
    Map<String, Holiday__c[]> mapOfHolidayListByClientId = new Map<String, Holiday__c[]> ();
    
    if(!clientIdList.isEmpty())
    {
        for (Holiday__c rec : [Select Client_Id__c, Holiday_Date__c from Holiday__c where Client_Id__c   in: clientIdList])
        {
            Holiday__c[] holidayList = mapOfHolidayListByClientId.get(rec.Client_Id__c);
            
            if(holidayList != null)
            {
                holidayList.add(rec);
            }
            else
            {
                holidayList = new Holiday__c[]{rec};
                mapOfHolidayListByClientId.put(rec.Client_Id__c, holidayList);
            }
        }
    }
    
    
    Map<Id, Review_Status_Audit__c> mapofReviewStatusAuditByAccountId = new Map<Id, Review_Status_Audit__c>();
    
    if(!eligibleAccountForReviewStatusAudit.isEmpty())
    {
        for(Review_Status_Audit__c rec : [select id, Review_End_Date_Time__c, IsLatest__c, Account__c from Review_Status_Audit__c where Account__c in :eligibleAccountForReviewStatusAudit and IsLatest__c = true ])
        {
            mapofReviewStatusAuditByAccountId.put(rec.Account__c, rec);
        }
    }
    
    for (Account newAccount : newAccountList) 
    {
      oldAccount = oldIdAccountMap.get(newAccount.id);
      previousLatesStatus = null;
      if (rtId != null && newAccount.recordtypeid == rtId && oldAccount != null && 
          ( newAccount.Credit_Limit_Status__c != oldAccount.Credit_Limit_Status__c || newAccount.Assigned_to__c != oldAccount.Assigned_to__c)) 
      {
            Review_Status_Audit__c lastReviewStatusAudit = mapofReviewStatusAuditByAccountId.get(newAccount.Id);
            
            audit = new Review_Status_Audit__c();
            auditList.add(audit);
            
            if ( lastReviewStatusAudit != null ) 
            {
                audit.Review_Start_Date_Time__c = lastReviewStatusAudit.Review_End_Date_Time__c;
                lastReviewStatusAudit.IsLatest__c = false;
                auditList.add(lastReviewStatusAudit);
            } 
            else 
            {
                audit.Review_Start_Date_Time__c =    System.now();
            }
            
            audit.Account__c = newAccount.id;
            audit.Wes_Review_Id__c = newAccount.Wes_Review_Id__c;
            audit.IsLatest__c = true;
            audit.Account_Status_Before_Review__c = oldAccount.Status__c;
            audit.Account_Status_After_Review__c = newAccount.Status__c;
            audit.Account_Sub_Status_After_Review__c = newAccount.Account_Sub_Status__c;
            audit.Account_Sub_Status_Before_Review__c = oldAccount.Account_Sub_Status__c;
            audit.Billing_Frequency_After_Review__c = newAccount.Billing_Frequency__c;
            audit.Billing_Frequency_Before_Review__c = oldAccount.Billing_Frequency__c;
            audit.Credit_Expiration_Date_After_Review__c = String.valueOf(newAccount.Nird__c);
            audit.Credit_Expiration_Date_Before_Review__c = String.valueOf(oldAccount.Nird__c);
            audit.Current_Risk_Grade_After_Review__c = newAccount.Risk_Grade_UK__c;
            audit.Current_Risk_Grade_Before_Review__c = oldAccount.Risk_Grade_UK__c; 
            audit.Credit_Utilisation__c = newAccount.Credit_Utilization__c;
            audit.Insured_Limit_After_Review__c = String.valueOf(newAccount.Insured_limit__c);
            audit.Insured_Limit_Before_Review__c = String.valueOf(oldAccount.Insured_limit__c);
            audit.Overall_Credit_Limit_After_Review__c = String.valueOf(newAccount.Overall_Credit_limit_WES__c);
            audit.Overall_Credit_Limit_Before_Review__c = String.valueOf(oldAccount.Overall_Credit_limit_WES__c);
            audit.Billing_Plan_After_Review__c = newAccount.Billing_Plan__c;
            audit.Billing_Plan_Before_Review__c = oldAccount.Billing_Plan__c;
            audit.Previous_Risk_Grade__c = newAccount.Previous_Risk_Grade__c;
            audit.Review_Date__c = System.Today();
            audit.Review_End_Date_Time__c = System.now();
            //audit.Duration_Ex_holidays__c = calculateDurationExHolidays(audit.Review_Start_Date_Time__c, audit.Review_End_Date_Time__c, newAccount.Account_Id__c.substring(0, 3));
            audit.Duration_Ex_holidays__c = calculateDurationExHolidays(newAccount, mapOfHolidayListByClientId, audit);
            audit.Review_Status__c = newAccount.Credit_Limit_Status__c;
            audit.Review_Type__c = newAccount.Review_Type__c;
             audit.User_Name__c = UserInfo.getName();
            audit.User_Role__c = userProfile.name;
            audit.User__c = UserInfo.getUserId();
      }
      
      
    }

    upsert auditList;
    
    

  }
  
  private static Integer calculateDurationExHolidays(Account acc, Map<String, Holiday__c[]> mapOfHolidayListByClientId, Review_Status_Audit__c auditRecord) 
  {
    if(acc == null || auditRecord == null)
    {
        return 0;
    }
    
    
    Datetime reviewStart = auditRecord.Review_Start_Date_Time__c;
    Datetime reviewEnd = auditRecord.Review_End_Date_Time__c;
    Integer countOfDays = (auditRecord.Review_Start_Date_Time__c.date().daysbetween(auditRecord.Review_End_Date_Time__c.date())) ;
    
    Holiday__c[] holidayList = mapOfHolidayListByClientId.get(acc.Account_Id__c.substring(0, 3));
    
    Integer holidays = holidayList != null ? holidayList.size() : 0;
    
    countOfDays = countOfDays - holidays;
    
    while (reviewStart <= reviewEnd) 
    {

      reviewStart = reviewStart.addDays(1);
      String day = reviewStart.format('EEEE');
      if (day == 'Saturday' || day == 'Sunday') 
      {
        countOfDays--;
      }
    }
    
    return countOfDays < 0 ? 0 : countOfDays;
  }
      

  /*public static Integer calculateDurationExHolidays(DateTime reviewStart, DateTime reviewEnd, String clientId) {

    List<Holiday__c> holidayList = [Select name from Holiday__c where Holiday_Date__c <= :reviewEnd.date() and Holiday_Date__c > :reviewStart.date() and Client_Id__c = :clientId];
    Integer countOfDays = (reviewStart.date().daysbetween(reviewEnd.date())) ;
    String day = null;
    Integer weekendCount = 0;

    while (reviewStart <= reviewEnd) {

      reviewStart = reviewStart.addDays(1);
      day = reviewStart.format('EEEE');
      if (day == 'Saturday' || day == 'Sunday') {
        weekendCount = weekendCount + 1;
      }
    }

    Integer Holidays = 0;

    if (holidayList != null && !holidayList.isEmpty()) {
      Holidays = holidayList.size();
    }

    Holidays = Holidays + weekendCount;

    countOfDays = countOfDays - Holidays;
    if (countOfDays < 0) {
      countOfDays = 0;
    }
    return countOfDays;

  }*/


}