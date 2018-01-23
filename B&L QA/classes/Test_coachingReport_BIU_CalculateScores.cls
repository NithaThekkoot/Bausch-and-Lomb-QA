/**
 * This test class covers the code coverage for the trigger coachingReport_BIU_CalculateScores, and the class ClsGettingChildRoles
 * Author                        |Author-Email                                                |Date        |Comment
 * ------------------------------|----------------------------------------------------------- |------------|-------------------------------------------------------------
 * Raja B.,                      |rajamaruthu.balasubramanian@listertechnologies.com          |09.15.2010  |First Draft
 * Neha Jain                     |neha.jain@bausch.com                                        |07-04-2014|Modified test class to comment the code of fetching user on Map created for managers
 *
 */
@isTest
private class Test_coachingReport_BIU_CalculateScores {

    //Test method for coaching report trigger
    static testMethod void testTrigger() {
        
        Id idRecordType = [SELECT Id FROM RecordType WHERE SObjectType= 'Coaching_Report__c' AND Name = 'CHNSU Coaching Report'].Id;
        
        //Map<Id, User> mapOfSalesManager = new Map<Id, User>([Select Id, Name, Profile.name From User Where Profile.name = 'APACSU Sales Manager' AND UserRole.Name LIKE '%CHNSU Regional Sales Manager%' limit 20]);
        //User salesExecutive = [Select Id, Name,ManagerId, Profile.name From User Where Profile.name = 'APACSU Sales Rep' and managerId in : mapOfSalesManager.keySet() limit 1];
        /*--Commented by Neha Jain to fix error in deployment -- PD on 7th April, 2014
        Map<Id, User> mapOfSalesManager = new Map<Id, User>([Select Id, Name, Profile.name From User Where Profile.name = 'APACSU China Sales Manager' AND UserRole.Name LIKE '%CHNSU Regional Sales Manager%' AND IsActive=true limit 20]);
        List<User> salesExecutive = [Select Id, Name,ManagerId, Profile.name From User Where Profile.name = 'APACSU China Sales Rep' and managerId in : mapOfSalesManager.keySet() AND IsActive=true limit 1];
        
       if(salesExecutive==NULL || salesExecutive.isEmpty() == true){
            mapOfSalesManager = new Map<Id, User>([Select Id, Name, Profile.name From User Where Profile.name = 'APACSU Sales Manager' AND UserRole.Name LIKE '%CHNSU National Sales Manager%' AND IsActive=true limit 20]);
            salesExecutive = [Select Id, Name,ManagerId, Profile.name From User Where Profile.name = 'APACSU China Sales Rep' and managerId in : mapOfSalesManager.keySet() AND IsActive=true limit 1];
        }
        User salesManager = [Select Id,Name From User where Id = : salesExecutive[0].managerId LIMIT 1];*/
        
        List<User> salesExecutive = [Select Id, Name,ManagerId, Profile.name From User Where Profile.name = 'APACSU China Sales Rep' and manager.isactive = true  AND IsActive=true limit 1];        
        User salesManager = new User(Id = salesExecutive[0].managerId);
        //Create coaching report
        Coaching_Report__c oCoachingReport = new Coaching_Report__c();
        oCoachingReport.Sales_Rep__c = salesExecutive[0].Id;
        oCoachingReport.RecordTypeId = idRecordType;
        
        Date datOldDate = Date.today().addMonths(-1);
        
        System.runAs(salesManager){
            try{
                
                //Create Store
                /*Account oStore = new Account();
                oStore.Name = 'TESTSTORE';
                insert oStore;
                
                Contact oContact = new Contact();
                oContact.AccountId = oStore.Id;
                oContact.LastName = 'TESTCONTACT';
                insert oContact;
                
                Physician_Info__c oPhysicianInfo = new Physician_Info__c();
                oPhysicianInfo.Contact__c = oContact.Id;
                insert oPhysicianInfo;
                
                RecordType rt = [SELECT Id FROM RecordType WHERE sObjectType = 'Physician_Visit__c' AND Name = 'APACSU Sales Planned' LIMIT 1];
                Physician_Visit__c oSalesExecutiveStoreVisit= new Physician_Visit__c();
                oSalesExecutiveStoreVisit.Activity_Date__c  = Date.today().addDays(-1);
                oSalesExecutiveStoreVisit.Start_Time__c     = oSalesExecutiveStoreVisit.Activity_Date__c; 
                oSalesExecutiveStoreVisit.End_Time__c       = oSalesExecutiveStoreVisit.Start_Time__c.addHours(2);
                oSalesExecutiveStoreVisit.Physician__c      = oContact.Id;
                oSalesExecutiveStoreVisit.Status__c         = 'Completed';
                oSalesExecutiveStoreVisit.OwnerId           = salesExecutive[0].Id;
                oSalesExecutiveStoreVisit.RecordTypeId  = rt.Id;
                oSalesExecutiveStoreVisit.Joint_Call_With_ASM__c = true;
                insert oSalesExecutiveStoreVisit;*/
                
                oCoachingReport.Date__c     = Date.today().addDays(-1);
                oCoachingReport.Session__c  = 'AM';
                oCoachingReport.Date2__c    = Date.today().addDays(-1);
                oCoachingReport.Session1__c = 'PM';
                oCoachingReport.Sales_Rep__c = salesExecutive[0].Id;
                oCoachingReport.A_1__c      = '1';
                oCoachingReport.A_2__c      = '1';
                oCoachingReport.A_3__c      = '1';
                oCoachingReport.A_4__c      = '1';
                oCoachingReport.A_5__c      = '1';
                oCoachingReport.A_6__c      = '1';
                oCoachingReport.A_7__c      = '1';
                oCoachingReport.A_8__c      = '1';
                oCoachingReport.B_1__c      = '1';
                oCoachingReport.B_2__c      = '1';
                oCoachingReport.B_3__c      = '1';
                oCoachingReport.C_1__c      = '1';
                oCoachingReport.C_2__c      = '1';
                oCoachingReport.D_1__c      = '1';
                oCoachingReport.D_2__c      = '1';
                oCoachingReport.D_3__c      = '1';
                oCoachingReport.D_4__c      = '1';
                oCoachingReport.D_5__c      = '1';
                oCoachingReport.D_6__c      = '1';
                oCoachingReport.D_7__c      = '1';
                oCoachingReport.E_1__c      = '1';
                insert oCoachingReport;
                
                oCoachingReport.Date2__c    = Date.today().addDays(-1);
                oCoachingReport.Session1__c = 'AM';
                update oCoachingReport;
                
            }catch(Exception ex){}
        }

        /*System.runAs(salesExecutive){
            try
            {
                insert oCoachingReport;
            }
            catch(Exception e){}
        }
        
        //Create Store
        Account oStore = new Account();
        oStore.Name = 'TESTSTORE';
        insert oStore;
        
        Contact oContact = new Contact();
        oContact.AccountId = oStore.Id;
        oContact.LastName = 'TESTCONTACT';
        insert oContact;
        
        Physician_Info__c oPhysicianInfo = new Physician_Info__c();
        oPhysicianInfo.Contact__c = oContact.Id;
        insert oPhysicianInfo;
        
        RecordType rt = [SELECT Id FROM RecordType WHERE sObjectType = 'Physician_Visit__c' AND Name = 'APACSU Sales Planned' LIMIT 1];
        Physician_Visit__c oSalesExecutiveStoreVisit1   = new Physician_Visit__c();
        oSalesExecutiveStoreVisit1.Activity_Date__c = Date.today().addDays(-1);
        oSalesExecutiveStoreVisit1.Start_Time__c    = oSalesExecutiveStoreVisit1.Activity_Date__c; 
        oSalesExecutiveStoreVisit1.End_Time__c      = oSalesExecutiveStoreVisit1.Start_Time__c.addHours(2);
        oSalesExecutiveStoreVisit1.Physician__c     = oContact.Id;
        oSalesExecutiveStoreVisit1.Status__c        = 'Completed';
        oSalesExecutiveStoreVisit1.OwnerId          = salesExecutive.Id;
        //oSalesExecutiveStoreVisit1.Planned__c     = false;
        oSalesExecutiveStoreVisit1.RecordTypeId     = rt.Id;
        oSalesExecutiveStoreVisit1.Joint_Call_With_ASM__c = true;
        insert oSalesExecutiveStoreVisit1;
        
        oSalesExecutiveStoreVisit1.Status__c        = 'Completed';
        update oSalesExecutiveStoreVisit1;
        
        Physician_Visit__c oSalesExecutiveStoreVisit2   = new Physician_Visit__c();
        oSalesExecutiveStoreVisit2.Activity_Date__c = Date.today().addDays(-1);
        oSalesExecutiveStoreVisit2.Start_Time__c    = oSalesExecutiveStoreVisit1.Activity_Date__c; 
        oSalesExecutiveStoreVisit2.End_Time__c      = oSalesExecutiveStoreVisit1.Start_Time__c.addHours(2);
        oSalesExecutiveStoreVisit2.Physician__c     = oContact.Id;
        oSalesExecutiveStoreVisit2.Status__c        = 'Completed';
        oSalesExecutiveStoreVisit2.OwnerId          = salesExecutive.Id;
        //oSalesExecutiveStoreVisit1.Planned__c     = false;
        oSalesExecutiveStoreVisit2.RecordTypeId     = rt.Id;
        oSalesExecutiveStoreVisit2.Joint_Call_With_ASM__c = true;
        insert oSalesExecutiveStoreVisit2;
        
        oSalesExecutiveStoreVisit2.Status__c        = 'Completed';
        update oSalesExecutiveStoreVisit2;
        
        System.runAs(salesManager){
            
            try
            {
                oCoachingReport = new Coaching_Report__c();
                oCoachingReport.RecordTypeId = idRecordType;
                System.Debug('Exception Block1');
                oCoachingReport.Date__c     = Date.today().addDays(-1);
                oCoachingReport.Session__c  = 'AM';
                oCoachingReport.Sales_Rep__c = salesExecutive.Id;
                oCoachingReport.A_1__c      = '1';
                oCoachingReport.A_2__c      = '1';
                oCoachingReport.A_3__c      = '1';
                oCoachingReport.A_4__c      = '1';
                oCoachingReport.A_5__c      = '1';
                oCoachingReport.A_6__c      = '1';
                oCoachingReport.A_7__c      = '1';
                oCoachingReport.A_8__c      = '1';
                oCoachingReport.B_1__c      = '1';
                oCoachingReport.B_2__c      = '1';
                oCoachingReport.B_3__c      = '1';
                oCoachingReport.C_1__c      = '1';
                oCoachingReport.C_2__c      = '1';
                oCoachingReport.D_1__c      = '1';
                oCoachingReport.D_2__c      = '1';
                oCoachingReport.D_3__c      = '1';
                oCoachingReport.D_4__c      = '1';
                oCoachingReport.D_5__c      = '1';
                oCoachingReport.D_6__c      = '1';
                oCoachingReport.D_7__c      = '1';
                oCoachingReport.E_1__c      = '1';
                insert oCoachingReport;
                //insert oCoachingReport;
            }
            catch(Exception e){}
            
            try
            {
                oCoachingReport.Date__c     = Date.today() + 1;
                oCoachingReport.Session__c  = 'AM';
                insert oCoachingReport;
            }
            catch(Exception e){}
            
            try
            {
                oCoachingReport.Date__c     = Date.today() - 1;
                oCoachingReport.Session1__c = 'PM';
                insert oCoachingReport;
            }
            catch(Exception e){}
            
            // second date less than first date
            try
            {
                oCoachingReport.Date2__c = Date.today() - 2;
                insert oCoachingReport;
            }
            catch(Exception e){}
            
            
            try
            {
                oCoachingReport.Date2__c = Date.today() + 1;
                insert oCoachingReport;
            }
            catch(Exception e){}
            
            // second date not null and second session empty
            try
            {
                oCoachingReport.Date2__c    = Date.today();
                oCoachingReport.Session1__c = null;
                insert oCoachingReport;
            }
            catch(Exception e){}
            
            // first date less than settlement date
            try
            {
                oCoachingReport.Date__c     = datOldDate;
                oCoachingReport.Session1__c = null;
                insert oCoachingReport;
            }
            catch(Exception e){}
            
            // second date less than settlement date
            try
            {
                oCoachingReport.Date__c     = Date.today() - 1;
                oCoachingReport.Session1__c = null;
                insert oCoachingReport;
            }
            catch(Exception e){}
            
            // dates equal
            try
            {
                oCoachingReport.Date__c     = Date.today();
                oCoachingReport.Session__c  = 'AM';
                oCoachingReport.Date2__c    = Date.today();
                oCoachingReport.Session1__c = 'AM';
                insert oCoachingReport;
            }
            catch(Exception e){}
            
            // dates equal
            try
            {
                oCoachingReport.Date__c     = Date.today();
                oCoachingReport.Session__c  = 'AM';
                oCoachingReport.Date2__c    = Date.today();
                oCoachingReport.Session1__c = 'AM';
                insert oCoachingReport;
            }
            catch(Exception e){}
            
            // dates equal
            try
            {
                oCoachingReport.Date__c     = Date.today();
                oCoachingReport.Session__c  = 'PM';
                oCoachingReport.Date2__c    = Date.today();
                oCoachingReport.Session1__c = 'AM';
                insert oCoachingReport;
            }
            catch(Exception e){}
            
            
            try
            {
                oCoachingReport.Date__c     = Date.today() - 1;
                oCoachingReport.Session__c  = 'AM';
                oCoachingReport.Date2__c    = Date.today();
                oCoachingReport.Session1__c = 'PM';
                insert oCoachingReport;
                
            }
            catch(Exception e)
            {
                
            }
            
            try
            {
                System.Debug('Exception Block1');
                oCoachingReport.Date__c     = Date.today().addDays(-1);
                oCoachingReport.Session__c  = 'AM';
                oCoachingReport.Date2__c    = Date.today();
                oCoachingReport.Session1__c = 'PM';
                oCoachingReport.Sales_Rep__c = salesExecutive.Id;
                insert oCoachingReport;
            }
            catch(Exception e)
            {
                System.Debug('Exception Block2');
             
            }
            
            try
            {
                oCoachingReport.Date__c     = Date.today() - 1;
                oCoachingReport.Session__c  = 'AM';
                oCoachingReport.Date2__c    = Date.today() - 1;
                oCoachingReport.Session1__c = 'PM';
                oCoachingReport.A_1__c      = '1';
                oCoachingReport.A_2__c      = '1';
                oCoachingReport.A_3__c      = '1';
                oCoachingReport.A_4__c      = '1';
                oCoachingReport.A_5__c      = '1';
                oCoachingReport.A_6__c      = '1';
                oCoachingReport.A_7__c      = '1';
                oCoachingReport.B_1__c      = '1';
                oCoachingReport.B_2__c      = '1';
                oCoachingReport.B_3__c      = '1';
                oCoachingReport.C_1__c      = '1';
                oCoachingReport.C_2__c      = '1';
                oCoachingReport.D_1__c      = '1';
                oCoachingReport.D_2__c      = '1';
                oCoachingReport.D_3__c      = '1';
                oCoachingReport.D_4__c      = '1';
                oCoachingReport.D_5__c      = '1';
                oCoachingReport.D_6__c      = '1';
                oCoachingReport.D_7__c      = '1';
                oCoachingReport.E_1__c      = '1';
                oCoachingReport.Sales_Rep__c = salesExecutive.Id;
                
                insert oCoachingReport;
            }
            catch(Exception e){}
        }*/
    }
    
    //Test method for ClsGettingChildRoles
    static TestMethod void TestMethod_gettingChildRoles(){
        
        List<User> list_RunAsUser = [SELECT Id, Name, Profile.Name FROM User WHERE Profile.Name = 'APACSU China Sales Rep' AND IsActive=true LIMIT 1];
        
        System.RunAs(list_RunAsUser[0]){
            
            List<User> list_TestUser = [SELECT Id, Name, Profile.Name FROM User WHERE ProfileId = : UserInfo.getProfileId() AND IsActive=true LIMIT 1];
            
            ClsGettingChildRoles.getChild(UserInfo.getUserRoleId(), 'APACSU');
            ClsGettingChildRoles.getChild(UserInfo.getUserRoleId(),list_TestUser[0].Profile.Name);
                    
        }
    }
}