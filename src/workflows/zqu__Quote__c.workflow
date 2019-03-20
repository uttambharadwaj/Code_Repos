<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_is_sent_to_the_Sales_Rep_when_a_Vendor_Order_is_sent</fullName>
        <description>Email is sent to the Sales Rep when a Vendor Order is sent</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Sales_Notification_of_Vendor_Order_Sent</template>
    </alerts>
    <alerts>
        <fullName>Email_sent_to_sales_rep</fullName>
        <description>An email is sent to the sales representatives once the quote agreement has been signed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>kristine.martinez@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Customer_Approval_Email_Alert_Sales</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_quoter</fullName>
        <description>Send email to quoter</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>fieldsupport@wrightexpress.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Quote_Pending_Customer_Approval_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_quoter_rejection</fullName>
        <description>Send email to quoter for rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>fieldsupport@wrightexpress.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Quote_Draft_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Reason_60P_of_the_Credit_Limit</fullName>
        <field>Approval_Reason__c</field>
        <formula>&apos;Quote is 60% of the credit limit&apos;</formula>
        <name>Approval Reason 60P of the Credit Limit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Reason_Below_Min_Price</fullName>
        <field>Approval_Reason__c</field>
        <formula>&apos;A product\&apos;s price is below the minimum Wex price&apos;</formula>
        <name>Approval Reason Below Min Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Reason_Free_Form_Fields</fullName>
        <field>Approval_Reason__c</field>
        <formula>&apos;The free form fields have been updated to include text&apos;</formula>
        <name>Approval Reason Free Form Fields</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Reason_No_Recurring_Charges</fullName>
        <field>Approval_Reason__c</field>
        <formula>&apos;There are no recurring charges on the Quote&apos;</formula>
        <name>Approval Reason No Recurring Charges</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Reason_Over_the_Credit_Limit</fullName>
        <field>Approval_Reason__c</field>
        <formula>&apos;Quote is over the credit limit&apos;</formula>
        <name>Approval Reason Over the Credit Limit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QuoteNumberUpdate</fullName>
        <field>QuoteNumber__c</field>
        <formula>SUBSTITUTE( QuoteAutoNumber__c , &quot;Q&quot;, IF(isPending__c,&quot;PT0&quot;, IF( UPPER(PrimarySource__c)  &lt;&gt; &quot;FLEETONE&quot;,&quot;WT4&quot;, &quot;FT0&quot;)))</formula>
        <name>Quote Number Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Approved</fullName>
        <field>Approved__c</field>
        <literalValue>1</literalValue>
        <name>Quote Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Number_Update_w_Starting_Value</fullName>
        <field>QuoteNumber__c</field>
        <formula>IF(isPending__c,&quot;PT&quot;, IF( UPPER(PrimarySource__c) &lt;&gt; &quot;FLEETONE&quot;,&quot;WT&quot;, &quot;FT&quot;))&amp;TEXT(VALUE(SUBSTITUTE( QuoteAutoNumber__c , &quot;Q&quot;, &quot;0&quot;))+VALUE(&quot;500000000&quot;))</formula>
        <name>Quote Number Update w Starting Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_Approved</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Pending_Approval</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_Updated</fullName>
        <field>RecordTypeId</field>
        <lookupValue>OutforSignature</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type Updated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Draft</fullName>
        <field>Quote_Stage__c</field>
        <literalValue>Draft</literalValue>
        <name>Set Stage to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_to_Pending_Customer_Approval</fullName>
        <field>Quote_Stage__c</field>
        <literalValue>Pending Customer Approval</literalValue>
        <name>Set Stage to Pending Customer Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateRecordtype</fullName>
        <field>RecordTypeId</field>
        <lookupValue>OutforSignature</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Issued_Order_Date</fullName>
        <description>Derek made me do this</description>
        <field>Issued_Order_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Issued Order Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_On_Customer_Approval_Override</fullName>
        <field>CustomerApproval__c</field>
        <literalValue>1</literalValue>
        <name>Update On Customer Approval Override</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Quote_RT_to_Customer_Approved</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CustomerApproved</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Quote RT to Customer Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Quote_Record_Type_to_Issued_Order</fullName>
        <field>RecordTypeId</field>
        <lookupValue>IssuedOrder</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Quote Record Type to Issued Order</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Quote_Status_to</fullName>
        <field>zqu__Status__c</field>
        <literalValue>Issued Order</literalValue>
        <name>Update Quote Status to</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Quote_Status_to_Customer_Approved</fullName>
        <field>zqu__Status__c</field>
        <literalValue>Customer Approved</literalValue>
        <name>Update Quote Status to Customer Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Approved</fullName>
        <field>zqu__Status__c</field>
        <literalValue>Customer Approved</literalValue>
        <name>Update Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Z_QuoteIsApproved</fullName>
        <field>Approved__c</field>
        <literalValue>1</literalValue>
        <name>Quote Is Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Email sent to Sales Rep on Vendor Order</fullName>
        <actions>
            <name>Email_is_sent_to_the_Sales_Rep_when_a_Vendor_Order_is_sent</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>zqu__Quote__c.Vendor_Order_Sent__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Quote Number Update</fullName>
        <actions>
            <name>Quote_Number_Update_w_Starting_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>zqu__Quote__c.zqu__Number__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Email to Sales Rep once Customer Approval</fullName>
        <actions>
            <name>Email_sent_to_sales_rep</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>zqu__Quote__c.CustomerApproval__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>zqu__Quote__c.CustomerApprovalOverride__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update On Customer Approval Override</fullName>
        <actions>
            <name>Update_On_Customer_Approval_Override</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>zqu__Quote__c.CustomerApprovalOverride__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>zqu__Quote__c.CustomerApproval__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Quote Record to Issued Order</fullName>
        <actions>
            <name>Update_Issued_Order_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Quote_Record_Type_to_Issued_Order</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Quote_Status_to</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Vendor_Order_Sent__c  = TRUE ||  RecordType.Name = &apos;IssuedOrder&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
