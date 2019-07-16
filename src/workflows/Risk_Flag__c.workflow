<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>EMAP_Track_RF_Refer_Status</fullName>
        <description>Update Refer date when status changed to any Refer status</description>
        <field>RFStatusReferDate__c</field>
        <formula>Today()</formula>
        <name>EMAP Track RF Refer Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Track_RF_Status_Under_Review</fullName>
        <description>Update Review date when status changed to any &apos;Under Review&apos;</description>
        <field>RFStatusUnderreview__c</field>
        <formula>Today()</formula>
        <name>EMAP Track RF Status Under Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Update_Closed_RF_Status_Date</fullName>
        <description>Update Closed RF Status Date</description>
        <field>RFStatusClosedDate__c</field>
        <formula>Today()</formula>
        <name>EMAP Update Closed RF Status Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Update_Is_Risk_Flag_Changed</fullName>
        <description>Update Is Risk Flag Changed</description>
        <field>isRFFlagChanged__c</field>
        <literalValue>1</literalValue>
        <name>EMAP Update Is Risk Flag Changed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Update_RF_Status_Changed_Date</fullName>
        <description>Update RF Status Changed Date</description>
        <field>RFStatusChangedDate__c</field>
        <formula>Today()</formula>
        <name>EMAP Update RF Status Changed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>EMAP Track RF Refer Status</fullName>
        <actions>
            <name>EMAP_Track_RF_Refer_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Risk_Flag__c.Status__c</field>
            <operation>equals</operation>
            <value>Refer – CVS,Refer – Customer,Refer – EMTC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Risk_Flag__c.RFStatusReferDate__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Track time spent under all Refer status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EMAP Track RF Status Closed</fullName>
        <actions>
            <name>EMAP_Update_Closed_RF_Status_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Risk_Flag__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Risk_Flag__c.RFStatusClosedDate__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Track RF Status Closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EMAP Track RF Under Review Status</fullName>
        <actions>
            <name>EMAP_Track_RF_Status_Under_Review</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Risk_Flag__c.Status__c</field>
            <operation>equals</operation>
            <value>Under review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Risk_Flag__c.RFStatusUnderreview__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Track time spent under RF Under Review Status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EMAP Track Risk Flag Status</fullName>
        <actions>
            <name>EMAP_Update_Is_Risk_Flag_Changed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>EMAP_Update_RF_Status_Changed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Track Risk Flag Status</description>
        <formula>ISCHANGED(Status__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
