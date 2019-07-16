<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>WES_Set_Count_as_Completed_as_TRUE</fullName>
        <field>Fuel_Card_Complete__c</field>
        <literalValue>1</literalValue>
        <name>WES - Set Count as Completed as TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Vel_Profile_different_False</fullName>
        <field>VelocityProfileDifferent__c</field>
        <literalValue>0</literalValue>
        <name>WES - Vel Profile different False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Vel_Profile_different_True</fullName>
        <field>VelocityProfileDifferent__c</field>
        <literalValue>1</literalValue>
        <name>WES - Vel Profile different True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WES - Set Count as Completed</fullName>
        <actions>
            <name>WES_Set_Count_as_Completed_as_TRUE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WES_Fuel_Card__c.Fuel_Card_Complete__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>WES_Fuel_Card__c.Fuel_Card_Complete_Formula__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Sets Count as Completed as True in order to use with Roll-up summary for validation rule.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Vel Prof on Card Not different than App</fullName>
        <actions>
            <name>WES_Vel_Profile_different_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Marks a checkbox as True if the velocity profile on the Fuel Card is different than the default velocity profile or the override on the application.</description>
        <formula>IF(ApplVelocityProfile__c  = TEXT(Velocity_Control_Profiler__c), TRUE, FALSE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Vel Prof on Card is different than App</fullName>
        <actions>
            <name>WES_Vel_Profile_different_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Marks a checkbox as True if the velocity profile on the Fuel Card is different than the default velocity profile or the override on the application.</description>
        <formula>IF(ApplVelocityProfile__c &lt;&gt; TEXT(Velocity_Control_Profiler__c), TRUE, FALSE)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
