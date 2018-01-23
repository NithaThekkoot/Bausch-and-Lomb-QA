trigger callPlan_AU_CreatePhysicianVisits on Call_Plan__c (after update) {
    
    //Map of Store Visit Record Type Names and Ids.
    Map<String, Id> map_RecordTypeName_Id = new Map<String, Id>();
    List<String> list_cpMonths = new List<String>();
    Map<String,String> map_monthAndQuarter = new Map<String,String>();
    Map<String,Integer> map_monthAndmonthNum = new Map<String,Integer>();
    List<Integer> list_cpMonthsNum = new List<Integer>();
    List<Date> list_cpDate = new List<Date>();
    String strCurrentQuarter;   
    
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
    
   //check if user is KOREA SOLTA or not
  list<UserRole> lstroleName=[SELECT Id, Name FROM UserRole WHERE Id =: UserInfo.getUserRoleId() LIMIT 1];  
    if(lstroleName[0].Name.contains('KOR SOLTA')){ 
    
    
        
    //For-loop: queries the record type ids of the Store Visit object and populates the map.
    for (RecordType rt : [SELECT Id, Name FROM RecordType                                 
                                   WHERE SObjectType='Physician_Visit__c'] ) {
          map_RecordTypeName_Id.put(rt.Name, rt.Id);  
     system.debug('@@@@@@@@@@@@@@@Record type of Physician Visit----------->'+map_RecordTypeName_Id);                
    }
    
    for(Call_Plan__c cp : Trigger.new) {
        list_cpMonths.add(cp.Month__c);
    system.debug('@@@@@@@@@@@@@@@Call Plan Obj Months------------>'+list_cpMonths);
    }
    
    for(String str : list_cpMonths) {
        list_cpMonthsNum.add(map_monthAndmonthNum.get(str));
      system.debug('@@@@@@@@@Call Plan mnths Number------>'+list_cpMonthsNum);
    }
    
    for(Integer intMonth : list_cpMonthsNum) {
        Date dt = Date.newInstance(system.today().year(),intMonth,system.today().day());
        list_cpDate.add(dt);
    system.debug('@@@@@@@@@@@@Call plan obj Date---------->'+list_cpDate);
    }
    /* **************************************************************************
    No USe of Utility class
    ClsUtilRBD objUtilRBD = new ClsUtilRBD();
    String strMonth = objUtilRBD.getMonth(list_cpDate[0]);    
    
    strCurrentQuarter = map_monthAndQuarter.get(strMonth);
  ********************************************************************************* */  
    
  //List of store visits to create.
  List<Physician_Visit__c> list_StoreVisit = new List<Physician_Visit__c>();
  
  //Proceed only if the plan is approved.
  
  for(Call_Plan__c cp : [Select Id, OwnerId, Owner.Profile.Name, Month__c, Year__c from Call_Plan__c where Id in :Trigger.new and Status__c='Approved'])
  {
   //added debug sanjib
      system.debug('@@@@@@@@@@@@@@@@@@@@@list_CallPlan  only Approved list '+cp ); 
    //Getting the executive's country.
    String strRole = [Select UserRole.Name from User where Id=:cp.OwnerId].UserRole.Name;
    system.debug('@@@@@@@@@@@@@user role------------>'+strRole );
    
    if (strRole.startsWith('KOR SOLTA')){
        strRole = 'KOR SOLTA';
    }
   
    
    //Getting the record type and role.
    String strRecordType = '';
    if (cp.Owner.Profile.Name.contains('KOR SOLTA Sales Rep')){
      strRecordType = 'KORSOLTA Sales Planned';
      strRole = strRole + 'Sales Rep';
      system.debug('@@@@@@@@@@@@@@@@@@@@@@@@YEs am here am rtpe is--------------->'+strRecordType );
    }else if (cp.Owner.Profile.Name.contains('KOR SOLTA Engineer')){
      strRecordType = 'KORSOLTA Service Planned';
      strRole = strRole + 'Engineer';
       system.debug('@@@@@@@@@@@@@@@@@@@@@@@@YEs am here am rtpe is--------------->'+strRecordType );
       
    }
    
 
    
    //Getting all the accounts involved.
    Set<Id> set_StoreId = new Set<Id>();
    List<Call_Plan_Detail__c> list_CallPlanDetail = [Select Account__c from Call_Plan_Detail__c where Call_Plan__c = :cp.Id AND (Account__c !='' OR Account__c !=null)];
     
      system.debug('@@@@@@@@@@@@@@@@@@@@list_CallPlanDetail---------------->'+list_CallPlanDetail );
    for (Call_Plan_Detail__c cpd:list_CallPlanDetail){     
      
      set_StoreId.add(cpd.Account__c);     
      
    }
    
    //Getting the classification and channel of all stores.
    Map<Id, String> map_AccountId_Class = new Map<Id, String>();
    system.debug('storeId size: '+set_StoreId.size());
    if(set_StoreId.size()> 0){
    for (Account_Profile__c ap:[Select Account__c, DASRX_ABC_Classification__c, Channel__c from Account_Profile__c where (Account__c !='' OR Account__c !=null) AND Account__c in :set_StoreId]){
      map_AccountId_Class.put(ap.Account__c, ap.DASRX_ABC_Classification__c + ap.Channel__c + strRole);
   system.debug('@@@@@@@@@@@@@@@@@@@@Account profile list------------------>'+map_AccountId_Class);
      
      }
    }

       
    //Looping through each call plan detail to create store visit for.
    //for(Call_Plan_Detail__c cpd : [SELECT Id, isFinished__c, Account__c, Date__c FROM Call_Plan_Detail__c WHERE Call_Plan__c = :cp.Id AND SpecialActivity__c = null AND (Account__c !='' OR Account__c !=null)])
    for(Call_Plan_Detail__c cpd : [SELECT Id, isFinished__c, Account__c, Date__c FROM Call_Plan_Detail__c WHERE Call_Plan__c = :cp.Id  AND (Account__c !='' OR Account__c !=null)]){      
      String strUnique = map_AccountId_Class.get(cpd.Account__c);
    system.debug('@@@@@@@@@@@@@@@@map_AccountId_Class strUnique----------------->'+strUnique );
    system.debug('@@@@@@@@@@@@@@@@@@@isFinished T or F ----------------->'+cpd.isFinished__c);
      Physician_Visit__c objStoreVisit = new Physician_Visit__c();
      objStoreVisit.OwnerId = cp.OwnerId;
      objStoreVisit.Planned_Call__c= True;    
      objStoreVisit.RecordTypeId = map_RecordTypeName_Id.get(strRecordType);
      String stat = 'Open';
      if (cpd.isFinished__c) {
        stat = 'Completed';
        Datetime cpdatetime = Datetime.newInstance(cpd.Date__c.year(), cpd.Date__c.month(), cpd.Date__c.day(), 0, 0, 0);
        objStoreVisit.Start_Time__c = cpdatetime;
        objStoreVisit.End_Time__c   = cpdatetime;
        system.debug('@@@@@@@@@@@@@@@@@@@@@@@START TIME------------->'+objStoreVisit.Start_Time__c);
        system.debug('@@@@@@@@@@@@@@@@@@@@@@@END TIME------------->'+objStoreVisit.End_Time__c);
      }
      objStoreVisit.CallPlanId__c = cp.Id;
      objStoreVisit.CallPlanDetailId__c = cpd.Id;

      objStoreVisit.Status__c = stat;
      objStoreVisit.Hospital__c = cpd.Account__c;
      objStoreVisit.Visit_Date__c = cpd.Date__c;
  list_StoreVisit.add(objStoreVisit);
    }
  }
  insert list_StoreVisit; 
  }//KOR USER
  else{
 system.debug('Trigger Name:callPlan_AU_CreatePhysicianVisits on Call_Plan__c:User is Other Than KOR SOLTA'); 
  } 
  }//trigger