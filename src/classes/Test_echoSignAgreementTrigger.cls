@isTest
private class Test_echoSignAgreementTrigger 
{
 
    public static testMethod void Test1() 
	{  		
		Opportunity o = new Opportunity();
  		o.stagename = '1) Qualified';
  		o.closeDate = system.today();
  		o.name = 'test';
  		o.Fueling_Methos__c = 'test';
  		insert o;
  		
  		echosign_dev1__SIGN_Agreement__c e = new echosign_dev1__SIGN_Agreement__c();
  		e.echosign_dev1__Opportunity__c = o.id;
  		e.echosign_dev1__Status__c = 'Out for Signature';
  		insert e;
  		
  		e.echosign_dev1__Status__c = 'Signed';
  		update e;
  		
  		
  	}
}