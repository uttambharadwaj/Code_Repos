({
	doInit : function(component, event, helper) {

	},

	addNewContact : function(component, event, helper){
        helper.addContact(component, event, helper);
	},

	removeContact : function(component, event, helper){
		helper.removeOneContact(component, event, helper);
	}
})