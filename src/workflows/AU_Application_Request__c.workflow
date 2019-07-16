<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AU_Partner_Created_by_TRIUMPH</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;TRIUMPH BUSINESS CAPITAL&quot;</formula>
        <name>AU Partner - Created by TRIUMPH</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AU Partner - Created by Beevo</fullName>
        <actions>
            <name>AU_Partner_Created_by_Beevo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AU_Application_Request__c.CreatedById</field>
            <operation>equals</operation>
            <value>Cat Bleach</value>
        </criteriaItems>
        <description>If created by Cat Bleach then set Created by Partner Tag to Beevo.  (for sharing rules)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
