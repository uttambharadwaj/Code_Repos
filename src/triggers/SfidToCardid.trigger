trigger SfidToCardid on Lead (before insert,before update) {
    if(TriggerFactory.disabledTriggers(Lead.sObjectType)) return;
	Set<Id> AU_Lead_RTs = UtilityClass.getRecTypeByDevName('Lead',new List<String>{'AU_Fuel_Application_Individual','AU_Fuel_Business','AU_Fuel_Merchant','AU_Fuel_Prepaid','AU_VCC'});
	
	List<String> SfIDs = new List<string>();
    for(Lead  L : Trigger.new)
    {
    	if(!AU_Lead_RTs.contains(L.RecordTypeId))
    	{
	        if(L.Card_Program_ID__c != null && L.Card_Program_ID__c != '')
	        {
	            SfIDs.add( L.Card_Program_ID__c);
	           
	        }
    	}
        
    }

    Map <String,Schema.RecordTypeInfo> recordTypes =account.sObjectType.getDescribe().getRecordTypeInfosByName();
    Map<String,Account> AllRequiredAcc = new  Map<String,Account>();
     if(recordTypes.containskey('Card Program'))
    {
    
        List <Account> accList = [select id from account where Recordtypeid =: recordTypes.get('Card Program').getRecordTypeId() And id in : SfIDs ]; 
          for(Account acc: accList )
        {
            AllRequiredAcc.put(acc.id,acc);
            String ACcID= acc.id;
            AllRequiredAcc.put(ACcID.substring(0,ACcID.length() - 3),acc);
        }
    }
    
    
     for(Lead  L : Trigger.new)
    {
    	if(!AU_Lead_RTs.contains(L.RecordTypeId))
        {
       // if(L.Initial_Contact_Method__c != null && L.Initial_Contact_Method__c ==  'Webform')
        //{
             if(L.Card_Program_ID__c != null && L.Card_Program_ID__c != '')
            {
               if(AllRequiredAcc.containskey(L.Card_Program_ID__c))
               {
                    L.Card_Program__c = L.Card_Program_ID__c ;
               }
               
            }
        //}
        }
    }
    
 

}