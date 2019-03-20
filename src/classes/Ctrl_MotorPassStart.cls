/***************************************************************************************************
* Created By : PRM | Cloud Solutions
* Purpose : Controller for Start Page of Motorpass web form
* Date of Creation : 24-July-2013
****************************************************************************************************/

public with sharing class Ctrl_MotorPassStart
{
    public String opt1 { get;set; }
    public String opt2 { get;set; }
    public String brand { get;set; }
     
    
    public Ctrl_MotorPassStart getThis() {
        return this;
    }
    
    public Boolean showFields { get;set; }
    
    public Ctrl_MotorPassStart()
    {
        showFields = false;
        brand = ApexPages.currentPage().getParameters().get('brand');
        if(brand == 'Motorpass')
        {
        	opt1 = ApexPages.currentPage().getParameters().get('opt');
        	if(opt1 != null && opt1 != '')
        		showFields = true;  
        }
    }
    
    public PageReference showMotorPass()
    {
        showFields = true;     
        if(brand == 'Motorcharge')
        {
            opt2 = 'Motorcharge';
            return  redirectToForm();
        }
        
        return NULL;
    }
    
    public PageReference redirectToForm()
    {
        PageReference pg;
        
        
        
        // set parameters and redirect to Individual or Organsiation page
        if(opt1 == 'Individual')
            pg = Page.IndividualDetails;
        else
            pg = Page.OrganisationDetails;
        
        pg.getParameters().put('opt',EncodingUtil.urlEncode(opt1, 'UTF-8'));    
        pg.getParameters().put('motorpass',EncodingUtil.urlEncode(opt2, 'UTF-8'));
        pg.getParameters().put('brand',EncodingUtil.urlEncode(brand, 'UTF-8'));    
        
        return pg;
    }
    
    public void resetForm()
    {
        showFields = false;
    }
    
    
    private static testmethod void myUnitTest()
    {
        PageReference pg = Page.MotorpassForm;
        Test.setCurrentPage(pg);
        
        pg.getParameters().put('brand','Motorpass');
        Ctrl_MotorPassStart controller = new Ctrl_MotorPassStart();        
        controller.opt1 = 'Individual';
        controller.showMotorPass();
        controller.opt2 = 'Motorpass';
        controller.redirectToForm();
        controller.opt1 = 'Organisation';
        controller.redirectToForm();
        controller.resetForm();
        controller.getThis();
    }
}