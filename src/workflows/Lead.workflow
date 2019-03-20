<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AU_Lead_Sales_Notification</fullName>
        <description>AU Lead Sales Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sales@wrightexpress.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AU_Email_Templates/AU_Lead_Sales_Notification</template>
    </alerts>
    <alerts>
        <fullName>AU_MVF_Intro_Email</fullName>
        <description>AU MVF Intro Email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>sales@wexaustralia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AU_Email_Templates/AU_MVF_Right_prom</template>
    </alerts>
    <alerts>
        <fullName>AU_Motorcharge_Company_Confirmation</fullName>
        <description>AU Motorcharge - Company Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>sales@wrightexpress.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AU_Email_Templates/AUMotorcharge_Company_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>AU_Motorcharge_Individual_Confirmation</fullName>
        <description>AU Motorcharge – Individual Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>sales@wrightexpress.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AU_Email_Templates/AUMotorcharge_Individual_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>AU_Motorpass_Company_Confirmation</fullName>
        <description>AU Motorpass - Company Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>sales@wrightexpress.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AU_Email_Templates/AU_Motorpass_Company_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>AU_Motorpass_Individual_Confirmation</fullName>
        <description>AU Motorpass - Individual Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>sales@wrightexpress.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AU_Email_Templates/AU_Motorpass_Individual_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>Community_Notify_partner_community_user_that_submitted_lead_has_been_recieved</fullName>
        <description>Community: Notify partner community user that submitted lead has been recieved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>WEX_Partner_Community_Templates/Communities_Lead_Received_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_sent_to_Contact_for_MMVF</fullName>
        <description>Email sent to Contact for MVF Leads</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/MVF_HTML</template>
    </alerts>
    <alerts>
        <fullName>Enterprise_Truck_Rental_Lead_Email</fullName>
        <description>Enterprise Truck Rental Lead Email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Referrer_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Enterprise_Auto_Generated_Email</template>
    </alerts>
    <alerts>
        <fullName>Lead_voice_mail_follow_up_email</fullName>
        <description>Lead: voice mail follow up email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_and_Marketing/Voicemail_Follow_Up_Message_1</template>
    </alerts>
    <alerts>
        <fullName>Trigger_an_email_from_SF_upon_receipt_of_web_to_lead_form_from_MVF</fullName>
        <description>Trigger an email from SF upon receipt of web to lead form from MVF</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>BOCA/MVF_QBW_Q7E_Generic_Series_1</template>
    </alerts>
    <alerts>
        <fullName>Trigger_an_email_from_SF_upon_receipt_of_web_to_lead_form_from_WQM</fullName>
        <description>Trigger an email from SF upon receipt of web to lead form from WQM</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>BOCA/MVF_WQM_Generic_Series_1</template>
    </alerts>
    <fieldUpdates>
        <fullName>AURecType</fullName>
        <description>Changes the record type to AU Fuel</description>
        <field>RecordTypeId</field>
        <lookupValue>AU_Fuel</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>AURecType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Application_Status_Credit_Queue</fullName>
        <field>AU_Application_Status__c</field>
        <literalValue>Ready for Assessment</literalValue>
        <name>AU Application Status - Credit Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Application_Status_Follow_Up</fullName>
        <field>AU_Application_Status__c</field>
        <literalValue>Follow up</literalValue>
        <name>AU Application Status: Follow Up</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Lead_Assign_to_Credit_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>AU_Credit_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>AU Lead: Assign to Credit Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Lead_Assign_to_Sales_Queue</fullName>
        <description>Assigns Owner to AU Sales Queue</description>
        <field>OwnerId</field>
        <lookupValue>AU_Fuel_Card_Applications</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>AU Lead: Assign to Sales Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Lead_Follow_Up_Status</fullName>
        <field>AU_Application_Status__c</field>
        <literalValue>Follow up</literalValue>
        <name>AU Lead: Follow Up Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Lead_In_progress_update</fullName>
        <field>Status</field>
        <literalValue>In Progress</literalValue>
        <name>AU Lead: In progress update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Lead_Ready_for_Assessment_Status</fullName>
        <description>Sets the Application Status to &quot;Ready for Assessment&quot;</description>
        <field>AU_Application_Status__c</field>
        <literalValue>Ready for Assessment</literalValue>
        <name>AU Lead: Ready for Assessment Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Lead_Unactioned_Status</fullName>
        <field>AU_Application_Status__c</field>
        <literalValue>Unactioned</literalValue>
        <name>AU Lead: Unactioned Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Update_Business_trading_name</fullName>
        <field>AU_Business_Trading_Name__c</field>
        <formula>AU_Account_Name__c</formula>
        <name>AU Update Business trading name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Affinity_Channel_Update</fullName>
        <field>Affinity_Cobrand_Channel_Opps__c</field>
        <formula>Text( Affinity_Cobrand_Sub_Interest__c )</formula>
        <name>Affinity Channel Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Application_Status</fullName>
        <field>AU_Application_Status__c</field>
        <literalValue>Follow up</literalValue>
        <name>Application Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Application_Status_Credit_Queue</fullName>
        <field>AU_Application_Status__c</field>
        <literalValue>Ready for Assessment</literalValue>
        <name>Application Status - Credit Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_Decision_Maker</fullName>
        <description>For online application form</description>
        <field>Decision_Maker__c</field>
        <literalValue>1</literalValue>
        <name>Assign Decision Maker</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Fleet_Outbound_Sales_Q</fullName>
        <field>OwnerId</field>
        <lookupValue>W2L_Fleet_Outbound_Sales</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to W2L Fleet Outbound Sales Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Fleet_Outbound_Sales_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>W2L_Fleet_Outbound_Sales</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Fleet Outbound Sales Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>C_Wright_Lead_Campaign_ID</fullName>
        <description>https://na5.salesforce.com/70170000000ifX9?srPos=0&amp;srKp=701</description>
        <field>Text_Primary_Campaign__c</field>
        <formula>&quot;70170000000ifX9&quot;</formula>
        <name>C-Wright Lead Campaign ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Call_Cycle_NULL</fullName>
        <field>Call_Stage__c</field>
        <name>Call Cycle:  NULL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Call_Stage_Place_1st_Call</fullName>
        <description>Change Call Stage to Place 1st Call</description>
        <field>Call_Stage__c</field>
        <literalValue>1st Call</literalValue>
        <name>Call Stage - Place 1st Call</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Card_Program_ID_Local</fullName>
        <description>If the Product/Service Type is Fleet Card - Direct Local, then Card Program ID is  0017000000un4U3</description>
        <field>Card_Program_ID__c</field>
        <formula>&quot;0017000000un4U3&quot;</formula>
        <name>Card Program ID Local</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Card_Program_ID_OTR</fullName>
        <description>If the Product/Service Type is Fleet Card - Direct OTR then Card Program ID is 0017000000un4U1.</description>
        <field>Card_Program_ID__c</field>
        <formula>&quot;0017000000un4U1&quot;</formula>
        <name>Card Program ID OTR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Call_Stage</fullName>
        <description>Change the Lead Call Stage to &quot;1st Call.&quot;</description>
        <field>Call_Stage__c</field>
        <literalValue>1st Call</literalValue>
        <name>Change Call Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Owner_To_Pardot_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Pardot_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Owner To Pardot Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_OBTM_Lead_Owner_from_Parent_Leads</fullName>
        <field>OBTM_Lead__c</field>
        <name>Clear OBTM_Lead Owner from Parent Leads</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Created_by_Partner_England_Logistics</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;England Logistics&quot;</formula>
        <name>Tag Partner England Logistics</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Express_Truck_Tax</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&apos;Express Truck Tax&apos;</formula>
        <name>Express Truck Tax</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Fleet_Channel_Update</fullName>
        <field>Fleet_Card_Channel_Opps__c</field>
        <formula>Text(Fleet_Sub_Interest__c)</formula>
        <name>Fleet Channel Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Background_Notes_to_Opportunity</fullName>
        <field>Lead_Background_Notes_to_Opportunity__c</field>
        <formula>Description</formula>
        <name>Lead Background Notes to Opportunity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Disqualified_Date</fullName>
        <field>Lead_Disqualified_Date__c</field>
        <formula>TODAY()</formula>
        <name>Lead Disqualified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Owner_Update</fullName>
        <field>OwnerId</field>
        <lookupValue>IS_Leads_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Lead Owner Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Status_Contacting</fullName>
        <field>Status</field>
        <literalValue>Contacting</literalValue>
        <name>Lead Status - Contacting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Update_Status_Working</fullName>
        <description>Updates the status of the lead to working when that first call is made.</description>
        <field>Status</field>
        <literalValue>Working</literalValue>
        <name>Lead_Update_Status_Working</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Name_Co_List_ID_Camp_Program_CC</fullName>
        <field>Name_Coupon_Code__c</field>
        <formula>FirstName &amp;&quot; &quot; &amp; LastName  &amp;&quot; &quot;&amp;  Company &amp;&quot; &quot;&amp;  List_ID__c &amp;&quot; &quot;&amp; Campaign_Program__r.Name &amp;&quot; &quot;&amp; Coupon_Code_2__c&amp;&quot; &quot;&amp; Prospect_ID__c</formula>
        <name>Name, Co, List ID, Camp Program &amp; CC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Next_Contact</fullName>
        <field>Next_Contact__c</field>
        <formula>Today()</formula>
        <name>Next Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Next_Contact_100_Days</fullName>
        <field>Next_Contact__c</field>
        <formula>Today() + 100</formula>
        <name>Next Contact + 100 Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Next_Contact_Blank</fullName>
        <field>Next_Contact__c</field>
        <name>Next Contact = Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Product_Interest_Update</fullName>
        <field>Opportunity_Product_Interest__c</field>
        <formula>TEXT( Product_Interest__c )</formula>
        <name>Opportunity Product Interest Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Tag_Trulos</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Trulos&quot;</formula>
        <name>Tag Partner Tag Trulos</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Card_Program_WF_TXT_Lead</fullName>
        <description>When there&apos;s a value in the Card Program field, copy it to Card Program WF TXT.</description>
        <field>Card_Program_WF_TXT__c</field>
        <formula>Card_Program__r.Name</formula>
        <name>Populate Card Program WF TXT Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Service_Type_Local</fullName>
        <description>For web to lead Leads, if Card Product is &quot;Local&quot; make Product/Service Type = Fleet Card - Direct Local.</description>
        <field>Product_Service_Type__c</field>
        <literalValue>Fleet Card - Direct Local</literalValue>
        <name>Product Service Type Local</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Service_Type_OTR</fullName>
        <description>For leads coming from website, if Card Product is OTR, make Product/Service Type = Fleet Card - Direct OTR.</description>
        <field>Product_Service_Type__c</field>
        <literalValue>Fleet Card - Direct OTR</literalValue>
        <name>Product Service Type - OTR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prospect_Id_Manual</fullName>
        <field>Prospect_ID__c</field>
        <formula>&quot;Manual&quot;</formula>
        <name>Prospect Id = Manual</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prospect_Id_to_Opp</fullName>
        <field>Prospect_ID_to_Opp1__c</field>
        <formula>Prospect_ID__c</formula>
        <name>Prospect Id to Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Provider_Source_Manual</fullName>
        <field>Provider_Source__c</field>
        <formula>&quot;Manual&quot;</formula>
        <name>Provider Source = Manual</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Provider_Source_to_Opp</fullName>
        <field>Provider_Source_to_Opp__c</field>
        <formula>Provider_Source__c</formula>
        <name>Provider Source to Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reassign_to_LDR_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>LDR_Lead_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Reassign to LDR Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Owner_Marketing_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>MarketingQueue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Record Owner = Marketing Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_Wright_Lead</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Wright_Leads</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type Wright Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lead_Status_to_Working</fullName>
        <field>Status</field>
        <literalValue>Working</literalValue>
        <name>Set Lead Status to Working</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_created_by_3MD_parner_tag</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&apos;3MD Solutions&apos;</formula>
        <name>Set created by 3MD parner tag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_created_by_FleetPro_Partner_Tag</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;FleetPro Services&quot;</formula>
        <name>Set created by FleetPro Partner Tag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_created_by_Fleet_Savings_Partner_Tag</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&apos;Fleet Savings&apos;</formula>
        <name>Set created by Fleet Savings Partner Tag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Dead</fullName>
        <field>Status</field>
        <literalValue>Dead</literalValue>
        <name>Status = Dead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_AAble_iFleet</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&apos;AAble iFleet&apos;</formula>
        <name>Tag Partner AAble iFleet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_AU_Partner_Salmat</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Salmat&quot;</formula>
        <name>Tag AU Partner Salmat</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Beevo</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Beevo&quot;</formula>
        <name>Tag AU Partner Beevo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_CenterFire</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&apos;CenterFire&apos;</formula>
        <name>Tag CenterFire</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_GE_Capital_Leads</fullName>
        <description>For tagging partner GE Capital createdby partner tag</description>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;GE Capital&quot;</formula>
        <name>Tag Partner GE Capital Leads</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Knight_Logistics_Leads</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&apos;Knight Logistics&apos;</formula>
        <name>Tag Knight Logistics Leads</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Mansfield_Oil_Company_Leads</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&apos;Mansfield Oil Company&apos;</formula>
        <name>Tag Mansfield Oil Company Leads</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_PTP_Stop_NATSN</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&apos;PTP Stop NATSN&apos;</formula>
        <name>Tag PTP Stop NATSN</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_123Loadboard</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;123Loadboard&quot;</formula>
        <name>Tag Partner 123Loadboard</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Advanced_Commercial_Credit</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Advanced Commercial Credit&quot;</formula>
        <name>Tag Partner Advanced Commercial Credit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Aladdin_Financial</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Aladdin Financial&quot;</formula>
        <name>Tag Partner Aladdin Financial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Ambest</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&apos;AMBEST&apos;</formula>
        <name>Tag Partner Ambest</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_BSNF</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;BSNF&quot;</formula>
        <name>Tag Partner BSNF</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_CJM_Financial</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;CJM Financial&quot;</formula>
        <name>Tag Partner CJM Financial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Commercial_Funding</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Commercial Funding&quot;</formula>
        <name>Tag Partner Commercial Funding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_CoreFund_Capital</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;CoreFund Capital&quot;</formula>
        <name>Tag Partner CoreFund Capital</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_DAT</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;DAT&quot;</formula>
        <name>Tag Partner DAT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_D_S_Fuel_Card</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;D&amp;S Fuel Card&quot;</formula>
        <name>Tag Partner D&amp;S Fuel Card</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_D_S_Supoort</fullName>
        <description>F1 Partner Portal</description>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;D&amp;S Support&quot;</formula>
        <name>Tag Partner D&amp;S Supoort</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Discount_Diesel</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Discount Diesel&quot;</formula>
        <name>Tag Partner Discount Diesel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_ECAPITAL</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;ECAPITAL&quot;</formula>
        <name>Tag Partner ECAPITAL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_ENGS_Commercial_Capital</fullName>
        <description>Populate the &quot;Created by Partner Tag&quot; text field with the name &quot;ENGS Commercial Capital&quot;</description>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;ENGS Commercial Capital&quot;</formula>
        <name>Tag Partner ENGS Commercial Capital</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Envio_360</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Envio 360&quot;</formula>
        <name>Tag Partner Envio 360</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Express_Freight_Finance</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Express Freight Finance&quot;</formula>
        <name>Tag Partner Express Freight Finance</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Far_West_Capital</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Far West Capital&quot;</formula>
        <name>Tag Partner Far West Capital</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_FedEx_Custom_Critical</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;FedEx Custom Critical&quot;</formula>
        <name>Tag Partner FedEx Custom Critical</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Financial_Carrier_Service</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Financial Carrier Service&quot;</formula>
        <name>Tag Partner Financial Carrier Service</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Foley_Carrier_Services</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Foley Carrier Services&quot;</formula>
        <name>Tag Partner Foley Carrier Services</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Freight_Factoring_Special</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Freight Factoring Special&quot;</formula>
        <name>Tag Partner Freight Factoring Special</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_G_H_Factor</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;G.H. Factor&quot;</formula>
        <name>Tag Partner G.H. Factor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Great_Plains</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Great Plains&quot;</formula>
        <name>Tag Partner Great Plains</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Integra</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Integra&quot;</formula>
        <name>Tag Partner Integra</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Integrated_Logistics</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Integrated Logistics&quot;</formula>
        <name>Tag Partner Integrated Logistics</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Interstate_Capital</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Interstate Capital&quot;</formula>
        <name>Tag Partner Interstate Capital</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Intouch_GPS</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;InTouch GPS&quot;</formula>
        <name>Tag Partner Intouch GPS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_JB_Hunt</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;JB Hunt&quot;</formula>
        <name>Tag Partner JB Hunt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_JD_Factors</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;JD Factors&quot;</formula>
        <name>Tag Partner JD Factors</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Liquid_Capital</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Liquid Capital&quot;</formula>
        <name>Tag Partner Liquid Capital</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Mike_Gordon</fullName>
        <description>Populate the &quot;Created by Partner Tag&quot; text field with the name &quot;Mike Gordon&quot;</description>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Mike Gordon&quot;</formula>
        <name>Tag Partner Mike Gordon</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_NASTC</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;NASTC&quot;</formula>
        <name>Tag Partner NASTC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_OTR_Capital</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;OTR Capital&quot;</formula>
        <name>Tag Partner OTR Capital</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Parikh_Financial</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Parikh Financial&quot;</formula>
        <name>Tag Partner Parikh Financial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Partners_Funding</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Partners Funding&quot;</formula>
        <name>Tag Partner Partners Funding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Pavestone_Capital</fullName>
        <description>F1 Partner Portal</description>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Pavestone Capital&quot;</formula>
        <name>Tag Partner Pavestone Capital</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Pay4Freight</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Pay4Freight&quot;</formula>
        <name>Tag Partner Pay4Freight</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Petro_Solutions</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Petro Solutions&quot;</formula>
        <name>Tag Partner Petro Solutions</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_PrePass</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;PrePass&quot;</formula>
        <name>Tag Partner PrePass</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Quality_Companies</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Quality Companies&quot;</formula>
        <name>Tag Partner Quality Companies</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Quick_Pay_Funding</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Quick Pay Funding&quot;</formula>
        <name>Tag Partner Quick Pay Funding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_RTS</fullName>
        <description>Populate the &quot;Created by Partner Tag&quot; text field with the name &quot;RTS&quot;</description>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;RTS&quot;</formula>
        <name>Tag Partner RTS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_STC</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;STC&quot;</formula>
        <name>Tag Partner STC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_SUMMAR</fullName>
        <description>Populate the &quot;Created by Partner Tag&quot; text field with the name &quot;SUMMAR&quot;</description>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;SUMMAR&quot;</formula>
        <name>Tag Partner SUMMAR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Single_Point</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Single Point&quot;</formula>
        <name>Tag Partner Single Point</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_St_Johns</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;St Johns&quot;</formula>
        <name>Tag Partner St Johns</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Steelhead</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Steelhead&quot;</formula>
        <name>Tag Partner Steelhead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Sunbelt</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Sunbelt&quot;</formula>
        <name>Tag Partner Sunbelt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_TRANSPORT_FINANCIAL_SOLUTIO</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;TRANSPORT FINANCIAL SOLUTIONS&quot;</formula>
        <name>Tag Partner TRANSPORT FINANCIAL SOLUTIO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_TRIUMPH_BUSINESS_CAPITAL</fullName>
        <description>Populate the &quot;Created by Partner Tag&quot; text field with the name &quot;TRIUMPH BUSINESS CAPITAL&quot;</description>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;TRIUMPH BUSINESS CAPITAL&quot;</formula>
        <name>Tag Partner TRIUMPH BUSINESS CAPITAL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Thunder_Carrier_Services</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Thunder Carrier Services&quot;</formula>
        <name>Tag Partner Thunder Carrier Services</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Trans_Alliance</fullName>
        <description>Populate the &quot;Created by Partner Tag&quot; text field with the name &quot;Trans-Alliance&quot;</description>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Trans-Alliance&quot;</formula>
        <name>Tag Partner Trans-Alliance</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Truckers_B2B</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Truckers B2B&quot;</formula>
        <name>Tag Partner Truckers B2B</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Truckers_Solutions</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Truckers Solutions&quot;</formula>
        <name>Tag Partner Truckers Solutions</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Vero_Business_Capital</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Vero Business Capital&quot;</formula>
        <name>Tag Partner Vero Business Capital</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Vessix</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Vessix&quot;</formula>
        <name>Tag Partner Vessix</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Xfactors</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Xfactors&quot;</formula>
        <name>Tag Partner Xfactors</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_iThrive_Funding</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;iThrive Funding&quot;</formula>
        <name>Tag Partner iThrive Funding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_to_Roady_s_Card</fullName>
        <description>F1 Partner Portal</description>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Roady&apos;s Card&quot;</formula>
        <name>Tag Partner to Roady&apos;s Card</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Patriot_Fleet_Systems</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&apos;Patriot Fleet Systems&apos;</formula>
        <name>Tag Patriot Fleet Systems</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_TBS_Factoring_Service</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&apos;TBS Factoring Service&apos;</formula>
        <name>Tag TBS Factoring Service</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_XPO_Logistics</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&apos;XPO Logistics&apos;</formula>
        <name>Tag XPO Logistics</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_3rd_call</fullName>
        <field>Call_Stage__c</field>
        <literalValue>3rd Call</literalValue>
        <name>Update 3rd call</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_4th_Call</fullName>
        <field>Call_Stage__c</field>
        <literalValue>4th Call</literalValue>
        <name>Update 4th Call</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_5th_Call</fullName>
        <field>Call_Stage__c</field>
        <literalValue>5th Call</literalValue>
        <name>Update 5th Call</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Call_Cycle_2</fullName>
        <field>Call_Stage__c</field>
        <literalValue>2nd Call</literalValue>
        <name>Update Call Cycle 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Call_Stage_6</fullName>
        <field>Call_Stage__c</field>
        <literalValue>6th Call</literalValue>
        <name>Update Call Stage 6</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Call_Stage_Null</fullName>
        <field>Call_Stage__c</field>
        <name>Update Call Stage:  Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Coupon_Code_Text_from_Coupon_Code</fullName>
        <field>Coupon_Code__c</field>
        <formula>Coupon_Code_2__c</formula>
        <name>Update Coupon Code Text from Coupon Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Last_Contact</fullName>
        <field>Last_Contact__c</field>
        <formula>Today()</formula>
        <name>Update Last Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Next_Contact_7_days</fullName>
        <field>Next_Contact__c</field>
        <formula>Last_Contact__c +7</formula>
        <name>Update Next Contact +7 days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Outcome</fullName>
        <field>Call_Outcome__c</field>
        <name>Update Outcome</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_to_MVF_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>MVF_Leads_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner to MVF Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_RT_to_Truckers</fullName>
        <description>Update the lead record type to the Truckers record type</description>
        <field>RecordTypeId</field>
        <lookupValue>Truckers_Leads</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update RT to Truckers</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Unqualified</fullName>
        <field>Status</field>
        <literalValue>Unqualified</literalValue>
        <name>Update Status:  Unqualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Add_to_Call_Outreach_Total</fullName>
        <field>WES_Call_Count__c</field>
        <formula>IF(WES_Call_Count__c &gt; 0, WES_Call_Count__c + 1, 1)</formula>
        <name>WES - Add to Call Outreach Total</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Assign_to_Telesales_RR_queue</fullName>
        <field>OwnerId</field>
        <lookupValue>WES_Telesales_auto_assign</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>WES - Assign to Telesales RR queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Auto_Assign_to_Field_Sales_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>WES_Field_Sales_auto_assign</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>WES - Auto Assign to Field Sales Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Change_Lead_Status_to_Disqualified</fullName>
        <field>Status</field>
        <literalValue>Disqualified</literalValue>
        <name>WES - Change Lead Status to Disqualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Clear_Auto_Assign</fullName>
        <field>AssigntoQueue__c</field>
        <name>WES - Clear Auto-Assign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Manually_Assign_Fieldsales_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>WES_Field_Sales_manually_assign</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>WES - Manually Assign Fieldsales Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Manually_Assign_Telesales_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>WES_Telesales_manually_assign</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>WES - Manually Assign Telesales Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Reset_Call_Outcome</fullName>
        <field>Call_Outcome__c</field>
        <name>WES - Reset Call Outcome</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Reset_Callback_Comments</fullName>
        <field>Call_Outcome_Comments__c</field>
        <name>WES - Reset Callback Comments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Reset_Callback_Time</fullName>
        <field>WES_Call_Back_Time__c</field>
        <name>WES - Reset Callback Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Reset_Sub_Status_1</fullName>
        <field>WES_Sub_Status1__c</field>
        <name>WES - Reset Sub-Status 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Reset_Sub_Status_2</fullName>
        <field>WES_Sub_Status2__c</field>
        <name>WES - Reset Sub-Status 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Callback_Time</fullName>
        <field>WES_Call_Back_Time__c</field>
        <formula>NOW()+ (1/6)</formula>
        <name>WES - Set Default Callback Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Diesel_used_month_GBP</fullName>
        <description>Sets Diesel used per month based on Litres. Using 1.2 GBP per Litre as price</description>
        <field>WES_Diesel_per_month_GBP__c</field>
        <formula>WES_Diesel_per_month_Litres__c * 1.2</formula>
        <name>WES Set Diesel used / month (GBP)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Diesel_used_month_Litres</fullName>
        <description>Sets Litres used per month based on GBP. Using 1.2 GBP per Litre as price</description>
        <field>WES_Diesel_per_month_Litres__c</field>
        <formula>WES_Diesel_per_month_GBP__c / 1.2</formula>
        <name>WES Set Diesel used / month (Litres)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Disqualified_Reason_1</fullName>
        <description>Used by WES</description>
        <field>WES_Disqualified_Reason1__c</field>
        <formula>TEXT(WES_Sub_Status1__c)</formula>
        <name>WES - Set Disqualified Reason 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Disqualified_Reason_2</fullName>
        <description>Used by WES</description>
        <field>WES_Disqualified_Reason2__c</field>
        <formula>TEXT(WES_Sub_Status2__c)</formula>
        <name>WES - Set Disqualified Reason 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Last_Call_Outcome_Time</fullName>
        <field>LastCallOutcomeTime__c</field>
        <formula>NOW()</formula>
        <name>WES - Set Last Call Outcome Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Petrol_used_month_GBP</fullName>
        <description>Sets Petrol used per month based on Litres. Using 1.2 GBP per Litre as price</description>
        <field>WES_Petrol_used_per_month_GBP__c</field>
        <formula>WES_Petrol_used_per_month_Litres__c * 1.2</formula>
        <name>WES Set Petrol used / month (GBP)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Petrol_used_month_Litres</fullName>
        <description>Sets Litres used per month based on GBP. Using 1.2 GBP per Litre as price</description>
        <field>WES_Petrol_used_per_month_Litres__c</field>
        <formula>WES_Petrol_used_per_month_GBP__c / 1.2</formula>
        <name>WES Set Petrol used / month (Litres)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Street</fullName>
        <field>Street</field>
        <formula>WES_Address_Line1__c&amp;BR()&amp;
WES_Address_Line2__c&amp;BR()&amp; 
WES_Address_Line3__c</formula>
        <name>WES - Set Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Trading_Country</fullName>
        <field>Country</field>
        <formula>TEXT(WES_Trading_Country__c)</formula>
        <name>WES - Set Trading Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Trading_County</fullName>
        <field>State</field>
        <formula>WES_Trading_County__c</formula>
        <name>WES - Set Trading County</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Trading_County_based_on_State</fullName>
        <field>WES_TradingPostcode__c</field>
        <formula>PostalCode</formula>
        <name>WES - Set Trading Postcode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Trading_County_on_State</fullName>
        <field>WES_Trading_County__c</field>
        <formula>State</formula>
        <name>WES - Set Trading County based on State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Trading_Postcode</fullName>
        <field>PostalCode</field>
        <formula>WES_TradingPostcode__c</formula>
        <name>WES - Set Trading Postcode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Trading_Street_with_Billing</fullName>
        <field>WES_Address_Line1__c</field>
        <formula>Street</formula>
        <name>WES - Set Trading Street with Billing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Trading_Town</fullName>
        <field>City</field>
        <formula>WES_Trading_Town__c</formula>
        <name>WES - Set City based on Trading Town</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Trading_Town_based_on_City</fullName>
        <field>WES_Trading_Town__c</field>
        <formula>City</formula>
        <name>WES - Set Trading Town based on City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Update_Last_Call_Outcome</fullName>
        <field>WES_Last_Call_Outcome__c</field>
        <formula>TEXT(Call_Outcome__c)</formula>
        <name>WES - Update Last Call Outcome</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WEX_Facebeok_Leads</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Wright_Leads</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>WEX Facebeok Leads</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WEX_Universal_Program</fullName>
        <description>https://na5.salesforce.com/a0Z70000001uyUB?srPos=0&amp;srKp=a0Z</description>
        <field>Text_Program__c</field>
        <formula>&quot;a0Z70000001uyUB&quot;</formula>
        <name>WEX Universal Program</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>set_Created_by_CarsArrive</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;CarsArrive&quot;</formula>
        <name>set Created by CarsArrive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>set_Created_by_to_Fuelbook</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Fuelbook&quot;</formula>
        <name>set Created by to Fuelbook</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>set_Lead_Source_Website_Oppt</fullName>
        <field>Lead_Source_Website_Oppt__c</field>
        <formula>Lead_Source_Website_Oppt__c</formula>
        <name>set Lead Source Website - Oppt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AU %3A Application status sales queue</fullName>
        <actions>
            <name>AU_Application_Status_Follow_Up</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>AU Sales Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>notEqual</operation>
            <value>Untouched</value>
        </criteriaItems>
        <description>If Lead is in the Sales Queue and Lead status = &quot;untouched&quot;, update the Lead application status.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU Application Status</fullName>
        <actions>
            <name>AU_Application_Status_Credit_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>AU Credit Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>notEqual</operation>
            <value>Untouched</value>
        </criteriaItems>
        <description>If owned by the Credit queue and lead status = &quot;untouched&quot;, then update the Lead Application Status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU Business Trading Name</fullName>
        <actions>
            <name>AU_Update_Business_trading_name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.AU_Business_Trading_Name__c</field>
            <operation>equals</operation>
            <value>Null</value>
        </criteriaItems>
        <description>If Business trading name is null populate with Legal Entity Name</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AU Lead%3A Assign to Sales Queue</fullName>
        <actions>
            <name>AU_Lead_Sales_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>AU_Lead_Assign_to_Sales_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>AU Fuel Application Individual,AU Fuel Application Business</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>notEqual</operation>
            <value>Glenna Wilder</value>
        </criteriaItems>
        <description>Changes Owner to Sales Queue [if Details Complete = False]</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AU Lead%3A Follow Up Status</fullName>
        <actions>
            <name>AU_Lead_Follow_Up_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.AU_Application_Status__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Details_Complete__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Sets the Application Status to Follow Up if blank and Details Complete = False and Lead Status = In Progress</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AU Lead%3A In progress update</fullName>
        <actions>
            <name>AU_Lead_In_progress_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Lead.AU_Application_Status__c</field>
            <operation>equals</operation>
            <value>Ready for Assessment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Details_Complete__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Change the Lead status to &quot;In Progress&quot; if the application status is &quot;Ready for Assessment&quot; and the lead details are complete.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AU Lead%3A Motorcharge Business Response</fullName>
        <actions>
            <name>AU_Motorcharge_Company_Confirmation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>AU Fuel Application Business</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Product_Name__c</field>
            <operation>equals</operation>
            <value>MC</value>
        </criteriaItems>
        <description>AU Lead: Motorcharge Business Response</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU Lead%3A Motorcharge Individual Response</fullName>
        <actions>
            <name>AU_Motorcharge_Individual_Confirmation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>AU Fuel Application Individual</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Product_Name__c</field>
            <operation>equals</operation>
            <value>MC</value>
        </criteriaItems>
        <description>AU Lead: Motorcharge Individual Response</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU Lead%3A Motorpass Business Response</fullName>
        <actions>
            <name>AU_Motorpass_Company_Confirmation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>AU Fuel Application Business</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Product_Name__c</field>
            <operation>equals</operation>
            <value>SM</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Product_Name__c</field>
            <operation>equals</operation>
            <value>DC</value>
        </criteriaItems>
        <description>AU Lead: Motorpass Business Response</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU Lead%3A Motorpass Individual Response</fullName>
        <actions>
            <name>AU_Motorpass_Individual_Confirmation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>AU Fuel Application Individual</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Product_Name__c</field>
            <operation>equals</operation>
            <value>SM</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Product_Name__c</field>
            <operation>equals</operation>
            <value>DC</value>
        </criteriaItems>
        <description>AU Lead: Motorpass Individual Response</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU Lead%3A Ready for Assessment Status</fullName>
        <actions>
            <name>AU_Lead_Ready_for_Assessment_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.AU_Application_Status__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Details_Complete__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Sets the Application Status to Ready for Assessment if blank</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU Lead%3A Unactioned Status</fullName>
        <actions>
            <name>AU_Lead_Unactioned_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.AU_Application_Status__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Details_Complete__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Untouched</value>
        </criteriaItems>
        <description>Sets the Application Status to Unactioned if blank and Details Complete = False and Lead Status = Untouched</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU MVF Rule</fullName>
        <actions>
            <name>AU_MVF_Intro_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>AURecType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>2018-MP-EXPERTMARKET</value>
        </criteriaItems>
        <description>This rules sends a promotional email to the contact upon creation and changes the record type to AU Fuel</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AU Tag Beevo Leads</fullName>
        <actions>
            <name>Tag_Beevo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Adi Polugari</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU Tag Salmat Leads</fullName>
        <actions>
            <name>Tag_AU_Partner_Salmat</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Nitesh Basudkar</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU_TEMP_MVF_RecTypeToAUFuel</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>2018-MP-EXPERTMARKET</value>
        </criteriaItems>
        <description>Changes the record type to AU fuel when the lead source is 2018-MP-EXPERTMARKET</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Act On Lead Activity</fullName>
        <actions>
            <name>Follow_Up_Call_After_Email_Campaign_Action</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Act_On_Behavior_Score__c</field>
            <operation>greaterOrEqual</operation>
            <value>150</value>
        </criteriaItems>
        <description>If Act On Behavior Score reaches 150&gt;= then create an open task for the sales person to contact the record.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Assign Decision Maker</fullName>
        <actions>
            <name>Assign_Decision_Maker</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>If the lead has come from an online application form submission</description>
        <formula>Text(LeadSource) = &quot;Online Application Form&quot;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Assign Lead to Marketing Queue</fullName>
        <actions>
            <name>Record_Owner_Marketing_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Provider_Source__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Provider_Source__c</field>
            <operation>notEqual</operation>
            <value>Manual</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Assign_to_Rep__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>Assigns list loaded Leads to the Marketing Queue; excluded Parent Leads 3/19</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Card Program Text Field Lead</fullName>
        <actions>
            <name>Populate_Card_Program_WF_TXT_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Card_Program_TXT__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Need to populate a text version of the Card Program lookup field for use in sharing rules. (can&apos;t use lookup field or formula field.)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Channel Update</fullName>
        <actions>
            <name>Affinity_Channel_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Fleet_Channel_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Company</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Clear OBTM_Lead from Parent Leads</fullName>
        <actions>
            <name>Clear_OBTM_Lead_Owner_from_Parent_Leads</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OBTM_Lead__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>Clears the value of OBTM_Lead checkbox so subsequent child leads are not created with the OBTM checkbox populated.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Community%3A notify lead creator that submission recieved</fullName>
        <actions>
            <name>Community_Notify_partner_community_user_that_submitted_lead_has_been_recieved</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Generic Partner Profile,QuikTrip Partners,Alon Partners,Enterprise Partners,Phillips 66 Partners</value>
        </criteriaItems>
        <description>5/29/15 - PUT ON HOLD FOR NOW PER ERICA.  Workflow will fire an email alert to the partner community user that submits a lead to say we have received their lead</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Coupon Code Update</fullName>
        <actions>
            <name>Update_Coupon_Code_Text_from_Coupon_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR(Coupon_Code_2__c &lt;&gt; null, AND(ISCHANGED(Coupon_Code_2__c),PRIORVALUE(Coupon_Code_2__c)&lt;&gt;null))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Dummy-ms-sample New_Lead_Begin_Cycle</fullName>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3)</booleanFilter>
        <criteriaItems>
            <field>Lead.Call_Stage__c</field>
            <operation>notEqual</operation>
            <value>1st Call,Legacy</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Fleet Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <description>For newly created Fleet Leads, that are not Legacy imports, and not assigned to a queue, defaults first call stage task and updates next call date.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Email to Mastercard Manager</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Fleet One</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Product_Interest__c</field>
            <operation>equals</operation>
            <value>MC</value>
        </criteriaItems>
        <description>This workflow will send an e-mail to Monica Fallow when a referral comes in from Fleet One</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>First Activity Change Status to Working</fullName>
        <active>false</active>
        <description>Factoring Leads Only, change status to &apos;Working&apos; if contact has been made.</description>
        <formula>AND(

RecordTypeId = &apos;012700000005p5v&apos;,
NOT(ISBLANK(LastActivityDate))

)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>First Activity Logged</fullName>
        <actions>
            <name>Lead_Status_Contacting</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Wex Europe record types only</description>
        <formula>AND(

RecordTypeId = &apos;012700000005oZv&apos;,

NOT(ISBLANK(LastActivityDate))

)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Flip TB2B program Lead to TB2B record type</fullName>
        <actions>
            <name>Update_RT_to_Truckers</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.i2i_Coupon_Code_Pass__c</field>
            <operation>equals</operation>
            <value>TB2BW,TB2BELD,FTSELD,TB2BGP,TB2BGPSweeper,TB2BGold,EFSELD,EDGEGold,FTSGold</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead,Truckers - Leads</value>
        </criteriaItems>
        <description>this will flip the record type of an inserted child lead to the Truckers record type if the i2i pass value is TB2B</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Gold Internal W2L</fullName>
        <actions>
            <name>Call</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Leads</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Web to Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Hearsource__c</field>
            <operation>equals</operation>
            <value>EFS</value>
        </criteriaItems>
        <description>Gold Internal W2L from Truckers</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LDR Lead Queue Assignment</fullName>
        <actions>
            <name>Reassign_to_LDR_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>David Goodwin</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Coupon_Code_2__c</field>
            <operation>contains</operation>
            <value>EAT,T49,QWK,RYW,RJM,N4J,D3T,EG3,M9Q</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.i2i_Coupon_Code_Pass__c</field>
            <operation>contains</operation>
            <value>EAT,T49,QWK,RYW,RJM,N4J,D3T,EG3,M9Q</value>
        </criteriaItems>
        <description>Any lead that is loaded with David Goodwin&apos;s name, assign to LDR Queue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Background Notes to Opportunity</fullName>
        <actions>
            <name>Lead_Background_Notes_to_Opportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Disqualified Date</fullName>
        <actions>
            <name>Lead_Disqualified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Disqualified</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Email After VM</fullName>
        <actions>
            <name>Lead_voice_mail_follow_up_email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Fleet Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Call_Outcome__c</field>
            <operation>startsWith</operation>
            <value>Left Voicemail</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.HasOptedOutOfEmail</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Card_Program_TXT__c</field>
            <operation>notContain</operation>
            <value>Hess</value>
        </criteriaItems>
        <description>Auto sends an intro email when Call Outcome = Left message.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Name%2C Company%2C Program%2C and Coupon Code</fullName>
        <actions>
            <name>Name_Co_List_ID_Camp_Program_CC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Reached Decision Maker</fullName>
        <actions>
            <name>Next_Contact_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Last_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Lead.Call_Outcome__c</field>
            <operation>startsWith</operation>
            <value>Reached Decision Maker</value>
        </criteriaItems>
        <description>Updates Last Contact date and deletes Next Contact date when Call Outcome = Reached Decision Maker.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Status %3D Working</fullName>
        <active>false</active>
        <formula>AND( OR(Datevalue(CreatedDate)&lt;&gt;LastActivityDate,CreatedDate&lt;&gt; LastModifiedDate), NOT(ISPICKVAL( Status ,&quot;Working&quot;))  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead%3A Fleet One Source</fullName>
        <actions>
            <name>C_Wright_Lead_Campaign_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WEX_Universal_Program</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Fleet One</value>
        </criteriaItems>
        <description>If lead source = Fleet One update Text_Primary_Campaign__c with C-Wright Lead Record ID and Text_Program__c with wex universal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead_1st_Call_Stage</fullName>
        <actions>
            <name>Next_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Place_1st_Call</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Call_Stage__c</field>
            <operation>equals</operation>
            <value>1st Call</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Fleet Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <description>When Call Stage is changed to 1st Call, for Fleet Lead Rec Type only, rule creates open task, and updates Next Contact field. Excludes leads owned by Queues.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead_2nd_Call_Stage</fullName>
        <actions>
            <name>Update_Call_Cycle_2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Last_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Next_Contact_7_days</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Outcome</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Place_2nd_Call</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Call_Stage__c</field>
            <operation>equals</operation>
            <value>1st Call</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Call_Outcome__c</field>
            <operation>startsWith</operation>
            <value>Left Voicemail,No Answer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Fleet Lead</value>
        </criteriaItems>
        <description>Creates tasks and updates to begin lead qualification process</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead_3rd_Call_Stage</fullName>
        <actions>
            <name>Update_3rd_call</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Last_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Next_Contact_7_days</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Outcome</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Place_3rd_Call</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Call_Stage__c</field>
            <operation>equals</operation>
            <value>2nd Call</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Call_Outcome__c</field>
            <operation>startsWith</operation>
            <value>Left Voicemail,No Answer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Fleet Lead</value>
        </criteriaItems>
        <description>Creates tasks and updates to begin lead qualification process</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead_4th_Call_Stage</fullName>
        <actions>
            <name>Update_4th_Call</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Last_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Next_Contact_7_days</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Outcome</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Place_4th_Call</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Call_Stage__c</field>
            <operation>equals</operation>
            <value>3rd Call</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Call_Outcome__c</field>
            <operation>startsWith</operation>
            <value>Left Voicemail,No Answer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Fleet Lead</value>
        </criteriaItems>
        <description>Creates tasks and updates to begin lead qualification process</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead_5th_Call_Stage</fullName>
        <actions>
            <name>Update_5th_Call</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Last_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Next_Contact_7_days</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Outcome</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Place</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Call_Stage__c</field>
            <operation>equals</operation>
            <value>4th Call</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Call_Outcome__c</field>
            <operation>startsWith</operation>
            <value>Left Voicemail,No Answer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Fleet Lead</value>
        </criteriaItems>
        <description>Creates tasks and updates to begin lead qualification process</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead_6th_Call_Stage</fullName>
        <actions>
            <name>Update_Call_Stage_6</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Last_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Next_Contact_7_days</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Outcome</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Place_6th_Call</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Call_Stage__c</field>
            <operation>equals</operation>
            <value>5th Call</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Call_Outcome__c</field>
            <operation>startsWith</operation>
            <value>Left Voicemail,No Answer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Fleet Lead</value>
        </criteriaItems>
        <description>Creates tasks and updates to begin lead qualification process</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead_DONOTCALL</fullName>
        <actions>
            <name>Call_Cycle_NULL</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Next_Contact_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Status_Dead</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Outcome</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.DoNotCall</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Update owner to queue and kill lead, when prospect doens&apos;t want a call back</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead_End_Call_Stages</fullName>
        <actions>
            <name>Next_Contact_100_Days</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Call_Stage_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Last_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Outcome</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Status_Unqualified</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Place_1st_Call2</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Call_Stage__c</field>
            <operation>equals</operation>
            <value>6th Call</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Call_Outcome__c</field>
            <operation>startsWith</operation>
            <value>Left Voicemail,No Answer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Fleet Lead</value>
        </criteriaItems>
        <description>Creates tasks and updates to begin lead qualification process</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead_Update_Stage_Working</fullName>
        <actions>
            <name>Lead_Update_Status_Working</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Call_Stage__c</field>
            <operation>equals</operation>
            <value>1st Call</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Call_Outcome__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Fleet Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>notEqual</operation>
            <value>Dead,Not Ready To Buy</value>
        </criteriaItems>
        <description>Updates status to &quot;working&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MVF Email to Contact</fullName>
        <actions>
            <name>Email_sent_to_Contact_for_MMVF</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Coupon_Code_2__c</field>
            <operation>equals</operation>
            <value>MFG</value>
        </criteriaItems>
        <description>This rule send an email to the contact when the lead record is created for leads that come in from MVF</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>MVF Leads to Queue</fullName>
        <actions>
            <name>Update_Owner_to_MVF_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Lead.Coupon_Code_2__c</field>
            <operation>equals</operation>
            <value>QBW,Q7E</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.i2i_Coupon_Code_Pass__c</field>
            <operation>equals</operation>
            <value>QBW,Q7E</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>Route MVF leads to Queue for Omni</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Mobile Lead Assignment</fullName>
        <actions>
            <name>Lead_Owner_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Coupon_Code_2__c</field>
            <operation>equals</operation>
            <value>OCT</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Mobile</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New_Lead_Begin_Cycle</fullName>
        <actions>
            <name>Call_Stage_Place_1st_Call</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Next_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Place_1st_Call</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>7 AND (1 AND 2 AND 3 AND 4 AND 5) OR (6 AND 2 AND 3)</booleanFilter>
        <criteriaItems>
            <field>Lead.Call_Stage__c</field>
            <operation>notEqual</operation>
            <value>1st Call,Legacy,Import</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Fleet Lead,Asia Corporate Payments Lead,AU Corporate Payments Lead,EU Corporate Payments Lead,NA Corporate Payments Lead,WEX Payables,WEX Payables</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Product_Service_Type__c</field>
            <operation>notEqual</operation>
            <value>Permits</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>notEqual</operation>
            <value>Existing SFDC Record</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Call_Stage__c</field>
            <operation>equals</operation>
            <value>1st Call</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Owner_Profile__c</field>
            <operation>notContain</operation>
            <value>RTS Partners - F1</value>
        </criteriaItems>
        <description>For newly created Fleet Leads, that are not Legacy imports, and not assigned to a queue, and not a Permit lead, defaults first call stage task and updates next call date. Filter out Call Stage = &quot;Import&quot; for mass imports.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed Prepass Partner</fullName>
        <actions>
            <name>Tag_Partner_PrePass</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Travis Lehew</value>
        </criteriaItems>
        <description>F1 Partner Portal - PrePass</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to BSNF Fuel Card</fullName>
        <actions>
            <name>Tag_Partner_BSNF</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Owner_Profile__c</field>
            <operation>startsWith</operation>
            <value>BSNF</value>
        </criteriaItems>
        <description>F1 Partner Portal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to D%26S Fuel Card</fullName>
        <actions>
            <name>Tag_Partner_D_S_Fuel_Card</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Owner_Profile__c</field>
            <operation>startsWith</operation>
            <value>D&amp;S Fuel Card</value>
        </criteriaItems>
        <description>F1 Partner Portal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to D%26S Support</fullName>
        <actions>
            <name>Tag_Partner_D_S_Supoort</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>D&amp;S Support</value>
        </criteriaItems>
        <description>F1 Partner Portal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Discount Diesel Fuel Card</fullName>
        <actions>
            <name>Tag_Partner_Discount_Diesel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Owner_Profile__c</field>
            <operation>startsWith</operation>
            <value>Discount Diesel</value>
        </criteriaItems>
        <description>Discount Diesel F1 Partner Portal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to England Logistics</fullName>
        <actions>
            <name>Created_by_Partner_England_Logistics</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Kevin Ellis</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Steven Mouritsen</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Alex Weiche</value>
        </criteriaItems>
        <description>F1 Partner Portal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to GE Capital</fullName>
        <actions>
            <name>Tag_GE_Capital_Leads</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>John Conkin</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Kristin Larimore</value>
        </criteriaItems>
        <description>F1 Partner Portal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to NASTC</fullName>
        <actions>
            <name>Tag_Partner_NASTC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Owner_Profile__c</field>
            <operation>startsWith</operation>
            <value>NASTC</value>
        </criteriaItems>
        <description>F1 Partner Portal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Pavestone Capital</fullName>
        <actions>
            <name>Tag_Partner_Pavestone_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Pavestone Capital</value>
        </criteriaItems>
        <description>F1 Partner Portal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Quality Companies</fullName>
        <actions>
            <name>Tag_Partner_Quality_Companies</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Owner_Profile__c</field>
            <operation>startsWith</operation>
            <value>Quality Companies</value>
        </criteriaItems>
        <description>F1 Partner Portal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to RTS</fullName>
        <actions>
            <name>Tag_Partner_RTS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Rick Albright</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Roady%27s Card</fullName>
        <actions>
            <name>Tag_Partner_to_Roady_s_Card</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Roady&apos;s Card</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to STC Fuel Card</fullName>
        <actions>
            <name>Tag_Partner_STC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Owner_Profile__c</field>
            <operation>startsWith</operation>
            <value>STC</value>
        </criteriaItems>
        <description>STC F1 Partner Portal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Single Point Fuel Card</fullName>
        <actions>
            <name>Tag_Partner_Single_Point</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Owner_Profile__c</field>
            <operation>startsWith</operation>
            <value>Single</value>
        </criteriaItems>
        <description>Single Point F1 Partner Portal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Trans-Alliance</fullName>
        <actions>
            <name>Tag_Partner_Trans_Alliance</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Jessie Singh</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Trulos</fullName>
        <actions>
            <name>Partner_Tag_Trulos</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Winfield Rinkle</value>
        </criteriaItems>
        <description>F1 Partner Portal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Vessix Fuel Card</fullName>
        <actions>
            <name>Tag_Partner_Vessix</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Owner_Profile__c</field>
            <operation>startsWith</operation>
            <value>Vessix</value>
        </criteriaItems>
        <description>Vessix F1 Partner Portal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to WilcoHess</fullName>
        <actions>
            <name>Tag_Partner_Mike_Gordon</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Mike Gordon</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Pardot Form Completed</fullName>
        <actions>
            <name>Change_Owner_To_Pardot_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(
  OR(
    RecordType.DeveloperName = &apos;CorporatePay&apos;,
    RecordType.DeveloperName = &apos;Virtual&apos;
  ),
OR( Owner:User.UserRoleId  = &apos;00E70000001T1T4EAK&apos;,
    Owner:User.UserRoleId = &apos;00E70000001T0f4EAC&apos;
),
  Owner:User.IsActive = FALSE,
   ISCHANGED(Last_Form_Completion_Date__c),
  /*
  Rule should only be triggered if this is the first time it&apos;s been triggered in the past 90 days
  */
  NOT(PRIORVALUE(Last_Form_Completion_Date__c) &gt;= TODAY() - 90),
  Last_Form_Completion_Date__c &gt;= TODAY() - 90
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Card Program ID Local</fullName>
        <actions>
            <name>Card_Program_ID_Local</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Card_Program_WF_TXT_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Product_Service_Type__c</field>
            <operation>equals</operation>
            <value>Fleet Card - Direct Local</value>
        </criteriaItems>
        <description>If the Product/Service Type is Fleet Card - Direct Local, then Card Program ID is 0017000000un4U3.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Card Program ID OTR</fullName>
        <actions>
            <name>Card_Program_ID_OTR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Card_Program_WF_TXT_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Product_Service_Type__c</field>
            <operation>equals</operation>
            <value>Fleet Card - Direct OTR</value>
        </criteriaItems>
        <description>If the Product/Service Type is Fleet Card - Direct OTR then Card Program ID is 0017000000un4U1.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Product Interest Update</fullName>
        <actions>
            <name>Opportunity_Product_Interest_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Product_Interest__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prospect ID %26 Source %3D Manual</fullName>
        <actions>
            <name>Prospect_Id_Manual</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Provider_Source_Manual</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Coupon_Code_2__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Rapid email alert for new web leads</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Lead.qRouting__c</field>
            <operation>equals</operation>
            <value>WEBPAYCARDQ</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Activity to New Lead Owner</fullName>
        <actions>
            <name>New_Short_App_Lead</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>This workflow will send an activity to the new lead owner for leads in the &apos;Short App&apos; Queue.</description>
        <formula>AND( ISCHANGED(OwnerId), PRIORVALUE(OwnerId) =  &quot;00G70000001uAcF&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Total Vehicle Count</fullName>
        <active>false</active>
        <booleanFilter>1 or 2</booleanFilter>
        <criteriaItems>
            <field>Lead.Number_of_Tractors__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Number_of_Other_Fuel_Vehicles__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Tag 123Loadboard Leads</fullName>
        <actions>
            <name>Tag_Partner_123Loadboard</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>WILLIE ANDRUSS</value>
        </criteriaItems>
        <description>If 123Loadboard Partner User WILLIE ANDRUSS creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag 3MD Solutions Leads</fullName>
        <actions>
            <name>Set_created_by_3MD_parner_tag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Role_Name__c</field>
            <operation>contains</operation>
            <value>3MD</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag AAble iFleet Leads</fullName>
        <actions>
            <name>Tag_AAble_iFleet</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Role_Name__c</field>
            <operation>startsWith</operation>
            <value>Aable</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>If AAble iFleet  partner user creates a lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag AMBEST Leads</fullName>
        <actions>
            <name>Tag_Partner_Ambest</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Role_Name__c</field>
            <operation>startsWith</operation>
            <value>AMBEST</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>If AMBEST partner user creates a lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Advanced Commercial Credit Leads</fullName>
        <actions>
            <name>Tag_Partner_Advanced_Commercial_Credit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Rob Timmons</value>
        </criteriaItems>
        <description>If Advanced Commercial Credit Partner User Rob Timmons creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Aladdin Financial Leads</fullName>
        <actions>
            <name>Tag_Partner_Aladdin_Financial</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Jay Larson</value>
        </criteriaItems>
        <description>If Aladdin Financial Partner User Jay Larson creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag BSNF Fuel Card Leads</fullName>
        <actions>
            <name>Tag_Partner_BSNF</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Role_Name__c</field>
            <operation>startsWith</operation>
            <value>Bridgestone</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>If BSNF Fuel Card partner user creates a lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag CJM Financial Leads</fullName>
        <actions>
            <name>Tag_Partner_CJM_Financial</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>TRENT MURPHY</value>
        </criteriaItems>
        <description>If CJM Financial Partner User TRENT MURPHY creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag CarsArrive Leads</fullName>
        <actions>
            <name>set_Created_by_CarsArrive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>CarsArrive Fuel Card</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>If CarsArrive partner user creates a lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag CenterFire Leads</fullName>
        <actions>
            <name>Tag_CenterFire</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Justin Heim</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>If CenterFire partner user creates a lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Commercial Funding Leads</fullName>
        <actions>
            <name>Tag_Partner_Commercial_Funding</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Julie Murphy</value>
        </criteriaItems>
        <description>If Commercial Funding Partner User Julie Murphy creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag CoreFund Capital Leads</fullName>
        <actions>
            <name>Tag_Partner_CoreFund_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Bonnie Castillo</value>
        </criteriaItems>
        <description>If CoreFund Capital Partner User Bonnie Castillo creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag D%26S Fuel Card Leads</fullName>
        <actions>
            <name>Tag_Partner_D_S_Fuel_Card</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Role_Name__c</field>
            <operation>startsWith</operation>
            <value>D&amp;S Fuel Card</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>If D&amp;S Fuel Card partner user creates a lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag DAT Leads</fullName>
        <actions>
            <name>Tag_Partner_DAT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Bert Goo</value>
        </criteriaItems>
        <description>If DAT User Bert Goo creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Discount Diesel Fuel Card Leads</fullName>
        <actions>
            <name>Tag_Partner_Discount_Diesel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Role_Name__c</field>
            <operation>startsWith</operation>
            <value>Discount Diesel</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>If Discount Diesel Fuel Card partner user creates a lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag ECAPITAL Leads</fullName>
        <actions>
            <name>Tag_Partner_ECAPITAL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Raul Pena</value>
        </criteriaItems>
        <description>If ECAPITAL Partner User  Raul Pena creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag England Logistics Leads</fullName>
        <actions>
            <name>Created_by_Partner_England_Logistics</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Role_Name__c</field>
            <operation>startsWith</operation>
            <value>England Logistics</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>If England Logistics partner user creates a lead</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Tag Engs Commercial Capital Leads</fullName>
        <actions>
            <name>Tag_Partner_ENGS_Commercial_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Leslye Campos</value>
        </criteriaItems>
        <description>If Engs Commercial Capital Partner User Leslye Campos creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Envio 360 Leads</fullName>
        <actions>
            <name>Tag_Partner_Envio_360</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Larry Cuddy</value>
        </criteriaItems>
        <description>If Envio 360 Partner User Larry Cuddy creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Express Freight Leads</fullName>
        <actions>
            <name>Tag_Partner_Express_Freight_Finance</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Bryan Doty</value>
        </criteriaItems>
        <description>If Express Freight Partner User Bryan Doty creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Express Truck Tax Leads</fullName>
        <actions>
            <name>Express_Truck_Tax</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Role_Name__c</field>
            <operation>startsWith</operation>
            <value>SPAN</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>If Express Truck Tax partner user creates a lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Far West Capital Leads</fullName>
        <actions>
            <name>Tag_Partner_Far_West_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Brenda Pinon</value>
        </criteriaItems>
        <description>If Far West Capital Partner User Brenda Pinon creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag FedEx Custom Critical Leads</fullName>
        <actions>
            <name>Tag_Partner_FedEx_Custom_Critical</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>MARIANNE TAMMINEN</value>
        </criteriaItems>
        <description>If FedEx Custom Critical Partner User MARIANNE TAMMINEN creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Financial Carrier Service Leads</fullName>
        <actions>
            <name>Tag_Partner_Financial_Carrier_Service</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Alex Kelis</value>
        </criteriaItems>
        <description>If Financial Carrier Service Partner User Alex Kelis creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Fleet Savings Leads</fullName>
        <actions>
            <name>Set_created_by_Fleet_Savings_Partner_Tag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Role_Name__c</field>
            <operation>contains</operation>
            <value>Fleet Savings</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag FleetPro Services Leads</fullName>
        <actions>
            <name>Set_created_by_FleetPro_Partner_Tag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Owner_Profile__c</field>
            <operation>startsWith</operation>
            <value>FleetPro Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>If FleetPro Services partner user creates a lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Foley Carrier Services Leads</fullName>
        <actions>
            <name>Tag_Partner_Foley_Carrier_Services</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Matt Nulle</value>
        </criteriaItems>
        <description>If Foley Carrier Services Partner User Matt Nulle creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Freight Factoring Special Leads</fullName>
        <actions>
            <name>Tag_Partner_Freight_Factoring_Special</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Steven Newman</value>
        </criteriaItems>
        <description>If Freight Factoring Special Partner User Steven Newman creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Fuelbook Leads</fullName>
        <actions>
            <name>set_Created_by_to_Fuelbook</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Tom Moreland</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>If Fuelbook partner user creates a lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag G%2EH%2E Factor Leads</fullName>
        <actions>
            <name>Tag_Partner_G_H_Factor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Karla Revilla</value>
        </criteriaItems>
        <description>If G.H. Factor Partner User Karla Revilla creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag GE Capital Leads</fullName>
        <actions>
            <name>Tag_GE_Capital_Leads</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) and 3</booleanFilter>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>John Conkin</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Kristin Larimore</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>If GE Capital partner user creates a lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Great Plains Leads</fullName>
        <actions>
            <name>Tag_Partner_Great_Plains</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Jerry Van Wyk</value>
        </criteriaItems>
        <description>If Great Plains Partner User Jerry Van Wyk creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag InTouch GPS Leads</fullName>
        <actions>
            <name>Tag_Partner_Intouch_GPS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Role_Name__c</field>
            <operation>startsWith</operation>
            <value>InTouch GPS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>If InTouch GPS partner user creates a lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Integra Leads</fullName>
        <actions>
            <name>Tag_Partner_Integra</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Kyle Klatzkin</value>
        </criteriaItems>
        <description>If Integra Partner User Kyle Klatzkin creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Integrated Logistics Leads</fullName>
        <actions>
            <name>Tag_Partner_Integrated_Logistics</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Amanda Keller</value>
        </criteriaItems>
        <description>If Integrated Logistics Partner User Amanda Keller creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Interstate Capital Leads</fullName>
        <actions>
            <name>Tag_Partner_Interstate_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Sarah Williams</value>
        </criteriaItems>
        <description>If Interstate Capital Partner User Sarah Williams creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag JB Hunt Leads</fullName>
        <actions>
            <name>Tag_Partner_JB_Hunt</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Mandy Robinson</value>
        </criteriaItems>
        <description>If JB Hunt Partner User Mandy Robinson creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag JD Factors Leads</fullName>
        <actions>
            <name>Tag_Partner_JD_Factors</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>CHIP WILEY</value>
        </criteriaItems>
        <description>If JD Factors Partner User CHIP WILEY creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Jessie Singh Leads</fullName>
        <actions>
            <name>Tag_Partner_Trans_Alliance</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Jessie Singh</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>If Trans-Alliance Partner User Jessie Singh creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Knight Logistics Leads</fullName>
        <actions>
            <name>Tag_Knight_Logistics_Leads</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Role_Name__c</field>
            <operation>contains</operation>
            <value>Knight Logistics</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>Tag Knight Logistics Leads</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Liquid Capital Leads</fullName>
        <actions>
            <name>Tag_Partner_Liquid_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Ernane Iung</value>
        </criteriaItems>
        <description>If Liquid Capital Partner User Ernane Iung creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Mansfield Oil Company Leads</fullName>
        <actions>
            <name>Tag_Mansfield_Oil_Company_Leads</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Role_Name__c</field>
            <operation>contains</operation>
            <value>Mansfield</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Mike Gordon Leads</fullName>
        <actions>
            <name>Tag_Partner_Mike_Gordon</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Mike Gordon</value>
        </criteriaItems>
        <description>If WilcoHess partner Mike Gordon creates a lead.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Tag NASTC Leads</fullName>
        <actions>
            <name>Tag_Partner_NASTC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Role_Name__c</field>
            <operation>startsWith</operation>
            <value>NASTC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>F1 Partner Portal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag OTR Capital Leads</fullName>
        <actions>
            <name>Tag_Partner_OTR_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Cody Barwig</value>
        </criteriaItems>
        <description>If OTR Capital Partner User Cody Barwig creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag PTP Stop NATSN Leads</fullName>
        <actions>
            <name>Tag_PTP_Stop_NATSN</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Role_Name__c</field>
            <operation>contains</operation>
            <value>PTP Stop NATSN</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>Tag PTP Stop NATSN Leads</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Parikh Financial Leads</fullName>
        <actions>
            <name>Tag_Partner_Parikh_Financial</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Raj Parikh</value>
        </criteriaItems>
        <description>If Parikh Financial Partner User Raj Parikh creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Partners Funding Leads</fullName>
        <actions>
            <name>Tag_Partner_Partners_Funding</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Patti Mielke</value>
        </criteriaItems>
        <description>If Partners Funding Partner User Patti Mielke creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Patriot Fleet Solutions Leads</fullName>
        <actions>
            <name>Tag_Patriot_Fleet_Systems</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Role_Name__c</field>
            <operation>contains</operation>
            <value>Peoplease</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>Tag Patriot Fleet Solutions Partner</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Pay4Freight Leads</fullName>
        <actions>
            <name>Tag_Partner_Pay4Freight</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Robert Beard</value>
        </criteriaItems>
        <description>If Pay4Freight Partner User Robert Beard creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Petro Solutions Leads</fullName>
        <actions>
            <name>Tag_Partner_Petro_Solutions</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Chuck Miller</value>
        </criteriaItems>
        <description>If Petro Solutions Partner User Chuck Miller creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag PrePass Leads</fullName>
        <actions>
            <name>Tag_Partner_PrePass</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Travis Lehew</value>
        </criteriaItems>
        <description>If RTS Partner User Travis creates a lead.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Tag Quality Companies Leads</fullName>
        <actions>
            <name>Tag_Partner_Quality_Companies</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Role_Name__c</field>
            <operation>startsWith</operation>
            <value>Quality Companies</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>If Quality Companies partner user creates a lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Quick Pay Funding Leads</fullName>
        <actions>
            <name>Tag_Partner_Quick_Pay_Funding</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>JUAN ESTRADA</value>
        </criteriaItems>
        <description>If Quick Pay Funding Partner User JUAN ESTRADA creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag STC Fuel Card Leads</fullName>
        <actions>
            <name>Tag_Partner_STC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Role_Name__c</field>
            <operation>startsWith</operation>
            <value>STC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>If STC Fuel Card partner user creates a lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag SUMMAR Leads</fullName>
        <actions>
            <name>Tag_Partner_SUMMAR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Jessi Saker</value>
        </criteriaItems>
        <description>If SUMMAR Partner User Jessi Saker creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Single Point Fuel Card Leads</fullName>
        <actions>
            <name>Tag_Partner_Single_Point</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Role_Name__c</field>
            <operation>startsWith</operation>
            <value>Single</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>If Single Point Fuel Card partner user creates a lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag St Johns Leads</fullName>
        <actions>
            <name>Tag_Partner_St_Johns</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Christina Kordik</value>
        </criteriaItems>
        <description>If St Johns Partner User Christina Kordik creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Steelhead Leads</fullName>
        <actions>
            <name>Tag_Partner_Steelhead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Rich Templeton</value>
        </criteriaItems>
        <description>If Steelhead Partner User Rich Templeton creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Sunbelt Leads</fullName>
        <actions>
            <name>Tag_Partner_Sunbelt</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Debbie Kimberland</value>
        </criteriaItems>
        <description>If Sunbelt Partner User Debbie Kimberland creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag TBS Factoring Service Leads</fullName>
        <actions>
            <name>Tag_TBS_Factoring_Service</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Role_Name__c</field>
            <operation>contains</operation>
            <value>TBS Factoring Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>Tag TBS Factoring Service</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag TRANSPORT FINANCIAL SOLUTIONS Leads</fullName>
        <actions>
            <name>Tag_Partner_TRANSPORT_FINANCIAL_SOLUTIO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Sheri Breedlove</value>
        </criteriaItems>
        <description>If TRANSPORT FINANCIAL SOLUTIONS Partner User Sheri Breedlove creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag TRIUMPH Leads</fullName>
        <actions>
            <name>Tag_Partner_TRIUMPH_BUSINESS_CAPITAL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Ray Workman</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Jason Mullican</value>
        </criteriaItems>
        <description>If TRIUMPH BUSINESS CAPITAL LLC Partner User Ray Workman or Jason Mullican creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Thunder Carrier Services Leads</fullName>
        <actions>
            <name>Tag_Partner_Thunder_Carrier_Services</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Willie Andruss</value>
        </criteriaItems>
        <description>If Thunder Carrier Services Partner User Willie Andruss creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Truckers B2B Leads</fullName>
        <actions>
            <name>Tag_Partner_Truckers_B2B</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Role_Name__c</field>
            <operation>startsWith</operation>
            <value>Truckers B2B</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>F1 Partner Portal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Truckers Solutions Leads</fullName>
        <actions>
            <name>Tag_Partner_Truckers_Solutions</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Dennis Woods</value>
        </criteriaItems>
        <description>If Truckers Solutions Partner User Dennis Woods creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Trulos Leads</fullName>
        <actions>
            <name>Partner_Tag_Trulos</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Winfield Rinkle</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>If Trulos partner user creates a lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Vero Business Capital Leads</fullName>
        <actions>
            <name>Tag_Partner_Vero_Business_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Trey Heath</value>
        </criteriaItems>
        <description>If Vero Business Capital Partner User Trey Heath creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Vessix Fuel Card Leads</fullName>
        <actions>
            <name>Tag_Partner_Vessix</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Role_Name__c</field>
            <operation>startsWith</operation>
            <value>Vessix</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>If Vessix Fuel Card partner user creates a lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag XPO Logistics Leads</fullName>
        <actions>
            <name>Tag_XPO_Logistics</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Role_Name__c</field>
            <operation>startsWith</operation>
            <value>XPO Logistics</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <description>F1 Partner Portal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Xfactors Leads</fullName>
        <actions>
            <name>Tag_Partner_Xfactors</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>JEFFREY COLBURN</value>
        </criteriaItems>
        <description>If Xfactors Partner User JEFFREY COLBURN creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag iThrive Funding Leads</fullName>
        <actions>
            <name>Tag_Partner_iThrive_Funding</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Robert Marker</value>
        </criteriaItems>
        <description>If iThrive Funding Partner User Robert Marker creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Task Created when Lead Disqualified</fullName>
        <actions>
            <name>Lead_Disqualified</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Disqualified</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Aquarient Sales,System Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Last Contact</fullName>
        <actions>
            <name>Update_Last_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Call_Outcome__c</field>
            <operation>startsWith</operation>
            <value>No Answer,Left Voicemail</value>
        </criteriaItems>
        <description>Updates last contact when user inputs the outcome of the existing call attempt.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Updated hidden Prospect Id and Provider Source</fullName>
        <actions>
            <name>Prospect_Id_to_Opp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Provider_Source_to_Opp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>So those values can be sent to the Opportunity on Lead Conversion</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WEBISSQ for NFIB S4M Group Nashville</fullName>
        <actions>
            <name>Assign_to_Fleet_Outbound_Sales_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 and 3 and 4 and 5</booleanFilter>
        <criteriaItems>
            <field>Lead.qRouting__c</field>
            <operation>equals</operation>
            <value>WEBISSQ</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.i2i_Coupon_Code_Pass__c</field>
            <operation>notContain</operation>
            <value>EQR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Untouched</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Description</field>
            <operation>contains</operation>
            <value>National Federation of Independent Business</value>
        </criteriaItems>
        <description>Route NFIB leads to Nashville team through Omni</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WEBOBSQ Leads to W2L Fleet Outbound Sales Queue</fullName>
        <actions>
            <name>Assign_to_Fleet_Outbound_Sales_Q</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 and (2 and 3 and 4 and 5)</booleanFilter>
        <criteriaItems>
            <field>Lead.qRouting__c</field>
            <operation>equals</operation>
            <value>WEBOBSQ</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.i2i_Coupon_Code_Pass__c</field>
            <operation>notContain</operation>
            <value>EQR,QBW,Q7E,WQM</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Untouched</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Parent Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Coupon_Code_2__c</field>
            <operation>notEqual</operation>
            <value>LB1,LB2,LB3,LB4,LB5,LB6,LB7,LB8,LB9</value>
        </criteriaItems>
        <description>Leads that come in the qRouting WEBOBSQ need to go to Nashville Team Queue for Omni Channel Routing. This is a workaround for Lead Assignment rule that is not firing (investigating)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Call Outcome Logged</fullName>
        <actions>
            <name>WES_Add_to_Call_Outreach_Total</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Reset_Call_Outcome</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Reset_Callback_Comments</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Set_Disqualified_Reason_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Set_Disqualified_Reason_2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Set_Last_Call_Outcome_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Update_Last_Call_Outcome</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Call_Outcome__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Change Lead Status to Disqualified</fullName>
        <actions>
            <name>WES_Change_Lead_Status_to_Disqualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Call_Outcome__c</field>
            <operation>equals</operation>
            <value>Not Interested,Invalid,Barred,Existing Customer,Unreachable,Incorrect country,Test Lead</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Change Lead Status to Working</fullName>
        <actions>
            <name>Set_Lead_Status_to_Working</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Call_Outcome__c</field>
            <operation>equals</operation>
            <value>Unanswered,Callback</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>WES Lead</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Clear Callback Time</fullName>
        <actions>
            <name>WES_Reset_Callback_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 
ISCHANGED(Call_Outcome__c), 
TEXT(Call_Outcome__c) &lt;&gt; &quot;Callback&quot;, 
TEXT(Call_Outcome__c) &lt;&gt; &quot;Unanswered&quot;	
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Reset Sub-Statuses</fullName>
        <actions>
            <name>WES_Reset_Sub_Status_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Reset_Sub_Status_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( 
ISCHANGED(WES_Disqualified_Reason1__c), 
ISCHANGED(WES_Disqualified_Reason2__c) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Set Default Callback Time</fullName>
        <actions>
            <name>WES_Set_Callback_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TEXT(Call_Outcome__c) = &quot;Unanswered&quot; 
&amp;&amp; ( 
ISBLANK(WES_Call_Back_Time__c) || 
WES_Call_Back_Time__c &lt;= (NOW() + 1/6) 
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Update Billing Address</fullName>
        <actions>
            <name>WES_Set_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Set_Trading_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Set_Trading_County</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Set_Trading_Postcode</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Set_Trading_Town</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 
RecordType.DeveloperName = &quot;WES_Lead&quot;, 
OR( 
ISCHANGED(WES_Address_Line1__c), 
ISCHANGED(WES_Address_Line2__c), 
ISCHANGED(WES_Address_Line3__c),	
ISCHANGED(WES_Trading_Town__c), 
ISCHANGED(WES_TradingPostcode__c), 
ISCHANGED(WES_Trading_County__c)	
) || 
AND( 
NOT(ISBLANK(WES_Address_Line1__c)), 
NOT(ISBLANK(WES_Trading_Town__c)), 
NOT(ISBLANK(WES_TradingPostcode__c)),	
ISBLANK(Street), 
ISBLANK(City), 
ISBLANK(PostalCode) 
) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES Set Diesel used %2F month %28GBP%29</fullName>
        <actions>
            <name>WES_Set_Diesel_used_month_GBP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets Diesel used per month based on Litres if Litres are set but GBP is blank.</description>
        <formula>AND( 
ISNEW(), 
NOT(ISBLANK(WES_Diesel_per_month_Litres__c)), 
ISBLANK(WES_Diesel_per_month_GBP__c) 
) || 
AND(	
ISCHANGED(WES_Diesel_per_month_Litres__c), 
NOT(ISCHANGED(WES_Diesel_per_month_GBP__c)) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES Set Diesel used %2F month %28Litres%29</fullName>
        <actions>
            <name>WES_Set_Diesel_used_month_Litres</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 
ISNEW(), 
NOT(ISBLANK(WES_Diesel_per_month_GBP__c)), 
ISBLANK(WES_Diesel_per_month_Litres__c) 
) || 
AND(	
ISCHANGED(WES_Diesel_per_month_GBP__c), 
NOT(ISCHANGED(WES_Diesel_per_month_Litres__c)) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES Set Petrol used %2F month %28GBP%29</fullName>
        <actions>
            <name>WES_Set_Petrol_used_month_GBP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 
ISNEW(), 
NOT(ISBLANK(WES_Petrol_used_per_month_Litres__c)),	
ISBLANK(WES_Petrol_used_per_month_GBP__c) 
) || 
AND( 
ISCHANGED(WES_Petrol_used_per_month_Litres__c),	
NOT(ISCHANGED(WES_Petrol_used_per_month_GBP__c)) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES Set Petrol used %2F month %28Litres%29</fullName>
        <actions>
            <name>WES_Set_Petrol_used_month_Litres</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 
ISNEW(), 
NOT(ISBLANK(WES_Petrol_used_per_month_GBP__c)),	
ISBLANK(WES_Petrol_used_per_month_Litres__c) 
) || 
AND( 
ISCHANGED(WES_Petrol_used_per_month_GBP__c),	
NOT(ISCHANGED(WES_Petrol_used_per_month_Litres__c)) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WEX Facebook Leads</fullName>
        <actions>
            <name>WEX_Facebeok_Leads</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Coupon_Code_2__c</field>
            <operation>equals</operation>
            <value>K62</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Wright Lead Record Type</fullName>
        <actions>
            <name>Record_Type_Wright_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Gulf OBS Queue,Conoco OBS Queue,Sunoco OBS Queue</value>
        </criteriaItems>
        <description>When the Lead Source equals Conoco OBS Queue,Gulf OBS Queue,Sunoco OBS Queue change the record type to Wright Leads</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>set Card Product - Local</fullName>
        <active>false</active>
        <description>If “# of 18 Wheelers” is less than “# of Other Fuel Vehicles” 
then “Card Product” = Local</description>
        <formula>Number_of_Tractors__c &lt; Number_of_Other_Fuel_Vehicles__c</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>set Card Product - OTR</fullName>
        <active>false</active>
        <description>If “# of 18 Wheelers” is greater than or equal to “# of Other Fuel Vehicles” 
then “Card Product” = OTR</description>
        <formula>Number_of_Tractors__c &gt;=  Number_of_Other_Fuel_Vehicles__c</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>set Lead Source Website - Oppt</fullName>
        <actions>
            <name>set_Lead_Source_Website_Oppt</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Source_Website__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Call</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please reach out immediately on this new Gold lead from EFS ISR.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Lead.CreatedDate</offsetFromField>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Call</subject>
    </tasks>
    <tasks>
        <fullName>Follow_Up_Call_After_Email_Campaign_Action</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Follow Up Call After Email Campaign Action</subject>
    </tasks>
    <tasks>
        <fullName>Lead_Disqualified</fullName>
        <assignedToType>owner</assignedToType>
        <description>Lead Disqualified</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Lead.Lead_Disqualified_Date__c</offsetFromField>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Lead Disqualified</subject>
    </tasks>
    <tasks>
        <fullName>New_Short_App_Lead</fullName>
        <assignedToType>owner</assignedToType>
        <description>You have been assigned a new Short App Lead.</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>New Short App Lead</subject>
    </tasks>
    <tasks>
        <fullName>Place</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Place 5th Call</subject>
    </tasks>
    <tasks>
        <fullName>Place_1st_Call</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Place 1st Call</subject>
    </tasks>
    <tasks>
        <fullName>Place_1st_Call2</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>100</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Place 1st Call (New Cycle)</subject>
    </tasks>
    <tasks>
        <fullName>Place_2nd_Call</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Place 2nd Call</subject>
    </tasks>
    <tasks>
        <fullName>Place_3rd_Call</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Place 3rd Call</subject>
    </tasks>
    <tasks>
        <fullName>Place_4th_Call</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Place 4th Call</subject>
    </tasks>
    <tasks>
        <fullName>Place_6th_Call</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Place 6th Call</subject>
    </tasks>
</Workflow>
