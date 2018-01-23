/**
* 
*   Test class for trigger "Event_BIU_EMEAFunctions": merge of pre-existing triggers and test classes.
* 
*   Author         |Author-Email                   |Date       |Comment
*   ---------------|-------------------------------|-----------|--------------------------------------------------
*   Frederic Faisst|frederic.faisst@itbconsult.com |26.11.2010 |First draft
*
*/
@isTest
private class TrgEvent_BIU_EMEAFunctions {

	static testMethod void testEvent_BIU_EMEAFunctions() {
  
	    //Select recordtypes and profile
	    
	    Id rtShipTo = clsUtility.getRecordTypeId('Account', 'Ship To Account');
	    Id rtEvent = clsUtility.getRecordTypeId('Event', 'EMEA SU Event');  
	    Profile pUserProfile = [SELECT Id From Profile Where Name = 'EMEASU EM Sales Admin' limit 1];
	    	    
	    //Create a test user
	    User testUser = new User (
	        Alias = 'testus',
	        Email = 'testuser123@bausch.com',
	        Emailencodingkey = 'UTF-8',
	        Lastname = 'User',
	        Firstname = 'Test',
	        Languagelocalekey = 'de',
	        Localesidkey = 'de',
	        Profileid = pUserProfile.Id,
	        isActive = true,
	        Timezonesidkey = 'America/New_York',
	        Username = 'testuser123@bausch.com');
	    
	    try{
	       insert testUser;
	    } 
	    catch(Exception e) {
      		System.debug('Error adding User: ' + e.getMessage());
    	}
	    //Insert Account
	    Account testAC = new Account (
	    	Name = 'SCTEST123',
	        RecordTypeId = rtShipTo,
	        Ship_To_ID__c = '00123456',
	        OwnerID = testUser.Id);
	    
	    try{
	    	insert testAC;
	    } 
	    catch(Exception e) {
        	System.debug('Error adding Account: ' + e.getMessage());
    	}        
    
	    Contact con = new Contact();
	    con.FirstName = 'First';
	    con.LastName = 'Last';
	    con.AccountId = testAC.Id;
	    insert con;
	    
	    System.runAs(testUser) {
	    	//Insert Event (no account)
	        Event testEvent = new Event (
	        	RecordTypeId = rtEvent,
		        WhoId = con.Id,
		        WhatId = null,
		       	Subject = 'Sales Call',
		       	Description = 'Test Event 123', 
		        Short_Description__c = '',
		        Ship_to_ID__c = '',
		        StartDateTime = System.now(),
		        EndDateTime = System.now(),
		        Type = 'Visit');
	        
	        try {
	        	insert testEvent;
	        } 
	        catch(Exception e) {
	        	System.debug('--> ERROR: ' + e.getMessage());
	        }
	        
	        //Update Event - test description > 255 chars
	        testEvent.Description = '12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890';
	        try {
	        	Update testEvent;
	        } 
	        catch(Exception e) {
	        	System.debug('--> ERROR: ' + e.getMessage());
	        }
	
	        //Insert Event (with account)
	        Event testEvent2 = new Event (
	        	RecordTypeId = rtEvent,
	          	WhoId = null,
	          	WhatId = testAC.Id,
	          	Subject = 'Sales Call',
	          	Description = 'Test Event 345', 
	          	Short_Description__c = '',
	          	Ship_to_ID__c = '',
	          	StartDateTime = System.now(),
	          	EndDateTime = System.now(),
	          	Type = 'Visit');
	        
	        try {
	        	insert testEvent2;
	        } 
	        catch(Exception e) {
	        	System.debug('--> ERROR: ' + e.getMessage());
	        }
	    }
	}
}