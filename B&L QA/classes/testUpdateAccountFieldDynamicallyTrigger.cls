/**
 * This class contains unit tests for validating the behavior of Apex trigger updateAccountFieldDynamicallyTrigger.
 *
 */
@isTest
private class testUpdateAccountFieldDynamicallyTrigger 
{

    private static final Integer EVENTS_100 = 100;

    private static final String UNIT_TEST_USER = 'Unit test user';
    private static final String TEST_ACCT = 'test@gmail.com';
    private static final String TEST_USER = 'test user';
    private static final String STANDARD_USER = 'Standard User';
    private static final String EMAIL_ENCODING_KEY = 'UTF-8';
    private static final String LANGUAGE_LOCALE = 'en_US';
    private static final String EDT = 'America/New_York';
    private static final String TEST_1 = 'test1';
    private static final String TEST_2 = 'test2';
    private static final String TEST_USER_1_EMAIL = 'testuser_1@Bausch.com';
    private static final String TEST_USER_2_EMAIL = 'testuser_2@Bausch.com';

    private static final String PHONE = '(123) 123 1234';
    private static final String EMAIL = 'test@gmail.com';

    private static final String SUBJECT_EAT_AND_LEARN = 'Eat and Learn';
    private static final String SUBJECT_SALES_CALL = 'Sales Call';
    private static final String SUBJECT_MEETING = 'Meeting';
    
    private static final String EVENT_TYPE_EAT_AND_LEARN = 'Eat and Learn';
    private static final String EVENT_TYPE_SALES_CALL = 'Sales Call';
    private static final String EVENT_TYPE_TRAINING = 'Training';
    
    private static final String RECORD_TYPE_SALES_CALL = 'DAS Pharma';
    private static final String RECORD_TYPE_ECS = 'ECS';
    private static final String RECORD_TYPE_USASL = 'USASL';
    
    private static final String UPDATE_FIELD_A = 'ITM_Last_Call_Date__c';
    private static final String UPDATE_FIELD_B = 'VTM_Last_Call_Date__c';
    
    private static final String EVENT_STATUS_OPEN = 'Open';
    private static final String EVENT_STATUS_CLOSED = 'Closed';
    private static final String OUTCOME_NOTES = 'Unit Test Desc';

    private static final String RECORD_TYPE_SOBJECTTYPE = 'Account_Profile__c';
    private static final String RECORD_TYPE_NAME = 'USASL';
    private static final String RECORD_TYPE_SOBJECTTYPE_ACCOUNT = 'Account';
    private static final String RECORD_TYPE_SOBJECTTYPE_EVENT = 'Event';
    private static final String RECORD_TYPE_ACCOUNT_NAME = 'Doorway Account';
    private static final String PROFILE_ITM = 'NAL: ITM Sales Rep User';
    private static final String PROFILE_VTM = 'NAL: VTM Sales Rep User';
    
    private static final String CURRENCY_USD = 'USD';
    
    private static final String CALL_OBJECTIVE_MF = 'MF - Increase Fitting Confidence';
    private static final String CALL_OBJECTIVE_PVSVS = 'PVSVS - Increase Share';
    private static final String CALL_OBJECTIVE_SDD = 'SDD - Build Confidence in Health vs Cost';
    private static final String CALL_OBJECTIVE_TORIC = 'Toric - HEMA upgrades & New Fits';
    private static final String CALL_OBJECTIVE_TORIC_RR = 'Toric - Retain Refits';
    private static final String CALL_OBJECTIVE_SERVICE = 'Service';
    private static final String CALL_OBJECTIVE_LE = 'LOTEMAX Einführung';
    private static final String CALL_OBJECTIVE_AC = 'ARTELAC/CORNEREGEL vs. Bepanthen';
    private static final String CALL_OBJECTIVE_CARMA = 'CARMA Studie';
    private static final String CALL_OBJECTIVE_CA = 'Call Attempt (ITM Only)';
    
    private static final String POA_PRESENTED_MF = 'Multi-Focal';
    private static final String POA_PRESENTED_SDD = 'SDD';
    private static final String POA_PRESENTED_SVS = 'SVS';
    private static final String POA_PRESENTED_TORIC = 'Toric';
    private static final String POA_PRESENTED_SERVICE = 'Service';
    
    private static final String CALL_ACTIVITIES_AP = 'Account Profiling';
    private static final String CALL_ACTIVITIES_EL = 'Eat and Learn';
    private static final String CALL_ACTIVITIES_HOI = 'Handle Outstanding Issues';
    
    private static final String MATERIAL_PRESENTED_AD = 'Auth Distributors for B&L Soft CLs';
    private static final String MATERIAL_PRESENTED_DMC = 'Dinner Menu Card';
    
    private static final String TEST_ACCT_1 = 'Test Account 1';

    private static final String ERROR_ADDING_ACCOUNT = 'Error occurred while adding an account - ';
    private static final String ERROR_ADDING_CONTACT = 'Error occurred while adding a contact - ';
    private static final String ERROR_ADDING_USER = 'Error occurred while adding a user - ';
    private static final String ERROR_ADDING_RECORD_TYPE = 'Error occurred while adding a record type lookup - ';
    private static final String ERROR_ADDING_EVENT = 'Error occurred while adding an event - ';
    private static final String ERROR_ADDING_ACCOUNT_PROFILE = 'Error occurred while adding an account profile - ';
    
    private static final String EXCEPTION_BULK_INSERT_UPDATE = 'Exception for bulk insert/update events ';
    
    private static final String CALL_RESULT_AOWDM = 'Achieved Objective with Decision Maker';
    private static final String CALL_RESULT_AO = 'Achieved Objective';
    
    // Add test record type lookup
    private static RecordTypeLookup__c AddRecordTypeLookup(String eventType, String recordType, String profileType, String updateField)
    {
        RecordTypeLookup__c recordTypeLookUp;
        try
        {
            // Create a RecordTypeLookup__c 
            recordTypeLookUp = new RecordTypeLookup__c(EventType__c = eventType, RecordType__c = recordType, AssignToProfile__c = profileType, UpdateField__c = updateField);
            insert recordTypeLookUp;
            System.debug('recordTypeLookUp added');
        }
        catch(Exception ex)
        {
            System.debug(ERROR_ADDING_RECORD_TYPE + ex);
        }
        return recordTypeLookUp;
    }

    // Add test event
    private static Event AddEvent(Boolean addEvent, String ownerId, String subject, String eventType, String accountId, String contactId, String eventStatus, ID recordTypeId)
    {
        Event event;
        try
        {
            Datetime dtStartDateTime = DateTime.now();
            Datetime dtEndDateTime = DateTime.now();
            
            // Create an Event 
            event = new Event(  OwnerId = ownerId, Subject = subject, Event_Type__c = eventType, 
                                StartDateTime = dtStartDateTime, EndDateTime = dtEndDateTime, 
                                CurrencyIsoCode = CURRENCY_USD,
                                Account_Name__c = null, 
                                POA_Presented__c = POA_PRESENTED_MF + ',' + POA_PRESENTED_SDD,
                                Call_Objective__c = CALL_OBJECTIVE_MF + ',' + CALL_OBJECTIVE_PVSVS,
                                Call_Activities__c = CALL_ACTIVITIES_AP + ',' + CALL_ACTIVITIES_HOI + ',' + CALL_ACTIVITIES_EL,
                                Material_Presented__c = MATERIAL_PRESENTED_AD + ',' + MATERIAL_PRESENTED_DMC,
                                Outcome_Notes__c = OUTCOME_NOTES, 
                                Call_Result__c = CALL_RESULT_AOWDM + ',' + CALL_RESULT_AO,
                                Description = OUTCOME_NOTES, RecordTypeId = recordTypeId,
                                WhatId=accountId, WhoId=contactId, Event_Status__c = eventStatus);
            System.debug('Event to be added - ' + event);
            if (addEvent)
                insert event;
            System.debug('event added');
        }
        catch(Exception ex)
        {
            System.debug(ERROR_ADDING_EVENT + ex);
        }
        return event;
    }

    // Add test user 
    private static User AddUser(String aliasToAdd, String userNameToAdd, String profileType)
    {
        User u;
        try
        {
            // Create a standard user profile
            Profile[] profiles = [Select p.name, p.id From Profile p WHERE Name = :profileType];
            Profile profile;
            if (profiles.size() > 0)
                profile = profiles[0];
            String profileId = profile.Id;
            
            // Create a user to the database
            u = new User(alias = aliasToAdd, email=TEST_ACCT, emailencodingkey=EMAIL_ENCODING_KEY, 
                lastname=TEST_USER, firstname=TEST_USER, languagelocalekey=LANGUAGE_LOCALE, localesidkey=LANGUAGE_LOCALE, 
                profileid = profileId, isActive=true, timezonesidkey=EDT, username=userNameToAdd);
            u.Department = TEST_USER;               
            insert u;
            System.debug('user added');
        }
        catch(Exception ex)
        {
            System.debug(ERROR_ADDING_USER + ex);
        }
        return u;
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
    private static Account AddAccount()
    {
        Account acct;
        try
        {
            RecordType recordType = [SELECT r.Id FROM RecordType r WHERE Name = :RECORD_TYPE_ACCOUNT_NAME AND SObjectType = :RECORD_TYPE_SOBJECTTYPE_ACCOUNT];
            // Create a RecordTypeLookup__c 
            acct = new Account(Name = TEST_ACCT_1, CurrencyIsoCode=CURRENCY_USD, RecordTypeId=recordType.Id);
            insert acct;
            System.debug('account added');
        }
        catch(Exception ex)
        {
            System.debug(ERROR_ADDING_ACCOUNT + ex);
        }
        return acct;
    }
    
    // Test insert/update Events
    static testMethod void testInsertUpdateEvents() 
    {
        Account acct = AddAccount();
        System.debug('acct = ' + acct);
        if (acct != null)
        {
            Contact contact = AddContact(acct.Id);
            System.debug('contact = ' + contact);
            if (contact != null)
            {           
                Account_Contact_Junction__c accountContact = new Account_Contact_Junction__c(Account__c = acct.Id, Contact__c = contact.Id);
                System.debug('accountContact = ' + accountContact);
    
                User uITM = AddUser(TEST_1, TEST_USER_1_EMAIL, PROFILE_ITM);
                User uVTM = AddUser(TEST_2, TEST_USER_2_EMAIL, PROFILE_VTM);
                System.debug('User uITM = ' + uITM + ', User VTM = ' + PROFILE_VTM);
                if (uITM != null && uVTM != null)
                {
                    RecordTypeLookup__c[] allRecordTypes = [SELECT ID FROM RecordTypeLookup__c];
                    delete allRecordTypes;
                    RecordTypeLookup__c r = AddRecordTypeLookup(EVENT_TYPE_SALES_CALL, RECORD_TYPE_USASL, PROFILE_ITM, UPDATE_FIELD_A);
                    System.debug('RecordTypeLookup__c = ' + r);
                    if (r != null)
                    {
                        r = AddRecordTypeLookup(EVENT_TYPE_EAT_AND_LEARN, RECORD_TYPE_USASL, PROFILE_VTM, UPDATE_FIELD_B);
                        System.debug('RecordTypeLookup__c again = ' + r);
                        if (r != null)
                        {
                            // Create USASL and DARSX Swiss record types
                            RecordType recordTypeUSASL = [SELECT r.Id FROM RecordType r WHERE Name = :RECORD_TYPE_USASL AND SObjectType = :RECORD_TYPE_SOBJECTTYPE_EVENT];
                            System.debug('event before adding');
                            
                            Event eventClosed = AddEvent(true, uITM.Id, SUBJECT_SALES_CALL, EVENT_TYPE_SALES_CALL, acct.Id, contact.Id, EVENT_STATUS_CLOSED, recordTypeUSASL.Id);
                            String sql = 'SELECT ' + UPDATE_FIELD_A + ' FROM Account WHERE Id =  \'' + acct.Id + '\'';
                            Account[] accounts = database.query(sql);
                            
                            System.AssertEquals(1, accounts.size());
                            System.AssertNotEquals(null, accounts[0].ITM_Last_Call_Date__c);
                            System.debug('eventClosed = ' + eventClosed);

                            Event eventOpen = AddEvent(true, uVTM.Id, SUBJECT_EAT_AND_LEARN, EVENT_TYPE_EAT_AND_LEARN, acct.Id, contact.Id, EVENT_STATUS_OPEN, recordTypeUSASL.Id);
                            System.debug('eventOpen = ' + eventOpen.Event_Status__c);
                            eventOpen.Event_Status__c = EVENT_STATUS_CLOSED;
                            updateEventInfo.updateAccountFieldDynamically = true;
                            update eventOpen;
                            
                            System.debug('eventOpen now = ' + eventOpen.Event_Status__c);
                            
                            sql = 'SELECT ' + UPDATE_FIELD_B + ' FROM Account WHERE Id = \'' + acct.Id + '\'';
                            System.debug('sql = ' + sql);
                            accounts = database.query(sql);
                            System.AssertEquals(1, accounts.size());
                            //System.AssertNotEquals(null, accounts[0].VTM_Last_Call_Date__c);
                            System.debug('eventOpen updated to closed');
                            
                        }
                    }
                }
            }
        }
    }
       
    // test bult account insert/update upto 100 accounts
    static testMethod void testInsertUpdateHundredEvents()
    {
        try
        {
            Account acct = AddAccount();
            System.debug('acct = ' + acct);
            if (acct != null)
            {
                Contact contact = AddContact(acct.Id);
                System.debug('contact = ' + contact);
                if (contact != null)
                {           
                    Account_Contact_Junction__c accountContact = new Account_Contact_Junction__c(Account__c = acct.Id, Contact__c = contact.Id);
                    System.debug('accountContact = ' + accountContact);
        
                    User uITM = AddUser(TEST_1, TEST_USER_1_EMAIL, PROFILE_ITM);
                    User uVTM = AddUser(TEST_2, TEST_USER_2_EMAIL, PROFILE_VTM);
                    System.debug('User uITM = ' + uITM + ', User VTM = ' + PROFILE_VTM);
                    if (uITM != null && uVTM != null)
                    {
                        RecordTypeLookup__c[] allRecordTypes = [SELECT ID FROM RecordTypeLookup__c];
                        delete allRecordTypes;
                        RecordTypeLookup__c r = AddRecordTypeLookup(EVENT_TYPE_SALES_CALL, RECORD_TYPE_USASL, PROFILE_ITM, UPDATE_FIELD_A);
                        System.debug('RecordTypeLookup__c = ' + r);
                        if (r != null)
                        {
                            r = AddRecordTypeLookup(EVENT_TYPE_EAT_AND_LEARN, RECORD_TYPE_USASL, PROFILE_VTM, UPDATE_FIELD_B);
                            System.debug('RecordTypeLookup__c again = ' + r);
                            if (r != null)
                            {
                                // Create USASL and DARSX Swiss record types
                                RecordType recordTypeUSASL = [SELECT r.Id FROM RecordType r WHERE Name = :RECORD_TYPE_USASL AND SObjectType = :RECORD_TYPE_SOBJECTTYPE_EVENT];
                                List<Event> eventsClosed = new List<Event>();
                                Event event = null;
                                for (integer i=0; i < EVENTS_100; i++)
                                {
                                    event = AddEvent(false, uITM.Id, SUBJECT_SALES_CALL, EVENT_TYPE_SALES_CALL, acct.Id, contact.Id, EVENT_STATUS_CLOSED, recordTypeUSASL.Id);
                                    eventsClosed.Add(event);
                                }

                                System.debug('event before adding');
                                List<Event> eventsOpen = new List<Event>();
                                for (integer i=0; i < EVENTS_100; i++)
                                {
                                    event = AddEvent(false, uVTM.Id, SUBJECT_EAT_AND_LEARN, EVENT_TYPE_EAT_AND_LEARN, acct.Id, contact.Id, EVENT_STATUS_OPEN, recordTypeUSASL.Id);
                                    eventsOpen.Add(event);
                                }

                                //Now insert data causing an account trigger to fire. 
                                Test.startTest();
                                insert eventsClosed;
                                Event[] events = [SELECT Id FROM Event WHERE Event_Status__c = :EVENT_STATUS_CLOSED AND Outcome_Notes__c = :OUTCOME_NOTES];
                                System.debug('events.size() = ' + events.size());
                                System.AssertEquals(EVENTS_100, events.size());
                                insert eventsOpen;
                                for (integer i=0; i < EVENTS_100; i++)
                                {
                                    eventsOpen[i].Event_Status__c = EVENT_STATUS_CLOSED;
                                
                                }   
                                updateEventInfo.updateAccountFieldDynamically = true;
                                //Now update data causing an account trigger to fire. 
                                update eventsOpen;
                                events = [SELECT Id FROM Event WHERE Event_Status__c = :EVENT_STATUS_CLOSED AND Outcome_Notes__c = :OUTCOME_NOTES];
                                System.AssertEquals(EVENTS_100 + EVENTS_100, events.size());
                                Test.stopTest();                                
                            }
                        }
                    }
                }
            }
        }
        catch(Exception ex)
        {
            System.debug(EXCEPTION_BULK_INSERT_UPDATE + ex.getMessage());
        }
    }
}