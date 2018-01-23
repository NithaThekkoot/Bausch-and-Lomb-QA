/**
* 
*   This trigger makes sure that validation is done on Event. 
*
*   Author           |Author-Email                      |Date       |Comment
*   -----------------|----------------------------------|-----------|--------------------------------------------------
*   Vishal Patel     |vishal@comitydesigns.com          |10.08.2009 |First draft
*	Hari Kalla		 |kallahc@bausch.com				|15.02.2010	|GCM 123536
*
*
*/
trigger ValidationEventTrigger on Event (before insert, before update) 
{
	 
    private String SYSTEM_ADMIN = 'System Administrator';
    private String BL_SYSTEM_ADMIN = 'BL: System Administrator';
    private String BL_INTEGRATION_USER = 'BL: Integration User';

	private String ITM_SALES_REP = 'NAL: ITM Sales Rep User';
	
    private String RECORD_TYPE_SOBJECTTYPE_EVENT = 'Event';
    private String RECORD_TYPE_NAME_USASL = 'USASL';
    private String RECORD_TYPE_NAME_CANVC = 'CANVC';
    private String RECORD_TYPE_NAME_USECS = 'USECS';

    private String RECORD_TYPE_SOBJECTTYPE_ACCOUNT = 'Account';
    private String RECORD_TYPE_NAME_DOORWAY = 'Doorway Account';
    
    private String EVENT_TYPE_SALES_CALL = 'sales call';
    private String EVENT_TYPE_EAT_AND_LEARN = 'eat and learn';
    private String EVENT_TYPE_OUT_OF_TERRITORY_SICK = 'out of territory - sick';
    private String EVENT_TYPE_OUT_OF_TERRITORY_VACATION = 'out of territory - vacation';
    private String EVENT_TYPE_OUT_OF_TERRITORY_INTERNAL = 'out of territory - internal';
    private String EVENT_TYPE_OUT_OF_TERRITORY_HOLIDAY = 'out of territory - holiday';
    private String EVENT_STATUS_CLOSED = 'closed';
    private String EVENT_STATUS_CANCELLED = 'cancelled';
    
    private String CALL_OBJECTIVE = 'Call Attempt (ITM Only)';
    
    private String ERROR_EVENT_ACCOUNT_NOT_DOORWAY = 'Unable to assign event for an account that is not of record type Doorway !';
    private String ERROR_EVENT_DATE_NOT_SAME = 'Event Start and End Date has to be the same for Sales Call, Eat and Learn and Out of Territory Event Types!';
    private String ERROR_EVENT_CREATED_PRIOR_WEEK = 'Event\'s Start Date cannot be created prior to current week !';
    private String ERROR_EVENT_EDITED_PAST_WEEK = 'Event cannot be edited past the week that fall for the Start Date !';
    private String ERROR_EVENT_FUTURE = 'Event in future cannot be closed !';

	System.debug('updateEventInfo.validateEventInfo = ' + updateEventInfo.validateEventInfo);

	// Check if Event Info needs to be executed
	if (updateEventInfo.validateEventInfo == true)
	{
		// Set the static variable so it is not executed again
		updateEventInfo.validateEventInfo = false;
		
	    // Events List
	    List<Event> eventNotUSASL = new List<Event>();
	    // Events List 
	    Set<ID> accountNotDoorway = new Set<ID>();
	    // Events List 
	    List<Event> eventNotDoorwayUpdate = new List<Event>();
	    // Events List 
	    List<Event> eventPriorToThisWeek = new List<Event>();
	    // Events List 
	    List<Event> eventNotSameDay = new List<Event>();
	    // Events List 
	    List<Event> eventInFutureCannotBeClosed = new List<Event>();
	
	    // Get record type of USASL for Event
	    RecordType[] specificRecordTypes = [SELECT r.Id FROM RecordType r WHERE (Name = :RECORD_TYPE_NAME_USASL OR Name =: RECORD_TYPE_NAME_CANVC OR Name =: RECORD_TYPE_NAME_USECS) AND SObjectType = :RECORD_TYPE_SOBJECTTYPE_EVENT];
	    Set<Id> validRecordTypes = new Set<Id>(); 
		for (RecordType recordType : specificRecordTypes)
		{
			validRecordTypes.add(recordType.Id);
		}
	    
	    RecordType[] doorwayRecordType = [SELECT Id FROM RecordType WHERE Name = :RECORD_TYPE_NAME_DOORWAY AND SObjectType = :RECORD_TYPE_SOBJECTTYPE_ACCOUNT];
	
		User[] user = [SELECT u.Profile.Name, u.Name, u.LastName, u.FirstName FROM User u WHERE u.Id = :UserInfo.getUserId()];
		
	    // Initial variables
	    String whatID;
	    DateTime dtStart;
	    DateTime dtStartNew;
	    DateTime dtEnd;
	    Date startDate;
	    Date endDate;
	    Date oldStartDate;
	    
	    // Start and end date
	    Date startOfWeek = date.today().toStartOfWeek();
	    Date endOfWeek = date.today().toStartOfWeek() + 7;
	    
	    Boolean addClosed = false;
	    
	    Boolean addPriorWeek = false;
	    // Check if we got the record types
	    if (specificRecordTypes != null && specificRecordTypes.size() > 0 && doorwayRecordType != null && doorwayRecordType.size() > 0)
	    {
	        // Retrieve all the closed events
	        for (Event e : Trigger.new) 
	        {
	            // Check if the record type is not USASL
	            if (validRecordTypes.contains(e.RecordTypeId))
	            {
	            
	            	// Get the what id  
	                whatID = e.WhatId;
	                System.debug('Debug Event - ' + e);
	                
	                if (whatID != null)
	                {	// Check if the record type is not Doorway for an Account
		                if (whatID.startsWith('001'))
		                {
		                    eventNotDoorwayUpdate.add(e);
		                    accountNotDoorway.add(e.WhatId);
		                }
	                }
	                	                    
	                if (e.StartDateTime != null && e.EndDateTime != null)
	                {
	                    // Initialize start and end datetime
	                    dtStart = e.StartDateTime;
	                    dtEnd = e.EndDateTime;
	                    
	                    // Check if the event for sales call and eat and learn has same start and end date
	                    /*if (
		                    	e.Event_Type__c.toLowerCase() == EVENT_TYPE_SALES_CALL 					|| 
		                    	e.Event_Type__c.toLowerCase() == EVENT_TYPE_EAT_AND_LEARN				||
		                    	e.Event_Type__c.toLowerCase() == EVENT_TYPE_OUT_OF_TERRITORY_SICK		||
	    						e.Event_Type__c.toLowerCase() == EVENT_TYPE_OUT_OF_TERRITORY_VACATION	||
	    						e.Event_Type__c.toLowerCase() == EVENT_TYPE_OUT_OF_TERRITORY_INTERNAL	||
	    						e.Event_Type__c.toLowerCase() == EVENT_TYPE_OUT_OF_TERRITORY_HOLIDAY
	                    	)
	                    
	                    {
	                        // Get the start date and end date
	                        startDate = Date.newInstance(dtStart.year(),dtStart.month(),dtStart.day());
	                        endDate = Date.newInstance(dtEnd.year(),dtEnd.month(),dtEnd.day());
	                        
	                        // Check if the start and end date are on the same day, else report an error
	                        if (startDate.isSameDay(endDate) == false)
	                        {
	                            eventNotSameDay.add(e); 
	                        }           
	                    }
	        */
 							//Hari Kalla 02/15/09 GCM 123536, removed above check as the valid record type check is already done above.	        
	                        // Get the start date and end date
	                        startDate = Date.newInstance(dtStart.year(),dtStart.month(),dtStart.day());
	                        endDate = Date.newInstance(dtEnd.year(),dtEnd.month(),dtEnd.day());
	                        
	                        // Check if the start and end date are on the same day, else report an error
	                        if (startDate.isSameDay(endDate) == false)
	                        {
	                            eventNotSameDay.add(e); 
	                        }           
	        
	                    addClosed = false;
	                    if (Trigger.isUpdate)
	                    {
	                        // Check if the status has not been changed
	                        //if (e.Event_Status__c != Trigger.oldMap.get(e.Id).Event_Status__c)// || e.StartDateTime != Trigger.oldMap.get(e.Id).StartDateTime)
	                            addClosed = true;
	                    }
	                    else
	                        addClosed = true;
	                
	                	System.debug('addClosed = ' + addClosed);
	                	System.debug('e.Call_Objective__c = ' + e.Call_Objective__c);
	                	System.debug('e.WhatId is null ? = ' + String.valueOf(e.WhatId)); 
	                	System.debug('e.WhoId is null ? = ' + String.valueOf(e.WhoId)); 
	                    // Check if the event status is closed in the future

						// Hari Kalla 02/15/09 GCM 123356, adding e.Out_of_Territory_Days__c == 0 condition to allow future dated out of territory events to close	                    
	                    
	                    if (user[0].Profile.Name == SYSTEM_ADMIN || user[0].Profile.Name == BL_SYSTEM_ADMIN)
	                    {
		                    if (addClosed && startDate > date.today() && e.Out_of_Territory_Days__c == 0)
		                        eventInFutureCannotBeClosed.add(e);
	                    }
	                    else
						{
							System.debug('addClosed = ' + addClosed + 'startDate > date.today() = ' + startDate > date.today() + ' e.Event_Status__c.toLowerCase() = ' + e.Event_Status__c.toLowerCase());
	                        if (addClosed && startDate > date.today() && (e.Event_Status__c.toLowerCase() == EVENT_STATUS_CLOSED) && e.Out_of_Territory_Days__c == 0)
		                        eventInFutureCannotBeClosed.add(e);
	                    }
		                                    
	                    // Convert the start date time to startdate 
	                    startDate = Date.newInstance(dtStart.year(),dtStart.month(),dtStart.day());
	                    
	                    addPriorWeek = false;
	                    if (Trigger.isUpdate)
	                    {
	                        // Check if the status has not been changed
	                        //if (e.StartDateTime != Trigger.oldMap.get(e.Id).StartDateTime)
	                            addPriorWeek = true;
	                    }
	                    else
	                        addPriorWeek = true;
	                    
	                    // Check if the start date is for current week only for insert
	                    
	 // JRB - 01/13/2010 omit admin users from error check            
	                    if (user[0].Profile.Name == SYSTEM_ADMIN || user[0].Profile.Name == BL_SYSTEM_ADMIN || user[0].Profile.Name == BL_INTEGRATION_USER)
						{
						addPriorWeek = false;
						}	         
	 					// Hari Kalla 02/15/09, GCM 123536, setting the falg to false to not to fire the prior week logic, when we are ready for this logic the below line can be commented.                   
	                    addPriorWeek = false;
	                    if (addPriorWeek && startDate < startOfWeek)
	                        eventPriorToThisWeek.add(e);
	                }
	            }
	        }
	        
	        // If the account associated with an event is not Doorway then show an error
	        if (accountNotDoorway.size() > 0)
	        {
	            // Get the error Accounts 
	            Map<Id, Account> errorAccounts = new Map<Id, Account>();
	            
	            // Get the accounts that are linked to the events 
	            Account[] accounts = [SELECT Id, RecordTypeId FROM Account WHERE Id IN :accountNotDoorway];
	            
	            // Go through each account in the accounts 
	            for(Account account :accounts)
	            {
	                // Check if they account selected is not a doorway account, add it to the error list
	                if (account.RecordTypeId != doorwayRecordType[0].Id)
	                    errorAccounts.put(account.Id, account);
	            }
	            
	            // If there are error Accounts
	            if (errorAccounts.size() > 0)
	            {
	                // Go through each event and add those in the list to be displayed as an error
	                for(Event event : eventNotDoorwayUpdate)
	                {
	                    if (errorAccounts.ContainsKey(event.WhatId))
	                    {
	                        System.debug('event with account not of type doorway  - ' + event);
	                        // Throw an error.
	                        event.WhatId.addError(ERROR_EVENT_ACCOUNT_NOT_DOORWAY);
	                    }
	                }
	            }
	        }
	        
	        // Check if there are events that are not for the same day
	        if (eventNotSameDay.size() > 0)
	        {
	            // Go through each event and show the error
	            for(Event event :eventNotSameDay)
	            {
	                System.debug('event with not same day error - ' + event);
	                // Throw an error.
	                event.StartDateTime.addError(ERROR_EVENT_DATE_NOT_SAME);
	            }
	        }
	        
	        // Check if there are events that are prior to this week that were created
	        if (eventPriorToThisWeek.size() > 0)
	        {
	            // Go through each event and show the error
	            for(Event event :eventPriorToThisWeek)
	            {
	                System.debug('event with prior week error - ' + event);
	                // Throw an error.
	                event.StartDateTime.addError(ERROR_EVENT_CREATED_PRIOR_WEEK);
	            }
	        }
	        
	        // Check if the future event are there that are being attempted to be closed
	        if (eventInFutureCannotBeClosed.size() > 0)
	        {
	            // Go through each event and show the error
	            for(Event event :eventInFutureCannotBeClosed)
	            {
	                // Throw an error.
	                event.Event_Status__c.addError(ERROR_EVENT_FUTURE);
	            }
	        }
	        
	    }
	}	   
}