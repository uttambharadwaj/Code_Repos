<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_PLI_Costs</fullName>
        <description>Updates the product line item cost field from Product2</description>
        <field>Unit_Cost__c</field>
        <formula>Product2.Cost__c</formula>
        <name>Update PLI Costs</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_from_0_to_1</fullName>
        <field>Quantity</field>
        <formula>1</formula>
        <name>Update from 0 to 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Costs on Product Line Item</fullName>
        <actions>
            <name>Update_PLI_Costs</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Unit_Cost__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Pulls in the cost from Product2 when a line item is selected.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
