@istest 

public class TestDatatUtility {

    public static  Account getAccount(){
        Schema.RecordTypeInfo accRecordType = TestDatatUtility.getRecordTypeInfo('Account', 'EMAP Fuel Accounts');

        Program__c prog = new Program__c (Program_Name__c ='HK Fleet Card' );
        insert prog; 
        
        Account acc = new Account();
        acc.RecordTypeId = accRecordType.getRecordTypeId();
        acc.Name ='TestSKVABABABABABABABABABABABABABABABABABABABAB';
        acc.Trade_Name_of_Business__c ='testBusinessABABABABABABABABABABABABABABABABABABABAB';
        acc.Business_Registration_Number__c = '1234'; 
        acc.Program__c = prog.id;
        acc.Type='Prospect';
        acc.Nird__c=System.Today()-5;
        acc.AU_Business_Trading_Name__c = 'TESTACC1 AU_Business_Trading_Name';
        return acc;
    }
    
    public static List<Account> getAccountList(){
        Schema.RecordTypeInfo accRecordType = TestDatatUtility.getRecordTypeInfo('Account', 'EMAP Fuel Accounts');

        List<Account> accList = new List<Account>();
        
        for(Integer i=1; i<=250; i++){
            
            Account acc = new Account();
            acc.RecordTypeId = accRecordType.getRecordTypeId();
            acc.Name ='Test Account'+i;
            acc.Trade_Name_of_Business__c ='Test Trade'+i;
            acc.Business_Registration_Number__c = '1234'; 
            acc.Nird__c=System.Today() - i;
            accList.add(acc);
        }
        return accList;
    }
    
    public static List<Account> getWexUKAccountList(){
        Schema.RecordTypeInfo accRecordType = TestDatatUtility.getRecordTypeInfo('Account', 'WES Accounts');

        List<Account> accList = new List<Account>();
        
        for(Integer i=1; i<=200; i++){
            
            Account acc = new Account();
            acc.RecordTypeId = accRecordType.getRecordTypeId();
            acc.Name ='Test Account'+i;
            acc.Account_Type__c='Prospect';
            acc.Auth_Node_Indicator__c = 'Y';
            acc.Credit_Limit_Status__c = 'Approved';
            acc.account_id__c = '1001' +i ;
            
            
            acc.Credit_Utilization__c =76;
            acc.Nird__c=System.Today();
            accList.add(acc);
        }
        return accList;
    }
    
    public static Credit_Assessment__c getCredit_Assessment()
    {
        Credit_Assessment__c creAss= new Credit_Assessment__c ();
        creAss.Final_Judgement__c = 'Not now';
        //creAss.account__c=acc.id;
        creAss.Nird__c=System.today();
        creAss.RPS_Outcome__c = 'None';
        creAss.Common_Account_Check__c ='None';
        return creAss;
    }
    
    public static Risk_Flag__c getRiskFlag()
    {
        Risk_Flag__c riskFlag= new Risk_Flag__c ();
        riskFlag.Status__c = 'Not now';
        riskFlag.Closed_Date__c=System.today();
        return riskFlag;
    }
    
    public static Contact  getContact(){
        
        Schema.RecordTypeInfo conRecordType = TestDatatUtility.getRecordTypeInfo('Contact', 'EMAP Contact');
        
        Contact cont = new Contact(); 
        cont.RecordTypeId = conRecordType.getRecordTypeId();
        cont.lastName = 'Test Contact';
        cont.Primary__c = false;
        //contact.accountId = acc.id;
        return cont;
    }
    
    public static Bank_Reference__c getBankReference() {
        Bank_Reference__c bankRef = new Bank_Reference__c ();
        bankRef.Name = 'Test Bank';
        return bankRef ;
    }
    
    public static Trade_Reference__c  getTradeReference(){
        Trade_Reference__c  tradeRef = new Trade_Reference__c ();
        tradeRef.Name ='TradeName1ABABABABABABABABABABABABABABABABABABABAB';
        tradeRef.Trade_Account_Number__c = '4563212';
        tradeRef.Trade_Supplier_Type__c = 'test type1';
        tradeRef.Trade_Date_Open__c = System.Today();
        tradeRef.Street_Address__c ='Test address1'; 
        tradeRef.Trade_Phone__c = '425845411';
        tradeRef.Trade_Fax__c = '4584585411';
        tradeRef.Trade_Payment_History__c = 'NO';
        return tradeRef ;
    }
    
    public static Document_Checklist_Matrix__c getDocCheckList(){
        Document_Checklist_Matrix__c docChkMatrix = new Document_Checklist_Matrix__c();
        docChkMatrix.Card_Embossing_Form__c = true;
        docChkMatrix.Credit_Bureau_Results__c = false;
        docChkMatrix.Direct_Debit_Authority__c = true;
        docChkMatrix.Duty_Exemption_Letter__c = false;
        docChkMatrix.Financial_Statement__c = true;
        docChkMatrix.Letter_from_Government__c = false;
        docChkMatrix.Program_Name__c ='SG Fleet Card';
        docChkMatrix.Application_TYpe__c = 'ExxonMobil Singapore Embassy';
        docChkMatrix.Proof_of_Address__c = true;
        docChkMatrix.Security_Document__c = false;
        docChkMatrix.Staff_ID__c = true;
        docChkMatrix.Vehicle_Registration_Certificate__c  = false;
        return docChkMatrix;
    }
        
    public static Restricted_Account__c getRestrictedCommonAccount(){
        Restricted_Account__c res = new Restricted_Account__c();
        res.name = 'Test Restricted Account';
        res.Type__c ='Restricted Account';
        return res;
    }
    
    public static AU_Application_Request__c getAUAppReq(){
        Schema.RecordTypeInfo appReqRecType = TestDatatUtility.getRecordTypeInfo('AU_Application_Request__c', 'EMAP Application Request');

        AU_Application_Request__c AUAppReq = new AU_Application_Request__c();
        AUAppReq.recordTypeId = appReqRecType.getRecordTypeId();
        AUAppReq.Application_Type__c = 'ExxonMobil Singapore Embassy';
        AUAppReq.Application_Status__c = 'RPS Pending';
        AUAppReq.Account_Business_Registration_Number__c='Test Reg 12345678';
        AUAppReq.Account_Company_Name__c = 'Test Account';
        AUAppReq.Assess_Start_Time__c = System.now();
        AUAppReq.Assess_End_Time__c = System.now() + 5;
        return AUAppReq;
    }

   public static User createUser(){
       Profile prof = [SELECT Id,Name FROM Profile where name ='AU EMAP Credit User'];
       
       UserRole userRole = [SELECT Id FROM UserRole WHERE Name = 'AU Credit Team Leader'];

       User u=new User();
       u.username = 'forseva2test@salesforce.com';
       u.email = 'data@email.com';
       u.lastName = 'lastName';
       u.firstName = 'firstName';
       u.alias = 'alias';
       u.languagelocalekey = 'en_US';
       u.localesidkey = 'en_US';
       u.emailEncodingKey = 'UTF-8';
       u.timeZoneSidKey = 'America/Los_Angeles';
       u.profileId = prof.id;
       u.UserRoleId = userRole.id;
       
       //return u;
       
       User user = [Select id from User where Id = :UserInfo.getUserId()];
       
       return user;
    }
    
    public static Credit_Security__c getCreditSecurity(){
        Credit_Security__c credSec = new Credit_Security__c();
        credSec.Name = 'Test Credit Security';
        credSec.CurrencyIsoCode = 'USD';
        return credSec;
    }   
    
    public static Program__c getProgram1(){
        Program__c prog1 = new Program__c();
        prog1.Name = 'Test Prog1';
        prog1.Program_Name__c = 'GU Fleet Card';
        prog1.Late_Payer_Days__c = 5;

        return prog1;
    } 
        
    public static Program__c getProgram2(){
        Program__c prog2 = new Program__c();
        prog2.Name = 'Test Prog2';
        prog2.Program_Name__c = 'SP Fleet Card';
        prog2.Late_Payer_Days__c = 5;
        
        return prog2;
    }     
    
    public static Program__c getProgram3(){
        Program__c prog3 = new Program__c();
        prog3.Name = 'Test Prog3';
        prog3.Program_Name__c = 'SG Fleet Card';
        prog3.Late_Payer_Days__c = 5;
        
        return prog3;
    }     
    
    public static Program__c getProgram4(){
        Program__c prog4 = new Program__c();
        prog4.Name = 'Test Prog4';
        prog4.Program_Name__c = 'HK Fleet Card';
        prog4.Late_Payer_Days__c = 5;
        
        return prog4;
    }
    
    public static Accounts_Receivable__c getAccountReceivable(){
        Accounts_Receivable__c AR = new Accounts_Receivable__c();
        AR.name = 'Test Account Receivable';
        AR.Current_Balance__c = 1500;
        
        return AR;
    }
    
    public static Invoice__c getInvoice(){
        Invoice__c invoice = new Invoice__c();
        invoice.Payment_Due_Date__c = System.today() - 10;
        
        return invoice;
    }
    
    public static List<Invoice__c> getInvoiceList(){
        List<Invoice__c> invoiceList = new List<Invoice__c>();
        
        for(Integer i=1; i<=100; i++){
            Invoice__c inv = new Invoice__c();
            inv.Name = 'Test Invoice' + i;
            inv.Total_Dishonours__c = '1';
            inv.Payment_Due_Date__c = System.today() - i;
            inv.INVOICE_ISSUE_DATE__c = System.today() - i;
            
            invoiceList.add(inv);
        }
        return invoiceList;
    }
    
    public static final Map<String, Schema.SObjectType> globalDesc = Schema.getGlobalDescribe(); 
    
    public Static Schema.RecordTypeInfo getRecordTypeInfo(String objectName, String recordTypeName){
                
        if(globalDesc.containsKey(objectName)){
                Schema.SObjectType d = globalDesc.get(ObjectName);
                Schema.DescribeSObjectResult r = d.getDescribe();
                Map<String,Schema.RecordTypeInfo> rtMapByName = r.getRecordTypeInfosByName();
                
                return rtMapByName.get(recordTypeName);                 
        }
        else {
            return null;
        }    
    } 
}