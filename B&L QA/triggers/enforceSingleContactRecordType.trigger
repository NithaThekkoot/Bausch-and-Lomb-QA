/**
* 
* 	This trigger makes sure that only one record of each record type per Contact. 
*
*  	Author		     |Author-Email			   	     	|Date		|Comment
*  	-----------------|----------------------------------|-----------|--------------------------------------------------
*  	Vishal Patel     |vishal@comitydesigns.com 			|10.02.2009 |First draft
*
*
*/
trigger enforceSingleContactRecordType on Contact_Profile__c (before insert, before update) {

	// Error Message
	String errorMsg = 'You are about to insert a contact profile with a record type that already exist!';
	
	// Accounts that we need to check 
	Set<ID> contacts = new Set<ID>();
	
	// Map of contact information
	Map<String, Contact_Profile__c> currentContactProfileMap = new Map<String, Contact_Profile__c>();
	
	// Add contact 
	Boolean addContact = false;
	
	// Retrieve all the contact profile
	for (Contact_Profile__c cp : Trigger.new) 
	{
		// Initialize contact
		addContact = false;
		
		// if the trigger is update then we need to check if the record type changed
		if (Trigger.isUpdate)
		{
			// Check if the record type was changed to new record type when edit of the record was created
			if (Trigger.oldMap.get(cp.Id).RecordTypeId != cp.RecordTypeId)
			{
				addContact = true;
			}
		}
		
		// Add contact is true and if the trigger is inserted
		if (addContact || Trigger.isInsert)
		{
			// contacts that we need to check the profile for
			contacts.add(cp.Contact__c);	
			currentContactProfileMap.put(cp.Contact__c + '_' + cp.RecordTypeId, cp);
		}
	}
	
	System.debug('contacts = ' + contacts);
	System.debug('currentContactProfileMap = ' + currentContactProfileMap);
	 
	// Retrieve all the contact profiles
	Contact_Profile__c[] contactProfiles = [SELECT c.RecordTypeId, c.RecordType.Name, c.Contact__c FROM Contact_Profile__c c WHERE c.Contact__c IN :contacts];
	
	// Map of contact information
	List<Contact_Profile__c> contactErrors = new List<Contact_Profile__c>();

	// Counter to check how many 		
	Integer counter = 0;
	
	System.debug('contactProfiles = ' + contactProfiles);
			
	// Go through each contact profile
	for(Contact_Profile__c contactProfile : contactProfiles)
	{
		counter = 1;
		System.debug('contactProfile.Contact__c and contactProfile.RecordTypeId = ' + contactProfile.Contact__c + '_' + contactProfile.RecordTypeId);
		
		if (currentContactProfileMap.containsKey(contactProfile.Contact__c + '_' + contactProfile.RecordTypeId))
		{
			contactErrors.add(currentContactProfileMap.get(contactProfile.Contact__c + '_' + contactProfile.RecordTypeId));
		}	
	}
	System.debug('contactErrors = ' + contactErrors);
		
	// If the contact profile map has values then we need to concentrate on those contacts only
	if (contactErrors != null && contactErrors.size() > 0)
	{
		for(Contact_Profile__c contactProfileError :contactErrors)
		{
			// Throw an error.
			contactProfileError.RecordTypeId.addError(errorMsg);
		}
	}

}