/*
    Name: UObjectChangeLog Class  
    Created By: Raja Yeccherla(GearsCRM)
    Created Date: 08/15/2017
    Description: Helper class for ObjectChangeLogTrigger
     
    Modified By: 
    Modified Date:  
    Description:   
*/
public class UObjectChangeLog
{
    public static list<pi__ObjectChangeLog__c> delObjChangeLogRecs;
    public static void updateOwner(List <pi__ObjectChangeLog__c> records)
    {
        Map <id, id> pardotUserSyncMap = new Map <id, string>();
        
        for(Pardot_User_Sync_Mapping__c pusm : Pardot_User_Sync_Mapping__c.getAll().values())
        {
            pardotUserSyncMap.put(pusm.RecordType_ID__c, pusm.User_ID__c);
        }
    
        if(pardotUserSyncMap.size() == 0)
        {
            return;
        }
        
        set<id> objchangLogLeads = new set<id>();
        set<id> objchangLogContacts = new set<id>();
        map<id,id> leadRecodtypeIDMap = new map<id,id>();
        map<id,id> acctRecodtypeIDMap = new map<id,id>();
        list<pi__ObjectChangeLog__c> updObjChangeLogRecs = new list<pi__ObjectChangeLog__c>();
        
        list<id> delObjChgLogRecs = new list<id>();
        
        for(pi__ObjectChangeLog__c objchnglog : records)
        {
            if(objchnglog.pi__ObjectFid__c != null && objchnglog.pi__ObjectFid__c.startsWith('00Q')) //Check to see if it is a lead
            {
                objchangLogLeads.add(objchnglog.pi__ObjectFid__c);
            }
            
            if(objchnglog.pi__ObjectFid__c != null && objchnglog.pi__ObjectFid__c.startsWith('003')) //Check to see if it is a Contact
            {
                objchangLogContacts.add(objchnglog.pi__ObjectFid__c);
            }
        }
        
        //get the recordTypeId from Lead 
        if(objchangLogLeads.size() > 0)
        { 
            for(Lead l: [select id,recordTypeId from lead where id in :objchangLogLeads])
            {
                leadRecodtypeIDMap.put(l.id,l.recordTypeId);
            }
        }
        
        //get the recordTypeId from Account 
        if(objchangLogContacts.size() > 0)
        {
            for(Contact c: [select id,Account.recordTypeId from contact where id in :objchangLogContacts])
            {
                acctRecodtypeIDMap.put(c.id,c.Account.recordTypeId);
            }
        }
        
        delObjChangeLogRecs = new list<pi__ObjectChangeLog__c>();
        for(pi__ObjectChangeLog__c objchnglog : records)
        {
            //Matching lead recordTypeId with pardotUserSyncMap for matching ownerID based on the recordTypeId
            if( objchnglog.pi__ObjectFid__c != null
            && objchnglog.pi__ObjectFid__c.startsWith('00Q')
            && leadRecodtypeIDMap.containsKey(objchnglog.pi__ObjectFid__c)
            && leadRecodtypeIDMap.get(objchnglog.pi__ObjectFid__c) != null
            && pardotUserSyncMap.containsKey(leadRecodtypeIDMap.get(objchnglog.pi__ObjectFid__c))
            && pardotUserSyncMap.get(leadRecodtypeIDMap.get(objchnglog.pi__ObjectFid__c)) != null)
            {
                pi__ObjectChangeLog__c objchngLogUpd = objchnglog.clone(true,true,true,true);
                objchngLogUpd.OwnerId = (ID)pardotUserSyncMap.get(leadRecodtypeIDMap.get(objchnglog.pi__ObjectFid__c));
                updObjChangeLogRecs.add(objchngLogUpd);
            }
            else if(objchnglog.pi__ObjectFid__c != null
                && objchnglog.pi__ObjectFid__c.startsWith('00Q') 
                && leadRecodtypeIDMap.containsKey(objchnglog.pi__ObjectFid__c)
                && leadRecodtypeIDMap.get(objchnglog.pi__ObjectFid__c) != null
                && !pardotUserSyncMap.containsKey(leadRecodtypeIDMap.get(objchnglog.pi__ObjectFid__c)))
            {
                delObjChangeLogRecs.add(objchnglog.clone(true,true,true,true));      
            } 
            
            //Matching Account recordTypeId with pardotUserSyncMap for matching ownerID based on the recordTypeId
            if(objchnglog.pi__ObjectFid__c != null 
            && objchnglog.pi__ObjectFid__c.startsWith('003')
            && acctRecodtypeIDMap.containsKey(objchnglog.pi__ObjectFid__c)
            && acctRecodtypeIDMap.get(objchnglog.pi__ObjectFid__c) != null
            && pardotUserSyncMap.containsKey(acctRecodtypeIDMap.get(objchnglog.pi__ObjectFid__c))
            && pardotUserSyncMap.get(acctRecodtypeIDMap.get(objchnglog.pi__ObjectFid__c)) != null)
            {
                pi__ObjectChangeLog__c objchngLogUpd = objchnglog.clone(true,true,true,true);
                objchngLogUpd.OwnerId = (ID)pardotUserSyncMap.get(acctRecodtypeIDMap.get(objchnglog.pi__ObjectFid__c));
                updObjChangeLogRecs.add(objchngLogUpd);             
            }
            else if(objchnglog.pi__ObjectFid__c != null
                && objchnglog.pi__ObjectFid__c.startsWith('003')
                && acctRecodtypeIDMap.containsKey(objchnglog.pi__ObjectFid__c)
                && acctRecodtypeIDMap.get(objchnglog.pi__ObjectFid__c) != null
                && !pardotUserSyncMap.containsKey(acctRecodtypeIDMap.get(objchnglog.pi__ObjectFid__c)))
            {
                delObjChangeLogRecs.add(objchnglog.clone(true,true,true,true));  
            }
        }
        
        if(updObjChangeLogRecs != null && updObjChangeLogRecs.size() > 0)
        {
            update updObjChangeLogRecs;
        }
        
        if(delObjChangeLogRecs != null && delObjChangeLogRecs.size() > 0)
        {
            deleteInvalidObjLogRecs(delObjChangeLogRecs);
        }
    }
    
    public static void deleteInvalidObjLogRecs(list<pi__ObjectChangeLog__c> delObjChangeLogRecs)
    {
        if(delObjChangeLogRecs != null && delObjChangeLogRecs.size() > 0)
            delete delObjChangeLogRecs;
            
        delObjChangeLogRecs.clear();  
    }
}