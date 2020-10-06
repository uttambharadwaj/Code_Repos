/************************************************************************
* Created By : PRM | Cloud Solutions
* Purpose : Apex class to validate suburb and postcode
* Date of Creation : 25-July-2013
**************************************************************************/

public class SuburbPostcodeValidation
{
	public static Boolean validate(String suburb, String postcode)
	{
		// return true if postcode or suburb is blank
		if(suburb == null || suburb == '' || postcode == null || postcode == '')
			return true;
			
		// Query Postcodes object
		List<Postcode__c> postcodesList = new List<Postcode__c>([select Id, Postcode__c, Suburb__c 
																from Postcode__c 
																where Suburb__c = :suburb
																AND Postcode__c = :postcode limit 1]);
		
		// return true if a postcode record exists for the given suburb and postcode 														
		if(!postcodesList.isEmpty())
			return true;
			
		return false;
	}
	
	private static testmethod void myUnitTest()
	{
		System.assert(SuburbPostcodeValidation.validate('', ''));
		System.assert(!SuburbPostcodeValidation.validate('suburb', '9999'));
		
		Postcode__c postcode = new Postcode__c(Suburb__c = 'suburb', Postcode__c = '9999');
		insert postcode; 
		
		System.assert(SuburbPostcodeValidation.validate('suburb', '9999'));
	}
}