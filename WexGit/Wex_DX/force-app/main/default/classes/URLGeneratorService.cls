global  class URLGeneratorService{
     Webservice static Boolean isValidSalesId(String SalesId, String ProgramName){
        
        if (SalesId == '' || ProgramName ==''){
            return false;
        }
        System.Debug('SalesId for the query = ' + SalesId );
        System.Debug('ProgramName for the query = ' + ProgramName);
        
        Sales_Code__c[] codes = [select Id from Sales_Code__c where name = :SalesId  and Program__r.Name = :ProgramName and status__c = 'Active'];   
        System.Debug('codes.size() = ' + codes.size());
        if (codes.size()== 0){
            return false;
        }
        
        return true;
        
    }
    @IsTest(SeeAllData=true)    
    public static void testIsValidSalesId()
    {
        //URLGeneratorService gen = new URLGeneratorService();        
        String pgm = 'Sinclair Fleet Track';
        String salesId = 'test';
        URLGeneratorService.isValidSalesId(salesId, pgm);
    }
    
     Webservice static Boolean isValidOfficeGrpCd(String OfficeGrpCd, String ProgramName){
        
        if (OfficeGrpCd == '' || ProgramName ==''){
            return false;
        }
        System.Debug('OfficeGrpCd for the query = ' + OfficeGrpCd );
        System.Debug('ProgramName for the query = ' + ProgramName);
        
        Office_Group_Code__c[] codes = [select Id from Office_Group_Code__c where name = :OfficeGrpCd and Program__r.Name = :ProgramName and status__c = 'Active'];   
        System.Debug('codes.size() = ' + codes.size());
        if (codes.size()== 0){
            return false;
        }
        
        return true;
        
    }
    
    @IsTest(SeeAllData=true)    
    public static void testIsValidOfficeGrpCd()
    {
        //URLGeneratorService gen = new URLGeneratorService();        
        String pgm = 'Sinclair Fleet Track';
        String code = 'test';
        URLGeneratorService.isValidOfficeGrpCd(code, pgm);
    }
    
    Webservice static Boolean isValidCouponCd(String couponCode, String ProgramName){
        
        if (couponCode == '' || ProgramName ==''){
            return false;
        }
        System.Debug('CouponCode for the query = ' + couponCode);
        System.Debug('ProgramName for the query = ' + ProgramName);
        
        Campaign_Program__c [] campaignPrograms = [SELECT Id FROM Campaign_Program__c where Campaign_Program__c.name = :ProgramName and Campaign__r.Coupon_Code__c = :couponCode];

        System.Debug('campaignPrograms.size() = ' + campaignPrograms.size());
        if (campaignPrograms.size()== 0){
            return false;
        }
        
        return true;
        
    }
    
    @IsTest(SeeAllData=true)    
    public static void testIsValidCouponCd()
    {
        //URLGeneratorService gen = new URLGeneratorService();        
        String pgm = 'Sinclair Fleet Track';
        String couponCode = 'A17';
        URLGeneratorService.isValidCouponCd(couponCode , pgm);
    }
    
    /*
    Webservice static Account[] getL1Accounts(String ProgramName){
    
        List <Account> accts  = new Account[]{};
        
        Account account1 = new Account();
        account1.name = 'test1';
        account1.AccountNumber = '123';

        Account account2 = new Account();
        account2.name = 'test2';
        account2.AccountNumber = '234';
        
        Account account3 = new Account();
        account3.name = 'test3';
        account3.AccountNumber = '111';

        Account account4 = new Account();
        account4.name = 'test4';
        account4.AccountNumber = '222';
                
        if (ProgramName != '') {
            if (ProgramName == 'Bosselman'){            
                accts.add( account1 );
                accts.add( account2 );
            }    
            if (ProgramName == 'Sinclair'){
                accts.add( account3 );
                accts.add( account4 );
            }
        }
        
        return accts;
    }
    */
    Webservice static Account[] getL2Accounts(String ProgramName){
        
        if (ProgramName == ''){
            return null;
        }

        System.Debug('ProgramName for the query = ' + ProgramName);
        
        List <Account> accts  = new Account[]{};
        
// test data        
        Account account1 = new Account();
        account1.name = 'test1';
        account1.AccountNumber = '123';

        Account account2 = new Account();
        account2.name = 'test2';
        account2.AccountNumber = '234';
        
        Account account3 = new Account();
        account3.name = 'test3';
        account3.AccountNumber = '111';

        Account account4 = new Account();
        account4.name = 'test4';
        account4.AccountNumber = '222';
                
        if (ProgramName == 'Bosselman'){            
            accts[0] = account1;
            accts[1] = account2;
        }    
        if (ProgramName == 'Sinclair'){
            accts[0] = account3;
            accts[1] = account4;
        }
 // end of test data section.       
        
/*        
        Sales_Code__c[] codes = [select Id from Sales_Code__c where name = :SalesId  and Program__r.Name = :ProgramName];   
        System.Debug('codes.size() = ' + codes.size());
        if (codes.size()== 0){
            return false;
        }
*/        
        return accts;
        
    }
}