<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>USSUR_Update_Sales_price_field</fullName>
        <description>US Sur Update sales price field with amount from the PS quote for the Instrument group</description>
        <field>UnitPrice</field>
        <formula>PS_Total_Price_on_Quote__c/ Quantity</formula>
        <name>USSUR Update Sales price field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Cost</fullName>
        <field>Total_cost__c</field>
        <formula>Quantity  *  Standard_Cost__c</formula>
        <name>Update Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Amount on PS Opp</fullName>
        <actions>
            <name>USSUR_Update_Sales_price_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.PS_Total_Price_on_Quote__c</field>
            <operation>greaterThan</operation>
            <value>USD 0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>USSUR INSTR</value>
        </criteriaItems>
        <description>USSUR update the Amount on the US Surg Instrument Opp with the amount from the PS field</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Cost</fullName>
        <actions>
            <name>Update_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Quantity</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>USSUR CPQ</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
