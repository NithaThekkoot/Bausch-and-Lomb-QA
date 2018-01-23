<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Amount_Received_to_Monthly_Payment</fullName>
        <description>Sets the Amount Received field equal to the Contract.Alliance_Monthly_Payment__c</description>
        <field>Amount_Received__c</field>
        <formula>Contract__r.Alliance_Monthly_Payment__c</formula>
        <name>Set Amount Received to Monthly Payment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Amount Received to Monthly Payment</fullName>
        <actions>
            <name>Set_Amount_Received_to_Monthly_Payment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Alliance_Payment_Details__c.Payment_Received__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Sets the Amount Received field on this object to equal the Alliance Monthly Payment  on the associated Contract when the user checks the Payment Received flag.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
