@isTest
public with sharing class PartnerBOCAToProspectControllerTest {

    public static void testPBPSend(){

        //we will test with a fun partner
        Id howdyPartner = [SELECT Id FROM Partner__c WHERE Partner_Key__c = 'howdy' LIMIT 1].Id;
        Integer programCount = [SELECT count() FROM Program__c WHERE Partner__c = :howdyPartner AND Publish_BOCA__c = TRUE];

        //we will need programs
        Program__c otrProgram = [SELECT Id FROM Program__c WHERE Partner__c = :howdyPartner AND BOCA_Type__c = 'OTR' LIMIT 1];
        Integer offerCount = [SELECT count() FROM OnlineApplicationOffer__c WHERE Program__c = :otrProgram.Id];
        Program__c nafProgram = [SELECT Id FROM Program__c WHERE Partner__c = :howdyPartner AND BOCA_Type__c = 'Fuel Card' LIMIT 1];
        Program__c cpProgram = [SELECT Id FROM Program__c WHERE Partner__c = :howdyPartner AND BOCA_Type__c = 'CPBOCA' LIMIT 1];
        OnlineApplicationOffer__c otrOffer = [SELECT Id FROM OnlineApplicationOffer__c WHERE Program__c = :otrProgram.Id LIMIT 1];

        //also need to know about emails
        Integer initialEmailCount = Limits.getEmailInvocations();

        //set up the page
        PageReference pbpPage = Page.PartnerBOCAToProspect;
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
        pbpPage.getParameters().put('partner','howdy'); //only required parameter
        pbpPage.getParameters().put('partnerDataField1','Test1');
        pbpPage.getParameters().put('partnerDataField2','Test2');
        pbpPage.getParameters().put('partnerDataField3','Test3');
        pbpPage.getParameters().put('partnerDataField4','Test4');
        pbpPage.getParameters().put('partnerDataField5','Test5');
        Test.setCurrentPage(pbpPage);

        //make the controller and then pretend to have filled something out
        PartnerBOCAToProspectController pbpFail = new PartnerBOCAToProspectController();
        pbpFail.init();
        pbpFail.partnerBOCAtoProspect.Partner_Opportunity_ID__c = 'not a real oppty id';
        pbpFail.partnerBOCAtoProspect.Sales_Rep_Code__c = 'reps digits go here';
        pbpFail.partnerBOCAtoProspect.Partner_Sales_Code__c = 'not howdy'; //will fail bc partner sales code does not match

        PartnerBOCAToProspectController pbpOTR = new PartnerBOCAToProspectController();
        pbpOTR.init();
        pbpOTR.partnerBOCAtoProspect.Partner_Opportunity_ID__c = 'not a real oppty id';
        pbpOTR.partnerBOCAtoProspect.Sales_Rep_Code__c = 'reps digits go here';
        pbpOTR.partnerBOCAtoProspect.Partner_Sales_Code__c = 'salskid';
        pbpOTR.selectedProgram = otrProgram.Id;
        pbpOTR.selectedOffer = otrOffer.Id;

        PartnerBOCAToProspectController pbpNAF = new PartnerBOCAToProspectController();
        pbpNAF.init();
        pbpNAF.partnerBOCAtoProspect.Partner_Opportunity_ID__c = 'not a real oppty id';
        pbpNAF.partnerBOCAtoProspect.Sales_Rep_Code__c = 'reps digits go here';
        pbpNAF.partnerBOCAtoProspect.Partner_Sales_Code__c = 'salskid';
        pbpNAF.selectedProgram = nafProgram.Id;

        PartnerBOCAToProspectController pbpCP = new PartnerBOCAToProspectController();
        pbpCP.init();
        pbpCP.partnerBOCAtoProspect.Partner_Opportunity_ID__c = 'not a real oppty id';
        pbpCP.partnerBOCAtoProspect.Sales_Rep_Code__c = 'reps digits go here';
        pbpCP.partnerBOCAtoProspect.Partner_Sales_Code__c = 'salskid';
        pbpCP.selectedProgram = cpProgram.Id;

        PageReference mypbpFail;
        PageReference mypbpOTR;
        PageReference mypbpNAF;
        PageReference mypbpCP;

        Test.startTest();
        mypbpFail = pbpFail.sendApplication();
        mypbpOTR = pbpOTR.sendApplication();
        List<SelectOption> programList = pbpOTR.additionalPrograms;
        List<SelectOption> offerList = pbpOTR.additionalOffers;
        mypbpNAF = pbpNAF.sendApplication();
        mypbpCP = pbpCP.sendApplication();
        Integer postEmailCount = Limits.getEmailInvocations() - initialEmailCount;
        Test.stopTest();

        Id mypbpOTRId = (Id)mypbpOTR.getParameters().get('appId');
        Id mypbpNAFId = (Id)mypbpNAF.getParameters().get('appId');
        Id mypbpCPId = (Id)mypbpCP.getParameters().get('appId');

        //assert stuff
        system.assertEquals(null, pbpFail.bocaType, 'It found a BOCA type before it should have.');
        system.assertEquals(null, pbpFail.additionalOffers, 'It found a possible program offer before it should have.');
        system.assert(mypbpFail.getURL().containsIgnoreCase('ExternalApplicationError'), 'It did not error as expected.'); //should error out with message
        system.assertEquals(mypbpOTRId.getsobjecttype().getDescribe().getName(), 'OnlineApplication__c', 'It did not create the expected application.');
        system.assertEquals(programCount + 1, programList.size(), 'It did not find the expected number of programs.'); //plus one bc we also have a select option for 'choose one'
        system.assertEquals(offerCount + 1, offerList.size(), 'It did not find the expected number of program offers.'); //plus one bc we also have a select option for 'choose one'
        system.assertEquals('OTR', pbpOTR.bocaType, 'It found a completely different BOCA type.');
        system.assertEquals(mypbpNAFId.getsobjecttype().getDescribe().getName(), 'WeFormObject__c', 'It did not create the expected application.');
        system.assertEquals(null, pbpNAF.additionalOffers, 'It found an offer for an Application Request record.');
        system.assertEquals(mypbpCPId.getsobjecttype().getDescribe().getName(), 'CP_Application_Request__c', 'It did not create the expected application.');
        system.assertEquals(3, postEmailCount, 'It did not send the expected number of emails.');
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
        pbpPage.getParameters().put('partnerDataField1','Test1');
        pbpPage.getParameters().put('partnerDataField2','Test2');
        pbpPage.getParameters().put('partnerDataField3','Test3');
        pbpPage.getParameters().put('partnerDataField4','Test4');
        pbpPage.getParameters().put('partnerDataField5','Test5');
        Test.setCurrentPage(pbpPage);

        //make the controller so we can init
        PartnerBOCAToProspectController pbp1 = new PartnerBOCAToProspectController();

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
        system.assert(myPBP3.getURL().containsIgnoreCase('ExternalApplicationError'), 'It did not error as expected.'); //should error out
        system.assert(myPBP4.getURL().containsIgnoreCase('ExternalApplicationError'), 'It did not error as expected.'); //should error out
        system.assertEquals(null, myPBP5); //pbp should null
    }
}