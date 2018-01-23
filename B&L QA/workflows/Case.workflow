<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>INDSU_Case_forwarded_for_Distribution_Logistic_Complain_Group</fullName>
        <description>INDSU Case forwarded for Distribution &amp; Logistic Complain Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>reddyk@su.bausch.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>APACSU_Email_Templates/Case_Assignment_Logistic_Complaint</template>
    </alerts>
    <alerts>
        <fullName>INDSU_Case_forwarded_for_Medical_Complain_Group</fullName>
        <description>INDSU Case forwarded for Medical Complain Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>reddyk@su.bausch.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>APACSU_Email_Templates/Notification_Medical_Complaint</template>
    </alerts>
    <alerts>
        <fullName>INDSU_Case_forwarded_for_Service_Complain_Group</fullName>
        <description>INDSU Case forwarded for Service Complain Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>reddyk@su.bausch.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>APACSU_Email_Templates/Notification_Merchendising_Complaint</template>
    </alerts>
    <alerts>
        <fullName>NA_CSS_Case_Billing_Team</fullName>
        <ccEmails>su.billing@bausch.com</ccEmails>
        <description>NA CSS Case Billing Team</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Customer_Service_Templates/NA_CSS_Case_Billing_Team</template>
    </alerts>
    <alerts>
        <fullName>NA_CSS_Case_Closed_or_Canceled</fullName>
        <description>NA CSS Case Closed or Canceled</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Service_Templates/NA_CSS_Case_Closed_or_Canceled</template>
    </alerts>
    <alerts>
        <fullName>NA_CSS_Case_Consigment_Team</fullName>
        <ccEmails>su.consign@bausch.com</ccEmails>
        <description>NA CSS Case Consigment Team</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Customer_Service_Templates/NA_CSS_Case_Consignment_Team</template>
    </alerts>
    <alerts>
        <fullName>NA_CSS_Case_Contracts_Team</fullName>
        <description>NA CSS Case Contracts Team</description>
        <protected>false</protected>
        <recipients>
            <recipient>domasik@bausch.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mosierjm@bausch.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Service_Templates/NA_CSS_Case_Contracts_Team</template>
    </alerts>
    <alerts>
        <fullName>NA_CSS_Case_Customer_Master_Team</fullName>
        <ccEmails>SU.Consign@bausch.com</ccEmails>
        <description>NA CSS Case Customer Master Team</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Customer_Service_Templates/NA_CSS_Case_Customer_Master_Team</template>
    </alerts>
    <alerts>
        <fullName>NA_CSS_Case_Out_of_Policy_Approval</fullName>
        <description>NA CSS Case Out of Policy Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>chavarn@bausch.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>premeakf@bausch.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Service_Templates/NA_CSS_Case_Out_of_Policy</template>
    </alerts>
    <alerts>
        <fullName>NA_CSS_Case_Pricing_Team</fullName>
        <ccEmails>SurgicalPricing@bausch.com</ccEmails>
        <description>NA CSS Case Pricing Team</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Customer_Service_Templates/NA_CSS_Case_Pricing_Team</template>
    </alerts>
    <alerts>
        <fullName>NA_CSS_Case_Returns_Team</fullName>
        <ccEmails>blreturns@bausch.com</ccEmails>
        <description>NA CSS Case Returns Team</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Customer_Service_Templates/NA_CSS_Case_Returns_Team</template>
    </alerts>
    <alerts>
        <fullName>NA_CSS_Case_Technical_Team</fullName>
        <ccEmails>csr_surgical@bausch.com</ccEmails>
        <description>NA CSS Case Technical Team</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Customer_Service_Templates/NA_CSS_Case_Technical_Team</template>
    </alerts>
    <alerts>
        <fullName>NA_CS_Case_Product_Complaint_Modified</fullName>
        <ccEmails>Julie.Marletta@Bausch.com</ccEmails>
        <ccEmails>Jennie.Burns@Bausch.com</ccEmails>
        <ccEmails>Hollie.Hall@Bausch.com</ccEmails>
        <description>NA CS Case Product Complaint - Modified</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Customer_Service_Email_Templates/NA_CS_Case_Product_Case_Modified</template>
    </alerts>
    <alerts>
        <fullName>NA_CS_Case_Product_Complaint_Stuck_in_Queue</fullName>
        <ccEmails>Jennie.Burns@Bausch.com</ccEmails>
        <ccEmails>Julie.Marletta@Bausch.com</ccEmails>
        <ccEmails>Hollie.Hall@Bausch.com</ccEmails>
        <description>NA CS Case Product Complaint - Stuck in Queue</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Customer_Service_Email_Templates/NA_CS_Case_Product_Case_Stuck_in_Queue</template>
    </alerts>
    <alerts>
        <fullName>Nordic_Pharma_Account_New_Service_Case</fullName>
        <description>Nordic Pharma Account New Service Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>vrennha@bausch.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EMEA_SU/New_Service_Case_Nordic_Pharma</template>
    </alerts>
    <alerts>
        <fullName>Send_Case_Notification_Email_to_Customer_Services</fullName>
        <description>Send Case Notification Email to Customer Services</description>
        <protected>false</protected>
        <recipients>
            <field>Customer_Svc_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Service_Templates/EMEA_CS_Case_Assigned</template>
    </alerts>
    <alerts>
        <fullName>TEST_EMAIL</fullName>
        <ccEmails>juliebausch@yahoo.com</ccEmails>
        <ccEmails>julie.marletta@bausch.com</ccEmails>
        <ccEmails>shumana34@yahoo.com</ccEmails>
        <description>TEST EMAIL</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Customer_Service_Templates/NA_CSS_Case_Billing_Team</template>
    </alerts>
    <alerts>
        <fullName>ZMG__ZMG_Send_Survey_Email_to_Case_Contact_after_Case_Closed</fullName>
        <description>ZMG_Send Survey Email to Case Contact after Case Closed</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ZMG__Zoomerang_Templates/ZMG__ZMG_Case_Closed_Survey_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>EMEA_CSS_Change_Status_to_Closed</fullName>
        <description>Change Status to Closed</description>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>EMEA CSS Change Status to Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMEA_CS_Populate_SETID_Text_Field</fullName>
        <description>Populates the SETID Text field based on the associated account or the manual picklist, as appropriate. Used by EMEA SU.</description>
        <field>SETID_text__c</field>
        <formula>IF( AccountId = Null, TEXT(SETID_Manual__c), Account.SETID__c)</formula>
        <name>EMEA CS Populate SETID Text Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMEA_Product_Complaint_Close_RecType</fullName>
        <description>Change the Record Type of Case to Read Only when a Product Complaint is closed</description>
        <field>RecordTypeId</field>
        <lookupValue>EMEA_SU_Product_Case_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>EMEA Product Complaint - Close RecType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMEA_Product_Complaint_Open_RecType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>EMEA_SU_Product_Case</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>EMEA Product Complaint - Open RecType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMEA_Product_Complaint_Open_Status</fullName>
        <field>Status</field>
        <literalValue>Open</literalValue>
        <name>EMEA Product Complaint - Open Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMEA_Product_Complaint_Status_Closed</fullName>
        <description>For Product Complaints, when a Complaint is closed in CW, it should get closed in SFDC.</description>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>EMEA Product Complaint - Status Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NA_CSS_Case_Billing_Touchpoints</fullName>
        <description>Increase the Touch Points field for each workflow</description>
        <field>Touchpoints__c</field>
        <formula>Touchpoints__c + 1</formula>
        <name>NA CSS Case Billing Touchpoints</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NA_CSS_Case_Closed_or_Cncld_Touchpoints</fullName>
        <field>Touchpoints__c</field>
        <formula>Touchpoints__c + 1</formula>
        <name>NA CSS Case Closed or Cncld Touchpoints</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NA_CSS_Case_Consignment_Touchpoints</fullName>
        <field>Touchpoints__c</field>
        <formula>Touchpoints__c + 1</formula>
        <name>NA CSS Case Consignment Touchpoints</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NA_CSS_Case_Contracts_Team_Touchpoints</fullName>
        <field>Touchpoints__c</field>
        <formula>Touchpoints__c</formula>
        <name>NA CSS Case Contracts Team Touchpoints</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NA_CSS_Case_Customer_Master_Touchpoints</fullName>
        <field>Touchpoints__c</field>
        <formula>Touchpoints__c</formula>
        <name>NA CSS Case Customer Master Touchpoints</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NA_CSS_Case_Out_of_Policy_Touchpoints</fullName>
        <field>Touchpoints__c</field>
        <formula>Touchpoints__c</formula>
        <name>NA CSS Case Out of Policy Touchpoints</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NA_CSS_Case_Pricing_Touchpoints</fullName>
        <field>Touchpoints__c</field>
        <formula>Touchpoints__c</formula>
        <name>NA CSS Case Pricing Touchpoints</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NA_CSS_Case_Returns_Touchpoints</fullName>
        <field>Touchpoints__c</field>
        <formula>Touchpoints__c + 1</formula>
        <name>NA CSS Case Returns Touchpoints</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NA_CSS_Case_Technical_Team_Touchpoints</fullName>
        <field>Touchpoints__c</field>
        <formula>Touchpoints__c</formula>
        <name>NA CSS Case Technical Team Touchpoints</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NA_Product_Complaint_Close_RecType</fullName>
        <description>Change the Record Type of Case to Read Only when a Product Complaint is closed</description>
        <field>RecordTypeId</field>
        <lookupValue>NA_SU_Product_Case_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>NA Product Complaint - Close RecType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NA_Product_Complaint_Open_RecType</fullName>
        <description>When a Product Complaint is reopened in CATSWeb, the corresponding Case should be reopened in SFDC, and no longer have a Read Only Record Type</description>
        <field>RecordTypeId</field>
        <lookupValue>NA_SU_Product_Case</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>NA Product Complaint - Open RecType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NA_Product_Complaint_Send_to_CATSWeb_Yes</fullName>
        <description>When a Pharma Complaint has a Complaint Type of Technical, send to CATSWeb = Yes.</description>
        <field>Send_to_CATSWeb__c</field>
        <literalValue>Yes</literalValue>
        <name>NA Product Complaint Send to CATSWeb Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NA_Product_Complaint_Status_Closed</fullName>
        <description>For Product Complaints, when a Complaint is closed in CW, it should get closed in SFDC.</description>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>NA Product Complaint - Status Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NA_Product_Complaint_Status_Open</fullName>
        <description>When a Case status changes from CW, update the SFDC status field to match</description>
        <field>Status</field>
        <literalValue>Open</literalValue>
        <name>NA Product Complaint - Status Open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Case_Status_Tracking_Field</fullName>
        <description>Populates Status Tracking field with values of the Route To, Forwarding and Done picklists and checkboxes. EMEA SU CS.</description>
        <field>Status_Tracking__c</field>
        <formula>&quot;[&quot; &amp; BR() &amp; 
IF( LEN( SUBSTITUTE( TEXT( Forward_1__c ), &quot; &quot;, &quot;&quot;) ) &gt; 0, &quot;Forward1: &quot; &amp; SUBSTITUTE( TEXT( Forward_1__c ), &quot; &quot;, &quot;&quot;) &amp; &quot; - &quot; &amp; IF( Forward1_Done__c, &quot;Y&quot;, &quot;N&quot; ) &amp; BR(), &quot;&quot;) &amp; 
IF( LEN( SUBSTITUTE( TEXT( Forward_2__c ), &quot; &quot;, &quot;&quot;) ) &gt; 0, &quot;Forward2: &quot; &amp; SUBSTITUTE( TEXT( Forward_2__c ), &quot; &quot;, &quot;&quot;) &amp; &quot; - &quot; &amp; IF( Forward2_Done__c, &quot;Y&quot;, &quot;N&quot; ) &amp; BR(), &quot;&quot;) &amp; 
IF( LEN( SUBSTITUTE( TEXT( Forward_3__c ), &quot; &quot;, &quot;&quot;) ) &gt; 0, &quot;Forward3: &quot; &amp; SUBSTITUTE( TEXT( Forward_3__c ), &quot; &quot;, &quot;&quot;) &amp; &quot; - &quot; &amp; IF( Forward3_Done__c, &quot;Y&quot;, &quot;N&quot; ) &amp; BR(), &quot;&quot;) &amp; 
IF( LEN( SUBSTITUTE( TEXT( Forward_4__c ), &quot; &quot;, &quot;&quot;) ) &gt; 0, &quot;Forward4: &quot; &amp; SUBSTITUTE( TEXT( Forward_4__c ), &quot; &quot;, &quot;&quot;) &amp; &quot; - &quot; &amp; IF( Forward4_Done__c, &quot;Y&quot;, &quot;N&quot; ) &amp; BR(), &quot;&quot;) &amp; 
IF( LEN( SUBSTITUTE( TEXT( Forward_5__c ), &quot; &quot;, &quot;&quot;) ) &gt; 0, &quot;Forward5: &quot; &amp; SUBSTITUTE( TEXT( Forward_5__c ), &quot; &quot;, &quot;&quot;) &amp; &quot; - &quot; &amp; IF( Forward5_Done__c, &quot;Y&quot;, &quot;N&quot; ) &amp; BR(), &quot;&quot;) &amp; 
IF( LEN( SUBSTITUTE( TEXT( Forward_6__c ), &quot; &quot;, &quot;&quot;) ) &gt; 0, &quot;Forward6: &quot; &amp; SUBSTITUTE( TEXT( Forward_6__c ), &quot; &quot;, &quot;&quot;) &amp; &quot; - &quot; &amp; IF( Forward6_Done__c, &quot;Y&quot;, &quot;N&quot; ) &amp; BR(), &quot;&quot;) 
&amp; &quot;]&quot;</formula>
        <name>Populate Case Status Tracking Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Customer_Service_Email</fullName>
        <description>Sets the appropriate Case notification customer service email based on the related Account SETID.</description>
        <field>Customer_Svc_Email_Address__c</field>
        <formula>CASE(Account.SETID__c,
&apos;UNKGD&apos;, &apos;uksurgorders@bausch.com&apos;, 
&apos;FRANC&apos;, &apos;chirurgie.commande@bausch.com&apos;, 
&apos;SPAIN&apos;, &apos;servclie@bausch.com&apos;, 
&apos;PORTU&apos;, &apos;servclie@bausch.com&apos;, 
&apos;ITALY&apos;, &apos;angelo.chirico@bausch.com&apos;, 
&apos;NETPR&apos;, &apos;medicalnl@bausch.com&apos;, 
&apos;BELGM&apos;, &apos;chirurgie.commande@bausch.com&apos;, 
&apos;NORSE&apos;, &apos;BLNordicSurgical.CSD@bausch.com&apos;, 
&apos;NORDK&apos;, &apos;BLNordicSurgical.CSD@bausch.com&apos;, 
&apos;NORFI&apos;, &apos;BLNordicSurgical.CSD@bausch.com&apos;, 
&apos;NORNO&apos;, &apos;BLNordicSurgical.CSD@bausch.com&apos;, 
&apos;DMBLV&apos;, &apos;kundenservice@bausch.com&apos;, 
&apos;SWICM&apos;, &apos;kundenservice@bausch.com&apos;, 
&apos;AUSTR&apos;, &apos;kundenservice@bausch.com&apos;,
&apos;SAFRI&apos;, &apos;ordersa@bausch.com&apos;,
&apos;CSD-FrontOffice@bausch.com&apos;)</formula>
        <name>Update Customer Service Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>CATSWeb_Update_Case</fullName>
        <apiVersion>22.0</apiVersion>
        <description>Update CATSWeb with NA product complaint data, and DOES include the fields that create the Communication Subtask in CATSWeb.</description>
        <endpointUrl>https://cqmsts.bausch.com/asxSFDCv7/asxSFDC.aspx</endpointUrl>
        <fields>Account_Name__c</fields>
        <fields>Address_2__c</fields>
        <fields>Address__c</fields>
        <fields>Affected_Eye__c</fields>
        <fields>Attachments_in_SFDC_Link__c</fields>
        <fields>Business_Unit__c</fields>
        <fields>CaseNumber</fields>
        <fields>City__c</fields>
        <fields>Comments__c</fields>
        <fields>Complaint_Description__c</fields>
        <fields>Contact_Type__c</fields>
        <fields>Country__c</fields>
        <fields>CreatedDate</fields>
        <fields>Created_By__c</fields>
        <fields>Date_Opened__c</fields>
        <fields>Date_of_Awareness__c</fields>
        <fields>Date_of_Event__c</fields>
        <fields>Department_Assigned_To__c</fields>
        <fields>Email__c</fields>
        <fields>Employee_Assigned_To__c</fields>
        <fields>Fax__c</fields>
        <fields>First_Name__c</fields>
        <fields>ID_18__c</fields>
        <fields>Id</fields>
        <fields>Last_Modified_By_Email__c</fields>
        <fields>Last_Name__c</fields>
        <fields>Level__c</fields>
        <fields>Line_of_Business__c</fields>
        <fields>Manual_Override_of_Lookup__c</fields>
        <fields>Medical_Intervention_Treatment_Desc__c</fields>
        <fields>Medical_Intervention_Treatment_Required__c</fields>
        <fields>Occurrence_Stage__c</fields>
        <fields>Origin</fields>
        <fields>Other_Products_Used__c</fields>
        <fields>Patient_Outcome__c</fields>
        <fields>Phone_2__c</fields>
        <fields>Phone__c</fields>
        <fields>Postal_Code__c</fields>
        <fields>Product_Category__c</fields>
        <fields>Product_Complaint_Reason__c</fields>
        <fields>Reason_for_Edit_Prior_Value__c</fields>
        <fields>Record_Type__c</fields>
        <fields>Response_Requested__c</fields>
        <fields>Return_Required__c</fields>
        <fields>Salutation__c</fields>
        <fields>State__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>dataintg_cw@su.bausch.com</integrationUser>
        <name>CATSWeb Update - Case</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>CATSWeb Product Complaint Update - Case</fullName>
        <actions>
            <name>Case_OB_Message_WF_Triggered</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Whenever a Product Complaint Case is edited or created and the &quot;Send to CATSWeb&quot; field is Yes, then send an update to CATSWeb with the Product Complaint information</description>
        <formula>and ( IsPickVal(Send_to_CATSWeb__c, &quot;Yes&quot;), IsPickVal(Status, &quot;Open&quot;), $User.Profile__c &lt;&gt; &quot;BL: Integration User&quot;, OR($RecordType.DeveloperName = &quot;NA_SU_Product_Case&quot;,$RecordType.DeveloperName = &quot;EMEA_SU_Product_Case&quot; ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EMEA CS Populate Case SETID Text</fullName>
        <actions>
            <name>EMEA_CS_Populate_SETID_Text_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>EMEA Service Case</value>
        </criteriaItems>
        <description>Populates the SETID Text field based on the associated account or the manual picklist, as appropriate. Used by EMEA SU.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EMEA CSS Close Case</fullName>
        <actions>
            <name>EMEA_CSS_Change_Status_to_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>EMEA Service Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Category__c</field>
            <operation>equals</operation>
            <value>Delivery</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Root_Cause__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Cancelled,Canceled,Closed-Resolved,Closed</value>
        </criteriaItems>
        <description>For EMEA Cases with Category of Delivery, if a Root Cause is entered, change Status to Closed</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EMEA Case Populate Status Tracking</fullName>
        <actions>
            <name>Populate_Case_Status_Tracking_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>EMEA Service Case</value>
        </criteriaItems>
        <description>Populates Status Tracking field for EMEA Service Cae</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EMEA Product Complaint - Status Closed in CW</fullName>
        <actions>
            <name>EMEA_Product_Complaint_Close_RecType</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>EMEA_Product_Complaint_Status_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For product complaints, if the Status is closed in CW, the Status should be closed in SFDC.</description>
        <formula>and (  Contains( $RecordType.Name, &quot;EMEA SU Product Case&quot;),    ISCHANGED( Status_from_CATSWeb__c ),         Status_from_CATSWeb__c &lt;&gt; &quot;1&quot;  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EMEA Product Complaint - Status Opened in CW</fullName>
        <actions>
            <name>EMEA_Product_Complaint_Open_RecType</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>EMEA_Product_Complaint_Open_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For product complaints, if the Status is opened in CW, the Status should be opened in SFDC.</description>
        <formula>and (   ISCHANGED(Status_from_CATSWeb__c),   Status_from_CATSWeb__c = &quot;1&quot;,    ISPICKVAL(Send_to_CATSWeb__c, &quot;Yes&quot;) , CONTAINS( $RecordType.Name, &quot;EMEA SU Product Case&quot;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>INDSU Case Assigned for Distribution %26 Logistic Medical Complain</fullName>
        <actions>
            <name>INDSU_Case_forwarded_for_Distribution_Logistic_Complain_Group</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>INDSU CS Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Category__c</field>
            <operation>equals</operation>
            <value>Distribution/Logistics Complaint</value>
        </criteriaItems>
        <description>INDSU Case Assigned for Distribution &amp; Logistic Complaint</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>INDSU Case Assigned for Medical Complain</fullName>
        <actions>
            <name>INDSU_Case_forwarded_for_Medical_Complain_Group</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>INDSU CS Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Category__c</field>
            <operation>equals</operation>
            <value>Medical Complaint</value>
        </criteriaItems>
        <description>INDSU Case Assigned for Medical Complain</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>INDSU Case Assigned for Service Complain</fullName>
        <actions>
            <name>INDSU_Case_forwarded_for_Service_Complain_Group</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>INDSU CS Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Category__c</field>
            <operation>equals</operation>
            <value>Service Complaint</value>
        </criteriaItems>
        <description>INDSU Case Assigned for Service Complain</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NA CSS Case Contracts Team Workflow</fullName>
        <actions>
            <name>NA_CSS_Case_Contracts_Team</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>NA_CSS_Case_Contracts_Team_Touchpoints</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Contracts_Team_Workflow</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and (2 or 3 or 4) and 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>NA Service Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_1__c</field>
            <operation>equals</operation>
            <value>Contracts Team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_2__c</field>
            <operation>equals</operation>
            <value>Contracts Team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_3__c</field>
            <operation>equals</operation>
            <value>Contracts Team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open,Closed</value>
        </criteriaItems>
        <description>NA Case logged for Contracts Team</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NA CSS Case Customer Master Team</fullName>
        <actions>
            <name>NA_CSS_Case_Customer_Master_Team</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>NA_CSS_Case_Customer_Master_Touchpoints</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NA_CSS_Customer_Master_Team_Workflow</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and (2 or 3 or 4) and 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>NA Service Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_1__c</field>
            <operation>equals</operation>
            <value>Customer Master Team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_2__c</field>
            <operation>equals</operation>
            <value>Customer Master Team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_3__c</field>
            <operation>equals</operation>
            <value>Customer Master Team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open,Closed</value>
        </criteriaItems>
        <description>NA Case logged for Customer Master Team</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NA CSS Case Returns Team Workflow</fullName>
        <actions>
            <name>NA_CSS_Case_Returns_Team</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>NA_CSS_Case_Returns_Touchpoints</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Returns_Team_Workflow</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and (2 or 3 or 4) and 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>NA Service Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_1__c</field>
            <operation>equals</operation>
            <value>Returns Team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_2__c</field>
            <operation>equals</operation>
            <value>Returns Team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_3__c</field>
            <operation>equals</operation>
            <value>Returns Team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open,Closed</value>
        </criteriaItems>
        <description>NA Case logged for Returns Team</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NA Case Billing Workflow</fullName>
        <actions>
            <name>NA_CSS_Case_Billing_Team</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>NA_CSS_Case_Billing_Touchpoints</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Billing_Team_Workflow</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and (2 or 3 or 4) and 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>NA Service Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_1__c</field>
            <operation>equals</operation>
            <value>Billing Team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_2__c</field>
            <operation>equals</operation>
            <value>Billing Team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_3__c</field>
            <operation>equals</operation>
            <value>Billing Team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open,Closed</value>
        </criteriaItems>
        <description>NA Case logged for Billing Team</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NA Case Case Closed or Canceled Workflow</fullName>
        <actions>
            <name>NA_CSS_Case_Closed_or_Canceled</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>NA_CSS_Case_Closed_or_Cncld_Touchpoints</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Closed_or_Canceled_Workflow</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>NA Service Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Canceled,Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Inform_Case_Owner_of_Closure__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>NA Case has been Closed or Canceled</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NA Case Consignment Team Workflow</fullName>
        <actions>
            <name>NA_CSS_Case_Consigment_Team</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>NA_CSS_Case_Consignment_Touchpoints</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Consigment_Team_Workflow</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and (2 or 3 or 4) and 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>NA Service Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_1__c</field>
            <operation>equals</operation>
            <value>Consignment Team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_2__c</field>
            <operation>equals</operation>
            <value>Consignment Team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_3__c</field>
            <operation>equals</operation>
            <value>Consignment Team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open,Closed</value>
        </criteriaItems>
        <description>NA Case logged for Consignment Team</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NA Case Out of Policy Workflow</fullName>
        <actions>
            <name>NA_CSS_Case_Out_of_Policy_Approval</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>NA_CSS_Case_Out_of_Policy_Touchpoints</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Out_of_Policy_Workflow</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and (2 or 3 or 4) and 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>NA Service Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_1__c</field>
            <operation>equals</operation>
            <value>Out of Policy</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_2__c</field>
            <operation>equals</operation>
            <value>Out of Policy</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_3__c</field>
            <operation>equals</operation>
            <value>Out of Policy</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open,Closed</value>
        </criteriaItems>
        <description>NA Case logged for out of policy</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NA Case Pricing Team Workflow</fullName>
        <actions>
            <name>NA_CSS_Case_Pricing_Team</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>NA_CSS_Case_Pricing_Touchpoints</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Pricing_Team_Workflow</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and (2 or 3 or 4) and 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>NA Service Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_1__c</field>
            <operation>equals</operation>
            <value>Pricing Team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_2__c</field>
            <operation>equals</operation>
            <value>Pricing Team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_3__c</field>
            <operation>equals</operation>
            <value>Pricing Team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open,Closed</value>
        </criteriaItems>
        <description>NA Case logged for Pricing Team</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NA Case Technical Team Workflow</fullName>
        <actions>
            <name>NA_CSS_Case_Technical_Team</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>NA_CSS_Case_Technical_Team_Touchpoints</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Technical_Team_Workflow</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and (2 or 3 or 4) and 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>NA Service Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_1__c</field>
            <operation>equals</operation>
            <value>Technical Team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_2__c</field>
            <operation>equals</operation>
            <value>Technical Team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_3__c</field>
            <operation>equals</operation>
            <value>Technical Team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open,Closed</value>
        </criteriaItems>
        <description>NA Case logged for Technical Team</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NA Product Complaint  Changed</fullName>
        <actions>
            <name>NA_CS_Case_Product_Complaint_Modified</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>For NA SU Product Complaints , ANY change should generate an email.</description>
        <formula>and (   Contains($RecordType.Name, &quot;Product Case&quot;),   Not(Contains($Profile.Name, &quot;BL: Integration User&quot;)),         Not(IsNull(Complaint_Action_ID__c)),   ISPICKVAL(Status, &quot;Open&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NA Product Complaint - Status Closed in CW</fullName>
        <actions>
            <name>NA_Product_Complaint_Close_RecType</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NA_Product_Complaint_Status_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For product complaints, if the Status is closed in CW, the Status should be closed in SFDC.</description>
        <formula>and (  Contains( $RecordType.Name, &quot;NA SU Product Case&quot;),   ISCHANGED(Status_from_CATSWeb__c),        Status_from_CATSWeb__c  &lt;&gt; &quot;1&quot;  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NA Product Complaint - Status Opened in CW</fullName>
        <actions>
            <name>NA_Product_Complaint_Open_RecType</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NA_Product_Complaint_Status_Open</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For product complaints, if the Status is opened in CW, the Status should be opened in SFDC.</description>
        <formula>and (   ISCHANGED(Status_from_CATSWeb__c),   Status_from_CATSWeb__c = &quot;1&quot;,    ISPICKVAL(Send_to_CATSWeb__c, &quot;Yes&quot;) , CONTAINS( $RecordType.Name, &quot;NA SU Product Case&quot;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NA Product Complaint CATSWeb Yes</fullName>
        <actions>
            <name>NA_Product_Complaint_Send_to_CATSWeb_Yes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Complaint_Type__c</field>
            <operation>equals</operation>
            <value>Technical</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CreatedDate</field>
            <operation>greaterThan</operation>
            <value>2/1/2013</value>
        </criteriaItems>
        <description>For Pharma Complaints, set the Send to CATSWeb field to Yes when Complaint Type is Technical</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Service Case Nordic Pharma</fullName>
        <actions>
            <name>Nordic_Pharma_Account_New_Service_Case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.SETID__c</field>
            <operation>equals</operation>
            <value>NORNO,NORFI,NORDK,NORSE</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Ship_to_ID__c</field>
            <operation>equals</operation>
            <value>70000465,70000720,70000544,72003164,72003154,72003162,60001803,60001173,60001422,60000894,80000686</value>
        </criteriaItems>
        <description>Used by EMEA Nordic CS to receive email notifications when a new service case is logged on a pharmaceutical account</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify Customer Services%3A Event triggered Case Created</fullName>
        <actions>
            <name>Send_Case_Notification_Email_to_Customer_Services</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Customer_Service_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>EMEA Service Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Sales Call</value>
        </criteriaItems>
        <description>Email customer services when a Case has been automatically created as the result of a &quot;Customer Complaint&quot; sales call being logged.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Product Complaint - Close Inquiry</fullName>
        <actions>
            <name>NA_Product_Complaint_Status_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>contains</operation>
            <value>Product Inquiry</value>
        </criteriaItems>
        <description>For all Product Inquiries, all should be closed on save, as they don&apos;t remain open.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Product Complaint - Update Stuck in Queue</fullName>
        <active>true</active>
        <description>For Product Complaints, if the Send to CATSWeb field is Yes, but there is no Complaint Number, it means the outbound message is stuck in the queue and needs to be resolved.</description>
        <formula>and (      IsPickVal(Send_to_CATSWeb__c, &quot;Yes&quot;),       CATSWeb_Complaint_Number__c = &quot;&quot;   )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>NA_CS_Case_Product_Complaint_Stuck_in_Queue</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TEST EMAIL</fullName>
        <actions>
            <name>TEST_EMAIL</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Case.Root_Cause_Description__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ZMG__ZMG_Case Closed Survey Completed</fullName>
        <actions>
            <name>ZMG__ZMG_Survey_Completed_by_Case_Contact</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ZMG__ZMG_Survey_Completed__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Task created when Zoomerang Survey is completed related to a closed Case.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ZMG__ZMG_Case Closed Survey Sent</fullName>
        <actions>
            <name>ZMG__ZMG_Survey_Sent_to_Case_Contact</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Email sent to Case Contact with Zoomerang Survey when Case is Closed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Billing_Team_Workflow</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Low</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Billing Team Workflow</subject>
    </tasks>
    <tasks>
        <fullName>Case_OB_Message_WF_Triggered</fullName>
        <assignedTo>burnsjr@su.bausch.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>-1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>2</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Case OB Message WF Triggered</subject>
    </tasks>
    <tasks>
        <fullName>Closed_or_Canceled_Workflow</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Low</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Closed or Canceled Workflow</subject>
    </tasks>
    <tasks>
        <fullName>Consigment_Team_Workflow</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Low</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Consigment Team Workflow</subject>
    </tasks>
    <tasks>
        <fullName>Contracts_Team_Workflow</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Low</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Contracts Team Workflow</subject>
    </tasks>
    <tasks>
        <fullName>NA_CSS_Customer_Master_Team_Workflow</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Low</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Customer Master Team Workflow</subject>
    </tasks>
    <tasks>
        <fullName>Out_of_Policy_Workflow</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Low</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Out of Policy Workflow</subject>
    </tasks>
    <tasks>
        <fullName>Pricing_Team_Workflow</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Low</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Pricing Team Workflow</subject>
    </tasks>
    <tasks>
        <fullName>Returns_Team_Workflow</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Low</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Returns Team Workflow</subject>
    </tasks>
    <tasks>
        <fullName>Technical_Team_Workflow</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Low</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Technical Team Workflow</subject>
    </tasks>
    <tasks>
        <fullName>ZMG__ZMG_Survey_Completed_by_Case_Contact</fullName>
        <assignedToType>owner</assignedToType>
        <description>Copy and paste this link to view the Survey:
[Insert public survey URL here for reference]</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Survey Completed : &apos;Customer Satisfaction with Customer Service&apos;</subject>
    </tasks>
    <tasks>
        <fullName>ZMG__ZMG_Survey_Sent_to_Case_Contact</fullName>
        <assignedToType>owner</assignedToType>
        <description>Copy and paste this link to view the Survey:
[Insert public survey URL here for reference]</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Survey Sent : &apos;Customer Satisfaction with Customer Service&apos;</subject>
    </tasks>
</Workflow>
