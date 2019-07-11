@isTest
private class WE_AcctSubmitAppEntitlement_Test {
    
    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

        //create custom setting to check Record Type Id against
        static testMethod void testEntitlementCreation() {
            
            WEID__c cs = New WEID__c(
                Name = 'CorporatePay Accounts',
                WEAccId__c = '012700000005oqE');
            insert cs;
            
            // create Account with the Wex Europe record type
            Account acc = new Account(
                Name = 'Test Acc',
                RecordTypeId = '012700000005oqE',
                // satisfy validation rules
                Type = 'Prospect',
                Sales_Group__c = 'Insurance');
            insert acc;
            
            // create Account with non Wex Europe record type
        	Account accFleet = new Account(
                Name = 'Test Acc - Fleet',
                RecordTypeId = '012700000005p5h',
                // satisfy validation rules
                Type = 'Prospect',
                Sales_Group__c = 'Insurance');
            
            system.assertNotEquals(accFleet.RecordTypeId, cs.WEAccId__c);
            
            try{
            insert accFleet;                
            } catch (Exception e){
                System.debug('Could not add an Entitlement to a Fleet Account');
            }
            
        }
}