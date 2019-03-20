<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Serv_Ops_Negative_Transactional_Survey_Dispositioning</fullName>
        <description>Serv Ops - Negative Transactional Survey Dispositioning</description>
        <protected>false</protected>
        <recipients>
            <field>Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Service_Operations/Service_Operations_Negative_Transactional_Survey_Dispositioning</template>
    </alerts>
    <rules>
        <fullName>Serv Ops - Negative Transactional Survey Dispositioning</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Service_Operations_Survey_Response__c.Negative_Flag__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Serv_Ops_Negative_Transactional_Survey_Dispositioning</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Service_Operations_Survey_Response__c.CreatedDate</offsetFromField>
            <timeLength>16</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
