({
   
     clickCreate: function(component, event, helper) {
        var newCompassionFundForm = component.get("v.newCompassionFundForm");
         var allValid = component.find('field').reduce(function (validSoFar, inputCmp)  {
                  inputCmp.showHelpMessageIfInvalid();
        		  return validSoFar && !inputCmp.get('v.validity').valueMissing;	
                  }, true);
         if (allValid) {
            helper.createCompassionFundForm(component, newCompassionFundForm);
        } else {
            alert('Please update the invalid form entries and try again.');           
        }           
    }
})