public with sharing class URLGeneratorController{
    List<Program__c> programList;
    List<String>programNames;
    
    public String parentProgramName { 
        								get{ 
                                        	Program__c[] pgmList = [select name from Program__c where URL_Generator_Group__c = :ApexPages.currentPage().getParameters().get('parentProgram') order by name asc];
                                            return pgmList[0].name;
                                        }
                                    }
        
    public PageReference SendEmail() {
        String env = 'test';
        System.debug('************* SendEmail');
        //Input fields from the form
        String salesId = ApexPages.currentPage().getParameters().get('salesid');       
        String couponCode = ApexPages.currentPage().getParameters().get('couponCode');
        String toAddress = ApexPages.currentPage().getParameters().get('email');
        String programName = ApexPages.currentPage().getParameters().get('program');
        String phoneNumber= ApexPages.currentPage().getParameters().get('phone');
                
        Program__c program = getProgram(programName);
               
        String FormName = program.Form_Template__c;
         
        if (programName != null){
            String tempPgm = '';
            String[] splitString = programName.split(' ');
            for(String s: splitString) {
                tempPgm = tempPgm + s;
            }
            programName = tempPgm;
        }
               
        String url = WEXHelper.getSecureSitesURL() + 'creditapplication/WexBOCA?pgm=' + program.Brand_Short_Name__c;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {toAddress };  
        String emailBody;
        
        OrgWideEmailAddress [] addr = [select Id from OrgWideEmailAddress where DisplayName = :program.Email_From_Name__c];
        
        if (addr.size() > 0){
            mail.setOrgWideEmailAddressId(addr[0].Id);
        }
        
        mail.setToAddresses(toAddresses );
        mail.setSubject(program.name + ' Application');
        
        if(salesId != null) {

            emailBody = 'Please use the link provided below to complete the ' + program.name + ' application. You will receive a confirmation email after you submit the completed application.';
            emailBody += '<br/><br/>';

            emailBody += '<a href='+ url + '&salescode=' + salesId + '&cc=' + couponCode  + '>' + url + '</a>';
            emailBody += '<br/><br/>';
   
        }
        
        if (phoneNumber != null && phoneNumber != ''){        
            emailBody += 'If you have questions, please call ' + phoneNumber+ '.';
            emailBody += '<br/><br/>';
        }                                        

        emailBody += 'Please do not reply to this email.';
        emailBody += '<br/><br/>';
        emailBody += 'Thank you.';
        emailBody += '<br/>';
        emailBody += program.name;

        mail.setHtmlBody(emailBody);    
        if(!Test.isRunningTest()){
        	Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        }
        
        PageReference p = Page.URLGeneratorConfirm;
        p.getParameters().put('parentProgram', ApexPages.currentPage().getParameters().get('parentProgram'));
        return p.setRedirect(true);
       
    } 
 
    private Program__c getProgram (String programName){
        Program__c[] programs = [select Id, name, Inside_Sales_Phone_Number__c, Email_From_Name__c, Form_Template__c, Brand_Short_Name__c from Program__c where name = :programName];   
        System.Debug('programs.size() = ' + programs.size());
        if (programs.size()== 0){
            return  null;
        }
        
        return programs[0];
    }

    public void setProgramNames (String[] programNames){
         this.programNames = programNames;
    }
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        Program__c [] programList = [select name from Program__c where URL_Generator_Group__c = :ApexPages.currentPage().getParameters().get('parentProgram') order by name asc]; 
        options.add(new SelectOption('',' -- Select -- '));   
        for (Program__c x : programList){        
            options.add(new SelectOption(x.name,x.name));         
        }
        return options;
    }
    public List<String> getProgramNames(){
        
        programNames = new List<String>();
        
        Program__c[] pgmList = [select name from Program__c where URL_Generator_Group__c = :ApexPages.currentPage().getParameters().get('parentProgram') order by name asc];
        for (Program__c pgm : pgmList){
            String nm = pgm.name.replaceAll('\'', '\\\\\'');
            programNames.add(nm);
        }
                  
        return programNames;
    }
        
}