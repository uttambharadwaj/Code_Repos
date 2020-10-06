public class WE_TeamTargetCalculation {
    
    static Boolean firstCalculation = true;
    Boolean isInsert;
    Target__c oldTarget;
    Map<Id,Target__c> oldTargets;
    Map<Id,Target__c> newTargets;
    List<Target__c> targets = new List<Target__c>();
    Set<String> targetCurrency = new Set<String>();
    Set<String> identifiers = new Set<String>();
    String teamName;
    String monthEndDate;
    String monthlyTeamTargetIdentifier;
    List<Target__c> targetsToUp = new List<Target__c>();
    Map<String,Decimal> targetsWIdentifiers = new Map<String,Decimal>();
    
    public WE_TeamTargetCalculation(
        Boolean triggerIsInsert,
        Map<Id,Target__c> oldTriggerTargets,
        Map<Id,Target__c> newTriggerTargets)
    {
        isInsert = triggerIsInsert;
        oldTargets = oldTriggerTargets;
        newTargets = newTriggerTargets;
    }
    
    public void updateTargets() {
        
        if (firstCalculation == true)
        {
            for(Target__c newTarget : newTargets.values()){
                
                if (oldTargets != null) // map will be empty on Insert
                {
                    oldTarget = oldTargets.get(newTarget.Id);
                }
                if (isInsert = true ||
                    oldTarget.Target__c != newTarget.Target__c ||
                    oldTarget.Team__c != newTarget.Team__c)
                {
                    system.debug('WE_TeamTargetCalculation: newTarget is' + newTarget);
                    targets.add(newTarget);
                    targetCurrency.add(newTarget.CurrencyIsoCode);
                    // replicate Team_MT_Identifier__c field
                    identifiers.add(String.valueOf(newTarget.Date_Type__c) + '-' + String.valueOf(newTarget.Team__c) + '-' + String.valueOf(newTarget.Month_End_Date__c.Month()) + '-' + String.valueOf(newTarget.Month_End_Date__c.Year()));
                    if (oldTargets != null)
                    {
                        identifiers.add(String.valueOf(newTarget.Date_Type__c) + '-' + String.valueOf(oldTarget.Team__c) + '-' + String.valueOf(oldTarget.Month_End_Date__c.Month()) + '-' + String.valueOf(oldTarget.Month_End_Date__c.Year()));
                    }
                }
            }
            system.debug('WE_TeamTargetCalculation: targets contains ' + targets);
            system.debug('WE_TeamTargetCalculation: targetCurrency contains ' + targetCurrency);
            system.debug('WE_TeamTargetCalculation: identifiers contains ' + identifiers);
            
            if (targets.size() > 0)
            {
                for(Target__c t : [SELECT Id,Team_Target__c,Team__c,Month_End_Date__c
                                     FROM Target__c
                                    WHERE Team_MT_Identifier__c IN :identifiers])
                {
                    targetsToUp.add(t);
                }
                system.debug('WE_TeamTargetCalculation: targetsToUp contains ' + targetsToUp);
                
                AggregateResult[] mnthlyTeamTargets = [SELECT Team__c, Month_End_Date__c, SUM(Target__c) sum
                                                         FROM Target__c
                                                        WHERE Id IN :targetsToUp
                                                     GROUP BY Team__c, Month_End_Date__c];
                
                system.debug('WE_TeamTargetCalculation: mnthlyTeamTargets contains ' + mnthlyTeamTargets);
                
                for (AggregateResult ar : mnthlyTeamTargets){
                    
                    teamName = String.valueOf(ar.get('Team__c'));
                    monthEndDate = String.valueOf(ar.get('Month_End_Date__c'));
                    monthlyTeamTargetIdentifier = teamName + '-' + monthEndDate;
                    // aggregate results cannot be converted straight to decimals, need to convert to string first
                    targetsWIdentifiers.put(monthlyTeamTargetIdentifier, Decimal.valueOf(String.valueOf(ar.get('sum'))));
                }
                // add If check here, when US users adopt Targets
                Decimal conversionRate = [SELECT conversionRate 
                                            FROM currencyType 
                                           WHERE isoCode = :targetCurrency LIMIT 1].conversionRate;
                
                for(Target__c t : targetsToUp){
                    Decimal teamTarget = targetsWIdentifiers.get(t.Team__c + '-' + t.Month_End_Date__c);
                    t.Team_Target__c = teamTarget * conversionRate;
                }
            }
        }
        firstCalculation = false;
        update targetsToUp;
    }
}