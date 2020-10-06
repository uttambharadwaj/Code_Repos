/**
* Forseva consumer credit check code.
*/
trigger DnBDecisionSupportInsert on forseva1__DnBDecisionSupport__c (after insert) {

    List<Account> updateList = new List<Account>();

    for(forseva1__DnBDecisionSupport__c ds : Trigger.new) {
    	
    	Account a = new Account(Id = ds.forseva1__Account__c);

        if(ds.forseva1__STRT_YR__c != null) {
            a.Business_Start_Date_D_B__c = ds.forseva1__STRT_YR__c;
        }
        if(ds.forseva1__PRIM_SIC__c != null) {
            a.SIC_Code_D_B__c = ds.forseva1__PRIM_SIC__c;
        }
        if(ds.forseva1__CR_SCR_CLAS__c != null) {
            a.Credit_Score_Class_D_B__c = ds.forseva1__CR_SCR_CLAS__c;
        }
        if(ds.forseva1__PAYD_SCR__c != null) {
            a.Paydex_Score_D_B__c = ds.forseva1__PAYD_SCR__c;
        }
        
        updateList.add(a);
    }
    
    update updateList;

}

// EOF