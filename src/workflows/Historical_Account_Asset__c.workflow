<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Gallons_Asset_Update</fullName>
        <field>Gallons_per_Month__c</field>
        <formula>Gallons__c</formula>
        <name>Gallons Asset Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account_Asset_MD__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>of_Cards_Update</fullName>
        <field>of_Cards__c</field>
        <formula>of_Cards__c</formula>
        <name># of Cards Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account_Asset_MD__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Account Asset Update</fullName>
        <actions>
            <name>Gallons_Asset_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>of_Cards_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Historical_Account_Asset__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
