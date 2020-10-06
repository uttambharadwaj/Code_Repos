({
	createCompassionFundForm : function(component, newCompassionFundForm) {
        var action = component.get("c.saveCompassionFundForm");  
        action.setParams({
            "newCompassionFundForm": newCompassionFundForm
        });
        action.setCallback(this, function(response){
            var state = response.getState(); 
            console.log('state = ' + response);
            if (state === "SUCCESS") {     
                component.set("v.formSubmitted", true);   
                var toastEvent = $A.get("e.force:showToast");                    
                toastEvent.setParams({ "type": "success", "title": "Success", "message": "Your Application has been submitted!", "duration": 15000});
                toastEvent.fire(); 
                //confirm('Application submitted, thank you ' + newCompassionFundForm.First_Name__c + '. You will recieve a confirmation email shortly.');
                var newCompassionFundForm = component.get("v.newCompassionFundForm");
                component.set("v.newCompassionFundForm", newCompassionFundForm);           
            }
            else if (state === "ERROR") {
                var errorMessage = "Unknown Fault";
                var errors = response.getError();
                if (errors && Array.isArray(errors) && errors.length > 0) {
                	errorMessage = errors[0].message;
                }
                var toastEvent = $A.get("e.force:showToast"); 
                toastEvent.setParams({ "type": "error", "title": "Error", "message": errorMessage, "duration": 15000});
                toastEvent.fire(); 
            }
            event.preventDefault();
        });
        $A.enqueueAction(action);           
	}
})