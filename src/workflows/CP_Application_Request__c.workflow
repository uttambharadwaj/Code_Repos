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
        <fullName>set_In_Progress_user_CP</fullName>
        <field>In_Progress_User__c</field>
        <formula>$User.FirstName+&quot; &quot;+$User.LastName</formula>
        <name>set In Progress user</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
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
</Workflow>
