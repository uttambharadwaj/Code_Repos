/*
* Test Setup Framework Iterator
* Author: Jason Arbegast
* Initial Date: 5/14/2019
* Description:  creates iterable for dataloaderbatch to use
* Revision History: 
*/

global class CustomIterable implements Iterator<String>, Iterable<String>{

    List<String> records {get; set;}
    Integer i {get; set;}

    public Iterator<String> iterator() {
        return this;
    }

    public CustomIterable(Integer order){

        Test_Data_Configuration__mdt tdc = [SELECT Object__c, Required_Fields_Only__c, Static_Resource__c
        FROM Test_Data_Configuration__mdt
        WHERE Order__c =: order];

        StaticResource nextResource = [SELECT Body FROM StaticResource  WHERE Name =: tdc.Static_Resource__c];

        Blob blobby = nextResource.Body;
        String contentFile = blobby.toString();
        String[] filelines = contentFile.split('\n');

        this.records = filelines;
        i = 0;

        //tests shouldn't need more than 200 of an object. if it does you have bigger issues than test code
        if ( Test.isRunningTest() ) {
            List<String> testRecords = new List<String>();
            for ( Integer i = 0; i < 200; i++ ) {
                if ( this.records.size() > i ) {
                    testRecords.add( filelines[i] );
                }
            }
            this.records = testRecords;
        }
    }

    global boolean hasNext(){
        if(i >= records.size())
            return false;
        return true;
    }

    global String next(){
        if(i < records.size()) {
            i++;
            return records[i-1];
        }
        return null;
    }
}