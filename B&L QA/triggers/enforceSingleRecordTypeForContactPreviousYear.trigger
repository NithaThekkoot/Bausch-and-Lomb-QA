/**
* 
*   This trigger makes sure that only one record of each record type per Contact. 
*
*   Author           |Author-Email                        |Date       |Comment
*   -----------------|------------------------------------|-----------|--------------------------------------------------
*   Sourav Mitra     |sourav.mitra@listertechnologies.com |25.09.2010 |First Draft
*
*/
trigger enforceSingleRecordTypeForContactPreviousYear on Contact_Previous_Year_Info__c (before insert, before update) 
{
    // Error Message
    String errorMsg = 'You are about to insert a contact profile record type that already exists!';
    
    // Accounts that we need to check 
    Set<ID> contacts = new Set<ID>();
    
    // Map of account information
    Map<String,Contact_Previous_Year_Info__c> currentContactPreviousYearMap = new Map<String,Contact_Previous_Year_Info__c>();
    
    // Add account 
    Boolean addContact = false;
    
    // Retrieve all the account profile
    for (Contact_Previous_Year_Info__c ap : Trigger.new) 
    {
        // Initialize account
        addContact = false;
        
        // if the trigger is update then we need to check if the record type changed
        if (Trigger.isUpdate)
        {
            // Check if the record type was changed to new record type when edit of the record was created
            if (Trigger.oldMap.get(ap.Id).RecordTypeId != ap.RecordTypeId)
            {
                addContact = true;
            }
        }
        
        // Add account is true and if the trigger is inserted
        if (addContact || Trigger.isInsert)
        {
            // accounts that we need to check the profile for
            contacts.add(ap.Contact__c);    
            currentContactPreviousYearMap.put(ap.Contact__c + '_' + ap.RecordTypeId, ap);
        }
    }
    
    System.debug('contacts = ' + contacts);
    System.debug('currentContactPreviousYearMap = ' + currentContactPreviousYearMap);
     
    // Retrieve all the account profiles
    Contact_Previous_Year_Info__c[] contactPreviousYears = [SELECT a.RecordTypeId, a.RecordType.Name, a.Contact__c FROM Contact_Previous_Year_Info__c a WHERE a.Contact__c IN :contacts];
    
    // Map of account information
    List<Contact_Previous_Year_Info__c> contactErrors = new List<Contact_Previous_Year_Info__c>();

    // Counter to check how many        
    Integer counter = 0;
    
    System.debug('contactPreviousYears = ' + contactPreviousYears);
            
    // Go through each account profile
    for(Contact_Previous_Year_Info__c contactPreviousYear : contactPreviousYears)
    {
        counter = 1;
        System.debug('contactPreviousYear.Contact__c and contactPreviousYear.RecordTypeId = ' + contactPreviousYear.Contact__c + '_' + contactPreviousYear.RecordTypeId);
        
        if (currentContactPreviousYearMap.containsKey(contactPreviousYear.Contact__c + '_' + contactPreviousYear.RecordTypeId))
        {
            contactErrors.add(currentContactPreviousYearMap.get(contactPreviousYear.Contact__c + '_' + contactPreviousYear.RecordTypeId));
        }   
    }
    System.debug('contactErrors = ' + contactErrors);
        
    // If the account profile map has values then we need to concentrate on those accounts only
    if (contactErrors != null && contactErrors.size() > 0)
    {
        for(Contact_Previous_Year_Info__c contactProfileError :contactErrors)
        {
            // Throw an error.
            contactProfileError.RecordTypeId.addError(errorMsg);
        }
    }
}