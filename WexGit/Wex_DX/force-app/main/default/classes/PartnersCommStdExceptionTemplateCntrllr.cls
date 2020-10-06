/*

    Name: PartnersCommStdExceptionTemplateController
    Created By: Jason McCormack (GearsCRM)
    Created Date: 
    Description: 
    
    Modified By: 
    Modified Date: 
    Description: 

*/

public with sharing class PartnersCommStdExceptionTemplateCntrllr extends APartnersComm 
{		
    public PartnersCommStdExceptionTemplateCntrllr()
    {
		super();
    }    
    
    public class CustomException extends Exception {}
    
	private static testMethod void test1()
    {
    	PartnersCommStdExceptionTemplateCntrllr controller = new PartnersCommStdExceptionTemplateCntrllr();
    	
    	Community__c settings = controller.Settings;
    }    
}