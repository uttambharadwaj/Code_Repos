<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>Activity_to_RDW</fullName>
        <apiVersion>24.0</apiVersion>
        <endpointUrl>https://wexfleet.wexapi.com/salesforceopportunityactivity</endpointUrl>
        <fields>ActivityDate</fields>
        <fields>Activity_Type__c</fields>
        <fields>Comments__c</fields>
        <fields>Id</fields>
        <fields>LastModifiedDate</fields>
        <fields>OwnerId</fields>
        <fields>Priority</fields>
        <fields>Siebel_LOGIN__c</fields>
        <fields>Status</fields>
        <fields>Subject</fields>
        <fields>Type</fields>
        <fields>WhatId</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>salesforce@wrightexpress.com</integrationUser>
        <name>Activity to HUB</name>
        <protected>false</protected>
        <useDeadLetterQueue>true</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Credit_Task</fullName>
        <apiVersion>20.0</apiVersion>
        <endpointUrl>https://wexfleet.wexapi.com/salesforceoutboundservice</endpointUrl>
        <fields>ActivityDate</fields>
        <fields>Activity_Type__c</fields>
        <fields>Comments__c</fields>
        <fields>Description</fields>
        <fields>Id</fields>
        <fields>Opportunity_ID__c</fields>
        <fields>OwnerId</fields>
        <fields>Priority</fields>
        <fields>Siebel_LOGIN__c</fields>
        <fields>Status</fields>
        <fields>Subject</fields>
        <fields>Type</fields>
        <fields>WhatId</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>rbeattie@wrightexpress.com</integrationUser>
        <name>Credit Task to Siebel</name>
        <protected>false</protected>
        <useDeadLetterQueue>true</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>INTEGRATION - Credit task to Siebel</fullName>
        <actions>
            <name>Credit_Task</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) OR (3 AND 2) OR (4 AND 2) OR (5 AND 2) OR 6</booleanFilter>
        <criteriaItems>
            <field>Task.Activity_Type__c</field>
            <operation>equals</operation>
            <value>Converted,Tailored Fee Schedule,App Forwarded To Credit,Account Set Up,Incomplete App,Information Needed,Application Comments,Notes,Application,FYI,New Tax Docs,Info Returned,Set Up Account,Approved Application,PreCard Call,Tax compliance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.CreatedById</field>
            <operation>notEqual</operation>
            <value>Salesforce Integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Activity_Type__c</field>
            <operation>equals</operation>
            <value>Oregon Fuel Document,Set Up Account</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Type</field>
            <operation>equals</operation>
            <value>Converted,Oregon Fuel Document,Tailored Fee Schedule,Account Set Up,App Forwarded to Credit,Info Needed,Info Returned,FYI,Other,Precard Call,Card Production Complete,Set Up Account,Email - Inbound,Email - Outbound,BO Info Returned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Type</field>
            <operation>equals</operation>
            <value>0-Standard,1-Daily,2-Tri,3-Weekly,4-5th,5-Dep/Loc,6-Financials Requested,7-PG Requested,Declined Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Type</field>
            <operation>equals</operation>
            <value>Set Up Account</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WES - Mark Closed Tasks Completed</fullName>
        <actions>
            <name>Task_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Complete__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>WES Tasks</value>
        </criteriaItems>
        <description>When a WES Task is Closed, mark the task complete.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
