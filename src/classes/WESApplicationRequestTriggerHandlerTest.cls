@istest
public class WESApplicationRequestTriggerHandlerTest {
    @testsetup
    static void setupData() {
        Velocity_Profile__c prof1 = new Velocity_Profile__c();
        prof1.Country_code__c = 'GB;DE';
        prof1.LowerLimit__c = 0;
        prof1.UpperLimit__c = 15000;
        prof1.VehicleType__c = 'Coaches';
        prof1.VelocityProfile__c = 'T01';
        insert prof1;

        Velocity_Profile__c prof2 = new Velocity_Profile__c();
        prof2.Country_code__c = 'GB;DE';
        prof2.LowerLimit__c = 15000;
        prof2.UpperLimit__c = 25000;
        prof2.VehicleType__c = 'Coaches';
        prof2.VelocityProfile__c = 'T02';
        insert prof2;

        Account acc1 = new Account(name='test1');
        acc1.WES_ISO_Country_Code__c = 'GB';
        insert acc1;

        Account acc2 = new Account(name='test2');
        acc2.WES_ISO_Country_Code__c = 'DE';
        insert acc2;
    }
    static testmethod void testVelocityProfileMatchFound1() {
        Account acc1 = [SELECT Id FROM Account WHERE WES_ISO_Country_Code__c = 'GB'];
        Velocity_Profile__c prof1 = [SELECT VelocityProfile__c FROM Velocity_Profile__c WHERE VelocityProfile__c = 'T01'];

        WES_Application_Request__c req = new WES_Application_Request__c();
        req.Account__c = acc1.Id;
        req.ofVehicles__c = 10;
        req.Diesel_per_month_Litres__c = 50000;
        req.Petrol_used_per_month_Litres__c = 50000;
        req.BiggestVehicle__c = 'Coaches';

        Test.startTest();
        insert req;
        Test.stopTest();

        req = [SELECT VelocityProfile__c FROM WES_Application_Request__c WHERE Id = :req.Id];
        System.assertEquals(prof1.VelocityProfile__c,req.VelocityProfile__c);
    }

    static testmethod void testVelocityProfileMatchFound2() {
        Account acc2 = [SELECT Id FROM Account WHERE WES_ISO_Country_Code__c = 'DE'];
        Velocity_Profile__c prof2 = [SELECT VelocityProfile__c FROM Velocity_Profile__c WHERE VelocityProfile__c = 'T02'];

        WES_Application_Request__c req = new WES_Application_Request__c();
        req.Account__c = acc2.Id;
        req.ofVehicles__c = 5;
        req.Diesel_per_month_Litres__c = 40000;
        req.Petrol_used_per_month_Litres__c = 40000;
        req.BiggestVehicle__c = 'Coaches';

        Test.startTest();
        insert req;
        Test.stopTest();

        req = [SELECT VelocityProfile__c FROM WES_Application_Request__c WHERE Id = :req.Id];
        System.assertEquals(prof2.VelocityProfile__c, req.VelocityProfile__c);
    }


    static testmethod void testVelocityProfileNoMatchFound() {
        Account acc2 = [SELECT Id FROM Account WHERE WES_ISO_Country_Code__c = 'DE'];

        WES_Application_Request__c req = new WES_Application_Request__c();
        req.Account__c = acc2.Id;
        req.ofVehicles__c = 10;
        req.Diesel_per_month_Litres__c = 50000;
        req.Petrol_used_per_month_Litres__c = 50000;
        req.BiggestVehicle__c = 'Cars';

        Test.startTest();
        insert req;
        Test.stopTest();

        req = [SELECT VelocityProfile__c FROM WES_Application_Request__c WHERE Id = :req.Id];
        System.assertEquals('No Match Found', req.VelocityProfile__c);
    }

    static testmethod void testVelocityProfileMatchUpdate() {
        Account acc1 = [SELECT Id FROM Account WHERE WES_ISO_Country_Code__c = 'GB'];

        WES_Application_Request__c req = new WES_Application_Request__c();
        req.Account__c = acc1.Id;
        req.ofVehicles__c = 10;
        req.Diesel_per_month_Litres__c = 50000;
        req.Petrol_used_per_month_Litres__c = 50000;
        req.BiggestVehicle__c = 'Coaches';
        insert req;

        req.BiggestVehicle__c = 'Cars';

        Test.startTest();
        update req;
        Test.stopTest();

        req = [SELECT VelocityProfile__c FROM WES_Application_Request__c WHERE Id = :req.Id];
        System.assertEquals('No Match Found', req.VelocityProfile__c);
    }

    static testmethod void testVelocityProfileMatchMultipleRecords() {
        Account acc1 = [SELECT Id FROM Account WHERE WES_ISO_Country_Code__c = 'GB'];
        Velocity_Profile__c prof1 = [SELECT VelocityProfile__c FROM Velocity_Profile__c WHERE VelocityProfile__c = 'T01'];

        WES_Application_Request__c req1 = new WES_Application_Request__c();
        req1.Account__c = acc1.Id;
        req1.ofVehicles__c = 10;
        req1.Diesel_per_month_Litres__c = 50000;
        req1.Petrol_used_per_month_Litres__c = 50000;
        req1.BiggestVehicle__c = 'Coaches';

        WES_Application_Request__c req2 = new WES_Application_Request__c();
        req2.Account__c = acc1.Id;

        Test.startTest();
        insert new List<WES_Application_Request__c> {req1, req2};
        Test.stopTest();

        req1 = [SELECT VelocityProfile__c FROM WES_Application_Request__c WHERE Id = :req1.Id];
        System.assertEquals(prof1.VelocityProfile__c, req1.VelocityProfile__c);

        req2 = [SELECT VelocityProfile__c FROM WES_Application_Request__c WHERE Id = :req2.Id];
        System.assertEquals(null, req2.VelocityProfile__c);
    }

    static testmethod void testFuelPacksAndCards() {
        Account acc1 = [SELECT Id FROM Account WHERE WES_ISO_Country_Code__c = 'GB'];

        Id rectypeid = [SELECT Id FROM RecordType WHERE sObjectType = 'WES_Application_Request__c' AND DeveloperName = 'WES_Limited_Company' LIMIT 1].Id;

        WES_Application_Request__c req = new WES_Application_Request__c();
        req.Account__c = acc1.Id;
        req.RecordTypeId = rectypeid;
        req.ofVehicles__c = 10;
        req.Diesel_per_month_Litres__c = 50000;
        req.Petrol_used_per_month_Litres__c = 50000;
        req.BiggestVehicle__c = 'Coaches';
        req.Fuel_Card_Packs__c = 3;
        req.Default_Card_Type__c = 'EDC';
        req.Default_Additional_Embossed_Line__c = 'test';
        req.Create_Fuel_Cards__c = true;
        insert req;

        Id defRectypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'WES_Fuel_Card_Default__c' AND DeveloperName = 'EDC' LIMIT 1].Id;

        WES_Fuel_Card_Default__c def = new WES_Fuel_Card_Default__c();
        def.WES_Application_Request__c = req.Id;
        def.RecordTypeId = defRectypeId;
        def.Toll_Usage__c = 'Y';
        def.Purchase_Option_Services__c = '0';
        insert def;

        Test.startTest();
        update req;
        Test.stopTest();

        List<WES_Fuel_Card__c> cards = [SELECT Id FROM WES_Fuel_Card__c WHERE WES_Application_Request__c = :req.Id];
        System.assert(cards.size()!=0);
    }
}