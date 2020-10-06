/*
* Test Setup Framework Data Loader
* Author: Jason Arbegast
* Initial Date: 5/14/2019
* Description:  does all the hard work of loading data for test setups and post-sandbox refreshes
* Test Class: DataLoaderBatchTest
* Revision History:
*/

global class DataLoaderBatch implements Database.Batchable<String>,
        Database.Stateful,
        Database.AllowsCallouts{

    private static Integer orderOfInsert = 0;
    private static Map<String, Map<String, String>> sObjectToIdMap = new Map<String, Map<String, String>>(); // heap size concern if we load at scale
    private static Map<Integer, String> headerFieldIndex = new Map<Integer, String>();
    private static Boolean firstExecution;
    private static Test_Data_Configuration__mdt tdc;
    private static Test_Data_Configuration__mdt currentTestConfig = null;
    private static Set<String> userMethods = new Set<String>{'profileid','userid'};

    // This constructor is called by the DataLoaderBatch itself in order to insert the next object
    global DataLoaderBatch (Integer pcmt, Map<String, Map<String, String>> idMap) {
        firstExecution = True;
        sObjectToIdMap = idMap;
        orderOfInsert = pcmt;

        setHeaderRow(orderOfInsert);

    }

    // Default constructor, get the very first config metadata for insertion
    global DataLoaderBatch () {
        firstExecution = True;

        // Get the first config record order number
        String tdcQuery = 'SELECT Object__c, Required_Fields_Only__c, Static_Resource__c, Order__c' +
                ' FROM Test_Data_Configuration__mdt WHERE Is_Active__c = true';
        tdcQuery += ' ORDER BY Order__c ASC' +
                ' LIMIT 1';
        List<Test_Data_Configuration__mdt> tdcs = Database.query(tdcQuery);
        if(tdcs.size()<=0) throw new TestSetupException('There must be at least 1 Test Data Configuration metadata record to run the DataLoaderBatch.');
        orderOfInsert = tdcs[0].Order__c.intValue();

        //turn that tdc number into a header row
        setHeaderRow(orderOfInsert);

    }

    //batch start method. sets the scope
    global Iterable<String> start(Database.BatchableContext bc) {
        return new CustomIterable(orderOfInsert);
    }

    //batch execute method. does the iterate and insert thang
    global void execute(Database.BatchableContext bc, List<String> scope) {

        Map<sObject, String> recordToOldId = new Map<sObject, String>(); //map of static resource's id to actually inserted id
        List<sObject> toInsert = new List<sObject>(); //new records go here
        List<sObject> toUpdate = new List<sObject>(); //self-referencing objects go here
        List<sObject> insertedObjects = new List<sObject>(); //completed objects go here
        //iterate over scope
        system.debug(tdc);
        for (Integer myRow=scope.size()-1; myRow>=1; myRow--) {
            //need a new sobject based on what our object should be
            sObject newRecord = Schema.getGlobalDescribe().get(tdc.Object__c).newSObject();
            //map our sobject fields
            Map<String,Schema.SObjectField> myObjectFieldMap = newRecord.getsObjectType().getDescribe().fields.getMap();

            //for each record in scope, split the row into columns
            String[] currentRecordFields=splitItUp(scope, myRow);

            // for each column in currentRecordFields, get col number to find which field you are on. Set the field value for the object.
            String currentId = '';
            for (Integer myFieldIndex=0; myFieldIndex<currentRecordFields.size(); myFieldIndex++) {

                // Get the current field name and current field value
                String currentFieldValue = currentRecordFields[myFieldIndex].replaceAll('"','').replaceAll('\r','');
                if (String.isEmpty(currentFieldValue)) continue; //no need to do anything with empties
                String currentFieldName = headerFieldIndex.get(myFieldIndex);

                // get the fieldDescribeResult from myObjectFieldMap
                Schema.SObjectField currentField = myObjectFieldMap.get(currentFieldName);

                //if that field isn't a thing then someone messed up somewhere
                if (currentField == null ) throw new TestSetupException(currentFieldName + ' found in file: ' + currentTestConfig.Static_Resource__c + ' does not exist in SF. Update file or add field to SF.');

                //they didn't mess up somewhere. it exists. so describe it.
                Schema.DescribeFieldResult currentFieldSchema = currentField.getDescribe();

                // check if the field is the std Id field
                if (currentFieldSchema.getType() == Schema.DisplayType.ID)
                    currentId = currentFieldValue;
                else {
                    //no need to do anything if we want only required fields and this isn't required
                    if (tdc.Required_Fields_Only__c && currentFieldSchema.isNillable()) continue;

                    //okay well then get the value of this thing and use it
                    String myValue = getTheValue(currentFieldSchema, currentFieldValue);

                    Set<String> numTypes = new Set<String>{'CURRENCY','INTEGER','DECIMAL','DOUBLE'};
                    if (currentFieldSchema.getType() == Schema.DisplayType.Reference && !'RecordTypeId'.equalsIgnoreCase(currentFieldSchema.getName())) newRecord.put(currentFieldName, myValue);
                    else if (currentFieldSchema.getType() == Schema.DisplayType.Date) newRecord.put(currentFieldName, getTheDate(myValue));
                    else if (currentFieldSchema.getType() == Schema.DisplayType.DateTime) newRecord.put(currentFieldName, DateTime.parse(myValue));
                    else if (numTypes.contains(string.valueof(currentFieldSchema.getType())) && myValue != null) newRecord.put(currentFieldName, integer.valueOf(myValue));
                    else if (currentFieldSchema.getType() == Schema.DisplayType.Boolean) newRecord.put(currentFieldName, boolean.valueof(myValue));
                    else if (currentFieldSchema.getType() == Schema.DisplayType.base64) newRecord.put(currentFieldName, Blob.valueOf(myValue));
                    else newRecord.put(currentFieldName, myValue);
                }
            }

            // update the recordToOldId map
            recordToOldId.put(newRecord.clone(false,true,false,false), currentId);

            // If this record has already been inserted to the Database due to a previous run, add it to the update list
            if (sObjectToIdMap.containsKey(tdc.Object__c) && sObjectToIdMap.get(tdc.Object__c).containsKey(currentId)) {
                newRecord.Id = sObjectToIdMap.get(tdc.Object__c).get(currentId);
                toUpdate.add(newRecord);
            } else {
                toInsert.add(newRecord);
            }

        }
        // clone toInsert so we have a copy as of this point in execution
        insertedObjects = toInsert.deepClone();

        insert toInsert;
        update toUpdate;

        firstExecution = False;

        // loop through the save results and the list of sObjects which were inserted
        // for each item, populate the sObjectToIdMap in order to store the new IDs
        populateSObjectToIdMap(insertedObjects, toInsert, recordToOldId);

    }

    //batch finish method. check to see if there is another batch to run
    global void finish(Database.BatchableContext bc) {

        Boolean nextBatchCalled = false; // If true, a batch was executed for the next object in the sequence

        // Check to see if there is another mtd to process after this one.
        // if so, call a new instance of the DataLoaderBatch
        List<Test_Data_Configuration__mdt> objectsToProcess = [SELECT Object__c, Required_Fields_Only__c, Static_Resource__c, Order__c
        FROM Test_Data_Configuration__mdt
        WHERE Order__c != NULL
        AND Is_Active__c = true
        AND Order__c > :orderOfInsert
        ORDER BY Order__c ASC
        LIMIT 1];

        // if there is a next metadata, run it
        if ( objectsToProcess.size() > 0){
            Database.ExecuteBatch(new DataLoaderBatch(objectsToProcess.get(0).Order__c.intValue(), sObjectToIdMap));
            nextBatchCalled = true;
        }

        if (!nextBatchCalled)
            UtilityTestLoader.postExecute();

    }

    //split that row up
    private static String[] splitItUp(List<String> scope, Integer j){
        if(!firstExecution) return scope[j-1].split(',');
        return scope[j].split(',');
    }

    public static void populateSObjectToIdMap(List<sObject>insertedObjects, List<sObject>toInsert, Map<sObject, String> recordToOldId){
        for (Integer insertedIndex = 0; insertedIndex < insertedObjects.size(); insertedIndex++) {
            for (Integer toInsertIndex = 0; toInsertIndex < toInsert.size(); toInsertIndex++){
                if (insertedIndex == toInsertIndex) {
                    String oldId = recordToOldId.get(insertedObjects[insertedIndex]);
                    String newId = toInsert[toInsertIndex].Id;
                    Map<String, String> temp = new Map<String, String>();
                    if (sObjectToIdMap.containsKey(tdc.Object__c)) {
                        temp = sObjectToIdMap.get(tdc.Object__c);
                        temp.put(oldId, newId);
                        sObjectToIdMap.put(tdc.Object__c, temp);
                    } else {
                        temp.put(oldId, newId);
                        sObjectToIdMap.put(tdc.Object__c, temp);
                    }
                }
            }
        }
    }

    //dates should be stored in yyyy-mm-dd format
    public static Date getTheDate(String currentFieldValue){
        Date d = Date.today();
        if(currentFieldValue.containsIgnoreCase('today')){
            if(currentFieldValue.contains('+')){
                d = d.AddDays(Integer.valueOf(currentFieldValue.substringAfter('+')));
            } else if(currentFieldValue.contains('-')){
                d = d.AddDays(Integer.valueOf(currentFieldValue.substring(currentFieldValue.indexOf('-'))));
            }
        } else {
            String[] dateArray = currentFieldValue.split('-');
            d = Date.parse(dateArray.get(1)+'/'+dateArray.get(2)+'/'+dateArray.get(0));
        }
        return d;
    }

    //take the field api name, take the field value, return appropriate value as a string
    public static String getTheValue(Schema.DescribeFieldResult currentFieldSchema, String currentFieldValue){
        if (!String.isBlank(currentFieldValue)) {
            if(userMethods.contains(string.valueof(currentFieldValue))) {
                switch on currentFieldValue{
                    when 'userid'{
                        return UserInfo.getUserId();
                    }
                    when 'profileid'{
                        return UserInfo.getProfileId();
                    }
                }
            }
        }
        if (currentFieldSchema.getType() == Schema.DisplayType.Reference){
            if('RecordTypeId'.equalsIgnoreCase(currentFieldSchema.getName())) {
                return currentFieldValue;
            }
            //TODO: fix references in static resources so that 'current' is instead using 'userid' as above
            if('current'.equalsIgnoreCase(currentFieldValue) &&
                    ('user'.equalsIgnoreCase(currentFieldSchema.getReferenceTo()[0].getDescribe().getName()) ||
                            'group'.equalsIgnoreCase(currentFieldSchema.getReferenceTo()[0].getDescribe().getName()))){
                return UserInfo.getUserId();
            }
            //do some lookup logic
            return doLookupLogic(currentFieldValue);
        }
        return currentFieldValue;
    }

    //consult that map to get actual id of parent
    public static String doLookupLogic(String currentFieldValue){
        Id oldId = Id.valueOf(currentFieldValue); //value of id originally assigned to parent record
        String newId = ''; //value of current id for parent record
        String lookupObjectName = oldId.getSobjectType().getDescribe().getName(); //whatchu lookin up to willis?

        //get map of oldid to new id for lookup object
        if(!sObjectToIdMap.containsKey(lookupObjectName) || !sObjectToIdMap.get(lookupObjectName).containsKey(currentFieldValue)) return null;
        Map<String, String> idMap = sObjectToIdMap.get(lookupObjectName);
        return idMap.get(currentFieldValue);
    }

    //header row is all the fields needed. kinda important.
    public void setHeaderRow(Integer order) {
        // Get the current mdt record for the csv being processed
        tdc = [SELECT Object__c, Required_Fields_Only__c, Static_Resource__c
        FROM Test_Data_Configuration__mdt
        WHERE Order__c =: order];
        currentTestConfig = tdc;

        StaticResource resource = [SELECT Body FROM StaticResource WHERE Name =: tdc.Static_Resource__c];
        // Get just the header row from the specified Static Resource and store that in a variable
        Blob blobby = resource.Body;
        String contentFile = blobby.toString();
        String[] filelines = contentFile.split('\n');

        String header = filelines[0];
        String[] headerValues = header.split(',');
        for (Integer i=0; i<headerValues.size(); i++) {
            String currentFieldName = headerValues[i].replaceAll('"','').replaceAll('\r','');
            headerFieldIndex.put(i, currentFieldName);
        }
    }

}