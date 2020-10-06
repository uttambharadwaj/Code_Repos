/**
* Forseva consumer credit check code.
*/
trigger DnBCustomReportInsert on forseva1__DnBCustomReport__c (after insert) {

    List<Account> updateList = new List<Account>();

    for(forseva1__DnBCustomReport__c cr : Trigger.new) {
        
        Account a = new Account(Id = cr.forseva1__Account__c);

        if(cr.STRT_YR__c != null) {
            a.Business_Start_Date_D_B__c = cr.STRT_YR__c;
        }
        if(cr.PRIM_SIC__c != null) {
            a.SIC_Code_D_B__c = cr.PRIM_SIC__c;
        }
        if(cr.DELQ_SCR_ENTRSCR_GRPSCR_CLAS__c != null) {
            a.Credit_Score_Class_D_B__c = cr.DELQ_SCR_ENTRSCR_GRPSCR_CLAS__c;
        }
        if(cr.PAYD_SCR__c != null) {
            a.Paydex_Score_D_B__c = cr.PAYD_SCR__c;
        }
        
        updateList.add(a);
    }
    
    update updateList;

}

// EOF