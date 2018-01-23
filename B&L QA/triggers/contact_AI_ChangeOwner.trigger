/**
 * 
 *   This trigger changes the owner of the contact to that of the associated account 
 *   for the record type INDSU Physician.
 *
 *    Author         |Author-Email                                   |Date       |Comment
 *    ---------------|---------------------------------------------  |-----------|--------------------------------------------------
 *    Balaji         |balaji.prabakaran@listertechnologies.com       |27.03.2010 |First Draft 
 *    
 *    Deepalakshmi   |deepalakshmi.venkatesh@listertechnologies.com  |29.03.2010 |Second Draft
 *    Update Records only if India Surgical Profiles
 *
 *    Sourav Mitra   |sourav.mitra@listertechnologies.com            |31.08.2010 |Third Draft
 *    Update Records for China Surgical Profiles too
 
 	  Vijay Singh	 |vijay.singh@aequor.com						 |05.04.2012   |Fouth Draft	
 	  Removed All filter 	
 */
 
 trigger contact_AI_ChangeOwner on Contact (before insert, before Update) 
 {    
    Set<Id> set_AccountId = new Set<Id>();
    for(Contact c:Trigger.new){
    	if(c.AccountId != null)	
        set_AccountId.add(c.AccountId);
    }
    
    if(!set_AccountId.isEmpty()){
    	Map<Id, Id> map_AccountId_OwnerId = new Map<Id, Id>();
	    for (Account a : [Select Id, OwnerId from Account where Id in :set_AccountId]){
	        map_AccountId_OwnerId.put(a.Id, a.OwnerId);
	    }

	    for (Contact c : Trigger.new){
	            if (map_AccountId_OwnerId.containskey(c.AccountId)) {
	                c.OwnerId = map_AccountId_OwnerId.get(c.AccountId);
	            }
	    }
    }    
}