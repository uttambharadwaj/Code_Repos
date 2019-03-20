trigger V2SA_OwnerChange on Task (before update, before insert) {
List <String> WhatId = new List <String> ();

for (Integer i = 0; i < Trigger.new.size(); i++)
{
//Salesforce Integration Id in Sandbox = 00570000001Lkjs
//Salesforce Integration Id in Live Org = 00570000001Lkjs
if(Trigger.new[i].OwnerId == '00570000001Lkjs')
{
WhatId.add(Trigger.new[i].WhatId);
}
}

List <Opportunity> OppList = new List <Opportunity> ([Select Id, OwnerId from Opportunity where Id in :WhatId]);

for (Integer i = 0; i < Trigger.new.size(); i++)
{
for (Integer j = 0; j < OppList.size(); j++)
{
Trigger.new[i].OwnerID = OppList[j].OwnerId;
}
}
}