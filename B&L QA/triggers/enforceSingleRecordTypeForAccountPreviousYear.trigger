/**
* 
*   This trigger makes sure that only one record of each record type per Account. 
*
*   Author           |Author-Email                        |Date       |Comment
*   -----------------|------------------------------------|-----------|--------------------------------------------------
*   Sourav Mitra     |sourav.mitra@listertechnologies.com |31.08.2010 |First Draft
*
*/
trigger enforceSingleRecordTypeForAccountPreviousYear on Account_Previous_Year_Info__c (before insert, before update) 
{
    // Error Message
    String errorMsg = 'You are about to insert an account profile record type that already exists!';
    
    // Accounts that we need to check 
    Set<ID> accounts = new Set<ID>();
    
    // Map of account information
    Map<String,Account_Previous_Year_Info__c> currentAccountPreviousYearMap = new Map<String,Account_Previous_Year_Info__c>();
    
    // Add account 
    Boolean addAccount = false;
    
    // Retrieve all the account profile
    for (Account_Previous_Year_Info__c ap : Trigger.new) 
    {
        // Initialize account
        addAccount = false;
        
        // if the trigger is update then we need to check if the record type changed
        if (Trigger.isUpdate)
        {
            // Check if the record type was changed to new record type when edit of the record was created
            if (Trigger.oldMap.get(ap.Id).RecordTypeId != ap.RecordTypeId)
            {
                addAccount = true;
            }
        }
        
        // Add account is true and if the trigger is inserted
        if (addAccount || Trigger.isInsert)
        {
            // accounts that we need to check the profile for
            accounts.add(ap.Account__c);    
            currentAccountPreviousYearMap.put(ap.Account__c + '_' + ap.RecordTypeId, ap);
        }
    }
    
    System.debug('accounts = ' + accounts);
    System.debug('currentAccountPreviousYearMap = ' + currentAccountPreviousYearMap);
     
    // Retrieve all the account profiles
    Account_Previous_Year_Info__c[] accountPreviousYears = [SELECT a.RecordTypeId, a.RecordType.Name, a.Account__c FROM Account_Previous_Year_Info__c a WHERE a.Account__c IN :accounts];
    
    // Map of account information
    List<Account_Previous_Year_Info__c> accountErrors = new List<Account_Previous_Year_Info__c>();

    // Counter to check how many        
    Integer counter = 0;
    
    System.debug('accountPreviousYears = ' + accountPreviousYears);
            
    // Go through each account profile
    for(Account_Previous_Year_Info__c accountPreviousYear : accountPreviousYears)
    {
        counter = 1;
        System.debug('accountPreviousYear.Account__c and accountPreviousYear.RecordTypeId = ' + accountPreviousYear.Account__c + '_' + accountPreviousYear.RecordTypeId);
        
        if (currentAccountPreviousYearMap.containsKey(accountPreviousYear.Account__c + '_' + accountPreviousYear.RecordTypeId))
        {
            accountErrors.add(currentAccountPreviousYearMap.get(accountPreviousYear.Account__c + '_' + accountPreviousYear.RecordTypeId));
        }   
    }
    System.debug('accountErrors = ' + accountErrors);
        
    // If the account profile map has values then we need to concentrate on those accounts only
    if (accountErrors != null && accountErrors.size() > 0)
    {
        for(Account_Previous_Year_Info__c accountProfileError :accountErrors)
        {
            // Throw an error.
            accountProfileError.RecordTypeId.addError(errorMsg);
        }
    }
}