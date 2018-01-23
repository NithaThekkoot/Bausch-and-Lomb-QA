@isTest(SeeAllData=true)
private class Test_ExtCreateCallPlan_KOR_SOLTA
 {
    static TestMethod void TestMethod_clsSingleMultiUtil(){
    
      UserRole objRoleSalesAdmin = [Select Id From UserRole where name LIKE '%KOR SOLTA%' LIMIT 1]; 
        Profile objProfileIntegrationUser = [SELECT Id FROM profile WHERE name LIKE '%KOR SOLTA%' LIMIT 1]; 
        User objUserIngetration = new User(alias = 'integra', email='integration@testorg.com', emailencodingkey='UTF-8',
                             lastname='Testing', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles',
                             username='integration123@testorg.com', profileid = objProfileIntegrationUser.Id, UserroleId = objRoleSalesAdmin.Id);
        Database.SaveResult sr = Database.insert(objUserIngetration);
        User objTestUser = [SELECT ID FROM USER WHERE ID = :sr.getId()];
        
        Account objTestAcc = new Account();
        
         system.runAs(objTestUser)
        {
                      Test.startTest();
        ClsSingleMultiUtility.WeekDetails objTestContactDetails = new ClsSingleMultiUtility.WeekDetails();                
        ClsSingleMultiUtility.getParents(UserInfo.getUserRoleId());
        
        DateTime dtTimeTest1 = DateTime.newInstance(Date.Today().year(),Date.Today().month(),Date.Today().day()-1);
        DateTime dtTimeTest2 = DateTime.newInstance(Date.Today().year(),Date.Today().month(),Date.Today().day()-2);
        DateTime dtTimeTest3 = DateTime.newInstance(Date.Today().year(),Date.Today().month(),Date.Today().day()-3);
        DateTime dtTimeTest4 = DateTime.newInstance(Date.Today().year(),Date.Today().month(),Date.Today().day()-4);
        DateTime dtTimeTest5 = DateTime.newInstance(Date.Today().year(),Date.Today().month(),Date.Today().day()-5);
        DateTime dtTimeTest6 = DateTime.newInstance(Date.Today().year(),Date.Today().month(),Date.Today().day()-6);
        
        
        ClsSingleMultiUtility.getWeekInDifferentFormat(Datetime.now(),ClsSingleMultiUtility.getWeekFormat(UserInfo.getUserRoleId()));
        ClsSingleMultiUtility.getWeekInDifferentFormat(dtTimeTest1, ClsSingleMultiUtility.getWeekFormat(UserInfo.getUserRoleId()));
        ClsSingleMultiUtility.getWeekInDifferentFormat(dtTimeTest2, ClsSingleMultiUtility.getWeekFormat(UserInfo.getUserRoleId()));
        ClsSingleMultiUtility.getWeekInDifferentFormat(dtTimeTest3, ClsSingleMultiUtility.getWeekFormat(UserInfo.getUserRoleId()));
        ClsSingleMultiUtility.getWeekInDifferentFormat(dtTimeTest4, ClsSingleMultiUtility.getWeekFormat(UserInfo.getUserRoleId()));
        ClsSingleMultiUtility.getWeekInDifferentFormat(dtTimeTest5, ClsSingleMultiUtility.getWeekFormat(UserInfo.getUserRoleId()));
        ClsSingleMultiUtility.getWeekInDifferentFormat(dtTimeTest6, ClsSingleMultiUtility.getWeekFormat(UserInfo.getUserRoleId()));
        
        ClsSingleMultiUtility.getDisplayWeek(Date.Today()-7,Date.Today());
        ClsSingleMultiUtility.getDisplayDate(Date.Today());
        ClsSingleMultiUtility.getListOfDays(Date.Today()-7,Date.Today());  
        ClsSingleMultiUtility.getWeekStringAndWeekDateMap();          
          
            objTestAcc.name = 'Test Account';
            objTestAcc.OwnerId = objTestUser.Id;
            insert objTestAcc; 
            
            //Single call plan and its detail object
            Call_Plan__c objTestCallPlan = new Call_Plan__c();        
            objTestCallPlan.Start_Date__c = Date.Today().toStartOfMonth().addDays(-50);
            objTestCallPlan.End_Date__c = Date.Today().toStartOfMonth();   
            objTestCallPlan.Month__c = 'Nov';   
            objTestCallPlan.Year__c = String.valueOf(Date.today().year());              
            objTestCallPlan.OwnerId = userInfo.getUserId();        
            insert objTestCallPlan; 
                
        
        Call_Plan_Detail__c objTestCPD = new Call_Plan_Detail__c();        
            objTestCPD.Call_Plan__c = objTestCallPlan.Id;
            objTestCPD.Date__c = Date.Today().toStartOfMonth().addDays(-48);
            objTestCPD.Account__c = objTestAcc.Id;
            insert objTestCPD;  
         
      Test.stopTest();      
    
   }
    }//method
    static TestMethod void TestMethod_ExtCreateCallPlan()
    {       
       
        UserRole objRoleSalesAdmin = [Select Id From UserRole where name LIKE '%KOR SOLTA%' LIMIT 1]; 
        Profile objProfileIntegrationUser = [SELECT Id FROM profile WHERE name LIKE 'KOR SOLTA Sales Rep' LIMIT 1];  
          
        User objUserIngetration = new User(alias = 'integra', email='integration@testorg.com', emailencodingkey='UTF-8',
                             lastname='Testing', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles',
                             username='integration123@testorg.com', profileid = objProfileIntegrationUser.Id, UserroleId = objRoleSalesAdmin.Id);
        Database.SaveResult sr = Database.insert(objUserIngetration);
        User objTestUser = [SELECT ID FROM USER WHERE ID = :sr.getId()];
        
        Account objTestAcc = new Account();
        
   RecordType rt =  [SELECT Id, Name FROM RecordType WHERE SObjectType='Physician_Visit__c' and Name = 'KORSOLTA Sales Planned' limit 1];                                 
                                               
        system.runAs(objTestUser)
        {
               Test.startTest();
            objTestAcc.name = 'Test Account';
            objTestAcc.OwnerId = objTestUser.Id;
            insert objTestAcc;
            
            //Single call plan and its detail object
            Call_Plan__c objTestCallPlan = new Call_Plan__c();        
            objTestCallPlan.Start_Date__c = Date.Today().toStartOfMonth().addDays(-50);
            objTestCallPlan.End_Date__c = Date.Today().toStartOfMonth();   
            objTestCallPlan.Month__c = 'Nov';   
            objTestCallPlan.Year__c = String.valueOf(Date.today().year());         //'2011';       
            objTestCallPlan.OwnerId = userInfo.getUserId();        
            insert objTestCallPlan;
            
            Call_Plan_Detail__c objTestCPD = new Call_Plan_Detail__c();        
            objTestCPD.Call_Plan__c = objTestCallPlan.Id;
            objTestCPD.Date__c = Date.Today().toStartOfMonth().addDays(-48);
            objTestCPD.Account__c = objTestAcc.Id;
            insert objTestCPD; 
        
           objTestCallPlan.status__c = 'Approved';
          // update objTestCallPlan;
         Test.stopTest();  
        
        }
        
        Account objTestAcc1 = new Account();
        
            
        system.runAs(objTestUser)
        {
           
            objTestAcc1.name = 'Test Account1';
            objTestAcc1.OwnerId = objTestUser.Id;
            insert objTestAcc1;
 
             
            //Single call plan and its detail object
            Call_Plan__c objTestCallPlan1 = new Call_Plan__c();        
            objTestCallPlan1.start_Date__c = Date.Today()-7;
            objTestCallPlan1.End_Date__c = Date.Today();        
            objTestCallPlan1.OwnerId = userInfo.getUserId();   
            objTestCallPlan1.Year__c = String.valueOf(Date.today().year());            
            insert objTestCallPlan1;
        
        
            Call_Plan_Detail__c objTestCPD1 = new Call_Plan_Detail__c();        
            objTestCPD1.Call_Plan__c = objTestCallPlan1.Id;
            objTestCPD1.Date__c = Date.Today();
            objTestCPD1.Account__c = objTestAcc1.Id;
            //insert objTestCPD1;        
        
  //getting data from Data base
  Call_Plan__c  objTestCallPlan2 = [select id,name,start_Date__C,End_Date__C,status__c,Year__c ,OwnerId  from Call_Plan__c where status__c = 'Draft' limit 1];
  
     
        
            ApexPages.StandardController testController = new ApexPages.StandardController(objTestCallPlan2);  
            ExtCreateCallPlan_KOR_SOLTA objTestExtCreateCallPlan = new ExtCreateCallPlan_KOR_SOLTA(testController);
            
            PageReference objPageRef = new PageReference('/apex/ExtCreateCallPlan_SingleWeek_KOR_SOLTA?Id=' + objTestCallPlan2.Id);
            Test.setCurrentPage(objPageRef);
            
           
            objTestExtCreateCallPlan.saveAndSchedule();
            objTestExtCreateCallPlan.schedule();
            objTestExtCreateCallPlan.getAllWeeks();
            objTestExtCreateCallPlan.save();
            objTestExtCreateCallPlan.saveCallPlan();        
            objTestExtCreateCallPlan.cancel();        
            
            testController = new ApexPages.StandardController(objTestCallPlan2);  
            objTestExtCreateCallPlan = new ExtCreateCallPlan_KOR_SOLTA(testController);
            
            objPageRef = new PageReference('/apex/ExtCreateCallPlan_SingleWeek_KOR_SOLTA?Id=' + objTestCallPlan2.Id);
            Test.setCurrentPage(objPageRef);
            
            objTestExtCreateCallPlan.saveAndSchedule();
            objTestExtCreateCallPlan.schedule();
            objTestExtCreateCallPlan.getAllWeeks();
            objTestExtCreateCallPlan.save();//
            objTestExtCreateCallPlan.saveCallPlan(); //       
            objTestExtCreateCallPlan.cancel();        
            objTestExtCreateCallPlan.redirectFromNewPage();
            
            //testController = new ApexPages.StandardController(objTestCallPlan2);  
            //objTestExtCreateCallPlan = new ExtCreateCallPlan_KOR_SOLTA(testController);
            
            //objPageRef = new PageReference('/apex/ExtCreateCallPlan_SingleWeek?RecordType='+list_RTMultiple[0].Id);
            //Test.setCurrentPage(objPageRef);
            
        }
    }
}