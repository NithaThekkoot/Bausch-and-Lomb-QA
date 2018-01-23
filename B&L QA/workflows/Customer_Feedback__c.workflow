<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Reset_Declined</fullName>
        <description>Reset the decline check box back to false</description>
        <field>Declined__c</field>
        <literalValue>0</literalValue>
        <name>Reset Declined</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Account_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Call_Date</fullName>
        <description>Set Call Date = today if Maual Participation Response was Yes</description>
        <field>Call_Date__c</field>
        <formula>today()</formula>
        <name>Set Call Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Declined</fullName>
        <description>Set the declined check box on the Account to TRUE if the Customer feedback Response was DO NOT Ask Again</description>
        <field>Declined__c</field>
        <literalValue>1</literalValue>
        <name>Set Declined</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Account_Name__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Do Not Ask Again Flag</fullName>
        <actions>
            <name>Set_Declined</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Feedback__c.Participation_Response__c</field>
            <operation>equals</operation>
            <value>Do Not Ask Again</value>
        </criteriaItems>
        <description>Set a Declined flag on the account if feedback response is DO NOT ASK Again</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Reset_Declined</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>180</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Set Call Date</fullName>
        <actions>
            <name>Set_Call_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Feedback__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Manual</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Feedback__c.Participation_Response__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Set the call date if Manual Participation Response = Yes (temporary way to indicate when surveyed - until integration is built)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
