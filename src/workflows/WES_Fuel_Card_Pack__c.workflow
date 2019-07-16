<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>WES_Set_EDC_Card_Type_to_False</fullName>
        <field>EDCCardType__c</field>
        <literalValue>0</literalValue>
        <name>WES - Set EDC Card Type to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_EDC_Card_Type_to_True</fullName>
        <field>EDCCardType__c</field>
        <literalValue>1</literalValue>
        <name>WES - Set EDC Card Type to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Esso_Card_Type_True</fullName>
        <field>EssoCardType__c</field>
        <literalValue>1</literalValue>
        <name>WES - Set Esso Card Type True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Esso_Card_Type_to_False</fullName>
        <field>EssoCardType__c</field>
        <literalValue>0</literalValue>
        <name>WES - Set Esso Card Type to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_UK_Fuels_Card_False</fullName>
        <field>UKFuelsCardType__c</field>
        <literalValue>0</literalValue>
        <name>WES - Set UK Fuels Card False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_UK_Fuels_Card_True</fullName>
        <field>UKFuelsCardType__c</field>
        <literalValue>1</literalValue>
        <name>WES - Set UK Fuels Card True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WES - EDC Card Type False</fullName>
        <actions>
            <name>WES_Set_EDC_Card_Type_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WES_Fuel_Card_Pack__c.Card_Type__c</field>
            <operation>excludes</operation>
            <value>EDC</value>
        </criteriaItems>
        <description>Sets EDC Card Type to False if Card Type excludes EDC</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - EDC Card Type True</fullName>
        <actions>
            <name>WES_Set_EDC_Card_Type_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WES_Fuel_Card_Pack__c.Card_Type__c</field>
            <operation>includes</operation>
            <value>EDC</value>
        </criteriaItems>
        <description>Sets EDC Card Type to True if Card Type includes EDC</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Esso Card Type False</fullName>
        <actions>
            <name>WES_Set_Esso_Card_Type_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WES_Fuel_Card_Pack__c.Card_Type__c</field>
            <operation>excludes</operation>
            <value>Esso</value>
        </criteriaItems>
        <description>Sets Esso Card Type to False if Card Type excludes Esso</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Esso Card Type True</fullName>
        <actions>
            <name>WES_Set_Esso_Card_Type_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WES_Fuel_Card_Pack__c.Card_Type__c</field>
            <operation>includes</operation>
            <value>Esso</value>
        </criteriaItems>
        <description>Sets Esso Card Type to True if Card Type includes Esso</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - UK Fuels Card Type False</fullName>
        <actions>
            <name>WES_Set_UK_Fuels_Card_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WES_Fuel_Card_Pack__c.Card_Type__c</field>
            <operation>excludes</operation>
            <value>UK Fuels</value>
        </criteriaItems>
        <description>Sets UK Fuels Card Type to False if Card Type excludes UK Fuels</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - UK Fuels Card Type True</fullName>
        <actions>
            <name>WES_Set_UK_Fuels_Card_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WES_Fuel_Card_Pack__c.Card_Type__c</field>
            <operation>includes</operation>
            <value>UK Fuels</value>
        </criteriaItems>
        <description>Sets UK Fuels Card Type to True if Card Type includes UK Fuels</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
