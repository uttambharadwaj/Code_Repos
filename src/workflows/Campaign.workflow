<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Campaign_Active</fullName>
        <field>IsActive</field>
        <literalValue>1</literalValue>
        <name>Campaign Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Campaign_Completed</fullName>
        <field>Status</field>
        <literalValue>Completed</literalValue>
        <name>Campaign Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Campaign_In_Progress</fullName>
        <field>Status</field>
        <literalValue>In Progress</literalValue>
        <name>Campaign In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Campaign_Naming_Convention</fullName>
        <field>Name</field>
        <formula>Name &amp;&quot; - &quot;&amp; Coupon_Code__c</formula>
        <name>Campaign Naming Convention</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Campaign_Record_Type_General</fullName>
        <field>RecordTypeId</field>
        <lookupValue>General</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Campaign Record Type - General</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Campign_Active</fullName>
        <description>The Active field on Campaign is unchecked when the end date is less than today</description>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Campign &apos;Active&apos;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_checkbox_to_Active</fullName>
        <field>IsActive</field>
        <literalValue>1</literalValue>
        <name>Set checkbox to Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_the_Active_box</fullName>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Uncheck the Active box</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Campaign_to_HUB</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>https://wexfleet.wexapi.com/salesforcecampaign</endpointUrl>
        <fields>Actual_Number_Of_Prospects__c</fields>
        <fields>Channel__c</fields>
        <fields>Coupon_Code__c</fields>
        <fields>CreatedById</fields>
        <fields>CreatedDate</fields>
        <fields>Description</fields>
        <fields>Drop_Date__c</fields>
        <fields>EndDate</fields>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Name</fields>
        <fields>NumberOfContacts</fields>
        <fields>NumberOfConvertedLeads</fields>
        <fields>NumberOfLeads</fields>
        <fields>NumberOfOpportunities</fields>
        <fields>NumberOfWonOpportunities</fields>
        <fields>Objective__c</fields>
        <fields>OwnerId</fields>
        <fields>Program__c</fields>
        <fields>Region__c</fields>
        <fields>Selection_Criteria__c</fields>
        <fields>Sponsor__c</fields>
        <fields>StartDate</fields>
        <fields>Status</fields>
        <fields>Target__c</fields>
        <fields>Type</fields>
        <fields>of_Members__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>salesforce@wrightexpress.com</integrationUser>
        <name>Campaign to HUB</name>
        <protected>false</protected>
        <useDeadLetterQueue>true</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Campaign Completed</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Campign_Active</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Campaign.EndDate</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Campaign Record Type - General</fullName>
        <actions>
            <name>Campaign_Record_Type_General</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.CreatedById</field>
            <operation>equals</operation>
            <value>Salesforce Integration</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Campaign goes Active</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.Type</field>
            <operation>equals</operation>
            <value>Direct Mail,Email Blast</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>General</value>
        </criteriaItems>
        <description>set Active checkbox to TRUE and email the owner</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_checkbox_to_Active</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Campaign.Drop_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Campaign goes Inactive</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>General</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Type</field>
            <operation>equals</operation>
            <value>Direct Mail,Email Blast</value>
        </criteriaItems>
        <description>Uncheck the Active box and email owner</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Uncheck_the_Active_box</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Campaign.EndDate</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>INTEGRATION - Campaign to HUB</fullName>
        <actions>
            <name>Campaign_to_HUB</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
