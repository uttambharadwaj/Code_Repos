/**
* Forseva online application code.
*/
public with sharing class OnlineApplicationParameters {

    // keep in synch with picklists on OnlineApplicationVehicleSetup object
    public final static String CAR_SEDAN = 'Car/Sedan';
    public final static String LIGHT_TRUCK_VAN = 'Light Truck/Van';
    public final static String MID_SIZE_TRUCK = 'Mid Size/Truck';
    public final static String LARGE_TRUCK_EQUIPMENT = 'Large Truck/Equipment';
    public final static String UNLEADED = 'Unleaded';

    // keep in synch with picklists on OnlineApplicationCardSetup object
    public final static String TRAVEL_CARD = 'Travel Card';
    public final static String PURCHASE_CARD = 'Purchase Card';
    public final static String FLEET_DRIVER_CARD = 'Fleet Driver Card';
    public final static String ALL_MERCHANTS = 'All Merchants';
    public final static String FUEL_ONLY = 'Fuel Only';
    public final static String FUEL_AND_MAINT = 'Fuel & Maint.';

    public static String getApplicationBaseUrl() {

        OnlineApplicationParameters__c oap = OnlineApplicationParameters__c.getInstance(BASE_APPLICATION_URL);
        if(oap != null) {
            return oap.Parameter_Value__c;
        }
        return null;
    }

    public static String getEchoSignApiKey() {

        OnlineApplicationParameters__c oap = OnlineApplicationParameters__c.getInstance(ECHOSIGN_API_KEY);
        if(oap != null) {
            return oap.Parameter_Value__c;
        }
        return null;
    }

    public static Integer getSmallFleetMaximum() {

        OnlineApplicationParameters__c oap = OnlineApplicationParameters__c.getInstance(SMALL_FLEET_MAXIMUM);
        if(oap != null) {
            return Integer.valueOf(oap.Parameter_Value__c);
        }
        return null;
    }

    public static String getThreatMetrixURL() {

        OnlineApplicationParameters__c oap = OnlineApplicationParameters__c.getInstance(THREATMETRIX_URL);
        if(oap != null) {
            return oap.Parameter_Value__c;
        }
        return null;
    }

    public static String getThreatMetrixOrgId() {

        OnlineApplicationParameters__c oap = OnlineApplicationParameters__c.getInstance(THREATMETRIX_ORG_ID);
        if(oap != null) {
            return oap.Parameter_Value__c;
        }
        return null;
    }

    public static String getThreatMetrixAPIKey() {

        OnlineApplicationParameters__c oap = OnlineApplicationParameters__c.getInstance(THREATMETRIX_API_KEY);
        if(oap != null) {
            return oap.Parameter_Value__c;
        }
        return null;
    }

    //----------------------------

    public static OnlineApplicationVehicleSetup__c getDefaultVehicleSetup(String vehicleType) {
        
        for(OnlineApplicationVehicleSetup__c setup : m_setups) {
            if(setup.Vehicle_Type__c == vehicleType) {
                return setup.clone(false,true);
            }
        }
        return null;
    }

    public static OnlineApplicationCardSetup__c getDefaultCardSetup(String cardType, String cardRestrictions) {
        
        for(OnlineApplicationCardSetup__c setup : m_cardSetups) {
            if(setup.Card_Type__c == cardType && setup.Card_Restrictions__c == cardRestrictions) {
                return setup.clone(false,true);
            }
        }
        for(OnlineApplicationCardSetup__c setup : m_cardSetups) {
            if(setup.Card_Type__c == cardType) {
                return setup.clone(false,true);
            }
        }        
        return null;
    }


    public static Integer getSetupListMaximumRows() {
        return 25;
    }

    public static Id getDefaultContactRecordType() {
        
        Id rId = null;
        try {
        	rId = [select Id from RecordType where SObjectType = 'Contact' and Name = 'F1_Contact'].Id;
        }
        catch(Exception e) {}
        return rId;
    }

    //----------------
    // private
    //----------------
    
    private final static String BASE_APPLICATION_URL = 'Base Application URL';
    private final static String ECHOSIGN_API_KEY = 'EchoSign API Key';
    private final static String SMALL_FLEET_MAXIMUM = 'Small Fleet Maximum';
    
    private final static String THREATMETRIX_URL = 'ThreatMetrix URL';
    private final static String THREATMETRIX_ORG_ID = 'ThreatMetrix Org Id';
    private final static String THREATMETRIX_API_KEY = 'ThreatMetrix API Key';

    private static List<OnlineApplicationVehicleSetup__c> m_setups = new List<OnlineApplicationVehicleSetup__c> {
        
        new OnlineApplicationVehicleSetup__c(
            Vehicle_Type__c = CAR_SEDAN,             Fuel_Grade__c = UNLEADED, Fuel__c = 100, Maintenance__c = 100, Additives__c = 20, Miscellaneous__c = 0),
        new OnlineApplicationVehicleSetup__c(
            Vehicle_Type__c = LIGHT_TRUCK_VAN,       Fuel_Grade__c = UNLEADED, Fuel__c = 150, Maintenance__c = 150, Additives__c = 30, Miscellaneous__c = 0),
        new OnlineApplicationVehicleSetup__c(
            Vehicle_Type__c = MID_SIZE_TRUCK,        Fuel_Grade__c = UNLEADED, Fuel__c = 300, Maintenance__c = 200, Additives__c = 50, Miscellaneous__c = 0),
        new OnlineApplicationVehicleSetup__c(
            Vehicle_Type__c = LARGE_TRUCK_EQUIPMENT, Fuel_Grade__c = UNLEADED, Fuel__c = 500, Maintenance__c = 300, Additives__c = 100, Miscellaneous__c = 0)
    };

    private static List<OnlineApplicationCardSetup__c> m_cardSetups = new List<OnlineApplicationCardSetup__c> {
    
        new OnlineApplicationCardSetup__c(
            Card_Type__c = TRAVEL_CARD, Card_Restrictions__c = ALL_MERCHANTS, Credit_Limit__c = 3500, Cash__c = 10),
        new OnlineApplicationCardSetup__c(
            Card_Type__c = PURCHASE_CARD, Card_Restrictions__c = ALL_MERCHANTS, Credit_Limit__c = 5000, All_Merchants__c = 1500),
        new OnlineApplicationCardSetup__c(
            Card_Type__c = FLEET_DRIVER_CARD, Card_Restrictions__c = FUEL_ONLY, Credit_Limit__c = 1500, Fuel__c = 200),
        new OnlineApplicationCardSetup__c(
            Card_Type__c = FLEET_DRIVER_CARD, Card_Restrictions__c = FUEL_AND_MAINT, Credit_Limit__c = 2500, Fuel__c = 200, Maint__c = 400),
        new OnlineApplicationCardSetup__c(
            Card_Type__c = FLEET_DRIVER_CARD, Card_Restrictions__c = ALL_MERCHANTS, Credit_Limit__c = 3500, Cash__c = 10, All_Merchants__c = 500, Fuel__c = 250, Maint__c = 500)            
    };
    
}

// EOF