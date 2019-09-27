@isTest
public class CreditUtilQueueable_ExperianPGTest{

	public static void testGoodRequests(){
		
		Id aid = [SELECT Id FROM Account WHERE Name = 'Test' LIMIT 1].Id;
		Id oid1 = [SELECT Id FROM Opportunity WHERE Name = 'Test Oppty 7' LIMIT 1].Id;
		Id oid2 = [SELECT Id FROM Opportunity WHERE Name = 'Test Oppty 9' LIMIT 1].Id;
		Id oid3 = [SELECT Id FROM Opportunity WHERE Name = 'Test Oppty 10' LIMIT 1].Id;

		OnlineApplication__c oa1 = [SELECT Id, LastModifiedDate FROM OnlineApplication__c WHERE Account__c = :aid AND PG_Required__c = false LIMIT 1];
		OnlineApplication__c oa2 = [SELECT Id, LastModifiedDate FROM OnlineApplication__c WHERE Account__c = :aid AND AO_Name__c = 'Maurice Moss' LIMIT 1];
		OnlineApplication__c oa3 = [SELECT Id, LastModifiedDate FROM OnlineApplication__c WHERE Account__c = :aid AND AO_Name__c = 'Peter File' LIMIT 1];
		Application_Request__c ar1 = [SELECT Id, LastModifiedDate FROM Application_Request__c WHERE Opportunity__c = :oid1 AND Personal_Guarantor_First_Name__c = 'Frederick' AND Personal_Guarantor_Last_Name__c = 'Krueger' LIMIT 1];
		Application_Request__c ar2 = [SELECT Id, LastModifiedDate FROM Application_Request__c WHERE Opportunity__c = :oid2 AND Personal_Guarantor_First_Name__c = 'Maurice' AND Personal_Guarantor_Last_Name__c = 'Moss' LIMIT 1];
		Application_Request__c ar3 = [SELECT Id, LastModifiedDate FROM Application_Request__c WHERE Opportunity__c = :oid3 AND Personal_Guarantor_First_Name__c = 'Peter' AND Personal_Guarantor_Last_Name__c = 'File' LIMIT 1];
		CP_Application_Request__c cp1 = [SELECT Id, LastModifiedDate FROM CP_Application_Request__c WHERE Opportunity__c = :oid1 AND Guarantor_First_Name__c = 'Frederick' AND Guarantor_Last_Name__c = 'Krueger' LIMIT 1];
		CP_Application_Request__c cp2 = [SELECT Id, LastModifiedDate FROM CP_Application_Request__c WHERE Opportunity__c = :oid2 AND Guarantor_First_Name__c = 'Maurice' AND Guarantor_Last_Name__c = 'Moss' LIMIT 1];
		CP_Application_Request__c cp3 = [SELECT Id, LastModifiedDate FROM CP_Application_Request__c WHERE Opportunity__c = :oid3 AND Guarantor_First_Name__c = 'Peter' AND Guarantor_Last_Name__c = 'File' LIMIT 1];

		DateTime oa1Date = oa1.LastModifiedDate;
		DateTime oa2Date = oa2.LastModifiedDate;
		DateTime oa3Date = oa3.LastModifiedDate;
		DateTime ar1Date = ar1.LastModifiedDate;
		DateTime ar2Date = ar2.LastModifiedDate;
		DateTime ar3Date = ar3.LastModifiedDate;
		DateTime cp1Date = cp1.LastModifiedDate;
		DateTime cp2Date = cp2.LastModifiedDate;
		DateTime cp3Date = cp3.LastModifiedDate;

		Set<Id> myIds = new Set<Id>{oa1.Id,oa2.Id,oa3.Id,ar1.Id,ar2.Id,ar3.Id,cp1.Id,cp2.Id,cp3.Id};
		
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, MockCalloutGenerator.makeRequest(new Set<String>{'expGood','expLogin'})); //set mock
		for(Id i : myIds)
			System.enqueueJob(new CreditUtilQueueable_ExperianPG(i));
		Test.stopTest();

		Map<String, String> codeDescriptions = new Map<String, String>();
		Set<String> testCodes = new Set<String>{'ALL0400','RTR5420','ILN5420','REH5420'};
		for(Experian_Premier_Attributes_Description__mdt epad : [SELECT Id, Code__c, Description__c FROM Experian_Premier_Attributes_Description__mdt WHERE Code__c IN :testCodes])
			codeDescriptions.put(epad.Code__c, epad.Description__c);
        

        String code1 = codeDescriptions.get('ALL0400');
        String code2 = codeDescriptions.get('RTR5420');
        String code3 = codeDescriptions.get('ILN5420');
        String code4 = codeDescriptions.get('REH5420');

		oa1 = [SELECT Id, LastModifiedDate FROM OnlineApplication__c WHERE Id = :oa1.Id LIMIT 1];
		oa2 = [SELECT Id, LastModifiedDate, PG_Score__c, PG_Data__c, Experian_Premier_Attributes__c, PG_High_Credit_Amount__c, Inquiry_Address_High_Risk__c, Security_Statement_on_Report__c, On_File_Address_High_Risk__c FROM OnlineApplication__c WHERE Id = :oa2.Id LIMIT 1];
		oa3 = [SELECT Id, LastModifiedDate, PG_Score__c, PG_Data__c, Experian_Premier_Attributes__c, PG_High_Credit_Amount__c, Inquiry_Address_High_Risk__c, Security_Statement_on_Report__c, On_File_Address_High_Risk__c FROM OnlineApplication__c WHERE Id = :oa3.Id LIMIT 1];
		ar1 = [SELECT Id, LastModifiedDate FROM Application_Request__c WHERE Id = :ar1.Id LIMIT 1];
		ar2 = [SELECT Id, LastModifiedDate, PG_FICO_Score__c, PG_Data__c, Experian_Premier_Attributes__c, Experian_Premier_Attribute_Codes__c, PG_High_Credit_Amount__c, Inquiry_Address_High_Risk__c, Security_Statement_on_Report__c, On_File_Address_High_Risk__c FROM Application_Request__c WHERE Id = :ar2.Id LIMIT 1];
		ar3 = [SELECT Id, LastModifiedDate, PG_FICO_Score__c, PG_Data__c, Experian_Premier_Attributes__c, Experian_Premier_Attribute_Codes__c, PG_High_Credit_Amount__c, Inquiry_Address_High_Risk__c, Security_Statement_on_Report__c, On_File_Address_High_Risk__c FROM Application_Request__c WHERE Id = :ar3.Id LIMIT 1];
		cp1 = [SELECT Id, LastModifiedDate FROM CP_Application_Request__c WHERE Id = :cp1.Id LIMIT 1];
		cp2 = [SELECT Id, LastModifiedDate, PG_FICO_Score__c, PG_Data__c, Experian_Premier_Attributes__c, PG_High_Credit_Amount__c, Inquiry_Address_High_Risk__c, Security_Statement_on_Report__c, On_File_Address_High_Risk__c FROM CP_Application_Request__c WHERE Id = :cp2.Id LIMIT 1];
		cp3 = [SELECT Id, LastModifiedDate, PG_FICO_Score__c, PG_Data__c, Experian_Premier_Attributes__c, PG_High_Credit_Amount__c, Inquiry_Address_High_Risk__c, Security_Statement_on_Report__c, On_File_Address_High_Risk__c FROM CP_Application_Request__c WHERE Id = :cp3.Id LIMIT 1];

		system.assertNotEquals(oa1Date,oa1.LastModifiedDate,'The app was not updated');

		system.assertNotEquals(oa2Date,oa2.LastModifiedDate,'The app was not updated');
		system.assertEquals(0610,oa2.PG_Score__c,'PG_Score__c was not updated');
		system.assert(oa2.PG_Data__c.length()>100,'PG_Data__c is not nearly big enough');//this field is a huge data dump of the response. kinda rough to get exact value in a test class
		system.assert(oa2.Experian_Premier_Attributes__c.contains(code1),'Experian_Premier_Attributes__c was not updated');
		system.assert(oa2.Experian_Premier_Attributes__c.contains(code2),'Experian_Premier_Attributes__c was not updated');
		system.assert(oa2.Experian_Premier_Attributes__c.contains(code3),'Experian_Premier_Attributes__c was not updated');
		system.assert(oa2.Experian_Premier_Attributes__c.contains(code4),'Experian_Premier_Attributes__c was not updated');
		system.assertEquals(3569,oa2.PG_High_Credit_Amount__c,'PG_High_Credit_Amount__c was not updated');
		system.assert(oa2.Inquiry_Address_High_Risk__c,'Inquiry_Address_High_Risk__c was not updated'); 
		system.assert(oa2.Security_Statement_on_Report__c,'Security_Statement_on_Report__c was not updated');
		system.assert(oa2.On_File_Address_High_Risk__c,'On_File_Address_High_Risk__c was not updated');

		system.assertNotEquals(oa3Date,oa3.LastModifiedDate,'The app was not updated');
		system.assertEquals(0610,oa3.PG_Score__c,'PG_Score__c was not updated');
		system.assert(oa3.PG_Data__c.length()>100,'PG_Data__c is not nearly big enough');//this field is a huge data dump of the response. kinda rough to get exact value in a test class
		system.assert(oa3.Experian_Premier_Attributes__c.contains(code1),'Experian_Premier_Attributes__c was not updated');
		system.assert(oa3.Experian_Premier_Attributes__c.contains(code2),'Experian_Premier_Attributes__c was not updated');
		system.assert(oa3.Experian_Premier_Attributes__c.contains(code3),'Experian_Premier_Attributes__c was not updated');
		system.assert(oa3.Experian_Premier_Attributes__c.contains(code4),'Experian_Premier_Attributes__c was not updated');
		system.assertEquals(3569,oa3.PG_High_Credit_Amount__c,'PG_High_Credit_Amount__c was not updated');
		system.assert(oa3.Inquiry_Address_High_Risk__c,'Inquiry_Address_High_Risk__c was not updated');
		system.assert(oa3.Security_Statement_on_Report__c,'Security_Statement_on_Report__c was not updated');
		system.assert(oa3.On_File_Address_High_Risk__c,'On_File_Address_High_Risk__c was not updated');

		system.assertNotEquals(ar1Date,ar1.LastModifiedDate,'The app was not updated');

		system.assertNotEquals(ar2Date,ar2.LastModifiedDate,'The app was not updated');
		system.assertEquals(0610,ar2.PG_FICO_Score__c,'PG_FICO_Score__c was not updated');
		system.assert(ar2.PG_Data__c.length()>100,'PG_Data__c is not nearly big enough');//this field is a huge data dump of the response. kinda rough to get exact value in a test class
		system.assert(ar2.Experian_Premier_Attributes__c.contains(code1),'Experian_Premier_Attributes__c was not updated');
		system.assert(ar2.Experian_Premier_Attributes__c.contains(code2),'Experian_Premier_Attributes__c was not updated');
		system.assert(ar2.Experian_Premier_Attributes__c.contains(code3),'Experian_Premier_Attributes__c was not updated');
		system.assert(ar2.Experian_Premier_Attributes__c.contains(code4),'Experian_Premier_Attributes__c was not updated');
		system.assertEquals(3569,ar2.PG_High_Credit_Amount__c,'PG_High_Credit_Amount__c was not updated');
		system.assert(ar2.Inquiry_Address_High_Risk__c,'Inquiry_Address_High_Risk__c was not updated');
		system.assert(ar2.Security_Statement_on_Report__c,'Security_Statement_on_Report__c was not updated');
		system.assert(ar2.On_File_Address_High_Risk__c,'On_File_Address_High_Risk__c was not updated');

		system.assertNotEquals(ar3Date,ar3.LastModifiedDate,'The app was not updated');
		system.assertEquals(0610,ar3.PG_FICO_Score__c,'PG_FICO_Score__c was not updated');
		system.assert(ar3.PG_Data__c.length()>100,'PG_Data__c is not nearly big enough');//this field is a huge data dump of the response. kinda rough to get exact value in a test class
		system.assert(ar3.Experian_Premier_Attributes__c.contains(code1),'Experian_Premier_Attributes__c was not updated');
		system.assert(ar3.Experian_Premier_Attributes__c.contains(code2),'Experian_Premier_Attributes__c was not updated');
		system.assert(ar3.Experian_Premier_Attributes__c.contains(code3),'Experian_Premier_Attributes__c was not updated');
		system.assert(ar3.Experian_Premier_Attributes__c.contains(code4),'Experian_Premier_Attributes__c was not updated');
		system.assertEquals(3569,ar3.PG_High_Credit_Amount__c,'PG_High_Credit_Amount__c was not updated');
		system.assert(ar3.Inquiry_Address_High_Risk__c,'Inquiry_Address_High_Risk__c was not updated');
		system.assert(ar3.Security_Statement_on_Report__c,'Security_Statement_on_Report__c was not updated');
		system.assert(ar3.On_File_Address_High_Risk__c,'On_File_Address_High_Risk__c was not updated');

		system.assertNotEquals(cp1Date,cp1.LastModifiedDate,'The app was not updated');

		system.assertNotEquals(cp2Date,cp2.LastModifiedDate,'The app was not updated');
		system.assertEquals(0610,cp2.PG_FICO_Score__c,'PG_FICO_Score__c was not updated');
		system.assert(cp2.PG_Data__c.length()>100,'PG_Data__c is not nearly big enough');//this field is a huge data dump of the response. kinda rough to get exact value in a test class
		system.assert(cp2.Experian_Premier_Attributes__c.contains(code1),'Experian_Premier_Attributes__c was not updated');
		system.assert(cp2.Experian_Premier_Attributes__c.contains(code2),'Experian_Premier_Attributes__c was not updated');
		system.assert(cp2.Experian_Premier_Attributes__c.contains(code3),'Experian_Premier_Attributes__c was not updated');
		system.assert(cp2.Experian_Premier_Attributes__c.contains(code4),'Experian_Premier_Attributes__c was not updated');
		system.assertEquals(3569,cp2.PG_High_Credit_Amount__c,'PG_High_Credit_Amount__c was not updated');
		system.assert(cp2.Inquiry_Address_High_Risk__c,'Inquiry_Address_High_Risk__c was not updated');
		system.assert(cp2.Security_Statement_on_Report__c,'Security_Statement_on_Report__c was not updated');
		system.assert(cp2.On_File_Address_High_Risk__c,'On_File_Address_High_Risk__c was not updated');

		system.assertNotEquals(cp3Date,cp3.LastModifiedDate,'The app was not updated');
		system.assertEquals(0610,cp3.PG_FICO_Score__c,'PG_FICO_Score__c was not updated');
		system.assert(cp3.PG_Data__c.length()>100,'PG_Data__c is not nearly big enough');//this field is a huge data dump of the response. kinda rough to get exact value in a test class
		system.assert(cp3.Experian_Premier_Attributes__c.contains(code1),'Experian_Premier_Attributes__c was not updated');
		system.assert(cp3.Experian_Premier_Attributes__c.contains(code2),'Experian_Premier_Attributes__c was not updated');
		system.assert(cp3.Experian_Premier_Attributes__c.contains(code3),'Experian_Premier_Attributes__c was not updated');
		system.assert(cp3.Experian_Premier_Attributes__c.contains(code4),'Experian_Premier_Attributes__c was not updated');
		system.assertEquals(3569,cp3.PG_High_Credit_Amount__c,'PG_High_Credit_Amount__c was not updated');
		system.assert(cp3.Inquiry_Address_High_Risk__c,'Inquiry_Address_High_Risk__c was not updated');
		system.assert(cp3.Security_Statement_on_Report__c,'Security_Statement_on_Report__c was not updated');
		system.assert(cp3.On_File_Address_High_Risk__c,'On_File_Address_High_Risk__c was not updated');

	}

	public static void testBadRequests(){

		Id aid = [SELECT Id FROM Account WHERE Name = 'Test' LIMIT 1].Id;
		Id oid = [SELECT Id FROM Opportunity WHERE Name = 'Test Oppty 9' LIMIT 1].Id;
		
		OnlineApplication__c oa1 = [SELECT Id, LastModifiedDate, PG_Score__c FROM OnlineApplication__c WHERE Account__c = :aid AND AO_Name__c = 'Maurice Moss' LIMIT 1];
		Application_Request__c ar1 = [SELECT Id, LastModifiedDate, PG_FICO_Score__c FROM Application_Request__c WHERE Opportunity__c = :oid AND Personal_Guarantor_First_Name__c = 'Maurice' AND Personal_Guarantor_Last_Name__c = 'Moss' LIMIT 1];
		CP_Application_Request__c cp1 = [SELECT Id, LastModifiedDate, PG_FICO_Score__c FROM CP_Application_Request__c WHERE Opportunity__c = :oid AND Guarantor_First_Name__c = 'Maurice' AND Guarantor_Last_Name__c = 'Moss' LIMIT 1];
		
		DateTime oa1Date = oa1.LastModifiedDate;
		Decimal oa1Score = oa1.PG_Score__c;
		DateTime ar1Date = ar1.LastModifiedDate;
		Decimal ar1Score = ar1.PG_FICO_Score__c;
		DateTime cp1Date = cp1.LastModifiedDate;
		Decimal cp1Score = cp1.PG_FICO_Score__c;

		Set<Id> myIds = new Set<Id>{oa1.Id,ar1.Id,cp1.Id};

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, MockCalloutGenerator.makeRequest(new Set<String>{'fail','expLogin'})); //set mock
		for(Id i : myIds)
			System.enqueueJob(new CreditUtilQueueable_ExperianPG(i));
		Test.stopTest();

		oa1 = [SELECT Id, LastModifiedDate, PG_Score__c FROM OnlineApplication__c WHERE Id = :oa1.Id LIMIT 1];
		ar1 = [SELECT Id, LastModifiedDate, PG_FICO_Score__c FROM Application_Request__c WHERE Id = :ar1.Id LIMIT 1];
		cp1 = [SELECT Id, LastModifiedDate, PG_FICO_Score__c FROM CP_Application_Request__c WHERE Id = :cp1.Id LIMIT 1];
		
		system.assertNotEquals(oa1Date,oa1.LastModifiedDate,'It was not updated');
		system.assertEquals(oa1Score,oa1.PG_Score__c,'The score was updated');
		system.assertNotEquals(ar1Date,ar1.LastModifiedDate,'It was not updated');
		system.assertEquals(ar1Score,ar1.PG_FICO_Score__c,'The score was updated');
		system.assertNotEquals(cp1Date,cp1.LastModifiedDate,'It was not updated');
		system.assertEquals(cp1Score,cp1.PG_FICO_Score__c,'The score was updated');
	}

}