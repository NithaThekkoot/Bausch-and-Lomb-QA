<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notification_of_Sample_Request_Approval_to_Submitter</fullName>
        <description>Notification of Sample Request Approval to Submitter</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EMEA_SU/EMEASU_Sample_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>Notification_of_Sample_Request_Rejection_to_Submitter</fullName>
        <description>Notification of Sample Request Rejection to Submitter</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EMEA_SU/EMEASU_Sample_Request_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_customer_svc</fullName>
        <description>Notification to customer svc</description>
        <protected>false</protected>
        <recipients>
            <field>Customer_Svc_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EMEA_SU/EMEASU_Sample_Request_to_CSS</template>
    </alerts>
    <alerts>
        <fullName>notificationtocustomersvc</fullName>
        <description>Notification to customer svc</description>
        <protected>false</protected>
        <recipients>
            <field>Customer_Svc_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>USECS_Sales_Rep_Templates/Sample_Request_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>Assign_Sample_Request_to_Cust_Svc</fullName>
        <description>ECS assign update</description>
        <field>OwnerId</field>
        <lookupValue>NALCustomerService</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign Sample Request to Cust Svc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_CSS_Email_Address</fullName>
        <description>Populates the CSS Email Address field with the correct customer services email for the customer&apos;s region. Used by EMEA SU.</description>
        <field>Customer_Svc_Email_Address__c</field>
        <formula>CASE ( IF ( Account__r.SETID__c = &apos;&apos;, Territory_Manager_Account__r.SETID__c , Account__r.SETID__c ) , 
&apos;UNKGD&apos;, &apos;uksurgorders@bausch.com&apos;, 
&apos;FRANC&apos;, &apos;chirurgie.commande@bausch.com&apos;, 
&apos;SPAIN&apos;, &apos;servclie@bausch.com&apos;, 
&apos;PORTU&apos;, &apos;servclie@bausch.com&apos;, 
&apos;ITALY&apos;, &apos;angelo.chirico@bausch.com&apos;, 
&apos;NETPR&apos;, &apos;medicalnl@bausch.com&apos;, 
&apos;BELGM&apos;, &apos;surgicalbe@bausch.com&apos;, 
&apos;NORSE&apos;, &apos;BLNordicSurgical.CSD@bausch.com&apos;, 
&apos;NORDK&apos;, &apos;BLNordicSurgical.CSD@bausch.com&apos;, 
&apos;NORFI&apos;, &apos;BLNordicSurgical.CSD@bausch.com&apos;, 
&apos;NORNO&apos;, &apos;BLNordicSurgical.CSD@bausch.com&apos;, 
&apos;DMBLV&apos;, &apos;kundenservice@bausch.com&apos;,
&apos;SWICM&apos;, &apos;kundenservice@bausch.com&apos;,
&apos;AUSTR&apos;, &apos;kundenservice@bausch.com&apos;, 
&apos;&apos;)</formula>
        <name>Populate CSS Email Address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approver_on_Request</fullName>
        <description>Sets the Approver (&quot;Approved/Rejected By&quot;) field on the sample request to the name of the individual. Used by EMEA SU</description>
        <field>Approver__c</field>
        <formula>$User.FirstName + &apos; &apos; + $User.LastName</formula>
        <name>Set Approver on Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Sample_Request_Date</fullName>
        <description>ECS</description>
        <field>Date_Request_Submitted__c</field>
        <formula>TODAY()</formula>
        <name>Set Sample Request Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sample_Request_Status_Fulfilled</fullName>
        <description>Indicates the sample request has gone to the CSS group. 
Used by EMEA SU.</description>
        <field>Request_Status__c</field>
        <literalValue>Request Fulfilled</literalValue>
        <name>Update Sample Request Status - Fulfilled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sample_Request_Status_Issue</fullName>
        <description>Updates the sample status to &quot;Sample Issue&quot; - the manager has rejected this request. 
Used by EMEA SU.</description>
        <field>Request_Status__c</field>
        <literalValue>Request Issue</literalValue>
        <name>Update Sample Request Status - Issue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Submitted</fullName>
        <description>Updates the Sample Request Status to &quot;Request Submitted&quot;. Used by EMEA SU.</description>
        <field>Request_Status__c</field>
        <literalValue>Request Submitted</literalValue>
        <name>Update Status to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Process Sample Request</fullName>
        <actions>
            <name>Notification_to_customer_svc</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Populate_CSS_Email_Address</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Status_to_Submitted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Sample_Request__c.Submit_for_Approval__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Sample_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EMEA SU Sample Request</value>
        </criteriaItems>
        <description>Updates fields and sends sample requests to customer services. Used by EMEA SU.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
