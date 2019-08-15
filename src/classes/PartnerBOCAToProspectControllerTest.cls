@isTest
public with sharing class PartnerBOCAToProspectControllerTest {

    public static void testPBPSend(){

        //set up the page
        PageReference pbpPage = Page.PartnerBOCAToProspect;
        pbpPage.getParameters().put('partner','howdy'); //only required parameter
        pbpPage.getParameters().put('firstName','cow');
        pbpPage.getParameters().put('lastName','boi');
        pbpPage.getParameters().put('email','cowboi@example.com');
        pbpPage.getParameters().put('phone','555-867-5309');
        pbpPage.getParameters().put('companyName','dud ranch');
        pbpPage.getParameters().put('opportunityId','006000000000123');
        pbpPage.getParameters().put('repFirstName','John');
        pbpPage.getParameters().put('repLastName','Wayne');
        pbpPage.getParameters().put('repEmail','johnwayne@example.com');
        pbpPage.getParameters().put('repPhone','719-266-2837');
        Test.setCurrentPage(pbpPage);

        //make the controller and then pretend to have filled something out
        PartnerBOCAToProspectController pbp = new PartnerBOCAToProspectController();
        pbp.partnerBOCAtoProspect.Partner_Opportunity_ID__c = 'not really an oppty id';
        pbp.partnerBOCAtoProspect.Sales_Rep_Code__c = 'reps digits go here';
        pbp.partnerBOCAtoProspect.Partner_Sales_Code__c = 'not howdy';

        Test.startTest();
        //we need to send application with incorrect sales code: assert error

        //we need to send application with correct sales code. three times (three objects) : assert things:

        /*
            assert correct object was created
            assert pbtp record created
            assert email sent
            assert redirect
         */

        //test stuff
        Test.stopTest();

        //assert stuff
    }

    public static void testInits(){

        //set up the page
        PageReference pbpPage = Page.PartnerBOCAToProspect;
        pbpPage.getParameters().put('partner','howdy'); //only required parameter
        pbpPage.getParameters().put('firstName','cow');
        pbpPage.getParameters().put('lastName','boi');
        pbpPage.getParameters().put('email','cowboi@example.com');
        pbpPage.getParameters().put('phone','555-867-5309');
        pbpPage.getParameters().put('companyName','dud ranch');
        pbpPage.getParameters().put('opportunityId','006000000000123');
        pbpPage.getParameters().put('repFirstName','John');
        pbpPage.getParameters().put('repLastName','Wayne');
        pbpPage.getParameters().put('repEmail','johnwayne@example.com');
        pbpPage.getParameters().put('repPhone','719-266-2837');
        Test.setCurrentPage(pbpPage);

        //make the controller so we can init
        PartnerBOCAToProspectController pbp1 = new PartnerBOCAToProspectController(); //test success init

        //currently five different results for an init
        Partner_BOCA_To_Prospect__c myPBP1;
        PageReference myPBP2;
        PageReference myPBP3;
        PageReference myPBP4;
        PageReference myPBP5;

        //test stuff
        Test.startTest();

        pbp1.init(); //init with a correct partner
        myPBP1 = pbp1.partnerBOCAtoProspect;

        pbpPage.getParameters().put('action', 'confirm');
        myPBP2 = pbp1.init(); //init with an action param 'confirm'. assert null

        pbpPage.getParameters().put('action', 'nowaythisisarealactioncode');
        myPBP3 = pbp1.init(); //init with unfounded action param. assert fail

        pbpPage.getParameters().put('partner', 'nowaythisisarealpartnercode');
        myPBP4 = pbp1.init(); //init without a correct partner. assert fail

        pbpPage.getParameters().put('partner', null);
        myPBP5 = pbp1.init(); //init with a blank partner. assert null

        Test.stopTest();

        //assert stuffs
        system.assertEquals('cow', myPBP1.First_Name__c); //pbp should update bc success
        system.assertEquals('boi', myPBP1.Last_Name__c); //pbp should update bc success
        system.assertEquals(null, myPBP2); //init should null
        system.assert(myPBP3.getURL().containsIgnoreCase('ExternalApplicationError'), 'It did not error as expected.'); //should error out with message
        system.assert(myPBP4.getURL().containsIgnoreCase('ExternalApplicationError'), 'It did not error as expected.'); //should error out with message
        system.assertEquals(null, myPBP5); //pbp should null
    }
}