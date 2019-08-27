/**
 * Created by W083158 on 4/16/2019.
 */
({

    /*

     * This method is being called from init event

     * to fetch all available recordTypes

     * */

    fetchListOfRecordTypes: function(component, event, helper) {

        // Set the validate attribute to a function that includes validation logic
        cmp.set('v.validate', function() {
            var userInput = cmp.get('v.recordTypePickList');
            if(userInput && userInput.length>0) {
                // If the component is valid...
                return { isValid: true };
            }
            else {
                // If the component is invalid...
                return { isValid: false, errorMessage: 'You must select Refund or Adjustment.' };
            }})


        var action = component.get("c.fetchRecordTypeValues");



        //pass the object name here for which you want

        //to fetch record types

        action.setParams({

            "objectName" : "refund_adjustment__c"

        });



        action.setCallback(this, function(response) {

            var mapOfRecordTypes = response.getReturnValue();

            component.set("v.mapOfRecordType", mapOfRecordTypes);



            var recordTypeList = [];

            //Creating recordTypeList from retrieved Map

            for(var key in mapOfRecordTypes){

                recordTypeList.push(mapOfRecordTypes[key]);

            }



            if(recordTypeList.length == 0){//Object does not have any record types

                //Close Quick Action Modal here

                helper.closeModal();



                //Calling CreateRecord modal here without providing recordTypeId

                helper.showCreateRecordModal(component, "", "Refund_Adjustment__c");

            } else{

                component.set("v.lstOfRecordType", recordTypeList);

            }



        });

        $A.enqueueAction(action);

    },



    /*

     * This method will be called when "Next" button is clicked

     * It finds the recordTypeId from selected recordTypeName

     * and passes same value to helper to create a record

     * */

    createRecord: function(component, event, helper, sObjectRecord) {

        var selectedRecordTypeName = component.find("recordTypePickList").get("v.value");

        if(selectedRecordTypeName != ""){

            var selectedRecordTypeMap = component.get("v.mapOfRecordType");

            var selectedRecordTypeId;



            //finding selected recordTypeId from recordTypeName

            for(var key in selectedRecordTypeMap){

                if(selectedRecordTypeName == selectedRecordTypeMap[key]){

                    selectedRecordTypeId = key;//match found, set value in selectedRecordTypeId variable

                    break;

                }

            }

            //Close Quick Action Modal here

            helper.closeModal();



            //Calling CreateRecord modal here without providing recordTypeId

            helper.showCreateRecordModal(component, selectedRecordTypeId, "Refund_Adjustment__c");

        } else{

            alert('You did not select any record type');

        }



    },



    /*

     * closing quickAction modal window

     * */

    closeModal : function(component, event, helper){

        helper.closeModal();

    }

})