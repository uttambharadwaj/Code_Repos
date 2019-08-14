<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>EMAP_Update_credit_security_status</fullName>
        <description>Update credit security status as expired when expiry date &lt;= Today and Security type is Bank Guarantee.</description>
        <field>Status__c</field>
        <literalValue>Expired</literalValue>
        <name>EMAP Update credit security status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>EMAP Update Credit Security status</fullName>
        <actions>
            <name>EMAP_Update_credit_security_status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Credit_Security__c.Security_Expiry__c</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Security__c.Type__c</field>
            <operation>equals</operation>
            <value>Bank Guarantee</value>
        </criteriaItems>
        <description>Update credit security status as expired when expiry date &lt;= Today and Security type is Bank Guarantee.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>EMAP_Update_credit_security_status</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Credit_Security__c.Security_Expiry__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
