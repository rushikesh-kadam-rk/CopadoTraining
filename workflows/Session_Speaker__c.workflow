<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Session Status Follow Up WF Final</fullName>
        <active>false</active>
        <formula>ISPICKVAL( Session__r.Status__c , &apos;Confirmed&apos;) ||ISPICKVAL( Session__r.Status__c , &apos;Cancelled&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Session_Speaker__c.CreatedDate</offsetFromField>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
