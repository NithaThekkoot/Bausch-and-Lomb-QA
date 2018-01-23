<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>NA_CS_Case_Product_Complaint_Addl_Contact_Modified</fullName>
        <ccEmails>Julie.Marletta@Bausch.com</ccEmails>
        <ccEmails>Jennie.Burns@Bausch.com</ccEmails>
        <ccEmails>Hollie.Hall@Bausch.com</ccEmails>
        <description>NA CS Case Product Complaint - Addl Contact Modified</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Customer_Service_Email_Templates/NA_CS_Case_Product_Case_Modified_Addl_Contact</template>
    </alerts>
    <outboundMessages>
        <fullName>CATSWeb_Update_Additional_Contacts</fullName>
        <apiVersion>21.0</apiVersion>
        <description>Update CATSWeb with Additional Contacts (Person Accounts) when added product complaint data</description>
        <endpointUrl>https://cqmsts.bausch.com/asxSFDCv7/asxSFDC.aspx</endpointUrl>
        <fields>Account_Name__c</fields>
        <fields>Address_2__c</fields>
        <fields>Address__c</fields>
        <fields>Business_Unit__c</fields>
        <fields>Case_ID_18__c</fields>
        <fields>City__c</fields>
        <fields>Contact_Type__c</fields>
        <fields>Country__c</fields>
        <fields>Email__c</fields>
        <fields>Fax__c</fields>
        <fields>First_Name__c</fields>
        <fields>ID_18__c</fields>
        <fields>Id</fields>
        <fields>Last_Modified_By_Email__c</fields>
        <fields>Last_Name__c</fields>
        <fields>Phone_2__c</fields>
        <fields>Phone__c</fields>
        <fields>Postal_Code__c</fields>
        <fields>Reason_for_Edit_Prior_Value__c</fields>
        <fields>Record_Type__c</fields>
        <fields>Salutation__c</fields>
        <fields>State__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>dataintg_cw@su.bausch.com</integrationUser>
        <name>CATSWeb Update - Additional Contacts</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>CATSWeb Product Complaint Update %E2%80%93 Additional Contacts</fullName>
        <actions>
            <name>CATSWeb_Update_Additional_Contacts</name>
            <type>OutboundMessage</type>
        </actions>
        <actions>
            <name>OB_Additional_Contact_WF_Triggered</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Whenever an Additional Contact is added/modified to a Product Complaint Case, and the related Case has &quot;Send to CATSWeb&quot; of Yes, send the update to CATSWeb.</description>
        <formula>and (   IsPickVal(Case__r.Send_to_CATSWeb__c, &quot;Yes&quot;),   IsPickVal(Case__r.Status, &quot;Open&quot;),   or (     $User.Profile__c  &lt;&gt; &quot;BL: Integration User&quot;,     IsChanged(Send_to_CATSWeb__c)   ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NA Product Complaint Addl Contact - Level 1 Changed</fullName>
        <actions>
            <name>NA_CS_Case_Product_Complaint_Addl_Contact_Modified</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>For NA VC Product Complaints, whenever there is a change to a Level 1 Additional Contact, then an email must be sent out.</description>
        <formula>and (     ISPICKVAL(Case__r.Line_of_Business__c, &quot;Vision Care&quot;),      Not(Contains($Profile.Name, &quot;BL: Integration User&quot;)),     Not(IsNull(Case__r.Complaint_Action_ID__c)),         IsPickVal(Case__r.Status, &quot;Open&quot;),       IsPickVal(Case__r.Level__c, &quot;Level 1&quot;)    )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>OB_Additional_Contact_WF_Triggered</fullName>
        <assignedTo>burnsjr@su.bausch.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Added to Track WF trigger for outbound messages to CATSWeb</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>OB Additional Contact WF Triggered</subject>
    </tasks>
</Workflow>
