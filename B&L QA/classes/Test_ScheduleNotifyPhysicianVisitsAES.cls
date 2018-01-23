/**
 * Test Class to test Send Mail for Notifications to Sales Reps and Managers for Open Physician Visit
 *
 *   Author             |Author-Email                                      |Date       |Comment
 *   -------------------|--------------------------------------------------|-----------|--------------------------------------------------
 *   Tarun Solanki      |tarun.solanki@bausch.com                          |18.06.2014 |First Draft 
 *
 * Class -- CtrlNotifyPhysicianVisitsManagersAES
 * CtrlNotifyPhysicianVisitsManagersAES
 * 
 */
@IsTest(SeeAllData=true)
public class Test_ScheduleNotifyPhysicianVisitsAES  {
   //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
   static String CRON_EXP = '0 0 10 1 12 ? 2017';
   
   public static testmethod void testNotificationEmails() {
      FetchPhysicians();
     //Test.startTest();
        
         //createStoreVisits();
         // Schedule the test job
         String jobId = System.schedule('testBasicScheduledApex11123', CRON_EXP, new clsNotifyOpenPhyMangersSchedulerAES());
    
         // Get the information from the CronTrigger API object
         CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        
         
         jobId = System.schedule('testBasicScheduledApexManager11', CRON_EXP, new clsNotifyOpenPhyMangersSchedulerAES());
         // Get the information from the CronTrigger API object
         ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
         system.debug('***CronTrigger ct' + ct);
     
     //Test.stopTest();
     
    }        
   
   public static testmethod void FetchPhysicians(){
         Test.startTest();
       List<Contact> listContacts = [Select Id, Owner.UserRoleId, AccountID  from contact where AccountId <> null  and Owner.UserRole.Name like 'INDSU Account Owner' limit 1];
       List<User> listSalesRep = [Select id from user where UserRole.Name like 'INDAES Sales Rep%' and isactive = true limit 1];
       system.debug('**** '+listContacts.size());
       system.debug('****listContacts --'+ listContacts + '****listSalesRep --' + listSalesRep);
       
       if(listContacts.size() == 0){
       
       /**********Account **************/
        Account oAccount = new Account();          
        oAccount.OwnerId = UserInfo.getUserId();            
        oAccount.Name = 'Test'; 
        //oAccount.recordTypeId = map_RecordType.get('INDSU Indirect');          
        insert oAccount;

   /**********Contact **************/
        Contact oContact1 = new Contact();           
        oContact1.AccountId = oAccount.Id;                        
        oContact1.LastName = 'Test Contact1';
        //oContact1.recordTypeId = map_RecordType.get('INDSU Contact');   
        insert oContact1 ;  
        
        listContacts = new  List<Contact>();
        listContacts.add(oContact1);                
      }                       
       
       //List<Physician_Visit__c> testpvList = new List<Physician_Visit__c>();               
                             
       Physician_Visit__c oPhysicianVisit = new Physician_Visit__c();                        
       oPhysicianVisit.Activity_Date__c = System.today().addDays(Integer.ValueOf(System.Label.DaysToComplete));
       oPhysicianVisit.Physician__c = listContacts[0].Id;
       oPhysicianVisit.Status__c = 'Open';
       oPhysicianVisit.Session__c = 'AM';
       oPhysicianVisit.Planned_Call__c = false;
       oPhysicianVisit.OwnerId = listSalesRep[0].Id;
       //oPhysicianVisit.Start_Time__c = Datetime.Now();
       //oPhysicianVisit.End_Time__c = Datetime.Now();
       //oPhysicianVisit.Joint_Call_With_ASM__c = False;           
       //oPhysicianVisit.Last_Activity__c=null;
       //oPhysicianVisit.Visit_Call__c = True;
       //oPhysicianVisit.Product_1__c  = 'Akreos MI-60';
       //oPhysicianVisit.Product_2__c = 'Akreos AO';
       //oPhysicianVisit.OT_Hours__c = True; 
       //oPhysicianVisit.Hours_in_Surgery__c = '6.5';              
       //testpvList.add(oPhysicianVisit);      
       
       insert oPhysicianVisit;
       
       Physician_Visit__c oPhysicianVisit1 = new Physician_Visit__c();                        
       oPhysicianVisit1.Activity_Date__c = System.today().addDays(Integer.ValueOf(System.Label.DaysToComplete));
       oPhysicianVisit1.Physician__c = listContacts[0].Id;
       oPhysicianVisit1.Status__c = 'Open';
       oPhysicianVisit1.Session__c = 'AM';
       oPhysicianVisit1.Planned_Call__c = false;
       oPhysicianVisit1.OwnerId = listSalesRep[0].Id;
       //oPhysicianVisit.Start_Time__c = Datetime.Now();
       //oPhysicianVisit.End_Time__c = Datetime.Now();
       //oPhysicianVisit.Joint_Call_With_ASM__c = False;           
       //oPhysicianVisit.Last_Activity__c=null;
       //oPhysicianVisit.Visit_Call__c = True;
       //oPhysicianVisit.Product_1__c  = 'Akreos MI-60';
       //oPhysicianVisit.Product_2__c = 'Akreos AO';
       //oPhysicianVisit.OT_Hours__c = True; 
       //oPhysicianVisit.Hours_in_Surgery__c = '6.5';              
       //testpvList.add(oPhysicianVisit);      
       
       insert oPhysicianVisit1;
        Test.stopTest();
       
       system.debug('***oPhysicianVisit ' + oPhysicianVisit);
       
       
        
       new clsNotifyOpenPhyMangersSchedulerAES();
       /*Test.startTest();
           Batch_NotifyPhysicianVisits controller = new Batch_NotifyPhysicianVisits() ;  
           Integer batchSize = 1;  
           database.executebatch(controller , batchSize);  
       Test.StopTest();*/
   }
   }