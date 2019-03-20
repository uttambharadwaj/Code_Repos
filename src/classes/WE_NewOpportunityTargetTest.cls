// revision history https://gist.github.com/aplssf/49389ca1ec04e0abb8c3/revisions
@isTest
public class WE_NewOpportunityTargetTest {
/* test should be removed from Production
    
    @testSetup
    static void dataSetup(){
        
        User u = WE_TestDataUtility.createStandardUser();
        
        // create Salesperson
        User s = new User();
        
        s.FirstName = 'Test';
        s.LastName = 'User';
        s.Email = 'test1@wexeurope.com';
        s.Username = 'utest@wexeurope.com';
        s.Alias = 'utest';
        s.ProfileId = u.ProfileId;
        s.TimeZoneSidKey    = 'America/Denver';
        s.LocaleSidKey      = 'en_US';
        s.EmailEncodingKey  = 'UTF-8';
        s.LanguageLocaleKey = 'en_US';
        
        insert s;
        
        System.runas(u){
            
            VRTN__c rtCS = WE_TestDataUtility.createRecTypeNameCustSett(
                'CP Virtual Prepaid MC', // rtName
                'EU Opps');              // csField
            
            insert rtCS;
            
            //create Targets
            List<Target__c> targets = WE_TestDataUtility.createTargets(
                1,                  // noMonths
                u.Id,               // salespersonId
                2015,               // firstYear
                6,                  // firstMonth
                'Virtual Sales EU', // team
                'Close Date',       // dateType
                100000);            //target
            
            insert targets;
            
        }
    }
    
    static testMethod void testNewTarget(){
        
        test.startTest();
        
        //create Opportunitys to update, in bulk
        List<Opportunity> opportunities = WE_TestDataUtility.createOpportunities(
            25,                         // noOpps
            'CP Virtual Prepaid MC',        // recordTypeName
            'id1',                          // identifier
            '1) Suspect',                   // stageName
            date.newInstance(2015,06,15),   // closeDate
            'Standard',                     // rampProfile
            100.00);                        // settlement
        
        insert opportunities;
        
        test.stopTest();
        
        List<TargetxOpp__c > juncRecs = [SELECT Id FROM TargetxOpp__c 
                                          WHERE Opportunity__c IN :opportunities];
                
        // 25 is noOpps
        system.assertEquals(25, juncRecs.size(), 'there should be 1 target record for each Opportunity');
    }
*/
}