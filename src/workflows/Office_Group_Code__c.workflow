<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Office_Group_Code_Name_Unique</fullName>
        <field>Office_Group_Code_Name_Unique__c</field>
        <formula>Name + Program__r.Id</formula>
        <name>Office Group Code Name Unique</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Group Code Name Unique</fullName>
        <actions>
            <name>Office_Group_Code_Name_Unique</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Office_Group_Code__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
