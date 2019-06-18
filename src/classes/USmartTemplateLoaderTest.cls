@isTest
public class USmartTemplateLoaderTest {
    
    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    @testSetup
    static void dataSetup() {
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User u1 = WE_TestDataUtility.createStandardUser();
        User u2 = WE_TestDataUtility.createStandardUser();
        u2.UserName = 'astest1@wexeurope.com';
        insert u2;
        User u3 = WE_TestDataUtility.createStandardUser();
        u3.UserName = 'astest2@wexeurope.com';
        u3.ProfileId = p1.Id;
        insert u3;
        
        system.runas(u1) {
            
            // !!! change recordTypeName to a Virtual CS rtn once in StageFull
            // no need to create Custom Metadata Type in test, see https://developer.salesforce.com/blogs/engineering/2015/05/testing-custom-metadata-types.html
            VRTN__c rtCS = WE_TestDataUtility.createRecTypeNameCustSett(
                'Virtual Credit CS', 			// rtName
                'Virtual EU Service Cases');    // csField
            insert rtCS;
            
            List<Case> casesToInsert = new List<Case>();
            
            // !!! change recordTypeName to a Virtual CS rtn once in StageFull
            List<Case> cases1 = WE_TestDataUtility.createCases(
                3,						// noCases
                '<1>',					// identifier
                'Virtual Credit CS'		// recordTypeName
            );
            // value should not be listed in metadata table
            cases1[1].Status = '--Test--';
            // value should have duplicate record
            cases1[2].Status = 'Case Assigned';
            casesToInsert.addAll(cases1);
            
            // !!! change recordTypeName to a Virtual CS rtn once in StageFull
            List<Case> cases2 = WE_TestDataUtility.createCases(
                3,						// noCases
                '<2>',					// identifier
                'Virtual Credit CS'		// recordTypeName
            );
            for(Case c : cases2) {
                c.OwnerId = u2.Id;
            }
            // value should not be listed in metadata table
            cases2[1].Status = '--Test--';
            // value should have duplicate record
            cases2[2].Status = 'Case Assigned';
            casesToInsert.addAll(cases2);
            
            // !!! change recordTypeName to a Virtual CS rtn once in StageFull
            // Case will be used to query with a username that's not listed in metadata table
            List<Case> cases3 = WE_TestDataUtility.createCases(
                1,						// noCases
                '<3>',					// identifier
                'Virtual Credit CS'		// recordTypeName
            );
            casesToInsert.addAll(cases3);
            
            // !!! change recordTypeName to a Virtual CS rtn once in StageFull
            List<Case> cases4 = WE_TestDataUtility.createCases(
                1,						// noCases
                '<4>',					// identifier
                'Virtual Credit CS'		// recordTypeName
            );
            cases4[0].Status = '--Test1--';
            casesToInsert.addAll(cases4);
            
            // !!! change recordTypeName to a Virtual CS rtn once in StageFull
            // Case will be used to query with a Record Type that's not listed in metadata table
            List<Case> cases5 = WE_TestDataUtility.createCases(
                1,									// noCases
                '<5>',								// identifier
                'WEX Salesforce Support Request'	// recordTypeName
            );
            casesToInsert.addAll(cases5);
            
            insert casesToInsert;
        }
    }
    
    static testMethod void testChooseTemplate() {
        
        Id actualTemplateId1;
        Id actualTemplateId2;
        Id actualTemplateId3;
        Id actualTemplateId4;
        Id actualTemplateId5;
        Id actualTemplateId6;
        Id actualTemplateId7;
        Id actualTemplateId8;
        Id actualTemplateId9;
        EmailTemplate expectedTemplate;
        Id expectedTemplateId;
        
        expectedTemplate =
            [SELECT Id, Name FROM EmailTemplate WHERE DeveloperName = 'USmartTemplateLoaderTest_Template'];
        expectedTemplateId = expectedTemplate.Id;
        USmartTemplateLoader loader = new USmartTemplateLoader();
        
        List<Case> cases1 = [SELECT Id, Status FROM Case WHERE Subject LIKE '%<1>%'];
        List<Case> cases2 = [SELECT Id, Status FROM Case WHERE Subject LIKE '%<2>%'];
        List<Case> cases3 = [SELECT Id, Status FROM Case WHERE Subject LIKE '%<3>%'];
        List<Case> cases4 = [SELECT Id, Status FROM Case WHERE Subject LIKE '%<4>%'];
        List<Case> cases5 = [SELECT Id, Status FROM Case WHERE Subject LIKE '%<5>%'];
        User u1 = [SELECT Id FROM User WHERE Username = 'astest@wexeurope.com'];
        User u2 = [SELECT Id FROM User WHERE Username = 'astest1@wexeurope.com'];
        User u3 = [SELECT Id FROM User WHERE Username = 'astest2@wexeurope.com'];
        
        test.startTest();
        
        system.runAs(u1) {
            
            for(Case c : cases1) {
                if (c.Status != '--Test--' && c.Status != 'Case Assigned') {
                    actualTemplateId1 = loader.getDefaultEmailTemplateId(c.Id);
                }
                else if (c.Status == 'Case Assigned') {
                    actualTemplateId2 = loader.getDefaultEmailTemplateId(c.Id);
                }
                else {
                    actualTemplateId3 = loader.getDefaultEmailTemplateId(c.Id);
                }
            }
        }
         
        system.runAs(u2) {
            for(Case c : cases2) {
                if (c.Status != '--Test--' && c.Status != 'Case Assigned') {
                    system.debug('+++ Case 4 Id is ' + c.Id);
                    actualTemplateId4 = loader.getDefaultEmailTemplateId(c.Id);
                }
                else if (c.Status == 'Case Assigned') {
                    actualTemplateId5 = loader.getDefaultEmailTemplateId(c.Id);
                }
                else {
                    actualTemplateId6 = loader.getDefaultEmailTemplateId(c.Id);
                }
            }
        }
        
        system.runAs(u3) {
            for(Case c : cases3) {
                actualTemplateId7 = loader.getDefaultEmailTemplateId(c.Id);
            }
        }
        
        system.runAs(u1) {
            for(Case c : cases4) {
                actualTemplateId8 = loader.getDefaultEmailTemplateId(c.Id);
            }
        }
        
        system.runAs(u1) {
            // can't get this loop to execute
            for(Case c : cases5) {
                actualTemplateId9 = loader.getDefaultEmailTemplateId(c.Id);
            }
        }
        
        test.stopTest();
        
        system.assertEquals(expectedTemplateId, actualTemplateId1, 'template should have been retrieved, based on Username, Record Type & matching Case Status');
        system.assertEquals(null, actualTemplateId2, 'template should not have been retrieved, due to duplicate record with same Username, Record Type & matching Case Status in Metadata Type');
        system.assertEquals(expectedTemplateId, actualTemplateId3, 'template should have been retrieved, based on Username, Record Type & ' + 'Unknown ' + 'Case Status');
        system.assertEquals(expectedTemplateId, actualTemplateId4, 'template should have been retrieved, based on Profile, Record Type & matching Case Status');
        system.assertEquals(null, actualTemplateId5, 'template should not have been retrieved, due to duplicate record with same Profile, Record Type & matching Case Status in Metadata Type');
        system.assertEquals(expectedTemplateId, actualTemplateId6, 'template should have been retrieved, based on Profile, Record Type & ' + 'Unknown ' + 'Case Status');
        system.assertEquals(null, actualTemplateId7, 'template should have been retrieved, as there should not be a record with a matching Username or Profile in Metadata Type');
        system.assertEquals(null, actualTemplateId8, 'template name should have been retrieved but not template Id, as template name is fake');
        system.assertEquals(null, actualTemplateId9, 'template should not have been retrieved, as Case does not have a Virtual EU Record Type');
    }

}