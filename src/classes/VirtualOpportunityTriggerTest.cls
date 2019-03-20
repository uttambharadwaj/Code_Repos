@IsTest
public class VirtualOpportunityTriggerTest {
    
    public static Id corporatePayRecordType {
        get {
         	if(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('CP Virtual Credit') != null) {
        		return Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('CP Virtual Credit').getRecordTypeId();
        	}
            
            return null;
        }
    }
    
    @isTest 
    public static void testVirtualOpportunityTriggerNoRamp() {
        
        Profile profile = [SELECT id FROM Profile WHERE Name = 'CorporatePay Sales'];
        
        User user = new User(
            FirstName = 'Test',
            LastName = 'Test',
            Email = 'test@wexinc.com',
            Alias = 'testl',
            Username = 'test@wexinc.com',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = profile.id,
            CompanyName = 'Test',
            CurrencyISOCode = 'EUR'
        );
        
        insert user;
        
        System.runAs(user) {
            
            // No Ramp
        	Opportunity opportunity = new Opportunity(name= 'TestOpp',closedate= date.newinstance(2099,1,1),stagename='1) Qualified', ownerId = user.id, sourcesystem__c = 'test', recordTypeId = corporatePayRecordType);

        	insert opportunity;
            
            opportunity.CloseDate = Date.newinstance(2098,1,1);
            
            upsert opportunity;
            
        }
        
    }
    
    @isTest 
    public static void testVirtualOpportunityTriggerImmediateRamp() {
        
        Profile profile = [SELECT id FROM Profile WHERE Name = 'CorporatePay Sales'];
        
        User user = new User(
            FirstName = 'Test',
            LastName = 'Test',
            Email = 'test@wexinc.com',
            Alias = 'testl',
            Username = 'test@wexinc.com',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = profile.id,
            CompanyName = 'Test',
            CurrencyISOCode = 'EUR'
        );
        
        insert user;
        
        System.runAs(user) {
            
            // No Ramp
        	Opportunity opportunity = new Opportunity(Ramp_Profile__c = 'Immediate', name= 'TestOpp',closedate= date.newinstance(2099,1,1),stagename='1) Qualified', ownerId = user.id, sourcesystem__c = 'test', recordTypeId = corporatePayRecordType);

        	insert opportunity;
            
            opportunity.CloseDate = Date.newinstance(2098,1,1);
            
            upsert opportunity;
            
        }
        
    }
    
        @isTest 
    public static void testVirtualOpportunityTriggerStandardRamp() {
        
        Profile profile = [SELECT id FROM Profile WHERE Name = 'CorporatePay Sales'];
        
        User user = new User(
            FirstName = 'Test',
            LastName = 'Test',
            Email = 'test@wexinc.com',
            Alias = 'testl',
            Username = 'test@wexinc.com',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = profile.id,
            CompanyName = 'Test',
            CurrencyISOCode = 'EUR'
        );
        
        insert user;
        
        System.runAs(user) {
            
            // No Ramp
        	Opportunity opportunity = new Opportunity(Ramp_Profile__c = 'Standard', name= 'TestOpp',closedate= date.newinstance(2099,1,1),stagename='1) Qualified', ownerId = user.id, sourcesystem__c = 'test', recordTypeId = corporatePayRecordType);

        	insert opportunity;
            
            opportunity.CloseDate = Date.newinstance(2098,1,1);
            
            upsert opportunity;
            
        }
        
    }
    
    @isTest 
    public static void testVirtualOpportunityTriggerMediumRamp() {
        
        Profile profile = [SELECT id FROM Profile WHERE Name = 'CorporatePay Sales'];
        
        User user = new User(
            FirstName = 'Test',
            LastName = 'Test',
            Email = 'test@wexinc.com',
            Alias = 'testl',
            Username = 'test@wexinc.com',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = profile.id,
            CompanyName = 'Test',
            CurrencyISOCode = 'EUR'
        );
        
        insert user;
        
        System.runAs(user) {
            
            // No Ramp
        	Opportunity opportunity = new Opportunity(Ramp_Profile__c = 'Medium', name= 'TestOpp',closedate= date.newinstance(2099,1,1),stagename='1) Qualified', ownerId = user.id, sourcesystem__c = 'test', recordTypeId = corporatePayRecordType);

        	insert opportunity;
            
            opportunity.CloseDate = Date.newinstance(2098,1,1);
            
            upsert opportunity;
            
        }
        
    }
    
    @isTest 
    public static void testVirtualOpportunityTriggerForecasting() {
        
        Profile profile = [SELECT id FROM Profile WHERE Name = 'CorporatePay Sales'];
        
        User user = new User(
            FirstName = 'Test',
            LastName = 'Test',
            Email = 'test@wexinc.com',
            Alias = 'testl',
            Username = 'test@wexinc.com',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = profile.id,
            CompanyName = 'Test',
            CurrencyISOCode = 'EUR'
        );
        
        insert user;
        
        System.runAs(user) {
            
            // No Ramp
        	Opportunity opportunity = new Opportunity(name= 'TestOpp',closedate= date.newinstance(2099,1,1),stagename='1) Qualified', ownerId = user.id, sourcesystem__c = 'test', recordTypeId = corporatePayRecordType);

        	insert opportunity;
            
            opportunity.Ramp_Profile__c = 'Medium';
            opportunity.Annual_Settlement_Value__c = 1000000.00;
            opportunity.Average_transaction_Value_POS__c = 150.00;
            
            upsert opportunity;
            
        }
        
    }
    
}