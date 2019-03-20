public class FleetEnrollmentConfirmationController {

    public String printToken {
        get {
            return ApexPages.currentPage().getParameters().get('token');
        }
    }
    
    public String applicantId { 
        get {
            return ApexPages.currentPage().getParameters().get('applicant');
        }
    }
    
    public FleetEnrollment__c fleetEnrollment { 
        get {
            FleetEnrollment__c fleetEnrollment = [SELECT Id, Credit_Line_Amount__c, Confirmation_Number__c, Credit_Approved__c, Program__c FROM FleetEnrollment__c WHERE Print_Token__c = :printToken and Id = :applicantId];
            return fleetEnrollment;
        }
    }
    
    // Branding - Elements from the specified program
    public Program__c program { 
        get {
            Program__c program = [SELECT Id, Fleet_Data_Capture_Form_Delivery__c, Brand_Long_Name__c, Implementation_Team_Number__c, Brand_Color_1__c FROM Program__c WHERE Id = :fleetEnrollment.Program__c];
            
            return program; 
        }
    }
    
    // Branding - Card image from the chosen program
    public Id brandingCard { 
        get {
            transient Attachment card = [SELECT Id, Name, Body FROM Attachment where ParentId = : program.Id AND Name=:'ui-credit-card.png'];
            return card.Id;
        }
    }

}