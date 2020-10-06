// revision history https://gist.github.com/aplssf/738275715bc4d0a51c0fdb62a87e470b/revisions
// previous revisions https://gist.github.com/aplssf/8e9cf9147c2bf499d0c4
@isTest
public class WE_TestDataUtility {

  public static User createStandardUser() {

  Profile p1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

    // create User
    User u = new User();

    u.ProfileId         = p1.Id;
    u.FirstName         = 'Alex';
    u.LastName          = 'Sherwood';
    u.Email             = 'test@wexeurope.com';
    u.Username          = 'astest@wexeurope.com';
    u.Alias             = 'astest';
    u.TimeZoneSidKey    = 'America/Denver';
    u.LocaleSidKey      = 'en_US';
    u.EmailEncodingKey  = 'UTF-8';
    u.LanguageLocaleKey = 'en_US';
    system.debug('user config is ' + u);

    return u;
  }
    
    public static VApexC__c createApexControllerCustSett(
    string  fieldRef,
    boolean settingStatus)
    {
      User u = [SELECT Id FROM User WHERE Username = 'astest@wexeurope.com'];

      //create Apex Controller Custom Setting
      VApexC__c cs = new VApexC__c();

      cs.SetupOwnerId = u.Id;

      if (fieldRef == 'Opportunity MRF') {
        cs.Name                             = 'Opportunity Forecast Disabled';
        cs.Opportunity_Forecast_Disabled__c = settingStatus;
      }
      else if (fieldRef == 'Target Manager') {
        cs.Name                             = 'Target Manager Disabled';
        cs.Target_Manager_Disabled__c       = settingStatus;
      }
      else if (fieldRef == 'Budget Manager') {
        cs.Name                             = 'Budget Manager Disabled';
        cs.BudgetManagerDisabled__c         = settingStatus;
      }
      else if (fieldRef == 'Domain Match') {
        cs.Name                             = 'Domain Match Disabled';
        cs.DomainMatchDisabled__c           = settingStatus;
      }
      else if (fieldRef == 'Net FSR') {
        cs.Name                             = 'Net FSR Calculation Disabled';
        cs.Net_FSR_Disabled__c              = settingStatus;
      }
/*
      else if (fieldRef == 'Spam Filter') {
        cs.Name                             = 'Spam Filter Disabled';
        cs.Spam_Filter_Disabled__c          = settingStatus;
      }
*/
      else if (fieldRef == 'Project Creation') {
        cs.Name                             = 'Project Creation Disabled';
        cs.ProjectCreationDisabled__c       = settingStatus;
      }
      system.debug('WE_TestDataUtility: Apex Controller setting is ' + cs);

      return cs;
    }

  public static VRTN__c createRecTypeNameCustSett(
  string rtName,
  string csFieldRef) {

    // create Record Type Name Custom Setting
      VRTN__c cs = new VRTN__c();
      
      cs.Name = rtName;
      if (csFieldRef == 'EU Opps') {
          cs.EUOpps__c = rtName;
      }
      else if (csFieldRef == 'NA Opps') {
          cs.NAOpps__c = rtName;
      }
      else if (csFieldRef == 'NAEU Opps') {
          cs.NAEUOpps__c = rtName;
      }
      else if (csFieldRef == 'Virtual AU Opps') {
          cs.AuOpps__c = rtName;
      }
      else if (csFieldRef == 'Virtual Partner Opps') {
          cs.Virtual_Partner__c = rtName;
      }
      else if (csFieldRef == 'EU Accts') {
          cs.EUAccts__c = rtName;
      }
      else if (csFieldRef == 'Virtual EU Service Cases') {
          cs.EUServiceCases__c = rtName;
      }
      else if (csFieldRef == 'Virtual EU Projects') {
          cs.EuProjects__c = rtName;
      }
      else if (csFieldRef == 'Virtual NA Projects') {
          cs.NaProjects__c = rtName;
      }
      
      System.debug(LoggingLevel.ERROR,'WE_TestDataUtility: RecordTypeName setting is ' + cs);
      return cs;
      
  }

  public static VProfileId__c createProfileIdCustSett(
  Id      uId,
  String  locationRef,
  String  fieldRef,
  Boolean settingStatus)
  {
    VProfileId__c cs;

    User u = [SELECT Id FROM User WHERE Id = :uId];

    system.runAs(u) {

      if (locationRef == 'User') {
        Id userId = u.Id;
        //create Apex Controller Custom Setting
        cs = VProfileId__c.getInstance(userId);
      }
      else if (locationRef == 'Profile') {
        Id userProfileId = userInfo.getProfileId();
        cs = VProfileId__c.getInstance(userProfileId);
      }
      else if (locationRef == 'Org') {
        Id orgId = userInfo.getOrganizationId();
        cs = VProfileId__c.getInstance(orgId);
      }

      if (fieldRef == 'System Admin User') {
        cs.Name                      = 'System Admin User';
      }
      else if (fieldRef == 'EuSalesRm Profile') {
        cs.Name                      = 'Virtual EU Sales & RM';
        cs.VEuSalesRM__c             = settingStatus;
      }
      else if (fieldRef == 'AuSalesRm Profile') {
        cs.Name                      = 'Virtual AU Sales & RM';
        cs.VAuSalesRM__c             = settingStatus;
      }
      else if (fieldRef == 'EuNaSalesRm Profile') {
        cs.Name                      = 'Virtual EU NA Sales & RM';
        cs.Virtual_EU_NA_Sales_RM__c = settingStatus;
      }
    }
    return cs;
  }

  public static List<Budget__c> createBudgets(
  integer noMonths,
  integer firstYear,
  integer firstMonth,
  string  team,
  integer budget)
  {

    User u = [SELECT Id FROM User WHERE Username = 'astest@wexeurope.com'];

    //create Target records
    Budget__c[] budgets = new Budget__c[]{};

    for(integer i = 0; i < noMonths; i++) {

      date budgetDate = date.newInstance(firstYear, firstMonth, 1);

      budgets.add(new Budget__c(
      Name      = 'Test Rec' + i,
      OwnerId   = u.Id,
      Team__c   = team,
      Date__c   = budgetDate,
      Budget__c = budget
      ));
    }
    return budgets;
  }

  public static List<Target__c> createTargets(
  integer noMonths,
  id      salespersonId,
  integer firstYear,
  integer firstMonth,
  string  team,
  string  dateType,
  integer target) {

    User u = [SELECT Id FROM User WHERE Username = 'astest@wexeurope.com'];

    //create Target records
    Target__c[] targets = new Target__c[]{};

    for(integer i = 0; i < noMonths; i++) {

      date startDate = date.newInstance(firstYear, firstMonth, 1);
      date monthEndDate = startDate.addMonths(i);
      date yearEndDate = date.newInstance(monthEndDate.year(),12,31);

      targets.add(new Target__c(
      Name              = 'Test Rec' + i,
      OwnerId           = u.Id,
      Salesperson__c    = salespersonId,
      Team__c           = team,
      Month_End_Date__c = monthEndDate,
      Year_End_Date__c  = yearEndDate,
      Date_Type__c      = dateType,
      Target__c         = target
      ));
    }
    return targets;
  }

  public static List<Opportunity> createOpportunities(
  string  oppRef,
  integer noOpps,
  string  recordTypeName,
  string  identifier,
  string  stageName,
  date    closeDate,
  string  rampProfile,
  decimal settlement) {

    RecordType rt = [SELECT Id FROM RecordType
    WHERE SObjectType = 'Opportunity' AND RecordType.Name = :recordTypeName
    LIMIT 1];

    User u = [SELECT Id FROM User WHERE Username = 'astest@wexeurope.com'];

    // create Opportunities
    Opportunity[] opportunities = new Opportunity[]{};
    for(integer i = 0; i < noOpps; i++)
    {
      if (oppRef == 'EU Opps')
      {
        opportunities.add(new Opportunity(
        Name                  = 'Test EU Opp ' + i + ' ' + identifier,
        RecordTypeId          = rt.Id,
        OwnerId               = u.Id,
        StageName             = stageName,
        CloseDate             = closeDate,
        Ramp_Profile__c       = rampProfile,
        LeadSource            = 'Cold Call',
        Rebate_Not_Offered__c = true,
        Type                  = 'New Customer',
        // cover Forecast validation rules
        Monthly_Txn_Revenue_POS__c       = 0,
        // cover Credit Agreement Details Required validation rule
        Credit_Limit__c                  = 100,
        Date_Credit_Limit_Approved__c    = date.newInstance(1901,1,1),
        Payment_Terms_Days__c            = 5,
        Billing_Cycle__c                 = 'Daily',
        Manual_Billing_Required__c       = 'Not Applicable',
        //cover Revenue Values Required validation rule
        Annual_Settlement_Value__c       = settlement,
        Average_transaction_Value_POS__c = 1.00,
        // cover API Name / Type required validation rule
        Platform__c                      = 'Multicom',
        // cover Program Type validation rule
        Program_Type__c                  = 'Test Program Type'
        //Implementation_Revenue__c      = date.today().addMonths(3)
        ));
      }
      if (oppRef == 'NA Opps')
      {
        opportunities.add(new Opportunity(
        Name                       = 'Test NA Opp ' + i + ' ' + identifier,
        RecordTypeId               = rt.Id,
        OwnerId                    = u.Id,
        StageName                  = stageName,
        CloseDate                  = closeDate,
        Ramp_Profile__c            = rampProfile,
        Annual_Settlement_Value__c = settlement,
        Type                       = 'Contract',
        LeadSource                 = 'Internal Referral',
        Revenue_Measure__c         = 'Monthly',
        Product_Interest__c        = 'Virtual',
        MC_Product__c              = 'Virtual',
        RM__c                      = u.Id
        ));
      }
      if (oppRef == 'AU Opps')
      {
        opportunities.add(new Opportunity(
        Name                       = 'Test AU Opp ' + i + ' ' + identifier,
        RecordTypeId               = rt.Id,
        OwnerId                    = u.Id,
        StageName                  = stageName,
        CloseDate                  = closeDate,
        Ramp_Profile__c            = rampProfile,
        Annual_Settlement_Value__c = settlement,
        Type                       = 'New Customer',
        Sales_Group__c             = 'Travel'
        ));
      }
    }
    return opportunities;
  }

  public static List<Case> createCases(
  integer noCases,
  string  identifier,
  string  recordTypeName)
  {
    RecordType rt = [SELECT Id FROM RecordType
                      WHERE SObjectType = 'Case' AND RecordType.Name = :recordTypeName
                      LIMIT 1];

    User u = [SELECT Id FROM User WHERE Username = 'astest@wexeurope.com'];

    // create Cases
    Case[] cases = new Case[]{};
    for(integer i = 0; i < noCases; i++) {

      cases.add(new Case(
      Subject       = 'Test Case ' + i + ' ' + identifier,
      Status        = 'New',
      RecordTypeId  = rt.Id,
      OwnerId       = u.Id,
      Reason        = 'Account Closure'
      ));
    }
    return cases;
  }
}