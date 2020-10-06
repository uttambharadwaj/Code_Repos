@isTest(SeeAllData=true)
public class OpptyQuoteSectionControllerTest {

    @isTest
    static void testOpptyQuoteSectionControllerTest() {
        
        Opportunity oppty = [SELECT Id FROM Opportunity WHERE RecordType.Name = 'Telematics' LIMIT 1];
        
        test.startTest();
        
        PageReference pageRef = Page.OpptyQuoteSection;
                
		Test.setCurrentPage(pageRef);
               
        pageRef.getParameters().put('id', oppty.Id);
        
        OpptyQuoteSectionController oqsc = new OpptyQuoteSectionController();
        
        // Test the gets
        System.assertNotEquals(null, oqsc.hasNoRecords);
        System.assertNotEquals(null, oqsc.recordPosition);
        
        // Test the pagination
        System.assertNotEquals(null, oqsc.previousPage);
        System.assertNotEquals(null, oqsc.nextPage);
        
        System.assertNotEquals(null, oqsc.selectedOpportunity);
        
        System.assertEquals(null, oqsc.selectedQuoteId);
               
        String formattedDate = oqsc.reformatDate(System.now());
        
        System.assertNotEquals(null, formattedDate);
        
        oqsc.paginationNext();
        
        oqsc.paginationPrevious();
        
        oqsc.quotes = null;
        
        System.assertNotEquals(null, oqsc.recordPosition);
        
        test.stopTest();
        
    }
    
}