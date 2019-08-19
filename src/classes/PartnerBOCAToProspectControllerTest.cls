@isTest
public with sharing class PartnerBOCAToProspectControllerTest {

    public static void testPBPSend(){

        //we will test with a fun partner
        Id howdyPartner = [SELECT Id FROM Partner__c WHERE Partner_Key__c = 'howdy' LIMIT 1].Id;

        //we will need programs
        Program__c otrProgram = [SELECT Id FROM Program__c WHERE Partner__c = :howdyPartner AND BOCA_Type__c = 'OTR' LIMIT 1];
        Program__c nafProgram = [SELECT Id FROM Program__c WHERE Partner__c = :howdyPartner AND BOCA_Type__c = 'Fuel Card' LIMIT 1];
        Program__c cpProgram = [SELECT Id FROM Program__c WHERE Partner__c = :howdyPartner AND BOCA_Type__c = 'CPBOCA' LIMIT 1];
        OnlineApplicationOffer__c otrOffer = [SELECT Id FROM OnlineApplicationOffer__c WHERE Program__c = :otrProgram.Id LIMIT 1];

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
        PartnerBOCAToProspectController pbpFail = new PartnerBOCAToProspectController();
        pbpFail.init();
        pbpFail.partnerBOCAtoProspect.Partner_Opportunity_ID__c = 'not really an oppty id';
        pbpFail.partnerBOCAtoProspect.Sales_Rep_Code__c = 'reps digits go here';
        pbpFail.partnerBOCAtoProspect.Partner_Sales_Code__c = 'not howdy'; //will fail bc partner sales code does not match

        PartnerBOCAToProspectController pbpOTR = new PartnerBOCAToProspectController();
        pbpOTR.init();
        pbpOTR.partnerBOCAtoProspect.Partner_Opportunity_ID__c = 'not really an oppty id';
        pbpOTR.partnerBOCAtoProspect.Sales_Rep_Code__c = 'reps digits go here';
        pbpOTR.partnerBOCAtoProspect.Partner_Sales_Code__c = 'salskid';
        pbpOTR.selectedProgram = otrProgram.Id;
        pbpOTR.selectedOffer = otrOffer.Id;

        PartnerBOCAToProspectController pbpNAF = new PartnerBOCAToProspectController();
        pbpNAF.init();
        pbpNAF.partnerBOCAtoProspect.Partner_Opportunity_ID__c = 'not really an oppty id';
        pbpNAF.partnerBOCAtoProspect.Sales_Rep_Code__c = 'reps digits go here';
        pbpNAF.partnerBOCAtoProspect.Partner_Sales_Code__c = 'salskid';
        pbpOTR.selectedProgram = nafProgram.Id;

        PartnerBOCAToProspectController pbpCP = new PartnerBOCAToProspectController();
        pbpCP.init();
        pbpCP.partnerBOCAtoProspect.Partner_Opportunity_ID__c = 'not really an oppty id';
        pbpCP.partnerBOCAtoProspect.Sales_Rep_Code__c = 'reps digits go here';
        pbpCP.partnerBOCAtoProspect.Partner_Sales_Code__c = 'salskid';
        pbpOTR.selectedProgram = cpProgram.Id;

        PageReference mypbpFail;
        PageReference mypbpOTR;
        PageReference mypbpNAF;
        PageReference mypbpCP;

        Test.startTest();
        mypbpFail = pbpFail.sendApplication();
        mypbpOTR = pbpOTR.sendApplication();
        mypbpNAF = pbpNAF.sendApplication();
        mypbpCP = pbpCP.sendApplication();
        Test.stopTest();

        /*
            assert correct object was created
            assert pbtp record created
            assert email sent
            assert redirect
         */
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