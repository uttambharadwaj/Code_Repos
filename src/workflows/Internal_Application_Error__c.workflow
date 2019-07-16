<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>WEX_Development_Internal_Error_Alert</fullName>
        <description>WEX Development Internal Error Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>derek.gilbert@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>leela.howland@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mark.bickford@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>WEX_Dev/WEX_Development_Internal_Error_Alert</template>
    </alerts>
    <rules>
        <fullName>WEX Internal Application Error</fullName>
        <actions>
            <name>WEX_Development_Internal_Error_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Internal_Application_Error__c.Application__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Internal_Application_Error__c.Error_Location__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Internal_Application_Error__c.Error_Message__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Internal_Application_Error__c.Send_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
