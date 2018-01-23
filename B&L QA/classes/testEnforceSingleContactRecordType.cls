/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * This class contains unit tests for validating the behavior of Apex trigger enforceSingleAccountRecordType.
 * 08/25/10 Hari Kalla, changed assert statements to debug
 */
@isTest
private class testEnforceSingleContactRecordType 
{   
    // Error Message
    private static final String ERROR_MSG = 'You are about to insert a contact profile with a record type that already exist!';
    private static final String TEST_ACCT_1 = 'Test Contact 1';
    private static final String RECORD_TYPE_EMEASU = 'EMEA SU Contact Profile';
    private static final String RECORD_TYPE_USASL = 'USASL';
    private static final String RECORD_TYPE_SOBJECTTYPE_ACCOUNT = 'Account';
    private static final String RECORD_TYPE_ACCOUNT_NAME = 'Ship To Account';
    private static final String TEST_1 = 'test1';
    private static final String TEST_USER_1_EMAIL = 'testuser_1@Bausch.com';

    private static final String PHONE = '(123) 123 1234';
    private static final String EMAIL = 'test@gmail.com';

    private static final String RECORD_TYPE_SOBJECTTYPE = 'Contact_Profile__c';

    private static final String CURRENCY_GBP = 'GBP';

    private static final String ERROR_ADDING_ACCOUNT = 'Error occurred while adding an account - ';
    private static final String ERROR_ADDING_CONTACT_PROFILE = 'Error occurred while adding an contact profile - ';
    private static final String ERROR_ADDING_CONTACT = 'Error occurred while adding a contact - ';
    
    
    // Add test account profile
    private static Contact_Profile__c AddContactProfile(String contactId, ID recordTypeId)
    {
        // Create a Contact_Profile__c 
        Contact_Profile__c contactProfile = new Contact_Profile__c(Contact__c = contactId, CurrencyIsoCode = CURRENCY_GBP, RecordTypeId = recordTypeId);
        
        System.debug('Contact__c = ' + contactId + ', CurrencyIsoCode = ' + CURRENCY_GBP + ', RecordTypeId = ' + recordTypeId);
        insert contactProfile;
        System.debug('contactProfile added');
        return contactProfile;
    }
    
    // Add test contact
    private static Contact AddContact(String accountId)
    {
        Contact contact;
        try
        {
            // Create a RecordTypeLookup__c 
            contact = new Contact(FirstName = TEST_1, LastName = TEST_1, Phone = PHONE, Email = EMAIL, AccountId = accountId);
            insert contact;
            System.debug('contact added');
        }
        catch(Exception ex)
        {
            System.debug(ERROR_ADDING_CONTACT + ex);
        }
        return contact;
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

    static testMethod void testInsertUpdateEnforceSingleContactRecordType() 
    {
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
                    Contact contact = AddContact(acct.Id);
                    System.debug('contact = ' + contact);
                    if (contact != null)
                    {
                        Contact_Profile__c contactProfile = AddContactProfile(contact.Id, recordTypeEMEASU.Id);
                        System.debug('contactProfile = ' + contactProfile);
                        // add the account profile twice
                        try
                        {
                            // add the contact profile second time around
                            contactProfile = AddContactProfile(contact.Id, recordTypeEMEASU.Id);
                        }
                        catch(Exception ex)
                        {
                            System.debug('ex.getMessage() = ' + ex.getMessage());
                            System.debug(ex.getMessage().contains(ERROR_MSG));
                        }
        
                        try
                        {
                            contactProfile.RecordTypeId = recordTypeUSASL.Id;
                            // update contact profile record
                            update contactProfile;
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
}