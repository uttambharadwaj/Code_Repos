@isTest
public class CreditDecisionEngineQueueableTest {

    public static void testExperianOnlineApp(){
        /*
        need onlineapp with pg required false (nothing should happen)
        need onlineapps with PG_Required__c
        need one with Type_of_Business__c==Proprietorship
        need one with Type_of_Business__c==null (or not proprietorship or partnership)
        need one with AO_First_Name__c and AO_Last_Name__c null, AO_Name__c not null
        need one with AO_First_Name__c and AO_Last_Name__c not null, AO_Name__c not null
        need AO_Date_of_Birth__c not null
        */
        OnlineApplication__c oa1 = [SELECT Id FROM OnlineApplication__c WHERE AO_NAME__C = 'Peter File' AND PG_Required__c = false LIMIT 1];
        OnlineApplication__c oa2 = [SELECT Id FROM OnlineApplication__c WHERE AO_NAME__C = 'Maurice Moss' AND PG_Required__c = true LIMIT 1];
        OnlineApplication__c oa3 = [SELECT Id FROM OnlineApplication__c WHERE AO_NAME__C = 'Peter File' AND PG_Required__c = true LIMIT 1];

        List<Id> oaList = new List<Id>{oa1.Id,oa2.Id,oa3.Id};
        Test.startTest();
        //Test.setMock(HTTPCalloutMock.class,MockCalloutGenerator.makeRequest('expGood'));
        for(Id i : oaList)
            System.enqueueJob(new CreditUtilQueueable_ExperianPG(i));
        Test.stopTest();

        oa1 = [SELECT Id,PG_Score__c,PG_Data__c,Experian_Premier_Attributes__c,PG_High_Credit_Amount__c,Inquiry_Address_High_Risk__c,Security_Statement_on_Report__c,On_File_Address_High_Risk__c FROM OnlineApplication__c WHERE Id = :oa1.Id LIMIT 1];
        oa2 = [SELECT Id,PG_Score__c,PG_Data__c,Experian_Premier_Attributes__c,PG_High_Credit_Amount__c,Inquiry_Address_High_Risk__c,Security_Statement_on_Report__c,On_File_Address_High_Risk__c FROM OnlineApplication__c WHERE Id = :oa2.Id LIMIT 1];
        oa3 = [SELECT Id,PG_Score__c,PG_Data__c,Experian_Premier_Attributes__c,PG_High_Credit_Amount__c,Inquiry_Address_High_Risk__c,Security_Statement_on_Report__c,On_File_Address_High_Risk__c FROM OnlineApplication__c WHERE Id = :oa3.Id LIMIT 1];


    }

    public static void testExperianAppRequest(){
        
    }

    public static void testExperianCPAppRequest(){
        
    }
}