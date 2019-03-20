<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Account_QA_Approved</fullName>
        <description>Account QA Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/Account_QA_Approved</template>
    </alerts>
    <alerts>
        <fullName>Account_QA_Rejected</fullName>
        <description>Account QA Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/Account_QA_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_Opportunity_Owner</fullName>
        <description>Email Notification - Opportunity Owner</description>
        <protected>false</protected>
        <recipients>
            <field>Opportunity_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Implementation_Project_Completed_Opportunity_Owner</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_RM</fullName>
        <description>Email Notification - RM</description>
        <protected>false</protected>
        <recipients>
            <field>Relationship_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Implementation_Project_Completed_RM</template>
    </alerts>
    <alerts>
        <fullName>Key_Update_Notification</fullName>
        <description>Key Update - Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Relationship_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Opportunity_Owner_L__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/Project_Update_Added</template>
    </alerts>
    <alerts>
        <fullName>Non_Standard_Implementation_Approved</fullName>
        <description>Non-Standard Implementation Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/Non_Standard_Implementation_Approved</template>
    </alerts>
    <alerts>
        <fullName>Non_Standard_Implementation_Rejected</fullName>
        <description>Non-Standard Implementation Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/Non_Standard_Implementation_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Expense_Value_Update</fullName>
        <description>To fix Status At A Glance bug in Milestones PM +</description>
        <field>MPM4_BASE__Total_Expense_Budget__c</field>
        <formula>0</formula>
        <name>Expense Value Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Key_Update_Date_Time</fullName>
        <field>Last_Key_Update_Date__c</field>
        <formula>NOW()</formula>
        <name>Key Update Date / Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Non_Standard_Implementation_Approved</fullName>
        <field>Non_Standard_Implementation_Approved__c</field>
        <formula>NOW()</formula>
        <name>Non-Standard Implementation Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Owner_Email_Update</fullName>
        <description>For email notification</description>
        <field>Opportunity_Owner_Email__c</field>
        <formula>MPM4_BASE__Opportunity__r.Owner.Email</formula>
        <name>Opp Owner Email Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_RM_Email_P</fullName>
        <field>Relationship_Manager_Email__c</field>
        <formula>IF( 
NOT(ISBLANK(MPM4_BASE__Account__r.Assigned_Relationship_Manager__c )), 
MPM4_BASE__Account__r.Assigned_Relationship_Manager__r.Email, 

IF( 
MPM4_BASE__Account__r.Owner.Role_Name__c = &apos;CorporatePay Relationship Manager&apos;, 
MPM4_BASE__Account__r.Owner.Email, 

NULL 
))</formula>
        <name>Populate RM Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prior_Value_RAG_Status_Update</fullName>
        <field>Previous_RAG_Status__c</field>
        <formula>TEXT(PRIORVALUE(RAG_Status_Picklist__c))</formula>
        <name>Prior Value RAG Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QA_Completed</fullName>
        <field>QA_Complete__c</field>
        <formula>NOW()</formula>
        <name>QA Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RAG_Status_Update</fullName>
        <field>RAG_Status_Picklist__c</field>
        <literalValue>Green</literalValue>
        <name>RAG Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_RAG_Status_Last_Modified_Date</fullName>
        <description>Populates date when RAG Status was last changed</description>
        <field>RAG_Status_Last_Change_Date__c</field>
        <formula>LastModifiedDate</formula>
        <name>Update RAG Status Last Modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Expense Value Update</fullName>
        <actions>
            <name>Expense_Value_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MPM4_BASE__Milestone1_Project__c.MPM4_BASE__Total_Expense_Budget__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>To fix Status At A Glance bug</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Implementation Project Completed</fullName>
        <actions>
            <name>Email_Notification_Opportunity_Owner</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Notification_RM</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>RAG_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TEXT(Stage__c) = &apos;Completed&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Key Update</fullName>
        <actions>
            <name>Key_Update_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Key_Update_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(
  OR(
    RecordType.DeveloperName = &apos;Virtual_NA_Implementation&apos;,
    RecordType.DeveloperName = &apos;Implementation&apos;
    ),
  OR(
    AND(
      ISNEW(),
      NOT(ISBLANK(Key_Updates__c))
      ),
    AND(
      ISCHANGED(Key_Updates__c),
      NOT(ISBLANK(Key_Updates__c))
     )
  )
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Project w%2E Account RM</fullName>
        <actions>
            <name>Populate_RM_Email_P</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(
NOT(ISBLANK(MPM4_BASE__Account__r.Assigned_Relationship_Manager__c )),
MPM4_BASE__Account__r.Owner.Role_Name__c = &apos;CorporatePay Relationship Manager&apos;
)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RAG Status Change</fullName>
        <actions>
            <name>Prior_Value_RAG_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_RAG_Status_Last_Modified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(RAG_Status_Picklist__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
