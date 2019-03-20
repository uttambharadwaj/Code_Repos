public class OpptyQuoteSectionController {
    
    // For paginations sake
    private integer totalRecords = 0;
    private integer offsetSize = 0;
    private integer offsetQuerySize;
    private integer recordLimitSize = 5;
    
    public boolean hasNoRecords {get;set;}
    
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
    
    public String selectedOpportunity {
        get {
            return ApexPages.currentPage().getParameters().get('id');
        }
    }
    
    public OpptyQuoteSectionController(){

        // Initially load all the quotes
        getQuotes();
               
    }
    
    public OpptyQuoteSectionController(ApexPages.StandardController ctrl){

        // Initially load all the quotes
        getQuotes();
               
    }

    // Gets quotes, and filters based on the search query
    public void getQuotes() {
        
        String currentOppty = ApexPages.currentPage().getParameters().get('id');
        
        String whereClause = 'WHERE zqu__Opportunity__c = :currentOppty';
        
        // Get the quotes
        String databaseQuery = 'SELECT Id, Name, PrimaryAccountName__c, CreatedBy.Name, CreatedDate, LastModifiedBy.Name, LastModifiedDate, QuoteNumber__c, zqu__Status__c, zqu__Opportunity__r.Id, zqu__Opportunity__r.Name FROM zqu__Quote__c ' + whereClause + ' ORDER BY QuoteNumber__c DESC LIMIT :recordLimitSize OFFSET :offsetSize';
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
        	List<zqu__Quote__c> totalQuotes = Database.query(totalQuotesQuery);
        	totalRecords = totalQuotes.size();
        }
        
        System.debug(hasNoRecords);
        
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