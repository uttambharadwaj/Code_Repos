/***************************************************************************************************
* Created By : PRM | Cloud Solutions
* Purpose : Test class to test ValidateSuburbPostcode trigger
* Date of Creation : 24-July-2013
****************************************************************************************************/

@isTest
private class TestValidateSuburbPostcodeTrg
{

    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testMethod void myUnitTest()
    {
    	Postcode__c postcode = new Postcode__c(Suburb__c = 'Melbourne', Postcode__c = '8888');
		insert postcode;
    	
    	Id leadRT = [select Id from RecordType where sObjectType = 'Lead' and DeveloperName IN ('AU_Fuel_Application_Individual','AU_Fuel_Business','AU_Fuel_Merchant','AU_Fuel_Prepaid','AU_VCC') limit 1].Id;
		
        Lead l = new Lead(RecordTypeId = leadRT, Firstname = 'test', Company = 'test', Lastname = 'test', City = 'Melbourne', Postalcode = '8888', AU_Postal_City__c = 'Melbourne', AU_Postal_Postcode__c = '8888');
        insert l;
        
        l = new Lead(RecordTypeId = leadRT, Company = 'test', Lastname = 'test', City = 'test', Postalcode = '8888', AU_Postal_City__c = 'test', AU_Postal_Postcode__c = '8888');
        try
        {
        	insert l;
        	System.assert(false);
        }
       	catch(Exception e)
       	{	 
       			System.assert(true,e.getMessage().contains('Incorrect suburb and postcode'));
       	}
       	
       	l = new Lead(RecordTypeId = leadRT, Company = 'test', Lastname = 'test', City = 'Melbourne', Postalcode = '8888', AU_Postal_City__c = 'test', AU_Postal_Postcode__c = '8888');
        try
        {
        	insert l;
        	System.assert(false);
        }
       	catch(Exception e)
       	{
       		System.assert(true,e.getMessage().contains('Incorrect postal suburb and postcode'));
       	}
    }
}