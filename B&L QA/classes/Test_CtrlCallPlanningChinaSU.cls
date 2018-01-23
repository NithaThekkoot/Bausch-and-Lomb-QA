/**
 *
 * This class covers the apex class CtrlCallPlanningChinaSU
 *
 *
 *      Author           |Author-Email                          |Date       |Comment
 *      -----------------|--------------------------------------|-----------|--------------------------------------------------
 *      Sourav Mitra     |sourav.mitra@listertechnologies.com   |21.09.2010 |First Draft
 *      Sourav Mitra     |sourav.mitra@listertechnologies.com   |29.10.2010 |Changes to incorporate weekly call plan
 *      Raviteja Vakity  |raviteja.vakity@bausch.com            |04.07.2013 |Increased the Code Coverage of CtrlCallPlanningChinaSU class
 *      Neha Jain        |neha.jain@bausch.com                  |20.03.2014 |Increased the Code Coverage of CtrlCallPlanningChinaSU class
 */
@isTest
private class Test_CtrlCallPlanningChinaSU {

    public static testMethod void callPlanUnitTest() 
    {
        // for getting the month name
        
        UserRole objRoleAccountOwner = [Select Id From UserRole where name = 'CHNSU Account Owner']; 
        UserRole objRoleSalesRep = [Select Id From UserRole where name = 'CHNSU Sales Rep (Central)'];//CHNSU Regional Sales Manager (Central) 
        UserRole objRoleSalesMgr = [Select Id From UserRole where name = 'CHNSU Regional Sales Manager (Central)'];
        //Parag Sharma | 15-Apr-13 | SFE Custom Report for India | start        
        UserRole objRoleINDSalesRep = [Select Id From UserRole where name = 'INDSU Sales Rep (East 2)'];
        //Parag Sharma | 15-Apr-13 | SFE Custom Report for India | End
        //Kandarp Shah | 26-Jan-13 | Resolve the issue of ANZSU validation error | start
        //comented the line below and added the profile BL: System Admin SSO
        //Profile objProfileIntegrationUser = [SELECT Id FROM profile WHERE name='APACSU System Administrator']; 
        Profile objProfileIntegrationUser = [SELECT Id FROM profile WHERE name= 'BL: System Admin SSO']; 

        Profile objProfileSalesRep = [SELECT Id FROM profile WHERE name='APACSU Sales Rep']; //APACSU Sales Manager        
        Profile objProfileSalesMgr = [SELECT Id FROM profile WHERE name='APACSU Sales Manager']; 
        //Parag Sharma | 15-Apr-13 | SFE Custom Report for India | Start
        Profile objProfileINDSalesRep = [SELECT Id FROM profile WHERE name='INDSU Sales Rep']; 
        //Parag Sharma | 15-Apr-13 | SFE Custom Report for India | End
        
        User objUserIngetration = new User(alias = 'integra', email='integration@testorg.com', emailencodingkey='UTF-8',
                             lastname='Testing', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles',
                             username='integration@testorg.com', profileid = objProfileIntegrationUser.Id, userRoleId=objRoleAccountOwner.Id);
        
        User objUserSalesMgr = new User(alias = 'salesmgr', email='salesmgr@testorg.com', emailencodingkey='UTF-8',
                         lastname='Testing', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles',
                         username='salesmgr@testorg.com', profileid = objProfileSalesMgr.Id, userRoleId=objRoleSalesMgr.Id);
        
        List<User> list_User = new List<User>();
        list_User.add(objUserIngetration);
        list_User.add(objUserSalesMgr);
        insert list_User;
        
        User objUserSalesRep = new User(alias = 'salesrep', email='salesrep@testorg.com', emailencodingkey='UTF-8',
                         lastname='Testing', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles',
                         username='salesrep@testorg.com', profileid = objProfileSalesRep.Id, userRoleId=objRoleSalesRep.Id, ManagerId=objUserSalesMgr.Id);

        insert objUserSalesRep;
        
        User objUserINDSalesRep = new User(alias = 'salesr1', email='salesrep@testneworg.com', emailencodingkey='UTF-8',
                         lastname='Testing1', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='Asia/Kolkata',
                         username='salesrep@testneworg.com', profileid = objProfileINDSalesRep.Id, userRoleId=objRoleINDSalesRep.Id, ManagerId=objUserSalesMgr.Id);
        insert objUserINDSalesRep;
        System.debug(objUserSalesRep.ManagerId);
        // Getting Id for recordTypes
        
        Id idDirectRecordType = [SELECT Id FROM RecordType 
                                        WHERE Name = 'APACSU Direct' AND SObjectType='Account'].Id;
        Id idRecordTypeCallPlan = [SELECT Id FROM RecordType 
                                        WHERE Name = 'APACSU Call Plan' AND SObjectType='Call_Plan__c'].Id;
        
        Id idRecordTypeCallPlanDetail = [SELECT Id FROM RecordType 
                                        WHERE Name = 'APACSU Call Plan Detail' AND SObjectType='Call_Plan_Detail__c'].Id;
        
       
                                        
        Id idRecordTypeContact = [SELECT Id FROM RecordType 
                                        WHERE Name = 'APACSU Contact' AND SObjectType='Contact'].Id;

        // for inserting the list of accounts
        Account[] list_accounts = new List<Account>();
        Contact[] list_contacts = new List<Contact>();
        
        System.runAs(objUserIngetration) {
        
            Account objTestAccount1 = new Account();
            objTestAccount1.name = 'Test name';
            objTestAccount1.recordTypeId = idDirectRecordType;
            objTestAccount1.Status__c = 'A – Active';
            //objTestAccount1.OwnerId = objUserIngetration.Id;
            list_accounts.add(objTestAccount1);
            
            Account objTestAccount2 = new Account();
            objTestAccount2.name = 'Test name';
            objTestAccount2.recordTypeId = idDirectRecordType;
            objTestAccount2.Status__c = 'A – Active';
            list_accounts.add(objTestAccount2);
            
            Account objTestAccount3 = new Account();
            objTestAccount3.name = 'Test name';
            objTestAccount3.recordTypeId = idDirectRecordType;
            objTestAccount3.Status__c = 'A – Active';
            list_accounts.add(objTestAccount3);
            
            Account objTestAccount4 = new Account();
            objTestAccount4.name = 'Test name';
            objTestAccount4.recordTypeId = idDirectRecordType;
            objTestAccount4.Status__c = 'A – Active';
            list_accounts.add(objTestAccount4);
            
            Account objTestAccount5 = new Account();
            objTestAccount5.name = 'Test name';
            objTestAccount5.recordTypeId = idDirectRecordType;
            objTestAccount5.Status__c = 'A – Active';
            list_accounts.add(objTestAccount5);
            
            insert list_accounts;
            
            List<Account_Profile__c> list_Accountprofiles =  new List<Account_Profile__c>();
            
            Account_Profile__c objProf1 = new Account_Profile__c();
            objProf1.Segmentation__c = 'Tier 1';
            objProf1.Account__c = list_accounts[0].Id;
            objProf1.Area__c = 'Test';
            list_Accountprofiles.add(objProf1);
            
            Account_Profile__c objProf2 = new Account_Profile__c();
            objProf2.Segmentation__c = 'Tier 2';
            objProf2.Account__c = objTestAccount2.Id;
            objProf2.Area__c = 'Test';
            list_Accountprofiles.add(objProf2);
            
            Account_Profile__c objProf3 = new Account_Profile__c();
            objProf3.Segmentation__c = 'Tier 3';
            objProf3.Account__c = objTestAccount3.Id;
            objProf3.Area__c = 'Test';
            list_Accountprofiles.add(objProf3);
            
            Account_Profile__c objProf4 = new Account_Profile__c();
            objProf4.Segmentation__c = 'Tier 4';
            objProf4.Account__c = objTestAccount4.Id;
            objProf4.Area__c = 'Test';
            list_Accountprofiles.add(objProf4);
            
            Account_Profile__c objProf5 = new Account_Profile__c();
            objProf5.Segmentation__c = 'Tier 5';
            objProf5.Account__c = objTestAccount5.Id;
            objProf5.Area__c = 'Test';
            list_Accountprofiles.add(objProf5);
            
            insert list_Accountprofiles;
            
            //List<Account_Profile__c> listAccountProfile = [Select Segmentation__c from Account_Profile__c where Id in: list_Accountprofiles];
            //system.debug('***listAccountProfile ' + listAccountProfile);
            
            integer i = 1;
            for(Account_Profile__c ac : list_Accountprofiles){
                ac.Segmentation__c = 'Tier ' + i;
                i++;
            }
            update list_Accountprofiles;
            
            
            AccountTeamMember[] list_accountTeamMembers = new List<AccountTeamMember>();
            
            AccountTeamMember teamMember1 = new AccountTeamMember();
            teamMember1.UserId = objUserSalesRep.Id;
            teamMember1.AccountId = list_accounts[0].Id;
            list_accountTeamMembers.add(teamMember1);
            
            AccountTeamMember teamMember2 = new AccountTeamMember();
            teamMember2.UserId = objUserSalesRep.Id;
            teamMember2.AccountId = list_accounts[1].Id;
            list_accountTeamMembers.add(teamMember2);
            
            AccountTeamMember teamMember3 = new AccountTeamMember();
            teamMember3.UserId = objUserSalesRep.Id;
            teamMember3.AccountId = list_accounts[2].Id;
            list_accountTeamMembers.add(teamMember3);
            
            AccountTeamMember teamMember4 = new AccountTeamMember();
            teamMember4.UserId = objUserSalesRep.Id;
            teamMember4.AccountId = list_accounts[3].Id;
            list_accountTeamMembers.add(teamMember4);
            
            AccountTeamMember teamMember5 = new AccountTeamMember();
            teamMember5.UserId = objUserSalesRep.Id;
            teamMember5.AccountId = list_accounts[4].Id;
            list_accountTeamMembers.add(teamMember5);
            
            insert list_accountTeamMembers;
            
            Contact objTestContact1 = new Contact();
            objTestContact1.RecordTypeId = idRecordTypeContact;
            objTestContact1.Lastname = 'test Contact1';
            objTestContact1.AccountId = list_accounts[0].Id;
            list_contacts.add(objTestContact1);
            
            Contact objTestContact2 = new Contact();
            objTestContact2.RecordTypeId = idRecordTypeContact;
            objTestContact2.Lastname = 'test Contact2';
            objTestContact2.AccountId = list_accounts[1].Id;
            list_contacts.add(objTestContact2);
            
            Contact objTestContact3 = new Contact();
            objTestContact3.RecordTypeId = idRecordTypeContact;
            objTestContact3.Lastname = 'test Contact3';
            objTestContact3.AccountId = list_accounts[2].Id;
            list_contacts.add(objTestContact3);
            
            Contact objTestContact4 = new Contact();
            objTestContact4.RecordTypeId = idRecordTypeContact;
            objTestContact4.Lastname = 'test Contact4';
            objTestContact4.AccountId = list_accounts[3].Id;
            list_contacts.add(objTestContact4);
            
            Contact objTestContact5 = new Contact();
            objTestContact5.RecordTypeId = idRecordTypeContact;
            objTestContact5.Lastname = 'test Contact5';
            objTestContact5.AccountId = list_accounts[4].Id;
            list_contacts.add(objTestContact5);
            
            insert list_contacts;
        }
        
        Call_Plan__c objnewCallPlan;
         System.runAs(objUserSalesRep) {   
            
              
            // creating call plan 
            objnewCallPlan = new Call_Plan__c();
            Date datReference1 = Date.today();
            Date datReference2 = datReference1.addmonths(1);
            objnewCallPlan.RecordTypeId = idRecordTypeCallPlan;
            objnewCallPlan.Status__c = 'Draft';
            objnewCallPlan.Manager_Comments__c = 'Test';
            objnewCallPlan.Executive_Comments__c = 'Test';
            objnewCallPlan.Start_Date__c = Date.newInstance(2013,1,22);
            objnewCallPlan.End_Date__c = Date.newInstance(2013,1,28);            
            objnewCallPlan.OwnerId = objUserSalesRep.Id;
            //try{
                insert objnewCallPlan;
            //} catch(Exception e){}
            
            // for covering the validation trigger
            Call_Plan__c[] list_callPlanForTrigger = new List<Call_Plan__c>();
            
            Call_Plan__c objCallPlan1 = new Call_Plan__c();
            objCallPlan1.RecordTypeId = idRecordTypeCallPlan;
            objCallPlan1.Status__c = 'Submitted';
            objCallPlan1.Manager_Comments__c = 'Test';
            objCallPlan1.Executive_Comments__c = 'Test';
            objCallPlan1.Start_Date__c = Date.newInstance(2013,1,1);
            objCallPlan1.End_Date__c = Date.newInstance(2013,1,7);
            objCallPlan1.City__c = 'Delhi';
            objCallPlan1.Region__c = 'East';
            objCallPlan1.Country__c = 'India';        
            
            Call_Plan__c objCallPlan2 = new Call_Plan__c();
            objCallPlan2.RecordTypeId = idRecordTypeCallPlan;
            objCallPlan2.Status__c = 'Draft';
            objCallPlan2.Manager_Comments__c = 'Test';
            objCallPlan2.Executive_Comments__c = 'Test';
            objCallPlan2.Start_Date__c = Date.newInstance(2013,1,8);
            objCallPlan2.End_Date__c = Date.newInstance(2013,1,14);
            
            Call_Plan__c objCallPlan3 = new Call_Plan__c();
            objCallPlan3.RecordTypeId = idRecordTypeCallPlan;
            objCallPlan3.Status__c = 'Draft';
            objCallPlan3.Manager_Comments__c = 'Test';
            objCallPlan3.Executive_Comments__c = 'Test';            
            //objCallPlan3.Start_Date__c = Date.newInstance(2013,1,15);
            //objCallPlan3.End_Date__c = Date.newInstance(2013,1,21);
            
            list_callPlanForTrigger.add(objCallPlan1);
            list_callPlanForTrigger.add(objCallPlan2);
            list_callPlanForTrigger.add(objCallPlan3);
            
            try{
                insert list_callPlanForTrigger;
            } catch(Exception e){}
            
       
           
          Call_Plan__c objEditCallPlan = new Call_Plan__c();
            
            System.debug(objnewCallPlan.id);
            
            //if(objnewCallPlan.id!=null)
           // {
                
                               
                // creating call plan details for the different classification
                Call_Plan_Detail__c[] callPlanDetailList = new List<Call_Plan_Detail__c>();
                
                Call_Plan_Detail__c cpd1 = new Call_Plan_Detail__c();                
                cpd1.RecordTypeId = idRecordTypeCallPlanDetail;
                cpd1.Call_Plan__c = objnewCallPlan.id;
                cpd1.Date__c = Date.newInstance(2013,1,22);
                cpd1.Physician_Name__c = list_contacts[0].Id;
                cpd1.Call__c = true;
                callPlanDetailList.add(cpd1);
                
                
                Call_Plan_Detail__c cpd2 = new Call_Plan_Detail__c();
                cpd2.RecordTypeId = idRecordTypeCallPlanDetail;
                cpd2.Call_Plan__c = objnewCallPlan.id;
                cpd2.Date__c = Date.newInstance(2013,1,23);
                cpd2.Physician_Name__c = list_contacts[1].Id;
                cpd2.Call__c = true;
                callPlanDetailList.add(cpd2);                
                
                Call_Plan_Detail__c cpd3 = new Call_Plan_Detail__c();
                cpd3.RecordTypeId = idRecordTypeCallPlanDetail;
                cpd3.Call_Plan__c = objnewCallPlan.id;
                cpd3.Date__c = Date.newInstance(2013,1,24);
                cpd3.Physician_Name__c = list_contacts[2].Id;
                cpd3.Call__c = true;
                callPlanDetailList.add(cpd3);
                
                Call_Plan_Detail__c cpd4 = new Call_Plan_Detail__c();
                cpd4.RecordTypeId = idRecordTypeCallPlanDetail;
                cpd4.Call_Plan__c = objnewCallPlan.id;
                cpd4.Date__c = Date.newInstance(2013,1,25);
                cpd4.Physician_Name__c = list_contacts[3].Id;
                cpd4.Call__c = true;
                callPlanDetailList.add(cpd4);
                
                try{
                insert callPlanDetailList;
                
                 // for testing the new functionality
                PageReference pr = new PageReference('/apex/CtrlCallPlan_planDetail?id=' + objnewCallPlan.id  + '&mode=new');
                Test.setCurrentPage(pr);
                
                System.debug('objUserSalesRep.ManagerId = '+objUserSalesRep.ManagerId);
                CtrlCallPlanningChinaSU cntrl1 = new CtrlCallPlanningChinaSU();

                system.debug('CallList>>>' + callPlanDetailList);               
                cntrl1.blnisSaveFlag = true;
                cntrl1.addErrorMessage('Test');   
                cntrl1.getArea='Test';
                cntrl1.getHospital='Test name';                
                cntrl1.go();
                cntrl1.details();
                cntrl1.getArea();
                cntrl1.clearAll();
                cntrl1.save();
                cntrl1.blnisSubmitFlag = true;
                cntrl1.save();
                
                PageReference pr1 = new PageReference('/apex/CtrlCallPlan_planDetail?id=' + objnewCallPlan.id  + '&mode=edit');
                Test.setCurrentPage(pr1);
                CtrlCallPlanningChinaSU cntrl11 = new CtrlCallPlanningChinaSU();
            
                cntrl11.blnisRejectFlag = true;
                cntrl11.save();                
                } catch(Exception e){
                    system.debug('Error save new plan ###' + e);
                }
     
                
                // for testing the clone functionality
                PageReference Clonepage = new PageReference('/apex/CtrlCallPlan_planDetail?id=' + objnewCallPlan.id  + '&mode=edit&clone=1');
                Test.setCurrentPage(Clonepage);
                CtrlCallPlanningChinaSU cntrl3 = new CtrlCallPlanningChinaSU();
                
                cntrl3.blnisSaveFlag = true;
                
                cntrl3.getHospital='Test name';                
                cntrl3.go();
                cntrl3.details();
                cntrl3.clearAll();                
                
                cntrl3.addErrorMessage('Test');   
                cntrl3.getArea='Test';
                cntrl3.getHospital='';                
                cntrl3.go();
                cntrl3.details();
                cntrl3.getArea();
                cntrl3.clearAll();
                                
                cntrl3.save();                
             //   cntrl3.saveAndDetails();
                
        

            //}
            PageReference pr11 = new PageReference('/apex/CtrlCallPlan_planDetail?id=' + objCallPlan1.id  + '&mode=edit');
            Test.setCurrentPage(pr11);
            CtrlCallPlanningChinaSU nodetails = new CtrlCallPlanningChinaSU();
            nodetails.createCallPlanRecords();
        }
        
         System.runAs(objUserSalesMgr) {
              PageReference pr1 = new PageReference('/apex/CtrlCallPlan_planDetail?id=' + objnewCallPlan.id  + '&mode=edit');
                Test.setCurrentPage(pr1);
                CtrlCallPlanningChinaSU cntrl11 = new CtrlCallPlanningChinaSU();
                try{
                    //cntrl11.blnisApproveFlag = true;
                    //cntrl11.save();  
                    cntrl11.blnisRejectFlag = true;
                    cntrl11.save();              
                }
                catch(Exception ex){}
          }
          
 
        
    }
    static testMethod void test1() 
    {
        ClsSingleMultiUtility objUtility = new ClsSingleMultiUtility();
        ClsSingleMultiUtility.ContactDetails objTemp1 = new ClsSingleMultiUtility.ContactDetails();
        ClsSingleMultiUtility.WeekDetails objTemp2 = new ClsSingleMultiUtility.WeekDetails();
        ClsSingleMultiUtility.getParents(UserInfo.getUserRoleId()); 
        ClsSingleMultiUtility.getWeek(DateTime.newInstance(2013,1,1,1,1,1));
        ClsSingleMultiUtility.getWeek(DateTime.newInstance(2013,1,2,1,1,1));
        ClsSingleMultiUtility.getWeek(DateTime.newInstance(2013,1,3,1,1,1));
        ClsSingleMultiUtility.getWeek(DateTime.newInstance(2013,1,4,1,1,1));
        ClsSingleMultiUtility.getWeek(DateTime.newInstance(2013,1,5,1,1,1));
        ClsSingleMultiUtility.getWeek(DateTime.newInstance(2013,1,6,1,1,1));
        ClsSingleMultiUtility.getWeek(DateTime.newInstance(2013,1,7,1,1,1));
        
        ClsSingleMultiUtility.getDisplayDate(Date.today());
        
        ClsSingleMultiUtility.getListOfDays(Date.today(),Date.today().addDays(6));
        
        ClsSingleMultiUtility.getWeekStringAndWeekDateMap();
    }
}