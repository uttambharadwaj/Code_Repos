/*
* Test Setup Framework Utility Loader
* Author: Jason Arbegast
* Initial Date: 5/14/2019
* Description:  load the data and then modify the custom settings accordingly
* Revision History:
*/

public class UtilityTestLoader {

    //does some pre-loading stuff then loads data then does some post-loading stuff
    public static void loadTestData(){
        preExecute();
        doTheLoad();
    }

    //separate method in case we want to do this with post sandbox refresh too
    public static void doTheLoad(){
        Database.executeBatch(new DataLoaderBatch());
    }

    public static void setAutomation(Boolean disabled){
        Automation_Settings__c newRecord = Automation_Settings__c.getOrgDefaults();
        if(newRecord == null) newRecord = new Automation_Settings__c();
        Map<String,Schema.SObjectField> myObjectFieldMap = newRecord.getsObjectType().getDescribe().fields.getMap();
        for(Schema.SObjectField sof : myObjectFieldMap.values()){
            Schema.DescribeFieldResult myField = sof.getDescribe();
            if(myField.getType() == Schema.DisplayType.Boolean && myField.isUpdateable())
                newRecord.put(sof.getDescribe().getName(), disabled);
        }
        upsert newRecord;
    }

    //add settings
    public static void preExecute(){
        setAutomation(true);
    }

    //modify settings
    public static void postExecute(){
        setAutomation(false);
        setLDSRole();
    }

    //lead development splits may require the user role id
    private static void setLDSRole(){
        Lead_Development_Splits__c lds = Lead_Development_Splits__c.getOrgDefaults();
        lds.Role_ID__c = UserInfo.getUserRoleId();
        update lds;
    }

}