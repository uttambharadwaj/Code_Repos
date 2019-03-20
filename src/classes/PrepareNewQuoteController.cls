/**
 * Controller for PrepareNewQuotePage
 * 
 * @authors Tan Pham , Marie Bradford
 * */
public with sharing class PrepareNewQuoteController{
    //Variables for intializing Quote and Page
    private Zuora.zApi api = new Zuora.zApi();
    public Opportunity opp  {get;set;}
    private final String CRMId;
    private final Map <String,List<SelectOption>> cachedSubOptions = new Map <String,List<SelectOption>>();
    public Account acc {get;set;}
    public String wexAccountNumber                      {get;set;}
    public Zuora__CustomerAccount__c custAcc            {get;set;}
    public Shipment__c ship                             {get;set;}
    public Boolean initFailed                           {get; private set;}
    
    public String  selectedAccountType                  {get;set;}
    public String  selectedAccount                      {get;set;}
    public String  selectedSubscription                 {get;set;}
    public String  selectedSubscriptionType             {get;set;}
    public String  selectedAmendmentType                {get;set;}
    
    public List<SelectOption> billingAccountList        {get;set;}
    public List<SelectOption> subscriptionList          {get;set;}
    public Boolean  useSecondaryAccount                 {get;set;}
    public zqu__Quote__c quote                          {get;set;}
    public Contact contact                              {get;set;}
    public String  selectedAccountId                    {get;set;}
    public String  selectedBillingContactId             {get;set;}
    public String  quoteId                              {get;set;}
    
    public String  shipAddress1                         {get;set;}
    public String  shipAddress2                         {get;set;}
    public String  shipContactName                      {get;set;}
    public String  shipContactPhone                     {get;set;}
    public String  shipContactEmail                     {get;set;}
    public String  shipCity                             {get;set;}
    public String  shipState                            {get;set;}
    public String  shipZipCode                          {get;set;}
    public Boolean shipSameAsPrimary                    {get;set;}
    public List<ID> shipmentIDs                         {get;set;}
    
    public String  paymentTerm                          {get;set;}
    public Integer shipmentIndex                        {get;set;}
    public Boolean isEditingLocation                    {get;set;}
    public Boolean isPending                            {get;set;}
    public string rma                                   {get;set;}
    public string oppNumber                             {get;set;}
    public boolean REQUIRED                             {get{return true;} set;}                        
   
    public List<SelectOption> salesRep1                 {get;set;}
    public List<SelectOption> salesRep2                 {
        //Returns all users in a Select Option list at a limit of 999 records
        get{
            List<User> userList = [
                Select
                    Id,
                    Name
                From
                    User
                Order By
                    Name ASC
                Limit 999
            ];
            
            List<SelectOption> code = new List<SelectOption>();
            code.add(new SelectOption('', ''));
            for (User u : userList){
                code.add(new SelectOption(u.Id, u.Name));
            }
            return code;
        }set;}
    public string    chosenSalesRep1                    {get;set;}
    public string    chosenSalesRep2                    {get;set;}
    
    public string    firstTimeOrder                     {get;set;}
    public string    chosenPromoCode                    {get;set;}
    public string    taxCertificateIDForTel             {get;set;}
    public String    datename                           {get;set;}
    public String    vendorOrderInstruction             {get;set;}
    public String    customerAppOveride                 {get;set;}
    public String    chosenPdfTemplate                  {get;set;}
    public String    SalesComments                      {get;set;}
    
    public String    quoteNumber                        {get;set;}
    public List<Shipment__c> shipments                  {get;set;}
    public List<Shipment__c> shipmentsToInsert          {get;set;}
    public zqu.NotificationOptions notificationOptions  {get;set;}
    private CCH_Transaction.ResolveAddressResult correctedAddressResult {get;set;}
    
    public String primaryFuelTaxExempt                  {get;set;}
    public String secondaryFuelTaxExempt                {get;set;}
    
    
    private Id editedShipmentId = null;
    private Pattern emailPattern = Pattern.compile('([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})');
    
    //functionality to help check if products exsit and another vendor is chosed
    private String chosenVendorCheck = '';                 
    private Boolean existingCharges = false;
    
    //' ------------------- 

    /**
     * Variables which require computation in the backend to either be filled in when page loads
     * or if based on other variables values
     */
    
    //Returns today's date
    public String datePrepared{
        get{
            DateTime datePrep = DateTime.now();
            String dateS = datePrep.format('MM/dd/yy');
            System.debug(datePrepared);
            return dateS;
        }set;}
    
    //Querys for all Conga Templates
    //Defaults to the first in the list
    public List<SelectOption> pdfTemplate{
        get{
            List<SelectOption> code = new List<SelectOption>();
            List<APXTConga4__Conga_Template__c> cts = [SELECT 
                Id, 
                APXTConga4__Name__c
              FROM   APXTConga4__Conga_Template__c 
              WHERE  DisplayOrder__c != null 
              ORDER BY DisplayOrder__c ASC]; 
            //code.add(new SelectOption('--None--', '')); 
            if (cts.size() > 0 && (chosenPdfTemplate == null || chosenPdfTemplate == '')) {
              chosenPdfTemplate = cts[0].Id; 
            }
            for (APXTConga4__Conga_Template__c ct : cts) {
              code.add(new SelectOption(ct.Id, ct.APXTConga4__Name__c)); 
            }
            System.debug('Chosen pdf template is: ' + chosenPdfTemplate); 
        
            return code;
        }set;}
    
    //Queries Campaign Programs
    //Does not default
    public List<SelectOption> promoCode{
        get{
            List<SelectOption> code = new List<SelectOption>();
            List<Campaign_Program__c> campaignPrograms = [
                Select 
                    Campaign__r.Name
                from
                    Campaign_Program__c
                where
                    Name = 'WEXTelematics'
            ];
            
            List<String> options = new List<String>();
            for (Campaign_Program__c co :campaignPrograms) {
                options.add(co.Campaign__r.Name);
            }
            
            options.sort();
            
            code.add(new SelectOption('--None--', '--None--'));
            for (String option :options) {
                if (option != null)
                    code.add(new SelectOption(option, option));
            }
            return code;
        }set;}
    
    //First Time Order field
    public List<SelectOption> firstTimeOrderList{
        get{
            List<SelectOption> firstOrder = new List<SelectOption>();
            firstOrder.add(new SelectOption('',''));
            firstOrder.add(new SelectOption('No','No'));
            firstOrder.add(new SelectOption('Yes','Yes'));
            return firstOrder;
        }set;}
    
    //Tax Exempt field
    public List<SelectOption> TaxExemptTelematics{
        get{
            List<SelectOption> taxExempt = new List<SelectOption>();
            //taxExempt.add(new SelectOption('',''));
            taxExempt.add(new SelectOption('No','No'));
            taxExempt.add(new SelectOption('Yes','Yes'));
            return taxExempt;
        }set;}
    
    //Queries for Accounts which are Vendor accounts and create list
    public List<SelectOption> TelematicsVendor{
        get{
            List<SelectOption> vendors = new List<SelectOption>();

            vendors.add(new SelectOption('', ''));
            
            List<Account> vendorAccounts = [Select Id, Name, Vendor_Name__c from Account WHERE Is_Vendor__c = true];
            System.debug(vendorAccounts);
            //Uses the vendor name as the select option and the account id as the value
            if(vendorAccounts != null && vendorAccounts.size() >0){
                for(Account a: vendorAccounts){
                    vendors.add(new SelectOption(a.Id,a.Vendor_Name__c));
                }
            }
        
            return vendors;
        }set;}
    
    /*
     * Controller Initialization
     */
    public PrepareNewQuoteController(ApexPages.StandardController controller) {
        
        // Add fields here to ensure controller has them visible to always have access to hidden (from viewstate) fields
        List<String> fields = new List<String>();
        
        if(!Test.isRunningTest())
           controller.addFields(fields);
    
        zqu.NotificationOptions notOpt = new zqu.NotificationOptions();
        notOpt.isPopup = true;
        notOpt.backLabel = 'OK';
        notOpt.continueAction = null;
        notOpt.backAction = 'stayOnCurrentPage();';
        notificationOptions = notOpt;
        
        if(ApexPages.currentPage().getParameters().get('useSecondaryAccount')!= null){
            useSecondaryAccount = ApexPages.currentPage().getParameters().get('useSecondaryAccount') == 'Y'?true:false;
        }else{  
            useSecondaryAccount = false;
        }

        this.initFailed = true;
        acc = new Account();
        
        final String oppId;
        if(controller.getId()!=null){
            oppId = controller.getId();
        } else if(ApexPages.currentPage().getParameters().get('oppid')!=null) {
            oppId=ApexPages.currentPage().getParameters().get('oppid');
        } else {
            appendErrorMessage('Need to specify the opportunity ID to create a quote.');
            return;
        }
        
        final List<Opportunity> oppList = [SELECT Id, Account.Wex_Account__c,Account.F1_Account_Number__c,Name, Sales_Rep_Name__c,Sales_Rep_Last_Name__c,Account.Id,Opportunity_Number__c, OwnerId, Owner.Name FROM Opportunity WHERE Id = :oppId limit 1];
        if (oppList.size() != 1) {
            appendErrorMessage('Invalid opportunity specified to create a quote.');
            return;
        }
        oppNumber=oppList.get(0).Opportunity_Number__c;
        this.opp = oppList[0];
        this.CRMId = this.opp.Account.Id;
        if (opp.Account.Wex_Account__c!=null && opp.Account.Wex_Account__c !='')
            this.wexAccountNumber = opp.Account.Wex_Account__c;
        else
            this.wexAccountNumber = opp.Account.F1_Account_Number__c;
        
        //Create SalesRep1 here because needs to be added to based on opp owner
        //These are specific users with the roles of Telematics Sales Manager, Telematics Data Administrator or Telamatics Inside Sales
        List<User> userList = [
                Select Id, Name From User
                Where userrole.name = 'Telematics Sales Manager' OR userrole.name = 'Telematics Data Administrator' OR userrole.name = 'Telamatics Inside Sales'
                Order By Name ASC Limit 999];
        
        this.salesRep1 = new List<SelectOption>();
        this.salesRep1.add(new SelectOption('', ''));
        Integer soCounter = 0;
        for (User u : userList){
            this.salesRep1.add(new SelectOption(u.Id, u.Name));
            //Check if the opp owner is in the sales list
            if(u.Id == opp.OwnerId){
                soCounter++;
            }
        }
        //If the opp owner is not in the list of sales, add them 
        if(soCounter == 0){
            System.debug('Adding new option');
            this.salesRep1.add(new SelectOption(opp.OwnerId, opp.Owner.Name));
        }
       
        //Checks if there is an existing quote
        if(ApexPages.currentPage().getParameters().get('quoteid')!=null){
            final String qId=ApexPages.currentPage().getParameters().get('quoteid');
            quoteId=qId;
            //Queries shipments from Quote
            List<Shipment__c> shipData= [SELECT Id,Address_Line_1__c,Address_Line_2__c,Shipping_Contact__c,Shipping_Contact_Phone__c,Shipping_Contact_Email__c,City__c,State__c,Zip__c FROM Shipment__c WHERE Quote__c=:quoteId];
            shipments=shipData;
            //Queries Quote values
            quote = [
                Select
                    Id,
                    Name,
                    isPending__c,
                    zqu__Number__c,
                    QuoteNumber__c,
                    zqu__Status__c,
                    zqu__ValidUntil__c,
                    FirstTimeOrder__c,
                    Vendor_Account__c,
                    Vendor__c,
                    SalesRep1__c,
                    DatePrepared__c,
                    SalesRep2__c,
                    PrimaryAccountNumber__c,
                    PrimarySponsor__c,
                    PrimaryAccountName__c,
                    PrimarySource__c,
                    PrimaryCreditLimit__c,
                    PrimaryAddress1__c,
                    PrimaryAddress2__c,
                    PrimaryCity__c,
                    PrimaryState__c,
                    PrimaryZip__c,
                    PrimaryContact__c,
                    PrimaryPhone__c,
                    PrimaryEmail__c,
                    zqu__Tax_Exempt__c,
                    zqu__Certificate_Id__c,
                    SecondaryAccountNumber__c,
                    SecondarySponsor__c,
                    SecondaryAccountName__c,
                    SecondarySource__c,
                    SecondaryCreditLimit__c,
                    SecondaryAddress1__c,
                    SecondaryAddress2__c,
                    SecondaryCity__c,
                    SecondaryState__c,
                    SecondaryZip__c,
                    SecondaryContact__c,
                    SecondaryPhone__c,
                    SecondaryEmail__c,
                    SecondaryTaxExempt__c,
                    SecondaryCertificateId__c,
                    Vendor_Order_Instructions__c,
                    Internal_Sales_Comments__c,
                    PromoCode__c,
                    CustomerApprovalOverride__c,
                    rmaNumber__c,
                    Chosen_PDF_Template__c
                From
                    zqu__Quote__c
                Where
                    Id = :quoteId
            ];
            
            chosenPdfTemplate = quote.Chosen_PDF_Template__c;
            System.debug('Quote during Controller load' + quote);
            
            chosenVendorCheck = quote.Vendor_Account__c;
            //Queries for existing charges
            //If there are exisiting charges, the Telematics Vendor cannot be changed
            List<Shipment_Charge_Group__c> shipmentCharges = [Select Id from Shipment_Charge_Group__c where Quote__c=:quoteId];
            System.debug(shipmentCharges);
            if(shipmentCharges != null && !shipmentCharges.isEmpty()){
                existingCharges = true;
            }
            
            if (quote.SecondarySponsor__c != null) {
                useSecondaryAccount = true;
            }
        //Creates Quote if one does not exist    
        } else {
            quote = new zqu__Quote__c();
            quote.datePrepared__c = Date.today();
            System.debug('Todays date ' + Date.today());
            quote.zqu__Status__c = 'New';
            quote.zqu__ValidUntil__c = quote.datePrepared__c.addDays(60);
            quote.isPending__c = false;
            quote.SalesRep1__c = opp.OwnerId;
            
        }
        
        this.initFailed = false;
        
        isEditingLocation = false;
        
    }
    
    public void checkFields(){
        if (quote.PrimaryAddress2__c == null)
            quote.PrimaryAddress2__c = 'test';
        if (quote.PrimaryPhone__c == null)
            quote.PrimaryPhone__c = '';
        
    }
    
    //Checks is the Tax Exempt Fields are set to True
    //If there is not Certificate Id specified, warning message is thrown
    public void createWarning(){
        if(quote.zqu__Tax_Exempt__c=='Yes' && (quote.zqu__Certificate_ID__c == null || quote.zqu__Certificate_ID__c == '')){
            notificationOptions.continueAction = null;
            notificationOptions.backLabel = 'OK';
            notificationOptions.backAction = 'stayOnCurrentPage();';
            appendWarningMessage( 'This account is being set as Tax Exempt. Please enter a Tax Certificate Id.');
        }
        if(quote.SecondaryTaxExempt__c=='Yes' && (quote.SecondaryCertificateId__c == null || quote.SecondaryCertificateId__c == '')){
            notificationOptions.continueAction = null;
            notificationOptions.backLabel = 'OK';
            notificationOptions.backAction = 'stayOnCurrentPage();';
            appendWarningMessage( 'Secondary account is being set as Tax Exempt. Please enter a Tax Certificate Id.');
        }
    }
    
    //Displays warning if Primary Account Qualifies for tax exempt
    public void showFuelTaxWarningForPrimary(){
        if(primaryFuelTaxExempt=='Qualified'){
            notificationOptions.continueAction = null;
            notificationOptions.backLabel = 'OK';
            notificationOptions.backAction = 'stayOnCurrentPage();';
            appendWarningMessage( 'This account is tax exempt for fuel.');
        }
    }
    //Displays warning if Secondary Account Qualifies for tax exempt
    public void showFuelTaxWarningForSecondary(){
        if(secondaryFuelTaxExempt=='Qualified'){
            notificationOptions.continueAction = null;
            notificationOptions.backLabel = 'OK';
            notificationOptions.backAction = 'stayOnCurrentPage();';
            appendWarningMessage( 'This account is tax exempt for fuel.');
        }
    }
    
    public class GenericException extends Exception {
    }
    
    //Clears values on page
    //Called when Pending WEX Account checkbox is toggled
    public void clearAccount(){
    
        System.Debug('clearAccount called...');
        System.Debug('..quote.isPending__c: ' + quote.isPending__c);

        Boolean pendingCheckbox = quote.isPending__c;

        quote = new zqu__Quote__c();
        quoteId = null;
        quote.datePrepared__c = Date.today();
        quote.zqu__Status__c = 'New';
        quote.zqu__ValidUntil__c = quote.datePrepared__c.addDays(60);
        quote.isPending__c = pendingCheckbox;
        
        shipAddress1 = null;
        shipAddress2 = null;
        shipContactName = null;
        shipContactPhone = null;
        shipContactEmail = null;
        shipCity = null;
        shipState = null;
        shipZipCode = null;
        
        shipments = new List<Shipment__c>();
        shipmentsToInsert = new List<Shipment__c>();
        
        ApexPages.getMessages().clear();
        
    }
    
    //Clears values on Secondary Account
    //Called when Use Separate Account checkbox is toggled
    public void clearSecondaryAccount(){

        quote.SecondarySponsor__c = '';
        quote.SecondaryAccountNumber__c = '';
        quote.SecondaryAccountName__c = '';
        quote.SecondarySource__c = '';
        quote.SecondaryCreditLimit__c = null;
        quote.SecondaryAddress1__c = '';
        quote.SecondaryAddress2__c = '';
        quote.SecondaryCity__c = '';
        quote.SecondaryState__c = '';
        quote.SecondaryZip__c = '';
        quote.SecondaryContact__c = '';
        quote.SecondaryPhone__c = '';
        quote.SecondaryEmail__c = '';
        quote.SecondaryTaxExempt__c = 'No';
        quote.SecondaryCertificateId__c = '';
        
    }
    
    public void confirmError(){
        clearOutNotifications();
    }
    
    public String quoteStatus{
        get{
            String status='New';
            return status;
        }set;}
    
    //Method is used to update or insert Quote
    public void goNewQuote() {
        System.debug('Quote ' + quote);
        
        System.debug('Primary Account # Before: ' + quote.PrimaryAccountNumber__c);
        
        
        System.debug('Primary Account # After: ' + quote.PrimaryAccountNumber__c);
        
        if(quoteId==null){
            if(this.acc!=null){
                quote.zqu__Account__c=this.acc.Id;
            }else {
                quote.zqu__Account__c = createAccount();
            }
            if(this.opp!=null){
                quote.zqu__Opportunity__c=this.opp.Id;
                quote.zqu__Account__c=this.CRMId;
            }
            if(quote.Vendor_Account__c != null){
                
                for(SelectOption so: TelematicsVendor){
                    if(so.getValue() == String.valueOf(quote.Vendor_Account__c)){
                        quote.Vendor__c = so.getLabel();
                        break;
                    }
                }
            }
            
            quote.Chosen_PDF_Template__c = chosenPdfTemplate; 
            quote.UsingSecondaryAccount__c = useSecondaryAccount; 
            System.debug('quote.UsingSecondaryAccount__c ' + quote.UsingSecondaryAccount__c); 
            System.debug('useSecondaryAccount: ' + useSecondaryAccount); 
            insert quote;
            quoteId=quote.Id;
        }else{
            
            quote.Chosen_PDF_Template__c = chosenPdfTemplate;
            
            //update Vendor
            if(quote.Vendor_Account__c != null){
                
                for(SelectOption so: TelematicsVendor){
                    if(so.getValue() == String.valueOf(quote.Vendor_Account__c)){
                        quote.Vendor__c = so.getLabel();
                        break;
                    }
                }
                System.debug(quote.Vendor__c);
            }
			quote.Chosen_PDF_Template__c = chosenPdfTemplate; 
            quote.UsingSecondaryAccount__c = useSecondaryAccount; 
            System.debug('quote.UsingSecondaryAccount__c ' + quote.UsingSecondaryAccount__c); 
            System.debug('useSecondaryAccount: ' + useSecondaryAccount); 
            update quote;
            
        }
        
        
        //Quote Id added here because Quote Id is known at this point
        //Quote Id is required for the shipment object
        for(Integer i =0; i < shipments.size(); i++){
            shipments.get(i).Quote__c = QuoteId;
        }
        if(!shipments.isEmpty()){
            upsert shipments;
        }
        
    }
    
    public Id createAccount(){
        
        return null;
    }
    
    //Method validates the fields and address of a shipment
    //Called by Add & Validate button
    //Called by Save & Validate button
    public void addAndValidateShippingAddress(){
        
        ApexPages.getMessages().clear();
        
        Pattern poBoxPattern = Pattern.compile('(?i)\\b(?:p\\.?\\s*o\\.?|post\\s+office)\\s+box.*');
        System.Debug('addAndValidateShippingAccress start...');
        System.Debug('..quote.PrimaryAccountNumber__c: ' + quote.PrimaryAccountNumber__c);
        
        if (isEditingLocation){
            Shipment__c ship =  shipments.remove(shipmentIndex);
            editedShipmentId = ship.Id;
            System.debug('Shipments ' + shipments);
        }
        
        /*
         *Checks if required fields are empty 
         */
        if(shipAddress1=='' || shipCity=='' || shipState=='' || shipZipCode=='' || shipContactName=='' || shipContactPhone=='' || shipContactEmail == ''){
            
            notificationOptions.backLabel = 'OK';
            notificationOptions.continueAction = null;
            notificationOptions.backAction = 'stayOnCurrentPage();';
            
            if(shipAddress1==''){
                appendWarningMessage(  'Shipping Address Line 1 is a required field. No shipping locations have been provided. Please add a shipping location.');
            }if(shipCity==''){
                 appendWarningMessage( 'Shipping City is a required field.');
            }if(shipState==''){
                 appendWarningMessage( 'Shipping State is a required field.');
            }if(shipZipCode==''){
                 appendWarningMessage( 'Shipping Zip Code is a required field.');
            }if(shipContactName==''){
                 appendWarningMessage( 'Shipping Contact Name is a required field.');
            }if(shipContactPhone==''){
                 appendWarningMessage( 'Shipping Contact Phone is a required field.');
            }if(shipContactEmail==''){
                 appendWarningMessage( 'Shipping Contact Email is a required field.');
            }
        }else if(poBoxPattern.matcher(shipAddress1).matches() || poBoxPattern.matcher(shipAddress2).matches()){
            notificationOptions.backLabel = 'OK';
            notificationOptions.continueAction = null;
            notificationOptions.backAction = 'stayOnCurrentPage();';
            appendWarningMessage( 'Shipping Address can not be a PO BOX.');
        }else if(shipContactEmail != null && shipContactEmail !='' && !(emailPattern.matcher(shipContactEmail)).find()){
            notificationOptions.backLabel = 'OK';
            notificationOptions.continueAction = null;
            notificationOptions.backAction = 'stayOnCurrentPage();';
            appendWarningMessage('Shipping Contact Email is not valid');
        }else{
            //Note(Jeff Tan): Begin code for address verification
            CCH_Transaction.ResolveAddressRequest address = new CCH_Transaction.ResolveAddressRequest();
            address.Address1 = shipAddress1;
            address.Address2 = shipAddress2;
            address.City = shipCity;
            address.State = shipState;
            address.Zip = shipZipCode;
            CCH__c cchSetting = [Select API_Password__c, API_Username__c, API_Endpoint__c, Message_Address_Invalid__c, Message_Address_Correction__c from CCH__c limit 1];
            CCH_Transaction.STxTransactionServiceEndpointPort cchService = new CCH_Transaction.STxTransactionServiceEndpointPort(cchSetting.API_Username__c, cchSetting.API_Password__c, cchSetting.API_Endpoint__c);       
            CCH_Transaction.ResolveAddressResult addressResult = cchService.ResolveAddress(address);
            String addressResultType = addressResult.ResultType;
            
            //Shipping Address is not Valid
            if (!addressResultType.equalsIgnoreCase('FULL')){
                //Address must be valid, only option to cancel
                notificationOptions.backLabel = 'OK';
                notificationOptions.backAction = 'stayOnCurrentPage();';
                notificationOptions.continueAction = null;
                appendWarningMessage( cchSetting.Message_Address_Invalid__c);
            //Shipping Address is PO Box
            }else if(poBoxPattern.matcher(addressResult.ResolvedAddress.Address1).matches() || poBoxPattern.matcher(addressResult.ResolvedAddress.Address2).matches()){
                notificationOptions.backLabel = 'OK';
                notificationOptions.continueAction = null;
                notificationOptions.backAction = 'stayOnCurrentPage();';
                appendWarningMessage( 'Shipping Address can not be a PO BOX.');
            //Returned result does not equal the input values
            }else if (!addressResult.ResolvedAddress.Address1.equalsIgnoreCase(shipAddress1) || 
               !addressResult.ResolvedAddress.Address2.equalsIgnoreCase(shipAddress2) || 
               !addressResult.ResolvedAddress.City.equalsIgnoreCase(shipCity) || 
               !addressResult.ResolvedAddress.State.equalsIgnoreCase(shipState) || 
               !addressResult.ResolvedAddress.Zip.equalsIgnoreCase(shipZipCode)){
                //Only take corrected address or cancel
                correctedAddressResult = addressResult;
                notificationOptions.continueAction = 'takeCorrectedAddressAndAddAddress();';
                notificationOptions.backAction = 'stayOnCurrentPage();';
                notificationOptions.backLabel = 'Cancel';
                appendWarningMessage( cchSetting.Message_Address_Correction__c);
                appendWarningMessage( addressResult.ResolvedAddress.Address1);
                appendWarningMessage( addressResult.ResolvedAddress.Address2);
                appendWarningMessage( addressResult.ResolvedAddress.City + ', ' + addressResult.ResolvedAddress.State + ' ' + addressResult.ResolvedAddress.Zip);
            //Address met all required scenarios and can be added
            }else{
                addShippingAddress();   
                clearOutNotifications();
            }
        }
    }
    
    //Sets the Page values to the Address result
    public void takeCorrectedAddressandAddAddress(){
        shipAddress1 = correctedAddressResult.ResolvedAddress.Address1;
        shipAddress2 = correctedAddressResult.ResolvedAddress.Address2;
        shipCity = correctedAddressResult.ResolvedAddress.City;
        shipState = correctedAddressResult.ResolvedAddress.State;
        shipZipCode = correctedAddressResult.ResolvedAddress.Zip;
        
        addShippingAddress();
        clearOutNotifications();
    }
    
    //Creates Shipment Object and Adds it to the shipment list
    //If the shipment is being edited, the existing shipment values are updated
    public void addShippingAddress(){
        
        Shipment__c shipingData = new Shipment__c();
        
        if(editedShipmentId != null){
            shipingData = new Shipment__c(Id = editedShipmentId);
        }
        
        shipingData.Address_Line_1__c=shipAddress1;
        shipingData.Address_Line_2__c=shipAddress2;                        
        shipingData.Shipping_Contact__c= shipContactName;                    
        shipingData.Shipping_Contact_Phone__c= shipContactPhone;                      
        shipingData.Shipping_Contact_Email__c= shipContactEmail;                    
        shipingData.City__c= shipCity;                             
        shipingData.State__c= shipState;                         
        shipingData.Zip__c= shipZipCode;
        
        if(shipments!=null && !shipments.isEmpty()){
           shipments.add(shipingData);
        } else{
            shipments= new List<Shipment__c>();
            shipments.add(shipingData);
        }
        isEditingLocation = false;
        System.Debug(shipments);
        editedShipmentId = null;
    }
    
    //Helper Error Message Method
    static private void appendErrorMessage(String message) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
    }
    
    //Helper Warning Message Method
    static private void appendWarningMessage(String message) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,message));
    }
    
    //Returns the index of the Shipment
    //Helps with editing Shipment functionality
    public List<Integer> getIndexes() {
        List<Integer> indexes = new List<Integer>();
        if(shipments!=null && !shipments.isEmpty()){
            for (Integer i = 0; i < this.shipments.size(); i++) indexes.add(i);
        }
        return indexes;
    }
    
    //Clears shipment information
    //Called by clear button in Shipment Section
    public void clear(){
        isEditingLocation = false;
        shipAddress1='';
        shipAddress2='';                           
        shipContactName='';                  
        shipContactPhone='';                      
        shipContactEmail='';                    
        shipCity='';                               
        shipState='';                        
        shipZipCode='';
        shipSameAsPrimary = false;
    }
    
    //Method checks if there are errors before allowing user to go to the next page
    //Called by Add Items button at the bottom of the page
    public PageReference goNextPage(){
        Integer errors = requestForCheck();
        if (errors > 0)
            return null;
        goNewQuote();

        PageReference  newQuotePage = Page.NewQuote;
        newQuotePage.getParameters().put('quoteid', quoteid);
        newQuotePage.getParameters().put('oppid', String.valueOf(this.opp.Id).substring(0,15));
        newQuotePage.setRedirect(true);
        return newQuotePage;
    }
    
    //Checks for errors before saving quote
    //If no errors, quote is update/inserted
    //Calles by Save button at the bottom of the page
    public PageReference save(){
        PageReference pageRef = null;
        Integer errors = requestForCheck();
        if (errors == 0){
            goNewQuote();

            pageRef = Page.PrepareNewQuote;
            pageRef.getParameters().put('quoteid', quoteid);
            pageRef.getParameters().put('oppid', String.valueOf(this.opp.Id).substring(0,15));
            pageRef.getParameters().put('useSecondaryAccount',(useSecondaryAccount?'Y':'N'));
            pageRef.setRedirect(true);
        }
        
        return pageRef;
        
    }

    //Helper method which take in a value and the error message if the value is null or empty
    //This method is used to check if account and shipment fields are filled in
    private Integer validateRequiredField(String value, String warningMessage){
        Boolean isValid = true;
        if(value == null || value == ''){
            isValid = false;
            appendWarningMessage(warningMessage);
        }

        return isValid?0:1;
    }
    
    //Helper method which validates Account fields
    //Validates if the email fields are ''@''.com format
    //Calls validateRequiredField
    public Integer requestForCheck(){
        
        ApexPages.getMessages().clear();
    
        Integer errorCount = 0;
        
        System.debug(quote.PrimaryAccountNumber__c);
        System.debug(quote.PrimarySponsor__c);

        errorCount += validateRequiredField(quote.PrimarySponsor__c, 'Account Number is a required field.');

        errorCount += validateRequiredField(quote.PrimaryAccountName__c, 'Account Name is a required field.');
        errorCount += validateRequiredField(quote.PrimarySource__c, 'Source is a required field.');
            
        if(quote.PrimaryCreditLimit__c == null || String.valueOf(quote.PrimaryCreditLimit__c) == ''){
           errorCount++;
           appendWarningMessage( 'Total Credit Limit is a required field.');
        }else if(!(quote.PrimaryCreditLimit__c).isNumeric()){
            try{
                Decimal pcl = Decimal.valueOf(quote.PrimaryCreditLimit__c);
            }catch(TypeException e){
                errorCount++;
                appendWarningMessage( 'Total Credit Limit is a number.');
            }
           
        }
        
        errorCount += validateRequiredField(quote.PrimaryAddress1__c, 'Billing Address Line 1 is a required field.');
        errorCount += validateRequiredField(quote.PrimaryCity__c, 'City is a required field.');
        errorCount += validateRequiredField(quote.PrimaryState__c, 'State is a required field.');
        errorCount += validateRequiredField(quote.PrimaryZip__c, 'ZIP is a required field.');
        
        if(quote.zqu__ValidUntil__c==null){
            errorCount++;
            appendWarningMessage( 'Valid Until is a required field.');            
        }
        if(quote.zqu__ValidUntil__c<System.today()){
            errorCount++;
            appendWarningMessage( 'The Valid Until date cannot be in the past.');
        }

        errorCount += validateRequiredField(quote.PrimaryContact__c, 'Contact is a required field.');
        errorCount += validateRequiredField(quote.PrimaryPhone__c, 'Contact Phone is a required field.');
        errorCount += validateRequiredField(quote.PrimaryEmail__c, 'Contact Email is a required field.');
        errorCount += validateRequiredField(quote.FirstTimeOrder__c, 'First Time Order is a required field.');
        errorCount += validateRequiredField(quote.Vendor_Account__c, System.Label.Z_TelematicsVendorRequired);
        
        
        if(quote.PrimaryEmail__c != null && quote.PrimaryEmail__c !=''){
            Matcher regexMatcher = emailPattern.matcher(quote.PrimaryEmail__c);
            if(!regexMatcher.find()){
                System.debug('email is not valid');
                errorCount ++;
                appendWarningMessage('Primary Contact Email is not valid');
            }
        }
        
        if(shipments == null ||shipments.size() == 0){
            errorCount++;
            appendWarningMessage(System.Label.Z_ShippingLocationRequired);
        }

        errorCount += validateRequiredField(quote.zqu__Tax_Exempt__c, 'Tax Exempt for Telematics is a required field.');
        errorCount += validateRequiredField(quote.SalesRep1__c, 'Sales Rep 1 is a required field.');

        
        if (useSecondaryAccount) {
            //errorCount += validateRequiredField(quote.SecondaryAccountNumber__c, 'Secondary Account Number is a required field.');
            errorCount += validateRequiredField(quote.SecondarySponsor__c, 'Secondary Account Number is a required field.');
            
            errorCount += validateRequiredField(quote.SecondaryAccountName__c, 'Secondary Account Name is a required field.');
            errorCount += validateRequiredField(quote.SecondarySource__c, 'Secondary Source is a required field.');

            if(quote.SecondaryCreditLimit__c == null){
               errorCount++;
               appendWarningMessage( 'Secondary Total Credit Limit is a required field.');
            }

            errorCount += validateRequiredField(quote.SecondaryAddress1__c, 'Secondary Address Line 1 is a required field.');
            errorCount += validateRequiredField(quote.SecondaryState__c, 'Secondary State is a required field.');
            errorCount += validateRequiredField(quote.SecondaryCity__c, 'Secondary City is a required field.');
            errorCount += validateRequiredField(quote.SecondaryZip__c, 'Secondary Zip Code is a required field.');

            errorCount += validateRequiredField(quote.SecondaryContact__c, 'Secondary Contact is a required field.');
            errorCount += validateRequiredField(quote.SecondaryPhone__c, 'Secondary Contact Phone is a required field.');
            errorCount += validateRequiredField(quote.SecondaryEmail__c, 'Secondary Contact Email is a required field.');
            
            if(quote.SecondaryEmail__c != null && quote.SecondaryEmail__c !=''){
                Matcher regexMatcher = emailPattern.matcher(quote.SecondaryEmail__c);
                if(!regexMatcher.find()){
                    errorCount ++;
                    appendWarningMessage('Secondary Contact Email is not valid');
                }
            }
            
            
        }
        
        if(!chosenVendorCheck.equals(quote.Vendor_Account__c) && existingCharges ){
            errorCount++;
            appendWarningMessage( 'Existing Line Items on Quote Page 2 must be deleted before changing Vendor.');
        }
        
        System.debug('Error Count ' + errorCount);
        if(errorCount > 0){
            notificationOptions.continueLabel = null;
            notificationOptions.continueAction = null;
            notificationOptions.backAction = 'stayOnCurrentPage();';
            notificationOptions.backLabel = 'Ok';

        } else if(isEditingLocation==true){
            notificationOptions.continueAction = 'continueToNewPage();';
            notificationOptions.backAction = 'stayOnCurrentPage();';
            notificationOptions.backLabel = 'Cancel';
            
            //Add a page message prompting the user for input
            appendWarningMessage( 'An unfinished line item has not been saved.  Are you sure you want to navigate away from the page?');
        }

        return errorCount;
    }
    
    //Method require confirmation from User to delete shipment
    public void confirmShippingDeletion(){
        notificationOptions.continueAction = 'continueToDeleteShipping();';
        notificationOptions.backAction = 'stayOnCurrentPage();';
        notificationOptions.backLabel = 'Cancel';
        //Add a page message prompting the user for input
        appendWarningMessage( 'Are you sure you want to delete this line?');
    }
    
    //Sets shipment creation field to the specified shipments values
    public void editShippingLocation(){
        
        isEditingLocation = true;
        Shipment__c currentShipment = shipments.get(shipmentIndex);
        
        shipAddress1=currentShipment.Address_Line_1__c;
        shipAddress2=currentShipment.Address_Line_2__c;                        
        shipContactName=currentShipment.Shipping_Contact__c;                     
        shipContactPhone=currentShipment.Shipping_Contact_Phone__c;                   
        shipContactEmail=currentShipment.Shipping_Contact_Email__c;                 
        shipCity=currentShipment.City__c;                              
        shipState=currentShipment.State__c;                      
        shipZipCode=currentShipment.Zip__c;
    }
    
    //Checks if the Valid Until Date is valid
    public void validUntilNotification(){
        notificationOptions.continueAction = null;
        notificationOptions.backAction = 'stayOnCurrentPage();';
        notificationOptions.backLabel = 'OK';
        
        //Add a page message prompting the user for input
        appendWarningMessage( 'The Valid Until date cannot be in the past. ');
    }
    
    //Method require confirmation from the user
    //Called by Cancel button at the bottom of the page
    public void cancelConfirm(){
        
        notificationOptions.continueAction = 'continueToCancelPage();';
        notificationOptions.backAction = 'stayOnCurrentPage();';
        notificationOptions.backLabel = 'Cancel';
        
        //Add a page message prompting the user for input
        appendWarningMessage( 'Are you sure you want to cancel this quote?  (This will delete the current quote)');
    }
    
    //Deletes Quote and closes Quoting flow window
    public PageReference cancelQuote(){
        if(quoteId!=null && quoteId!=''){
            zqu__Quote__c quoteTodelete = new zqu__Quote__c();
            //ID id= new ID();
            quoteTodelete.Id=quoteId;
            /*if(!shipments.isEmpty()){
                delete shipments;
            }*/
            delete quoteTodelete;
        }
        return new PageReference('javascript:window.close()');
    }
    
    //Removes shimpent from list and deletes from the database
    public void deleteShippingLocation(){
        if(shipments!=null && !shipments.isEmpty()){
            if(shipments.get(shipmentIndex).Id!=null){
                Shipment__c toDelete = shipments.get(shipmentIndex);
                delete toDelete;
            }
            shipments.remove(shipmentIndex);
        }
        clearOutNotifications();
    }

    public void clearOutNotifications(){
        notificationOptions.backLabel = 'OK';
        notificationOptions.continueAction = null;
        notificationOptions.backAction = 'stayOnCurrentPage();';
        ApexPages.getMessages().clear();
    }
    
    //Test helper method
    public void throwDebugs() {
        // Enter things to get dumped into debug logs here...
        System.Debug('Throwing debugs ...');

        System.Debug('Quote AcctNum: ' + quote.PrimaryAccountNumber__c);
        System.Debug('Secondary Contact: ' + quote.SecondaryContact__c);
        System.Debug('Secondary Email: ' + quote.SecondaryEmail__c);
    }
    
    //Inner class implements Comparable 
    //defines compareTo method
    public class SchemaPLEComparable implements Comparable {

        public Schema.PicklistEntry ple;

        public SchemaPLEComparable(Schema.PicklistEntry ple) {
            this.ple = ple;
        }
         
        // Compare opportunities based on the opportunity amount.
        public Integer compareTo(Object compareTo) {
            // Cast argument to OpportunityWrapper
            SchemaPLEComparable compareToPLE = (SchemaPLEComparable)compareTo;
             
            // The return value of 0 indicates that both elements are equal.
            Integer returnValue = 0;
            if (this.ple.getLabel().toUpperCase() > compareToPLE.ple.getLabel().toUpperCase()) {
                // Set return value to a positive value.
                returnValue = 1;
            } else if (this.ple.getLabel().toUpperCase() < compareToPLE.ple.getLabel().toUpperCase()) {
                // Set return value to a negative value.
                returnValue = -1;
            }
             
            return returnValue;      
        }

    }
    
}