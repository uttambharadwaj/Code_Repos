<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Change_Owner_to_Factoring_Queue</fullName>
        <description>Upon creation of a Factory Underwriting record ownership is changed to Factory Underwriting queue</description>
        <field>OwnerId</field>
        <lookupValue>Factoring_Underwriting</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Owner to Factoring Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Assign Ownership to Queue</fullName>
        <actions>
            <name>Change_Owner_to_Factoring_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a Factoring Underwriting record is first created, ownership is assigned to the Factory Underwriting queue</description>
        <formula>ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
