// revision history https://gist.github.com/aplssf/0d7aa2ec27247e808b1e/revisions
@isTest
public class WE_MasterOpportunityTriggerTest {

    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testMethod void testTrigger() {
        User u = WE_TestDataUtility.createStandardUser();

        System.runas(u) {
            List<Opportunity> opps = WE_TestDataUtility.createOpportunities(
                'EU Opps',            	// oppRef
                10,              		// noOpps
                'CP Virtual Prepaid MC',// recordTypeName
                'id2',              	// identifier
                '1) Suspect',           // stageName
                date.today()+1,         // closeDate
                'Standard',             // rampProfile
                100.00);            	// settlement
            insert opps;

            for(Opportunity o : opps) {
                o.CloseDate = date.today()+2;
            }
            update opps;
        }
    }

}