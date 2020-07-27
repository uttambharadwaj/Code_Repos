/*
 * Created by MFarrell on 7/26/2020.
 * Implementing Trigger Factory Framework for Case.
 *
 */

trigger CaseTrigger on Case (after insert, after update, before insert, before update, before delete, after delete) {
    TriggerFactory.createTriggerDispatcher(Case.SObjectType);
}


//trigger CaseTrigger on Case (before insert,after insert, after update)
//{
//    List<Case> records = trigger.isDelete ? trigger.old : trigger.new;
//
//    if(trigger.isBefore == true)
//    {
//        if(trigger.isInsert == true)
//        {
//            Ucase.updateBusinessHours(records,trigger.oldmap);
//            UCase.accountDomainMatch(Trigger.new, Trigger.oldMap);
//            UCase.setDefaultEntitlement(records, trigger.oldMap);
//            UCase.associateContact(records, trigger.oldMap);
//        }
//        else if(trigger.isUpdate == true)
//        {
//            UCase.setDefaultEntitlement(records, trigger.oldMap);
//        }
//        else if(trigger.isDelete == true)
//        {
//        }
//    }
//    else
//            if(trigger.isAfter == true)
//            {
//                if(trigger.isInsert == true)
//                {
//                    UCase.EmailToCaseOwernshipAssignment(records, trigger.oldmap);
//                    // Need this one in after op because we need the CreatedDate filled in.
//                    UCase.associateWithEntitlement(Trigger.new);
//                }
//                else if(trigger.isUpdate == true)
//                {
//                    UCase.EmailToCaseOwernshipAssignment(records, trigger.oldmap);
//                    UCase.sendCaseCloseEmailToOpportunityOwner(records, trigger.oldMap);
//                    UCase.sendCaseCloseSurveyEmail(records, trigger.oldMap);
//                    UCase.associateWithEntitlement(Trigger.new);
//                }
//                /*else if(trigger.isDelete == true)
//                {
//                }
//                else if(trigger.isUndelete == true)
//                {
//                }*/
//            }
//}