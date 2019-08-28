@istest
public class EMAP_AUAppReq_TriggerHandler_Test{
   @testSetup
   static void setup(){
      UtilityTestLoader.setAutomation(false);
   }
     static testMethod void TestAuAppReq(){
            
        user US= TestDatatUtility.createUser();

        System.runAs(US){
                       
        EMAP_AUAppReq_TriggerHandler objAU= new EMAP_AUAppReq_TriggerHandler();
        
        Account Acc=TestDatatUtility.getAccount();
        insert Acc;
        
        Contact CON=TestDatatUtility.getContact();
        CON.accountId = Acc.id;
        insert CON;     
        
        EMAP_AUAppReq_TriggerHandler.AUAppAccUpdateflag = false;
        
        AU_Application_Request__c AUA = TestDatatUtility.getAUAppReq(); 
        AUA.Account__c=Acc.id;
        
        AUA.Primary_Contact__c=CON.Id;
         
        AUA.Account_Billing_Street__c ='TestAccount_Billing_Street__c ';         
        AUA.Account_Billing_City__c='TestAccount_Billing_City__c';
        AUA.Account_Billing_State__c='TestAccount_Billing_State__c';
        AUA.Account_Billing_Country__c='TestAccount_Billing_Country__c';
        AUA.Account_Billing_Zip_Code__c='23141';
        AUA.Account_Billing_Frequency__c='Bill Monthly';
        AUA.Account_Billing_Plan__c='5 days after invoice date - CHQ';
        AUA.Account_Business_Registration_Number__c='12344';
        AUA.Account_Number_of_Employees__c = '50';
		AUA.Application_Status__c = 'Credit Assessment';
        
        Test.starttest();
        insert AUA;
        
        AUA.Assess_Start_Time__c = System.Today();
        AUA.Assess_End_Time__c = System.Today() + 10;
        AUA.Application_Status__c = 'Pending EMTC';
        update AUA;

        Contact cont =TestDatatUtility.getContact();
        cont.accountId = Acc.id;
        insert cont;

        AUA.Application_Status__c = 'Hold';
        AUA.Revert_To_Status__c = '';
        AUA.Hold_Expiration_Date__c = System.today() + 10;
        AUA.Primary_Contact__c = cont.Id;
        update AUA;
        
        AUA.Hold_Expiration_Date__c = System.today() - 10;
        //AUA.Revert_To_Status__c = 'Hold';
        update AUA;
        
        EMAP_AUAppReq_TriggerHandler.AUAppAccUpdateflag = false;
        
        Acc.AU_Application_Request__c=AUA.id;
        
        update Acc;
        
        Test.stoptest();
        
        }  
     }
}