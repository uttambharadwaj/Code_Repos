trigger ContactValidator on Contact(before insert, before update) {
	if(TriggerFactory.disabledTriggers(Contact.sObjectType)) return;
 	Set<Id> AU_Contact_RTs = UtilityClass.getRecTypeByDevName('Contact',new List<String>{'AU_Contact'});
	
	List<Contact> contacts = new List<Contact>();
    for(Contact c : Trigger.new)
    {
    	if(!AU_Contact_RTs.contains(c.RecordTypeId))
    		contacts.add(c);
    }     
    
    if(!contacts.isEmpty())
    	ContactUtility.removeCarriageReturnsFromContact(contacts);
                     
}