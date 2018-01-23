/**
* 
*   Test class for trigger "event_BIU_setShortDescAndShipTo"
* 
*    Author         |Author-Email                   |Date       |Comment
*    ---------------|-------------------------------|-----------|--------------------------------------------------
*    S Cardinali    |samantha.cardinali@bausch.com  |06.01.2010 |First draft
*    S Cardinali    |samantha.cardinali@bausch.com  |16.02.2010 |Rename of classes and custom field
*    S Cardinali    |samantha.cardinali@bausch.com  |12.04.2010 |Applying to the SU org for EMEA SU
*    S Cardinali    |samantha.cardinali@bausch.com  |01.02.2010 |Commenting out all logic - has been replaced by EMEAFunctions
*
*/
@isTest
private class TrgEvent_BIU_setShortDescAndShipTo{
  static testMethod void testEvent_BIU_setShortDescAndShipTo() {
    
        //Select recordtypes and profile
    RecordType rtShipTo = [SELECT Id From RecordType Where SobjectType = 'Account' And Name = 'Ship To Account' Limit 1];
    RecordType rtEvent = [SELECT Id From RecordType Where SobjectType = 'Event' And Name = 'USSUR Clinical Development Specialist' Limit 1];  
    Profile pUserProfile = [SELECT Id From Profile Where Name = 'USSUR: CPQ Sales Rep User' Limit 1];  
    //Create a test user
    User testUser = new User (
      Alias = 'testus',
      Email = 'testuser123@bausch.com',
      Emailencodingkey = 'UTF-8',
      Lastname = 'User',
      Firstname = 'Test',
      Languagelocalekey = 'en_US',
      Localesidkey = 'en_US',
      Profileid = pUserProfile.Id,
      isActive = true,
      Timezonesidkey = 'America/New_York',
      Username = 'testuser123@bausch.com'
    );
    try{
      insert testUser;
    } catch(Exception e) {
      System.debug('Error adding User: ' + e.getMessage());
    }
    //Insert Account
    Account testAC = new Account (
      Name = 'SCTEST123',
      RecordType = rtShipTo,
      Ship_To_ID__c = '00123456',
      OwnerId = testUser.Id
    );
    try{
     insert testAC;
    } catch(Exception e) {
      System.debug('Error adding Account: ' + e.getMessage());
    }
    Account aInsertedAccount = [Select Id, Ship_To_ID__c From Account Where Id = :testAC.Id];
    System.debug('Inserted Account: ' + aInsertedAccount.Ship_To_ID__c);
    System.runAs(testUser) {
      //Insert Event
      Event testE = new Event (
        RecordType = rtEvent,
        WhatId = testAC.Id,
        OwnerId = testUser.Id,
        Subject = 'A Test Event',
        Description = 'Test SU Event', 
        Short_Description__c = '',
        Ship_to_ID__c = '',
        StartDateTime = System.now(),
        EndDateTime = System.now());
      try {
        insert testE;
        System.debug('New Event ID: ' + testE.Id);
      } catch(Exception e) {
        System.debug('--> ERROR: ' + e.getMessage());
      }
      Event eInsertedEvent = [Select Id, Description, Short_Description__c, Ship_To_ID__c From Event Where Id = :testE.Id];
      System.debug('Inserted Event - shipto: ' + eInsertedEvent.Ship_To_ID__c);
      //Check Short Description is populated
      String sCalculatedShortDesc1 = eInsertedEvent.Description;
      String sActualShortDesc1 = eInsertedEvent.Short_Description__c;
      Boolean bResult1 = sCalculatedShortDesc1.equalsIgnoreCase(sActualShortDesc1);
      //System.assertEquals(bResult1, true);
      //Check ShipTo populated correctly
      //System.assertEquals(aInsertedAccount.Ship_To_ID__c, eInsertedEvent.Ship_To_ID__c);

      //Update Description on Event
      eInsertedEvent.Description = 'Text greater than 255 characters. Text greater than 255 characters. Text greater than 255 characters. Text greater than 255 characters. Text greater than 255 characters. Text greater than 255 characters. Text greater than 255 characters. Text greater than 255 characters.';
      try {
        update eInsertedEvent;
      } catch (DmlException e) {
        System.debug('--> ERROR: ' + e.getMessage());
      }
      Event eUpdatedEvent = [Select Id, Description, Short_Description__c From Event Where Id = :eInsertedEvent.Id];
      //Check Short Description is updated
      String sCalculatedShortDesc2 = eUpdatedEvent.Description.substring(0,254);
      String sActualShortDesc2 = eUpdatedEvent.Short_Description__c;
      Boolean bResult2 = sCalculatedShortDesc2.equalsIgnoreCase(sActualShortDesc2);
      //System.assertEquals(bResult2, true);
    }
        
  }
}