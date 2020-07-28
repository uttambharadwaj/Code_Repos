trigger CaseFetchUserRole on Case (before insert, before update) {
//
//    please tell me this can just be commented out and deleted...
//
//    Bulk_Data_Load_Settings__c bulkDataLoadSettings = Bulk_Data_Load_Settings__c.getInstance();
//    if(bulkDataLoadSettings != null && bulkDataLoadSettings.Disable_Case_Automation__c) { return; }
//
//    Case currentCase = trigger.new[0];
//    Id recTypeId = currentCase.RecordTypeId;
//
//    try{
//        if (recTypeId != null){
//
//            String recTypeStr = (((String)recTypeId).substring(0,15));
//            RecordType recType = [select name from RecordType where id = :recTypeStr ];
//
//            //only set the role for the 'WEX Salesforce Support Request' recordtype
//            if (recType.Name.equals('WEX Salesforce Support Request')){
//                Id requestorId = currentCase.User__c;
//                User requestor = [select id, name, UserRoleId, ProfileId from User where id = :requestorId];
//
//                if (requestor.ProfileId != null){
//                    String profileStr = ((String)requestor.ProfileId).substring(0,15);
//                    Profile myProfile = [select id, Name from Profile where id = :profileStr];
//                    currentCase.Requestors_Profile__c = myProfile.Name;
//
//                } else {
//                    System.debug('CaseFetchUserRole Trigger: No role for this person');
//                    currentCase.Requestors_Profile__c = '';
//                }
//            }else{
//                System.debug('CaseFetchUserRole Trigger: Different recordtype than salesforce enhancement: ' + recType.Name);
//            }
//
//        }
//    } catch (Exception e){
//        System.debug('Exception in CaseFetchUserRole Trigger: ' + e.getStackTraceString());
//        System.debug('Exception in CaseFetchUserRole Trigger Message: ' + e.getMessage());
//    }
}