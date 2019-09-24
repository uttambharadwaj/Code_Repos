@isTest
public class ContactUnsubscribeControllerTest{

    public static void testContactUnsubscribe(){

        Program__c pro = [SELECT Id, Brand_Short_Name__c FROM Program__c WHERE Name = 'Test 2' LIMIT 1];
        Contact con = [SELECT Id FROM Contact LIMIT 1];

        //need to set a page with currentPage
        PageReference cuPage = Page.ContactUnsubscribe;
        cuPage.getParameters().put('pgm',pro.Brand_Short_Name__c);
        cuPage.getParameters().put('id',con.Id);
        Test.setCurrentPage(cuPage);

        ContactUnsubscribeController cuc = new ContactUnsubscribeController();

        Test.startTest();
        //do the init
        cuc.init();
        Test.stopTest();

        con = [SELECT Email,HasOptedOutOfEmail FROM Contact WHERE Id = :con.Id LIMIT 1];

        system.assertNotEquals(null,cuc.brandingLogo,'The logo was unfounded');
        system.assertEquals(con.Email,cuc.emailAddress,'The contact email address is wrong');
        system.assert(con.HasOptedOutOfEmail,'The contact is still subscribed');

    }

    public static void testLeadUnsubscribe(){

        Program__c pro = [SELECT Id, Brand_Short_Name__c FROM Program__c WHERE Name = 'Test 2' LIMIT 1];
        Lead myLead = [SELECT Id FROM Lead LIMIT 1];

        //need to set a page with currentPage
        PageReference cuPage = Page.ContactUnsubscribe;
        cuPage.getParameters().put('pgm',pro.Brand_Short_Name__c);
        cuPage.getParameters().put('id',myLead.Id);
        Test.setCurrentPage(cuPage);

        ContactUnsubscribeController cuc = new ContactUnsubscribeController();

        Test.startTest();
        //do the init
        cuc.init();
        Test.stopTest();

        myLead = [SELECT Email,HasOptedOutOfEmail FROM Lead WHERE Id = :myLead.Id LIMIT 1];

        system.assertNotEquals(null,cuc.brandingLogo,'No logo found');
        system.assertEquals(myLead.Email,cuc.emailAddress,'The lead email address is wrong');
        system.assert(myLead.HasOptedOutOfEmail,'The lead is still subscribed');

    }

}