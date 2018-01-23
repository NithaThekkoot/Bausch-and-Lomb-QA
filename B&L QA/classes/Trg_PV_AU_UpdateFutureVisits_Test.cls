@istest
private class Trg_PV_AU_UpdateFutureVisits_Test{

    /**
    * 
    * Test class for triggers PhysicianVisit_AU_UpdateFutureVisits
    * 
    * Author              |Author-Email                       |Date        |Comment
    * --------------------|---------------------------------- |------------|----------------------------------------------------
    *Neha Jain            |neha.jain@bausch.com               |11.02.2014  |First Draft
  
    */

    
    static testMethod void TestUpdatePhysicianVisit(){ 

       List<User> listUser = [Select Id from User where Profile.Name = 'INDSU Sales Rep' and isactive=true limit 1];
       User oUser = listUser[0];
       
       List<user> listIntegrationUser = [Select Id from User where Profile.Name = 'BL: Integration User' and isactive=true limit 1];
       
      //choose a valid record type for the trigger to fire
      recordType[] oRecType = [select Id from recordType where sobjecttype = 'Physician_Visit__c' and Name = 'INDSU Sales Planned'];
       
      Account objAccount = new Account(Name = 'test');
            
      Contact objCon = new Contact();
      objCon.LastName = 'test Contact';
      
      Contact objCon1 = new Contact();
      objCon1.LastName = 'test Contact';
      
      Contact objCon2 = new Contact();
      objCon2.LastName = 'test Contact';
      
      Contact objCon3 = new Contact();
      objCon3.LastName = 'test Contact';
      
      
      system.runAs(listIntegrationUser[0]){
           insert objAccount;
           
           objCon.AccountId = objAccount.Id;
           insert objCon;    
           
           objCon1.AccountId = objAccount.Id;
           insert objCon1;   
           
           objCon2.AccountId = objAccount.Id;
           insert objCon2;    
           
           objCon3.AccountId = objAccount.Id;
           insert objCon3; 
           
           Account_Profile__c newAccountProfile = new Account_Profile__c();
           newAccountProfile.Account__c = objAccount.Id;
           insert newAccountProfile;
          
           Contact_Profile__c cp = new Contact_Profile__c();
           cp.Contact__c = objCon.Id;
           cp.Doctor_Segmentation__c = 'A';
           insert cp;    
           
           Contact_Profile__c cp1 = new Contact_Profile__c();
           cp1.Contact__c = objCon1.Id;
           cp1.Doctor_Segmentation__c = 'B';
           insert cp1;    
           
           Contact_Profile__c cp2 = new Contact_Profile__c();
           cp2.Contact__c = objCon2.Id;
           cp2.Doctor_Segmentation__c = 'C';
           insert cp2;    
           
           Contact_Profile__c cp3 = new Contact_Profile__c();
           cp3.Contact__c = objCon3.Id;
           cp3.Doctor_Segmentation__c = 'D';
           insert cp3; 
           
           AccountTeamMember atm = new AccountTeamMember();
           atm.AccountId = objAccount.Id;
           atm.UserId = oUser.Id; 
           insert atm;  
            
           AccountShare share = new AccountShare();
           share.AccountId = objAccount.Id;
           share.UserOrGroupId = oUser.Id;
           share.AccountAccessLevel = 'Edit';
           share.OpportunityAccessLevel = 'Read';
           share.CaseAccessLevel = 'Edit';
           insert share;
        }
            
        System.runAs(oUser) {
            Date saturday = Date.Today();
            String strWeekday = DateTime.Now().format('E');
            if(strWeekday != 'Sat' || strWeekday != 'Sun'){
                if(strWeekday == 'Mon'){
                    saturday  = Date.ValueOf(DateTime.Now().addDays(5));
                }
                 if(strWeekday == 'Tue'){
                    saturday  = Date.ValueOf(DateTime.Now().addDays(4));
                }
                 if(strWeekday == 'Wed'){
                    saturday  = Date.ValueOf(DateTime.Now().addDays(3));
                }
                 if(strWeekday == 'Thu'){
                    saturday  = Date.ValueOf(DateTime.Now().addDays(2));
                }
                 if(strWeekday == 'Fri'){
                    saturday  = Date.ValueOf(DateTime.Now().addDays(1));
                }
                
            }
            List<Physician_Visit__c> listPhysicianVisit = new List<Physician_Visit__c>();
            //create a new physician visit
            Physician_Visit__c oPhyVisit = new Physician_Visit__c();
            oPhyVisit.Physician__c = objCon.Id;
            oPhyVisit.recordTypeId = oRecType[0].Id;
            oPhyVisit.Start_Time__c = Datetime.Now();
            oPhyVisit.End_Time__c = Datetime.Now();
            oPhyVisit.status__c = 'Open';
            oPhyVisit.Joint_Call_With_ASM__c = false;
            oPhyVisit.Activity_Date__c = saturday  ;
            oPhyVisit.Key_Driver_1__c = 'Akreos AO Micro Incision Lens';
            oPhyVisit.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
            oPhyVisit.Outcome_1__c = 'Accept product benefit';
            oPhyVisit.Envista__c = 10;
            oPhyVisit.Expiry_Date__c= Date.Today().addDays(10);
            oPhyVisit.Bundling_Competitor__c = 'Neha';
            
            oPhyVisit.OT_Hours__c  = true;
            oPhyVisit.Hours_in_Surgery__c = '1';
            oPhyVisit.Doctor_Segmentation__c = 'A';
            oPhyVisit.Planned_Call__c = true;
            oPhyVisit.OwnerId = oUser.Id;
            
            Physician_Visit__c oPhyVisit1 = new Physician_Visit__c();
            oPhyVisit1.Physician__c = objCon1.Id;
            oPhyVisit1.recordTypeId = oRecType[0].Id;
            oPhyVisit1.Start_Time__c = Datetime.Now();
            oPhyVisit1.End_Time__c = Datetime.Now();
            oPhyVisit1.status__c = 'Open';
            oPhyVisit1.Joint_Call_With_ASM__c = false;
            oPhyVisit1.Activity_Date__c = Date.today();
            oPhyVisit1.Key_Driver_1__c = 'Akreos AO Micro Incision Lens';
            oPhyVisit1.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
            oPhyVisit1.Outcome_1__c = 'Accept product benefit';
            oPhyVisit1.Envista__c = 10;
            oPhyVisit1.Expiry_Date__c= Date.Today().addDays(10);
            oPhyVisit1.Bundling_Competitor__c = 'Neha';
            
            oPhyVisit1.OT_Hours__c  = true;
            oPhyVisit1.Hours_in_Surgery__c = '1';
            oPhyVisit1.Doctor_Segmentation__c = 'B';
            oPhyVisit1.Planned_Call__c = true;
            oPhyVisit1.OwnerId = oUser.Id;
            
            Physician_Visit__c oPhyVisit2 = new Physician_Visit__c();
            oPhyVisit2.Physician__c = objCon2.Id;
            oPhyVisit2.recordTypeId = oRecType[0].Id;
            oPhyVisit2.Start_Time__c = Datetime.Now();
            oPhyVisit2.End_Time__c = Datetime.Now();
            oPhyVisit2.status__c = 'Open';
            oPhyVisit2.Joint_Call_With_ASM__c = false;
            oPhyVisit2.Activity_Date__c = Date.today();
            oPhyVisit2.Key_Driver_1__c = 'Akreos AO Micro Incision Lens';
            oPhyVisit2.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
            oPhyVisit2.Outcome_1__c = 'Accept product benefit';
            oPhyVisit2.Envista__c = 10;
            oPhyVisit2.Expiry_Date__c= Date.Today().addDays(10);
            oPhyVisit2.Bundling_Competitor__c = 'Neha';
            
            oPhyVisit2.OT_Hours__c  = true;
            oPhyVisit2.Hours_in_Surgery__c = '1';
            oPhyVisit2.Doctor_Segmentation__c = 'C';
            oPhyVisit2.Planned_Call__c = true;
            oPhyVisit2.OwnerId = oUser.Id;
            
            Physician_Visit__c oPhyVisit3 = new Physician_Visit__c();
            oPhyVisit3.Physician__c = objCon3.Id;
            oPhyVisit3.recordTypeId = oRecType[0].Id;
            oPhyVisit3.Start_Time__c = Datetime.Now();
            oPhyVisit3.End_Time__c = Datetime.Now();
            oPhyVisit3.status__c = 'Open';
            oPhyVisit3.Joint_Call_With_ASM__c = false;
            oPhyVisit3.Activity_Date__c = Date.today();
            oPhyVisit3.Key_Driver_1__c = 'Akreos AO Micro Incision Lens';
            oPhyVisit3.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
            oPhyVisit3.Outcome_1__c = 'Accept product benefit';
            oPhyVisit3.Envista__c = 10;
            oPhyVisit3.Expiry_Date__c= Date.Today().addDays(10);
            oPhyVisit3.Bundling_Competitor__c = 'Neha';
            oPhyVisit3.OT_Hours__c  = true;
            oPhyVisit3.Hours_in_Surgery__c = '1';
            oPhyVisit3.Doctor_Segmentation__c = 'D';
            oPhyVisit3.Planned_Call__c = true;
            oPhyVisit3.OwnerId = oUser.Id;
            
            listPhysicianVisit.add(oPhyVisit);
            listPhysicianVisit.add(oPhyVisit1);
            listPhysicianVisit.add(oPhyVisit2);
            listPhysicianVisit.add(oPhyVisit3);
            
            
            Physician_Visit__c oPhyVisit4 = new Physician_Visit__c();
            oPhyVisit4.Physician__c = objCon.Id;
            oPhyVisit4.recordTypeId = oRecType[0].Id;
            oPhyVisit4.Start_Time__c = Datetime.Now();
            oPhyVisit4.End_Time__c = Datetime.Now();
            oPhyVisit4.status__c = 'Open';
            oPhyVisit4.Joint_Call_With_ASM__c = false;
            oPhyVisit4.Activity_Date__c = Date.today();
            oPhyVisit4.Key_Driver_1__c = 'Akreos AO Micro Incision Lens';
            oPhyVisit4.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
            oPhyVisit4.Outcome_1__c = 'Accept product benefit';
            oPhyVisit4.Envista__c = 10;
            oPhyVisit4.Expiry_Date__c= Date.Today().addDays(10);
            oPhyVisit4.Bundling_Competitor__c = 'Neha';
            
            oPhyVisit4.OT_Hours__c  = true;
            oPhyVisit4.Hours_in_Surgery__c = '1';
            oPhyVisit4.Doctor_Segmentation__c = 'A';
            oPhyVisit4.Planned_Call__c = false;
            oPhyVisit4.OwnerId = oUser.Id;
            
            Physician_Visit__c oPhyVisit5 = new Physician_Visit__c();
            oPhyVisit5.Physician__c = objCon1.Id;
            oPhyVisit5.recordTypeId = oRecType[0].Id;
            oPhyVisit5.Start_Time__c = Datetime.Now();
            oPhyVisit5.End_Time__c = Datetime.Now();
            oPhyVisit5.status__c = 'Open';
            oPhyVisit5.Joint_Call_With_ASM__c = false;
            oPhyVisit5.Activity_Date__c = Date.today();
            oPhyVisit5.Key_Driver_1__c = 'Akreos AO Micro Incision Lens';
            oPhyVisit5.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
            oPhyVisit5.Outcome_1__c = 'Accept product benefit';
            oPhyVisit5.Envista__c = 10;
            oPhyVisit5.Expiry_Date__c= Date.Today().addDays(10);
            oPhyVisit5.Bundling_Competitor__c = 'Neha';
            
            oPhyVisit5.OT_Hours__c  = true;
            oPhyVisit5.Hours_in_Surgery__c = '1';
            oPhyVisit5.Doctor_Segmentation__c = 'B';
            oPhyVisit5.Planned_Call__c = false;
            oPhyVisit5.OwnerId = oUser.Id;
            
            Physician_Visit__c oPhyVisit6 = new Physician_Visit__c();
            oPhyVisit6.Physician__c = objCon2.Id;
            oPhyVisit6.recordTypeId = oRecType[0].Id;
            oPhyVisit6.Start_Time__c = Datetime.Now();
            oPhyVisit6.End_Time__c = Datetime.Now();
            oPhyVisit6.status__c = 'Open';
            oPhyVisit6.Joint_Call_With_ASM__c = false;
            oPhyVisit6.Activity_Date__c = Date.today();
            oPhyVisit6.Key_Driver_1__c = 'Akreos AO Micro Incision Lens';
            oPhyVisit6.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
            oPhyVisit6.Outcome_1__c = 'Accept product benefit';
            oPhyVisit6.Envista__c = 10;
            oPhyVisit6.Expiry_Date__c= Date.Today().addDays(10);
            oPhyVisit6.Bundling_Competitor__c = 'Neha';
            
            oPhyVisit6.OT_Hours__c  = true;
            oPhyVisit6.Hours_in_Surgery__c = '1';
            oPhyVisit6.Doctor_Segmentation__c = 'C';
            oPhyVisit6.Planned_Call__c = false;
            oPhyVisit6.OwnerId = oUser.Id;
            
            Physician_Visit__c oPhyVisit7 = new Physician_Visit__c();
            oPhyVisit7.Physician__c = objCon3.Id;
            oPhyVisit7.recordTypeId = oRecType[0].Id;
            oPhyVisit7.Start_Time__c = Datetime.Now();
            oPhyVisit7.End_Time__c = Datetime.Now();
            oPhyVisit7.status__c = 'Open';
            oPhyVisit7.Joint_Call_With_ASM__c = false;
            oPhyVisit7.Activity_Date__c = Date.today();
            oPhyVisit7.Key_Driver_1__c = 'Akreos AO Micro Incision Lens';
            oPhyVisit7.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
            oPhyVisit7.Outcome_1__c = 'Accept product benefit';
            oPhyVisit7.Envista__c = 10;
            oPhyVisit7.Expiry_Date__c= Date.Today().addDays(10);
            oPhyVisit7.Bundling_Competitor__c = 'Neha';
            
            oPhyVisit7.OT_Hours__c  = true;
            oPhyVisit7.Hours_in_Surgery__c = '1';
            oPhyVisit7.Doctor_Segmentation__c = 'D';
            oPhyVisit7.Planned_Call__c = false;
            oPhyVisit7.OwnerId = oUser.Id;
            
            listPhysicianVisit.add(oPhyVisit4);
            listPhysicianVisit.add(oPhyVisit5);
            listPhysicianVisit.add(oPhyVisit6);
            listPhysicianVisit.add(oPhyVisit7);
            
            insert listPhysicianVisit;
            
            List<Effectiveness_Summary__c> listEffect = new List<Effectiveness_Summary__c>();
            Effectiveness_Summary__c effectivenessSummary = new Effectiveness_Summary__c();
            effectivenessSummary.Date__c =  Date.today();
            effectivenessSummary.ownerId = oUser.Id;    
            effectivenessSummary.OT_Hours__c = 4;        
            listEffect.add(effectivenessSummary) ;
            
            Effectiveness_Summary__c effectivenessSummary1 = new Effectiveness_Summary__c();
            effectivenessSummary1.Date__c =  Date.today();
            effectivenessSummary1.ownerId = oUser.Id;            
            effectivenessSummary1.OT_Hours__c = 3;
            listEffect.add(effectivenessSummary1) ;
            insert listEffect;
            
            clsPhysicianVisitUpdate.isExecute = false;
            clsPhysicianVisitUpdate.isInsert = false;
            
            oPhyVisit.Call_Duration_Mns__c = '11-15mins';
            oPhyVisit.Call_Objective__c = 'ABC';
            oPhyVisit.Call_Type__c = 'Call';
            oPhyVisit.Session__c = 'PM';
            oPhyVisit.Hours_in_Surgery__c = '5';
            oPhyVisit.Status__c = 'Completed';
            oPhyVisit.Doctor_Segmentation__c = 'A';
            oPhyVisit.Planned_Call__c = true;
            
            oPhyVisit1.Call_Duration_Mns__c = '11-15mins';
            oPhyVisit1.Call_Objective__c = 'ABC';
            oPhyVisit1.Call_Type__c = 'Call';
            oPhyVisit1.Session__c = 'PM';
            oPhyVisit1.Hours_in_Surgery__c = '5';
            oPhyVisit1.Status__c = 'Completed';
            oPhyVisit1.Doctor_Segmentation__c = 'B';
            oPhyVisit1.Planned_Call__c = true;
            
            oPhyVisit2.Call_Duration_Mns__c = '11-15 mins';
            oPhyVisit2.Call_Objective__c = 'ABC';
            oPhyVisit2.Call_Type__c = 'Call';
            oPhyVisit2.Session__c = 'PM';
            oPhyVisit2.Hours_in_Surgery__c = '5';
            oPhyVisit2.Status__c = 'Completed';
            oPhyVisit2.Doctor_Segmentation__c = 'C';
            oPhyVisit2.Planned_Call__c = true;
            
            oPhyVisit3.Call_Duration_Mns__c = '11-15mins';
            oPhyVisit3.Call_Objective__c = 'ABC';
            oPhyVisit3.Call_Type__c = 'Call';
            oPhyVisit3.Session__c = 'PM';
            oPhyVisit3.Hours_in_Surgery__c = '5';
            oPhyVisit3.Status__c = 'Completed';
            oPhyVisit3.Doctor_Segmentation__c = 'D';
            oPhyVisit3.Planned_Call__c = true;
            oPhyVisit3.Call_Objective_Achieved__c = true;
            
            Set<id> setIds = new Set<id>();
            setIds.add(oPhyVisit.Id);
            setIds.add(oPhyVisit1.Id);
            setIds.add(oPhyVisit2.Id);
            setIds.add(oPhyVisit3.Id);
            
            oPhyVisit4.Call_Duration_Mns__c = '11-15mins';
            oPhyVisit4.Call_Objective__c = 'ABC';
            oPhyVisit4.Call_Type__c = 'Call';
            oPhyVisit4.Session__c = 'PM';
            oPhyVisit4.Hours_in_Surgery__c = '5';
            oPhyVisit4.Status__c = 'Completed';
            oPhyVisit4.Doctor_Segmentation__c = 'A';
            oPhyVisit4.Planned_Call__c = false;
            
            oPhyVisit5.Call_Duration_Mns__c = '11-15mins';
            oPhyVisit5.Call_Objective__c = 'ABC';
            oPhyVisit5.Call_Type__c = 'Call';
            oPhyVisit5.Session__c = 'PM';
            oPhyVisit5.Hours_in_Surgery__c = '5';
            oPhyVisit5.Status__c = 'Completed';
            oPhyVisit5.Doctor_Segmentation__c = 'B';
            oPhyVisit5.Planned_Call__c = false;
            
            oPhyVisit6.Call_Duration_Mns__c = '11-15mins';
            oPhyVisit6.Call_Objective__c = 'ABC';
            oPhyVisit6.Call_Type__c = 'Call';
            oPhyVisit6.Session__c = 'PM';
            oPhyVisit6.Hours_in_Surgery__c = '5';
            oPhyVisit6.Status__c = 'Completed';
            oPhyVisit6.Doctor_Segmentation__c = 'C';
            oPhyVisit6.Planned_Call__c = false;
            
            oPhyVisit7.Call_Duration_Mns__c = '11-15mins';
            oPhyVisit7.Call_Objective__c = 'ABC';
            oPhyVisit7.Call_Type__c = 'Call';
            oPhyVisit7.Session__c = 'PM';
            oPhyVisit7.Hours_in_Surgery__c = '5';
            oPhyVisit7.Status__c = 'Completed';
            oPhyVisit7.Doctor_Segmentation__c = 'D';
            oPhyVisit7.Planned_Call__c = false;
            
            setIds.add(oPhyVisit4.Id);
            setIds.add(oPhyVisit5.Id);
            setIds.add(oPhyVisit6.Id);
            setIds.add(oPhyVisit7.Id);
            
            listPhysicianVisit = [Select id from Physician_Visit__c where Id IN : setIds];
            listEffect = [select id,ownerId,OT_Hours__c from Effectiveness_Summary__c where Date__c =: Date.Today() and ownerId =: oUser.Id];
            update listEffect;
            update listPhysicianVisit;
            
         
        }
      }
}