/**
 * Created by dgilbert on 2019-09-23.
 */

({
    init : function (component, event, helper) {
        // Find the component whose aura:id is "flowData"
        var flow = component.find("flowData");
        // In that component, start your flow. Reference the flow's API Name.
        console.log(component.get("v.recordId"));

        var action = helper.getURLParameter("c__action");

        var inputVariables = [
            {
                name: 'recordId',
                type: 'String',
                value: component.get('v.recordId')
            },
            {
                name: 'onlineUrl',
                type: 'String',
                value: component.get('v.onlineUrl')
            }
        ]
        
        if(component.get('v.didLength') !== "" && action === "driver") {
            inputVariables.push({
                name: 'didLength',
                type: 'String', 
                value: component.get('v.didLength')
            });
        }
        
        if(action === "driver") {
            flow.startFlow("NA_Add_Driver", inputVariables);
        }
        else if(action === "card") {
            flow.startFlow("Add_Card", inputVariables);
        }
        else {
            flow.startFlow("NA_Add_Contact", inputVariables);
        }
    },

});