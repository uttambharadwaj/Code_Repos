<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Milestone_Edit_Notification</fullName>
        <description>Milestone Edit Notification</description>
        <protected>false</protected>
        <recipients>
            <field>RM_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Milestone_Edit</template>
    </alerts>
    <fieldUpdates>
        <fullName>Last_Edit_Date</fullName>
        <field>Last_Edit__c</field>
        <formula>NOW()</formula>
        <name>Last Edit Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Original_Deadline_Date</fullName>
        <field>Original_Deadline__c</field>
        <formula>PRIORVALUE(MPM4_BASE__Deadline__c)</formula>
        <name>Populate Original Deadline Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_RM_Email_M</fullName>
        <field>RM_Email__c</field>
        <formula>IF( 
NOT(ISBLANK(MPM4_BASE__Project__r.MPM4_BASE__Account__r.Assigned_Relationship_Manager__c )), 
MPM4_BASE__Project__r.MPM4_BASE__Account__r.Assigned_Relationship_Manager__r.Email, 

IF( 
MPM4_BASE__Project__r.MPM4_BASE__Account__r.Owner.Role_Name__c = &apos;CorporatePay Relationship Manager&apos;, 
MPM4_BASE__Project__r.MPM4_BASE__Account__r.Owner.Email, 

NULL 
))</formula>
        <name>Populate RM Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>1st Milestone Deadline Change</fullName>
        <actions>
            <name>Populate_Original_Deadline_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(
ISCHANGED(MPM4_BASE__Deadline__c),
ISBLANK(Original_Deadline__c)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Milestone Edited</fullName>
        <actions>
            <name>Milestone_Edit_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Last_Edit_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(DATEVALUE(Last_Edit__c)  = TODAY())</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Milestone w%2E Account RM</fullName>
        <actions>
            <name>Populate_RM_Email_M</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( 
NOT(ISBLANK(MPM4_BASE__Project__r.MPM4_BASE__Account__r.Assigned_Relationship_Manager__c )), 
MPM4_BASE__Project__r.MPM4_BASE__Account__r.Owner.Role_Name__c = &apos;CorporatePay Relationship Manager&apos; 
)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
