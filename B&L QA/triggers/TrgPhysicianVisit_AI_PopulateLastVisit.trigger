/*
    * 
    * This trigger populates the previous physician visit for the physician in physician visit
    * 
    * Author                        |Author-Email                                      |Date        |Comment
    * ------------------------------|------------------------------------------------- |------------|----------------------------------------------------
    * Sourav Mitra                  |sourav.mitra@listertechnologies.com               |08.09.2010  |First Draft
    * Saranya Sivakumar             |saranya.sivakumar@listertechnologies.com          |01.11.2010  |Added Booleans to restrict recursive firing of triggers
    * Rajesh Sriramulu               |rajesh.sriramulu@rishabhsoft.com                 |11.09.2012  |Added Open to Status 
    *Venkateswara Reddy             |venkateswara.reddy2@bausch.com                    |25.11.2015  |Added code for checking if user is KOR SOLTA or not.
    */
trigger TrgPhysicianVisit_AI_PopulateLastVisit on Physician_Visit__c (after insert,after update) 
{
    Set<Id> set_physicianVisitIds = new Set<Id>();
    Set<Id> set_physicianIds = new Set<Id>();
    Map<Id,Contact> map_physicians = new Map<Id,Contact>();
    List<Physician_Visit__c> list_visitsToUpdate = new List<Physician_Visit__c>();
    Map<Id,Integer> map_physicianId_countOfVisits = new Map<Id,Integer>();
    Integer intMaxCount = 0;
    Date datLastVisit; 
    clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk  = False;  
    
    //check if user is other than KOREA SOLTA or not
  //list<UserRole> lstroleName=[SELECT Id, Name FROM UserRole WHERE Id =: UserInfo.getUserRoleId() LIMIT 1];  
    string lstroleName = UserInfo.getLocale();
    if(!lstroleName.contains('ko_KR')){   
    
    if(!clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk)
    {
            System.debug('Trigger.isInsert:'+Trigger.isInsert);
        // insert case : Bulk needs to be handled
        if(Trigger.isInsert)
        {
             
             System.debug('Trigger.new[0].Activity_Date__c:'+Trigger.new[0].Activity_Date__c);
            if(Trigger.new[0].Activity_Date__c != null)
            
                datLastVisit = Trigger.new[0].Activity_Date__c;
                
            
            for(Physician_Visit__c objVisit : Trigger.new)
            {              
              System.debug('objVisit:'+objVisit);
               System.debug('objVisit.Last_Activity__c:'+objVisit.Last_Activity__c+objVisit.Physician__c);
                if(objVisit.Last_Activity__c == null && objVisit.Physician__c != null)
                {
                
                    set_physicianIds.add(objVisit.Physician__c);
                    set_physicianVisitIds.add(objVisit.Id);
                    System.debug('set_physicianVisitIds:'+set_physicianVisitIds+objVisit.Physician__c);
                    if(map_physicianId_countOfVisits.containsKey(objVisit.Physician__c))                  
                        map_physicianId_countOfVisits.put(objVisit.Physician__c,map_physicianId_countOfVisits.get(objVisit.Physician__c) + 1);
                        
                    else
                        map_physicianId_countOfVisits.put(objVisit.Physician__c,1);
                        
                     System.debug('objVisit.Activity_Date__c:'+objVisit.Activity_Date__c+objVisit.Activity_Date__c + datLastVisit);   
                    if(objVisit.Activity_Date__c != null && objVisit.Activity_Date__c > datLastVisit)
                    {
                        datLastVisit = objVisit.Activity_Date__c;
                        System.debug('datLastVisit :'+datLastVisit);
                    }   
                }
            }
            for(Integer intCount : map_physicianId_countOfVisits.values())
            {
                System.debug('intCount :'+intCount + intMaxCount);
                if(intCount > intMaxCount)
                    intMaxCount = intCount;
            }
        
            
            if(set_physicianVisitIds.size() > 0)
            {
                System.debug('set_physicianVisitIds.size:'+set_physicianVisitIds.size());
                System.debug('Activity_Date__c:'+datLastVisit);
                
                
                map_physicians = new Map<Id,Contact>([SELECT Id,
                                        (SELECT Id,Activity_Date__c,Status__c FROM Physician_Visit__r WHERE Activity_Date__c <= :datLastVisit AND Activity_Date__c != null 
                                        AND (Status__c = 'Completed' OR Id IN :set_physicianVisitIds) ORDER BY Activity_Date__c DESC ) //LIMIT :(intMaxCount +1)) 
                                   FROM Contact WHERE Id IN :set_physicianIds]);
                                    System.debug('map_physicians :'+map_physicians);
                
                for(Physician_Visit__c objVisit : [SELECT Id,Physician__c,Status__c FROM Physician_Visit__c WHERE Id IN :set_physicianVisitIds])
                {
                     
                     System.Debug('<<<<<<<<<<<< objPhysician = ' + objVisit);
                    if(objVisit.Physician__c != null && map_physicians.containsKey(objVisit.Physician__c))
                    {   
                        /*
                        if(map_physicians.get(objVisit.Physician__c).Physician_Visit__r.size() == 2)
                        {
                            Contact objPhysician = map_physicians.get(objVisit.Physician__c);
                            // if the iterator physician visit is the most recent one then the second most recent is the last activity
                            if(objPhysician.Physician_Visit__r[0].Id == objVisit.Id)
                            {
                                objVisit.
                            }
                        }
                        */
                        Integer iterator = 0;
                        Boolean blnBreakFlag = false;
                        Contact objPhysician = map_physicians.get(objVisit.Physician__c);
                        System.Debug('<<<<<<<<<<<< objPhysician = ' + objPhysician);
                        for(Physician_Visit__c  objVisitInner: objPhysician.Physician_Visit__r)
                        {
                            System.debug('objVisit.Id:'+objVisit.Id+objVisitInner.Id);
                            if(objVisit.Id == objVisitInner.Id)
                            {
                                 System.debug('objVisit.Id:'+objVisit.Id+objVisitInner.Id);
                                  System.debug('objPhysician.Physician_Visit__r.size():'+objPhysician.Physician_Visit__r.size());
                                for(Integer j=iterator + 1; j < objPhysician.Physician_Visit__r.size() ; j++)
                                {
                                     System.debug('objVisit.Id:'+objVisit.Id+objVisitInner.Id);
                                     System.debug('objPhysician.Physician_Visit__r[j].Status__c:'+objPhysician.Physician_Visit__r[j].Status__c);
                                    if(objPhysician.Physician_Visit__r[j].Status__c == 'Completed')
                                    {                                        
                                        objVisit.Last_Activity__c = objPhysician.Physician_Visit__r[j].Id;
                                       
                                        System.debug('obj_VIsit111===='+objVisit);
                                        list_visitsToUpdate.add(objVisit);
                                        blnBreakFlag = true;
                                        break;
                                    }
                                }
                            }
                            
                            if(blnBreakFlag)
                                break;
                                
                            iterator++;
                        }
                    }
                }
                
                if(list_visitsToUpdate.size() > 0){
                   System.debug('list_visitsToUpdate_size'+list_visitsToUpdate.size()); 
                   System.debug('list_visitsToUpdate'+list_visitsToUpdate);
                    Update list_visitsToUpdate;}
            }
        }
        
        // update case : handling single record
        else
        {System.debug('clsPhysicianVisitUpdate.blnhasTriggerFired && Trigger.new.size()=='+clsPhysicianVisitUpdate.blnhasTriggerFired + Trigger.new.size());
            if(!clsPhysicianVisitUpdate.blnhasTriggerFired && Trigger.new.size() == 1)
            {
                System.debug('Trigger.new_0 :'+Trigger.new[0]);
                Physician_Visit__c objPhysicianVisit = Trigger.new[0];
                //Added by Rajesh Sriramulu
                System.debug('Trigger.old_0 :'+Trigger.old[0]);
                System.debug('objPhysicianVisit.Status__c:'+objPhysicianVisit.Status__c+Trigger.old[0].Status__c);
                if(objPhysicianVisit.Status__c == 'Open'&& Trigger.old[0].Status__c != 'Open')
                {
                    System.debug('objPhysicianVisit.Status__c:'+objPhysicianVisit.Status__c+Trigger.old[0].Status__c);
                    list_visitsToUpdate = [SELECT Id FROM Physician_Visit__c WHERE Activity_Date__c > :objPhysicianVisit.Activity_Date__c AND Physician__c = :objPhysicianVisit.Physician__c];
                    for(Physician_Visit__c objPhyVisitLoopVar : list_visitsToUpdate)
                    {
                        objPhyVisitLoopVar.Last_Activity__c = objPhysicianVisit.Id;
                      
                    }
                    if(list_visitsToUpdate.size() > 0)
                    {   System.debug('List Of Visit to Update:=='+list_visitsToUpdate);
                        update list_visitsToUpdate;
                    }  
                     
                    clsPhysicianVisitUpdate.blnhasTriggerFired = true;
                }
                
            }
        }
    }
    
  }//!KOR
  else{
  
 system.debug('Trigger Name:TrgPhysicianVisit_AI_PopulateLastVisit---------> No Need fro KOR SOLTA USers');
  }
    
}//trigger