<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Nordic_Pharma_Account_New_Product_Complaint</fullName>
        <description>Nordic Pharma Account New Product Complaint</description>
        <protected>false</protected>
        <recipients>
            <recipient>vrennha@bausch.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EMEA_SU/Nordic_Pharma_Product_Complaint</template>
    </alerts>
    <alerts>
        <fullName>Send_Dutch_Product_Complaint_Email</fullName>
        <ccEmails>esther.van-den-oever@bausch.com</ccEmails>
        <ccEmails>rob.jansbeken@bausch.com</ccEmails>
        <ccEmails>marie-laure.chaufer@bausch.com</ccEmails>
        <ccEmails>medicalnl.MedicalNL@bausch.com</ccEmails>
        <description>Send Dutch Product Complaint Email</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EMEA_SU/Dutch_Product_Complaint</template>
    </alerts>
    <alerts>
        <fullName>Send_English_Product_Complaint_Email</fullName>
        <ccEmails>SurgicalUKComplaints@bausch.com</ccEmails>
        <description>Send English Product Complaint Email</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EMEA_SU/English_Product_Complaint</template>
    </alerts>
    <alerts>
        <fullName>Send_French_Product_Complaint_Email</fullName>
        <ccEmails>chirurgie.commande@bausch.com</ccEmails>
        <ccEmails>marie-laure.chaufer@bausch.com</ccEmails>
        <description>Send French Product Complaint Email (France)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EMEA_SU/French_Product_Complaint</template>
    </alerts>
    <alerts>
        <fullName>Send_French_Product_Complaint_Email_Belgium</fullName>
        <ccEmails>surgicalbe@bausch.com</ccEmails>
        <ccEmails>esther.van-den-oever@bausch.com</ccEmails>
        <ccEmails>marie-laure.chaufer@bausch.com</ccEmails>
        <description>Send French Product Complaint Email (Belgium)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EMEA_SU/French_Product_Complaint</template>
    </alerts>
    <alerts>
        <fullName>Send_German_Product_Complaint_Email</fullName>
        <ccEmails>kundenservice@bausch.com</ccEmails>
        <description>Send German Product Complaint Email</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EMEA_SU/German_Product_Complaint</template>
    </alerts>
    <alerts>
        <fullName>Send_Italian_Product_Complaint_Email</fullName>
        <ccEmails>servizio_clienti@bausch.com</ccEmails>
        <description>Send Italian Product Complaint Email</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EMEA_SU/Italian_Product_Complaint</template>
    </alerts>
    <alerts>
        <fullName>Send_Nordic_Product_Complaint_Email</fullName>
        <ccEmails>BLSurgicalNordicsComplaints@bausch.com</ccEmails>
        <description>Send Nordic Product Complaint Email</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EMEA_SU/English_Product_Complaint</template>
    </alerts>
    <alerts>
        <fullName>Send_Spanish_Product_Complaint_Email</fullName>
        <ccEmails>hernan.basso@bausch.com</ccEmails>
        <description>Send Spanish Product Complaint Email</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EMEA_SU/Spanish_Product_Complaint</template>
    </alerts>
    <rules>
        <fullName>Product Complaint Alert - Dutch</fullName>
        <actions>
            <name>Send_Dutch_Product_Complaint_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.SETID__c</field>
            <operation>equals</operation>
            <value>NETPR</value>
        </criteriaItems>
        <description>Sends an email to ensure a product complaint is logged in CATSWEB. Runs for NETPR to send Dutch version of the email.
(Used to be dasrx pharma covigilance alert.)
Used by EMEA SU.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Product Complaint Alert - English</fullName>
        <actions>
            <name>Send_English_Product_Complaint_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.SETID__c</field>
            <operation>equals</operation>
            <value>UNKGD</value>
        </criteriaItems>
        <description>Sends an email to ensure a product complaint is logged in CATSWEB. Runs for UNKGD to send English version of the email. 
(Used to be dasrx pharma covigilance alert.) 
Used by EMEA SU.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Product Complaint Alert - French %28Belgium%29</fullName>
        <actions>
            <name>Send_French_Product_Complaint_Email_Belgium</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.SETID__c</field>
            <operation>equals</operation>
            <value>BELGM</value>
        </criteriaItems>
        <description>Sends an email to ensure a product complaint is logged in CATSWEB. Runs for BELGM to send French version of the email. 
(Used to be dasrx pharma covigilance alert.) 
Used by EMEA SU.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Product Complaint Alert - French %28France%29</fullName>
        <actions>
            <name>Send_French_Product_Complaint_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.SETID__c</field>
            <operation>equals</operation>
            <value>FRANC</value>
        </criteriaItems>
        <description>Sends an email to ensure a product complaint is logged in CATSWEB. Runs for FRANC to send French version of the email. 
(Used to be dasrx pharma covigilance alert.) 
Used by EMEA SU.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Product Complaint Alert - German</fullName>
        <actions>
            <name>Send_German_Product_Complaint_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Account.SETID__c</field>
            <operation>equals</operation>
            <value>DMBLV</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.SETID__c</field>
            <operation>equals</operation>
            <value>AUSTR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.SETID__c</field>
            <operation>equals</operation>
            <value>SWICM</value>
        </criteriaItems>
        <description>Sends an email to ensure a product complaint is logged in CATSWEB. Runs for DMBLV, AUSTR and SWICM to send German version of the email.
(Used to be dasrx pharma covigilance alert.)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Product Complaint Alert - Italian</fullName>
        <actions>
            <name>Send_Italian_Product_Complaint_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.SETID__c</field>
            <operation>equals</operation>
            <value>ITALY</value>
        </criteriaItems>
        <description>Sends an email to ensure a product complaint is logged in CATSWEB. Runs for ITALY to send Italian version of the email. 
(Used to be dasrx pharma covigilance alert.) 
Used by EMEA SU.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Product Complaint Alert - Nordics</fullName>
        <actions>
            <name>Send_Nordic_Product_Complaint_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4</booleanFilter>
        <criteriaItems>
            <field>Account.SETID__c</field>
            <operation>equals</operation>
            <value>NORNO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.SETID__c</field>
            <operation>equals</operation>
            <value>NORDK</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.SETID__c</field>
            <operation>equals</operation>
            <value>NORSE</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.SETID__c</field>
            <operation>equals</operation>
            <value>NORFI</value>
        </criteriaItems>
        <description>Sends an email to ensure a product complaint is logged in CATSWEB. Runs for NORDIC to send English version of the email. 
(Used to be dasrx pharma covigilance alert.) 
Used by EMEA SU.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Product Complaint Alert - Pharma Nordics</fullName>
        <actions>
            <name>Nordic_Pharma_Account_New_Product_Complaint</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Ship_To_Id__c</field>
            <operation>equals</operation>
            <value>70000465,70000720,70000544,72003164,72003154,72003162,60001803,60001173,60001422,60000894,80000686</value>
        </criteriaItems>
        <description>Sends an email to notify Nordic CS of product complaint raised on Pharma account. Used by EMEA SU.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Product Complaint Alert - Spanish</fullName>
        <actions>
            <name>Send_Spanish_Product_Complaint_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Account.SETID__c</field>
            <operation>equals</operation>
            <value>PORTU</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.SETID__c</field>
            <operation>equals</operation>
            <value>SPACM</value>
        </criteriaItems>
        <description>Sends an email to ensure a product complaint is logged in CATSWEB. Runs for PORTU and SPACM to send Spanish version of the email.
(Used to be dasrx pharma covigilance alert.) 
Used by EMEA SU.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
