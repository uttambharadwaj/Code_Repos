/*
 * Description: Sweep batch controller to route Lead and Contact preference updates
 * Date: April 2020
 * Author: Lev
 */
public class SweepsBatchService {
    public static final String leadObj = 'Lead';
    public static final String contObj = 'Contact';
    public static final String contactFields = 'PartnerID__c, DoNotCall, Outbound_Call_Opt_In__c , et4ae5__HasOptedOutOfMobile__c, ' +
            				   				   'HasOptedInOfMobile__c, HasOptedOutOfEmail, Email_Opt_In_Contact__c, ' +
            				   				   'Mail_Opt_Out__c, Direct_Mail_Opt_In__c ';
    public static final String leadFields = 'PartnerID__c, DoNotCall, Outbound_Call_Opt_In__c , et4ae5__HasOptedOutOfMobile__c, ' +
            								'HasOptedInOfMobile__c, HasOptedOutOfEmail, Email_Opt_In__c, ' +
            								'Mail_Opt_Out__c, Direct_Mail_Opt_In__c ';
    public static final Integer batchLimit = Integer.valueOf(Label.SweepBatchLimit);

    
    //If Changes exist route to batch
    public static void routeLeadBatch (List<Lead>triggerNew, Map<Id, Lead> newMap, Map<Id, Lead> oldMap) {
        for( Id leadId : newMap.keySet() ) {
            if(oldMap.get( leadId ).DoNotCall != newMap.get( leadId ).DoNotCall || 
               oldMap.get( leadId ).HasOptedOutOfEmail != newMap.get( leadId ).HasOptedOutOfEmail || 
               oldMap.get( leadId ).Mail_Opt_Out__c != newMap.get( leadId ).Mail_Opt_Out__c ){
                   SweepsBatchService.handleLeadUpdate(triggerNew);
               }
        }
    }
    
    /*
     * Description: If Contact record is changed, update all related records
     * Param: updatedcontact is list of changed records
     * Param: contactMap is Trigger.newMap sent from trigger
     */
    public static void handleContactUpdate(List<Contact> updatedContacts) {
        Map<String, MCPreferences> prefMap = new Map<String, MCPreferences>();
        
        for(Contact c : updatedContacts) {
            if(c.PartnerID__c != null) {
                MCPreferences pref = new MCPreferences();
                pref.directMail = c.Mail_Opt_Out__c;
                pref.email = c.HasOptedOutOfEmail;
                pref.mobile = c.et4ae5__HasOptedOutOfMobile__c;
                pref.telemarking = c.DoNotCall;
                prefMap.put(c.PartnerID__c, pref);
            }
		}
        

        //If partnerIds exist on the records
		if(!prefMap.isEmpty()) {
            SweepsBatch leadBatch = buildBatch(leadFields, leadObj, prefMap);
            SweepsBatch contactBatch = buildBatch(contactFields, contObj, prefMap);
            Database.executeBatch(leadBatch, batchLimit);
            Database.executeBatch(contactBatch, batchLimit);
        }
        
    }
    
    /*
     * Description: If Lead record is changed, update all related records
     * Param: updatedLeads is list of changed records
     * Param: leadMap is Trigger.newMap sent from trigger
     */
    public static void handleLeadUpdate(List<Lead> updatedLeads) {
        Map<String, MCPreferences> prefMap = new Map<String, MCPreferences>();
        
        for(Lead ld : updatedLeads) {
            if(ld.PartnerID__c != null) {
                MCPreferences pref = new MCPreferences();
                pref.directMail = ld.Mail_Opt_Out__c;
                pref.email = ld.HasOptedOutOfEmail;
                pref.mobile = ld.et4ae5__HasOptedOutOfMobile__c;
                pref.telemarking = ld.DoNotCall;
                prefMap.put(ld.PartnerID__c, pref);
            }
		}
        SYSTEM.debug('####prefMap ' + prefMap);
        //If partnerIds exist on the records
        if(!prefMap.isEmpty()) {
            SweepsBatch leadBatch = buildBatch(leadFields, leadObj, prefMap);
            SweepsBatch contactBatch = buildBatch(contactFields, contObj, prefMap);
            Database.executeBatch(leadBatch, batchLimit);
            Database.executeBatch(contactBatch, batchLimit);
        }
    }
    
   /*
    * @description  Log DML exceptions
    * @param       recordId
    * @param       sr SaveResult
    */

    public static Internal_Application_Error__c  buildErrorLog (String recordId,Database.SaveResult sr){ 
        Internal_Application_Error__c error = new Internal_Application_Error__c();
        string errDBMsg; 
        for (Database.Error err : sr.getErrors()) {
            errDBMsg =+ err.getStatusCode() + ': ' + err.getMessage() +  ' ' + err.getFields();
                
        }                   
        error.Error_Message__c = recordId + ':' + errDBMsg;
        return error;
    }

    /*
     * Description: Setup batch class
     * Param: fields query fields
     * Param: batchObj the object to query for
     * Param: partnerIds the object to query for
     */
    public static SweepsBatch buildBatch(String fields, String batchObj, Map<String, MCPreferences> prefMap) {
        //Setup Batch 
        SweepsBatch sweep = new SweepsBatch();
        sweep.changedObject = batchObj;
        sweep.fields = fields;
        sweep.prefMap = prefMap;
        return sweep;
    }
    
    public class MCPreferences {
        public Boolean directMail;
        public Boolean telemarking;
        public Boolean email;
        public Boolean mobile;
    }
}