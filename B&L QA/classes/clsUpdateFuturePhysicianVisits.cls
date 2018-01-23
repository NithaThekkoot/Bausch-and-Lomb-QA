public class clsUpdateFuturePhysicianVisits
{
    /*
    * 
    * This Class is for updating future Physician Visit Records whenever an update/insert happens on Physician Visit
    * 
    * Author                        |Author-Email                                      |Date        |Comment
    * ------------------------------|------------------------------------------------- |------------|----------------------------------------------------
    * DeepaLakshmi.R                |deepalakshmi.venkatesh@listertechnologies.com     |30.04.2010  |First Draft
    * Sanjib Mahanta                |sanjib.mahanta@bausch.com                         |21.05.2012  |Updated the class to handle Duplicate Id Exception.
    * Sridhar Aluru                 |sridhar.aluru@bausch.com                          |28.08.2015  |Add 2 Fields-Active User, Lens Usage for the Week (for India Users).
    */
    
    /*************************************************************************
    * Variables and Properties
    *************************************************************************/
    // Sanjib Mahanta  -21-May-12- --Start----------
    // Commented the List variable and updated the same with set data type.
    //List<Id> list_PhysicianID = new List<Id>();//List of Physician Ids for the INDSU RecordType 
    //List<Id> list_Id = new List<Id>();
    Set<Id> set_PhysicianID = new Set<Id>();
    Set<Id> set_Id = new Set<Id>();
    Set<Physician_Visit__c> PhysicianVisitsToUpdate = new Set<Physician_Visit__c>();
    List<Physician_Visit__c> PhysicianVisitsToUpdate1 = new List<Physician_Visit__c>();
    
    // Sanjib Mahanta  -21-May-12- --End----------
    
    Map<Id,String> map_RecordType = new Map<Id,String>();//Map of recordType Id and Name
    Map<Integer,String> map_Months = new Map<Integer,String>();//Map of Month in number and in 'MMM' format 
    Map<Id,Date> map_PhysicianIdVisitDate = new Map<Id,Date>();//Map of Physician Id and Visit Date
    Map<Id,List<Physician_Visit__c>> map_PhysicianAndVisits = new Map<Id,List<Physician_Visit__c>>();
    
    /**************************************************************************************************
    * Method to update visits. Whenever a visit is updated, the future visits corresponding 
    * to the same physician and same month are updated. Insert happens only for Unplanned visits
    ***************************************************************************************************/
    public void updateFuturePhysicianVisits(List<Physician_Visit__c> list_PhysicianVisits, String strAction)
    {
        //Get the RecordTypes in the map for INDSU Physician Visit Sales
        for(RecordType rt : [Select Id, Name from RecordType where (Name = 'INDSU Sales Planned' or Name = 'INDSU Sales Unplanned') and sObjectType = 'Physician_Visit__c'])
        {
            map_RecordType.put(rt.Id,rt.Name);
        }
        
        //Create a map of Months in Integer and 'MMM' format
        for(integer i=0;i<12;i++)
        {
            DateTime dtMonth = dateTime.newInstance(2010,1,1);
            map_Months.put(i+1,dtMonth.addmonths(i).format('MMM'));
        }
        System.debug('List Visit::= '+list_PhysicianVisits); 
        System.debug('Action : ==='+strAction);   
        for(Physician_Visit__c pv : list_PhysicianVisits)
        {
            //Get the Physician Ids in a list
            if(strAction == 'update')
            {
                if((map_RecordType.get(pv.RecordTypeId) == 'INDSU Sales Planned') || (map_RecordType.get(pv.RecordTypeId) == 'INDSU Sales Unplanned'))
                {
                    set_PhysicianID.add(pv.Physician__c);
                    map_PhysicianIdVisitDate.put(pv.Physician__c,pv.Activity_Date__c);
                    set_Id.add(pv.Id); 
                }
            }
            else
            {
                if(map_RecordType.get(pv.RecordTypeId) == 'INDSU Sales Unplanned')
                {
                    set_PhysicianID.add(pv.Physician__c);
                    map_PhysicianIdVisitDate.put(pv.Physician__c,pv.Activity_Date__c);
                    set_Id.add(pv.Id); 
                }
            }
        }
        
        if(strAction == 'Update')
        {
            for(Physician_Visit__c pv : [Select Id, Name, Activity_Date__c, Physician__c,Active_User_IND__c,Lens_usage_for_the_Week_IND__c,
            Imported_Foldable_Implant__c, Akreos_MIL__c, Akreos_AO__c, Akreos__c, 
            LI61_AO__c, LI61_SE__c, LI61AOV__c, Crystalens__c, AMO__c, Hanitta__c, 
            Acrysof_Single_piece__c, Acrysof_3_piece__c, Acrysof_IQ__c, Rayner__c, 
            Sensar__c, Tecnis_Acrylic__c, Zeiss__c, Others__c
            from Physician_Visit__c where Physician__c in :set_PhysicianID and Id not in :set_Id 
            order by Physician__c, Activity_Date__c])
            {       
                if(map_PhysicianIdVisitDate.get(pv.Physician__c) != null)
                {
                    Date dtVisitDate = map_PhysicianIdVisitDate.get(pv.Physician__c);               
                    
                    if(pv.Activity_Date__c > dtVisitDate && pv.Activity_Date__c.month() == dtVisitDate.month() && pv.Activity_Date__c.year() == dtVisitDate.year()) 
                    {
                        if(map_PhysicianAndVisits.get(pv.Physician__c) == null)
                        {
                            map_PhysicianAndVisits.put(pv.Physician__c, new List<Physician_Visit__c>());  map_PhysicianAndVisits.get(pv.Physician__c).add(pv);
                        }
                        else
                            map_PhysicianAndVisits.get(pv.Physician__c).add(pv);
                    }                               
                }
            }
        }
        else
        {
            for(Physician_Visit__c pv : [Select Id, Name, Activity_Date__c, Physician__c,Active_User_IND__c,Lens_usage_for_the_Week_IND__c,
            Imported_Foldable_Implant__c, Akreos_MIL__c, Akreos_AO__c, Akreos__c, 
            LI61_AO__c, LI61_SE__c, LI61AOV__c, Crystalens__c, AMO__c, Hanitta__c, 
            Acrysof_Single_piece__c, Acrysof_3_piece__c, Acrysof_IQ__c, Rayner__c, 
            Sensar__c, Tecnis_Acrylic__c, Zeiss__c, Others__c
            from Physician_Visit__c where Physician__c in :set_PhysicianID and Id not in :set_Id 
            order by Physician__c, Activity_Date__c desc])
            {       
                if(map_PhysicianIdVisitDate.get(pv.Physician__c) != null)
                {
                    Date dtVisitDate = map_PhysicianIdVisitDate.get(pv.Physician__c);               
                    
                    if(pv.Activity_Date__c < dtVisitDate && pv.Activity_Date__c.month() == dtVisitDate.month() && pv.Activity_Date__c.year() == dtVisitDate.year()) 
                    {
                        if(map_PhysicianAndVisits.get(pv.Physician__c) == null)
                        {
                            map_PhysicianAndVisits.put(pv.Physician__c, new List<Physician_Visit__c>());
                            map_PhysicianAndVisits.get(pv.Physician__c).add(pv);
                        }                       
                    }                               
                }
            }
        }
            
        for(Physician_Visit__c pv : list_PhysicianVisits)
        {
            if((strAction == 'update' && ((map_RecordType.get(pv.RecordTypeId) == 'INDSU Sales Planned') || (map_RecordType.get(pv.RecordTypeId) == 'INDSU Sales Unplanned'))))
            {
                if(map_PhysicianAndVisits.get(pv.Physician__c) != null)
                {
                    List<Physician_Visit__c> list_visit = new List<Physician_Visit__c>();     Set<Physician_Visit__c> set_visitId = new Set<Physician_Visit__c>();
                    list_visit = map_PhysicianAndVisits.get(pv.Physician__c);   set_visitId.addAll(list_visit);
                    System.debug('List of Visit:=='+list_visit);
                    System.debug('List of Visit:=='+set_visitId);
                    for(Physician_Visit__c visit : set_visitId)
                    {
                        Physician_Visit__c oPhyVisit = new Physician_Visit__c(Id = visit.Id);     oPhyVisit.Imported_Foldable_Implant__c = pv.Imported_Foldable_Implant__c;
                        oPhyVisit.Akreos_MIL__c = pv.Akreos_MIL__c;  oPhyVisit.Akreos_AO__c = pv.Akreos_AO__c;  oPhyVisit.Akreos__c = pv.Akreos__c;  oPhyVisit.LI61_AO__c = pv.LI61_AO__c;
                        oPhyVisit.LI61_SE__c = pv.LI61_SE__c;        oPhyVisit.LI61AOV__c = pv.LI61AOV__c;      oPhyVisit.Crystalens__c = pv.Crystalens__c; oPhyVisit.AMO__c = pv.AMO__c;
                        oPhyVisit.Hanitta__c = pv.Hanitta__c;        oPhyVisit.Acrysof_Single_piece__c = pv.Acrysof_Single_piece__c;  oPhyVisit.Acrysof_3_piece__c = pv.Acrysof_3_piece__c;       oPhyVisit.Acrysof_IQ__c = pv.Acrysof_IQ__c;      oPhyVisit.Rayner__c = pv.Rayner__c;
                        oPhyVisit.Sensar__c = pv.Sensar__c;          oPhyVisit.Tecnis_Acrylic__c = pv.Tecnis_Acrylic__c;  oPhyVisit.Zeiss__c = pv.Zeiss__c;  oPhyVisit.Others__c = pv.Others__c; 
                        PhysicianVisitsToUpdate.add(oPhyVisit);
                        System.debug('Test=== '+PhysicianVisitsToUpdate);
                    }
                }
            }
            
            if(strAction == 'insert' && map_RecordType.get(pv.RecordTypeId) == 'INDSU Sales Unplanned')
            {
                if(map_PhysicianAndVisits.get(pv.Physician__c) != null)
                {
                    List<Physician_Visit__c> list_visit = new List<Physician_Visit__c>();
                    list_visit = map_PhysicianAndVisits.get(pv.Physician__c);
                    
                    for(Physician_Visit__c visit : list_visit)
                    {                       
                        Physician_Visit__c oPhyVisit = new Physician_Visit__c(Id = pv.Id);
                        oPhyVisit.Imported_Foldable_Implant__c = visit.Imported_Foldable_Implant__c;
                        oPhyVisit.Akreos_MIL__c = visit.Akreos_MIL__c;
                        oPhyVisit.Akreos_AO__c = visit.Akreos_AO__c;
                        oPhyVisit.Akreos__c = visit.Akreos__c;
                        oPhyVisit.LI61_AO__c = visit.LI61_AO__c;
                        oPhyVisit.LI61_SE__c = visit.LI61_SE__c;
                        oPhyVisit.LI61AOV__c = visit.LI61AOV__c;
                        oPhyVisit.Crystalens__c = visit.Crystalens__c;
                        oPhyVisit.AMO__c = visit.AMO__c;
                        oPhyVisit.Hanitta__c = visit.Hanitta__c;
                        oPhyVisit.Acrysof_Single_piece__c = visit.Acrysof_Single_piece__c;
                        oPhyVisit.Acrysof_3_piece__c = visit.Acrysof_3_piece__c;
                        oPhyVisit.Acrysof_IQ__c = visit.Acrysof_IQ__c;
                        oPhyVisit.Rayner__c = visit.Rayner__c;
                        oPhyVisit.Sensar__c = visit.Sensar__c;
                        oPhyVisit.Tecnis_Acrylic__c = visit.Tecnis_Acrylic__c;
                        oPhyVisit.Zeiss__c = visit.Zeiss__c;
                        oPhyVisit.Others__c = visit.Others__c;     
                       
                       //START  -  Code added by SRIDHAR ALURU
                       oPhyVisit.Active_User_IND__c = visit.Active_User_IND__c;
                       oPhyVisit.Lens_usage_for_the_Week_IND__c = visit.Lens_usage_for_the_Week_IND__c;
                       //END    -  Code added by SRIDHAR ALURU
                       
                        PhysicianVisitsToUpdate.add(oPhyVisit);
                        
                    }
                }
            }
        }
            
        if(PhysicianVisitsToUpdate.size() > 0){
            System.debug('Physician list to be updated: '+PhysicianVisitsToUpdate);
            PhysicianVisitsToUpdate1.addAll(PhysicianVisitsToUpdate);
           // update PhysicianVisitsToUpdate1;
        }
    }
}