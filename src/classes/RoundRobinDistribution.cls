global class RoundRobinDistribution {
	
	webService static void loadDistributionButton(id leadRRqID)
	{
		loadDistribution(leadRRqID);		
	}
	
	webService static void loadDistributionAllButton(string x)
	{
		loadDistribution(null);		
	}

	public static void loadDistribution(id leadRRqID)
	{
		Map <id, List <Lead_RR_Queue_Member_Assignments__c>> qMap = new Map <id, List <Lead_RR_Queue_Member_Assignments__c>>();
		
		string sqlStatement = 'Select Weight__c, Member__c, member__r.name, Lead_Round_Robin_Queue__c ';
		sqlStatement += ' From Lead_RR_Queue_Member_Assignments__c ';
		sqlStatement += ' where weight__c > 0 ';
		
		if(leadRRqID != null)
		{
			sqlStatement += ' and Lead_Round_Robin_Queue__c = :leadRRqID ';
		}
		
		sqlStatement += ' order by Lead_Round_Robin_Queue__c, weight__c desc ';
		
		set <id> qIds = new set <id>();
		
		for(Lead_RR_Queue_Member_Assignments__c l : database.query(sqlStatement))
		{
			qIds.add(l.Lead_Round_Robin_Queue__c);
			
			if(qMap.containsKey(l.lead_Round_robin_Queue__c))
			{
				List <Lead_RR_Queue_Member_Assignments__c> q = qMap.get(l.lead_Round_robin_Queue__c);	
				q.add(l);
				qMap.put(l.lead_Round_robin_Queue__c, q);
				
				system.debug('-----' + l.member__r.name);
			}
			else
			{
				List <Lead_RR_Queue_Member_Assignments__c> q = new List <Lead_RR_Queue_Member_Assignments__c>();
				q.add(l);
				qMap.put(l.lead_Round_robin_Queue__c, q);
				
				system.debug('-----' + l.member__r.name);
			}
		}
		
		// the Lead_RR_Queue_Member_Assignments__c is already assigned to an existing RR Queue definition.
		// so no maintenance needed there
		// This will determine how to load the data on the queue members
		List <LeadRoundRobinQueueMember__c> qMembersAll = new List <LeadRoundRobinQueueMember__c>();
		
		for(id qId : qMap.keyset())
		{
			List <LeadRoundRobinQueueMember__c> qMembers = buildQueueMembers (qId, qMap.get(qId));
			qMembersAll.addAll(qMembers);
		}
		
		List <LeadRoundRobinQueueMember__c> qMembersToDelete = [select id 
		                                                        from LeadRoundRobinQueueMember__c
		                                                        where Lead_Round_Robin_Queue__c in :qMap.keySet()];
		                                                        
		if(qMembersToDelete.size() > 0)
		{
			delete qMembersToDelete;
		}
		
		if(qMembersAll.size() > 0)
		{
			insert qMembersAll;
		}
		
		List <LeadRoundRobinQueue__c> qsToUpdate = new List <LeadRoundRobinQueue__c>();
		
		for(LeadRoundRobinQueue__c l : [select id, MemberAssignmentsLastExecuted__c 
		                                   from LeadRoundRobinQueue__c 
		                                   where id in :qIds])
		{
			l.MemberAssignmentsLastExecuted__c = system.now();
			qsToUpdate.add(l);
		}
		
		update qsToUpdate;
		
		
	}
	
	public static List <LeadRoundRobinQueueMember__c> buildQueueMembers (id qId, List <Lead_RR_Queue_Member_Assignments__c> records)
	{
		integer loopCount = integer.valueOf(records[0].weight__c);
		integer position = 0;
		
		List <LeadRoundRobinQueueMember__c> qMembers = new List <LeadRoundRobinQueueMember__c>();
		
		// loop through as many times as the first weight since that will always be first in the list
		
		for (Integer i = 1; i < loopCount + 1; i++) 
		{
    		for(Lead_RR_Queue_Member_Assignments__c l : records)
    		{
    			if(l.weight__c >= i)
    			{
    				system.debug('-----' + l.member__r.name);
    				
    				position ++;
    				LeadRoundRobinQueueMember__c lrq = new LeadRoundRobinQueueMember__c();
    				lrq.Position__c = position;
					lrq.member__c = l.member__c;    				
    				lrq.Lead_Round_Robin_Queue__c = qId;
    				qMembers.add(lrq);
    			}
    		}
		}
		
		return qMembers;		
	}
}