trigger PhysicianVisit_AI_UpdateUnplannedCall on Physician_Visit__c (after Insert) 
{
    /*
    * 
    * This trigger to update Physician Visit Records whenever an insert happens on Physician Visit
    * 
    * Author                        |Author-Email                                      |Date        |Comment
    * ------------------------------|------------------------------------------------- |------------|----------------------------------------------------
    * DeepaLakshmi.R                |deepalakshmi.venkatesh@listertechnologies.com     |30.04.2010  |First Draft
    *
    */
 //check if user is other than KOREA SOLTA or not
 //list<UserRole> lstroleName=[SELECT Id, Name FROM UserRole WHERE Id =: UserInfo.getUserRoleId() LIMIT 1];  
   string lstroleName = UserInfo.getLocale();
    if(!lstroleName.contains('ko_KR')){ 
       if(Trigger.isInsert)
       {  
           try
           {
              if(clsPhysicianVisitUpdate.isInsert == false)
              {
                clsPhysicianVisitUpdate.isInsert =  true;
                clsUpdateFuturePhysicianVisits oclsUpdateFuturePhysicianVisits = new clsUpdateFuturePhysicianVisits();
                oclsUpdateFuturePhysicianVisits.updateFuturePhysicianVisits(trigger.new,'insert');
            
              }
        }
        catch(Exception e)
        {    Trigger.New[0].addError('Error occurred in Updating future Physician Visits - ' + e);
        }
    } 
 }//!KOR USER
 
 else{
 
 system.debug('Trigger Name:PhysicianVisit_AI_UpdateUnplannedCall------> NO Need for KOR SOLTA Users');
    }  
}