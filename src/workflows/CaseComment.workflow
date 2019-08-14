<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Make_Comment_Public</fullName>
        <field>IsPublished</field>
        <literalValue>1</literalValue>
        <name>Make Comment Public</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stop_SLA_Timer_CS_Comment</fullName>
        <field>IsStopped</field>
        <literalValue>1</literalValue>
        <name>Stop SLA Timer - CS Comment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>New Comment</fullName>
        <actions>
            <name>Make_Comment_Public</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Parent.RecordTypeId = &apos;012700000005x2r&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
