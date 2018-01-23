<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_FirstUpdate</fullName>
        <field>FirstUpdate__c</field>
        <literalValue>1</literalValue>
        <name>Update_FirstUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ServiceProduct_UpdateFirstUpdate</fullName>
        <actions>
            <name>Update_FirstUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Service_Product__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>APACSU Technical Service,APACSU Service Rep Product</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
