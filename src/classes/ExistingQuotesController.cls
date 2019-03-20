public class ExistingQuotesController {
    
    // For paginations sake
    private integer totalRecords = 0;
    private integer offsetSize = 0;
    private integer offsetQuerySize;
    private integer recordLimitSize = 25;
    
    public Map<String, String> columnOrdering { get; set; }
    
    public boolean hasNoRecords {get;set;}
    
    public String searchQuery {get;set;}
    
    public String orderSearchBy { get; set; }
    
    public String salesRepFilter { get; set; }
    
    public String orderFilterDirection { get { return columnOrdering.get(orderSearchBy); } }
    
    public List<User> salesRepList { get; set; }
    
    public List<SelectOption> salesReps { 
        get {
            List<SelectOption> salesreps = new List<SelectOption>();
            
            salesReps.add(new SelectOption('#', 'All Reps'));
            
            if(!salesRepList.isEmpty()) {
	            for(User salesRep : salesRepList) {
	            	salesReps.add(new SelectOption(salesRep.Id, salesRep.Name));
            	}
            }
            
            return salesreps;
        }
    }
    
    public String statusFilter { get; set; }
    
    public List<SelectOption> quoteStatuses { 
        get {
            List<SelectOption> quoteStatuses = new List<SelectOption>();
            
            quoteStatuses.add(new SelectOption('#', 'All'));
            quoteStatuses.add(new SelectOption('New', 'New'));
            quoteStatuses.add(new SelectOption('Out For Signature', 'Out For Signature'));
            quoteStatuses.add(new SelectOption('Customer Approved', 'Customer Approved'));
            quoteStatuses.add(new SelectOption('Issued Order', 'Issued Order'));
            quoteStatuses.add(new SelectOption('Cancelled', 'Cancelled'));
            
            return quoteStatuses;
        }
    }
    
    public String recordPosition { 
        get {
            if(quotes != null) {
            	return 'Displaying Records ' + (offsetSize + 1) + ' - ' + (offsetSize + offsetQuerySize) + ' of ' + totalRecords;
            }
            else {
                return 'Displaying Records 0 - 0 of 0';
            }
        }
    }
    
    public boolean previousPage {
        get {
            if(offsetSize == 0) {
                return true;
			} else { 
                return false; 
            }
        }
    }
    
    public boolean nextPage {
        get {
            System.debug('Offset ' + offsetSize + ' LimitSize ' + recordLimitSize + ' Total' + totalRecords);
            if((offsetSize + recordLimitSize) < totalRecords) {
                return false;
			} else { 
                return true; 
            }
        }
    }
       
    public List<zqu__Quote__c> quotes {get;set;}
    
    public String selectedQuoteId {get;set;}
    
	public ExistingQuotesController() {
        
        salesRepFilter = '#';
        statusFilter = '#';
        searchQuery = '';
        orderSearchBy = 'QuoteNumber__c';
        
        salesRepList = [Select Id, Name From User Where userrole.name = 'Telematics Sales Manager' OR userrole.name = 'Telematics Data Administrator' OR userrole.name = 'Telamatics Inside Sales' Order By Name ASC Limit 999];
        
        columnOrdering = new Map<String, String>();
        columnOrdering.put('QuoteNumber__c', 'DESC');
        columnOrdering.put('PrimaryAccountName__c', '#');
        columnOrdering.put('zqu__Opportunity__r.Name', '#');
        columnOrdering.put('CreatedBy.Name', '#');
        columnOrdering.put('DatePrepared__c', '#');
        columnOrdering.put('zqu__Status__c', '#');
        
        // Initially load all the quotes
        getQuotes();

    }

    // Gets quotes, and filters based on the search query
    public void getQuotes() {
        
        searchQuery = searchQuery.trim();
        
        String whereClause = '';
         
        String whereQuery = '%' + searchQuery + '%';
            
        whereClause = 'WHERE (QuoteNumber__c like :whereQuery or PrimaryAccountName__c like :whereQuery or zqu__Opportunity__r.Name like :whereQuery)';
        
        if(salesRepFilter != '#') {
            whereClause = whereClause + ' and CreatedBy.Id = :salesRepFilter';
        }
        
        if(statusFilter != '#') {
            whereClause = whereClause + ' and zqu__Status__c = :statusFilter';
        }
        
        System.debug(whereClause);
        
        String columnSortOption = columnOrdering.get(orderSearchBy);
        
        String orderBy = ' ORDER BY ' + orderSearchBy + ' ' + columnSortOption;
        
        // Get the quotes
        String databaseQuery = 'SELECT Id, Name, PrimaryAccountName__c, DatePrepared__c, CreatedBy.Name, QuoteNumber__c, zqu__Status__c, zqu__Opportunity__r.Id, zqu__Opportunity__r.Owner.Name, zqu__Opportunity__r.Name FROM zqu__Quote__c ' + whereClause +  orderBy + ' LIMIT :recordLimitSize OFFSET :offsetSize';
        quotes = Database.query(databaseQuery);
        if(quotes.size() == 0) {
    		quotes = null;
            totalRecords = 0;
            hasNoRecords = true;
        }
        else {
            hasNoRecords = false;
            
			offsetQuerySize = quotes.size();
        
        	// Get the total number of quotes - cannot depend on above because it uses the offset
        	// for pagination
        	String totalQuotesQuery = 'SELECT Id FROM zqu__Quote__c ' + whereClause;
            
            if(TestUtils.isRunningTest()) {
                totalQuotesQuery = 'SELECT Id FROM zqu__Quote__c LIMIT 100';
            }
        	List<zqu__Quote__c> totalQuotes = Database.query(totalQuotesQuery);
        	totalRecords = totalQuotes.size();
            
            System.debug('### Total Records: ' + totalRecords);
        }
        
        System.debug(hasNoRecords);
        
    }
    
    public void orderSearch() {
        
        // Traverse the Map
        // If field matches, then if #, set to ASC, if ASC, set to DESC
        // If field doesn't match, then set to #
        System.debug(orderSearchBy);
        
        for(String key : columnOrdering.keyset()) {
            String state = columnOrdering.get(key);
            
            if(orderSearchBy == key) {
                if(state.equalsIgnoreCase('ASC')) {
                    state = 'DESC';
                }
                else if(state.equalsIgnoreCase('DESC') || state.equalsIgnoreCase('#')) {
                    state = 'ASC';
                } 
                
                columnOrdering.put(key, state);
            }
            else {
                columnOrdering.put(key, '#');
            }
        }
        
        System.debug(columnOrdering);
        
        getQuotes();
        
    }
    
    // Sets the pagination offsets back to 0, then gets the quotes for the search
    public void doSearch() {
        totalRecords = 0;
        offsetSize = 0;
        
        getQuotes();
    }
    
    // Sets the pagination offsets back to 0, then gets all the quotes
    public void clearSearch() {
        
        totalRecords = 0;
        offsetSize = 0;
        
        salesRepFilter = '#';
        statusFilter = '#';
        searchQuery = '';
        orderSearchBy = 'QuoteNumber__c';
        
        for(String key : columnOrdering.keySet()) {
            if(key == 'QuoteNumber__c') { columnOrdering.put(key, 'DESC'); }
            else { columnOrdering.put(key, '#'); }
        }
        
        getQuotes();
        
    }
    
    // Goes to the previous set of records  
    public void paginationPrevious() {
        offsetSize = offsetSize - recordLimitSize;
        getQuotes();
    }
    
    // Goes to the next set of records
    public void paginationNext() {
        offsetSize = offsetSize + recordLimitSize;
        getQuotes();
    }
    
    public void paginationFirst() {
        offsetSize = 0;
        getQuotes();
    }
    
    // Reformats the date per the users time zone
    public String reformatDate(DateTime inputDateTime) {
        
        String reformattedDate = inputDateTime.format('MM/dd/yyyy HH:mm:ss z', UserInfo.getTimeZone().toString());
        
        return reformattedDate;
        
    }
    
    // Delete that quote!
    public void deleteQuote() {
        
        if(selectedQuoteId == null) {
            return;
        }
        
        zqu__Quote__c quoteToDelete = [SELECT Id FROM zqu__Quote__c WHERE Id = :selectedQuoteId];
        
        delete quoteToDelete;
        
        getQuotes();
        
    }
    
}