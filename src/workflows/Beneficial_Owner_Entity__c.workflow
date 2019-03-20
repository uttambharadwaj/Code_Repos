<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>BOCDD_Send_Confirmation_Email_French</fullName>
        <description>BOCDD - Send Confirmation Email - French</description>
        <protected>false</protected>
        <recipients>
            <field>Correspondence_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Beneficial_Owner/BO_Confirmation_Email_FR</template>
    </alerts>
    <alerts>
        <fullName>BOCDD_Send_Save_For_Later_Email_French</fullName>
        <description>BOCDD - Send Save For Later Email - French</description>
        <protected>false</protected>
        <recipients>
            <field>Correspondence_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Beneficial_Owner/BO_Saved_For_Later_FR</template>
    </alerts>
    <alerts>
        <fullName>Notify_record_owner_of_BO_Certification_form_received</fullName>
        <description>BOCDD - Notify record owner of BO Certification form received</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Beneficial_Owner/BO_Form_Received</template>
    </alerts>
    <alerts>
        <fullName>Notify_record_owner_of_BO_Certification_form_received_Merchant</fullName>
        <description>BOCDD - Notify record owner of BO Certification form received - Merchant</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Beneficial_Owner/BO_Form_Received_Merchant</template>
    </alerts>
    <alerts>
        <fullName>Send_Confirmation_English</fullName>
        <description>BOCDD - Send Confirmation - English</description>
        <protected>false</protected>
        <recipients>
            <field>Correspondence_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Beneficial_Owner/Beneficial_Owner_Confirmation_Email</template>
    </alerts>
    <alerts>
        <fullName>Send_Save_For_Later_Email_English</fullName>
        <description>BOCDD - Send Save For Later Email - English</description>
        <protected>false</protected>
        <recipients>
            <field>Correspondence_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Beneficial_Owner/Beneficial_Owner_Saved_For_Later_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>Program_Name_Update</fullName>
        <description>Used in workflow on BO object to build sharing rule.</description>
        <field>Program_Name_WF_Update__c</field>
        <formula>Opportunity__r.Campaign_Program__r.Name</formula>
        <name>Program Name Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BOCDD - Information Returned From Customer</fullName>
        <actions>
            <name>Notify_record_owner_of_BO_Certification_form_received</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(  ISCHANGED(Record_Status__c), TEXT(PRIORVALUE(Record_Status__c)) == &apos;Awaiting Customer&apos;, TEXT(Record_Status__c) == &apos;Active&apos;,  RecordType.Name != &apos;Merchant&apos;, $User.Id != Owner:User.Id )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BOCDD - Information Returned From Customer - Merchant</fullName>
        <actions>
            <name>Notify_record_owner_of_BO_Certification_form_received_Merchant</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(  ISCHANGED(Record_Status__c), TEXT(PRIORVALUE(Record_Status__c)) == &apos;Awaiting Customer&apos;, TEXT(Record_Status__c) == &apos;Active&apos;,  RecordType.Name == &apos;Merchant&apos;, $User.Id != Owner:User.Id )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BOCDD - Send Confirmation Email</fullName>
        <actions>
            <name>Send_Confirmation_English</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( $User.Alias == &apos;guest&apos;, ISCHANGED(Record_Status__c), TEXT(PRIORVALUE(Record_Status__c)) == &apos;Awaiting Customer&apos;, ISPICKVAL(Record_Status__c, &apos;Active&apos;), NOT(ISBLANK(Save_For_Later_Key__c)), NOT(Owner:User.Alias == &apos;guest&apos;), ISPICKVAL(Language_Preference__c, &apos;English&apos;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BOCDD - Send Confirmation Email - French</fullName>
        <actions>
            <name>BOCDD_Send_Confirmation_Email_French</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( $User.Alias == &apos;guest&apos;, ISCHANGED(Record_Status__c), TEXT(PRIORVALUE(Record_Status__c)) == &apos;Awaiting Customer&apos;, ISPICKVAL(Record_Status__c, &apos;Active&apos;), NOT(ISBLANK(Save_For_Later_Key__c)), NOT(Owner:User.Alias == &apos;guest&apos;), ISPICKVAL(Language_Preference__c, &apos;French&apos;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BOCDD - Send Save For Later Email</fullName>
        <actions>
            <name>Send_Save_For_Later_Email_English</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( $User.Alias == &apos;guest&apos;,  ISCHANGED(Save_For_Later_URL__c), ISPICKVAL(Language_Preference__c, &apos;English&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BOCDD - Send Save For Later Email - French</fullName>
        <actions>
            <name>BOCDD_Send_Save_For_Later_Email_French</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( $User.Alias == &apos;guest&apos;,  ISCHANGED(Save_For_Later_URL__c), ISPICKVAL(Language_Preference__c, &apos;French&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Program Name Update</fullName>
        <actions>
            <name>Program_Name_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Beneficial_Owner_Entity__c.Account_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Used to update the program name field to build sharing rules.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
