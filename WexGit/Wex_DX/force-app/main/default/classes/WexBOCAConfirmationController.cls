/*
Revision History:   4/26/2019 IADJUDICAT-1164 if instant adjudication is disabled, set decisioncomplete to true so that fleet enrollment appears
                    03/Jul/2019     MFarrell    NAFONBOARD-43   Added Publish_Fleet_Data_Capture_Form_1_1__c to Program SOQL
                    
*/
public class WexBOCAConfirmationController {

    public String programParameter {
        get {
            return ApexPages.CurrentPage().getParameters().get('pgm');
        }
    }

    // Get all program information
    public Program__c program { get; set; }

    // Get the branding utility
    public BOCA_res__c brandingUtility { get; set; }

    public Id applicationRequest { get; set; }

    public String applicationNumber { get; set; }

    public String applicationRequestNumber { get; set; }

    public String applicationOpportunity { get; set; }

    public String applicationCouponCode { get; set; }

    public String applicationGroupCode { get; set; }

    public String applicationLocationCode { get; set; }

    public Boolean disableFleetEnrollment { get; set; }

    public Boolean decisioningCompleted { get; set; }

    public Boolean creditApproved { get; set; }

    public Integer creditLineApproved { get; set; }

    public Integer numberOfPolls { get; set; }

    public String weFormId {
        get {
            return ApexPages.CurrentPage().getParameters().get('id');
        }
    }

    public String languageCode {
        get {
            String languageParam = ApexPages.CurrentPage().getParameters().get('lang');

            if(languageParam != null && program != null) {
                List<BOCA_res__c> brandingUtility = [SELECT Id FROM BOCA_res__c WHERE Program__c = :program.Id AND ISO_code__c = :languageParam];

                if(brandingUtility.size() > 0) { return languageParam; }
            }
            return 'en_us';
        }
    }

    // Get the branding logo
    public Id brandingLogo {
        get {
            transient Attachment logo = [SELECT Id, Name, Body FROM Attachment where ParentId = : program.Id AND Name=:'ui-logo.png'];
            return logo.Id;
        }
    }

    // Get the branding card
    public Id brandingCard {
        get {
            transient Attachment card = [SELECT Id, Name, Body FROM Attachment where ParentId = : program.Id AND Name=:'ui-credit-card.png'];
            return card.Id;
        }
    }

    public WexBOCAConfirmationController() {

        disableFleetEnrollment = false;

    }

    public PageReference init() {

        numberOfPolls = 0;
        decisioningCompleted = false;
        creditApproved = false;

        PageReference wexBOCAError = null;

        if(programParameter == null || programParameter == '') {
            wexBOCAError = Page.WexBOCAError;
            wexBOCAError.getParameters().put('errorCode', '1');
            wexBOCAError.setRedirect(true);
            return wexBOCAError;
        }
        else {
            // Setup the program
            List<Program__c> programs = [SELECT Id, Disable_Instant_Decisioning__c, Brand_Short_Name__c, Publish_Fleet_Data_Capture_Form__c, Publish_Fleet_Data_Capture_Form_1_1__c, Confirmation_Info__c, Publish_BOCA__c, Custom_Email_Header_URL__c, Analytics_Body_Block__c, Analytics_Head_Block__c, Peoplesoft_rel_code__c, Upload_Pricing_Data_Flag__c, T_C__c, BOCA_Disclaimer__c, Brand_Long_Name__c, Inside_Sales_Phone_Number__c, Brand_Color_1__c, Brand_Color_2__c FROM Program__c WHERE Brand_Short_Name__c = :programParameter];

            // If we have a program, then set it, otherwise, redirect to error page
            if(programs.size() > 0) {
                if(programs[0].Publish_BOCA__c != true) {
                    wexBOCAError = Page.WexBOCAError;
                    wexBOCAError.getParameters().put('errorCode', '1');
                    wexBOCAError.setRedirect(true);
                    return wexBOCAError;
                }
                else {
                    program = programs[0];
                }
            }
            else {
                wexBOCAError = Page.WexBOCAError;
                wexBOCAError.getParameters().put('errorCode', '1');
                wexBOCAError.setRedirect(true);
                return wexBOCAError;
            }

            // Setup the branding utility
            System.debug(program);
            List<BOCA_res__c> brandingUtilities = [SELECT Id, Program_Name__c, Email_Template_ID__c, SideBar__c, Side_Panel_Title__c FROM BOCA_res__c WHERE Program__c = :program.Id AND ISO_code__c = :languageCode];
            if(brandingUtilities.size() > 0) { brandingUtility = brandingUtilities[0]; }

            if(weFormId != null && weFormId != '') {
                WeFormObject__c creditApp = [SELECT ID, Application_Request__c, Opportunity__c, Application_Number__c, Disable_Fleet_Enrollment__c, Opportunity__r.Coupon_Code2__c, Group_Code__c, Location_Code__c FROM WeFormObject__c WHERE ID =: weFormId];

                applicationNumber = creditApp.Application_Number__c;

                applicationRequestNumber = creditApp.Application_Request__c;

                disableFleetEnrollment = creditApp.Disable_Fleet_Enrollment__c;

                applicationOpportunity = creditApp.Opportunity__c;

                applicationCouponCode = creditApp.Opportunity__r.Coupon_Code2__c;

                applicationGroupCode = creditApp.Group_Code__c;

                applicationLocationCode = creditApp.Location_Code__c;

                applicationRequest = creditApp.Application_Request__c;
            }

            //IADJUDICAT 1164
            if(program.Disable_Instant_Decisioning__c)
                decisioningCompleted = true;

        }

        return null;

    }

    public PageReference checkStatusOfApplication() {

        numberOfPolls++;

        if(numberOfPolls >= 6) {
            decisioningCompleted = true;
            creditApproved = false;
            return null;
        }

        List<Application_Request__c> applicationRequests = [SELECT Id, Approved_Credit_Limit__c, Credit_Decision_Recommendation__c, Credit_Decision__c FROM Application_Request__c WHERE Id =: applicationRequest LIMIT 1];

        if(applicationRequests.size() > 0) {

            if(applicationRequests[0].Credit_Decision_Recommendation__c != null && (applicationRequests[0].Credit_Decision_Recommendation__c).equalsIgnoreCase('Recommend Approve') && applicationRequests[0].Credit_Decision__c != null && (applicationRequests[0].Credit_Decision__c).equalsIgnoreCase('Approved')) {

                creditApproved = true;
                decisioningCompleted = true;

                creditLineApproved = Integer.valueOf(applicationRequests[0].Approved_Credit_Limit__c);

            }
            else if(applicationRequests[0].Credit_Decision_Recommendation__c != null && !(applicationRequests[0].Credit_Decision_Recommendation__c).equalsIgnoreCase('Recommend Approve')) {

                creditApproved = false;
                decisioningCompleted = true;

            }

        }

        return null;

    }

}