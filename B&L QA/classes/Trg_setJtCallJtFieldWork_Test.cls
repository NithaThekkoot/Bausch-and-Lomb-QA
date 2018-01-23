@istest
private class Trg_setJtCallJtFieldWork_Test{

    /**
    * 
    * Test class for 2 triggers event_AU_setJtCallPhysicianVisit and PhysicianVisit_AIBU_CreateEventJtFldWork     
    * 
    * Author              |Author-Email                       |Date        |Comment
    * --------------------|---------------------------------- |------------|----------------------------------------------------
    * Arun David          |arun.david@listertechnologies.com  |11.03.2010  |First Draft
    * Santosh Kumar       |santosh.sriram@listertechnologies.com|10.03.2011|Changing INDSU System Admin to APACSU Admin
    */

    
    static testMethod void JtCallJtFieldWorkTest(){ 

        Profile oProfile = [SELECT Id 
                          FROM profile 
                          WHERE name='INDSU Sales Rep']; //APACSU System Administrator

        UserRole userRole = [Select id from UserRole where UserRole.Name like 'INDSU Sales Rep%' limit 1];
        User oManager = new User(alias = 'mgruser', 
                             email='mgruser@testorg.com', 
                             emailencodingkey='UTF-8',
                             lastname='lastname2',
                             languagelocalekey='en_US', 
                             localesidkey='en_US', 
                             profileid = oProfile.Id, 
                             timezonesidkey='America/Los_Angeles',
                             username='mgruser@testorg.com');
       insert oManager; 
       oManager.lastname='lastname22'; 
       update oManager;
        
        User oUser = new User(alias = 'stduser', 
                             email='stduser@testorg.com', 
                             emailencodingkey='UTF-8',
                             lastname='lastname1',
                             languagelocalekey='en_US', 
                             localesidkey='en_US', 
                             profileid = oProfile.Id, 
                             timezonesidkey='America/Los_Angeles',
                             managerId = oManager.Id,
                             username='stduser@testorg.com',
                             userroleid = userRole.Id
                             );
       insert oUser;  
       oUser.email='stduser@testorg1.com';
        update oUser;
        
        //select a user that has a manager
        //User u = oUser;
        List<User> listIntegrationUser = [Select id from user where Profile.Name = 'BL: Integration User' and isactive = true limit 1] ;
        
        
        Account objAccount = new Account(Name = 'test');
        
        Contact objCon = new Contact();
        
        if(listIntegrationUser.size() > 0){
              system.runAs(listIntegrationUser[0]){
                    objCon.LastName = 'test Contact';
                    objCon.AccountId = objAccount.Id;
                    
                    insert objAccount;
                        
                    insert objCon;
                    
                    AccountTeamMember atm = new AccountTeamMember();
                    atm.AccountId = objAccount.Id;
                    atm.UserId = oUser.Id; 
                    insert atm;
                          
                    Account_Profile__c newAccountProfile = new Account_Profile__c();
                    newAccountProfile.Account__c = objAccount.Id;
                    insert newAccountProfile;
                   
                    Contact_Profile__c cp = new Contact_Profile__c();
                    cp.Contact__c = objCon.Id;
                    insert cp; 
              }
         }
        
        
         
        
        System.runAs(oUser) {

            //choose a valid record type for the trigger to fire
            recordType[] oRecType = [select Id from recordType where sobjecttype = 'Physician_Visit__c' and Name = 'INDSU Sales Planned'];
            
            List<Physician_Visit__c> listPhysicianVisit = new List<Physician_Visit__c>();
            //create a new physician visit
            Physician_Visit__c oPhyVisit = new Physician_Visit__c();
            oPhyVisit.Physician__c = objCon.Id;
            oPhyVisit.recordTypeId = oRecType[0].Id;
            oPhyVisit.Planned_Call__c = true;
            oPhyVisit.OwnerId = oUser.Id;
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
            oPhyVisit.Hours_in_Surgery__c = '2';
            oPhyVisit.Doctor_Segmentation__c = 'A';
            listPhysicianVisit.add(oPhyVisit);
            
            Physician_Visit__c oPhyVisit1 = new Physician_Visit__c();
            oPhyVisit1.Physician__c = objCon.Id;
            oPhyVisit1.recordTypeId = oRecType[0].Id;
            oPhyVisit1.Planned_Call__c = true;
            oPhyVisit1.OwnerId = oUser.Id;
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
            oPhyVisit1.Hours_in_Surgery__c = '2';
            oPhyVisit1.Doctor_Segmentation__c = 'B';
            listPhysicianVisit.add(oPhyVisit1);
            
            Physician_Visit__c oPhyVisit2 = new Physician_Visit__c();
            oPhyVisit2.Physician__c = objCon.Id;
            oPhyVisit2.recordTypeId = oRecType[0].Id;
            oPhyVisit2.Planned_Call__c = true;
            oPhyVisit2.OwnerId = oUser.Id;
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
            oPhyVisit2.Hours_in_Surgery__c = '2';
            oPhyVisit2.Doctor_Segmentation__c = 'C';
            listPhysicianVisit.add(oPhyVisit2);
            
            Physician_Visit__c oPhyVisit3 = new Physician_Visit__c();
            oPhyVisit3.Physician__c = objCon.Id;
            oPhyVisit3.recordTypeId = oRecType[0].Id;
            oPhyVisit3.Planned_Call__c = true;
            oPhyVisit3.OwnerId = oUser.Id;
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
            oPhyVisit3.Hours_in_Surgery__c = '2';
            oPhyVisit3.Doctor_Segmentation__c = 'D';
            listPhysicianVisit.add(oPhyVisit3);
            
            
            insert listPhysicianVisit; 
            
            oPhyVisit.status__c = 'Completed';
            oPhyVisit1.status__c = 'Completed';
            oPhyVisit2.status__c = 'Completed';
            oPhyVisit3.status__c = 'Completed';
            
            update listPhysicianVisit;
            //---------------------
            oPhyVisit.Planned_Call__c = false;
            oPhyVisit.Doctor_Segmentation__c = 'A';
           
            
            oPhyVisit1.Planned_Call__c = false;
            oPhyVisit1.Doctor_Segmentation__c = 'B';
           
            
            oPhyVisit2.Planned_Call__c = false;
            oPhyVisit2.Doctor_Segmentation__c = 'C';
             
             
            oPhyVisit3.Planned_Call__c = false;
            oPhyVisit3.Doctor_Segmentation__c = 'D';
            
            clsPhysicianVisitUpdate.isInsert = false; 
            update listPhysicianVisit;
           
            
            Monthly_Implantation_Detail__c monthlyImplantation = new Monthly_Implantation_Detail__c();
            monthlyImplantation.Physician_Name__c = objCon.Id;
            monthlyImplantation.Month__c = String.ValueOf(oPhyVisit.Activity_Date__c.Month());
            monthlyImplantation.Year__c = oPhyVisit.Activity_Date__c.Year();
            insert monthlyImplantation;
            
            oPhyVisit.Joint_Call_With_ASM__c = true; 
            oPhyVisit.status__c = 'Completed';
            clsPhysicianVisitUpdate.isInsert = false;
            oPhyVisit.Hours_in_Surgery__c = '5';
            oPhyVisit.Call_Objective_Achieved__c = true;
            
            oPhyVisit1.Joint_Call_With_ASM__c = true; 
            oPhyVisit1.status__c = 'Completed';
            //clsPhysicianVisitUpdate.isInsert = false;
            oPhyVisit1.Hours_in_Surgery__c = '1';
            oPhyVisit1.Call_Objective_Achieved__c = true;
            
            oPhyVisit2.status__c = 'Completed';
            oPhyVisit2.Call_Objective_Achieved__c = true;
            
            oPhyVisit3.status__c = 'Completed';
            oPhyVisit3.Call_Objective_Achieved__c = true;
            
            update listPhysicianVisit;
            
            Effectiveness_Summary__c effectivenessSummary = new Effectiveness_Summary__c();
            effectivenessSummary.Date__c = oPhyVisit.Activity_Date__c;
            effectivenessSummary.ownerId = oPhyVisit.OwnerId;            
            effectivenessSummary.OT_Hours__c = 3;
            
            
            insert effectivenessSummary ;
            
           
            
           
            
            /*oPhyVisit.Hours_in_Surgery__c = '3';
            oPhyVisit.Doctor_Segmentation__c = 'B';
            update oPhyVisit;*/
           /* try {  
                update oPhyVisit;
            }
            catch(exception e)

{
System.debug(Logginglevel.ERROR, 'ERROR: ' + e.getMessage() );
} */

            //query the event that was created as a result of insertion of a physician visit
            Event oEvt = [Select Join_Call__c from Event where Physician_Visit_Id__c = :oPhyVisit.Id];
            
            oEvt.Join_Call__c = true;

            //update the event to mark it as joint call to fire the event trigger
            update oEvt;
            
            clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk = false;
            
            //oPhyVisit.status__c = 'Completed';
            //oPhyVisit.Joint_Call_With_ASM__c = true;

            //update the physician vist to objetive achieved so that the update trigger fires
            //update oPhyVisit;
            
            
        }           
    }
    static testMethod void JtCallJtFieldWorkTest1(){
        
    //  Joint_Field_Work__c jtFldWork = new Joint_Field_Work__c();
        
    //  insert jtFldWork;
        
         
    }
    
}