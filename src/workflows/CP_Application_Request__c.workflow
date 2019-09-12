<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Decisioned_Email_Alert_CP_App_Request</fullName>
        <description>Decisioned Email Alert CP App Request</description>
        <protected>false</protected>
        <recipients>
            <field>Partner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CorporatePayments_Appilcation_Request/Credit_Decision_CP_App_Request</template>
    </alerts>
    <fieldUpdates>
        <fullName>CP_Program_Name</fullName>
        <field>Program_WF_TEXT__c</field>
        <formula>Program__r.Name</formula>
        <name>CP Program Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>In_Progress_User</fullName>
        <field>In_Progress_User__c</field>
        <formula>$User.FirstName+&quot; &quot;+$User.LastName</formula>
        <name>In Progress User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Financial_Form_Uploaded_Checkbox</fullName>
        <field>Financial_Forms_Uploaded__c</field>
        <literalValue>1</literalValue>
        <name>Update Financial Form Uploaded Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Financials_uploaded_Checkbox</fullName>
        <field>Financial_Forms_Uploaded__c</field>
        <literalValue>1</literalValue>
        <name>Update Financials uploaded Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>set_In_Progress_user_CP</fullName>
        <field>In_Progress_User__c</field>
        <formula>$User.FirstName+&quot; &quot;+$User.LastName</formula>
        <name>set In Progress user</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Alert CorpPayment App Owner Financials uploaded</fullName>
        <actions>
            <name>Update_Financial_Form_Uploaded_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2 OR 3 OR 4</booleanFilter>
        <criteriaItems>
            <field>CP_Application_Request__c.Voided_Check__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>CP_Application_Request__c.Audited_Financials__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>CP_Application_Request__c.Copy_of_Driver_s_License__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>CP_Application_Request__c.Direct_Debit_Form__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This rule will update the CorporatePayments Application Request owner when the financial information is uploaded</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Decisioned Email Alert CP App Request</fullName>
        <actions>
            <name>Decisioned_Email_Alert_CP_App_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>email is sent to when app status = decisioned</description>
        <formula>AND(ISPICKVAL(Status__c, &quot;Decisioned&quot;),   Owner:User.Alias &lt;&gt; &quot;sinte&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Financials Uploaded Alert</fullName>
        <actions>
            <name>Update_Financials_uploaded_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Financial_Documents_have_been_received</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>AND (NOT($Setup.Automation_Settings__c.Disable_Workflow_Rules__c) &amp;&amp;   Credit_Line_Requested__c  &gt; 150000 &amp;&amp;  Voided_Check__c = TRUE ||  Audited_Financials__c = TRUE ||  Copy_of_Driver_s_License__c  = TRUE ||   Direct_Debit_Form__c  = TRUE &amp;&amp; Financial_Forms_Uploaded__c  = FALSE &amp;&amp;  NOT(Owner:User.Alias=&apos;sinte&apos;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>In Progress User</fullName>
        <actions>
            <name>In_Progress_User</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CP_Application_Request__c.In_Progress__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When a user checks this box it popluates their user record in the In Progress User field.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Partner Name Update</fullName>
        <actions>
            <name>CP_Program_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CP_Application_Request__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This rule up</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Site Visit Required</fullName>
        <actions>
            <name>Site_Visit_Required</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>AND( NOT($Setup.Automation_Settings__c.Disable_Workflow_Rules__c), Credit_Line_Requested__c  &gt; 100000, NOT(Owner:User.Alias=&apos;sinte&apos;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>set In Progress user</fullName>
        <actions>
            <name>set_In_Progress_user_CP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CP_Application_Request__c.In_Progress__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Financial_Documents_have_been_received</fullName>
        <assignedToType>owner</assignedToType>
        <description>Financial Documents have been received.</description>
        <dueDateOffset>90</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>4-Medium</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Financial Documents have been received</subject>
    </tasks>
    <tasks>
        <fullName>Site_Visit_Required</fullName>
        <assignedToType>owner</assignedToType>
        <description>An opportunity is created with a large credit request. A site visit is required before approval.</description>
        <dueDateOffset>90</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>4-Medium</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Site Visit Required</subject>
    </tasks>
</Workflow>
