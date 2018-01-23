@isTest
class CtrlINDAESPhysicianVisiting_Test{
    
   @isTest static void testMethodCtrlINDAESPhysicianVisiting() {       
               
           CtrlINDAESPhysicianVisiting objpg = new CtrlINDAESPhysicianVisiting(new ApexPages.StandardController(new Physician_Visit__c()));        
            
           CtrlINDAESPhysicianVisiting obj = new CtrlINDAESPhysicianVisiting();            
                    
           Integer idays = obj.getintSelectedDays();
           obj.setintSelectedDays(3);
           obj.setintSelectedDays(0);
           //obj.BindDataTable();
           obj.intSelectedDays = 3;
           //obj.BindDataTable();  
           List<SelectOption> lst = obj.getViewOptions();
           PageReference pgph = obj.getPhysicianVisitDetails();
           PageReference pgSave = obj.save();
           PageReference pgnew = obj.newUnplannedvisit();
              
           Profile oProfileBLSSO = [SELECT Id FROM profile WHERE name = 'BL: System Admin SSO' limit 1]; 
                Map<string,UserRole> role = new Map<string,UserRole>();
                for(UserRole r:[select Id,Name from UserRole where name in ('INDAES Sales Rep(West)','INDAES Area Sales Manager(West)') ]){
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
                                     UserRole = role.get('INDAES Area Sales Manager(West)'));
                insert oUserBLSSO;         
                                                                                                                                                                                      
           
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
                    
           for(Physician_Visit__c p :testpvList){
               obj.list_PhysicianVisitDetails.add(p);           
               }            
           PageReference pgSave2 = obj.save();           
       }
       
          @isTest static void testMethodCtrlINDAESUnplannedPhysicianVisit() { 
          
              CtrlINDAESUnplannedPhysicianVisit objupv = new CtrlINDAESUnplannedPhysicianVisit(new ApexPages.StandardController(new Physician_Visit__c()));
              Physician_Visit__c getpv = objupv.getObjPhysicianvisit();
              objupv.setObjPhysicianvisit(new Physician_Visit__c());
              PageReference pgSave = objupv.Cancel();
              ID recTypeINDSUSalesPlanned = CtrlINDSUUnplannedPhysicianVisit.GetRecordTypeId('Physician_Visit__c','INDSU Sales Planned'); 
              Boolean blndate = objupv.IsDateInRange();
             // Boolean blnselectcheck = objupv.IsValuesInputedForSelectedCheckbox();
              PageReference pgnew = objupv.Save();
              
                Profile oProfileBLSSO = [SELECT Id FROM profile WHERE name = 'BL: System Admin SSO' limit 1]; 
                Profile oProfileIndia=[SELECT Id FROM profile WHERE name = 'INDAES Sales Rep' limit 1];
                
                Map<string,UserRole> role = new Map<string,UserRole>();
                for(UserRole r:[select Id,Name from UserRole where name in ('INDAES Sales Rep(West)','INDAES Area Sales Manager(West)') ]){
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
                                     UserRole = role.get('INDAES Area Sales Manager(West)'));
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
                                     UserRole = role.get('INDAES Sales Rep(West)'));  
                                     
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
              CtrlINDAESUnplannedPhysicianVisit objupv1 = new CtrlINDAESUnplannedPhysicianVisit(new ApexPages.StandardController(new Physician_Visit__c()));
              Physician_Visit__c getpv1 = objupv1.getObjPhysicianvisit();
              objupv1.setObjPhysicianvisit(new Physician_Visit__c());
              PageReference pgSave1 = objupv1.Cancel();
              ID recTypeINDSUSalesPlanned1 = CtrlINDAESUnplannedPhysicianVisit.GetRecordTypeId('Physician_Visit__c','INDSU Sales Planned'); 
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
              
              
          }   

}