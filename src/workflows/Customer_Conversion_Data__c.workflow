<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Chevron_Send_Confirmation_Email</fullName>
        <description>Chevron - Send Confirmation Email</description>
        <protected>false</protected>
        <recipients>
            <field>Confirmation_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>BOCA/Chevron_Conversion_Confirmation</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Confirmation_Email_Sent_To_True</fullName>
        <field>Confirmation_Email_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Set Confirmation Email Sent To True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Chevron - Confirmation Email</fullName>
        <actions>
            <name>Chevron_Send_Confirmation_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Confirmation_Email_Sent_To_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>$User.Alias = &apos;guest&apos; &amp;&amp; Confirmation_Email_Address__c != null &amp;&amp; Confirmation_Email_Sent__c == false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
