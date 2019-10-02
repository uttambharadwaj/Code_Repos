/***************************************************************************************************
* Created By : PRM | Cloud Solutions
* Purpose : Trigger to validate suburb and postcode on Lead record
* Date of Creation : 24-July-2013
****************************************************************************************************/

trigger ValidateSuburbPostcode on Lead (before insert, before update)
{
    // trigger should fire only for Leads with Australian record types
    
    Set<String> AU_Lead_RTs = new Set<String>();
    
    // Query record types
	/*SGupta 07/07/2014 updated below line of code
	*    for(RecordType rt : [select Id from RecordType where sObjectType = 'Lead' and DeveloperName IN ('AU_Fuel_Application_Individual','AU_Fuel_Business','AU_Fuel_Merchant','AU_Fuel_Prepaid','AU_VCC')])
	*/
    /*for(RecordType rt : [select Id from RecordType where sObjectType = 'Lead' and DeveloperName IN ('AU_Fuel_Application_Individual','AU_Fuel_Application_Business','AU_Merchant','AU_Fuel')])
        AU_Lead_RTs.add(rt.Id);*/
	
	/*
		Added by Trekbin to get all AU record types from custom setting based on the wex case no : 00022109.
		Date: 21 July 2015
	*/
	// Find all the AU record types in the custom setting.
	Map<String, AULeadRecordTypes__c> mapAU_Lead_RTs = AULeadRecordTypes__c.getAll();
	
	AU_Lead_RTs.addAll(mapAU_Lead_RTs.keySet());
	/*    */
	
    Set<String> suburbs = new Set<String>();
    Set<String> postcodes = new Set<String>();
    
    for(Lead l : Trigger.new)
    {
        if(AU_Lead_RTs.contains(l.RecordTypeId))
        {
            // add suburb and postal codes to sets
            
            if(l.City != null && l.City != '')
                suburbs.add(l.City);
                
            if(l.AU_Postal_City__c != null && l.AU_Postal_City__c != '')
                suburbs.add(l.AU_Postal_City__c);
                
            if(l.PostalCode != null && l.PostalCode != '')
                postcodes.add(l.PostalCode);
                
            if(l.AU_Postal_Postcode__c != null && l.AU_Postal_Postcode__c != '')
                postcodes.add(l.AU_Postal_Postcode__c);
        }
    }
    
    List<Postcode__c> postcodesList = new List<Postcode__c>();
    
    if(!suburbs.isEmpty() || !postcodes.isEmpty())
    {
        // Query Postcode records that contain valid suburb and postal codes
        postcodesList = [select Id, Postcode__c, Suburb__c from Postcode__c where Suburb__c IN :suburbs OR Postcode__c IN :postcodes];
        
        for(Lead l : Trigger.new)
        {
            if(l.City != null && l.City != '' && l.PostalCode != null && l.PostalCode != '')
            {
                Boolean isValid = false;
                
                // check if a postcode record exists for the given suburb and postcode
                for(Postcode__c p : postcodesList)
                {
                    if(p.Suburb__c.equalsIgnoreCase(l.City) && p.Postcode__c == l.PostalCode)
                    {
                        isValid = true;
                        break;
                    }
                }
                
                // throw error if invalid
                if(!isValid)
                {
                    l.addError('Incorrect suburb and postcode');
                    return;
                }
            }
            
            if(l.AU_Postal_City__c != null && l.AU_Postal_City__c != '' && l.AU_Postal_Postcode__c != null && l.AU_Postal_Postcode__c != '')
            {
                Boolean isValid = false;
                
                for(Postcode__c p : postcodesList)
                {
                    // check if a postcode record exists for the given suburb and postcode
                    if(p.Suburb__c.equalsIgnoreCase(l.AU_Postal_City__c) && p.Postcode__c == l.AU_Postal_Postcode__c)
                    {
                        isValid = true;
                        break;
                    }
                }
                
                // throw error if invalid
                if(!isValid)
                {
                    l.addError('Incorrect postal suburb and postcode');
                    return;
                }
            }
        }
    }
}