public class AppDecisioningExtension2 {
  
    public List<Application_Request__c> appRequests {get;set;}
    
    public AppDecisioningExtension2(ApexPages.StandardSetController mySetController){
        appRequests = (List<Application_Request__c>)mySetController.getSelected();
    }

    public void process(){
        List<Id> theIds = new List<Id>();
        theIds.addAll((new Map<Id,Application_Request__c>(appRequests)).keySet());
        Batch_RunAppDecisioning brad = new Batch_RunAppDecisioning('select id from Application_Request__c where id in :pitt');
        brad.pitt = theIds;
        Database.executeBatch(brad,1); // do one so if it fails we can just try that one again later and not worry about it breaking the others
    }

}