/**
* Forseva consumer credit check code.
*/
trigger CorteraCPRInsert on forseva1__CorteraCPR__c (after insert) {

    List<Account> updateList = new List<Account>();

    for(forseva1__CorteraCPR__c cpr : Trigger.new) {
        
        Account a = new Account(Id = cpr.forseva1__Account__c);

        if(cpr.forseva1__YearStarted__c != null) {
            a.Business_Start_Date_Cortera__c = cpr.forseva1__YearStarted__c;
        }
        if(cpr.forseva1__CprReportPrimarySic__c != null) {
            a.SIC_Code_Cortera__c = cpr.forseva1__CprReportPrimarySic__c;
        }
        if(cpr.forseva1__CprIndexSegment__c != null) {
            a.Payment_Risk_Segment_Cortera__c = cpr.forseva1__CprIndexSegment__c;
        }
        if(cpr.forseva1__CprIndexRating__c != null) {
            a.CPR_Score_Cortera__c = String.valueOf(cpr.forseva1__CprIndexRating__c);
        }
        
        updateList.add(a);
    }
    
    update updateList;

}

// EOF