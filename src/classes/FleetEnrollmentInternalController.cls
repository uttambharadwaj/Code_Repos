/*
*
* Created by dgilbert on 9/26/2018.
*
* Revision History: 19/Jul/2019 MFarrell    NAFONBOARD-44   Added Embossing Name to FleetEnrollmentInternal Page.
*
*/

public with sharing class FleetEnrollmentInternalController {

    public final static String APPLICATION_NAME = 'Internal Fleet Enrollment Form';

    public Id dataSheetFolder {
        get {
            List<Folder> folders = [SELECT Id FROM Folder WHERE DeveloperName = 'Fleet_Implementation_Data_Sheets'];

            if(folders.size() > 0) {
                return folders[0].Id;
            }

            return null;
        }
    }

    public List<Document> fleetDataSheets {
        get {

            List<Document> documents = new List<Document>();

            if(program != null && !String.isBlank(program.Default_Fleet_Data_Sheets__c)) {
                documents = [SELECT Id, Name FROM Document WHERE FolderId = :dataSheetFolder and DeveloperName =: program.Default_Fleet_Data_Sheets__c];
            }
            if(documents.size() == 0) {
                documents = [SELECT Id, Name FROM Document WHERE FolderId = :dataSheetFolder];
            }

            return documents;

        }
    }

    public String opportunityId {
        get {
            return ApexPages.currentPage().getParameters().get('opportunityId');
        }
    }

    public String errorCode {
        get {
            return ApexPages.currentPage().getParameters().get('errorCode');
        }
    }

    public String errorCodeDescription { get; set; }

    public String confirm {
        get {
            return ApexPages.currentPage().getParameters().get('confirm');
        }
    }

    public Opportunity opportunity { get; set; }

    public Application_Request__c applicationRequest { get; set; }

    public FleetEnrollmentInformation fleetEnrollmentInformation { get; set; }

    public FleetEnrollment__c fleetEnrollment { get; set; }

    public Program__c program { get; set; }

    public Boolean hasError {
        get {
            return ApexPages.hasMessages();
        }
    }

    // NAFONBOARD-44
    public boolean embossingNameBlank { get; set; }

    public Id internalRecordType {
        get {
            if (FleetEnrollment__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('Internal') != null) {
                return FleetEnrollment__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('Internal').getRecordTypeId();
            }

            return null;
        }
    }

    public List<SelectOption> availableContactRoles {
        get {

            List<SelectOption> availableContactRoles = new List<SelectOption>();
            availableContactRoles.add(new SelectOption('', '--- Choose One ---'));

            Schema.DescribeFieldResult fleetEnrollmentContactRoles = FleetEnrollment_Contact__c.Contact_Role__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fleetEnrollmentContactRoles.getPicklistValues();
            for (Schema.PicklistEntry picklistValue : picklistEntries) {
                availableContactRoles.add(new SelectOption(picklistValue.getLabel(), picklistValue.getLabel()));
            }

            return availableContactRoles;

        }
    }

    public List<SelectOption> availableCardShippingOptions {
        get {
            List<SelectOption> availableCardShippingOptions = new List<SelectOption>();
            availableCardShippingOptions.add(new SelectOption('', '--- Choose One ---'));

            if (program != null && program.Available_Card_Shipping_Options__c != null) {

                for (String option : (program.Available_Card_Shipping_Options__c).split(';')) {

                    availableCardShippingOptions.add(new SelectOption(option, option));

                }

            }

            return availableCardShippingOptions;
        }
    }

    public List<SelectOption> availableCardTypes {
        get {
            List<SelectOption> availableCardTypes = new List<SelectOption>();
            availableCardTypes.add(new SelectOption('', '--- Choose One ---'));

            if (program != null && program.Fleet_Available_Card_Types__c != null) {

                for (String option : (program.Fleet_Available_Card_Types__c).split(';')) {

                    availableCardTypes.add(new SelectOption(option, option));

                }

            }

            return availableCardTypes;
        }
    }

    public Integer availableCardTypesSize {
        get {
            return availableCardTypes.size();
        }
    }

    public List<SelectOption> availableUsageTypes {
        get {
            List<SelectOption> availableUsageTypes = new List<SelectOption>();
            availableUsageTypes.add(new SelectOption('', '--- Choose One ---'));

            if (program != null && program.Fleet_Available_Usage_Types__c != null) {

                for (String option : (program.Fleet_Available_Usage_Types__c).split(';')) {

                    availableUsageTypes.add(new SelectOption(option, option));

                }

            }

            return availableUsageTypes;
        }
    }

    public Integer availableUsageTypesSize {
        get {
            return availableUsageTypes.size();
        }
    }

    public List<SelectOption> availableAssociations {
        get {
            List<SelectOption> availableAssociations = new List<SelectOption>();
            availableAssociations.add(new SelectOption('', '--- Choose One ---'));

            if (program != null && program.WEX_Associations__c != null) {

                for (String option : (program.WEX_Associations__c).split(';')) {

                    availableAssociations.add(new SelectOption(option, option));

                }

            }

            return availableAssociations;
        }
    }

    public Integer availableAssociationsSize {
        get {
            return availableAssociations.size();
        }
    }

    public List<SelectOption> availableBillingCycles {
        get {
            List<SelectOption> availableBillingCycles = new List<SelectOption>();
            availableBillingCycles.add(new SelectOption('', '--- Choose One ---'));

            if (program != null && program.Fleet_Available_Billing_Cycles__c != null) {

                for (String option : (program.Fleet_Available_Billing_Cycles__c).split(';')) {

                    if(option != 'Cycle 4')
                        availableBillingCycles.add(new SelectOption(option, option));

                }

            }

            return availableBillingCycles;
        }
    }

    public Integer availableBillingCyclesSize {
        get {
            return availableBillingCycles.size();
        }
    }

    public List<SelectOption> availableStateOptions {
        get {
            List<SelectOption> availableStateOptions = new List<SelectOption>();
            availableStateOptions.add(new SelectOption('', '--- Choose One ---'));

            Schema.DescribeFieldResult stateOptions = WeFormObject__c.Billing_State__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = stateOptions.getPicklistValues();
            for (Schema.PicklistEntry picklistValue : picklistEntries) {
                availableStateOptions.add(new SelectOption(picklistValue.getLabel(), picklistValue.getLabel()));
            }

            return availableStateOptions;
        }
    }

    public FleetEnrollmentInternalController() {

    }

    public void init() {

        try {

            if (confirm != null) {
                if (confirm.equalsIgnoreCase('true')) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Fleet Enrollment submitted successfully!'));
                } else {
                    if (errorCode != null) {
                        List<Internal_Application_Error__c> error = [SELECT Id, Error_Message__c FROM Internal_Application_Error__c WHERE Name = :errorCode];

                        if (error.size() > 0) {
                            errorCodeDescription = error[0].Error_Message__c;
                        } else {
                            errorCodeDescription = 'General Fault';
                        }
                    }

                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorCodeDescription + '  <br><br>The support organization has been notified. Your error tracking number is: ' + errorCode));
                }
            } else {

                if (opportunityId != null) {

                    List<Opportunity> opportunities = [SELECT Id, Opportunity_Number__c, Name, Billing_Contact_First_Name__c, Billing_Contact_Last_Name__c, Billing_Street__c, Billing_City__c, Billing_State__c, Billing_Zip_Postal_Code__c, Billing_Contact_Email__c, Billing_Contact_Phone__c, Campaign.Allow_Monthly_Accounting_Fee_Waiver__c, Campaign_Program__r.Program__c, Campaign.Name FROM Opportunity WHERE Id = :opportunityId];

                    if (opportunities.size() == 1) {

                        fleetEnrollmentInformation = new FleetEnrollmentInformation();

                        opportunity = opportunities[0];

                        fleetEnrollment = new FleetEnrollment__c();

                        List<FleetEnrollment__c> fleetEnrollments = [SELECT Id, Embossing_Company_Name__c FROM FleetEnrollment__c WHERE Opportunity__c =: opportunity.Id or Debug_Opportunity_Parameter__c=:opportunity.Id];

                        if(fleetEnrollments.size() > 0) {
                            fleetEnrollment.Id = fleetEnrollments[0].Id;
                        } else {
                            fleetEnrollment.Opportunity__c = opportunity.Id;
                        }

                        // NAFONBOARD-44
                        if (fleetEnrollments.size() > 0 && fleetEnrollments[0].Embossing_Company_Name__c != null) {
                            embossingNameBlank = false;
                        } else {
                            embossingNameBlank = true;
                            if (opportunity.Name.length() > 30) {
                                FleetEnrollment.Embossing_Company_Name__c = opportunity.Name.substring(0, 30);
                            } else {
                                FleetEnrollment.Embossing_Company_Name__c = opportunity.Name;
                            }
                        }

                        if (opportunity.Campaign_Program__r.Program__c != null) {

                            program = WexBrandingController.getProgram(opportunity.Campaign_Program__r.Program__c);

                            if(program.Allow_Partner_Billed_Overnight_Cards__c) {
                                fleetEnrollmentInformation.expeditedCardShipping = true;
                                fleetEnrollmentInformation.overnightCardsBillPartner = true;
                                fleetEnrollmentInformation.selectedCardShippingOption = 'Overnight';
                            }

                        }

                        List<Application_Request__c> applicationRequests = [SELECT Id, Siebel_Oppty__c FROM Application_Request__c WHERE Opportunity__c = :opportunityId];

                        if (applicationRequests.size() == 1) {

                            applicationRequest = applicationRequests[0];

                            fleetEnrollment.Application_Request__c = applicationRequest.Id;

                        }

                    } else {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unable to find Opportunity!'));
                    }

                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unable to find opportunity.'));
                }
            }

        } catch (Exception e) {

            // TODO Modify the WEXDEVReporting to take an "email" flag in on whether to send the email or not
            System.debug(e);

        }

    }

    public void addNewContact() {

        if(fleetEnrollmentInformation.fleetEnrollmentContacts != null) {
            FleetEnrollmentContacts newFEC = new FleetEnrollmentContacts();
            newFEC.myIndex = fleetEnrollmentInformation.fleetEnrollmentContacts.size();
            fleetEnrollmentInformation.fleetEnrollmentContacts.add(newFEC);
        }

    }

    public Integer selectedContact { get; set; }

    public Integer additionalContactsSize {
        get {
            if(fleetEnrollmentInformation.fleetEnrollmentContacts != null) {
                return fleetEnrollmentInformation.fleetEnrollmentContacts.size();
            }
            return -1;
        }
    }

    public PageReference removeContact() {

        System.debug(selectedContact);

        if(fleetEnrollmentInformation.fleetEnrollmentContacts != null && selectedContact != null && fleetEnrollmentInformation.fleetEnrollmentContacts[selectedContact] != null) {
            fleetEnrollmentInformation.fleetEnrollmentContacts.remove(selectedContact);
            //reset the indexes
            for(Integer i=0; i<fleetEnrollmentInformation.fleetEnrollmentContacts.size(); i++){
                fleetEnrollmentInformation.fleetEnrollmentContacts[i].myIndex = i;
            }
        }

        return null;

    }

    public PageReference submitForm() {

        try {

            fleetEnrollment.Status__c = 'New';

            fleetEnrollment.RecordTypeId = internalRecordType;

            fleetEnrollment.Opportunity__c = opportunityId;

            fleetEnrollment.Program__c = program.Id;

            if (fleetEnrollmentInformation.expeditedCardShipping) {
                fleetEnrollment.Card_Shipping__c = fleetEnrollmentInformation.selectedCardShippingOption;

                if (fleetEnrollmentInformation.overnightCardsBillCustomer) {
                    fleetEnrollment.Card_Shipping_Bill_To__c = 'Customer';
                }
                if (fleetEnrollmentInformation.overnightCardsBillPartner) {
                    fleetEnrollment.Card_Shipping_Bill_To__c = 'Partner';
                }
                if (fleetEnrollmentInformation.overnightCardsBillWEX) {
                    fleetEnrollment.Card_Shipping_Bill_To__c = 'WEX';
                }

                fleetEnrollment.Customer_Carrier_Number__c = fleetEnrollmentInformation.customerCarrierNumber;
            }


            if(fleetEnrollmentInformation.feeWaiversSetupFeeAmount != 0) fleetEnrollment.Setup_Fee__c = fleetEnrollmentInformation.feeWaiversSetupFeeAmount;
            if(fleetEnrollmentInformation.feeWaiversCardReplacementDurationAmount != 0) fleetEnrollment.Card_Replacement_Duration__c = fleetEnrollmentInformation.feeWaiversCardReplacementDurationAmount;
            if(fleetEnrollmentInformation.feeWaiversMonthlyCardChargesAmount != 0) fleetEnrollment.Monthly_Card_Charges__c = fleetEnrollmentInformation.feeWaiversMonthlyCardChargesAmount;
            if(fleetEnrollmentInformation.feeWaiversMonthlyAccountingFeeAmount != 0) fleetEnrollment.Monthly_Accounting_Fee__c = fleetEnrollmentInformation.feeWaiversMonthlyAccountingFeeAmount;
            if(!String.isBlank(fleetEnrollmentInformation.feeWaiversMonthlyAccountingFeeEndDate)) fleetEnrollment.Monthly_Accounting_Fee_Waive_Date__c = Date.parse(fleetEnrollmentInformation.feeWaiversMonthlyAccountingFeeEndDate);
            if(fleetEnrollmentInformation.feeWaiversPaperFeeAmount != 0) fleetEnrollment.Paper_Fee__c = fleetEnrollmentInformation.feeWaiversPaperFeeAmount;
            if(fleetEnrollmentInformation.feeWaiversMonthlyActivityFeeAmount != 0) fleetEnrollment.Monthly_Activity_Fee__c = fleetEnrollmentInformation.feeWaiversMonthlyActivityFeeAmount;

            if (fleetEnrollmentInformation.billingCycleDifferentThanProgramDefault) {
                fleetEnrollment.Billing_Cycle__c = fleetEnrollmentInformation.selectedBillingCycle;
            } else {
                fleetEnrollment.Billing_Cycle__c = program.Fleet_Default_Billing_Cycle__c;
            }

            if (fleetEnrollmentInformation.association) {
                fleetEnrollment.Association__c = fleetEnrollmentInformation.selectedAssociation;
            }

            if (fleetEnrollmentInformation.directDebit == true) {
                fleetEnrollment.Direct_Debit__c = true;
            }

            fleetEnrollment.Hierarchy_Needed__c = fleetEnrollmentInformation.hierarchyNeeded;

            fleetEnrollment.Station_Card__c = fleetEnrollmentInformation.stationCard;

//            fleetEnrollment.Embossing_Company_Name__c = opportunity.Name;

            fleetEnrollment.Billing_Full_Name__c = opportunity.Billing_Contact_First_Name__c + ' ' + opportunity.Billing_Contact_Last_Name__c;
            fleetEnrollment.Billing_Email__c = opportunity.Billing_Contact_Email__c;
            fleetEnrollment.Billing_Phone__c = opportunity.Billing_Contact_Phone__c;
            fleetEnrollment.Billing_Address_Line_1__c = opportunity.Billing_Street__c;
            fleetEnrollment.Billing_City__c = opportunity.Billing_City__c;
            fleetEnrollment.Billing_State__c = opportunity.Billing_State__c;
            fleetEnrollment.Billing_Postal_Code__c = opportunity.Billing_Zip_Postal_Code__c;

            if (fleetEnrollmentInformation.alternateCardShippingAddress) {
                fleetEnrollment.Card_Shipping_Attention__c = fleetEnrollmentInformation.cardShippingAttention;
                fleetEnrollment.Card_Shipping_Address_Line_1__c = fleetEnrollmentInformation.cardShippingAddressLine1;
                fleetEnrollment.Card_Shipping_Address_Line_2__c = fleetEnrollmentInformation.cardShippingAddressLine2;
                fleetEnrollment.Card_Shipping_City__c = fleetEnrollmentInformation.cardShippingCity;
                fleetEnrollment.Card_Shipping_State__c = fleetEnrollmentInformation.cardShippingState;
                fleetEnrollment.Card_Shipping_Postal_Code__c = fleetEnrollmentInformation.cardShippingPostalCode;
            } else {
                fleetEnrollment.Card_Shipping_Attention__c = opportunity.Billing_Contact_First_Name__c + ' ' + opportunity.Billing_Contact_Last_Name__c;
                fleetEnrollment.Card_Shipping_Address_Line_1__c = opportunity.Billing_Street__c;
                fleetEnrollment.Card_Shipping_City__c = opportunity.Billing_City__c;
                fleetEnrollment.Card_Shipping_State__c = opportunity.Billing_State__c;
                fleetEnrollment.Card_Shipping_Postal_Code__c = opportunity.Billing_Zip_Postal_Code__c;
            }

            if(fleetEnrollmentInformation.specialShippingAddress) {
                fleetEnrollment.Special_Shipping_Attention__c = fleetEnrollmentInformation.specialShippingAttention;
                fleetEnrollment.Special_Shipping_Address_Line_1__c = fleetEnrollmentInformation.specialShippingAddressLine1;
                fleetEnrollment.Special_Shipping_Address_Line_2__c = fleetEnrollmentInformation.specialShippingAddressLine2;
                fleetEnrollment.Special_Shipping_City__c = fleetEnrollmentInformation.specialShippingCity;
                fleetEnrollment.Special_Shipping_State__c = fleetEnrollmentInformation.specialShippingState;
                fleetEnrollment.Special_Shipping_Postal_Code__c = fleetEnrollmentInformation.specialShippingPostalCode;
            }

            if (fleetEnrollmentInformation.selectedCardType != null) {
                fleetEnrollment.Card_Type__c = fleetEnrollmentInformation.selectedCardType;
            } else {
                fleetEnrollment.Card_Type__c = availableCardTypes.get(1).getValue();
            }

            if (fleetEnrollmentInformation.selectedUsageType != null) {
                fleetEnrollment.Usage_Type__c = fleetEnrollmentInformation.selectedUsageType;
            } else {
                fleetEnrollment.Usage_Type__c = availableUsageTypes.get(1).getValue();
            }

            List<Program_Template_Account__c> programTemplateAccounts = null;

            if(fleetEnrollmentInformation.association == true) {

                programTemplateAccounts = [SELECT Id FROM Program_Template_Account__c WHERE Billing_Cycle__c = :fleetEnrollment.Billing_Cycle__c and Usage_Type__c = :fleetEnrollment.Usage_Type__c and Program__c = :program.Id and Association__c =: fleetEnrollmentInformation.selectedAssociation];

            }
            else {

                programTemplateAccounts = [SELECT Id FROM Program_Template_Account__c WHERE Billing_Cycle__c = :fleetEnrollment.Billing_Cycle__c and Usage_Type__c = :fleetEnrollment.Usage_Type__c and Program__c = :program.Id];

            }

            if (programTemplateAccounts.size() > 0) {
                fleetEnrollment.Program_Template_Account__c = programTemplateAccounts[0].Id;
            } else {
                fleetEnrollment.Program_Template_Account__c = WexBrandingController.getDefaultAccountTemplateByProgram(program.Id);
            }

            Database.UpsertResult result = Database.upsert(fleetEnrollment);

            if (result.success) {

                if (fleetEnrollmentInformation.overnightCardsFileBody != null) {
                    Attachment managerApproval = new Attachment();
                    if(applicationRequest.Siebel_Oppty__c != null) {
                        managerApproval.Name = applicationRequest.Siebel_Oppty__c + '_OvernightCardApproval_' + fleetEnrollmentInformation.overnightCardsFileName.replaceAll('[^a-zA-Z0-9_\\-\\.]', '');
                    }
                    else {
                        managerApproval.Name = opportunity.Opportunity_Number__c + '_OvernightCardApproval_' + fleetEnrollmentInformation.overnightCardsFileName.replaceAll('[^a-zA-Z0-9_\\-\\.]', '');
                    }
                    managerApproval.Body = fleetEnrollmentInformation.overnightCardsFileBody;
                    managerApproval.ParentId = fleetEnrollment.Id;
                    insert managerApproval;
                }

                if (fleetEnrollmentInformation.feeWaiversTFSFileBody != null) {
                    Attachment tfsSchedule = new Attachment();
                    if(applicationRequest.Siebel_Oppty__c != null) {
                        tfsSchedule.Name = applicationRequest.Siebel_Oppty__c + '_TFS_' + fleetEnrollmentInformation.feeWaiversTFSFileName.replaceAll('[^a-zA-Z0-9_\\-\\.]', '');
                    }
                    else {
                        tfsSchedule.Name = opportunity.Opportunity_Number__c + '_TFS_' + fleetEnrollmentInformation.feeWaiversTFSFileName.replaceAll('[^a-zA-Z0-9_\\-\\.]', '');
                    }
                    tfsSchedule.Body = fleetEnrollmentInformation.feeWaiversTFSFileBody;
                    tfsSchedule.ParentId = fleetEnrollment.Id;
                    insert tfsSchedule;
                }

                if (fleetEnrollmentInformation.fleetDataFileBody != null) {
                    Attachment fleetEnrollmentData = new Attachment();
                    if(applicationRequest.Siebel_Oppty__c != null) {
                        fleetEnrollmentData.Name = applicationRequest.Siebel_Oppty__c + '_FleetData_' + fleetEnrollmentInformation.fleetDataFileName.replaceAll('[^a-zA-Z0-9_\\-\\.]', '');
                    }
                    else {
                        fleetEnrollmentData.Name = opportunity.Opportunity_Number__c + '_FleetData_' + fleetEnrollmentInformation.fleetDataFileName.replaceAll('[^a-zA-Z0-9_\\-\\.]', '');
                    }
                    fleetEnrollmentData.Body = fleetEnrollmentInformation.fleetDataFileBody;
                    fleetEnrollmentData.ParentId = fleetEnrollment.Id;
                    insert fleetEnrollmentData;
                }

                if (fleetEnrollmentInformation.directDebitFileBody != null) {
                    Attachment directDebitData = new Attachment();
                    if(applicationRequest.Siebel_Oppty__c != null) {
                        directDebitData.Name = applicationRequest.Siebel_Oppty__c + '_DirectDebit_' + fleetEnrollmentInformation.directDebitFileName.replaceAll('[^a-zA-Z0-9_\\-\\.]', '');
                    }
                    else {
                        directDebitData.Name = opportunity.Opportunity_Number__c + '_DirectDebit_' + fleetEnrollmentInformation.directDebitFileName.replaceAll('[^a-zA-Z0-9_\\-\\.]', '');
                    }
                    directDebitData.Body = fleetEnrollmentInformation.directDebitFileBody;
                    directDebitData.ParentId = fleetEnrollment.Id;
                    insert directDebitData;
                }

                System.debug(fleetEnrollmentInformation.fleetEnrollmentContacts);

                for (FleetEnrollmentContacts fleetEnrollmentContact : fleetEnrollmentInformation.fleetEnrollmentContacts) {

                    if (!String.isBlank(fleetEnrollmentContact.firstName)) {

                        FleetEnrollment_Contact__c newFleetEnrollmentContact = new FleetEnrollment_Contact__c();

                        newFleetEnrollmentContact.First_Name__c = fleetEnrollmentContact.firstName;
                        newFleetEnrollmentContact.Last_Name__c = fleetEnrollmentContact.lastName;
                        newFleetEnrollmentContact.Full_Name__c = fleetEnrollmentContact.firstName + ' ' + fleetEnrollmentContact.lastName;
                        newFleetEnrollmentContact.Contact_Role__c = fleetEnrollmentContact.role;
                        newFleetEnrollmentContact.Email__c = fleetEnrollmentContact.emailAddress;
                        newFleetEnrollmentContact.Phone__c = fleetEnrollmentContact.phone;
                        newFleetEnrollmentContact.Fleet_Enrollment__c = fleetEnrollment.Id;

                        insert newFleetEnrollmentContact;

                    }

                }

                PageReference success = Page.FleetEnrollmentInternal;
                success.getParameters().put('confirm', 'true');
                success.setRedirect(true);
                return success;

            }

        } catch (Exception e) {

            String errorCode = WEXDEVErrorReporting.reportInternalError(APPLICATION_NAME, ApexPages.currentPage().getUrl(), UserInfo.getUserId(), e);

            PageReference error = Page.FleetEnrollmentInternal;
            error.getParameters().put('confirm', 'false');
            error.getParameters().put('errorCode', errorCode);
            error.setRedirect(true);
            return error;

        }

        return null;

    }

    public class FleetEnrollmentInformation {

        public Boolean expeditedCardShipping { get; set; }
        public String selectedCardShippingOption { get; set; }
        public Boolean overnightCardsBillWEX { get; set; }
        public Boolean overnightCardsBillPartner { get; set; }
        public Boolean overnightCardsBillCustomer { get; set; }
        public String overnightCardsFileName { get; set; }
        public Blob overnightCardsFileBody { get; set; }
        public String customerCarrierNumber { get; set; }

        public Boolean feeWaivers { get; set; }
        public Boolean feeWaiversSetupFee { get; set; }
        public Decimal feeWaiversSetupFeeAmount { get; set; }
        public Boolean feeWaiversCardReplacementDuration { get; set; }
        public Decimal feeWaiversCardReplacementDurationAmount { get; set; }
        public Boolean feeWaiversMonthlyCardCharges { get; set; }
        public Decimal feeWaiversMonthlyCardChargesAmount { get; set; }
        public Boolean feeWaiversPaperFee { get; set; }
        public Decimal feeWaiversPaperFeeAmount { get; set; }
        public Boolean feeWaiversMonthlyAccountingFee { get; set; }
        public Decimal feeWaiversMonthlyAccountingFeeAmount { get; set; }
        public String feeWaiversMonthlyAccountingFeeEndDate { get; set; }
        public String feeWaiversTFSFileName { get; set; }
        public Blob feeWaiversTFSFileBody { get; set; }

        public Boolean feeWaiversMonthlyActivityFee { get; set; }
        public Decimal feeWaiversMonthlyActivityFeeAmount { get; set; }

        public Boolean billingCycleDifferentThanProgramDefault { get; set; }
        public String selectedBillingCycle { get; set; }
        public Boolean hierarchyNeeded { get; set; }
        public Boolean stationCard { get; set; }
        public Boolean association { get; set; }
        public String selectedAssociation { get; set; }

        public Boolean alternateCardShippingAddress { get; set; }

        public String cardShippingAttention { get; set; }
        public String cardShippingAddressLine1 { get; set; }
        public String cardShippingAddressLine2 { get; set; }
        public String cardShippingCity { get; set; }
        public String cardShippingState { get; set; }
        public String cardShippingPostalCode { get; set; }

        public Boolean specialShippingAddress { get; set; }

        public String specialShippingAttention { get; set; }
        public String specialShippingAddressLine1 { get; set; }
        public String specialShippingAddressLine2 { get; set; }
        public String specialShippingCity { get; set; }
        public String specialShippingState { get; set; }
        public String specialShippingPostalCode { get; set; }

        public String fleetDataFileName { get; set; }
        public Blob fleetDataFileBody { get; set; }

        public Boolean directDebit { get; set; }
        public String directDebitFileName { get; set; }
        public Blob directDebitFileBody { get; set; }

        public String selectedCardType { get; set; }
        public String selectedUsageType { get; set; }

        public Boolean additionalContacts { get; set; }

        public List<FleetEnrollmentContacts> fleetEnrollmentContacts { get; set; }

        public FleetEnrollmentInformation() {

            fleetEnrollmentContacts = new List<FleetEnrollmentContacts>();

            fleetEnrollmentContacts.add(new FleetEnrollmentContacts());
            fleetEnrollmentContacts[0].myIndex=0;

        }

    }

    public class FleetEnrollmentContacts {

        public String firstName { get; set; }
        public String lastName { get; set; }
        public String phone { get; set; }
        public String emailAddress { get; set; }
        public String role { get; set; }
        public Integer myIndex {get;set;}

        public FleetEnrollmentContacts() {

        }


    }


}