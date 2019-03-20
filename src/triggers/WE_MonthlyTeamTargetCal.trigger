trigger WE_MonthlyTeamTargetCal on Target__c (after insert, after update) {
 
    List<Target__c> updatedTargets = new list<Target__c>();
    Set<String> teamTargetIden = new Set<String>();
    Set<String> targetCurrency = new Set<String>();
    
    If(Trigger.isInsert){
        for (Target__c t : Trigger.New){
            
            updatedTargets.add(t);
            teamTargetIden.add(t.Team_MT_Identifier__c);
            targetCurrency.add(t.CurrencyIsoCode);
        }
    }
        
    If(Trigger.isUpdate){
        for (Target__c t : Trigger.New){
        
            Target__c oldT = Trigger.oldMap.get(t.Id);
            
            if(oldT.Target__c != t.Target__c)
            {
                updatedTargets.add(t);
                teamTargetIden.add(t.Team_MT_Identifier__c);
                targetCurrency.add(t.CurrencyIsoCode);
            }
        }
    }
    system.debug('updatedTargets contains ' + updatedTargets);
    system.debug('teamTargetIden contains ' + teamTargetIden);
    system.debug('targetCurrency contains ' + targetCurrency);
    
    If(updatedTargets.size() > 0){
    
    List<Target__c> targetsToUpdate = [SELECT Id, Target__c FROM Target__c
                                        WHERE Team_MT_Identifier__c IN :teamTargetIden];
        
        system.debug('targetsToUpdate contains ' + targetsToUpdate);
    
    Decimal mnthlyTeamTarget = (Decimal) [SELECT SUM(Target__c) sum FROM Target__c
                                           WHERE Id IN :targetsToUpdate][0].get('sum');
        
        system.debug('mnthlyTeamTarget contains ' + mnthlyTeamTarget);
        
        if(targetCurrency.contains('USD') == false){
        
            Decimal conversionRate = [SELECT conversionrate FROM currencytype 
                                       WHERE isocode = :targetCurrency LIMIT 1].conversionRate;
        
            for(Target__c t : targetsToUpdate){
                t.Team_Target__c = mnthlyTeamTarget*conversionRate;
            }
        }else{
            for(Target__c t : targetsToUpdate){
                t.Team_Target__c = mnthlyTeamTarget;
            }
        }
        update targetsToUpdate;
    }
}