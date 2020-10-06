public class WESApplicationRequestTriggerHandler {
    public static void matchVelocityProfile(List<WES_Application_Request__c> records, Map<Id, WES_Application_Request__c> oldMap) {
        Set<String> countryCodes = new Set<String>();
        Set<String> biggestVehicles = new Set<String>();
        for (WES_Application_Request__c req : records) {
            if (processRecordForProfileMatch(req, oldMap)) {
                countryCodes.add(req.Account_ISO_Country_Code__c);
                biggestVehicles.add(req.BiggestVehicle__c);
            }
        }

        if (!countryCodes.isEmpty() && !biggestVehicles.isEmpty()) {
            List<String> countryCodesList = new List<String>();
            for (String s : countryCodes) {
                countryCodesList.add('\'' + s + '\'');
            }
            String countries = String.join(countryCodesList, ',');

            List<Velocity_Profile__c> profList = Database.query('SELECT Country_code__c, LowerLimit__c, UpperLimit__c, VehicleType__c, VelocityProfile__c' +
                                                 ' FROM' +
                                                 ' Velocity_Profile__c' +
                                                 ' WHERE' +
                                                 ' Country_code__c INCLUDES (' + countries + ')' +
                                                 ' AND' +
                                                 ' VehicleType__c IN :biggestVehicles');

            for (WES_Application_Request__c req : records) {
                if (processRecordForProfileMatch(req, oldMap)) {
                    req.VelocityProfile__c = 'No Match Found';
                    for (Velocity_Profile__c prof : profList) {
                        if (prof.Country_code__c.split(';').contains(req.Account_ISO_Country_Code__c)
                                && prof.LowerLimit__c < req.Litrespendpervehicle__c
                                && prof.UpperLimit__c >= req.Litrespendpervehicle__c
                                && prof.VehicleType__c == req.BiggestVehicle__c) {
                            req.VelocityProfile__c = prof.VelocityProfile__c;
                            break;
                        }
                    }
                }
            }
        }
    }

    private static Boolean processRecordForProfileMatch(WES_Application_Request__c req, Map<Id, WES_Application_Request__c> oldMap) {
        Boolean isInsert = oldMap == null;
        if (req.Account_ISO_Country_Code__c!=null
                && req.ofVehicles__c!=null && req.ofVehicles__c >0
                && req.MonthlyFuelVolumeLitres__c   !=null
                && req.BiggestVehicle__c!=null
                &&  (isInsert
                     || req.Account_ISO_Country_Code__c != oldMap.get(req.Id).Account_ISO_Country_Code__c
                     || req.ofVehicles__c != oldMap.get(req.Id).ofVehicles__c
                     || req.MonthlyFuelVolumeLitres__c   != oldMap.get(req.Id).MonthlyFuelVolumeLitres__c   
                     || req.BiggestVehicle__c != oldMap.get(req.Id).BiggestVehicle__c)) {
            return true;
        } else {
            return false;
        }
    }

    public static void checkDNBIntegration(List<WES_Application_Request__c> records, Map<Id, WES_Application_Request__c> oldMap) {
        if (!System.isFuture()) {
            Set<Id> reqIds = new Set<Id> ();
            Boolean isInsert = oldMap == null;
            Id recTypeId = UtilityClass.getRecTypeByDevName('WES_Application_Request__c','WES_Limited_Company');

            for (WES_Application_Request__c req : records) {
                if ( !DNBIntegration.processedIds.contains(req.Id)
                        && req.RecordTypeId == recTypeId
                        && req.Application_Status__c == 'Being Credit Checked'
                        && req.Companies_House_Check__c == 'Pass'
                        && (
                            isInsert
                            || req.RecordTypeId != oldMap.get(req.Id).RecordTypeId
                            || req.Application_Status__c != oldMap.get(req.Id).Application_Status__c
                            || req.Companies_House_Check__c != oldMap.get(req.Id).Companies_House_Check__c
                        )) {
                    reqIds.add(req.Id);
                    DNBIntegration.processedIds.add(req.Id);
                }
            }
            if (!reqIds.isEmpty()) {
                DNBIntegration.getFailureScoreAndRisk(reqIds);
            }
        }
    }

    public static void createCreditDetails(List<WES_Application_Request__c> records, Map<Id, WES_Application_Request__c> oldMap) {
        Map<Id, WES_Credit_Details__c> reqCreditDetailsMap = new Map<Id, WES_Credit_Details__c>();
        for (WES_Application_Request__c req : records) {
            if (req.WES_Credit_Details__c==null) {
                WES_Credit_Details__c cd = new WES_Credit_Details__c();
                cd.WES_Application_Request__c = req.Id;
                reqCreditDetailsMap.put(req.Id, cd);
            }
        }

        if (!reqCreditDetailsMap.isEmpty()) {
            insert reqCreditDetailsMap.values();

            List<WES_Application_Request__c> reqList = [SELECT Id, WES_Credit_Details__c FROM WES_Application_Request__c WHERE Id IN : reqCreditDetailsMap.keySet()];
            for (WES_Application_Request__c req : reqList) {
                req.WES_Credit_Details__c = reqCreditDetailsMap.get(req.Id).Id;
            }

            update reqList;

            Set<Id> creditDetailsIds = new Set<Id>();
            for (WES_Credit_Details__c cd : reqCreditDetailsMap.values()) {
                if ( !DNBIntegration.processedIds.contains(cd.Id)) {
                    creditDetailsIds.add(cd.Id);
                    DNBIntegration.processedIds.add(cd.Id);
                }
            }
            if (!creditDetailsIds.isEmpty()) {
                DNBIntegration.getBusinessReport(creditDetailsIds);
            }
        }
    }

    public static void createFuelPacks(List<WES_Application_Request__c> records, Map<Id, WES_Application_Request__c> oldMap) {
        Boolean isInsert = oldMap == null;
        List<WES_Fuel_Card_Pack__c> cpList = new List<WES_Fuel_Card_Pack__c>();
        for (WES_Application_Request__c req: records) {
            if (req.Fuel_Card_Packs__c!=null
                    && (isInsert
                        || ((req.Fuel_Card_Packs__c != oldMap.get(req.Id).Fuel_Card_Packs__c)
                            &&  req.Fuel_Card_Packs__c > req.Total_Card_Packs__c))) {
                Integer fuelPacksToBeCreated = Integer.valueOf(isInsert ? req.Fuel_Card_Packs__c : (req.Fuel_Card_Packs__c - req.Total_Card_Packs__c));
                for (Integer i=0; i<fuelPacksToBeCreated; i++) {
                    WES_Fuel_Card_Pack__c cp = new WES_Fuel_Card_Pack__c();
                    cp.Card_Type__c = req.Default_Card_Type__c;
                    cp.Additional_Embossed_Line__c = req.Default_Additional_Embossed_Line__c;
                    cp.WES_Application_Request__c = req.Id;
                    cpList.add(cp);
                }
            }
        }

        if (!cpList.isEmpty()) {
            insert cpList;
        }
    }

    public static void createFuelCards(List<WES_Application_Request__c> records, Map<Id, WES_Application_Request__c> oldMap) {
        Boolean isInsert = oldMap == null;
        Set<Id> reqIds = new Set<Id> ();
        for (WES_Application_Request__c req: records) {
            if (req.Create_Fuel_Cards__c==true
                    && (isInsert
                        || req.Total_Fuel_Cards_Needed__c > req.Total_Fuel_Cards__c)) {
                reqIds.add(req.Id);
            }
        }

        if (!reqIds.isEmpty()) {
            Map<Id, RecordType> defaultRecTypes = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE SobjectType = 'WES_Fuel_Card_Default__c']);
            Map<String, Id> cardRecTypes = new Map<String, Id>();
            for (RecordType recType : [SELECT Id, Name FROM RecordType WHERE SobjectType = 'WES_Fuel_Card__c']) {
                cardRecTypes.put(recType.Name, recType.Id);
            }

            List<WES_Fuel_Card__c> fuelCards = new List<WES_Fuel_Card__c>();

            List<WES_Application_Request__c> reqList = [SELECT Id, Create_Fuel_Cards__c,
                                             (SELECT Id, Card_Type__c FROM WES_Fuel_Card_Packs1__r WHERE Fuel_Cards_Needed__c > 0 AND Fuel_Cards_in_Pack__c = 0),
                                             (SELECT Id, RecordTypeId, Invoice_Sort_Label__c, National_International__c, Other_Networks__c, PIN__c, PIN_Creation_Method__c, PIN_Type__c, POS_Prompt__c, Purchase_Option_Fuel__c, Purchase_Option_Products__c, Purchase_Option_Services__c, Toll_Usage__c, Truck_Fleet__c, Application_Velocity_Profile__c, Card_Holder_Type__c FROM WES_Fuel_Card_Defaults_Defaults__r)
                                             FROM WES_Application_Request__c WHERE Id IN : reqIds];

            for (WES_Application_Request__c req : reqList) {
                for (WES_Fuel_Card_Pack__c cp : req.WES_Fuel_Card_Packs1__r) {
                    List<String> cardTypes = (cp.Card_Type__c!=null) ? cp.Card_Type__c.split(';') : new List<String>();
                    for (String cardType : cardTypes) {
                        for (WES_Fuel_Card_Default__c def: req.WES_Fuel_Card_Defaults_Defaults__r) {
                            if (defaultRecTypes.get(def.RecordTypeId).Name.contains(cardType)) {
                                WES_Fuel_Card__c fc = new WES_Fuel_Card__c();
                                fc.Card_Type__c = cardType;
                                fc.Invoice_Sort_Label__c = def.Invoice_Sort_Label__c;
                                fc.National_International__c = def.National_International__c;
                                fc.Other_Networks__c = def.Other_Networks__c;
                                fc.PIN__c = def.PIN__c;
                                fc.PIN_Creation_Method__c = def.PIN_Creation_Method__c;
                                fc.PIN_Type__c = def.PIN_Type__c;
                                fc.POS_Prompt__c = def.POS_Prompt__c;
                                fc.Purchase_Option_Fuel__c = def.Purchase_Option_Fuel__c;
                                fc.Purchase_Option_Products__c = def.Purchase_Option_Products__c;
                                fc.Purchase_Option_Services__c = def.Purchase_Option_Services__c;
                                fc.Toll_Usage__c = def.Toll_Usage__c;
                                fc.Truck_Fleet__c = def.Truck_Fleet__c;
                                fc.Velocity_Control_Profiler__c = def.Application_Velocity_Profile__c;
                                fc.WESFuelCardPack__c = cp.Id;
                                fc.WES_Application_Request__c = req.Id;
                                fc.RecordTypeId = cardRecTypes.get(cardType);
                                fc.CardHolderType__c = def.Card_Holder_Type__c;
                                fuelCards.add(fc);
                            }
                        }
                    }
                }

                req.Create_Fuel_Cards__c = false;
            }

            if (!fuelCards.isEmpty()) {
                insert fuelCards;
            }

            update reqList;
        }
    }

    public static void sendApplicationToIFCS(List<WES_Application_Request__c> records, Map<Id, WES_Application_Request__c> oldMap) {
        if (!System.isFuture()) {
            Set<Id> reqIds = new Set<Id> ();
            Boolean isInsert = oldMap == null;
            for (WES_Application_Request__c req : records) {
                if ( !IFCSIntegration.processedIds.contains(req.Id)
                        && req.Send_App_to_IFCS__c == true
                        && (
                            isInsert
                            || req.Send_App_to_IFCS__c != oldMap.get(req.Id).Send_App_to_IFCS__c
                        )) {
                    reqIds.add(req.Id);
                    IFCSIntegration.processedIds.add(req.Id);
                }
            }
            if (!reqIds.isEmpty()) {
                IFCSIntegration.sendApplicationToIFCS(reqIds);
            }
        }
    }
}