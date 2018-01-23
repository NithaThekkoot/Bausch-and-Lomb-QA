/*
* Test class for CtrlINDAesthetics_Dashboard
* Author                        |Author-Email                                      |Date        |Comment
* ------------------------------|------------------------------------------------- |------------|----------------------------------------------------
* Tarun Solanki                |Tarun.Solanki@bausch.com     |17.06.2014  |First Draft
*/
@istest
class Test_CtrlINDAesthetics_Dashboard
{
    public static testMethod void OTHrs_DashboardTest()
    {
   
              
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
                 
                 CtrlINDAesthetics_Dashboard objCtrlINDSU_OTHrs_Dashboard=new CtrlINDAesthetics_Dashboard();
                 try
                 {
                     objCtrlINDSU_OTHrs_Dashboard.SendMailToUserOnly();
                     
                 }
                 catch(exception err)
                 {
                 
                 }
                 
                 //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
          String CRON_EXP = '0 0 10 1 12 ? 2017';
          //Test class for schedular 
         Test.startTest();
 
         //createStoreVisits();
         // Schedule the test job
         String jobId = System.schedule('testBasicScheduledApe23412', CRON_EXP, new ClsINDSUdashboradScheduler());
     
         Test.stopTest();
                
                   
    }
}