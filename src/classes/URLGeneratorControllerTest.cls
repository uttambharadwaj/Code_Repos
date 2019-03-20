@isTest
private class URLGeneratorControllerTest{

    @IsTest(SeeAllData=true)
    public static void testURLGeneratorController() {
    
        Test.setCurrentPageReference(new PageReference('Page.URLGenerator'));
        System.currentPageReference().getParameters().put('parentProgram', 'Test');

        
        ApexPages.currentPage().getParameters().put('salesid', 'Test');       
        ApexPages.currentPage().getParameters().put('email', 'derek.gilbert@wexinc.com');
        ApexPages.currentPage().getParameters().put('emailAddr', 'derek.gilbert@wexinc.com');
        ApexPages.currentPage().getParameters().put('negFees', null);
        ApexPages.currentPage().getParameters().put('program', 'Test');
        ApexPages.currentPage().getParameters().put('officegrpcd', '1');
        ApexPages.currentPage().getParameters().put('phoneNumber', '555-555-5555');
        
        Test.startTest();
        
        Program__c pgm = new Program__c();
        
        pgm.Name = 'Test';
        pgm.URL_Generator_Group__c = 'Test';
        pgm.Inside_Sales_Phone_Number__c = '555-555-5555';
        pgm.Email_From_Name__c = 'test@test.com'; 
        pgm.Form_Template__c = 'WexBOCA';
        pgm.Email_From_Name__c = 'Test E-mailer';
        
        insert pgm;
            	  
        URLGeneratorController ugc = new URLGeneratorController();
      
        // Quick tests to ensure the functions are returning correctly..
        System.assertEquals('Test', ugc.parentProgramName);
        System.assertNotEquals(null, ugc.getProgramNames());
        System.assertNotEquals(null, ugc.getItems());
                
        ugc.SendEmail();
        
        ApexPages.currentPage().getParameters().remove('salesid');
        
        ugc.SendEmail();
        
    }

}