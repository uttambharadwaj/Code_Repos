@IsTest
public class TestActivePricingUpdate{
    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testMethod void updateCampaignActive(){
        Campaign testCamp = new Campaign();
        testCamp.Name = 'test 1';
        testCamp.Type = 'Generic';
        testCamp.Status = 'Planned';
        testCamp.Coupon_Code__c = '111';
        testCamp.IsActive = true;
        testCamp.Drop_Date__c = date.today();
        testCamp.EndDate = date.today().addDays(100);
        testCamp.CurrencyIsoCode = 'USD';
       
        insert testCamp;
        
        Campaign_Pricing__c priceObj = new Campaign_Pricing__c();
        priceObj.Name = 'test generic 1';
        priceObj.coup_code__c = '111';
        priceObj.is_Active__c = true;
        priceObj.CurrencyIsoCode = 'USD';
        
        insert priceObj;
        
        Campaign openTest = [SELECT Coupon_Code__c, IsActive FROM Campaign Where Coupon_Code__c = '111'];
        		openTest.IsActive = false;
        
        update openTest;
        
        Campaign_Pricing__c checkP = [SELECT coup_code__c, is_Active__c FROM Campaign_Pricing__c WHERE coup_code__c
                                           = '111'];
        
        
        update checkP;
         
        
        Campaign_Pricing__c checkP2 = [SELECT coup_code__c, is_Active__c FROM Campaign_Pricing__c WHERE coup_code__c
                                           = '111'];
        
        System.assert(checkP2.is_Active__c == false, checkP);
        
        
        
        
        
    }
}