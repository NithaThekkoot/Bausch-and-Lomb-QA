/*
* 
* This class covers class CtrlCallPlanning_ChinaVC
* Author                        |Author-Email                                      |Date        |Comment
* ------------------------------|------------------------------------------------- |------------|----------------------------------------------------
* Venkateswara Reddy.C          |venkateswara.reddy2@bausch.com                    |11.15.2015  |First Draft
* 
* 
*/ 

@istest
private class Test_CtrlCallPlanning_KOR_SOLTA
{
      public static Boolean blnisManager;
    static TestMethod void TestMethod_CtrlCallPlanning_KoreaSu_1()
    {
      // User objTestUser = [SELECT Id, Name, Profile.Name,ManagerId,isActive,UserRole.Name  FROM User WHERE isActive = : true AND Profile.Name like : (Label.KOR_SOLTA_Label+'%') and ManagerId != : NULL AND UserRole.Name like : (Label.KOR_SOLTA_Label+ '%') AND UserRole.Name like : ('%' + 'KOR' + '%') LIMIT 1];
      
      User objTestUser = [Select id from User where Id = :UserInfo.getUserId()];
      
       system.runAs(objTestUser)
        {
            CtrlCallPlanning_KOR_SOLTA testCallPlanningObj = new CtrlCallPlanning_KOR_SOLTA();
            CtrlCallPlanning_KOR_SOLTA.CallPlan testCallPlanObj = new CtrlCallPlanning_KOR_SOLTA.CallPlan();
            CtrlCallPlanning_KOR_SOLTA.CallPlanDetail testCallPlanDetailObj = new CtrlCallPlanning_KOR_SOLTA.CallPlanDetail();
            CtrlCallPlanning_KOR_SOLTA.days testDays = new CtrlCallPlanning_KOR_SOLTA.days();
        }
        
        Account objTestAcc1 = new Account();
        system.runAs(objTestUser)
        {
            objTestAcc1 = new Account();
            objTestAcc1.name = 'Test Account1';
            objTestAcc1.OwnerId = objTestUser.Id;
            insert objTestAcc1;
        }   
        Account_Profile__c objTestAccProf1 = new Account_Profile__c();
        objTestAccProf1.DASRX_ABC_Classification__c = 'A';
        objTestAccProf1.Account__c = objTestAcc1.Id;
        objTestAccProf1.No_Of_Visits_Per_Month__c = 5;
        objTestAccProf1.Maximum_days_from_last_visit__c = 3;
        insert objTestAccProf1;
        
         
        system.runAs(objTestUser)
        {   
            //Single call plan and its detail object
            Call_Plan__c objTestCallPlan1 = new Call_Plan__c(); 
            objTestCallPlan1.Start_Date__c = Date.Today()-15;
            objTestCallPlan1.End_Date__c = Date.Today()-8;          
            objTestCallPlan1.OwnerId = userInfo.getUserId();        
            insert objTestCallPlan1; 
                   
           
            
            Call_Plan_Detail__c objTestCPD1 = new Call_Plan_Detail__c();        
            objTestCPD1.Call_Plan__c = objTestCallPlan1.Id;
             objTestCPD1.Date__c = Date.Today()-9;
            //objTestCPD1.Date__c = Date.Today().addDays(6);
            objTestCPD1.Account__c = objTestAcc1.Id;
            
            
            
            
          
         
            PageReference objPageRef = new PageReference('/apex/CallPlan_KOR_SOLTA?id=' + objTestCallPlan1.Id);
            Test.setCurrentPage(objPageRef);
            
            CtrlCallPlanning_KOR_SOLTA testCallPlanningObj1 = new CtrlCallPlanning_KOR_SOLTA();
            testCallPlanningObj1.cancel();
            //testCallPlanningObj1.doCloneAFterChoosingMonth();
            
            //ClsSingleMultiUtility.blnIsUpdateFromApproveReject = true;
            
            testCallPlanningObj1.blnisSaveFlag = true;
            testCallPlanningObj1.save();
            testCallPlanningObj1.getMonthsSelected();
            
            testCallPlanningObj1.blnisSubmitFlag = true;
            testCallPlanningObj1.save();
            
            testCallPlanningObj1.blnisApproveFlag = true;
            testCallPlanningObj1.save();
            
            testCallPlanningObj1.blnisRejectFlag = true;
            testCallPlanningObj1.save();
            
            
            //added by cvsr
             testCallPlanningObj1.getClass = 'A';
            testCallPlanningObj1.getarea= 'Area';
            testCallPlanningObj1.go();
            testCallPlanningObj1.getClass = 'B';
            testCallPlanningObj1.getarea= 'Area';
            testCallPlanningObj1.go();
            testCallPlanningObj1.getClass = 'C';
            testCallPlanningObj1.getarea= 'Area';
            testCallPlanningObj1.go();
            testCallPlanningObj1.getClass = 'D';
            testCallPlanningObj1.getarea= 'Area';
            testCallPlanningObj1.go();
          
            
            testCallPlanningObj1.getClass = '';
            testCallPlanningObj1.getarea= 'Area';
            testCallPlanningObj1.go();
            testCallPlanningObj1.clearAll();
            
                           
     
            
            
        }
        
    }  

    static TestMethod void TestMethod_CtrlCallPlanning_KoreaSu_2()
    {
        //User objTestUser = [SELECT Id, Name, Profile.Name,ManagerId,isActive,UserRole.Name   FROM User WHERE isActive = : true AND Profile.Name like : (Label.KOR_SOLTA_Label+'%') and ManagerId != : NULL AND UserRole.Name like : (Label.KOR_SOLTA_Label+ '%') AND UserRole.Name like : ('%' + 'KOR' + '%') LIMIT 1];
        
        User objTestUser = [Select id from User where Id = :UserInfo.getUserId()];
        
        
        
        
        system.runAs(objTestUser)
        {
            CtrlCallPlanning_KOR_SOLTA testCallPlanningObj = new CtrlCallPlanning_KOR_SOLTA();
            CtrlCallPlanning_KOR_SOLTA.CallPlan testCallPlanObj = new CtrlCallPlanning_KOR_SOLTA.CallPlan();
            CtrlCallPlanning_KOR_SOLTA.CallPlanDetail testCallPlanDetailObj = new CtrlCallPlanning_KOR_SOLTA.CallPlanDetail();
            CtrlCallPlanning_KOR_SOLTA.days testDays = new CtrlCallPlanning_KOR_SOLTA.days();
        }
        
        Account objTestAcc1 = new Account();
        system.runAs(objTestUser)
        {
            objTestAcc1 = new Account();
            objTestAcc1.name = 'Test Account1';
            objTestAcc1.OwnerId = objTestUser.Id;
            insert objTestAcc1;
        }   
        Account_Profile__c objTestAccProf1 = new Account_Profile__c();
        objTestAccProf1.DASRX_ABC_Classification__c = 'A';
        objTestAccProf1.Account__c = objTestAcc1.Id;
        objTestAccProf1.No_Of_Visits_Per_Month__c = 5;
        objTestAccProf1.Maximum_days_from_last_visit__c = 3;
        insert objTestAccProf1;
        
        
       
        system.runAs(objTestUser)
        {   
            //Single call plan and its detail object
            Call_Plan__c objTestCallPlan1 = new Call_Plan__c();  
            objTestCallPlan1.Start_Date__c=  Date.Today()-15;
            objTestCallPlan1.End_Date__c= Date.Today()-8;         
            objTestCallPlan1.OwnerId = userInfo.getUserId();        
            insert objTestCallPlan1;
    
            PageReference objPageRef = new PageReference('/apex/CallPlan_KOR_SOLTA?id=' + objTestCallPlan1.Id);
            Test.setCurrentPage(objPageRef);
            
            CtrlCallPlanning_KOR_SOLTA testCallPlanningObj1 = new CtrlCallPlanning_KOR_SOLTA();
            testCallPlanningObj1.cancel();
            
            ClsSingleMultiUtility.blnIsUpdateFromApproveReject = true;
            testCallPlanningObj1.doCloneAFterChoosingMonth();
            
            testCallPlanningObj1.blnisSaveFlag = true;
            testCallPlanningObj1.save();
            testCallPlanningObj1.getMonthsSelected();
            
            testCallPlanningObj1.blnisSubmitFlag = true;
            testCallPlanningObj1.save();
            
            testCallPlanningObj1.blnisApproveFlag = true;
            testCallPlanningObj1.save();
            
            testCallPlanningObj1.blnisRejectFlag = true;
            testCallPlanningObj1.save();
            
             testCallPlanningObj1.getClass = 'A';
            testCallPlanningObj1.getarea= 'Area';
            testCallPlanningObj1.go();
            testCallPlanningObj1.getClass = 'B';
            testCallPlanningObj1.getarea= 'Area';
            testCallPlanningObj1.go();
            testCallPlanningObj1.getClass = 'C';
            testCallPlanningObj1.getarea= 'Area';
            testCallPlanningObj1.go();
            testCallPlanningObj1.getClass = 'D';
            testCallPlanningObj1.getarea= 'Area';
            testCallPlanningObj1.go();
            
          
            
            testCallPlanningObj1.getClass = '';
            testCallPlanningObj1.getarea= 'Area';
            testCallPlanningObj1.go();
            testCallPlanningObj1.clearAll();
        }
        
    } 
        //Implementing the N & Z classification customers in call plan Only for Korea. 
       
       
        static TestMethod void TestMethod_CtrlCallPlanning_Korea_3()
    {
      
  //User objKorUser = [SELECT Id, Name, Profile.Name,ManagerId,isActive,UserRole.Name FROM User WHERE isActive = : true AND Profile.Name like : (Label.KOR_SOLTA_Label+'%') and ManagerId != : NULL AND UserRole.Name like : (Label.KOR_SOLTA_Label+ '%') AND UserRole.Name like : ('%' + 'KOR' + '%') LIMIT 1];     
    User objKorUser  = [Select id from User where Id = :UserInfo.getUserId()];
        
        
        
        
        
        system.runAs(objKorUser)
        {
            CtrlCallPlanning_KOR_SOLTA testCallPlanningObj = new CtrlCallPlanning_KOR_SOLTA();
            CtrlCallPlanning_KOR_SOLTA.CallPlan testCallPlanObj = new CtrlCallPlanning_KOR_SOLTA.CallPlan();
            CtrlCallPlanning_KOR_SOLTA.CallPlanDetail testCallPlanDetailObj = new CtrlCallPlanning_KOR_SOLTA.CallPlanDetail();
            CtrlCallPlanning_KOR_SOLTA.days testDays = new CtrlCallPlanning_KOR_SOLTA.days();
           
        }
        
        Account objTestAcc3 = new Account();
        system.runAs(objKorUser)
        {
            objTestAcc3 = new Account();
            objTestAcc3.name = 'Test Account3';
            objTestAcc3.OwnerId = objKorUser.Id;
            insert objTestAcc3;
        }   
        Account_Profile__c objTestAccProf3 = new Account_Profile__c();
        objTestAccProf3.DASRX_ABC_Classification__c = 'N';
        objTestAccProf3.Account__c = objTestAcc3.Id;
        objTestAccProf3.No_Of_Visits_Per_Month__c = 5;
        objTestAccProf3.Area__c = 'Area';
        objTestAccProf3.Maximum_days_from_last_visit__c = 3;
        insert objTestAccProf3;
        
          
        system.runAs(objKorUser)
        {   
            //Single call plan and its detail object
            Call_Plan__c objTestCallPlan1 = new Call_Plan__c(); 
           
                   
            objTestCallPlan1.Start_Date__c = Date.Today().addDays(25);
            objTestCallPlan1.End_Date__c = Date.Today().addDays(31);        
            objTestCallPlan1.OwnerId = userInfo.getUserId();        
            insert objTestCallPlan1; 
            
            
            Call_Plan_Detail__c objTestCPD1 = new Call_Plan_Detail__c();        
            objTestCPD1.Call_Plan__c = objTestCallPlan1.Id;
           // objTestCPD1.Date__c = Date.Today()-9;
            objTestCPD1.Date__c = Date.Today().addDays(25);
            objTestCPD1.Account__c = objTestAcc3.Id;
            insert objTestCPD1;  
           
           
            
            PageReference objPageRef = new PageReference('/apex/CallPlan_KOR_SOLTA?id=' + objTestCallPlan1.Id);
            Test.setCurrentPage(objPageRef);
            
            CtrlCallPlanning_KOR_SOLTA testCallPlanningObj1 = new CtrlCallPlanning_KOR_SOLTA();
            testCallPlanningObj1.cancel();
            
            ClsSingleMultiUtility.blnIsUpdateFromApproveReject = true;
           //testCallPlanningObj1.doCloneAFterChoosingMonth();
            
            testCallPlanningObj1.blnisSaveFlag = true;
           testCallPlanningObj1.save();
            testCallPlanningObj1.getMonthsSelected();
            
            testCallPlanningObj1.blnisSubmitFlag = true;
            testCallPlanningObj1.save();
            
            testCallPlanningObj1.blnisApproveFlag = true;
            testCallPlanningObj1.save();
            
            testCallPlanningObj1.blnisRejectFlag = true;
            testCallPlanningObj1.save();
            
            List<SelectOption> list_options = testCallPlanningObj1.getArea();
            List<SelectOption> list_Classifictn = testCallPlanningObj1.getClassifictn();
            testCallPlanningObj1.getClass = 'A';
            testCallPlanningObj1.getarea= 'Area';
            testCallPlanningObj1.go();
            testCallPlanningObj1.getClass = 'B';
            testCallPlanningObj1.getarea= 'Area';
            testCallPlanningObj1.go();
            testCallPlanningObj1.getClass = 'C';
            testCallPlanningObj1.getarea= 'Area';
            testCallPlanningObj1.go();
            testCallPlanningObj1.getClass = 'D';
            testCallPlanningObj1.getarea= 'Area';
            testCallPlanningObj1.go();
            
           
            
            testCallPlanningObj1.getClass = '';
            testCallPlanningObj1.getarea= 'Area';
            testCallPlanningObj1.go();
            testCallPlanningObj1.clearAll();
            
        }
        
    } 
    
     
     }