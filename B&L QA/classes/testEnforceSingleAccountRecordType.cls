/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * This class contains unit tests for validating the behavior of Apex trigger enforceSingleAccountRecordType.
 * 08/25/10 Hari Kalla, changed assert statements to debug
 */
@isTest
private class testEnforceSingleAccountRecordType {
    
    // Error Message
    private static final String ERROR_MSG = 'You are about to insert an account profile record type that already exist!';
    private static final String ERROR_ADDING_ACCOUNT = 'Error occurred while adding an account - ';
    private static final String ERROR_ADDING_ACCOUNT_PROFILE = 'Error occurred while adding an account profile - ';
    // Constants    
    private static final String TEST_ACCT_1 = 'Test Account 1';
    private static final String RECORD_TYPE_EMEASU = 'EMEA SU Account Profile';
    private static final String RECORD_TYPE_USASL = 'USASL';
    private static final String RECORD_TYPE_SOBJECTTYPE_ACCOUNT = 'Account';
    private static final String RECORD_TYPE_ACCOUNT_NAME = 'Ship To Account';
    private static final String RECORD_TYPE_SOBJECTTYPE = 'Account_Profile__c';
    private static final String CURRENCY_GBP = 'GBP';

    
    // Add test account profile
    private static Account_Profile__c AddAccountProfile(String accountId, ID recordTypeId)
    {
        // Create a Account_Profile__c 
        Account_Profile__c accountProfile = new Account_Profile__c(Account__c = accountId, CurrencyIsoCode = CURRENCY_GBP, RecordTypeId = recordTypeId, Cataract_Procedure_Volume__c = 56, VR_Procedure_Volume__c = 17);
            
        System.debug('Account__c = ' + accountId + ', CurrencyIsoCode = ' + CURRENCY_GBP + ', RecordTypeId = ' + recordTypeId);
        insert accountProfile;
        System.debug('accountProfile added');
        return accountProfile;
    }
    
    // Add test account
    private static Account AddAccount(String accountName)
    {
        Account acct;
        try
        {
            RecordType recordType = [SELECT r.Id FROM RecordType r WHERE Name = :RECORD_TYPE_ACCOUNT_NAME AND SObjectType = :RECORD_TYPE_SOBJECTTYPE_ACCOUNT];
            // Create a RecordTypeLookup__c 
            acct = new Account(Name = accountName, CurrencyIsoCode=CURRENCY_GBP, RecordTypeId=recordType.Id);
            insert acct;
            System.debug('account added');
        }
        catch(Exception ex)
        {
            System.debug(ERROR_ADDING_ACCOUNT + ex);
        }
        return acct;
    }

    static testMethod void testInsertUpdateEnforceSingleAccountRecordType() 
    {
        /*
        try
        {
            User objSysAdminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' ]
        }
        catch(Exception e)
        {
            System.debub('<<<<<<< Exception : ' + e.getMessage())
        }*/
        User oUser = null;
        try
        {
            Id idSysAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
            oUser = new User(alias = 'stduser', 
                     email='stduser@testorg.com', 
                     emailencodingkey='UTF-8',
                     lastname='lastname1',
                     languagelocalekey='en_US', 
                     localesidkey='en_US', 
                     profileid = idSysAdmin, 
                     timezonesidkey='America/Los_Angeles',
                     username='stduser123@testorg.com');
        }
        catch(Exception e)
        {
            System.debug('<<<<<<< Exception : ' + e.getMessage());
        }
        if(oUser != null)
        {
            System.runAs(oUser)
            {
                 RecordType recordTypeEMEASU = [SELECT r.Id FROM RecordType r WHERE Name = :RECORD_TYPE_EMEASU AND SObjectType = :RECORD_TYPE_SOBJECTTYPE];
                RecordType recordTypeUSASL = [SELECT r.Id FROM RecordType r WHERE Name = :RECORD_TYPE_USASL AND SObjectType = :RECORD_TYPE_SOBJECTTYPE];
                
                String accountName = TEST_ACCT_1;
                Account acct = AddAccount(TEST_ACCT_1);
                System.debug('acct = ' + acct);
                if (acct != null)
                {
                    Account_Profile__c accountProfile = AddAccountProfile(acct.Id, recordTypeEMEASU.Id);
                    System.debug('accountProfile = ' + accountProfile);
                    // add the account profile twice
        
                    try
                    {
                        // add the account profile EMEASU second time around
                        accountProfile = AddAccountProfile(acct.Id, recordTypeEMEASU.Id);
                    }
                    catch(Exception ex)
                    {
                        System.debug(ex.getMessage().contains(ERROR_MSG));
                    }
                    
                    try
                    {
                        accountProfile.RecordTypeId = recordTypeUSASL.Id;
                        // update account profile record
                        update accountProfile;
                    }
                    catch(Exception ex)
                    {
                        System.debug(ex.getMessage().contains(ERROR_MSG));
                    }
        
                }
            }
        }     
    }
}