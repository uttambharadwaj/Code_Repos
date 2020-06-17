///*
// * Description: Sweep batch controller to route Lead and Contact preference updates
// * Date: April 2020
// * Author: Lev
// */
//public class SweepsBatchService {
//    public static final String leadObj = 'Lead';
//    public static final String contObj = 'Contact';
//    public static final String contactFields = 'Email, Phone, MobilePhone, MailingStreet, MailingCity, MailingState, MailingPostalCode, PartnerID__c, DoNotCall, Outbound_Call_Opt_In__c , et4ae5__HasOptedOutOfMobile__c, ' +
//            				   				   'HasOptedInOfMobile__c, HasOptedOutOfEmail, Email_Opt_In_Contact__c, ' +
//            				   				   'Mail_Opt_Out__c, Direct_Mail_Opt_In__c ';
//    public static final String leadFields = 'Email, Phone, MobilePhone, Street, City, State, PostalCode, PartnerID__c, DoNotCall, Outbound_Call_Opt_In__c , et4ae5__HasOptedOutOfMobile__c, ' +
//            								'HasOptedInOfMobile__c, HasOptedOutOfEmail, Email_Opt_In__c, ' +
//            								'Mail_Opt_Out__c, Direct_Mail_Opt_In__c ';
//    public static final Integer batchLimit = Integer.valueOf(Label.SweepBatchLimit);
//
//
//    //If Changes exist route to batch
//    public static void routeLeadBatch (List<Lead>triggerNew, Map<Id, Lead> newMap, Map<Id, Lead> oldMap) {
//        for( Id leadId : newMap.keySet() ) {
//            if(oldMap.get( leadId ).DoNotCall != newMap.get( leadId ).DoNotCall ||
//               oldMap.get( leadId ).Outbound_Call_Opt_In__c != newMap.get( leadId ).Outbound_Call_Opt_In__c ||
//			  oldMap.get( leadId ).HasOptedOutOfEmail != newMap.get( leadId ).HasOptedOutOfEmail ||
//   			  oldMap.get( leadId ).Email_Opt_In__c != newMap.get( leadId ).Email_Opt_In__c ||
//               oldMap.get( leadId ).Mail_Opt_Out__c != newMap.get( leadId ).Mail_Opt_Out__c ||
//              oldMap.get(leadId).Direct_Mail_Opt_In__c != newMap.get( leadId ).Direct_Mail_Opt_In__c ||
// 			  oldMap.get( leadId ).et4ae5__HasOptedOutOfMobile__c != newMap.get( leadId ).et4ae5__HasOptedOutOfMobile__c ||
//              oldMap.get(leadId).HasOptedInOfMobile__c != newMap.get( leadId ).HasOptedInOfMobile__c){
//        		SweepsBatchService.handleLeadUpdate(triggerNew, oldMap);
//            }
//        }
//    }
//
//    /*
//     * Description: If Contact record is changed, update all related records
//     * Param: updatedcontact is list of changed records
//     * Param: contactMap is Trigger.newMap sent from trigger
//     */
//    public static void handleContactUpdate(List<Contact> updatedContacts, Map<Id, Contact> oldMap) {
//        Map<String, MCPreferences> prefMap = new Map<String, MCPreferences>();
//
//        for(Contact c : updatedContacts) {
//            if(c.PartnerID__c != null) {
//                Contact parentCont = oldMap.get(c.Id);
//
//                MCPreferences pref = new MCPreferences();
//                pref.directMailOut = c.Mail_Opt_Out__c;
//                pref.emailOut = c.HasOptedOutOfEmail;
//                pref.mobileOut = c.et4ae5__HasOptedOutOfMobile__c;
//                pref.telemarkingOut = c.DoNotCall;
//                pref.directMailIn = c.Direct_Mail_Opt_In__c;
//                pref.emailIn = c.Email_Opt_In_Contact__c;
//                pref.mobileIn = c.HasOptedInOfMobile__c;
//                pref.telemarkingIn = c.Outbound_Call_Opt_In__c;
//
//                //Check if Email preferences have changed
//                if(c.HasOptedOutOfEmail != parentCont.HasOptedOutOfEmail ||
//                  c.Email_Opt_In_Contact__c != parentCont.Email_Opt_In_Contact__c) {
//                    pref.parentEmail = c.Email;
//                }
//
//                //Check if Phone preferences have changed
//                if(c.DoNotCall != parentCont.DoNotCall ||
//                   c.Outbound_Call_Opt_In__c != parentCont.Outbound_Call_Opt_In__c) {
//                    pref.parentPhone = c.Phone;
//                }
//
//                //Check if Mobile preferences have changed
//                if(c.HasOptedInOfMobile__c != parentCont.HasOptedInOfMobile__c ||
//                   c.et4ae5__HasOptedOutOfMobile__c != parentCont.et4ae5__HasOptedOutOfMobile__c) {
//                    pref.parentMobile = c.MobilePhone;
//                }
//
//                //Check if Mailing preferences have changed
//                if(c.Direct_Mail_Opt_In__c != parentCont.Direct_Mail_Opt_In__c ||
//                  c.Mail_Opt_Out__c != parentCont.Mail_Opt_Out__c) {
//                    pref.parentStreet = c.MailingStreet;
//                    pref.parentState = c.MailingState;
//                    pref.parentZip = c.MailingPostalCode;
//                    pref.parentCity = c.MailingCity;
//                }
//
//                prefMap.put(c.PartnerID__c, pref);
//            }
//		}
//
//        //If partnerIds exist on the records
//		if(!prefMap.isEmpty()) {
//            SweepsBatch leadBatch = buildBatch(leadFields, leadObj, prefMap);
//            SweepsBatch contactBatch = buildBatch(contactFields, contObj, prefMap);
//            Database.executeBatch(leadBatch, batchLimit);
//            Database.executeBatch(contactBatch, batchLimit);
//        }
//    }
//
//    /*
//     * Description: If Lead record is changed, update all related records
//     * Param: updatedLeads is list of changed records
//     * Param: leadMap is Trigger.newMap sent from trigger
//     */
//    public static void handleLeadUpdate(List<Lead> updatedLeads, Map<Id, Lead> oldMap) {
//        Map<String, MCPreferences> prefMap = new Map<String, MCPreferences>();
//        for(Lead ld : updatedLeads) {
//            if(ld.PartnerID__c != null) {
//                Lead parentLd = oldMap.get(ld.Id);
//
//                MCPreferences pref = new MCPreferences();
//                pref.directMailOut = ld.Mail_Opt_Out__c;
//                pref.emailOut = ld.HasOptedOutOfEmail;
//                pref.mobileOut = ld.et4ae5__HasOptedOutOfMobile__c;
//                pref.telemarkingOut = ld.DoNotCall;
//                pref.directMailIn = ld.Direct_Mail_Opt_In__c;
//                pref.emailIn = ld.Email_Opt_In__c;
//                pref.mobileIn = ld.HasOptedInOfMobile__c;
//                pref.telemarkingIn = ld.Outbound_Call_Opt_In__c;
//
//                //Check if Email preferences have changed
//                if(ld.HasOptedOutOfEmail != parentLd.HasOptedOutOfEmail ||
//                  ld.Email_Opt_In__c != parentLd.Email_Opt_In__c) {
//                    pref.parentEmail = ld.Email;
//                }
//
//                //Check if Phone preferences have changed
//                if(ld.DoNotCall != parentLd.DoNotCall ||
//                  ld.Outbound_Call_Opt_In__c != parentLd.Outbound_Call_Opt_In__c) {
//                    pref.parentPhone = ld.Phone;
//                }
//
//                //Check if Mobile preferences have changed
//                if(ld.HasOptedInOfMobile__c != parentLd.HasOptedInOfMobile__c ||
//                  ld.et4ae5__HasOptedOutOfMobile__c != parentLd.et4ae5__HasOptedOutOfMobile__c) {
//                    pref.parentMobile = ld.MobilePhone;
//                }
//
//                //Check if Mailing preferences have changed
//                if(ld.Direct_Mail_Opt_In__c != parentLd.Direct_Mail_Opt_In__c ||
//                  ld.Mail_Opt_Out__c != parentLd.Mail_Opt_Out__c) {
//                    pref.parentStreet = ld.Street;
//                    pref.parentCity = ld.City;
//                    pref.parentState = ld.State;
//                    pref.parentZip = ld.PostalCode;
//                }
//
//                prefMap.put(ld.PartnerID__c, pref);
//            }
//		}
//        //If partnerIds exist on the records
//        if(!prefMap.isEmpty()) {
//            SweepsBatch leadBatch = buildBatch(leadFields, leadObj, prefMap);
//            SweepsBatch contactBatch = buildBatch(contactFields, contObj, prefMap);
//           	Database.executeBatch(leadBatch, batchLimit);
//            Database.executeBatch(contactBatch, batchLimit);
//        }
//    }
//
//   /*
//    * @description: Log DML exceptions
//    * @param: recordId
//    * @param: sr SaveResult
//    */
//    public static Internal_Application_Error__c  buildErrorLog (String recordId,Database.SaveResult sr){
//        Internal_Application_Error__c error = new Internal_Application_Error__c();
//        string errDBMsg;
//        for (Database.Error err : sr.getErrors()) {
//            errDBMsg =+ err.getStatusCode() + ': ' + err.getMessage() +  ' ' + err.getFields();
//        }
//        error.Error_Message__c = recordId + ':' + errDBMsg;
//        return error;
//    }
//
//    /*
//     * Description: Setup batch class
//     * Param: fields query fields
//     * Param: batchObj the object to query for
//     * Param: partnerIds the object to query for
//     */
//    public static SweepsBatch buildBatch(String fields, String batchObj, Map<String, MCPreferences> prefMap) {
//        //Setup Batch
//        SweepsBatch sweep = new SweepsBatch();
//        sweep.changedObject = batchObj;
//        sweep.fields = fields;
//        sweep.prefMap = prefMap;
//        return sweep;
//    }
//
//    public class MCPreferences {
//        public Boolean directMailOut;
//        public Boolean telemarkingOut;
//        public Boolean emailOut;
//        public Boolean mobileOut;
//        public Boolean directMailIn;
//        public Boolean telemarkingIn;
//        public Boolean emailIn;
//        public Boolean mobileIn;
//        public String parentPhone;
//        public String parentEmail;
//        public String parentMobile;
//        public String parentStreet;
//        public String parentCity;
//        public String parentState;
//        public String parentZip;
//    }
//}