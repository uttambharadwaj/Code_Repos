trigger EchoRevolverTrigger on Opportunity (after update) {
    List<Application_Request__c> apps = new List<Application_Request__c>();
    Boolean isApp = false;
    
    Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Revolver Record').getRecordTypeId();
    
    for(Opportunity o : Trigger.new){
        if(o.RecordTypeId == recordTypeId && o.SourceSystem__c != 'BOCA'){        
            Id i = o.Id;
            apps = [SELECT Opportunity__c, ID FROM Application_Request__c WHERE Opportunity__c =: i LIMIT 1];
            //check to see if the appreq. already exists
            isApp = apps.size() == 0 ? false : true;
            if(!isApp){
                // Create Application Requests
                try{
                    SYSTEM.debug('camp prog id' + o.Campaign_Program__c);
                    Campaign_Program__c cp1 = [SELECT Id, Program__c FROM Campaign_Program__c WHERE Id = : o.Campaign_Program__c];
                    Program__c pro = [SELECT Id, Auto_Send_BOCA_to_Siebel__c FROM Program__c WHERE Id = :cp1.Program__c];
                    
                    Application_Request__c app = new Application_Request__c();
                    
                    app.RecordTypeId = UtilityClass.getRecordTypeByName(Application_Request__c.getSObjectType(),'Revolver Application');
                    
                    app.Account_Name__c = o.AccountId;
                    app.Opportunity__c = o.Id;
                    app.Source_System_Text__c = 'Salesforce';

                    //check for app signer on Opp
                    OpportunityContactRole cr = new OpportunityContactRole();
                    try{
                    	cr = [SELECT ContactId, role, OpportunityId
                                      FROM OpportunityContactRole WHERE role =: 'App Signer' and OpportunityId =: o.id LIMIT 1];
                    }
                    catch(DMLexception ex){
                        SYSTEM.debug('Contact Role Query: ' + ex);
                    }
                    //Opp is read-only at this point so we have to update the app requet directly from the contact role
                    if(cr != null){app.App_Signer__c = cr.ContactId;}
                    
                    //app.App_Signer__c =o.Application_Signer__c;
                    
                    app.Sales_Person__c = o.OwnerId;
                    
                    app.Billing_Contact__c = o.Billing_Contact__c;
                    
                    //create a new contact for the PG
                    contact PG = new contact();
                    PG.RecordTypeId = UtilityClass.getRecordTypeByName(Contact.getSObjectType(),'Revolver');
                    
                    PG.AccountId = o.AccountId;
                    PG.FirstName = o.Billing_Contact_First_Name__c;
                    PG.LastName = o.Billing_Contact_Last_Name__c;                
                    PG.Birthdate =  o.Guarantor_date_of_birth__c;
                    PG.Phone = o.Guarantor_home_phone__c;
                    PG.SSN__c = o.Guarantor_Social_Security_Number__c;
                    PG.Annual_Income__c = o.Guarantor_Annual_Income__c;
                    PG.MailingStreet = o.Guarantor_address_line_1__c + ' ' + o.Guarantor_address_line_2__c ;
                    PG.MailingCity = o.Guarantor_City__c;
                    PG.MailingState = o.Guarantor_State__c;
                    PG.MailingPostalCode = o.Guarantor_Zip_code__c;
                    PG.Email = o.Guarantor_Email__c;          
                    
                    insert PG;
          
                    app.Personal_Guarantor__c = PG.Id;
         
                    app.Paperless_Delivery__c = o.Paperless_Billing_Flag__c;
                    app.DUNS_Number__c = o.DUNS_Number__c;
                    app.Annual_Gross_Revenue__c = o.Annual_Gross_Revenue__c;                
                    
                    app.Billing_Street__c = o.Billing_Street__c;
                    app.Billing_Street_Line_2__c = o.Billing_Street_Line_2__c;
                    app.Billing_City__c = o.Billing_City__c;
                    app.Billing_State__c = o.Billing_State__c;
                    app.Billing_Zip_Postal_Code__c = o.Billing_Zip_Postal_Code__c;
                    
                    app.Physical_Street__c = o.Physical_Street__c;
                    app.Physical_Street_Line_2__c = o.Physical_Street_Line_2__c;
                    app.Physical_City__c = o.Physical_City__c;
                    app.Physical_State__c = o.Physical_State__c;
                    app.Physical_Zip_Postal_Code__c = o.Physical_Zip_Postal_Code__c;              
                    
                    app.Expected_Monthly_Vehicle_Expense__c = o.Average_Monthly_Expenses__c;
                    app.Requested_Credit_limit__c = o.Requested_Credit_Limit__c;
                    app.App_Signer_IP_Address__c = o.IP_Address__c; 
                    app.Fiscal_Year_Starts__c = o.Fiscal_Year_Starts__c;                   
                    if(o.fiscal_year_starts__c == null){
                        app.fiscal_year_starts__c = 'January';
                    }
                    
                    app.How_did_you_hear_about_this_offer__c = o.How_did_you_hear_about_this_offer__c == null ? 'Web' : o.How_did_you_hear_about_this_offer__c;
                    
                    app.Legal_Structure__c = o.Legal_Structure__c;
                    
                    app.Exempt_from_Motor_Fuels_Tax__c =  o.Exempt_from_Motor_Fuels_Tax__c ;
                                       
                    app.Years_In_Business__c = o.Years_In_Business__c;
                   
                    try{
                         app.Forward_Application_to_Credit__c = 'Yes';
                        insert app; 
                        system.debug('Here is oppty in App:' +app.Opportunity__c);
                    }
                    catch(Exception ex){
                        System.debug('ERROR ADDING THE APP REQUEST: ' + ex.getStackTraceString() );
                        app.Forward_Application_to_Credit__c = ' ';
                        app.Offic_App_Error_Log__c = 'Error submitting app request: ' + ex.getMessage();
                        
                        insert app;
                        
                    }//end try/catch for App Request
                    
                    
                }
                catch (Exception ex){
                    System.debug('ERROR: ' + ex.getStackTraceString() );
                }//end global try/catch 
                
            }
            
            
            
        }
    }
    
    
}