/**
* 
*   This trigger makes sure that each Event has What Id and Who Id assigned based on Account Contact Junction object
*
*   Author           |Author-Email                      |Date       |Comment
*   -----------------|----------------------------------|-----------|--------------------------------------------------
*   Vishal Patel     |vishal@comitydesigns.com          |11.03.2009 |First draft
*
*
*/
trigger updateEventWhatAndWhoId on Event (after insert) {

    System.debug('updateEventInfo.updateEventWhatAndWhoId = ' + updateEventInfo.updateEventWhatAndWhoId);

    // Check if Event Info needs to be executed
    if (updateEventInfo.updateEventWhatAndWhoId == true)
    {
        // Set the static variable so it is not executed again
        updateEventInfo.updateEventWhatAndWhoId = false;

        // Get the prefix for account contact junction object
        String accountContactPrefix = Schema.SObjectType.Account_Contact_Junction__c.getKeyPrefix();
    
        // Map of event based on account contact junction object id
        Map<String, Event> events = new Map<String, Event>(); 
    
        // String what ID
        String whatID;
    
        // Set of all event ids
        Set<Id> eventIds = new Set<Id>();
        
        // Retrieve all the closed events
        for (Event e : Trigger.new) 
        {
            // Assign the what ID
            whatID = e.WhatId;
            
            if(whatID != null)
            {
                // Check if the what id starts with account contact junction object prefix 
                if (whatID.startsWith(accountContactPrefix))
                {
                    eventIds.add(e.Id);
                    events.put(whatId, e);
                }
            }
        }
        
        // Check if the events are not null and the size is > 0
        if (events != null && events.size() > 0)
        {
            // Map of Account_Contact_Junction__c object
            Map<Id, Account_Contact_Junction__c> accountContactMap = new Map<Id, Account_Contact_Junction__c>();
             
            // Get all the account contact junction objects
            Account_Contact_Junction__c[] accountContacts = [SELECT Account__c, Contact__c FROM Account_Contact_Junction__c WHERE Id IN : events.keySet()];
        
            // Go through each accountContact object and put it in the map
            for (Account_Contact_Junction__c accountContact : accountContacts)
                accountContactMap.put(accountContact.Id, accountContact);
        
            // Stores Account_Contact_Junction__c information
            Account_Contact_Junction__c accountContact;
            
            // Get the list of events to update
            List<Event> eventsToUpdate = [SELECT Id, WhatId, WhoId FROM Event WHERE Id IN : eventIds]; 
            
            // Loop through each event and assign the what and who ids
            for (Event event : eventsToUpdate)
            {
                // Set the what and who ids
                accountContact = accountContactMap.get(event.WhatId);
                event.WhatId = accountContact.Account__c;
                event.WhoId = accountContact.Contact__c;
            }
        
            // Update events with accountid and account name in the custom field
            database.Saveresult[] eventSRs = database.update(eventsToUpdate);
            
            // Initialize the variable
            Integer i = 0;
            
            // Process the save results
            for(Database.SaveResult sr : eventSRs)
            {
                if(!sr.isSuccess())
                {
                    // Get the first save result error
                    Database.Error err = sr.getErrors()[0];
                    
                    // Throw an error.
                    trigger.newMap.get(eventsToUpdate[i].Id).addError('Unable to update what and who id field for an event!');
                }
                i++;
            }
        }
    }       
}