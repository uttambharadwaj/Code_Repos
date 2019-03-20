// revision history https://gist.github.com/aplssf/0d7aa2ec27247e808b1e/revisions
trigger WE_MasterOpportunityTrigger on Opportunity (
    before insert, after insert,
    before update, after update,
    before delete, after delete)
{
    
  //  if (Trigger.isBefore) {
    //    if (Trigger.isInsert) { }
    //    if (Trigger.isUpdate)
    //    {
    //        WE_OppUpdates.updateOpportunities(Trigger.old,Trigger.new);
    //    }
   //     if (Trigger.isDelete) { }
 //   }

  //  if (Trigger.isAfter) {
     //   if (Trigger.isInsert)
      //  {
       //     WE_OppUpdates.recursiveInsert(Trigger.new);

            //WE_MRFv3 forecast = new WE_MRFv3(true,Trigger.newMap);
            //forecast.generateMRF();

       //     WE_TargetManager target = new WE_TargetManager(Trigger.newMap);
        //    target.generateNewTargets();

       //     WE_ImpProjectManager projectManager = new WE_ImpProjectManager(Trigger.oldMap,Trigger.newMap);
       //     projectManager.evaluateOpportunities();
       // }
      //  if (Trigger.isUpdate)
      //  {
            // Class has to execute in After context because it needs values from OppUpdates
            //WE_MRFv3 forecast = new WE_MRFv3(Trigger.oldMap,Trigger.newMap);
            //forecast.generateMRF();

       //     WE_TargetManager target = new WE_TargetManager(Trigger.oldMap,Trigger.newMap);
       //     target.updateTargets();

       //     WE_ImpProjectManager projectManager = new WE_ImpProjectManager(Trigger.oldMap,Trigger.newMap);
        //    projectManager.evaluateOpportunities();
            
      //      WE_WinLossSurvey survey = new WE_WinLossSurvey(Trigger.oldMap,Trigger.newMap);
     //   }
     //   if (Trigger.isDelete) { }
    //}
}