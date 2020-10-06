public class UProgram {
    public static void executeBREeze(List<Program__c> records, Map<Id, Program__c> oldMap) {
        BREeze.processRules.ruleDataSet rds = new BREeze.processRules.ruleDataSet();
        rds.records = records;
        rds.oldMap = oldMap;
        BREeze.ProcessRules.processRuleLogic('MC_Programs_Sync_to_Marketing_Cloud', false, rds);
    }
}