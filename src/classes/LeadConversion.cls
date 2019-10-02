/***********************************************************************************************
* Created By : PRM | Cloud Solutions
* Purpose : Custom Lead convert
* Date of Creation : 16-Aug-2013
***********************************************************************************************/

global without sharing class LeadConversion
{
    static webservice String convertLead(Id leadId)
    {
        String retString = '';
        
        try
        {
            // call Standard lead conversion method
            
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(leadId);
            lc.setOwnerId(UserInfo.getUserId());
            
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            // return converted Opportunity Id if lead conversion is successful
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            if(lcr.isSuccess())
                retString = lcr.getOpportunityId();
            else
            {
                Database.Error err = lcr.getErrors()[0];
                retString = 'Lead Conversion failed : ' + err.getMessage();
            }
        }
        catch(Exception e)
        {
            retString = 'Lead Conversion failed : ' + e.getMessage();
        }
        
        return retString;
    }
    
    
    private static testmethod void myUnitTest()
    {
        UtilityTestLoader.setAutomation(false);
        Id leadRT = [select Id from RecordType where sObjectType = 'Lead' and DeveloperName IN ('AU_Fuel_Application_Individual','AU_Fuel_Business','AU_Fuel_Merchant','AU_Fuel_Prepaid','AU_VCC') limit 1].Id;
        
        Lead l = new Lead(RecordTypeId = leadRT, Company = 'test', Lastname = 'test', Firstname = 'test');
        insert l;
        
        test.starttest();
        String result = LeadConversion.convertLead(l.Id);
        test.stoptest();
        
        System.assert(result.startsWith(sObjectType.Opportunity.getKeyPrefix()));
        result = LeadConversion.convertLead(null);
        System.assert(result.startsWith('Lead Conversion failed'));
    }
    
}