/**
* 
* Trigger that moves the values from RFE to RFEPV to make it clear for the next change (non-NA cases have default value if not filled in)
* 
* Author              |Author-Email                    |Date        |Comment
* --------------------|------------------------------- |------------|----------------------------------------------------
* Vijay Singh         |vijay.singh@aequor.com          |15-Oct-2011 |Initial release 
* Craig Stanton       |craig.stanton@bausch.com        |26-Oct-2011 |If Case record type is EMEA or APAC VC Product Case, fill in RFE 
*
*/

trigger UpdateReasonForEditAndReasonforEditPriorValue1_APCC on Additional_Product_Complaint_Contact__c (before update,before insert) {
    
    for(Additional_Product_Complaint_Contact__c ac :trigger.new){
        
        RecordType CaseRecordTypeName;
        String CaseRecordTypeNameString;
        List <Case> CaseRecordTypeId;
        
        //Get the Case Record Type Id
        CaseRecordTypeId = [select RecordTypeId from Case where Id = :ac.Case__c];
        
        //From the Record Type ID, get the Case Record Type Name
        CaseRecordTypeName = [select Name from RecordType where Id = :CaseRecordTypeId[0].RecordTypeId];
        
        //Cast the Record Type Name to a string  
        CaseRecordTypeNameString = String.valueOf(CaseRecordTypeName);
        
        if (CaseRecordTypeNameString.contains('APAC VC Product Case')) {
            //system.debug('********************** APAC VC Case ***********************');
            if (ac.Reason_for_Edit__c == '' || ac.Reason_for_Edit__c == null) {
                ac.Reason_for_Edit_Prior_Value__c = 'Modified by APAC Customer Service';
            }
            
            else {
                ac.Reason_for_Edit_Prior_Value__c = ac.Reason_for_Edit__c;
                ac.Reason_for_Edit__c = '';     
            }
        }
        
        else if (CaseRecordTypeNameString.contains('EMEA VC Product Case')) {
            //system.debug('********************** EMEA VC Case ***********************');
            if (ac.Reason_for_Edit__c == '' || ac.Reason_for_Edit__c == null) {
                ac.Reason_for_Edit_Prior_Value__c = 'Modified by EMEA Customer Service';
            }
            
            else {
                ac.Reason_for_Edit_Prior_Value__c = ac.Reason_for_Edit__c;
                ac.Reason_for_Edit__c = '';     
            }
        }
        
        else {
            //system.debug('********************** Not APAC or EMEA VC Case (Else case) ***********************');
            ac.Reason_for_Edit_Prior_Value__c = ac.Reason_for_Edit__c;
            ac.Reason_for_Edit__c = '';
        }
        
        Class_to_prevent_trigger_recursively.IsContactAutoPopulate = true;
    }
}