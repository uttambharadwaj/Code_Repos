@isTest
public with sharing class PartnerBOCAToProspectControllerTest {

    public static void testPBP(){
        //get stuff
        //we need to do an init without a correct partner. assert fail
        //we need to do an init with a correct partner
        //we need to do an init with an action param 'confirm'. assert things
        //we need to do an init with an action param 'unfounded'. assert fail

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

        pbpPage.getParameters().put('action', 'confirm');
        PartnerBOCAToProspectController pbp2 = new PartnerBOCAToProspectController(); //test success init for confirm action

        pbpPage.getParameters().put('action', 'nowaythisisarealactioncode');
        PartnerBOCAToProspectController pbp3 = new PartnerBOCAToProspectController(); //test fail init for faulty action

        pbpPage.getParameters().put('partner', 'nowaythisisarealpartnercode');
        PartnerBOCAToProspectController pbp4 = new PartnerBOCAToProspectController(); //test fail for faulty partner

        pbpPage.getParameters().put('partner', '');
        PartnerBOCAToProspectController pbp5 = new PartnerBOCAToProspectController(); //test success init for no partner param

        Partner_BOCA_To_Prospect__c myPBP1;
        PageReference myPBP2;
        PageReference myPBP3;
        PageReference myPBP4;
        PageReference myPBP5;


        //test stuff
        Test.startTest();
        //we need to do an init with a correct partner
        pbp1.init();
        myPBP1 = pbp1.partnerBOCAtoProspect;

        myPBP2 = pbp2.init(); //we need to do an init with an action param 'confirm'. assert null

        myPBP3 = pbp3.init(); //we need to do an init with an action param 'unfounded'. assert fail

        myPBP4 = pbp4.init(); //we need to do an init without a correct partner. assert fail

        myPBP5 = pbp5.init(); //we need to do an init with a blank partner. assert null

        Test.stopTest();

        //assert stuff
        system.assertEquals('cow', myPBP1.First_Name__c); //pbp should update bc success
        system.assertEquals(null, myPBP2); //init should be null
        system.assert(myPBP3.getURL().contains('ExternalApplicationError'), 'It did not error as expected.'); //should error out with message
        system.assert(myPBP4.getURL().contains('ExternalApplicationError'), 'It did not error as expected.'); //should error out with message
        system.assertEquals(null, myPBP5); //pbp should be null
    }
}