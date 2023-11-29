<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Session_Status</fullName>
        <description>Session Status</description>
        <protected>false</protected>
        <recipients>
            <recipient>rushikeshkadamsfdc+devorgrk@gmail.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Session_Status</template>
    </alerts>
    <alerts>
        <fullName>Session_Status_Follow</fullName>
        <description>Session Status Follow Up</description>
        <protected>false</protected>
        <recipients>
            <recipient>rushikeshkadamsfdc+devorgrk@gmail.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>vijay.chouhan2@abc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Session_Status</template>
    </alerts>
    <alerts>
        <fullName>Session_Status_Follow_Up</fullName>
        <description>Session Status Follow Up</description>
        <protected>false</protected>
        <recipients>
            <recipient>rushikeshkadamsfdc+devorgrk@gmail.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>vijay.chouhan2@abc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Session_Status</template>
    </alerts>
    <rules>
        <fullName>Session Status Follow Up WF</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Session__c.Status__c</field>
            <operation>equals</operation>
            <value>Confirmed,Cancelled</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Session Status Follow up</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Session__c.Status__c</field>
            <operation>equals</operation>
            <value>Confirmed,Cancelled</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Session_Status_Follow</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Session__c.CreatedDate</offsetFromField>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
