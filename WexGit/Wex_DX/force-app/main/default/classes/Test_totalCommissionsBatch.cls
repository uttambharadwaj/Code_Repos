/**
 * Created By: Phillip Southern (GearsCRM)
 */
@isTest
private class Test_totalCommissionsBatch {

//    @testSetup
//    static void setup(){
//        UtilityTestLoader.setAutomation(false);
//    }
//
//    static testMethod void myUnitTest() {
//
//
//        date oppclosedate = date.newInstance(system.now().year(),2,1);
//        Account a = new Account(name='test');
//        insert a;
//
//        RecordType rt = [Select Id, Name from RecordType Where sobjectType='Opportunity' and IsActive = true LIMIT 1];
//        OppRecordTypeForComm__c opprtc = new OppRecordTypeForComm__c(name=rt.name);
//        opprtc.RecordTypeId__c = rt.id;
//
//        insert opprtc;
//
//        Opportunity o = new Opportunity(name='test',amount=100,accountid=a.Id,stagename='5) Signed',closedate=system.now().date(), recordtypeid=rt.id);
//        insert o;
//        Account_Asset__c aac = new Account_Asset__c(account__c=a.Id,opportunity__c=o.Id);
//        insert aac;
//
//        //o.Account_Asset__c = aac.Id;
//        //update o;
//
//        Date dateToSet = date.newinstance(system.now().date().addDays(90).year(), system.now().date().addDays(90).month(),1);
//
//        Gallons_Data__c gd = new Gallons_Data__c(account_Asset__c=aac.Id,Gallons_Amount__c=100,Gallon_Month__c=datetoSet); //system.now().date());
//        insert gd;
//
//        test.startTest();
//        //do batch here
//        SchedulableContext sc;
//        totalCommissionsBatch tcb = new totalCommissionsBatch();
//        tcb.execute(sc);
//        test.stopTest();
//        Opportunity ocheck = [select id, name, closedate, stagename, accountid, account_asset__c from Opportunity];
//        system.debug('-- ' + ocheck);
//
//        //asserts
//        //Date datecheck = date.newinstance(system.now().date().addDays(90).year(), system.now().date().addDays(90).month(),1);
//        Commission__c c = [Select Commission_Report_Date__c, Total_Commissionable_Gallons__c, Opportunity__c, Opportunity__r.Account_Asset__c, Opportunity_Close_Date__c
//                        from Commission__c LIMIT 1];
//        system.debug('-- ' + c);
//
//        //system.assert(c.Total_Commissionable_Gallons__c == gd.Gallons_Amount__c);
//    }
}