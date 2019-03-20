/*

    Name: PartnersCommLeftNavController
    Created By: Jason McCormack (GearsCRM)
    Created Date: 
    Description: 
    
    Modified By: 
    Modified Date: 
    Description: 

*/

public class PartnersCommLeftNavController 
{	
	public List<URL__c> LeftNavURLs {get; private set;}	
	public List<URL__c> LeftNavCommonIssuesURLs {get; private set;}
	
    public PartnersCommLeftNavController()
    {    	
		loadLeftNavURLs();
		loadLeftNavCommonIssuesURLs();
    }    
    
    private void loadLeftNavURLs()
    {
    	String urlCategory = Deployment_PartnersCommunity.LeftNavURLsCategoryName;
    	String urlGroup = Deployment_PartnersCommunity.LeftNavURLsGroupName; 
    	    	
    	this.LeftNavURLs = [select 
    							Id, 
    							URL_Label__c,    
    							URL__c, 							
    							URL_Target__c 
    						from 
    							URL__c 
    						where 
    							URL_Category__c = :urlCategory and 
    							URL_Group__c = :urlGroup 
    						order by 
    							Sort_Order__c asc];		
	}
    
    private void loadLeftNavCommonIssuesURLs()
    {
    	String urlCategory = Deployment_PartnersCommunity.LeftNavCommonIssuesURLsCategoryName;
    	String urlGroup = Deployment_PartnersCommunity.LeftNavCommonIssuesURLsGroupName; 
    	
    	this.LeftNavCommonIssuesURLs = [select 
			    							Id, 
			    							URL_Label__c, 
			    							URL__c, 
			    							URL_Target__c 
			    						from 
			    							URL__c 
			    						where 
			    							URL_Category__c = :urlCategory and 
			    							URL_Group__c = :urlGroup 
			    						order by 
			    							Sort_Order__c asc];
	}
        
    public class CustomException extends Exception {}
}