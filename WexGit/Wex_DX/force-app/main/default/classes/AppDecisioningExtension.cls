public class AppDecisioningExtension {
  
    public List<OnlineApplication__c> onlineApps {get;set;}
    
    public AppDecisioningExtension(ApexPages.StandardSetController mySetController){
        onlineApps = (List<OnlineApplication__c>)mySetController.getSelected();
    }

    public void process(){
        List<Id> theIds = new List<Id>();
        theIds.addAll((new Map<Id,OnlineApplication__c>(onlineApps)).keySet());
        Batch_RunAppDecisioning brad = new Batch_RunAppDecisioning('select id from OnlineApplication__c where id in :pitt');
        brad.pitt = theIds;
        Database.executeBatch(brad,1); // do one so if it fails we can just try that one again later and not worry about it breaking the others
    }

}