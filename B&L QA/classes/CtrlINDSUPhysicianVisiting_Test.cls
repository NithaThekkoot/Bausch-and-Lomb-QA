@isTest
class CtrlINDSUPhysicianVisiting_Test{
    
   @isTest static void testMethodCtrlINDSUPhysicianVisiting () {       
               
           CtrlINDSUPhysicianVisiting objpg = new CtrlINDSUPhysicianVisiting(new ApexPages.StandardController(new Physician_Visit__c()));        
            
           CtrlINDSUPhysicianVisiting obj = new CtrlINDSUPhysicianVisiting ();            
                    
           Integer idays = obj.getintSelectedDays();
           obj.setintSelectedDays(3);
           obj.setintSelectedDays(0);
           obj.BindDataTable();
           obj.intSelectedDays = 3;
           obj.BindDataTable();  
           List<SelectOption> lst = obj.getViewOptions();
           PageReference pgph = obj.getPhysicianVisitDetails();
           PageReference pgSave = obj.save();
           PageReference pgnew = obj.newUnplannedvisit();
              
           Profile oProfileBLSSO = [SELECT Id FROM profile WHERE name = 'BL: System Admin SSO' limit 1]; 
           Profile oProfileIndia=[SELECT Id FROM profile WHERE name = 'INDSU Sales Rep' limit 1];
            
                Map<string,UserRole> role = new Map<string,UserRole>();
                for(UserRole r:[select Id,Name from UserRole where name in ('INDSU Sales Rep (South1)','INDSU Area Sales Manager (South 1)') ]){
                    role.put(r.Name,r);
                }
        
          User oUserBLSSO  = new User(alias = 'mg456', 
                                     email='mgruser456@testorg.com', 
                                     emailencodingkey='UTF-8',
                                     lastname='lastname2',
                                     languagelocalekey='en_US', 
                                     localesidkey='en_US', 
                                     profileid = oProfileBLSSO.Id, 
                                     timezonesidkey='America/Los_Angeles',
                                     username='mgruser456789@testorg.com',
                                     UserRole = role.get('INDSU Area Sales Manager (South 1)'));
                insert oUserBLSSO;         
          User oUserIndia  = new User(alias = 'mg4561', 
                                     email='mgruser456@testorg1.com', 
                                     emailencodingkey='UTF-8',
                                     lastname='lastname2',
                                     languagelocalekey='en_US', 
                                     localesidkey='en_US', 
                                     profileid = oProfileIndia.Id, 
                                     timezonesidkey='America/Los_Angeles',
                                     username='mgruser456789@testorg1.com',
                                     UserRole = role.get('INDSU Sales Rep (South1)'));  
                                     
                     Insert oUserIndia;                                                                                                                                                                            
           
            Map<string,String> map_RecordType = new Map<string,String>();
                for(RecordType rt : [Select Id, Name from RecordType where Name in ('INDSU Indirect','INDSU Contact','INDSU Sales Unplanned','INDSU Sales Planned','INDSU Monthly Implantation Detail') and sObjectType in ('Physician_Visit__c','Account','Contact')])
                {
                    map_RecordType.put(rt.Name,rt.Id);
                }
           
           Physician_Visit__c pv = new Physician_Visit__c();
           
           
           
            /**********Account **************/
                Account oAccount = new Account();          
                oAccount.OwnerId = UserInfo.getUserId();            
                oAccount.Name = 'Test'; 
                oAccount.recordTypeId = map_RecordType.get('INDSU Indirect');          
                insert oAccount;
       
           /**********Contact **************/
                Contact oContact1 = new Contact();           
                oContact1.AccountId = oAccount.Id;                        
                oContact1.LastName = 'Test Contact1';
                oContact1.recordTypeId = map_RecordType.get('INDSU Contact');   
                insert oContact1 ;                   
                             
                      
             List<Physician_Visit__c> testpvList = new List<Physician_Visit__c>();               
                                 
                        Physician_Visit__c oPhysicianVisit = new Physician_Visit__c();                        
                        oPhysicianVisit.Activity_Date__c = System.today()-1;
                        oPhysicianVisit.Physician__c = oContact1.Id;
                        oPhysicianVisit.Status__c = 'Open';
                        oPhysicianVisit.Session__c = 'AM';
                        oPhysicianVisit.Planned_Call__c = false;
                        oPhysicianVisit.OwnerId = oUserIndia.Id;
                        oPhysicianVisit.Start_Time__c = Datetime.Now();
                        oPhysicianVisit.End_Time__c = Datetime.Now();
                        oPhysicianVisit.Joint_Call_With_ASM__c = False;           
                        oPhysicianVisit.Last_Activity__c=null;
                        oPhysicianVisit.Visit_Call__c = True;
                        oPhysicianVisit.Product_1__c  = 'Akreos MI-60';
                        oPhysicianVisit.Product_2__c = 'Akreos AO';
                        oPhysicianVisit.OT_Hours__c = True; 
                        oPhysicianVisit.Akreos_AO__c=123;
                        oPhysicianVisit.Akreos_Adapt__c=123;
                        oPhysicianVisit.Akreos_MIL__c=123;
                        oPhysicianVisit.Envista__c=123;
                        oPhysicianVisit.Crystalens__c=123;
                        oPhysicianVisit.Acrysof_IQ__c=123;
                        oPhysicianVisit.Hours_in_Surgery__c = '6.5';                                      
                        testpvList.add(oPhysicianVisit); 
                        
                        Physician_Visit__c oPhysicianVisit1 = new Physician_Visit__c();                        
                        oPhysicianVisit1.Activity_Date__c = System.today()-1;
                        oPhysicianVisit1.Physician__c = oContact1.Id;
                        oPhysicianVisit1.Status__c = 'Open';
                        oPhysicianVisit1.Session__c = 'AM';
                        oPhysicianVisit1.Planned_Call__c = false;
                        oPhysicianVisit1.OwnerId = oUserIndia.Id;
                        oPhysicianVisit1.Start_Time__c = Datetime.Now();
                        oPhysicianVisit1.End_Time__c = Datetime.Now();
                        oPhysicianVisit1.Joint_Call_With_ASM__c = False;           
                        oPhysicianVisit1.Last_Activity__c=null;
                        oPhysicianVisit1.Visit_Call__c = True;
                        oPhysicianVisit1.Product_1__c  = 'Akreos MI-60';
                        oPhysicianVisit1.Product_2__c = 'Akreos AO';
                        oPhysicianVisit1.OT_Hours__c = True; 
                        oPhysicianVisit1.Hours_in_Surgery__c = '6.5'; 
                        oPhysicianVisit1.Akreos_Adapt__c=12345;
                        
                        testpvList.add(oPhysicianVisit1);   
                        ////
          List<Physician_Visit__c> testpvList2 = new List<Physician_Visit__c>();               
                                 
                        Physician_Visit__c oPhysicianVisit2 = new Physician_Visit__c();                        
                        oPhysicianVisit2.Activity_Date__c = System.today()-1;
                        oPhysicianVisit2.Physician__c = oContact1.Id;
                        oPhysicianVisit2.Status__c = 'Open';
                        oPhysicianVisit2.Session__c = 'AM';
                        oPhysicianVisit2.Planned_Call__c = false;
                        oPhysicianVisit2.OwnerId = oUserIndia.Id;
                        oPhysicianVisit2.Start_Time__c = Datetime.Now();
                        oPhysicianVisit2.End_Time__c = Datetime.Now();
                        oPhysicianVisit2.Joint_Call_With_ASM__c = False;           
                        oPhysicianVisit2.Last_Activity__c=null;
                        oPhysicianVisit2.Visit_Call__c = True;
                        oPhysicianVisit2.Product_1__c  = 'Akreos MI-60';
                        oPhysicianVisit2.Product_2__c = 'Akreos AO';
                        oPhysicianVisit2.OT_Hours__c = True; 
                        oPhysicianVisit.Akreos_AO__c=123;
                        oPhysicianVisit.Akreos_Adapt__c=123;
                        oPhysicianVisit.Akreos_MIL__c=123;
                        oPhysicianVisit.Envista__c=123;
                        oPhysicianVisit.Crystalens__c=123;                 
                        oPhysicianVisit2.Hours_in_Surgery__c = '6.5';                                      
                        testpvList2.add(oPhysicianVisit2); 
                        ///////////
                         List<Physician_Visit__c> testpvList3 = new List<Physician_Visit__c>();               
                                 
                        Physician_Visit__c oPhysicianVisit3 = new Physician_Visit__c();                        
                        oPhysicianVisit3.Activity_Date__c = System.today()-1;
                        oPhysicianVisit3.Physician__c = oContact1.Id;
                        oPhysicianVisit3.Status__c = 'Open';
                        oPhysicianVisit3.Session__c = 'AM';
                        oPhysicianVisit3.Planned_Call__c = false;
                        oPhysicianVisit3.OwnerId = oUserIndia.Id;
                        oPhysicianVisit3.Start_Time__c = Datetime.Now();
                        oPhysicianVisit3.End_Time__c = Datetime.Now();
                        oPhysicianVisit3.Joint_Call_With_ASM__c = False;           
                        oPhysicianVisit3.Last_Activity__c=null;
                        oPhysicianVisit3.Visit_Call__c = True;
                        oPhysicianVisit3.Product_1__c  = 'Akreos MI-60';
                        oPhysicianVisit3.Product_2__c = 'Akreos AO';
                        oPhysicianVisit3.OT_Hours__c = True; 
                        oPhysicianVisit3.Akreos_AO__c=123;
                        oPhysicianVisit3.Akreos_Adapt__c=123;
                        oPhysicianVisit3.Akreos_MIL__c=123;
                        oPhysicianVisit3.Envista__c=123;
                        oPhysicianVisit3.Acrysof_IQ__c=123;                   
                        oPhysicianVisit3.Hours_in_Surgery__c = '6.5';                                      
                        testpvList3.add(oPhysicianVisit3);
                        ///////
                         List<Physician_Visit__c> testpvList4 = new List<Physician_Visit__c>();               
                                 
                        Physician_Visit__c oPhysicianVisit4 = new Physician_Visit__c();                        
                        oPhysicianVisit4.Activity_Date__c = System.today();
                        oPhysicianVisit4.Physician__c = oContact1.Id;
                        oPhysicianVisit4.Status__c = 'Open';
                        oPhysicianVisit4.Session__c = 'AM';
                        oPhysicianVisit4.Planned_Call__c = false;
                        oPhysicianVisit4.OwnerId = oUserIndia.Id;
                        oPhysicianVisit4.Start_Time__c = Datetime.Now();
                        oPhysicianVisit4.End_Time__c = Datetime.Now();
                        oPhysicianVisit4.Joint_Call_With_ASM__c = False;           
                        oPhysicianVisit4.Last_Activity__c=null;
                        oPhysicianVisit4.Visit_Call__c = True;
                        oPhysicianVisit4.Product_1__c  = 'Akreos MI-60';
                        oPhysicianVisit4.Product_2__c = 'Akreos AO';
                        oPhysicianVisit4.OT_Hours__c = True; 
                        oPhysicianVisit4.Akreos_AO__c=123;
                        oPhysicianVisit4.Akreos_Adapt__c=123;
                        oPhysicianVisit4.Akreos_MIL__c=123;
                        oPhysicianVisit4.Crystalens__c=123;
                        oPhysicianVisit4.Acrysof_IQ__c=123;                   
                        oPhysicianVisit4.Hours_in_Surgery__c = '6.5';                                      
                        testpvList4.add(oPhysicianVisit4); 
                        ///////
                         List<Physician_Visit__c> testpvList5 = new List<Physician_Visit__c>();               
                                 
                        Physician_Visit__c oPhysicianVisit5 = new Physician_Visit__c();                        
                        oPhysicianVisit5.Activity_Date__c = System.today();
                        oPhysicianVisit5.Physician__c = oContact1.Id;
                        oPhysicianVisit5.Status__c = 'Open';
                        oPhysicianVisit5.Planned_Call__c = false;
                        oPhysicianVisit5.OwnerId = oUserIndia.Id;
                        oPhysicianVisit5.Akreos_AO__c=123;
                        oPhysicianVisit5.Akreos_Adapt__c=123;
                        oPhysicianVisit5.Envista__c=123;
                        oPhysicianVisit5.Crystalens__c=123;
                        oPhysicianVisit5.Acrysof_IQ__c=123;                   
                        oPhysicianVisit5.Hours_in_Surgery__c = '6.5';                                      
                        testpvList5.add(oPhysicianVisit5); 
                              
                                 
                 system.runAs(oUserBLSSO){                    
                    insert testpvList;
                    insert testpvList2;
                    insert testpvList3;
                    //insert testpvList4;
                    //insert testpvList5;
                    
                 }    
                    
           for(Physician_Visit__c p :testpvList){
               obj.list_PhysicianVisitDetails.add(p);           
               }            
           PageReference pgSave2 = obj.save();  
           
              system.runAs(oUserIndia)
              {                    
                      {                    
                           CtrlINDSUPhysicianVisiting objpgIND = new CtrlINDSUPhysicianVisiting(new ApexPages.StandardController(new Physician_Visit__c()));        
                        
                           CtrlINDSUPhysicianVisiting objIND = new CtrlINDSUPhysicianVisiting();            
                                
                           Integer idays1 = obj.getintSelectedDays();
                           objIND.setintSelectedDays(3);
                           objIND.setintSelectedDays(0);
                           objIND.BindDataTable();
                           objIND.intSelectedDays = 3;
                           objIND.BindDataTable();  
                           List<SelectOption> lst1 = objIND.getViewOptions();
                           PageReference pgph1 = objIND.getPhysicianVisitDetails();
                           PageReference pgSave1 = objIND.save();
                           PageReference pgnew1 = objIND.newUnplannedvisit();
                            
                          List<Physician_Visit__c> lstVisitNewUP = new  List<Physician_Visit__c>();
                          lstVisitNewUP.add(new Physician_Visit__c());
                          objIND.list_PhysicianVisitDetails =testpvList ;
                          objIND.Save();
                          //
                          objIND.list_PhysicianVisitDetails =null;
                          objIND.list_PhysicianVisitDetails =testpvList2 ;
                          objIND.Save();
                          ////                          
                          objIND.list_PhysicianVisitDetails =null;
                          objIND.list_PhysicianVisitDetails =testpvList3 ;
                          objIND.Save();
                          
                          objIND.list_PhysicianVisitDetails =null;
                          objIND.list_PhysicianVisitDetails =testpvList4 ;
                          objIND.Save();
                          
                          objIND.list_PhysicianVisitDetails =null;
                          objIND.list_PhysicianVisitDetails =testpvList5 ;
                          objIND.Save();
                    } 
 
       
           }
       }
       
          @isTest static void testMethodCtrlINDSUUnplannedPhysicianVisit() { 
          
              CtrlINDSUUnplannedPhysicianVisit objupv = new CtrlINDSUUnplannedPhysicianVisit(new ApexPages.StandardController(new Physician_Visit__c()));
              Physician_Visit__c getpv = objupv.getObjPhysicianvisit();
              objupv.setObjPhysicianvisit(new Physician_Visit__c());
              PageReference pgSave = objupv.Cancel();
              ID recTypeINDSUSalesPlanned = CtrlINDSUUnplannedPhysicianVisit.GetRecordTypeId('Physician_Visit__c','INDSU Sales Planned'); 
              Boolean blndate = objupv.IsDateInRange();
             // Boolean blnselectcheck = objupv.IsValuesInputedForSelectedCheckbox();
              PageReference pgnew = objupv.Save();
              
                Profile oProfileBLSSO = [SELECT Id FROM profile WHERE name = 'BL: System Admin SSO' limit 1]; 
                Profile oProfileIndia=[SELECT Id FROM profile WHERE name = 'INDSU Sales Rep' limit 1];
                
                Map<string,UserRole> role = new Map<string,UserRole>();
                for(UserRole r:[select Id,Name from UserRole where name in ('INDSU Sales Rep (South1)','INDSU Area Sales Manager (South 1)') ]){
                    role.put(r.Name,r);
                }
        
          User oUserBLSSO  = new User(alias = 'mg456', 
                                     email='mgruser456@testorg.com', 
                                     emailencodingkey='UTF-8',
                                     lastname='lastname2',
                                     languagelocalekey='en_US', 
                                     localesidkey='en_US', 
                                     profileid = oProfileBLSSO.Id, 
                                     timezonesidkey='America/Los_Angeles',
                                     username='mgruser456789@testorg.com',
                                     UserRole = role.get('INDSU Area Sales Manager (South 1)'));
             insert oUserBLSSO;   
                                     
            User oUserIndia  = new User(alias = 'mg4561', 
                                     email='mgruser456@testorg1.com', 
                                     emailencodingkey='UTF-8',
                                     lastname='lastname2',
                                     languagelocalekey='en_US', 
                                     localesidkey='en_US', 
                                     profileid = oProfileIndia.Id, 
                                     timezonesidkey='America/Los_Angeles',
                                     username='mgruser456789@testorg1.com',
                                     UserRole = role.get('INDSU Sales Rep (South1)'));  
                                     
                     Insert oUserIndia;
           
              
              
              
               Map<string,String> map_RecordType = new Map<string,String>();
                for(RecordType rt : [Select Id, Name from RecordType where Name in ('INDSU Indirect','INDSU Contact','INDSU Sales Unplanned','INDSU Sales Planned','INDSU Monthly Implantation Detail') and sObjectType in ('Physician_Visit__c','Account','Contact')])
                {
                    map_RecordType.put(rt.Name,rt.Id);
                }
              
              /**********Account **************/
                Account oAccount = new Account();          
                oAccount.OwnerId = UserInfo.getUserId();            
                oAccount.Name = 'Test'; 
                oAccount.recordTypeId = map_RecordType.get('INDSU Indirect');          
                insert oAccount;
       
           /**********Contact **************/
                Contact oContact1 = new Contact();           
                oContact1.AccountId = oAccount.Id;                        
                oContact1.LastName = 'Test Contact1';
                oContact1.recordTypeId = map_RecordType.get('INDSU Contact');   
                insert oContact1 ;  
                
                
                 List<Physician_Visit__c> testpvList = new List<Physician_Visit__c>();               
                                 
                        Physician_Visit__c oPhysicianVisit = new Physician_Visit__c();                        
                        oPhysicianVisit.Activity_Date__c = System.today()-1;
                        oPhysicianVisit.Physician__c = oContact1.Id;
                        oPhysicianVisit.Status__c = 'Open';
                        oPhysicianVisit.Session__c = 'AM';
                        oPhysicianVisit.Planned_Call__c = false;
                        oPhysicianVisit.OwnerId = oUserBLSSO.Id;
                        oPhysicianVisit.Start_Time__c = Datetime.Now();
                        oPhysicianVisit.End_Time__c = Datetime.Now();
                        oPhysicianVisit.Joint_Call_With_ASM__c = False;           
                        oPhysicianVisit.Last_Activity__c=null;
                        oPhysicianVisit.Visit_Call__c = True;
                        oPhysicianVisit.Product_1__c  = 'Akreos MI-60';
                        oPhysicianVisit.Product_2__c = 'Akreos AO';
                        oPhysicianVisit.OT_Hours__c = True; 
                        oPhysicianVisit.Hours_in_Surgery__c = '6.5';              
                        testpvList.add(oPhysicianVisit);         
                                 
                 system.runAs(oUserBLSSO){                    
                    insert testpvList;
                 }    
                
                   
          
              List<Physician_Visit__c> lstVisitNewUP = new  List<Physician_Visit__c>();
              lstVisitNewUP.add(new Physician_Visit__c());
              objupv.list_Physicianvisitcapture = lstVisitNewUP;
              objupv.list_Physicianvisitcapture =testpvList ;
              objupv.Save();
              
              Physician_Visit__c objVisit1 = new Physician_Visit__c(Activity_Date__c = System.today().addDays(-3), Physician__c = new Contact().Id, Status__c = 'Open');
              lstVisitNewUP = new  List<Physician_Visit__c >();
              lstVisitNewUP.add(objVisit1);
              objupv.list_Physicianvisitcapture = lstVisitNewUP;
              objupv.Save();
              
              Physician_Visit__c  objStoreVisit2 = new Physician_Visit__c(Activity_Date__c = System.today().addDays(-1), Status__c = 'Open');
              lstVisitNewUP = new  List<Physician_Visit__c >();
              lstVisitNewUP.add(objStoreVisit2);
              objupv.list_Physicianvisitcapture = lstVisitNewUP;
              objupv.Save();
              
              Physician_Visit__c objStoreVisit3 = new Physician_Visit__c(Status__c = 'Open', Physician__c = new Contact().Id);
              lstVisitNewUP = new  List<Physician_Visit__c >();
              lstVisitNewUP.add(objStoreVisit3);
              objupv.list_Physicianvisitcapture = lstVisitNewUP;
              objupv.Save();
              
              Physician_Visit__c objStoreVisit4 = new Physician_Visit__c(Activity_Date__c = System.today().addDays(-4), Status__c = 'Open');
              lstVisitNewUP = new  List<Physician_Visit__c >();
              lstVisitNewUP.add(objStoreVisit4);
              objupv.list_Physicianvisitcapture = lstVisitNewUP;
              objupv.Save();
              
              
              Physician_Visit__c objStoreVisit5 = new Physician_Visit__c(Status__c = 'Open',Physician__c =oContact1.Id);
             List<Physician_Visit__c> lstVisitNewUP5 = new  List<Physician_Visit__c>();
              lstVisitNewUP5.add(objStoreVisit5);
              objupv.list_Physicianvisitcapture = lstVisitNewUP5;
              objupv.list_Physicianvisitcapture =testpvList ;
              objupv.Save();
              
               Physician_Visit__c objStoreVisit6 = new Physician_Visit__c(Status__c = 'Open',Activity_Date__c = System.today().addDays(-4),Physician__c =oContact1.Id);
               List<Physician_Visit__c> lstVisitNewUP6 = new  List<Physician_Visit__c>();
               lstVisitNewUP6.add(objStoreVisit6);
               objupv.list_Physicianvisitcapture = lstVisitNewUP6;
               objupv.Save();
              
              system.runAs(oUserIndia)
              {                    
              CtrlINDSUUnplannedPhysicianVisit objupv1 = new CtrlINDSUUnplannedPhysicianVisit(new ApexPages.StandardController(new Physician_Visit__c()));
              Physician_Visit__c getpv1 = objupv1.getObjPhysicianvisit();
              objupv1.setObjPhysicianvisit(new Physician_Visit__c());
              PageReference pgSave1 = objupv1.Cancel();
              ID recTypeINDSUSalesPlanned1 = CtrlINDSUUnplannedPhysicianVisit.GetRecordTypeId('Physician_Visit__c','INDSU Sales Planned'); 
              Boolean blndate1 = objupv1.IsDateInRange();
                // Boolean blnselectcheck = objupv1.IsValuesInputedForSelectedCheckbox();
                PageReference pgnew1 = objupv1.Save();
                
               // List<Physician_Visit__c> lstVisitNewUP = new  List<Physician_Visit__c>();
              lstVisitNewUP.add(new Physician_Visit__c());
              objupv1.list_Physicianvisitcapture = lstVisitNewUP;
              objupv1.list_Physicianvisitcapture =testpvList ;
              objupv1.Save();
              
              //Physician_Visit__c objVisit1 = new Physician_Visit__c(Activity_Date__c = System.today().addDays(-3), Physician__c = new Contact().Id, Status__c = 'Open');
              lstVisitNewUP = new  List<Physician_Visit__c >();
              lstVisitNewUP.add(objVisit1);
              objupv1.list_Physicianvisitcapture = lstVisitNewUP;
              objupv1.Save();
              
             // Physician_Visit__c  objStoreVisit2 = new Physician_Visit__c(Activity_Date__c = System.today().addDays(-1), Status__c = 'Open');
              lstVisitNewUP = new  List<Physician_Visit__c >();
              lstVisitNewUP.add(objStoreVisit2);
              objupv1.list_Physicianvisitcapture = lstVisitNewUP;
              objupv1.Save();
              
             // Physician_Visit__c objStoreVisit3 = new Physician_Visit__c(Status__c = 'Open', Physician__c = new Contact().Id);
              lstVisitNewUP = new  List<Physician_Visit__c >();
              lstVisitNewUP.add(objStoreVisit3);
              objupv1.list_Physicianvisitcapture = lstVisitNewUP;
              objupv1.Save();
              
              //Physician_Visit__c objStoreVisit4 = new Physician_Visit__c(Activity_Date__c = System.today().addDays(-4), Status__c = 'Open');
              lstVisitNewUP = new  List<Physician_Visit__c >();
              lstVisitNewUP.add(objStoreVisit4);
              objupv1.list_Physicianvisitcapture = lstVisitNewUP;
              objupv1.Save();
              
              
             // Physician_Visit__c objStoreVisit5 = new Physician_Visit__c(Status__c = 'Open',Physician__c =oContact1.Id);
            // List<Physician_Visit__c> lstVisitNewUP5 = new  List<Physician_Visit__c>();
              lstVisitNewUP5.add(objStoreVisit5);
              objupv1.list_Physicianvisitcapture = lstVisitNewUP5;
              objupv1.list_Physicianvisitcapture =testpvList ;
              objupv1.Save();
              
               //Physician_Visit__c objStoreVisit6 = new Physician_Visit__c(Status__c = 'Open',Activity_Date__c = System.today().addDays(-4),Physician__c =oContact1.Id);
              // List<Physician_Visit__c> lstVisitNewUP6 = new  List<Physician_Visit__c>();
               lstVisitNewUP6.add(objStoreVisit6);
               objupv1.list_Physicianvisitcapture = lstVisitNewUP6;
               objupv1.Save();
                 }    
              
              
              
              //Store_Visit__c objStoreVisit5 = new Store_Visit__c(Visit_Date__c = System.today().addDays(-1), Status__c = 'Open', Enter_Time__c = true);
             
              
              /*objupv.lstStoreVisitNewUP = lstStoreVisitNewUP; 
              objupv.IsPageValidated();
              //objStandard.IsValuesInputedForSelectedCheckbox();
              objupv.IsAccountProvidedForDateInputed();
              objupv.IsDateProvidedForAccountInputed();
              objupv.Save();*/
              
              
          }   

}