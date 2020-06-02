global class Batch_RunAppDecisioning implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    /*
    Batch_RunAppDecisioning brad = new Batch_RunAppDecisioning('select id from {{myobject}} where id in :pitt');
    brad.pitt = {{put those ids here in a list}};
    Database.executeBatch(brad,1); // do one so if it fails we can just try that one again later and not worry about it breaking the others
    */

    String query = '';
    public List<Id> pitt = new List<Id>();
    
    global Batch_RunAppDecisioning() {

    }

    global Batch_RunAppDecisioning(String theQuery){
        query = theQuery;
    }
    //essentially we are querying for some records, then iterating over those records to get the id and send it to the processing method. 
    //technically that is just silly. but it has no impact on current buttons. which is not silly. so take that.
    //TODO: move all the buttons to one AppDecisioning class; store field mappings in metadata/custom setting
    //TODO: move query in runOTRDecisioningProcess to its own method, which buttons will call. then we just send our lone record over.
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        String objName = scope[0].getSObjectType().getDescribe().getName();
        if(objName == 'OnlineApplication__c'){
            for(sObject so : scope){
                CreditDecisionEngineOTR.runHandler(so.Id);
            }
        } else if(objName == 'Application_Request__c'){
            for(sObject so : scope){
                CreditDecisionEngineNA.runHandler(so.Id);
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
}