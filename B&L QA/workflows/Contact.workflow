<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_CL_New_Start_Rep</fullName>
        <description>USSUR Set CL New Start Rep</description>
        <field>CL_New_Start_Rep__c</field>
        <formula>$User.FirstName &amp; &quot; &quot; &amp; $User.LastName</formula>
        <name>Set CL New Start Rep</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_P3_Rep</fullName>
        <field>P3_Rep__c</field>
        <formula>$User.FirstName &amp; &quot; &quot;    &amp; $User.LastName</formula>
        <name>Set P3 Rep</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set CL New Start Rep</fullName>
        <actions>
            <name>Set_CL_New_Start_Rep</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.CL_New_Start_Process_Start_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>USSUR Contact</value>
        </criteriaItems>
        <description>Set CL New Start Rep field = Name of rep updaing Contact when CL New Start Process Start Date is entered.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set P3 Rep</fullName>
        <actions>
            <name>Set_P3_Rep</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.P3_Process_Start_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>USSUR Contact</value>
        </criteriaItems>
        <description>Set P3 Rep field = Name of rep updating Contact when P3 Date is entered.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
