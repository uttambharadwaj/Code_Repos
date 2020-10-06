@isTest
private class ProgramArticlesControllerTest {
    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testmethod void testController() {
        Program__c program = new Program__c(Name = 'test');
        insert program;
        Account acc = new Account(Name='test', Program__c = program.Id);
        insert acc;
        Case c = new Case(Subject = 'test', Status = 'New', Description = 'test desc', AccountId = acc.Id);
        insert c;
        Knowledge__kav article =  new Knowledge__kav (Title='test article',  UrlName='testUrl', Language='en_US', Account__c = acc.Id);
        insert article;
        article = [SELECT KnowledgeArticleId FROM Knowledge__kav WHERE Id =: article.Id];
        KbManagement.PublishingService.publishArticle(article.KnowledgeArticleId, true);

        Test.startTest();
        List<Knowledge__kav> articleList = ProgramArticlesController.getArticlesServ(c.Id);
        Test.stopTest();

        System.assertEquals(1, articleList.size());
        System.assertEquals(article.Id, articleList[0].Id);
    }
}