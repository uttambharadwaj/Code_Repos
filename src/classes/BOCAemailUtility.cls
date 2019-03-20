public class BOCAemailUtility {
    
    public WeFormObject__c weFormObject { 
        get {
            String bocaToProspectId = ApexPages.CurrentPage().getParameters().get('id');
            
            System.debug(bocaToProspectId);
            
            if(bocaToProspectId != null) {
                BOCA_To_Prospect__c bocaToProspect = [SELECT Id, WeFormObject__c FROM Boca_To_Prospect__c WHERE Id = :bocaToProspectId];
                
                if(bocaToProspect != null) {
                	WeFormObject__c weFormObject = [SELECT Id, Opportunity__c, Opportunity__r.Name, CreatedDate, Signer_s_First_Name__c, Signer_s_Last_Name__c, Signer_s_Email__c, Status__c, Message__c FROM WeFormObject__c WHERE Id = :bocaToProspect.WeFormObject__c];
                	if(weFormObject != null) {
	                	return weFormObject;
    	            }
                }
            }
            return null;
        }
    }
    
    public String reminderMessage { get; set; }
    
    public Boolean messageSent { get; set; }
    
    public String messageStatus { get; set; }
    
    public static String jsonList{get;set;}
   // public static Map<String, String> bocaURLS{get;set;}
    public static Map<String, BOCA_IDs__c> bi{get;set;}
    
    public bocaEmailUtility(ApexPages.StandardController ctrl){
        
        Schema.DescribeFieldResult f = Program__c.URL_Generator_Group__c.getDescribe();
        List<Schema.PicklistEntry> p = f.getPicklistValues();
        List<String> v = new List<String>();
        jsonList = '';
        for(Schema.PicklistEntry r : p){
            v.add( r.getLabel() );
        } 
        jsonList = JSON.serialize(v);
    } 
    
     @remoteAction
    public static String sendEmail(Id con, String uName,  boolean togglePG, String we, String oppId, String ccEmail, List<String> fileAttachments){
        //get the custom settings for the email address and instance info
        //
        bi = new Map<String, BOCA_IDs__c>();
        bi = BOCA_IDs__c.getAll();
        BOCA_IDs__c singleBI = new BOCA_IDs__c();
        
        String instance = '';
        String emailAdd = '';
        String replyTo = '';
        String fromName = '';
        Id sellShtz;
        SYSTEM.debug('custom setting ' + bi.get('BOCA IDS') + 'single bi ' + singleBI.get('Email_Address_Noreply__c'));
        if(bi.size() != 0){
            singleBI = bi.get('BOCA IDS');
            SYSTEM.debug('custom setting ' + bi.get('BOCA IDS') + 'single bi ' + singleBI.get('Email_Address_Noreply__c'));
            emailAdd = String.valueOf(singleBI.get('Email_Address_Noreply__c'));
            sellShtz = Id.valueOf(String.valueOf(singleBI.get('BOCA_Sell_Sheet__c')));

        }
        
        String message = '';
        //bocaURLS = new Map<String, String>();
        String body = '';
        
        
        SYSTEM.debug('oppId ' + oppId);
        if(oppId != null && oppId != ''){
            try{
                WeFormObject__c weForm = [SELECT Id, Program__r.BOCA_To_Prospect_Template__c, Sales_Id__c, Name, Program_Info__c, togglePG__c, Promotional_Code__c  
                                          FROM WeFormObject__c WHERE Id =: we LIMIT 1];
           
                User salesPerson = [SELECT Id, Name, Email FROM User WHERE Sales_Code__c =: weForm.Sales_Id__c LIMIT 1];
                
                if(salesPerson.Email != null && salesPerson.Name != null) { 
                	replyTo = salesPerson.Email;
                	fromName = salesPerson.Name;
                }
            
                System.debug('ReplyTo: ' + replyTo + ' | FromName: ' + fromName);
                
                weForm.togglePG__c = togglePG;
                SYSTEM.debug('toggle ' + weForm.togglePG__c );

                Opportunity opty = [SELECT OwnerId, Name, Application_Signer_City__c, Application_Signer_Address__c, Application_Signer_First_Name__c, Application_Signer_Last_Name__c, Application_Signer_Email_Address__c, 
                                    Application_Signer_Phone__c, Application_Signer_Zip_Code__c, Application_Signer__c, Application_Signer_title__c, Billing_City__c, Billing_Contact_Email__c, Billing_Contact_Fax__c, Billing_Contact_First_Name__c, Billing_Contact_Last_Name__c, 
                                    Billing_Contact_Middle_Name__c, Billing_Contact_Phone__c, Annual_Income__c, Annual_Gross_Revenue__c, Average_Monthly_Fueling__c, Account_Phone__c,
                                    Average_Monthly_Expenses__c, Billing_Contact__c, Billing_Country__c, Billing_Street__c, Billing_Street_Line_2__c, Billing_State__c, Billing_Zip_Postal_Code__c, City__c, 
                                    DUNS_Number__c, Doing_Business_As__c, Fiscal_Year_Starts__c, Fleet_Size__c, Id, Legal_Structure__c, Number_Fleet_Vehicles__c, coupon_code__c, Tax_Payer_ID__c,
                                    Physical_Street_Line_2__c, Physical_State__c, Physical_Country__c, Physical_City__c, Physical_Street__c, Physical_Zip_Postal_Code__c, fax__c, Guarantor_Email__c,
                                    Primary_Contact_City__c, Primary_Contact_Fax__c, Primary_Contact_Email__c, Primary_Contact_Country__c, Primary_Contact_First_Name__c, Annual_revenue__c, How_did_you_hear_about_this_offer__c,
                                    Primary_Contact_Last_Name__c, Primary_Contact_Middle_Name__c, Primary_Contact_State__c, Primary_Contact_ZIP_Code__c, Guarantor_Name__c, Exempt_from_Motor_Fuels_Tax__c,
                                    Guarantor_Last_Name__c, Guarantor_City__c, Guarantor_State__c, Guarantor_Zip_code__c, Guarantor_home_phone__c, Guarantor_address_line_1__c, Guarantor_Annual_Income__c,
                                    Primary_Contact_Work_Phone__c, Paperless_Billing_Flag__c, Primary_Contact_Street_Address__c, Years_In_Business__c,Primary_Contact_Street_Address_Line_2__c, Promotional_Code__c 
                                    FROM Opportunity WHERE Id =: oppId];
                
                OpportunityContactRole[] contactRoleArray =
                    [select ContactID, isPrimary from OpportunityContactRole where OpportunityId = :opty.id ORDER BY isPrimary DESC, createdDate];
                
                Contact c = [SELECT Email, Phone, Name, title FROM Contact WHERE Id =: contactRoleArray[0].ContactID];
                Contact b = new Contact();
                
                if(opty.Billing_Contact__c != null) b = [SELECT MobilePhone FROM Contact WHERE Id =: opty.Billing_Contact__c];
                
                if(weForm.Promotional_Code__c == null) weForm.Promotional_Code__c = opty.coupon_Code__c;
                weForm.Company_Name__c = opty.name;
                weForm.Billing_Street_Address__c = opty.Billing_Street__c;
                weForm.Address_Line_2__c = opty.Billing_Street_Line_2__c;
                weForm.Billing_Contact_First_Name__c = opty.Billing_Contact_First_Name__c;
                weForm.Billing_Contact_Last_Name__c = opty.Billing_Contact_Last_Name__c;
                weForm.Billing_Phone__c = String.isEmpty(opty.Billing_Contact_Phone__c) ? '' : opty.Billing_Contact_Phone__c.replaceAll('[^0-9]','');
                weForm.Billing_Fax__c = String.isEmpty(opty.Billing_Contact_Fax__c) ? '': opty.Billing_Contact_Fax__c.replaceAll('[^0-9]','');
                weForm.Billing_Email__c = opty.Billing_Contact_Email__c;
                weForm.Billing_City__c = opty.Billing_City__c;
                weForm.Billing_State__c = opty.Billing_State__c;
                weForm.Billing_Zip_Code__c = opty.Billing_Zip_Postal_Code__c;
                weForm.Taxpayer_ID__c = opty.Tax_Payer_ID__c;
                if(b != null)weForm.Billing_Mobile_Phone__c = String.isEmpty(b.MobilePhone) ? '': b.MobilePhone.replaceAll('[^0-9]','');
                
                weForm.Paperless_Flag__c = opty.Paperless_Billing_Flag__c;
                weForm.Is_business_exempt_from_Motor_Fuels_Tax__c = (opty.Exempt_from_Motor_Fuels_Tax__c != false) ? 'yes' : '';
                weForm.Business_Street_Address__c = opty.Physical_Street__c;
                weForm.City__c = opty.Physical_City__c;
                weForm.State__c = opty.Physical_State__c;
                weForm.Zip_code__c = opty.Physical_Zip_Postal_Code__c;
                weForm.Business_fax__c = String.isEmpty(opty.Fax__c)?'':opty.Fax__c.replaceAll('[^0-9]','');
                weForm.Business_Phone__c = String.isEmpty(opty.Account_Phone__c)?'':opty.Account_Phone__c.replaceAll('[^0-9]','');
                weForm.How_did_you_hear_about_this_offer__c = opty.How_did_you_hear_about_this_offer__c;
                
                weForm.Doing_Business_As__c = opty.Doing_Business_As__c;
                weForm.Years_in_Business__c = String.valueOf(opty.Years_In_Business__c);
                weForm.Legal_Structure__c = opty.Legal_Structure__c;
                weForm.DUNS_Number__c = opty.DUNS_Number__c;
                weForm.Fleet_Size__c = opty.Fleet_Size__c;
                weForm.Estimated_Monthly_Vehicle_Expenses__c = opty.Average_Monthly_Expenses__c;
                weForm.Avg_Monthly_Fuel_Service_Expenses__c = opty.Average_Monthly_Fueling__c;
                weForm.Fiscal_Year_Starts__c = opty.Fiscal_Year_Starts__c;
                weForm.Annual_Gross_Revenue__c = opty.Annual_Revenue__c;
                
                weForm.First_Name__c = opty.Guarantor_Name__c;
                weForm.Last_Name__c = opty.Guarantor_Last_Name__c;
                weForm.Guarantor_Annual_Income__c = opty.Guarantor_Annual_Income__c;
                weForm.PG_Residential_Street_Address__c = opty.Guarantor_address_line_1__c;
                weForm.PG_Residential_City__c = opty.Guarantor_City__c;
                weForm.PG_Residential_State__c = opty.Guarantor_State__c;
                weForm.PG_Residential_Zip__c = opty.Guarantor_Zip_code__c;
                weForm.PG_Residential_Phone__c = opty.Guarantor_home_phone__c;
                weForm.Email__c = opty.Guarantor_Email__c;
                //weForm.Mobile_Phone__c 
                
                weForm.Signer_s_Email__c = c.Email;
                weForm.Signer_s_First_Name__c = c.Name.substringBefore(' ');
                weForm.Signer_s_Last_Name__c = c.Name.substringAfter(' ');
                weForm.Signer_s_Phone__c = String.isEmpty(c.phone)?'':c.phone.replaceAll('[^0-9]','');
                weForm.signer_title__c = c.title;
                
                weForm.OwnerId = opty.OwnerId;
                
                upsert weForm;
                
                BOCA_To_Prospect__c bocaToProspect = new BOCA_To_Prospect__c();
                bocaToProspect.Opportunity__c = opty.Id;
                bocaToProspect.WeFormObject__c = weForm.Id;
                bocaToProspect.Contact__c = con;
                bocaToProspect.Sent__c = Date.today();
                
                insert bocaToProspect;
                
                if(weForm.Program__r.BOCA_To_Prospect_Template__c != null) {
         			sellShtz = weForm.Program__r.BOCA_To_Prospect_Template__c;
        		}
                
            }
            catch(SYSTEM.DmlException ex){
                SYSTEM.debug('Could not access weFormObject ' + ex.getMessage());
            }
        }


        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        System.debug(con);

        mail.setTemplateId(sellShtz);
        mail.setWhatId(we);
        mail.setTargetObjectId(con);
        mail.SetSaveAsActivity(false); 
        if(!String.isEmpty(replyTo) && !String.isEmpty(fromName)) {
        	mail.setReplyTo(replyTo);
        	mail.setSenderDisplayName(fromName);
        }

        if(!String.isEmpty(ccEmail)) {
        	String[] ccAddresses = ccEmail.split(',');
        	for(Integer i = 0; i < ccAddresses.size(); i++) {
	            ccAddresses[i] = (String.valueOf(ccAddresses[i])).replaceAll('(\\s+)', ' ');
    	    }
            
            if(ccAddresses.size() > 0) {
            	mail.setCCAddresses(ccAddresses);
            }
    	}	

        if(fileAttachments != null) {
        
        	List<Messaging.Emailfileattachment> emailAttachments = new List<Messaging.Emailfileattachment>();

            for(String fileId : fileAttachments) { 
        		Document document = [SELECT Id, Name, Body, Type, IsInternalUseOnly FROM Document WHERE Id =: fileId];
        
            	if(document != null && document.IsInternalUseOnly == false) {
   					Messaging.Emailfileattachment emailFileAttachment = new Messaging.Emailfileattachment();
  					emailFileAttachment.setFileName(document.Name + '.' + document.Type);
  					emailFileAttachment.setBody(document.Body);
  					emailAttachments.add(emailFileAttachment);
           		}
                
            }
            
            if(emailAttachments.size() > 0) {
				mail.setFileAttachments(emailAttachments);
            }
        }
        
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        if (!results.get(0).isSuccess()) {
            System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
            message = results.get(0).getErrors()[0].getMessage();
            SYSTEM.debug('message ' + message);
        }
        else message = String.valueOf(results.get(0));
        
        SYSTEM.debug('message ' + message);
        
        return message;
        
    }   
    @remoteAction
    public static String sendEmailMulti(Id con, String uName, List<String> sellSht, List<String> urls, List<String> names, boolean togglePG, String we, String oppId){
        //get the custom settings for the email address and instance info
        //
        bi = new Map<String, BOCA_IDs__c>();
        bi = BOCA_IDs__c.getAll();
        BOCA_IDs__c singleBI = new BOCA_IDs__c();
        
        String instance = '';
        String emailAdd = '';
        String replyTo = '';
        String fromName = '';
        Id sellShtz;
        SYSTEM.debug('custom setting ' + bi.get('BOCA IDS') + 'single bi ' + singleBI.get('Email_Address_Noreply__c'));
        if(bi.size() != 0){
            singleBI = bi.get('BOCA IDS');
            SYSTEM.debug('custom setting ' + bi.get('BOCA IDS') + 'single bi ' + singleBI.get('Email_Address_Noreply__c'));
            emailAdd = String.valueOf(singleBI.get('Email_Address_Noreply__c'));
            sellShtz = Id.valueOf(String.valueOf(singleBI.get('BOCA_Sell_Sheet__c')));
            instance = String.valueOf(singleBI.get('Instance_Prefix__c'));
        }
        
        SYSTEM.debug('lists ' + sellSht + ' ' + urls);
        String message = '';
        //bocaURLS = new Map<String, String>();
        String body = '';
        
        
        SYSTEM.debug('oppId ' + oppId);
        if(oppId != null && oppId != ''){
            try{
                WeFormObject__c weForm = [SELECT Id, Sales_Id__c, Name, Program_Info__c, togglePG__c, Promotional_Code__c  
                                          FROM WeFormObject__c WHERE Id =: we LIMIT 1];
                if(urls.size() > 0 ){
                    for(Integer i=0; i<urls.size(); i++){
                        //bocaURLS.put(urls.get(i),sellSht.get(i));
                        body+= '\n' +'<a href=' + instance + 'creditapplication/' + urls.get(i) + '&priority=true&customer='+ weForm.id + '&salescode=' + weForm.Sales_Id__c + '&cc=' + weForm.Promotional_Code__c + '>'+
                            +names.get(i) +' Program'+'</a><br/><br/>' + 'Program Information ' + '<br/>'+
                            sellSht.get(i) + '<br/><br/>' ;
                    }
                }
            
                weForm.togglePG__c = togglePG;
                SYSTEM.debug('toggle ' + weForm.togglePG__c );
                weForm.Program_Info__c =  body;
                SYSTEM.debug('message ' + weForm.Program_Info__c);
                
                User salesPerson = [SELECT Id, Name, Email FROM User WHERE Sales_Code__c =: weForm.Sales_Id__c LIMIT 1];
                
                if(salesPerson.Email != null && salesPerson.Name != null) { 
                	replyTo = salesPerson.Email;
                	fromName = salesPerson.Name;
                }
                
                Opportunity opty = [SELECT name, OwnerId, Application_Signer_City__c, Application_Signer_Address__c, Application_Signer_First_Name__c, Application_Signer_Last_Name__c, Application_Signer_Email_Address__c, 
                                    Application_Signer_Phone__c, Application_Signer_Zip_Code__c, Application_Signer__c, Application_Signer_title__c, Billing_City__c, Billing_Contact_Email__c, Billing_Contact_Fax__c, Billing_Contact_First_Name__c, Billing_Contact_Last_Name__c, 
                                    Billing_Contact_Middle_Name__c, Billing_Contact_Phone__c, Annual_Income__c, Annual_Gross_Revenue__c, Average_Monthly_Fueling__c, Account_Phone__c,
                                    Average_Monthly_Expenses__c, Billing_Contact__c, Billing_Country__c, Billing_Street__c, Billing_Street_Line_2__c, Billing_State__c, Billing_Zip_Postal_Code__c, City__c, 
                                    DUNS_Number__c, Doing_Business_As__c, Fiscal_Year_Starts__c, Fleet_Size__c, Id, Legal_Structure__c, Number_Fleet_Vehicles__c, coupon_code__c, Tax_Payer_ID__c,
                                    Physical_Street_Line_2__c, Physical_State__c, Physical_Country__c, Physical_City__c, Physical_Street__c, Physical_Zip_Postal_Code__c, fax__c, Guarantor_Email__c,
                                    Primary_Contact_City__c, Primary_Contact_Fax__c, Primary_Contact_Email__c, Primary_Contact_Country__c, Primary_Contact_First_Name__c, Annual_revenue__c, How_did_you_hear_about_this_offer__c,
                                    Primary_Contact_Last_Name__c, Primary_Contact_Middle_Name__c, Primary_Contact_State__c, Primary_Contact_ZIP_Code__c, Guarantor_Name__c, Exempt_from_Motor_Fuels_Tax__c,
                                    Guarantor_Last_Name__c, Guarantor_City__c, Guarantor_State__c, Guarantor_Zip_code__c, Guarantor_home_phone__c, Guarantor_address_line_1__c, Guarantor_Annual_Income__c,
                                    Primary_Contact_Work_Phone__c, Paperless_Billing_Flag__c, Primary_Contact_Street_Address__c, Years_In_Business__c,Primary_Contact_Street_Address_Line_2__c, Promotional_Code__c 
                                    FROM Opportunity WHERE Id =: oppId];
                
                OpportunityContactRole[] contactRoleArray =
                    [select ContactID, isPrimary from OpportunityContactRole where OpportunityId = :opty.id ORDER BY isPrimary DESC, createdDate];
                
                Contact c = [SELECT Email, Phone, Name, title FROM Contact WHERE Id =: contactRoleArray[0].ContactID];
                Contact b = new Contact();
                
                if(opty.Billing_Contact__c != null) b = [SELECT MobilePhone FROM Contact WHERE Id =: opty.Billing_Contact__c];
                
                if(weForm.Promotional_Code__c == null) weForm.Promotional_Code__c = opty.coupon_Code__c;
                weForm.Company_Name__c = opty.name;
                weForm.Billing_Street_Address__c = opty.Billing_Street__c;
                weForm.Address_Line_2__c = opty.Billing_Street_Line_2__c;
                weForm.Billing_Contact_First_Name__c = opty.Billing_Contact_First_Name__c;
                weForm.Billing_Contact_Last_Name__c = opty.Billing_Contact_Last_Name__c;
                weForm.Billing_Phone__c = String.isEmpty(opty.Billing_Contact_Phone__c) ? '' : opty.Billing_Contact_Phone__c.replaceAll('[^0-9]','');
                weForm.Billing_Fax__c = String.isEmpty(opty.Billing_Contact_Fax__c) ? '': opty.Billing_Contact_Fax__c.replaceAll('[^0-9]','');
                weForm.Billing_Email__c = opty.Billing_Contact_Email__c;
                weForm.Billing_City__c = opty.Billing_City__c;
                weForm.Billing_State__c = opty.Billing_State__c;
                weForm.Billing_Zip_Code__c = opty.Billing_Zip_Postal_Code__c;
                weForm.Taxpayer_ID__c = opty.Tax_Payer_ID__c;
                if(b != null)weForm.Billing_Mobile_Phone__c = String.isEmpty(b.MobilePhone) ? '': b.MobilePhone.replaceAll('[^0-9]','');
                
                weForm.Paperless_Flag__c = opty.Paperless_Billing_Flag__c;
                weForm.Is_business_exempt_from_Motor_Fuels_Tax__c = (opty.Exempt_from_Motor_Fuels_Tax__c != false) ? 'yes' : '';
                weForm.Business_Street_Address__c = opty.Physical_Street__c;
                weForm.City__c = opty.Physical_City__c;
                weForm.State__c = opty.Physical_State__c;
                weForm.Zip_code__c = opty.Physical_Zip_Postal_Code__c;
                weForm.Business_fax__c = String.isEmpty(opty.Fax__c)?'':opty.Fax__c.replaceAll('[^0-9]','');
                weForm.Business_Phone__c = String.isEmpty(opty.Account_Phone__c)?'':opty.Account_Phone__c.replaceAll('[^0-9]','');
                weForm.How_did_you_hear_about_this_offer__c = opty.How_did_you_hear_about_this_offer__c;
                
                weForm.Doing_Business_As__c = opty.Doing_Business_As__c;
                weForm.Years_in_Business__c = String.valueOf(opty.Years_In_Business__c);
                weForm.Legal_Structure__c = opty.Legal_Structure__c;
                weForm.DUNS_Number__c = opty.DUNS_Number__c;
                weForm.Fleet_Size__c = opty.Fleet_Size__c;
                weForm.Estimated_Monthly_Vehicle_Expenses__c = opty.Average_Monthly_Expenses__c;
                weForm.Avg_Monthly_Fuel_Service_Expenses__c = opty.Average_Monthly_Fueling__c;
                weForm.Fiscal_Year_Starts__c = opty.Fiscal_Year_Starts__c;
                weForm.Annual_Gross_Revenue__c = opty.Annual_Revenue__c;
                
                weForm.First_Name__c = opty.Guarantor_Name__c;
                weForm.Last_Name__c = opty.Guarantor_Last_Name__c;
                weForm.Guarantor_Annual_Income__c = opty.Guarantor_Annual_Income__c;
                weForm.PG_Residential_Street_Address__c = opty.Guarantor_address_line_1__c;
                weForm.PG_Residential_City__c = opty.Guarantor_City__c;
                weForm.PG_Residential_State__c = opty.Guarantor_State__c;
                weForm.PG_Residential_Zip__c = opty.Guarantor_Zip_code__c;
                weForm.PG_Residential_Phone__c = opty.Guarantor_home_phone__c;
                weForm.Email__c = opty.Guarantor_Email__c;
                //weForm.Mobile_Phone__c 
                
                weForm.Signer_s_Email__c = c.Email;
                weForm.Signer_s_First_Name__c = c.Name.substringBefore(' ');
                weForm.Signer_s_Last_Name__c = c.Name.substringAfter(' ');
                weForm.Signer_s_Phone__c = String.isEmpty(c.phone)?'':c.phone.replaceAll('[^0-9]','');
                weForm.signer_title__c = c.title;
                
                weForm.OwnerId = opty.OwnerId;
                
                upsert weForm;
  
            }
            catch(SYSTEM.DmlException ex){
                SYSTEM.debug('Could not access weFormObject ' + ex.getMessage());
            }
        }
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setTemplateId(sellShtz);
        mail.setWhatId(we);
        mail.setTargetObjectId(con);
        mail.SetSaveAsActivity(false);
        if(!String.isEmpty(replyTo) && !String.isEmpty(fromName)) {
        	mail.setReplyTo(replyTo);
        	mail.setSenderDisplayName(fromName);
        }
              
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        if (!results.get(0).isSuccess()) {
            System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
            message = results.get(0).getErrors()[0].getMessage();
            SYSTEM.debug('message ' + message);
        }
        else message = String.valueOf(results.get(0));
        SYSTEM.debug('message ' + message);
        return message;
        
    }
    
    public PageReference sendReminder(){
	
		//get the custom settings for the email address and instance info
		//
		bi = new Map<String, BOCA_IDs__c>();
		bi = BOCA_IDs__c.getAll();
		BOCA_IDs__c singleBI = new BOCA_IDs__c();
	
		String instance = '';
		String emailAdd = '';
		String replyTo = '';
		String fromName = '';
		Id sellShtz;
		SYSTEM.debug('custom setting ' + bi.get('BOCA IDS') + 'single bi ' + singleBI.get('Email_Address_Noreply__c'));
		if(bi.size() != 0){
			singleBI = bi.get('BOCA IDS');
			SYSTEM.debug('custom setting ' + bi.get('BOCA IDS') + 'single bi ' + singleBI.get('Email_Address_Noreply__c'));
			emailAdd = String.valueOf(singleBI.get('Email_Address_Noreply__c'));
			sellShtz = Id.valueOf(String.valueOf(singleBI.get('BOCA_Sell_Sheet__c')));

		}
	
		String message = '';
		//bocaURLS = new Map<String, String>();
		String body = '';
	
        Boca_To_Prospect__c bocaToProspect = [SELECT Id, Contact__c FROM Boca_To_Prospect__c WHERE WeFormObject__c = :weFormObject.Id];
            
		WeFormObject__c weForm = [SELECT Id, Program__r.BOCA_To_Prospect_Template__c, Message__c, Sales_Id__c, Name, Program_Info__c, togglePG__c, Promotional_Code__c  
									FROM WeFormObject__c WHERE Id = :weFormObject.Id LIMIT 1];
        
        weForm.message__c = reminderMessage;
        
        upsert weForm;
		
        if(weForm.Program__r.BOCA_To_Prospect_Template__c != null) {
        	sellShtz = weForm.Program__r.BOCA_To_Prospect_Template__c;
		}
        
		User salesPerson = [SELECT Id, Name, Email FROM User WHERE Sales_Code__c =: weForm.Sales_Id__c LIMIT 1];
		
		if(salesPerson.Email != null && salesPerson.Name != null) { 
			replyTo = salesPerson.Email;
			fromName = salesPerson.Name;
		}
        
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	
		mail.setTemplateId(sellShtz);
		mail.setWhatId(weForm.Id);
		mail.setTargetObjectId(bocaToProspect.Contact__c);
		mail.SetSaveAsActivity(false);     
		mail.setReplyTo(replyTo);
		mail.setSenderDisplayName(fromName);
	
		List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		if (!results.get(0).isSuccess()) {
			System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
			message = results.get(0).getErrors()[0].getMessage();
			SYSTEM.debug('message ' + message);
		}
		else message = String.valueOf(results.get(0));
	
		SYSTEM.debug('message ' + message);

        messageSent = true;
        
        bocaToProspect.Last_Reminder_Sent__c = Date.today();
        
        upsert bocaToProspect;
        
        System.debug(messageSent);
        System.debug(message);

        messageStatus = message;
        
        return null;
	}
    
}