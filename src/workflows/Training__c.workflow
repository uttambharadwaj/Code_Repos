<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Follow Up Task After Training</fullName>
        <actions>
            <name>Follow_Up_with_Training_Attendees</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Training__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>PayCard</value>
        </criteriaItems>
        <criteriaItems>
            <field>Training__c.Follow_Up_Date__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>PayCard Follow-up Task 10 days after training</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Training Activity</fullName>
        <actions>
            <name>Training_Scheduled</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Training__c.Status__c</field>
            <operation>equals</operation>
            <value>Cancelled,Planned,Rescheduled,Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Training__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>General</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Follow_Up_with_Training_Attendees</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please follow-up with each client that attended the Training.</description>
        <dueDateOffset>15</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Training__c.Training_End_Date__c</offsetFromField>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Follow Up with Training Attendees</subject>
    </tasks>
    <tasks>
        <fullName>Training_Scheduled</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Training__c.CreatedDate</offsetFromField>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Training Scheduled</subject>
    </tasks>
</Workflow>
