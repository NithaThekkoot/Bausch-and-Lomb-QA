<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>DASRX_Set_Reminder_to_False</fullName>
        <field>IsReminderSet</field>
        <literalValue>0</literalValue>
        <name>DASRX Set Reminder to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Event_Status_To_Closed</fullName>
        <description>Update Event Status to Closed</description>
        <field>Event_Status__c</field>
        <literalValue>Closed</literalValue>
        <name>Set Event Status To Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Out_Of_Territory_Days</fullName>
        <description>Update Event Out of Territory Days based on the Out of Territory Time value selected by user</description>
        <field>Out_of_Territory_Days__c</field>
        <formula>CASE( Out_of_Territory_Time__c , &quot;Quarter Day&quot;, 0.25, &quot;Half Day&quot;, 0.5, &quot;Full Day&quot;, 1,0)</formula>
        <name>Set Out Of Territory Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>USECS_Close_Event</fullName>
        <description>ECS Auto close event</description>
        <field>Event_Status__c</field>
        <literalValue>Closed</literalValue>
        <name>USECS Close Event</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Location</fullName>
        <field>Location</field>
        <formula>Account_Name__c</formula>
        <name>Update Location</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>DASRX Unset Event Reminder</fullName>
        <actions>
            <name>DASRX_Set_Reminder_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Event.RecordTypeId</field>
            <operation>equals</operation>
            <value>DASRX Swiss Visit Report,DASRX German Visit Report</value>
        </criteriaItems>
        <description>For DASRX events are currently all visit reports for the past. To prevent an event reminder popup we set the reminder to false at all times.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Out Of Territory Days</fullName>
        <actions>
            <name>Set_Out_Of_Territory_Days</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Event Out of Territory Days based on the Out of Territory Time value selected by user</description>
        <formula>OR ( ISPICKVAL ( Out_of_Territory_Time__c,  &apos;Full Day&apos; ), ISPICKVAL ( Out_of_Territory_Time__c,  &apos;Half Day&apos; ), ISPICKVAL ( Out_of_Territory_Time__c,  &apos;Quarter Day&apos; ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>USECS Update Event Status to Closed</fullName>
        <actions>
            <name>USECS_Close_Event</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>ECS Update Event Status to Closed when the required fields are populated</description>
        <formula>AND (  ($Profile.Name &lt;&gt; &apos;BL: Integration User&apos;),  ( $RecordType.DeveloperName = &apos;USECS&apos;),  OR((ISPICKVAL (Event_Type__c, &apos;Eat and Learn&apos;)),  (ISPICKVAL (Event_Type__c, &apos;Sales Call&apos;)),  (ISPICKVAL (Event_Type__c, &apos;Intro Call&apos;))  ),  (LEN ( WhatId ) &gt; 0),  (LEN ( WhoId ) &gt; 0),  (IF(ISPICKVAL(Event_Type__c,&apos;Intro Call&apos;),NOT(ISPICKVAL(Primary_product__c,&apos;&apos;)),NOT(ISPICKVAL (Outcome__c,&apos;&apos;))))  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Event Status to Closed</fullName>
        <actions>
            <name>Set_Event_Status_To_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Event Status to Closed when the required fields are populated</description>
        <formula>OR ( AND ( OR ($Profile.Name = &apos;NAL: VTM Sales Rep User&apos;, $Profile.Name = &apos;NAL: Canada Sales Rep&apos;), OR ( $RecordType.DeveloperName = &apos;USASL&apos;, $RecordType.DeveloperName = &apos;CANVC&apos;), OR (ISPICKVAL (Event_Type__c, &apos;Eat and Learn&apos;), ISPICKVAL (Event_Type__c, &apos;Sales Call&apos;)), NOT (ISPICKVAL ( Event_Status__c, &apos;Cancelled&apos;)), LEN ( WhatId ) &gt; 0, NOT (ISNULL ( POA_Presented__c)), NOT (ISNULL ( Call_Objective__c)), NOT (ISNULL ( Call_Activities__c )), LEN ( Description ) &gt; 0, (LEN ( WhoId ) &gt; 0), (NOT (ISNULL ( Material_Presented__c ))) ), AND ( ($Profile.Name = &apos;NAL: ITM Sales Rep User&apos;), OR ( $RecordType.DeveloperName = &apos;USASL&apos;, $RecordType.DeveloperName = &apos;CANVC&apos;), NOT (ISPICKVAL ( Event_Status__c, &apos;Cancelled&apos;)), OR (ISPICKVAL (Event_Type__c, &apos;Eat and Learn&apos;), ISPICKVAL (Event_Type__c, &apos;Sales Call&apos;)), OR ( AND ( LEN ( WhatId ) &gt; 0, NOT (ISNULL ( POA_Presented__c)), NOT (ISNULL ( Call_Objective__c)), NOT (ISNULL ( Call_Activities__c )), LEN ( Description ) &gt; 0, (NOT (ISPICKVAL (Call_Result__c , &apos;&apos;))) ), (INCLUDES (Call_Objective__c, &apos;Call Attempt (ITM Only)&apos;)) ) ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Event Status to Closed - Out of Territory</fullName>
        <actions>
            <name>Set_Event_Status_To_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Event Status to Closed for Out of Territory Events</description>
        <formula>AND ( NOT (ISPICKVAL ( Event_Status__c, &apos;Closed&apos; )), NOT (ISPICKVAL ( Event_Status__c, &apos;Cancelled&apos; )), OR ( ISPICKVAL (Event_Type__c, &apos;Out of Territory - Sick&apos;), ISPICKVAL (Event_Type__c, &apos;Out of Territory - Vacation&apos;), ISPICKVAL (Event_Type__c, &apos;Out of Territory - Internal&apos;), ISPICKVAL (Event_Type__c, &apos;Out of Territory - Holiday&apos;) ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Location</fullName>
        <actions>
            <name>Update_Location</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Event.RecordTypeId</field>
            <operation>equals</operation>
            <value>USSUR Clinical Development Specialist</value>
        </criteriaItems>
        <description>Update Location with Account Name</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
