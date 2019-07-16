<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Clear_Task_Order</fullName>
        <field>Order__c</field>
        <name>Clear Task Order</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Completed_Date</fullName>
        <field>Completed_Date__c</field>
        <formula>TODAY()</formula>
        <name>Populate Completed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Original_Due_Date</fullName>
        <field>Original_Due_Date__c</field>
        <formula>MPM4_BASE__Due_Date__c</formula>
        <name>Populate Original Due Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Original_Est_Hours_FIeld</fullName>
        <field>Original_Estimated_Hours__c</field>
        <formula>PRIORVALUE(MPM4_BASE__Estimated_Hours__c)</formula>
        <name>Populate Original Est Hours FIeld</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Task_Complete</fullName>
        <field>MPM4_BASE__Complete__c</field>
        <literalValue>1</literalValue>
        <name>Task Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Task_Completed_Date</fullName>
        <description>Inserts last modified date into field.</description>
        <field>Completed_Date__c</field>
        <formula>PRIORVALUE(LastModifiedDate)</formula>
        <name>Task Completed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>1st Estimated Hours Change</fullName>
        <actions>
            <name>Populate_Original_Est_Hours_FIeld</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 
  ISCHANGED(MPM4_BASE__Estimated_Hours__c), 
  ISBLANK(Original_Estimated_Hours__c) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Collect Milestone Requestor</fullName>
        <active>false</active>
        <criteriaItems>
            <field>MPM4_BASE__Milestone1_Milestone__c.Requestor__c</field>
            <operation>notEqual</operation>
            <value></value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Completed Date Update</fullName>
        <actions>
            <name>Task_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>MPM4_BASE__Milestone1_Task__c.Completed_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>To save the time of manually selecting a completed date for every historic record.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Task Cancelled</fullName>
        <actions>
            <name>Clear_Task_Order</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Task_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(
ISCHANGED(Cancelled__c),
Cancelled__c = TRUE
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Task Completed</fullName>
        <actions>
            <name>Clear_Task_Order</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(

AND(
ISNEW(),
MPM4_BASE__Complete__c = TRUE,
ISBLANK( Completed_Date__c)
),

AND(
ISCHANGED(MPM4_BASE__Complete__c),
MPM4_BASE__Complete__c = TRUE,
ISBLANK(Completed_Date__c)
)

)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Task Due Date Change</fullName>
        <actions>
            <name>Populate_Original_Due_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(

AND(
ISNEW(),
NOT(ISBLANK(MPM4_BASE__Due_Date__c))
),

ISBLANK(PRIORVALUE(MPM4_BASE__Due_Date__c))

)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
