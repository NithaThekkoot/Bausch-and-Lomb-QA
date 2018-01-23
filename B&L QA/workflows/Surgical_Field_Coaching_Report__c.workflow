<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>FCR_Acknowledged</fullName>
        <description>FCR Acknowledged</description>
        <protected>false</protected>
        <recipients>
            <field>Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>USSUR/FCR_Acknowledged</template>
    </alerts>
    <alerts>
        <fullName>FCR_Completed_Notify_Rep</fullName>
        <description>FCR Completed Notify Rep</description>
        <protected>false</protected>
        <recipients>
            <field>Representative__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>USSUR/Manager_Completed_FCR</template>
    </alerts>
    <alerts>
        <fullName>FCR_created_Notify_Manager</fullName>
        <description>FCR created Notify Manager</description>
        <protected>false</protected>
        <recipients>
            <field>Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>USSUR/Rep_Created_FCR</template>
    </alerts>
    <fieldUpdates>
        <fullName>FCR_Record_Type_Update_to_Accepted</fullName>
        <field>RecordTypeId</field>
        <lookupValue>USSUR_Accepted</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>FCR Record Type Update to Accepted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FCR_Status_Update</fullName>
        <field>Status__c</field>
        <literalValue>Accepted</literalValue>
        <name>FCR Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_FCR_Rec_Type_to_Complete</fullName>
        <field>RecordTypeId</field>
        <lookupValue>USSUR_Completed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update FCR Rec Type to Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_FCR_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>USSUR_In_Process</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update FCR Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_FCR_status_to_Manager_Notified</fullName>
        <field>Status__c</field>
        <literalValue>Manager Notified</literalValue>
        <name>Update FCR status to Manager Notified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Complete</fullName>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Update Status to Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_In_Process</fullName>
        <field>Status__c</field>
        <literalValue>In-Process</literalValue>
        <name>Update Status to In-Process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>FCR Acknowledged</fullName>
        <actions>
            <name>FCR_Acknowledged</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>FCR_Record_Type_Update_to_Accepted</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FCR_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Surgical_Field_Coaching_Report__c.Rep_Reviewed_Accepted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Rep Acknowledged reviewing FCR - Update status to lock down as Read only</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FCR Completed Notify Rep</fullName>
        <actions>
            <name>FCR_Completed_Notify_Rep</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_FCR_Rec_Type_to_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Status_to_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Surgical_Field_Coaching_Report__c.Submit_FCR_will_become_read_only__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>FCR Completed Notify Rep</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FCR Entered Notify Manager</fullName>
        <actions>
            <name>FCR_created_Notify_Manager</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_FCR_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_FCR_status_to_Manager_Notified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Surgical_Field_Coaching_Report__c.Submitted_to_Manager__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Notify the Manager when a rep creates a FCR</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
