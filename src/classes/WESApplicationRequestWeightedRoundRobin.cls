public class WESApplicationRequestWeightedRoundRobin {

    public static void executeRoundRobin (List <WES_Application_Request__c> records, Map <id, WES_Application_Request__c> oldMap) {
        boolean isInsert = (oldMap == null);


        Set <String> eligibleQueues = new Set <String>();

        for(LeadRoundRobinQueue__c eq : [Select isActive__c, Standard_Queue_Id__c
                                         From LeadRoundRobinQueue__c
                                         where isActive__c = true]) {
            eligibleQueues.add(eq.Standard_Queue_Id__c);
            system.debug('--------------------eligible Queue='+eq.Standard_Queue_Id__c);
        }

        if(eligibleQueues.size() == 0) {
            return;
        }

        Set <Id> Queues = new Set <Id>();
        Set <Id> appRequestIds = new Set <Id>();


        for(WES_Application_Request__c req : records) {
            // if the WES_Application_Request__c is now assigned to an eligible queue

            if(req.skip_round_robin__c == false
                    && eligibleQueues.contains(req.ownerid)
                    && ((isInsert == true )
                        || (isInsert == false && oldMap.get(req.id).ownerid != req.ownerid))) {
                Queues.add(req.ownerid);
                appRequestIds.add(req.id);

                system.debug('--------------------eligible Queue=' + req.ownerid);
            }
        }

        if(appRequestIds.size() == 0) {
            return;
        }

        // Build Maps of the Eligible Queues

        Map <String,Id> qMembers = new Map <String,Id>();
        Map <Id, Integer> qMemberCount = new Map <Id, Integer>();
        Map <String, LeadRoundRobinQueue__c> qNext = new Map <String, LeadRoundRobinQueue__c>();

        Integer cnt;

        for(LeadRoundRobinQueue__c q: [select Standard_Queue_Id__c, Next_Position__c,
                                       (Select id, Member__c, Position__c
                                        From Lead_Round_Robin_Queue_Members__r
                                        order by position__c asc)
                                       From LeadRoundRobinQueue__c
                                       where Standard_Queue_Id__c in :Queues]) {
            cnt = 0;

            for(LeadRoundRobinQueueMember__c qm : q.Lead_Round_Robin_Queue_Members__r) {
                cnt = cnt + 1;
                qMembers.put(q.Standard_Queue_Id__c + '-' + cnt, qm.member__c);
            }

            qMemberCount.put(q.Standard_Queue_Id__c, cnt);
            qNext.put(q.Standard_Queue_Id__c, q);

        }

        if(qMembers.size() == 0) {
            return;
        }


        // find the inactive users
        // this will get rid of groups
        Set <Id> ActiveUsers = new Set <Id>();

        //treat pause round robin the same as inactive, skip
        for(User u : [select id
                      from user
                      where id in :qMembers.values()
                      and isactive = true
                                     and Pause_Round_Robin__c = false]) {
            ActiveUsers.add(u.id);
        }

        integer nxtrep;
        id nxtrepId;

        List <WES_Application_Request__c> appRequestsToUpdate = new List <WES_Application_Request__c>();


        for(WES_Application_Request__c req : [select id, ownerid
                                            from WES_Application_Request__c
                                            where id in :appRequestIds
                                            and ownerid in :eligibleQueues]) {

            if(qNext.containsKey(req.ownerid)) {
                nxtrep = qNext.get(req.ownerid).next_position__c.intValue();

                // if for some reason a member is deleted from the queue and
                //the next rep is greater than the member count
                // need to check and if not there, go back to number 1
                if(nxtrep > qMemberCount.get(req.ownerid)) {
                    nxtrep = 1;
                }

                //if missing from the middle because inactive
                boolean activeFound = false;

                do {

                    if(ActiveUsers.contains(qMembers.get(req.ownerid + '-' + nxtrep))) {
                        activeFound = true;
                    } else {
                        nxtrep = nxtrep + 1;
                        if(nxtrep > qMemberCount.get(req.ownerid)) {
                            nxtrep = 1;
                        }
                    }

                } while (activeFound == false);

                // get the user id for the rep found
                nxtrepId = qMembers.get(req.ownerid + '-' + nxtrep);

                //debugging
                req.Round_Robin_Queue__c = req.ownerid;
                req.Round_Robin_Queue_Position__c = string.valueof(nxtRep);


                //set the next rep
                if(nxtrep + 1 <= qMemberCount.get(req.ownerid)) {
                    nxtrep = nxtrep + 1;
                } else {
                    nxtrep = 1;
                }

                LeadRoundRobinQueue__c x = qNext.get(req.ownerid);
                x.next_position__c = nxtrep;
                qNext.put(req.ownerid, x);

            }

            req.ownerid = nxtrepId;
            appRequestsToUpdate.add(req);

        }

        if(appRequestsToUpdate.size() > 0) {
            update appRequestsToUpdate;
        }


        // Update the Settings
        List <LeadRoundRobinQueue__c> RoundRobinQueuesToUpdate = new List <LeadRoundRobinQueue__c>();

        for(LeadRoundRobinQueue__c lrr : qNext.values()) {
            RoundRobinQueuesToUpdate.add(lrr);
        }

        update RoundRobinQueuesToUpdate;

    }
}