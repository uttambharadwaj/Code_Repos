<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Activity_Type_Update</fullName>
        <field>Type</field>
        <name>Activity Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Activity_Type_Update_Non_Solicited</fullName>
        <description>Update the Type field to Non Solicited when the subject equals &apos;Non Solicited&apos;</description>
        <field>Type</field>
        <literalValue>Non Solicited</literalValue>
        <name>Activity Type Update - Non Solicited</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Activity_Type_Update_Solicited</fullName>
        <description>This updates the Type field to Solicited when the Subject = Solicited</description>
        <field>Type</field>
        <literalValue>Solicited</literalValue>
        <name>Activity Type Update - Solicited</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Flag_Public</fullName>
        <field>IsVisibleInSelfService</field>
        <literalValue>1</literalValue>
        <name>Flag Public</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Priority</fullName>
        <field>Priority</field>
        <literalValue>2-High</literalValue>
        <name>Priority</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Salesforce_test</fullName>
        <field>Priority</field>
        <literalValue>High</literalValue>
        <name>Salesforce test</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Activity_Type_to_FYI</fullName>
        <field>Activity_Type__c</field>
        <literalValue>FYI</literalValue>
        <name>Set Activity Type to FYI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Task_Comments_Update</fullName>
        <field>Comments__c</field>
        <formula>LEFT(Description , 255)</formula>
        <name>Task Comments Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Task_Completed</fullName>
        <field>Status</field>
        <literalValue>Completed</literalValue>
        <name>Task Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Task_set_Type_to_Other</fullName>
        <field>Type</field>
        <literalValue>Other</literalValue>
        <name>Task:  set Type to Other</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Time_Stamp_Task_Complete</fullName>
        <field>Completed_Date_Stamp__c</field>
        <formula>Today()</formula>
        <name>Time Stamp Task Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
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
        <fullName>BOCA Task to WEX Bank</fullName>
        <actions>
            <name>Credit_Task</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>equals</operation>
            <value>Solicited Application</value>
        </criteriaItems>
        <description>This sends and activity to WEX Bank so they can tell if a BOCA app is solicited or non solicited</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Community%3A Expose Task Public</fullName>
        <actions>
            <name>Flag_Public</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CreatedDate</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Mark Tasks public so that they may been seen by community members</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
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
        <fullName>INTEGRATION - Task to RDW</fullName>
        <actions>
            <name>Activity_to_RDW</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Activity_Type__c</field>
            <operation>notEqual</operation>
            <value>Implementation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Opportunity_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Project Updates</fullName>
        <actions>
            <name>Task_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(

RecordTypeId = &apos;012700000005wir&apos;,

OR(
$Setup.VProfileId__c.WE_Imp__c = TRUE,
$Setup.VProfileId__c.Wex_Europe_Administrator__c = TRUE
)

)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Set Up Account Activity</fullName>
        <actions>
            <name>Credit_Task</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>equals</operation>
            <value>Set Up Account</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Activity Type to FYI for Fleet Data Form Task</fullName>
        <actions>
            <name>Set_Activity_Type_to_FYI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>equals</operation>
            <value>Fleet Data Form Sent</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.OwnerId</field>
            <operation>equals</operation>
            <value>Salesforce Integration</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Subject %3D Non Solicited</fullName>
        <actions>
            <name>Activity_Type_Update_Non_Solicited</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>equals</operation>
            <value>Non Solicited Application</value>
        </criteriaItems>
        <description>When the subject = Non Solicited change the type to &apos;Non Solicited&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Subject %3D Solicited</fullName>
        <actions>
            <name>Activity_Type_Update_Solicited</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>equals</operation>
            <value>Solicited Application</value>
        </criteriaItems>
        <description>When the subject = Solicited change the type to &apos;Solicited&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Task Closed Time Stamp</fullName>
        <actions>
            <name>Time_Stamp_Task_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Task Comments Update</fullName>
        <actions>
            <name>Task_Comments_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(

/* Original workflow criteria */
NOT(Subject = null),
NOT($Profile.Name = &apos;Integration User&apos;),

/* Wex Europe edit - rule shouldn&apos;t be triggered for WE users */
NOT($Setup.VProfileId__c.WE_All__c = TRUE)

)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Task%3A set Type to Other for Create Asset</fullName>
        <actions>
            <name>Task_set_Type_to_Other</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>equals</operation>
            <value>Create Asset</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
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
