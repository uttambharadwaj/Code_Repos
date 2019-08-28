/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seealldata=true)
private class Test_AccountAsset {

/*    static testMethod void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testMethod void myUnitTest() {
        *//*
        // TO DO: implement unit test. no. TODO: fix this trash in a new, proper test
        test.startTest();
        
        Account a = new Account(name='test');
        insert a;
        Opportunity o = new Opportunity(name='test',closedate=system.now().date(),amount=100,accountid=a.Id,stagename='test');
        insert o;
        Opportunity o2 = new Opportunity(name='test',closedate=system.now().date(),amount=100,accountid=a.Id,stagename='test'); //o.clone();
        insert o2;
        //system.debug('-- ' + o2);
        Account_Asset__c aac = new Account_Asset__c(account__c=a.Id,opportunity__c=o.Id);
        insert aac;
        Account_Asset__c aac2 = new Account_Asset__c(account__c=a.Id);
        insert aac2;
        aac2.opportunity__c=o2.id;
        update aac2;

        
        test.stopTest();
         
          for(Opportunity ocheck : [Select Account_Asset__c from Opportunity limit 10] )
        {
        	system.debug('-- ocheck' + ocheck);
         //  	system.assert(ocheck.Account_Asset__c!=null);
        }  
 *//*
    }*/
}