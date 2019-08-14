public class FleetEnrollmentPrintController {

    public String fleetEnrollmentId { get; set; }
    public String printToken { get; set; }
    
    public FleetEnrollment__c fleetEnrollment {
        get { 
        	FleetEnrollment__c fleetEnrollment = [SELECT Id, Billing_Full_Name__c, Billing_Phone__c, Billing_Email__c, Billing_Address_Line_1__c, Billing_Address_Line_2__c, 
                                                  Billing_City__c, Billing_State__c, Billing_Postal_Code__c, Company_Name__c, Confirmation_Number__c, Embossing_Company_Name__c, Embossing_Second_Line__c, 
                                                  Driver_ID_Random__c, Number_Of_Vehicles__c, Program__c, Report_VehicleId__c, Reporting_Dept__c, Report_LicensePlt__c, Report_VehicleDesc__c  
                                                  FROM FleetEnrollment__c WHERE Id = :fleetEnrollmentId and Print_Token__c = :printToken];
            return fleetEnrollment;
        }
    }
    
    public List<FleetEnrollment_Contact__c> fleetEnrollmentContacts {
        get {
            List<FleetEnrollment_Contact__c> fleetEnrollmentContacts = [SELECT Full_Name__c, Email__c, Phone__c FROM FleetEnrollment_Contact__c WHERE Fleet_Enrollment__c = :fleetEnrollment.Id];
            return fleetEnrollmentContacts;
        }
    }
    
    public List<FleetEnrollment_Vehicle__c> fleetEnrollmentVehicles {
        get {
           List<FleetEnrollment_Vehicle__c> fleetEnrollmentVehicles = [SELECT Customer_Vehicle_ID__c, Card_Control_Type__c, Department__c, License_Plate__c, Vehicle_Description__c, Prompt_Options__c, Acceptance__c 
                                                                       FROM FleetEnrollment_Vehicle__c WHERE Fleet_Enrollment__c = :fleetEnrollment.Id];
           return fleetEnrollmentVehicles;
        }
    }
    
    public List<FleetEnrollment_Driver__c> fleetEnrollmentDrivers {
        get {
            List<FleetEnrollment_Driver__c> fleetEnrollmentDrivers = [SELECT First_Name__c, Last_Name__c, Driver_ID__c FROM FleetEnrollment_Driver__c WHERE Fleet_Enrollment__c = :fleetEnrollment.Id];
            return fleetEnrollmentDrivers;
        }
    }
    
    public Program__c program { 
        get {
            Program__c program = [SELECT Id, Brand_Long_Name__c, Inside_Sales_Phone_Number__c, Brand_Color_1__c, Fleet_Enrollment_Enable_Prompt_Options__c, 
                                  Fleet_Enrollment_Enable_Universal_PL__c, Fleet_Enrollment_Disable_Driver_Page__c FROM Program__c WHERE Id = :fleetEnrollment.Program__c];
            
            return program; 
        }
    }
    
    public FleetEnrollmentPrintController() {
        
        printToken = ApexPages.currentPage().getParameters().get('token');
        fleetEnrollmentId = ApexPages.currentPage().getParameters().get('id');
        
    }
    
}