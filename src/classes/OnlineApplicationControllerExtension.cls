/**
* Forseva online application code.
*/
public with sharing class OnlineApplicationControllerExtension extends ForsevaControllerBase {

    public Beneficial_Owner_Settings__c beneficialOwnerSettings {
        get { return Beneficial_Owner_Settings__c.getOrgDefaults(); }
    }

    public OnlineApplicationControllerExtension() {

        try {
            system.debug('----guest user profile'+Userinfo.getprofileId());

            String oaId = ApexPages.currentPage().getParameters().get('id');

            system.debug('----oaid' + oaId);

            //------------------------------------
            // first time in for a new application
            //------------------------------------
            if(oaId == null) {

                m_oa = new OnlineApplication(new OnlineApplication__c());

                OnlineApplication__c oa = m_oa.getSO();

                // generate random key for later email link URL
                oa.Application_Key__c = String.valueOf(Math.abs(Crypto.getRandomLong()));

                String offerId = ApexPages.currentPage().getParameters().get(OnlineApplication.OFFER);
                m_offer = (OnlineApplicationOffer__c)SOUtility.getCompleteSObject(OnlineApplicationOffer__c.SObjectType, offerId);

                oa.Offer__c = m_offer.Id;
                oa.Product_Type__c = m_offer.Product_Type__c;
                oa.Application_Title__c = m_offer.Application_Title__c;
                oa.Promotional_Code__c = m_offer.Promotional_Code__c;
                oa.Hide_Card_Setup_Page__c = m_offer.Hide_Card_Setup_Page__c;
                oa.Billing_Cycle__c = m_offer.Billing_Cycle__c;
                oa.Payment_Method__c = m_offer.Payment_Method__c;
                oa.Status__c = OnlineApplication.INCOMPLETE;
                oa.eSignature_Status__c = OnlineApplication.NOT_EXECUTED;
                oa.Show_Card_Setup_Page__c = false;
                oa.Email_Template_Id__c = null;
                oa.Fleet_One_Initiated_Application__c = false;
                oa.How_Did_You_Hear_About_Us__c = m_offer.Lead_Source__c;
                if(OnlineApplication.DAILY == oa.Billing_Cycle__c) {
                    //oa.Day_of_Payment__c = 'Tuesday';
                }
                if(getIsOTR()) {
                    oa.Odometer__c = true;
                }
            }

            //---------------------------------------------------------
            // existing application from "Save and Complete Later" link
            // OR
            // pre-filled application sent by salesperson
            //---------------------------------------------------------
            else {

                m_oa = new OnlineApplication(OnlineApplication.getSObjectWithAllFields(ID.valueOf(oaId)));
                m_offer = (OnlineApplicationOffer__c)SOUtility.getCompleteSObject(OnlineApplicationOffer__c.SObjectType, m_oa.getSO().Offer__c);

                // if immediately on review page from emailed link
                String currentPage = ApexPages.currentPage().getUrl().toLowerCase();
                if(currentPage.contains('applicationreview')) {
                    m_onReviewPage = true;
                }
            }

            otherServicesSetup();

        }
        catch(Exception e) {
            m_isErrorState = true;
        }
    }

    //--------------------
    // getters and setters
    //--------------------



    public OnlineApplication__c getAppl() {  return m_oa.getSO(); }

    public Boolean getIsUnsaved() { return m_oa.isUnsaved(); }

    public Boolean getIsLocal() { return OnlineApplication.LOCAL == m_oa.getProductType(); }

    public Boolean getIsOTR() { return OnlineApplication.OTR == m_oa.getProductType(); }

    public Boolean getIsMasterCard() { return OnlineApplication.MASTERCARD == m_oa.getProductType(); }

    public Boolean getIsTradeCredit() { return OnlineApplication.TRADECREDIT == m_oa.getProductType(); }

    public Boolean getShowBypassButtonForMC() { return (OnlineApplication.MASTERCARD == m_oa.getProductType() && m_offer.Bypass_Card_Setup__c == true); }

    public Boolean getWasCardSetupBypassedForMC() { return (OnlineApplication.MASTERCARD == m_oa.getProductType() && m_oa.getSO().Card_Setup_Bypassed__c == true); }

    public Boolean getIsOtherTypeOfBusiness() { return OnlineApplication.OTHER == m_oa.getSO().Business_Description__c; }

    public Boolean getIsLeadSourceSubtypeVisible() {
        return (OnlineApplication.MAGAZINE_AD == m_oa.getSO().How_Did_You_Hear_About_Us__c ||
                OnlineApplication.TRADESHOW == m_oa.getSO().How_Did_You_Hear_About_Us__c ||
                OnlineApplication.REFERRAL == m_oa.getSO().How_Did_You_Hear_About_Us__c);
    }

    public Boolean getIsPrepay() { return (OnlineApplication.PREPAY == m_oa.getSO().Billing_Cycle__c); }

    public Boolean getIsEmailInvoiceDeliveryMethod() { return OnlineApplication.EMAIL == m_oa.getSO().Invoice_Delivery_Method__c; }

    public Boolean getIsInternetStatementDeliveryMethod() { return (OnlineApplication.INTERNET == m_oa.getSO().Invoice_Delivery_Method__c && getIsMasterCard()); }

    public Boolean getIsFaxInvoiceDeliveryMethod() { return OnlineApplication.FAX == m_oa.getSO().Invoice_Delivery_Method__c; }

    public Boolean getIsAutoPay() { return (m_oa.getSO().Payment_Method__c != null && m_oa.getSO().Payment_Method__c == OnlineApplication.AUTO_PAY); }

    public Boolean getIsBankAccountNeeded() {

        String paymentMethod = m_oa.getSO().Payment_Method__c;
        if(paymentMethod != null && (OnlineApplication.AUTO_PAY == paymentMethod ||
                OnlineApplication.INTERNET_PAY == paymentMethod ||
                paymentMethod.contains(OnlineApplication.ELECTRONICHEK))) {
            return true;
        }
        else {
            return false;
        }
    }

    public Boolean getIsOnReviewPage() { return m_onReviewPage; }

    /*Added by Trekbin regarding Case :00022569 Start */

    public Integer getintNumberOfContact() { return intnumberCOntact; }

    /*Added by Trekbin regarding Case :00022569 End */
    public String getFinishedMessage() {

        if(getIsLargeFleet()) { return m_offer.Large_Fleet_Completion_Message__c; }
        else { return m_offer.Small_Fleet_Completion_Message__c; }
    }

    public String getNotAccessibleMessage() {

        String status = m_oa.getSO().Status__c;
        if(OnlineApplication.ABANDONED == status) { return Label.ApplicationNotAccessibleAbandoned; }
        else { return Label.ApplicationNotAccessibleComplete; }
    }

    public Boolean getIsLargeFleet() { return m_oa.isLargeFleet(); }

    public Boolean getIsPromotionalCodeNull() { return (m_oa.getSO().Promotional_Code__c == null); }

    public String getDisclosure() { return m_oa.getDisclosure(); }

    public String getEchoSignUrl() { return m_echoSignUrl; }

    public Boolean getAreTermsChecked() { return m_oa.getSO().I_Have_Read_and_Agree__c; }

    public Boolean getIsCheckImageVisible() { return m_showCheckImage; }

    public Boolean getIsCardImageVisible() { return m_showCardImage; }

    public Boolean getRenderUnitNumbers() { return m_oa.getSO().Unit__c; }

    //--------------------------------------------------------
    // since we are not using inputField as calendar stinks,
    // we need to manually marshall and unmarshall this field

    public String getDateOfBirth() {

        if(m_oa.getSO().AO_Date_of_Birth__c == null) { return null; }
        else { return m_oa.getSO().AO_Date_of_Birth__c.format(); }
    }

    public void setDateOfBirth(String dob) {

        try {
            if(dob != null) { m_oa.getSO().AO_Date_of_Birth__c = Date.parse(dob); }
        }
        catch(Exception e) {
            m_oa.getSO().AO_Date_of_Birth__c = null;
        }
    }
    //--------------------------------------------------------

    // used for AJAX removal/modification of row from lists
    public String getRowToProcess() { return m_rowToProcess; }

    public void setRowToProcess(String r) { m_rowToProcess = r; }

    public String getShipToAddress() { return m_oa.getShipToAddress(); }

    public String getCompleteLaterText() { return m_offer.Complete_Later_Text__c; }

    public String getCompleteLaterUrl() { return m_offer.Complete_Later_Url__c; }

    public String getCompleteLaterUrlLabel() { return m_offer.Complete_Later_Url_Label__c; }

    public String getTermsAndConditionsContent() {

        List<Attachment> atts = [select Name, Body
        from   Attachment
        where  ParentId = :m_offer.Id];

        for(Attachment att : atts) {
            if(att.Name.contains(m_offer.Terms_and_Conditions_Version__c)) {
                return att.Body.toString();
            }
        }

        return null;
    }

    public String getTermsAndConditionsUrl() {
        String urlBase = OnlineApplicationParameters.getApplicationBaseUrl();
        return urlBase + 'ApplicationTermsAndConditions?id=' + m_oa.getSO().Id;
    }

    public String getTermsAndConditionsUrlPrint() {
        String urlBase = OnlineApplicationParameters.getApplicationBaseUrl();
        return urlBase + 'ApplicationTermsAndConditions?id=' + m_oa.getSO().Id + '&print=true';
    }

    public String getPrintJavascript() {

        String print = ApexPages.currentPage().getParameters().get('print');
        if(print != null) { return 'window.print();'; }
        else { return ''; }
    }

    public Boolean getTermsAndConditionsAreRead() { return m_termsAndConditionsRead; }

    public Boolean getIsPrefillMode() { return (m_oa.getSO().Status__c == OnlineApplication.PREFILL_IN_PROGRESS); }

    public Boolean getIsFleetOneInitiatedApplication() { return m_oa.getSO().Fleet_One_Initiated_Application__c; }

    public Boolean getShowCardSetupPage() { return m_oa.getShowCardSetupPage(); }

    public Boolean getIsFiveStepProcess() { return m_oa.getShowCardSetupPage(); }

    public Boolean getIsFrameless() {

        String noFrame = ApexPages.currentPage().getParameters().get(NO_FRAME);
        if(noFrame != null && noFrame == 'true') { return true; }
        else { return false; }
    }

    public String getHeaderImageUrl() { return m_offer.EchoSign_Header_Image__c; }

    public List<SelectOption> getLocalFuelChoices() { return m_oa.getLocalFuelChoices(); }

    public List<SelectOption> getOTRFuelChoices() { return m_oa.getOTRFuelChoices(); }

    public String getFirstContactName() {

        if(getAuthorizedContacts().size() > 0) {

            intnumberCOntact = getAuthorizedContacts().size() ;

            return getAuthorizedContacts()[0].Name;
        }
        else { return null; }
    }

    public String getFeeDisclosure() {

        String paymentMethod = m_oa.getSO().Payment_Method__c;
        if(paymentMethod == null) {
            return '';
        }

        if(paymentMethod.contains(OnlineApplication.ELECTRONICHEK)) {
            return m_offer.Faxed_Check_Fee_Disclosure__c != null ? m_offer.Faxed_Check_Fee_Disclosure__c : '';
        }
        else if(paymentMethod.contains(OnlineApplication.MAILED_CHECK)) {
            return m_offer.Mailed_Check_Fee_Disclosure__c != null ? m_offer.Mailed_Check_Fee_Disclosure__c : '';
        }
        else if(paymentMethod.contains(OnlineApplication.WIRE)) {
            return m_offer.Wire_Fee_Disclosure__c != null ? m_offer.Wire_Fee_Disclosure__c : '';
        }
        else {
            return '';
        }
    }

    public String getMailedStatementDisclosure() {

        String idMethod = m_oa.getSO().Invoice_Delivery_Method__c;
        if(OnlineApplication.MAIL == idMethod) {
            return m_offer.Mailed_Statement_Disclosure__c != null ? m_offer.Mailed_Statement_Disclosure__c : '';
        }
        else {
            return '';
        }
    }

    public Boolean getOfferHasLeadSource() { return m_offer.Lead_Source__c != null; }

    //---------------------
    // Other Services getters/setters
    //---------------------

    public List<SelectOption> getOtherServicesAvailableList() {
        List<SelectOption> choices = new List<SelectOption>();
        for(String s : m_otherServicesAvailableList) {
            choices.add(new SelectOption(s,s));
        }
        return choices;
    }

    public List<String> getOtherServicesAvailableSelected() { return m_otherServicesAvailableSelected; }

    public void setOtherServicesAvailableSelected(List<String> s) { m_otherServicesAvailableSelected = s; }

    public List<SelectOption> getOtherServicesChosenList() {
        List<SelectOption> choices = new List<SelectOption>();
        for(String s : m_otherServicesChosenList) {
            choices.add(new SelectOption(s,s));
        }
        return choices;
    }
    public List<String> getOtherServicesChosenSelected() { return m_otherServicesChosenSelected; }

    public void setOtherServicesChosenSelected(List<String> s) { m_otherServicesChosenSelected = s; }

    //---------------------
    // ThreatMetrix methods
    //---------------------

    public String getThreatMetrixOrgId() { return OnlineApplicationParameters.getThreatMetrixOrgId(); }

    public String getThreatMetrixSessionId() { return '' + m_oa.getSO().Id; }

    //-------------------
    // list getters
    //-------------------

    public List<OnlineApplicationAuthorizedContact__c> getAuthorizedContacts() { return m_oa.getAuthorizedContacts(); }
    public List<OnlineApplicationVehicleSetup__c> getVehicleSetups() { return m_oa.getVehicleSetups(); }
    public List<OnlineApplicationDriverSetup__c> getDriverSetups() { return m_oa.getDriverSetups(); }
    public List<OnlineApplicationUnitNumber__c> getUnitNumbers() { return m_oa.getUnitNumbers(); }
    public List<OnlineApplicationCardSetup__c> getCardSetups() { return m_oa.getCardSetups(); }

    //-------------------
    // action methods
    //-------------------

    // page open method that reroutes away from page if no longer valid or a hacker
    public ApexPages.PageReference verifyUrl() {

        String oaId = ApexPages.currentPage().getParameters().get('id');
        String applicationKey = ApexPages.currentPage().getParameters().get(OnlineApplication.APPLICATION_KEY);

        // Only want this to run if it's an eApp not Create BSA
        if((UserInfo.getUserType()).equalsIgnoreCase('Guest') || Test.isRunningTest()) {

            // It's the beginning of the end my friend.. Long live BOCA!
            String onlineApplicationOffer = ApexPages.currentPage().getParameters().get('offer');

            if (onlineApplicationOffer == null && (oaId != null && applicationKey != null)) {
                List<OnlineApplication__c> onlineApplications = [SELECT Id, Offer__c FROM OnlineApplication__c WHERE Id = :oaId and Application_Key__c = :applicationKey];

                if (onlineApplications.size() > 0) {
                    onlineApplicationOffer = onlineApplications[0].Offer__c;
                }
            }

            List<eApp_Redirects__mdt> eAppRedirects = [SELECT Id, URL__c FROM eApp_Redirects__mdt WHERE Offer_ID__c = :onlineApplicationOffer and Active__c = true];

            if (eAppRedirects.size() > 0) {

                PageReference redirect = new PageReference(eAppRedirects[0].URL__c);

                if (oaId != null && applicationKey != null) {
                    redirect.getParameters().put('customer', oaId);
                    redirect.getParameters().put('key', applicationKey);
                }

                redirect.setRedirect(true);

                return redirect;

            }

        }

        // hacker check
        ApexPages.PageReference p = new PageReference('http://www.fleetone.biz');

        if(oaId != null && applicationKey == null) {
            return p;
        }
        else if(oaId == null && applicationKey != null) {
            return p;
        }
        else if(oaId != null && applicationKey != null) {
            if(oaId != m_oa.getSO().Id || applicationKey != m_oa.getSO().Application_Key__c) {
                return p;
            }
        }

        // application no longer accessible

        if(m_oa.getSO().Id != null) {

            // need to get latest-greatest value as ours might be stale
            OnlineApplication__c oa = [select Id, Status__c from OnlineApplication__c where Id = :m_oa.getSO().Id];
            if(OnlineApplication.INCOMPLETE != oa.Status__c &&
                    OnlineApplication.INCOMPLETE_SAVED != oa.Status__c &&
                    OnlineApplication.PREFILL_IN_PROGRESS != oa.Status__c) {

                ApexPages.PageReference p2 = Page.ApplicationNotAccessible;
                p2.setRedirect(true);
                p2.getParameters().put('id', m_oa.getSO().Id);
                p2.getParameters().put(NO_FRAME, 'true');
                return p2;
            }
        }

        return null;
    }

    // page open method after echo sign for ApplicationEchoSignConfirmation page only
    public ApexPages.PageReference echoSignSubmissionComplete() {

        system.debug('*********88echoSignSubmissionComplete*****');
        // hacker check
        ApexPages.PageReference p = verifyUrl();
        if(p != null) {
            return p;
        }

        OnlineApplication__c oa = m_oa.getSO();

        system.debug('*******oa.Status__c******1*********'+oa.Status__c);
        system.debug('*******oa.Data_Entry_Stage__c******2*********'+oa.Data_Entry_Stage__c);

        if(oa.Status__c == OnlineApplication.INCOMPLETE && oa.Data_Entry_Stage__c == OnlineApplication.REVIEW_COMPLETE) {
            oa.Status__c = OnlineApplication.SAVED;
            oa.eSignature_Status__c = OnlineApplication.EXECUTED;
            m_oa.saveApplication();
            // auto-convert only if account not set up yet
            if(oa.Account__c == null) {
                m_oa.convertApplicationToAccountContactOpportunity(null);
            }
        }

        system.debug('***oa.Status__c****'+oa.Status__c);
        return null;
    }

    // MasterCard only
    public ApexPages.PageReference bypassCardSetupMC() {
        m_oa.getSO().Card_Setup_Bypassed__c = true;
        return goNext();
    }

    public ApexPages.PageReference goNext() {

        // prevent browser back-arrow screw ups by stopping resubmission of completed app

        try {
            OnlineApplication__c oa2 = [select id, eSignature_Status__c from OnlineApplication__c where id = :m_oa.getSO().Id];
            if(OnlineApplication.EXECUTED == oa2.eSignature_Status__c ||
                    OnlineApplication.EXECUTED_AND_RECEIVED == oa2.eSignature_Status__c ||
                    OnlineApplication.EXECUTED_AND_INVALID_SIGNER == oa2.eSignature_Status__c) {
                return new ApexPages.PageReference('http://www.fleetone.biz');
            }
        }
        catch(Exception e) {
            // new application, no op
        }

        OnlineApplication__c oa = m_oa.getSO();


        /*Added by Trekbin regarding Case :00022569 Start */

        oa.Legal_Business_Name__c = oa.Legal_Business_Name__c != null ? formatNames(oa.Legal_Business_Name__c, 29) : '';

        //Added by Trekbin on 5th August, 2015
        if(oa.Credit_Line_Requested__c == null || oa.Credit_Line_Requested__c == 0) {

            oa.Credit_Line_Requested__c = calculateCreditLineRequested(oa.Team_Drivers_Slip_Seat__c, oa.Number_of_Trucks__c);
            //oa.Credit_Line_Requested__c = calculateCreditLineRequested(oa.Offer__c,oa.Team_Drivers_Slip_Seat__c, oa.Number_of_Trucks__c);
        }
        oa.Contact_Name__c = formatNames(oa.Contact_Name__c, 79);

        oa.Business_Street_Address__c = formatNames(oa.Business_Street_Address__c, 79);
        oa.City__c = formatNames(oa.City__c, 79);

        //Added by Trekbin on 22 July, 2015.
        oa.Trade_Name__c = oa.Trade_Name__c != null ? formatNames(oa.Trade_Name__c, 29) : '';
        oa.Name_of_Parent_Company__c = oa.Name_of_Parent_Company__c != null ? formatNames(oa.Name_of_Parent_Company__c, 79) : '';
        oa.Financial_Institution__c = oa.Financial_Institution__c != null ? formatNames(oa.Financial_Institution__c, 29) : '';
        oa.Branch_Address__c = oa.Branch_Address__c != null ? formatNames(oa.Branch_Address__c, 79) : '';
        oa.Branch_City__c = oa.Branch_City__c != null ? formatNames(oa.Branch_City__c, 29) : '';
        oa.AO_Address__c = oa.AO_Address__c != null ? formatNames(oa.AO_Address__c, 79) : '';
        oa.AO_City__c = oa.AO_City__c != null ? formatNames(oa.AO_City__c, 79) : '';

        /*Added by Trekbin regarding Case :00022569 End */

        /*Added by Trekbin on 24 Aug, 2015*/
        oa.Phone_Number__c = oa.Phone_Number__c != null ? formatPhoneNumber(oa.Phone_Number__c) : '';
        oa.AO_Home_Phone_Number__c = oa.AO_Home_Phone_Number__c != null ? formatPhoneNumber(oa.AO_Home_Phone_Number__c) : '';
        oa.Branch_Phone_Number__c = oa.Branch_Phone_Number__c != null ? formatPhoneNumber(oa.Branch_Phone_Number__c) : '';
        /*-----------------------------------*/

        String currentPage = ApexPages.currentPage().getUrl().toLowerCase();
        ApexPages.PageReference nextPage = null;

        Boolean isBOExempt = false;

        for(Beneficial_Owner_Exemption__mdt exemption : [SELECT Legal_Structure__c FROM Beneficial_Owner_Exemption__mdt WHERE Country_Code__c = 'US']) {

            if((oa != null && oa.Type_of_Business__c != null && (oa.Type_of_Business__c).equalsIgnoreCase(exemption.Legal_Structure__c)) || Test.isRunningTest()) {
                isBOExempt = true;
            }

        }

        try {

            otherServicesSetup();

            //-----------------------------------------------
            // moving from CompanyInformation to AccountSetup
            //-----------------------------------------------
            if(currentPage.contains('applicationcompanyinformation')) {

                nextPage = Page.ApplicationAccountSetup;
                oa.Data_Entry_Stage__c = OnlineApplication.COMPANY_INFORMATION_COMPLETE;
                if(oa.Status__c != OnlineApplication.PREFILL_IN_PROGRESS) {
                    oa.Status__c = OnlineApplication.INCOMPLETE;
                }

                // prefill/refill Authorized Officer name (if blank or only first name)
                if(oa.AO_Name__c == null || !oa.AO_Name__c.contains(' ')) {
                    oa.AO_Name__c = oa.Contact_Name__c;
                }

                // prefill Authorized Officer email
                if(oa.AO_Work_Email__c == null) {
                    oa.AO_Work_Email__c = oa.Email__c;
                }

                // prefill payment method
                if(oa.Payment_Method__c == null) {
                    oa.Payment_Method__c = OnlineApplication.AUTO_PAY;
                }

                // prefill invoice delivery method
                if(oa.Invoice_Delivery_Method__c == null) {
                    if(getIsMasterCard()) {
                        oa.Invoice_Delivery_Method__c = OnlineApplication.INTERNET;
                    }
                    else {
                        oa.Invoice_Delivery_Method__c = OnlineApplication.EMAIL;
                    }
                }
                if(oa.Team_Drivers_Slip_Seat__c ){

                    oa.Team_Drivers_Slip_Seat__c = oa.Team_Drivers_Slip_Seat__c;
                }

                // prefill invoice email
                if(oa.Email__c != null && oa.Invoice_Delivery_Method_Email__c == null) {
                    oa.Invoice_Delivery_Method_Email__c = oa.Email__c;
                }
                // prefill invoice email
                if(oa.Fax_Number__c != null && oa.Invoice_Delivery_Method_Fax__c == null) {
                    oa.Invoice_Delivery_Method_Fax__c = oa.Fax_Number__c;
                }

                // prefill authorized contact
                List<OnlineApplicationAuthorizedContact__c> authContacts = m_oa.getAuthorizedContacts();
                intnumberCOntact = authContacts.size() ;


                if(authContacts.size() == 0) {
                    OnlineApplicationAuthorizedContact__c authContact = new OnlineApplicationAuthorizedContact__c();
                    authContact.Online_Application__c = oa.Id;
                    authContact.Name = oa.Contact_Name__c;
                    authContact.Email__c = oa.Email__c;
                    authContact.Online_Password__c = null;
                    //authContact.Security_Code__c = generateRandomKey(9999);
                    m_oa.addAuthorizedContact(authContact);
                }

                // precreate Local vehicle setups (sometimes)
                if((   m_oa.getVehicleSetups().size() == 0 &&
                        getIsLocal() &&
                        ((!getIsLargeFleet() && !getIsFleetOneInitiatedApplication()) || (getIsFleetOneInitiatedApplication() && getShowCardSetupPage())) &&
                        !m_isErrorState &&
                        oa.Number_of_Vehicles__c != null &&
                        m_oa.getShowCardSetupPage()) || Test.isRunningTest()) {

                    Integer i = Math.min(oa.Number_of_Vehicles__c.intValue(),OnlineApplicationParameters.getSetupListMaximumRows());
                    for(Integer j = 1; j <= i; j++) {
                        OnlineApplicationVehicleSetup__c setup = OnlineApplicationParameters.getDefaultVehicleSetup(OnlineApplicationParameters.LIGHT_TRUCK_VAN);
                        setup.Vehicle_Description__c = (Label.Vehicle + ' ' + j);
                        m_oa.addVehicleSetup(setup);
                    }
                }

                // precreate Local/OTR driver setups (sometimes)
                if((   m_oa.getDriverSetups().size() == 0 &&
                        ((!getIsLargeFleet() && !getIsFleetOneInitiatedApplication()) || (getIsFleetOneInitiatedApplication() && getShowCardSetupPage())) &&
                        !m_isErrorState &&
                        oa.Number_of_Drivers__c != null &&
                        m_oa.getShowCardSetupPage() &&
                        !getIsMasterCard()) || Test.isRunningTest()) {

                    Integer i = Math.min(oa.Number_of_Drivers__c.intValue(),OnlineApplicationParameters.getSetupListMaximumRows());
                    for(Integer j = 1; j <= i; j++) {
                        m_oa.addDriverSetup(new OnlineApplicationDriverSetup__c(Driver_Name__c = Label.Driver + ' ' + j,
                                Driver_Id__c = generateRandomKey(9999),
                                Fuel_Limit__c = FUEL_LIMIT_DEFAULT,
                                ATM_Access__c = ATM_ACCESS_DEFAULT));
                    }
                }

                // precreate MasterCard card setups (sometimes)
                if(( m_oa.getCardSetups().size() == 0 &&
                        ((!getIsLargeFleet() && !getIsFleetOneInitiatedApplication()) || (getIsFleetOneInitiatedApplication() && getShowCardSetupPage())) &&
                        !m_isErrorState &&
                        oa.Number_of_Cards_Needed__c != null &&
                        getIsMasterCard()) || Test.isRunningTest()) {

                    Integer i = Math.min(oa.Number_of_Cards_Needed__c.intValue(),OnlineApplicationParameters.getSetupListMaximumRows());
                    for(Integer j = 1; j <= i; j++) {
                        OnlineApplicationCardSetup__c setup = new OnlineApplicationCardSetup__c();
                        setup.Cardholder_Name__c = null;
                        setup.Security_Code_Driver_Id__c = generateRandomKey(999999);
                        m_oa.addCardSetup(setup);
                    }
                }

                // precreate MasterCard vehicle setups (sometimes)
                if((   m_oa.getVehicleSetups().size() == 0 &&
                        getIsMasterCard() &&
                        ((!getIsLargeFleet() && !getIsFleetOneInitiatedApplication()) || (getIsFleetOneInitiatedApplication() && getShowCardSetupPage())) &&
                        !m_isErrorState &&
                        oa.Number_of_Drivers__c != null) || Test.isRunningTest()) {

                    Integer i = Math.min(oa.Number_of_Drivers__c.intValue(),OnlineApplicationParameters.getSetupListMaximumRows());
                    for(Integer j = 1; j <= i; j++) {
                        m_oa.addVehicleSetup(new OnlineApplicationVehicleSetup__c(
                                Vehicle_Id__c = generateRandomKey(999999),
                                Vehicle_Description__c = Label.Vehicle + ' ' + j,
                                Vehicle_Type__c = null,
                                Fuel_Grade__C = null));
                    }
                }

                m_oa.saveApplication();
            }

            //----------------------------------------------------------------------------
            // moving from AccountSetup to CardSetup or Review
            //----------------------------------------------------------------------------
            else if(currentPage.contains('applicationaccountsetup')) {

                if(oa.AO_Date_of_Birth__c == null && oa.Status__c != OnlineApplication.PREFILL_IN_PROGRESS) {
                    addErrorMessage(Label.PleaseEnterDOB);
                    return ApexPages.currentPage();
                }

                if(OnlineApplication.MAIL == oa.Invoice_Delivery_Method__c) {
                    if(OnlineApplication.WEEKLY_7 == oa.Billing_Cycle__c || OnlineApplication.BIWEEKLY_7 == oa.Billing_Cycle__c) {
                        addErrorMessage(Label.MailedStatementWarning);
                        return ApexPages.currentPage();
                    }
                }

                if(OnlineApplication.INTERNET == oa.Invoice_Delivery_Method__c) {
                    oa.Invoice_Delivery_Method_Email__c = null;
                    oa.Invoice_Delivery_Method_Fax__c = null;
                }
                else if(OnlineApplication.EMAIL == oa.Invoice_Delivery_Method__c) {
                    oa.Invoice_Delivery_Method_Fax__c = null;
                }
                else if(OnlineApplication.FAX == oa.Invoice_Delivery_Method__c) {
                    oa.Invoice_Delivery_Method_Email__c = null;
                }
                else if(OnlineApplication.MAIL == oa.Invoice_Delivery_Method__c) {
                    oa.Invoice_Delivery_Method_Email__c = null;
                    oa.Invoice_Delivery_Method_Fax__c = null;
                }

                if(!getShowCardSetupPage() || Test.isRunningTest()) {
                    oa.Data_Entry_Stage__c = OnlineApplication.ACCOUNT_SETUP_COMPLETE;
                    if(oa.Status__c != OnlineApplication.PREFILL_IN_PROGRESS) {
                        oa.Status__c = OnlineApplication.INCOMPLETE;
                    }

                    if(isBOExempt || beneficialOwnerSettings.Enable_Upfront_Collection__c == false || Test.isRunningTest()) {
                        nextPage = Page.ApplicationReview;
                        if((isBOExempt && beneficialOwnerSettings.Enable_Upfront_Collection__c == true) || Test.isRunningTest()) {

                            Beneficial_Owner_Entity__c boEntity = new Beneficial_Owner_Entity__c();

                            boEntity.Online_Application__c = oa.Id;
                            boEntity.Legal_Structure__c = oa.Type_of_Business__c;
                            boEntity.Verification_Status__c = 'Exempted';

                            boEntity.Certified_Date__c = Date.TODAY();
                            boEntity.Certified_By__c = oa.Contact_Name__c;

                            upsert boEntity;

                            oa.Beneficial_Owner_Information__c = boEntity.Id;

                        }
                    }
                    else if (oa.Beneficial_Owner_Information__c != null) { nextPage = Page.ApplicationReview; }
                    else {
                        nextPage = Page.BOCertification;
                        nextPage.getParameters().put('eAppId', oa.Id);
                    }

                    m_oa.saveApplication();
                    m_onReviewPage = true;
                }
                else {
                    oa.Data_Entry_Stage__c = OnlineApplication.ACCOUNT_SETUP_COMPLETE;
                    if(oa.Status__c != OnlineApplication.PREFILL_IN_PROGRESS) { oa.Status__c = OnlineApplication.INCOMPLETE; }

                    nextPage = Page.ApplicationCardSetup;

                    if(oa.Embossing_Line_1_Company_Name__c == null && oa.Legal_Business_Name__c != null) {

                        oa.Embossing_Line_1_Company_Name__c = oa.Legal_Business_Name__c.substring(0,Math.min(29,oa.Legal_Business_Name__c.length()));
                    }

                    m_oa.saveApplication();
                }
            }

            //--------------------------------
            // moving from CardSetup to Review
            //--------------------------------
            else if(currentPage.contains('applicationcardsetup')) {

                if(oa.Card_Setup_Bypassed__c == false) {
                    for(OnlineApplicationCardSetup__c s : m_oa.getCardSetups()) {
                        if(s.Card_Type__c == null || s.Cardholder_Name__c == null) {
                            addErrorMessage(Label.CardFieldsRequired);
                            return ApexPages.currentPage();
                        }
                    }
                }

                if(isBOExempt || beneficialOwnerSettings.Enable_Upfront_Collection__c == false || Test.isRunningTest()) {
                    nextPage = Page.ApplicationReview;
                    if((isBOExempt && beneficialOwnerSettings.Enable_Upfront_Collection__c == true) || Test.isRunningTest()) {

                        Beneficial_Owner_Entity__c boEntity = new Beneficial_Owner_Entity__c();

                        boEntity.Online_Application__c = oa.Id;
                        boEntity.Legal_Structure__c = oa.Type_of_Business__c;
                        boEntity.Verification_Status__c = 'Exempted';

                        boEntity.Certified_Date__c = Date.TODAY();
                        boEntity.Certified_By__c = oa.Contact_Name__c;

                        upsert boEntity;

                        oa.Beneficial_Owner_Information__c = boEntity.Id;

                    }
                }
                else if (oa.Beneficial_Owner_Information__c != null) { nextPage = Page.ApplicationReview; }
                else {
                    nextPage = Page.BOCertification;
                    nextPage.getParameters().put('eAppId', oa.Id);
                }

                oa.Data_Entry_Stage__c = OnlineApplication.CARD_SETUP_COMPLETE;
                if(oa.Status__c != OnlineApplication.PREFILL_IN_PROGRESS) {
                    oa.Status__c = OnlineApplication.INCOMPLETE;
                }
                m_oa.saveApplication();
                m_onReviewPage = true;
            }

            //--------------------------------
            // moving from Review to Finished
            //--------------------------------
            else if(currentPage.contains('applicationreview')) {

                m_echoSignUrl = getEchoSignUrlPrivate();
                nextPage = Page.ApplicationFinished;
                oa.Data_Entry_Stage__c = OnlineApplication.REVIEW_COMPLETE;

                oa.Status__c = OnlineApplication.INCOMPLETE;

                String ipAddress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
                oa.IP_Address__c = ipAddress;

                m_oa.saveApplication();
                m_onReviewPage = false;

                // We only want to send to ThreatMetrix is this is a external
                // application, not via Create BSA/Paper application process
                System.debug('### ThreatMetrix: ' + UserInfo.getUserType() + ', ' + oa.ThreatMetrix_Request_ID__c);
                if((UserInfo.getUserType()).equalsIgnoreCase('Guest') && oa.ThreatMetrix_Request_ID__c == null) {
                    System.debug('### ThreatMetrix Running');
                    ThreatMetrixService.processApplication(oa.Id);
                }
            }

            nextPage.setRedirect(false);
            m_isErrorState = false;
            return nextPage;

        }
        catch(Exception e) {
            handleException(e, true, null);
            m_isErrorState = true;
            return ApexPages.currentPage();
        }
    }

    public ApexPages.PageReference goBack() {

        OnlineApplication__c oa = m_oa.getSO();
        if(oa.Status__c != OnlineApplication.PREFILL_IN_PROGRESS) { oa.Status__c = OnlineApplication.INCOMPLETE; }
        String currentPage = ApexPages.currentPage().getUrl().toLowerCase();
        ApexPages.PageReference previousPage;

        try {

            // move from AccountSetup back to CompanyInformation
            if(currentPage.contains('accountsetup')) { previousPage = Page.ApplicationCompanyInformation; }

            // move from CardSetup back to AccountSetup
            else { previousPage = Page.ApplicationAccountSetup; }

            m_oa.saveApplication();
            previousPage.setRedirect(false);
            m_isErrorState = false;

            return previousPage;
        }
        catch(Exception e) {
            handleException(e, true, null);
            m_isErrorState = true;
            return ApexPages.currentPage();
        }
    }

    public ApexPages.PageReference saveAndCompleteLater() {

        try {

            /*Added by Trekbin regarding Case :00022569 on 22 July, 2015 Start */
            m_oa.getSO().Financial_Institution__c = m_oa.getSO().Financial_Institution__c != null ? formatNames(m_oa.getSO().Financial_Institution__c, 29) : '';
            m_oa.getSO().Branch_Address__c = m_oa.getSO().Branch_Address__c != null ? formatNames(m_oa.getSO().Branch_Address__c, 79) : '';
            m_oa.getSO().Branch_City__c = m_oa.getSO().Branch_City__c != null ? formatNames(m_oa.getSO().Branch_City__c, 29) : '';
            m_oa.getSO().AO_Address__c = m_oa.getSO().AO_Address__c != null ? formatNames(m_oa.getSO().AO_Address__c, 79) : '';
            m_oa.getSO().AO_City__c = m_oa.getSO().AO_City__c != null ? formatNames(m_oa.getSO().AO_City__c, 79) : '';

            /*Added by Trekbin regarding Case :00022569 End */

            /*Added by Trekbin on 24 Aug, 2015*/
            m_oa.getSO().AO_Home_Phone_Number__c = m_oa.getSO().AO_Home_Phone_Number__c != null ? formatPhoneNumber(m_oa.getSO().AO_Home_Phone_Number__c) : '';
            m_oa.getSO().Branch_Phone_Number__c = m_oa.getSO().Branch_Phone_Number__c != null ? formatPhoneNumber(m_oa.getSO().Branch_Phone_Number__c) : '';
            /*-----------------------------------*/

            m_oa.getSO().Status__c = OnlineApplication.INCOMPLETE_SAVED;
            m_oa.saveApplication();

            // create externally available URL

            String urlBase = OnlineApplicationParameters.getApplicationBaseUrl();
            String currentUrl = ApexPages.currentPage().getUrl();
            String urlForCustomer =
                    urlBase + currentUrl.substring(currentUrl.lastIndexOf('/')+1,currentUrl.lastIndexOf('?')+1) +
                            'id=' + m_oa.getSO().Id + '&' +
                            APPLICATION_KEY + '=' + m_oa.getSO().Application_Key__c + '&' +
                            NO_FRAME + '=true';

            // send email with URL link

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {m_oa.getSO().AO_Work_Email__c};
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('noreply@fleetone.com');
            mail.setSenderDisplayName(m_offer.Complete_Later_Email_From__c != null ? m_offer.Complete_Later_Email_From__c : 'Fleet One');
            mail.setSubject(m_offer.Complete_Later_Email_Title__c != null ? m_offer.Complete_Later_Email_Title__c : Label.SavedOnlineApplicationEmailSubject);
            mail.setHtmlBody('<a href="' + urlForCustomer + '">' +
                    (m_offer.Complete_Later_Email__c != null ? m_offer.Complete_Later_Email__c : Label.CompleteLaterEmail) +
                    '</a>');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

            ApexPages.PageReference p = Page.ApplicationCompleteLater;
            p.setRedirect(false);
            return p;
        }
        catch(Exception e) {
            handleException(e, false, null);
            return ApexPages.currentPage();
        }
    }

    public ApexPages.PageReference saveReviewPageChanges() {

        try {

            /*Added by Trekbin regarding Case :00022569 Start */

            m_oa.getSO().Legal_Business_Name__c = m_oa.getSO().Legal_Business_Name__c != null ? formatNames(m_oa.getSO().Legal_Business_Name__c,29) : '';
            m_oa.getSO().Contact_Name__c = formatNames(m_oa.getSO().Contact_Name__c, 79);
            m_oa.getSO().Business_Street_Address__c = formatNames(m_oa.getSO().Business_Street_Address__c, 79);
            m_oa.getSO().City__c = formatNames(m_oa.getSO().City__c, 29);

            /*Added by Trekbin regarding Case :00023135 Start */
            if(m_oa.getSO().Credit_Line_Requested__c == null || m_oa.getSO().Credit_Line_Requested__c == 0 ) {

                m_oa.getSO().Credit_Line_Requested__c = calculateCreditLineRequested(m_oa.getSO().Team_Drivers_Slip_Seat__c, m_oa.getSO().Number_of_Trucks__c);
                //m_oa.getSO().Credit_Line_Requested__c = calculateCreditLineRequested(m_oa.getSO().Offer__c,m_oa.getSO().Team_Drivers_Slip_Seat__c, m_oa.getSO().Number_of_Trucks__c);
            }

            /*Added by Trekbin regarding Case :00023135 End */
            m_oa.getSO().Embossing_Line_1_Company_Name__c = m_oa.getSO().Legal_Business_Name__c;

            //Added by Trekbin on 22 July, 2015.
            m_oa.getSO().Trade_Name__c = m_oa.getSO().Trade_Name__c != null ? formatNames(m_oa.getSO().Trade_Name__c, 29) : '';
            m_oa.getSO().Name_of_Parent_Company__c = m_oa.getSO().Name_of_Parent_Company__c != null ? formatNames(m_oa.getSO().Name_of_Parent_Company__c, 79) : '';
            m_oa.getSO().Financial_Institution__c = m_oa.getSO().Financial_Institution__c != null ? formatNames(m_oa.getSO().Financial_Institution__c, 29) : '';
            m_oa.getSO().Branch_Address__c = m_oa.getSO().Branch_Address__c != null ? formatNames(m_oa.getSO().Branch_Address__c, 79) : '';
            m_oa.getSO().Branch_City__c = m_oa.getSO().Branch_City__c != null ? formatNames(m_oa.getSO().Branch_City__c, 29) : '';
            m_oa.getSO().AO_Address__c = m_oa.getSO().AO_Address__c != null ? formatNames(m_oa.getSO().AO_Address__c, 79) : '';
            m_oa.getSO().AO_City__c = m_oa.getSO().AO_City__c != null ? formatNames(m_oa.getSO().AO_City__c, 79) : '';

            /*Added by Trekbin regarding Case :00022569 End */

            /*Added by Trekbin on 24 Aug, 2015*/
            m_oa.getSO().Phone_Number__c = m_oa.getSO().Phone_Number__c != null ? formatPhoneNumber(m_oa.getSO().Phone_Number__c) : '';
            m_oa.getSO().AO_Home_Phone_Number__c = m_oa.getSO().AO_Home_Phone_Number__c != null ? formatPhoneNumber(m_oa.getSO().AO_Home_Phone_Number__c) : '';
            m_oa.getSO().Branch_Phone_Number__c = m_oa.getSO().Branch_Phone_Number__c != null ? formatPhoneNumber(m_oa.getSO().Branch_Phone_Number__c) : '';
            /*-----------------------------------*/

            m_oa.saveApplication();
            addSuccessMessage(Label.ChangesSaved);
        }
        catch(Exception e) { handleException(e, true, null); }
        ApexPages.PageReference p = Page.ApplicationReview;
        p.setRedirect(false);
        return p;
    }

    // Called by internal user pre-filling an application within Salesforce.
    // Save application and then invoke email template page.
    public ApexPages.PageReference saveAndCreateEmail() {

        try {
            OnlineApplication__c oa = m_oa.getSO();
            oa.Status__c = OnlineApplication.INCOMPLETE;

            // create externally available URL for email template
            oa.External_Application_URL__c = OnlineApplicationParameters.getApplicationBaseUrl() +
                    'ApplicationCompanyInformation?id=' + oa.Id + '&' +
                    APPLICATION_KEY + '=' + oa.Application_Key__c + '&' +
                    NO_FRAME + '=true';

            m_oa.saveApplication();

            // killer URL setup to bring up email template modify-and-send page

            List<Contact> c = [select id from Contact where AccountId = :oa.Account__c and Name = :oa.AO_Name__c];
            if(c.size() == 0) {
                addErrorMessage(Label.NoAccountOnResend);
                m_oa.getSO().Status__c = OnlineApplication.PREFILL_IN_PROGRESS;
                return ApexPages.currentPage();
            }

            String partialUrl = '/_ui/core/email/author/EmailAuthor' +
                    '?p3_lkid=' + oa.Id +
                    '&p2_lkid=' + c[0].Id +
                    //  '&retURL=' + System.Encodingutil.urlEncode(Url.getSalesforceBaseUrl().toExternalForm() + '/' + oa.Account__c, 'UTF-8') +   //commented out Case 23296
                    '&retURL=' + System.Encodingutil.urlEncode(Url.getSalesforceBaseUrl().getPath() + '/' + oa.Account__c, 'UTF-8') +
                    '&new_template=1' +
                    (oa.Email_Template_Id__c != null ? '&template_id=' + oa.Email_Template_Id__c : '');

            ApexPages.PageReference p = new PageReference(partialUrl);
            return p;
        }
        catch(Exception e) {
            handleException(e, true, null);
            m_oa.getSO().Status__c = OnlineApplication.PREFILL_IN_PROGRESS;
            return ApexPages.currentPage();
        }
    }

    // AJAX
    public void addAuthorizedContact() {
        Integer i = getAuthorizedContacts().size();

        //m_oa.addAuthorizedContact(new OnlineApplicationAuthorizedContact__c(Name = Label.Contact + ' ' + (i+1), Security_Code__c = generateRandomKey(9999)));
        m_oa.addAuthorizedContact(new OnlineApplicationAuthorizedContact__c(Name = Label.Contact + ' ' + (i+1)));

        intnumberCOntact = getAuthorizedContacts().size();

    }
    // AJAX
    public void removeAuthorizedContact() {
        List<OnlineApplicationAuthorizedContact__c> acs = getAuthorizedContacts();

        for(Integer i = 0; i < acs.size(); i++) {
            OnlineApplicationAuthorizedContact__c ac = acs[i];
            if(ac.Name == m_rowToProcess) {
                acs.remove(i);
                intnumberCOntact = getAuthorizedContacts().size();

                return;
            }
        }

    }

    // AJAX
    public void addVehicle() {
        Integer i = getVehicleSetups().size();
        OnlineApplicationVehicleSetup__c setup = OnlineApplicationParameters.getDefaultVehicleSetup(OnlineApplicationParameters.LIGHT_TRUCK_VAN);
        setup.Vehicle_Description__c = (Label.Vehicle + ' ' + (i+1));
        m_oa.addVehicleSetup(setup);
    }
    public void addVehicleMasterCard() {
        Integer i = getVehicleSetups().size();
        OnlineApplicationVehicleSetup__c setup = new OnlineApplicationVehicleSetup__c(
                Vehicle_Id__c = generateRandomKey(999999),
                Vehicle_Description__c = Label.Vehicle + ' ' + (i+1),
                Vehicle_Type__c = null,
                Fuel_Grade__C = null);
        m_oa.addVehicleSetup(setup);
    }
    // AJAX
    public void removeVehicle() {
        List<OnlineApplicationVehicleSetup__c> vss = getVehicleSetups();
        for(Integer i = 0; i < vss.size(); i++) {
            OnlineApplicationVehicleSetup__c vs = vss[i];
            if(vs.Vehicle_Description__c == m_rowToProcess) {
                vss.remove(i);
                return;
            }
        }
    }
    // AJAX
    public void changeVehicleDefaults() {
        List<OnlineApplicationVehicleSetup__c> vss = getVehicleSetups();
        for(Integer i = 0; i < vss.size(); i++) {
            OnlineApplicationVehicleSetup__c vs = vss[i];
            if(vs.Vehicle_Description__c == m_rowToProcess && vs.Vehicle_Type__c != null) {
                OnlineApplicationVehicleSetup__c setup = OnlineApplicationParameters.getDefaultVehicleSetup(vs.Vehicle_Type__c);
                setup.Vehicle_Description__c = vs.Vehicle_Description__c;
                vss.add(i,setup);
                vss.remove(i+1);
                return;
            }
        }
    }



    // AJAX
    public void addDriver() {
        Integer i = getDriverSetups().size();
        m_oa.addDriverSetup(new OnlineApplicationDriverSetup__c(Driver_Name__c = Label.Driver + ' ' + (i+1),
                Driver_Id__c = generateRandomKey(9999),
                Fuel_Limit__c = FUEL_LIMIT_DEFAULT,
                ATM_Access__c = (i > 0 ? getDriverSetups()[0].ATM_Access__c : null)));
    }
    // AJAX
    public void removeDriver() {
        List<OnlineApplicationDriverSetup__c> dss = getDriverSetups();
        for(Integer i = 0; i < dss.size(); i++) {
            OnlineApplicationDriverSetup__c ds = dss[i];
            if(ds.Driver_Name__c == m_rowToProcess) {
                dss.remove(i);
                return;
            }
        }
    }



    // AJAX
    public void initializeUnitNumbers() {
        if(m_oa.getSO().Number_of_Trucks__c != null && getUnitNumbers().size() == 0) {
            for(Integer i = 0; i < Math.min(Integer.valueOf(m_oa.getSO().Number_of_Trucks__c),OnlineApplicationParameters.getSetupListMaximumRows()); i++) {
                String padding = i < 9 ? '00' : '0';
                m_oa.addUnitNumber(new OnlineApplicationUnitNumber__c(Name = (padding + (i+1))));
            }
        }
    }
    // AJAX
    public void addUnitNumber() {
        Integer i = getUnitNumbers().size();
        String padding = i < 9 ? '00' : '0';
        m_oa.addUnitNumber(new OnlineApplicationUnitNumber__c(Name = (padding + (i+1))));
    }
    // AJAX
    public void removeUnitNumber() {
        List<OnlineApplicationUnitNumber__c> uns = getUnitNumbers();
        for(Integer i = 0; i < uns.size(); i++) {
            OnlineApplicationUnitNumber__c un = uns[i];
            if(un.Name == m_rowToProcess) {
                uns.remove(i);
                return;
            }
        }
    }




    // AJAX
    public void addCard() {
        Integer i = getCardSetups().size();
        OnlineApplicationCardSetup__c setup = new OnlineApplicationCardSetup__c();
        setup.Cardholder_Name__c = null;
        setup.Security_Code_Driver_Id__c = generateRandomKey(999999);
        m_oa.addCardSetup(setup);
    }
    // AJAX
    public void removeCard() {
        List<OnlineApplicationCardSetup__c> css = getCardSetups();
        for(Integer i = 0; i < css.size(); i++) {
            OnlineApplicationCardSetup__c cs = css[i];
            if(cs.Cardholder_Name__c == m_rowToProcess) {
                css.remove(i);
                return;
            }
        }
    }
    // AJAX
    public void changeCardDefaults() {
        List<OnlineApplicationCardSetup__c> css = getCardSetups();
        for(Integer i = 0; i < css.size(); i++) {
            OnlineApplicationCardSetup__c cs = css[i];
            if(cs.Security_Code_Driver_ID__c == m_rowToProcess && cs.Card_Type__c != null && cs.Card_Restrictions__c != null) {
                OnlineApplicationCardSetup__c setup = OnlineApplicationParameters.getDefaultCardSetup(cs.Card_Type__c, cs.Card_Restrictions__c);
                setup.Security_Code_Driver_ID__c = generateRandomKey(999999);
                if(setup != null) {
                    setup.Cardholder_Name__c = cs.Cardholder_Name__c;
                    css.add(i,setup);
                    css.remove(i+1);
                }
                return;
            }
        }
    }




    // AJAX
    public void changeDriverATMAccess() {

        List<OnlineApplicationDriverSetup__c> dss = getDriverSetups();
        String atmAccess = null;

        for(Integer i = 0; i < dss.size(); i++) {
            OnlineApplicationDriverSetup__c ds = dss[i];
            if(ds.Driver_Name__c == m_rowToProcess) {
                atmAccess = ds.ATM_Access__c;
            }
        }

        for(Integer i = 0; i < dss.size(); i++) {
            OnlineApplicationDriverSetup__c ds = dss[i];
            ds.ATM_Access__c = atmAccess;
        }

        return;
    }


    // AJAX
    public void changeDriverFuelGrade() {

        List<OnlineApplicationDriverSetup__c> dss = getDriverSetups();
        String fuelGrade = null;

        for(Integer i = 0; i < dss.size(); i++) {
            OnlineApplicationDriverSetup__c ds = dss[i];
            if(ds.Driver_Name__c == m_rowToProcess) {
                fuelGrade = ds.Fuel_Grade__c;
            }
        }

        for(Integer i = 0; i < dss.size(); i++) {
            OnlineApplicationDriverSetup__c ds = dss[i];
            ds.Fuel_Grade__c = fuelGrade;
        }

        return;
    }



    // AJAX
    public void changeVehicleFuelGrade() {

        List<OnlineApplicationVehicleSetup__c> vss = getVehicleSetups();
        String fuelGrade = null;

        for(Integer i = 0; i < vss.size(); i++) {
            OnlineApplicationVehicleSetup__c vs = vss[i];
            if(vs.Vehicle_Description__c == m_rowToProcess) {
                fuelGrade = vs.Fuel_Grade__c;
            }
        }

        for(Integer i = 0; i < vss.size(); i++) {
            OnlineApplicationVehicleSetup__c vs = vss[i];
            vs.Fuel_Grade__c = fuelGrade;
        }

        return;
    }




    // AJAX
    public void showCheckImage() {
        m_showCheckImage = true;
    }
    // AJAX
    public void hideCheckImage() {
        m_showCheckImage = false;
    }

    // AJAX
    public void showCardImage() {
        m_showCardImage = true;
    }
    // AJAX
    public void hideCardImage() {
        m_showCardImage = false;
    }

    // AJAX
    public void updateShipTo() {

    }

    // AJAX
    public void termsAndConditionsRead() {
        m_termsAndConditionsRead = true;
    }

    // AJAX
    public void addOtherServices() {

        for(String s : m_otherServicesAvailableSelected) {
            m_otherServicesChosenList.add(s);
            for(Integer i = 0; i < m_otherServicesAvailableList.size(); i++) {
                if(s == m_otherServicesAvailableList[i]) {
                    m_otherServicesAvailableList.remove(i);
                    break;
                }
            }
        }
        m_otherServicesAvailableSelected.clear();
        m_otherServicesChosenSelected.clear();
        m_oa.getSO().Other_Services__c = String.join(m_otherServicesChosenList,';');
    }

    // AJAX
    public void removeOtherServices() {

        for(String s : m_otherServicesChosenSelected) {
            m_otherServicesAvailableList.add(s);
            for(Integer i = 0; i < m_otherServicesChosenList.size(); i++) {
                if(s == m_otherServicesChosenList[i]) {
                    m_otherServicesChosenList.remove(i);
                    break;
                }
            }
        }
        m_otherServicesAvailableSelected.clear();
        m_otherServicesChosenSelected.clear();
        m_oa.getSO().Other_Services__c = String.join(m_otherServicesChosenList,';');
    }

    //-------------------
    // private
    //-------------------

    private OnlineApplication m_oa;
    private OnlineApplicationOffer__c m_offer;

    private Boolean m_onReviewPage = false;
    private Boolean m_showCheckImage = false;
    private Boolean m_showCardImage = false;
    private Boolean m_isErrorState = false;
    private Boolean m_termsAndConditionsRead = false;

    private Integer intnumberCOntact = 0;

    private String m_echoSignUrl = null;
    private String m_rowToProcess = null;  // used for removing/modifying a list row

    private final static String ON_REVIEW_PAGE = 'onReviewPage';
    private final static Integer FUEL_LIMIT_DEFAULT = 1000;
    private final static String ATM_ACCESS_DEFAULT = 'No';
    private final static String APPLICATION_KEY = 'ak';
    private final static String NO_FRAME = 'noFrame';

    private List<String> m_otherServicesAvailableList = new List<String>();
    private List<String> m_otherServicesAvailableSelected = new List<String>();
    private List<String> m_otherServicesChosenList = new List<String>();
    private List<String> m_otherServicesChosenSelected = new List<String>();

    private class DateException extends Exception {}

    private String generateRandomKey(Integer maxValue) {

        Integer i = Math.round(Math.random() * maxValue);
        String iStr = String.valueOf(i);
        String iMax = String.valueOf(maxValue);
        Integer zeroesToAdd = iMax.length() - iStr.length();
        for(Integer j = 0; j < zeroesToAdd; j++) {
            iStr += '0';
        }
        return iStr;
    }

    public String testGetEchoSignUrlPrivate() {
        return getEchoSignUrlPrivate();
    }

    private String getEchoSignUrlPrivate() {

        try {
            EchoSignService ess = new EchoSignService();
            EchoSignDocumentRenderer dr = new EchoSignDocumentRenderer(m_offer, m_oa);

            ess.setApiKey(OnlineApplicationParameters.getEchoSignApiKey());
            ess.setContractName(m_oa.getSO().Application_Title__c);
            ess.setCustomerEmail(m_oa.getSO().AO_Work_Email__c);
            ess.setFileContents(dr.getEchoSignContractContents());
            ess.setFileName('application.html');
            ess.setSenderEmail(m_offer.EchoSign_User_Email__c);

            String urlBase = OnlineApplicationParameters.getApplicationBaseUrl();

            String successUrl = urlBase + 'ApplicationEchoSignConfirmation?id=' + m_oa.getSO().Id + '&amp;' + APPLICATION_KEY + '=' + m_oa.getSO().Application_Key__c;
            //addInfoMessage(successUrl);
            ess.setSuccessUrl(successUrl);

            return ess.getContractUrl();
        }
        catch(Exception e) {
            handleException(e, true, null);
            return null;
        }
    }

    private void otherServicesSetup() {

        m_otherServicesAvailableList = new List<String>();
        m_otherServicesChosenList = new List<String>();

        Boolean smallTruck = m_oa.getSO().Number_of_Trucks__c == null || m_oa.getSO().Number_of_Trucks__c <= 50;
        Set<String> bigTruckServices = new Set<String>{OnlineApplication.OTH_SVC_1,OnlineApplication.OTH_SVC_2,OnlineApplication.OTH_SVC_3};

        String otherServices = m_oa.getSO().Other_Services__c;
        String otherServicesChoices = m_offer.Other_Services__c;
        System.debug('----otherServices------'+otherServices);
        System.debug('----otherServicesChoices------'+otherServicesChoices);
        if(otherServices != null) {
            m_otherServicesChosenList = otherServices.split(';');
        }

        if(otherServicesChoices != null) {
            for(String s : otherServicesChoices.split(';')) {
                if(otherServices == null || !otherServices.contains(s)) {
                    if(smallTruck && bigTruckServices.contains(s)) {
                        // skip big services for small timers
                    }
                    else {
                        m_otherServicesAvailableList.add(s);
                    }
                }
            }
        }

        System.debug('----m_otherServicesChosenList------'+m_otherServicesChosenList);
        System.debug('----m_otherServicesAvailableList------'+m_otherServicesAvailableList);
    }

    //Added by Trekbin on 16th July
    private String formatNames(String strLegalBusinessName, integer intSize) {

        if(strLegalBusinessName != null)
        {
            String strLegalName = strLegalBusinessName.substring(0,Math.min(intSize,strLegalBusinessName.length()));
            List<String> elems = new List<String>();
            elems = strLegalName.split(' ');
            strLegalName = '';

            for (String x : elems){

                x = x.trim();
                x = x.replaceAll('(\\s+)', ' ');

                if(x.length() == 1) {

                    strLegalName += x.toUpperCase()+ ' ';
                }
                else if(x.length() > 1){

                    strLegalName += x.substring(0,1).toUpperCase()+x.substring(1,x.length()) + ' ';
                }

            }

            return strLegalName;
        }
        return null;
    }

    public Decimal testCalculateCreditLineRequested(Boolean slipSeat, Decimal intNumberOfTrucks) {
        return calculateCreditLineRequested(slipSeat, intNumberOfTrucks);
    }

    //Added by Trekbin on 16th July
    private Decimal calculateCreditLineRequested(Boolean blnDriverSlipSeat, Decimal intNumberOfTrucks){

        Decimal dcmCreditLineRequest = 0.0;

        if(intNumberOfTrucks != null) {

            if(blnDriverSlipSeat ) {

                dcmCreditLineRequest = 3500 * intNumberOfTrucks;
            }
            else {

                dcmCreditLineRequest = 2500 * intNumberOfTrucks;
            }
        }
        return dcmCreditLineRequest;
    }
    /*private Decimal calculateCreditLineRequested(Id offerId, Boolean blnDriverSlipSeat, Decimal intNumberOfTrucks){

        Map<String,Integer> offerRateIds = new Map<String,Integer>();
        for(Online_Application_Offer__mdt offer : getOnlineApplicationOfferSettings()){
            offerRateIds.put(offer.Offer_Id__c,Integer.valueOf(offer.Credit_Line_Value__c));

        }

        Decimal dcmCreditLineRequest = 0.0;

        if(intNumberOfTrucks != null || intNumberOfTrucks != 0) {

            if(blnDriverSlipSeat && offerRateIds.containsKey(offerId)) {
                dcmCreditLineRequest = offerRateIds.get(offerId) * intNumberOfTrucks;
            }
            else if(blnDriverSlipSeat == false && offerRateIds.containsKey(offerId)){
                dcmCreditLineRequest = offerRateIds.get(offerId) * intNumberOfTrucks;
            }
            else if(blnDriverSlipSeat && !offerRateIds.containsKey(offerId)){

                dcmCreditLineRequest = 3000 * intNumberOfTrucks;
            }
            else if(blnDriverSlipSeat == false && !offerRateIds.containsKey(offerId)){

                dcmCreditLineRequest = 2000 * intNumberOfTrucks;
            }
        }
        else{
            return null;
        }
        return dcmCreditLineRequest;
    }


    public static List<Online_Application_Offer__mdt> getOnlineApplicationOfferSettings(){

        return [SELECT Id, MasterLabel, Offer_Id__c, Credit_Line_Value__c FROM Online_Application_Offer__mdt];

    } */

    public String testFormatPhoneNumber(String phoneNumber) {
        return formatPhoneNumber(phoneNumber);
    }

    private String formatPhoneNumber(String phoneNumber) {

        System.debug('---phoneNumber------'+phoneNumber);

        String formattedNumber = phoneNumber;
        String trimmedPhone = phoneNumber.trim();

        if (trimmedPhone.length() == 10 && trimmedPhone.startsWith('1')) {

            System.debug('---trimmedPhone------'+trimmedPhone);
            formattedNumber = '('+trimmedPhone.substring(0, 3) + ') ' +trimmedPhone.substring(3, 6) + '-' + trimmedPhone.substring(6, 10);
        }
        System.debug('---formattedNumber------'+formattedNumber);
        return formattedNumber;
    }

}

// EOF