@isTest
public class NewOpportunityTargetTest {
    
    static testMethod void testNewTarget(){
        
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
        
        System.runas(u){
            
            // create Custom Setting
            WEID__c[] csList = new WEID__c[]{};
                WEID__c cs = New WEID__c();
            cs.Name = 'CP Virtual Prepaid MC';
            cs.WEOppId__c = '012700000005qif';
            
            csList.add(cs);
            
            insert csList;
            system.debug('csList contains ' + csList);
            
            Target__c t = new Target__c();
            
            t.Name = 'Jan Test';
            t.OwnerId = u.Id;
            t.Salesperson__c = u.Id;
            t.Team__c = 'Virtual Sales EU';
            t.Year_End_Date__c = Date.newInstance(2015,12,31);
            t.Target__c = 100000;
            t.Month_End_Date__c = Date.newInstance(2015,06,30);
            
            insert t;
            
            // insert new Opportunity
            
            //test opportunitys which satisfy all criteria, in bulk
            
            List<Opportunity> opportunitys = new List<Opportunity>();
            for (Integer i = 0; i < 10; i++) {
                
                Opportunity o = new Opportunity();
                o.name = 'Test Opp' + i;
                o.RecordTypeId = '012700000005qif';
                o.OwnerId = u.Id;
                
                o.StageName = '1) Qualified';
                o.CloseDate = date.newInstance(2015,06,15);
                
                //cover Credit Agreement Details Required validation rule
                o.Credit_Limit__c = 100.00;
                o.Date_Credit_Limit_Approved__c = date.newInstance(1901, 01, 01);
                o.Payment_Terms_Days__c = 5;
                o.Billing_Cycle__c = 'Daily';
                
                //cover Revenue Values Required validation rule
                o.Annual_Settlement_Value__c = 100.00;
                o.Average_transaction_Value_POS__c = 1.00;
                
                opportunitys.add(o);
                //system.AssertEquals(opp.FSR_Estimate_on_Contract_Signature__c,10.00);
            }
            insert opportunitys;
            system.debug('opportunitys contains ' + opportunitys);
                       
        }//run as
    }
}