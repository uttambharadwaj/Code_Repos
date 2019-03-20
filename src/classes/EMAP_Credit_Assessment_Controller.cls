/**
*  This class is used as a controller on Credit Assessment VF page.
*  used to auto populate fields from related Account and latest Approved Credit Assessment in that Account.
*/
public with sharing class EMAP_Credit_Assessment_Controller {

    public static final Map<String, Schema.SObjectType> globalDesc = Schema.getGlobalDescribe(); 
    public static Schema.RecordTypeInfo creditAssmntRecType = getRecordTypeInfo('Credit_Assessment__c', 'EMAP Credit Assessment');
    
    public Credit_Assessment__c credAssess {get; set;}
    public ApexPages.StandardController stdController;
    public String accId = '';
    
    public EMAP_Credit_Assessment_Controller(ApexPages.StandardController controller) {
        this.stdController = controller;
        this.credAssess = (Credit_Assessment__c) stdController.getRecord();
        
        accId = ApexPages.CurrentPage().getParameters().get('accId');
        if(accId != null){

            Account acc = [Select id, Name, Program_Currency__c, Payment_Days__c, Payment_Method__c, Total_Security_Value__c, Credit_Limit__c, Credit_Limit_Lcy__c, 
                            Credit_Limit_USD__c, Total_Exposure_Limit__c, Total_Exposure_Limit_USD__c, Risk_Grade__c 
                           From Account 
                           Where id=: accId ];

            List<Credit_Assessment__c> credAssList = 
                    [Select id, name, Account__c, Final_Judgement__c, Payment_Days__c, Payment_Method__c, Credit_Limit_Requested__c, Credit_Limit_Lcy__c, Approved_Credit_Limit_USD__c, 
                        Total_Exposure_Limit_LCY__c, Total_Exposure_Limit_USD__c, Aggregated_TEL_LCY__c, Aggregated_Tel_USD__c, Risk_Level__c, Nird__c,
                        Full_Assmt_Weighted_Score__c, Full_Assmt_Final_Score__c, Bureau_Name__c, Bureau_Score__c, Bureau_Score_Translated__c, Bureau_Comments__c 
                     From Credit_Assessment__c
                     Where Account__c =: accId AND Final_Judgement__c = 'Approved' Order by CreatedDate DESC Limit 1];
            
            //below lines of code is used auto populate fields from latest approved Credit Assessment
            if(credAssList != null && credAssList.size() > 0){
                Credit_Assessment__c credAssTemp = credAssList.get(0);
                
                credAssess.recordTypeId = creditAssmntRecType.getRecordTypeId();
                credAssess.Account__c = acc.id;
                //credAssess.Payment_Days__c = credAssTemp.Payment_Days__c;// commented on 6.6.2017 for BCPUL-1103
                //credAssess.Payment_Method__c = credAssTemp.Payment_Method__c;// commented on 6.6.2017 for BCPUL-1103
                credAssess.Payment_Days__c = acc.Payment_Days__c;//added on 6.6.2017 for BCPUL-1103
                credAssess.Payment_Method__c = acc.Payment_Method__c;//added on 6.6.2017 for BCPUL-1103
                credAssess.Credit_Limit_Requested__c = credAssTemp.Credit_Limit_Requested__c;
                credAssess.Credit_Limit_Lcy__c = credAssTemp.Credit_Limit_Lcy__c;
                credAssess.Approved_Credit_Limit_USD__c = credAssTemp.Approved_Credit_Limit_USD__c;
                //credAssess.Invoice_Frequency__c = credAssTemp.Invoice_Frequency__c;
                credAssess.Total_Exposure_Limit_LCY__c = credAssTemp.Total_Exposure_Limit_LCY__c;
                credAssess.Total_Exposure_Limit_USD__c = credAssTemp.Total_Exposure_Limit_USD__c;
                credAssess.Aggregated_TEL_LCY__c = credAssTemp.Aggregated_TEL_LCY__c;
                credAssess.Aggregated_Tel_USD__c = credAssTemp.Aggregated_Tel_USD__c;
                credAssess.Risk_Level__c = credAssTemp.Risk_Level__c;
                credAssess.Nird__c = credAssTemp.Nird__c;
                credAssess.Full_Assmt_Weighted_Score__c = credAssTemp.Full_Assmt_Weighted_Score__c;
                credAssess.Full_Assmt_Final_Score__c = credAssTemp.Full_Assmt_Final_Score__c;
                credAssess.Bureau_Name__c = credAssTemp.Bureau_Name__c;
                credAssess.Bureau_Score__c = credAssTemp.Bureau_Score__c;
                credAssess.Bureau_Score_Translated__c = credAssTemp.Bureau_Score_Translated__c;
                credAssess.Bureau_Comments__c = credAssTemp.Bureau_Comments__c;

            } 
            //below lines of code is used auto populate fields from related Account
            else {
        
                credAssess.recordTypeId = creditAssmntRecType.getRecordTypeId();
                credAssess.Account__c = acc.id;
                credAssess.Payment_Days__c = acc.Payment_Days__c;
                credAssess.Payment_Method__c = acc.Payment_Method__c;
                credAssess.Credit_Limit_Requested__c = acc.Credit_Limit__c;
                credAssess.Credit_Limit_Lcy__c = acc.Credit_Limit_Lcy__c;
                credAssess.Approved_Credit_Limit_USD__c = acc.Credit_Limit_USD__c;
                credAssess.Total_Exposure_Limit_LCY__c = acc.Total_Exposure_Limit__c;
                credAssess.Total_Exposure_Limit_USD__c = acc.Total_Exposure_Limit_USD__c;
                credAssess.Risk_Level__c = acc.Risk_Grade__c;
            }
            
            credAssess.Security_Value__c = acc.Total_Security_Value__c;
            credAssess.CurrencyIsoCode = acc.Program_Currency__c;
        }
        
    }
    
    /** This method is used to save and create new Credit Assessment record
    */
    public PageReference SaveAndNew() {
        try{
            // code to do saving goes here
            stdController.save();
        
            PageReference pageRef = new PageReference('/apex/EMAP_CreditAssessment_Page?retURL=%2F'+ accId +'&accId='+accId );
            pageRef.setRedirect(true);
            return pageRef;
            
        } catch(Exception ex){
            System.debug('Save failed. Reason is::-'+ex.getMessage());
            return null;
        }
    }

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
    
}