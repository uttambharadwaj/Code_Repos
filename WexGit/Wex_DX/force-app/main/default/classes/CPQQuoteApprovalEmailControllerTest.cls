@isTest
public class CPQQuoteApprovalEmailControllerTest {

	@testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    public static testmethod void testController() {
		SBQQ__Quote__c q = new SBQQ__Quote__c();
		insert q;
		CPQQuoteApprovalEmailController ctl = new CPQQuoteApprovalEmailController();
		ctl.quoteID = q.Id;
		SBQQ__Quote__c q1 = ctl.getQuote();
		System.assert(q1.Id != null);
	}

}