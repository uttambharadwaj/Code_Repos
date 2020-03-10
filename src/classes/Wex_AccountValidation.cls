public class Wex_AccountValidation {
    
    @AuraEnabled
    public static string validateAccountAndZip( string aactNumber, string zipCode){
        system.debug('aactNumber: '+aactNumber);
        system.debug('zipCode: '+zipCode);
        List<Account> actlist = [Select Id, Name, Sponsor_Acct__c, BillingPostalCode, Phone, Carrier_ID__c, fax from Account];
        List<string> actNumberList = new List<string>();
        List<string> zipNumberist = new List<string>();
        string returnStatement ='';
        boolean isAccount = false;
        boolean isNAfleetAccount = false;
        boolean  isEFSAccount = false;
        boolean isZip = false;
        string actNumber = '';
        string carrierNumber='';
        string actzipcode = '';
        string platformName = '';
        List<Account> ziPNumberList = [Select Id, Name, Sponsor_Acct__c, BillingPostalCode, Phone, fax, Carrier_ID__c from Account where BillingPostalCode =:zipCode];
        List<Account> AccountNumberList = [Select Id, Name, Sponsor_Acct__c, BillingPostalCode, Phone, fax, Carrier_ID__c from Account 
                                           where (Sponsor_Acct__c =:aactNumber OR Carrier_ID__c=: aactNumber)];
        
        
        for(Account act : actlist){
            if(act.Sponsor_Acct__c == aactNumber){
                actNumber = act.Sponsor_Acct__c;
            }
            if(act.Carrier_ID__c == aactNumber){
                carrierNumber = act.Carrier_ID__c; 
            }
            if(act.BillingPostalCode == zipCode){
                actzipcode = act.BillingPostalCode;
            }
        }
        
        if(actlist.size()>0){
            for(Account acts: actlist){
                actNumberList.add(acts.Sponsor_Acct__c);
                zipNumberist.add(acts.BillingPostalCode);
            }
        }
        system.debug('zipNumberist: '+zipNumberist);
        
        if(AccountNumberList.size()>0){
            for(Account act:AccountNumberList){
                if( act.Sponsor_Acct__c == aactNumber){
                    isNAfleetAccount = true;
                }else if(act.Carrier_ID__c == aactNumber){
                    isEFSAccount =true;
                }
            }
            
        }else{
            isAccount = false;
            returnStatement = 'The Account Number is invalid';
        }
        
        
        
        if(ziPNumberList.size()>0){
            
            system.debug('zipCode: '+zipCode);
            isZip =true;
        } else{
            system.debug('Coming inside');
            isZip = false;
            returnStatement = 'The Postal Code is invalid';
            
        }
        if(ziPNumberList.size()==0 && AccountNumberList.size()==0){
            returnStatement = 'Both are invalid';
        }
        
        
        List<Account> act = new  List<Account>();
        if( (isNAfleetAccount || isEFSAccount) && isZip){
            
            act = [Select Id, Name, Sponsor_Acct__c, BillingPostalCode , Phone, fax, Platform__c
                   from Account  where (Sponsor_Acct__c =:aactNumber or Carrier_ID__c =: aactNumber)  and BillingPostalCode=: zipCode];
            if(act.size()!=0){
            platformName =    act[0].Platform__c;  
                }
            
        }
        
        if(isNAfleetAccount && isZip){
            if(platformName=='SIEBEL' || platformName=='Tandem'){
                if(actNumber == aactNumber && actzipcode == zipCode){
                    
                    returnStatement = 'NA fleet SUCCESS';
                }     
                else if ( (actNumber == aactNumber && actzipcode != zipCode && aactNumber!=null && zipCode !=null) ||
                         (actNumber != aactNumber && actzipcode == zipCode  && aactNumber!=null && zipCode !=null) || act.size()==0) {
                             returnStatement = 'not matching';
                         }else{
                             returnStatement = 'Something Went wrong';
                         }
            }  else {
                 returnStatement = 'not matching';
            } 
        }
        
        else if(isEFSAccount && isZip) {
            if(platformName=='OTR'){
                if(carrierNumber == aactNumber && actzipcode == zipCode){
                    
                    returnStatement = 'EFS SUCCESS';
                }     
                else if ( (carrierNumber == aactNumber && actzipcode != zipCode && aactNumber!=null && zipCode !=null) ||
                         (carrierNumber != aactNumber && actzipcode == zipCode  && aactNumber!=null && zipCode !=null) || act.size()==0) {
                             returnStatement = 'not matching';
                         }else{
                             returnStatement = 'Something Went wrong';
                         }
                
            }    else {
                 returnStatement = 'not matching';
            } 
            
        }
        
        system.debug('returnStatement: '+returnStatement);
        return returnStatement;
        
    }
    
}