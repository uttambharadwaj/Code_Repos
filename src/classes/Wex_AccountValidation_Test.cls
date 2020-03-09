@isTest
public class Wex_AccountValidation_Test {
   
   @istest static void sameactnumber(){
       account acc = new account(name ='shelby inc',Sponsor_Acct__c = '1234567891011',BillingPostalCode = '1234',Platform__c='SIEBEL');
       insert acc;
       account act = new account(name ='shelby inc',Sponsor_Acct__c = '1234567891019',BillingPostalCode = '1236',Platform__c='Tandem');
       insert act;
       account acb = new account(name ='crosby inc',Carrier_ID__c = '123457',BillingPostalCode = '1235',Platform__c='OTR');
       insert acb;
       
        string naval = Wex_AccountValidation.validateAccountAndZip(acc.Sponsor_Acct__c ,acc.BillingPostalCode);
        system.assertEquals(naval, 'NA fleet SUCCESS');
        string navale = Wex_AccountValidation.validateAccountAndZip(act.Sponsor_Acct__c,act.BillingPostalCode);
        system.assertEquals(navale, 'NA fleet SUCCESS');
        string efval = Wex_AccountValidation.validateAccountAndZip(acb.Carrier_ID__c,acb.BillingPostalCode);
        system.assertEquals(efval, 'EFS SUCCESS');
    }
    @istest static void diffzipnumber(){
        account acc = new account(name ='shelby inc',Sponsor_Acct__c = '1234567891011',BillingPostalCode = '1234',Platform__c='SIEBEL');
        insert acc;
        account act = new account(name ='shelby inc',Sponsor_Acct__c = '1234567891019',BillingPostalCode = '1236',Platform__c='Tandem');
        insert act;
        account acb = new account(name ='crosby inc',Carrier_ID__c = '123457',BillingPostalCode = '1235',Platform__c='OTR');
        insert acb;
        string naval = Wex_AccountValidation.validateAccountAndZip(acc.Sponsor_Acct__c,'1204');
        system.assertEquals(naval, 'The Postal Code is invalid');
        string navale = Wex_AccountValidation.validateAccountAndZip(act.Sponsor_Acct__c,'1230');
        system.assertEquals(navale, 'The Postal Code is invalid');
        string efval = Wex_AccountValidation.validateAccountAndZip(acb.Sponsor_Acct__c,'1211');
        system.assertEquals(efval, 'The Postal Code is invalid');
    }
      @istest static void diffactnumber(){
        account acc = new account(name ='shelby inc',Sponsor_Acct__c = '1234567891011',BillingPostalCode = '1234',Platform__c='SIEBEL');
        insert acc;
        account act = new account(name ='shelby inc',Sponsor_Acct__c = '1234567891019',BillingPostalCode = '1236',Platform__c='Tandem');
        insert act;
        account acb = new account(name ='crosby inc',Carrier_ID__c = '123457',BillingPostalCode = '1235',Platform__c='OTR');
        insert acb;
        string naval = Wex_AccountValidation.validateAccountAndZip('1234567890000',acc.BillingPostalCode);
          system.assertEquals(naval, 'The Account Number is invalid');
         string navale = Wex_AccountValidation.validateAccountAndZip('1234567891010',act.BillingPostalCode);
          system.assertEquals(navale, 'The Account Number is invalid');
        string efval = Wex_AccountValidation.validateAccountAndZip('123000',acb.BillingPostalCode);
          system.assertEquals(efval,'The Account Number is invalid' );
    }
    @istest static void blankactnumber(){
        account acc = new account(name ='shelby inc',Sponsor_Acct__c = '1234567891011',BillingPostalCode = '1234',Platform__c='SIEBEL');
        insert acc;
        account act = new account(name ='shelby inc',Sponsor_Acct__c = '1234567891019',BillingPostalCode = '1236',Platform__c='Tandem');
        insert act;
        account acb = new account(name ='crosby inc',Carrier_ID__c = '123457',BillingPostalCode = '1235',Platform__c='OTR');
        string naval = Wex_AccountValidation.validateAccountAndZip('',acc.BillingPostalCode);
        //system.assertEquals(naval, 'The Account Number is invalid');
        string navale = Wex_AccountValidation.validateAccountAndZip('',act.BillingPostalCode);
        //system.assertEquals(navale, 'The Account Number is invalid');
        string efval = Wex_AccountValidation.validateAccountAndZip('',acb.BillingPostalCode);
        //system.assertEquals(efval, 'The Account Number is invalid');
    }
    @istest static void blankzipnumber(){
        
        string naval = Wex_AccountValidation.validateAccountAndZip('1234567891011','');
        string navale = Wex_AccountValidation.validateAccountAndZip('1234567891019','');
        string efval = Wex_AccountValidation.validateAccountAndZip('123457','');
    }
}