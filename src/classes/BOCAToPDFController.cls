public class BOCAToPDFController {

    public String applicationId {
        get {
            return ApexPages.CurrentPage().getParameters().get('applicationId');
        }
    }

    public String applicationType {
        get {
            if (applicationId != null) {
                return (Id.valueOf(applicationId)).getSobjectType().getDescribe().getName();
            }
            return null;
        }
    }

    public String token {
        get {
            return ApexPages.CurrentPage().getParameters().get('token');
        }
    }

    public Program__c program { get; set; }

    // Get the branding logo
    public Id brandingLogo { get; set; }

    public String languageCode {
        get {
            String languageParam = ApexPages.CurrentPage().getParameters().get('lang');

            if (languageParam != null) {
                List<BOCA_res__c> brandingUtility = [SELECT Id FROM BOCA_res__c WHERE Program__c = :program.Id AND ISO_code__c = :languageCode];

                if (brandingUtility.size() > 0) {
                    return languageParam;
                }
            }
            return 'en_us';
        }
    }

    public Boolean containsPG {
        get {

            if ((onlineApplication != null && (onlineApplication.AO_Address__c != null || onlineApplication.AO_City__c != null || onlineApplication.AO_State__c != null ||
                    onlineApplication.AO_Zip_Code__c != null || onlineApplication.AO_Home_Phone_Number__c != null || onlineApplication.AO_Social_Security_Number__c != null || onlineApplication.AO_Date_of_Birth__c != null))) {

                return true;

            }

            return false;

        }
    }

    public WeFormObject__c creditApp { get; set; }

    public OnlineApplication__c onlineApplication { get; set; }

    public OnlineApplicationOffer__c onlineApplicationOffer { get; set; }

    public List<OnlineApplicationAuthorizedContact__c> onlineApplicationAuthorizedContacts { get; set; }

    public List<OnlineApplicationDriverSetup__c> onlineApplicationDrivers { get; set; }

    public List<OnlineApplicationUnitNumber__c> onlineApplicationUnits { get; set; }

    public String termsAndConditions {
        get {
            Attachment tnc = [SELECT Id, Name, Body FROM Attachment where Id = :termsAndConditionsId];

            if (tnc != null) {
                HttpRequest tmp = new HttpRequest();
                tmp.setBodyAsBlob(tnc.Body);

                String converted = tmp.getBody();

                return converted;
            }

            return null;
        }
    }

    public String termsAndConditionsId {
        get {
            List<Attachment> tncs = [SELECT Id, Name FROM Attachment where ParentId = :onlineApplicationOffer.Id];

            if (!tncs.isEmpty()) {
                for (Attachment tnc : tncs) {
                    if ((tnc.Name).contains(onlineApplicationOffer.Terms_and_Conditions_Version__c)) {
                        return tnc.Id;
                    }
                }
            }

            return null;
        }
    }

    public BOCAToPDFController() {

    }

    public void init() {

        System.debug('### PDF: ' + applicationId + ',' + token);

        if (token != null) {

            if (applicationId != null && (applicationType).equalsIgnoreCase('OnlineApplication__c')) {

                onlineApplication = [
                        SELECT ABA_Routing_Number__c, AO_Address__c, AO_City__c, AO_Date_of_Birth__c, AO_Home_Phone_Number__c, AO_Mobile_Number__c,
                                AO_Social_Security_Number__c, AO_State__c, AO_Title__c, AO_Zip_Code__c, Business_Address_Line_2__c, Business_Description__c,
                                Business_Street_Address__c, Card_Shipping_Address_Line_1__c, Card_Shipping_Address_Line_2__c, Card_Shipping_Attention__c,
                                Card_Shipping_Postal_Code__c, Cell_Number__c, Checking_Account_Number__c, City__c, Contact_First_Name__c, Contact_Last_Name__c,
                                Credit_Line_Requested__c, DOT_Number__c, DUNS__c, Daily_Cash_Limit__c, Daily_DEF_Limit__c, Daily_Fuel_Gallons__c,
                                Day_of_Payment__c, Email__c, Embossing_Line_1_Company_Name__c, FF_Number__c, Fax_Number__c, Federal_Tax_ID__c,
                                Financial_Institution__c, Invoice_Delivery_Method_Email__c, Invoice_Delivery_Method__c, Legal_Business_Name__c,
                                MC_FF_or_DOT__c, MC_Number__c, Name_of_Parent_Company__c, Name, Number_Of_Drivers__c, Number_of_Cards_Needed__c,
                                Number_of_Trucks__c, Other_Services__c, Payment_Method__c, Phone_Number__c, Promotional_Code__c, State__c,
                                Trade_Name__c, Type_of_Business__c, Year_Established__c, Zip_code__c, Program__c, Offer__c, Team_Drivers_Slip_Seat__c, Unit__c,
                                Card_Shipping_City__c, Card_Shipping_State__c, Trip__c, Odometer__c
                        FROM OnlineApplication__c
                        WHERE Id = :applicationId and (PDF_Token__c != null and PDF_Token__c = :token) LIMIT 1
                ];

                onlineApplicationOffer = [
                        SELECT Id, Name, Terms_and_Conditions_Version__c, EchoSign_Header_Image__c, Enable_Authorized_Contacts__c, Enable_Card_Information__c,
                                Enable_Driver_Unit_Information__c, Authorized_Signer_Disclosure__c, PG_Disclosure__c
                        FROM OnlineApplicationOffer__c
                        WHERE Id = :onlineApplication.Offer__c
                ];

                onlineApplicationAuthorizedContacts = [
                        SELECT Id, First_Name__c, Last_Name__c, Email__c, Phone_Number__c, Mobile_Number__c
                        FROM OnlineApplicationAuthorizedContact__c
                        WHERE Online_Application__c = :onlineApplication.Id
                ];

                onlineApplicationDrivers = [SELECT Id, Driver_Name__c, Driver_ID__c FROM OnlineApplicationDriverSetup__c WHERE Online_Application__c = :onlineApplication.Id];

                onlineApplicationUnits = [SELECT Id, Name FROM OnlineApplicationUnitNumber__c WHERE Online_Application__c = :onlineApplication.Id];

                if (onlineApplication.Program__c != null) {
                    program = WexBrandingController.getProgram(onlineApplication.Program__c);

                    brandingLogo = WexBrandingController.getLogoId(onlineApplication.Program__c);
                }

            } else if (applicationId != null && (applicationType).equalsIgnoreCase('WeFormObject__c')) {

            } else if (applicationId != null && (applicationType).equalsIgnoreCase('CP_Application_Request__c')) {

            }

        }

    }

}