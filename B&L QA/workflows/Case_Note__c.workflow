<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>NA_CS_Case_Product_Complaint_Case_Note_Modified</fullName>
        <ccEmails>Julie.Marletta@Bausch.com</ccEmails>
        <ccEmails>Jennie.Burns@Bausch.com</ccEmails>
        <ccEmails>Hollie.Hall@Bausch.com</ccEmails>
        <description>NA CS Case Product Complaint - Case Note Modified</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Customer_Service_Email_Templates/NA_CS_Case_Product_Case_Modified_Case_Note</template>
    </alerts>
    <outboundMessages>
        <fullName>CATSWeb_Update_Case_Notes</fullName>
        <apiVersion>23.0</apiVersion>
        <description>Update CATSWeb with Case Notes when they are created or updated on a Product Complaint Case</description>
        <endpointUrl>https://cqmsts.bausch.com/asxSFDCv7/asxSFDC.aspx</endpointUrl>
        <fields>Case_ID_18__c</fields>
        <fields>CreatedDate</fields>
        <fields>ID_18__c</fields>
        <fields>Id</fields>
        <fields>Last_Modified_By_Email__c</fields>
        <fields>Note_Body__c</fields>
        <fields>Reason_for_Edit_Prior_Value__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>dataintg_cw@su.bausch.com</integrationUser>
        <name>CATSWeb Update - Case Notes</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>CATSWeb Product Complaint Update %E2%80%93 Case Note</fullName>
        <actions>
            <name>CATSWeb_Update_Case_Notes</name>
            <type>OutboundMessage</type>
        </actions>
        <actions>
            <name>OB_Note_WF_Triggered</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Whenever a Case Note is added/modified to a Product Complaint Case, and the related Case has &quot;Send to CATSWeb&quot; of Yes, send the update to CATSWeb.</description>
        <formula>and (    IsPickVal(Case__r.Send_to_CATSWeb__c, &quot;Yes&quot;),    IsPickVal(Case__r.Status, &quot;Open&quot;),    or (      $User.Profile__c &lt;&gt; &quot;BL: Integration User&quot;,      IsChanged(Send_to_CATSWeb__c)    ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NA Product Complaint Case Note - Level 1 Changed</fullName>
        <actions>
            <name>NA_CS_Case_Product_Complaint_Case_Note_Modified</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>For all VC Product Complaints, whenever there is a change to a Level 1 Case Note, then an email must be sent out.</description>
        <formula>and (      IsPickVal(Case__r.Line_of_Business__c, &quot;Vision Care&quot;),      Not(Contains($Profile.Name, &quot;BL: Integration User&quot;)),      Not(IsNull(Case__r.Complaint_Action_ID__c)),      IsPickVal(Case__r.Status, &quot;Open&quot;),      IsPickVal(Case__r.Level__c, &quot;Level 1&quot;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>OB_Note_WF_Triggered</fullName>
        <assignedTo>burnsjr@su.bausch.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Added to Track WF trigger for outbound messages to CATSWeb</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>OB Note WF Triggered</subject>
    </tasks>
</Workflow>
