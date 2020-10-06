@isTest
private class AcctSubmitAppEntitlement_Test {
    

    @testSetup
    static void setup(){
       UtilityTestLoader.setAutomation(false);
    }

        //create custom setting to check Record Type Id against
        static testMethod void testCustSett() {
            
        WEID__c[] csList = new WEID__c[]{};
        WEID__c cs = New WEID__c();
                cs.Name = 'CorporatePay Accounts';
                cs.WEAccId__c = '012700000005oqE';
        csList.add(cs);
                //causes error when missing a character
        WEID__c cs2 = New WEID__c();
                cs2.Name = 'Made Up Id';
                cs2.WEAccId__c = '012700000005p5h';
        csList.add(cs2);
                insert csList;
            
            // create Account with the Wex Europe record type
            Account acc = new Account();
            acc.Name = 'Test Acc';
            acc.RecordTypeId = '012700000005oqE';
            // satisfy validation rules
            acc.Type = 'Prospect';
            acc.Sales_Group__c = 'Insurance';
            
            insert acc;
            
            // create Account with non Wex Europe record type
        	Account accFleet = new Account();
            accFleet.Name = 'Test Acc - Fleet';
            accFleet.RecordTypeId = '012700000005p5h';
            // satisfy validation rules
            accFleet.Type = 'Prospect';
            accFleet.Sales_Group__c = 'Insurance';
            
            system.assertNotEquals(accFleet.RecordTypeId,cs.WEAccId__c);
            
            try{
            insert accFleet;                
            } catch (Exception e){
                System.debug('Could not add an Entitlement to a Fleet Account');
            }
            
        }
}