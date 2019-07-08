({
	addContact : function(component, event, helper) {
		var allContacts = component.get("v.myContacts");
		var oneContact = this.newContact();
		allContacts.push(oneContact);
		component.set("v.myContacts", allContacts);
	},
    
    newContact : function(component, event, helper){
		var oneContact = {
			firstName : '',
			lastName : '',
			email : '',
			phone : ''
		};
		return oneContact;
	},

	removeOneContact : function(component, event, helper){
		console.log('remove contact');
		const thisEvent = event.getSource().get('v.value');
		var allContacts = component.get("v.myContacts");
		allContacts.splice(thisEvent, 1);
		component.set("v.myContacts", allContacts);
	},
})