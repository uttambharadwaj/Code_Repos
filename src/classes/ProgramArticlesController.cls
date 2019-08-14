public with sharing class ProgramArticlesController {
    @AuraEnabled
    public static List<Knowledge__kav> getArticlesServ(String recordId) {
        List<Case> caseList = [SELECT AccountId, Account.Program__c FROM Case WHERE Id = :recordId AND Account.Program__c!=null];
        if (!caseList.isEmpty()) {
            List<Knowledge__kav> articleList = [SELECT Id FROM Knowledge__kav WHERE PublishStatus = 'Online' AND (Account__c =: caseList[0].AccountId OR Program__c =: caseList[0].Account.Program__c) ORDER BY ArticleNumber ASC];
            if (!articleList.isEmpty()) {
                return articleList;
            }
        }
        return null;
    }
}