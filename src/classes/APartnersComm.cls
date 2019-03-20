/*

    Name: APartnersComm
    Created By: (GearsCRM)
    Created Date: 
    Description: 
    
    Modified By: 
    Modified Date: 
    Description: 

*/

public abstract class APartnersComm 
{	
	public Community__c Settings {get{return CommunitySettings;} private set;} //This needs to be deprecated
	public Community__c CommunitySettings {get; private set;}
	
    public APartnersComm()
    {		
		this.CommunitySettings = Community__c.getValues(Site.getName());
		
		UGears.UDebug.printDebug('COMMUNITY SETTINGS: ' + Settings);
    }    
    
    public class CustomException extends Exception {}
}