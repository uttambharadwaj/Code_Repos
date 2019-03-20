/**************************************************************************************
* Created By : PRM | Cloud Solutions
* Purpose : Controller for Call back Form
* Date of Creation : 23-July-2013
***************************************************************************************/

public without sharing class CallBackCtrl
{
    private Ctrl_MotorpassForm Motorpass;
    
    public Ctrl_MotorpassForm getMotorpass(){
        return Motorpass;
    }
    
    public void setMotorpass(Ctrl_MotorpassForm tempController) {  
        this.Motorpass =  tempController;       
        this.Motorpass.setobjCallbackController(this);
    }
    
    public Lead l { get;set; }

    public String errorStr { get;set; }
    
    public Boolean showThankYouText { get;set; }
    
    public CallBackCtrl()

        
    {
        
        l = new Lead();

        populateLeadFields();
        
        // initialise the variables
        showThankYouText = false;
        errorStr = '';
    }
    
    public void populateLeadFields()
    {
        if(Motorpass != null)
        {
            if(Motorpass.theLead != null)
            {               
                l.RecordTypeId = Motorpass.theLead.RecordTypeId;
                l.FirstName = Motorpass.theLead.FirstName;
                l.LastName = Motorpass.theLead.LastName;
                l.Phone = Motorpass.theLead.Phone;
                if(Motorpass.option == 'Individual')
                    l.Company = Motorpass.theLead.AU_Company__c;
                else
                    l.Company = Motorpass.theLead.AU_Account_Name__c;
                    
            }
        }
    }
    
    // invoked on form submission
    public void createNewLead()
    {
        errorStr = '';
        
        Pattern isnumbers = Pattern.Compile('^[0-9]+$');
         
                    
        if(l.Phone != null && l.Phone != '')
        {
            Matcher patternMatcher = isnumbers.matcher(l.Phone);
            if(!patternMatcher.Matches())
            {
                errorStr = 'Phone must contain only numbers';
                return;
            }
                
            if(l.Phone.length() != 10)
            {
                errorStr = 'Phone number must be 10 digits';
                return;
            }
        }
        if(l.Company !=null && l.Company!='' && l.Company.length() > 35 && Motorpass.option != 'Individual')
        {
            errorStr='Business name must not be more than 35 characters';
            return;
            
        }
        
        Savepoint sp;
        try
        {
            sp = Database.setSavepoint();
            l = l.clone(false,true);
            
            l.AU_Application_Status__c = 'Unactioned';
            l.Status = 'Untouched';
            l.Brand__c = ApexPages.currentPage().getParameters().get('brand');
            l.AU_Sales_Channel__c = 'Internet SF';
            //Setting the Employer name if "Individual"
            if(Motorpass.option == 'Individual')
            	l.AU_Company__c=l.Company;
                
                // set Product name
                if(Motorpass.theLead.AU_Card_Type__c == 'Motorpass')
                    l.Product_Name__c = 'SM';
                else if(Motorpass.theLead.AU_Card_Type__c == 'Motorpass Diesel')
                    l.Product_Name__c = 'DC';
                else
                    l.Product_Name__c = 'MC';
            
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule= true;
            l.setOptions(dmo);
                
            insert l;
            
            
            // create a task against the person account
            Task t = new Task(WhoID = l.Id, Subject = 'Call back requested', Type='Call');
            
            List<RecordType> taskRT = [select Id from RecordType where sObjectType = 'Task' and DeveloperName = 'AU_Task_Record_Type' limit 1];
            if(taskRT != null && !taskRT.isEmpty())
                t.RecordTypeId = taskRT[0].Id;
                
            t.Description = '';
                
            t.ActivityDate = Date.today();
            
            insert t;
            
            // reinitialise form fields
            resetForm();
            
            // show thank you text
            showThankYouText = true;
        }
        
        catch(Exception e)
        {
            errorStr = e.getMessage();
            Database.rollback(sp);
        }
        
    }
    
    // invoked on clicking Close
    public PageReference closeForm()
    {
        resetForm();
        showThankYouText = false;
        return NULL;
    }
    
    
    // reset form fields
    private void resetForm()
    {
        l = new Lead();
        errorStr = '';
    }
    
    
    private static testmethod void myUnitTest()
    {
        Id leadRT = [select Id,DeveloperName from RecordType where sObjectType = 'Lead' and DeveloperName IN ('AU_Fuel_Application_Individual') limit 1].Id;
        
        CallBackCtrl controller = new CallBackCtrl();
        
        Ctrl_MotorpassForm obj = new Ctrl_MotorpassForm();
        obj.theLead = new Lead(RecordTypeId=leadRT);
        controller.setMotorpass(obj);
        controller.getMotorpass();
        
        controller.populateLeadFields();
        
        controller.l.FirstName = 'TestFName';
        controller.l.LastName = 'TestLName';
        controller.l.Company = 'test';
        controller.l.Phone = '673647';
        controller.createNewLead();
        controller.l.Phone = '1234567890';
        controller.l.MobilePhone = '346';
        controller.createNewLead();
        controller.l.MobilePhone = '1234567890';
        controller.createNewLead();
        System.assertEquals(true, controller.showThankYouText);
        controller.closeForm();
        
    }
    
}