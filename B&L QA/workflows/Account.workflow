<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>BLUSA_BU_Update</fullName>
        <description>Update the BLUSA Account with Business Unit = BLUSA</description>
        <field>Business_Unit__c</field>
        <literalValue>BLUSA</literalValue>
        <name>BLUSA BU Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DASRX_Copy_Shipping_to_Billing_Country</fullName>
        <field>BillingCountry</field>
        <formula>ShippingCountry</formula>
        <name>DASRX Copy Shipping to Billing Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DASRX_Copy_Shipping_to_Billing_State</fullName>
        <field>BillingState</field>
        <formula>ShippingState</formula>
        <name>DASRX Copy Shipping to Billing State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DASRX_Copy_Shipping_to_Billing_Street</fullName>
        <field>BillingStreet</field>
        <formula>ShippingStreet</formula>
        <name>DASRX Copy Shipping to Billing Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DASRX_Copy_Shipping_to_Billing_Zip</fullName>
        <field>BillingPostalCode</field>
        <formula>ShippingPostalCode</formula>
        <name>DASRX Copy Shipping to Billing Zip</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DASRX_Update_Billing_City</fullName>
        <field>BillingCity</field>
        <formula>ShippingCity</formula>
        <name>DASRX Copy Shipping to Billing City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMEA_SU_EM_Update_Shipto_from_EM_ShipTo</fullName>
        <description>Update the ship to id field with the value in the EM-shipto autonumber field. Used by EMEASU Emerging Markets (EMEASU Emerging Markets recordtype).</description>
        <field>Ship_To_Id__c</field>
        <formula>EM_ShipTo__c</formula>
        <name>EMEA SU EM Update Shipto from EM-ShipTo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BLUSA BU Update</fullName>
        <actions>
            <name>BLUSA_BU_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.SETID__c</field>
            <operation>equals</operation>
            <value>BLUSA</value>
        </criteriaItems>
        <description>Update Business Unit = BLUSA if setid = BLUSA</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DASRX Copy Shipping Address</fullName>
        <actions>
            <name>DASRX_Copy_Shipping_to_Billing_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DASRX_Copy_Shipping_to_Billing_State</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DASRX_Copy_Shipping_to_Billing_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DASRX_Copy_Shipping_to_Billing_Zip</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DASRX_Update_Billing_City</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.ShippingCountry</field>
            <operation>equals</operation>
            <value>DEU,CHE,Germany,Switzerland</value>
        </criteriaItems>
        <description>Copies shipping address into billing address. This way once a contact is created SFDC defaults the contact&apos;s mailing address.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EMEA SU EM Update ShipTo from EM-ShipTo</fullName>
        <actions>
            <name>EMEA_SU_EM_Update_Shipto_from_EM_ShipTo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>EMEASU Emerging Markets</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Ship_To_Id__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Populates the ship to id field from the autonumber value in EM-ShipTo. Used by EMEA SU Emerging Markets (EMEA SU Emerging Markets recordtype).</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
