trigger SiebelLoginIdUpdate on Task (before update, before insert) {
List <String> OwnerId = new List <String> ();

for (Integer i = 0; i < Trigger.new.size(); i++)
{
//Salesforce Integration Id in Sandbox = 00570000001Lkjs
//Salesforce Integration Id in Live Org = 00570000001Lkjs
//if(Trigger.new[i].OwnerId == '00570000001Lkjs') //can have this fired only for certain record types???
{
OwnerId.add(Trigger.new[i].OwnerId);
}
}

List <User> UserList = new List <User> ([Select Siebel_Login_Id__c from User where Id in :OwnerId]);

for (Integer i = 0; i < Trigger.new.size(); i++)
{
for (Integer j = 0; j < UserList.size(); j++)
{
Trigger.new[i].Siebel_LOGIN__c = UserList[j].Siebel_Login_Id__c;
}
}
}