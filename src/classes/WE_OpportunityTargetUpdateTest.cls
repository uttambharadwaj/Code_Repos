@isTest
public class WE_OpportunityTargetUpdateTest {
/* test should be removed from Production

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
        u.TimeZoneSidKey   = 'America/Denver';
        u.LocaleSidKey      = 'en_US';
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
        s.TimeZoneSidKey   = 'America/Denver';
        s.LocaleSidKey      = 'en_US';
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
            
            //create Target records
            Target__c[] targetList = new Target__c[]{};
                Target__c t = new Target__c();
            
            t.Name = 'Jun Test';
            t.OwnerId = u.Id;
            t.Salesperson__c = u.Id;
            t.Team__c = 'Virtual Sales EU';
            t.Year_End_Date__c = Date.newInstance(2015,12,31);
            t.Target__c = 100000;
            t.Month_End_Date__c = Date.newInstance(2015,06,30);
            targetList.add(t);
            
            Target__c t1 = new Target__c();
            t1.Name = 'Jul Test';
            t1.OwnerId = u.Id;
            t1.Salesperson__c = u.Id;
            t1.Team__c = 'Virtual Sales EU';
            t1.Year_End_Date__c = Date.newInstance(2015,12,31);
            t1.Target__c = 100000;
            t1.Month_End_Date__c = Date.newInstance(2015,07,30);
            targetList.add(t1);
            
            Target__c t2 = new Target__c();
            t2.Name = 'Jul Test';
            t2.OwnerId = s.Id;
            t2.Salesperson__c = s.Id;
            t2.Team__c = 'Virtual Sales EU';
            t2.Year_End_Date__c = Date.newInstance(2015,12,31);
            t2.Target__c = 100000;
            t2.Month_End_Date__c = Date.newInstance(2015,07,30);
            targetList.add(t2);
            
            insert targetList;  
            system.debug('targetList contains ' + targetList);
            
            //create Opportunitys to update, in bulk
            List<Opportunity> opportunitys = new List<Opportunity>();
            
            for (Integer i = 0; i < 50; i++) {
                
                Opportunity o = new Opportunity();
                o.name = 'Test Opp' + i;
                o.RecordTypeId = '012700000005qif';
                o.OwnerId = u.Id;
                
                o.StageName = '1) Suspect';
                o.CloseDate = date.newInstance(2015,06,15);
                
                //cover Credit Agreement Details Required validation rule
                o.Credit_Limit__c = 100.00;
                o.Date_Credit_Limit_Approved__c = date.newInstance(1901, 01, 01);
                o.Payment_Terms_Days__c = 5;
                o.Billing_Cycle__c = 'Daily';
                
                //cover Revenue Values Required validation rule
                o.Annual_Settlement_Value__c = 100.00;
                o.Average_transaction_Value_POS__c = 1.00;
                
                //cover MRFv2 requirements
                o.Implementation_Revenue__c = date.newInstance(1901, 01, 01);
                o.FSR_End_Date__c = date.newInstance(1902, 01, 01);
                o.Average_transaction_Value_POS__c = 50;
                o.Implementation_Revenue_as_a_of_FSR__c = 40;
                
                opportunitys.add(o);
                //system.AssertEquals(opp.FSR_Estimate_on_Contract_Signature__c,10.00);
            }
            insert opportunitys;
            system.debug('opportunitys contains ' + opportunitys);
            
            for(Opportunity upOppsDate : opportunitys){
                upOppsDate.CloseDate = date.newInstance(2015,07,15);
            }
            update opportunitys;
            
            for(Opportunity upOppsOwner : opportunitys){
                upOppsOwner.OwnerId = s.Id;
            }
            update opportunitys;
            
            for(Opportunity noTargetOpp : opportunitys){
                noTargetOpp.CloseDate = date.newInstance(2017,01,01);
            }
            try {
                update opportunitys;
            } catch (Exception e) {
                String message = e.getMessage();
                System.assert(message.contains(' Please ask your Salesforce Administrator to add a target record, for the month & year of your Opportunity\'s close date'), 'message = ' + message);
                return;
            }
            
            for(Opportunity noTargetnewOwnerOpp : opportunitys){
                noTargetnewOwnerOpp.OwnerId = u.Id;
                noTargetnewOwnerOpp.CloseDate = date.newInstance(2017,01,01);
            }
            try {
                update opportunitys;
            } catch (Exception e) {
                String message = e.getMessage();
                System.assert(message.contains(' Please ask your Salesforce Administrator to add a target record, for the month & year of your Opportunity\'s close date'), 'message = ' + message);
                return;
            }
        }//run as
    }
*/
}