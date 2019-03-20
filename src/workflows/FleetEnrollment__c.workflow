<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Fleet_Enrollment_Notification</fullName>
        <ccEmails>Bocafleetdata@wexinc.com</ccEmails>
        <description>Fleet Enrollment Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>derek.gilbert@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>BOCA/FleetDataCaptureFormNotify</template>
    </alerts>
    <fieldUpdates>
        <fullName>Fleet_Enrollment_Update_Completed_Date</fullName>
        <description>Update the completed date to today when the Status is changed to completed</description>
        <field>Completed_Date__c</field>
        <formula>TODAY()</formula>
        <name>Fleet Enrollment Update Completed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Fleet Enrollment New Submission</fullName>
        <actions>
            <name>Fleet_Enrollment_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>FleetEnrollment__c.Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Fleet Enrollment Update Completed Date</fullName>
        <actions>
            <name>Fleet_Enrollment_Update_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>FleetEnrollment__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
