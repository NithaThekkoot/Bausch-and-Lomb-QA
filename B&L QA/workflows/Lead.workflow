<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>INDSU_email_sent_to_sales_admin_and_sales_rep_when_lead_record_submitted_for_app</fullName>
        <description>INDSU email sent to sales admin and sales rep when lead record submitted for approval is approved by manager</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>sundarp_su@bausch.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LeadsNewassignmentnotificationSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>INDSU_email_sent_to_sales_rep_when_lead_record_submitted_for_approval_is_rejecte</fullName>
        <description>INDSU email sent to sales rep when lead record submitted for approval is rejected by manager</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SUPPORTCaseescalationnotificationSAMPLE</template>
    </alerts>
    <fieldUpdates>
        <fullName>Complete_Company_Name</fullName>
        <description>USSUR Trade show lead - update Company name with AAO Chicago 2010</description>
        <field>Company</field>
        <formula>&quot;AAO Chicago 2010&quot;</formula>
        <name>Complete Company Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type</fullName>
        <description>Update Record Type for INDSU Trade Show</description>
        <field>RecordTypeId</field>
        <lookupValue>INDSU_Trade_Show</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Create Task when lead Status as Contacted and Contacted Lead Status equals CallBack</fullName>
        <actions>
            <name>Customer_Survey</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Contacted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Contacted_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Call back</value>
        </criteriaItems>
        <description>Create a Task when Contacted Lead Status equals Call Back.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Create Task when lead Status as Contacted and not equal CallBack</fullName>
        <actions>
            <name>Contacted</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Contacted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Contacted_Lead_Status__c</field>
            <operation>notEqual</operation>
            <value>Call back</value>
        </criteriaItems>
        <description>Task creation when Lead Status equals Contacted</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>USSUR Complete Trade Show Lead</fullName>
        <actions>
            <name>Complete_Company_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>USSUR Trade Show</value>
        </criteriaItems>
        <description>USSUR Complete required fields for a trade show lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Record Type for India Trade Show</fullName>
        <actions>
            <name>Update_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>User.User_Role__c</field>
            <operation>contains</operation>
            <value>INDSU</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>contains</operation>
            <value>INDSU</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>contains</operation>
            <value>APAC</value>
        </criteriaItems>
        <description>Update Record Type for India Trade Show</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Contacted</fullName>
        <assignedToType>owner</assignedToType>
        <description>Contacted to the Client.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Contacted</subject>
    </tasks>
    <tasks>
        <fullName>Convert_Lead</fullName>
        <assignedTo>reddyk@su.bausch.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Convert Lead</subject>
    </tasks>
    <tasks>
        <fullName>Customer_Survey</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Customer Survey</subject>
    </tasks>
</Workflow>
