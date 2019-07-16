@isTest
public class ApprovalProcessHandlerTest {

    static testMethod void testApprovalProcessHandler() {
       
        CP_Projects__c cpProjects = new CP_Projects__c();
        
        cpProjects.Name = 'Test Project';
        
        insert cpProjects;
                
        ApprovalProcessHandler.unlockRecord(new List<Id>{cpProjects.Id});
        
    }
    
}