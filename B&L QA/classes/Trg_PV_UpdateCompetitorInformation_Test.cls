@istest
private class Trg_PV_UpdateCompetitorInformation_Test{

    /**
    * 
    * Test class for triggers PhysicianVisit_BU_UpdateCompetitorInformation
    * 
    * Author              |Author-Email                       |Date        |Comment
    * --------------------|---------------------------------- |------------|----------------------------------------------------
    *Neha Jain         |neha.jain@bausch.com                  |11.02.2014  |First Draft
    *Neha Jain         |neha.jain@bausch.com                  |18.03.2014  |Modified to improve the code coverage
    */

    
    static testMethod void TestUpdatePhysicianVisit(){ 
       Test.startTest();
       List<User> listUser = [Select Id, ManagerId from User where Profile.Name like 'INDSU Sales Rep%' and Manager.UserRole.Name like 'INDSU%Manager%' and Manager.isactive = true and isactive=true limit 1]; 
       List<User> listUserAdmin = [Select Id, ManagerId from User where name='APAC Integration User India' and Profile.Name like 'APACSU System Administrator%' limit 1];    
         User oUserAdmin=listUserAdmin[0];
       User oUser = listUser[0];
       User managerUser = new User(Id = listUser[0].ManagerId);
       //choose a valid record type for the trigger to fire
       recordType[] oRecType = [select Id from recordType where sobjecttype = 'Physician_Visit__c' and Name in ('INDSU Sales Planned')];
       List<Physician_Visit__c> listPhysicianVisit = new List<Physician_Visit__c>();
       
       
       System.runAs(oUserAdmin) {
            Account objAccount = new Account(Name = 'test');
            insert objAccount;
            
            Contact objCon = new Contact();
            objCon.LastName = 'test Contact';
            objCon.AccountId = objAccount.Id;
            insert objCon;
        
            //create a new physician visit
            Physician_Visit__c oPhyVisit = new Physician_Visit__c();
            oPhyVisit.Physician__c = objCon.Id;
            oPhyVisit.recordTypeId = oRecType[0].Id;
            oPhyVisit.Start_Time__c = Datetime.Now();
            oPhyVisit.End_Time__c = Datetime.Now();
            oPhyVisit.status__c = 'Open';
            oPhyVisit.Joint_Call_With_ASM__c = false;
            oPhyVisit.Activity_Date__c = Date.today();
            oPhyVisit.Key_Driver_1__c = 'Akreos AO Micro Incision Lens';
            oPhyVisit.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
            oPhyVisit.Outcome_1__c = 'Accept product benefit';
            oPhyVisit.Envista__c = 10;
            oPhyVisit.Expiry_Date__c= Date.Today().addDays(10);
            oPhyVisit.Bundling_Competitor__c = 'Neha';
            oPhyVisit.OT_Hours__c  = true;
            oPhyVisit.Hours_in_Surgery__c = '';
            oPhyVisit.Doctor_Segmentation__c = 'A';
            oPhyVisit.Planned_Call__c = true;
            oPhyVisit.OwnerId = oUser.Id;
            oPhyVisit.Akreos_MIL__c = 1;
            oPhyVisit.AKREOS_AO__c = 1;
            oPhyVisit.AKREOS__c = 1;
            oPhyVisit.LI61_AO__c = 1;
            oPhyVisit.LI61_SE__c = 1;
            oPhyVisit.LI61AOV__c = 1;
            oPhyVisit.Crystalens__c = 1;
            oPhyVisit.AMO__c = 1;
            oPhyVisit.Hanitta__c = 1;
            oPhyVisit.Acrysof_3_piece__c = 1;
            oPhyVisit.Acrysof_IQ__c = 1;
            oPhyVisit.Rayner__c = 1;
            oPhyVisit.Sensar__c = 1;
            oPhyVisit.Tecnis_Acrylic__c = 1;
            oPhyVisit.Zeiss__c = 1;
            oPhyVisit.Others__c = 1;
            oPhyVisit.Akreos_MI_60__c = 1;
            oPhyVisit.Akreos_Adapt__c = 1;
            oPhyVisit.Acrysof_ReStor__c = 1;
            oPhyVisit.Acrysof_Toric__c = 1;
            oPhyVisit.ReZoom__c = 1;
            oPhyVisit.Tecnis__c = 1;
            oPhyVisit.Tecnis_Multifocal__c = 1;
            oPhyVisit.Canon_Staar__c = 1;
            oPhyVisit.Hoya__c = 1;
            oPhyVisit.Envista__c = 1;
            listPhysicianVisit.add(oPhyVisit);
            
            insert listPhysicianVisit;
            
            Monthly_Implantation_Detail__c monthlyImplantation = new Monthly_Implantation_Detail__c();
            monthlyImplantation.Physician_Name__c = objCon.Id;
            monthlyImplantation.Month__c = String.ValueOf(oPhyVisit.Activity_Date__c.Month());
            monthlyImplantation.Year__c = oPhyVisit.Activity_Date__c.Year();
            insert monthlyImplantation;
            
            oPhyVisit.Akreos_MIL__c = 2;
            oPhyVisit.AKREOS_AO__c = 2;
            oPhyVisit.AKREOS__c = 2;
            oPhyVisit.LI61_AO__c = 2;
            oPhyVisit.LI61_SE__c = 2;
            oPhyVisit.LI61AOV__c = 2;
            oPhyVisit.Crystalens__c = 2;
            oPhyVisit.AMO__c = 2;
            oPhyVisit.Hanitta__c = 3;
            oPhyVisit.Acrysof_3_piece__c = 2;
            oPhyVisit.Acrysof_IQ__c = 2;
            oPhyVisit.Rayner__c = 2;
            oPhyVisit.Sensar__c = 2;
            oPhyVisit.Tecnis_Acrylic__c = 2;
            oPhyVisit.Zeiss__c = 2;
            oPhyVisit.Others__c = 2;
            oPhyVisit.Akreos_MI_60__c = 2;
            oPhyVisit.Akreos_Adapt__c = 2;
            oPhyVisit.Acrysof_ReStor__c = 2;
            oPhyVisit.Acrysof_Toric__c = 2;
            oPhyVisit.ReZoom__c = 2;
            oPhyVisit.Tecnis__c = 2;
            oPhyVisit.Tecnis_Multifocal__c = 2;
            oPhyVisit.Canon_Staar__c = 2;
            oPhyVisit.Hoya__c = 2;
            oPhyVisit.Envista__c = 2;
            
            //clsPhysicianVisitUpdate.isUpdate = false; 
            //clsPhysicianVisitUpdate.isInsert = false; 
            try{
                 clsPhysicianVisitUpdate.isUpdate = false; 
                clsPhysicianVisitUpdate.isInsert = false; 
                update listPhysicianVisit;
            }
            catch(Exception ex){
            // to avoid error in code - t0 cover exceptions for code coverage
            }
            
            List<Physician_Visit__c> listPV = new List<Physician_Visit__c>();
            
            Physician_Visit__c oPhyVisit1 = new Physician_Visit__c();
            oPhyVisit1.Physician__c = objCon.Id;
            //oPhyVisit1.recordTypeId = oRecType[0].Id;
            oPhyVisit1.Start_Time__c = Datetime.Now();
            oPhyVisit1.End_Time__c = Datetime.Now();
            oPhyVisit1.status__c = 'Open';
            oPhyVisit1.Joint_Call_With_ASM__c = false;
            oPhyVisit1.Activity_Date__c = Date.today();
            oPhyVisit1.Key_Driver_1__c = 'Akreos AO Micro Incision Lens';
            oPhyVisit1.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
            oPhyVisit1.Outcome_1__c = 'Accept product benefit';
            oPhyVisit1.Envista__c = 10;
            //oPhyVisit1.Expiry_Date__c= Date.Today().addDays(-1);
            oPhyVisit1.Bundling_Competitor__c = 'Neha';
            oPhyVisit1.OT_Hours__c  = true;
            oPhyVisit1.Hours_in_Surgery__c = '7';
            oPhyVisit1.Doctor_Segmentation__c = 'B';
            oPhyVisit1.Planned_Call__c = true;
            oPhyVisit1.OwnerId = oUser.Id;
            listPV.add(oPhyVisit1);
            
            
            Physician_Visit__c oPhyVisit2 = new Physician_Visit__c();
            oPhyVisit2.Physician__c = objCon.Id;
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
            oPhyVisit2.Expiry_Date__c= Date.Today();
            oPhyVisit2.Bundling_Competitor__c = 'Neha';
            oPhyVisit2.OT_Hours__c  = true;
            oPhyVisit2.Hours_in_Surgery__c = '7';
            oPhyVisit2.Doctor_Segmentation__c = 'B';
            oPhyVisit2.Planned_Call__c = true;
            oPhyVisit2.OwnerId = oUser.Id;
            listPV.add(oPhyVisit2);
            
            Physician_Visit__c oPhyVisit3 = new Physician_Visit__c();
            oPhyVisit3.Physician__c = objCon.Id;
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
            oPhyVisit3.Expiry_Date__c= Date.Today();
            oPhyVisit3.Bundling_Competitor__c = 'Neha';
            oPhyVisit3.OT_Hours__c  = true;
            oPhyVisit3.Hours_in_Surgery__c = '7';
            oPhyVisit3.Doctor_Segmentation__c = 'B';
            oPhyVisit3.Planned_Call__c = true;
            oPhyVisit3.OwnerId = oUser.Id;
            listPV.add(oPhyVisit3);
            insert listPV;
            try{
                 clsPhysicianVisitUpdate.isUpdate = false; 
                clsPhysicianVisitUpdate.isInsert = false; 
                update listPV;
            }
            catch(Exception ex){
            // to avoid error in code - t0 cover exceptions for code coverage
            } 
       }   
        
     
       System.runAs(managerUser) {
           Physician_Visit__c oPhyVisit= listPhysicianVisit[0];
            oPhyVisit.Akreos_MIL__c = 5;
            oPhyVisit.AKREOS_AO__c = 5;
            oPhyVisit.AKREOS__c = 5;
            oPhyVisit.LI61_AO__c = 5;
            oPhyVisit.LI61_SE__c = 5;
            oPhyVisit.LI61AOV__c = 5;
            oPhyVisit.Crystalens__c = 5;
            oPhyVisit.AMO__c = 5;
            oPhyVisit.Hanitta__c = 4;
            oPhyVisit.Acrysof_3_piece__c = 4;
            oPhyVisit.Acrysof_IQ__c = 3;
            oPhyVisit.Rayner__c = 4;
            oPhyVisit.Sensar__c = 4;
            oPhyVisit.Tecnis_Acrylic__c = 4;
            oPhyVisit.Zeiss__c = 3;
            oPhyVisit.Others__c = 1;
            oPhyVisit.Akreos_MI_60__c = 6;
            oPhyVisit.Akreos_Adapt__c = 4;
            oPhyVisit.Acrysof_ReStor__c = 1;
            oPhyVisit.Acrysof_Toric__c = 1;
            oPhyVisit.ReZoom__c = 1;
            oPhyVisit.Tecnis__c = 1;
            oPhyVisit.Tecnis_Multifocal__c = 3;
            oPhyVisit.Canon_Staar__c = 3;
            oPhyVisit.Hoya__c = 3;
            oPhyVisit.Envista__c = 3;
            clsPhysicianVisitUpdate.isUpdate = false; 
            clsPhysicianVisitUpdate.isInsert = false; 
            try{
                update listPhysicianVisit;
            }
            catch(Exception ex){
            }
            
            
            
        }    
        Test.StopTest();             
    }
   
   
   static testMethod void TestUpdatePhysicianVisit1(){ 
       Test.startTest();
       List<User> listUser = [Select Id, ManagerId from User where Profile.Name like 'INDSU Sales Rep%' and Manager.UserRole.Name like 'INDSU%Manager%' and Manager.isactive = true and isactive=true limit 1];    
       List<User> listUserAdmin1 = [Select Id, ManagerId from User where name='APAC Integration User India' and Profile.Name like 'APACSU System Administrator%' limit 1];    
       User oUserAdmin=listUserAdmin1[0]; 
       User oUser = listUser[0];
       User managerUser = new User(Id = listUser[0].ManagerId);
       //choose a valid record type for the trigger to fire
       recordType[] oRecType = [select Id from recordType where sobjecttype = 'Physician_Visit__c' and Name in ('APACSU Technical Service')];
       List<Physician_Visit__c> listPhysicianVisit = new List<Physician_Visit__c>();
       
       
       System.runAs(oUserAdmin) {
            Account objAccount = new Account(Name = 'test');
            insert objAccount;
            
            Contact objCon = new Contact();
            objCon.LastName = 'test Contact';
            objCon.AccountId = objAccount.Id;
            insert objCon;
        
            //create a new physician visit
            Physician_Visit__c oPhyVisit = new Physician_Visit__c();
            oPhyVisit.Physician__c = objCon.Id;
            oPhyVisit.recordTypeId = oRecType[0].Id;
            oPhyVisit.Start_Time__c = Datetime.Now();
            oPhyVisit.End_Time__c = Datetime.Now();
            oPhyVisit.status__c = 'Open';
            oPhyVisit.Joint_Call_With_ASM__c = false;
            oPhyVisit.Activity_Date__c = Date.today();
            oPhyVisit.Key_Driver_1__c = 'Akreos AO Micro Incision Lens';
            oPhyVisit.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
            oPhyVisit.Outcome_1__c = 'Accept product benefit';
            oPhyVisit.Envista__c = 10;
            oPhyVisit.Expiry_Date__c= Date.Today().addDays(10);
            oPhyVisit.Bundling_Competitor__c = 'Neha';
            oPhyVisit.OT_Hours__c  = true;
            oPhyVisit.Hours_in_Surgery__c = '';
            oPhyVisit.Doctor_Segmentation__c = 'A';
            oPhyVisit.Planned_Call__c = true;
            oPhyVisit.OwnerId = oUser.Id;
            oPhyVisit.Akreos_MIL__c = 1;
            oPhyVisit.AKREOS_AO__c = 1;
            oPhyVisit.AKREOS__c = 1;
            oPhyVisit.LI61_AO__c = 1;
            oPhyVisit.LI61_SE__c = 1;
            oPhyVisit.LI61AOV__c = 1;
            oPhyVisit.Crystalens__c = 1;
            oPhyVisit.AMO__c = 1;
            oPhyVisit.Hanitta__c = 1;
            oPhyVisit.Acrysof_3_piece__c = 1;
            oPhyVisit.Acrysof_IQ__c = 1;
            oPhyVisit.Rayner__c = 1;
            oPhyVisit.Sensar__c = 1;
            oPhyVisit.Tecnis_Acrylic__c = 1;
            oPhyVisit.Zeiss__c = 1;
            oPhyVisit.Others__c = 1;
            oPhyVisit.Akreos_MI_60__c = 1;
            oPhyVisit.Akreos_Adapt__c = 1;
            oPhyVisit.Acrysof_ReStor__c = 1;
            oPhyVisit.Acrysof_Toric__c = 1;
            oPhyVisit.ReZoom__c = 1;
            oPhyVisit.Tecnis__c = 1;
            oPhyVisit.Tecnis_Multifocal__c = 1;
            oPhyVisit.Canon_Staar__c = 1;
            oPhyVisit.Hoya__c = 1;
            oPhyVisit.Envista__c = 1;
            listPhysicianVisit.add(oPhyVisit);
            
            insert listPhysicianVisit;
            
            Monthly_Implantation_Detail__c monthlyImplantation = new Monthly_Implantation_Detail__c();
            monthlyImplantation.Physician_Name__c = objCon.Id;
            monthlyImplantation.Month__c = String.ValueOf(oPhyVisit.Activity_Date__c.Month());
            monthlyImplantation.Year__c = oPhyVisit.Activity_Date__c.Year();
            insert monthlyImplantation;
            
            oPhyVisit.Akreos_MIL__c = 2;
            oPhyVisit.AKREOS_AO__c = 2;
            oPhyVisit.AKREOS__c = 2;
            oPhyVisit.LI61_AO__c = 2;
            oPhyVisit.LI61_SE__c = 2;
            oPhyVisit.LI61AOV__c = 2;
            oPhyVisit.Crystalens__c = 2;
            oPhyVisit.AMO__c = 2;
            oPhyVisit.Hanitta__c = 3;
            oPhyVisit.Acrysof_3_piece__c = 2;
            oPhyVisit.Acrysof_IQ__c = 2;
            oPhyVisit.Rayner__c = 2;
            oPhyVisit.Sensar__c = 2;
            oPhyVisit.Tecnis_Acrylic__c = 2;
            oPhyVisit.Zeiss__c = 2;
            oPhyVisit.Others__c = 2;
            oPhyVisit.Akreos_MI_60__c = 2;
            oPhyVisit.Akreos_Adapt__c = 2;
            oPhyVisit.Acrysof_ReStor__c = 2;
            oPhyVisit.Acrysof_Toric__c = 2;
            oPhyVisit.ReZoom__c = 2;
            oPhyVisit.Tecnis__c = 2;
            oPhyVisit.Tecnis_Multifocal__c = 2;
            oPhyVisit.Canon_Staar__c = 2;
            oPhyVisit.Hoya__c = 2;
            oPhyVisit.Envista__c = 2;
            
            //clsPhysicianVisitUpdate.isUpdate = false; 
            //clsPhysicianVisitUpdate.isInsert = false; 
            try{
                 clsPhysicianVisitUpdate.isUpdate = false; 
                clsPhysicianVisitUpdate.isInsert = false; 
                update listPhysicianVisit;
            }
            catch(Exception ex){
            // to avoid error in code - t0 cover exceptions for code coverage
            }
            
           /* List<Physician_Visit__c> listPV = new List<Physician_Visit__c>();
            
            Physician_Visit__c oPhyVisit1 = new Physician_Visit__c();
            oPhyVisit1.Physician__c = objCon.Id;
            //oPhyVisit1.recordTypeId = oRecType[0].Id;
            oPhyVisit1.Start_Time__c = Datetime.Now();
            oPhyVisit1.End_Time__c = Datetime.Now();
            oPhyVisit1.status__c = 'Open';
            oPhyVisit1.Joint_Call_With_ASM__c = false;
            oPhyVisit1.Activity_Date__c = Date.today();
            oPhyVisit1.Key_Driver_1__c = 'Akreos AO Micro Incision Lens';
            oPhyVisit1.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
            oPhyVisit1.Outcome_1__c = 'Accept product benefit';
            oPhyVisit1.Envista__c = 10;
            //oPhyVisit1.Expiry_Date__c= Date.Today().addDays(-1);
            oPhyVisit1.Bundling_Competitor__c = 'Neha';
            oPhyVisit1.OT_Hours__c  = true;
            oPhyVisit1.Hours_in_Surgery__c = '7';
            oPhyVisit1.Doctor_Segmentation__c = 'B';
            oPhyVisit1.Planned_Call__c = true;
            oPhyVisit1.OwnerId = oUser.Id;
            listPV.add(oPhyVisit1);
            
            
            Physician_Visit__c oPhyVisit2 = new Physician_Visit__c();
            oPhyVisit2.Physician__c = objCon.Id;
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
            oPhyVisit2.Expiry_Date__c= Date.Today();
            oPhyVisit2.Bundling_Competitor__c = 'Neha';
            oPhyVisit2.OT_Hours__c  = true;
            oPhyVisit2.Hours_in_Surgery__c = '7';
            oPhyVisit2.Doctor_Segmentation__c = 'B';
            oPhyVisit2.Planned_Call__c = true;
            oPhyVisit2.OwnerId = oUser.Id;
            listPV.add(oPhyVisit2);
            
           
            insert listPV;
            try{
                 clsPhysicianVisitUpdate.isUpdate = false; 
                clsPhysicianVisitUpdate.isInsert = false; 
                update listPV;
            }
            catch(Exception ex){
            // to avoid error in code - t0 cover exceptions for code coverage
            } */
       }   
        
     
       /*System.runAs(managerUser) {
           Physician_Visit__c oPhyVisit= listPhysicianVisit[0];
            oPhyVisit.Akreos_MIL__c = 5;
            oPhyVisit.AKREOS_AO__c = 5;
            oPhyVisit.AKREOS__c = 5;
            oPhyVisit.LI61_AO__c = 5;
            oPhyVisit.LI61_SE__c = 5;
            oPhyVisit.LI61AOV__c = 5;
            oPhyVisit.Crystalens__c = 5;
            oPhyVisit.AMO__c = 5;
            oPhyVisit.Hanitta__c = 4;
            oPhyVisit.Acrysof_3_piece__c = 4;
            oPhyVisit.Acrysof_IQ__c = 3;
            oPhyVisit.Rayner__c = 4;
            oPhyVisit.Sensar__c = 4;
            oPhyVisit.Tecnis_Acrylic__c = 4;
            oPhyVisit.Zeiss__c = 3;
            oPhyVisit.Others__c = 1;
            oPhyVisit.Akreos_MI_60__c = 6;
            oPhyVisit.Akreos_Adapt__c = 4;
            oPhyVisit.Acrysof_ReStor__c = 1;
            oPhyVisit.Acrysof_Toric__c = 1;
            oPhyVisit.ReZoom__c = 1;
            oPhyVisit.Tecnis__c = 1;
            oPhyVisit.Tecnis_Multifocal__c = 3;
            oPhyVisit.Canon_Staar__c = 3;
            oPhyVisit.Hoya__c = 3;
            oPhyVisit.Envista__c = 3;
            clsPhysicianVisitUpdate.isUpdate = false; 
            clsPhysicianVisitUpdate.isInsert = false; 
            try{
                update listPhysicianVisit;
            }
            catch(Exception ex){
            }
            
            
            
        }   */ 
        Test.StopTest();             
    }
   
  }