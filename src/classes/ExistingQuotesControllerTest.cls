@isTest(SeeAllData=true)
public class ExistingQuotesControllerTest {

    @isTest
    static void testExistingQuotesController() {
        
        TestUtils.enable_isRunningTest = true;
        
        ExistingQuotesController eqc = new ExistingQuotesController();
        
        // Test the gets
        System.assertEquals(false, eqc.hasNoRecords);
        System.assertNotEquals(null, eqc.recordPosition);
        System.assertNotEquals(null, eqc.salesReps);
        System.assertNotEquals(null, eqc.quoteStatuses);
        
        // Test the pagination
        System.assertEquals(true, eqc.previousPage);
        System.assertEquals(false, eqc.nextPage);
        
        eqc.paginationNext();
        
        System.assertEquals(false, eqc.previousPage);
        System.assertEquals(false, eqc.nextPage);
        
        eqc.paginationPrevious();
        
        System.assertEquals(true, eqc.previousPage);
        System.assertEquals(false, eqc.nextPage);
  
        // Run through some quick search/reset functions
        eqc.clearSearch();

		String formattedDate = eqc.reformatDate(System.now());
        
        System.assertNotEquals(null, formattedDate);
        
    }
    
    @isTest
    static void testExistingQuotesControllerOrderSearch() {
        
        TestUtils.enable_isRunningTest = true;
        
        ExistingQuotesController eqc = new ExistingQuotesController();
        
        eqc.orderSearch();

		String formattedDate = eqc.reformatDate(System.now());
        
        System.assertNotEquals(null, formattedDate);
        
    }
    
    @isTest
    static void testExistingQuotesControllerDoSearch() {
        
        TestUtils.enable_isRunningTest = true;
        
        ExistingQuotesController eqc = new ExistingQuotesController();
        
        // Test the search functions
        eqc.searchQuery = 'x0x0x0x0x0x0';
        eqc.doSearch();

		String formattedDate = eqc.reformatDate(System.now());
        
        System.assertNotEquals(null, formattedDate);
        
    }
    
}