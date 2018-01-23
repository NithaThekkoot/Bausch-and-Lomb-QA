/*
* 
*  APAC VC trigger to create a event for the executive making the visit and update the reference in the field Activity Id.
*  Also updates the visit with the objectives. And updates the visit with the Account Profile and Store Info references.
*  
*  Test class Name : Test_storeVisit_AI_CreateEvent 
* 
*  Author              |Author-Email                                      |Date        |Comment
*  --------------------|--------------------------------------------------|------------|----------------------------------------------------
* 
*/

trigger storeVisit_AI_CreateEvent on Physician_Visit__c(after insert) {
   
  //check if user is KOREA SOLTA or not
  //list<UserRole> lstroleName=[SELECT Id, Name FROM UserRole WHERE Id =: UserInfo.getUserRoleId() LIMIT 1]; 
   
   string lstroleName = UserInfo.getLocale();
    if(lstroleName.contains('ko_KR')){ 
    if ((Trigger.isAfter && Trigger.isInsert) && (!Class_to_prevent_trigger_recursively.hasAlreadyFiredAfterInsertStoreVisitTrigger())) {  
     //List of events to create.
      list<Event> list_EventToCreate = new list<Event>();
      Map<String,String> map_monthAndQuarter = new Map<String,String>();
      Map<String,Integer> map_monthAndmonthNum = new Map<String,Integer>();   
      List<String> list_storeId = new List<String>();
      List<String> list_storevisitId = new List<String>();
      List<Physician_Visit__c> list_storevisitToInsert = new List<Physician_Visit__c>();
      List<Physician_Visit__c> list_storevisitNew = new List<Physician_Visit__c>();
      Physician_Visit__c objStoreVisitLatest =  new Physician_Visit__c();
      String strCurrentQuarter;
      String testMonth;
      
          map_monthAndQuarter.put('Jan','Q1');
          map_monthAndQuarter.put('Feb','Q1');
          map_monthAndQuarter.put('Mar','Q1');
          map_monthAndQuarter.put('Apr','Q2');
          map_monthAndQuarter.put('May','Q2');
          map_monthAndQuarter.put('Jun','Q2');
          map_monthAndQuarter.put('Jul','Q3');
          map_monthAndQuarter.put('Aug','Q3');
          map_monthAndQuarter.put('Sep','Q3');
          map_monthAndQuarter.put('Oct','Q4');
          map_monthAndQuarter.put('Nov','Q4');
          map_monthAndQuarter.put('Dec','Q4');   
          
                 
          
          
          map_monthAndmonthNum.put('Jan',1);
          map_monthAndmonthNum.put('Feb',2);
          map_monthAndmonthNum.put('Mar',3);
          map_monthAndmonthNum.put('Apr',4);
          map_monthAndmonthNum.put('May',5);
          map_monthAndmonthNum.put('Jun',6);
          map_monthAndmonthNum.put('Jul',7);
          map_monthAndmonthNum.put('Aug',8);
          map_monthAndmonthNum.put('Sep',9);
          map_monthAndmonthNum.put('Oct',10);
          map_monthAndmonthNum.put('Nov',11);
          map_monthAndmonthNum.put('Dec',12);
      
          String strOwnerrole = '';        
             
          //Map of account Id and call objetcive from Account profile.
          Map<Id, String> map_AccountId_callobjective_1 = new Map<Id, String>();
          Map<Id, String> map_AccountId_callobjective_2 = new Map<Id, String>();
          Map<Id, String> map_AccountId_callobjective_3 = new Map<Id, String>();
          Map<Id, String> map_AccountId_callobjective_4 = new Map<Id, String>();
          Map<Id, String> map_AccountId_callobjective_5 = new Map<Id, String>();
          
          
      if (Trigger.isAfter && Trigger.isInsert) {
          
          for(Physician_Visit__c svNew : Trigger.new) {
              list_storevisitId.add(svNew.Id);
          }
          System.debug('list_storevisitId : ' + list_storevisitId);
          
          list_storevisitNew = [SELECT Id, OwnerId,Contact__c,Start_Time__c,End_Time__c,Owner.UserRole.Name,Enter_Time__c,  
                                Visit_Date__c,Planned_Call__c, recordType.Name, Hospital__c,Status__c,Account_Profile__c,
                                Activity_Date__c,With_Manager__c,Session__c,Activity_Id__c,Call_Type__c,Call_Duration_Mns__c,CallPlanId__c,CallPlanDetailId__c                                                 
                                FROM Physician_Visit__c WHERE Id in :list_storevisitId]; 
           system.debug('Tarunlist_storevisitNew ' +list_storevisitNew.size());
          
          //Proceed only if the visit is unplanned  
           for (Physician_Visit__c sv:list_storevisitNew){   
              //if (sv.Planned_Call__c==false){
              system.debug('Unplannedsv.Visit_Date__c ' +sv.Visit_Date__c);
                                   
                  list_storeId.add(sv.Hospital__c);               
           
                  //Querying the list of store visits belonging to the same store and taking the recently visited one.
                  List<Physician_Visit__c> list_StoreVisit = [SELECT Id, OwnerId,Contact__c,Start_Time__c,End_Time__c,Owner.UserRole.Name,Enter_Time__c,  
                                Visit_Date__c,Planned_Call__c, recordType.Name, Hospital__c,Status__c,Account_Profile__c,
                                Activity_Date__c,With_Manager__c,Session__c,Activity_Id__c,Call_Type__c,Call_Duration_Mns__c,CallPlanId__c, CallPlanDetailId__c                                                
                                FROM Physician_Visit__c WHERE Hospital__c  in :list_storeId Order By Visit_Date__c DESC];
                             
                  
                  list_storevisitToInsert.add(sv);                
             // }
          }    
          
                    //Set of account Ids.
          Set<Id> set_AccountId = new Set<Id>();
  
          
          //Gets the recordtype id for the store visit event record type.
          recordType[] objRecordType = [select Id from recordType where sObjectType = 'Event' and Name = 'APACSU'];
          
          //map of the Store Visit record id and the corresponding event id.
          Map<Id, Id> map_StoreVisitId_EventId = new Map<Id, Id>();
  
          //Proceed only if the Store Visit Event record type is present.
          if(objRecordType.size()>0){
              //Set of affected record ids.
              Set<Id> set_StoreVisitId = new Set<Id>();
              
              //For-loop: loop through each record and create a event.
              for(Physician_Visit__c sv : list_storevisitNew){
                  //Proceed only if the record type is one of APAVC record types.
     /*based on record type event not created once manager approved */
     /* create event only for planned */
 //if(sv.recordType.name=='KORSOLTA Sales Planned' || sv.recordType.name=='KORSOLTA Sales UnPlanned' || sv.recordType.name=='KORSOLTA Service Planned' || sv.recordType.name=='KORSOLTA Service UnPlanned'){
 if(sv.recordType.name=='KORSOLTA Sales Planned' || sv.recordType.name=='KORSOLTA Service Planned' ){
                 
                      Event objEvent = new Event();
                      objEvent.OwnerId = sv.ownerId;
                      objEvent.whatId = sv.Hospital__c;
                      objEvent.WhoId = sv.Contact__c;
                      if(sv.Start_Time__c != Null && sv.End_Time__c != Null){
                          objEvent.startDateTime = sv.Start_Time__c;
                          objEvent.EndDateTIme = sv.End_Time__c;
                      }
                      
                      objEvent.IsAllDayEvent = true;                      
                      objEvent.subject = 'Outlet Visit';
                      objEvent.ActivityDate = sv.Visit_Date__c;
                      objEvent.recordTypeId = objRecordType[0].Id;
                      objEvent.Type = 'Meeting';
                      objEvent.Reference_Id__c = sv.Id;
                      objEvent.CallPlanId__c = sv.CallPlanId__c;
                      objEvent.CallPlanDetailId__c = sv.CallPlanDetailId__c;
                      list_EventToCreate.add(objEvent);
                      set_StoreVisitId.add(sv.Id);
                      set_AccountId.add(sv.Hospital__c);
                  }
              }
              //To create the events.
              if(list_EventToCreate.size()>0){
                  
                  try{
                  Database.SaveResult[] dbResults = Database.insert(list_EventToCreate);
                  
                  system.debug('@@@@@@@@@@@@@@@@@Store vist EVENT Create Trigger--------------->'+dbResults );
              
                  //For-loop: get the event ids just created and populate the map.
                  Integer intCounter=0;
                  for (Database.SaveResult dbResult:dbResults){
                      Event objEvent = list_EventToCreate.get(intCounter);
                      //map_StoreVisitId_EventId.put(objEvent.Reference_Id__c,dbResult.getId());
                      intCounter++;
                  }
                  }catch(Exception e){
                      System.debug('Stack Trace >>> ' + e.getStackTraceString());
                  }                 
                  
              }
          }
          
           
        //Kandarp Shah | 20-Sep-13 | Changes in Call objective - End
         
          //Map of StoreVisit Id and month.
          Map<Id, String> map_StoreVisitId_Month = new Map<Id, String>();
  
          //Map of StoreVisit Id and year.
          Map<Id, String> map_StoreVisitId_Year = new Map<Id, String>();
  
          //Map of StoreVisit Id and role.
          Map<Id, String> map_StoreVisitId_Role = new Map<Id, String>();
                  
          //If there is any unplanned call.
          boolean blnUnplannedCallExists = false;        
  
          //For-loop: loop through each record and get the list of roles.
          for(Physician_Visit__c sv : list_storevisitNew){
              //Proceed only if the record type is one of APACSU record types.
             
        if(sv.recordType.name=='KORSOLTA Sales Planned' || sv.recordType.name=='KORSOLTA Sales UnPlanned' || sv.recordType.name=='KORSOLTA Service Planned' || sv.recordType.name=='KORSOLTA Service UnPlanned'||sv.recordType.name=='APACSU Sales Planned'){
                   
                  //Getting the executive's country.
                  String strCountry = sv.Owner.UserRole.Name;
                  strOwnerrole = sv.Owner.UserRole.Name;
                  if (strCountry==null) strCountry = '';
                  if (strCountry.startsWith('KOR SOLTA')){
                      strCountry = 'KOR SOLTA ';
                  }
  
                  //Get the executive role 
                  String strRole;
                  if (sv.RecordType.Name.contains('Sales')){
                  
                      strRole = strCountry + 'Sales Rep';
                  }else{
                      strRole = strCountry + 'Service Rep';
                  }
                  map_StoreVisitId_Role.put(sv.Id, strRole);                                    
                  
                  blnUnplannedCallExists=true;
                  
              }
          }
          
          //To fetch the objectives and map them against unique
          Map<String, String> map_Unique_Objective = new Map<String, String>();
         
          
           
          
          
          //To update back the event id in the Store Visit records. And to set the account profile reference. And to set the objectives
          for (Physician_Visit__c objStoreVisit : list_storevisitNew){
              //To set the Event reference.
              objStoreVisit.Activity_Id__c = map_StoreVisitId_EventId.get(objStoreVisit.Id);
              
              //-----Personal Objective added by sanjib mahanta--------
              String strRoleInd = objStoreVisit.Owner.UserRole.Name;                  
              if (strRoleInd.startsWith('APACSU')){                
              Id id = objStoreVisit.Hospital__c ;                  
              Boolean isActive = false;  
             
              }
              
                  //Get the month
                  String strMonth = map_StoreVisitId_Month.get(objStoreVisit.Id);
                  //Get the year
                  String strYear = map_StoreVisitId_Year.get(objStoreVisit.Id);
                      
                  //Get the executive role 
                  String strRole = map_StoreVisitId_Role.get(objStoreVisit.Id);
                  
                 
                  
            //  }
          }
          
          update list_storevisitNew;
      }
      if(list_storevisitToInsert.size()>0)
              update list_storevisitToInsert;
      Class_to_prevent_trigger_recursively.setAlreadyFiredAfterInsertStoreVisitTrigger();        
    }
  }//KOR
  else{
  system.debug('Trigger Name:storeVisit_AI_CreateEvent on Physician_Visit__c:----->No Need for other than KOR SOLTA USers');
  }
    
}//trigger