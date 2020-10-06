/**
 * Created by mfarrell on 7/26/20.
 */

public class CaseBeforeDeleteTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        befofeDeleteHandler(tp.oldList);

    }
    public static void befofeDeleteHandler(List<Case> caseList){
        system.debug('Inside case befofeDeleteHandler');
        List<Profile> profileOfUser = [SELECT Name FROM Profile Where Id =:UserInfo.getProfileId()];
        List<RecordType> caseRecordType = [SELECT Id FROM RecordType Where SobjectType='Case' AND  Name ='Service Operations' LIMIT 1];
        String recordTypeId = caseRecordType.isEmpty()?'':caseRecordType[0].Id;
        String profileName = profileOfUser[0].Name;
        for(Case caseRecord : caseList){
             if(String.isNotBlank(recordTypeId)  && recordTypeId.equalsIgnoreCase(caseRecord.RecordTypeId)){
               if('Service Operations Agent'.equalsIgnoreCase(profileName)) {
                caseRecord.addError('You are not allowed to delete this record');
                }
             }
        }

    }

}