<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>USSUR_Dr_Dinner_KOL_Request</fullName>
        <description>USSUR Dr Dinner KOL Request</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>kingn@bausch.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>woodaltv@bausch.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>USSUR/US_Speaker_Request_for_Meeting</template>
    </alerts>
    <alerts>
        <fullName>USSUR_Dr_Dinner_Rejected</fullName>
        <description>USSUR Dr Dinner Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>USSUR/US_Dr_Dinner_Rejected</template>
    </alerts>
    <alerts>
        <fullName>USSUR_Meeting_Evaluation_Complete</fullName>
        <description>USSUR Meeting Evaluation Complete</description>
        <protected>false</protected>
        <recipients>
            <recipient>kingn@bausch.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>woodaltv@bausch.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>USSUR/US_Meeting_Evaluation_Complete</template>
    </alerts>
    <alerts>
        <fullName>USSUR_Rejected_Speaker_Not_Available</fullName>
        <description>USSUR Rejected - Speaker Not Available</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>USSUR/USSUR_Speaker_Not_Available</template>
    </alerts>
    <alerts>
        <fullName>USSUR_Speaker_Confirmed</fullName>
        <description>USSUR Speaker Confirmed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>USSUR/US_Speaker_Confirmed</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approved_Spkr_Requested</fullName>
        <description>USSUR Changes status to approved - Speaker Requested</description>
        <field>Status</field>
        <literalValue>Approved - Spkr Requested</literalValue>
        <name>Approved - Spkr Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>USSUR_Campaign_Complete</fullName>
        <description>USSUR Campaign Complete</description>
        <field>Status</field>
        <literalValue>Completed</literalValue>
        <name>USSUR Campaign Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>USSUR_Mgr_Approved</fullName>
        <description>USSUR Mgr approved.  Used so that if a request is rejected at step 2 and rep resubmits, RBD does not have to approve again</description>
        <field>Manager_Approved__c</field>
        <literalValue>1</literalValue>
        <name>USSUR Mgr Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>USSUR_Rejected_Recalled</fullName>
        <description>USSUR Campaign was rejected or recalled; in both cases, set back to Planning</description>
        <field>Status</field>
        <literalValue>Planning</literalValue>
        <name>USSUR Rejected/Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>USSUR_Speaker_Confirmed</fullName>
        <description>USSUR Speaker Confirmed - field update once Marketing has confirmed speaker availability</description>
        <field>Status</field>
        <literalValue>Speaker Confirmed</literalValue>
        <name>USSUR Speaker Confirmed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>USSUR_Submitted_for_Approval</fullName>
        <description>USSUR Change status to Pending Approval</description>
        <field>Status</field>
        <literalValue>Submitted for Approval</literalValue>
        <name>USSUR Submitted for Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>USSUR_Update_Sales_Rep</fullName>
        <description>USSUR Update Sales Rep</description>
        <field>Sales_Rep__c</field>
        <formula>CreatedBy.FirstName &amp;&quot; &quot;&amp; CreatedBy.LastName &amp;&quot; Cell Phone:&quot;&amp; CreatedBy.MobilePhone &amp;&quot; &quot;&amp; CreatedBy.Email</formula>
        <name>USSUR Update Sales Rep</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>USSUR Dinner Complete</fullName>
        <actions>
            <name>USSUR_Meeting_Evaluation_Complete</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>USSUR_Campaign_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>USSUR Dinner Complete</description>
        <formula>AND(Actual_Food_Beverage_Cost__c &gt;0, Customer_Attendees__c &gt; 0, of_B_L_Attendees__c &gt; 0, NOT(ISPICKVAL(Speaker_s_Knowledge_of_Material__c, &quot;&quot;)),
NOT(ISPICKVAL(Speaker_Engagement__c, &quot;&quot;)),
NOT(ISPICKVAL(Speaker_s_Overall_Presentation_Skills__c, &quot;&quot;)),
NOT(ISPICKVAL(Speaker_s_Ability_to_Answer_Questions__c, &quot;&quot;)),
NOT(ISPICKVAL(Were_any_off_label_questions_raised__c, &quot;&quot;)),
NOT(ISPICKVAL(Were_there_any_non_approved_slides__c, &quot;&quot;)),
Customer_Attendees__c = Number_of_Campaign_Members__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>USSUR Update Sales Rep</fullName>
        <actions>
            <name>USSUR_Update_Sales_Rep</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>USSUR Dr Dinners</value>
        </criteriaItems>
        <description>USSUR Update sales rep from Created by</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
