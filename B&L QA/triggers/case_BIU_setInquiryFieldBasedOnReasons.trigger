/**
* 
*   This trigger sets the value of the Inquiry__c field based on the value of the Reason__c field
*
*    Author         |Author-Email                   |Date          |Comment
*    ---------------|-------------------------------|--------------|--------------------------------------------------
*    C Stanton      |craig.stanton@bausch.com       |06-May-2010   |First draft
*    C Stanton      |craig.stanton@bausch.com       |21-Jun-2010   |Added EMEA Inquiry values
*    C Stanton      |craig.stanton@bausch.com       |05-Oct-2010   |Grouped SOQL for Record Types into 1 SOQL
*
*/

trigger case_BIU_setInquiryFieldBasedOnReasons on Case (before insert, before update) {
    for (Case c:Trigger.new) {
        
        //GET RECORD TYPE ID FOR NA
        //RecordType na_rt = new RecordType();
        //na_rt = [Select Id, Name From RecordType Where Name = 'NA Service Case' limit 1];
        
        //GET RECORD TYPE ID FOR EMEA
        //RecordType emea_rt = new RecordType();
        //emea_rt = [Select Id, Name From RecordType Where Name = 'EMEA Service Case' limit 1];
        
        //GET BOTH RECORD TYPES SO THAT ONLY 1 SOQL IS USED
        RecordType[] recordTypes = new RecordType[2];
        recordTypes = [Select Id, Name From RecordType Where Name in ('EMEA Service Case', 'NA Service Case') order by Name limit 2];
        
        if( 
            //NA SERVICE CASE RECORD TYPE
            c.RecordTypeId == recordTypes[1].id && 
            (c.Reason__c == 'Cancel Order' ||
            c.Reason__c == 'Credit Inquiry' ||
            c.Reason__c == 'Credit Card Payment on Account' ||
            c.Reason__c == 'Credit/Invoice/Statement Inquiry' ||
            c.Reason__c == 'On Hold Inquiry' ||
            c.Reason__c == 'Invoice Copy' ||
            c.Reason__c == 'Payment Inquiry' ||
            c.Reason__c == 'Promotion Info Request' ||
            c.Reason__c == 'Rep Contact Request' ||
            c.Reason__c == 'Returns Process Inquiry' ||
            c.Reason__c == 'Track My Order' ||
            c.Reason__c == 'Web Account Setup' ||
            c.Reason__c == 'Web Ordering Question/Comment' ||
            c.Reason__c == 'Web Password Question')
          ) {
               c.Inquiry__c = true;
        }
        
        else if (
            //EMEA SERVICE CASE RECORD TYPE
            c.RecordTypeId == recordTypes[0].id && 
            (c.Reason__c == 'Account Change' ||
            c.Reason__c == 'Contact Request' ||
            c.Reason__c == 'Export Documentation Request' ||
            c.Reason__c == 'Help Using Web Ordering' ||
            c.Reason__c == 'Medical Information Inquiry' ||
            c.Reason__c == 'Open New Account' ||
            c.Reason__c == 'POS Request' ||
            c.Reason__c == 'Product Inquiry' ||
            c.Reason__c == 'Promotion Info Request' ||
            c.Reason__c == 'Request Invoice Copy' ||
            c.Reason__c == 'Request New Web Account' ||
            c.Reason__c == 'Request Web Password Reset' ||
            c.Reason__c == 'Returns Process Inquiry')
        ) {
            c.Inquiry__c = true;
        }
        
        
        else {
            c.Inquiry__c = false;
        }
    }
}