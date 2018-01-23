trigger PhysicianVisit_AU_UpdateFutureVisits on Physician_Visit__c(after Update) 
{
    /*
    * 
    * This trigger future Physician Visit Records whenever an update happens on Physician Visit
    * 
    * Author                        |Author-Email                                      |Date        |Comment
    * ------------------------------|------------------------------------------------- |------------|----------------------------------------------------
    * DeepaLakshmi.R                |deepalakshmi.venkatesh@listertechnologies.com     |30.04.2010  |First Draft
    * DeepaLakshmi.R                |deepalakshmi.venkatesh@listertechnologies.com     |30.04.2010  |Second Draft to update call summary, effectiveness summary
    * Sanjib Mahanta                |sanjib.mahanta@bausch.com                         |29.05.2012  |Updated the trigger to incorporate Call Summary record.  
    * Raviteja Vakity               |Raviteja.vakity@bausch.com                        |30-Jul-2012 |Updating the Hours_in_Surgery__c value as '0.0' , if Hours_in_Surgery__c having null at 41 & 42 line.
    * Rajesh Sriramulu              |rajesh.sriramulu@rishabhsoft.com                  |12/09/2012  |Added  code to update status is completed
    * Raviteja Vakity               |Raviteja.vakity@bausch.com                        |02-Nov-2012 |Update the logic for INDSU as work days for India is 6 Days a week  
    * Parag Sharma                  |Parag.Sharma@bausch.com                           |12-Apr-2013 |Added code for SFE Custom Report
    * Raviteja Vakity               |Raviteja.vakity@bausch.com                        |27-Nov-2012 |Update the logic for INDSU multi Physician Visit Reporting
    * Neha Jain                     |neha.jain@bausch.com                              |09-Apr-2014 |Modified the code to update physician visit also changed the logic to calculate OT hours 
    * Tarun Solanki                 |tarun.solanki@bausch.com                          |02-june-2014 |Modified the code India Aesthetic BU
    * VEnkateswara Reddy.C          |Venkateswara.reddy2@bausch.com                    |25-Nov-2015 | Added code for Checking if the user is KOR SOLTA or not.
    */ 
     
    //check if user is other than KOREA SOLTA or not
  //list<UserRole> lstroleName=[SELECT Id, Name FROM UserRole WHERE Id =: UserInfo.getUserRoleId() LIMIT 1];  
   string lstroleName = UserInfo.getLocale();
    if(!lstroleName.contains('ko_KR')){  
    
    
    
      system.debug('clsPhysicianVisitUpdate.isExecute :' + clsPhysicianVisitUpdate.isExecute + clsPhysicianVisitUpdate.isInsert);  
      system.debug(' Trigger.New size : '+ Trigger.New.size());
      system.debug(' Trigger.New : '+ Trigger.New);
      
      Set<Id> parentIds = new Set<Id>();
        for (Physician_Visit__c chld : trigger.new) {
              parentIds.add(chld.Id);
       }
      
    Double calcSumOTHours = 0;  
     
    if(clsPhysicianVisitUpdate.isExecute == false && clsPhysicianVisitUpdate.isInsert == false)
    {
        clsPhysicianVisitUpdate.isExecute = true; 
         system.debug('clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk :' + clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk );       
        if(!clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk)
        {
        
            if(Trigger.isUpdate)
            {  
                Double sumOTHours; 
                List<Effectiveness_Summary__c> listEffect = new List<Effectiveness_Summary__c>();
                try
                        {
                            clsUpdateFuturePhysicianVisits oclsUpdateFuturePhysicianVisits = new clsUpdateFuturePhysicianVisits();
                            oclsUpdateFuturePhysicianVisits.updateFuturePhysicianVisits(trigger.new,'update');                      
                            //List of affected physician visits.
                          //  List<Physician_Visit__c> list_PhysicianVisit = [select Id, Reporting_Time__c,OwnerId,Doctor_Segmentation__c,Time_Spent_In_OT__c,Hours_in_Surgery__c, Activity_Date__c, recordType.Name, End_time__c,Status__c, Call_Objective__c, Call_Objective_Achieved__c  from Physician_Visit__c where id in :Trigger.New];
                             List<Physician_Visit__c> list_PhysicianVisit = [select Id, Reporting_Time__c,OwnerId,Doctor_Segmentation__c,Time_Spent_In_OT__c,Hours_in_Surgery__c, Activity_Date__c, recordType.Name, End_time__c,Status__c, Call_Objective__c, Call_Objective_Achieved__c  from Physician_Visit__c where id in :parentIds];
                            //Proceed only if the status of any of the record is completed.
                            Boolean blnContinue = False;
                    
                    for (Physician_Visit__c pv:list_PhysicianVisit){
                      //  if(Trigger.OldMap.get(pv.Id).Status__c == 'Open' && pv.Status__c == 'Open')
                    // pv.Status__c = 'Completed';
                        // Sanjib Mahanta 29.05.2012 commented the if condition and created new if below to incorporate Call Summary record.
                       // if ((pv.Status__c == 'Completed' && Trigger.oldmap.get(pv.Id).Status__c == 'Open')) Commented by Sanjib 28-May-12
                        listEffect = [select id,ownerId,OT_Hours__c from Effectiveness_Summary__c where Date__c=:pv.Activity_Date__c and ownerId=:pv.OwnerId];
                        System.debug('pv before if update Hours_in_Surgery__c: '+pv.Hours_in_Surgery__c);
                        System.debug('pv before if update Time_Spent_In_OT__c: '+pv.Time_Spent_In_OT__c);
                        System.debug('before if update pv : '+pv);
                       
                        if(pv.Hours_in_Surgery__c == null || pv.Hours_in_Surgery__c == ''){
                        pv.Hours_in_Surgery__c = '0.0';}
                        
                        if (pv.Status__c=='Completed'){
                        
                            if (pv.Status__c=='Completed' && Trigger.oldmap.get(pv.Id).Status__c=='Open')
                            {
                             System.debug(' Before Date:  '+pv.Reporting_Time__c);
                             pv.Reporting_Time__c =system.now();
                             System.debug(' After Date:  '+pv.Reporting_Time__c); 
                            } 
                     
                            blnContinue = True; 
                            if(listEffect.size()>0) {
                                    System.debug('List greater than zero sanjib');    
                                    system.debug('***pv.id -- ' + pv.id);                                  
                                    if(Trigger.oldmap.get(pv.id).Time_Spent_In_OT__c!=null && Trigger.oldmap.get(pv.id).Time_Spent_In_OT__c!=pv.Time_Spent_In_OT__c){
                                        system.debug('***Trigger.oldmap.get(pv.id).Time_Spent_In_OT__c!=pv.Time_Spent_In_OT__c' + Trigger.oldmap.get(pv.id).Time_Spent_In_OT__c + '=' + pv.Time_Spent_In_OT__c);                        
                                        //logic if values are not same
                                        //Sanjib Mahanta : 1. Get the difference of the value. Formula: NewValue - OldValue - 6-July-12
                                        double TimeSpentInOTDifference = pv.Time_Spent_In_OT__c - Trigger.oldmap.get(pv.id).Time_Spent_In_OT__c;                                            
                                        //2. If difference is negative, subtract it from sumOTHours, else, add it.
                                        System.debug('Difference Sanjib'+TimeSpentInOTDifference );
                                        System.debug('Difference Sanjib listEffect[0].OT_Hours__c'+listEffect[0].OT_Hours__c);
                                        if(TimeSpentInOTDifference < 0){
                                            sumOTHours =(listEffect[0].OT_Hours__c + TimeSpentInOTDifference);                              
                                            System.debug('Difference Positive'+sumOTHours);
                                        }
                                        else{
                                            sumOTHours =listEffect[0].OT_Hours__c + TimeSpentInOTDifference;
                                            System.debug('Difference Negative'+sumOTHours );                                                        
                                        }
                                    }else{
                                        System.debug('New Visit OT Hours Capture'+listEffect[0].OT_Hours__c);
                                        System.debug('Latest OT Hours'+pv.Time_Spent_In_OT__c);
                                        if(sumOTHours==null && listEffect[0].OT_Hours__c==null){                   
                                            //neha
                                            sumOTHours = pv.Time_Spent_In_OT__c;
                                        }else{
                                            //neha
                                            sumOTHours=  (listEffect[0].OT_Hours__c+pv.Time_Spent_In_OT__c);
                                        }
                                    }
                        } else{               
                            System.debug('List empty');
                            //System.debug('else sanjib'+listEffect[0].OT_Hours__c);
                            if(sumOTHours==null){
                            //if(listEffect[0].OT_Hours__c==0 ||sumOTHours==null)
                            sumOTHours=  pv.Time_Spent_In_OT__c;
                            
                            }else{
                            sumOTHours= (listEffect[0].OT_Hours__c+pv.Time_Spent_In_OT__c);                                                 
                        
                        }
                        }
                        }
                        System.debug('pv before update Hours_in_Surgery__c: '+pv.Hours_in_Surgery__c);
                        System.debug('pv before update Time_Spent_In_OT__c: '+pv.Time_Spent_In_OT__c);
                        System.debug('before update pv : '+pv);
                        //----commented by neha update pv;
                        System.debug('pv after update Hours_in_Surgery__c: '+pv.Hours_in_Surgery__c);
                        System.debug('pv after update Time_Spent_In_OT__c: '+pv.Time_Spent_In_OT__c);
                        System.debug('after update pv : '+pv);
                        break;
            }
            //Neha Jain - update the list instead of updating each
            update list_PhysicianVisit;
                   
            if (!blnContinue) return;
            System.debug('blnContinue=='+blnContinue);
            //List of Call summaries to insert.update.
            List<Call_Summary__c> list_CallSummary = new List<Call_Summary__c>();
    
            //List of effectiveness summaries to insert.update.
            List<Effectiveness_Summary__c> list_EffectivenessSummary = new List<Effectiveness_Summary__c>();
    
            //Get the user values.
            User objUser = [Select Id, Name, APAC_Country__c, APAC_Region__c, APAC_Area__c, UserRoleId,UserRole.Name, Profile.Name From User Where Id=:Userinfo.getUserId()];
            
            //Get the user profile.
            //Profile objProfile = [Select Name from Profile where id=:Userinfo.getProfileId()];
            String strProfile = objUser.Profile.Name;
            
            /* Start Logic for Custom Report by Parag Sharma */
            List<Physician_Visit__c> objTriggerNew = new List<Physician_Visit__c>();
            objTriggerNew = Trigger.New;
            //System.debug('objTriggerNew : ' + objTriggerNew);         
            String strINDProfile = '';
            IF(objUser.Profile.Name == 'INDSU Sales Rep' || objUser.Profile.Name == 'THASU Sales Rep' || objUser.Profile.Name == 'INDAES Sales Rep' || objUser.Profile.Name == 'INDSU Service Rep'){
                strINDProfile = objUser.Profile.Name;
            }
             integer noOfContactsOfSalesRep  = 0;
             integer noOfContactsOfSalesRepofA  = 0;
             integer noOfContactsOfSalesRepofB  = 0;
             integer noOfContactsOfSalesRepofC  = 0;         
             integer noOfContactsOfSalesRepOthers  = 0;
             IF(objUser.Profile.Name.startsWith('INDSU') == true || objUser.Profile.Name.startsWith('THASU') == true || objUser.Profile.Name.startsWith('INDAES') == true) {
                             
                     //Get the list of accounts where the found user is an account team member
                     List<AccountTeamMember> lstATM = [Select id, accountId FROM AccountTeamMember where userId =: objTriggerNew[0].OwnerId];
                    Set<Id> setATM = New Set<Id>();
                    FOR(AccountTeamMember ATM: lstATM){
                        setATM.add(ATM.accountId);
                    }
                    System.debug('Test = '+setATM.size());
                    List<Contact_Profile__c> lstConProfile = [Select Id, Name, Doctor_Segmentation__c FROM Contact_Profile__c WHERE Contact__r.AccountId IN : setATM];
                    System.debug('Contact.size() = '+lstConProfile.size()); 
                    noOfContactsOfSalesRep = lstConProfile.size();
                    IF(lstConProfile.size() > 0){
                        FOR(Contact_Profile__c CPP: lstConProfile){
                            IF(CPP.Doctor_Segmentation__c == 'A'){
                                noOfContactsOfSalesRepofA = noOfContactsOfSalesRepofA + 1;
                            }
                            IF(CPP.Doctor_Segmentation__c == 'B'){
                                noOfContactsOfSalesRepofB = noOfContactsOfSalesRepofB + 1;
                            }
                            IF(CPP.Doctor_Segmentation__c == 'C'){
                                noOfContactsOfSalesRepofC = noOfContactsOfSalesRepofC + 1;
                            }
                            IF(CPP.Doctor_Segmentation__c != 'A' && CPP.Doctor_Segmentation__c != 'B' && CPP.Doctor_Segmentation__c != 'C'){
                                noOfContactsOfSalesRepOthers = noOfContactsOfSalesRepOthers + 1;
                            }
                        }
                     }                     
                 
            }
            /* End Logic for Custom Report by Parag Sharma */
            System.debug('strProfile : '+strProfile);
            if (strProfile.contains('Service')){
                strProfile = 'Service';
            }else{
                strProfile = 'Sales';
            }            
            //For-loop: loops through each affected store visit record.
            for(Physician_Visit__c p : list_PhysicianVisit){
    
    
                /*
                 *  To update the call summary and effectiveness summary objects.
                 *
                 */
                if (p.Status__c=='Completed'){
                //Map of the unique value and the no. of actual calls for the day.
                Map<String, Integer> map_Unique_ActualCalls = new Map<String, Integer>(); 
                //Map of the unique value and the no. of planned calls for the day.
                Map<String, Integer> map_Unique_PlannedCalls = new Map<String, Integer>(); 
                //Map of the unique value and the no. of targetted calls for the day.
                Map<String, Integer> map_Unique_TragettedCalls = new Map<String, Integer>(); 
                
                //Map of the unique value and the no. of actual calls for the day.
                Map<String, Integer> map_UniqueEffectiveness_ActualCalls = new Map<String, Integer>(); 
                //Map of the unique value and objective for the day.
                Map<String, Integer> map_UniqueEffectiveness_Obj = new Map<String, Integer>(); 
                
                 /* Start Logic for Custom Report by Parag Sharma */                 
                 Map<String, Integer> map_Unique_PlannedCallsofA = new Map<String, Integer>();
                 Map<String, Integer> map_Unique_PlannedCallsofB = new Map<String, Integer>();
                 Map<String, Integer> map_Unique_PlannedCallsofC = new Map<String, Integer>();
                 Map<String, Integer> map_Unique_PlannedCallsOthers = new Map<String, Integer>();
                 //Map of the unique value and the no. of Unplanned calls for the day.
                // Map<String, Integer> map_Unique_UnPlannedCalls = new Map<String, Integer>(); 
                Map<String, Integer> map_Unique_UnPlannedCallsofA = new Map<String, Integer>(); 
                Map<String, Integer> map_Unique_UnPlannedCallsofB = new Map<String, Integer>(); 
                Map<String, Integer> map_Unique_UnPlannedCallsofC = new Map<String, Integer>(); 
                Map<String, Integer> map_Unique_UnPlannedCallsOthers = new Map<String, Integer>();                  
                 //Map of the unique value and the no. of targetted calls for the day.
                 
                 Map<String, Integer> map_Unique_TragettedCallsofA = new Map<String, Integer>(); 
                 Map<String, Integer> map_Unique_TragettedCallsofB = new Map<String, Integer>(); 
                 Map<String, Integer> map_Unique_TragettedCallsofC = new Map<String, Integer>(); 
                 Map<String, Integer> map_Unique_TragettedCallsOthers = new Map<String, Integer>(); 
                 /* End Logic for Custom Report by Parag Sharma */
                
                //List of Physician visits by the rep for the visit date.
                List<Physician_Visit__c> list_PhysicianVisitsForDay = [Select Segmentation__c,Doctor_Segmentation__c,Time_Spent_In_OT__c, Planned_Call__c, Status__c, Call_Objective__c, Call_Objective_Achieved__c from Physician_Visit__c where Activity_Date__c = :p.Activity_Date__c and OwnerId = :p.OwnerId];
                //Added by Neha Jain for summation of OT Hours 
                calcSumOTHours = 0;        
                //for-loop: to calculate the no. of actual, planned and targetted calls.
                for (Physician_Visit__c pv : list_PhysicianVisitsForDay){
                    IF(objUser.Profile.Name.startsWith('INDSU') == true || objUser.Profile.Name.startsWith('THASU') == true || objUser.Profile.Name.startsWith('INDAES') == true) {
                        //sum of OT hrs for each PV
                        calcSumOTHours += pv.Time_Spent_In_OT__c; 
                    }
                    //Unique value to represent a call summary record.
                    String strUnique = String.valueOf(p.OwnerId)+String.valueOf(p.Activity_Date__c);
    
                    //Unique value to represent a effectiveness summary record.
                    String strUniqueEffectiveness = String.valueOf(pv.Segmentation__c)+String.valueOf(p.OwnerId)+String.valueOf(p.Activity_Date__c);
                    
                    //If the status is completed.
                    if (pv.Status__c=='Completed'){
                    /* Start Logic for Custom Report by Parag Sharma */
                    IF(objUser.Profile.Name.startsWith('INDSU') == true || objUser.Profile.Name.startsWith('THASU') == true || objUser.Profile.Name.startsWith('INDAES') == true) {
                        IF(pv.Planned_Call__c == True && pv.Doctor_Segmentation__c == 'A'){
                              Integer intTargettedCallsofA = 1;
                              if (map_Unique_TragettedCallsofA.containsKey(strUnique)){
                                intTargettedCallsofA = map_Unique_TragettedCallsofA.get(strUnique) + 1;
                              }
                              //System.debug('unique='+strUnique+',intTargettedCallsofA'+intTargettedCallsofA);
                              map_Unique_TragettedCallsofA.put(strUnique, intTargettedCallsofA);
                        }
                        IF(pv.Planned_Call__c == True && pv.Doctor_Segmentation__c == 'B'){     
                              Integer intTargettedCallsofB = 1;
                              if (map_Unique_TragettedCallsofB.containsKey(strUnique)){
                                intTargettedCallsofB = map_Unique_TragettedCallsofB.get(strUnique) + 1;
                              }
                              //System.debug('unique='+strUnique+',intTargettedCallsofB'+intTargettedCallsofB);
                              map_Unique_TragettedCallsofB.put(strUnique, intTargettedCallsofB);
                        }
                        IF(pv.Planned_Call__c == True && pv.Doctor_Segmentation__c == 'C'){     
                              Integer intTargettedCallsofC = 1;
                              if (map_Unique_TragettedCallsofC.containsKey(strUnique)){
                                intTargettedCallsofC = map_Unique_TragettedCallsofC.get(strUnique) + 1;
                              }
                              //System.debug('unique='+strUnique+',intTargettedCallsofC'+intTargettedCallsofC);
                              map_Unique_TragettedCallsofC.put(strUnique, intTargettedCallsofC);
                        }
                        if (pv.Planned_Call__c == True && pv.Doctor_Segmentation__c != 'A'  && pv.Doctor_Segmentation__c != 'B' && pv.Doctor_Segmentation__c != 'C'){
                              Integer intTargettedCallsOthers = 1;
                              if (map_Unique_TragettedCallsOthers.containsKey(strUnique)){
                                intTargettedCallsOthers = map_Unique_TragettedCallsOthers.get(strUnique) + 1;
                              }
                              //System.debug('unique='+strUnique+',intTargettedCallsOthers'+intTargettedCallsOthers);
                              map_Unique_TragettedCallsOthers.put(strUnique, intTargettedCallsOthers);
                        }
                    }
                    /* End Logic for Custom Report by Parag Sharma */
                    Integer intActualCalls = 1;                    
                    if (map_Unique_ActualCalls.containsKey(strUnique)){
                        intActualCalls = map_Unique_ActualCalls.get(strUnique) + 1;                        
                    }
                    System.debug('unique='+strUnique+',intActualCalls'+intActualCalls);                 
                    map_Unique_ActualCalls.put(strUnique, intActualCalls);
                    //If the visit is a planned one.
                    if (pv.Planned_Call__c == True){
                        Integer intTargettedCalls = 1;
                        if (map_Unique_TragettedCalls.containsKey(strUnique)){
                        intTargettedCalls = map_Unique_TragettedCalls.get(strUnique) + 1;
                        }
                        System.debug('unique='+strUnique+',intTargettedCalls'+intTargettedCalls);
                        map_Unique_TragettedCalls.put(strUnique, intTargettedCalls);
                    }
                    
                    if (map_UniqueEffectiveness_ActualCalls.containsKey(strUniqueEffectiveness)){
                        intActualCalls = map_UniqueEffectiveness_ActualCalls.get(strUniqueEffectiveness) + 1;
                    }
                    System.debug('unique='+strUniqueEffectiveness+',intActualCalls'+intActualCalls);
                    map_UniqueEffectiveness_ActualCalls.put(strUniqueEffectiveness, intActualCalls);
    
                    //If objective is achieved.
                    if (pv.Call_Objective_Achieved__c==TRUE){
                        Integer intObj = 1;
                        if (map_UniqueEffectiveness_Obj.containsKey(strUniqueEffectiveness)){
                        intObj = map_UniqueEffectiveness_Obj.get(strUniqueEffectiveness) + 1;
                        }
                        System.debug('unique='+strUniqueEffectiveness+',intObj'+intObj);
                        map_UniqueEffectiveness_Obj.put(strUniqueEffectiveness, intObj);
                    }                       
                    } 
                    //If the visit is a planned one.
                    if (pv.Planned_Call__c == True) {
                    Integer intPlannedCalls = 1;
                    if (map_Unique_PlannedCalls.containsKey(strUnique)){
                        intPlannedCalls = map_Unique_PlannedCalls.get(strUnique) + 1;
                    }
                    System.debug('unique='+strUnique+',intPlannedCalls'+intPlannedCalls);
                    map_Unique_PlannedCalls.put(strUnique, intPlannedCalls);
                    }
                     /* Start Logic for Custom Report by Parag Sharma */
                      IF(objUser.Profile.Name.startsWith('INDSU') == true || objUser.Profile.Name.startsWith('THASU') == true || objUser.Profile.Name.startsWith('INDAES') == true) {
                        
                              if (pv.Planned_Call__c == True && pv.Doctor_Segmentation__c == 'A'){
                                  Integer intPlannedCallsofA = 1;
                                  if (map_Unique_PlannedCallsofA.containsKey(strUnique)){
                                    intPlannedCallsofA = map_Unique_PlannedCallsofA.get(strUnique) + 1;
                                  }
                                  //System.debug('unique='+strUnique+',intPlannedCallsofA'+intPlannedCallsofA);
                                  map_Unique_PlannedCallsofA.put(strUnique, intPlannedCallsofA);
                              }
                              if (pv.Planned_Call__c == True && pv.Doctor_Segmentation__c == 'B'){
                                  Integer intPlannedCallsofB = 1;
                                  if (map_Unique_PlannedCallsofB.containsKey(strUnique)){
                                    intPlannedCallsofB = map_Unique_PlannedCallsofB.get(strUnique) + 1;
                                  }
                                  //System.debug('unique='+strUnique+',intPlannedCallsofB'+intPlannedCallsofB);
                                  map_Unique_PlannedCallsofB.put(strUnique, intPlannedCallsofB);
                              }
                              if (pv.Planned_Call__c == True && pv.Doctor_Segmentation__c == 'C'){
                                  Integer intPlannedCallsofC = 1;
                                  if (map_Unique_PlannedCallsofC.containsKey(strUnique)){
                                    intPlannedCallsofC = map_Unique_PlannedCallsofC.get(strUnique) + 1;
                                  }
                                  //System.debug('unique='+strUnique+',intPlannedCallsofC'+intPlannedCallsofC);
                                  map_Unique_PlannedCallsofC.put(strUnique, intPlannedCallsofC);
                              }
                              if (pv.Planned_Call__c == True && pv.Doctor_Segmentation__c != 'A'  && pv.Doctor_Segmentation__c != 'B' && pv.Doctor_Segmentation__c != 'C'){
                                  Integer intPlannedCallsOthers = 1;
                                  if (map_Unique_PlannedCallsOthers.containsKey(strUnique)){
                                    intPlannedCallsOthers = map_Unique_PlannedCallsOthers.get(strUnique) + 1;
                                  }
                                  //System.debug('unique='+strUnique+',intPlannedCallsOthers'+intPlannedCallsOthers);
                                  map_Unique_PlannedCallsOthers.put(strUnique, intPlannedCallsOthers);
                              }
                         
                      }
                      /* End Logic for Custom Report by Parag Sharma */
                      /* Start Logic for Custom Report by Parag Sharma */
                          IF(objUser.Profile.Name.startsWith('INDSU') == true || objUser.Profile.Name.startsWith('THASU') == true || objUser.Profile.Name.startsWith('INDAES') == true) {
                              if (pv.Planned_Call__c == false && pv.Doctor_Segmentation__c == 'A') {
                                Integer intUnPlannedCallsofA = 1;
                                if (map_Unique_UnPlannedCallsofA.containsKey(strUnique)){
                                  intUnPlannedCallsofA = map_Unique_UnPlannedCallsofA.get(strUnique) + 1;
                                }
                                //System.debug('unique='+strUnique+',intUnPlannedCallsofA'+intUnPlannedCallsofA);
                                map_Unique_UnPlannedCallsofA.put(strUnique, intUnPlannedCallsofA);
                              }
                              if (pv.Planned_Call__c == false && pv.Doctor_Segmentation__c == 'B') {
                                Integer intUnPlannedCallsofB = 1;
                                if (map_Unique_UnPlannedCallsofB.containsKey(strUnique)){
                                  intUnPlannedCallsofB = map_Unique_UnPlannedCallsofB.get(strUnique) + 1;
                                }
                                //System.debug('unique='+strUnique+',intUnPlannedCallsofB'+intUnPlannedCallsofB);
                                map_Unique_UnPlannedCallsofB.put(strUnique, intUnPlannedCallsofB);
                              }
                              if (pv.Planned_Call__c == false && pv.Doctor_Segmentation__c == 'C') {
                                Integer intUnPlannedCallsofC = 1;
                                if (map_Unique_UnPlannedCallsofC.containsKey(strUnique)){
                                  intUnPlannedCallsofC = map_Unique_UnPlannedCallsofC.get(strUnique) + 1;
                                }
                                //System.debug('unique='+strUnique+',intUnPlannedCallsofC'+intUnPlannedCallsofC);
                                map_Unique_UnPlannedCallsofC.put(strUnique, intUnPlannedCallsofC);
                              }
                              if (pv.Planned_Call__c == false && pv.Doctor_Segmentation__c != 'A' && pv.Doctor_Segmentation__c != 'B' && pv.Doctor_Segmentation__c != 'C') {
                                Integer intUnPlannedCallsOthers = 1;
                                if (map_Unique_UnPlannedCallsOthers.containsKey(strUnique)){
                                  intUnPlannedCallsOthers = map_Unique_UnPlannedCallsOthers.get(strUnique) + 1;
                                }
                                //System.debug('unique='+strUnique+',intUnPlannedCallsOthers'+intUnPlannedCallsOthers);
                                map_Unique_UnPlannedCallsOthers.put(strUnique, intUnPlannedCallsOthers);
                              } 
                          }
                          /* End Logic for Custom Report by Parag Sharma */
                }
            
                //Business_Day_or_not__c is '0' on Weekends and '1' on Weekdays
                Datetime dtmVisitDate = Datetime.newInstance(p.Activity_Date__c, Time.newInstance(0,0,0,0));
                String strWeekday = dtmVisitDate.format('E');
                Boolean blnBusinessDay = TRUE;
                
                
                if(strWeekday == 'Sat' || strWeekday == 'Sun'){                
                    if((objUser.UserRole.Name != null && objUser.UserRole.Name.contains('INDSU') && strWeekday == 'Sat') || (objUser.UserRole.Name != null && objUser.UserRole.Name.contains('INDAES') && strWeekday == 'Sat') || (objUser.UserRole.Name != null && objUser.UserRole.Name.contains('THASU') && strWeekday == 'Sat')){
                        blnBusinessDay = TRUE;
                        }
                    else{
                        blnBusinessDay = FALSE;
                        }
                 }
               System.debug('blnBusinessDay : '+blnBusinessDay); 
                //Set of the unique values for call summary.
                Set<String> list_Unique = new Set<String>();
                
                //Set of the unique values for effectiveness summary.
                Set<String> list_UniqueEffectiveness = new Set<String>();
    
                //for-loop: to create the call summary & effectiveness summary records.
                for (Physician_Visit__c pv : list_PhysicianVisitsForDay){
                    //Unique value to represent a call summary record.
                    String strUnique = String.valueOf(p.OwnerId)+String.valueOf(p.Activity_Date__c);
                    System.debug('Call Summary'+strUnique);
                    //Unique value to represent a effectiveness summary record.
                    String strUniqueEffectiveness = String.valueOf(pv.Segmentation__c)+String.valueOf(p.OwnerId)+String.valueOf(p.Activity_Date__c);
    
                    //To create the call summary record.
                    if (!list_Unique.contains(strUnique)) {
                    system.debug('***Neha --entering call Summary loop' + strUnique);
                    Call_Summary__c objCallSummary = new Call_Summary__c();                    
                    objCallSummary.Country__c = objUser.APAC_Country__c;
                    objCallSummary.RegionINDSU__c = objUser.APAC_Region__c;
                    objCallSummary.Area__c = objUser.APAC_Area__c;
                    objCallSummary.Date__c = p.Activity_Date__c;
                    objCallSummary.Business_Day_or_not__c = blnBusinessDay;
                    objCallSummary.Actual_Calls__c = (map_Unique_ActualCalls.containsKey(strUnique) ? map_Unique_ActualCalls.get(strUnique) : 0);
                    System.debug('CALL SUMMARY ACTUAL CALL'+objCallSummary.Actual_Calls__c);
                    objCallSummary.Planned_Calls__c = (map_Unique_PlannedCalls.containsKey(strUnique) ? map_Unique_PlannedCalls.get(strUnique) : 0);
                    objCallSummary.Targeted_Calls__c = (map_Unique_TragettedCalls.containsKey(strUnique) ? map_Unique_TragettedCalls.get(strUnique) : 0);
                    objCallSummary.Profile__c = strProfile;
                    objCallSummary.OwnerId = p.OwnerId;
                    objCallSummary.Unique__c = strUnique;                    
                    System.debug('objCallSummary : '+objCallSummary);
                    
                     /* Start Logic for Custom Report by Parag Sharma */
                            IF(objUser.Profile.Name.startsWith('INDSU') == true || objUser.Profile.Name.startsWith('THASU') == true || objUser.Profile.Name.startsWith('INDAES') == true) {
                                
                                objCallSummary.Planned_Calls_of_A__c = (map_Unique_PlannedCallsofA.containsKey(strUnique) ? map_Unique_PlannedCallsofA.get(strUnique) : 0);
                                objCallSummary.Planned_Calls_of_B__c = (map_Unique_PlannedCallsofB.containsKey(strUnique) ? map_Unique_PlannedCallsofB.get(strUnique) : 0);
                                objCallSummary.Planned_Calls_of_C__c = (map_Unique_PlannedCallsofC.containsKey(strUnique) ? map_Unique_PlannedCallsofC.get(strUnique) : 0);
                                objCallSummary.Planned_Calls_Others__c = (map_Unique_PlannedCallsOthers.containsKey(strUnique) ? map_Unique_PlannedCallsOthers.get(strUnique) : 0);
                                
                                objCallSummary.Unplanned_Calls_of_A__c = (map_Unique_UnPlannedCallsofA.containsKey(strUnique) ? map_Unique_UnPlannedCallsofA.get(strUnique) : 0);
                                objCallSummary.Unplanned_Calls_of_B__c = (map_Unique_UnPlannedCallsofB.containsKey(strUnique) ? map_Unique_UnPlannedCallsofB.get(strUnique) : 0);
                                objCallSummary.Unplanned_Calls_of_C__c = (map_Unique_UnPlannedCallsofC.containsKey(strUnique) ? map_Unique_UnPlannedCallsofC.get(strUnique) : 0);
                                objCallSummary.Unplanned_Calls_Others__c = (map_Unique_UnPlannedCallsOthers.containsKey(strUnique) ? map_Unique_UnPlannedCallsOthers.get(strUnique) : 0);
                                
                                objCallSummary.Targeted_Calls_of_A__c = (map_Unique_TragettedCallsofA.containsKey(strUnique) ? map_Unique_TragettedCallsofA.get(strUnique) : 0);
                                objCallSummary.Targeted_Calls_of_B__c = (map_Unique_TragettedCallsofB.containsKey(strUnique) ? map_Unique_TragettedCallsofB.get(strUnique) : 0);
                                objCallSummary.Targeted_Calls_of_C__c = (map_Unique_TragettedCallsofC.containsKey(strUnique) ? map_Unique_TragettedCallsofC.get(strUnique) : 0);
                                objCallSummary.Targeted_Calls_Others__c = (map_Unique_TragettedCallsOthers.containsKey(strUnique) ? map_Unique_TragettedCallsOthers.get(strUnique) : 0);
                            }
                            
                            objCallSummary.Total_Customers__c = noOfContactsOfSalesRep;
                            objCallSummary.OT_Hours__c = sumOTHours;
                            
                            IF(objUser.Profile.Name.startsWith('INDSU') == true || objUser.Profile.Name.startsWith('THASU') == true || objUser.Profile.Name.startsWith('INDAES') == true) {
                                //assign total OT Hours
                                objCallSummary.OT_Hours__c = calcSumOTHours ;
                                objCallSummary.Total_Customers_of_A__c = noOfContactsOfSalesRepofA;
                                objCallSummary.Total_Customers_of_B__c = noOfContactsOfSalesRepofB;
                                objCallSummary.Total_Customers_of_C__c = noOfContactsOfSalesRepofC;                            
                                objCallSummary.Total_Customers_of_Others__c = noOfContactsOfSalesRepOthers;
                            }
                            /* End Logic for Custom Report by Parag Sharma */

                    list_CallSummary.add(objCallSummary);
                    System.debug('list_CallSummary size : '+list_CallSummary.size());
                    System.debug('list_CallSummary : '+list_CallSummary);
                    list_Unique.add(strUnique);
                    System.debug('unique value='+strUnique+',actual='+objCallSummary.Actual_Calls__c+',planned='+objCallSummary.Planned_Calls__c+'targetted='+objCallSummary.Targeted_Calls__c);
                    }
    
                    system.debug('***list_UniqueEffectiveness.contains(strUniqueEffectiveness)--' + list_UniqueEffectiveness.contains(strUniqueEffectiveness) + '--' + list_UniqueEffectiveness);
                    //To create the effectiveness summary record.
                    if (!list_UniqueEffectiveness.contains(strUniqueEffectiveness)) {
                    system.debug('***Neha --entering effectiveness Summary loop' + strUnique);
                    Effectiveness_Summary__c objEffectSummary = new Effectiveness_Summary__c();
                    objEffectSummary.ABC_Classification__c = pv.Segmentation__c; 
                    objEffectSummary.OT_Hours__c = sumOTHours; 
                    IF(objUser.Profile.Name.startsWith('INDSU') == true || objUser.Profile.Name.startsWith('THASU') == true || objUser.Profile.Name.startsWith('INDAES') == true) {
                        //assign total OT Hours
                        objEffectSummary.OT_Hours__c = calcSumOTHours ;
                    }
                    System.debug('EFFECTIVE Summary OT Hours'+objEffectSummary.OT_Hours__c + '**sumOTHours**' + sumOTHours + '--calcSumOTHours ' + calcSumOTHours + '*** p.OwnerId--' +  p.OwnerId);                                      
                    objEffectSummary.Country__c = objUser.APAC_Country__c;
                    objEffectSummary.Region__c = objUser.APAC_Region__c;
                    objEffectSummary.Area__c = objUser.APAC_Area__c;                    
                    objEffectSummary.Date__c = p.Activity_Date__c;
                    objEffectSummary.Actual_Calls__c = (map_UniqueEffectiveness_ActualCalls.containsKey(strUniqueEffectiveness) ? map_UniqueEffectiveness_ActualCalls.get(strUniqueEffectiveness) : 0);
                    objEffectSummary.Objective_Met__c = (map_UniqueEffectiveness_Obj.containsKey(strUniqueEffectiveness) ? map_UniqueEffectiveness_Obj.get(strUniqueEffectiveness) : 0);
                    objEffectSummary.Profile__c = strProfile;
                    objEffectSummary.OwnerId = p.OwnerId;
                    objEffectSummary.Unique__c = strUniqueEffectiveness;
                    list_EffectivenessSummary.add(objEffectSummary);
                    list_UniqueEffectiveness.add(strUniqueEffectiveness);
                    //System.debug('unique value='+strUniqueEffectiveness+',actual='+objEffectSummary.Actual_Calls__c+',No_of_objective_1s_met__c='+objEffectSummary.No_of_objective_1s_met__c+'No_of_objective_2s_met__c='+objEffectSummary.No_of_objective_2s_met__c+'No_of_objective_3s_met__c='+objEffectSummary.No_of_objective_3s_met__c);
                    }
                }
                }
            }
            
            Set<Call_Summary__c> myset = new Set<Call_Summary__c>();
            List<Call_Summary__c> result = new List<Call_Summary__c>();
            myset.addAll(list_CallSummary);
        
            result.addAll(myset);        
            
            //To update the call summary.
            if (list_CallSummary.Size()>0){
               // Database.upsert(list_CallSummary,Call_Summary__c.Unique__c,false);
               Database.upsert(result,Call_Summary__c.Unique__c,false);
                System.debug('list_CallSummary upsert: '+list_CallSummary);
            }
    
            system.debug('****list_EffectivenessSummary--' + list_EffectivenessSummary);
            //To update the effectiveness summary.
            if (list_EffectivenessSummary.Size()>0){
                List<Database.upsertResult> uResults = Database.upsert(list_EffectivenessSummary,Effectiveness_Summary__c.Unique__c,false);
                System.debug('list_EffectivenessSummary upsert: '+list_EffectivenessSummary + '**result1--' + uResults);
                 for(Database.upsertResult result1:uResults) {
                     if (result1.isSuccess()) {
                          System.debug('*** -- success');
                     }
                  }
            }
        }
                
                catch(Exception e)
                {
                    Trigger.New[0].addError('Error occurred in Updating future Physician Visits - ' + e);
                }
            }   
        }
    }
    
  }//!kor  
    else{
 system.debug('Trigger Name:PhysicianVisit_AU_UpdateFutureVisits------> NO Need for KOR SOLTA Users');
    }
    
}