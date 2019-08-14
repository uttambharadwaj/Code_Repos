<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Application_request_stage_updated</fullName>
        <description>Application request stage updated</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>jpivo@fleetone.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Application_request_stage_updated</template>
    </alerts>
    <alerts>
        <fullName>Community_Notify_partner_community_user_that_app_submitted_for_referred_lead</fullName>
        <description>Community: Notify partner community user that app submitted for referred lead</description>
        <protected>false</protected>
        <recipients>
            <field>External_Referring_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>WEX_Partner_Community_Templates/Communities_Application_Submitted_for_your_referred_Lead</template>
    </alerts>
    <alerts>
        <fullName>Community_Notify_partner_community_user_that_application_is_approved</fullName>
        <description>Community: Notify partner community user that application is approved</description>
        <protected>false</protected>
        <recipients>
            <field>External_Referring_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>WEX_Partner_Community_Templates/Community_Application_Approved_Notification_to_Partner</template>
    </alerts>
    <alerts>
        <fullName>Community_Notify_partner_community_user_that_application_is_declined</fullName>
        <description>Community: Notify partner community user that application is declined</description>
        <protected>false</protected>
        <recipients>
            <field>External_Referring_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>WEX_Partner_Community_Templates/Community_Application_Declined_Notification_to_Partner</template>
    </alerts>
    <alerts>
        <fullName>Credit_Decision_Updated_Shell_CSM_East</fullName>
        <description>Credit Decision Updated - Shell CSM East</description>
        <protected>false</protected>
        <recipients>
            <recipient>lindsay.brocher@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Application_request_stage_updated</template>
    </alerts>
    <alerts>
        <fullName>Credit_Decision_Updated_Shell_CSM_West</fullName>
        <description>Credit Decision Updated - Shell CSM West</description>
        <protected>false</protected>
        <recipients>
            <recipient>zachariah.saker@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Application_request_stage_updated</template>
    </alerts>
    <alerts>
        <fullName>Credit_Decision_Updated_Shell_Inside_Sales</fullName>
        <description>Credit Decision Updated - Shell Inside Sales</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Application_request_stage_updated</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_Fleet_Sales_that_the_App_had_been_Decisioned</fullName>
        <description>Email Alert to Fleet Sales that the App had been Decisioned</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Sales_Rep_Activity_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>App_Approved_Date</fullName>
        <description>App Aprroved data is updated with todays date when the app is approved</description>
        <field>App_Approved_Date__c</field>
        <formula>NOW()</formula>
        <name>App Approved Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>App_Declined_Date</fullName>
        <description>App Declined Date is updated when sales stage is declined</description>
        <field>App_Declined_Date__c</field>
        <formula>NOW()</formula>
        <name>App Declined Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>App_Submitted_Date_Today</fullName>
        <field>App_Submitted_Date__c</field>
        <formula>Today()</formula>
        <name>App Submitted Date = Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Application_Approved_Date</fullName>
        <description>Update App Approved Date on Oppty</description>
        <field>Application_Approved_Date__c</field>
        <formula>TODAY()</formula>
        <name>Application Approved Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Billing_Contact_Email_Update</fullName>
        <field>Billing_Contact_Email_Workflow__c</field>
        <formula>Billing_Contact_Email__c</formula>
        <name>Billing Contact Email Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_In_Progress_flag</fullName>
        <field>In_Progress__c</field>
        <literalValue>0</literalValue>
        <name>Clear In Progress flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_In_Progress_user</fullName>
        <field>In_Progress_User__c</field>
        <name>Clear In Progress user</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Forward_App_to_Credit</fullName>
        <field>Forward_Application_to_Credit__c</field>
        <literalValue>Yes</literalValue>
        <name>Forward App to Credit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Move_AR_Stage_To_Adjudication</fullName>
        <field>Application_Stage__c</field>
        <literalValue>Adjudication</literalValue>
        <name>Move AR Stage To Adjudication</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Move_AR_To_Pending_Decision</fullName>
        <field>Status__c</field>
        <literalValue>Pending Decision</literalValue>
        <name>Move AR To Pending Decision</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Revolver_Update_App_Request_Record_Type</fullName>
        <description>Update the Application Request type to Revolver Application</description>
        <field>RecordTypeId</field>
        <lookupValue>Revolver_Application</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Revolver Update App Request Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_Opp</fullName>
        <description>Update SF_Opp</description>
        <field>SF_Opp__c</field>
        <formula>Opportunity__r.Opportunity_Number__c</formula>
        <name>SF Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Application_Stage_To_Credit_F_U</fullName>
        <field>Application_Stage__c</field>
        <literalValue>Credit Follow-up</literalValue>
        <name>Set Application Stage To Credit F/U</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Credit_Bureau_Score</fullName>
        <field>Credit_Bureau_Score__c</field>
        <formula>IF(ISPICKVAL(Credit_Bureau_Source__c, &quot;DNB Custom&quot;), TEXT(DNB_Score__c), 
IF(ISPICKVAL(Credit_Bureau_Source__c, &quot;Experian Consumer&quot;), TEXT(PG_FICO_Score__c), 
&quot;&quot; 
) 
)</formula>
        <name>Update Credit Bureau Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Decision_Code_To_Blank</fullName>
        <field>Decision_Date__c</field>
        <name>Update Decision Code To Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>set_In_Progress_user</fullName>
        <field>In_Progress_User__c</field>
        <formula>$User.FirstName+&quot; &quot;+$User.LastName</formula>
        <name>set In Progress user</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Application_Request_Update_to_Siebel</fullName>
        <apiVersion>43.0</apiVersion>
        <endpointUrl>https://wexfleet.wexapi.com/salesforceupdateopportunity</endpointUrl>
        <fields>Approved_Credit_Limit__c</fields>
        <fields>Credit_Bureau_Score__c</fields>
        <fields>Credit_Bureau_Source__c</fields>
        <fields>Credit_Decision__c</fields>
        <fields>DNB_Resolved_DUNS__c</fields>
        <fields>Fraud_Flag__c</fields>
        <fields>Id</fields>
        <fields>Opportunity__c</fields>
        <fields>Risk_Grade__c</fields>
        <fields>SIC_Code__c</fields>
        <fields>Siebel_Oppty__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>salesforce@wrightexpress.com</integrationUser>
        <name>Application Request Update to Siebel</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Application_Request_to_Siebel</fullName>
        <apiVersion>20.0</apiVersion>
        <endpointUrl>https://webservices.wrightexpress.com/gateway/services/WEXSalesForceOBService</endpointUrl>
        <fields>Account_Phone__c</fields>
        <fields>Annual_Gross_Revenue__c</fields>
        <fields>App_Signer_Email__c</fields>
        <fields>App_Signer_IP_Address__c</fields>
        <fields>App_Signer_Last_Name_Text__c</fields>
        <fields>App_Signer_Title__c</fields>
        <fields>Application_Channel__c</fields>
        <fields>Application_Signer_FirstName_Text__c</fields>
        <fields>Application_Signer_Phone__c</fields>
        <fields>BO_Status__c</fields>
        <fields>BO_Verification_Log__c</fields>
        <fields>Billing_City__c</fields>
        <fields>Billing_Contact_Email__c</fields>
        <fields>Billing_Contact_Fax_Number__c</fields>
        <fields>Billing_Contact_First_Name_Text__c</fields>
        <fields>Billing_Contact_Last_Name_Text__c</fields>
        <fields>Billing_Contact_Phone_Number__c</fields>
        <fields>Billing_Contact_Phone__c</fields>
        <fields>Billing_Country__c</fields>
        <fields>Billing_State__c</fields>
        <fields>Billing_Street_Line_2__c</fields>
        <fields>Billing_Street__c</fields>
        <fields>Billing_Zip_Postal_Code__c</fields>
        <fields>Business_Fax__c</fields>
        <fields>Campaign_Program__c</fields>
        <fields>Consumer__c</fields>
        <fields>Corporate_Guarantor__c</fields>
        <fields>Coupon_Code__c</fields>
        <fields>CreatedById</fields>
        <fields>Doing_Business_As__c</fields>
        <fields>Exempt_from_Motor_Fuels_Tax__c</fields>
        <fields>Expected_Monthly_Vehicle_Expense__c</fields>
        <fields>External_Sales_Id__c</fields>
        <fields>Fiscal_Year_Starts__c</fields>
        <fields>Fleet_Contact_Email__c</fields>
        <fields>Fleet_Contact_First_Name__c</fields>
        <fields>Fleet_Contact_Last_Name__c</fields>
        <fields>Fleet_Size__c</fields>
        <fields>Group_Code__c</fields>
        <fields>Guarantor_DOB__c</fields>
        <fields>Guarantor_SSN__c</fields>
        <fields>Guarantor_Type__c</fields>
        <fields>How_did_you_hear_about_this_offer__c</fields>
        <fields>Id</fields>
        <fields>Integration_Error_Message__c</fields>
        <fields>Legal_Structure__c</fields>
        <fields>Merchant_Facility_Number__c</fields>
        <fields>Opportunity_Name_Text__c</fields>
        <fields>Opportunity__c</fields>
        <fields>Paperless_Delivery__c</fields>
        <fields>Partner_Commission_Option__c</fields>
        <fields>Personal_Guarantor_Annual_Income__c</fields>
        <fields>Personal_Guarantor_DOB__c</fields>
        <fields>Personal_Guarantor_Email__c</fields>
        <fields>Personal_Guarantor_First_Name__c</fields>
        <fields>Personal_Guarantor_Home_Phone__c</fields>
        <fields>Personal_Guarantor_Last_Name__c</fields>
        <fields>Personal_Guarantor_Mailing_City__c</fields>
        <fields>Personal_Guarantor_Mailing_Country__c</fields>
        <fields>Personal_Guarantor_Mailing_State__c</fields>
        <fields>Personal_Guarantor_Mailing_Street__c</fields>
        <fields>Personal_Guarantor_Mailing_Zip__c</fields>
        <fields>Personal_Guarantor_Middle_Name__c</fields>
        <fields>Personal_Guarantor_Mobile__c</fields>
        <fields>Personal_Guarantor_Phone__c</fields>
        <fields>Personal_Guarantor_Role__c</fields>
        <fields>Personal_Guarantor_SSN__c</fields>
        <fields>Personal_Guarantor__c</fields>
        <fields>Physical_City__c</fields>
        <fields>Physical_Country__c</fields>
        <fields>Physical_State__c</fields>
        <fields>Physical_Street_Line_2__c</fields>
        <fields>Physical_Street__c</fields>
        <fields>Physical_Zip_Postal_Code__c</fields>
        <fields>Preferred_Language__c</fields>
        <fields>Program_Name__c</fields>
        <fields>Program__c</fields>
        <fields>Requested_Credit_Limit__c</fields>
        <fields>SF_Opp__c</fields>
        <fields>SF_Opportunity_ID__c</fields>
        <fields>Sales_Code__c</fields>
        <fields>Sales_Rep_s_First_Name__c</fields>
        <fields>Sales_Rep_s_Last_Name__c</fields>
        <fields>Siebel_L1_Account_Number__c</fields>
        <fields>Siebel_Login_Id__c</fields>
        <fields>Source_System_Text__c</fields>
        <fields>Tax_Payer_ID_number__c</fields>
        <fields>WEX_Account_Nbr__c</fields>
        <fields>WEX_Program_Account_Nbr__c</fields>
        <fields>Years_In_Business__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>salesforce@wrightexpress.com</integrationUser>
        <name>Application Request to Siebel</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>App Approved Create Activity - Larry Tracey</fullName>
        <actions>
            <name>Application_Approved_Please_Create_Case</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Call_Time_to_Cross_Sell_Larry</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Checkin_Call</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application_Request__c.Sales_Person__c</field>
            <operation>equals</operation>
            <value>Nysia Sanabria,Frank Cerullo,Bob King,Joe Shreffler,Larry Tracey,Paul Gioia,Marcus Alley</value>
        </criteriaItems>
        <criteriaItems>
            <field>Application_Request__c.Credit_Decision__c</field>
            <operation>equals</operation>
            <value>Approved,Approved - Rereview</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>App Approved Create Activity - Will Bailey</fullName>
        <actions>
            <name>Application_Approved_Please_Create_Case2</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Call_TIme_to_Cross_Sell_Will</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Checkin_Call2</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Application_Request__c.Credit_Decision__c</field>
            <operation>equals</operation>
            <value>Approved,Approved - Rereview</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.OwnerId</field>
            <operation>equals</operation>
            <value>Katherine Scott,April Gramley,Toni Clemens,Derek Kavanagh,Quinn McNamara,Geoff Meng</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>App Approved Date</fullName>
        <actions>
            <name>App_Approved_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Application_Approved_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Application_Request__c.Credit_Decision__c</field>
            <operation>equals</operation>
            <value>Approved,Approved - Rereview</value>
        </criteriaItems>
        <description>App Approved Date is updated with todays date when the sales stage is changed to approved</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>App Declined Date</fullName>
        <actions>
            <name>App_Declined_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Application_Request__c.Credit_Decision__c</field>
            <operation>equals</operation>
            <value>Declined,Declined - Rereview</value>
        </criteriaItems>
        <description>App Declined Date is updated when sales stage is declined</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>App Declined%2FIncomplete - IS Sales</fullName>
        <actions>
            <name>AR_Updated</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application_Request__c.Credit_Decision__c</field>
            <operation>equals</operation>
            <value>Declined,Incomplete,Re-Review Declined</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Owner_Role__c</field>
            <operation>equals</operation>
            <value>IS Sales Rep</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>App Declined%2FIncomplete Create Activity - Larry Tracey</fullName>
        <actions>
            <name>Application_Updated_Larry</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application_Request__c.Sales_Person__c</field>
            <operation>equals</operation>
            <value>Nysia Sanabria,April Gramley,Toni Clemens,Derek Kavanagh,Matt Miller,Tyler Bloomfield,Frank Cerullo,Bob King,Irv Margulis,David Plauche,Joe Shreffler,Larry Tracey,Rod Freeman,Paul Gioia,Garrett Montague,Marcus Alley,Alston Quillin</value>
        </criteriaItems>
        <criteriaItems>
            <field>Application_Request__c.Sales_Stage__c</field>
            <operation>contains</operation>
            <value>08 - Re-review,Declined,Incomplete,Non Prospect</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>App Declined%2FIncomplete Create Activity - Will Bailey</fullName>
        <actions>
            <name>Application_Updated</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.OwnerId</field>
            <operation>equals</operation>
            <value>Katherine Scott,April Gramley,Toni Clemens,Derek Kavanagh,Quinn McNamara,Geoff Meng</value>
        </criteriaItems>
        <criteriaItems>
            <field>Application_Request__c.Credit_Decision__c</field>
            <operation>equals</operation>
            <value>Declined,Incomplete,Declined - Rereview</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Application Request Update to Siebel</fullName>
        <actions>
            <name>Application_Request_Update_to_Siebel</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>AND (  Siebel_Oppty__c != null,  TEXT(PRIORVALUE(Credit_Decision__c)) != TEXT(Credit_Decision__c), NOT(ISPICKVAL(Credit_Decision__c, &quot;Incomplete&quot;)), NOT(ISPICKVAL(Credit_Decision__c, &quot;Re-Review&quot;)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Community%3A notfy partner app approved</fullName>
        <actions>
            <name>Community_Notify_partner_community_user_that_application_is_approved</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application_Request__c.Sales_Stage__c</field>
            <operation>contains</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>Notifies partner that the submitted App has been approved</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Community%3A notfy partner app declined</fullName>
        <actions>
            <name>Community_Notify_partner_community_user_that_application_is_declined</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application_Request__c.Sales_Stage__c</field>
            <operation>contains</operation>
            <value>Declined</value>
        </criteriaItems>
        <description>Notifies partner that the submitted App has been declined</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credit Decision Re-review</fullName>
        <actions>
            <name>Set_Application_Stage_To_Credit_F_U</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application_Request__c.Credit_Decision__c</field>
            <operation>equals</operation>
            <value>Re-Review</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Credit Decision Updated - Shell CSM East</fullName>
        <actions>
            <name>Credit_Decision_Updated_Shell_CSM_East</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application_Request__c.Credit_Decision__c</field>
            <operation>equals</operation>
            <value>Approved,Declined,Incomplete,Re-Review,Approved - Rereview,Declined - Rereview</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Owner_Role__c</field>
            <operation>equals</operation>
            <value>Shell RSM Sales Rep East</value>
        </criteriaItems>
        <description>This formula will send an email alert every time the Credit Decision is changed on the application request to the Shell CSM East.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Credit Decision Updated - Shell CSM West</fullName>
        <actions>
            <name>Credit_Decision_Updated_Shell_CSM_West</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application_Request__c.Credit_Decision__c</field>
            <operation>equals</operation>
            <value>Approved,Declined,Incomplete,Re-Review,Approved - Rereview,Declined - Rereview</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Owner_Role__c</field>
            <operation>equals</operation>
            <value>Shell RSM Sales Rep West</value>
        </criteriaItems>
        <description>This formula will send an email alert every time the Credit Decision is changed on the application request to the Shell CSM West.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Credit Decision Updated - Shell Inside Sales</fullName>
        <actions>
            <name>Credit_Decision_Updated_Shell_Inside_Sales</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This formula will send an email alert every time the Credit Decision is changed on the application request to the Shell Inside sales team.</description>
        <formula>AND(
(Opportunity__r.Owner.UserRoleId = &quot;00E0g00000164wk&quot;),
OR(
 (Opportunity__r.Owner.UserRoleId = &quot;00E0g00000164wf&quot;),
OR(
(Opportunity__r.Owner.UserRoleId = &quot;00E0g000001654Z&quot;),
 ISCHANGED( Credit_Decision__c ))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>INTEGRATION - Send Application to Siebel</fullName>
        <actions>
            <name>Application_Request_to_Siebel</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application_Request__c.Forward_Application_to_Credit__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Move Application To Decisioned After Siebel</fullName>
        <actions>
            <name>Application_Request_Update_to_Siebel</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>AND( CASESAFEID($User.Id) == $Setup.BOCA_Settings__c.BOCA_Integration_User_ID__c, Siebel_Oppty__c != null, PRIORVALUE(Siebel_Oppty__c) == null, TEXT(Credit_Decision__c) != null )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Move Application To Re-Review</fullName>
        <actions>
            <name>Update_Decision_Code_To_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Application_Request__c.Credit_Decision__c</field>
            <operation>equals</operation>
            <value>Re-Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Application_Request__c.Credit_Decision__c</field>
            <operation>equals</operation>
            <value>Incomplete</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Move Traditional Apps To Credit</fullName>
        <actions>
            <name>Move_AR_Stage_To_Adjudication</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Move_AR_To_Pending_Decision</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( Application_Channel__c == &apos;Traditional&apos;, ISCHANGED(Forward_Application_to_Credit__c), TEXT(Forward_Application_to_Credit__c) == &apos;Yes&apos;, OR( TEXT(Application_Stage__c) == null, TEXT(Status__c) == null ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Revolver Application Request Type</fullName>
        <actions>
            <name>Revolver_Update_App_Request_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>startsWith</operation>
            <value>Revolver</value>
        </criteriaItems>
        <criteriaItems>
            <field>Application_Request__c.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Revolver Application</value>
        </criteriaItems>
        <description>Check to see if the Application Request needs to be updated to Revolver Application if the Opportunity Record Type is Revolver</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SF Opty update</fullName>
        <actions>
            <name>SF_Opp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application_Request__c.SF_Opp__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>This rule updates the SF Opp# with the Opportunity Number generated in the Opportunity.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Sales Stage Updated</fullName>
        <actions>
            <name>Application_request_stage_updated</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This formula will send an email alert every time the Sales Stage is changed on the application request</description>
        <formula>AND(
(Opportunity__r.Owner.ProfileId = &quot;00e70000000xFzd&quot;),
OR(
 (Opportunity__r.Owner.ProfileId = &quot;00e70000000x2PB&quot;),
 ISCHANGED( Credit_Decision__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Rep E-mail when sales stage is updated - Fleet Sales</fullName>
        <actions>
            <name>Email_Alert_to_Fleet_Sales_that_the_App_had_been_Decisioned</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Application_Request__c.Credit_Decision__c</field>
            <operation>equals</operation>
            <value>,Approved,Declined,Incomplete,Re-Review,Approved - Rereview,Declined - Rereview</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Owner_Role__c</field>
            <operation>equals</operation>
            <value>XOM Regional Sales Manager - South,XOM Regional Sales Manager - North,Marathon Regional Sales Mgr,Circle K RSM,7-11 RSM,Sunoco Client Development Mgr,CP Regional Sales Manager</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Owner_Role__c</field>
            <operation>equals</operation>
            <value>Chevron RSM - East,RaceTrac RSM,Esso Sales,Citgo Sales Rep,Sheetz Regional Sales Manager,Gulf Regional Sales Manager,Speedway RSM</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Owner_Role__c</field>
            <operation>equals</operation>
            <value>Shell FBAM Sales Rep,Chevron RSM - West,Shell RSM Sales Rep East,Shell RSM Sales Rep West</value>
        </criteriaItems>
        <description>This workflow rule will send the sales rep an e-mail that the sales stage has been changed by credit and it needs attention</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Credit Bureau Score</fullName>
        <actions>
            <name>Update_Credit_Bureau_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(   ISCHANGED(Credit_Bureau_Source__c),   OR(     ISPICKVAL(Credit_Bureau_Source__c, &quot;DNB Custom&quot;),     ISPICKVAL(Credit_Bureau_Source__c, &quot;Experian Consumer&quot;)   ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Solicited Activity to WEX Bank</fullName>
        <actions>
            <name>Solicited_Application</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3 AND 5 AND 6 AND 7) OR (1 AND 3 AND 4 AND 5 AND 7) OR (1 AND 3 AND 8)</booleanFilter>
        <criteriaItems>
            <field>Application_Request__c.Siebel_Oppty__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Application_Request__c.Campaign_Type__c</field>
            <operation>equals</operation>
            <value>Call Program,Demo Mailer,Direct Mail,Direct Mail Partner Managed,E-mail blast</value>
        </criteriaItems>
        <criteriaItems>
            <field>Application_Request__c.Source_System_Text__c</field>
            <operation>equals</operation>
            <value>BOCA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Application_Request__c.Sales_Person__c</field>
            <operation>notEqual</operation>
            <value>Salesforce Integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Application_Request__c.Campaign_Program__c</field>
            <operation>equals</operation>
            <value>WEX Small Business</value>
        </criteriaItems>
        <criteriaItems>
            <field>Application_Request__c.Sales_Person__c</field>
            <operation>equals</operation>
            <value>Salesforce Integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Application_Request__c.Sales_Stage__c</field>
            <operation>notEqual</operation>
            <value>,10 - Re-review Approved,13 - Incomplete,07 - Declined,06 - Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Application_Request__c.Coupon_Code__c</field>
            <operation>equals</operation>
            <value>GP6,PF5,QFQ</value>
        </criteriaItems>
        <description>This workflow creates an activity when an app is received by siebel to tell WEX Bank if it was solicited</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>clear In Progress user on Status update</fullName>
        <actions>
            <name>Clear_In_Progress_flag</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_In_Progress_user</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>set In Progress user</fullName>
        <actions>
            <name>set_In_Progress_user</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application_Request__c.In_Progress__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>AR_Updated</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please check the application as the status has changed</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>4-Medium</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Application Updated</subject>
    </tasks>
    <tasks>
        <fullName>Application_Approved_Please_Create_Case</fullName>
        <assignedTo>larry.tracey@wexinc.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Please create a case.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Application_Request__c.App_Approved_Date__c</offsetFromField>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Application Approved - Please Create Case</subject>
    </tasks>
    <tasks>
        <fullName>Application_Approved_Please_Create_Case2</fullName>
        <assignedTo>richard.bailey@wexinc.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Please create a case.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Application_Request__c.App_Approved_Date__c</offsetFromField>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Application Approved - Please Create Case</subject>
    </tasks>
    <tasks>
        <fullName>Application_Request_is_Approved</fullName>
        <assignedToType>owner</assignedToType>
        <description>This Opportunity&apos;s Application Request has been approved.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Application_Request__c.Today_Hidden_for_Workflow__c</offsetFromField>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Application Request is Approved</subject>
    </tasks>
    <tasks>
        <fullName>Application_Request_is_Approved_Conditions</fullName>
        <assignedToType>owner</assignedToType>
        <description>This Opportunity&apos;s Application Request has been approved with conditions.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Application_Request__c.Today_Hidden_for_Workflow__c</offsetFromField>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Application Request is Approved-Conditions</subject>
    </tasks>
    <tasks>
        <fullName>Application_Request_is_Approved_Rereview_Conditional</fullName>
        <assignedToType>owner</assignedToType>
        <description>This Opportunity&apos;s Application Request has been approved for rereview conditionally.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Application_Request__c.Today_Hidden_for_Workflow__c</offsetFromField>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Application Request is Approved Rereview Conditional</subject>
    </tasks>
    <tasks>
        <fullName>Application_Request_is_Declined</fullName>
        <assignedToType>owner</assignedToType>
        <description>This Opportunity&apos;s Application Request has been declined.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Application_Request__c.Today_Hidden_for_Workflow__c</offsetFromField>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Application Request is Declined</subject>
    </tasks>
    <tasks>
        <fullName>Application_Request_is_Declined_Pending_Conditions</fullName>
        <assignedToType>owner</assignedToType>
        <description>This Opportunity&apos;s Application Request has been declined pending conditions.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Application_Request__c.Today_Hidden_for_Workflow__c</offsetFromField>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Application Request is Declined Pending Conditions</subject>
    </tasks>
    <tasks>
        <fullName>Application_Request_is_Declined_Rereview_Pending_Conditions</fullName>
        <assignedToType>owner</assignedToType>
        <description>This Opportunity&apos;s Application Request has been declined rereview-pending conditions.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Application_Request__c.Today_Hidden_for_Workflow__c</offsetFromField>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Application Request is Declined Rereview-Pending Conditions</subject>
    </tasks>
    <tasks>
        <fullName>Application_Request_is_Incomplete</fullName>
        <assignedToType>owner</assignedToType>
        <description>This Opportunity&apos;s Application Request is incomplete.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Application_Request__c.Today_Hidden_for_Workflow__c</offsetFromField>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Application Request is Incomplete</subject>
    </tasks>
    <tasks>
        <fullName>Application_Request_is_Pending</fullName>
        <assignedToType>owner</assignedToType>
        <description>his Opportunity&apos;s Application Request is Pending.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Application_Request__c.Today_Hidden_for_Workflow__c</offsetFromField>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Application Request is Pending</subject>
    </tasks>
    <tasks>
        <fullName>Application_Request_is_Rereviewed_Declined</fullName>
        <assignedToType>owner</assignedToType>
        <description>This Opportunity&apos;s Application Request is rereviewed declined.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Application_Request__c.Today_Hidden_for_Workflow__c</offsetFromField>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Application Request is Rereviewed Declined</subject>
    </tasks>
    <tasks>
        <fullName>Application_Request_status_is_in_Manager_Review</fullName>
        <assignedToType>owner</assignedToType>
        <description>This Opportunity&apos;s Application Request has been moved to Manager Review.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Application_Request__c.Today_Hidden_for_Workflow__c</offsetFromField>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Application Request status is in Manager Review</subject>
    </tasks>
    <tasks>
        <fullName>Application_Updated</fullName>
        <assignedTo>richard.bailey@wexinc.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Please check the application as the status has changed</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Application Updated</subject>
    </tasks>
    <tasks>
        <fullName>Application_Updated_Larry</fullName>
        <assignedTo>larry.tracey@wexinc.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Please check the application as the status has changed</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Application Updated - Larry</subject>
    </tasks>
    <tasks>
        <fullName>Approval_Email_Sent</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Approval Email Sent</subject>
    </tasks>
    <tasks>
        <fullName>Call_TIme_to_Cross_Sell_Will</fullName>
        <assignedTo>richard.bailey@wexinc.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Schedule a call to Cross Sell 60 days after application is approved.</description>
        <dueDateOffset>60</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Application_Request__c.App_Approved_Date__c</offsetFromField>
        <priority>4-Medium</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Call: TIme to Cross Sell</subject>
    </tasks>
    <tasks>
        <fullName>Call_Time_to_Cross_Sell_Larry</fullName>
        <assignedTo>larry.tracey@wexinc.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Schedule a cross sell call for 60 days after application is approved</description>
        <dueDateOffset>60</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Application_Request__c.App_Approved_Date__c</offsetFromField>
        <priority>4-Medium</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Call: Time to Cross Sell</subject>
    </tasks>
    <tasks>
        <fullName>Card_Production_Complete</fullName>
        <assignedToType>owner</assignedToType>
        <description>Card Production has been completed for the related Application Request.  Please follow up with the Billing Contact and/or Decision Maker to confirm.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Card Production Complete</subject>
    </tasks>
    <tasks>
        <fullName>Card_Production_Complete_Notifcation_Sent</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Card Production Complete Notifcation Sent</subject>
    </tasks>
    <tasks>
        <fullName>Checkin_Call</fullName>
        <assignedTo>larry.tracey@wexinc.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>30 Day check-in call</description>
        <dueDateOffset>30</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Application_Request__c.App_Approved_Date__c</offsetFromField>
        <priority>4-Medium</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Checkin Call</subject>
    </tasks>
    <tasks>
        <fullName>Checkin_Call2</fullName>
        <assignedTo>richard.bailey@wexinc.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>30 Day check-in call</description>
        <dueDateOffset>30</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Application_Request__c.App_Approved_Date__c</offsetFromField>
        <priority>4-Medium</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Checkin Call</subject>
    </tasks>
    <tasks>
        <fullName>Fleet_Data_Form_Sent</fullName>
        <assignedTo>salesforce@wrightexpress.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Fleet Data Form Sent</subject>
    </tasks>
    <tasks>
        <fullName>Non_Solicited_Application</fullName>
        <assignedTo>none@wexinc.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Non Solicited Application</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>4-Medium</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Non Solicited Application</subject>
    </tasks>
    <tasks>
        <fullName>Set_UP_Account</fullName>
        <assignedTo>account@wexinc.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>360 Account- use 360 Template</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CreatedDate</offsetFromField>
        <priority>4-Medium</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Set UP Account</subject>
    </tasks>
    <tasks>
        <fullName>Solicited_Application</fullName>
        <assignedTo>none@wexinc.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Solicited Application</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>4-Medium</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Solicited Application</subject>
    </tasks>
    <tasks>
        <fullName>Thank_you_Email_Sent</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Thank you Email Sent</subject>
    </tasks>
    <tasks>
        <fullName>This_Opportunity_s_Application_Request_is_Pending</fullName>
        <assignedToType>owner</assignedToType>
        <description>This Opportunity&apos;s Application Request is rereviewed approved.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Application_Request__c.Today_Hidden_for_Workflow__c</offsetFromField>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>This Opportunity&apos;s Application Request is Rereviewed Approved.</subject>
    </tasks>
</Workflow>
