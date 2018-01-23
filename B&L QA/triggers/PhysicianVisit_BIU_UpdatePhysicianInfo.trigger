/**
* 
*   This trigger creates Physician Info record the first time a Physician Visit is created and populates the Rate and Stick fields. 
*   These fields are updated on subsequent visits.
*   Also, the Rate fields are prepopulated in the Physician Visit records if the Physician Info record for that Physician Visit record exists.
*
*   Author            |Author-Email                                   |Date       |Comment
*   ---------------   |-----------------------------------------------|-----------|--------------------------------------------------------------------------- 
*   Saranya Sivakumar |saranya.sivakumar@listertechnologies.com       |18.10.2010 |First Draft
*   Saranya Sivakumar    |saranya.sivakumar@listertechnologies.com    |01.11.2010  |Added Booleans to restrict recursive firing of triggers
*   Sanjib Mahanta    |sanjib.mahanta@bausch.com                      |21.11.2011 |updated the aggregate query so that it will returns limited records.  
*   Sanjib Mahanta    |sanjib.mahanta@bausch                          |29.05.2012 |Updated to make store visit Completed.   
*   Rajesh Sriramulu  |rajesh.sriramulu@rishabhsoft.com               |23.04.2012 |Added to make Status is Completed when ever Sales Rep update
*   Gordon Gao        |Gordon.gao@ibreakingpoint.com                  |07.08.2012 |Added Record Type limit,so that the trigger won't fire when the record type is CHNSU Service     
*   Venkateswara Reddy|venkateswara.reddy2@bausch.com                 |24.11.2015 |Added code for checking if User is KOR SOLTA or not.      
*/
 
trigger PhysicianVisit_BIU_UpdatePhysicianInfo on Physician_Visit__c(before insert, before update)
{
//check if user is other than KOREA SOLTA or not
  //list<UserRole> lstroleName=[SELECT Id, Name FROM UserRole WHERE Id =: UserInfo.getUserRoleId() LIMIT 1];  
    String lstroleName = String.valueof(UserInfo.getTimeZone().getID());
    system.debug('User Timezone'+lstroleName);
  // string lstroleName = UserInfo.getLocale();
    if(!lstroleName.contains('Asia/Seoul')){ 


 IF(trigger.isBefore) { 
  List<String> list_PhyVisitId = new List<String>();
  List<String> list_PhysicianId = new List<String>();
  List<Contact_Profile__c> listContactProfile = new List<Contact_Profile__c>();   
  List<Physician_Info__c> list_PhyInfoToInsert = new List<Physician_Info__c>();
  List<Physician_Info__c> list_PhyInfoToUpdate = new List<Physician_Info__c>();
  Map<String,Physician_Info__c> map_PhyId_PhyInfo = new Map<String,Physician_Info__c>();  
  Map<String,Contact> map_PhyId_Physician = new Map<String,Contact>();
  Map<String,Physician_Visit__c> map_Contact_LatestPhyVisit = new Map<String,Physician_Visit__c>();
  
  //add by gordon 2012-8-7   
  List<RecordType> T1List=[select Id, name from RecordType Where SobjectType='Physician_Visit__c' and name in ('APACSU Service Engineer', 'APACSU Technical Service')];
  
  Map<String, Id> idMap = new Map<String, Id>();
  
  Set<ID> idSet = new Set<ID>();
  
  For(RecordType idItem : T1List) {
      idMap.put(idItem.Name, idItem.Id);
      idSet.add(idItem.Id);
  }
  
  Id SerEngineerTypeId = idMap.get('APACSU Service Engineer');
  Id TechnicalSerTypeId = idMap.get('APACSU Technical Service');
  
  //system.debug('Service Engineer Type ID:'+SerEngineerTypeId);
  //system.debug('Technical Service Type ID:'+TechnicalSerTypeId);
  for(Physician_Visit__c objPhyVisit : Trigger.new)
  {       
    
   if(!(idSet.contains(objPhyVisit.RecordTypeId)))//add by gordon 2012-8-7  
   {        
     list_PhyVisitId.add(objPhyVisit.Id);        
     list_PhysicianId.add(objPhyVisit.Physician__c);   
   }
  }
  
        
     
  List<Contact_Profile__c> cpList = [select Id,Contact__c, Doctor_Segmentation__c from Contact_Profile__c where Contact__c in : list_PhysicianId];
  for(Physician_Visit__c objPhyVisit : trigger.new){
   for(Contact_Profile__c cp: cpList){
    if(cp.Contact__c==objPhyVisit.Physician__c){
     objPhyVisit.Doctor_Segmentation__c = cp.Doctor_Segmentation__c;
    }
   }   
  }
  system.debug('tttttttttttttt-----'+list_PhysicianId.size());
    
  if(!clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk)
  {
     
   for(Physician_Info__c objTemp : [SELECT Id, 
             Name, 
             Physician_Visit__c,
             Contact__c,
             Acrysof_3_piece_rate__c,
             Acrysof_IQ_rate__c,
             Acrysof_Single_piece_rate__c,
             Sensar_rate__c,                         
             //Tecnis_Acr_rate__c,
             //Zeiss_acry_rate__c,
             Acrys_of_Toric_rate__c,
             Canon_Staar_Rate__c,
             Hoya_Rate__c,
             ReZoom_Rate__c,
             Tecnis_Multifocal_Rate__c,
             Tecnis_Rate__c,
             Acrys_of_ReStor_rate__c,
             Stock_Level_Akreos_Adapt__c,
             Stock_Level_Akreos_AO__c,
             Stock_Level_Akreos_MI_60__c,
             Stock_Level_LI61AO__c,
             Stock_Level_LI61SE__c,
             Stock_Level_Envista__c,
             Stock_Level_Crystalens__c,
             Other_Brand_Name__c,
             Other_Brands_Rate__c 
           FROM Physician_Info__c
           WHERE Contact__c in : list_PhysicianId])
   {
    map_PhyId_PhyInfo.put(objTemp.Contact__c,objTemp);
   }
   
   //Querying contact for the Physician Name - to be put in the Info record's Name fields
   for(Contact objContact : [SELECT Id,Name FROM Contact WHERE Id in : list_PhysicianId])
   {
    map_PhyId_Physician.put(objContact.Id,objContact);      
   }
   
   //Insert
   System.debug('TestIsInsert1==='+trigger.isInsert); 
   if(trigger.isInsert)
   {
      
    for(Physician_Visit__c objPhyVisit :Trigger.new)
    {
     objPhyVisit.Status__c = 'Open';
     system.debug('objPhyVisit>>>>>>:'+objPhyVisit);
     /* Mouse Comment
     if(objPhyVisit.Physician__c != null && objPhyVisit.Activity_Date__c != null)
     {
      objPhyVisit.Name = map_PhyId_Physician.get(objPhyVisit.Physician__c).Name + '-' + String.valueOf(objPhyVisit.Activity_Date__c);
     }
     */
     System.debug('TestIsInsert2==='+map_PhyId_PhyInfo.get(objPhyVisit.Physician__c));
     
       if(objPhyVisit.RecordTypeId!=SerEngineerTypeId)//add by gordon 2012-8-7  
        { 
       if(map_PhyId_PhyInfo.get(objPhyVisit.Physician__c)!=null)
       {
        System.debug('TestIsInsert3==='+map_PhyId_PhyInfo.get(objPhyVisit.Physician__c));
        //list_PhyInfoToUpdate.add(populatePhysicianInfoFields(objPhyVisit,map_PhyId_PhyInfo.get(objPhyVisit.Physician__c)));
        
        populatePhysicianVisitFields(objPhyVisit,map_PhyId_PhyInfo.get(objPhyVisit.Physician__c));
       }
       else
       {
        System.debug('TestIsInsert4==='+map_PhyId_PhyInfo.get(objPhyVisit.Physician__c));
        Physician_Info__c objPhyInfoToInsert = new Physician_Info__c();
        objPhyInfoToInsert.Contact__c = objPhyVisit.Physician__c;
        
        list_PhyInfoToInsert.add(populatePhysicianInfoFields(objPhyVisit,objPhyInfoToInsert));
       }
      }      
    }
   }
   
   //Update
   System.debug('trigger.isUpdate :' +trigger.isUpdate);
    
   if(trigger.isUpdate)
   { 
                
    //Map of Contact and the latest visit for the contact
      for(Contact objContactTemp: [SELECT Id, Name,
             (SELECT Id,
               Name,
               Activity_Date__c,
               Physician__c,
               Acrysof_3_piece_rate__c,
               Acrysof_IQ_rate__c,
               Acrysof_Single_piece_rate__c,
               Sensar_rate__c,
               Stock_Level_Akreos_Adapt__c,
               Stock_Level_Akreos_AO__c,
               Stock_Level_Akreos_MI_60__c,
               Stock_Level_LI61AO__c,
               Stock_Level_LI61SE__c,
               Stock_Level_Envista__c,
               Stock_Level_Crystalens__c,
               //Tecnis_Acr_rate__c,
               //Zeiss_acry_rate__c,
               Acrysof_Toric_Rate__c,
               Canon_Staar_Rate__c,
               Hoya_Rate__c,
               ReZoom_Rate__c,
               Tecnis_Multifocal_Rate__c,
               Tecnis_Rate__c,
               Acrysof_ReStor_rate__c,
               Other_Brand_Name__c,
               Other_Brands_Rate__c 
             FROM Physician_Visit__r where Activity_Date__c != null ORDER BY Activity_Date__c DESC limit 1)
           FROM Contact
           WHERE Id in : list_PhysicianId])
    {
     map_Contact_LatestPhyVisit.put(objContactTemp.Id,objContactTemp.Physician_Visit__r[0]);
     system.debug('map_Contact_LatestPhyVisit>>>'+map_Contact_LatestPhyVisit);
    }
    
    
    
   List <Profile>  prof=[select Name from profile where id = : userinfo.getProfileId()];
      
    
    
    for(Physician_Visit__c objPhyVisit : Trigger.New)
    {
    
     
     //objPhyVisit.Status__c = 'Completed';   
     system.debug('objPhyVisit>>>:'+objPhyVisit);
     if(map_Contact_LatestPhyVisit.containsKey(objPhyVisit.Physician__c))
     {
      system.debug('map_Contact_LatestPhyVisit.get(objPhyVisit.Physician__c)>>>'+map_Contact_LatestPhyVisit.get(objPhyVisit.Physician__c));
      
      //Newest of visits - update the info record
       
       if(objPhyVisit.Activity_Date__c >= map_Contact_LatestPhyVisit.get(objPhyVisit.Physician__c).Activity_Date__c)
       {
        system.debug('UPDATE BLOCK - Newest Visit');
        system.debug('objPhyVisit>>>'+objPhyVisit);
        system.debug('map_PhyId_PhyInfo.get(objPhyVisit.Physician__c)>>>'+map_PhyId_PhyInfo.get(objPhyVisit.Physician__c));
        if(populatePhysicianInfoFields(objPhyVisit,map_PhyId_PhyInfo.get(objPhyVisit.Physician__c))!=NULL)
         list_PhyInfoToUpdate.add(populatePhysicianInfoFields(objPhyVisit,map_PhyId_PhyInfo.get(objPhyVisit.Physician__c)));
       }
       
       //update on an old visit - copy rate fields alone from info to the visit record
       else
       {                   
        Physician_Info__c objPhyInfoToUpdateVisit = new Physician_Info__c();
        objPhyInfoToUpdateVisit = map_PhyId_PhyInfo.get(objPhyVisit.Physician__c);
        system.debug('UPDATE BLOCK - Old Visit');
        system.debug('objPhyVobjPhyInfoToUpdateVisitisit>>>'+objPhyInfoToUpdateVisit);
        
        populatePhysicianVisitFields(objPhyVisit,objPhyInfoToUpdateVisit);
        
       }
       
     }
    }
   }
   
   //Inserting the new Store Info records
   system.debug('list_PhyInfoToUpdate>>>'+list_PhyInfoToUpdate);
   if(list_PhyInfoToUpdate.size() > 0){
        //Modified to add List data to set for unique value by  Raviteja Kumar | 3-12-2013
        Set<Physician_Info__c> Set_Update_PhysicianInfo = new  Set<Physician_Info__c>();
        Set_Update_PhysicianInfo.addAll(list_PhyInfoToUpdate);
        list_PhyInfoToUpdate = new List<Physician_Info__c>(Set_Update_PhysicianInfo);
        update list_PhyInfoToUpdate;
    
   }
   
   //Updating the existing Store Info records  
   system.debug('list_PhyInfoToInsert>>>'+list_PhyInfoToInsert);   
   if(list_PhyInfoToInsert.size() > 0)
    insert list_PhyInfoToInsert;
  }
 }//if trigger isBefore
 }//!KOR
 else{
 
 system.debug('Trigger Name:PhysicianVisit_BIU_UpdatePhysicianInfo ------->No Nedd for KOR SOLTA USers');
 }
 
 
    //Method to populate the Info fields
    public Physician_Info__c populatePhysicianInfoFields(Physician_Visit__c objPhyVisitMthd, Physician_Info__c objPhyInfoMthd)
    {   
        if(objPhyInfoMthd!=NULL)
        {  
             /* Mouse Comment
            if(map_PhyId_Physician.containsKey(objPhyVisitMthd.Physician__c))
            {
                if(map_PhyId_Physician.get(objPhyVisitMthd.Physician__c) != NULL)
                    objPhyInfoMthd.Name = 'Physician Info - ' + map_PhyId_Physician.get(objPhyVisitMthd.Physician__c).Name;
            }
            else
                objPhyInfoMthd.Name = 'Physician Info - ';
            */
                
            objPhyInfoMthd.Physician_Visit__c = objPhyVisitMthd.Id;
            
            objPhyInfoMthd.Acrysof_3_piece_rate__c = objPhyVisitMthd.Acrysof_3_piece_rate__c;
            objPhyInfoMthd.Acrysof_IQ_rate__c = objPhyVisitMthd.Acrysof_IQ_rate__c;
            objPhyInfoMthd.Acrysof_Single_piece_rate__c = objPhyVisitMthd.Acrysof_Single_piece_rate__c;
            objPhyInfoMthd.Sensar_rate__c = objPhyVisitMthd.Sensar_rate__c;
            //objPhyInfoMthd.Tecnis_Acr_rate__c = objPhyVisitMthd.Tecnis_Acr_rate__c;
            //objPhyInfoMthd.Zeiss_acry_rate__c = objPhyVisitMthd.Zeiss_acry_rate__c;
            objPhyInfoMthd.Acrys_of_Toric_rate__c = objPhyVisitMthd.Acrysof_Toric_Rate__c;
            objPhyInfoMthd.Canon_Staar_Rate__c = objPhyVisitMthd.Canon_Staar_Rate__c;
            objPhyInfoMthd.Hoya_Rate__c = objPhyVisitMthd.Hoya_Rate__c;
            objPhyInfoMthd.ReZoom_Rate__c = objPhyVisitMthd.ReZoom_Rate__c;
            objPhyInfoMthd.Tecnis_Multifocal_Rate__c = objPhyVisitMthd.Tecnis_Multifocal_Rate__c;
            objPhyInfoMthd.Tecnis_Rate__c = objPhyVisitMthd.Tecnis_Rate__c;
            objPhyInfoMthd.Acrys_of_ReStor_rate__c = objPhyVisitMthd.Acrysof_ReStor_rate__c;
            objPhyInfoMthd.Other_Brand_Name__c = objPhyVisitMthd.Other_Brand_Name__c;
            objPhyInfoMthd.Other_Brands_Rate__c = objPhyVisitMthd.Other_Brands_Rate__c;           
            
            objPhyInfoMthd.Stock_Level_Akreos_Adapt__c = objPhyVisitMthd.Stock_Level_Akreos_Adapt__c;
            objPhyInfoMthd.Stock_Level_Akreos_AO__c = objPhyVisitMthd.Stock_Level_Akreos_AO__c;
            objPhyInfoMthd.Stock_Level_Akreos_MI_60__c = objPhyVisitMthd.Stock_Level_Akreos_MI_60__c;
            objPhyInfoMthd.Stock_Level_LI61AO__c = objPhyVisitMthd.Stock_Level_LI61AO__c;
            objPhyInfoMthd.Stock_Level_LI61SE__c = objPhyVisitMthd.Stock_Level_LI61SE__c;
            objPhyInfoMthd.Stock_Level_Envista__c = objPhyVisitMthd.Stock_Level_Envista__c;
            objPhyInfoMthd.Stock_Level_Crystalens__c = objPhyVisitMthd.Stock_Level_Crystalens__c;
            
        }    
        return objPhyInfoMthd;
    }
    
    //Method to populate the Visit fields
    public void populatePhysicianVisitFields(Physician_Visit__c objPhyVisitMthd, Physician_Info__c objPhyInfoMth)
    {
        //Update the Visit with fields from the Info record
        objPhyVisitMthd.Acrysof_3_piece_rate__c = objPhyInfoMth.Acrysof_3_piece_rate__c;
        objPhyVisitMthd.Acrysof_IQ_rate__c = objPhyInfoMth.Acrysof_IQ_rate__c;
        objPhyVisitMthd.Acrysof_Single_piece_rate__c = objPhyInfoMth.Acrysof_Single_piece_rate__c;
        objPhyVisitMthd.Sensar_rate__c = objPhyInfoMth.Sensar_rate__c;
        //objPhyVisitMthd.Tecnis_Acr_rate__c = objPhyInfoMth.Tecnis_Acr_rate__c;
        //objPhyVisitMthd.Zeiss_acry_rate__c = objPhyInfoMth.Zeiss_acry_rate__c;
        objPhyVisitMthd.Acrysof_Toric_Rate__c = objPhyInfoMth.Acrys_of_Toric_rate__c;
        objPhyVisitMthd.Canon_Staar_Rate__c = objPhyInfoMth.Canon_Staar_Rate__c;
        objPhyVisitMthd.Hoya_Rate__c = objPhyInfoMth.Hoya_Rate__c;
        objPhyVisitMthd.ReZoom_Rate__c = objPhyInfoMth.ReZoom_Rate__c;
        objPhyVisitMthd.Tecnis_Multifocal_Rate__c = objPhyInfoMth.Tecnis_Multifocal_Rate__c;
        objPhyVisitMthd.Tecnis_Rate__c = objPhyInfoMth.Tecnis_Rate__c;
        objPhyVisitMthd.Acrysof_ReStor_rate__c = objPhyInfoMth.Acrys_of_ReStor_rate__c;     
        objPhyVisitMthd.Other_Brand_Name__c = objPhyInfoMth.Other_Brand_Name__c;
        objPhyVisitMthd.Other_Brands_Rate__c = objPhyInfoMth.Other_Brands_Rate__c;
    }   
}//trigger