/**
*  This class is used as a controller on Risk flag VF page.
*  used to auto populate field HLA Level from related Account.
*/
public with sharing class EMAP_RiskFlag_Controller {

    public Risk_Flag__c riskFlag {get; set;}
    public ApexPages.StandardController stdController;
    public String accId = '';

    public EMAP_RiskFlag_Controller(ApexPages.StandardController controller) {
        this.stdController = controller;
        this.riskFlag = (Risk_Flag__c) stdController.getRecord();
        
        accId = ApexPages.CurrentPage().getParameters().get('accId');
         if(accId != null){

            Account acc = [Select id, Name, Percent_Credit_Utilization__c From Account Where id=: accId ];
            
            riskFlag.Account__c = acc.id;
            riskFlag.HLA_Level__c = acc.Percent_Credit_Utilization__c;
            riskFlag.Schedule_Date__c = EMAP_DateTime_Handler.AddBusinessDays(Date.today(), 3);

    }
   }
    /** This method is used to save and create new Credit Assessment record
    */
    public PageReference SaveAndNew() {
        try{
            // code to do saving goes here
            stdController.save();
        
            PageReference pageRef = new PageReference('/apex/EMAP_RiskFlag_Page?retURL=%2F'+ accId +'&accId='+accId );
            pageRef.setRedirect(true);
            return pageRef;
            
        } catch(Exception ex){
            System.debug('Save failed. Reason is::-'+ex.getMessage());
            return null;
        }
    }

}