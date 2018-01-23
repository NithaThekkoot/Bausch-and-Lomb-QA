/*
    * 
    * This trigger inserts or updates Competitor Product whenever an update happens on Physician Visit
    * 
    * Author                        |Author-Email                                       |Date        |Comment
    * ------------------------------|---------------------------------------------------|------------|----------------------------------------------------
    * DeepaLakshmi.R                |deepalakshmi.venkatesh@listertechnologies.com      |29.04.2010  |First Draft
    * Sourav Mitra                  |sourav.mitra@listertechnologies.com                |01.09.2010  |Changes to incorporate China
    * Harvin Vincent                |harvin.vincent@listertechnologies.com              |06.09.2010  |Changes to include Products
    * Harvin Vincent                |harvin.vincent@listertechnologies.com              |06.10.2010  |To prevent too many queries error
    * Saranya Sivakumar             |saranya.sivakumar@listertechnologies.com           |01.11.2010  |Added Booleans to restrict recursive firing of triggers
    * Vidhyashankar Lakshmanan      |vidhyashankar.lakshmanan@listertechnologies.com    |24.06.2011  |Prevents exception due to multiple visits for same Physician
    * Sanjib Mahanta                |sanjib.mahanta@bausch.com                          |21.06.2012  |Updated the triggers to populate No. of OT Hours and Envista.
    * Rajesh Sriramulu              |rajesh.sriramulu@rishabhsoft.com                   |23.04.2012  |Added to make Status is Completed when ever Sales Rep update
    * Gordon Gao                    |Gordon.gao@ibreakingpoint.com                      |20.08.2012  |Added Technical Service Phsician Visit Condition
    * Raviteja Vakity               |raviteja.vakity@bausch.com                         |08.Nov.2012 |Updated the trigger to populate Expiry Date and Bundling Competitor and create the Task based on Expiry Date.
    * Raviteja Vakity               |raviteja.vakity@bausch.com                         |31.Dec.2012 |Resloving the Run Test issue by using isRunningTest()
    * Rohit Kumar Verma             |rohit.verma@bausch.com                             |10.Jan.2013 |Resloved PhysicianVisit Status Issue 
    * Raviteja Vakity               |raviteja.vakity@bausch.com                         |26.Mar.2013 |Updated the trigger for CHNSU Engineer changes    
    * Neha Jain                     |neha.jain@bausch.com                               |18.Mar.2013 |Commented the isrunning test code in the class
    *Venkateswara Reddy             |venkateswara.reddy2@bausch.com                     |25.Nov.2015 |Added code for checking if the user is KOR SOLTA or Not.
*/
trigger PhysicianVisit_BU_UpdateCompetitorInformation on Physician_Visit__c (before Update) 
 {
    
    /*************************************************************************
    * Variables and Properties
    *************************************************************************/
    List<Id> list_PhysicianID = new List<Id>();//List of Physician Ids for the INDSU RecordType 
    List<Monthly_Implantation_Detail__c> list_CompProdToUpdate = new List<Monthly_Implantation_Detail__c>();//List of Competitor Products to Update
    List<Monthly_Implantation_Detail__c> list_CompProdToCreate = new List<Monthly_Implantation_Detail__c>();//List of Competitor Products to Create
    
    Map<Id,Date> map_PhysicianIdVisitDate = new Map<Id,Date>();//Map of Physician Id and Visit Date
    Map<Id,Monthly_Implantation_Detail__c> map_PhysicianProduct = new Map<Id, Monthly_Implantation_Detail__c>();//Map of Physician Id and Competitor Product
    Map<Id,String> map_RecordType = new Map<Id,String>();//Map of recordType Id and Name
    Map<Integer,String> map_Months = new Map<Integer,String>();//Map of Month in number and in 'MMM' format
    Map<Id, Monthly_Implantation_Detail__c> map_monthlyImplantDetails = new Map<Id, Monthly_Implantation_Detail__c>();  // Used instead of list_CompProdToUpdate;
                                                                                                                        // exception due to multiple visits
    
    Map<String,Id> map_recTypeNameToIdMonthly = new Map<String,Id>();
    Set<Id> set_idRecTypesMonthly = new Set<Id>();
    Static Boolean blnmidTask = false;
  
    Static String midindsurt = 'INDSU Task';
   
    RecordType midRecordType =  [SELECT Id, Name FROM RecordType  WHERE NAME =: midindsurt AND SObjectType =: 'Task'];
    System.debug('midRecordType: '+midRecordType );
    
    //clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk = false; //testing 
    system.debug('PhysicianVisit_BU_UpdateCompetitorInformation.trigger');
 //check if user is other than KOREA SOLTA or not
  //list<UserRole> lstroleName=[SELECT Id, Name FROM UserRole WHERE Id =: UserInfo.getUserRoleId() LIMIT 1];  
    string lstroleName = UserInfo.getLocale();
    if(!lstroleName.contains('ko_KR')){      

    
    if(!clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk)
    {
        system.debug('clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk');
        system.debug('clsPhysicianVisitUpdate.isUpdate' + clsPhysicianVisitUpdate.isUpdate);
        system.debug('clsPhysicianVisitUpdate.isInsert' + clsPhysicianVisitUpdate.isInsert);
        if(clsPhysicianVisitUpdate.isUpdate == false && clsPhysicianVisitUpdate.isInsert == false)
        {
            
            ClsPhysicanVisit.getPhysicanVisitRecordTypes();
            clsPhysicianVisitUpdate.isUpdate = true;
            
            if(Trigger.isUpdate)
            {     
            
              // Start of code by Rajesh Sriramulu on 11/05/2012 to update the status from open to completed 
              User objUser = [Select Id, Name, APAC_Country__c, APAC_Region__c, APAC_Area__c, UserRole.Name, Profile.Name From User Where Id=:Userinfo.getUserId()]; 
           for (Physician_Visit__c p:Trigger.new){
           system.debug('p.Status__c'+Trigger.OldMap.get(p.Id).Status__c +p.Status__c);             
            System.debug(' objUser: '+objUser);
            System.debug(' objUser role: '+objUser.UserRole.Name);
            // Start of code by Rajesh Sriramulu on 11/06/2012 added the roles of service rep and INDSU COS/
            if(objUser.UserRole.Name != null && (objUser.UserRole.Name.contains('Sales Rep') || objUser.UserRole.Name.contains('Service Rep') || objUser.UserRole.Name.contains('INDSU COS') || objUser.UserRole.Name.contains('Service Engineer') || objUser.UserRole.Name.equals('CHNSU Engineer')) && p.ownerid == objUser.id){// && p.Planned_call__c == True){//By: Rohit Kumar Verma On :1/8/2013
            // End of code by Rajesh Sriramulu on 11/06/2012 added the roles of service rep and INDSU COS     
                 System.debug('Status is going to update');
                 p.Status__c = 'Completed';
            }  
            else if(objUser.UserRole.Name != null && objUser.UserRole.Name.contains('Manager') && p.ownerid == objUser.id){
                 System.debug('Status is going to updated');
                 p.Status__c = 'Completed';
            }
            // Start of code by Jojo on 12/18/2012 CHNSU Service Engineer and rep will not trigge the status logic here
            else if(objUser.UserRole.Name != null && (objUser.UserRole.Name.contains('CHNSU Service Engineer') || objUser.UserRole.Name.contains('CHNSU Engineer') || objUser.UserRole.Name.contains('CHNSU Service Rep') || objUser.UserRole.Name.contains('CHNSU Engineer Manager'))) {
                p.Status__c = p.Status__c;
            }
            // End of code by Jojo on 12/18/2012 CHNSU Service Engineer and rep will not trigge the status logic here
            else {
                 p.Status__c = 'Open';
            }   
          } 
                // End of code by Rajesh Sriramulu on 11/05/2012 to update the status from open to completed   
              
                //Get the RecordTypes in the map for INDSU Physician Visit Sales
                for (String key : ClsPhysicanVisit.map_staticRecordType.keySet()) {
                    if (key == 'Physician_Visit__c-INDSU Sales Planned' || key == 'Physician_Visit__c-INDSU Sales Unplanned' 
                                || key == 'Physician_Visit__c-APACSU Sales Planned' || key == 'Physician_Visit__c-APACSU Sales Unplanned'
                                // Added by Shibin 2012/08/14 APACSU Technical Service
                                || key == 'Physician_Visit__c-APACSU Technical Service') {
                        map_RecordType.put(ClsPhysicanVisit.map_staticRecordType.get(key), key.substring((key.indexOf('-')) + 1));
    
                    }
                }
    
                /*for(RecordType rt : [Select Id, Name from RecordType 
                                            WHERE Name IN ('INDSU Sales Planned','INDSU Sales Unplanned','APACSU Sales Planned','APACSU Sales Unplanned') 
                                            AND sObjectType = 'Physician_Visit__c'])
                {
                    map_RecordType.put(rt.Id,rt.Name);
                }*/
                
                //Create a map of Months in Integer and 'MMM' format
                for(integer i=0;i<12;i++)
                {
                    DateTime dtMonth = dateTime.newInstance(2010,1,1);
                    map_Months.put(i+1,dtMonth.addmonths(i).format('MMM'));
                }
                
                //RecordType for Competitor Product
                List<RecordType> list_compRecordType = new List<RecordType>();
                for (String key : ClsPhysicanVisit.map_staticRecordType.keySet()) {
                    if (key == 'Monthly_Implantation_Detail__c-INDSU Monthly Implantation Detail' 
                            || key == 'Monthly_Implantation_Detail__c-APACSU Monthly Implantation Detail') {
                        set_idRecTypesMonthly.add(ClsPhysicanVisit.map_staticRecordType.get(key));
                        map_recTypeNameToIdMonthly.put(key.substring((key.indexOf('-')) + 1),ClsPhysicanVisit.map_staticRecordType.get(key));
                        list_compRecordType.add(ClsPhysicanVisit.map_staticRecordTypeObj.get(key));
                    }
                }
    
                /*List<RecordType> list_compRecordType = [Select Id, Name from RecordType where Name IN ('INDSU Monthly Implantation Detail','APACSU Monthly Implantation Detail')  
                                                        AND sObjectType = 'Monthly_Implantation_Detail__c'];
                
                for(RecordType rt : list_compRecordType)
                {
                    set_idRecTypesMonthly.add(rt.Id);
                    map_recTypeNameToIdMonthly.put(rt.Name,rt.Id);
                } */
                
                for(Physician_Visit__c pv : trigger.new)
                {
                    //Get the Physician Ids in a list
                    if((map_RecordType.get(pv.RecordTypeId) == 'INDSU Sales Planned') || (map_RecordType.get(pv.RecordTypeId) == 'INDSU Sales Unplanned') ||
                        (map_RecordType.get(pv.RecordTypeId) == 'APACSU Sales Planned') || (map_RecordType.get(pv.RecordTypeId) == 'APACSU Sales Unplanned')
                        // Added by Shibin 2012/08/14 APACSU Technical Service
                        || (map_RecordType.get(pv.RecordTypeId) == 'APACSU Technical Service'))
                    {
                        list_PhysicianID.add(pv.Physician__c);
                        map_PhysicianIdVisitDate.put(pv.Physician__c,pv.Activity_Date__c);
                    }
                }
                system.debug('&&&&&&&&list_PhysicianID:'+list_PhysicianID);
                system.debug('&&&&&&&&set_idRecTypesMonthly:'+set_idRecTypesMonthly);
                //Get the competitor products for those physicians in the list and them to the map
                for(Monthly_Implantation_Detail__c cp : [Select X1_8mm_B_L__c,X2_2mm_B_L__c,X2_8mm_B_L__c,X1_8mm_Others__c,X2_8mm_Others__c,X2_2mm_Others__c,X1_8mm_AMO__c,
                                                                X2_2mm_AMO__c,X2_8mm_AMO__c, X1_8mm_Alcon__c,X2_2mm_Alcon__c,X2_8mm_Alcon__c,X1_8mm_Zeiss__c,X2_2mm_Zeiss__c,
                                                                X2_8mm_Zeiss__c,X1_8mm_HumanOptics__c,X2_2mm_HumanOptics__c,X2_8mm_HumanOptics__c,Id, Name, Physician_Name__c, Month__c, Year__c, 
                                            Current_Total_Implantations__c, AKREOS_MIL__c, AKREOS_AO__c, AKREOS__c,Expiry_Date__c, Bundling_Competitor__c,
                                            LI61_AO__c, LI61_SE__c, LI61AOV__c, No_of_IOLs_AMO__c, No_of_IOLs_HANITTA__c, 
                                            No_of_IOLs_Acrysof_Single_piece__c, No_of_IOLs_Acrysof_3_piece__c, 
                                            No_of_IOLs_Acrysof_IQ__c, No_of_IOLs_Rayner__c, No_of_IOLs_Sensar__c, 
                                            No_of_IOLs_Tecnis_Acrylic__c, No_of_IOLs_ZEISS__c, No_of_IOLs_OTHERS__c,
                                            Akreos_MI_60__c,Akreos_Adapt__c,Acrysof_ReStor__c,Acrysof_Toric__c,ReZoom__c,
                                            Tecnis__c,Tecnis_Multifocal__c,Canon_Staar__c,Hoya__c,Envista__c,No_of_OT_Hours__c   
                                            FROM Monthly_Implantation_Detail__c where Physician_Name__c IN :list_PhysicianID and RecordTypeId IN :set_idRecTypesMonthly])
                {
                    if(map_PhysicianIdVisitDate.get(cp.Physician_Name__c) != null)
                    {
                        Date dtVistDate = map_PhysicianIdVisitDate.get(cp.Physician_Name__c);
                        if((cp.Month__c == map_Months.get(dtVistDate.month())) && (cp.Year__c == dtVistDate.year()))
                        {
                            map_PhysicianProduct.put(cp.Physician_Name__c, cp);
                        }
                    }
                }
                system.debug('Check  trigger inside'+map_PhysicianProduct);
                for(Physician_Visit__c pv : trigger.new)
                {
                       system.debug('^^^^^^^^^^^^^^^^^^^'+map_RecordType.get(pv.RecordTypeId)); 
                    if((map_RecordType.get(pv.RecordTypeId) == 'INDSU Sales Planned') || (map_RecordType.get(pv.RecordTypeId) == 'INDSU Sales Unplanned') ||
                        (map_RecordType.get(pv.RecordTypeId) == 'APACSU Sales Planned') || (map_RecordType.get(pv.RecordTypeId) == 'APACSU Sales Unplanned')
                        // Added by Shibin 2012/08/14 APACSU Technical Service
                        || (map_RecordType.get(pv.RecordTypeId) == 'APACSU Technical Service'))
                    {
                        //If Competitor Product already exists for the physician
                        system.debug('map_PhysicianProduct' + map_PhysicianProduct.get(pv.Physician__c));
                        if(map_PhysicianProduct.get(pv.Physician__c) != null)
                        {
                        
                            Monthly_Implantation_Detail__c oCompProduct = map_PhysicianProduct.get(pv.Physician__c);
                            
                            if(map_monthlyImplantDetails.containsKey(oCompProduct.Id))
                                oCompProduct = map_monthlyImplantDetails.get(oCompProduct.Id);
                            else
                                map_monthlyImplantDetails.put(oCompProduct.Id, oCompProduct);
                                
                            if ((map_RecordType.get(pv.RecordTypeId) == 'APACSU Sales Planned')||(map_RecordType.get(pv.RecordTypeId) == 'INDSU Sales Planned')) {
                                oCompProduct.Current_Total_Implantations__c = pv.Imported_Foldable_Implant__c;
                                oCompProduct.Bundling_Competitor__c=pv.Bundling_Competitor__c;
                                oCompProduct.Expiry_Date__c=pv.Expiry_Date__c;
                                system.debug('trigger.OldMap.get(pv.Id).Akreos_MIL__c'+trigger.OldMap.get(pv.Id).Akreos_MIL__c);
                                system.debug('trigger.OldMap.get(pv.Id).Akreos_MIL__c'+trigger.newMap.get(pv.Id).Akreos_MIL__c);
                                if (trigger.OldMap.get(pv.Id).Akreos_MIL__c != pv.Akreos_MIL__c) {                                                       
                                    oCompProduct.AKREOS_MIL__c = (oCompProduct.Akreos_MIL__c != null ? oCompProduct.Akreos_MIL__c : 0) - (trigger.OldMap.get(pv.Id).Akreos_MIL__c != null ? trigger.OldMap.get(pv.Id).Akreos_MIL__c : 0) ; 
                                    oCompProduct.AKREOS_MIL__c = oCompProduct.Akreos_MIL__c +  (pv.Akreos_MIL__c != null ? pv.Akreos_MIL__c : 0); 
                                } 
                                if (trigger.OldMap.get(pv.Id).AKREOS_AO__c!= pv.AKREOS_AO__c) {
                                    oCompProduct.AKREOS_AO__c= (oCompProduct.AKREOS_AO__c != null ? oCompProduct.AKREOS_AO__c: 0) - (trigger.OldMap.get(pv.Id).AKREOS_AO__c!= null ? trigger.OldMap.get(pv.Id).AKREOS_AO__c: 0) ; 
                                    oCompProduct.AKREOS_AO__c= oCompProduct.AKREOS_AO__c +  (pv.AKREOS_AO__c != null ? pv.AKREOS_AO__c: 0); 
                                }
                                if (trigger.OldMap.get(pv.Id).AKREOS__c!= pv.AKREOS__c) {
                                    oCompProduct.AKREOS__c= (oCompProduct.AKREOS__c != null ? oCompProduct.AKREOS__c: 0) - (trigger.OldMap.get(pv.Id).AKREOS__c!= null ? trigger.OldMap.get(pv.Id).AKREOS__c: 0) ; 
                                    oCompProduct.AKREOS__c= oCompProduct.AKREOS__c +  (pv.AKREOS__c != null ? pv.AKREOS__c: 0); 
                                }
                                if (trigger.OldMap.get(pv.Id).LI61_AO__c!= pv.LI61_AO__c) {
                                    oCompProduct.LI61_AO__c= (oCompProduct.LI61_AO__c != null ? oCompProduct.LI61_AO__c: 0) - (trigger.OldMap.get(pv.Id).LI61_AO__c!= null ? trigger.OldMap.get(pv.Id).LI61_AO__c: 0) ; 
                                    oCompProduct.LI61_AO__c= oCompProduct.LI61_AO__c +  (pv.LI61_AO__c != null ? pv.LI61_AO__c: 0); 
                                }
                                if (trigger.OldMap.get(pv.Id).LI61_SE__c!= pv.LI61_SE__c) {
                                    oCompProduct.LI61_SE__c= (oCompProduct.LI61_SE__c != null ? oCompProduct.LI61_SE__c: 0) - (trigger.OldMap.get(pv.Id).LI61_SE__c!= null ? trigger.OldMap.get(pv.Id).LI61_SE__c: 0) ; 
                                    oCompProduct.LI61_SE__c= oCompProduct.LI61_SE__c +  (pv.LI61_SE__c != null ? pv.LI61_SE__c: 0); 
                                }
                                if (trigger.OldMap.get(pv.Id).LI61AOV__c!= pv.LI61AOV__c) {
                                    oCompProduct.LI61AOV__c= (oCompProduct.LI61AOV__c != null ? oCompProduct.LI61AOV__c: 0) - (trigger.OldMap.get(pv.Id).LI61AOV__c!= null ? trigger.OldMap.get(pv.Id).LI61AOV__c: 0) ; 
                                    oCompProduct.LI61AOV__c= oCompProduct.LI61AOV__c +  (pv.LI61AOV__c != null ? pv.LI61AOV__c: 0); 
                                }
                                if (trigger.OldMap.get(pv.Id).Crystalens__c!= pv.Crystalens__c) {
                                    oCompProduct.Crystalens__c= (oCompProduct.Crystalens__c != null ? oCompProduct.Crystalens__c: 0) - (trigger.OldMap.get(pv.Id).Crystalens__c!= null ? trigger.OldMap.get(pv.Id).Crystalens__c: 0) ; 
                                    oCompProduct.Crystalens__c= oCompProduct.Crystalens__c +  (pv.Crystalens__c != null ? pv.Crystalens__c: 0); 
                                }
                                if (trigger.OldMap.get(pv.Id).AMO__c!= pv.AMO__c) {
                                    oCompProduct.No_of_IOLs_AMO__c= (oCompProduct.No_of_IOLs_AMO__c != null ? oCompProduct.No_of_IOLs_AMO__c: 0) - (trigger.OldMap.get(pv.Id).AMO__c!= null ? trigger.OldMap.get(pv.Id).AMO__c: 0) ; 
                                    oCompProduct.No_of_IOLs_AMO__c= oCompProduct.No_of_IOLs_AMO__c +  (pv.AMO__c != null ? pv.AMO__c: 0); 
                                }
                                if (trigger.OldMap.get(pv.Id).Hanitta__c!= pv.Hanitta__c) {
                                    oCompProduct.No_of_IOLs_HANITTA__c= (oCompProduct.No_of_IOLs_HANITTA__c != null ? oCompProduct.No_of_IOLs_HANITTA__c: 0) - (trigger.OldMap.get(pv.Id).Hanitta__c!= null ? trigger.OldMap.get(pv.Id).Hanitta__c: 0) ; 
                                    oCompProduct.No_of_IOLs_HANITTA__c= oCompProduct.No_of_IOLs_HANITTA__c +  (pv.Hanitta__c != null ? pv.Hanitta__c: 0); 
                                }
                                /*if (trigger.OldMap.get(pv.Id).Acrysof_3_piece__c!= pv.Acrysof_3_piece__c) {
                                    oCompProduct.No_of_IOLs_Acrysof_Single_piece__c= (oCompProduct.No_of_IOLs_Acrysof_Single_piece__c != null ? oCompProduct.No_of_IOLs_Acrysof_Single_piece__c: 0) - (trigger.OldMap.get(pv.Id).Acrysof_Single_piece__c!= null ? trigger.OldMap.get(pv.Id).Acrysof_Single_piece__c: 0) ; 
                                    oCompProduct.No_of_IOLs_Acrysof_Single_piece__c= oCompProduct.No_of_IOLs_Acrysof_Single_piece__c +  (pv.Acrysof_Single_piece__c != null ? pv.Acrysof_Single_piece__c: 0); 
                                }*/
                                if (trigger.OldMap.get(pv.Id).Acrysof_3_piece__c!= pv.Acrysof_3_piece__c) {
                                    oCompProduct.No_of_IOLs_Acrysof_3_piece__c= (oCompProduct.No_of_IOLs_Acrysof_3_piece__c != null ? oCompProduct.No_of_IOLs_Acrysof_3_piece__c: 0) - (trigger.OldMap.get(pv.Id).Acrysof_3_piece__c!= null ? trigger.OldMap.get(pv.Id).Acrysof_3_piece__c: 0) ; 
                                    oCompProduct.No_of_IOLs_Acrysof_3_piece__c= oCompProduct.No_of_IOLs_Acrysof_3_piece__c +  (pv.Acrysof_3_piece__c != null ? pv.Acrysof_3_piece__c: 0); 
                                }
                                if (trigger.OldMap.get(pv.Id).Acrysof_IQ__c!= pv.Acrysof_IQ__c) {
                                    oCompProduct.No_of_IOLs_Acrysof_IQ__c= (oCompProduct.No_of_IOLs_Acrysof_IQ__c != null ? oCompProduct.No_of_IOLs_Acrysof_IQ__c: 0) - (trigger.OldMap.get(pv.Id).Acrysof_IQ__c!= null ? trigger.OldMap.get(pv.Id).Acrysof_IQ__c: 0) ; 
                                    oCompProduct.No_of_IOLs_Acrysof_IQ__c= oCompProduct.No_of_IOLs_Acrysof_IQ__c +  (pv.Acrysof_IQ__c != null ? pv.Acrysof_IQ__c: 0); 
                                }
                                if (trigger.OldMap.get(pv.Id).Rayner__c!= pv.Rayner__c) {
                                    oCompProduct.No_of_IOLs_Rayner__c= (oCompProduct.No_of_IOLs_Rayner__c != null ? oCompProduct.No_of_IOLs_Rayner__c: 0) - (trigger.OldMap.get(pv.Id).Rayner__c!= null ? trigger.OldMap.get(pv.Id).Rayner__c: 0) ; 
                                    oCompProduct.No_of_IOLs_Rayner__c= oCompProduct.No_of_IOLs_Rayner__c +  (pv.Rayner__c != null ? pv.Rayner__c: 0); 
                                }
                                if (trigger.OldMap.get(pv.Id).Sensar__c!= pv.Sensar__c) {
                                    oCompProduct.No_of_IOLs_Sensar__c= (oCompProduct.No_of_IOLs_Sensar__c != null ? oCompProduct.No_of_IOLs_Sensar__c: 0) - (trigger.OldMap.get(pv.Id).Sensar__c!= null ? trigger.OldMap.get(pv.Id).Sensar__c: 0) ; 
                                    oCompProduct.No_of_IOLs_Sensar__c= oCompProduct.No_of_IOLs_Sensar__c +  (pv.Sensar__c != null ? pv.Sensar__c: 0); 
                                }
                                if (trigger.OldMap.get(pv.Id).Tecnis_Acrylic__c!= pv.Tecnis_Acrylic__c) {
                                    oCompProduct.No_of_IOLs_Tecnis_Acrylic__c= (oCompProduct.No_of_IOLs_Tecnis_Acrylic__c!= null ? oCompProduct.No_of_IOLs_Tecnis_Acrylic__c: 0) - (trigger.OldMap.get(pv.Id).Tecnis_Acrylic__c!= null ? trigger.OldMap.get(pv.Id).Tecnis_Acrylic__c: 0) ; 
                                    oCompProduct.No_of_IOLs_Tecnis_Acrylic__c= oCompProduct.No_of_IOLs_Tecnis_Acrylic__c+  (pv.Tecnis_Acrylic__c != null ? pv.Tecnis_Acrylic__c: 0); 
                                }
                                if (trigger.OldMap.get(pv.Id).Zeiss__c!= pv.Zeiss__c) {
                                    oCompProduct.No_of_IOLs_ZEISS__c= (oCompProduct.No_of_IOLs_ZEISS__c!= null ? oCompProduct.No_of_IOLs_ZEISS__c: 0) - (trigger.OldMap.get(pv.Id).Zeiss__c!= null ? trigger.OldMap.get(pv.Id).Zeiss__c: 0) ; 
                                    oCompProduct.No_of_IOLs_ZEISS__c= oCompProduct.No_of_IOLs_ZEISS__c+  (pv.Zeiss__c!= null ? pv.Zeiss__c: 0); 
                                }
                                if (trigger.OldMap.get(pv.Id).Others__c!= pv.Others__c) {
                                    oCompProduct.No_of_IOLs_OTHERS__c= (oCompProduct.No_of_IOLs_OTHERS__c!= null ? oCompProduct.No_of_IOLs_OTHERS__c: 0) - (trigger.OldMap.get(pv.Id).Others__c!= null ? trigger.OldMap.get(pv.Id).Others__c: 0) ; 
                                    oCompProduct.No_of_IOLs_OTHERS__c= oCompProduct.No_of_IOLs_OTHERS__c+  (pv.Others__c!= null ? pv.Others__c: 0); 
                                }
                                if (trigger.OldMap.get(pv.Id).Akreos_MI_60__c!= pv.Akreos_MI_60__c) {
                                    oCompProduct.Akreos_MI_60__c= (oCompProduct.Akreos_MI_60__c!= null ? oCompProduct.Akreos_MI_60__c: 0) - (trigger.OldMap.get(pv.Id).Akreos_MI_60__c!= null ? trigger.OldMap.get(pv.Id).Akreos_MI_60__c: 0) ; 
                                    oCompProduct.Akreos_MI_60__c= oCompProduct.Akreos_MI_60__c+  (pv.Akreos_MI_60__c!= null ? pv.Akreos_MI_60__c: 0); 
                                }
                                if (trigger.OldMap.get(pv.Id).Akreos_Adapt__c!= pv.Akreos_Adapt__c) {
                                    oCompProduct.Akreos_Adapt__c= (oCompProduct.Akreos_Adapt__c!= null ? oCompProduct.Akreos_Adapt__c: 0) - (trigger.OldMap.get(pv.Id).Akreos_Adapt__c!= null ? trigger.OldMap.get(pv.Id).Akreos_Adapt__c: 0) ; 
                                    oCompProduct.Akreos_Adapt__c= oCompProduct.Akreos_Adapt__c+  (pv.Akreos_Adapt__c!= null ? pv.Akreos_Adapt__c: 0); 
                                }
                                if (trigger.OldMap.get(pv.Id).Acrysof_ReStor__c != pv.Acrysof_ReStor__c) {
                                    oCompProduct.Acrysof_ReStor__c = (oCompProduct.Acrysof_ReStor__c != null ? oCompProduct.Acrysof_ReStor__c : 0) - (trigger.OldMap.get(pv.Id).Acrysof_ReStor__c != null ? trigger.OldMap.get(pv.Id).Acrysof_ReStor__c : 0) ; 
                                    oCompProduct.Acrysof_ReStor__c = oCompProduct.Acrysof_ReStor__c +  (pv.Acrysof_ReStor__c != null ? pv.Acrysof_ReStor__c : 0); 
                                }
                                if (trigger.OldMap.get(pv.Id).Acrysof_Toric__c != pv.Acrysof_Toric__c) {
                                    oCompProduct.Acrysof_Toric__c = (oCompProduct.Acrysof_Toric__c != null ? oCompProduct.Acrysof_Toric__c : 0) - (trigger.OldMap.get(pv.Id).Acrysof_Toric__c != null ? trigger.OldMap.get(pv.Id).Acrysof_Toric__c : 0) ; 
                                    oCompProduct.Acrysof_Toric__c = oCompProduct.Acrysof_Toric__c +  (pv.Acrysof_Toric__c != null ? pv.Acrysof_Toric__c : 0); 
                                }
                                if (trigger.OldMap.get(pv.Id).ReZoom__c != pv.ReZoom__c) {
                                    oCompProduct.ReZoom__c = (oCompProduct.ReZoom__c != null ? oCompProduct.ReZoom__c : 0) - (trigger.OldMap.get(pv.Id).ReZoom__c != null ? trigger.OldMap.get(pv.Id).ReZoom__c : 0) ; 
                                    oCompProduct.ReZoom__c = oCompProduct.ReZoom__c +  (pv.ReZoom__c != null ? pv.ReZoom__c : 0); 
                                } 
                                if (trigger.OldMap.get(pv.Id).Tecnis__c != pv.Tecnis__c) {
                                    oCompProduct.Tecnis__c = (oCompProduct.Tecnis__c != null ? oCompProduct.Tecnis__c : 0) - (trigger.OldMap.get(pv.Id).Tecnis__c != null ? trigger.OldMap.get(pv.Id).Tecnis__c : 0) ; 
                                    oCompProduct.Tecnis__c = oCompProduct.Tecnis__c +  (pv.Tecnis__c != null ? pv.Tecnis__c : 0); 
                                } 
                                if (trigger.OldMap.get(pv.Id).Tecnis_Multifocal__c != pv.Tecnis_Multifocal__c) {
                                    oCompProduct.Tecnis_Multifocal__c = (oCompProduct.Tecnis_Multifocal__c != null ? oCompProduct.Tecnis_Multifocal__c : 0) - (trigger.OldMap.get(pv.Id).Tecnis_Multifocal__c != null ? trigger.OldMap.get(pv.Id).Tecnis_Multifocal__c : 0) ; 
                                    oCompProduct.Tecnis_Multifocal__c = oCompProduct.Tecnis_Multifocal__c +  (pv.Tecnis_Multifocal__c != null ? pv.Tecnis_Multifocal__c : 0); 
                                } 
                                if (trigger.OldMap.get(pv.Id).Canon_Staar__c != pv.Canon_Staar__c) {
                                    oCompProduct.Canon_Staar__c = (oCompProduct.Canon_Staar__c != null ? oCompProduct.Canon_Staar__c : 0) - (trigger.OldMap.get(pv.Id).Canon_Staar__c != null ? trigger.OldMap.get(pv.Id).Canon_Staar__c : 0) ; 
                                    oCompProduct.Canon_Staar__c = oCompProduct.Canon_Staar__c +  (pv.Canon_Staar__c != null ? pv.Canon_Staar__c : 0); 
                                } 
                                if (trigger.OldMap.get(pv.Id).Hoya__c != pv.Hoya__c) {
                                    oCompProduct.Hoya__c = (oCompProduct.Hoya__c != null ? oCompProduct.Hoya__c : 0) - (trigger.OldMap.get(pv.Id).Hoya__c != null ? trigger.OldMap.get(pv.Id).Hoya__c : 0) ; 
                                    oCompProduct.Hoya__c = oCompProduct.Hoya__c +  (pv.Hoya__c != null ? pv.Hoya__c : 0); 
                                } 
                                /*Start Added by Sanjib dated:20-Jun-12*/
                                if (trigger.OldMap.get(pv.Id).Envista__c != pv.Envista__c) {
                                    oCompProduct.Envista__c = (oCompProduct.Envista__c != null ? oCompProduct.Envista__c : 0) - (trigger.OldMap.get(pv.Id).Envista__c != null ? trigger.OldMap.get(pv.Id).Envista__c : 0) ; 
                                    oCompProduct.Envista__c = oCompProduct.Envista__c +  (pv.Envista__c != null ? pv.Envista__c : 0); 
                                }
                                if (trigger.OldMap.get(pv.Id).Hours_in_Surgery__c != pv.Hours_in_Surgery__c) {
                                  Double value1 = Double.valueof((oCompProduct.No_of_OT_Hours__c != null ? Double.valueof(oCompProduct.No_of_OT_Hours__c) : 0));
                                  Double value2 = Double.valueof((trigger.OldMap.get(pv.Id).Hours_in_Surgery__c != null ? Double.valueof(trigger.OldMap.get(pv.Id).Hours_in_Surgery__c) : 0));
                                  Double value3 = Double.valueof((oCompProduct.No_of_OT_Hours__c!=null?Double.valueof(oCompProduct.No_of_OT_Hours__c):0));
                                  Double value4 = Double.valueof((pv.Hours_in_Surgery__c != null ?Double.valueof(pv.Hours_in_Surgery__c) : 0));
                                  oCompProduct.No_of_OT_Hours__c =String.valueof(value1-value2);
                                  oCompProduct.No_of_OT_Hours__c = String.valueof(value3+value4);
                                  
                                    //oCompProduct.No_of_OT_Hours__c = (oCompProduct.No_of_OT_Hours__c != null ? oCompProduct.No_of_OT_Hours__c : 0) - (trigger.OldMap.get(pv.Id).Hours_in_Surgery__c != null ? trigger.OldMap.get(pv.Id).Hours_in_Surgery__c : 0) ; 
                                    //oCompProduct.No_of_OT_Hours__c = oCompProduct.No_of_OT_Hours__c +  (pv.Hours_in_Surgery__c != null ? pv.Hours_in_Surgery__c : 0); 
                                } 
                                /*End Added by Sanjib dated:20-Jun-12*/ 
                                
                                 // *START Added by Shibin 2012-8-16    
                            // When Physician visit is service visit    
                            } else if (map_RecordType.get(pv.RecordTypeId) == 'APACSU Technical Service') { //&& !Test.isRunningTest() 
                                

                                
                                
                                    if (trigger.OldMap.get(pv.Id).X1_8mm_Alcon__c != pv.X1_8mm_Alcon__c) {                                                       
                                    oCompProduct.X1_8mm_Alcon__c = (oCompProduct.X1_8mm_Alcon__c != null ? oCompProduct.X1_8mm_Alcon__c : 0) - (trigger.OldMap.get(pv.Id).X1_8mm_Alcon__c != null ? trigger.OldMap.get(pv.Id).X1_8mm_Alcon__c : 0) ; 
                                    oCompProduct.X1_8mm_Alcon__c = oCompProduct.X1_8mm_Alcon__c +  (pv.X1_8mm_Alcon__c != null ? pv.X1_8mm_Alcon__c : 0); 
                                    } 
                                    
                                    if (trigger.OldMap.get(pv.Id).X1_8mm_AMO__c != pv.X1_8mm_AMO__c) {                                                       
                                    oCompProduct.X1_8mm_AMO__c = (oCompProduct.X1_8mm_AMO__c != null ? oCompProduct.X1_8mm_AMO__c : 0) - (trigger.OldMap.get(pv.Id).X1_8mm_AMO__c != null ? trigger.OldMap.get(pv.Id).X1_8mm_AMO__c : 0) ; 
                                    oCompProduct.X1_8mm_AMO__c = oCompProduct.X1_8mm_AMO__c +  (pv.X1_8mm_AMO__c != null ? pv.X1_8mm_AMO__c : 0); 
                                    } 
                                    
                                    if (trigger.OldMap.get(pv.Id).X1_8mm_B_L__c != pv.X1_8mm_B_L__c) {                                                       
                                    oCompProduct.X1_8mm_B_L__c = (oCompProduct.X1_8mm_B_L__c != null ? oCompProduct.X1_8mm_B_L__c : 0) - (trigger.OldMap.get(pv.Id).X1_8mm_B_L__c != null ? trigger.OldMap.get(pv.Id).X1_8mm_B_L__c : 0) ; 
                                    oCompProduct.X1_8mm_B_L__c = oCompProduct.X1_8mm_B_L__c +  (pv.X1_8mm_B_L__c != null ? pv.X1_8mm_B_L__c : 0); 
                                    } 
                                    
                                    if (trigger.OldMap.get(pv.Id).X1_8mm_HumanOptics__c != pv.X1_8mm_HumanOptics__c) {                                                       
                                    oCompProduct.X1_8mm_HumanOptics__c = (oCompProduct.X1_8mm_HumanOptics__c != null ? oCompProduct.X1_8mm_HumanOptics__c : 0) - (trigger.OldMap.get(pv.Id).X1_8mm_HumanOptics__c != null ? trigger.OldMap.get(pv.Id).X1_8mm_HumanOptics__c : 0) ; 
                                    oCompProduct.X1_8mm_HumanOptics__c = oCompProduct.X1_8mm_HumanOptics__c +  (pv.X1_8mm_HumanOptics__c != null ? pv.X1_8mm_HumanOptics__c : 0); 
                                    } 
                                    
                                    if (trigger.OldMap.get(pv.Id).X1_8mm_Zeiss__c != pv.X1_8mm_Zeiss__c) {                                                       
                                    oCompProduct.X1_8mm_Zeiss__c = (oCompProduct.X1_8mm_Zeiss__c != null ? oCompProduct.X1_8mm_Zeiss__c : 0) - (trigger.OldMap.get(pv.Id).X1_8mm_Zeiss__c != null ? trigger.OldMap.get(pv.Id).X1_8mm_Zeiss__c : 0) ; 
                                    oCompProduct.X1_8mm_Zeiss__c = oCompProduct.X1_8mm_Zeiss__c +  (pv.X1_8mm_Zeiss__c != null ? pv.X1_8mm_Zeiss__c : 0); 
                                    } 
                                    
                                    if (trigger.OldMap.get(pv.Id).X2_2mm_Alcon__c != pv.X2_2mm_Alcon__c) {                                                       
                                    oCompProduct.X2_2mm_Alcon__c = (oCompProduct.X2_2mm_Alcon__c != null ? oCompProduct.X2_2mm_Alcon__c : 0) - (trigger.OldMap.get(pv.Id).X2_2mm_Alcon__c != null ? trigger.OldMap.get(pv.Id).X2_2mm_Alcon__c : 0) ; 
                                    oCompProduct.X2_2mm_Alcon__c = oCompProduct.X2_2mm_Alcon__c +  (pv.X2_2mm_Alcon__c != null ? pv.X2_2mm_Alcon__c : 0); 
                                    } 
                                    
                                    if (trigger.OldMap.get(pv.Id).X2_2mm_AMO__c != pv.X2_2mm_AMO__c) {                                                       
                                    oCompProduct.X2_2mm_AMO__c = (oCompProduct.X2_2mm_AMO__c != null ? oCompProduct.X2_2mm_AMO__c : 0) - (trigger.OldMap.get(pv.Id).X2_2mm_AMO__c != null ? trigger.OldMap.get(pv.Id).X2_2mm_AMO__c : 0) ; 
                                    oCompProduct.X2_2mm_AMO__c = oCompProduct.X2_2mm_AMO__c +  (pv.X2_2mm_AMO__c != null ? pv.X2_2mm_AMO__c : 0); 
                                    } 
                                    
                                    if (trigger.OldMap.get(pv.Id).X2_2mm_B_L__c != pv.X2_2mm_B_L__c) {                                                       
                                    oCompProduct.X2_2mm_B_L__c = (oCompProduct.X2_2mm_B_L__c != null ? oCompProduct.X2_2mm_B_L__c : 0) - (trigger.OldMap.get(pv.Id).X2_2mm_B_L__c != null ? trigger.OldMap.get(pv.Id).X2_2mm_B_L__c : 0) ; 
                                    oCompProduct.X2_2mm_B_L__c = oCompProduct.X2_2mm_B_L__c +  (pv.X2_2mm_B_L__c != null ? pv.X2_2mm_B_L__c : 0); 
                                    } 
                                    
                                    if (trigger.OldMap.get(pv.Id).X2_2mm_HumanOptics__c != pv.X2_2mm_HumanOptics__c) {                                                       
                                    oCompProduct.X2_2mm_HumanOptics__c = (oCompProduct.X2_2mm_HumanOptics__c != null ? oCompProduct.X2_2mm_HumanOptics__c : 0) - (trigger.OldMap.get(pv.Id).X2_2mm_HumanOptics__c != null ? trigger.OldMap.get(pv.Id).X2_2mm_HumanOptics__c : 0) ; 
                                    oCompProduct.X2_2mm_HumanOptics__c = oCompProduct.X2_2mm_HumanOptics__c +  (pv.X2_2mm_HumanOptics__c != null ? pv.X2_2mm_HumanOptics__c : 0); 
                                    } 
                                    
                                    if (trigger.OldMap.get(pv.Id).X2_2mm_Zeiss__c != pv.X2_2mm_Zeiss__c) {                                                       
                                    oCompProduct.X2_2mm_Zeiss__c = (oCompProduct.X2_2mm_Zeiss__c != null ? oCompProduct.X2_2mm_Zeiss__c : 0) - (trigger.OldMap.get(pv.Id).X2_2mm_Zeiss__c != null ? trigger.OldMap.get(pv.Id).X2_2mm_Zeiss__c : 0) ; 
                                    oCompProduct.X2_2mm_Zeiss__c = oCompProduct.X2_2mm_Zeiss__c +  (pv.X2_2mm_Zeiss__c != null ? pv.X2_2mm_Zeiss__c : 0); 
                                    } 
                                    
                                    if (trigger.OldMap.get(pv.Id).X2_8mm_Alcon__c != pv.X2_8mm_Alcon__c) {                                                       
                                    oCompProduct.X2_8mm_Alcon__c = (oCompProduct.X2_8mm_Alcon__c != null ? oCompProduct.X2_8mm_Alcon__c : 0) - (trigger.OldMap.get(pv.Id).X2_8mm_Alcon__c != null ? trigger.OldMap.get(pv.Id).X2_8mm_Alcon__c : 0) ; 
                                    oCompProduct.X2_8mm_Alcon__c = oCompProduct.X2_8mm_Alcon__c +  (pv.X2_8mm_Alcon__c != null ? pv.X2_8mm_Alcon__c : 0); 
                                    } 
                                    
                                    if (trigger.OldMap.get(pv.Id).X2_8mm_AMO__c != pv.X2_8mm_AMO__c) {                                                       
                                    oCompProduct.X2_8mm_AMO__c = (oCompProduct.X2_8mm_AMO__c != null ? oCompProduct.X2_8mm_AMO__c : 0) - (trigger.OldMap.get(pv.Id).X2_8mm_AMO__c != null ? trigger.OldMap.get(pv.Id).X2_8mm_AMO__c : 0) ; 
                                    oCompProduct.X2_8mm_AMO__c = oCompProduct.X2_8mm_AMO__c +  (pv.X2_8mm_AMO__c != null ? pv.X2_8mm_AMO__c : 0); 
                                    } 
                                    
                                    if (trigger.OldMap.get(pv.Id).X2_8mm_B_L__c != pv.X2_8mm_B_L__c) {                                                       
                                    oCompProduct.X2_8mm_B_L__c = (oCompProduct.X2_8mm_B_L__c != null ? oCompProduct.X2_8mm_B_L__c : 0) - (trigger.OldMap.get(pv.Id).X2_8mm_B_L__c != null ? trigger.OldMap.get(pv.Id).X2_8mm_B_L__c : 0) ; 
                                    oCompProduct.X2_8mm_B_L__c = oCompProduct.X2_8mm_B_L__c +  (pv.X2_8mm_B_L__c != null ? pv.X2_8mm_B_L__c : 0); 
                                    } 
                                    
                                    if (trigger.OldMap.get(pv.Id).X2_8mm_HumanOptics__c != pv.X2_8mm_HumanOptics__c) {                                                       
                                    oCompProduct.X2_8mm_HumanOptics__c = (oCompProduct.X2_8mm_HumanOptics__c != null ? oCompProduct.X2_8mm_HumanOptics__c : 0) - (trigger.OldMap.get(pv.Id).X2_8mm_HumanOptics__c != null ? trigger.OldMap.get(pv.Id).X2_8mm_HumanOptics__c : 0) ; 
                                    oCompProduct.X2_8mm_HumanOptics__c = oCompProduct.X2_8mm_HumanOptics__c +  (pv.X2_8mm_HumanOptics__c != null ? pv.X2_8mm_HumanOptics__c : 0); 
                                    } 
                                    
                                    if (trigger.OldMap.get(pv.Id).X2_8mm_Zeiss__c != pv.X2_8mm_Zeiss__c) {                                                       
                                    oCompProduct.X2_8mm_Zeiss__c = (oCompProduct.X2_8mm_Zeiss__c != null ? oCompProduct.X2_8mm_Zeiss__c : 0) - (trigger.OldMap.get(pv.Id).X2_8mm_Zeiss__c != null ? trigger.OldMap.get(pv.Id).X2_8mm_Zeiss__c : 0) ; 
                                    oCompProduct.X2_8mm_Zeiss__c = oCompProduct.X2_8mm_Zeiss__c +  (pv.X2_8mm_Zeiss__c != null ? pv.X2_8mm_Zeiss__c : 0); 
                                    } 
                                    
                                    if (trigger.OldMap.get(pv.Id).X1_8mm_Others__c != pv.X1_8mm_Others__c) {                                                       
                                    oCompProduct.X1_8mm_Others__c = (oCompProduct.X1_8mm_Others__c != null ? oCompProduct.X1_8mm_Others__c : 0) - (trigger.OldMap.get(pv.Id).X1_8mm_Others__c != null ? trigger.OldMap.get(pv.Id).X1_8mm_Others__c : 0) ; 
                                    oCompProduct.X1_8mm_Others__c = oCompProduct.X1_8mm_Others__c +  (pv.X1_8mm_Others__c != null ? pv.X1_8mm_Others__c : 0); 
                                    }
                                    
                                    if (trigger.OldMap.get(pv.Id).X2_2mm_Others__c != pv.X2_2mm_Others__c) {                                                       
                                    oCompProduct.X2_2mm_Others__c = (oCompProduct.X2_2mm_Others__c != null ? oCompProduct.X2_2mm_Others__c : 0) - (trigger.OldMap.get(pv.Id).X2_2mm_Others__c != null ? trigger.OldMap.get(pv.Id).X2_2mm_Others__c : 0) ; 
                                    oCompProduct.X2_2mm_Others__c = oCompProduct.X2_2mm_Others__c +  (pv.X2_2mm_Others__c != null ? pv.X2_2mm_Others__c : 0); 
                                    } 
                                    
                                    if (trigger.OldMap.get(pv.Id).X2_8mm_Others__c != pv.X2_8mm_Others__c) {                                                       
                                    oCompProduct.X2_8mm_Others__c = (oCompProduct.X2_8mm_Others__c != null ? oCompProduct.X2_8mm_Others__c : 0) - (trigger.OldMap.get(pv.Id).X2_8mm_Others__c != null ? trigger.OldMap.get(pv.Id).X2_8mm_Others__c : 0) ; 
                                    oCompProduct.X2_8mm_Others__c = oCompProduct.X2_8mm_Others__c +  (pv.X2_8mm_Others__c != null ? pv.X2_8mm_Others__c : 0); 
                                    } 
                                    
         
                                     
                                    
                                }
                                
                                
                                
                                
                            
                            // *END Added by Shibin 2012-8-16
                            
                            else {
                                
                                
                                        if (map_RecordType.get(pv.RecordTypeId) == 'APACSU Technical Service')
                                        {
                                            // && !Test.isRunningTest())
                                            oCompProduct.X1_8mm_Alcon__c=pv.X1_8mm_Alcon__c;
                                            oCompProduct.X1_8mm_AMO__c=pv.X1_8mm_AMO__c;
                                            oCompProduct.X1_8mm_B_L__c=pv.X1_8mm_B_L__c;
                                            oCompProduct.X1_8mm_HumanOptics__c=pv.X1_8mm_HumanOptics__c;
                                            oCompProduct.X1_8mm_Zeiss__c=pv.X1_8mm_Zeiss__c;
                                            oCompProduct.X2_2mm_Alcon__c=pv.X2_2mm_Alcon__c;
                                            oCompProduct.X2_2mm_AMO__c=pv.X2_2mm_AMO__c;
                                            oCompProduct.X2_2mm_B_L__c=pv.X2_2mm_B_L__c;
                                            oCompProduct.X2_2mm_HumanOptics__c=pv.X2_2mm_HumanOptics__c;
                                            oCompProduct.X2_2mm_Zeiss__c=pv.X2_2mm_Zeiss__c;
                                            oCompProduct.X2_8mm_Alcon__c=pv.X2_8mm_Alcon__c;
                                            oCompProduct.X2_8mm_AMO__c=pv.X2_8mm_AMO__c;
                                            oCompProduct.X2_8mm_B_L__c=pv.X2_8mm_B_L__c;
                                            oCompProduct.X2_8mm_HumanOptics__c=pv.X2_8mm_HumanOptics__c;
                                            oCompProduct.X2_8mm_Zeiss__c=pv.X2_8mm_Zeiss__c;
                                            oCompProduct.X1_8mm_Others__c=pv.X1_8mm_Others__c;
                                            oCompProduct.X2_2mm_Others__c=pv.X2_2mm_Others__c;
                                            oCompProduct.X2_8mm_Others__c=pv.X2_8mm_Others__c;
                                            
                                        }  
                                
                             else {
                                oCompProduct.Current_Total_Implantations__c = pv.Imported_Foldable_Implant__c;
                                oCompProduct.AKREOS_MIL__c = pv.Akreos_MIL__c;
                                oCompProduct.AKREOS_AO__c = pv.Akreos_AO__c;
                                oCompProduct.AKREOS__c = pv.Akreos__c;
                                oCompProduct.LI61_AO__c = pv.LI61_AO__c;
                                oCompProduct.LI61_SE__c = pv.LI61_SE__c;
                                oCompProduct.LI61AOV__c = pv.LI61AOV__c;
                                oCompProduct.Crystalens__c = pv.Crystalens__c;
                                oCompProduct.No_of_IOLs_AMO__c = pv.AMO__c;
                                oCompProduct.No_of_IOLs_HANITTA__c = pv.Hanitta__c;
                                oCompProduct.No_of_IOLs_Acrysof_Single_piece__c = pv.Acrysof_Single_piece__c;
                                oCompProduct.No_of_IOLs_Acrysof_3_piece__c = pv.Acrysof_3_piece__c;
                                oCompProduct.No_of_IOLs_Acrysof_IQ__c = pv.Acrysof_IQ__c;
                                oCompProduct.No_of_IOLs_Rayner__c = pv.Rayner__c;
                                oCompProduct.No_of_IOLs_Sensar__c = pv.Sensar__c;
                                oCompProduct.No_of_IOLs_Tecnis_Acrylic__c = pv.Tecnis_Acrylic__c;
                                oCompProduct.No_of_IOLs_ZEISS__c = pv.Zeiss__c;
                                oCompProduct.No_of_IOLs_OTHERS__c = pv.Others__c;
                                oCompProduct.Akreos_MI_60__c = pv.AKREOS_MI_60__c;
                                oCompProduct.Akreos_Adapt__c = pv.AKREOS_ADAPT__c;
                                oCompProduct.Acrysof_ReStor__c = pv.Acrysof_ReStor__c;
                                oCompProduct.Acrysof_Toric__c = pv.Acrysof_Toric__c;
                                oCompProduct.ReZoom__c = pv.ReZoom__c;
                                oCompProduct.Tecnis__c = pv.Tecnis__c; 
                                oCompProduct.Tecnis_Multifocal__c = pv.Tecnis_Multifocal__c;
                                oCompProduct.Canon_Staar__c = pv.Canon_Staar__c;
                                oCompProduct.Hoya__c = pv.Hoya__c;
                                oCompProduct.Envista__c = pv.Envista__c;
                                oCompProduct.No_of_OT_Hours__c = pv.Hours_in_Surgery__c;
                                oCompProduct.Bundling_Competitor__c=pv.Bundling_Competitor__c;
                                oCompProduct.Expiry_Date__c=pv.Expiry_Date__c;
                               }
                            }
                            map_monthlyImplantDetails.put(oCompProduct.Id, oCompProduct);
                              System.debug('map_monthlyImplantDetails: '+map_monthlyImplantDetails);
                            //list_CompProdToUpdate.add(oCompProduct);                    
                        }
                        //If no Competitor product exists
                        else
                        {   system.debug('list_compRecordType' + list_compRecordType.size());
                            if(list_compRecordType.size() > 0)
                            {
                                Monthly_Implantation_Detail__c oCompProductToCreate = new Monthly_Implantation_Detail__c();
                                oCompProductToCreate.Physician_Name__c = pv.Physician__c;
                                oCompProductToCreate.Current_Total_Implantations__c = pv.Imported_Foldable_Implant__c;
                                oCompProductToCreate.AKREOS_MIL__c = pv.Akreos_MIL__c;
                                oCompProductToCreate.AKREOS_AO__c = pv.Akreos_AO__c;
                                oCompProductToCreate.AKREOS__c = pv.Akreos__c;
                                oCompProductToCreate.LI61_AO__c = pv.LI61_AO__c;
                                oCompProductToCreate.LI61_SE__c = pv.LI61_SE__c;
                                oCompProductToCreate.LI61AOV__c = pv.LI61AOV__c;
                                oCompProductToCreate.Crystalens__c = pv.Crystalens__c;
                                oCompProductToCreate.No_of_IOLs_AMO__c = pv.AMO__c;
                                oCompProductToCreate.No_of_IOLs_HANITTA__c = pv.Hanitta__c;
                                oCompProductToCreate.No_of_IOLs_Acrysof_Single_piece__c = pv.Acrysof_Single_piece__c;
                                oCompProductToCreate.No_of_IOLs_Acrysof_3_piece__c = pv.Acrysof_3_piece__c;
                                oCompProductToCreate.No_of_IOLs_Acrysof_IQ__c = pv.Acrysof_IQ__c;
                                oCompProductToCreate.No_of_IOLs_Rayner__c = pv.Rayner__c;
                                oCompProductToCreate.No_of_IOLs_Sensar__c = pv.Sensar__c;
                                oCompProductToCreate.No_of_IOLs_Tecnis_Acrylic__c = pv.Tecnis_Acrylic__c;
                                oCompProductToCreate.No_of_IOLs_ZEISS__c = pv.Zeiss__c;
                                oCompProductToCreate.No_of_IOLs_OTHERS__c = pv.Others__c;
                                oCompProductToCreate.Month__c = map_Months.get(pv.Activity_Date__c.month());
                                oCompProductToCreate.Year__c = pv.Activity_Date__c.year();
                                oCompProductToCreate.Akreos_MI_60__c = pv.Akreos_MI_60__c;
                                oCompProductToCreate.Akreos_Adapt__c = pv.Akreos_Adapt__c;
                                oCompProductToCreate.Acrysof_ReStor__c = pv.Acrysof_ReStor__c;
                                oCompProductToCreate.Acrysof_Toric__c = pv.Acrysof_Toric__c;
                                oCompProductToCreate.ReZoom__c = pv.ReZoom__c;
                                oCompProductToCreate.Tecnis__c = pv.Tecnis__c;
                                oCompProductToCreate.Tecnis_Multifocal__c = pv.Tecnis_Multifocal__c;
                                oCompProductToCreate.Canon_Staar__c = pv.Canon_Staar__c;
                                oCompProductToCreate.Hoya__c = pv.Hoya__c; 
                                oCompProductToCreate.Envista__c = pv.Envista__c;
                                oCompProductToCreate.No_of_OT_Hours__c = pv.Hours_in_Surgery__c;
                                oCompProductToCreate.Bundling_Competitor__c=pv.Bundling_Competitor__c;
                                oCompProductToCreate.Expiry_Date__c=pv.Expiry_Date__c;  
                                
                                
                                //if(!Test.isRunningTest()){
                                //Added by Gordon 2012-8-20
                                    oCompProductToCreate.X1_8mm_Alcon__c=pv.X1_8mm_Alcon__c;
                                    oCompProductToCreate.X1_8mm_AMO__c=pv.X1_8mm_AMO__c;
                                    oCompProductToCreate.X1_8mm_B_L__c=pv.X1_8mm_B_L__c;
                                    oCompProductToCreate.X1_8mm_HumanOptics__c=pv.X1_8mm_HumanOptics__c;
                                    oCompProductToCreate.X1_8mm_Zeiss__c=pv.X1_8mm_Zeiss__c;
                                    oCompProductToCreate.X2_2mm_Alcon__c=pv.X2_2mm_Alcon__c;
                                    oCompProductToCreate.X2_2mm_AMO__c=pv.X2_2mm_AMO__c;
                                    oCompProductToCreate.X2_2mm_B_L__c=pv.X2_2mm_B_L__c;
                                    oCompProductToCreate.X2_2mm_HumanOptics__c=pv.X2_2mm_HumanOptics__c;
                                    oCompProductToCreate.X2_2mm_Zeiss__c=pv.X2_2mm_Zeiss__c;
                                    oCompProductToCreate.X2_8mm_Alcon__c=pv.X2_8mm_Alcon__c;
                                    oCompProductToCreate.X2_8mm_AMO__c=pv.X2_8mm_AMO__c;
                                    oCompProductToCreate.X2_8mm_B_L__c=pv.X2_8mm_B_L__c;
                                    oCompProductToCreate.X2_8mm_HumanOptics__c=pv.X2_8mm_HumanOptics__c;
                                    oCompProductToCreate.X2_8mm_Zeiss__c=pv.X2_8mm_Zeiss__c;
                                    oCompProductToCreate.X1_8mm_Others__c=pv.X1_8mm_Others__c;
                                    oCompProductToCreate.X2_2mm_Others__c=pv.X2_2mm_Others__c;
                                    oCompProductToCreate.X2_8mm_Others__c=pv.X2_8mm_Others__c; 
                                //}
                                
                                //oCompProductToCreate.RecordTypeId = list_compRecordType.get(0).Id;
                                if((map_RecordType.get(pv.RecordTypeId) == 'INDSU Sales Planned') || (map_RecordType.get(pv.RecordTypeId) == 'INDSU Sales Unplanned'))
                                    oCompProductToCreate.RecordTypeId = map_recTypeNameToIdMonthly.get('INDSU Monthly Implantation Detail');
                                else if((map_RecordType.get(pv.RecordTypeId) == 'APACSU Technical Service') || (map_RecordType.get(pv.RecordTypeId) == 'APACSU Sales Planned') || (map_RecordType.get(pv.RecordTypeId) == 'APACSU Sales Unplanned'))
                                    oCompProductToCreate.RecordTypeId = map_recTypeNameToIdMonthly.get('APACSU Monthly Implantation Detail');
                                
                                //list_CompProdToCreate.add(oCompProductToCreate);
                                insert oCompProductToCreate; // need id in next iterations
                                map_monthlyImplantDetails.put(oCompProductToCreate.Id, oCompProductToCreate);
                                map_PhysicianProduct.put(pv.Physician__c, oCompProductToCreate);
                            }
                        }
                    }
                }
                
                if(!map_monthlyImplantDetails.isEmpty())
                    update map_monthlyImplantDetails.values();
                    
                      if(!blnmidTask)  {       
                    for(Monthly_Implantation_Detail__c temp_Mid : [SELECT Id,Name,RecordTypeId,OwnerId,Expiry_Date__c,Bundling_Competitor__c,Physician_Name__c,Month__c,Year__c FROM Monthly_Implantation_Detail__c WHERE Id IN :map_monthlyImplantDetails.keyset()]){
       
            System.debug('temp_Mid :'+temp_Mid + '--objUser.UserRole.Name--' + objUser.UserRole.Name);
            
            if((objUser.UserRole.Name.contains('INDSU') || objUser.UserRole.Name.contains('INDAES')) && temp_Mid.Expiry_Date__c != null && temp_Mid.Expiry_Date__c >= System.Today() && temp_Mid.Bundling_Competitor__c != null ){
                
                Task midTask = new Task();
                midTask.Subject = 'Competitor Bundling Expiring';
                midTask.Priority = 'Normal';
                midTask.Status = 'Not Started';
                midTask.ActivityDate = temp_Mid.Expiry_Date__c;
                midTask.WhatId = temp_Mid.Id;
                midTask.WhoId = temp_Mid.Physician_Name__c;
                midTask.recordTypeId = midRecordType.Id;
                midTask.OwnerId = temp_Mid.OwnerId; 
                midTask.IsReminderSet = True;
                midTask.ReminderDateTime = temp_Mid.Expiry_Date__c - 1;
                
                System.debug('midTask.IsReminderSet: '+midTask.IsReminderSet);
                System.debug('midTask.ActivityDate: '+ midTask.ActivityDate);
                System.debug('midTask.ReminderDateTime: '+midTask.ReminderDateTime);
                
                insert midTask;
            
            }
            else { 
                if((temp_Mid.Expiry_Date__c != null && temp_Mid.Bundling_Competitor__c == null ) || (temp_Mid.Expiry_Date__c == null && temp_Mid.Bundling_Competitor__c != null ) ){
                         trigger.new[0].Expiry_Date__c.addError('Please select the Bundling Competitor and Date.');
                    }
                else if(temp_Mid.Expiry_Date__c != null && temp_Mid.Expiry_Date__c <= System.Today() ) {
                     trigger.new[0].Expiry_Date__c.addError('Date should not be less than today');
                    }
                
                }
                
                blnmidTask = true;
            }
        }
                system.debug('list_CompProdToCreate' + list_CompProdToCreate.size());
                /*if(!list_CompProdToCreate.isEmpty())
                    insert list_CompProdToCreate;*/
                
            }
        }
    }
    
    }//!kor
    else{
    
  system.debug('Trigger Name:PhysicianVisit_BU_UpdateCompetitorInformation on Physician_Visit__c------->This trigger No Need for KOR SOLTA USers');
    }
}//trigger