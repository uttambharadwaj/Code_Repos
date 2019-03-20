<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>D_B_Business_Verification_CQR</fullName>
        <field>forseva1__F_Credit_Quality_Rating__c</field>
        <formula>IF(forseva1__OUT_BUS_IND__c = &apos;Y&apos;, 0, null)</formula>
        <name>D&amp;B Business Verification CQR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>D_B_Business_Verification_CQR_Descr</fullName>
        <field>forseva1__F_CQR_Description__c</field>
        <formula>IF(forseva1__OUT_BUS_IND__c = &apos;Y&apos;, &quot;Bankrupt Company&quot;, &quot;&quot;)</formula>
        <name>D&amp;B Business Verification CQR Desc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>D_B_Business_Verification_Status</fullName>
        <field>forseva1__F_Verification_Status__c</field>
        <formula>IF(forseva1__OUT_BUS_IND__c = &apos;Y&apos;, &quot;Failed&quot;, &quot;Passed&quot;)</formula>
        <name>D&amp;B Business Verification Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Forseva D%26B Business Verification</fullName>
        <actions>
            <name>D_B_Business_Verification_CQR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>D_B_Business_Verification_CQR_Descr</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>D_B_Business_Verification_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>forseva1__DnBBusinessVerification__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Forseva Implementation</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
