@isTest
public class WE_IMProjCmpltnUpTest {

    @testSetup
    static void dataSetup() {
        
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
        u.TimeZoneSidKey    = 'America/Denver';
        u.LocaleSidKey      = 'en_US';
        u.EmailEncodingKey  = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        userList.add(u);
        
        system.debug('u contains ' + u);
        
        insert userList;
        
        System.runas(u){
            
            // create Custom Setting
            VRTN__c[] csList = new VRTN__c[]{};
                VRTN__c cs = New VRTN__c();
            cs.Name = 'Project';
            cs.NAEUProjs__c = 'Project';
            csList.add(cs);
            
            insert csList;
            system.debug('csList contains ' + csList);
            
            List<MPM4_BASE__Milestone1_Project__c> testProjs = new List<MPM4_BASE__Milestone1_Project__c>();
            
            List<RecordType> rtId = new List<RecordType> ([SELECT Id FROM RecordType
                                                        WHERE SObjectType = 'MPM4_BASE__Milestone1_Project__c' AND RecordType.Name = 'Project' 
                                                        LIMIT 1]);
            
            for (Integer i = 0; i < 25; i++) {
                
                MPM4_BASE__Milestone1_Project__c p = new MPM4_BASE__Milestone1_Project__c();
                p.Name = 'Test Project <*>' + i;
                p.RecordTypeId = rtId[0].Id;
                p.OwnerId = u.Id;
                
                p.MPM4_BASE__Kickoff__c = date.newInstance(2015,02,1);
                p.MPM4_BASE__Deadline__c = date.newInstance(2015,08,1);
                
                testProjs.add(p);
            }
            insert testProjs;
            
            List<Opportunity> testOpps = new List<Opportunity>();
            
            for (Integer i = 0; i < 25; i++) {
            
                Opportunity o = new Opportunity();
                o.name = 'Test Opp <*>' + i;
                o.RecordTypeId = '012700000005qif';
                o.OwnerId = u.Id;
                o.Ramp_Profile__c = 'Standard';
                
                o.StageName = '1) Suspect';
                o.CloseDate = date.newInstance(2015,06,15);
                
                //cover Forecast validation rules
                o.Monthly_Txn_Revenue_POS__c = 0;
                //COMMENT OUT BEFORE DEPLOYMENT
                //o.Annual_transaction_volume__c = 1000;
                o.Implementation_Revenue__c = date.newInstance(2015,07,01);
                
                //cover Credit Agreement Details Required validation rule
                o.Credit_Limit__c = 100.00;
                o.Date_Credit_Limit_Approved__c = date.newInstance(1901,01,01);
                o.Payment_Terms_Days__c = 5;
                o.Billing_Cycle__c = 'Daily';
                
                //cover Revenue Values Required validation rule
                o.Annual_Settlement_Value__c = 100.00;
                o.Average_transaction_Value_POS__c = 1.00;
                
                testOpps.add(o);
            }
            insert testOpps;
            
            List<ProjectxOpp__c> testJuncs = new List<ProjectxOpp__c>();
            
            for (Integer i = 0; i < 25; i++) {
                
                ProjectxOpp__c j = new ProjectxOpp__c();
                j.Project__c = testProjs[i].Id;
                j.Opportunity__c = testOpps[i].Id;
                testJuncs.add(j);
            }
            insert testJuncs;
            
        }//runas
    }//testSetup
    
    static testMethod void testProjs(){
    
        //retrieve projects from @testSetup
        List <MPM4_BASE__Milestone1_Project__c> projects = [SELECT Id, Name from MPM4_BASE__Milestone1_Project__c WHERE Name LIKE '%<*>%'];
        
        //reset governor limits
        test.startTest();
        
        List <MPM4_BASE__Milestone1_Project__c> updProjects = new List<MPM4_BASE__Milestone1_Project__c>();
        
        for(MPM4_BASE__Milestone1_Project__c p : projects){
            p.MPM4_BASE__Deadline__c = date.newInstance(2016,06,06);
            updProjects.add(p);
        }
        update updProjects;
        
        //assert results
        List <Opportunity> opportunitys = [SELECT Id, Name, Implementation_Revenue__c from Opportunity WHERE Name LIKE '%<*>%'];
        
        for(Opportunity o : opportunitys){
            system.assertEquals(date.newInstance(2016,06,06), o.Implementation_Revenue__c);
        }
        
        test.stopTest();
    }
}