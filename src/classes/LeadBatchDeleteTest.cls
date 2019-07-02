@isTest 
public class LeadBatchDeleteTest{ 

   static testMethod void runTest(){
      UtilityTestLoader.setAutomation(false);
  
      List<String> AU_Lead_RTs = new List<String>{'AU_Fuel_Application_Individual','AU_Fuel_Business','AU_Fuel_Merchant','AU_Fuel_Prepaid','AU_VCC'};
      
      Id leadRT = [select Id from RecordType where sObjectType = 'Lead' and DeveloperName NOT IN :AU_Lead_RTs limit 1].Id;
      
        Lead lead = new Lead();
        lead.RecordTypeId = leadRT;
        lead.company = 'sawicki test';
        lead.lastname = 'sawicki';
        insert lead;
        
        String sql = 'SELECT ID FROM Lead WHERE company = \'sawicki test\'';
        List <Lead> leads = Database.query(sql);
        System.debug('lead size:' + leads.size());      
         
        Test.StartTest();
        System.Assert(leads.size()> 0);
        BatchDelete batchApex = new BatchDelete (sql);
        Database.executeBatch(batchApex);   
           
        Test.StopTest();

        leads = Database.query(sql);
        System.debug('lead size NOW:' + leads.size());       
        System.Assert(leads.size() == 0); 
    }
 
}