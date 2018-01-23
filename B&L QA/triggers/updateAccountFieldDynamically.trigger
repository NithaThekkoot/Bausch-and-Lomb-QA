/**
* 
*   This trigger takes the event that are closed, take the date and assign it to the fields dynamically using DML
*   custom object. 
*
*   Author           |Author-Email                      |Date       |Comment
*   -----------------|----------------------------------|-----------|--------------------------------------------------
*   Vishal Patel     |vishal@comitydesigns.com          |09.29.2009 |First draft
*
*
*/
trigger updateAccountFieldDynamically on Event (after insert, after update) 
{
    clsPhysicianVisitUpdate.blnIsTriggerFiredAlready = true;
    
    // event status Closed
    private String RECORD_TYPE_SOBJECTTYPE = 'Event';
    private String RECORD_TYPE_NAME_USASL = 'USASL';
    private String RECORD_TYPE_NAME_CANVC = 'CANVC';
    private String RECORD_TYPE_NAME = 'USASL';
    private String ITM_SALES_REP = 'NAL: ITM Sales Rep User';
    
    private String EVENT_TYPE_SALES_CALL = 'sales call';
    private String EVENT_TYPE_EAT_AND_LEARN = 'eat and learn';
    private String EVENT_STATUS_CLOSED = 'closed';
    private String EVENT_STATUS_CANCELLED = 'cancelled';
    
    private String CALL_OBJECTIVE = 'Call Attempt (ITM Only)';
    
    System.debug('updateEventInfo.updateAccountFieldDynamically = ' + updateEventInfo.updateAccountFieldDynamically);

    // Check if Event Info needs to be executed
    if (updateEventInfo.updateAccountFieldDynamically == true)
    {
        // Set the static variable so it is not executed again
        updateEventInfo.updateAccountFieldDynamically = false;

        // Get all event ids that we need to process
        Set<ID> eventIds = new Set<ID>();
        
        // Get all the events that are closed
        Map<ID, Event> events = new Map<ID, Event>();
        
        // Get all the account ids
        Map<ID, Event> accountIds = new Map<ID, Event>();
    
        // Is Valid
        Boolean isValid = false;
    
        Set<ID> userIds = new Set<ID>();
        
        // Get User info
        User[] userInformation = [SELECT u.Profile.Name, u.Name, u.LastName, u.FirstName FROM User u WHERE u.Id = :UserInfo.getUserId()];
        
        // Get record type of USASL from AccountProfile
        RecordType[] specificRecordTypes = [SELECT r.Id FROM RecordType r WHERE (Name = :RECORD_TYPE_NAME_USASL OR Name =: RECORD_TYPE_NAME_CANVC) AND SObjectType = :RECORD_TYPE_SOBJECTTYPE];
        Set<Id> validRecordTypes = new Set<Id>(); 
        for (RecordType recordType : specificRecordTypes)
        {
            validRecordTypes.add(recordType.Id);
        }

        // Retrieve all the closed events
        for (Event e : Trigger.new) 
        {
            // Check if the record type is not USASL
            if (validRecordTypes.contains(e.RecordTypeId))
            {
                // Initialize variables
                isValid = false;
            
                Boolean eventClosed =   (
                                        userInformation[0].Profile.Name != ITM_SALES_REP &&
                                        (
                                            e.Event_Type__c.toLowerCase() == EVENT_TYPE_EAT_AND_LEARN ||
                                            e.Event_Type__c.toLowerCase() == EVENT_TYPE_SALES_CALL
                                        ) && 
                                        e.Event_Status__c.toLowerCase() != EVENT_STATUS_CANCELLED &&
                                        e.WhatId != null &&
                                        e.POA_Presented__c != null &&
                                        e.Call_Objective__c != null && 
                                        e.Call_Activities__c != null && 
                                        e.Description != null &&
                                        e.WhoId != null &&
                                        e.Material_Presented__c != null
                                    ) ||
                                    (
                                        userInformation[0].Profile.Name == ITM_SALES_REP &&
                                        e.Event_Status__c.toLowerCase() != EVENT_STATUS_CANCELLED &&
                                        (
                                            e.Event_Type__c.toLowerCase() == EVENT_TYPE_EAT_AND_LEARN ||
                                            e.Event_Type__c.toLowerCase() == EVENT_TYPE_SALES_CALL
                                        ) && 
                                        (
                                            (
                                                e.WhatId != null &&
                                                e.POA_Presented__c != null && 
                                                e.Call_Objective__c != null && 
                                                e.Call_Activities__c != null && 
                                                e.Description != null &&
                                                e.Call_Result__c != ''
                                            ) || 
                                            (
                                                String.valueOf(e.Call_Objective__c).contains(CALL_OBJECTIVE)
                                            )
                                        )
                                    );
                                                                                            
                System.debug('eventClosed = ' + eventClosed);
                System.debug('e.Call_Objective__c = ' + e.Call_Objective__c);
                System.debug('e.WhatId is null ? = ' + String.valueOf(e.WhatId)); 
                System.debug('e.WhoId is null ? = ' + String.valueOf(e.WhoId)); 
                            
                // Just in case if the event is closed on insert
                if (Trigger.isInsert)
                    isValid = (e.Event_Status__c.toLowerCase() == EVENT_STATUS_CLOSED || eventClosed) && e.AccountId != null;
                else
                {
                    // Check if the event was open prior to have been closed, just if event type is not updated and so we need to prevent the trigger to be fired again
                    //isValid = Trigger.oldMap.get(e.Id).Event_Status__c != e.Event_Status__c && (e.Event_Status__c.toLowerCase() == EVENT_STATUS_CLOSED || eventClosed) && e.AccountId != null;
                    isValid = Trigger.oldMap.get(e.Id).Event_Status__c != EVENT_STATUS_CLOSED && eventClosed && e.AccountId != null;
                    System.debug('Trigger.oldMap.get(e.Id).Event_Status__c = ' + Trigger.oldMap.get(e.Id).Event_Status__c + ', e.AccountId = ' + e.AccountId + ', e.Event_Status__c = ' + e.Event_Status__c);
                     
                }
        
                System.debug('isValid = ' + isValid);
                // Check if old status is not closed and check if the new event status is closed and account id != null
                if (isValid)
                {
                    events.put(e.Id, e);
                    accountIds.put(e.AccountId, e);
                    userIds.add(e.OwnerId);
                }
            }
        }
            
                
        // Check if events have any data
        if (events != null && events.size() > 0)
        {
            // Set a map for userId and profile
            Map<Id, String> userIdMap = new Map<Id, String>();
             
            // Get users for specific profiles      
            User[] users = [SELECT u.Profile.Name, u.ProfileId From User u WHERE u.Id IN :userIds];
            for(User user : users)
            {
                userIdMap.put(user.Id, user.Profile.Name);
            }
    
                // Map of all the fields to update
            Map<String, String> fieldsToUpdate = new Map<String, String>();
                
            // Get all the fields to update
            RecordTypeLookup__c[] recordsToUpdate = [SELECT EventType__c, RecordType__c, AssignToProfile__c, UpdateField__c FROM RecordTypeLookup__c];
        
            System.debug('recordsToUpdate = ' + recordsToUpdate);
                
            // Get all the record type fields in a map      
            for (RecordTypeLookup__c recordTypeToUpdate : recordsToUpdate)
                fieldsToUpdate.put(recordTypeToUpdate.RecordType__c + '_' + recordTypeToUpdate.EventType__c + '_' + recordTypeToUpdate.AssignToProfile__c, recordTypeToUpdate.UpdateField__c);
        
            System.debug('fieldsToUpdate = ' + fieldsToUpdate);
                    
            if (fieldsToUpdate != null && fieldsToUpdate.size() > 0)
            {
                // Map of field and value
                Map<String, Date> fieldValue = new Map<String, Date>();
    
                // Retrieve the update field and value that we need to update
                Map<ID, Map<String, Date>> updateFields = new Map<ID, Map<String, Date>>();
                    
                // Fields that are part of the string 
                String fields = '';
                String accountIdList = '';
                        
                // Go through all the events
                for (ID e : events.keySet())
                {
                    // variable for retrieving the field and value
                    String eventType; 
                    String ownerProfile; 
                    String fieldToUpdate;
                    Date value;
                        
                    // retrieve the event type
                    eventType = events.get(e).Event_Type__c; 
                        
                    // retrieve the owner profile
                    ownerProfile = userIdMap.get(events.get(e).OwnerId);
                        
                    System.debug('eventType = ' + eventType);
    
                    // Retrieve the field that we need to update based on record type and event type
                    if (fieldsToUpdate.containsKey(RECORD_TYPE_NAME_USASL + '_' + eventType + '_' + ownerProfile))
                        fieldToUpdate = fieldsToUpdate.get(RECORD_TYPE_NAME_USASL + '_' + eventType + '_' + ownerProfile);

                    if (fieldsToUpdate.containsKey(RECORD_TYPE_NAME_CANVC + '_' + eventType + '_' + ownerProfile))
                        fieldToUpdate = fieldsToUpdate.get(RECORD_TYPE_NAME_CANVC + '_' + eventType + '_' + ownerProfile);

                    System.debug('fieldToUpdate = ' + fieldToUpdate);
                    // Check if the StartDateTime is not null
                    if (events.get(e).StartDateTime != null)
                    {
                        System.debug('Startdatetime = ' + events.get(e).StartDateTime);
                        
                        DateTime dt = events.get(e).StartDateTime;
                        value = Date.newInstance(dt.year(),dt.month(),dt.day());
                    }
                        
                    // Check if the fieldToUpdate and value is not null
                    if (fieldToUpdate != null && value != null)
                    {
                        System.debug('fields.indexOf(fieldToUpdate)  = ' + fields.indexOf(fieldToUpdate) );
                            
                        // Check if the fields exist
                        if (fields.indexOf(fieldToUpdate) < 0)
                        {
                            // Get all the fields as comma delimited by checking the length of the field
                            if (fields.length() == 0)
                                fields = fieldToUpdate;
                        }
    
                        System.debug('fields = ' + fields);
    
                        // Check if the fields exist
                        if (accountIdList.indexOf(events.get(e).AccountId) < 0)
                        {
                            // Get all the fields as comma delimited by checking the length of the field
                            if (accountIdList.length() == 0)
                                accountIdList =  '\'' + events.get(e).AccountId + '\'';
                        }
                            
                        System.debug('accountIdList = ' + accountIdList);
                        
                        // assign a string and date map
                        fieldValue = new Map<String, Date>();
                        
                        // assign the field and value
                        fieldValue.put(fieldToUpdate, value); 
                        
                        // Assign the account id and field value
                        updateFields.put(events.get(e).AccountId, fieldValue);
                    }
                }
                System.debug('updateFields = ' + updateFields);
                        
                // Check if the update fields
                if (fields.length() > 0 && accountIdList.length() > 0 && (updateFields != null && updateFields.size() > 0))
                {
                    // SQL String
                    String sql = 'SELECT Id, ' + fields + ' FROM account WHERE Id IN (' + accountIdList + ')';
                    
                    System.debug('sql = ' + sql);
    
                    // Execute sql
                    SObject[] accounts = database.query(sql);
    
                    System.debug('accounts = ' + accounts);
    
                    // Map of field and value
                    fieldValue = new Map<String, Date>();
                        
                    // Key/Value variables
                    ID idKey;
                    Date value;
                            
                    // loop through each account and assign values
                    for (SObject account :accounts)
                    {
                        // Get the key value
                        idKey = (ID)account.get('Id');
                        
                        // Get field value
                        fieldValue = updateFields.get(idKey);
                        
                        // Retrieve the first key
                        Set<String> fieldSet = fieldValue.keySet();
                        for(String field :fieldSet)
                        {
                            // retrieve the value for the field
                            value = fieldValue.get(field);
                            
                            // Get the original field value 
                            Object o = account.get(field);
                            if ((o == null) || (o != null && value > Date.valueOf(o)))
                                account.put(field, value);
                        }
                    }
                    
                    System.debug('accounts = ' + accounts);
                    // Updated the accounts
                    if (accounts != null && accounts.size() > 0)
                    {
                        // Save the accounts with the key and value we set
                        Database.SaveResult[] SRs = Database.update(accounts);
        
                        Integer i = 0;
                        // Process the save results
                        for(Database.SaveResult sr : SRs)
                        {
                            if(!sr.isSuccess())
                            {
                                // Get the first save result error
                                Database.Error err = sr.getErrors()[0];
                                
                                idKey = (ID)accounts[i].get('Id');
                                // Throw an error.
                                trigger.newMap.get(accountIds.get(idKey).Id).addError('Unable to assign value to an account field !');
                            }
                            i++;
                        }
                    }               
                }               
            }
        }
    }
}