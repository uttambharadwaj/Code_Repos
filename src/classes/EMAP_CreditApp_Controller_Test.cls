@istest(seeAllData=false)
private class EMAP_CreditApp_Controller_Test{

static testMethod void DupeChecktest(){

       
    Program__c prog = new Program__c (Program_Name__c ='HK Fleet Card' );
    insert prog; 
    
    Account acc = TestDatatUtility.getAccount();
    acc.recordtype = [select id from recordtype where name = 'EMAP Fuel Accounts'];
    insert acc;
    
    Contact contact = TestDatatUtility.getContact();
    contact.accountId = acc.id;
    insert contact;
    
    AU_Application_Request__c AUAppReq = TestDatatUtility.getAUAppReq();
    AUAppReq.Account__c = acc.id;
    AUAppReq.Account_Company_Name__c = acc.name;
    insert AUAppReq;

    Document_Checklist_Matrix__c docChkMatrix = TestDatatUtility.getDocCheckList();
    insert docChkMatrix; 
    
    Bank_Reference__c bankRef = TestDatatUtility.getBankReference();
    insert bankRef;
    
    Trade_Reference__c  tradeRef1 = TestDatatUtility.getTradeReference();
    insert tradeRef1;
    
    Trade_Reference__c  tradeRef2 = TestDatatUtility.getTradeReference();
    insert tradeRef2;
    
    Pagereference pageRef = new Pagereference('/apex/creditApplicationPage');
    Test.setCurrentPageReference(pageRef);
    
    EMAP_CreditApp_Controller ccap =new EMAP_CreditApp_Controller();
    ccap.program = prog;
    ccap.acc = TestDatatUtility.getAccount();
    ccap.AUAppReq = AUAppReq;
    
    Test.startTest();
    
    ccap.DupeCheck();
    
    System.assertEquals((ccap.accList.size()>0),True);
    
    ccap.acc = TestDatatUtility.getAccount();
    
    prog.Program_Name__c ='SG Fleet Card';
    ccap.program = prog;
    
    ccap.DupeCheck();
    
    //System.assertEquals((ccap.accList.size()<=0),True);
    
    ccap.closePopup();
    ccap.nextPage();
    ccap.clearPage();    
    Test.stopTest(); 
    
}

static testMethod void SaveRecordCall(){

    Program__c prog1 = TestDatatUtility.getProgram1();
    insert prog1;
    
    
    EMAP_CreditApp_Controller ccap =new EMAP_CreditApp_Controller();
    ccap.program = prog1;
    
    Account acc = TestDatatUtility.getAccount();
    acc.Program__c = prog1.id;
    acc.Status__c = '1 - Active';
    acc.Security_Expiry__c = System.today() + 10;
    acc.Business_Expiry_Date__c = System.today() + 10;
    acc.Temporary_Credit_Limit__c = 500;
    acc.Temporary_Credit_Expire_Date__c = System.today() + 5;
    acc.Temporary_Credit_Reason__c = 'Temporary usage increase';
    acc.Credit_Limit_Lcy__c = 500;
    acc.Account_Controller__c = 'WEX';
            
    ccap.acc = acc;
    
    ccap.contact = TestDatatUtility.getContact();
    
    ccap.AUAppReq = TestDatatUtility.getAUAppReq();
    
    Test.StartTest();
    System.debug('1st Save records call');
    ccap.SaveRecords();

    Account acc1 = TestDatatUtility.getAccount();
    acc1.Program__c = prog1.id;
    acc1.Status__c = '1 - Active';
    acc1.Security_Expiry__c = System.today() + 20;
    acc1.Business_Expiry_Date__c = System.today() + 20;
    acc1.Temporary_Credit_Limit__c = 1500;
    acc1.Temporary_Credit_Expire_Date__c = System.today() + 15;
    acc1.Temporary_Credit_Reason__c = 'Temporary usage increase';
    acc1.Credit_Limit_Lcy__c = 2500;
    acc1.Account_Controller__c = 'WEX';

    ccap.acc = acc1;
    
    Contact cont = TestDatatUtility.getContact();
    ccap.contact = cont;
    
    AU_Application_Request__c AUAppReq = TestDatatUtility.getAUAppReq();
    ccap.AUAppReq = AUAppReq;
    
    ccap.bankRef = TestDatatUtility.getBankReference();
    
    ccap.tradeRef1 = TestDatatUtility.getTradeReference();
    
    ccap.tradeRef2 = TestDatatUtility.getTradeReference();
    
    System.debug('2nd Save records call');
    
    ccap.SaveRecords();
    
    Test.StopTest();
}

static testMethod void closePopup(){
    EMAP_CreditApp_Controller ccap =new EMAP_CreditApp_Controller();
    ccap.closePopup();
    ccap.clearPage();
}

static testmethod void nextpageCall(){
    Boolean presentheck = false;
    List<Document_Checklist_Matrix__c> docChkListData = new List<Document_Checklist_Matrix__c>();
    Document_Checklist_Matrix__c docChkList = new Document_Checklist_Matrix__c();
    docChkList.Name = 'Singapore Embassy';
    docChkList.Card_Embossing_Form__c = true;
    docChkList.Proof_of_Address__c = true;
    
    
    Document_Checklist_Matrix__c docChkList1 = new Document_Checklist_Matrix__c();
    docChkList1.Name = 'Singapore Embassy1';
    docChkList1.Card_Embossing_Form__c = true;
    docChkList1.Proof_of_Address__c = true;
    
    docChkListData.add(docChkList);
    docChkListData.add(docChkList1);
    
    if(docChkListData != null && !docChkListData.isEmpty()) {
                presentheck = true;
    }
}


}