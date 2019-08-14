public class OnlineApplicationWeightedRoundRobin 
{
	public static void executeRoundRobin(List<OnlineApplication__c> records, Map<Id, OnlineApplication__c> oldMap) 
    {
        Boolean isInsert = (oldMap == null);
        Set<String> eligibleQueues = new Set<String>();

        for (LeadRoundRobinQueue__c eq : [SELECT isActive__c, Standard_Queue_Id__c FROM LeadRoundRobinQueue__c WHERE isActive__c = TRUE]) 
        {
            eligibleQueues.add(eq.Standard_Queue_Id__c);
            
            System.debug('--------------------eligible Queue= ' + eq.Standard_Queue_Id__c);
        }

        if (eligibleQueues.size() == 0)
        {
            return;
        }

        Set<Id> queues = new Set<Id>();
        Set<Id> appRequestIds = new Set<Id>();

        for (OnlineApplication__c req : records)
        {
            // if the OnlineApplication__c is now assigned to an eligible queue
            if (eligibleQueues.contains(req.OwnerId)
               && ((isInsert == true )
                   || (isInsert == false && oldMap.get(req.Id).OwnerId != req.OwnerId)))
            {
                queues.add(req.OwnerId);
                appRequestIds.add(req.Id);
                
                System.debug('--------------------eligible Queue=' + req.OwnerId);
            }
        }

        if (appRequestIds.size() == 0) 
        {
            return;
        }

        // Build Maps of the Eligible Queues
        Map<String,Id> qMembers = new Map<String, Id>();
        Map<Id, Integer> qMemberCount = new Map<Id, Integer>();
        Map<String, LeadRoundRobinQueue__c> qNext = new Map<String, LeadRoundRobinQueue__c>();

        Integer cnt;

        for (LeadRoundRobinQueue__c q: [SELECT 
                                       		Standard_Queue_Id__c, 
                                       		Next_Position__c,
                                       		(SELECT 
                                             		Id, 
                                             		Member__c, 
                                             		Position__c
                                        	 FROM 
                                             		Lead_Round_Robin_Queue_Members__r
                                        	 ORDER BY position__c ASC)
                                       	FROM 
                                       		LeadRoundRobinQueue__c
                                       	WHERE 
                                       		Standard_Queue_Id__c IN : queues]) 
        {
            cnt = 0;

            for (LeadRoundRobinQueueMember__c qm : q.Lead_Round_Robin_Queue_Members__r) 
            {
                cnt = cnt + 1;
                qMembers.put(q.Standard_Queue_Id__c + '-' + cnt, qm.member__c);
            }

            qMemberCount.put(q.Standard_Queue_Id__c, cnt);
            qNext.put(q.Standard_Queue_Id__c, q);
        }

        if (qMembers.size() == 0) 
        {
            return;
        }

        // find the inactive users
        // this will get rid of groups
        Set<Id> ActiveUsers = new Set<Id>();

        //treat pause round robin the same as inactive, skip
        for (User u : [SELECT Id
                       FROM User
                       WHERE Id IN : qMembers.values()
                       AND isActive = TRUE
                       AND Pause_Round_Robin__c = FALSE]) 
        {
            ActiveUsers.add(u.id);
        }

        Integer nxtrep;
        Id nxtrepId;

        List<OnlineApplication__c> appRequestsToUpdate = new List<OnlineApplication__c>();
        List<Opportunity> oppsToUpdate = new List<Opportunity>();

        for (OnlineApplication__c req : [SELECT Id, OwnerId, Opportunity__c
                                         FROM OnlineApplication__c
                                         WHERE Id IN : appRequestIds
                                         AND OwnerId IN : eligibleQueues]) 
        {
            if (qNext.containsKey(req.OwnerId)) 
            {
                nxtrep = qNext.get(req.OwnerId).Next_Position__c.intValue();

                // if for some reason a member is deleted from the queue and
                // the next rep is greater than the member count
                // need to check and if not there, go back to number 1
                if (nxtrep > qMemberCount.get(req.OwnerId)) 
                {
                    nxtrep = 1;
                }

                //if missing from the middle because inactive
                Boolean activeFound = false;

                do 
                {
                    if (ActiveUsers.contains(qMembers.get(req.OwnerId + '-' + nxtrep))) 
                    {
                        activeFound = true;
                    } 
                    else 
                    {
                        nxtrep = nxtrep + 1;
                        if (nxtrep > qMemberCount.get(req.OwnerId)) 
                        {
                            nxtrep = 1;
                        }
                    }

                } 
                while (activeFound == false);

                // get the user id for the rep found
                nxtrepId = qMembers.get(req.OwnerId + '-' + nxtrep);

                //debugging
                //req.Round_Robin_Queue__c = req.OwnerId;
                //req.Round_Robin_Queue_Position__c = string.valueof(nxtRep);

                //set the next rep
                if (nxtrep + 1 <= qMemberCount.get(req.OwnerId)) 
                {
                    nxtrep = nxtrep + 1;
                } 
                else 
                {
                    nxtrep = 1;
                }

                LeadRoundRobinQueue__c x = qNext.get(req.OwnerId);
                x.Next_Position__c = nxtrep;
                qNext.put(req.OwnerId, x);
            }

            req.OwnerId = nxtrepId;
            appRequestsToUpdate.add(req);
            
            if (req.Opportunity__c != null)
            {
                oppsToUpdate.add(new Opportunity(Id = req.Opportunity__c, OwnerId = nxtrepId));
            }
        }

        if (appRequestsToUpdate.size() > 0) 
        {
            update appRequestsToUpdate;
        }
        
        if (oppsToUpdate.size() > 0)
        {
            update oppsToUpdate;
        }

        // Update the Settings
        List<LeadRoundRobinQueue__c> RoundRobinQueuesToUpdate = new List<LeadRoundRobinQueue__c>();

        for (LeadRoundRobinQueue__c lrr : qNext.values()) 
        {
            RoundRobinQueuesToUpdate.add(lrr);
        }

        update RoundRobinQueuesToUpdate;
    }
}