/*

    Name: Deployment_PartnersCommunity
    Created By: Jason McCormack (GearsCRM)
    Created Date: 
    Description: 
    
    Deployment_PartnersCommunity d = new Deployment_PartnersCommunity(Deployment_PartnersCommunity.Environment.DEV);
    
    d.run();
    
    Modified By: 
    Modified Date: 
    Description: 

*/

public class Deployment_PartnersCommunity
{    
    private Environment sfEnvironment;
    private String communityName;
    private String homePageUrl;
    
    public Boolean IsSandbox {get; private set;}        
    
    public static String SiteCategoryName = 'Partners Comm';
    
    public Deployment_PartnersCommunity(Environment sfEnvironment)
    {
        this.sfEnvironment = sfEnvironment;   
        //this.communityName = 'customer';     
        this.communityName = 'partners';
        //this.communityName = '';
        //this.homePageUrl = '/' + communityName + '/apex/PartnersCommHome';
        
        isSandboxEnvironment();
    }   
    
    private void isSandboxEnvironment()
    {
        if(sfEnvironment == Environment.PRODUCTION)
        {
            this.IsSandbox = false;
        }
        else
        {
            this.IsSandbox = true;
        }
    }
    
    public void run()
    {       
        insertURLs();          
        insertSettings();          
    }
 
    private URL__c url(String label, String url)
    {
        URL__c u = new URL__c();
                
        u.URL_Label__c = label;     
        u.URL__c  = url;        
        
        return u;
    }

    private void deleteURLs(String urlCategory, String urlGroup)
    {
        if(urlCategory == null || urlCategory.trim().length() == 0)
        {
            return;
        }
        
        if(urlGroup == null || urlGroup.trim().length() == 0)
        {
            return;
        }
        
        List<URL__c> urlsToDelete = [select Id from URL__c where URL_Category__c = :urlCategory and URL_Group__c = :urlGroup];
        
        try
        {
            delete urlsToDelete;
        }
        catch(DmlException e)
        {
            System.debug('EXCEPTION:' + e);
        }
    }
    
    private void incrementURLNameAndSortOrder(List<URL__c> urls, String name)
    {
        Integer counter = 0;
        
        for(URL__c url : urls)
        {
            url.Name = name + ' ' + (counter + 1);
            url.Sort_Order__c = (counter + 1);
            
            counter++;  
        }           
    }
    
    private void setURLCategory(List<URL__c> urls, String urlCategory)
    {   
        setURLValue(urls, 'URL_Category__c', urlCategory);
    }   
    
    private void setURLGroup(List<URL__c> urls, String urlGroup)
    {           
        setURLValue(urls, 'URL_Group__c', urlGroup);
    }   
    
    private void setURLValue(List<URL__c> urls, String fieldName, Object fieldValue)
    {
        Integer counter = 0;
        
        for(URL__c url : urls)
        {
            url.put(fieldName, fieldValue); 
        }
    }
    
    
    public void insertURLs()
    {    	        
        insertLeftNavComponentURLs();        
        insertLeftNavCommonIssueURLs();    
    }    
    
    public static String LeftNavURLsCategoryName = SiteCategoryName;
    public static String LeftNavURLsGroupName = 'Main LeftNav';
    
    private void insertLeftNavComponentURLs()
    {
    	String categoryName = LeftNavURLsCategoryName;
    	String groupName = LeftNavURLsGroupName;
    	
    	List<URL__c> urlsToInsert = new List<URL__c>();
        
        //build out URLS here                        
		        
        saveURLs(urlsToInsert, categoryName, groupName);                    
    }  
    
    public static String LeftNavCommonIssuesURLsCategoryName = SiteCategoryName;
    public static String LeftNavCommonIssuesURLsGroupName = 'LeftNav Common Issues';
    
    
    private void insertLeftNavCommonIssueURLs()
    {
    	String categoryName = LeftNavCommonIssuesURLsCategoryName;
    	String groupName = LeftNavCommonIssuesURLsGroupName;
    	
    	List<URL__c> urlsToInsert = new List<URL__c>();
        
        //build out URLs here                    
		        
        saveURLs(urlsToInsert, categoryName, groupName);                    
    }    
    
 
    /* ENVIRONMENT SPECIFIC URL METHOD TEMPLATE
    private String getContactSupportURL()
    {
        String url = null;
        
        if(sfEnvironment == Environment.DEV)
        {
            url = './ContactSupport';
        }
        else if(sfEnvironment == Environment.UAT)
        {
            url = './ContactSupport';
        }
        else if(sfEnvironment == Environment.STAGING)
        {
            url = './ContactSupport';
        }
        else
        {
            //Production
            url = './ContactSupport';
        }
        
        return url;
    }
    */
    
    private void saveURLs(List<URL__c> urlsToInsert, String categoryName, String groupName)
    {
    	incrementURLNameAndSortOrder(urlsToInsert, groupName);
        setURLCategory(urlsToInsert, categoryName);
        setURLGroup(urlsToInsert, groupName);
        
        deleteURLs(categoryName, groupName);
        
        try
        {
            insert urlsToInsert;
        }
        catch(DmlException e)
        {
            System.debug('EXCEPTION: ' + e);
        }
    }
    
    public void insertSettings()
    {    	    	
    	createCommunitySetting();		 	
		createCommunitySettings();
    	createLoginSettings();   	  	
    }
    
    public void createCommunitySetting()
    {
    	Community__c c = new Community__c();
    	
    	c.Name = communityName;
    	c.Component_Width__c = 758;
    	c.Submit_Form_As_POST__c = true;
    	c.Community_Hostname__c = getHostName();
    	
    	try
    	{
    		delete [select Id from Community__c where SetupOwnerId = :Userinfo.getOrganizationId()];
    		insert c;
    	}
    	catch(DmlException e)
    	{
    		System.debug('### EXCEPTION: ' + e);
    	}
    }
    
    public String getHostName()
    {
    	
    	
        String hostname = null;
        
        if(sfEnvironment == Environment.DEV)
        {
            hostname = 'https://' + communityName.toLowerCase() + '';
        }
        else if(sfEnvironment == Environment.UAT)
        {
            hostname = 'https://stagefull-wexpartners.cs3.force.com' + communityName.toLowerCase() + '';
        }
        else if(sfEnvironment == Environment.STAGING)
        {
            hostname = 'https://stagefull-wexpartners.cs3.force.com' + communityName.toLowerCase() + '';
        }
        else
        {
            //Production
            hostname = 'https://onlineservices.force.com' + communityName.toLowerCase() + '';
        }
        
        return hostname;    	
    }
    
    private static void createCommunitySettings()
    {
    	String categoryName = Deployment_PartnersCommunity.SiteCategoryName;
    	String groupName = 'Component Width';
    	
    	List<Setting__c> recordsToInsert = new List<Setting__c>();
    	
    	Setting__c setting1 = new Setting__c();
    	
	    setting1.Name = categoryName + ' ' + groupName;
	    setting1.Category__c = categoryName;
	    setting1.Group__c = groupName;
	    setting1.Value__c = '400px';
	    	
	    recordsToInsert.add(setting1);
	    
	    try
        {
        	delete [select Id from Setting__c where Category__c = :categoryName and Group__c = :groupName];
        	
        	insert recordsToInsert;
        }
        catch(DmlException e)
        {
        	System.debug('EXCEPTION: ' + e);
        }
    }
    
    private void createLoginSettings()
    {
    	String communityCodePrefix = 'PartnersComm'; //The prefix used in all the classes, components and VF pages    	
    	String categoryName = Deployment_PartnersCommunity.SiteCategoryName;
    	
    	Map<String, String> devSettingsMap = new Map<String, String>();
    	    	
    	devSettingsMap.put('Server Name', '');
    	devSettingsMap.put('Community Name', communityName);
    	devSettingsMap.put('Portal Id', 'ABC');    	
    	devSettingsMap.put('Start URL', '/' + communityName + '/home/home.jsp');
    	devSettingsMap.put('Forgot Password URL', '/' + communityName + '/' + communityCodePrefix + 'ForgotPassword');    	    
    	
    	Map<String, String> uatSettingsMap = new Map<String, String>();
    	    	
    	uatSettingsMap.put('Server Name', 'https://stagefull-wexpartners.cs3.force.com');
    	uatSettingsMap.put('Community Name', communityName);
    	uatSettingsMap.put('Portal Id', 'ABC');    	
    	uatSettingsMap.put('Start URL', '/' + communityName + '/home/home.jsp');
    	uatSettingsMap.put('Forgot Password URL', '/' + communityName + '/' + communityCodePrefix + 'ForgotPassword');
    	
    	Map<String, String> prodSettingsMap = new Map<String, String>();
    	
    	//NEED TO GET PROD VALUES
    	prodSettingsMap.put('Server Name', 'https://onlineservices.force.com ');
    	prodSettingsMap.put('Community Name', communityName);
    	prodSettingsMap.put('Portal Id', 'ABC');    	
    	prodSettingsMap.put('Start URL', '/' + communityName + '/home/home.jsp');  
    	prodSettingsMap.put('Forgot Password URL', '/' + communityName + '/' + communityCodePrefix + 'ForgotPassword');  	
    	
    	Map<String, String> settingsMap = null;
    	
    	if(sfEnvironment == Environment.DEV)
        {
            settingsMap = devSettingsMap;
        }
        else if(sfEnvironment == Environment.UAT)
        {
            settingsMap = uatSettingsMap;
        }
        else if(sfEnvironment == Environment.STAGING)
        {
            settingsMap = uatSettingsMap;
        }
        else
        {
            //Production
            settingsMap = prodSettingsMap;
        }
          
        List<Setting__c> recordsToInsert = new List<Setting__c>();
        
        for(String key : settingsMap.keySet())
        {
        	Setting__c setting = new Setting__c();
    	
	    	setting.Name = categoryName + ' ' + key;
	    	setting.Category__c = categoryName;
	    	setting.Group__c = key;
	    	setting.Value__c = settingsMap.get(key);
	    	
	    	recordsToInsert.add(setting);
        }
        
        try
        {
        	delete [select Id from Setting__c where Category__c = :categoryName and Group__c in :settingsMap.keySet()];
        	
        	insert recordsToInsert;
        }
        catch(DmlException e)
        {
        	System.debug('EXCEPTION: ' + e);
        }
    }     
    
    public enum Environment 
    {
        PRODUCTION,
        STAGING, 
        UAT,
        DEV
    }    
    
    private static testMethod void test1()
    {
        Deployment_PartnersCommunity deployment = new Deployment_PartnersCommunity(Deployment_PartnersCommunity.Environment.PRODUCTION);
        
        deployment.run();
    }
}