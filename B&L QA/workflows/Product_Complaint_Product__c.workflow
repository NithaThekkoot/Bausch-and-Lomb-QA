<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>NA_CS_Case_Product_Complaint_Product_Modified</fullName>
        <ccEmails>Julie.Marletta@Bausch.com</ccEmails>
        <ccEmails>Jennie.Burns@Bausch.com</ccEmails>
        <ccEmails>Hollie.Hall@Bausch.com</ccEmails>
        <description>NA CS Case Product Complaint - Product Modified</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Customer_Service_Email_Templates/NA_CS_Case_Product_Case_Modified_Product</template>
    </alerts>
    <outboundMessages>
        <fullName>CATSWeb_Update_Product</fullName>
        <apiVersion>21.0</apiVersion>
        <description>Update CATSWeb with Products when added to Product Complaint</description>
        <endpointUrl>https://cqmsts.bausch.com/asxSFDCv7/asxSFDC.aspx</endpointUrl>
        <fields>CATSWeb_Complaint_Number__c</fields>
        <fields>Carton_Lot_Number__c</fields>
        <fields>Case_ID_18__c</fields>
        <fields>Comments__c</fields>
        <fields>Complaint_Quantity_Int__c</fields>
        <fields>Date_Received_Subsidiary__c</fields>
        <fields>Date_Received__c</fields>
        <fields>Expiration_Date__c</fields>
        <fields>ID_18__c</fields>
        <fields>Id</fields>
        <fields>Last_Modified_By_Email__c</fields>
        <fields>Line_of_Business__c</fields>
        <fields>Manufacturing_Site__c</fields>
        <fields>Product_Availability__c</fields>
        <fields>Product_Category__c</fields>
        <fields>Product_Description__c</fields>
        <fields>Product_Lot_Number__c</fields>
        <fields>Product_Number__c</fields>
        <fields>Product_Type__c</fields>
        <fields>Quantity_Received_Int__c</fields>
        <fields>Quantity_to_be_Returned_Int__c</fields>
        <fields>Reason_for_Edit_Prior_Value__c</fields>
        <fields>Record_Type__c</fields>
        <fields>Serial_Number__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>dataintg_cw@su.bausch.com</integrationUser>
        <name>CATSWeb Update - Product</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>CATSWeb Product Complaint Update %E2%80%93 Product</fullName>
        <actions>
            <name>CATSWeb_Update_Product</name>
            <type>OutboundMessage</type>
        </actions>
        <actions>
            <name>SU_OB_Product_Triggered</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Whenever a product is added/modified to a Product Complaint Case, and the related Case &quot;Send to CATSWeb&quot; field is Yes, update CATSWeb with the Product information.</description>
        <formula>and (   IsPickVal(Case__r.Send_to_CATSWeb__c, &quot;Yes&quot;),   IsPickVal(Case__r.Status, &quot;Open&quot;),   OR($RecordType.DeveloperName = &quot;NA_SU_Product&quot;, $RecordType.DeveloperName = &quot;EMEA_SU_Product&quot;), or (     $User.Profile__c &lt;&gt; &quot;BL: Integration User&quot;,     IsChanged(Send_to_CATSWeb__c)   ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NA Product Complaint Product - Level 1 Changed</fullName>
        <actions>
            <name>NA_CS_Case_Product_Complaint_Product_Modified</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>For NA SU Product Complaints, whenever there is a change to a Level 1 Product, then an email must be sent out.</description>
        <formula>and (   IsPickVal(Case__r.Line_of_Business__c, &quot;Vision Care&quot;),   Not(Contains($Profile.Name, &quot;BL: Integration User&quot;)),   Not(IsNull(Case__r.Complaint_Action_ID__c)),   IsPickVal(Case__r.Status, &quot;Open&quot;),   IsPickVal(Case__r.Level__c, &quot;Level 1&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>SU_OB_Product_Triggered</fullName>
        <assignedTo>burnsjr@su.bausch.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Added to Track WF trigger for outbound messages to CATSWeb</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>SU OB Product Triggered</subject>
    </tasks>
</Workflow>
