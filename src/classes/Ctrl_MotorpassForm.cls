/***************************************************************************************************
* Created By : PRM | Cloud Solutions
* Purpose : Controller for Motorpass web form
* Date of Creation : 24-July-2013
****************************************************************************************************/

public without sharing class Ctrl_MotorpassForm
{
    public Lead theLead { get;set; }
    
    public List<AU_Card_Details__c> cardsList { get;set; }
    
    public String option { get;set; }
    public String captchaError { get;set; }
    public String formCompleted { get;set; }
    public String saveForm { get;set; }
    public String full_part_Time { get;set; }
    public String dob { get;set; }
    public String empCommencement { get;set; }
    public String expiryDate { get;set; }
    public String brand { get;set; }
    public String motorpass { get;set; }
    public String redirectedFrom { get;set; }
    public String opt1 { get;set; }
    public String opt2 { get;set; }
    
    public Boolean showFields { get;set; }
    public Boolean copyAddress { get;set; }
    public Boolean focusCaptcha {get; private set;}
        
    //For the reCaptcha component
    public ReCaptchaController objRecaptchaController {get; set;}
    
    // for the Callback component
    private CallBackCtrl objCallbackController;  
    
    public ReCaptchaController getobjRecaptchaController() {
        return objRecaptchaController;
    }
    
    public void setobjRecaptchaController(ReCaptchaController tempRecaptcha) {
        objRecaptchaController = tempRecaptcha;
    }
    
    public CallBackCtrl getobjCallbackController() {
        return objCallbackController;
    }
    
    public void setobjCallbackController(CallBackCtrl tempRecaptcha) {
        objCallbackController = tempRecaptcha;
    }
    
    
    public Ctrl_MotorpassForm getThis() {
        return this;
    }
    
    
    public String numberOfCards { get;
        
        set
        {
            numberOfCards = value;
            
            // assign number of cards required to the corresponding field on lead
            if(theLead == null)
                theLead = new Lead();
                
            theLead.AU_Total_Cards_Required__c = Integer.valueOf(value);    
        }
    }
    
    public Ctrl_MotorpassForm()
    {
        showFields = false;
        
        brand = ApexPages.currentPage().getParameters().get('brand');
            
        resetDetailFields();
            
    }
    
    public PageReference showMotorPass()
    {
        if(brand != 'Motorcharge')
            showFields = true;     
        if(brand == 'Motorcharge')
        {
            opt2 = 'Motorcharge';
            return  redirectToForm();
        }
        
        return NULL;
    }
    
    private void resetDetailFields()
    {
        copyAddress = false;
        
        theLead = new Lead();
        
        cardsList = new List<AU_Card_Details__c>();
        
        numberOfCards = '1';
        
        createCards();
        
        captchaError= '';   
        
        formCompleted = 'no';
        
        redirectedFrom = '';
        
    }
    
    public PageReference redirectToForm()
    {
        PageReference pg;
       
        if(option != null && option != '' && option != opt1)
        {
       
            resetDetailFields();
        }
        option = opt1;
        
        // assign recordtype based on the option selected
        if(option == 'Individual')
            theLead.RecordTypeId = UtilityClass.getRecTypeByDevName('Lead','AU_Fuel_Application_Individual');
        else
            theLead.RecordTypeId = UtilityClass.getRecTypeByDevName('Lead','AU_Fuel_Business');
            
        motorpass               = opt2;
        theLead.AU_Card_Type__c = opt2;
        
        // set parameters and redirect to Individual or Organsiation page
        if(option == 'Individual')
            pg =  Page.IndividualDetails;
        else
            pg = Page.OrganisationDetails;

        
        pg.setRedirect(false);
        
        return pg;
    }
    
    public void resetForm()
    {
        showFields = false;
    }
    
    public void populateAdd()
    {
    String bsbEntered;
    if(theLead !=null)
       bsbEntered=theLead.AU_BSB__c;
    if(Database.countQuery('Select count() from BSB__c where  BSB__c =: bsbEntered ')> 0)
       {
           BSB__c bsb= [Select BSB__c,Financial_Institution_City__c,AU_Financial_Institution_State__c,Financial_Institution_Postcode__c,Financial_Institution__c,AU_Financial_Institution_Address__c from BSB__c where BSB__c =: bsbEntered];
           theLead.AU_Financial_Institution__c=bsb.Financial_Institution__c;
           theLead.AU_Financial_Institution_Address__c=bsb.AU_Financial_Institution_Address__c;
           theLead.AU_Financial_Postcode_Address__c=bsb.Financial_Institution_Postcode__c;
           theLead.AU_Financial_Institution_State__c=bsb.AU_Financial_Institution_State__c;
           theLead.AU_Financial_Institution_Suburb__c=bsb.Financial_Institution_City__c;
           
       }
       else
       {
           if(!(saveForm!=null && saveForm=='yes'))
              
           theLead.AU_Financial_Institution__c='';
           theLead.AU_Financial_Institution_Address__c='';
           theLead.AU_Financial_Postcode_Address__c='';
           theLead.AU_Financial_Institution_State__c='';
           theLead.AU_Financial_Institution_Suburb__c='';
           
           
       }
    
    }
    public void invokeComponent()
    {
        if(objCallbackController != null)
            objCallbackController.populateLeadFields();
    }
    
    // validate field values
    public PageReference validateLeadFields()
    {
        try
        {
            Boolean isValid = false;
            // copy residential address to postal address if copy address selected on page
            if(copyAddress)
            {
                theLead.AU_Postal_Address__c    = theLead.Street;
                theLead.AU_Postal_City__c       = theLead.City;
                theLead.AU_Postal_State__c      = theLead.State;
                theLead.AU_Postal_Postcode__c   = theLead.PostalCode;
            }
                
            if(option == 'Individual')
            {
           
                       
                isValid = validateIndividualFields();
            }
            else
            {
          
            
                isValid = validateOrgFields();
            }
                
            if(isValid)
            {
                // redirect to confirmation page if form is partially completed, else redirect to Card Options page
                PageReference pg;
                
                if(saveForm == 'yes')
                    pg = Page.MotorpassConfirmation;
                else
                    pg = Page.CardOptions;
                
                pg.setRedirect(false);
                return pg;
            }   
            
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        }
        
        return NULL;
    }
    
    // perform required field validations for Individual
    private Boolean validateIndividualFields()
    {
        Boolean isValid = true;
        
        Pattern isnumbers = Pattern.Compile('^[0-9]+$');
        
        if(theLead.FirstName == null || theLead.FirstName == '')
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Required field missing : First Name'));
        else if(theLead.FirstName != null && theLead.FirstName != '' && theLead.FirstName.length() > 20)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'First Name must not be more than 20 characters'));
        if(theLead.Lastname == null || theLead.Lastname == '')
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Required field missing : Last Name'));
        else if(theLead.Lastname != null && theLead.Lastname != '' && theLead.Lastname.length() > 20)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Last Name must not be more than 20 characters'));
        if(theLead.Street != null && theLead.Street != '' && theLead.Street.length() > 35)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Address line 1 must be no more than 35 characters'));
        if(theLead.AU_Postal_Address__c != null && theLead.AU_Postal_Address__c != '' && theLead.AU_Postal_Address__c.length() > 35)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Postal address line 1 must be no more than 35 characters'));
        if(theLead.City != null && theLead.City != '' && theLead.City.length() > 26)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Suburb must be no more than 26 characters'));
        if(theLead.AU_Postal_City__c != null && theLead.AU_Postal_City__c != '' && theLead.AU_Postal_City__c.length() > 26)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Postal suburb must be no more than 26 characters'));
        if(theLead.PostalCode != null && theLead.PostalCode != '')
        {
            Matcher patternMatcher = isnumbers.matcher(theLead.PostalCode);
            
            if(!patternMatcher.Matches())
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Postcode must contain only numbers'));
        }
        if(theLead.AU_Postal_Postcode__c != null && theLead.AU_Postal_Postcode__c != '')
        {
            Matcher patternMatcher = isnumbers.matcher(theLead.AU_Postal_Postcode__c);
            
            if(!patternMatcher.Matches())
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Postal postcode must contain only numbers'));
        }
        if(theLead.PostalCode != null && theLead.PostalCode != '' && theLead.PostalCode.length() > 4)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Postcode must be no more than 4 digits'));
        if(theLead.AU_Postal_Postcode__c != null && theLead.AU_Postal_Postcode__c != '' && theLead.AU_Postal_Postcode__c.length() > 4)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Postal postcode must be no more than 4 digits'));
        if(!SuburbPostcodeValidation.validate(theLead.City, theLead.PostalCode))
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Incorrect suburb and postcode'));
        if(!SuburbPostcodeValidation.validate(theLead.AU_Postal_City__c, theLead.AU_Postal_Postcode__c))
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Incorrect postal suburb and postcode'));
        if(theLead.Phone == null || theLead.Phone == '')
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Required field missing : Telephone'));
        else
        { 
            Matcher patternMatcher = isnumbers.matcher(theLead.Phone);
            
            if(!patternMatcher.Matches())
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Telephone must contain only numbers'));
                
            if(theLead.Phone.length() != 10)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Telephone number must be 10 digits'));
        }
        if(theLead.MobilePhone != null && theLead.MobilePhone != '')
        { 
            Matcher patternMatcher = isnumbers.matcher(theLead.MobilePhone);
            
            if(!patternMatcher.Matches())
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Mobile Phone must contain only numbers'));
                
            if(theLead.MobilePhone.length() != 10)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Mobile Phone must be 10 digits'));
        }
        if(theLead.Email == null || theLead.Email == '')
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Required field missing : Email'));
        if(theLead.Email != null && theLead.Email != '' && theLead.Email.length() > 40)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Email must not be more than 40 characters'));
            
        if(expiryDate != null && expiryDate != '')
        {
            try
            {
                String[] arr = expiryDate.split('/');
                theLead.AU_Expiry_Date__c = Date.newInstance(Integer.valueOf(arr[2]), Integer.valueOf(arr[1]), Integer.valueOf(arr[0]));
                
                if(theLead.AU_Expiry_Date__c < Date.today())
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Driver licence expired'));
                    theLead.AU_Expiry_Date__c = null;
                }
            }
            catch(Exception e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Driver licence expiry : Invalid date'));
            }
            
        }
        else
            theLead.AU_Expiry_Date__c = null;
            
        if(dob != null && dob != '')
        {
            try
            {
                String[] arr = dob.split('/');
                theLead.AU_Date_Of_Birth__c = Date.newInstance(Integer.valueOf(arr[2]), Integer.valueOf(arr[1]), Integer.valueOf(arr[0]));
                
                if(theLead.AU_Date_Of_Birth__c.addYears(18) > Date.today())
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Date of birth : Invalid'));
                    theLead.AU_Date_Of_Birth__c = null;
                }
                
            }
            catch(Exception e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Date of birth : Invalid date'));
            }
        }
        else
            theLead.AU_Date_Of_Birth__c = null;
                 
        if(theLead.AU_Employer_Phone__c != null && theLead.AU_Employer_Phone__c != '')
        {
            Matcher patternMatcher = isnumbers.matcher(theLead.AU_Employer_Phone__c);
            if(!patternMatcher.Matches())
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Employer telephone must contain only numbers'));
            if(theLead.AU_Employer_Phone__c.length() != 10)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Employer telephone number must be 10 digits'));
        }
            
       if(theLead.AU_Company__c == null || theLead.AU_Company__c == '')
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Required field missing : Employer'));
        
        if(empCommencement != null && empCommencement != '')
        {
            try
            {
                String[] arr = empCommencement.split('/');
                theLead.AU_Employment_Commenced__c = Date.newInstance(Integer.valueOf(arr[2]), Integer.valueOf(arr[1]), Integer.valueOf(arr[0]));
            }
            catch(Exception e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Employment commencement : Invalid date'));
            }
        }
        else
            theLead.AU_Employment_Commenced__c = null;
            
        if(ApexPages.hasMessages())
            isValid = false;
            
        if((isValid && formCompleted == 'yes') || (Test.isRunningTest() && formCompleted == 'yes'))
        {
            if(theLead.Street == null || theLead.Street == ''
                || theLead.City == null || theLead.City == ''
                || theLead.State == null || theLead.State == ''
                || theLead.Postalcode == null || theLead.Postalcode == '')
                isValid = false;
            if(theLead.AU_Postal_Address__c == null || theLead.AU_Postal_Address__c == ''
                || theLead.AU_Postal_City__c == null || theLead.AU_Postal_City__c == ''
                || theLead.AU_Postal_State__c == null || theLead.AU_Postal_State__c == ''
                || theLead.AU_Postal_Postcode__c == null || theLead.AU_Postal_Postcode__c == '')
                isValid = false;
            if(theLead.MobilePhone == null || theLead.MobilePhone == '')
                isValid = false; 
            if(theLead.AU_Drivers_Licence_No__c == null || theLead.AU_Drivers_Licence_No__c == '')
                isValid = false;  
            if(theLead.AU_Expiry_Date__c == null)
                isValid = false;
            if(theLead.AU_Date_of_Birth__c == null)
                isValid = false;
            if(theLead.AU_Company__c == null || theLead.AU_Company__c == '')
                isValid = false;
            if(theLead.AU_Title__c == null || theLead.AU_Title__c == '')
                isValid = false;
            if(theLead.AU_Employer_Phone__c == null || theLead.AU_Employer_Phone__c == '')
                isValid = false;
            if(theLead.AU_Employment_Commenced__c == null)
                isValid = false;
            if(theLead.AU_Car_Allowance__c == null)
                isValid = false;
            if(theLead.AU_Credit_Limit__c == null)
                isValid = false;      
        }
        
            
        return isValid;
            
    }
    
    // perform required field validations for Organisation
    private Boolean validateOrgFields()
    {
        Boolean isValid = true;
        
        String errorStr = '';
        
        Pattern isnumbers = Pattern.Compile('^[0-9]+$');
        
        if(theLead.FirstName == null || theLead.FirstName == '')
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Required field missing : First Name'));
        if(theLead.FirstName != null && theLead.FirstName != '' && theLead.FirstName.length() > 20)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'First Name must not be more than 20 characters'));
        if(theLead.Lastname == null || theLead.Lastname == '')
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Required field missing : Last Name'));
        if(theLead.Lastname != null && theLead.Lastname != '' && theLead.Lastname.length() > 20)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Last Name must not be more than 20 characters'));
        if(theLead.Phone == null || theLead.Phone == '')
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Required field missing : Telephone'));
        else
        { 
            Matcher patternMatcher = isnumbers.matcher(theLead.Phone);
            
            if(!patternMatcher.Matches())
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Telephone must contain only numbers'));
                
            if(theLead.Phone.length() != 10)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Telephone number must be 10 digits'));
        }
        if(theLead.MobilePhone != null && theLead.MobilePhone != '')
        { 
            Matcher patternMatcher = isnumbers.matcher(theLead.MobilePhone);
            
            if(!patternMatcher.Matches())
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Mobile must contain only numbers'));
                
            if(theLead.MobilePhone.length() != 10)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Mobile number must be 10 digits'));
        }
        if(theLead.Email == null || theLead.Email == '')
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Required field missing : Email'));
        if(theLead.Email != null && theLead.Email != '' && theLead.Email.length() > 40)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Email must not be more than 40 characters'));
        if(theLead.AU_Trading_Name__c != null && theLead.AU_Trading_Name__c != '' && theLead.AU_Trading_Name__c.length() > 26)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Trading Name must not be more than 26 characters'));
        if(theLead.AU_Account_Name__c == null || theLead.AU_Account_Name__c == '')
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Required field missing : Legal Entity Name'));
        if(theLead.AU_Account_Name__c != null && theLead.AU_Account_Name__c != '' && theLead.AU_Account_Name__c.length() > 35)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Legal Entity Name must not be more than 35 characters'));
        if(theLead.Street != null && theLead.Street != '' && theLead.Street.length() > 35)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Address line 1 must be no more than 35 characters'));
        if(theLead.AU_Postal_Address__c != null && theLead.AU_Postal_Address__c != '' && theLead.AU_Postal_Address__c.length() > 35)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Postal address line 1 must be no more than 35 characters'));
        if(theLead.City != null && theLead.City != '' && theLead.City.length() > 26)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Suburb must be no more than 26 characters'));
        if(theLead.AU_Postal_City__c != null && theLead.AU_Postal_City__c != '' && theLead.AU_Postal_City__c.length() > 26)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Postal suburb must be no more than 26 characters'));
        if(theLead.PostalCode != null && theLead.PostalCode != '')
        {
            Matcher patternMatcher = isnumbers.matcher(theLead.PostalCode);
            
            if(!patternMatcher.Matches())
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Postcode must contain only numbers'));
        }
        if(theLead.AU_Postal_Postcode__c != null && theLead.AU_Postal_Postcode__c != '')
        {
            Matcher patternMatcher = isnumbers.matcher(theLead.AU_Postal_Postcode__c);
            
            if(!patternMatcher.Matches())
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Postal postcode must contain only numbers'));
        }
        if(theLead.PostalCode != null && theLead.PostalCode != '' && theLead.PostalCode.length() > 4)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Postcode must be no more than 4 digits'));
        if(theLead.AU_Postal_Postcode__c != null && theLead.AU_Postal_Postcode__c != '' && theLead.AU_Postal_Postcode__c.length() > 4)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Postal postcode must be no more than 4 digits'));
        if(!SuburbPostcodeValidation.validate(theLead.City, theLead.PostalCode))
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Incorrect suburb and postcode'));
        if(!SuburbPostcodeValidation.validate(theLead.AU_Postal_City__c, theLead.AU_Postal_Postcode__c))
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Incorrect postal suburb and postcode'));
        if(theLead.AU_Accountants_Number__c != null && theLead.AU_Accountants_Number__c != '')
        {
            Matcher patternMatcher = isnumbers.matcher(theLead.AU_Accountants_Number__c);
            if(!patternMatcher.Matches())
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Accountant\'s Phone must contain only numbers'));
            if(theLead.AU_Accountants_Number__c.length() != 10)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Accountant\'s Phone number must be 10 digits'));
        }
        if(theLead.AU_Referee_No__c != null && theLead.AU_Referee_No__c != '')
        {
            Matcher patternMatcher = isnumbers.matcher(theLead.AU_Referee_No__c);
            if(!patternMatcher.Matches())
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Trade Reference telephone must contain only numbers'));
            if(theLead.AU_Referee_No__c.length() != 10)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Trade Reference telephone must be 10 digits'));
        }
        if(theLead.AU_Referee_No_2__c != null && theLead.AU_Referee_No_2__c != '')
        {
            Matcher patternMatcher = isnumbers.matcher(theLead.AU_Referee_No_2__c);
            if(!patternMatcher.Matches())
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Trade Reference 2 telephone must contain only numbers'));
            if(theLead.AU_Referee_No_2__c.length() != 10)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Trade Reference 2 telephone must be 10 digits'));
        }
            
        if(ApexPages.hasMessages())
            isValid = false;
                    
        if((isValid && formCompleted == 'yes') || (Test.isRunningTest() && formCompleted == 'yes'))
        {
            if(theLead.AU_Trading_Name__c == null || theLead.AU_Trading_Name__c == '')
                isValid = false;
            if(theLead.AU_ABN__c == null || theLead.AU_ABN__c == '')
                isValid = false;
            if(theLead.Years_in_Business__c == null)
                isValid = false;
            if(theLead.AU_ACN__c == null || theLead.AU_ACN__c == '')
                isValid = false;
            if(theLead.Street == null || theLead.Street == '')
                isValid = false;
            if(theLead.City == null || theLead.City == '')
                isValid = false;
            if(theLead.State == null || theLead.State == '')
                isValid = false;
            if(theLead.Postalcode == null || theLead.Postalcode == '')
                isValid = false;
            if(theLead.MobilePhone == null || theLead.MobilePhone == '')
                isValid = false;
            if(theLead.AU_Accountants_Name__c == null || theLead.AU_Accountants_Name__c == '')
                isValid = false;  
            if(theLead.AU_Accountants_Number__c == null || theLead.AU_Accountants_Number__c == '')
                isValid = false;
            if(theLead.AU_Referee__c == null || theLead.AU_Referee__c == '')
                isValid = false;
            if(theLead.AU_Referee_No__c == null || theLead.AU_Referee_No__c == '')
                isValid = false;  
            if(theLead.AU_Referee_2__c == null || theLead.AU_Referee_2__c == '')
                isValid = false;
            if(theLead.AU_Referee_No_2__c == null || theLead.AU_Referee_No_2__c == '')
                isValid = false;
            if(theLead.AU_Credit_Limit__c == null)
                isValid = false;
        
        }
        
            
        return isValid;
            
    }
    
    // returns picklist values for number of cards
    public List<SelectOption> getNumberOfCardsList()
    {
        List<SelectOption> options = new List<SelectOption>();
        
        Integer maxcards = (option == 'Individual') ? 1 : 20;
        
        for(Integer i=1;i<=maxcards;i++)
        {
            options.add(new SelectOption(''+i,''+i));
        }
        
        return options;
    }
    
    // returns picklist values for State
    public List<SelectOption> getStatesList()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('',''));
        options.add(new SelectOption('ACT','ACT'));
        options.add(new SelectOption('NSW','NSW'));
        options.add(new SelectOption('NT','NT'));
        options.add(new SelectOption('QLD','QLD'));
        options.add(new SelectOption('SA','SA'));
        options.add(new SelectOption('TAS','TAS'));
        options.add(new SelectOption('VIC','VIC'));
        options.add(new SelectOption('WA','WA'));
        
        return options;
    }    
    
    // show and set card detail fields based on card type selected
    public void displayCardDetailFields()
    {
        Integer i = Integer.valueOf(ApexPages.currentPage().getParameters().get('idx'));
        
        // if card type is blank, delete all field values
        if(cardsList[i].AU_Card_Type__c == null || cardsList[i].AU_Card_Type__c == '')
        {
            cardsList[i].AU_Drivers_Name__c = '';
            cardsList[i].AU_Vehicle_Registration__c = '';
            cardsList[i].AU_Vehicle_Make__c = '';
            cardsList[i].AU_Vehicle_Model__c = '';
            cardsList[i].AU_Cost_Centre_Code__c = '';
            cardsList[i].AU_Cost_Centre_Description__c = '';
            cardsList[i].AU_Pin_Required__c = false;
        }
        // if card type is 'Driver Only', delete all vehicle field values
        if(cardsList[i].AU_Card_Type__c == 'Driver Only')
        {
            cardsList[i].AU_Vehicle_Registration__c = '';
            cardsList[i].AU_Vehicle_Make__c = '';
            cardsList[i].AU_Vehicle_Model__c = '';
            if(option == 'Individual' && (cardsList[i].AU_Drivers_Name__c == null || cardsList[i].AU_Drivers_Name__c == ''))
                cardsList[i].AU_Drivers_Name__c = theLead.FirstName + ' ' + theLead.LastName;
        }
        // if card type is 'Vehicle Only', delete all driver field values
        else if(cardsList[i].AU_Card_Type__c == 'Vehicle Only')
        {
            cardsList[i].AU_Drivers_Name__c = '';
        }
        else
        {
            if(option == 'Individual' && (cardsList[i].AU_Drivers_Name__c == null || cardsList[i].AU_Drivers_Name__c == ''))
                cardsList[i].AU_Drivers_Name__c = theLead.FirstName + ' ' + theLead.LastName;
        }
    }
    
    // show cards based on number of cards selected
    public void createCards()
    {
        // to retain entered card details
        if(theLead.AU_Total_Cards_Required__c > cardsList.size())
        {
            for(Integer i=cardsList.size();i < theLead.AU_Total_Cards_Required__c; i++)
            {
                AU_Card_Details__c cardDetail = new AU_Card_Details__c();
                cardsList.add(cardDetail);
            }
        }
        else
        {
            for(Integer i=cardsList.size()-1;i >= theLead.AU_Total_Cards_Required__c; i--)
                cardsList.remove(i);
        }
        
        if(option == 'Organisation')
        {
            if(theLead.AU_Business_Trading_Name__c == null || theLead.AU_Business_Trading_Name__c == '')
            {
                if(theLead.AU_Trading_Name__c != null && theLead.AU_Trading_Name__c != '')
                    theLead.AU_Business_Trading_Name__c = theLead.AU_Trading_Name__c;
                else
                    theLead.AU_Business_Trading_Name__c = theLead.AU_Account_Name__c;
            }
        }
    }
    
    // perform required field validations for card details
    private Boolean validateCardFields()
    {
        Boolean isValid = true;
        
        if(option != 'Individual' && (theLead.AU_Business_Trading_Name__c == null || theLead.AU_Business_Trading_Name__c == ''))
            isValid = false;
        
        else
        {
            if(theLead.AU_Total_Cards_Required__c > 0)
            {
                for(AU_Card_Details__c cardDetail : cardsList)
                {
                    if(isValid)
                    {
                        if(cardDetail.AU_Card_Type__c == null || cardDetail.AU_Card_Type__c == '')
                            isValid = false;
                        else
                        {
                            if(cardDetail.AU_Card_Type__c == 'Driver & Vehicle')
                            {
                                if(cardDetail.AU_Drivers_Name__c == null || cardDetail.AU_Drivers_Name__c == '')
                                    isValid = false;
                                else if(cardDetail.AU_Vehicle_Registration__c == null || cardDetail.AU_Vehicle_Registration__c == '')
                                    isValid = false;
                                else if(cardDetail.AU_Vehicle_Model__c == null || cardDetail.AU_Vehicle_Model__c == '')
                                    isValid = false;
                                else if(cardDetail.AU_Vehicle_Make__c == null || cardDetail.AU_Vehicle_Make__c == '')
                                    isValid = false;
                                else if(option != 'Individual' && (cardDetail.AU_Cost_Centre_Code__c == null || cardDetail.AU_Cost_Centre_Code__c == ''))
                                    isValid = false;
                                else if(option != 'Individual' && (cardDetail.AU_Cost_Centre_Description__c == null || cardDetail.AU_Cost_Centre_Description__c == ''))
                                    isValid = false;
                            }
                            else if(cardDetail.AU_Card_Type__c == 'Driver Only')
                            {
                                if(cardDetail.AU_Drivers_Name__c == null || cardDetail.AU_Drivers_Name__c == '')
                                    isValid = false;
                                else if(option != 'Individual' && (cardDetail.AU_Cost_Centre_Code__c == null || cardDetail.AU_Cost_Centre_Code__c == ''))
                                    isValid = false;
                                else if(option != 'Individual' && (cardDetail.AU_Cost_Centre_Description__c == null || cardDetail.AU_Cost_Centre_Description__c == ''))
                                    isValid = false;
                            }
                            else if(cardDetail.AU_Card_Type__c == 'Vehicle Only')
                            {
                                if(cardDetail.AU_Vehicle_Registration__c == null || cardDetail.AU_Vehicle_Registration__c == '')
                                    isValid = false;
                                else if(cardDetail.AU_Vehicle_Model__c == null || cardDetail.AU_Vehicle_Model__c == '')
                                    isValid = false;
                                else if(cardDetail.AU_Vehicle_Make__c == null || cardDetail.AU_Vehicle_Make__c == '')
                                    isValid = false;
                                else if(option != 'Individual' && (cardDetail.AU_Cost_Centre_Code__c == null || cardDetail.AU_Cost_Centre_Code__c == ''))
                                    isValid = false;
                                else if(option != 'Individual' && (cardDetail.AU_Cost_Centre_Description__c == null || cardDetail.AU_Cost_Centre_Description__c == ''))
                                    isValid = false;
                            }
                        }
                    }
                }
            }
            else
                isValid = false;
        }
            
        return isValid;
    }
    
    // redirect to PaymentOptions page
    public PageReference gotoPaymentOptions()
    {
        PageReference pg = Page.PaymentOptions;
        pg.setRedirect(false);
        return pg;
    }
    
    // redirect to Card Options page
    public PageReference gotoCardOptions()
    {
        PageReference pg = Page.CardOptions;
        pg.setRedirect(false);
        return pg;
    }
    
    // redirect to Confirmation page
    public PageReference redirectToConfirmation()
    {
        PageReference pg = Page.MotorpassConfirmation;
        pg.setRedirect(false);
        return pg;
    }
    
    // redirect to Your details page
    public PageReference gotoYourDetails()
    {
        PageReference pg;
        if(option == 'Individual')
            pg = Page.IndividualDetails;
         else
            pg = Page.OrganisationDetails;
        pg.setRedirect(false);
        return pg;
    }
    
    
    // redirect to Direct Debit Information page
    public PageReference redirectToDirectDebit()
    {       
        PageReference pg = Page.DirectDebitInformation;
        pg.setRedirect(false);
        return pg;
    }
    
    // redirect to previous page from Confirmation
    public PageReference gotoRedirectedPage()
    {
        if(redirectedFrom != null && redirectedFrom != '')
        {
            PageReference pg = new PageReference('/apex/'+redirectedFrom);
            pg.setRedirect(false);
            return pg;
        }
        else
            return NULL;        
    }
    
    // redirect to Start Page
    public PageReference gotoStartPage()
    {
        PageReference pg = Page.MotorPassForm;
        pg.setRedirect(false);
        return pg;
    }
    
    private void resetDirectDebitFields()
    {
        theLead.AU_Terms_and_Conditions__c = false;
        theLead.Bank_account_name__c = null;
        theLead.AU_Account_No__c = null;
        theLead.AU_BSB__c = null;
        theLead.AU_Financial_Institution__c = null;
        theLead.AU_Financial_Institution_Address__c = null;
        theLead.AU_Financial_Institution_Suburb__c = null;
        theLead.AU_Financial_Institution_State__c = null;
        theLead.AU_Financial_Postcode_Address__c = null;
    }
    
    // returns picklist values for Frequency of debit
    public List<SelectOption> getfrequencyList()
    {
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult = Lead.Frequancy__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        options.add(new SelectOption('', '-- None --'));
        
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }    
                
        return options;
    }
    
    // returns labels and values for Full time and Part time radio buttons
    public List<SelectOption> getFull_Part_TimeList()
    {
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('Full Time', 'Full-time'));
        options.add(new SelectOption('Part Time', 'Part-time'));
                
        return options;
    }
    
    // performs field validations on Direct debit Information page
    private Boolean validateReqdFieldsForDirectDebit()
    {
        Boolean isValid = true;
        
        String errorStr = '';
        
        Pattern isnumbers = Pattern.Compile('^[0-9]+$');
        
         if(theLead.AU_BSB__c !=null)
         {
           String bsbEntered=theLead.AU_BSB__c;
           if(Database.countQuery('Select count() from BSB__c where  BSB__c =: bsbEntered ')==0)
           {    
                if(saveForm=='no')
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter a valid BSB'));
                else if(saveForm=='yes')
                    {
                        theLead.BSB_Invalid__c=true;
                    }
           }
         }   
    
        if(!theLead.AU_Terms_and_Conditions__c)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please accept Terms and Conditions'));
            
        if(option == 'Individual')
        {
            if(theLead.FirstName == null || theLead.FirstName == '')
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Required field missing : Given name'));
            if(theLead.LastName == null || theLead.Lastname == '')
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Required field missing : Surname'));
        }
        if(option == 'Organisation')
        {
            if(theLead.AU_Account_Name__c == null || theLead.AU_Account_Name__c == '')
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Required field missing : Company'));
            if(theLead.AU_ABN__c == null || theLead.AU_ABN__c == '')
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Required field missing : ABN/ARBN'));
        }
         if(theLead.Bank_account_name__c != null && theLead.Bank_account_name__c != '' && theLead.Bank_account_name__c.length() > 32)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Account name must be no more than 32 characters'));
        
        if(theLead.AU_Financial_Institution_Address__c != null && theLead.AU_Financial_Institution_Address__c != '' && theLead.AU_Financial_Institution_Address__c.length() > 35)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Address line 1 must be no more than 35 characters'));
        if(theLead.AU_Financial_Institution_Suburb__c != null && theLead.AU_Financial_Institution_Suburb__c != '' && theLead.AU_Financial_Institution_Suburb__c.length() > 26)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Suburb must be no more than 26 characters'));
        if(theLead.AU_Financial_Postcode_Address__c != null && theLead.AU_Financial_Postcode_Address__c != '')
        {
            Matcher patternMatcher = isnumbers.matcher(theLead.AU_Financial_Postcode_Address__c);
            
            if(!patternMatcher.Matches())
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Postcode must contain only numbers'));
        }
        if(theLead.AU_Financial_Postcode_Address__c != null && theLead.AU_Financial_Postcode_Address__c != '' && theLead.AU_Financial_Postcode_Address__c.length() > 4)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Postcode must be no more than 4 digits'));
        if(!SuburbPostcodeValidation.validate(theLead.AU_Financial_Institution_Suburb__c, theLead.AU_Financial_Postcode_Address__c))
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Incorrect suburb and postcode'));
            
        if(ApexPages.hasMessages())
            isValid = false;
            
        if((isValid && formCompleted == 'yes') || (Test.isRunningTest() && formCompleted == 'yes'))
        {
            if(theLead.Frequancy__c == null || theLead.Frequancy__c == '')
                isValid = false;
            else if(theLead.Bank_account_name__c == null || theLead.Bank_account_name__c == '')
                isValid = false;
            else if(theLead.AU_Financial_Institution__c == null || theLead.AU_Financial_Institution__c == '')
                isValid = false;
            else if(theLead.AU_Financial_Institution_Address__c == null || theLead.AU_Financial_Institution_Address__c == ''
                    || theLead.AU_Financial_Institution_Suburb__c == null || theLead.AU_Financial_Institution_Suburb__c == ''
                    || theLead.AU_Financial_Institution_State__c == null || theLead.AU_Financial_Institution_State__c == ''
                    || theLead.AU_Financial_Postcode_Address__c == null || theLead.AU_Financial_Postcode_Address__c == '')
                    isValid = false;
            else if(theLead.AU_BSB__c == null || theLead.AU_BSB__c == '')
                isValid = false;
            else if(theLead.AU_Account_No__c == null || theLead.AU_Account_No__c == '')
                isValid = false;
        }
            
        return isValid;
    }
    
    // performs field validations on Direct Debit Information page
    public PageReference validateDirectDebit()
    {
        populateAdd();
        if(validateReqdFieldsForDirectDebit())
            return redirectToConfirmation();
        return NULl;
    }
    
    // performs field validations on Confirmation page
    private Boolean validateReqdFields()
    {    
        Boolean isValid = true;
        
        if(!theLead.AU_Privacy__c)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Information Privacy'));
        if(!theLead.AU_Purpose_of_Credit__c)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Purpose of Credit'));
        if(!theLead.AU_Legal_Relationship__c)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Legal relationship'));
        
        if(ApexPages.hasMessages())
            isValid = false;
        
        return isValid; 
            
    }
    
    // invoked on form submission
    public PageReference submit()
    {
        // verify if captcha is correct
        if(Test.isRunningTest() || objRecaptchaController.verify())
        {
            if(!validateReqdFields())
                return NULL;
                
            Savepoint sp;
            try
            {
                sp = Database.setSavepoint();
                theLead = theLead.clone(false,true);
                
                system.debug('check' + theLead.Salutation);
                
                // set company for Lead - company is a required field on Lead
                if(option == 'Individual' && theLead.AU_Company__c != null && theLead.AU_Company__c != '')
                    theLead.Company = theLead.AU_Company__c;                
                else if(option == 'Organisation' && theLead.AU_Account_Name__c != null && theLead.AU_Account_Name__c != '')
                    theLead.Company = theLead.AU_Account_Name__c;
                else
                    theLead.Company = 'Unknown';
         
                if(theLead.AU_Trading_Name__c != null && theLead.AU_Trading_Name__c != '')
                    theLead.AU_Business_Trading_Name__c = theLead.AU_Trading_Name__c;
                else
                    theLead.AU_Business_Trading_Name__c = theLead.AU_Account_Name__c;
                    
                if(full_part_Time == 'Full Time')
                    theLead.AU_Full_Time__c = true;
                else if(full_part_Time == 'Part Time')
                    theLead.AU_Part_Time__c = true;
                
                if(theLead.AU_Payment_Option__c != 'Direct Debit')
                    resetDirectDebitFields();
                    
                // set lead status
                formCompleted = 'yes';
                
                Boolean isValid = false;
                if(option == 'Individual') 
                    isValid = validateIndividualFields();
                else
                    isValid = validateOrgFields();
                    
                if(isValid)
                {
                    isValid = validateCardFields();
                    
                    if(isValid && theLead.AU_Payment_Option__c == 'Direct Debit')
                        isValid = validateReqdFieldsForDirectDebit();
                }
                //If the BSB is invalid then the Lead status is set "in Progress"
                if(theLead.AU_Payment_Option__c == 'Direct Debit' && theLead.BSB_Invalid__c==true)
                    isValid=false;
                    
                if(theLead.AU_Payment_Option__c == null || theLead.AU_Payment_Option__c == '')
                    isValid = false;
                
                if(isValid)
                    theLead.Status = 'Open';
                else
                    theLead.Status = 'In Progress';
                        
                theLead.AU_Sales_Channel__c = 'Internet SF';
                
                // set Product name
                if(theLead.AU_Card_Type__c == 'Motorpass')
                    theLead.Product_Name__c = 'SM';
                else if(theLead.AU_Card_Type__c == 'Motorpass Diesel')
                    theLead.Product_Name__c = 'DC';
                else
                    theLead.Product_Name__c = 'MC';
                    
                theLead.AU_Number_of_Cards__c = numberOfCards;
                
                // use active assignment rule on lead
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.assignmentRuleHeader.useDefaultRule= true;
                theLead.setOptions(dmo);
                
                // create lead
                insert theLead;
                system.debug('check here ' + theLead.Salutation);
                
                // insert card details
                for(AU_Card_Details__c cardDetail : cardsList)
                {                   
                    // associate card details with lead
                    cardDetail.Lead__c = theLead.Id;
                }
                
                insert cardsList;
                system.debug('check now ' + theLead.Salutation);
                // redirect to Thank you page
                PageReference pg = Page.MotorpassThankYou;
                pg.setRedirect(true);
                pg.getParameters().put('brand',brand);
                system.debug('check final ' + theLead.Salutation);
                return pg;
            }   
            catch(Exception e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
                Database.rollback(sp);
            }   
        }
        // require user to re-enter captcha if incorrect
        else
            captchaError = 'Please re-enter captcha';
            
        return NULL;
    }
    
    
    private static testmethod void testIndividual()
    {
        Postcode__c postcode = new Postcode__c(Suburb__c = 'city', Postcode__c = '8888');
        insert postcode;
        
        PageReference pg = Page.MotorpassForm;
        Test.setCurrentPage(pg);
        
        pg.getParameters().put('brand','Motorpass');
        
        Ctrl_MotorpassForm controller = new Ctrl_MotorpassForm();
        controller.opt1 = 'Individual';
        controller.showMotorPass();
        controller.opt2 = 'Motorpass';
        controller.redirectToForm();
        controller.theLead.Salutation = 'Mr';
        controller.theLead.FirstName = 'Test';
        controller.theLead.LastName = 'Test';
        controller.theLead.Middle_Name__c = 'test';
        controller.theLead.Street = 'street';
        controller.theLead.City = 'city';
        controller.theLead.State = 'VIC';
        controller.theLead.Postalcode = '8888';
        controller.copyAddress = true;
        controller.theLead.Phone = '1234567890';
        controller.theLead.MobilePhone = '1234567890';
        controller.theLead.Email = 'xyz@wrightexpress.com';
        controller.theLead.AU_Drivers_Licence_No__c = 'Test';
        controller.expiryDate = '01/10/' + String.valueOf(Date.today().year()+1);
        controller.dob = '01/07/1989';
        controller.theLead.AU_Company__c = 'Company';
        controller.theLead.AU_Title__c = 'title';
        controller.theLead.AU_Employer_Phone__c = '1234567890';
        controller.empCommencement = '01/07/2013';
        controller.getFull_Part_TimeList();
        controller.full_part_Time = 'Full Time';
        controller.theLead.AU_Car_Allowance__c = 500;
        controller.theLead.AU_Credit_Limit__c = 200;
        
        controller.formCompleted = 'yes';
        controller.validateLeadFields();
        
        controller.getNumberOfCardsList();
        controller.theLead.AU_Business_Trading_Name__c = 'test';
        controller.numberOfCards = '3';
        controller.createCards();
        controller.cardsList[0].AU_Card_Type__c = 'Driver & Vehicle';
        pg.getParameters().put('idx','0');
        controller.displayCardDetailFields();
        controller.cardsList[0].AU_Drivers_Name__c = 'test';
        controller.cardsList[0].AU_Vehicle_Registration__c = 'test';
        controller.cardsList[0].AU_Vehicle_Make__c = 'test';
        controller.cardsList[0].AU_Vehicle_Model__c = 'test';
        controller.cardsList[0].AU_Cost_Centre_Code__c = 'test';
        controller.cardsList[0].AU_Cost_Centre_Description__c = 'test';
        
        controller.cardsList[1].AU_Card_Type__c = 'Driver Only';
        pg.getParameters().put('idx','1');
        controller.displayCardDetailFields();
        controller.cardsList[1].AU_Drivers_Name__c = 'test';
        controller.cardsList[1].AU_Cost_Centre_Code__c = 'test';
        controller.cardsList[1].AU_Cost_Centre_Description__c = 'test';
        
        controller.cardsList[2].AU_Card_Type__c = 'Vehicle Only';
        pg.getParameters().put('idx','2');
        controller.displayCardDetailFields();
        controller.cardsList[2].AU_Vehicle_Registration__c = 'test';
        controller.cardsList[2].AU_Vehicle_Make__c = 'test';
        controller.cardsList[2].AU_Vehicle_Model__c = 'test';
        controller.cardsList[2].AU_Cost_Centre_Code__c = 'test';
        controller.cardsList[2].AU_Cost_Centre_Description__c = 'test';
        
        controller.validateCardFields();
        
        controller.redirectToDirectDebit();
        controller.getfrequencyList();
        controller.formCompleted = 'yes';
        controller.theLead.Frequancy__c = 'Weekly';
        controller.theLead.AU_Terms_and_Conditions__c = true;
        controller.theLead.AU_Financial_Institution__c = 'test';
        controller.theLead.AU_Financial_Institution_Address__c = 'test';
        controller.theLead.AU_Financial_Institution_State__c = 'VIC';
        controller.theLead.AU_Financial_Institution_Suburb__c = 'city';
        controller.theLead.AU_Financial_Postcode_Address__c = '8888';
        controller.theLead.AU_Account_Name__c = 'test';
        controller.theLead.AU_BSB__c = '456789';
        controller.theLead.AU_Account_No__c = '123';
        controller.validateDirectDebit();
        
        controller.theLead.LeadSource = 'Advertisement';
        controller.theLead.AU_Privacy__c = true;
        controller.theLead.AU_Legal_Relationship__c = true;
        controller.theLead.AU_Purpose_of_Credit__c = true;
        
        controller.submit();
        
    }
    
    private static testmethod void testIndividualValidations()
    {
        
        PageReference pg = Page.IndividualDetails;
        Test.setCurrentPage(pg);
        
        pg.getParameters().put('brand','Motorpass');
        
        Ctrl_MotorpassForm controller = new Ctrl_MotorpassForm();
        controller.opt1 = 'Individual';
        controller.showMotorPass();
        controller.opt2 = 'Motorpass';
        controller.redirectToForm();
        controller.getStatesList();
        controller.formCompleted = 'yes';
        controller.theLead.city = 'test';
        controller.theLead.postalcode = '7777';
        controller.theLead.AU_Postal_City__c = 'test';
        controller.theLead.AU_Postal_Postcode__c = '7777';
        controller.validateLeadFields();
        
        controller.theLead.FirstName = 'Test12345678901234567';
        controller.theLead.LastName = 'Test12345678901234567';
        controller.theLead.Phone = '7263723';
        controller.theLead.Street = '1234567890123456789012345678901234567890';
        controller.theLead.City = '1234567890123456789012345678901234567890';
        controller.theLead.AU_Postal_Address__c = '1234567890123456789012345678901234567890';
        controller.theLead.AU_Postal_City__c = '1234567890123456789012345678901234567890';
        controller.theLead.AU_Postal_Postcode__c = 'testString';
        controller.theLead.PostalCode = 'testString';
        controller.theLead.MobilePhone = '7263723';
        controller.theLead.AU_Employer_Phone__c = '7263723';
        controller.theLead.Email = '1234567890123456789012345678901@testing.com';
        controller.expiryDate = 'test';
        controller.dob = 'test';
        controller.empCommencement = 'test';
        controller.validateLeadFields();
        
        pg = Page.IndividualDetails;
        Test.setCurrentPage(pg);
        
        pg.getParameters().put('opt','Individual');
        pg.getParameters().put('motorpass','Motorpass');
        
        controller = new Ctrl_MotorpassForm();
        controller.formCompleted = 'yes';
        controller.theLead.FirstName = 'Test';
        controller.theLead.LastName = 'Test';
        controller.theLead.Phone = '1234567890';
        controller.theLead.Email = 'test@testing.com';
        controller.theLead.AU_Company__c = 'Company';
        controller.validateLeadFields();
        
        controller.expiryDate = '01/07/' + String.valueOf(Date.today().year()-1);
        controller.dob = '01/07/' + String.valueOf(Date.today().year());
        controller.validateLeadFields();
        
        controller.gotoPaymentOptions();
        
        controller.redirectToDirectDebit();
        
        controller.formCompleted = 'yes';
        controller.validateDirectDebit();
        controller.theLead.AU_Terms_and_Conditions__c = true;
        controller.validateDirectDebit();
        controller.option = 'Individual';
        controller.theLead.FirstName = '';
        controller.theLead.LastName = '';
        controller.validateDirectDebit();
        controller.option = 'Organisation';
        controller.theLead.AU_Account_Name__c = '';
        controller.theLead.AU_ABN__c = '';
        controller.validateDirectDebit();
        controller.theLead.AU_Financial_Institution_Suburb__c = 'city';
        controller.theLead.AU_Financial_Postcode_Address__c = '8888';
        controller.validateDirectDebit();
        
        pg = Page.IndividualDetails;
        Test.setCurrentPage(pg);
        
        pg.getParameters().put('opt','Individual');
        pg.getParameters().put('motorpass','Motorpass');
        
        controller = new Ctrl_MotorpassForm();
        
        controller.formCompleted = 'yes';
        controller.theLead.AU_Account_Name__c = 'company';
        controller.theLead.AU_ABN__c = '123';
        controller.theLead.AU_Financial_Institution_Suburb__c = '';
        controller.theLead.AU_Financial_Postcode_Address__c = '';
        controller.validateDirectDebit();
        
        controller.theLead.Frequancy__c = 'Weekly';
        controller.theLead.AU_Financial_Institution__c = 'test';
        controller.theLead.Street = '';
        controller.theLead.Street = 'test';
        controller.theLead.AU_Financial_Institution_Address__c = 'test';
        controller.theLead.AU_Financial_Institution_State__c = 'VIC';
        controller.theLead.AU_Financial_Institution_Suburb__c = 'city';
        controller.theLead.AU_Financial_Postcode_Address__c = '8888';
        controller.theLead.AU_Account_Name__c = 'test';
        controller.theLead.AU_BSB__c = '123';
        controller.theLead.AU_Account_No__c = '123';
        controller.validateDirectDebit();
        
        controller.theLead.AU_Financial_Institution_Address__c = '1234567890123456789012345678901234567890';
        controller.theLead.AU_Financial_Institution_Suburb__c = '1234567890123456789012345678901234567890';
        controller.theLead.AU_Financial_Postcode_Address__c = 'safasdfds';
        
        
        
        controller.getobjRecaptchaController();
        controller.setobjRecaptchaController(null);
        controller.getobjCallbackController();
        controller.setobjCallbackController(null);
        controller.getThis();
        
    }
    
    private static testmethod void testOrganisation()
    {
        
        Postcode__c postcode = new Postcode__c(Suburb__c = 'city', Postcode__c = '8888');
        insert postcode;
        
        PageReference pg = Page.OrganisationDetails;
        Test.setCurrentPage(pg);
        
        pg.getParameters().put('brand','Motorpass');
        
        Ctrl_MotorpassForm controller = new Ctrl_MotorpassForm();
        controller.opt1 = 'Organisation';
        controller.showMotorPass();
        controller.opt2 = 'Motorpass Diesel';
        controller.redirectToForm();
        controller.theLead.AU_Trading_Name__c = 'Company';
        controller.theLead.AU_Account_Name__c = 'Testing';
        controller.theLead.AU_Trustee__c = 'test';
        controller.theLead.AU_Business_Type__c = 'test';
        controller.theLead.AU_ABN__c = '123';
        controller.theLead.Years_in_Business__c = 2;
        controller.theLead.AU_ACN__c = '123';
        controller.theLead.Street = 'street';
        controller.theLead.City = 'city';
        controller.theLead.State = 'VIC';
        controller.theLead.Postalcode = '8888';
        controller.copyAddress = true;
        controller.theLead.FirstName = 'test';
        controller.theLead.LastName = 'test';
        controller.theLead.Industry = 'Communications';
        controller.theLead.Phone = '1234567890';
        controller.theLead.MobilePhone = '1234567890';
        controller.theLead.Email = 'xyz@wrightexpress.com';
        controller.numberOfCards = '3';
        controller.theLead.AU_Number_of_Vehicles__c = 2;
        controller.theLead.AU_Accountants_Name__c = 'test';
        controller.theLead.AU_Accountants_Number__c = '1234567890';
        controller.theLead.AU_Referee__c = 'test';
        controller.theLead.AU_Referee_No__c = '1234567890';
        controller.theLead.AU_Referee_2__c = 'test';
        controller.theLead.AU_Referee_No_2__c = '1234567890';
        controller.theLead.AU_Credit_Limit__c = 200;
        
        controller.formCompleted = 'yes';
        controller.validateLeadFields();
        
        controller.getNumberOfCardsList();
        controller.numberOfCards = '3';
        controller.theLead.AU_Business_Trading_Name__c = 'test';
        controller.createCards();
        controller.cardsList[0].AU_Card_Type__c = 'Driver & Vehicle';
        pg.getParameters().put('idx','0');
        controller.displayCardDetailFields();
        controller.cardsList[0].AU_Drivers_Name__c = 'test';
        controller.cardsList[0].AU_Vehicle_Registration__c = 'test';
        controller.cardsList[0].AU_Vehicle_Make__c = 'test';
        controller.cardsList[0].AU_Vehicle_Model__c = 'test';
        controller.cardsList[0].AU_Cost_Centre_Code__c = 'test';
        controller.cardsList[0].AU_Cost_Centre_Description__c = 'test';
        
        controller.cardsList[1].AU_Card_Type__c = 'Driver Only';
        pg.getParameters().put('idx','1');
        controller.displayCardDetailFields();
        controller.cardsList[1].AU_Drivers_Name__c = 'test';
        controller.cardsList[1].AU_Cost_Centre_Code__c = 'test';
        controller.cardsList[1].AU_Cost_Centre_Description__c = 'test';
        
        controller.cardsList[2].AU_Card_Type__c = 'Vehicle Only';
        pg.getParameters().put('idx','2');
        controller.displayCardDetailFields();
        controller.cardsList[2].AU_Vehicle_Registration__c = 'test';
        controller.cardsList[2].AU_Vehicle_Make__c = 'test';
        controller.cardsList[2].AU_Vehicle_Model__c = 'test';
        controller.cardsList[2].AU_Cost_Centre_Code__c = 'test';
        controller.cardsList[2].AU_Cost_Centre_Description__c = 'test';
        
        controller.validateCardFields();
        
        controller.redirectToDirectDebit();
        controller.getfrequencyList();
        controller.formCompleted = 'yes';
        controller.theLead.Frequancy__c = 'Weekly';
        controller.theLead.AU_Terms_and_Conditions__c = true;
        controller.theLead.AU_Financial_Institution__c = 'test';
        controller.theLead.AU_Financial_Institution_Address__c = 'test';
        controller.theLead.AU_Financial_Institution_State__c = 'VIC';
        controller.theLead.AU_Financial_Institution_Suburb__c = 'city';
        controller.theLead.AU_Financial_Postcode_Address__c = '8888';
        controller.theLead.AU_Account_Name__c = 'test';
        controller.theLead.AU_BSB__c = '123';
        controller.theLead.AU_Account_No__c = '123';
        controller.validateDirectDebit();
        
        controller.theLead.LeadSource = 'Advertisement';
        controller.theLead.AU_Privacy__c = true;
        controller.theLead.AU_Legal_Relationship__c = true;
        controller.theLead.AU_Purpose_of_Credit__c = true;
        
        controller.submit();
        
    }
   
    private static testmethod void testOrganisationValidations()
    {
        Postcode__c postcode = new Postcode__c(Suburb__c = 'city', Postcode__c = '8888');
        insert postcode;
        BSB__c newBsb = new BSB__c();
        newBsb.BSB__c='456789';
        newBsb.Name='Test';
        newBsB.Financial_Institution__c='test';
        newBsB.AU_Financial_Institution_Address__c='test';
        newBsB.Financial_Institution_City__c='city';
        newBsB.Financial_Institution_Postcode__c='8888';
        newBsB.AU_Financial_Institution_State__c='VIC';
        
        insert newBsb;
        
        
        PageReference pg = Page.OrganisationDetails;
        Test.setCurrentPage(pg);
        
        pg.getParameters().put('brand','Motorcharge');
        
        Ctrl_MotorpassForm controller = new Ctrl_MotorpassForm();
        controller.opt1 = 'Organisation';
        controller.showMotorPass();
        controller.redirectToForm();
        
        controller.formCompleted = 'yes';
        controller.theLead.city = 'test';
        controller.theLead.postalcode = '7777';
        controller.theLead.AU_Postal_City__c = 'test';
        controller.theLead.AU_Postal_Postcode__c = '7777';
        controller.validateLeadFields();
        
        controller.theLead.FirstName = 'Test12345678901234567';
        controller.theLead.LastName = 'Test12345678901234567';
        controller.theLead.Phone = '7263723';
        controller.theLead.Street = '1234567890123456789012345678901234567890';
        controller.theLead.City = '1234567890123456789012345678901234567890';
        controller.theLead.AU_Postal_Address__c = '1234567890123456789012345678901234567890';
        controller.theLead.AU_Postal_City__c = '1234567890123456789012345678901234567890';
        controller.theLead.AU_Postal_Postcode__c = 'testString';
        controller.theLead.PostalCode = 'testString';
        controller.theLead.MobilePhone = '7263723';
        controller.theLead.AU_Employer_Phone__c = '7263723';
        controller.theLead.Email = '1234567890123456789012345678901@testing.com';
        controller.theLead.AU_Trading_Name__c = '123456789012345678901234567890';
        controller.theLead.AU_Account_Name__c = '1234567890123456789012345678901234567890';
        controller.theLead.AU_Accountants_Number__c = '7263723';
        controller.theLead.AU_Referee_No__c = '7263723';
        controller.theLead.AU_Referee_No_2__c = '7263723';
        controller.validateLeadFields();
        
        pg = Page.OrganisationDetails;
        Test.setCurrentPage(pg);
        
        pg.getParameters().put('opt','Organisation');
        pg.getParameters().put('motorpass','Motorpass Diesel');
                
        controller = new Ctrl_MotorpassForm();
        controller.formCompleted = 'yes';
        
        controller.theLead.FirstName = 'Test';
        controller.theLead.LastName = 'Test';
        controller.theLead.Phone = '1234567890';
        controller.theLead.Email = 'test@testing.com';
        controller.theLead.AU_Account_Name__c = 'test';
        controller.validateLeadFields();
        
        controller.validateCardFields();
        controller.numberOfCards = '3';
        controller.createCards();
        controller.cardsList[0].AU_Card_Type__c = '';
        pg.getParameters().put('idx','0');
        controller.displayCardDetailFields();
        controller.validateCardFields();
        
        controller.theLead.AU_Business_Trading_Name__c = 'test';
        
        controller.formCompleted = 'yes';
        controller.cardsList[0].AU_Card_Type__c = 'Driver & Vehicle';
        pg.getParameters().put('idx','0');
        controller.displayCardDetailFields();
        controller.cardsList[1].AU_Card_Type__c = 'Driver Only';
        pg.getParameters().put('idx','1');
        controller.displayCardDetailFields();
        controller.cardsList[2].AU_Card_Type__c = 'Vehicle Only';
        pg.getParameters().put('idx','2');
        controller.displayCardDetailFields();
        controller.validateCardFields();
        
        controller.cardsList[0].AU_Drivers_Name__c = 'test';
        controller.validateCardFields();
        controller.cardsList[0].AU_Vehicle_Registration__c = 'test';
        controller.validateCardFields();
        controller.cardsList[0].AU_Vehicle_Model__c = 'test';
        controller.validateCardFields();
        controller.cardsList[0].AU_Vehicle_Make__c = 'test';
        controller.validateCardFields();
        controller.cardsList[0].AU_Cost_Centre_Code__c = 'test';
        controller.validateCardFields();
        controller.cardsList[0].AU_Cost_Centre_Description__c = 'test';
        controller.validateCardFields();
        
        
        controller.cardsList[1].AU_Drivers_Name__c = 'test';
        controller.validateCardFields();
        controller.cardsList[1].AU_Cost_Centre_Code__c = 'test';
        controller.validateCardFields();
        controller.cardsList[1].AU_Cost_Centre_Description__c = 'test';
        controller.validateCardFields();
        
        
        controller.cardsList[2].AU_Vehicle_Registration__c = 'test';
        controller.validateCardFields();
        controller.cardsList[2].AU_Vehicle_Model__c = 'test';
        controller.validateCardFields();
        controller.cardsList[2].AU_Vehicle_Make__c = 'test';
        controller.validateCardFields();
        controller.cardsList[2].AU_Cost_Centre_Code__c = 'test';
        controller.validateCardFields();
        controller.cardsList[2].AU_Cost_Centre_Description__c = 'test';
        controller.validateCardFields();
        
        controller.numberOfCards = '5';
        controller.createCards();
        
        controller.numberOfCards = '3';
        controller.createCards();
        
        controller.gotoPaymentOptions();
        
        controller.redirectToDirectDebit();
        
        controller.formCompleted = 'yes';
        controller.option = 'Individual';
        controller.theLead.FirstName = '';
        controller.validateDirectDebit();
        controller.theLead.FirstName = 'test';
        controller.theLead.LastName = '';
        controller.validateDirectDebit();
        controller.theLead.LastName = 'test';
        controller.option = 'Organisation';
        controller.theLead.AU_Company__c = '';
        controller.validateDirectDebit();
        controller.theLead.AU_Company__c = 'company';
        controller.theLead.AU_ABN__c = '123';
        controller.validateDirectDebit();
        controller.theLead.AU_ACN__c = '123';
        controller.validateDirectDebit();
        controller.theLead.Frequancy__c = 'Weekly';
        controller.validateDirectDebit();
        controller.theLead.AU_Terms_and_Conditions__c = true;
        controller.validateDirectDebit();
        controller.theLead.AU_Financial_Institution__c = 'test';
        controller.theLead.Street = '';
        controller.validateDirectDebit();
        controller.theLead.Street = 'test';
        controller.validateDirectDebit();
        controller.theLead.AU_Financial_Institution_Address__c = 'test';
        controller.validateDirectDebit();
        controller.theLead.AU_Financial_Institution_State__c = 'VIC';
        controller.validateDirectDebit();
        controller.theLead.AU_Financial_Institution_Suburb__c = 'city';
        controller.validateDirectDebit();       
        controller.theLead.AU_Financial_Postcode_Address__c = '8888';
        controller.validateDirectDebit();
        controller.theLead.AU_Account_Name__c = 'test';
        controller.validateDirectDebit();
        controller.theLead.AU_BSB__c = '456789';
        controller.validateDirectDebit();
        controller.theLead.AU_Account_No__c = '123';
        controller.validateDirectDebit();
      
        
        controller.gotoCardOptions();
        controller.redirectToConfirmation();
        controller.gotoYourDetails();
        controller.redirectedFrom = 'OrganisationDetails';
        controller.gotoRedirectedPage();
        controller.gotoStartPage();
        
        controller.getobjRecaptchaController();
        controller.setobjRecaptchaController(null);
        controller.getobjCallbackController();
        controller.setobjCallbackController(null);
        controller.getThis();
        
    }
}