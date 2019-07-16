public class FleetEnrollmentController2 extends FleetEnrollmentController{

    // Controller constructor
    public FleetEnrollmentController2() {

        // Setup for the pagination
        minStep = 1;
        maxStep = 3;
        currentStep = 1;
        showPreview = false;
        
        cardShippingSameAsBillingAddress = true;

        if(currentPage != null) {
            currentStep = Integer.valueOf(currentPage);
        }

        // Initialize the FleetEnrollment__c record
        fleetEnrollment = new FleetEnrollment__c();

        // Default to custom Drive ID's
        selectedDriverIdOption = 'custom';

        // Set the default embossing option
        fleetEnrollment.Embossing_Second_Line__c = '#';

        // Initialize the local FleetContacts collection
        fleetContacts = new List<FleetContact>();
        nextFleetContactId = 0;

        for(Integer i = 0; i < 1; i++) {
            addNewContact();
        }

        // Initialize the local FleetVehicles collection
        fleetVehicles = new List<FleetVehicle>();
        nextFleetVehicleId = 0;

        // Initialize the local FleetDrivers collection
        fleetDrivers = new List<FleetDriver>();
        nextFleetDriverId = 0;

        for(Integer i = 0; i < 2; i++) {
            addNewFleetDriver();
        }

    }

    public FleetEnrollmentController2(FleetEnrollmentController fc){}

    public override void nextStep() {

        if(currentStep == 1) {
            setCardShippingSame();
        }

        if(currentStep == 2 && program.Fleet_Enrollment_Disable_Driver_Page__c == true) {
            currentStep = currentStep + 1;
        }
        else {
            currentStep = currentStep + 1;
        }

        if(currentStep == 2) {
            setupFleetVehicles();
        }

    }

}