/*
* 
* This class provides generic access to Program elements
* 
*/
public class BrandingController {
    
    public String programParameter {
        get {
            if(ApexPages.CurrentPage().getParameters().get('pgm') != null) {
                return ApexPages.CurrentPage().getParameters().get('pgm');
            }
            return null;
        }
    }
    
    public BrandingController() {
        
    }
    
    // Branding logo related to the program
    public Id brandingLogo { get; set; }
    
    // Branding card related to the program
    public Id brandingCard { get; set; }
    
    public Program__c program { get; set; }
    
    public BOCA_res__c brandingUtility { get; set; }
    
    public void init() {
        
        if(!String.isEmpty(programParameter)) {
            
            // Setup the program
            List<Program__c> programs = [SELECT Id, Live_Person_Code__c, Publish_BOCA__c, Custom_Email_Header_URL__c, 
                                         Analytics_Body_Block__c, Analytics_Head_Block__c, Peoplesoft_rel_code__c, 
                                         Upload_Pricing_Data_Flag__c, T_C__c, Brand_Long_Name__c, BOCA_Disclaimer__c,
                                         Inside_Sales_Phone_Number__c, Brand_Color_1__c, Brand_Color_2__c, Confirmation_Info__c, BOCA_Type__c, Always_Require_PG__c
                                         FROM Program__c WHERE Brand_Short_Name__c = :programParameter];   
            
            // If we have a program, then set it, otherwise, redirect to error page
            if(!programs.isEmpty()) {
                
                program = programs[0]; 
                
                // Setup branding logo
                transient Attachment logo = [SELECT Id, Name, Body FROM Attachment where ParentId = : program.Id AND Name=:'ui-logo.png'];
                if(logo != null) {
                    brandingLogo = logo.Id;
                }
                else { brandingLogo = null; }
                
                // Setup branding card image
                transient Attachment card = [SELECT Id, Name, Body FROM Attachment where ParentId = : program.Id AND Name=:'ui-credit-card.png'];
                brandingCard = card.Id;
                
            }
            
        }
        
    }
    
}