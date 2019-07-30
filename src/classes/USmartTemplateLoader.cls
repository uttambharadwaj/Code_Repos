global class USmartTemplateLoader {//implements Support.EmailTemplateSelector {
//
//    /*
//     * implemented based on guide https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_email_template_selector.htm
//     */
//
//    String userName;
//    Id profileId;
//    Map<Id, Schema.RecordTypeInfo> rts = new Map<Id, Schema.RecordTypeInfo>();
//    String rtName;
//    String caseStatus;
//    List<Smart_Template_Loader_Conf__mdt> confs;
//    // List not Set so that if the same template name is retrieved from 2 records, this can be flagged
//    List<String> confTemplateNames = new List<String>();
//    String confTemplateName;
//    String profileName;
//    EmailTemplate et;
//
//    // empty constructor
//    global USmartTemplateLoader() {
//    }
//
//    // The main interface method
//    global Id getDefaultEmailTemplateId(Id caseId) {
//
//        // Select the Case we're interested in, choosing any fields that are relevant to our decision
//        Case c = [SELECT RecordTypeId, Status
//                    FROM Case
//                   WHERE Id = :caseId];
//
//        WE_ApexUtility apxUtil = new WE_ApexUtility();
//        apxUtil.retrieveValidRecordTypes('Virtual EU Service Cases');
//
//        if (WE_ApexUtility.validEuServiceCaseRecordTypeIds.contains(c.RecordTypeId)) {
//
//            userName = userInfo.getUserName();
//            profileId = userInfo.getProfileId();
//            rts = Case.SObjectType.getDescribe().getRecordTypeInfosById();
//            rtName = rts.get(c.RecordTypeId).getName();
//
//            system.debug('USmartTemplateLoader: Case Id is +++ ' + c.Id);
//            system.debug('USmartTemplateLoader: Case Status is +++ ' + c.Status);
//            system.debug('USmartTemplateLoader: userName is ' + userName);
//            system.debug('USmartTemplateLoader: profileId is ' + profileId);
//            system.debug('USmartTemplateLoader: rtName is ' + rtName);
//
//            confs = [SELECT Id, Template_Name__c, Username__c, Record_Type_Name__c, Case_Status__c
//                       FROM Smart_Template_Loader_Conf__mdt
//                      WHERE Username__c = :userName AND Record_Type_Name__c = :rtName AND Case_Status__c IN (:c.Status, 'Unknown')];
//
//            if (!confs.isEmpty()) {
//
//                for(Smart_Template_Loader_Conf__mdt cmt : confs) {
//                    if (cmt.Case_Status__c != 'Unknown') {
//                        confTemplateNames.add(cmt.Template_Name__c);
//                    }
//                }
//                // only add Unknown template(s) to the list if no others were retrieved
//                if (confTemplateNames.isEmpty()) {
//                    for(Smart_Template_Loader_Conf__mdt cmt : confs) {
//                        confTemplateNames.add(cmt.Template_Name__c);
//                    }
//                }
//
//                if (confTemplateNames.size() > 1) {
//                    for(Smart_Template_Loader_Conf__mdt cnf : confs) {
//                        // lack of template should prompt user complaint but addError not used, to enable user to still compose email
//                        system.debug('USmartTemplateLoader: more than one template returned, metadata record Id: ' + cnf.Id);
//                    }
//                }
//                else {
//                    confTemplateName = confTemplateNames[0];
//                    system.debug('USmartTemplateLoader: got template: ' + confTemplateName);
//                }
//                // clear List's values for tests
//                confTemplateNames.clear();
//            }
//
//            if (confTemplateName == null) {
//
//                Profile profile = [SELECT Name
//                                     FROM Profile
//                                    WHERE Id = :profileId];
//
//                profileName = profile.Name;
//                system.debug('USmartTemplateLoader: profileName is ' + profileName);
//
//                confs = [SELECT Id, Template_Name__c, Profile_Name__c, Record_Type_Name__c, Case_Status__c
//                           FROM Smart_Template_Loader_Conf__mdt
//                          WHERE Profile_Name__c = :profileName AND Record_Type_Name__c = :rtName AND Case_Status__c IN (:c.Status, 'Unknown')];
//
//                if (!confs.isEmpty()) {
//
//                    for(Smart_Template_Loader_Conf__mdt cmt : confs) {
//                        if (cmt.Case_Status__c != 'Unknown') {
//                            confTemplateNames.add(cmt.Template_Name__c);
//                        }
//                    }
//                    // only add Unknown template(s) to the list if no others were retrieved
//                    if (confTemplateNames.isEmpty()) {
//                        for(Smart_Template_Loader_Conf__mdt cmt : confs) {
//                            confTemplateNames.add(cmt.Template_Name__c);
//                        }
//                    }
//
//                    if (confTemplateNames.size() > 1) {
//                        for(Smart_Template_Loader_Conf__mdt cnf : confs) {
//                            system.debug('USmartTemplateLoader: more than one template returned, metadata record Id: ' + cnf.Id);
//                        }
//                    }
//                    else {
//                        confTemplateName = confTemplateNames[0];
//                        system.debug('USmartTemplateLoader: got template: ' + confTemplateName);
//                    }
//                    // clear List's values for tests
//                    confTemplateNames.clear();
//                }
//            }
//
//            if (confTemplateName == null) {
//                system.debug('USmartTemplateLoader: no template!');
//                return null;
//            }
//
//            // get the template ID - must be a list, in case no values are retrieved
//            List<EmailTemplate> et = [SELECT Id
//                                        FROM EmailTemplate
//                                       WHERE DeveloperName = :confTemplateName];
//
//            // return the ID of the template selected
//            if (et.size() > 0) {
//                system.debug('USmartTemplateLoader: template: ' + confTemplateName + ' -- Id: ' + et[0].Id);
//                // clear variable's value for tests
//                confTemplateName = null;
//                return et[0].Id;
//            }
//            else {
//                system.debug('USmartTemplateLoader: No template with the name: ' + confTemplateName);
//                // clear variable's value for tests
//                confTemplateName = null;
//                return null;
//            }
//        }
//        else {
//            system.debug('USmartTemplateLoader: Case does not have a valid virtual EU record type');
//            return null;
//        }
//    }
}