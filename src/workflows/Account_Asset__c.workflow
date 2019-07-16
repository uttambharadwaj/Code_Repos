<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Account_Approval_Declined</fullName>
        <description>Account Approval Declined</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Account_Declined</template>
    </alerts>
    <alerts>
        <fullName>Account_Asset_Set_Up</fullName>
        <description>Account Asset Set Up - CS</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Account_Created</template>
    </alerts>
    <alerts>
        <fullName>Account_Asset_Set_Up_OAF_Sales</fullName>
        <description>Account Asset Set Up - OAF - Sales</description>
        <protected>false</protected>
        <recipients>
            <field>Opportunity_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Account_Created</template>
    </alerts>
    <alerts>
        <fullName>Account_Asset_Set_Up_Sales</fullName>
        <description>Account Asset Set Up - Sales</description>
        <protected>false</protected>
        <recipients>
            <field>Opportunity_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Account_Created</template>
    </alerts>
    <alerts>
        <fullName>Account_Funded_Reminder</fullName>
        <description>Account Not Funded Reminder</description>
        <protected>false</protected>
        <recipients>
            <recipient>none@corporatepay.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/Account_Funded</template>
    </alerts>
    <alerts>
        <fullName>Application_Information_Requested_1</fullName>
        <description>Application Information Requested</description>
        <protected>false</protected>
        <recipients>
            <field>Opportunity_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Application_Information_Requested</template>
    </alerts>
    <alerts>
        <fullName>Application_Rejected</fullName>
        <description>Application Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>Opportunity_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/Application_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Cards_Created_Reminder</fullName>
        <description>Cards Not Created Reminder</description>
        <protected>false</protected>
        <recipients>
            <recipient>none@corporatepay.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/Cards_Created</template>
    </alerts>
    <alerts>
        <fullName>New_Account_Asset_Finance</fullName>
        <ccEmails>megha.shah@wexeurope.com,siqi.li@wexeurope.com,Aiste.Paulik@wexeurope.com,Vishesh.Mehta@wexeurope.com</ccEmails>
        <description>Changed Virtual Account Asset - All - Finance</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/New_Account_Asset_Finance</template>
    </alerts>
    <alerts>
        <fullName>New_Virtual_Account_Asset_Credit_Finance</fullName>
        <ccEmails>siqi.li@wexeurope.com</ccEmails>
        <description>New Virtual Account Asset - Credit - Finance</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/New_Virtual_Credit_Account_Asset_Finance</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_IM_to_set_up_implementation_project</fullName>
        <description>Notification to IM to set up implementation project</description>
        <protected>false</protected>
        <recipients>
            <field>IM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WEX_CPS_MasterCard/notification_for_pre_implementation_call</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_RM_to_set_up_implementation_project</fullName>
        <description>Notification to RM to set up implementation project</description>
        <protected>false</protected>
        <recipients>
            <field>RM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WEX_CPS_MasterCard/notification_for_pre_implementation_call</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_SSM_to_set_up_implementation_project</fullName>
        <description>Notification to SSM to set up implementation project</description>
        <protected>false</protected>
        <recipients>
            <field>SSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WEX_CPS_MasterCard/notification_for_pre_implementation_call</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Approval_Declined</fullName>
        <field>Account_form_status__c</field>
        <literalValue>Declined</literalValue>
        <name>Account Approval Declined</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Application_Form_Status_Approved</fullName>
        <field>Account_form_status__c</field>
        <literalValue>Approved</literalValue>
        <name>Application Form Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Application_Form_Status_Rejected</fullName>
        <field>Account_form_status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Application Form Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Application_Status_Information_Request</fullName>
        <field>Account_form_status__c</field>
        <literalValue>Information Requested</literalValue>
        <name>Application Status - Information Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Application_Status_Information_Updated</fullName>
        <field>Account_form_status__c</field>
        <literalValue>Information Updated</literalValue>
        <name>Application Status - Information Updated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Date_Update</fullName>
        <description>Adds the date when Asset Application Complete is changed to true.</description>
        <field>Approval_Date__c</field>
        <formula>LastModifiedDate</formula>
        <name>Approval Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Asset_Application_Complete</fullName>
        <field>Asset_Application_Complete__c</field>
        <literalValue>1</literalValue>
        <name>Asset Application Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Gallons_Updated</fullName>
        <description>This will get updated with TODAY&apos;s date when the MTD Gallons field is updated</description>
        <field>Gallons_Updated__c</field>
        <formula>TODAY()</formula>
        <name>Gallons Updated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Information_Last_Updated_Date_Time</fullName>
        <field>Information_Last_Updated_Date__c</field>
        <formula>LastModifiedDate</formula>
        <name>Information Last Updated Date / Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Owner_Email_Update</fullName>
        <description>In case the opportunity owner&apos;s changed since the Account Asset was last edited</description>
        <field>Opportunity_Owner_Email__c</field>
        <formula>Opportunity__r.Owner.Email</formula>
        <name>Opportunity Owner Email Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Project_Complete</fullName>
        <description>PC</description>
        <field>Asset_Application_Complete__c</field>
        <literalValue>1</literalValue>
        <name>Project Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Terminted_Date</fullName>
        <description>Current Date populated when asset is changed to Terminted</description>
        <field>Terminated_Date__c</field>
        <formula>NOW()</formula>
        <name>Terminted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>set_Card_Program_Name</fullName>
        <field>Card_Program_WF_TXT__c</field>
        <formula>Opportunity__r.Card_Program_WF_TXT__c</formula>
        <name>set Card Program Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Account Asset Created %2F Edited</fullName>
        <actions>
            <name>Opportunity_Owner_Email_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Triggers updates to fields which contain opportunity information &amp; can&apos;t be updated on opportunity edit</description>
        <formula>OR( 
/*Currencies */
Opportunity__r.RecordTypeId = &apos;012700000005r08&apos;, 
Opportunity__r.RecordTypeId = &apos;012700000005qzy&apos;, 
Opportunity__r.RecordTypeId = &apos;012700000005r0D&apos;, 

/* Bespoke, TourCard, Disbursement */
Opportunity__r.RecordTypeId = &apos;012700000005qia&apos;, 
Opportunity__r.RecordTypeId = &apos;012700000005qid&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005qib&apos;, 

/* Expense - Crew, General, Petty Cash, Platform, Tour, Transport &amp; Haulage, UTB Consumer, UTB Corporate */ 
Opportunity__r.RecordTypeId = &apos;012700000005qic&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005rA9&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005rAA&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005rAB&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005qzo&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005rAC&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005r0I&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005r0N&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005qzt&apos;,

/* Virtual Credit, Virtual Prepaid MC, Virtual Prepaid VE, Virtual Debit MC */ 
Opportunity__r.RecordTypeId = &apos;012700000005qie&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005qif&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005qig&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005wUG&apos;
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account Not Funded Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account_Asset__c.Asset_Application_Complete__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Asset__c.Account_Funded__c</field>
            <operation>notEqual</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Reminds Customer Service if Account has not been funded</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Account_Funded_Reminder</name>
                <type>Alert</type>
            </actions>
            <timeLength>15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Application Information Requested</fullName>
        <actions>
            <name>Application_Information_Requested_1</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Application_Status_Information_Request</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>All opportunity record types.</description>
        <formula>OR(

AND(
ISNEW(),
NOT(ISBLANK(Information_Requested_Notes__c))
),

ISCHANGED(Information_Requested_Notes__c)

)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Application Rejected</fullName>
        <actions>
            <name>Application_Rejected</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Application_Form_Status_Rejected</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>All opportunity record types.</description>
        <formula>AND( 

OR(

/*Currencies */
Opportunity__r.RecordTypeId = &apos;012700000005r08&apos;, 
Opportunity__r.RecordTypeId = &apos;012700000005qzy&apos;, 
Opportunity__r.RecordTypeId = &apos;012700000005r0D&apos;, 

/* Bespoke, TourCard, Disbursement */
Opportunity__r.RecordTypeId = &apos;012700000005qia&apos;, 
Opportunity__r.RecordTypeId = &apos;012700000005qid&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005qib&apos;, 

/* Expense - Crew, General, Petty Cash, Platform, Tour, Transport &amp; Haulage, UTB Consumer, UTB Corporate */ 
Opportunity__r.RecordTypeId = &apos;012700000005qic&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005rA9&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005rAA&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005rAB&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005qzo&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005rAC&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005r0I&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005r0N&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005qzt&apos;,

/* Virtual Credit, Virtual Prepaid MC, Virtual Prepaid VE, Virtual Debit MC */ 
Opportunity__r.RecordTypeId = &apos;012700000005qie&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005qif&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005qig&apos;,
Opportunity__r.RecordTypeId = &apos;012700000005wUG&apos;
), 

ISCHANGED(Account_form_status__c), 
TEXT(Account_form_status__c) = &quot;Rejected&quot; 

)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Asset Creation Complete</fullName>
        <actions>
            <name>Project_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account_Asset__c.Asset_Application_Complete__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Cards Not Created Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account_Asset__c.Cards_Created__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Asset__c.Cards_Created__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Remind Customer Service when cards haven&apos;t been created</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Cards_Created_Reminder</name>
                <type>Alert</type>
            </actions>
            <timeLength>15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Changed Virtual Account Asset</fullName>
        <actions>
            <name>New_Account_Asset_Finance</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>RecordType.DeveloperName = &apos;CorporatePay&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Gallons Updated</fullName>
        <actions>
            <name>Gallons_Updated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This rule updates the gallons updated field with todays date when the MTD Gallons field is updated</description>
        <formula>AND(
ISCHANGED( Gallons_MTD__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IM Get pre-implementation call task creation</fullName>
        <actions>
            <name>Notification_to_IM_to_set_up_implementation_project</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Asset__c.IM__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Account Asset</fullName>
        <actions>
            <name>New_Account_Asset_Finance</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>RecordType.DeveloperName = &apos;CorporatePay&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Virtual Credit Account Asset</fullName>
        <actions>
            <name>New_Virtual_Account_Asset_Credit_Finance</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Email Alert not currently needed as it&apos;s already set from New Virtual Account Asset - All - Finance, to Qiqi.</description>
        <formula>AND(
  RecordType.DeveloperName = &apos;CorporatePay&apos;,
  OR(
    ISNEW(),
    ISCHANGED(BankCompanyNo__c)
  ),
  NOT(ISBLANK(BankCompanyNo__c))
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RM Get pre-implementation call task creation</fullName>
        <actions>
            <name>Notification_to_RM_to_set_up_implementation_project</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Asset__c.RM__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SSM Get pre-implementation call task creation</fullName>
        <actions>
            <name>Notification_to_SSM_to_set_up_implementation_project</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Asset__c.SSM__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Card Program Name</fullName>
        <actions>
            <name>set_Card_Program_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Asset__c.Card_Program__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Terminate Date</fullName>
        <actions>
            <name>Terminted_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Asset__c.Status_N__c</field>
            <operation>equals</operation>
            <value>Terminated</value>
        </criteriaItems>
        <description>Date the Assett was terminated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
