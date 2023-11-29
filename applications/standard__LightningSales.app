<?xml version="1.0" encoding="UTF-8"?>
<CustomApplication xmlns="http://soap.sforce.com/2006/04/metadata">
    <formFactors>Small</formFactors>
    <formFactors>Medium</formFactors>
    <formFactors>Large</formFactors>
    <isNavAutoTempTabsDisabled>false</isNavAutoTempTabsDisabled>
    <isNavPersonalizationDisabled>false</isNavPersonalizationDisabled>
    <isNavTabPersistenceDisabled>false</isNavTabPersistenceDisabled>
    <label>Sales</label>
    <navType>Standard</navType>
    <profileActionOverrides>
        <actionName>Tab</actionName>
        <content>New_Home_Page</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>standard-home</pageOrSobjectType>
        <type>Flexipage</type>
        <profile>Admin</profile>
    </profileActionOverrides>
    <profileActionOverrides>
        <actionName>Tab</actionName>
        <content>Sales_Home</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>standard-home</pageOrSobjectType>
        <type>Flexipage</type>
        <profile>Custom: Sales Profile</profile>
    </profileActionOverrides>
    <tabs>standard-home</tabs>
    <tabs>Employee_Review__c</tabs>
    <tabs>Product_Quote__c</tabs>
    <tabs>Service_Quote__c</tabs>
    <tabs>Student__c</tabs>
    <tabs>School__c</tabs>
    <tabs>Logs__c</tabs>
    <tabs>CaseReplacementProduct__c</tabs>
    <uiType>Lightning</uiType>
    <utilityBar>LightningSales_UtilityBar</utilityBar>
</CustomApplication>
