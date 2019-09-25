@isTest
public class FleetEnrollmentController2Test{

	public static void testFleetEnrollmentOneToOne(){

		//need to set a page with currentPage
		PageReference fePage = Page.FleetEnrollment2;
		fePage.getParameters().put('currentPage','1');
		Test.setCurrentPage(fePage);

		//first do constructor with FEC, which does pretty much nothing
		FleetEnrollmentController fec = new FleetEnrollmentController();
		FleetEnrollmentController2 fec2 = new FleetEnrollmentController2(fec);

		Test.startTest();
		//now do basic constructor, which does things
		fec2 = new FleetEnrollmentController2();

		system.assertEquals(1,fec2.minStep,'The minStep is wrong');
		system.assertEquals(3,fec2.maxStep,'The maxStep is wrong');
		system.assertEquals(1,fec2.currentStep,'The currentStep is wrong');
		system.assert(!fec2.showPreview,'It wants to show the preview');
		system.assertEquals('#',fec2.fleetEnrollment.Embossing_Second_Line__c,'Second line embossing seems off');
		system.assertEquals('custom',fec2.selectedDriverIdOption,'The selectedDriverIdOption is wrong');
		system.assertEquals(1,fec2.fleetContacts.size(),'The fleetContacts is wrong');
		system.assertEquals(1,fec2.nextFleetContactId,'The nextFleetContactId is wrong');
		system.assertEquals(0,fec2.fleetVehicles.size(),'The fleetVehicles is wrong');
		system.assertEquals(0,fec2.nextFleetVehicleId,'The nextFleetVehicleId is wrong');
		system.assertEquals(2,fec2.fleetDrivers.size(),'The fleetDrivers is wrong');
		system.assertEquals(2,fec2.nextFleetDriverId,'The nextFleetDriverId is wrong');
		
		//pretend we are on 'page one'
		fec2.cardShippingSameAsBillingAddress = false;
		fec2.nextStep();
		system.assertEquals('',fec2.fleetEnrollment.Card_Shipping_Address_Line_1__c,'Shipping line one seems off');
		system.assertEquals('',fec2.fleetEnrollment.Card_Shipping_Address_Line_2__c,'Shipping line two seems off');
		system.assertEquals('',fec2.fleetEnrollment.Card_Shipping_City__c,'Shipping city seems off');
		system.assertEquals('',fec2.fleetEnrollment.Card_Shipping_State__c,'Shipping state seems off');
		system.assertEquals('',fec2.fleetEnrollment.Card_Shipping_Postal_Code__c,'Shipping postal code seems off');

		//okay let's pretend we went to 'page two'
		fec2.currentStep = 2;
		fec2.fleetEnrollment.Number_Of_Vehicles__c = 5;
		fec2.nextStep();
		system.assertEquals(3,fec2.currentStep,'It did not move to page three');
		system.assertEquals(5,fec2.fleetVehicles.size(),'The fleetVehicles size is wrong');
		system.assert(fec2.nextStep,'The nextStep is wrong');

		Test.stopTest();

    }

}