/*
* 
* This class covers class ExtViewCallPlan.
* Author                        |Author-Email                                      |Date        |Comment
* ------------------------------|------------------------------------------------- |------------|----------------------------------------------------
* venkateswara Reddy                  |venkateswara.reddy2@bausch.com          |24.11.2010  |First Draft
* 
*/ 
@isTest
private class Test_ExtViewCallPlan_KOR_SOLTA
{

    public static  Boolean blnHasDetails;
     public static  Boolean blnIsEditable;
    static TestMethod void TestMethod_ExtViewCallPlan()
    {   
        /*
        User objTestUser = [SELECT Id, Name, Profile.Name, UserRole.Name 
                            FROM User 
                            WHERE Profile.Name like : (Label.apacvc_label+ '%') AND Profile.Name like : ('%' + 'Executive' + '%')
                                  AND UserRole.Name like : (Label.china_label + '%') AND UserRole.Name like : ('%' + 'Executive' + '%') LIMIT 1];
        */

       // UserRole objRoleSalesAdmin = [Select Id From UserRole where name LIKE '%KOR SOLTA Administrator%' LIMIT 1]; KOR SOLTA Sales Rep
        UserRole objRoleSalesAdmin = [Select Id From UserRole where name LIKE '%KOR SOLTA Sales Rep%' LIMIT 1];
        Profile objProfileIntegrationUser = [SELECT Id FROM profile WHERE name LIKE 'BL: System Admin SSO' LIMIT 1]; 
        User objUserIngetration = new User(alias = 'integra', email='integration@testorg.com', emailencodingkey='UTF-8',
                             lastname='Testing', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles',
                             username='integration@testorg.com', profileid = objProfileIntegrationUser.Id, UserroleId = objRoleSalesAdmin.Id);
        Database.SaveResult sr = Database.insert(objUserIngetration);
        User objTestUser = [SELECT ID,profile.Name FROM USER WHERE ID = :sr.getId()];
        
        Account objTestAcc = new Account();

        
        system.runAs(objTestUser)
        {
            objTestAcc.name = 'Test Account';
            objTestAcc.OwnerId = objTestUser.Id;
            insert objTestAcc;
            
            //Single call plan and its detail object
            Call_Plan__c objTestCallPlan = new Call_Plan__c();        
            objTestCallPlan.Start_Date__c= Date.Today().AddDays(6);
            objTestCallPlan.End_Date__c= Date.Today().AddDays(12);  
            objTestCallPlan.Month__c = 'Nov';   
            objTestCallPlan.Year__c = String.valueOf(Date.today().year());         //'2011';        
            objTestCallPlan.OwnerId = userInfo.getUserId();        
            insert objTestCallPlan;
        
        
            Call_Plan_Detail__c objTestCPD = new Call_Plan_Detail__c();        
            objTestCPD.Call_Plan__c = objTestCallPlan.Id;
            objTestCPD.Date__c = Date.Today().AddDays(6);
            objTestCPD.Account__c = objTestAcc.Id;
            insert objTestCPD;
             
            if(objTestCallPlan.Call_Plan_Detail__r.size() > 0){
             blnHasDetails = true;
            }
            if(objTestCallPlan.Status__c == 'Submitted' || objTestCallPlan.Status__c == 'Approved')
                blnIsEditable = false;
        
        }
        
        Account objTestAcc1 = new Account();
        
            
        system.runAs(objTestUser)
        {
           
            objTestAcc1.name = 'Test Account1';
            objTestAcc1.OwnerId = objTestUser.Id;
            insert objTestAcc1;
            
            //Single call plan and its detail object
            Call_Plan__c objTestCallPlan1 = new Call_Plan__c();        
            objTestCallPlan1.Start_Date__c= Date.Today().AddDays(13);
            objTestCallPlan1.End_Date__c= Date.Today().AddDays(19);         
            objTestCallPlan1.OwnerId = userInfo.getUserId();  
            objTestCallPlan1.Year__c = String.valueOf(Date.today().year());
            objTestCallPlan1.Status__c = 'Draft';     
            insert objTestCallPlan1;
        
        
            Call_Plan_Detail__c objTestCPD1 = new Call_Plan_Detail__c();        
            objTestCPD1.Call_Plan__c = objTestCallPlan1.Id;
            objTestCPD1.Date__c =Date.Today().AddDays(13);
            objTestCPD1.Account__c = objTestAcc1.Id;
            //insert objTestCPD1;  
            
            
        
            ApexPages.StandardController testController = new ApexPages.StandardController(objTestCallPlan1);  
            ExtViewCallPlan_KOR_SOLTA  objTestExtCreateCallPlan = new ExtViewCallPlan_KOR_SOLTA(testController);
            
            
       
            if(objTestCallPlan1.Call_Plan_Detail__r.size() > 0){
             blnHasDetails = true;
            }
            if(objTestCallPlan1.Status__c == 'Submitted' || objTestCallPlan1.Status__c == 'Approved')
                blnIsEditable = false;      
            else
                 blnIsEditable = true;
               
                 if(blnIsEditable){
   //  Profile thisProfile = [select Id,Name from Profile where Id =: objTestUser.Profile. LIMIT 1];            
                 if(objTestUser.Profile.Name !=NULL && objTestUser.Profile.Name.contains(Label.manager_label))
                    blnIsEditable = false;
                    
                if(objTestCallPlan1.Status__c == 'Submitted')
                    blnIsEditable = false;
            }
                 
                 
                 
                 
            
            
            /////
             objTestExtCreateCallPlan.objCallPlan=objTestCallPlan1;
             objTestExtCreateCallPlan.schedule();
             ////
            PageReference objPageRef = new PageReference('/apex/ExtViewCallPlan_Single_Week_KOR_SOLTA?Id=' + objTestCallPlan1.Id);
            Test.setCurrentPage(objPageRef);
            
            //objTestExtCreateCallPlan.schedule();                        
            objTestExtCreateCallPlan.cancel();        
            
            testController = new ApexPages.StandardController(objTestCallPlan1);  
            objTestExtCreateCallPlan = new ExtViewCallPlan_KOR_SOLTA(testController);
            
            objPageRef = new PageReference('/apex/ExtViewCallPlan_Single_Week_KOREA?Id=' + objTestCallPlan1.Id);
            Test.setCurrentPage(objPageRef);            
            
            //objTestExtCreateCallPlan.schedule();            
            objTestExtCreateCallPlan.cancel();        
            objTestExtCreateCallPlan.redirectFromNewPage();
            
            testController = new ApexPages.StandardController(objTestCallPlan1);  
            objTestExtCreateCallPlan = new ExtViewCallPlan_KOR_SOLTA(testController);
            
            //objPageRef = new PageReference('/apex/ExtCreateCallPlan_SingleWeek?RecordType='+list_RTMultiple[0].Id);
            //Test.setCurrentPage(objPageRef);
        }
    }
}