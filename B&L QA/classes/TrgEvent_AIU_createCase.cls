/**
* 
*   Test class for trigger "event_AIU_createCase"
* 
*    Author         |Author-Email                   |Date       |Comment
*    ---------------|-------------------------------|-----------|--------------------------------------------------
*    S Cardinali    |samantha.cardinali@bausch.com  |16.09.2010 |First draft
*    S Cardinali    |samantha.cardinali@bausch.com  |11.04.2011 |Migrating to Surgical
*    S Cardinali    |samantha.cardinali@bausch.com  |24.05.2012 |Adding primary focus (to pass new validation rule)
*    S Cardinali    |samantha.cardinali@bausch.com  |06.03.2013 |Changes in support of streamlining / bugfixing
*/
@isTest
private class TrgEvent_AIU_createCase {
  static testMethod void testEvent_AIU_createCase() {

    ID rtShipTo = ClsUtility.getRecordTypeId('Account','Ship To Account');
    ID rtEMEAEvent = ClsUtility.getRecordTypeId('Event','EMEA SU Event');
    ID prEMEASUTM = ClsUtility.getProfileId('EMEASU Territory Manager');
    List<UserRole> list_Roles = [SELECT Id, Name FROM UserRole WHERE Name IN ('EMEA SU Regional Director','UK SU TM - North','FRA SU TM RG01_01','Germany Nth TM','EM SU Russia TM') Limit 5];

    //Create User
    List<User> list_Users = new List<User>();
    Integer i = 1;
    For(UserRole ur : list_Roles) {
        System.debug('Role found: ' + ur.Name);
        String sCountry = '';
        if(ur.Name == 'UK SU TM - North') {
            sCountry = 'UNKGD';
        } else if(ur.Name == 'Germany Nth TM'){
            sCountry = 'DMBLV';
        } else if(ur.Name == 'FRA SU TM RG01_01') {
            sCountry = 'FRANC';
        } else if(ur.Name == 'EM SU Russia TM') {
            sCountry = 'RUSSIA';
        } else if(ur.Name == 'EMEA SU Regional Director') {
            sCountry = '';
        }
        User oUser = new User(FirstName = 'SCTest', LastName = 'User12345', UserRoleId = ur.Id, ProfileId = prEMEASUTM, alias = 'user99' + i, username='SCTest@User12345' + i + '.com',
                     email='SCTest@User12345.com',Country=sCountry, emailencodingkey='UTF-8', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles');
        list_Users.add(oUser);
        i = i+1;
    }
    insert list_Users;

    List<User> list_SavedUsers = new List<User>();
    list_SavedUsers = [SELECT Id, Name, Country FROM User WHERE Id IN :list_Users];
    System.debug('list_SavedUsers: ' + list_SavedUsers);

    List<Account> list_Accounts = new List<Account>();
    List<AccountTeamMember> list_AccountTeam = new List<AccountTeamMember>();
    List<AccountShare> list_AccountShare = new List<AccountShare>();
    List<Contact> list_Contacts = new List<Contact>();
    List<Event> list_Event = new List<Event>();
    Set<ID> set_Event2Ids = new Set<ID>();
    List<Account> list_SavedAccounts = new List<Account>();
    List<Contact> list_SavedContacts = new List<Contact>();

    User runningUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs(runningUser) {
        System.debug('list_SavedUsers.size(): ' + list_SavedUsers.size());
        for(User u : list_SavedUsers) {
            //Create Account
            Account oAccount = new Account(Name = 'SCTestAcct12345' + u.Country, recordtypeid = rtShipTo, SETID__c = u.Country, ownerid = u.Id);
            list_Accounts.add(oAccount);
        }
        System.debug('list_Accounts.size(): ' + list_Accounts.size());
        insert list_Accounts;
        list_SavedAccounts = [SELECT Id, SETID__c From Account Where Id IN :list_Accounts];
        System.debug('list_SavedAccounts.size(): ' + list_SavedAccounts.size());
        
        for(User u : list_SavedUsers) {
            for (Account a : list_SavedAccounts) {
                if (a.SETID__c == u.Country) {
                    AccountTeamMember AccountTeam = new AccountTeamMember(AccountId = a.Id, UserId = u.Id, TeamMemberRole= 'Sales Rep');
                    list_AccountTeam.add(AccountTeam);
                }
            }
        }
        insert list_AccountTeam;
        System.debug('list_AccountTeam: ' + list_AccountTeam);

        for(User u : list_SavedUsers) {
            System.debug('User Country: ' + u.Country);
            for(Account a : list_SavedAccounts) {
                System.debug('Account SETID: ' + a.SETID__c);
                if(a.SETID__c == u.Country) {
                   System.debug('Create contact: ' + a.SETID__c);
                   //Create Contact
                   Contact oContact = new Contact(FirstName = 'SCTest12345', LastName = 'Cntct' + u.Country, Email = 'sctest@cntct12345.com', AccountId = a.Id, OwnerId = u.Id);
                   list_Contacts.add(oContact);
                }
            }
        }
        System.debug('list_Contacts.size(): ' + list_Contacts.size());
        insert list_Contacts;
        list_SavedContacts = [SELECT Id, FirstName, LastName, AccountId From Contact WHERE Id IN :list_Contacts];
        system.debug('list_SavedContacts: ' + list_SavedContacts);

        List<Event> list_SavedEvents = New List<Event>();
        for(User u : list_SavedUsers) {
            System.debug('User: ' + u.Name);
                for(Account a : list_SavedAccounts) {
                    System.debug('Account: ' + a.SETID__c);
                    if(a.SETID__c == u.Country) {
                        for(Contact c : list_SavedContacts) {
                            System.debug('Contact: ' + c.Lastname);
                            if(c.AccountId == a.Id) {
                                //Create Event with Complaint
                                Event oEvent1 = new Event(RecordTypeId = rtEMEAEvent,
                                                          OwnerId = u.Id, 
                                                          WhatId = a.Id, 
                                                          WhoId = c.Id, 
                                                          Description = 'A test description',
                                                          Complaint_Description__c = u.Country + 'Test sales call with customer complaint checked.', 
                                                          ActivityDate = date.today(),
                                                          StartDateTime = System.now(),
                                                          EndDateTime = System.now(),
                                                          Type = 'Visit',
                                                          IsReminderSet = false,
                                                          Customer_Complaint__c = true,
                                                          Primary_focus__c = 'Amvisc');
                                list_Event.add(oEvent1);
                                System.debug('Adding Event 1: ' + oEvent1);
                                //Create Event without Complaint
                                Event oEvent2 = new Event(RecordTypeId = rtEMEAEvent, 
                                                          OwnerId = u.Id, 
                                                          WhatId = a.Id, 
                                                          WhoId = c.Id, 
                                                          Description = 'A test description',
                                                          Complaint_Description__c = u.Country + 'Test sales call with customer complaint unchecked.', 
                                                          ActivityDate = date.today(), 
                                                          StartDateTime = System.now(),
                                                          EndDateTime = System.now(),
                                                          Type = 'Visit',
                                                          IsReminderSet = false,
                                                          Customer_Complaint__c = false,
                                                          Primary_focus__c = 'Amvisc');
                                list_Event.add(oEvent2);
                                System.debug('Adding Event 2: ' + oEvent2);
                            }
                        }
                    }
                }
            }
            System.debug('list_Event.size(): ' + list_Event.size());
            if (list_Event.size() > 0) {
                insert list_Event;
                list_SavedEvents = list_Event; //this will pick up the last inserted events
            }

            //Update Event to Complaint
            list_SavedEvents = [SELECT Id, Customer_Complaint__c FROM Event WHERE Id IN :list_SavedEvents];
            List<Event> list_EventsToUpdate = new List<Event>();
            for(Event e : list_SavedEvents ) {
               if(e.Customer_complaint__c == false) {
                   e.Customer_Complaint__c = true;
                   list_EventsToUpdate.add(e);
               }
            }
            update list_EventsToUpdate;

        }

    }
}