/*
* 
* Test class for Triggers on Physician Insert and Update
* PhysicianVisit_BU_UpdateCompetitorInformation, PhysicianVisit_AU_UpdateFutureVisits, PhysicianVisit_AI_UpdateUnplannedCall
* Author                        |Author-Email                                      |Date        |Comment
* ------------------------------|------------------------------------------------- |------------|----------------------------------------------------
* DeepaLakshmi.R                |deepalakshmi.venkatesh@listertechnologies.com     |07.05.2010  |First Draft
*Santosh Kumar S     | santosh.sriram@listertechnologies.com    | 10.03.2011  | Changing INDSU to APACSU System Admin
* Sridhar Aluru      | sridhar.aluru@bausch.com                 | 28-05-2015  | Updating to satisfy the new Validation Rule implemented for India Users
*/



@isTest
class ClsPhysicianVisit_Test
{
    public static testMethod void physicianVisitTest()
    {
        // Getting Profile for INDSU System Administrator and creating User for that Profile       
        //Profile oProfile = [SELECT Id FROM profile WHERE name = 'BL: System Admin SSO' limit 1]; 
        Profile oProfile = [SELECT Id FROM profile WHERE name = 'INDSU Sales Rep' limit 1]; 
        User oUser  = [SELECT Id, Name, email,lastname , emailencodingkey, localesidkey, profileid ,timezonesidkey, username
  FROM User 
  WHERE profileid =: oProfile.Id AND IsActive = True limit 1];
        /*new User(alias = 'mgruser', 
                             email='mgruser@testorg.com', 
                             emailencodingkey='UTF-8',
                             lastname='lastname2',
                             languagelocalekey='en_US', 
                             localesidkey='en_US', 
                             profileid = oProfile.Id, 
                             timezonesidkey='America/Los_Angeles',
                             username='mgruser@testorg.com');
       insert oManager; */
              
       /* User oUser = new User(alias = 'standt',
        email='standarduser3@testorg.com',
        emailencodingkey='UTF-8',
        lastname='Testing3',
        languagelocalekey='en_US',
        localesidkey='en_US',
        managerId = oManager.Id,
        profileid = oProfile.Id,
        timezonesidkey='America/Los_Angeles',
        username='standarduser3@testorg.com'); 
        //insert oUser; */
        User u = oUser;
        System.runAs(oUser) 
        {            
            /*List<RecordType> list_recordType = new List<RecordType>();                        
            // Getting Id for recordType INDSU Direct, INDSU Indirect            
            list_recordType = [SELECT Id FROM RecordType                            
            WHERE Name IN ('INDSU Direct','INDSU Indirect')                             
            AND SObjectType='Account'];   */  

            Map<Integer,String> map_Months = new Map<Integer,String>();
            //Create a map of Months in Integer and 'MMM' format            
            for(integer i=0;i<12;i++)            
            {                
                DateTime dtMonth = dateTime.newInstance(2010,1,1);                
                map_Months.put(i+1,dtMonth.addmonths(i).format('MMM'));            
            }
            
            //Insert Account and Contact
            Account oAccount = new Account();          
            oAccount.OwnerId = oUser.Id;            
            oAccount.Name = 'Test'; 
           // oAccount.recordTypeId = list_recordType[0].Id;          
          //  insert oAccount;
            
            Contact oContact = new Contact();           
            oContact.AccountId = oAccount.Id;                        
            oContact.LastName = 'Test Contact';
            insert oContact;  

            Account oAccount1 = new Account();          
            oAccount1.OwnerId = oUser.Id;            
            oAccount1.Name = 'Test'; 
           // oAccount1.recordTypeId = list_recordType[0].Id;          
           // insert oAccount1;
            
            Contact oContact1 = new Contact();           
            oContact1.AccountId = oAccount1.Id;                        
            oContact1.LastName = 'Test Contact1';
           // insert oContact1; 
            Map<Id, Monthly_Implantation_Detail__c> map_monthlyImplantDetails = new Map<Id, Monthly_Implantation_Detail__c>();
           
            //Insert and update Physician visit
            RecordType oRecordType = [Select Id, Name from RecordType where Name = 'INDSU Sales Unplanned' and sObjectType = 'Physician_Visit__c' limit 1];
           // RecordType oRecordType1 = [SELECT Id, Name  FROM RecordType WHERE  Name  = 'INDSU Sales Planned' AND sObjectType = 'Physician_Visit__c'];   
            Physician_Visit__c oPhysicianVisit1 = new Physician_Visit__c();
            //oPhysicianVisit1.Name = 'Test1';
            oPhysicianVisit1.RecordTypeId = oRecordType.Id;
            //oPhysicianVisit1.Activity_Date__c = date.newInstance(system.today().year(),system.today().month(),1);
            oPhysicianVisit1.Activity_Date__c = System.today()-1;
            oPhysicianVisit1.Physician__c = oContact.Id;
            oPhysicianVisit1.Status__c = 'Open';
            oPhysicianVisit1.Session__c = 'AM';
            oPhysicianVisit1.Planned_Call__c = false;
            oPhysicianVisit1.OwnerId = u.Id;
            oPhysicianVisit1.Start_Time__c = Datetime.Now();
            oPhysicianVisit1.End_Time__c = Datetime.Now();
            oPhysicianVisit1.Joint_Call_With_ASM__c = False;
            oPhysicianVisit1.Hours_in_Surgery__c = '1.5';
           
             oPhysicianVisit1.Last_Activity__c=null;
           
             system.debug('oPhysicianVisit1 Before insert : '+oPhysicianVisit1);
            
           
            Insert oPhysicianVisit1;
            system.debug('oPhysicianVisit After insert : '+oPhysicianVisit1);
            clsPhysicianVisitUpdate.isExecute = false; 
            clsPhysicianVisitUpdate.isInsert = false;
            
            //oPhysicianVisit1.RecordTypeId = oRecordType1.Id;
            oPhysicianVisit1.Session__c = 'AM';
            oPhysicianVisit1.OwnerId = u.Id;
            clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk = false;
            oPhysicianVisit1.Status__c = 'Open';
            oPhysicianVisit1.Joint_Call_With_ASM__c = true;
            oPhysicianVisit1.Hours_in_Surgery__c = '';
            oPhysicianVisit1.Akreos_MIL__c=96;
            oPhysicianVisit1.Crystalens__c=65;
            oPhysicianVisit1.Outcome_1__c = 'Agreee to further consider';
            oPhysicianVisit1.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
            oPhysicianVisit1.Key_Driver_1__c = 'AKREOS';
            update oPhysicianVisit1;
                        
            system.debug('oPhysicianVisit1'+oPhysicianVisit1);
                         
     
           clsPhysicianVisitUpdate.isInsert = false;
           
            Physician_Visit__c oPhysicianVisit2 = new Physician_Visit__c();
            //oPhysicianVisit2.Name = 'Test2';
            oPhysicianVisit2.RecordTypeId = oRecordType.Id;
           // oPhysicianVisit2.Activity_Date__c = date.newInstance(system.today().year(),system.today().month(),2);
           oPhysicianVisit2.Activity_Date__c = System.today();
            oPhysicianVisit2.Physician__c = oContact.Id;
            oPhysicianVisit2.Status__c = 'Open';
            oPhysicianVisit2.Akreos_MIL__c=55;
            oPhysicianVisit2.AKREOS_AO__c=66;
            oPhysicianVisit2.Call_Ojective_CHN__c='others';
            oPhysicianVisit2.Others_Please_Enter__c='NULL';
            //insert oPhysicianVisit2;
           
           
            system.debug('AKREOS_AO__cttt'+oPhysicianVisit1); 
            //oPhysicianVisit2.Name = 'Test123';
            clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk = false;
            oPhysicianVisit2.Status__c = 'Completed';
            oPhysicianVisit2.Hours_in_Surgery__c = null;
            oPhysicianVisit2.Akreos_MIL__c=35;
            oPhysicianVisit2.AKREOS_AO__c=85;
            //update oPhysicianVisit2;
            
          // clsPhysicianVisitUpdate.isInsert = false;
            
            Physician_Visit__c oPhysicianVisit3 = new Physician_Visit__c();
            //oPhysicianVisit3.Name = 'Test3';
            oPhysicianVisit3.RecordTypeId = oRecordType.Id;
           // oPhysicianVisit3.Activity_Date__c = date.newInstance(system.today().year(),system.today().month(),3); 
           oPhysicianVisit3.Activity_Date__c = System.today();
            oPhysicianVisit3.Physician__c = oContact.Id;
            oPhysicianVisit3.Status__c = 'Open';
            oPhysicianVisit3.Call_Ojective_CHN__c='others';
             oPhysicianVisit3.Others_Please_Enter__c='NULL';
          //  insert oPhysicianVisit3;   
             
            clsPhysicianVisitUpdate.isExecute = false; 
            clsPhysicianVisitUpdate.isInsert = false;
            //oPhysicianVisit1.Name = 'Test123';
            clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk = false;
            oPhysicianVisit1.Status__c = 'Completed';
            oPhysicianVisit1.Akreos_MIL__c=96;
            oPhysicianVisit1.AKREOS_AO__c=65;
           // update oPhysicianVisit1;
             
           Contact_Profile__c cp = new Contact_Profile__c();
           cp.Contact__c = oPhysicianVisit1.Physician__c;
           cp.Doctor_Segmentation__c = 'Clinical Innovator';
           //insert cp; 
             
           // RecordType oCompRType = [Select Id, Name from RecordType where Name = 'APACSU Monthly Implantation Detail' 
          //  and sObjectType = 'Monthly_Implantation_Detail__c' limit 1];
            
                      
            Monthly_Implantation_Detail__c oCompProduct = new Monthly_Implantation_Detail__c();
            oCompProduct.Current_Total_Implantations__c = 93;
                        oCompProduct.AKREOS_MIL__c = 68; 
            oCompProduct.AKREOS_AO__c = 11; 
            oCompProduct.AKREOS__c = 12; 
            oCompProduct.LI61_AO__c = 13; 
            oCompProduct.LI61_SE__c = 14; 
            oCompProduct.LI61AOV__c = 15; 
            oCompProduct.Crystalens__c = 17.87; 
            oCompProduct.Physician_Name__c = oContact.Id;
            oCompProduct.month__c = map_Months.get(system.today().month());
            oCompProduct.year__c = system.today().year();
            oCompProduct.Expiry_Date__c = System.Today().adddays(+2);
            oCompProduct.Bundling_Competitor__c = 'Others';
          //  oCompProduct.RecordTypeId = oCompRType.Id;
            insert oCompProduct;
            
            clsPhysicianVisitUpdate.isUpdate = false; 
            clsPhysicianVisitUpdate.isInsert = false;
            //oPhysicianVisit3.Name = 'Test123';
       
            oPhysicianVisit3.Status__c = 'Completed';
            clsPhysicianVisitUpdate.isUpdate = false; 
            clsPhysicianVisitUpdate.isInsert = false;
            clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk = false;
            //update oPhysicianVisit3;
               
          //  RecordType oRecordType1 = [Select Id, Name from RecordType where Name = 'APACSU Sales UnPlanned' and sObjectType = 'Physician_Visit__c' limit 1];
                            
            Physician_Visit__c oPhysicianVisit6 = new Physician_Visit__c();
            //oPhysicianVisit1.Name = 'Test1';
            //oPhysicianVisit6.RecordTypeId = oRecordType1.Id;
            //oPhysicianVisit1.Activity_Date__c = date.newInstance(system.today().year(),system.today().month(),1);
            oPhysicianVisit6.Activity_Date__c = System.today();
            oPhysicianVisit6.Physician__c = oContact.Id;
            oPhysicianVisit6.Status__c = 'Open';
            oPhysicianVisit6.Call_Ojective_CHN__c='others';
             oPhysicianVisit6.Others_Please_Enter__c='NULL';
             oPhysicianVisit6.Akreos_MIL__c=86;
            oPhysicianVisit6.Crystalens__c=65;
           // insert oPhysicianVisit6;
            
            oPhysicianVisit6.Status__c ='Completed';
            clsPhysicianVisitUpdate.isUpdate = false; 
            clsPhysicianVisitUpdate.isInsert = false;
           // clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk = false;
             clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk = false;
             oPhysicianVisit6.Akreos_MIL__c=186;
            oPhysicianVisit6.Crystalens__c=165;
            // update oPhysicianVisit6;
                       
             
                     }
        }
        
       public static testMethod void physicianVisitTest1()
       {
        // Getting Profile for INDSU System Administrator and creating User for that Profile       
        Profile oProfile = [SELECT Id FROM profile WHERE name = 'INDSU Sales Manager' limit 1]; 
        User oUser  = [SELECT Id, Name, email,lastname , emailencodingkey, localesidkey, profileid ,timezonesidkey, username
  FROM User 
  WHERE profileid =: oProfile.Id AND IsActive = True limit 1];
        System.runAs(oUser) 
        {            
           /* List<RecordType> list_recordType = new List<RecordType>();                        
            // Getting Id for recordType INDSU Direct, INDSU Indirect            
            list_recordType = [SELECT Id FROM RecordType                            
            WHERE Name IN ('INDSU Direct','INDSU Indirect')                             
            AND SObjectType='Account'];     */

            Map<Integer,String> map_Months = new Map<Integer,String>();
            //Create a map of Months in Integer and 'MMM' format            
            for(integer i=0;i<12;i++)            
            {                
                DateTime dtMonth = dateTime.newInstance(2010,1,1);                
                map_Months.put(i+1,dtMonth.addmonths(i).format('MMM'));            
            }
            
            //Insert Account and Contact
            Account oAccount = new Account();          
            oAccount.OwnerId = oUser.Id;            
            oAccount.Name = 'Test'; 
           // oAccount.recordTypeId = list_recordType[0].Id;          
           // insert oAccount;
            
            Contact oContact = new Contact();           
            oContact.AccountId = oAccount.Id;                        
            oContact.LastName = 'Test Contact';
            insert oContact;  

            Account oAccount1 = new Account();          
            oAccount1.OwnerId = oUser.Id;            
            oAccount1.Name = 'Test'; 
          //  oAccount1.recordTypeId = list_recordType[0].Id;          
           // insert oAccount1;
            
            Contact oContact1 = new Contact();           
            oContact1.AccountId = oAccount1.Id;                        
            oContact1.LastName = 'Test Contact1';
           // insert oContact1; 
            
          //  List<Physician_Visit__c> oPhysicianVisit7 = new List<Physician_Visit__c>();
           //  oPhysicianVisit7 =[Select Akreos_MIL__c,AKREOS_AO__c,AKREOS__c from Physician_Visit__c where Id='01280000000YLuiAAG'];
           //  System.debug('oPhysicianVisit7 '+oPhysicianVisit7); 
            //Insert and update Physician visit
            RecordType oRecordType = [Select Id, Name from RecordType where Name = 'APACSU Sales Planned' and sObjectType = 'Physician_Visit__c'];
            System.debug('oRecordType '+oRecordType);           
            Physician_Visit__c oPhysicianVisit1 = new Physician_Visit__c();
            //oPhysicianVisit1.Name = 'Test1';
            oPhysicianVisit1.RecordTypeId = oRecordType.Id;
            //oPhysicianVisit1.Activity_Date__c = date.newInstance(system.today().year(),system.today().month(),1);
            oPhysicianVisit1.Activity_Date__c = System.today();
            oPhysicianVisit1.Physician__c = oContact.Id;
            oPhysicianVisit1.Status__c = 'Open';
            oPhysicianVisit1.Akreos_MIL__c=18;
            oPhysicianVisit1.AKREOS_AO__c=16;
            oPhysicianVisit1.Outcome_1__c = 'Agreee to further consider';
            oPhysicianVisit1.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
            oPhysicianVisit1.Key_Driver_1__c = 'AKREOS';
            //insert oPhysicianVisit1;
            
            
            clsPhysicianVisitUpdate.isExecute = false; 
            clsPhysicianVisitUpdate.isInsert = false;
            //oPhysicianVisit1.Name = 'Test123';
            clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk = false;
            oPhysicianVisit1.Status__c = 'Completed';
            
          /*  Physician_Visit__c[] pvUpdate = [select id,Activity_Date__c from Physician_Visit__c where Akreos_MIL__c= 18];
            
            pvUpdate[0].Akreos_MIL__c= 20;
            
            update pvUpdate;*/
            
            oPhysicianVisit1.Session__c = 'AM';
            oPhysicianVisit1.Akreos_MIL__c=21;
            oPhysicianVisit1.AKREOS_AO__c=22;
            oPhysicianVisit1.Status__c = 'Open';
            //update oPhysicianVisit1; 
           system.debug('Akreos_MIL__c'+oPhysicianVisit1.Akreos_MIL__c);
            
           clsPhysicianVisitUpdate.isInsert = false;
          
            Physician_Visit__c oPhysicianVisit2 = new Physician_Visit__c();
            //oPhysicianVisit2.Name = 'Test2';
            oPhysicianVisit2.RecordTypeId = oRecordType.Id;
           // oPhysicianVisit2.Activity_Date__c = date.newInstance(system.today().year(),system.today().month(),2);
            oPhysicianVisit2.Activity_Date__c = System.today()+1;
            oPhysicianVisit2.Physician__c = oContact.Id;
            oPhysicianVisit2.Status__c = 'Open';
            oPhysicianVisit2.Akreos_MIL__c=19;
            oPhysicianVisit2.AKREOS_AO__c=20;
            oPhysicianVisit2.Outcome_1__c = 'Agreee to further consider';
            oPhysicianVisit2.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
            oPhysicianVisit2.Key_Driver_1__c = 'AKREOS';
           // insert oPhysicianVisit2;
            
            system.debug('oPhysicianVisit1tt'+oPhysicianVisit1); 
            //oPhysicianVisit2.Name = 'Test123';
            clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk = false;
            oPhysicianVisit2.Status__c = 'Completed';
            oPhysicianVisit2.Akreos_MIL__c=23;
            oPhysicianVisit2.AKREOS_AO__c=24;
            //update oPhysicianVisit2;
            system.debug('AKREOS_AO__cttt'+oPhysicianVisit2); 
           // system.debug('trigger.OldMap.get(pv.Id).Akreos_MIL__c'+trigger.OldMap.get(oPhysicianVisit1.Id).Akreos_MIL__c);
            clsPhysicianVisitUpdate.isInsert = false;
            
            Physician_Visit__c oPhysicianVisit3 = new Physician_Visit__c();
            //oPhysicianVisit3.Name = 'Test3';
            oPhysicianVisit3.RecordTypeId = oRecordType.Id;
           // oPhysicianVisit3.Activity_Date__c = date.newInstance(system.today().year(),system.today().month(),3); 
            oPhysicianVisit3.Activity_Date__c = System.today()+2;
            oPhysicianVisit3.Physician__c = oContact.Id;
            oPhysicianVisit3.Status__c = 'Open';
            oPhysicianVisit3.Akreos_MIL__c=21;
            oPhysicianVisit3.Outcome_1__c = 'Agreee to further consider';
            oPhysicianVisit3.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
            oPhysicianVisit3.Key_Driver_1__c = 'AKREOS';
            oPhysicianVisit3.AKREOS_AO__c=22;
            insert oPhysicianVisit3;   
                                
            /*system.debug('oPhysicianVisit1tt'+oPhysicianVisit1); 
            //oPhysicianVisit2.Name = 'Test123';
            clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk = false;
            oPhysicianVisit2.Status__c = 'Completed';
            oPhysicianVisit2.Akreos_MIL__c=23;
            oPhysicianVisit2.AKREOS_AO__c=24;
            update oPhysicianVisit2;
            system.debug('AKREOS_AO__cttt'+oPhysicianVisit2); */
           // RecordType oCompRType = [Select Id, Name from RecordType where Name = 'INDSU Monthly Implantation Detail' 
            //and sObjectType = 'Monthly_Implantation_Detail__c' limit 1];
            
                                     
            clsPhysicianVisitUpdate.isUpdate = false; 
            clsPhysicianVisitUpdate.isInsert = false;
            //oPhysicianVisit3.Name = 'Test123';
            clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk = false;
            oPhysicianVisit3.Status__c = 'Completed';
            oPhysicianVisit3.Akreos_MIL__c=85;
            oPhysicianVisit3.AKREOS_AO__c=26;
            oPhysicianVisit3.AKREOS__c=26;
            oPhysicianVisit3.LI61_AO__c=26;
            oPhysicianVisit3.LI61_SE__c=26;
            oPhysicianVisit3.LI61AOV__c=26;
            oPhysicianVisit3.Crystalens__c=26;
            oPhysicianVisit3.AMO__c=26;
            oPhysicianVisit3.Hours_in_Surgery__c ='3.5';
            oPhysicianVisit3.Envista__c = 45;
            oPhysicianVisit3.Hanitta__c=26;
            oPhysicianVisit3.Acrysof_3_piece__c=26;
            oPhysicianVisit3.Acrysof_IQ__c=26;
            oPhysicianVisit3.Rayner__c=26;
            oPhysicianVisit3.Sensar__c=26;
            oPhysicianVisit3.Tecnis_Acrylic__c=26;
            oPhysicianVisit3.Zeiss__c=26;
            oPhysicianVisit3.Others__c=26;
            oPhysicianVisit3.Akreos_MI_60__c=26;
            oPhysicianVisit3.Akreos_Adapt__c=26;
            oPhysicianVisit3.Acrysof_ReStor__c=26;
            oPhysicianVisit3.Acrysof_Toric__c=26;
            oPhysicianVisit3.ReZoom__c=26;
            oPhysicianVisit3.Tecnis__c=26;
            oPhysicianVisit3.Tecnis_Multifocal__c=26;
            oPhysicianVisit3.Canon_Staar__c=26;
            oPhysicianVisit3.Hoya__c=26;
                        
          //  update oPhysicianVisit3;    
            
            oPhysicianVisit3.Status__c = 'Completed';
            oPhysicianVisit3.Akreos_MIL__c=95;
            oPhysicianVisit3.AKREOS_AO__c=86;
            oPhysicianVisit3.AKREOS__c=86;
            oPhysicianVisit3.LI61_AO__c=56;
            oPhysicianVisit3.LI61_SE__c=126;
            oPhysicianVisit3.LI61AOV__c=216;
            oPhysicianVisit3.Crystalens__c=126;
            oPhysicianVisit3.AMO__c=261;
            oPhysicianVisit3.Hours_in_Surgery__c ='3.0';
            oPhysicianVisit3.Envista__c = 40;
            oPhysicianVisit3.Hanitta__c=216;
            oPhysicianVisit3.Acrysof_3_piece__c=126;
            oPhysicianVisit3.Acrysof_IQ__c=216;
            oPhysicianVisit3.Rayner__c=126;
            oPhysicianVisit3.Sensar__c=216;
            oPhysicianVisit3.Tecnis_Acrylic__c=261;
            oPhysicianVisit3.Zeiss__c=126;
            oPhysicianVisit3.Others__c=216;
            oPhysicianVisit3.Akreos_MI_60__c=216;
            oPhysicianVisit3.Akreos_Adapt__c=216;
            oPhysicianVisit3.Acrysof_ReStor__c=261;
            oPhysicianVisit3.Acrysof_Toric__c=126;
            oPhysicianVisit3.ReZoom__c=126;
            oPhysicianVisit3.Tecnis__c=261;
            oPhysicianVisit3.Tecnis_Multifocal__c=216;
            oPhysicianVisit3.Canon_Staar__c=126;
            oPhysicianVisit3.Hoya__c=216;
            clsPhysicianVisitUpdate.isUpdate = false; 
            clsPhysicianVisitUpdate.isInsert = false;
            clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk = false;
          //  update oPhysicianVisit3;
            
            
            Contact_Profile__c cp = new Contact_Profile__c();
           cp.Contact__c = oPhysicianVisit1.Physician__c;
           cp.Doctor_Segmentation__c = 'Clinical Innovator';
          // insert cp; 
                   
           RecordType list_phy_recordType = [SELECT Id, Name  FROM RecordType WHERE  Name  = 'INDSU Sales Planned' AND sObjectType = 'Physician_Visit__c'];
            
           Physician_Visit__c oPhysicianVisit4 = new Physician_Visit__c();
            //oPhysicianVisit4.Name = 'Test1';
            oPhysicianVisit4.Akreos_MIL__c = 14.0;
            oPhysicianVisit4.AKREOS_AO__c = 17.0;
            oPhysicianVisit4.RecordTypeId = list_phy_recordType.Id;
          // START -- Updated by SRIDHAR ALURU to satisfy Validation Rule implemented for INDIA Users
          //  oPhysicianVisit4.Activity_Date__c = date.newInstance(system.today().year(),system.today().month(),1);
            oPhysicianVisit4.Activity_Date__c = System.today()-2;
          // END -- Updated by SRIDHAR ALURU to satisfy Validation Rule implemented for INDIA Users
            oPhysicianVisit4.Physician__c = oContact.Id;
            oPhysicianVisit4.Outcome_1__c = 'Agreee to further consider';
            oPhysicianVisit4.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
            oPhysicianVisit4.Key_Driver_1__c = 'AKREOS';
           insert oPhysicianVisit4;
            
            oPhysicianVisit4.Status__c = 'Completed';
            clsPhysicianVisitUpdate.isExecute = FALSE;
            clsPhysicianVisitUpdate.isInsert = FALSE;
            clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk = FALSE;
            
           //update oPhysicianVisit4;
      
          } 

       }
}