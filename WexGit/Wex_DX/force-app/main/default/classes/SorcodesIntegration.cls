public class SorcodesIntegration 
{
public string bank_sort_code{get;set;}
public string bank_account_number{get;set;}
public string bank{get;set;}
public string address{get;set;}
public string branch{get;set;}
public string city{get;set;}
public string zip{get;set;}
public string country{get;set;}
public string phone{get;set;}
public string DD{get;set;}
public integer code{get;set;}
public string modulus{get;set;}
public string sort_found1{get;set;}
public boolean b=false;
public HttpResponse response;
public String sortcode;  
public String account;
public String api_Key;
public String EndPoint;
public WES_Application_Request__c wesapp;
 public SorcodesIntegration(ApexPages.StandardController stdController) 
  { 
    WES_Application_Request__c wesapp=(WES_Application_Request__c)stdController.getRecord();
    wesapp=[select Id, bankIdentifier__c,bankAccountNumber__c,Bank_Account_Validity__c from WES_Application_Request__c where Id=:wesapp.id];
    String sortcode=wesapp.bankIdentifier__c;
    String account=wesapp.bankAccountNumber__c;
    String Bank_Account_Validity=wesapp.Bank_Account_Validity__c;
    String api_Key='54ac699cdd4680310ba9c7ca56b0053c';
    String EndPoint='https://api.iban.com/clients/api/v4/sort';
    EndPoint+='/?api_key='+api_key;
    EndPoint+='&format=json';
    EndPoint+='&sortcode='+sortcode;
    EndPoint+='&account='+account;
  Try{ 
    Http http=new Http();    
    HttpRequest req1=new HttpRequest();
    req1.setEndPoint(EndPoint);
    req1.setMethod('GET');
    HttpResponse response=http.send(req1);
   //system.debug('====================> Debug: '+ response.getBody());
    If (response.getStatusCode()==200)
    {
    Map<String,Object> results=(Map<String,Object>)JSON.deserializeUntyped(response.getBody());
       Map<String,Object> mainresultbank=(Map<String,Object>)(results.get('bank_data'));   
       Map<String,Object> mainresultpayment=(Map<String,Object>)(results.get('payment_schemes')); 
       Map<String,Object> mainresultresponse1=(Map<String,Object>)(results.get('validations')); 
       Map<String,Object> mainresultresponse2=(Map<String,Object>)(mainresultresponse1.get('modulus'));
       Map<String,Object> mainresultresponse3=(Map<String,Object>)(mainresultresponse1.get('sort_found'));                    
       bank=String.valueOf(mainresultbank.get('bank'));
       address=String.valueOf(mainresultbank.get('address'));
       branch=String.valueOf(mainresultbank.get('branch'));
       city=String.valueOf(mainresultbank.get('city'));
       zip=String.valueOf(mainresultbank.get('zip'));
       country=String.valueOf(mainresultbank.get('country'));
       phone=String.valueOf(mainresultbank.get('phone'));
       DD= string.valueof(mainresultpayment.get('DD'));
       modulus=string.valueof(mainresultresponse1.get('modulus'));
       sort_found1=string.valueof(mainresultresponse1.get('sort_found'));
      b=sort_found1.contains('{code=002, message=Sort Code found in bank directory}');
       If(b)
         {
           code= integer.valueof(mainresultresponse2.get('code'));
             if(code==001)
              {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm,'Validation Successful: sortcode found & check digit is valid'));
              }
            else
             {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Validation Failed: account number is incorrect'));
             }
        }
       else
        {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Validation Failed: Sort Code not found in bank directory'));
        }
   }
  }
 Catch (Exception ex)
 {
  Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL,  'Exception error occur : '+ex.getmessage()));
    }
 }
}