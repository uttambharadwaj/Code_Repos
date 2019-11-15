/**
* This class is used as a controller in RPSCommonAccountPage VF page
* and it is used to perform RPS check and Common Account check on Account record during Credit Assessment
*/
public with sharing class EMAP_RPSCommonAccount_Controller
{
    public Id CreditRecordId {get;set;}
    public Credit_Assessment__c creditAssessment {get; set;}
    public string IsRPSButton {get; set;}
    public string IsCommonAccButton{get;set;}
    public Boolean isCommonAcc {get; set;}    
    public String redirectUrl {get; set;}
    public String selectedAcc {get; set;}
    public Boolean isResultFound {get; set;}
    public Boolean isEMAPAccsFound {get; set;}
    public List<Restricted_Account__c> restrictedList {get;set;}
    public List<checkWrapper> restrictedCommonList{get; set;}
    public List<Account> emapAccList;
    public List<checkWrapper> emapCommonAccList {get; set;}
    
    public EMAP_RPSCommonAccount_Controller(ApexPages.StandardController controller) 
    {
        CreditRecordId = ApexPages.currentPage().getParameters().get('Id'); 

        this.redirectUrl = '/'+CreditRecordId;
        
        //parameters set in URL and URL called from on click of RPS check and common account check button
        IsRPSButton = ApexPages.currentPage().getParameters().get('IsRPSButton');
        IsCommonAccButton = ApexPages.currentPage().getParameters().get('IsCommonAccButton');

    }
    
    //This method is used to populate Restricted, Common and EMAP accoun list on VF page
    public void populateAccountList(){

        creditAssessment = [select  Account__r.Name , Account__r.ShippingCountry ,Common_Account_Check__c, RPS_Outcome__c 
                            From Credit_Assessment__c Where id=:CreditRecordId];
        
        //Account Name associated with Credit Assessment
        String accName = creditAssessment.Account__r.Name ;
        
        String queryNameStr = '';
        
        if(accName != null && accName != ''){
            if(accName.length() > 10)
            {
                accName = accName.substring(0, 10);
                
                queryNameStr = ' Name LIKE \''+String.escapeSingleQuotes(accName)+'%\' ';
            }
            else
            {                
                queryNameStr = ' Name = \'' + accName + '\' ';
            }
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Account field can not be empty.'));
        }
        
        String restrictedList_query = ''; //Restricted Accounts query string
        String commonEMAPAccList_query = ''; //Restricted EMAP Accounts query string
        
        //Note: RPS check not getting used in this EMAP project
        if(IsRPSButton == 'Yes')
        {
            isCommonAcc = false;
            
            String Country = creditAssessment.Account__r.ShippingCountry;
            
            restrictedList_query = 'Select Name,Type__c , Country__c From Restricted_Account__c Where Country__c =: Country AND '+ queryNameStr +' AND Type__c =\'Restricted Account\' ';
        }
        
        if(IsCommonAccButton == 'Yes')
        {
            isCommonAcc = true;
            
            restrictedList_query = 'Select Name,Type__c , Country__c From Restricted_Account__c Where ' + queryNameStr + ' AND Type__c =\'Common Account\' ';

            commonEMAPAccList_query = 'Select Id, Name, AU_Account_Number__c, ShippingCountry, Status__c, Account_Sub_Status__c, Client_Name__c ' +
                                            ' From Account ' +
                                            ' Where RecordType.Name = \'EMAP Fuel Accounts\' AND Id != \'' + creditAssessment.Account__r.id + '\' AND ' + queryNameStr + ' ' +
                                            ' AND Id IN (SELECT AccountId FROM Opportunity WHERE Product_Type__c = \'Mobil Card\') ';

            //execute query to get list of Restricted accounts or Common accounts
            restrictedList = Database.query(restrictedList_query);
            
            if(restrictedList.size() > 0){
                isResultFound = true;
                
                //list of common accounts from Restricted and common accounts object 
                restrictedCommonList = new List<checkWrapper>();
                
                for(Restricted_Account__c res_com : restrictedList)
                {
                    checkWrapper cw = new checkWrapper(res_com, false);
                    
                    //result list of Common Accounts to be displayed on VF page
                    restrictedCommonList.add(cw);
                }
                
            } else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No common accounts found'));
            }
            
            //execute query to get list of EMAP common accounts
            emapAccList = Database.query(commonEMAPAccList_query);
            
            if(emapAccList.size() > 0){
                isEMAPAccsFound = true;
                
                //list of emap common accounts from Account object 
                emapCommonAccList = new List<checkWrapper>();
                
                for(Account emapCommonAcc: emapAccList){
                    
                    checkWrapper chkWrapper = new checkWrapper(emapCommonAcc, false);
                    
                    //result list of EMAP Common Accounts to be displayed on VF page
                    emapCommonAccList.add(chkWrapper);
                }
            } else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No EMAP Accounts found'));
            }
        
        }
        
    }

    //This method is used to set matched Account names in RPS Account Match result on Credit Assessment record
    public PageReference matchRecord()
    {
        //System.debug('selectedAcc::-'+selectedAcc);

        if(IsRPSButton == 'Yes')
        {    
            creditAssessment.RPS_Outcome__c = selectedAcc;
        }
        if(IsCommonAccButton == 'Yes') 
        {
            creditAssessment.Common_Account_Check__c = selectedAcc;
        }

        update creditAssessment ; 
        
        return null;
    }
    
    //This method is used to set matched Account names in Common Account Match result on Credit Assessment record
    public PageReference matchRecordNew()
    {
        String selectedCommAcct = '';
        if(IsCommonAccButton == 'Yes') 
        {
            if(restrictedCommonList != null && restrictedCommonList.size() > 0){

                for(checkWrapper cwp: restrictedCommonList)
                {
                    if(cwp.selectCheck == true)
                    {
                        if((selectedCommAcct .trim()).length() == 0)
                        {
                            selectedCommAcct = cwp.RestrictedCommonAccount.name + ':' + cwp.RestrictedCommonAccount.Country__c;
                        }
                        else
                        {
                            selectedCommAcct = selectedCommAcct + ';\n'+cwp.RestrictedCommonAccount.name  + ':' + cwp.RestrictedCommonAccount.Country__c;
                            //System.debug('##########'+selectedCommAcct );
                        }
                        
                    }
                }

                creditAssessment.Common_Account_Check__c = selectedCommAcct;
            }
            
            String selectedEMAPAcct = '';
            
            if(emapCommonAccList != null && emapCommonAccList.size() > 0){

                for(checkWrapper emapAcct: emapCommonAccList )
                {
                    if(emapAcct.selectCheck == true)
                    {
                        if((selectedEMAPAcct.trim()).length() == 0)
                        {
                            selectedEMAPAcct = emapAcct.emapAcc.name;
                        }
                        else
                        {
                            selectedEMAPAcct = selectedEMAPAcct + ';\n'+ emapAcct.emapAcc.name;
                            //System.debug('##########'+selectedEMAPAcct );
                        }
                    }
                }
                if(selectedCommAcct != ''){
                    creditAssessment.Common_Account_Check__c = selectedCommAcct + '\n' + selectedEMAPAcct ; 
                } else {
                    creditAssessment.Common_Account_Check__c = selectedEMAPAcct ;   
                }               
            }
    
            update creditAssessment ; 
        
        }
        return null;
    }

    //This method is used to set no match result if match not found on RPS or Common Accounts check
    public PageReference noMatchRecord()
    {   
        if(IsRPSButton == 'Yes')
        {    
            creditAssessment.RPS_Outcome__c = 'No Match';
        }
        if(IsCommonAccButton == 'Yes') 
        {
            creditAssessment.Common_Account_Check__c = 'No Match';
        }
        update creditAssessment ;   
             
        return null;
    }
    
    //used to get selected radio button value
    public PageReference getSelected() {
        return null;
    }
    
    //This method used to clear previous RPS or Common Account match result
    public void clearPrevResults() {
        if(IsRPSButton == 'Yes')
        {    
            creditAssessment.RPS_Outcome__c = '';
        }
        if(IsCommonAccButton == 'Yes') 
        {
            creditAssessment.Common_Account_Check__c = '';
        }

        update creditAssessment;
    }
    
    //This wrapper class used to set Common Accounts along with its default checkbox value on VF page
    public class checkWrapper
    {
        public Account emapAcc {get; set;}
        public Restricted_Account__c RestrictedCommonAccount {get; set;}
        public boolean selectCheck {get; set;}
        
        public checkWrapper (Restricted_Account__c restacc, boolean b)
        {
            this.RestrictedCommonAccount = restacc;
            selectCheck = b;
        }
        
        public checkWrapper (Account emapAcc, boolean b)
        {
            this.emapAcc = emapAcc;
            selectCheck = b;
        }
    }    
}