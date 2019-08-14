public without sharing class TakeOwnershipController {
    @AuraEnabled
    public static Boolean changeOwnerServ(String recordId) {
        List<Case> caseList = [SELECT Id FROM Case WHERE Id = :recordId];
        if (!caseList.isEmpty()) {
            Case c = caseList[0];
            c.OwnerId = UserInfo.getUserId();
            update c;
            return true;
        }
        return false;
    }
}