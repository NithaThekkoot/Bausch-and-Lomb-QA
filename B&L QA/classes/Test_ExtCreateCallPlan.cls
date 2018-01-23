/*
* 
* This class covers class ExtCreateCallPlan.
* Author                        |Author-Email                                      |Date        |Comment
* ------------------------------|------------------------------------------------- |------------|----------------------------------------------------
* Sourav Mitra                  |sourav.mitra@listertechnologies.com               |29.10.2010  |First Draft
* Santosh Kumar                 |santosh.sriram@listertechnologies.com             |02.12.2010  |Changes in the INDSU Call plan : month__c
*/ 
@isTest
private class Test_ExtCreateCallPlan
{
    static TestMethod void TestMethod_ExtCreateCallPlan()
    {        
        List<RecordType> list_RTSingle = [SELECT Id, Name, sObjectType FROM RecordType WHERE sObjectType = 'Call_Plan__c' AND Name IN ('APACSU Call Plan','INDSU Call Plan') ORDER BY Name LIMIT 2];
        
        /*Profile objProfileIntegrationUser = [SELECT Id FROM profile WHERE name='APACSU System Administrator']; 
        UserRole objRoleAccountOwner = [Select Id From UserRole where name = 'CHNSU Account Owner']; 
         
        User objUserIngetration = new User(alias = 'integra', email='integration@testorg.com', emailencodingkey='UTF-8',
                             lastname='Testing', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles',
                             username='integration@testorg.com', profileid = objProfileIntegrationUser.Id, userRoleId=objRoleAccountOwner.Id); */
        
        List<Profile> list_objProfileSalesRep = [SELECT Id FROM profile WHERE name='APACSU Sales Rep' OR name='APACSU China Sales Rep' OR name='INDSU Sales Rep']; 
        
        //User objUserSalesRep = [SELECT Id,ProfileId,UserRoleId From User Where isActive=true AND UserRoleId!=Null AND ProfileId in : list_objProfileSalesRep Limit 1];
        
        User objUserSalesRep = [SELECT Id, Name, Profile.Name, UserRole.Name 
                            FROM User 
                            WHERE ProfileId in : list_objProfileSalesRep
                                  AND isActive=True 
                                  AND UserRole.Name like : ('%' + 'Rep' + '%') LIMIT 1];
                                  
        Account objTestAcc = new Account();     
        objTestAcc.name = 'Test Account';
        objTestAcc.ownerId = objUserSalesRep.Id;
        insert objTestAcc;
        
        System.runAs(objUserSalesRep)
        { 
            Contact objTestCon1 = new Contact();
            objTestCon1.FirstName = 'Test First Name';
            objTestCon1.LastNAme = 'Test Last Name';
            objTestCon1.Title = 'Ms';
            objTestCon1.AccountId = objTestAcc.Id;
            insert objTestCon1;
            
            //Single call plan and its detail object
            Call_Plan__c objTestCallPlan1 = new Call_Plan__c();
            objTestCallPlan1.Start_Date__c = Date.Today()-7;
            objTestCallPlan1.End_Date__c = Date.Today();
            objTestCallPlan1.OwnerId = userInfo.getUserId();
            objTestCallPlan1.RecordTypeId = list_RTSingle[0].Id;
            insert objTestCallPlan1;
            
            Call_Plan_Detail__c objTestCPD1 = new Call_Plan_Detail__c();        
            objTestCPD1.Call_Plan__c = objTestCallPlan1.Id;
            objTestCPD1.Date__c = Date.Today();
            objTestCPD1.physician_Name__c = objTestCon1.Id;
            objTestCPD1.Joint_Call__c = false;
            insert objTestCPD1;
            
            ApexPages.StandardController testController = new ApexPages.StandardController(objTestCallPlan1);  
            ExtCreateCallPlan objTestExtCreateCallPlan = new ExtCreateCallPlan(testController);
            
            PageReference objPageRef = new PageReference('/apex/ExtCreateCallPlan_SingleWeek?Id=' + objTestCallPlan1.Id);
            Test.setCurrentPage(objPageRef);
            
            objTestExtCreateCallPlan = new ExtCreateCallPlan(testController);
            
            objTestExtCreateCallPlan.saveAndSchedule();
            objTestExtCreateCallPlan.schedule();
            objTestExtCreateCallPlan.getAllWeeks();
            objTestExtCreateCallPlan.save();
            objTestExtCreateCallPlan.saveCallPlan();
            objTestExtCreateCallPlan.cancel();
            objTestExtCreateCallPlan.redirectFromNewPage();
            
            //INDSU call plan
            Map<Integer,String> month_link = new Map<Integer, String>{1=>'Jan', 2=>'Feb',3=>'Mar',4=>'Apr',5=>'May',6=>'Jun',7=>'Jul',8=>'Aug',9=>'Sep',10=>'Oct',11=>'Nov',12=>'Dec'};
            Date test_date = Date.Today();
            Date month_start = test_date.toStartOfMonth();
            //month_start = month_start + 31;
            objTestCallPlan1 = new Call_Plan__c();
            objTestCallPlan1.Month__c = month_link.get(month_start.month());
            objTestCallPlan1.year__c = String.valueOf(Date.today().year());
            objTestCallPlan1.OwnerId = userInfo.getUserId();
            objTestCallPlan1.RecordTypeId = list_RTSingle[1].Id;
            insert objTestCallPlan1;
            
            objPageRef = new PageReference('/apex/ExtCreateCallPlan_SingleWeek?Id=' + objTestCallPlan1.Id);
            Test.setCurrentPage(objPageRef);
            
            objTestExtCreateCallPlan = new ExtCreateCallPlan(testController);
            objTestExtCreateCallPlan.redirectFromNewPage();
            
            objPageRef = new PageReference('/apex/ExtCreateCallPlan_SingleWeek?RecordType=' + list_RTSingle[1].Id + '&Id=' + objTestCallPlan1.Id);
            Test.setCurrentPage(objPageRef);
            
            objTestExtCreateCallPlan.redirectFromNewPage(); 
        }           
    }
}