<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Legacy_System_ID_on_Account_Profile</fullName>
        <description>Used to default the Legacy System ID into a new account profile. Value should be the concatenation of the Legacy System ID for the related account and the record type value</description>
        <field>Legacy_System_Id__c</field>
        <formula>Account__r.Legacy_System_Id__c&amp; $RecordType.DeveloperName</formula>
        <name>Set Legacy System ID on Account Profile</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
