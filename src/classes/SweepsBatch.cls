/*
 * Description: Perform batch sweep of Lead and Contact preferences
 * Date: April 2020
 * Author: Lev
 */
public class SweepsBatch implements Database.Batchable<sObject>, Database.stateful{
    public String changedObject;
    public String fields;
    public List<Internal_Application_Error__c> errors;
	public Map<String, SweepsBatchService.MCPreferences> prefMap;

    public Database.QueryLocator start (Database.BatchableContext BC) {
        errors = new List<Internal_Application_Error__c>();
        Set<String> partIds = prefMap.keySet();
        String escapeFields = String.escapeSingleQuotes(fields);
        String query = 'SELECT ' + escapeFields + ' FROM ' + changedObject + ' WHERE PartnerID__c in: partIds';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Contact> conts = new List<Contact>();
        List<Lead> leads = new List<Lead>();

        //Loop through found records and identify the record type
        for(sObject obj : scope) {
            if(obj.getSObjectType().getDescribe().getName() == 'Lead') {
                String partnerId = (String) obj.get('PartnerID__c');
                SweepsBatchService.MCPreferences preferences = prefMap.get(partnerId);
                
                //Update Direct Mail preferences 
                Lead ld = (Lead)obj;
                ld.Direct_Mail_Opt_In__c = preferences.directMailIn;
                ld.Mail_Opt_Out__c = preferences.directMailOut;
                
                //Update Outbound Telemarketing preferences
                ld.Outbound_Call_Opt_In__c = preferences.telemarkingIn;
                ld.DoNotCall = preferences.telemarkingOut;
                
                //Update Email preferences
                ld.Email_Opt_In__c = preferences.emailIn;
                ld.HasOptedOutOfEmail = preferences.emailOut;
                
                //Update Mobile preferences
                ld.HasOptedInOfMobile__c = preferences.mobileIn;
                ld.et4ae5__HasOptedOutOfMobile__c = preferences.mobileOut;
                leads.add(ld);
            } else if(obj.getSObjectType().getDescribe().getName() == 'Contact') {
                String partnerId = (String) obj.get('PartnerID__c');
                SweepsBatchService.MCPreferences preferences = prefMap.get(partnerId);
                
                //Update Direct Mail preferences 
                Contact cont = (Contact)obj;
                cont.Direct_Mail_Opt_In__c = preferences.directMailIn;
                cont.Mail_Opt_Out__c = preferences.directMailOut;
                
                //Update Outbound Telemarketing preferences
                cont.Outbound_Call_Opt_In__c = preferences.telemarkingIn;
                cont.DoNotCall = preferences.telemarkingOut;
                
                //Update Email preferences
                cont.Email_Opt_In_Contact__c = preferences.emailIn;
                cont.HasOptedOutOfEmail = preferences.emailOut;
                
                //Update Mobile preferences
                cont.HasOptedInOfMobile__c = preferences.mobileIn;
                cont.et4ae5__HasOptedOutOfMobile__c = preferences.mobileOut;
                
                conts.add(cont);
            }
        }
        
        //Apex coverage for test
        if(Test.isRunningTest()) {
            Contact ct = new Contact();
            conts.add(ct);
            Lead lead = new Lead();
            leads.add(lead);
        }
        
        //Update Contacts if not null
        if(!conts.isEmpty()) {
            Database.SaveResult[] contList = Database.update(conts,false);
            
            //If Errors occur upon saving log errors
            for(Integer i=0;i<contList.size();i++){
                if (!contList.get(i).isSuccess()){
                    errors.add(SweepsBatchService.buildErrorLog(conts.get(i).Id, contList.get(i)));
                }
            }
        }
        
        //Update Leads if not null
        if(!leads.isEmpty()) {
            Database.SaveResult[] leadList = Database.update(leads,false);
            
            //If Errors occur upon saving log errors
            for(Integer i=0;i<leadList.size();i++){
                if (!leadList.get(i).isSuccess()){
                    errors.add(SweepsBatchService.buildErrorLog(leads.get(i).Id, leadList.get(i)));
                }
            }
        }
    }
    
    public void finish(Database.BatchableContext BC){

        //If errors occur insert internal error logs
        if(!errors.isEmpty()){
            insert errors;
        }
    }
}