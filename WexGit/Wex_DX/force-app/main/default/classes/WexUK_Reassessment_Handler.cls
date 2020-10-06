public class WexUK_Reassessment_Handler {

  public  static Wex_UK_Configurable__c configVals =  getConfigurableValues();

  public static List<Credit_Assessment__c> createCreditAsmt(List<Account> accList) {

    List<Credit_Assessment__c> credAssmtLst = new List<Credit_Assessment__c>();

    for (Account acc : accList) {
      Credit_Assessment__c creditAss = new Credit_Assessment__c();
      creditAss.Account__c = acc.id;
      if (acc.Credit_Utilization__c >= configVals.Pre_HLA_Lower__c && acc.Credit_Utilization__c <= configVals.Pre_HLA_Upper__c ) {
        creditAss.Review_Type__c = 'PRE-HLA';
      } else if (acc.Credit_Utilization__c > configVals.HLA_Threshold__c) {
        creditAss.Review_Type__c = 'HLA';
      } else if (acc.Nird__c <= System.Today() + (Integer)configVals.Nird_Review__c) {
        creditAss.Review_Type__c = 'NIRD';
      }
      credAssmtLst.add(creditAss);

    }

    insert credAssmtLst;
    //Database.insert(credAssmtLst,false);
    return credAssmtLst;
  }



//Initial Validation
  //pass a list of accounts
  public static list<Account> ValidateAccounts(list<Account> accList, Map<id, Credit_Assessment__c> acctidAssmentMap) {
    system.debug('inside ValidateAccounts');
    //create the lists to add accounts to for passed and failed accounts
    List<Account> ValidAccts = new List<Account>();
    List<Account> inValidAccts = new List<Account>();
    List<Credit_Assessment__c> assmtList = new  List<Credit_Assessment__c>();
    Boolean Validation1;
    Boolean Validation2;
    Boolean Validation3;
    Boolean Validation4;
    Boolean Validation5;
    String FailedAutoMess1 = '';
    String FailedAutoMess2 = '';
    String FailedAutoMess3 = '';
    String FailedAutoMess4a = '';
    String FailedAutoMess4b = '';
    String FailedAutoMess4c = '';
    String FailedAutoMess5 = '';
    String Review_Type; //remove
    String Auto_Evaluation_Message; //remove
    for (Account currentAccount : accList) {
      Credit_Assessment__c assmt = acctidAssmentMap.get(currentAccount.id);

      Credit_Assessment__c CredAss  = [select id, Wes_Review_Id__c from Credit_Assessment__c where id = :assmt.id];
      system.debug(' CredAss.Wes_Review_Id__c ' +  CredAss.Wes_Review_Id__c + ' id'  + assmt.id );
      currentAccount.Wes_Review_Id__c = CredAss.Wes_Review_Id__c;
      currentAccount.Review_Type__c = assmt.Review_Type__c;
      Review_Type = assmt.Review_Type__c;
      Auto_Evaluation_Message = null;
      Validation1 = false;
      Validation2 = false;
      Validation3 = false;
      Validation4 = false;
      Validation5 = false;
      FailedAutoMess1 = '';
      FailedAutoMess2 = '';
      FailedAutoMess3 = '';
      FailedAutoMess4a = '';
      FailedAutoMess4b = '';
      FailedAutoMess4c = '';
      FailedAutoMess5 = '';

      //1
      //check if credit insurance object is present
      list<Credit_Insurance__c> creditInsCheck = [SELECT Id, Expiration_Date__c, Insured_limit__c FROM Credit_Insurance__c where Account__c = :currentAccount.id];
      /*   if(creditInsCheck.isEmpty())
             {
                 Validation1 = false;
                  FailedAutoMess1= 'There is no Credit Insurance Object.\r\n';
             }
         else{Validation1 = true;}*/

      if (creditInsCheck == null || creditInsCheck.isEmpty()) {
        Validation1 = true;
      } else {
        for (Credit_Insurance__c currentAccCreditInsCheck :  creditInsCheck ) {
          if (currentAccCreditInsCheck.Insured_limit__c > 0  && currentAccCreditInsCheck.Expiration_Date__c > Date.Today() ) {
            Validation1 = false;
            FailedAutoMess1 = 'There is Credit Insurance on account.\r\n';
          } else {Validation1 = true;}
        }
      }
      //2


      Account creditCheck = [SELECT Id, Overall_Credit_limit_WES__c, Security_Limit__c, Initial_Validation_Status__c, billingcountry, account_id__c    FROM Account where Account.id = :currentAccount.id];


      system.debug('currentAccount.name ' + currentAccount.name + 'Security_Limit__c ' + creditCheck.Security_Limit__c.setscale(2) + 'creditCheck.Overall_Credit_limit_WES__c '  +
                   creditCheck.Overall_Credit_limit_WES__c + ' creditCheck.Overall_Credit_limit_WES__c ' + creditCheck.Overall_Credit_limit_WES__c);


      if (creditCheck.Security_Limit__c.setscale(2) ==  creditCheck.Overall_Credit_limit_WES__c) {
        Validation2 = false;
        FailedAutoMess2 = 'Security Limit = Overall Credit Limit.\r\n';
      } else {Validation2 = true;}


      //3
      Decimal ConvertedCreditLimit = performCurrencyConversion(creditCheck.account_id__c, creditCheck.Overall_Credit_limit_WES__c);
      system.debug('ConvertedCreditLimit ' + ConvertedCreditLimit);
      if (ConvertedCreditLimit >= configVals.Overall_Cred_Lmt_threshold__c) {
        Validation3 = false;
        FailedAutoMess3 = 'Overall Credit Limit is >= ' + configVals.Overall_Cred_Lmt_threshold__c + '.\r\n';
      }

      else {Validation3 = true;}




      //4

      Account transactCheck = [SELECT Id, Original_Creation_Date__c, Account_First_Transaction_Date__c, Account_First_Invoicing_Date__c FROM Account where Account.id = :currentAccount.id limit 1];

      Validation4 = true;
      if (transactCheck.Account_First_Transaction_Date__c != null && transactCheck.Account_First_Transaction_Date__c >= Date.Today().addDays((Integer)configVals.Account_Dates__c) )  {
        Validation4 = false;
        FailedAutoMess4a = 'Account First Transaction Date >= ' + configVals.Account_Dates__c + ' Days.\r\n';
      } else {
        Validation4 = true;

      }
      //pick up teh first invoicing date from account and use that
      if (transactCheck.Account_First_Transaction_Date__c == null && transactCheck.Account_First_Invoicing_Date__c != null && transactCheck.Account_First_Invoicing_Date__c  >= Date.Today().addDays((Integer)configVals.Account_Dates__c) ) {
        Validation4 = false;
        FailedAutoMess4b = 'Account First Invoicing Date >= ' + configVals.Account_Dates__c + ' Days.\r\n';
      } else {
        if (Validation4 != false)
          Validation4 = true;

      }

      //Change it to account creation date on account object populated by ifcs
      system.debug('transactCheck.Original_Creation_Date__c ' + transactCheck.Original_Creation_Date__c + ' Date.Today().addDays(-90) ' + Date.Today().addDays((Integer)configVals.Account_Dates__c) );
      if (transactCheck.Account_First_Transaction_Date__c == null && transactCheck.Account_First_Invoicing_Date__c == null && transactCheck.Original_Creation_Date__c != null && transactCheck.Original_Creation_Date__c  >= Date.Today().addDays((Integer)configVals.Account_Dates__c) ) {

        Validation4 = false;
        FailedAutoMess4c = 'Account Creation Date >= ' + configVals.Account_Dates__c + ' Days.\r\n';
      } else {
        if (Validation4 != false)
          Validation4 = true;
      }

      //5

      list<Account_Status_History__c> statusCheck = [SELECT Id, Account_Status__c  FROM Account_Status_History__c WHERE (LastModifiedDate >= LAST_N_MONTHS:3 AND Account_Status__c not in ('1 - Active', '') AND Account__r.id = :currentAccount.id )];
      //  list<Account> statusCheck = [SELECT Id, Status__c  FROM Account WHERE (LastModifiedDate >= LAST_N_MONTHS:3 AND (Status__c = 'Prospect' OR Status__c = 'Inactive' OR Status__c = 'Terminated'OR Status__c = '3 - Stopped (blocked)'OR Status__c = '4 - Closed'OR Status__c = '5 - Write Off'OR Status__c = '9 - Temporary Locked'OR Status__c = 'Parent Controlled Lockout')AND Account.id= :currentAccount.id )];


      if (statusCheck.isEmpty() ) {
        Validation5 = true;
      } else {
        Validation5 = false;
        FailedAutoMess5 = 'Account has had a different status than Active within the last 3 months.\r\n';
      }


      if (Validation1 == true && Validation2 == true && Validation3 == true && Validation4 == true && Validation5 == true) {
        currentAccount.Initial_Validation_Status__c = 'PASS';
        ValidAccts.add(currentAccount);
      } else {
        if ( Review_Type == 'PRE-HLA' ) { /* CHECK LOGIC*/  //  if PRE-HLA  no manual review
        } else { //if NIRD of HLA
          /* CHECK LOGIC*/
          Auto_Evaluation_Message = FailedAutoMess1 + FailedAutoMess2 + FailedAutoMess3 +  FailedAutoMess5;
          system.debug('Auto_Evaluation_Message ' + Auto_Evaluation_Message);
          if (!Validation4) {
            Auto_Evaluation_Message = Auto_Evaluation_Message + FailedAutoMess4a + FailedAutoMess4b + FailedAutoMess4c ;
          }
          system.debug('Auto_Evaluation_Message final ' + Auto_Evaluation_Message);
          currentAccount.Initial_Validation_Status__c = 'Manual Review';
          assmt.Assessment_Status__c = 'Initial Validation Failed';
          currentAccount.Credit_Limit_Status__c = 'Pending Activity';
          currentAccount.Payment_History_Status__c = null;
          currentAccount.Risk_Grade_Criteria__c = null;
          currentAccount.forseva1__Credit_Review_Status__c = null;

          inValidAccts.add(currentAccount);
          system.debug('assmt ' + assmt);
          system.debug('currentAccount ' + currentAccount);

        }
      }

      system.debug('Auto_Evaluation_Message' + Auto_Evaluation_Message);
      assmt.Auto_Evaluation_Message__c = Auto_Evaluation_Message;
      assmtList.add(assmt);

    } //end (Account currentAccount:accList)
// update invalid accounts with manual review

    update inValidAccts;
    update assmtList;
    update ValidAccts;
    // Database.SaveResult[] srList =Database.update(inValidAccts);
    //Database.update(assmtList);

    return ValidAccts;      // Return All valid Accounts
  }// endValidateAccounts

//Initial Validation End


  public static void calculateExpiryDate(Account acc, Credit_Assessment__c creditAss) {
    //--------
    String riskGrade =  [select Risk_Grade_UK__c from account where id = :acc.id][0].Risk_Grade_UK__c;
    // Integer.valueOf(creditAss.Risk_Grade_UK__c);
    Integer creditAssRiskGrade = Integer.valueOf(riskGrade.substring(0, 1));
    if (creditAssRiskGrade <= 3) {
      acc.Nird__c =  System.today().addMonths((Integer)configVals.Expiry_date_lower__c) ;//24 risk grade is less than 3
    } else if (creditAssRiskGrade > 3) {
      acc.Nird__c = System.today().addMonths((Integer)configVals.Expiry_Date_upper__c) ; //12 risk grade is more than 3
    } else {
      //acc.forseva1__Credit_Limit_Expiration_Date__c = ;
    }
  }


  public static void calculateCreditUtilization(Account acc, Credit_Assessment__c creditAss) {

    Boolean result = false;

    if (creditAss.Review_Type__c == 'HLA' || creditAss.Review_Type__c == 'PRE-HLA') {
      //if(credit utilization for last 6 months each time  >= 50){
      List<Credit_Utilization_History__c> utilList = [Select Credit_Utilization__c
          from Credit_Utilization_History__c where lastmodifieddate > LAST_N_MONTHS:6 and account__c = :acc.id];

      Boolean isHighUtil = true;

      for (Credit_Utilization_History__c util : utilList) {
        if (util.Credit_Utilization__c < configVals.High_Cred_Util_limit__c) {
          isHighUtil = false;
          break;
        }
      }

      if (isHighUtil) {
        //acc.Credit_Limit_Status__c = 'Auto approved';
        creditAss.Assessment_Status__c = 'Batch Assesment Passed';
        creditAss.HLA_OR_PRE_HLA_Evalaution__c = true;
        //  calculateRiskGradeCriteria(acc, creditAss);
      } else {
        creditAss.Assessment_Status__c = 'Autolimit validation Failed';
        acc.Credit_Limit_Status__c = 'Pending Activity';
        creditAss.Auto_Evaluation_Message__c = (creditAss.Auto_Evaluation_Message__c == null ? '' :  creditAss.Auto_Evaluation_Message__c) + 'Credit Utilization Criteria Failed';
        creditAss.HLA_OR_PRE_HLA_Evalaution__c = false;
      }
      //}
    } else if (creditAss.Review_Type__c == 'NIRD') {
      //  calculateRiskGradeCriteria(acc, creditAss);
      creditAss.HLA_OR_PRE_HLA_Evalaution__c = false;
      creditAss.Assessment_Status__c = 'Batch Assesment Passed';
    }
  }

  /* public static void calculatePaymentHistoryDetails(Account acc, Credit_Assessment__c creditAss){
       if(creditAss.Return_Debit_6_months__c == true && creditAss.Overdue_6_months__c == true){
           creditAss.Payment_History_Validation__c = 'Pass';
       } else {
           creditAss.Payment_History_Validation__c = 'Fail';
       }
   }*/

  /* public static void calculateRiskGradeCriteria(Account acc, Credit_Assessment__c creditAss){
        Integer creditAssRiskGrade = Integer.valueOf(creditAss.Risk_Grade_UK__c);

        //--------created new field 'Risk_Grade_UK__c' picklist field for WEX UK
        if(creditAssRiskGrade <= 3 && creditAss.Auto_Increase_Count_3_months__c <= 3) {
                creditAss.Risk_Grade_Criteria__c = 'PASS';
        }
        //----Previous Risk Grade <= Current Risk Grades (Previous Risk grade should be calculated)
        else if(creditAssRiskGrade > 3 && acc.Previous_Risk_Grade__c < = acc.Risk_Grade__c) {
                creditAss.Risk_Grade_Criteria__c = 'PASS';
        } else if(creditAss.Auto_Increase_Count_3_months__c <= 1){
                creditAss.Risk_Grade_Criteria__c = 'PASS';
        } else {
            creditAss.Risk_Grade_Criteria__c = 'FAIL';
        }
    }*/

  public static void calculateResult(Account acc, Credit_Assessment__c creditAss, Account_Status_History__c history) {

    Boolean result = false;

    if (creditAss.Auto_Evaluation_Message__c == null) {
      creditAss.Auto_Evaluation_Message__c = '';

    }

    if (acc.Payment_History_Status__c == null) {
      acc.Payment_History_Status__c = 'FAIL';
      acc.Credit_Limit_Status__c = 'Pending Activity';

    }

    if (acc.Risk_Grade_Criteria__c == null) {
      acc.Risk_Grade_Criteria__c = 'FAIL';
      acc.Credit_Limit_Status__c = 'Pending Activity';

    }

    creditAss.Payment_History_Validation__c = acc.Payment_History_Status__c;
    creditAss.Risk_Grade_Criteria__c = acc.Risk_Grade_Criteria__c;

    system.debug('acc.Payment_History_Status__c ' + acc.Payment_History_Status__c + 'acc.Risk_Grade_Criteria__c ' + acc.Risk_Grade_Criteria__c );

    if (acc.Payment_History_Status__c.equals('FAIL')) {
      system.debug('inside if');
      creditAss.Assessment_Status__c = 'Autolimit validation Failed';
      creditAss.Auto_Evaluation_Message__c = creditAss.Auto_Evaluation_Message__c  + ' Payment Validation Failed ';
    }
    if (acc.Risk_Grade_Criteria__c.equals('FAIL')) {
      system.debug('inside if');
      creditAss.Assessment_Status__c = 'Autolimit validation Failed';
      creditAss.Auto_Evaluation_Message__c = creditAss.Auto_Evaluation_Message__c +  ' Risk Grade Criteria Failed ';
    }


    if (creditAss.Assessment_Status__c == 'Autolimit validation Failed' || creditAss.Assessment_Status__c == 'Initial Validation Failed' ) {
      system.debug('Before return');
      acc.Credit_Limit_Status__c = 'Pending Activity';
      return;

    } else if (creditAss.Review_Type__c == 'HLA' || creditAss.Review_Type__c == 'PRE-HLA') {
      creditAss.Assessment_Status__c = 'Batch Assesment Passed';
      Decimal creditAuthLimitEuro = performCurrencyConversion(acc.account_id__c, acc.Credit_authorised_limit__c);
      system.debug('creditAuthLimitEuro ' + creditAuthLimitEuro);
      if (creditAuthLimitEuro < configVals.Credit_Limit_Threshold__c) {
        acc.Recommended_credit_limit__c  = acc.Credit_authorised_limit__c + (acc.Credit_authorised_limit__c * 0.25);
        //conveting and checking recomemnded credit limit

        Decimal RecomCreditLimit = performCurrencyConversion(acc.account_id__c, acc.Recommended_credit_limit__c);
        if (RecomCreditLimit <= configVals.Credit_Limit_Threshold__c) {
          calculateExpiryDate(acc, creditAss);
          acc.Credit_Limit_Status__c = 'Auto approved';
          acc.Credit_authorised_limit__c =  acc.Recommended_credit_limit__c;
          result = true;
          history.Account__c = acc.id;
          history.Auto_Limit_Increased__c = true;
        } else {
          acc.Credit_Limit_Status__c = 'Pending Activity';
          result = false;
        }
      } else {
        acc.Credit_Limit_Status__c = 'Pending Activity';
        result = false;
      }
    } else if (creditAss.Review_Type__c == 'NIRD') {
      creditAss.Assessment_Status__c = 'Batch Assesment Passed';
      // if(acc.Credit_Utilization__c <= configVals.HLA_Threshold__c){//80
      calculateExpiryDate(acc, creditAss);
      acc.Credit_Limit_Status__c = 'Auto approved';
      result = true;
      //} else {
      //     acc.Credit_Limit_Status__c = 'Pending Activity';
      //     result = false;
      // }
    }

  }

  //used in WexUK_CreditReassessment_BatchClass
  public static void calculateAutolimitIncrease(Account acc) {

    list<Account_Status_History__c> histList = [Select Auto_Limit_Increased__c from Account_Status_History__c where Account__r.id = :acc.id and lastmodifieddate > LAST_N_MONTHS:3 ];

    integer counter = 0;

    if (histList != null && !histList.isEmpty()) {

      for (Account_Status_History__c acctHist : histList) {

        if (acctHist.Auto_Limit_Increased__c) {
          counter = counter + 1;
        }
      }

    }
    acc.AutoIncreaseCount3months__c = counter;

  }


  public static Decimal performCurrencyConversion(String AccountNumber, Decimal fieldToConvert) {


    Decimal convertedAmount = 0;

    String clientId = AccountNumber.substring(0, 3);

    system.debug('clientId ' + clientId);

    list<Currency_Conversion__c> cccList = [select Currency_Value_Euro__c from Currency_Conversion__c where Client_Id__c = :clientId limit 1 ];
    Currency_Conversion__c ccc = null;

    if (cccList != null && !cccList.isEmpty()) {
      ccc = cccList[0];
    } else {
      ccc = new Currency_Conversion__c();
      ccc.Currency_Value_Euro__c = 0;
    }

    system.debug('Currency_Conversion__c ccc ' + ccc);

    system.debug('fieldToConvert ' + fieldToConvert);

    if (ccc != null && ccc.Currency_Value_Euro__c != null && ccc.Currency_Value_Euro__c != 0) {
      convertedAmount = fieldToConvert / ccc.Currency_Value_Euro__c;
    } else {
      convertedAmount = fieldToConvert;
    }

    system.debug('convertedAmount ' + convertedAmount);
    return convertedAmount;
  }

  public static Wex_UK_Configurable__c getConfigurableValues() {

    Map<String, Wex_UK_Configurable__c> mapWex_UK_Configurable = Wex_UK_Configurable__c.getAll();
    if (mapWex_UK_Configurable.get('Wex UK') != null) {
      configVals = mapWex_UK_Configurable.get('Wex UK');
    } else {
      //   throw new Exception('Custom Settinngs unavialable');
    }

    return configVals;
  }


  public static void updateIsParentOverdue(List<Wes_Accounts_Receivable__c> listAccRec) 
  {
 
    String[] parentAccountIds = new String[]{};
    
     for (Wes_Accounts_Receivable__c accountRcbl : listAccRec) 
     {
         if(String.isNotBlank(accountRcbl.Ultimate_Parent_External_Id__c))
         {
            parentAccountIds.add(accountRcbl.Ultimate_Parent_External_Id__c);
         }
    } 
    
    if(!parentAccountIds.isEmpty())
    {
        Account[] parentAccounts = [SELECT ID FROM Account WHERE Account_Id__c IN : parentAccountIds];
        
        AggregateResult[] countResult = [SELECT  Account__c, count(Name) cnt from Wes_Accounts_Receivable__c WHERE Account__c = :parentAccounts AND  isOverdue__c = true GROUP BY Account__c];
        
        Account[] parentAccountsToBeUpdated = new Account[]{};
        for (AggregateResult ar : countResult)  
        {
            Id accountId = (Id) ar.get('Account__c');
            
            if(((Integer)ar.get('cnt')) > 0)
            {
                parentAccountsToBeUpdated.add(new Account(Id = accountId , Overdue_6_months__c = true));
            }
            else
            {
                parentAccountsToBeUpdated.add(new Account(Id = accountId , Overdue_6_months__c = false));
            }
        }
        
        update parentAccountsToBeUpdated;
        
    }
     
    }


  /*public static Map<Account, list<Account>> findAccountTree(List<Account> childAcct) {

    Map<Account, list<Account>> accAccMap = new Map<Account, list<Account>>();
    if (childAcct == null || childAcct.isEmpty()) {
      return accAccMap;
    }

    Account parentAcc = null;
    set<Account> parentAccountSet = new set<Account>();
    Account ultimateParent = null;
    set<Account> UltparentAccountSet = new set<Account>();

    for (Account acct : childAcct) {
      system.debug('acct ' + acct);
      ultimateParent = findUltimateParent(acct);
      system.debug('ultimateParent ' + ultimateParent);
      UltparentAccountSet.add(ultimateParent);
    }

    system.debug('UltparentAccountSet ' + UltparentAccountSet);

    for (Account utlParent : UltparentAccountSet) {
      accAccMap.put(utlParent, getHeirarchDetails(utlParent));
    }

    return accAccMap;
  }

  public static Account findUltimateParent(Account anyAccount) {
    anyAccount = [select id, name, parentid, Overdue_6_months__c, Overall_Balance__c,
                  Summary_of_Invoices_Overdue__c, Summary_of_Invoices_Not_Due__c, Summary_of_Unallocated_Payments__c,
                  Summary_of_Uninvoiced_Customer_Trans__c, Currency__c  from account where id = :anyAccount.id];
    system.debug('anyAccount ' + anyAccount);

    Account parentAcc = [Select id, name, ParentId, Overdue_6_months__c, Overall_Balance__c,  Summary_of_Invoices_Overdue__c, Summary_of_Invoices_Not_Due__c, Summary_of_Unallocated_Payments__c,
                         Summary_of_Uninvoiced_Customer_Trans__c, Currency__c  from account where id = :anyAccount.id];

    Account ultimateParent = null;
    Account currentAcct  =  null;

    if (parentAcc.parentid != null) {
      while (parentAcc.parentid != null ) {
        parentAcc = [Select id, name, ParentId, Overdue_6_months__c, Overall_Balance__c,   Summary_of_Invoices_Overdue__c, Summary_of_Invoices_Not_Due__c, Summary_of_Unallocated_Payments__c,
                     Summary_of_Uninvoiced_Customer_Trans__c, Currency__c from account where id = :parentAcc.parentid];
        system.debug('parentAcc ' + parentAcc);
        if (parentAcc.parentid == null) {
          ultimateParent = parentAcc;
        }
      }
    } else {
      ultimateParent = anyAccount;
    }

    return ultimateParent;

  }


  public static List<Account> getHeirarchDetails(Account ultimateParent) {
    List<Account> totalAcctList = new List<Account>();

    List<Account> accountList = [select id, Overdue_6_months__c, name,    Summary_of_Invoices_Overdue__c, Summary_of_Invoices_Not_Due__c, Summary_of_Unallocated_Payments__c,
                                 Summary_of_Uninvoiced_Customer_Trans__c, Currency__c from account where parentid = :ultimateParent.id];

    if (accountList != null && !accountList.isempty()) {
      totalAcctList.addAll(accountList);
    } else {
      totalAcctList.add(ultimateParent);
    }

    list<Id> parentids = new List<id>();

    while (accountList != null && !accountList.isempty()) {

      for (Account acct : accountList) {
        parentids = new list<id>();
        parentids.add(acct.id);
      }
      accountList = [select id , Overdue_6_months__c,  parentId, Summary_of_Invoices_Overdue__c, Summary_of_Invoices_Not_Due__c, Summary_of_Unallocated_Payments__c,
                     Summary_of_Uninvoiced_Customer_Trans__c, Currency__c from account where parentid = :parentids];

      if (accountList != null && !accountList.isempty())
        totalAcctList.addAll(accountList);
    }

    return totalAcctList;
  }*/
}