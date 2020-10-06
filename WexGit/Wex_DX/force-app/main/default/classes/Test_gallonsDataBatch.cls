/**
Created by: Phillip Southern (GearsCRM)

 */
@isTest  
private class Test_gallonsDataBatch {

    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
       	//cretae Account...
		Account ac1 = new Account();
		ac1.Type = 'GearsCRM Test';
		ac1.Name = 'TestAcc';
        ac1.First_Gallon_Pumped_Month__c = date.today().addDays(-20);
        ac1.Gallons_YTD__c = 440.22;
        ac1.Gallons_Last_Three_Months__c = 33.11;
		insert ac1;

        	//cretae Account...
		Account ac2 = new Account();
		ac2.Type = 'GearsCRM Test2';
		ac2.Name = 'TestAcc';
        ac2.First_Gallon_Pumped_Month__c = date.today().addDays(-21);
        ac2.Gallons_YTD__c = 540.22;
        ac2.Gallons_Last_Three_Months__c = 44.11;
		insert ac2;   
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Account_Asset__c; 
        Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        
        id rtId = AccountRecordTypeInfo.get('Fuel Card').getRecordTypeID();

        Account_Asset__c a1 = new Account_Asset__c();
        a1.name = 'test Account Asset';
        a1.Account__c = ac1.id;
        a1.Gallons_MTD__c = 22.22;
        a1.Gallons_YTD__c = 122.22;
        a1.Gallons_Last_Three_Months__c = 66.66;
        a1.recordtypeid = rtId;
        Insert a1;
     
        Account_Asset__c a12 = new Account_Asset__c();
        a12.name = 'test Account Asset2';
        a12.Account__c = ac2.id;
        a12.Gallons_MTD__c = 33.33;
        a12.Gallons_YTD__c = 0;
        a12.Gallons_Last_Three_Months__c = 0;
        a12.recordtypeid = rtId;
        Insert a12;
     	 
        GlobalSettings__c gc = new GlobalSettings__c();
        gc.Name = 'test';
        gc.AccountAssetRecordTypeID__c = rtId;
        insert gc; 
        
        GlobalSettings__c gc1 = new GlobalSettings__c();
        gc1.Name = 'test1';
        gc1.AccountAssetRecordTypeID__c = rtId;
        insert gc1; 
        
        test.startTest();
        List<account> toadd = new List<account>();
        List<account_asset__c> toadd2 = new List<account_asset__c>();
        List<gallons_data__c> toadd3 = new List<gallons_data__c>();
        
        Account a = new Account(name='test',First_Gallon_Pumped_Month__c = date.today().addDays(-21),Gallons_YTD__c = 22.22,Gallons_Last_Three_Months__c = 33.33);
        toadd.add(a);
        Account a2 = new Account(name='test',First_Gallon_Pumped_Month__c = date.today().addDays(-21),Gallons_YTD__c = 222.222,Gallons_Last_Three_Months__c = 333.333);
        toadd.add(a2);
        
        insert toadd;
        
        for(account acc : toadd)
        {
        	for(integer x = 0; x<2; x++)
        	{
        		Account_asset__c acca = new Account_asset__c(Account__c=acc.Id, name='test',recordtypeid = rtId);
        		if(x==1)
        		{
        			acca.Gallons_MTD__c = 1;
        		}
        		toadd2.add(acca);
        	}
        }
        
        insert toadd2;
        
        for(account_asset__c aa : toadd2)
        {
        	for(integer x = 0; x<2; x++)
        	{
        		gallons_data__c gd = new gallons_data__c(account_asset__c=aa.Id,gallons_amount__c=100,gallon_month__c=system.now().date());
        		toadd3.add(gd);
        	}
        }
        
        insert toadd3;

        List<Account_Asset__c> extraAAC = new List<Account_Asset__c>();
        //account asset with no gallons data
        Account_Asset__c aacND = new Account_Asset__c(Account__c=a.Id,name='aacND',Gallons_YTD__c=100,Gallons_Last_Three_Months__c=100,recordtypeid = rtId);
        extraAAC.add(aacND);
        
        //account asset that has MTD but no gallons data
        Account_Asset__c aacMTD = new Account_Asset__c(Account__c=a.Id,name='aacMTD',Gallons_MTD__c=50,recordtypeid = rtId);
        extraAAC.add(aacMTD);
        
        insert extraAAC;
        
        //maintenanceScheduleCheckBatchSched mscb = new maintenanceScheduleCheckBatchSched();
        SchedulableContext sc;
        //mscb.execute(sc);
        UgallonsDataBatch ugdb = new UgallonsDataBatch();
        ugdb.execute(sc);
        
        test.stopTest();
        
        for(Account acheck : [Select Id, First_Gallon_Pumped_Month__c, Gallons_YTD__c, Gallons_Last_Three_Months__c from Account])
        {
            system.assert(acheck.First_Gallon_Pumped_Month__c!= null && acheck.Gallons_YTD__c !=null && acheck.Gallons_Last_Three_Months__c != null);
        	//system.debug('-- acheck: ' + acheck);
        }
        
        for(Account_Asset__c aacheck : [Select Id, Name, Gallons_YTD__c, Gallons_Last_Three_Months__c from Account_Asset__c])// Where Id IN :toadd2 or Id IN :extraAAC])
        {
            //system.debug('-- aacheck: ' + aacheck);
        	if(aacheck.Name=='aacND')
        	{
               system.assert(aacheck.Gallons_YTD__c==0 && aacheck.Gallons_Last_Three_Months__c==0);
        	}
        }

        
    }
}