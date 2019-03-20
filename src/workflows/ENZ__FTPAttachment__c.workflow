<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>Attachment_Message_Sent_to_WOL_NP</fullName>
        <apiVersion>20.0</apiVersion>
        <endpointUrl>https://wexfleet.wexapi.com/salesforceoutboundservice</endpointUrl>
        <fields>Application_Request__c</fields>
        <fields>CreatedById</fields>
        <fields>ENZ__Bytes__c</fields>
        <fields>ENZ__File__c</fields>
        <fields>ENZ__Opportunity__c</fields>
        <fields>ENZ__Size__c</fields>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>Name</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>salesforce@wrightexpress.com</integrationUser>
        <name>Attachment Message Sent to WOL NP</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>INTEGRATION - Attachment Message to WOL NP</fullName>
        <actions>
            <name>Attachment_Message_Sent_to_WOL_NP</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ENZ__FTPAttachment__c.ENZ__Bytes__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
