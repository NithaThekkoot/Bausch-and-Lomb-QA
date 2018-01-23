trigger event_AU_setJtCallPhysicianVisit on Event (after Update) {

    /**
    * 
    * This trigger creates new event for the Manager in the event of a Joint call. It also updates the physician visit as a Joint call    
    * 
    * Author              |Author-Email                       |Date        |Comment
    * --------------------|---------------------------------- |------------|----------------------------------------------------
    * Arun David          |arun.david@listertechnologies.com  |10.03.2010  |First Draft
    * 
    */

    /*************************************************************************
    * Variables and Properties
    *************************************************************************/

    recordType[] oRecType = [select Id from recordType where sobjecttype = 'Event' and Name = 'INDSU'];
    
    list<Physician_Visit__c> list_phyVisitToUpdate = new list<Physician_Visit__c>();
    list<Event> list_ManagerEventToCreate = new list<Event>();
    set<Id> set_RepIds = new set<Id>();
    set<Id> set_VisitIds = new set<Id>();
    map<Id,Id> map_userManager = new map<Id,Id>();
    
    if(oRecType.size()>0)
    {
        for(event e: Trigger.new)
        {
            //We need to create manager events if the sales/service rep events are marked as joint call
            if(e.RecordTypeId == oRecType[0].Id && e.Join_Call__c == true && trigger.oldMap.get(e.Id).Join_Call__c == false)
            {
                Event oNewEvent = e.Clone(false, true);
                set_RepIds.add(e.ownerId);
                set_VisitIds.add(e.Physician_Visit_Id__c);
                list_ManagerEventToCreate.add(oNewEvent);
            }
        }
        
        //Insert events for managers
        //Identify the manager value for the reps and assign as the owner for the new event    
        if(list_ManagerEventToCreate.size()>0)
        {
            for(User u: [select Id, ManagerId from user where id in :set_RepIds])
                map_userManager.put(u.Id, u.ManagerId);
                
            for(Event e: list_ManagerEventToCreate)
            {
                e.OwnerId = map_userManager.get(e.OwnerId);
            }
            
            insert list_ManagerEventToCreate;
        
        }

        if(set_VisitIds.size()>0)
        {
            for(Physician_Visit__c p : [select Joint_Call_With_ASM__c from Physician_Visit__c where id in :set_VisitIds])
            {
                p.Joint_Call_With_ASM__c = true;
                list_phyVisitToUpdate.add(p);
            }
        }

        if(list_phyVisitToUpdate.size()>0)
            update list_phyVisitToUpdate;
            
    }
    
}