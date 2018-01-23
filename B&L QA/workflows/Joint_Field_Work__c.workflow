<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>APACSU_Update_Joint_Field_Work_Name</fullName>
        <description>Update Joint Field Work Name</description>
        <field>Name</field>
        <formula>&quot;Joint Field Work&quot;+&quot;-&quot;+ TEXT( Activity_Date__c )</formula>
        <name>APACSU Update Joint Field Work Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Joint_Field_Work_Name</fullName>
        <field>Name</field>
        <formula>&quot;Joint Field Work&quot;+&quot;-&quot;+ TEXT( Activity_Date__c )</formula>
        <name>Update Joint Field Work Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>APACSU Update Joint Field Work Name</fullName>
        <actions>
            <name>APACSU_Update_Joint_Field_Work_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Joint_Field_Work__c.Activity_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Joint_Field_Work__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>APACSU Joint Field Work</value>
        </criteriaItems>
        <description>APACSU Update Joint Field Work Name</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>INDSU-Update Joint Field Work Name</fullName>
        <actions>
            <name>Update_Joint_Field_Work_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Joint_Field_Work__c.Activity_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Joint_Field_Work__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>INDSU</value>
        </criteriaItems>
        <description>India SU - Update Joint Field Work Name</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
