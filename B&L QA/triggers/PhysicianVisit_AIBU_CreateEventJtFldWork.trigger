/**
    * 
    * This trigger creates a new Event. On update it will also create the Joint field work record if the objective is met
    * 
    * Author              |Author-Email                             |Date        |Comment
    * --------------------|---------------------------------------- |------------|----------------------------------------------------
    * Arun David          |arun.david@listertechnologies.com        |10.03.2010  |First Draft
    * Balaji Prabhakaran  |balaji.prabakaran@listertechnologies.com |16.03.2010  |Update - Changing the owner of Joint Field Work to be as same as the owner of Physician Visit.
    * Balaji Prabhakaran  |balaji.prabakaran@listertechnologies.com |16.03.2010  |Update - Update Time_Spent_del of Joint Field Work with the value from Time_Spent of Physician Visit.
    * Harvin              |harvin.vincent@listertechnologies.com    |24.03.2010  |Update - update Sales_Service_Executive__c filed with the Physician visit owner field.
    * Ramsrinivas         |ramsrinivas.rajagopalan@listertechnologies.com    |11.05.2010  |Update - Account profile id.
    * Yash Agarwal        |yash.agarwal@listertechnologies.com      |21.05.2010 | Update - add is not null condition on line 78
    * Sourav Mitra        |sourav.mitra@listertechnologies.com      |01.09.2010 |Changes to incorporate China
    * Harvin              |harvin.vincent@listertechnologies.com    |05.10.2010  |Modified for Too many query rows.
    *Saranya Sivakumar    |saranya.sivakumar@listertechnologies.com |01.11.2010  |Added Booleans to restrict recursive firing of triggers
    *Sanjib Mahanta       |sanjib.mahanta@bausch.com                |16.11.2011  |Updated the trigger to restrict the Physician Visit Update.  
    *Rajesh Sriramulu     |rajesh.sriramulu@rishabhsoft.com            |28.08.2012  |Added to update the Account in Event when created 
    *Venkateswara Reddy   |venkateswara.reddy2@bausch.com           |25.11.2015   |Added code for Checking if the user is KOR SOLTA or not
    */
trigger PhysicianVisit_AIBU_CreateEventJtFldWork on Physician_Visit__c (after Insert, after Update) 
{    
    
    /*************************************************************************
    * Variables and Properties
    *************************************************************************/
    list<Event> list_EventToCreate = new list<Event>();    
    list<Event>  list_EventToUpdate= new list<Event>();     
    list<Joint_Field_Work__c> list_JtWorkToCreate = new list<Joint_Field_Work__c>();
    list<Physician_Visit__c> list_VisitToUpdate = new list<Physician_Visit__c>();
    set<Id> set_RepIds = new set<Id>();
    map<Id,Id> map_userManager = new map<Id,Id>();
    ClsPhysicanVisit.getPhysicanVisitRecordTypes();
//check if user is other than KOREA SOLTA or not
  //list<UserRole> lstroleName=[SELECT Id, Name FROM UserRole WHERE Id =: UserInfo.getUserRoleId() LIMIT 1];  
   string lstroleName = UserInfo.getLocale();
    if(!lstroleName.contains('ko_KR')){      

    if(Trigger.isInsert)
    {
        //Set of account Ids.
        Set<Id> set_AccountId = new Set<Id>();
        Map<String,Id> map_RecType = new Map<String,Id>();
        for (String key : ClsPhysicanVisit.map_staticRecordType.keySet()) {
            if (key == 'Event-INDSU' || key == 'Event-APACSU') {
                map_RecType.put(key.substring((key.indexOf('-')) + 1),ClsPhysicanVisit.map_staticRecordType.get(key));
            }
        }
        
        //recordType[] oRecType = [SELECT Id from recordType where sobjecttype = 'Event' AND (Name = 'INDSU' OR Name = 'APACSU') ORDER BY Name];
        /*for(RecordType oRec : [SELECT Id,Name from recordType where sobjecttype = 'Event' AND (Name = 'INDSU' OR Name = 'APACSU')])
        {
            map_RecType.put(oRec.Name,oRec.Id);
        }*/
        List<Physician_Visit__c> list_PhysicianVisit = new List<Physician_Visit__c>();
        
        System.debug('Trigger.New: '+Trigger.New);
        
        if(map_RecType.keySet().size() > 0)
        {
            list_PhysicianVisit = [SELECT
                                          Id,
                                          Activity_Date__c,     
                                          recordType.Name,                                           
                                          OwnerId,  
                                          Physician__c,
                                          Hospital__c,
                                          Start_Time__c,
                                          End_Time__c,
                                          Account_ID__c, 
                                          Account_Profile__c,                                                                               
                                          Session__c,
                                          Physician__r.AccountID   //Added by Rajesh Sriramulu 
                                          
                                    FROM
                                          Physician_Visit__c
                                    WHERE
                                          Id IN :Trigger.New];                                           
                                  
             system.debug('list_PhysicianVisit :' + list_PhysicianVisit );
            //for(Physician_Visit__c p : [select Id, Activity_Date__c, recordType.Name, Planned_Call__c, OwnerId, Physician__c, Start_Time__c, End_Time__c from Physician_Visit__c where id in :Trigger.New])
            
            for(Physician_Visit__c p : list_PhysicianVisit)
            {
                if(p.recordType.name=='INDSU Sales Planned' || p.recordType.name=='INDSU Sales Unplanned' 
                    || p.recordType.name =='INDSU Service Planned' || p.recordType.name=='INDSU Service Unplanned'                    
                    || p.recordType.name =='APACSU Sales Planned' || p.recordType.name=='APACSU Sales Unplanned')
                {                
                    Event oEvt = new Event();
                    oEvt.OwnerId = p.ownerId;
                    oEvt.whoId = p.Physician__c;                     
                    oEvt.whatid= p.Physician__r.AccountID; //Added by Rajesh Sriramulu 
                    system.debug('oEvt.whatid:' + oEvt.whatid);
                    if(p.Start_Time__c != Null && p.End_Time__c != Null)
                    {
                        oEvt.startDateTime = p.Start_Time__c;
                        oEvt.EndDateTIme = p.End_Time__c;
                    }
                    /* Mouse Comment
                    else if(p.Session__c != 'AM') {
                        oEvt.StartDateTime = Datetime.newInstanceGmt(p.Activity_Date__c, Time.newInstance(09,00, 0, 0)).addHours(-8);
                        oEvt.EndDateTIme = Datetime.newInstanceGmt(p.Activity_Date__c, Time.newInstance(13,00, 0, 0)).addHours(-8);
                    }
                    
                    else if(p.Session__c != 'PM') {
                        oEvt.StartDateTime = Datetime.newInstanceGmt(p.Activity_Date__c, Time.newInstance(12,00, 0, 0)).addHours(-8);
                        oEvt.EndDateTIme = Datetime.newInstanceGmt(p.Activity_Date__c, Time.newInstance(18,00, 0, 0)).addHours(-8);
                    }
                    */
                    else {
                        oEvt.IsAllDayEvent = true;
                    }
                    oEvt.subject = 'Physician Visit';
                    oEvt.ActivityDate = p.Activity_Date__c;
                    if(p.recordType.name.startsWith('INDSU'))
                        oEvt.recordTypeId = map_RecType.get('INDSU');                     
                    else if(p.recordType.name.startsWith('APACSU'))
                        oEvt.recordTypeId = map_RecType.get('APACSU');                       
                    oEvt.Type = 'Meeting';
                    oEvt.Physician_Visit_Id__c = p.Id;
                    list_EventToCreate.add(oEvt);
                }
            }

            if(list_EventToCreate.size() > 0)
                insert list_EventToCreate;
        }
        System.Debug('$$$$$$$$ = list_EventToCreate = ' + list_EventToCreate);
        if (list_PhysicianVisit.size() == 0) {
            list_PhysicianVisit = [select Id, OwnerId, Account_ID__c, Account_Profile__c from Physician_Visit__c where id in :Trigger.New ];
        }
        //List<Physician_Visit__c> list_PhysicianVisit = [select Id, OwnerId, Account_ID__c, Account_Profile__c from Physician_Visit__c where id in :Trigger.New];

           //Map of account Id and account profile Ids.
            Map<Id, Account_Profile__c> map_AccountId_AccountProfile = new Map<Id, Account_Profile__c>();
       
        for(Physician_Visit__c pv : list_PhysicianVisit){
                    set_AccountId.add(pv.Account_ID__c);
            }
            System.debug('set_AccountId: '+set_AccountId);
        for(Account_Profile__c ap:[Select Id, Account__c from Account_Profile__c where Account__c in :set_AccountId ]){
              map_AccountId_AccountProfile.put(ap.Account__c, ap);
            }
        
        //To set the account profile reference
        for (Physician_Visit__c objStoreVisit : list_PhysicianVisit){
          Account_Profile__c objAccountProfile = map_AccountId_AccountProfile.get(objStoreVisit.Account_ID__c);
            if(objAccountProfile != null)
                objStoreVisit.Account_Profile__c = objAccountProfile.Id;
        
        }
        
        //Boolean to restrict the firing of tHE UpdatePhysicianInfo trigger
        clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk = true;
        
        //update list_PhysicianVisit;
    }
    
    if(!clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk)
    {
        if(Trigger.isUpdate)
        {  
              
            //recordType[] oRecType = [select Id from recordType where sobjecttype = 'Joint_Field_Work__c' and Name = 'INDSU'];
            
            //if(oRecType.size()>0)
            if (ClsPhysicanVisit.map_staticRecordType.get('Joint_Field_Work__c-INDSU') != null)
            {
                for(Physician_Visit__c p : [select Id, Activity_Date__c, Status__c, recordType.Name, Planned_Call__c, OwnerId, Physician__c, Start_Time__c, End_Time__c, Joint_Call_With_ASM__c, Time_Spent__c from Physician_Visit__c where id in :Trigger.New])
                {
                    if((p.recordType.name=='INDSU Sales Planned' || 
                        p.recordType.name=='INDSU Sales Unplanned' ||                       
                        p.recordType.name=='INDSU Service Planned' || 
                        p.recordType.name=='INDSU Service Unplanned' ||
                        p.recordType.name =='APACSU Sales Planned' || 
                        p.recordType.name=='APACSU Sales Unplanned') 
                        && p.Status__c == 'Completed' && Trigger.oldmap.get(p.Id).Status__c == 'Open'
                        && p.Joint_Call_With_ASM__c == true)
                    {
                        Joint_Field_Work__c oJtWork = new Joint_Field_Work__c();
                        oJtWork.Physician_Visit__c = p.Id;
                        oJtWork.Activity_Date__c = p.Activity_Date__c;
                        oJtWork.OwnerId = p.OwnerId;
                        oJtWork.Physician__c = p.Physician__c;
                        /*
                         * 16.03.2010 Balaji Prabhakaran.
                         * Update Time_Spent_del of Joint Field Work with the value from Time_Spent of Physician Visit.
                         */
                        oJtWork.Time_Spent_del__c = p.Time_Spent__c;
                        /*
                         * 24.03.2010 Harvin.
                         * update this Sales_Service_Executive__c filed with the Physician visit owner field.
                         */
                         System.debug(p.recordType.name + ' ==== ' + ClsPhysicanVisit.map_staticRecordType.get('Joint_Field_Work__c-INDSU'));
                         if (p.recordType.name != null && (p.recordType.name.contains('INDSU')))  {
                             oJtWork.RecordTypeId = ClsPhysicanVisit.map_staticRecordType.get('Joint_Field_Work__c-INDSU');     
                         } else if (p.recordType.name != null && p.recordType.name.contains('APACSU')) {
                             oJtWork.RecordTypeId = ClsPhysicanVisit.map_staticRecordType.get('Joint_Field_Work__c-APACSU Joint Field Work');   
                         }
                        oJtWork.Sales_Service_Executive__c = p.ownerId;
                        list_JtWorkToCreate.add(oJtWork);
                        set_RepIds.add(p.OwnerId);
                        list_VisitToUpdate.add(p);
                    }
                }
                
                if(list_JtWorkToCreate.size()>0)
                {
                    for(User u: [select Id, ManagerId from user where id in :set_RepIds])
                        map_userManager.put(u.Id, u.ManagerId);
                        
                    for(Joint_Field_Work__c j: list_JtWorkToCreate)
                    {
                        j.Manager__c = map_userManager.get(j.OwnerId);
                        /*
                         * 16.03.2010 Balaji Prabhakaran.
                         * Commenting the below line so that the owner of Joint Field work remains the same as the Physician Visit.
                         */
                        //j.OwnerId = j.Manager__c;
                    }
                    
                    insert list_JtWorkToCreate;
    
                    for(integer i=0;i<list_VisitToUpdate.size();i++)
                        list_VisitToUpdate[i].Joint_Field_Work__c = list_JtWorkToCreate[i].Id;
                        
                    //Boolean to restrict the firing of tHE UpdatePhysicianInfo trigger
                    clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk = true;
    
                    update list_VisitToUpdate;
                }
            }
        }
    }
 }//!KOR SOLTA
 else{
 system.debug('Trigger Name:PhysicianVisit_AIBU_CreateEventJtFldWork ----------> No Need for KOR SOLTA Users');
 }  
}//trigger