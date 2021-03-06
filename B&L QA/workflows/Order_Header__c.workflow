<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Bill_To_Account_Name</fullName>
        <field>Bill_To_Account_Name__c</field>
        <formula>Account__r.Bill_To_Name__c</formula>
        <name>Update Bill To Account Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Bill_To_Address_1_on_Order</fullName>
        <field>Bill_To_Address_1__c</field>
        <formula>Account__r.Bill_To_Address_1__c</formula>
        <name>Update Bill To Address 1 on Order</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Bill_To_Address_2_On_Order</fullName>
        <field>Bill_To_Address_2__c</field>
        <formula>Account__r.Bill_To_Address_2__c</formula>
        <name>Update Bill To Address 2 On Order</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Bill_To_City</fullName>
        <field>Bill_To_City__c</field>
        <formula>Account__r.BillingCity</formula>
        <name>Update Bill To City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Bill_To_ID</fullName>
        <field>Bill_To_ID__c</field>
        <formula>Account__r.Bill_To__c</formula>
        <name>Update Bill To ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Bill_To_Postcode</fullName>
        <field>Bill_To_Postcode__c</field>
        <formula>Account__r.BillingPostalCode</formula>
        <name>Update Bill To Postcode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SF_Order_Name</fullName>
        <description>Update the Order Ref field for all Salesforce entered orders. The Order name will be overwritten with the autogenerated SF number when saving the record. For all non-SF created records (ie. those from PS) the order name will reflect the PS Order Ref</description>
        <field>Name</field>
        <formula>SF_Order_Number__c</formula>
        <name>Update SF Order Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>NORDCSS%3A Set the Order Name for SF Orders</fullName>
        <actions>
            <name>Update_SF_Order_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order_Header__c.Name</field>
            <operation>equals</operation>
            <value>auto</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>BL: Integration User</value>
        </criteriaItems>
        <description>When an order is created in salesforce the workflow should update the name field with the prefixed Salesforce autonumber.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NORDCSS%3A Update Billing Information</fullName>
        <actions>
            <name>Update_Bill_To_Account_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Bill_To_Address_1_on_Order</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Bill_To_Address_2_On_Order</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Bill_To_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Bill_To_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Bill_To_Postcode</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order_Header__c.Ship_To_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Updates the Billing information in the Order header on saving a record.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
