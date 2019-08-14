<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Credit_Line_Requested</fullName>
        <description>Check field</description>
        <field>Initial_Credit_Line_Requested__c</field>
        <literalValue>1</literalValue>
        <name>Credit Line Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Status</fullName>
        <field>ApprovalStatus__c</field>
        <literalValue>Pending</literalValue>
        <name>Set Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Draft_Status</fullName>
        <field>SBQQ__Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Set Draft Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Draft_Status2</fullName>
        <field>SBQQ__Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Set Draft Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Primary</fullName>
        <description>Set quote to primary on create</description>
        <field>SBQQ__Primary__c</field>
        <literalValue>1</literalValue>
        <name>Set Primary</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Quote_Status_to_approved</fullName>
        <field>SBQQ__Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Set Quote Status to approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Watermark</fullName>
        <field>SBQQ__WatermarkShown__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Watermark</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Watermark</fullName>
        <description>Set watermark</description>
        <field>SBQQ__WatermarkShown__c</field>
        <literalValue>1</literalValue>
        <name>Watermark</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Credit Line requested</fullName>
        <actions>
            <name>Credit_Line_Requested</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SBQQ__Quote__c.Requested_Credit_Limit__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>check Initial Credit Line Requested Checkbox if value in requested credit line field on opportunity.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Remove Watermark</fullName>
        <actions>
            <name>Uncheck_Watermark</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SBQQ__Quote__c.ApprovalStatus__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Approved</fullName>
        <actions>
            <name>Set_Quote_Status_to_approved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SBQQ__Quote__c.ApprovalStatus__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>Set status to approved once advanced approvals is complete</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Draft</fullName>
        <actions>
            <name>Set_Approval_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SBQQ__Quote__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Set Draft Status on Create</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Draft Status on Quote</fullName>
        <actions>
            <name>Set_Draft_Status2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SBQQ__Quote__c.SBQQ__Type__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Primary Quote</fullName>
        <actions>
            <name>Set_Primary</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SBQQ__Quote__c.SBQQ__Status__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Set quote to primary on create</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Watermark</fullName>
        <actions>
            <name>Watermark</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SBQQ__Quote__c.SBQQ__Status__c</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <criteriaItems>
            <field>SBQQ__Quote__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Fleet</value>
        </criteriaItems>
        <description>Insert Watermark when quote is in draft status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
