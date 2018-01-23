<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Remind_Approved_Of_Physician_Visit</fullName>
        <description>Remind Approved Of Physician Visit</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/PhysicianVisit_Notify_Engineer_Approved</template>
    </alerts>
    <alerts>
        <fullName>Remind_Rejected_Of_Physician_Visit</fullName>
        <description>Remind Rejected Of Physician Visit</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/PhysicianVisit_Notify_Engineer_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Reminder_Approved_Of_Physician_Visit</fullName>
        <description>Reminder Approved Of Physician Visit</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/PhysicianVisit_Notify_Engineer_Approved</template>
    </alerts>
    <alerts>
        <fullName>Reminder_Rejected_Of_Physician_Visit</fullName>
        <description>Reminder Rejected Of Physician Visit</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/PhysicianVisit_Notify_Engineer_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>APACSU_Update_Sales_Record_Type</fullName>
        <description>APACSU - Update Sales Record Type From Unplanned to Planned</description>
        <field>RecordTypeId</field>
        <lookupValue>APACSU_Sales_Planned</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>APACSU-Update Sales Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CHNSU_Update_Status_to_Completed</fullName>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <name>CHNSU-Update Status to Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>India_SU_Update_Sales_Record_Type</fullName>
        <description>India SU - Update Sales Record Type From Unplanned to Planned</description>
        <field>RecordTypeId</field>
        <lookupValue>INDSU_Sales_Planned</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>India SU-Update Sales Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>India_SU_Update_Service_Record_Type</fullName>
        <description>India SU - Update Service Record Type From Unplanned to Planned</description>
        <field>RecordTypeId</field>
        <lookupValue>INDSU_Service_Planned</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>India SU - Update Service Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Stage_To_Rejected</fullName>
        <field>Approval_Stage__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Approval Stage To Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Stage_to_Approved</fullName>
        <field>Approval_Stage__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Approval Stage to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Stage_to_Submitted</fullName>
        <field>Approval_Stage__c</field>
        <literalValue>Submitted</literalValue>
        <name>Update Approval Stage to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approved_Time</fullName>
        <field>Time_Of_Approved__c</field>
        <formula>NOW()</formula>
        <name>Update Approved Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_To_Rejected</fullName>
        <field>Approval_Stage__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Stage To Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_Approved</fullName>
        <field>Approval_Stage__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Stage to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_Submitted</fullName>
        <field>Approval_Stage__c</field>
        <literalValue>Submitted</literalValue>
        <name>Update Stage to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Submission_Time</fullName>
        <field>Time_Of_Submission__c</field>
        <formula>NOW()</formula>
        <name>Update Submission Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updating_Approved_Time</fullName>
        <field>Time_Of_Approved__c</field>
        <formula>NOW()</formula>
        <name>Updating Approved Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>APACSU Update Physician Visit Name</fullName>
        <active>false</active>
        <booleanFilter>(1 AND 2) AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Physician_Visit__c.Activity_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Physician_Visit__c.Physician_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Physician_Visit__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>APACSU Sales Planned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Physician_Visit__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>APACSU Sales Unplanned</value>
        </criteriaItems>
        <description>APACSU Update Physician Visit Name
[Tulipe] Inactivated on Sep 26, 2011 because Physician Visit Name changed to auto-number field</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APACSU Update Sales Record Type</fullName>
        <actions>
            <name>APACSU_Update_Sales_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Physician_Visit__c.Planned_Call__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Physician_Visit__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>APACSU Sales Unplanned</value>
        </criteriaItems>
        <description>APAC SU Update Sales Record Type For Unplanned Call</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CHNSU-Update Status</fullName>
        <actions>
            <name>CHNSU_Update_Status_to_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Physician_Visit__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>Physician_Visit__c.Call_Duration_Mns__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Physician_Visit__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>APACSU Sales Planned,APACSU Sales Unplanned,INDSU Sales Planned,INDSU Sales Unplanned,INDSU Service Planned,INDSU Service Unplanned</value>
        </criteriaItems>
        <description>The Status field is set read-only on CHNSU Other Call Activity layout and auto updated when record is saved.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>INDSU Update Physician Visit Name</fullName>
        <active>true</active>
        <booleanFilter>(1 AND 2) AND (3 OR 4 OR 5 OR 6)</booleanFilter>
        <criteriaItems>
            <field>Physician_Visit__c.Activity_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Physician_Visit__c.Physician_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Physician_Visit__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>INDSU Service Unplanned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Physician_Visit__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>INDSU Sales Planned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Physician_Visit__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>INDSU Sales Unplanned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Physician_Visit__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>INDSU Service Planned</value>
        </criteriaItems>
        <description>India SU Update Physician Visit Name</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>INDSU- Update Physician Visit Name</fullName>
        <active>false</active>
        <booleanFilter>(1 AND 2) AND (3 OR 4 OR 5 OR 6)</booleanFilter>
        <criteriaItems>
            <field>Physician_Visit__c.Activity_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Physician_Visit__c.Physician_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Physician_Visit__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>INDSU Service Unplanned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Physician_Visit__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>INDSU Sales Planned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Physician_Visit__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>INDSU Sales Unplanned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Physician_Visit__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>INDSU Service Planned</value>
        </criteriaItems>
        <description>India SU- Update Physician Visit Name</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>INDSU- Update Sales Record Type</fullName>
        <actions>
            <name>India_SU_Update_Sales_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Physician_Visit__c.Planned_Call__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Physician_Visit__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>INDSU Sales Unplanned</value>
        </criteriaItems>
        <description>India SU- Update Sales Record Type For Unplanned Call</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>INDSU- Update Service Record Type</fullName>
        <actions>
            <name>India_SU_Update_Service_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Physician_Visit__c.Planned_Call__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Physician_Visit__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>INDSU Service Unplanned</value>
        </criteriaItems>
        <description>India SU- Update Service Record Type For Unplanned Call</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
