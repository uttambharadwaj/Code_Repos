@isTest
private class Test_Commission_Opportunity {
  
  @isTest
  private static void Test_Trigger() {
  	List<String> AU_Opp_RTs = new List<String>{'AU_Fuel_Card_Business','AU_Fuel_Card_Individual','AU_Fuel_Merchant'};
		
	Id oppRT = [select Id from RecordType where sObjectType = 'Opportunity' and DeveloperName NOT IN :AU_Opp_RTs limit 1].Id;
	
    Opportunity opportunity = new Opportunity(Name = 'SSS',CloseDate = System.today(),StageName = 'SSS', RecordTypeId = oppRT);
    insert opportunity;
  }
}