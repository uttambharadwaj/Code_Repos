/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest (seealldata=true)
private class TestCreateCommission {

    static testMethod void myUnitTest() {
        
        id recordTypeForCommissions;
        
        for(OppRecordTypeForComm__c ortc : OppRecordTypeForComm__c.getall().values())
        {
            recordTypeForCommissions = ID.valueof(ortc.recordtypeid__c);
        }
        
        
        // TO DO: implement unit test
        
        test.starttest();
        List<String> AU_Acc_RTs = new List<String>{'AU_Fuel_Customer'};
  		
  		Id accRT = [select Id from RecordType where sObjectType = 'Account' and DeveloperName NOT IN :AU_Acc_RTs limit 1].Id;
  		
        Account a = new Account();
        //a.recordtypeid = '012S00000008s1V';
        a.name = 'Test Account';
        a.RecordTypeId = accRT;
        insert a;
		
		//sandbox
        //OppRecordTypeForComm__c testCS = new OppRecordTypeForComm__c(Name='test',RecordTypeId__c='012S00000008rzuIAA');
        //production
        OppRecordTypeForComm__c testCS = new OppRecordTypeForComm__c(Name='test',RecordTypeId__c='012700000005p63AAA');
		insert testCS;
		
		//********testing commission type insert
		Opportunity o = new Opportunity();
		o.name = 'test opp';
		o.AccountId = a.Id;
		o.CloseDate = date.newinstance(2013,12,01);
		//o.StageName = '1) Qualified';
		o.StageName = '3) Evaluating';
        o.Number_of_18_Wheelers__c = 0;
		o.Product_Interest__c = 'test';
		o.RecordTypeId = recordTypeForCommissions;
		insert o;
		
		Integer commsize = [select id, opportunity__c from Commission__c Where Opportunity__c = :o.Id].size();
	
		//system.assert(commsize>0);
		
		//*****************************************
		
		//*****testing with non comm type*********
		/*Opportunity o2 = new Opportunity();
		o2.name = 'test';
		o2.AccountId = a.Id;
		o2.CloseDate = date.newInstance(2013,12,01);
		o2.StageName = '1) Qualified';
		o2.Opportunity_Category__c = 'test';
		
		o2.RecordTypeId = recordTypeForCommissions;
		insert o2;
		
		Integer commsize2 = [select id, opportunity__c from Commission__c Where Opportunity__c = :o2.Id].size();
		
		system.assert(commsize2==0);
		o2.RecordTypeId = recordTypeForCommissions;
		update o2;
		
		Integer commsize3 = [select id, opportunity__c from Commission__c Where Opportunity__c = :o2.id].size();
		system.assert(commsize3>0);
		//*******************************************
		
		//push o2 back to noncommissionable RT then back to commissionable to make sure
		//another comm record is not created.
		
		//sandbox
		//o2.RecordTypeId = '012700000005fzO';
		//production
		//o2.RecordTypeId = [select id from recordType where sObjectType = 'Opportunity' limit 1].id;
		//update o2;
		
		//sandbox
		//o2.RecordTypeId = '012S00000008rzuIAA';
		//production
		//o2.RecordTypeId = '012700000005p63AAA';
		//update o2;
		
		//system.assert([select id, opportunity__c from Commission__c Where Opportunity__c = :o2.id].size()==1);
				*/

        test.stoptest();
    }
}