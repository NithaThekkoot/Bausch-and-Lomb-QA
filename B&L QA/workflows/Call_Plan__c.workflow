<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>APACSU_Call_Plan_approved</fullName>
        <description>APACSU Call Plan Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>APACSU_Email_Templates/APACSU_Notify_Sales_Rep_Call_plan_Approved</template>
    </alerts>
    <alerts>
        <fullName>APACSU_Rejection_Alert</fullName>
        <description>APACSU Rejection Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>APACSU_Email_Templates/APACSU_Notify_Sales_Rep_Call_plan_Rejected</template>
    </alerts>
    <alerts>
        <fullName>CHNSU_Notify_Manager1</fullName>
        <description>CHNSU Notify Manager</description>
        <protected>false</protected>
        <recipients>
            <field>Manager_s_Email_ID__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>APACSU_Email_Templates/CHNSU_Notify_Manager</template>
    </alerts>
    <alerts>
        <fullName>CHNSU_Notify_Sales_Rep_Call_plan_Approved</fullName>
        <description>CHNSU Notify Sales Rep (Call plan-Approved)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>APACSU_Email_Templates/CHNSU_Notify_Sales_Rep_Call_plan_Approved</template>
    </alerts>
    <alerts>
        <fullName>CHNSU_Notify_Sales_Rep_Call_plan_Rejected</fullName>
        <description>CHNSU Notify Sales Rep (Call plan-Rejected)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>APACSU_Email_Templates/CHNSU_Notify_Sales_Rep_Call_plan_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Manager_on_Call_Plan_Submission</fullName>
        <description>Email to Manager on Call Plan Submission</description>
        <protected>false</protected>
        <recipients>
            <field>Manager_s_Email_ID__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>APACSU_Email_Templates/KORSU_Notify_Manager_Submitted_Call_Plan</template>
    </alerts>
    <alerts>
        <fullName>KORSU_Notify_Sales_Rep_Single_Call_plan_Approved</fullName>
        <description>KORSU Notify Sales Rep (Single Call plan-Approved)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/KORSU_Notify_Sales_Rep_Single_Call_plan_Approved</template>
    </alerts>
    <alerts>
        <fullName>KORSU_Notify_Sales_Rep_Single_Call_plan_Rejected</fullName>
        <description>KORSU Notify Sales Rep (Single Call plan-Rejected)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>APACSU_Email_Templates/KORSU_Notify_Sales_Rep_Single_Call_plan_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Notify_The_APACSU_HKG_Manager_for_plan_submission</fullName>
        <description>Notify The APACSU HKG Manager for plan submission</description>
        <protected>false</protected>
        <recipients>
            <recipient>HKGSUNationalSalesManager</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>APACSU_Email_Templates/APACSU_Notify_Manager</template>
    </alerts>
    <alerts>
        <fullName>Notify_The_INDSU_Manager_for_plan_submission</fullName>
        <description>Notify The INDSU Manager for plan submission</description>
        <protected>false</protected>
        <recipients>
            <field>Manager_s_Email_ID__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>APACSU_Email_Templates/APACSU_Notify_Manager</template>
    </alerts>
    <fieldUpdates>
        <fullName>APACSU_Field_Update</fullName>
        <field>Status__c</field>
        <literalValue>Draft</literalValue>
        <name>APACSU Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CHNSU_Call_Plan_Rejected_Status_Change</fullName>
        <field>Status__c</field>
        <literalValue>Draft</literalValue>
        <name>CHNSU Call Plan Rejected (Status Change)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Email_of_manager</fullName>
        <field>Manager_s_Email_ID__c</field>
        <formula>CreatedBy.Manager.Email</formula>
        <name>Populate Email of manager</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Email_of_manager_India</fullName>
        <field>Manager_s_Email_ID__c</field>
        <formula>CreatedBy.Manager.Email</formula>
        <name>Populate Email of manager_India</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Manager_Email_ID</fullName>
        <field>Manager_s_Email_ID__c</field>
        <formula>CreatedBy.Manager.Email</formula>
        <name>Populate Manager Email ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Manager_s_Email_ID_chn</fullName>
        <field>Manager_s_Email_ID__c</field>
        <formula>CreatedBy.ManagerId</formula>
        <name>Populate Manager&apos;s Email ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>APACSU Notify Manager HongKong and India</fullName>
        <actions>
            <name>Notify_The_APACSU_HKG_Manager_for_plan_submission</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Populate_Email_of_manager</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Call_Plan__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>APACSU Call Plan</value>
        </criteriaItems>
        <criteriaItems>
            <field>Call_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>notContain</operation>
            <value>CHN</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>notContain</operation>
            <value>INDSU</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>contains</operation>
            <value>HKG</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>notContain</operation>
            <value>INDAES</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>APACSU Notify Sales Rep %28Call plan-Approved%29</fullName>
        <actions>
            <name>APACSU_Call_Plan_approved</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Call_Plan__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>APACSU Call Plan</value>
        </criteriaItems>
        <criteriaItems>
            <field>Call_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>notContain</operation>
            <value>CHN</value>
        </criteriaItems>
        <description>APACSUworkflow to notify the sales rep about the approval of his/her call plan.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>APACSU Notify Sales Rep %28Call plan-Rejected%29</fullName>
        <actions>
            <name>APACSU_Rejection_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>APACSU_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Call_Plan__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>APACSU Call Plan</value>
        </criteriaItems>
        <criteriaItems>
            <field>Call_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>notContain</operation>
            <value>CHN</value>
        </criteriaItems>
        <description>APACSU workflow to notify the sales rep about the rejection of his/her call plan.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CHNSU Notify Manager</fullName>
        <actions>
            <name>CHNSU_Notify_Manager1</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Call_Plan__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>APACSU Call Plan</value>
        </criteriaItems>
        <criteriaItems>
            <field>Call_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>contains</operation>
            <value>CHN</value>
        </criteriaItems>
        <criteriaItems>
            <field>Call_Plan__c.Manager_s_Email_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CHNSU Notify Sales Rep %28Call plan-Approved%29</fullName>
        <actions>
            <name>CHNSU_Notify_Sales_Rep_Call_plan_Approved</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Call_Plan__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>APACSU Call Plan</value>
        </criteriaItems>
        <criteriaItems>
            <field>Call_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>contains</operation>
            <value>CHN</value>
        </criteriaItems>
        <description>CHNSUworkflow to notify the sales rep about the approval of his/her call plan.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CHNSU Notify Sales Rep %28Call plan-Rejected%29</fullName>
        <actions>
            <name>CHNSU_Notify_Sales_Rep_Call_plan_Rejected</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CHNSU_Call_Plan_Rejected_Status_Change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Call_Plan__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>APACSU Call Plan</value>
        </criteriaItems>
        <criteriaItems>
            <field>Call_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>contains</operation>
            <value>CHN</value>
        </criteriaItems>
        <description>CHNSU workflow to notify the sales rep about the rejection of his/her call plan.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>China Populate Manager Email China</fullName>
        <actions>
            <name>Populate_Manager_s_Email_ID_chn</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Call_Plan__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>APACSU Call Plan</value>
        </criteriaItems>
        <criteriaItems>
            <field>Call_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>contains</operation>
            <value>CHN</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>INDSU Notify Manager %28Single Call plan Submission%29</fullName>
        <actions>
            <name>Notify_The_INDSU_Manager_for_plan_submission</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Populate_Email_of_manager_India</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 6) AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Call_Plan__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>APACSU Call Plan</value>
        </criteriaItems>
        <criteriaItems>
            <field>Call_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>contains</operation>
            <value>INDSU</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>notContain</operation>
            <value>CHNSU</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>notContain</operation>
            <value>HKG</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>contains</operation>
            <value>INDAES</value>
        </criteriaItems>
        <description>INDSU Workflow to notify Manager on Call Plan Submission</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>KORSU Notify Manager %28Single Call plan Submission%29</fullName>
        <actions>
            <name>Email_to_Manager_on_Call_Plan_Submission</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Call_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.User_Role__c</field>
            <operation>contains</operation>
            <value>KORSU</value>
        </criteriaItems>
        <description>To notify the Manager in case of Call Plan Submission.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>KORSU Notify Sales Rep %28Single Call plan-Approved%29</fullName>
        <actions>
            <name>KORSU_Notify_Sales_Rep_Single_Call_plan_Approved</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.User_Role__c</field>
            <operation>contains</operation>
            <value>KORSU</value>
        </criteriaItems>
        <criteriaItems>
            <field>Call_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>KORSU workflow to notify the sales rep about the approval of his/her call plan (single)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>KORSU Notify Sales Rep %28Single Call plan-Rejected%29</fullName>
        <actions>
            <name>KORSU_Notify_Sales_Rep_Single_Call_plan_Rejected</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.User_Role__c</field>
            <operation>contains</operation>
            <value>KORSU</value>
        </criteriaItems>
        <criteriaItems>
            <field>Call_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <description>KORSU workflow to notify the sales rep about the rejection of his/her call plan (single)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
