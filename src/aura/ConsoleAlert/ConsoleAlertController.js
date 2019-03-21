({
    doInit: function(component, event, helper) {
        var utilityAPI = component.find("utilitybar");
        utilityAPI.getAllUtilityInfo().then(function(response) {
            var currentUtil = response[response.length - 1];  
            utilityAPI.setUtilityLabel({ label: "", utilityId: currentUtil.id });
        });

        helper.checkForAlert(component);
        window.setInterval(function() { helper.checkForAlert(component); }, 60000);
    },
})