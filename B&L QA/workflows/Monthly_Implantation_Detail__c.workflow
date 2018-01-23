<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Current_Total_Implantations</fullName>
        <field>Current_Total_Implantations__c</field>
        <formula>IF(Current_Total_Implantations_Done__c&lt; 1,1,Current_Total_Implantations_Done__c)</formula>
        <name>Update Current Total Implantations</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>INDSU Populate Current Total Implantations</fullName>
        <actions>
            <name>Update_Current_Total_Implantations</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Monthly_Implantation_Detail__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>APACSU Monthly Implantation Detail,INDSU Monthly Implantation Detail</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
