@isTest
public class WE_ProjectLifecycleTest {
    
    static testMethod void testNewProjectMonths(){
        
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
        system.debug('*****getDMLRows***'+Limits.getDMLRows());
        system.debug('*****totalgetDMLRows***'+Limits.getLimitDMLRows());
        System.runas(u){
            
            // create Custom Setting
            VRTN__c[] csList = new VRTN__c[]{};
                VRTN__c cs = New VRTN__c();
            cs.Name = 'Project';
            cs.NAEUProjs__c = 'Project';
            csList.add(cs);
            
            insert csList;
            system.debug('csList contains ' + csList);
        
    }
        List<MPM4_BASE__Milestone1_Project__c> projects1 = new List<MPM4_BASE__Milestone1_Project__c>();
        List<MPM4_BASE__Milestone1_Project__c> projects2 = new List<MPM4_BASE__Milestone1_Project__c>();
        List<MPM4_BASE__Milestone1_Project__c> projectsNewDates = new List<MPM4_BASE__Milestone1_Project__c>();
        List<MPM4_BASE__Milestone1_Project__c> projectsNullDates = new List<MPM4_BASE__Milestone1_Project__c>();
        List<Id> projectNewDate = new List<Id>();
        
        List<RecordType> rtId = new List<RecordType> ([SELECT Id FROM RecordType
                                                        WHERE SObjectType = 'MPM4_BASE__Milestone1_Project__c' AND RecordType.Name = 'Project' 
                                                        LIMIT 1]);
        
        for (Integer i = 0; i < 100; i++) {
            
            MPM4_BASE__Milestone1_Project__c p = new MPM4_BASE__Milestone1_Project__c();
            p.Name = 'Test Project new dates ' + i;
            p.RecordTypeId = rtId[0].Id;
            p.OwnerId = u.Id;
            
            p.MPM4_BASE__Kickoff__c = date.today().addMonths(1);
            p.MPM4_BASE__Deadline__c = date.today().addMonths(4);
            
            projects1.add(p);
        }
        insert projects1;
        
        for (Integer i = 0; i < 100; i++) {
            
            MPM4_BASE__Milestone1_Project__c p = new MPM4_BASE__Milestone1_Project__c();
            p.Name = 'Test Project null dates ' + i;
            p.RecordTypeId = rtId[0].Id;
            p.OwnerId = u.Id;
            
            p.MPM4_BASE__Kickoff__c = date.today().addMonths(1);
            p.MPM4_BASE__Deadline__c = date.today().addMonths(4);
            
            projects2.add(p);
        }
        insert projects2;
        
        test.startTest();
        
        for(MPM4_BASE__Milestone1_Project__c p : projects1){
            p.MPM4_BASE__Deadline__c = date.today().addMonths(5);
            projectsNewDates.add(p);
        }
        update projectsNewDates;
        
        //retrieve single Project from list to use in assert checks
        projectNewDate.add(projectsNewDates[0].Id);
        system.debug('projectNewDate contains' + projectNewDate);
        
        for(MPM4_BASE__Milestone1_Project__c p : projects2){
            p.MPM4_BASE__Kickoff__c = null;
            p.MPM4_BASE__Deadline__c = null;
            projectsNullDates.add(p);            
        }
        update projectsNullDates;

        //assert results
        List <Project_Month__c> pmsNewD = [SELECT Id, Project__c, Month__c FROM Project_Month__c 
                                            WHERE Project__c IN :projectNewDate ORDER BY Month__c ASC NULLS FIRST];
        
        system.debug('pmsNewD contains ' + pmsNewD);
        
        //check that correct number of Project Month Records have been created
        system.assertEquals(5, pmsNewD.size());
        //check that the first Project Month's Month__c matches Kickoff date
        Date date1 = date.today().addMonths(2);
        system.assertEquals(date.newInstance(date1.year(),date1.month(),01)-1, pmsNewD[0].Month__c);
        //check that the last Project Month's Month__c matches Deadline date
        Date date2 = date.today().addMonths(6);
        system.assertEquals(date.newInstance(date2.year(),date2.month(),01)-1, pmsNewD[4].Month__c);
        
        List <Project_Month__c> pmsNullD = [SELECT Id, Name, Project__c FROM Project_Month__c WHERE Project__c IN :projectsNullDates];

        //check that no Project Months were created when Project Deadline was set to null
        system.assertEquals(0, pmsNullD.size());
        
        test.stopTest();
        }
}