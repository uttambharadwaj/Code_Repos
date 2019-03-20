public class ShippingAddressSearchController {
    public Opportunity opp  {get;set;}
    private final String CRMId;
    private final Map <String,List<SelectOption>> cachedSubOptions = new Map <String,List<SelectOption>>();
    public Account acc {get;set;}
    public Boolean initFailed                          {get; private set;}
    public String  selectedAccountType                 {get;set;}
    public String  selectedAccount                     {get;set;}
    public String  selectedSubscription                {get;set;}
    public String  selectedSubscriptionType            {get;set;}
    public String  selectedAmendmentType               {get;set;}
    public List<SelectOption> billingAccountList       {get;set;}
    public List<SelectOption> subscriptionList         {get;set;}
    public Boolean  inputValue                 		   {get;set;}
    public zqu__Quote__c quote 						   {get;set;}
    public Contact contact 							   {get;set;}
    public List<Shipment__c> accountName				{get;set;}
    public List<selectOption> accountNumber				{get;set;}
    public List<selectOption> source					{get;set;}
    public List<selectOption> sponsor					{get;set;}
    public List<Shipment__c> shipment					{get;set;}
    public Boolean accountNameBol						{get;set;}
    public String chosenSearchCriteria					{get;set;}
    public String searchText							{get;set;}
    public String L1AccountNumber						{get;set;}
    public Account sfdcAccount							{get;set;}
    public List<AccountsearchPart2.AccountSearchResponseRecordType> accountsList {get;set;}
    public List<AccountsearchPart2.ShippingAddressSearchResponseRecordType> shippingAccountsList {get;set;}
    private AccountsearchPart1.AccountSearchSOAP accountSearchService;
    private AccountsearchPart1.ShippingAccountSearchSOAP shippingAccountSearchService;
    public Boolean listEmpty 							{get;set;}
    
     public ShippingAddressSearchController(ApexPages.StandardController controller) {
	 	final String oppId = controller.getId();
        this.initFailed = false;
        listEmpty = false;
        this.shipment = new List<Shipment__c>();
        this.L1AccountNumber = ApexPages.currentPage().getParameters().get('accountNumber');
        this.searchText = ApexPages.currentPage().getParameters().get('searchText');
         
        sfdcAccount = [
            SELECT
            	Name,
           		AccountNumber,
            	Status__c
            FROM
            	Account
            WHERE
                Wex_Account__c = :L1AccountNumber
            OR
                F1_Account_Number__c = :L1AccountNumber
            LIMIT 1
        ];
         
        Wex__c wexSetting = [Select Account_Search_Endpoint__c, Shipping_Account_Search_Endpoint__c, API_Timeout_ms__c from Wex__c limit 1];
        accountSearchService = new AccountsearchPart1.AccountSearchSOAP();
        accountSearchService.endpoint_x = wexSetting.Account_Search_Endpoint__c;
        accountSearchService.timeout_x = wexSetting.API_Timeout_ms__c.intValue();
        shippingAccountSearchService = new AccountsearchPart1.ShippingAccountSearchSOAP();
        shippingAccountSearchService.endpoint_x = wexSetting.Shipping_Account_Search_Endpoint__c;
        shippingAccountSearchService.timeout_x = wexSetting.API_Timeout_ms__c.intValue();
        
        accountsList = new List<AccountsearchPart2.AccountSearchResponseRecordType>();
		shippingAccountsList = new List<AccountsearchPart2.ShippingAddressSearchResponseRecordType>();
        chosenSearchCriteria = 'Name';
     }
    
    static private void appendErrorMessage(String message) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
    }
    
    public void searchShippingAccount(){
        AccountsearchPart2.ShippingAccountSearchRequestRecordType accountSearch = new AccountsearchPart2.ShippingAccountSearchRequestRecordType();
        if(chosenSearchCriteria=='Name' && searchText!='' && searchText!=null){
            accountSearch.AccountName = searchText;
        } else if(chosenSearchCriteria=='Number' && searchText!='' && searchText!=null){
            accountSearch.ShippingAccountNumber = searchText;
        } else if(chosenSearchCriteria=='ContactFirst' && searchText!='' && searchText!=null){
            accountSearch.ShippingContactFirstName= searchText;
        } else if(chosenSearchCriteria=='ContactLast' && searchText!='' && searchText!=null){
            accountSearch.ShippingContactLastName= searchText;
        } else if(chosenSearchCriteria=='Sponsor' && searchText!='' && searchText!=null){
            accountSearch.Sponsor = searchText;
        } else if(chosenSearchCriteria=='Email' && searchText!='' && searchText!=null){
            accountSearch.Email = searchText;
        } else if(chosenSearchCriteria=='Phone' && searchText!='' && searchText!=null){
            accountSearch.Phone = searchText;
        }
        
        accountSearch.L1AccountNumber = L1AccountNumber;
        
        try{
            system.debug(accountSearch);
		AccountsearchPart2.ShippingAccountRecords_element searchResults = shippingAccountSearchService.GetShippingAccounts(accountSearch);
		shippingAccountsList = searchResults.ShippingAccount;
        system.debug(shippingAccountsList);
        if (shippingAccountsList == null || shippingAccountsList.size()==0)
            listEmpty = true;
        else
            listEmpty = false;
        }catch (exception e){
            listEmpty = true;
            system.debug(e);
        }
    }   
    
    public void searchAccount(){
        AccountsearchPart2.AccountSearchRequestRecordType accountSearch = new AccountsearchPart2.AccountSearchRequestRecordType();
        //ShippingAccountSearchRequestRecordType
        if(chosenSearchCriteria=='Name' && searchText!='' && searchText!=null){
            accountSearch.AccountName = searchText;
        } else if(chosenSearchCriteria=='Number' && searchText!='' && searchText!=null){
            accountSearch.AccountNumber = searchText;
        } else if(chosenSearchCriteria=='ContactFirst' && searchText!='' && searchText!=null){
            accountSearch.ContactFirstName= searchText;
        } else if(chosenSearchCriteria=='ContactLast' && searchText!='' && searchText!=null){
            accountSearch.ContactLastName= searchText;
        } else if(chosenSearchCriteria=='Sponsor' && searchText!='' && searchText!=null){
            accountSearch.Sponsor = searchText;
        } else if(chosenSearchCriteria=='Email' && searchText!='' && searchText!=null){
            accountSearch.Email = searchText;
        } else if(chosenSearchCriteria=='Phone' && searchText!='' && searchText!=null){
            accountSearch.Phone = searchText;
        }
        
        accountSearch.L1AccountNumber = L1AccountNumber;
        
        try{
        //ShippingAccountsearch GetShippingAccounts
        system.debug(accountSearch);
		AccountsearchPart2.AccountSearchRecords_element searchResults = accountSearchService.GetAccounts(accountSearch);
		accountsList = searchResults.Account;
            System.debug(accountsList);
        
        if (accountsList == null || accountsList.size() == 0)
            listEmpty = true;
        else
            listEmpty = false;
        } catch (exception e){
            listEmpty = true;
            system.debug(e);
        }
    }    
}