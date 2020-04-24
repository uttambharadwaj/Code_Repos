/**
* Forseva online application code.
*/
public with sharing class SOUtility {

    public static SObject getCompleteSObject(Schema.SObjectType sot, ID objectId) {

        String query;
        String columnList = '';

        // SOQL query too long if we include flaccid formula fields on account
        Set<String> excludeSet = new Set<String>{'MAIN_LOCATION__C','SIC_CODE_1__C','SIC_CODE_2__C','SIC_CODE_3__C','SIC_CODE_4__C','SIC_CODE_5__C','SIC_CODE_6__C','SIC_CODE_7__C','SIC_CODE_8__C','SIC_CODE_9__C','SIC_CODE_10__c','SIC_CODE_11__C','SIC_CODE_12__C','SIC_CODE_13__C','SIC_CODE_14__C','SIC_CODE_15__C','SIC_CODE_16__C','SIC_CODE_17__C'};
        
        Map<String, Schema.SObjectField> fields = sot.getDescribe().fields.getMap();
        Set<String> nameSet = fields.keySet();
        List<String> nameList = new List<String>();

        // 23-May-2014 Manu Erwin (Salesforce.com) Removing "Address" fields per https://developer.salesforce.com/forums/ForumsMain?id=906F0000000AHVtIAO
        nameSet.remove('shippingaddress');
        nameSet.remove('billingaddress');
        nameSet.remove('mailingaddress');
        nameSet.remove('otheraddress');
        nameSet.remove('geolocation__c');

        nameList.addAll(nameSet);
        for(String columnName : nameList) {
            if(!excludeSet.contains(columnName.toUpperCase())) {
                if(columnList.length() > 0) {
                    columnList += ',';
                }
                columnList += columnName;
            }
        }
        
        query = 'select ' + columnList + ' from ' + sot.getDescribe().getName() + ' where id=\'' + String.escapeSingleQuotes(objectId) + '\'';
        SObject so = Database.query(query);
        return so;
    }
}
// EOF