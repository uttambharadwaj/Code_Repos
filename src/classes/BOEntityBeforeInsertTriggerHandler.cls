public class BOEntityBeforeInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {
    	getOpptyLegalStructure((List<Beneficial_Owner_Entity__c>) tp.newList); //verify legal structure exists
    	BOEntityHelper.updateExemptionStatus((List<Beneficial_Owner_Entity__c>) tp.newList); //do the exemption status thang
    }

    private void getOpptyLegalStructure(List<Beneficial_Owner_Entity__c> boList){
		Map<Id,String> opptyLegalMap = new Map<Id,String>();
		
		for(Beneficial_Owner_Entity__c boe : boList) {
			if(boe.Opportunity__c != null)
				opptyLegalMap.put(boe.Opportunity__c, null);
		}

		if(opptyLegalMap.size()>0){
	    	for(Opportunity o : [SELECT Id, Legal_Structure__c FROM Opportunity WHERE Id IN :opptyLegalMap.keySet()])
				opptyLegalMap.put(o.Id, o.Legal_Structure__c);

			for(Beneficial_Owner_Entity__c boe : boList)
				if(boe.Opportunity__c != null && opptyLegalMap.get(boe.Opportunity__c) != null) 
					boe.Legal_Structure__c = opptyLegalMap.get(boe.Opportunity__c);
				else 
					boe.addError('Please ensure you have selected a Legal Structure on the Opportunity, then try again!');
		}

	}

}