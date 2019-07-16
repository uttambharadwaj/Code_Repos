<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CP_Department_APAC</fullName>
        <field>Department__c</field>
        <literalValue>Corporate Payments Account Management Asia</literalValue>
        <name>CP Department APAC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CP_Department_AU</fullName>
        <field>Department__c</field>
        <literalValue>Corporate Payments Account Management AU</literalValue>
        <name>CP Department AU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CP_Department_EU</fullName>
        <field>Department__c</field>
        <literalValue>Corporate Payments Account Management EU</literalValue>
        <name>CP Department EU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CP_Set_Case_Department_NA</fullName>
        <field>Department__c</field>
        <literalValue>Corporate Payments Account Management NA</literalValue>
        <name>CP - Set Case Department NA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Customer_RespondedCase</fullName>
        <field>Status</field>
        <literalValue>Unread</literalValue>
        <name>Status - Customer RespondedCase</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>CP - New Email Received</fullName>
        <actions>
            <name>Status_Customer_RespondedCase</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Service Operations</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Department__c</field>
            <operation>equals</operation>
            <value>Corporate Payments Account Management EU,Corporate Payments Account Management NA,Corporate Payments Account Management AU,Corporate Payments Account Management Asia</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
