// revision history https://gist.github.com/aplssf/ed0678562368a4ad48f053970ceb7f52/revisions
// previous revisions https://gist.github.com/aplssf/cfeda65c514b8fc28ab4
public class WE_ApexUtility {

  /**
  * WIP - removed commented out lines & reference to non-existent record type metadata
  **/

  // variables
  // adapted from here https://developer.salesforce.com/blogs/engineering/2015/05/testing-custom-metadata-types.html
  public static Boolean testContext = false;
  public static String testContextStatus = 'FALSE';

  public static Set<Boolean> forecastDisabled = new Set<boolean>();
  public static Set<Boolean> budgetManagerDisabled = new Set<boolean>();
  public static Set<Boolean> targetManagerDisabled = new Set<boolean>();
  public static Set<Boolean> netFsrDisabled = new Set<Boolean>();
  public static Set<Boolean> domainMatchDisabled = new Set<boolean>();
  public static Set<Boolean> spamFilterManagerDisabled = new Set<boolean>();
  public static Set<Boolean> lostDealSurveyDisabled = new Set<boolean>();
  public static Set<Boolean> ProjectCreationDisabled = new Set<boolean>();
  public static Boolean apxCntrlrOppMrfStatusAssessed = false;
  public static Boolean apxCntrlrBudgetManagerStatusAssessed = false;
  public static Boolean apxCntrlrTargetManagerStatusAssessed = false;
  public static Boolean apxCntrlrDomainMatchStatusAssessed = false;
  public static Boolean apxCntrlrLostDealSurveyStatusAssessed = false;
  public static Boolean apxCntrlrSpamFilterStatusAssessed = false;
  public static Boolean apxCntrlrProjectCreationStatusAssessed  = false;

  String objectApiName;
  String fieldRef;
  Map<String, Schema.RecordTypeInfo> Rts = new Map<String, Schema.RecordTypeInfo>();
  List<VRTN__c> weRts = new List<VRTN__c>();
  Set<String> weEuRtNames = new Set<String>();
  //Set<String> weNaRtNames = new Set<String>();
  // cannot be static as may need to hold values from several objects in course of single transaction
  Set<String> weRtNames = new Set<String>();
  // !!! needs to be updated in StageFull to include object in name
  public static Set<Id> validEuNaRecordTypeIds = new Set<Id>();
  public static Set<Id> validEuRecordTypeIds = new Set<Id>();
  public static Set<Id> validNaRecordTypeIds = new Set<Id>();
  public static Set<Id> validAuRecordTypeIds  = new Set<Id>();
  public static Set<Id> validPartnerOppRecordTypeIds = new Set<Id>();
  public static Set<Id> validEuServiceCaseRecordTypeIds = new Set<Id>();
  public static Set<Id> validAuProjectRecordTypeIds = new Set<Id>();
  public static Set<Id> validEuProjectRecordTypeIds = new Set<Id>();
  public static Set<Id> validNaProjectRecordTypeIds = new Set<Id>();

  // booleans created in this Class to avoid dependencies on code that may be replaced
  public static Boolean recursiveOppUpdate = false;
  public static Boolean recursiveCdUpdate = false;
  public static Boolean recursiveCaseUpdate = false;
  public static Boolean recursiveMilestoneUpdate = false;

  public static Set <Id> validEuNaSalesRmProfiles = new Set<Id>();
  public static Set <Id> validEuSalesRmProfiles = new Set<Id>();
  public static Set <Id> validAuSalesRmProfiles = new Set<Id>();
  public static Set <Id> validAsiaSalesRmProfiles = new Set<Id>();
  public static Set <Id> evaluatedRegionsProfiles = new Set<Id>();

  // method 1
  public static void checkApexControllerStatus(string process) {

    // !!! it's not necessary to explicitly check all 3 hierarchy levels in the custom setting
    // but I need to work out which one to check

    Id userId;
    Id userProfileId;
    Id orgId;
    VApexC__c userApexController;
    VApexC__c profileApexController;
    VApexC__c orgApexController;
    boolean userSetting;
    boolean userProfileSetting;
    boolean orgSetting;

    system.debug('WE_ApexUtility: process is ' + process);

    userId = userinfo.getUserId();
    userApexController = VApexC__c.getInstance(userId);

    if (process == 'Opportunity MRF') {
      userSetting = userApexController.Opportunity_Forecast_Disabled__c;
      forecastDisabled.add(userSetting);
    }
    else if (process == 'Budget Manager') {
      userSetting = userApexController.BudgetManagerDisabled__c;
      budgetManagerDisabled.add(userSetting);
    }
    else if (process == 'Target Manager') {
      userSetting = userApexController.Target_Manager_Disabled__c;
      targetManagerDisabled.add(userSetting);
    }
    else if (process == 'Domain Match') {
      userSetting = userApexController.DomainMatchDisabled__c;
      domainMatchDisabled.add(userSetting);
    }
    else if (process == 'Net FSR') {
      userSetting = userApexController.Net_FSR_Disabled__c;
      netFSRDisabled.add(userSetting);
    }
/*
    else if (process == 'Spam Filter Manager') {
      userSetting = userApexController.Spam_Filter_Disabled__c;
      spamFilterManagerDisabled.add(UserSetting);
    }
*/
    else if (process == 'Automatic Project Creation') {
      userSetting = userApexController.ProjectCreationDisabled__c;
      ProjectCreationDisabled.add(UserSetting);
    }
    //no need to check Profile if setting's been deactivated at User level
    if (userSetting == false) {
      userProfileId = userinfo.getProfileId();
      profileApexController = VApexC__c.getInstance(userProfileId);

      if (process == 'Opportunity MRF') {
        userProfileSetting = profileApexController.Opportunity_Forecast_Disabled__c;
        forecastDisabled.add(userProfileSetting);
      }
      else if (process == 'Budget Manager') {
        userProfileSetting = profileApexController.BudgetManagerDisabled__c;
        budgetManagerDisabled.add(userProfileSetting);
      }
      else if (process == 'Target Manager') {
        userProfileSetting = profileApexController.Target_Manager_Disabled__c;
        targetManagerDisabled.add(userProfileSetting);
      }
      else if (process == 'Domain Match') {
        userProfileSetting = profileApexController.DomainMatchDisabled__c;
        domainMatchDisabled.add(userProfileSetting);
      }
      else if (process == 'Net FSR') {
        userProfileSetting = profileApexController.Net_FSR_Disabled__c;
        netFsrDisabled.add(userProfileSetting);
      }
      else if (process == 'Lost Deal Survey') {
        userProfileSetting = profileApexController.Lost_Deal_Survey_Disabled__c;
        lostDealSurveyDisabled.add(userProfileSetting);
      }
/*
      else if (process == 'Spam Filter Manager') {
        userProfileSetting = profileApexController.Spam_Filter_Disabled__c;
        spamFilterManagerDisabled.add(userProfileSetting);
      }
*/
      else if (process == 'Automatic Project Creation') {
        userProfileSetting = profileApexController.ProjectCreationDisabled__c;
        ProjectCreationDisabled.add(userProfileSetting);
      }
    }
    //no need to check Org if setting's been deactivated at User / Profile level
    if (userSetting == false &&
    userProfileSetting == false) {
      orgId = userinfo.getOrganizationId();
      orgApexController = VApexC__c.getInstance(orgId);

      if (process == 'Opportunity MRF') {
        orgSetting = orgApexController.Opportunity_Forecast_Disabled__c;
        forecastDisabled.add(orgSetting);
      }
      else if (process == 'Budget Manager') {
        orgSetting = orgApexController.BudgetManagerDisabled__c;
        budgetManagerDisabled.add(orgSetting);
      }
      else if (process == 'Target Manager') {
        orgSetting = orgApexController.Target_Manager_Disabled__c;
        targetManagerDisabled.add(orgSetting);
      }
      else if (process == 'Domain Match') {
        orgSetting = orgApexController.DomainMatchDisabled__c;
        domainMatchDisabled.add(orgSetting);
      }
      else if (process == 'Net FSR') {
        orgSetting = orgApexController.Net_FSR_Disabled__c;
        netFSRDisabled.add(orgSetting);
      }
      else if (process == 'Lost Deal Survey') {
               orgSetting = orgApexController.Lost_Deal_Survey_Disabled__c;
               lostDealSurveyDisabled.add(orgSetting);
      }
/*
      else if (process == 'Spam Filter Manager') {
        orgSetting = orgApexController.Spam_Filter_Disabled__c;
        spamFilterManagerDisabled.add(orgSetting);
      }
*/
      else if (process == 'Automatic Project Creation') {
        orgSetting = orgApexController.ProjectCreationDisabled__c;
        ProjectCreationDisabled.add(orgSetting);
      }
    }
    if (process == 'Opportunity MRF') {
      apxCntrlrOppMrfStatusAssessed = true;
      system.debug('WE_ApexUtility: apxCntrlrOppMrfStatusAssessed set to true');
    }
    else if (process == 'Budget Manager') {
      apxCntrlrBudgetManagerStatusAssessed = true;
      system.debug('WE_ApexUtility: apxCntrlrBudgetManagerStatusAssessed set to true');
    }
    else if (process == 'Target Manager') {
      apxCntrlrTargetManagerStatusAssessed = true;
      system.debug('WE_ApexUtility: apxCntrlrTargetManagerStatusAssessed set to true');
    }
    else if (process == 'Domain Match') {
      apxCntrlrDomainMatchStatusAssessed = true;
      system.debug('WE_ApexUtility: apxCntrlrDomainMatchStatusAssessed');
    }
    else if (process == 'Spam Filter Manager') {
      apxCntrlrSpamFilterStatusAssessed = true;
      system.debug('WE_ApexUtility: apxCntrlrSpamFilterStatusAssessed');
    }
    else if (process == 'Lost Deal Survey') {
      apxCntrlrLostDealSurveyStatusAssessed = true;
      system.debug('WE_ApexUtility: apxCntrlrLostDealSurveyStatusAssessed');
    }
    else if (process == 'Automatic Project Creation') {
      apxCntrlrProjectCreationStatusAssessed  = true;
      system.debug('WE_ApexUtility: apxCntrlrProjectCreationStatusAssessed ');
    }
  }

  // method 2
  public void retrieveValidRecordTypes(String csFieldRef) {

      fieldRef = csFieldRef;

      if (fieldRef.containsIgnoreCase('Lead')) {
          objectApiName = 'Lead';
      }
      else if (fieldRef.containsIgnoreCase('Opp')) {
          objectApiName = 'Opportunity';
      }
      else if (fieldRef.containsIgnorecase('Case')) {
          objectApiName = 'Case';
      }
      else if (fieldRef.containsIgnorecase('Project')) {
          objectApiName = 'MPM4_BASE__Milestone1_Project__c';
      }

      if (objectApiName == 'Lead') {
          Rts = Lead.SObjectType.getDescribe().getRecordTypeInfosByName();
      }
      else if (objectApiName == 'Opportunity') {
          Rts = Opportunity.SObjectType.getDescribe().getRecordTypeInfosByName();
      }
      else if (objectApiName == 'Case') {
          Rts = Case.SObjectType.getDescribe().getRecordTypeInfosByName();
      }
      else if (objectApiName == 'MPM4_BASE__Milestone1_Project__c') {
          Rts = MPM4_BASE__Milestone1_Project__c.SObjectType.getDescribe().getRecordTypeInfosByName();
      }

      weRts = VRTN__c.getall().values();

      for(VRTN__c weRt : weRts) {

          if (csFieldRef == 'EU Opps') {
              try {
                  weEuRtNames.add(weRt.EUOpps__c);
                  weRtNames.add(weRt.EUOpps__c);
              }
              catch (system.StringException e) {
                  system.debug(system.LoggingLevel.ERROR,'Invalid Record Type Name ' + weRT.EUOpps__c);
              }
          }
          else if (csFieldRef == 'NA Opps') {
              try {
                  weRtNames.add(weRt.NaOpps__c);
              }
              catch (system.StringException e) {
                  system.debug(system.LoggingLevel.ERROR,'Invalid Record Type Name ' + weRT.NaOpps__c);
              }
          }
          else if (csFieldRef == 'Virtual AU Opps') {
              try {
                  weRtNames.add(weRt.AuOpps__c);
              }
              catch (system.StringException e) {
                  system.debug(system.LoggingLevel.ERROR,'Invalid Record Type Name ' + weRT.AuOpps__c);
              }
          }
          else if (csFieldRef == 'EU NA Opps') {
              try {
                  weRtNames.add(weRt.EuOpps__c); // in case Unit Test hasn't populated NAEUOpps__c field
                  weRtNames.add(weRt.NaEuOpps__c);
              }
              catch (system.StringException e) {
                  system.debug(system.LoggingLevel.ERROR,'Invalid Record Type Name ' + weRT.NAEUOpps__c);
              }
          }
          else if (csFieldRef == 'Virtual Partner Opps') {
              try {
                  weRtNames.add(weRt.Virtual_Partner__c);
              }
              catch (system.StringException e) {
                  system.debug(system.LoggingLevel.ERROR,'Invalid Record Type Name ' + weRT.Virtual_Partner__c);
              }
          } else if (csFieldRef == 'Virtual EU Service Cases') {
              try {
                  weRtNames.add(weRt.EUServiceCases__c);
              }
              catch (system.StringException e) {
                  system.debug(system.LoggingLevel.ERROR,'Invalid Record Type Name ' + weRT.EUServiceCases__c);
              }
          } else if (csFieldRef == 'Virtual EU Projects') {
              try {
                  weRtNames.add(weRt.EuProjects__c);
              }
              catch (system.StringException e) {
                  system.debug(system.LoggingLevel.ERROR,'Invalid Record Type Name ' + weRT.EuProjects__c);
              }
          } else if (csFieldRef == 'Virtual NA Projects') {
              try {
                  weRtNames.add(weRt.NaProjects__c);
              }
              catch (system.StringException e) {
                  system.debug(system.LoggingLevel.ERROR,'Invalid Record Type Name ' + weRT.NaProjects__c);
              }
          }
      }

    for(String weRtN : weRtNames) {
        // checks whether the RT is included in the list retrieved from the Custom Setting field
        if (Rts.get(weRtN) != null) {
            if (csFieldRef == 'EU NA Opps') {
                validEuNaRecordTypeIds.add(Rts.get(weRtN).getRecordTypeId());
            }
            else if (csFieldRef == 'EU Opps') {
                validEuRecordTypeIds.add(Rts.get(weRtN).getRecordTypeId());
            }
            else if (csFieldRef == 'NA Opps') {
                validNaRecordTypeIds.add(Rts.get(weRtN).getRecordTypeId());
            }
            else if (csFieldRef == 'Virtual AU Opps') {
                validAuRecordTypeIds.add(Rts.get(weRtN).getRecordTypeId());
            }
            else if (csFieldRef == 'Virtual Partner Opps') {
                validPartnerOppRecordTypeIds.add(Rts.get(weRtN).getRecordTypeId());
            }
            else if (csFieldRef == 'Virtual EU Service Cases') {
                validEuServiceCaseRecordTypeIds.add(Rts.get(weRtN).getRecordTypeId());
            }
            //else if (csFieldRef == 'Virtual AU Projects') {
                //validAuProjectRecordTypeIds.add(Rts.get(weRtn).getRecordTypeId());
            //}
            else if (csFieldRef == 'Virtual EU Projects') {
                validEuProjectRecordTypeIds.add(Rts.get(weRtn).getRecordTypeId());
            }
            else if (csFieldRef == 'Virtual NA Projects') {
                validNaProjectRecordTypeIds.add(Rts.get(weRtn).getRecordTypeId());
            }
        }
    }
    if ((csFieldRef == 'EU NA Opps')) {
        system.debug('WE_ApexUtility: validEuNaRecordTypeIds contains ' + validEuNaRecordTypeIds);
    }
    else if (csFieldRef == 'EU Opps') {
        system.debug('WE_ApexUtility: validEuRecordTypeIds contains ' + validEuRecordTypeIds);
    }
    else if (csFieldRef == 'NA Opps') {
        system.debug('WE_ApexUtility: validNaRecordTypeIds contains ' + validNaRecordTypeIds);
    }
    else if (csFieldRef == 'Virtual AU Opps') {
        system.debug('WE_ApexUtility: validAuRecordTypeIds contains ' + validAuRecordTypeIds);
    }
    else if (csFieldRef == 'Virtual Partner Opps') {
        system.debug('WE_ApexUtility: validPartnerOppRecordTypeIds contains ' + validPartnerOppRecordTypeIds);
    }
    else if (csFieldRef == 'Virtual EU Service Cases') {
        system.debug('WE_ApexUtility: validEuServiceCaseRecordTypeIds contains ' + validEuServiceCaseRecordTypeIds);
    }
    else if (csFieldRef == 'Virtual EU Projects') {
        system.debug('WE_ApexUtility: validEuProjectRecordTypeIds contains ' + validEuProjectRecordTypeIds);
    }
  }

  // method 3
  // !!! update WE_ApexUtilityTest to cover this method
  public Static void checkValidProfile(Set<Id> uPIds) {
    Set<Id> userProfileIds = uPIds;
    VProfileId__c csProfileId;
    boolean profileSetting;

    for(Id i : userProfileIds) {
        csProfileId = VProfileId__c.getInstance(i);

        profileSetting = csProfileId.Virtual_EU_NA_Sales_RM__c;
        if (profileSetting == true) {
            validEuNaSalesRmProfiles.add(i);
        }
        profileSetting = csProfileId.VAuSalesRM__c;
        if (profileSetting == true) {
            validAuSalesRmProfiles.add(i);
        }
        profileSetting = csProfileId.VAsiaSalesRM__c;
        if (profileSetting == true) {
            validAsiaSalesRmProfiles.add(i);
        }
        profileSetting = csProfileId.VEuSalesRM__c;
        if (profileSetting == true) {
            validEuSalesRmProfiles.add(i);
        }
        evaluatedRegionsProfiles.add(i);
    }

  }

  // method 4
  // !!! update WE_ApexUtilityTest to cover this method
  public static void recursiveOppUpdate(List<Opportunity> opps, boolean b) {
    recursiveOppUpdate = b;
    update opps.deepClone(true);
  }

  // method 5
  // !!! update WE_ApexUtilityTest to cover this method
  public static void recursiveCdUpdate(List<Currency_Detail__c> cds, boolean b) {
    recursiveCdUpdate = b;
    update cds.deepClone(true);
  }
    
        // adapted from http://www.sfdc99.com/2014/03/01/sending-emails-using-apex/ and
    // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_forcecom_email_outbound.htm
    public class PrepareEmails {

        public Messaging.SingleEmailMessage createEmail(
            String[] sendTo,
            String replyTo,
            String senderDisplayName,
            String[] ccTo,
            String[] bccTo,
            String subject,
            String body) {

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                mail.SetToAddresses(sendTo);
                mail.SetReplyTo(replyTo);
                mail.SetSenderDisplayName(senderDisplayName);
                if (ccTo != null &&
                    !ccTo.isEmpty())
                {
                    mail.SetCcAddresses(ccTo);
                }
                if (bccTo != null &&
                    !bccTo.isEmpty())
                {
                    mail.SetBccAddresses(bccTo);
                }
                mail.SetSubject(subject);
                mail.SetHtmlBody(body);

                return mail;
            }
        }

  // method 6
  // !!! update WE_ApexUtilityTest to cover this method
  public static void recursiveCaseUpdate(List<Case> cases, boolean b) {
    recursiveCaseUpdate = b;
    update cases.deepClone(true);
  }

  // method 7
  // !!! update WE_ApexUtilityTest to cover this method
  public static void recursiveMilestoneUpdate(List<MPM4_BASE__Milestone1_Milestone__c> milestones, boolean b) {
    recursiveMilestoneUpdate = b;
    update milestones.deepClone(true);
  }

  // adapted from this documentation https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_list_sorting_sobject.htm
  // also see https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_comparable.htm
  public class MilestoneWrapper implements Comparable {

    public MPM4_BASE__Milestone1_Project__c mstne;

    // Constructor
    public MilestoneWrapper(MPM4_BASE__Milestone1_Project__c ms) {
      mstne = ms;
    }

    // Compare Milestones based on the Milestone's Kickoff date.
    public Integer compareTo(Object compareTo) {
      // Cast argument to MilestoneWrapper
      MilestoneWrapper compareToMstne = (MilestoneWrapper)compareTo;

      // The return value of 0 indicates that both elements are equal.
      Integer returnValue = 0;
      if (mstne.MPM4_BASE__Kickoff__c > compareToMstne.mstne.MPM4_BASE__Kickoff__c) {
        // Set return value to a positive value.
        returnValue = 1;
      } else if (mstne.MPM4_BASE__Kickoff__c < compareToMstne.mstne.MPM4_BASE__Kickoff__c) {
        // Set return value to a negative value.
        returnValue = -1;
      }

      return returnValue;
    }
  }


}