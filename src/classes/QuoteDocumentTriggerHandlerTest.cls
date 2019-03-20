@isTest
public class QuoteDocumentTriggerHandlerTest {
    public static testmethod void insertDoc() {
        OnlineApplicationOffer__c offer1 = new OnlineApplicationOffer__c(Application_Title__c = 'test', Complete_Later_Text__c = 'test', EchoSign_User_Email__c = 'test@test.com', Terms_and_Conditions_Version__c = '1.0');
        insert offer1;

        SBQQ__Quote__c q1 = new SBQQ__Quote__c(Online_Application_Offer__c = offer1.Id);
        insert q1;
        q1 = [select OwnerId from SBQQ__Quote__c where Id = :q1.Id];


        SBQQ__QuoteDocument__c doc1 = new SBQQ__QuoteDocument__c(SBQQ__SignatureStatus__c = 'Signed', Incorporation_Date__c = '2008', SBQQ__Quote__c = q1.Id);
        insert doc1;
        doc1 = [select Online_Application__c, SBQQ__Quote__r.OwnerId from SBQQ__QuoteDocument__c where Id = : doc1.Id];
        System.assert(doc1.Online_Application__c != null);
        OnlineApplication__c app = [select OwnerId, Offer__c, Application_Stage__c, Status__c,  Year_Established__c from OnlineApplication__c where Id = :doc1.Online_Application__c];

        System.assertEquals(q1.OwnerId, app.OwnerId);
        System.assertEquals(offer1.Id, app.Offer__c);
        System.assertEquals('Application', app.Application_Stage__c);
        System.assertEquals('Saved-Complete', app.Status__c);
        System.assertEquals('2008', app.Year_Established__c);
    }

    public static testmethod void updateDoc() {
        OnlineApplicationOffer__c offer1 = new OnlineApplicationOffer__c(Application_Title__c = 'test', Complete_Later_Text__c = 'test', EchoSign_User_Email__c = 'test@test.com', Terms_and_Conditions_Version__c = '1.0');
        insert offer1;
        SBQQ__Quote__c q1 = new SBQQ__Quote__c();
        insert q1;
        q1 = [select OwnerId from SBQQ__Quote__c where Id = :q1.Id];

        SBQQ__QuoteDocument__c doc1 = new SBQQ__QuoteDocument__c(SBQQ__Quote__c = q1.Id);
        insert doc1;

        List<OnlineApplication__c> appList = [select Id from OnlineApplication__c];
        System.assertEquals(0, appList.size());

        q1.Online_Application_Offer__c = offer1.Id;
        update q1;

        doc1.Incorporation_Date__c = '2008' ;
        update doc1;

        appList = [select Id from OnlineApplication__c];
        System.assertEquals(0, appList.size());

        doc1.SBQQ__SignatureStatus__c = 'Signed';
        update doc1;

        appList = [select OwnerId, Offer__c, Application_Stage__c, Status__c, Year_Established__c from OnlineApplication__c];
        System.assertEquals(1, appList.size());

        doc1 = [select Online_Application__c, SBQQ__Quote__r.OwnerId from SBQQ__QuoteDocument__c where Id = : doc1.Id];
        System.assert(doc1.Online_Application__c != null);

        OnlineApplication__c app = appList[0];

        System.assertEquals(q1.OwnerId, app.OwnerId);
        System.assertEquals(offer1.Id, app.Offer__c);
        System.assertEquals('Application', app.Application_Stage__c);
        System.assertEquals('Saved-Complete', app.Status__c);
        System.assertEquals('2008', app.Year_Established__c);

    }

    public static testmethod void bulkInsertDoc() {
        OnlineApplicationOffer__c offer1 = new OnlineApplicationOffer__c(Application_Title__c = 'test', Complete_Later_Text__c = 'test', EchoSign_User_Email__c = 'test@test.com', Terms_and_Conditions_Version__c = '1.0');
        insert offer1;
        SBQQ__Quote__c q1 = new SBQQ__Quote__c(Online_Application_Offer__c = offer1.Id);
        insert q1;
        List<SBQQ__QuoteDocument__c> docList = new List<SBQQ__QuoteDocument__c>();
        for (Integer i = 0; i < 200; i++) {
            SBQQ__QuoteDocument__c doc1 = new SBQQ__QuoteDocument__c(SBQQ__SignatureStatus__c = 'Signed', Incorporation_Date__c = '2008', SBQQ__Quote__c = q1.Id);
            docList.add(doc1);
        }

        insert docList;

        for (SBQQ__QuoteDocument__c doc : [select Online_Application__c, SBQQ__Quote__r.OwnerId from SBQQ__QuoteDocument__c]) {
            System.assert(doc.Online_Application__c != null);
        }

        List<OnlineApplication__c> appList = [select Application_Stage__c, Status__c, Year_Established__c from OnlineApplication__c];

        System.assertEquals(200,  appList.size());

        for (OnlineApplication__c app : appList ) {
            System.assertEquals('Application', app.Application_Stage__c);
            System.assertEquals('Saved-Complete', app.Status__c);
            System.assertEquals('2008', app.Year_Established__c);

        }
    }

    public static testmethod void insertUpdateDoc() {
        OnlineApplicationOffer__c offer1 = new OnlineApplicationOffer__c(Application_Title__c = 'test', Complete_Later_Text__c = 'test', EchoSign_User_Email__c = 'test@test.com', Terms_and_Conditions_Version__c = '1.0');
        insert offer1;
        SBQQ__Quote__c q1 = new SBQQ__Quote__c(Online_Application_Offer__c = offer1.Id);
        insert q1;
        SBQQ__QuoteDocument__c doc1 = new SBQQ__QuoteDocument__c(SBQQ__SignatureStatus__c = 'Signed', SBQQ__Quote__c = q1.Id);
        insert doc1;

        List<OnlineApplication__c> appList = [select Id from OnlineApplication__c];
        System.assertEquals(1, appList.size());

        doc1.Incorporation_Date__c = '2012';
        update doc1;

        appList = [select Id, Year_Established__c from OnlineApplication__c];
        System.assertEquals(1, appList.size());
        System.assertEquals('2012', appList[0].Year_Established__c);
    }
}