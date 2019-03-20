public with sharing class CaseHelper {
    static final Integer WEEKEND_DAYS = 2;
    static final Integer HIGH_PRIORITY_SLA= 1;
    static final Integer MEDIUM_PRIORITY_SLA= 5;  
    static final Integer FRIDAY = 5;  
    
    public static RecordType getRecordType(Id recTypeId){
        RecordType recType = null;
        if (recTypeId != null){            
            String recTypeStr = (((String)recTypeId).substring(0,15));
            recType = [select name from RecordType where id = :recTypeStr ]; 
        }
        return recType;
    }
    
    public static void setCasePriority(Case currentCase){
        if (currentCase.Type == 'User Provisioning'){     
            currentCase.Priority = 'High';
        } else {
            currentCase.Priority = 'Medium';
        }
    }
    
    public static void setTargetCompletionDate(Case currentCase){
        Long dayOfWeek = WEXHelper.getDayOfWeek(Date.today());    
        Date tempDate = Date.Today();
        
        if (currentCase.Target_Completion_Date__c == null){
        
            if (currentCase.Priority == 'High'){ 
                if (dayOfWeek + HIGH_PRIORITY_SLA > FRIDAY ){
                    tempDate = Date.Today() + WEEKEND_DAYS + HIGH_PRIORITY_SLA;            
                } else {
                    tempdate = Date.Today() + HIGH_PRIORITY_SLA;
                }
            } else if (currentCase.Priority != 'High'){          
                if (dayOfWeek + MEDIUM_PRIORITY_SLA > FRIDAY ){
                    tempDate = Date.Today() + WEEKEND_DAYS + MEDIUM_PRIORITY_SLA;            
                }else {
                    tempdate = Date.Today() + MEDIUM_PRIORITY_SLA;
                }
            }

            currentCase.Target_Completion_Date__c = tempDate + WEXHelper.skipToNextBusinessDay(tempDate);
        }
    }
        
}