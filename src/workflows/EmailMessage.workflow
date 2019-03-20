<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CP_Department_APAC</fullName>
        <field>Department__c</field>
        <literalValue>Corporate Payments Account Management Asia</literalValue>
        <name>CP Department APAC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CP_Department_AU</fullName>
        <field>Department__c</field>
        <literalValue>Corporate Payments Account Management AU</literalValue>
        <name>CP Department AU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CP_Department_EU</fullName>
        <field>Department__c</field>
        <literalValue>Corporate Payments Account Management EU</literalValue>
        <name>CP Department EU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CP_Set_Case_Department_NA</fullName>
        <field>Department__c</field>
        <literalValue>Corporate Payments Account Management NA</literalValue>
        <name>CP - Set Case Department NA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_Working</fullName>
        <field>Status</field>
        <literalValue>Working</literalValue>
        <name>Case Status - Working</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_First_Response</fullName>
        <description>Record time when first response was sent</description>
        <field>First_Response__c</field>
        <formula>NOW()</formula>
        <name>Set First Response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Customer_RespondedCase</fullName>
        <field>Status</field>
        <literalValue>Unread</literalValue>
        <name>Status - Customer RespondedCase</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unread_Email</fullName>
        <field>Status</field>
        <literalValue>Unread Email</literalValue>
        <name>Unread Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Virtual_CS_ReOpen_Case</fullName>
        <field>Status</field>
        <literalValue>Re-opened</literalValue>
        <name>Virtual CS - ReOpen Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>set_Response_Date</fullName>
        <description>sets the response date and time of the actual reply from the rep</description>
        <field>Actual_Response_Date__c</field>
        <formula>Now()</formula>
        <name>set Response Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>1st Email Response</fullName>
        <actions>
            <name>Case_Status_Working</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>set_Response_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Subject</field>
            <operation>notContain</operation>
            <value>has been created</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Virtual Payments,Virtual</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CP - New Email Received</fullName>
        <actions>
            <name>Status_Customer_RespondedCase</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Service Operations</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Department__c</field>
            <operation>equals</operation>
            <value>Corporate Payments Account Management EU,Corporate Payments Account Management NA,Corporate Payments Account Management AU,Corporate Payments Account Management Asia</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>First Email Response Sent</fullName>
        <actions>
            <name>Set_First_Response</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Virtual record types only</description>
        <formula>AND(
  OR(
    Parent.RecordType.DeveloperName = &apos;Virtual_Credit_CS&apos;,
    Parent.RecordType.DeveloperName = &apos;Virtual_Prepaid_CS&apos;,
    Parent.RecordType.DeveloperName = &apos;Virtual_Business_Support_CS&apos;,
    Parent.RecordType.DeveloperName = &apos;Virtual_Payments&apos;
  ), Incoming = FALSE,
  ISBLANK(Parent.First_Response__c),
  /* Salesforce Integration user - sends automated emails */
  NOT(CreatedById = &apos;00570000001Lkjs&apos;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Virtual CS - Closed Case Reply</fullName>
        <actions>
            <name>Virtual_CS_ReOpen_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Virtual Business Support CS,Virtual Credit CS,Virtual Prepaid CS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Virtual CS - Reply from customer</fullName>
        <actions>
            <name>Unread_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Virtual Business Support CS,Virtual Prepaid CS,Virtual Credit CS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,New</value>
        </criteriaItems>
        <description>update the case status to unread email when a reply comes in to a case</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
