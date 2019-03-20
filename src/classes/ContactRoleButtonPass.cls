@isTest
private class ContactRoleButtonPass{

    static testMethod void verifyContactRoleButtonPassTrigger(){
    
		List<String> AU_Opp_RTs = new List<String>{'AU_Fuel_Card_Business','AU_Fuel_Card_Individual','AU_Fuel_Merchant'};
	
	Id oppRT = [select Id from RecordType where sObjectType = 'Opportunity' and DeveloperName NOT IN :AU_Opp_RTs limit 1].Id;

        Opportunity o= new Opportunity(Name='My Opportunity',CloseDate=date.today(),StageName='5) Signed', RecordTypeId = oppRT);
        insert o;
        
       	List<String> AU_Contact_RTs = new List<String>{'AU_Contact'};
	
		Id conRT = [select Id from RecordType where sObjectType = 'Contact' and DeveloperName NOT IN :AU_Contact_RTs limit 1].Id;
		

Contact con = new Contact(LastName='Jones', RecordTypeId = conRT);
insert con;

Contact con2 = new Contact(LastName='Smith', RecordTypeId = conRT);
insert con2;

Contact con3 = new Contact(LastName='Andrews', RecordTypeId = conRT);
insert con3;

Contact con4 = new Contact(LastName='Marks', RecordTypeId = conRT);
insert con4;



        OpportunityContactRole ocr= new OpportunityContactRole(OpportunityID = o.Id,ContactId = con.Id,Role = 'App Signer',IsPrimary=false);
        insert ocr;
        
        OpportunityContactRole ocr2= new OpportunityContactRole(OpportunityID = o.Id,ContactId = con2.Id,Role = 'Economic Buyer',IsPrimary=false);
        insert ocr2;
        
                OpportunityContactRole ocr3= new OpportunityContactRole(OpportunityID = o.Id,ContactId = con3.Id,Role = 'App Signer',IsPrimary=false);
        insert ocr3;


        
              test.startTest();
              
              ocr3.IsPrimary=true;
              update ocr3;
              update o;
              
              ocr.Role='Billing Contact';
              update ocr;
              update o;
              
              ocr2.Role='App Signer';
              ocr3.IsPrimary=false;
              update ocr2;
              update ocr3;
              update o;
              
                    
              ocr.IsPrimary=true;
              update ocr;
              ocr3.Role='Billing Contact';
              update ocr3;
              update o;
              
              delete ocr;
              delete ocr2;             
              delete ocr3;
              update o;
              
                                    OpportunityContactRole ocr13= new OpportunityContactRole(OpportunityID = o.Id,ContactId = con4.Id,Role = 'Decision Maker',IsPrimary=false);
        insert ocr13;
                                            OpportunityContactRole ocr14= new OpportunityContactRole(OpportunityID = o.Id,ContactId = con3.Id,Role = 'Decision Maker',IsPrimary=false);
        insert ocr14;
        update o;
        
                      ocr14.IsPrimary=true;
              update ocr14;
                      update o;
              
                      OpportunityContactRole ocr11= new OpportunityContactRole(OpportunityID = o.Id,ContactId = con.Id,Role = 'App Signer',IsPrimary=false);
        insert ocr11;
        
        OpportunityContactRole ocr12= new OpportunityContactRole(OpportunityID = o.Id,ContactId = con2.Id,Role = 'Billing Contact',IsPrimary=false);
        insert ocr12;



              
              test.stopTest();
              
             }
}