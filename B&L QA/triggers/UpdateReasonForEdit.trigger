/**
* 
* Trigger that moves the values from RFE to RFEPV to make it clear for the next change (non-NA cases have default value if not filled in)
* 
* Author              |Author-Email                    |Date        |Comment
* --------------------|------------------------------- |------------|----------------------------------------------------
* Vijay Singh         |vijay.singh@aequor.com          |15-Oct-2011 |Initial release 
* Craig Stanton       |craig.stanton@bausch.com        |26-Oct-2011 |If Case record type is EMEA or APAC VC Product Case, fill in RFE 
* Craig Stanton       |craig.stanton@bausch.com        |02-Nov-2011 |Check to make sure there is a Case associated to the note
*
*/

trigger UpdateReasonForEdit on Case_Note__c (before update,before insert) {
    
    for(Case_Note__c note :trigger.new){
        RecordType CaseRecordTypeName;
        String CaseRecordTypeNameString;
        List <Case> CaseRecordTypeId;
        
        //Get the Case Record Type Id
        CaseRecordTypeId = [select RecordTypeId from Case where Id = :note.Case__c];
        
        //Check to be sure there is a Case associated, as there may not be if the Note is being deleted
        if (CaseRecordTypeId.size() > 0) {
        
            //From the Record Type ID, get the Case Record Type Name
            CaseRecordTypeName = [select Name from RecordType where Id = :CaseRecordTypeId[0].RecordTypeId];
        
            //Cast the Record Type Name to a string  
            CaseRecordTypeNameString = String.valueOf(CaseRecordTypeName);
        
            if (CaseRecordTypeNameString.contains('APAC SU Product Case')) {
                //system.debug('********************** APAC SU Case ***********************');
                if (note.Reason_for_Edit__c == '' || note.Reason_for_Edit__c == null) {
                    note.Reason_for_Edit_Prior_Value__c = 'Modified by APAC Customer Service';
                }
            
                else {
                    note.Reason_for_Edit_Prior_Value__c = note.Reason_for_Edit__c;
                    note.Reason_for_Edit__c = '';     
                }
            }
        
            else if (CaseRecordTypeNameString.contains('EMEA SU Product Case')) {
                //system.debug('********************** EMEA SU Case ***********************');
                if (note.Reason_for_Edit__c == '' || note.Reason_for_Edit__c == null) {
                    note.Reason_for_Edit_Prior_Value__c = 'Modified by EMEA Customer Service';
                }
            
                else {
                    note.Reason_for_Edit_Prior_Value__c = note.Reason_for_Edit__c;
                    note.Reason_for_Edit__c = '';     
                }
            }
        
            else {
                //system.debug('********************** Not APAC or EMEA VC Case (Else case) ***********************');
                note.Reason_for_Edit_Prior_Value__c = note.Reason_for_Edit__c;
                note.Reason_for_Edit__c = '';
            }
        }
    }
}