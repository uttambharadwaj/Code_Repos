<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Handover_Checklist_Completed</fullName>
        <field>Handover_Checklist_Status__c</field>
        <literalValue>Checklist Completed</literalValue>
        <name>Handover Checklist Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Project__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Handover_Checklist_Created</fullName>
        <field>Handover_Checklist_Status__c</field>
        <literalValue>Record Created</literalValue>
        <name>Handover Checklist Created</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Project__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Handover Checklist Completed</fullName>
        <actions>
            <name>Handover_Checklist_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Handover_Checklist__c.Checklist_Complete__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Handover Checklist Created</fullName>
        <actions>
            <name>Handover_Checklist_Created</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Handover_Checklist__c.CreatedDate</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
