/* ************************************************************
* Created By  : Phillip Southern (GearsCRM)
* Created Date: 05/03/2013
 * Description : UOpportunity
*
 * Modified By   : Sean Fielding (GearsCRM)
* Modified Date :
 * Description   : moved a bunch of the old triggers into this template and fixed the bulkified/performance issues
*
 * Modified By  : Marc Gartner (GearsCRM)
* Modified Date: 4/2/2014
* Description  : added Program Description and Application Signer/Billing Contact update logic

* Modified By  : Phillip Southern (GearsCRM)
* Modified Date: 11/12/2014
* Description  : default campaign and program lookups by userid then profileid
*
 * ************************************************************/
public class UOpportunity {

    public static Set<Id> programAccountProcessedIds = new Set<Id> ();
    public static Set<Id> programAccountInsertIds = new Set<Id> ();

    // trigger EchoTrigger on Opportunity (before update, after update) {
    // just the after update piece


    public static void echoAfter (List <Opportunity> records, Map <id, Opportunity> oldMap)
    {
        if (EchoHelper.hasAlreadyCreatedFollowUpTasks() == true)
        {
            return;
        }

        set <id> excludeRecordTypeIds = new set <id>();

        for(echoRecordTypeIds__c r : echoRecordTypeIds__c.getall().values())
        {
            excludeRecordTypeIds.add(r.record_type_id__c);
        }

        List<Application_Request__c> appRequest = new List<Application_Request__c>();

        for (Opportunity o : records)

        /*[select id, accountId, ownerId, requested_credit_limit__c, years_in_business__c, legal_structure__c,
                                     application_signer__c, billing_contact__c, Physical_Street__c, Physical_city__c, Physical_State__c,
                                     Physical_Zip_Postal_Code__c, Physical_country__c, Billing_street__c, Billing_City__c,
                                     Billing_state__c, Billing_zip_postal_code__c, Billing_Country__c, sourcesystem__c, recordTypeId
                              from opportunity
                              where id in :records])*/
        {
            if(o.SourceSystem__c == 'Echosigned'
                    && o.SourceSystem__c != oldMap.get(o.id).SourceSystem__c
                    && !excludeRecordTypeIds.contains(o.recordTypeId))
            {
                system.debug('$$$$$$$$$$ echo After o.Application_Signer__c = ' + o.Application_Signer__c);

                Application_Request__c arq = new Application_Request__c();
                arq.Account_Name__c = o.AccountId;
                arq.Opportunity__c = o.Id;
                arq.Sales_Person__c = o.ownerId;
                arq.Forward_Application_to_Credit__c = 'Yes';
                arq.App_Submitted_Date__c = system.today();
                arq.Requested_Credit_Limit__c = o.Requested_Credit_Limit__c;
                arq.Years_In_Business__c = o.Years_In_Business__c;
                arq.Legal_Structure__c = o.Legal_Structure__c;
                arq.Source_System_Text__c = 'Salesforce';
                arq.App_Signer__c = o.Application_Signer__c;
                arq.Billing_Contact__c = o.Billing_Contact__c;
                arq.Physical_Street__c = o.Physical_Street__c;
                arq.Physical_city__c = o.Physical_city__c;
                arq.Physical_State__c = o.Physical_State__c==null?'':o.Physical_State__c.toUpperCase();
                arq.Physical_Zip_Postal_Code__c = o.Physical_Zip_Postal_Code__c;
                arq.Physical_country__c = o.Physical_country__c;
                arq.Billing_Street__c = o.Billing_street__c;
                arq.Billing_City__c = o.Billing_City__c;
                arq.Billing_State__c = o.Billing_state__c==null?'':o.billing_state__c.toUpperCase();
                arq.Billing_Zip_Postal_Code__c = o.Billing_zip_postal_code__c;
                arq.Billing_Country__c = o.Billing_Country__c;
                arq.Created_by_Echosign__c = true;

                system.debug('-----arq = ' + arq);

                appRequest.add(arq);
            }
        }

        //try
        //{

        if(appRequest.size() > 0)
        {
            EchoHelper.setAlreadyCreatedFollowUpTasks();
            insert appRequest;
        }
        //}
        //catch(Exception ex)
        //{
        //   System.debug('ERROR ADDING THE APP REQUEST: ' + ex.getStackTraceString() );
        //}
    }

    // trigger EchoTrigger on Opportunity (before update, after update) {
    // just the before update piece
    // brining over the functionality as is just fixing the performance issues
    public static void echoBefore (List <Opportunity> records, Map <id, Opportunity> oldMap)
    {
        system.debug('-----echoBefore-----');


        //List <Contact> contactsToCreate = new List <Contact>();
        Map<String,Contact> contactsToCreate = new Map<String,Contact>();


        set <id> excludeRecordTypeIds = new set <id>();

        for(echoRecordTypeIds__c r : echoRecordTypeIds__c.getall().values())
        {
            excludeRecordTypeIds.add(r.record_type_id__c);
        }

        set <string> contactEmails = new set <string>();
        set<Id> accountIds = new set<Id>();
        for(Opportunity o : records)
        {
            if(o.SourceSystem__c == 'Echosign' && !excludeRecordTypeIds.contains(o.recordTypeId))
            {
                system.debug('-----' + o.SourceSystem__c);

                if(o.AccountId == null) continue;

                if(o.es_Billing_Contact_Email__c != null)
                {
                    system.debug('-----has o.es_Billing_Contact_Email__c');
                    contactEmails.add(o.es_Billing_Contact_Email__c);
                    accountIds.add(o.AccountId);
                }
                if(o.Application_Signer_Email_Address__c != null)
                {
                    system.debug('-----has o.Application_Signer_Email_Address__c');
                    contactEmails.add(o.Application_Signer_Email_Address__c);
                    accountIds.add(o.AccountId);
                }
            }
        }

        Map <string, Contact> existingContactMap = new Map <string, Contact>();

        /*
        for(Contact c : [select id, email from Contact where email in :contactEmails])
        {
            existingContactMap.put(c.email, c);
        }
        */
        /*
        for(Contact c : [Select Id, Email, LastName, FirstName, Phone, MailingStreet, MailingCity,
                            MailingState, MailingCountry, MailingPostalCode, AccountId,
                            created_from_echo_opportunity__c, Title
                             from Contact Where Email IN :contactEmails])
        {
            */
        for(Contact c : [Select Id, Email, LastName, FirstName, AccountId
        from Contact Where Email IN :contactEmails AND AccountId IN :accountIds])
        {
            if(c.FirstName != null && c.FirstName.length()>2 && c.LastName != null)
            {
                existingContactMap.put(c.AccountId+'-'+c.FirstName.substring(0,3).tolowercase()+'-'+c.LastName.tolowercase()+'-'+c.email.tolowercase(),c);
            }
        }

        system.debug('--echobefore contactmap: ' + existingContactMap);

        for(Opportunity o : records)
        {

            /*
            system.debug('-----Existing Billing Contact ' + existingContactMap.containsKey(o.es_Billing_Contact_Email__c));
            system.debug('-----Existing App Signer Contact ' + existingContactMap.containsKey(o.Application_Signer_Email_Address__c));
            */

            system.debug('-----SourceSystem ' + o.SourceSystem__c);

            // the existing code is getting around this being called twice by resetting the sourceSystem
            /* existing commented out
            if(o.SourceSystem__c == 'Echosign' && !excludeRecordTypeIds.contains(o.recordTypeId)
                && !existingContactMap.containsKey(o.es_Billing_Contact_Email__c))

            {
                system.debug('------creating a billing contact');

                Contact billingContact = new Contact();
                billingContact.AccountId = o.AccountId;
                billingContact.FirstName = o.es_Billing_Contact_First_Name__c;
                billingContact.LastName = o.es_Billing_Contact_Last_Name__c;
                billingContact.Email = o.es_Billing_Contact_Email__c;
                billingContact.Phone = o.es_Billing_Contact_Phone__c;
                billingContact.MailingStreet = o.Billing_Street__c;
                billingContact.MailingCity = o.Billing_City__c;
                billingContact.MailingState = o.Billing_State__c;
                billingContact.MailingPostalCode = o.Billing_Zip_Postal_Code__c;
                billingContact.MailingCountry = o.Billing_Country__c;
                billingContact.created_from_echo_opportunity__c = o.id+'~Billing';

                contactsToCreate.add(billingContact);
            }
            */

            // New not testing yet. 081714
            system.debug('---firstname: ' + o.es_Billing_Contact_First_Name__c);
            system.debug('---lastname: ' + o.es_Billing_Contact_Last_Name__c);
            system.debug('---email: ' + o.es_Billing_Contact_Email__c);
            if(o.SourceSystem__c == 'Echosign'
                    && !excludeRecordTypeIds.contains(o.recordTypeId)
                    && o.es_Billing_Contact_First_Name__c != null
                    && o.es_Billing_Contact_First_Name__c.length() > 2
                    && o.es_Billing_Contact_Last_Name__c != null
                    && o.es_Billing_Contact_Email__c != null
                    && !existingContactMap.containsKey(o.AccountId +'-'+o.es_Billing_Contact_First_Name__c.substring(0,3).tolowercase()+'-'+o.es_Billing_Contact_Last_Name__c.toLowerCase()+'-'+o.es_Billing_Contact_Email__c.toLowerCase())
                    )

            {
                system.debug('------creating a billing contact');

                Contact billingContact = new Contact();
                billingContact.AccountId = o.AccountId;
                billingContact.FirstName = o.es_Billing_Contact_First_Name__c;
                billingContact.LastName = o.es_Billing_Contact_Last_Name__c;
                billingContact.Email = o.es_Billing_Contact_Email__c;
                billingContact.Phone = o.es_Billing_Contact_Phone__c;
                billingContact.MailingStreet = o.Billing_Street__c;
                billingContact.MailingCity = o.Billing_City__c;
                billingContact.MailingState = o.Billing_State__c;
                billingContact.MailingPostalCode = o.Billing_Zip_Postal_Code__c;
                billingContact.MailingCountry = o.Billing_Country__c;
                billingContact.created_from_echo_opportunity__c = o.id+'~Billing';

                //contactsToCreate.add(billingContact);
                String key = o.AccountId+'-'+o.es_Billing_Contact_First_Name__c.substring(0,3).tolowercase()+'-'+o.es_Billing_Contact_Last_Name__c.toLowerCase()+'-'+o.es_Billing_Contact_Email__c.toLowerCase();
                contactsToCreate.put(key,billingContact);

                system.debug('--echobefore billing key: ' + key);


            }



            /* existing commented out
            if(o.SourceSystem__c == 'Echosign'
               && !excludeRecordTypeIds.contains(o.recordTypeId)
               && o.es_Billing_Contact_Email__c != o.Application_Signer_Email_Address__c
               && !existingContactMap.ContainsKey(o.Application_Signer_Email_Address__c))
            {
                system.debug('------creating a signer contact');

                Contact signerContact = new Contact();
                signerContact.AccountId = o.AccountId;
                signerContact.FirstName = o.Application_Signer_First_Name__c;
                signerContact.LastName = o.Application_Signer_Last_Name__c;
                signerContact.Email = o.Application_Signer_Email_Address__c;
                signerContact.MailingStreet = o.Application_Signer_Address__c;
                signerContact.MailingCity = o.Application_Signer_City__c;
                signerContact.MailingState = o.Application_Signer_State__c;
                signerContact.MailingPostalCode = o.Application_Signer_Zip_Code__c;
                //signerContact.Phone = o.Application_Signer_Phone__c;
                signerContact.Phone = o.Account_Phone_Number__c;
                signerContact.SSN__c = o.Application_Signer_SSN__c;
                signerContact.Birthdate = o.Application_Signer_DOB__c;
                signerContact.created_from_echo_opportunity__c = o.id+'~Signer';

                contactsToCreate.add(signerContact);

            }
            */
            //  New not tested yet 081714
            if(o.SourceSystem__c == 'Echosign'
                    && !excludeRecordTypeIds.contains(o.recordTypeId)
                    && o.es_Billing_Contact_Email__c != o.Application_Signer_Email_Address__c
                    && o.Application_Signer_First_Name__c != null
                    && o.Application_Signer_First_Name__c.length() > 2
                    && o.Application_Signer_Last_Name__c != null
                    && o.Application_Signer_Email_Address__c != null
                    && !existingContactMap.ContainsKey(o.AccountId+'-'+o.Application_Signer_First_Name__c.substring(0,3).toLowerCase()+'-'+o.Application_Signer_Last_Name__c.toLowerCase()+'-'+o.Application_Signer_Email_Address__c.toLowerCase())
                    )
            {
                system.debug('------creating a signer contact');

                Contact signerContact = new Contact();
                signerContact.AccountId = o.AccountId;
                signerContact.FirstName = o.Application_Signer_First_Name__c;
                signerContact.LastName = o.Application_Signer_Last_Name__c;
                signerContact.Email = o.Application_Signer_Email_Address__c;
                signerContact.MailingStreet = o.Application_Signer_Address__c;
                signerContact.MailingCity = o.Application_Signer_City__c;
                signerContact.MailingState = o.Application_Signer_State__c;
                signerContact.MailingPostalCode = o.Application_Signer_Zip_Code__c;
                //signerContact.Phone = o.Application_Signer_Phone__c;
                signerContact.Phone = o.Account_Phone_Number__c;
                signerContact.SSN__c = o.Application_Signer_SSN__c;
                signerContact.Birthdate = o.Application_Signer_DOB__c;
                signerContact.created_from_echo_opportunity__c = o.id+'~Signer';

                //contactsToCreate.add(signerContact);

                String key = o.AccountId+'-'+o.Application_Signer_First_Name__c.substring(0,3).toLowerCase()+'-'+o.Application_Signer_Last_Name__c.toLowerCase()+'-'+o.Application_Signer_Email_Address__c.toLowerCase();
                contactsToCreate.put(key,signerContact);

                system.debug('--echobefore signer key: ' + key);
            }


        }

        system.debug('--echo before contactstocreate: ' + contactstocreate);

        if(contactsToCreate.size() > 0)
        {
            //insert contactsToCreate;
            insert contactsToCreate.values();
        }


        /*
        Map <string, Contact> contactMap = new Map <string, Contact>();

        for(Contact c : contactsToCreate)
        {
            contactMap.put(c.email, c);
        }
        */

        set <string> existingContactRoles = new set <string>();
        for(OpportunityContactRole ocr : [select opportunityId, contactId, role, opportunity.AccountId
        from OpportunityContactRole where opportunityId in :records])
        {
            existingContactRoles.add(ocr.opportunityId + '~' + ocr.contactId + '~' + ocr.role);

            system.debug('------existing contact roles ' + ocr.opportunityId + '~' + ocr.contactId + '~' + ocr.role);

        }

        List <OpportunityContactRole> rolesToCreate = new List <OpportunityContactRole>();

        for(Opportunity o : records)
        {
            system.debug('--variable check: ' + o.SourceSystem__c + ' ' + o.recordtypeid + ' ' + o.Name);

            // the existing code is getting around this being called twice by resetting the sourceSystem
            if(o.SourceSystem__c == 'Echosign' && !excludeRecordTypeIds.contains(o.recordTypeId))
            {


                //check to see if new billing contact, if so create OCR for opportunity.
                if(o.es_Billing_Contact_First_Name__c != null
                        && o.es_Billing_Contact_Last_Name__c != null
                        && o.es_Billing_Contact_Email__c != null
                        && o.es_Billing_Contact_First_Name__c.length() > 2)
                {
                    String billingContactKey = o.AccountId+'-'+o.es_Billing_Contact_First_Name__c.substring(0,3).tolowercase()+'-'+o.es_Billing_Contact_Last_Name__c.toLowerCase()+
                            '-'+o.es_Billing_Contact_Email__c.toLowerCase();

                    if(contactsToCreate.containskey(billingContactKey))
                    //&& !existingContactRoles.contains(o.id + '~' + contactsToCreate.get(billingContactKey).id + '~Billing Contact'))
                    {
                        o.Billing_Contact__c = contactsToCreate.get(billingContactKey).Id;

                        if(!existingContactRoles.contains(o.id + '~' + contactsToCreate.get(billingContactKey).id + '~Billing Contact'))
                        {
                            OpportunityContactRole ocr = new OpportunityContactRole();
                            ocr.ContactId = o.Billing_Contact__c;
                            ocr.OpportunityId = o.Id;
                            ocr.Role = 'Billing Contact';
                            rolesToCreate.add(ocr);
                        }

                    }
                    else if(existingContactMap.containskey(billingContactKey))
                    {

                        o.Billing_Contact__c = existingContactMap.get(billingContactKey).Id;

                        if(!existingContactRoles.contains(o.id + '~' + existingContactMap.get(billingContactKey).id + '~Billing Contact'))
                        {
                            OpportunityContactRole ocr = new OpportunityContactRole();
                            ocr.ContactId = o.Billing_Contact__c;
                            ocr.OpportunityId = o.Id;
                            ocr.Role = 'Billing Contact';
                            rolesToCreate.add(ocr);
                        }
                    }

                }



                /* existing
                if(contactMap.containsKey(o.es_Billing_Contact_Email__c))
                {
                    o.Billing_Contact__c = contactMap.get(o.es_Billing_Contact_Email__c).id;
                    system.debug('-----o.Billing_Contact__c = ' + o.Billing_Contact__c);

                    if(!existingContactRoles.contains(o.id + '~' + contactMap.get(o.es_Billing_Contact_Email__c).id + '~Billing Contact'))
                    {
                        OpportunityContactRole ocr = new OpportunityContactRole();
                        ocr.ContactId = o.Billing_Contact__c;
                        ocr.OpportunityId = o.Id;
                        ocr.Role = 'Billing Contact';
                        rolesToCreate.add(ocr);
                    }
                }
                else if(existingContactMap.containsKey(o.es_Billing_Contact_Email__c))
                {
                    o.Billing_Contact__c = existingContactMap.get(o.es_Billing_Contact_Email__c).id;

                    system.debug('-----o.Billing_Contact__c = ' + o.Billing_Contact__c);

                    if(!existingContactRoles.contains(o.id + '~' + existingContactMap.get(o.es_Billing_Contact_Email__c).id + '~Billing Contact'))
                    {
                        OpportunityContactRole ocr = new OpportunityContactRole();
                        ocr.ContactId = o.Billing_Contact__c;
                        ocr.OpportunityId = o.Id;
                        ocr.Role = 'Billing Contact';
                        rolesToCreate.add(ocr);
                    }
                }
                */


                //Same process, go through signer contact info.
                if(o.Application_Signer_Last_Name__c!=null
                        && o.Application_Signer_First_Name__c!=null
                        && o.Application_Signer_Email_Address__c!=null
                        && o.Application_Signer_First_Name__c.length() > 2)
                {
                    String signerContactKey = o.AccountId+'-'+o.Application_Signer_First_Name__c.substring(0,3).toLowerCase()+'-'+o.Application_Signer_Last_Name__c.toLowerCase()+
                            '-'+o.Application_Signer_Email_Address__c.toLowerCase();

                    if(contactsToCreate.containskey(signerContactKey))
                    //&& !existingContactRoles.contains(o.id + '~' + contactsToCreate.get(signerContactKey).id + '~App Signer'))
                    {
                        o.Application_Signer__c = contactsToCreate.get(signerContactKey).Id;

                        if(!existingContactRoles.contains(o.id + '~' + contactsToCreate.get(signerContactKey).id + '~App Signer'))
                        {
                            OpportunityContactRole ocr = new OpportunityContactRole();
                            ocr.ContactId = o.Application_Signer__c;
                            ocr.OpportunityId = o.Id;
                            ocr.Role = 'App Signer';
                            rolesToCreate.add(ocr);
                        }

                    }
                    else if(existingContactMap.containskey(signerContactKey))
                    {
                        o.Application_Signer__c = existingContactMap.get(signerContactKey).Id;

                        if(!existingContactRoles.contains(o.id + '~' + existingContactMap.get(signerContactKey).id + '~App Signer'))
                        {
                            OpportunityContactRole ocr = new OpportunityContactRole();
                            ocr.ContactId = o.Application_Signer__c;
                            ocr.OpportunityId = o.Id;
                            ocr.Role = 'App Signer';
                            rolesToCreate.add(ocr);
                        }
                    }


                }



                /* existing
                system.debug('------ o.Application_Signer_Email_Address__c  ' + o.Application_Signer_Email_Address__c);



                if(contactMap.containsKey(o.Application_Signer_Email_Address__c))
                {
                    o.Application_Signer__c = contactMap.get(o.Application_Signer_Email_Address__c).id;
                    system.debug('-----o.Application_Signer__c = ' + o.Application_Signer__c);

                    if(!existingContactRoles.contains(o.id + '~' + contactMap.get(o.Application_Signer_Email_Address__c).id + '~App Signer'))
                    {
                        OpportunityContactRole ocr = new OpportunityContactRole();
                        ocr.ContactId = o.Application_Signer__c;
                        ocr.OpportunityId = o.Id;
                        ocr.Role = 'App Signer';
                        rolesToCreate.add(ocr);
                    }
                }
                else if(existingContactMap.containsKey(o.Application_Signer_Email_Address__c))
                {
                    o.Application_Signer__c = existingContactMap.get(o.Application_Signer_Email_Address__c).id;
                    system.debug('-----o.Application_Signer__c = ' + o.Application_Signer__c);

                    if(!existingContactRoles.contains(o.id + '~' + existingContactMap.get(o.Application_Signer_Email_Address__c).id + '~App Signer'))
                    {
                        OpportunityContactRole ocr = new OpportunityContactRole();
                        ocr.ContactId = o.Application_Signer__c;
                        ocr.OpportunityId = o.Id;
                        ocr.Role = 'App Signer';
                        rolesToCreate.add(ocr);
                    }
                }
                */



                if(o.Name != null && o.Name.length()>40)
                {
                    system.debug('--* name check: ' + o.Name + ' ' + o.Name.length());

                    String shortName = o.Name.substring(0,40);
                    o.Name = shortName;

                    system.debug('--* shortname: ' + shortName + ' ' + shortName.length());
                }

                o.SourceSystem__c = 'Echosigned';
                o.StageName = '5) Signed';
                o.closeDate = system.today();

                if(o.Fueling_Expenditure__c != null)
                {
                    system.debug('-----has o.Fueling_Expenditure__c - ' + o.Fueling_Expenditure__c);
                    //String tmpCL = (o.Fueling_Expenditure__c * 3).format();
                    //o.Requested_Credit_Limit__c = tmpCL.remove(',');

                    string temp = o.Fueling_Expenditure__c;
                    if(temp.indexOf('.') > 0)
                    {
                        temp = temp.substring(0,o.Fueling_Expenditure__c.indexOf('.'));
                    }

                    o.Requested_Credit_Limit__c = string.valueOf(double.valueOf(temp.replaceAll('[^\\d]', '' )) * 3.0);
                }

            }

            //if(o.SourceSystem__c == 'Echosign' && o.Name != null && o.Name.length()>40)
            //{
            //String shortName = o.Name.substring(0,39);
            //o.Name = shortName;
            //}
        }

        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        Map<String, String> campaignMap = new Map<String, String>();
        List<String> campaigns = new List<String>();
        List<String> campaignIds = new List<String>();

        for (Opportunity o : records)
        {
            if (o.App_Program_Name__c != null && o.SourceSystem__c == 'Echosigned' && o.App_Program_Name__c != o.Program_Name__c)
            {
                opportunitiesToUpdate.add(o);
                campaigns.add(o.App_Program_Name__c);
                campaignIds.add(o.CampaignId);
            }
        }

        if (!opportunitiesToUpdate.isEmpty())
        {
            List<Campaign_Program__c> campaignsList = [SELECT Id, Name FROM Campaign_Program__c WHERE Name in : campaigns AND Campaign__r.Id in : campaignIds];

            for (Campaign_Program__c cp : campaignsList)
            {
                campaignMap.put(cp.Name, cp.Id);
            }

            if (!campaignMap.isEmpty())
            {
                for (Opportunity o : opportunitiesToUpdate)
                {
                    System.debug('campaign program id: ' + campaignMap.get(o.App_Program_Name__c));
                    System.debug('campaign program names: ' + campaignMap.keySet());
                    o.Campaign_Program__c = campaignMap.get(o.App_Program_Name__c);
                }
            }
        }

        if(rolesToCreate.size() > 0)
        {
            insert rolesToCreate;
        }
    }


    //replace StageId Trigger
    public static void getStageId (List <Opportunity> records, Map <id, Opportunity> oldMap)
    {

        boolean isInsert = (oldMap == null);
        Map <string, OpportunityStage> stageMap = new Map <string, OpportunityStage>();
        set <string> stageNames = new set <string>();

        for(Opportunity o : records)
        {
            if(o.stageName != null
                    && (isInsert == true || (isInsert == false && o.stageName != oldMap.get(o.id).stageName)))
            {
                stageNames.add(o.stageName.toLowerCase());
            }
        }

        if(stageNames.size() == 0)
        {
            return;
        }

        for(OpportunityStage os : [SELECT Id, Masterlabel FROM OpportunityStage WHERE Masterlabel in :stageNames])
        {
            stageMap.put(os.Masterlabel.toLowerCase(), os);
        }


        for(Opportunity o : records)
        {
            if(o.stageName != null
                    && (isInsert == true || (isInsert == false && o.stageName != oldMap.get(o.id).stageName))
                    && stageMap.containsKey(o.stageName.toLowerCase()))
            {
                o.Sales_Stage_Id__c = stageMap.get(o.stageName.toLowerCase()).id;
            }
        }
    }

    // replace the ContactRoleButtonPassTrigger code which was not bulkified.
    public static void setContactRoles (List <Opportunity> records)
    {
        for(Opportunity o : [Select id, Application_Signer__c, Billing_Contact__c,
        (Select ContactId, Role, IsPrimary
        From OpportunityContactRoles
        order by isPrimary desc, createdDate)
        From Opportunity
        where id in :records])
        {
            id applicationSigner = null;
            id billingContact = null;

            for(OpportunityContactRole ocr : o.OpportunityContactRoles)
            {
                if(applicationSigner == null && ocr.role == 'App Signer')
                {
                    applicationSigner = ocr.id;
                }

                if(billingContact == null && ocr.role == 'Billing Contact')
                {
                    billingContact = ocr.id;
                }
            }

            if(o.Application_Signer__c != applicationSigner || o.Billing_Contact__c != billingContact)
            {
                o.Application_Signer__c = applicationSigner;
                o.Billing_Contact__c = billingContact;
            }
        }
    }

    public static void createCommission (List <Opportunity> records, Map <id, Opportunity> oldMap)
    {
        boolean isInsert = (oldMap == null);

        Set<Id> oppForCommIds = new Set<Id>();
        for(OppRecordTypeForComm__c ortc : OppRecordTypeForComm__c.getall().values())
        {
            oppForCommIds.add(ID.valueof(ortc.recordtypeid__c));
        }

        if(oppForCommIds.size() == 0)
        {
            return;
        }

        List <Opportunity> oppsOfInterest = new List <Opportunity>();

        for(Opportunity o : records)
        {
            if(oppForCommIds.contains(o.recordTypeId)
                    && ((isInsert == true)
                    || (isInsert == false && o.ownerId != oldMap.get(o.id).ownerId)
                    || (isInsert == false && o.recordTypeId != oldMap.get(o.id).recordTypeId && !oppForCommIds.contains(oldMap.get(o.id).recordTypeId))))
            {

                oppsOfInterest.add(o);
            }
        }

        if(oppsOfInterest.size() == 0)
        {
            return;
        }

        Set<Id> existingComms = new Set<Id>();
        for(Commission__c c : [Select Id, Name, Opportunity__c from Commission__c Where Opportunity__c != null and Opportunity__c in :oppsOfInterest])
        {
            existingComms.add(c.Opportunity__c);
        }

        List <Commission__c> commissionsToCreate = new List <Commission__c>();

        for(Opportunity o : [select id, ownerId, owner.UserType, owner.ManagerId from Opportunity where id in :oppsOfInterest])
        {
            if(!(isInsert==false && existingComms.contains(o.id) && o.ownerId == oldMap.get(o.Id).ownerId && !(oppForCommIds.contains(oldMap.get(o.id).recordTypeId))))
            {
                if(o.owner.UserType != 'Guest')
                {
                    Commission__c commission = new Commission__c();
                    commission.Opportunity__c = o.Id;
                    commission.Sales_Rep__c = o.ownerId;
                    commission.OwnerId = o.OwnerId;
                    commission.Manager__c = o.owner.ManagerId;
                    commissionsToCreate.add(commission);
                }
            }
        }

        if(commissionsToCreate.size() > 0)
        {
            insert commissionsToCreate;
        }
    }


    public static void findCampaignByCouponCode(List <Opportunity> opps)
    {

        Map<string,string> couponcodesbyprofileid = new Map<String,String>();
        Map<String, String> couponcodesbyuserid = new Map<String,String>();
        Set<String> couponcodes = new Set<String>();

        for(Default_Campaigns__c dc : Default_Campaigns__c.getall().values())
        {
            if(dc.ProfileID__c != null && dc.Coupon_Code__c!=null)
            {
                couponcodesbyprofileid.put(dc.profileid__c,dc.Coupon_Code__c.touppercase());
            }
            if(dc.UserId__c!=null && dc.Coupon_Code__c!=null)
            {
                couponcodesbyuserid.put(dc.userid__c,dc.Coupon_Code__c);
                couponcodes.add(dc.Coupon_Code__c);
            }
        }
        //Map<String,Id> campaignsbycouponcode = new Map<String,Id>();
        Map<String,Campaign> campaignsbycouponcode = new Map<String,Campaign>();

        for(Campaign c: [Select Id, Coupon_code__c, Default_Campaign_Program__c
        from Campaign
        Where Coupon_Code__c IN :couponcodesbyprofileid.values()
        OR Coupon_Code__c IN :couponcodesbyuserid.values()]) //:couponcodes])
        {
            //campaignsbycouponcode.put(c.coupon_code__c,c.Id);
            campaignsbycouponcode.put(c.coupon_code__c,c);
        }

        //system.debug('++ userinfo profileid: ' + UserInfo.getProfileId());

        if(campaignsbycouponcode.isempty()== true
                ||
                (!(couponcodesbyprofileid.containskey(UserInfo.getprofileid())) && !(couponcodesbyuserid.containskey(UserInfo.getUserId())))
                )
        {
            //system.debug('++ exit findcampaignbycouponcode');
            return;
        }

        //system.debug('++ cs value: ' + couponcodesbyprofileid.get(Userinfo.getprofileid()));
        //system.debug('++ campaign value: ' + campaignsbycouponcode.get(couponcodesbyprofileid.get(Userinfo.getprofileid())));



        for(Opportunity o : opps)
        {
            if(o.CampaignId == null)
            {
                if(couponcodesbyuserid.containskey(UserInfo.getUserId()))
                {
                    o.CampaignId = campaignsbycouponcode.get(couponcodesbyuserid.get(Userinfo.getUserId())).Id;
                    o.Campaign_Program__c = campaignsbycouponcode.get(couponcodesbyuserid.get(Userinfo.getUserId())).Default_Campaign_Program__c;
                }
                else if(couponCodesByProfileId.containskey(UserInfo.getprofileid()))
                {

                    o.CampaignId = campaignsbycouponcode.get(couponcodesbyprofileid.get(Userinfo.getprofileid())).Id;
                    o.Campaign_Program__c = campaignsbycouponcode.get(couponcodesbyprofileid.get(UserInfo.getProfileId())).Default_Campaign_Program__c;

                }
            }
        }


    }


    public static void communityUserStampData(List<Opportunity> records)
    {
        String userId = UserInfo.getUserId();
        List<User> userRecord = [Select id, UserType, AccountId, ContactId, Profile.UserLicense.Name from User where id=:userId LIMIT 1];

        if (userRecord.size() == 0 || userRecord == null || !UGears.UUser.isPartnerCommunityUser(userRecord[0])) return;
        if (userRecord[0].contactId == null || userRecord[0].accountid == null) return;


        for(Opportunity o : records)
        {
            o.External_Referred_By_Account_Name__c = userRecord[0].AccountId;
            o.External_Referred_By__c = userRecord[0].ContactId;
        }

    }

    public static void createTasks(List<Opportunity> records, Map <id, Opportunity> oldMap)
    {
        //system.debug('______#######createTasks_____');
        boolean isInsert = (oldMap == null);
        list<Task> lstTask = new list<Task>();
        map<string,SetUpAccountSettings__mdt> AccountSettingsCMDTMap  = new map<string,SetUpAccountSettings__mdt>();

        for(SetUpAccountSettings__mdt setUpAcct : [select
                id,Developername,AssignedTo__c,Activity_Type__c,
                Comments__c,CouponCode__c,Error_Log__c,
                Outbound_Message__c,Priority__c,
                RelativeDueDate__c,Status__c,Subject__c,Type__c
        from SetUpAccountSettings__mdt])
        {
            AccountSettingsCMDTMap.put(setUpAcct.Developername,setUpAcct);
        }

        if(records.size() == 0)  { return;}

        if(AccountSettingsCMDTMap.size() > 0)
        {
            for(Opportunity o : records)
            {
                if ( String.isNotBlank( o.Coupon_code2__c ) && String.isNotBlank( o.Error_Log__c ) )
                {
                    SetUpAccountSettings__mdt cmdt = AccountSettingsCMDTMap.get( o.Coupon_code2__c );

                    if(cmdt != null)
                    {
                        Boolean couponCodeChanged = false;
                        Boolean errorLogChanged = false;
                        Boolean errorLogStartsWithCMDT = o.Error_Log__c.startsWith( cmdt.Error_Log__c );

                        if (oldMap != null)
                        {
                            Opportunity oldOppty = oldMap.get(o.id);
                            couponCodeChanged = ( oldOppty.Coupon_code2__c != o.Coupon_code2__c );
                            errorLogChanged = ( oldOppty.Error_Log__c != o.Error_Log__c );
                        }

                        if ( errorLogStartsWithCMDT && ( isInsert || ( couponCodeChanged || errorLogChanged ) ) )
                        {
                            Task t = new Task();
                            t.whatId = o.id;
                            if(cmdt.AssignedTo__c != null)
                                t.OwnerId = cmdt.AssignedTo__c;
                            if(cmdt.Subject__c != null)
                                t.Subject = cmdt.Subject__c;
                            if(cmdt.RelativeDueDate__c != null && cmdt.RelativeDueDate__c == 'Today')
                                t.ActivityDate = System.today();
                            if(cmdt.Type__c != null)
                                t.Type = cmdt.Type__c;
                            if(cmdt.Comments__c != null)
                                t.Description = string.valueOf(cmdt.Comments__c);
                            if(cmdt.Status__c != null)
                                t.Status = cmdt.Status__c;
                            if(cmdt.Priority__c != null)
                                t.Priority = cmdt.Priority__c;
                            if(cmdt.Activity_type__c != null)
                                t.Activity_type__c = cmdt.Activity_type__c;
                            lstTask.add(t);
                        }
                    }
                }
            }
        }

        if(lstTask.size() > 0)
        {
            insert lstTask;

            Set<ID> taskIds = new Set<ID>();

            for(Task tsk : lstTask)
            {
                taskIds.add(tsk.id);
            }

            if(taskIds.size() > 0)
            {
                createTaskOutbound(taskIds);
            }
        }
    }

    @future (callout = true)
    public static void createTaskOutbound(set<id> taskIds)
    {
        //system.debug('______#####createTaskOutbound___');
        list<string> endpointURL = new list<string>();

        for(SetUpAccountSettings__mdt setUpAcct : [select id,Endpoint_URL__c from SetUpAccountSettings__mdt WHERE Endpoint_URL__c != null LIMIT 1])
        {
            endpointURL.add(setUpAcct.Endpoint_URL__c);
        }

        Http http = new Http();
        HttpRequest request = new HttpRequest();

        if(endPointURL != null && endPointURL.size() > 0)
            request.setEndpoint(endpointURL[0]);
        request.setMethod('POST');

        request.setHeader('Accept', 'application/xml');
        request.setBody(UOpportunity.prepareTaskBody(taskIds));

        HttpResponse response = http.send(request);
        system.debug('Response-->'+response.getBody());
    }

    public static string prepareTaskBody(set<id> taskIds)
    {
        string message =    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"  ' +
                'xmlns:out="http://soap.sforce.com/2005/09/outbound"  ' +
                'xmlns:urn="urn:sobject.enterprise.soap.sforce.com">\n' +
                '<soapenv:Header/>\n' +
                '<soapenv:Body>\n' +
                '<out:notifications>\n' +
                '<!--1 to 100 repetitions:-->\n';


        if(taskIds != null && !taskIds.isEmpty())
        {
            for(Task t : [select id,ActivityDate,OwnerId,Priority,Siebel_LOGIN__c,Status,Subject,Type,WhatId,Activity_Type__c,Opportunity_ID__c,Description
            from Task where id in :taskIds])
            {
                message +=
                        '<out:Notification>\n' +
                                '<out:sObject>\n' +
                                '<urn:Id>' + t.Id + '</urn:Id>\n' +
                                '<urn:ActivityDate>' +  t.ActivityDate + '</urn:ActivityDate>\n' +
                                '<urn:Activity_Type__c>' +  t.Activity_Type__c + '</urn:Activity_Type__c>\n' +
                                '<urn:Comments__c>' +  t.Description + '</urn:Comments__c>\n' +
                                '<urn:Description>' + '' + '</urn:Description>\n' +
                                '<urn:Opportunity_ID__c>' +  t.Opportunity_ID__c+ '</urn:Opportunity_ID__c>\n' +
                                '<urn:OwnerId>' +  t.OwnerId+ '</urn:OwnerId>\n' +
                                '<urn:Priority>' +  t.Priority + '</urn:Priority>\n' +
                                '<urn:Siebel_LOGIN__c>' +  t.Siebel_LOGIN__c+ '</urn:Siebel_LOGIN__c>\n' +
                                '<urn:Status>' +  t.Status+ '</urn:Status>\n' +
                                '<urn:Subject>' +  t.Subject+ '</urn:Subject>\n' +
                                '<urn:Type>' +  t.Type+ '</urn:Type>\n' +
                                '<urn:WhatId>' +  t.WhatId + '</urn:WhatId>\n' +
                                '</out:sObject>\n' +
                                '</out:Notification>\n';
            }
        }

        message += '</out:notifications>\n' +
                '</soapenv:Body>\n' +
                '</soapenv:Envelope>';
        //system.debug('_____message____' + message);
        return message;
    }

    public static void checkProgramAccount (List<Opportunity> records, Map <Id, Opportunity> oldMap)
    {
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        for (Opportunity opp : records) {
            if (!programAccountProcessedIds.contains(opp.Id) &&
                    (programAccountInsertIds.contains(opp.Id) ||
                            (oldMap!=null && opp.Campaign_Program__c!=null && opp.Campaign_Program__c != oldMap.get(opp.Id).Campaign_Program__c
                                    && opp.AccountId == oldMap.get(opp.Id).AccountId))) {
                oppMap.put(opp.Id, opp);
                programAccountProcessedIds.add(opp.Id);
            }
        }

        if (!oppMap.isEmpty()) {
            Id acctRecTypeId = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('CPS_Accounts').getRecordTypeId();
            Map<Id, Opportunity> qualifiedOppMap = new Map<Id, Opportunity>();
            Map<Id, Id> existingAccMap = new Map<Id, Id>();
            Map<Id, String> existingAccNames = new Map<Id, String>();
            Map<Id, Id> existingParentAccMap = new Map<Id, Id>();
            Set<Id> cmpPrgIds = new Set<Id>();
            for (Opportunity opp: [SELECT Id, AccountId, Account.Name, Account.ParentId FROM Opportunity WHERE Id IN : oppMap.keySet()
            AND Account.RecordTypeId = :acctRecTypeId
            AND Account.Is_Program_Account__c = true
            AND Account.ParentId != null]) {
                qualifiedOppMap.put(opp.Id, oppMap.get(opp.Id));
                existingAccMap.put(opp.Id, opp.AccountId);
                existingAccNames.put(opp.Id, opp.Account.Name);
                existingParentAccMap.put(opp.Id, opp.Account.ParentId);
                cmpPrgIds.add(oppMap.get(opp.Id).Campaign_Program__c);
            }

            if (!qualifiedOppMap.isEmpty()) {
                Map<Id, Id> cmpPrgMap = new Map<Id, Id>();
                Map<Id, Campaign_Program__c> campaignPrograms = new Map<Id, Campaign_Program__c>([SELECT Id, Program__c, Program__r.Partner__c FROM Campaign_Program__c WHERE Id IN : cmpPrgIds]);
                for (Campaign_Program__c cmp : campaignPrograms.values()) {
                    cmpPrgMap.put(cmp.Id, cmp.Program__c);
                }

                Map<String, Id> programAccMap = new Map<String, Id>();
                Map<Id, Id> singleChildAcctMap1 = new Map<Id, Id>();
                Map<Id, Id> singleChildAcctMap2 = new Map<Id, Id>();
                for (Account acc : [SELECT Id, ParentId, Program__c FROM Account WHERE //Program__c IN : cmpPrgMap.values()
                RecordTypeId = :acctRecTypeId
                AND Is_Program_Account__c = true
                AND ParentId IN : existingParentAccMap.values()]) {
                    programAccMap.put(acc.ParentId + '$' + acc.Program__c, acc.Id);
                    if (singleChildAcctMap1.get(acc.ParentId)==null) {
                        singleChildAcctMap1.put(acc.ParentId, acc.Id);
                        singleChildAcctMap2.put(acc.ParentId, acc.Id);
                    } else if (singleChildAcctMap2.containsKey(acc.ParentId)) {
                        singleChildAcctMap2.remove(acc.ParentId);
                    }
                }

                Map<Id, Id> newAccMap = new Map<Id, Id>();
                Map<Id, Account> oppNewAccMap = new Map<Id, Account>();
                Map<Id, Account> oppSingleAccMap = new Map<Id, Account>();
                for (Opportunity opp : qualifiedOppMap.values()) {
                    Id parentAccId = existingParentAccMap.get(opp.Id);
                    Id pgm = cmpPrgMap.get(opp.Campaign_Program__c);
                    if (programAccMap.get(parentAccId + '$' + pgm)!=null) {  //found existing program account
                        opp.AccountId = programAccMap.get(parentAccId + '$' + pgm);  //move opportunities to existing accounts
                        newAccMap.put(opp.Id,  opp.AccountId);
                    } else if (singleChildAcctMap2.containsKey(parentAccId)) {
                        Account acc = new Account(Id = singleChildAcctMap2.get(parentAccId));
                        acc.Program__c = pgm;
                        acc.Partner_Name__c = campaignPrograms.get(opp.Campaign_Program__c).Program__r.Partner__c;
                        oppSingleAccMap.put(opp.Id, acc);
                        existingAccMap.remove(opp.Id);
                        qualifiedOppMap.remove(opp.Id);
                    } else {  //create new program account
                        Account acc = new Account();
                        acc.Name = existingAccNames.get(opp.Id);
                        acc.RecordTypeId = acctRecTypeId;
                        acc.Is_Program_Account__c = true;
                        acc.Program__c = pgm;
                        acc.Partner_Name__c = campaignPrograms.get(opp.Campaign_Program__c).Program__r.Partner__c;
                        acc.ParentId = parentAccId;
                        oppNewAccMap.put(opp.Id, acc);
                    }
                }

                insert oppNewAccMap.values();
                update oppSingleAccMap.values();

                for (Opportunity opp : qualifiedOppMap.values()) { //move opportunities to newly created accounts
                    if (oppNewAccMap.get(opp.Id)!=null) {
                        opp.AccountId = oppNewAccMap.get(opp.Id).Id;
                        newAccMap.put(opp.Id,  opp.AccountId);
                    }
                }

                //clone contacts from old program accounts to new program accounts if they don't already exist
                Map<Id, List<Contact>> existingAccContactMap = new Map<Id, List<Contact>>();
                Map<Id, List<Contact>> newAccContactMap = new Map<Id, List<Contact>>();
                List<Id> existingAccIds = existingAccMap.values();
                List<Id> newAccIds = newAccMap.values();

                List<String> contactFields = new List<String>();
                List<FieldSetMember> fieldsToClone = SObjectType.Contact.fieldSets.Opportunity_Program_Account_Clone_Fields.getFields();
                for (FieldSetMember field : fieldsToClone) {
                    contactFields.add(field.getFieldPath());
                }
                String contactsQuery = 'SELECT ' + contactFields.get(0);
                for (Integer i=1; i < contactFields.size(); i++) {
                    contactsQuery += ', ' + contactFields.get(i);
                }
                contactsQuery += ' FROM Contact WHERE AccountId IN : existingAccIds OR AccountId IN : newAccIds';

                for (Contact ct : Database.query(contactsQuery)) {
                    if (existingAccIds.contains(ct.AccountId)) {
                        if (existingAccContactMap.get(ct.AccountId)!=null) {
                            List<Contact> ctList = existingAccContactMap.get(ct.AccountId);
                            ctList.add(ct);
                            existingAccContactMap.put(ct.AccountId, ctList);
                        } else {
                            existingAccContactMap.put(ct.AccountId,  new List<Contact>{ct});
                        }
                    } else {
                        if (newAccContactMap.get(ct.AccountId)!=null) {
                            List<Contact> ctList = newAccContactMap.get(ct.AccountId);
                            ctList.add(ct);
                            newAccContactMap.put(ct.AccountId, ctList);
                        } else {
                            newAccContactMap.put(ct.AccountId,  new List<Contact>{ct});
                        }
                    }
                }

                List<Contact> cloneContacts = new List<Contact>();
                Map<Id, Id> cloneContactAcctMap = new Map<Id, Id>();
                for (Opportunity opp : qualifiedOppMap.values()) {
                    Id existingAccId = existingAccMap.get(opp.Id);
                    Id newAccId = newAccMap.get(opp.Id);
                    List<Contact> existingCtList = existingAccContactMap.get(existingAccId);
                    List<Contact> newCtList = newAccContactMap.get(newAccId);
                    Set<String> nameEmails = new Set<String>();
                    if (newCtList!=null) {
                        for (Contact ct : newCtList) {
                            nameEmails.add(ct.FirstName + '$' + ct.LastName + '$' + ct.Email);
                        }
                    }
                    if (existingCtList!=null) {
                        for (Contact ct : existingCtList) {
                            if (!nameEmails.contains(ct.FirstName + '$' + ct.LastName + '$' + ct.Email)) {
                                cloneContacts.add(ct);
                                cloneContactAcctMap.put(existingAccId, newAccId);
                            }
                        }
                    }
                }

                if (!cloneContacts.isEmpty()) {
                    List<Contact> clonedCtList = cloneContacts.deepClone();
                    for (Contact ct : clonedCtList) {
                        ct.AccountId = cloneContactAcctMap.get(ct.AccountId);
                    }

                    insert clonedCtList;
                }
            }
        }
    }

    public static void updateProgramAccount (List<Opportunity> records, Map <Id, Opportunity> oldMap) {
        boolean isInsert = (oldMap == null);
        Set<Id> oppIds = new Set<Id>();
        for (Opportunity opp : records) {
            if (isInsert && opp.Campaign_Program__c!=null) {
                oppIds.add(opp.Id);
            }
        }

        if (!oppIds.isEmpty()) {
            Id acctRecTypeId = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('CPS_Accounts').getRecordTypeId();
            Map<Id, Account> accMap = new Map<Id, Account>();
            Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();

            for (Opportunity opp: [SELECT Id, AccountId, Account.Program__c, Campaign_Program__r.Program__c FROM Opportunity WHERE Id IN : oppIds
            AND Account.RecordTypeId = :acctRecTypeId
            ]) {
                if (opp.Campaign_Program__r.Program__c!=null) {
                    if (opp.Account.Program__c==null) {
                        Account acc = new Account(Id = opp.AccountId);
                        acc.Program__c = opp.Campaign_Program__r.Program__c;
                        accMap.put(opp.AccountId, acc);
                    } else if (opp.Campaign_Program__r.Program__c != opp.Account.Program__c) {
                        oppMap.put(opp.Id, opp);
                        programAccountInsertIds.add(opp.Id);
                    }
                }
            }

            update accMap.values();
            update oppMap.values(); //trigger checkProgramAccount logic
        }
    }

    public static void executeBREeze(List<Opportunity> records, Map<Id, Opportunity> oldMap) {
        BREeze.processRules.ruleDataSet rds = new BREeze.processRules.ruleDataSet();
        rds.records = records;
        rds.oldMap = oldMap;
        BREeze.ProcessRules.processRuleLogic('MC_Opportunity_Sync_to_Marketing_Cloud', false, rds);
    }
}