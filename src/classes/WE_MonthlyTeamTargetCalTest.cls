@isTest
public class WE_MonthlyTeamTargetCalTest {
    
    static testMethod void testUpdateTargetAmount(){
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator - Wex Europe'];
        
        // create User
        User[] userList = new User[]{};
            User u = new User();
        
        u.FirstName = 'Alex';
        u.LastName = 'Sherwood';
        u.Email = 'test@wexeurope.com';
        u.Username = 'astest@wexeurope.com';
        u.Alias = 'astest';
        u.ProfileId = p1.Id;
        u.TimeZoneSidKey 	= 'America/Denver';
        u.LocaleSidKey    	= 'en_US';
        u.EmailEncodingKey  = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        userList.add(u);
        
        system.debug('u contains ' + u);
        
        // create Salesperson
        User s = new User();
        
        s.FirstName = 'Test';
        s.LastName = 'User';
        s.Email = 'test1@wexeurope.com';
        s.Username = 'utest@wexeurope.com';
        s.Alias = 'utest';
        s.ProfileId = p1.Id;
        s.TimeZoneSidKey 	= 'America/Denver';
        s.LocaleSidKey    	= 'en_US';
        s.EmailEncodingKey  = 'UTF-8';
        s.LanguageLocaleKey = 'en_US';
        
        userList.add(s);
        system.debug('u contains ' + u);
        
        insert userList;
        
        //create Target records, in bulk
        List<Target__c> gbpTargetList = new List<Target__c>();
        
        for (Integer i = 0; i < 200; i++) {
            
            Target__c t = new Target__c();
            
            t.Name = 'Jun Test' + i;
            t.OwnerId = u.Id;
            t.Salesperson__c = u.Id;
            t.Team__c = 'Virtual Sales EU';
            t.Year_End_Date__c = Date.newInstance(2015,12,31);
            t.Target__c = 100000;
            t.Month_End_Date__c = Date.newInstance(2015,06,30);
            gbpTargetList.add(t);
        }
        insert gbpTargetList;
        
        for(Target__c tUpdate : gbpTargetList){
            //update targets
            tUpdate.target__c = 100001;
        }
        update gbpTargetList;
        
        //test with record set to corporate currency
        List<Target__c> usdTargetList = new List<Target__c>();
        
        for (Integer i = 0; i < 200; i++) {
            
            Target__c t = new Target__c();
            
            t.Name = 'Jun Test' + i;
            t.CurrencyIsoCode = 'USD';
            t.OwnerId = u.Id;
            t.Salesperson__c = u.Id;
            t.Team__c = 'Virtual Sales EU';
            t.Year_End_Date__c = Date.newInstance(2015,12,31);
            t.Target__c = 100000;
            t.Month_End_Date__c = Date.newInstance(2015,06,30);
            usdTargetList.add(t);
        }
        insert usdTargetList;
        
        for(Target__c tUpdate : usdTargetList){
            //update targets
            tUpdate.target__c = 100001;
        }
        update usdTargetList;
    }
}