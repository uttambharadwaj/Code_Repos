/**
* This class is used as a Trigger handler for Bank Reference and Trade Reference objects
* Includes all the actions to be performed before or after specific trigger events
* BR : Bank Reference
* TR : Trade Reference
*/
public with sharing class EMAP_Bank_Trade_ReferenceTriggerHandler 
{
    public static final Map<String, Schema.SObjectType> globalDesc = Schema.getGlobalDescribe(); 
    public static Schema.RecordTypeInfo appReqRecType = getRecordTypeInfo('AU_Application_Request__c', 'EMAP Application Request');
    public static boolean isBank = false;
    public static boolean isTrade = false;
    public static boolean isApplication = false;
    
    /* used to get Record Type info on any object
    *  Parameters: Object name and Record Type name
    */
    public static Schema.RecordTypeInfo getRecordTypeInfo(String objectName, String recordTypeName){
                
        if(globalDesc.containsKey(objectName)){
                Schema.SObjectType d = globalDesc.get(ObjectName);
                Schema.DescribeSObjectResult r = d.getDescribe();
                Map<String,Schema.RecordTypeInfo> rtMapByName = r.getRecordTypeInfosByName();
                
                return rtMapByName.get(recordTypeName);                 
        }
        else {
            return null;
        }    
    }
    
    /* used to propagate BR details on AU App Req's Bank Ref fields 
    *  Parameters: List of new BR records
    */
    public void createBankReference_OnAU(list<Bank_Reference__c> bankNewList)
    {
        try
        {
            if(isBank == false)
            {
                List<ID> Bank_ID = new List<ID>();
                Map<Id, Bank_Reference__c> BanRefMap = new Map<Id, Bank_Reference__c>();

                for(Bank_Reference__c BRNew : bankNewList)
                {
                    Bank_ID.add(BRNew.id);
                    BanRefMap.put(BRNew.AU_Application_Request__c, BRNew);
                }
                
                if(Bank_ID != null && Bank_ID.size() > 0)
                {
                    List<AU_Application_Request__c> AU_List = new List<AU_Application_Request__c>();
                    AU_List = [select id, Application_Status__c, Bank_Reference__c, Bank_Name__c, Bank_Account_Type__c, Bank_Account_Number__c, Date_Open__c, 
                            Mailing_Address__c, Bank_Contact_Phone__c, Bank_Contact_Fax__c, Bank_Payment_History__c, RecordTypeId 
                            From AU_Application_Request__c 
                            Where Bank_Reference__c IN:Bank_ID AND RecordTypeId =: appReqRecType.getRecordTypeId()];

                    if(AU_List != null && AU_List.size() > 0){
                    
                        List<AU_Application_Request__c> AU_ListToUpdate = new List<AU_Application_Request__c>();

                        for(AU_Application_Request__c AU: AU_List)
                        {
                            if(AU.recordTypeId == appReqRecType.getRecordTypeId()){
                                Bank_Reference__c BLTemp = BanRefMap.get(AU.id);
                                
                                if( AU.Application_Status__c != 'Fulfilled')
                                {
                                    AU.Bank_Name__c = BLTemp.Name;
                                    AU.Bank_Account_Type__c = BLTemp.Bank_Account_Type__c;
                                    AU.Bank_Account_Number__c = BLTemp.Bank_Account_Number__c;
                                    AU.Date_Open__c  = BLTemp.Bank_Date_Open__c;
                                    AU.Mailing_Address__c = BLTemp.Mailing_Address__c;
                                    AU.Bank_Contact_Phone__c = BLTemp.Bank_Phone__c;
                                    AU.Bank_Contact_Fax__c = BLTemp.Bank_Fax__c;
                                    AU.Bank_Payment_History__c = BLTemp.Bank_Payment_History__c;
                                    
                                    AU_ListToUpdate.add(AU);
                                }
                            }
                        }
                        
                        isBank = true;
                        isApplication =true;
                        Update AU_ListToUpdate; 
                    }
                }
            }
        } 
        catch(Exception ex) 
        {
            System.debug('Trigger failed. Reason is::-'+ex.getMessage());
        }    
    }
    
    /* used to propagate TR1 and TR2 details on AU App Req's Trade Ref1 and Trade Ref1 fields respectively
    *  Parameters: List of new TR records
    */
    public void createTradeReference_OnAU(list<Trade_Reference__c> TradeRefNew)
    {
        try
        {
            if(isTrade == false)
            {
                List<ID> Trade_ID = new List<ID>();
                Map<Id, Trade_Reference__c> TradeRefMap = new Map<Id, Trade_Reference__c>();
                for(Trade_Reference__c TRNew : TradeRefNew)
                {
                    Trade_ID.add(TRNew.id);
                    TradeRefMap.put(TRNew.AU_Application_Request__c, TRNew);
                }
        
                List<AU_Application_Request__c> AU_ListToUpdate = new List<AU_Application_Request__c>();
                system.debug('******Trade_ID****'+ Trade_ID);    
                //update AU App Req's Trade Ref1 with TR1 details
                if(Trade_ID != null && Trade_ID.size() > 0)
                {
                	system.debug('******appReqRecType.getRecordTypeId()****'+ appReqRecType.getRecordTypeId());  
                    List<AU_Application_Request__c> AU_List = new List<AU_Application_Request__c>();
                    AU_List = [select id, Application_Status__c, Trade_Reference__c, Trade_Reference1__c, Trade_Contact_Name__c, Trade_Contact_Name1__c, Trade_Supplier_Type__c,
                            Trade_Supplier_Type1__c, Trade_Account_Number__c, Trade_Account_Number1__c, Trade_Date_Open__c, Trade_Date_Open1__c, Street_Address__c, Street_Address1__c, 
                            Trade_Contact_Phone__c, Trade_Contact_Phone1__c, Trade_Contact_Fax__c, Trade_Contact_Fax1__c, Trade_Payment_History__c, Trade_Payment_History1__c, RecordTypeId  
                            From AU_Application_Request__c 
                            Where Trade_Reference__c IN:Trade_ID AND RecordTypeId =: appReqRecType.getRecordTypeId()];
             		           
                    if(AU_List != null && AU_List.size() > 0){
                        
                        for(AU_Application_Request__c AU: AU_List)
                        {
                            if(AU.recordTypeId == appReqRecType.getRecordTypeId()){
                            
                                Trade_Reference__c TRTemp = TradeRefMap.get(AU.id);
     
                                if(AU.Application_Status__c != 'Fulfilled')
                                {
                                    AU.Trade_Contact_Name__c = TRTemp.Name;
                                    AU.Trade_Supplier_Type__c = TRTemp.Trade_Supplier_Type__c;
                                    AU.Trade_Account_Number__c = TRTemp.Trade_Account_Number__c;
                                    AU.Trade_Date_Open__c  = TRTemp.Trade_Date_Open__c;
                                    AU.Street_Address__c = TRTemp.Street_Address__c;
                                    AU.Trade_Contact_Phone__c = TRTemp.Trade_Phone__c;
                                    AU.Trade_Contact_Fax__c = TRTemp.Trade_Fax__c;
                                    AU.Trade_Payment_History__c = TRTemp.Trade_Payment_History__c;
                                    
                                    AU_ListToUpdate.add(AU);
                                }
                            }
                        }
                    }
                    
                    List<AU_Application_Request__c> AU_List1 = new List<AU_Application_Request__c>();
                    AU_List1 = [select id, Application_Status__c, Trade_Reference__c, Trade_Reference1__c, Trade_Contact_Name__c, Trade_Contact_Name1__c, Trade_Supplier_Type__c, 
                            Trade_Supplier_Type1__c, Trade_Account_Number__c, Trade_Account_Number1__c, Trade_Date_Open__c, Trade_Date_Open1__c, Street_Address__c, Street_Address1__c, 
                            Trade_Contact_Phone__c, Trade_Contact_Phone1__c, Trade_Contact_Fax__c, Trade_Contact_Fax1__c, Trade_Payment_History__c, Trade_Payment_History1__c, RecordTypeId  
                            From AU_Application_Request__c 
                            Where Trade_Reference1__c IN:Trade_ID  AND RecordTypeId =: appReqRecType.getRecordTypeId()];
                
                    //update AU App Req's Trade Ref2 with TR2 details
                    if(AU_List1 != null && AU_List1.size() > 0)
                    {   
                        for(AU_Application_Request__c AU: AU_List1)
                        {
                            if(AU.recordTypeId == appReqRecType.getRecordTypeId()){

                                Trade_Reference__c TRTemp = TradeRefMap.get(AU.id);

                                if(AU.Application_Status__c != 'Fulfilled')
                                {
                                    AU.Trade_Contact_Name1__c = TRTemp.Name;
                                    AU.Trade_Supplier_Type1__c = TRTemp.Trade_Supplier_Type__c;
                                    AU.Trade_Account_Number1__c = TRTemp.Trade_Account_Number__c;
                                    AU.Trade_Date_Open1__c  = TRTemp.Trade_Date_Open__c;
                                    AU.Street_Address1__c = TRTemp.Street_Address__c;
                                    AU.Trade_Contact_Phone1__c = TRTemp.Trade_Phone__c;
                                    AU.Trade_Contact_Fax1__c = TRTemp.Trade_Fax__c;
                                    AU.Trade_Payment_History1__c = TRTemp.Trade_Payment_History__c;

                                    AU_ListToUpdate.add(AU);
                                }
                            }
                        }
                    }
            
                    isTrade = true;
                    isApplication =true;
                    Update AU_ListToUpdate;
                }
            }
        }
        catch(Exception ex) 
        {
            System.debug('Trigger failed. Reason is::-'+ex.getMessage());
        }
    }
    
    /* used to propagate Bank Ref, Trade Ref1 and Trade Ref2 details from AU App Req to BR, TR1 and TR2 respectively
    *  Parameters: List of new BR records
    */
    public void CreateBankTradeReference_FromAU(list<AU_Application_Request__c> AU_ApplicationRequest)
    {
        try{
        	system.debug('#####'+isApplication);
        if(isApplication == false)
        {
            List<ID> BankIDs = new List<ID>();
            List<ID> TradeIDs = new List<ID>();
            Map<Id, AU_Application_Request__c> AUAppReqMap = new Map<Id, AU_Application_Request__c>();
            
            for(AU_Application_Request__c AU : AU_ApplicationRequest)
            {
                if(AU.recordTypeId == appReqRecType.getRecordTypeId()){
                    if(AU.Bank_Reference__c != null){
                        BankIDs.add(AU.Bank_Reference__c);
                    }
                    if(AU.Trade_Reference__c != null){
                        TradeIDs.add(AU.Trade_Reference__c);
                    }
                    if(AU.Trade_Reference1__c != null){
                        TradeIDs.add(AU.Trade_Reference1__c);
                    }
                    
                    AUAppReqMap.put(AU.id, AU);
                }
            } 
            system.debug('***AUAppReqMap'+AUAppReqMap);
            if(BankIDs != null && BankIDs.size() > 0){
                List<Bank_Reference__c> BankList = new List<Bank_Reference__c>();
                BankList = [select id , name , AU_Application_Request__c,  Bank_Account_Type__c , Bank_Account_Number__c , Bank_Date_Open__c , Mailing_Address__c , 
                            Bank_Phone__c , Bank_Fax__c , Bank_Payment_History__c from Bank_Reference__c where id IN: BankIDs];
                            
                system.debug('@@@@@@@@'+ BankList);
                
                //update Bank Ref details from AU App Req
                List<Bank_Reference__c> BankListToUpdate = new List<Bank_Reference__c>();
                for(Bank_Reference__c BL : BankList)
                {
                    AU_Application_Request__c AU = AUAppReqMap.get(BL.AU_Application_Request__c);
                    
                    if(BL.id == AU.Bank_Reference__c)
                    {
                        BL.Name = AU.Bank_Name__c;
                        BL.Bank_Account_Type__c = AU.Bank_Account_Type__c;
                        BL.Bank_Account_Number__c = AU.Bank_Account_Number__c;
                        BL.Bank_Date_Open__c = AU.Date_Open__c;
                        BL.Mailing_Address__c =AU.Mailing_Address__c;
                        BL.Bank_Phone__c = AU.Bank_Contact_Phone__c;
                        BL.Bank_Fax__c = AU.Bank_Contact_Fax__c;
                        BL.Bank_Payment_History__c = AU.Bank_Payment_History__c;
                        
                        BankListToUpdate.add(BL);
                    }
                }
                
                isApplication = true;
                isTrade = true;
                isBank = true;
                update BankListToUpdate;
            }
            
            if(TradeIDs != null && TradeIDs.size() > 0){
                List<Trade_Reference__c> TradeList = new List<Trade_Reference__c>();
                TradeList = [select id , name , AU_Application_Request__c,  Trade_Supplier_Type__c , Trade_Account_Number__c , Trade_Date_Open__c ,Street_Address__c , 
                            Trade_Phone__c , Trade_Fax__c , Trade_Payment_History__c from Trade_Reference__c where id IN: TradeIDs];
                            
                system.debug('$$$$$$$$'+TradeList);

                //update Trade Ref1 and Trade Ref2 details from AU App Req   
                List<Trade_Reference__c> TradeListToUpdate = new List<Trade_Reference__c>();
                for(Trade_Reference__c TL : TradeList)
                {
                    AU_Application_Request__c AU = AUAppReqMap.get(TL.AU_Application_Request__c);

                    if(TL.id == AU.Trade_Reference__c)
                    {
                        //TL.Name = AU.Trade_Contact_Name__c;
                        TL.Trade_Supplier_Type__c = AU.Trade_Supplier_Type__c;
                        TL.Trade_Account_Number__c = AU.Trade_Account_Number__c;
                        TL.Trade_Date_Open__c = AU.Trade_Date_Open__c;
                        TL.Street_Address__c = AU.Street_Address__c;
                        TL.Trade_Phone__c = AU.Trade_Contact_Phone__c;
                        TL.Trade_Fax__c = AU.Trade_Contact_Fax__c;
                        TL.Trade_Payment_History__c = AU.Trade_Payment_History__c;
                    }
                    else if(TL.id == AU.Trade_Reference1__c)
                    {
                        //TL.Name = AU.Trade_Contact_Name1__c;
                        TL.Trade_Supplier_Type__c = AU.Trade_Supplier_Type1__c;
                        TL.Trade_Account_Number__c = AU.Trade_Account_Number1__c;
                        TL.Trade_Date_Open__c = AU.Trade_Date_Open1__c;
                        TL.Street_Address__c = AU.Street_Address1__c;
                        TL.Trade_Phone__c = AU.Trade_Contact_Phone1__c;
                        TL.Trade_Fax__c = AU.Trade_Contact_Fax1__c;
                        TL.Trade_Payment_History__c = AU.Trade_Payment_History1__c;
                    }

                    TradeListToUpdate.add(TL);
                }
                isApplication = true;
                isTrade = true;
                isBank = true;
                update TradeListToUpdate;
            }
        }
    
    }   
        catch(Exception ex) 
        {
            System.debug('Trigger failed. Reason is::-'+ex.getMessage());
        }
    }
}