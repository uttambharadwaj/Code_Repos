<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Events_Comment_Update</fullName>
        <field>Comments__c</field>
        <formula>Description</formula>
        <name>Events Comment Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Expose_Event_Public</fullName>
        <description>Flags the event as public</description>
        <field>IsVisibleInSelfService</field>
        <literalValue>1</literalValue>
        <name>Expose Event Public</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Community%3A Expose Event Public</fullName>
        <actions>
            <name>Expose_Event_Public</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Event.CreatedDate</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Mark Events public so that they may been seen by community members</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Events Comment Update</fullName>
        <actions>
            <name>Events_Comment_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(

  /* Original workflow rule criteria */
  NOT(ISBLANK(OwnerId)),

  /* Wex Europe edit - field update shouldn&apos;t apply to Wex Europe users - prevents calendar items with more than 255 characters being synced into events using Salesforce for Outlook
  */
  NOT($Setup.VProfileId__c.Virtual_User__c = TRUE)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
