trigger ContactValidator on Contact(before insert, before update) {
 	
 	Set<Id> AU_Contact_RTs = new Set<Id>();
	
	for(RecordType rt : [select Id from RecordType where sObjectType = 'Contact' and DeveloperName IN ('AU_Contact')])
		AU_Contact_RTs.add(rt.Id);
		
	List<Contact> contacts = new List<Contact>();
    for(Contact c : Trigger.new)
    {
    	if(!AU_Contact_RTs.contains(c.RecordTypeId))
    		contacts.add(c);
    }     
    
    if(!contacts.isEmpty())
    	ContactUtility.removeCarriageReturnsFromContact(contacts);
                     
}