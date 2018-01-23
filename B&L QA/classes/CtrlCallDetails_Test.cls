/*
*
*
* Author                        |Author-Email                                      |Date        |Comment
* ------------------------------|------------------------------------------------- |------------|----------------------------------------------------
* Rohit Kumar Verma             |rohit.verma@bausch.com                             |10.Jan.2013 |Resloved the Run Test issue 
* Neha Jain                     |neha.jain@bausch.com                               |18.Mar.2014 |To improve the code coverage for class ctrlCalplanDetails
*/
@isTest 
public class CtrlCallDetails_Test {
    
    
    List<Account> lst_Account = new List<Account>();
   // lst_Account = [select Account__c, ];
    List<AccountTeamMember> AllAccountTeam = [select AccountId, userId from AccountTeamMember where TeamMemberRole like 'IND Sales Rep'];
    
    public static testMethod void callPlanDetailsUnitTest() {
    Test.startTest();
        // for getting the month name       
        Map<Integer,String> MAP_MONTHNO_MONTHNAME = new Map<Integer,String>();
        MAP_MONTHNO_MONTHNAME.put(1,'Jan');
        MAP_MONTHNO_MONTHNAME.put(2,'Feb');
        MAP_MONTHNO_MONTHNAME.put(3,'Mar');
        MAP_MONTHNO_MONTHNAME.put(4,'Apr');
        MAP_MONTHNO_MONTHNAME.put(5,'May');
        MAP_MONTHNO_MONTHNAME.put(6,'Jun');
        MAP_MONTHNO_MONTHNAME.put(7,'Jul');
        MAP_MONTHNO_MONTHNAME.put(8,'Aug');
        MAP_MONTHNO_MONTHNAME.put(9,'Sep');
        MAP_MONTHNO_MONTHNAME.put(10,'Oct');
        MAP_MONTHNO_MONTHNAME.put(11,'Nov');
        MAP_MONTHNO_MONTHNAME.put(12,'Dec');
        
        
        UserRole objRoleAccountOwner = [Select Id From UserRole where name = 'INDSU Account Owner']; 
        UserRole objRoleSalesRep = [Select Id From UserRole where name like : ( 'INDSU Sales Rep'+ '%') limit 1]; 
        
        Profile objProfileIntegrationUser = [SELECT Id FROM profile WHERE name='APACSU System Administrator']; 
      //  Profile objProfileSalesAdmin = [SELECT Id FROM profile WHERE name ='INDSU Sales Administrator']; 
        Profile objProfileSalesRep = [SELECT Id FROM profile WHERE name ='INDSU Sales Rep']; 
      //  Profile objProfilePSRep = [SELECT Id FROM profile WHERE name ='INDSU Service Rep']; 
        
        User objUserIngetration = new User(alias = 'integra', email='integration@testorg.com', emailencodingkey='UTF-8',
                             lastname='Testing', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles',
                             username='integration@testorg.com', profileid = objProfileIntegrationUser.Id, userRoleId=objRoleAccountOwner.Id);
        
        User objUserSalesRep = new User(alias = 'salesrep', email='salesrep@testorg.com', emailencodingkey='UTF-8',
                         lastname='Testing', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles',
                         username='salesrep@testorg.com', profileid = objProfileSalesRep.Id, userRoleId=objRoleSalesRep.Id);

        List<User> list_User = new List<User>();
        list_User.add(objUserIngetration);
        list_User.add(objUserSalesRep);
        insert list_User;
        

        // Getting Id for recordTypes
        
        Id idDirectRecordType = [SELECT Id FROM RecordType 
                                        WHERE Name = 'INDSU Direct' AND SObjectType='Account'].Id;
        Id idRecordTypeCallPlan = [SELECT Id FROM RecordType 
                                        WHERE Name = 'INDSU Call Plan' AND SObjectType='Call_Plan__c'].Id;
        
        Id idRecordTypeCallPlanDetail = [SELECT Id FROM RecordType 
                                        WHERE Name = 'INDSU Call Plan Detail' AND SObjectType='Call_Plan_Detail__c'].Id;
        
        Id idRecordTypePhysicianVisit = [SELECT Id FROM RecordType 
                                        WHERE Name = 'INDSU Sales Planned' AND SObjectType='Physician_Visit__c'].Id;    
                                        
        Id idRecordTypeContact = [SELECT Id FROM RecordType 
                                        WHERE Name = 'INDSU Contact' AND SObjectType='Contact'].Id;


        // for inserting the list of accounts
        Account[] list_accounts = new List<Account>();
        Contact[] list_contacts = new List<Contact>();
        System.runAs(objUserIngetration) {
            Account objTestAccount1 = new Account();
            objTestAccount1.name = 'Test name';
            objTestAccount1.recordTypeId = idDirectRecordType;
            objTestAccount1.Status__c = 'A – Active';
            
            list_accounts.add(objTestAccount1);
            
            Account objTestAccount2 = new Account();
            objTestAccount2.name = 'Test name2';
            objTestAccount2.recordTypeId = idDirectRecordType;
            objTestAccount2.Status__c = 'A – Active';
            
            list_accounts.add(objTestAccount2);
            
            insert list_accounts;
            
            AccountTeamMember[] list_accountTeamMembers = new List<AccountTeamMember>();
            
            AccountTeamMember teamMember1 = new AccountTeamMember();
            teamMember1.UserId = objUserSalesRep.Id;
            teamMember1.AccountId = list_accounts[0].Id;
            list_accountTeamMembers.add(teamMember1);
            
            AccountTeamMember teamMember2 = new AccountTeamMember();
            teamMember2.UserId = objUserSalesRep.Id;
            teamMember2.AccountId = list_accounts[1].Id;
            list_accountTeamMembers.add(teamMember2);
            
            insert list_accountTeamMembers;
            
            Contact objTestContact1 = new Contact();
            objTestContact1.RecordTypeId = idRecordTypeContact;
            objTestContact1.Lastname = 'test Contact1';
            objTestContact1.AccountId = list_accounts[0].Id;
            list_contacts.add(objTestContact1);
            
            Contact objTestContact2 = new Contact();
            objTestContact2.RecordTypeId = idRecordTypeContact;
            objTestContact2.Lastname = 'test Contact2';
            objTestContact2.AccountId = list_accounts[0].Id;
            list_contacts.add(objTestContact2);
            
            Contact objTestContact3 = new Contact();
            objTestContact3.RecordTypeId = idRecordTypeContact;
            objTestContact3.Lastname = 'test Contact3';
            objTestContact3.AccountId = list_accounts[1].Id;
            list_contacts.add(objTestContact3);
            
            Contact objTestContact4 = new Contact();
            objTestContact4.RecordTypeId = idRecordTypeContact;
            objTestContact4.Lastname = 'test Contact4';
            objTestContact4.AccountId = list_accounts[1].Id;
            list_contacts.add(objTestContact4);
            
            insert list_contacts;
        }                   
        System.runAs(objUserSalesRep) {        
            // creating call plan 
            Call_Plan__c objnewCallPlan = new Call_Plan__c();
            Date datReference1 = Date.today();
            Date datReference2 = datReference1.addmonths(1);
            objnewCallPlan.RecordTypeId = idRecordTypeCallPlan;
            objnewCallPlan.Month__c = MAP_MONTHNO_MONTHNAME.get(datReference1.month()) ;
            objnewCallPlan.Status__c = 'Draft';
            objnewCallPlan.Manager_Comments__c = 'Test';
            objnewCallPlan.Executive_Comments__c = 'Test';
            objnewCallPlan.Year__c = String.valueof(datReference1.year());
            objnewCallPlan.OwnerId = objUserSalesRep.Id;

            
            try{
                insert objnewCallPlan;
            } catch(Exception e){}
            
            // for covering the validation trigger
            Call_Plan__c[] list_callPlanForTrigger = new List<Call_Plan__c>();
            
            Call_Plan__c objCallPlan1 = new Call_Plan__c();
            objCallPlan1.RecordTypeId = idRecordTypeCallPlan;
            objCallPlan1.Month__c = MAP_MONTHNO_MONTHNAME.get(datReference1.month()) ;
            objCallPlan1.Status__c = 'Draft';
            objCallPlan1.Manager_Comments__c = 'Test';
            objCallPlan1.Executive_Comments__c = 'Test';
            objCallPlan1.Year__c = String.valueof(datReference1.year());
            list_callPlanForTrigger.add(objCallPlan1);
            
            Call_Plan__c objCallPlan2 = new Call_Plan__c();
            objCallPlan2.RecordTypeId = idRecordTypeCallPlan;
            objCallPlan2.Month__c = MAP_MONTHNO_MONTHNAME.get(datReference1.month() + 1) ;
            objCallPlan2.Status__c = 'Submitted';
            objCallPlan2.Manager_Comments__c = 'Test';
            objCallPlan2.Executive_Comments__c = 'Test';
            objCallPlan2.Year__c = String.valueof(datReference1.year());
            list_callPlanForTrigger.add(objCallPlan2);
            
            Call_Plan__c objCallPlan3 = new Call_Plan__c();
            objCallPlan3.RecordTypeId = idRecordTypeCallPlan;
            objCallPlan3.Month__c = MAP_MONTHNO_MONTHNAME.get(datReference1.month() + 2) ;
            objCallPlan3.Status__c = 'Draft';
            objCallPlan3.Manager_Comments__c = 'Test';
            objCallPlan3.Executive_Comments__c = 'Test';
            objCallPlan3.Year__c = String.valueof(datReference1.year() + 1);
            list_callPlanForTrigger.add(objCallPlan3);
            
            try{
                insert list_callPlanForTrigger;
            } catch(Exception e){}
            
            
            Call_Plan__c objEditCallPlan = new Call_Plan__c();
            
            //if(objnewCallPlan.id!=null)
            //{
                
                Call_Plan_Detail__c[] callPlanDetailList = new List<Call_Plan_Detail__c>();
                
                Call_Plan_Detail__c cpd1 = new Call_Plan_Detail__c();
                cpd1.Call_Objective__c = 'testNeha';
                cpd1.RecordTypeId = idRecordTypeCallPlanDetail;
                cpd1.Call_Plan__c = objnewCallPlan.id;
                cpd1.Date__c = getMonthStartDate(datReference1.month(),datReference1) + 1;
                cpd1.Physician_Name__c = list_contacts[0].Id;
                cpd1.Call__c = true;
                cpd1.Product1__c='Test1';
                cpd1.Product2__c='Test1';
                callPlanDetailList.add(cpd1);
                
                
                Call_Plan_Detail__c cpd2 = new Call_Plan_Detail__c();
                cpd2.Call_Objective__c = 'testAvani';
                cpd2.RecordTypeId = idRecordTypeCallPlanDetail;
                cpd2.Call_Plan__c = objnewCallPlan.id;
                cpd2.Date__c = getMonthStartDate(datReference1.month(),datReference1) + 1;
                cpd2.Physician_Name__c = list_contacts[1].Id;
                cpd2.Call__c = true;
                cpd2.Product1__c='Test1';
                cpd2.Product2__c='Test1';
                callPlanDetailList.add(cpd2);
                
                Call_Plan_Detail__c cpd3 = new Call_Plan_Detail__c();
                cpd3.Call_Objective__c = 'test123';
                cpd3.RecordTypeId = idRecordTypeCallPlanDetail;
                cpd3.Call_Plan__c = objnewCallPlan.id;
                cpd3.Date__c = getMonthStartDate(datReference1.month(),datReference1) + 2;
                cpd3.Physician_Name__c = list_contacts[2].Id;
                cpd3.Call__c = true;
                
                callPlanDetailList.add(cpd3);
                
                Call_Plan_Detail__c cpd4 = new Call_Plan_Detail__c();
                cpd4.Call_Objective__c = '';
                cpd4.RecordTypeId = idRecordTypeCallPlanDetail;
                cpd4.Call_Plan__c = objnewCallPlan.id;
                cpd4.Date__c = getMonthStartDate(datReference1.month(),datReference1) + 3;
                cpd4.Physician_Name__c = list_contacts[3].Id;
                cpd4.Call__c = true;
                
                callPlanDetailList.add(cpd4);
                
                try{
                insert callPlanDetailList;
                system.debug('callPlanDetailList'+callPlanDetailList);
                } catch(Exception e){
                   system.debug('Error save new plan ###' + e);
                }
                
                // creating physician visit records
                //Date datLastMonthStartDate = getMonthStartDate((datReference1.month() - 1),datReference1);
                //Date datLastMonthEndDate = getMonthStartDate((datReference1.month() - 1),datReference1) + 30;
                Date datLastMonthStartDate = System.today().toStartOfMonth();
                Date datLastMonthEndDate = datLastMonthStartDate.addDays(Date.daysInMonth(datLastMonthStartDate.year(), datLastMonthStartDate.month()) - 1);
                System.debug('datLastMonthEndDate ' +datLastMonthStartDate );
                System.debug('datLastMonthStartDate ' +datLastMonthEndDate);
                // creating call plan for last month
                Call_Plan__c  objLastMonthCallPlan = new Call_Plan__c();
                objLastMonthCallPlan.RecordTypeId = idRecordTypeCallPlan;
                objLastMonthCallPlan.Month__c = MAP_MONTHNO_MONTHNAME.get(datReference1.month()+1) ;
                objLastMonthCallPlan.Status__c = 'Draft';
                objLastMonthCallPlan.Manager_Comments__c = 'Test';
                objLastMonthCallPlan.Executive_Comments__c = 'Test';
                objLastMonthCallPlan.Year__c = String.valueof(datReference1.year());
                
                try{
                    insert objLastMonthCallPlan;
                     
               } catch(Exception Err){
                    system.debug('Error save new plan last month ###' + Err);
               }
                Call_Plan_Detail__c[] list_callPlanDetail;
                 
                if(objLastMonthCallPlan.Id!= null)
                {
                    list_callPlanDetail = new List<Call_Plan_Detail__c>();
                
                    Call_Plan_Detail__c objCpd1 = new Call_Plan_Detail__c();
                    objCpd1.RecordTypeId = idRecordTypeCallPlanDetail;
                    objCpd1.Call_Plan__c = objLastMonthCallPlan.id;
                    objCpd1.Date__c = datLastMonthStartDate + 1;
                    objCpd1.Physician_Name__c = list_contacts[0].Id;
                    objCpd1.Call__c = true;
                    objCpd1.Call_Objective__c = 'test';
                    objCpd1.Product1__c='Test1';
                    objCpd1.Product2__c='Test1';
                    list_callPlanDetail.add(objCpd1);
                    
                    
                    Call_Plan_Detail__c objCpd2 = new Call_Plan_Detail__c();
                    objCpd2.Call_Objective__c = 'test';
                    objCpd2.RecordTypeId = idRecordTypeCallPlanDetail;
                    objCpd2.Call_Plan__c = objLastMonthCallPlan.id;
                    objCpd2.Date__c = datLastMonthStartDate + 2;
                    objCpd2.Physician_Name__c = list_contacts[0].Id;
                    objCpd2.Call__c = true;
                    /*objCpd2.Product1__c='Test1';
                    objCpd2.Product2__c='Test1';*/
                    list_callPlanDetail.add(objCpd2);
                    
                    
                    Call_Plan_Detail__c objCpd3 = new Call_Plan_Detail__c();
                    objCpd3.Call_Objective__c = '';
                    objCpd3.RecordTypeId = idRecordTypeCallPlanDetail;
                    objCpd3.Call_Plan__c = objLastMonthCallPlan.id;
                    objCpd3.Date__c = datLastMonthStartDate + 2;
                    objCpd3.Physician_Name__c = list_contacts[0].Id;
                    objCpd3.Call__c = true;                                 
                    list_callPlanDetail.add(objCpd3);
                    
                    insert list_callPlanDetail;
                    system.debug('CallPlanDetailList>>>>>>' + list_callPlanDetail);
                
                }
                
                Id conId;
                ApexPages.currentPage().getParameters().put('conId', 'objTestContact1.Id');
                Id idContact = conId;
                List<Physician_visit__c> list_physicianVist = new List<Physician_visit__c>();

                Physician_visit__c objPhysicianVisit1 = new Physician_visit__c();
                objPhysicianVisit1.RecordTypeId = idRecordTypePhysicianVisit;
                objPhysicianVisit1.Physician__c = callPlanDetailList[0].Physician_name__c;
                objPhysicianVisit1.Activity_Date__c = System.today()-1;
                objPhysicianVisit1.Status__c = 'Open';
                objPhysicianVisit1.Key_Driver_1__c = 'Akreos AO Micro Incision Lens';
                objPhysicianVisit1.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
                objPhysicianVisit1.Outcome_1__c = 'Accept product benefit';
                objPhysicianVisit1.Envista__c = 10;
                objPhysicianVisit1.Session__c = 'AM';
                insert objPhysicianVisit1;
                objPhysicianVisit1.Session__c = 'PM';
                objPhysicianVisit1.Status__c = 'Completed';
                objPhysicianVisit1.Key_Driver_1__c = 'Akreos AO Micro Incision Lens';
                objPhysicianVisit1.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
                objPhysicianVisit1.Outcome_1__c = 'Accept product benefit';
                update objPhysicianVisit1;
               // list_physicianVist.add(objPhysicianVisit1);

                Physician_visit__c objPhysicianVisit2 = new Physician_visit__c();
                objPhysicianVisit2.RecordTypeId = idRecordTypePhysicianVisit;
                objPhysicianVisit2.Physician__c = callPlanDetailList[0].Physician_name__c;
             // START -- Updated by SRIDHAR ALURU to satisfy Validation Rule implemented for INDIA Users
            //  objPhysicianVisit2.Activity_Date__c = System.today()+1;   // Commented by SRIDHAR ALURU
                objPhysicianVisit2.Activity_Date__c = System.today();     // Added by SRIDHAR ALURU
            // END -- Updated by SRIDHAR ALURU to satisfy Validation Rule implemented for INDIA Users    
                objPhysicianVisit2.Status__c = 'Open';
                objPhysicianVisit2.Key_Driver_1__c = 'Akreos AO Micro Incision Lens';
                objPhysicianVisit2.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
                objPhysicianVisit2.Outcome_1__c = 'Accept product benefit';
                objPhysicianVisit2.Envista__c = 10;
                insert objPhysicianVisit2;
                objPhysicianVisit2.Status__c = 'Completed';
                update objPhysicianVisit2;
               // list_physicianVist.add(objPhysicianVisit2); 

              //  insert list_physicianVist;
                system.debug('list_physicianVist>>>>>>' + list_physicianVist);
                // for testing the other pages
                PageReference detailbyContact1 = Page.CtrlCallPlanDetails_detailByContact;
                Test.setCurrentPage(detailbyContact1);
                ApexPages.currentPage().getParameters().put('conId',callPlanDetailList[0].Physician_name__c);
                ApexPages.currentPage().getParameters().put('start',string.valueOf(datLastMonthStartDate));
                ApexPages.currentPage().getParameters().put('end',string.ValueOf(datLastMonthEndDate));
                CtrlCallPlanDetails ctrl0 = new CtrlCallPlanDetails();
                ctrl0.blnIsAllCallObjSelected=false;
                ctrl0.blnisManager=false;
                ctrl0.save();
                ctrl0.addErrorMessage('Error');
                
                
                PageReference detailbyContact = Page.CtrlCallPlanDetails_detailByContact;
                Test.setCurrentPage(detailbyContact);
                ApexPages.currentPage().getParameters().put('conId',callPlanDetailList[1].Physician_name__c);
                
                CtrlCallPlanDetails ctrl6 = new CtrlCallPlanDetails();
                ctrl6.save();
                
                // for testing the other pages
                PageReference detailbyContact2 = new PageReference('/apex/CtrlCallPlanDetails_detailByContact?id=' + objnewCallPlan.id + '&conId=' + callPlanDetailList[0].Id );
                Test.setCurrentPage(detailbyContact2);
                ApexPages.currentPage().getParameters().put('conId',callPlanDetailList[2].Physician_name__c);
                
                CtrlCallPlanDetails ctrl7 = new CtrlCallPlanDetails();
                ctrl7.submit();
                ctrl7.cancel();
                ctrl7.getObjectiveOptions(); 
                
                PageReference errorPage = new PageReference('/apex/CtrlCallPlanErrors_reportLastMonth?conId=' + callPlanDetailList[0].Physician_name__c + '&start=' + datLastMonthStartDate + '&end=' + datLastMonthEndDate);
                Test.setCurrentPage(errorPage);
                ApexPages.currentPage().getParameters().put('conId',callPlanDetailList[3].Physician_name__c);
                
                CtrlCallPlanErrors cpError = new CtrlCallPlanErrors();
                cpError.addErrorMessage('Error');
                
                // for testing the approve functionality
                PageReference approve = new PageReference('/apex/CtrlCallPlan_planDetail?id=' + objnewCallPlan.id  + '&mode=edit');
                Test.setCurrentPage(approve);
                ApexPages.currentPage().getParameters().put('conId',callPlanDetailList[3].Physician_name__c);
 system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ Am from Test class first method');               
               // CtrlCallPlan cntrl5 = new CtrlCallPlan();
                String strUserId = UserInfo.getUserId();
                
               // cntrl5.objUser =[Select Id,Name,userRoleId,email from User where id=:strUserId ];
               // cntrl5.blnisApproveFlag = true;
               // cntrl5.save();
         Test.stopTest();       
                
            //}
        }
    }
    public static testMethod void callPlanDetailsUnitTest1(){
     
     // for getting the month name      
        Map<Integer,String> MAP_MONTHNO_MONTHNAME = new Map<Integer,String>();
        MAP_MONTHNO_MONTHNAME.put(1,'Jan');
        MAP_MONTHNO_MONTHNAME.put(2,'Feb');
        MAP_MONTHNO_MONTHNAME.put(3,'Mar');
        MAP_MONTHNO_MONTHNAME.put(4,'Apr');
        MAP_MONTHNO_MONTHNAME.put(5,'May');
        MAP_MONTHNO_MONTHNAME.put(6,'Jun');
        MAP_MONTHNO_MONTHNAME.put(7,'Jul');
        MAP_MONTHNO_MONTHNAME.put(8,'Aug');
        MAP_MONTHNO_MONTHNAME.put(9,'Sep');
        MAP_MONTHNO_MONTHNAME.put(10,'Oct');
        MAP_MONTHNO_MONTHNAME.put(11,'Nov');
        MAP_MONTHNO_MONTHNAME.put(12,'Dec');
        
        
        UserRole objRoleAccountOwner = [Select Id From UserRole where name = 'KORSU Account Owner']; 
        UserRole objRoleSalesRep = [Select Id From UserRole where name like : ( 'KORSU Sales Rep'+ '%') limit 1]; 
        
        Profile objProfileIntegrationUser = [SELECT Id FROM profile WHERE name='APACSU System Administrator']; 
      //  Profile objProfileSalesAdmin = [SELECT Id FROM profile WHERE name ='APACSU Sales Administrator' limit 1]; 
        Profile objProfileSalesRep = [SELECT Id FROM profile WHERE Name ='APACSU KOR Sales Rep'limit 1]; 
       // Profile objProfilePSRep = [SELECT Id FROM profile WHERE name ='INDSU Service Rep']; 
        
        User objUserIngetration = new User(alias = 'integra', email='integration@testorg.com', emailencodingkey='UTF-8',
                             lastname='Testing', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles',
                             username='integration@testorg.com', profileid = objProfileIntegrationUser.Id, userRoleId=objRoleAccountOwner.Id);
        
        User userManager = [Select Id from User where isactive = true and userrole.name like 'INDSU Area Sales Manager%' limit 1];

        User objUserSalesRep = new User(alias = 'salesrep', email='salesrep@testorg.com', emailencodingkey='UTF-8',
                         lastname='Testing', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles',
                         username='salesrep@testorg.com', profileid = objProfileSalesRep.Id, userRoleId=objRoleSalesRep.Id, ManagerId = userManager.Id);

        List<User> list_User = new List<User>();
        list_User.add(objUserIngetration);
        list_User.add(objUserSalesRep);
        insert list_User;
        

        // Getting Id for recordTypes
        
        Id idDirectRecordType = [SELECT Id FROM RecordType 
                                        WHERE Name ='APACSU Indirect' AND SObjectType='Account' limit 1].Id;
        Id idRecordTypeCallPlan = [SELECT Id FROM RecordType 
                                       WHERE Name ='APACSU Call Plan' AND SObjectType='Call_Plan__c' limit 1].Id;
        
        Id idRecordTypeCallPlanDetail = [SELECT Id FROM RecordType 
                                        WHERE Name ='APACSU Call Plan Detail' AND SObjectType='Call_Plan_Detail__c' limit 1].Id;
        
        Id idRecordTypePhysicianVisit = [SELECT Id FROM RecordType 
                                       WHERE Name IN('APACSU Sales Unplanned','APACSU Sales Planned') AND SObjectType='Physician_Visit__c' limit 1].Id;    
                                        
        Id idRecordTypeContact = [SELECT Id FROM RecordType 
                                       WHERE Name ='APACSU Contact' AND SObjectType='Contact' limit 1].Id;


        // for inserting the list of accounts
        Account[] list_accounts = new List<Account>();
        Contact[] list_contacts = new List<Contact>();
        System.runAs(objUserIngetration) {
            Account objTestAccount1 = new Account();
            objTestAccount1.name = 'Test name';
            objTestAccount1.recordTypeId = idDirectRecordType;
            objTestAccount1.Status__c = 'A – Active';
            
            list_accounts.add(objTestAccount1);
            
            Account objTestAccount2 = new Account();
            objTestAccount2.name = 'Test name2';
            objTestAccount2.recordTypeId = idDirectRecordType;
            objTestAccount2.Status__c = 'A – Active';
            
            list_accounts.add(objTestAccount2);
            
            insert list_accounts;
            
            AccountTeamMember[] list_accountTeamMembers = new List<AccountTeamMember>();
            
            AccountTeamMember teamMember1 = new AccountTeamMember();
            teamMember1.UserId = objUserSalesRep.Id;
            teamMember1.AccountId = list_accounts[0].Id;
            list_accountTeamMembers.add(teamMember1);
            
            AccountTeamMember teamMember2 = new AccountTeamMember();
            teamMember2.UserId = objUserSalesRep.Id;
            teamMember2.AccountId = list_accounts[1].Id;
            list_accountTeamMembers.add(teamMember2);
            
            insert list_accountTeamMembers;
            
            Contact objTestContact1 = new Contact();
            objTestContact1.RecordTypeId = idRecordTypeContact;
            objTestContact1.Lastname = 'test Contact1';
            objTestContact1.AccountId = list_accounts[0].Id;
            list_contacts.add(objTestContact1);
            
            Contact objTestContact2 = new Contact();
            objTestContact2.RecordTypeId = idRecordTypeContact;
            objTestContact2.Lastname = 'test Contact2';
            objTestContact2.AccountId = list_accounts[0].Id;
            list_contacts.add(objTestContact2);
            
            Contact objTestContact3 = new Contact();
            objTestContact3.RecordTypeId = idRecordTypeContact;
            objTestContact3.Lastname = 'test Contact3';
            objTestContact3.AccountId = list_accounts[1].Id;
            list_contacts.add(objTestContact3);
            
            Contact objTestContact4 = new Contact();
            objTestContact4.RecordTypeId = idRecordTypeContact;
            objTestContact4.Lastname = 'test Contact4';
            objTestContact4.AccountId = list_accounts[1].Id;
            list_contacts.add(objTestContact4);
            
            insert list_contacts;
        }
        System.runAs(userManager) { 
            // creating call plan 
            Call_Plan__c objnewCallPlan1 = new Call_Plan__c();
            Date datReference1 = Date.today();
            Date datReference2 = datReference1.addmonths(1);
            objnewCallPlan1.RecordTypeId = idRecordTypeCallPlan;
            objnewCallPlan1.Month__c = MAP_MONTHNO_MONTHNAME.get(datReference1.month()) ;
            objnewCallPlan1.Status__c = 'Draft';
            objnewCallPlan1.Manager_Comments__c = 'Test';
            objnewCallPlan1.Executive_Comments__c = 'Test';
            objnewCallPlan1.Year__c = String.valueof(datReference1.year());
            insert objnewCallPlan1;
            
            Call_Plan_Detail__c cpd11 = new Call_Plan_Detail__c();
            cpd11.Call_Objective__c = 'test';
            cpd11.RecordTypeId = idRecordTypeCallPlanDetail;
            cpd11.Call_Plan__c = objnewCallPlan1.id;
            cpd11.Date__c = getMonthStartDate(datReference1.month(),datReference1) + 1;
            cpd11.Physician_Name__c = list_contacts[0].Id;
            cpd11.Call__c = true;
            cpd11.Product1__c='Test1';
            cpd11.Product2__c='Test1';
            //insert cpd11;
            
            PageReference detailbyContactManager = new PageReference('/apex/CtrlCallPlanDetails_detailByContact?id=' + objnewCallPlan1.id);
            Test.setCurrentPage(detailbyContactManager);
            //ApexPages.currentPage().getParameters().put('conId',null);
            
  system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ Am from Test class second method');          
            CtrlCallPlanDetails ctrl6 = new CtrlCallPlanDetails();
            ctrl6.save();
         }  
        System.runAs(objUserSalesRep) {        
            // creating call plan 
            Call_Plan__c objnewCallPlan = new Call_Plan__c();
            Date datReference1 = Date.today();
            Date datReference2 = datReference1.addmonths(1);
            objnewCallPlan.RecordTypeId = idRecordTypeCallPlan;
            objnewCallPlan.Month__c = MAP_MONTHNO_MONTHNAME.get(datReference1.month()) ;
            objnewCallPlan.Status__c = 'Draft';
            objnewCallPlan.Manager_Comments__c = 'Test';
            objnewCallPlan.Executive_Comments__c = 'Test';
            objnewCallPlan.Year__c = String.valueof(datReference1.year());
            
            
          //  try{
                insert objnewCallPlan;
          //  } catch(Exception e){}
            
            // for covering the validation trigger
            Call_Plan__c[] list_callPlanForTrigger = new List<Call_Plan__c>();
            
            Call_Plan__c objCallPlan1 = new Call_Plan__c();
            objCallPlan1.RecordTypeId = idRecordTypeCallPlan;
            objCallPlan1.Month__c = MAP_MONTHNO_MONTHNAME.get(datReference1.month()) ;
            objCallPlan1.Status__c = 'Draft';
            objCallPlan1.Manager_Comments__c = 'Test';
            objCallPlan1.Executive_Comments__c = 'Test';
            objCallPlan1.Year__c = String.valueof(datReference1.year());
            list_callPlanForTrigger.add(objCallPlan1);
            
            Call_Plan__c objCallPlan2 = new Call_Plan__c();
            objCallPlan2.RecordTypeId = idRecordTypeCallPlan;
            objCallPlan2.Month__c = MAP_MONTHNO_MONTHNAME.get(datReference1.month() + 1) ;
            objCallPlan2.Status__c = 'Submitted';
            objCallPlan2.Manager_Comments__c = 'Test';
            objCallPlan2.Executive_Comments__c = 'Test';
            objCallPlan2.Year__c = String.valueof(datReference1.year());
            list_callPlanForTrigger.add(objCallPlan2);
            
            Call_Plan__c objCallPlan3 = new Call_Plan__c();
            objCallPlan3.RecordTypeId = idRecordTypeCallPlan;
            objCallPlan3.Month__c = MAP_MONTHNO_MONTHNAME.get(datReference1.month() + 2) ;
            objCallPlan3.Status__c = 'Draft';
            objCallPlan3.Manager_Comments__c = 'Test';
            objCallPlan3.Executive_Comments__c = 'Test';
            objCallPlan3.Year__c = String.valueof(datReference1.year() + 1);
            list_callPlanForTrigger.add(objCallPlan3);
            
           // try{
                insert list_callPlanForTrigger;
            //} catch(Exception e){}
            
            
            Call_Plan__c objEditCallPlan = new Call_Plan__c();
            
            if(objnewCallPlan.id!=null)
            {
                
                Call_Plan_Detail__c[] callPlanDetailList = new List<Call_Plan_Detail__c>();
                
                Call_Plan_Detail__c cpd1 = new Call_Plan_Detail__c();
                cpd1.Call_Objective__c = 'test';
                cpd1.RecordTypeId = idRecordTypeCallPlanDetail;
                cpd1.Call_Plan__c = objnewCallPlan.id;
                cpd1.Date__c = getMonthStartDate(datReference1.month(),datReference1) + 1;
                cpd1.Physician_Name__c = list_contacts[0].Id;
                cpd1.Call__c = true;
                //cpd1.Product1__c='Test1';
                     cpd1.Product2__c='Test1';
                callPlanDetailList.add(cpd1);
                
                
                Call_Plan_Detail__c cpd2 = new Call_Plan_Detail__c();
                cpd2.Call_Objective__c = 'test';
                cpd2.RecordTypeId = idRecordTypeCallPlanDetail;
                cpd2.Call_Plan__c = objnewCallPlan.id;
                cpd2.Date__c = getMonthStartDate(datReference1.month(),datReference1) + 2;
                cpd2.Physician_Name__c = list_contacts[1].Id;
                cpd2.Call__c = true;
                cpd2.Product1__c='Test1';
                //     cpd2.Product2__c='Test1';
                callPlanDetailList.add(cpd2);
                
                Call_Plan_Detail__c cpd3 = new Call_Plan_Detail__c();
                cpd3.Call_Objective__c = '';
                cpd3.RecordTypeId = idRecordTypeCallPlanDetail;
                cpd3.Call_Plan__c = objnewCallPlan.id;
                cpd3.Date__c = getMonthStartDate(datReference1.month(),datReference1) + 3;
                cpd3.Physician_Name__c = list_contacts[2].Id;
                cpd3.Call__c = true;
                //cpd3.Product1__c='Test1';
                //cpd3.Product2__c='Test1';
                callPlanDetailList.add(cpd3);
                
                Call_Plan_Detail__c cpd4 = new Call_Plan_Detail__c();
                cpd4.Call_Objective__c = 'arihant';
                cpd4.RecordTypeId = idRecordTypeCallPlanDetail;
                cpd4.Call_Plan__c = objnewCallPlan.id;
                cpd4.Date__c = getMonthStartDate(datReference1.month(),datReference1) + 4;
                cpd4.Physician_Name__c = list_contacts[3].Id;
                cpd4.Call__c = true;
                cpd4.Product1__c='Test1';
                cpd4.Product2__c='Test1';
                callPlanDetailList.add(cpd4);
                
                try{
                insert callPlanDetailList;
                system.debug('callPlanDetailList'+callPlanDetailList);
                } catch(Exception e){
                   system.debug('Error save new plan ###' + e);
               }
                
                                
                // creating physician visit records
                Date datLastMonthStartDate = getMonthStartDate((datReference1.month() - 1),datReference1);
                Date datLastMonthEndDate = getMonthStartDate((datReference1.month() - 1),datReference1) + 30;
                
                
                // creating call plan for last month
                Call_Plan__c  objLastMonthCallPlan = new Call_Plan__c();
                objLastMonthCallPlan.RecordTypeId = idRecordTypeCallPlan;
                objLastMonthCallPlan.Month__c = MAP_MONTHNO_MONTHNAME.get(datReference1.month() - 1) ;
                objLastMonthCallPlan.Status__c = 'Draft';
                objLastMonthCallPlan.Manager_Comments__c = 'Test';
                objLastMonthCallPlan.Executive_Comments__c = 'Test';
                objLastMonthCallPlan.Year__c = String.valueof(datReference1.year());
                
                try{
                   // insert objLastMonthCallPlan;
                     
               } catch(Exception Err){
               system.debug('Error save new plan last month ###' + Err);
               }
                Call_Plan_Detail__c[] list_callPlanDetail;
                 
                if(objLastMonthCallPlan.Id!= null)
                {
                    list_callPlanDetail = new List<Call_Plan_Detail__c>();
                
                    Call_Plan_Detail__c objCpd1 = new Call_Plan_Detail__c();
                    objCpd1.RecordTypeId = idRecordTypeCallPlanDetail;
                    objCpd1.Call_Plan__c = objLastMonthCallPlan.id;
                    objCpd1.Date__c = datLastMonthStartDate + 1;
                    objCpd1.Physician_Name__c = list_contacts[0].Id;
                    objCpd1.Call__c = true;
                    objCpd1.Call_Objective__c = '';
                    objCpd1.Product1__c='Test1';
                     objCpd1.Product2__c='Test1';
                    list_callPlanDetail.add(objCpd1);
                    
                    
                    Call_Plan_Detail__c objCpd2 = new Call_Plan_Detail__c();
                    objCpd2.Call_Objective__c = '';
                    objCpd2.RecordTypeId = idRecordTypeCallPlanDetail;
                    objCpd2.Call_Plan__c = objLastMonthCallPlan.id;
                    objCpd2.Date__c = datLastMonthStartDate + 2;
                    objCpd2.Physician_Name__c = list_contacts[0].Id;
                    objCpd2.Call__c = true;                      
                    list_callPlanDetail.add(objCpd2);
                    
                    Call_Plan_Detail__c objCpd3 = new Call_Plan_Detail__c();
                    objCpd3.Call_Objective__c = '';
                    objCpd3.RecordTypeId = idRecordTypeCallPlanDetail;
                    objCpd3.Call_Plan__c = objLastMonthCallPlan.id;
                    objCpd3.Date__c = datLastMonthStartDate + 2;
                    objCpd3.Physician_Name__c = list_contacts[0].Id;
                    objCpd3.Call__c = true;
                    list_callPlanDetail.add(objCpd3);
                    
                    insert list_callPlanDetail;
                    system.debug('CallPlanDetailList>>>>>>' + list_callPlanDetail);
                
                }
                List<Physician_visit__c> pVisitToBeDeleted=[select Id, Name from Physician_visit__c];
                delete pVisitToBeDeleted;               
                
                List<Physician_visit__c> list_physicianVist = new List<Physician_visit__c>();

                Physician_visit__c objPhysicianVisit1 = new Physician_visit__c();
                objPhysicianVisit1.RecordTypeId = idRecordTypePhysicianVisit;
                objPhysicianVisit1.Physician__c = callPlanDetailList[0].Physician_name__c;
                objPhysicianVisit1.Activity_Date__c = getMonthStartDate(datReference1.month(),datReference1) + 2;
                objPhysicianVisit1.Status__c = 'Open';
                objPhysicianVisit1.Key_Driver_1__c = 'Akreos AO Micro Incision Lens';
                objPhysicianVisit1.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
                objPhysicianVisit1.Outcome_1__c = 'Accept product benefit';
                objPhysicianVisit1.Envista__c = 10;
                list_physicianVist.add(objPhysicianVisit1);

                Physician_visit__c objPhysicianVisit2 = new Physician_visit__c();
                objPhysicianVisit2.RecordTypeId = idRecordTypePhysicianVisit;
                objPhysicianVisit2.Physician__c = callPlanDetailList[0].Physician_name__c;
                objPhysicianVisit2.Activity_Date__c = getMonthStartDate(datReference1.month(),datReference1) + 3;
                objPhysicianVisit2.Status__c = 'Completed';
                objPhysicianVisit2.Key_Driver_1__c = 'Akreos AO Micro Incision Lens';
                objPhysicianVisit2.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
                objPhysicianVisit2.Outcome_1__c = 'Accept product benefit';
                objPhysicianVisit2.Envista__c = 10;
                list_physicianVist.add(objPhysicianVisit2); 

                insert list_physicianVist;
                                
                system.debug('list_physicianVist>>>>>>' + list_physicianVist);
                // for testing the other pages
                PageReference detailbyContact1 = Page.CtrlCallPlanDetails_detailByContact;
                Test.setCurrentPage(detailbyContact1);
                ApexPages.currentPage().getParameters().put('conId',callPlanDetailList[3].Physician_name__c);
                
                CtrlCallPlanDetails ctrl0 = new CtrlCallPlanDetails();
                ctrl0.blnIsAllCallObjSelected=true;
                ctrl0.blnisManager=false;
                ctrl0.save();
                ctrl0.addErrorMessage('Error');
                
                
                PageReference detailbyContact = new PageReference('/apex/CtrlCallPlanDetails_detailByContact?id=' + objnewCallPlan.id);
                Test.setCurrentPage(detailbyContact);
                ApexPages.currentPage().getParameters().put('conId',null);
                
               
                CtrlCallPlanDetails ctrl6 = new CtrlCallPlanDetails();
                ctrl6.save();
                ctrl6.blnIsAllCallObjSelected=true;
                
                // for testing the other pages
                PageReference detailbyContact2 = new PageReference('/apex/CtrlCallPlanDetails_detailByContact?id=' + objnewCallPlan.id + '&conId=' + callPlanDetailList[0].Id );
                Test.setCurrentPage(detailbyContact2);
                ApexPages.currentPage().getParameters().put('conId',callPlanDetailList[0].Physician_name__c);
                ApexPages.currentPage().getParameters().put('start',null);
                ApexPages.currentPage().getParameters().put('end',null);
                
                CtrlCallPlanDetails ctrl7 = new CtrlCallPlanDetails();
                ctrl7.submit();
                ctrl7.cancel();
                ctrl7.getObjectiveOptions(); 
                //ctrl7.blnIsAllCallObjSelected=true;
                
                PageReference errorPage = new PageReference('/apex/CtrlCallPlanErrors_reportLastMonth?conId=' + callPlanDetailList[0].Physician_name__c + '&start=' + datLastMonthStartDate + '&end=' + datLastMonthEndDate);
                Test.setCurrentPage(errorPage);
                ApexPages.currentPage().getParameters().put('conId',callPlanDetailList[1].Physician_name__c);               
                
                System.debug('callPlanDetailList size : '+callPlanDetailList.size());
                System.debug('list_physicianVist size : '+list_physicianVist.size());
                CtrlCallPlanErrors cpError = new CtrlCallPlanErrors();
                cpError.addErrorMessage('Error');
                cpError.list_callPlanDetailRecords=callPlanDetailList.clone();
                cpError.list_physicianVist= list_physicianVist.clone();
               
                
                cpError.idContact =NULL;
                ApexPages.currentPage().getParameters().put('strStartDate',NULL);
               // CtrlCallPlanErrors.strStartDate=NULL;
               // cpError.strEndDate=NULL;
                // for testing the approve functionality
                PageReference approve = new PageReference('/apex/CtrlCallPlan_planDetail?id=' + objnewCallPlan.id  + '&mode=edit');
                Test.setCurrentPage(approve);
                
                CtrlCallPlanErrors cpError01 = new CtrlCallPlanErrors();
                
                ApexPages.currentPage().getParameters().put('start',null);
                ApexPages.currentPage().getParameters().put('end',null);
                CtrlCallPlanErrors cpError02 = new CtrlCallPlanErrors();
               // CtrlCallPlan cntrl5 = new CtrlCallPlan();
               // String strUserId = UserInfo.getUserId();
                
              //  cntrl5.objUser =[Select Id,Name,userRoleId,email from User where id=:strUserId ];
              //  cntrl5.blnisApproveFlag = true;                
               // cntrl5.save();
                
                
            }
        }
     
     
     
     }
    /*************************************************************************
    ** Method for getting strt date of RBD Month
    *************************************************************************/
    
    
    public static Date getMonthStartDate(Integer intMonthNo ,Date datRefDate){
         
        Map<Integer,Date> MAP_YEAR_YEARSTARTDATE = new Map<Integer,Date>();
        MAP_YEAR_YEARSTARTDATE.put(2009, Date.newInstance(2008, 12, 22));
        MAP_YEAR_YEARSTARTDATE.put(2010, Date.newInstance(2009, 12, 21));
        MAP_YEAR_YEARSTARTDATE.put(2011, Date.newInstance(2010, 12, 20));
        MAP_YEAR_YEARSTARTDATE.put(2012, Date.newInstance(2011, 12, 19));
        MAP_YEAR_YEARSTARTDATE.put(System.Today().Year(), Date.newInstance(System.Today().Year() - 1, 12, 19));// By Rohit Kumar Verma
        Integer intQuarterDays = 13 * 7;
        Integer yr = datRefDate.year();
        Date datYearStart = MAP_YEAR_YEARSTARTDATE.get(yr);
        
        if(datYearStart !=null){
            intMonthNo = intMonthNo - 1;
            if (intMonthNo == 0) return datYearStart;
            Integer intQuaters = intMonthNo/3;
            Integer intMonthsThisQuarter = Math.mod(intMonthNo, 3);
            Integer intDays = intQuaters * intQuarterDays;
            if (intMonthsThisQuarter==1) intDays+=28;
            else if (intMonthsThisQuarter==2) intDays+=56;
            return  datYearStart.addDays(intDays);
        } else {
            return null;
        }
    }
    
    
    public static testMethod void callPlanDetailsUnitTestForINDAES() {
        // for getting the month name       
        Map<Integer,String> MAP_MONTHNO_MONTHNAME = new Map<Integer,String>();
        MAP_MONTHNO_MONTHNAME.put(1,'Jan');
        MAP_MONTHNO_MONTHNAME.put(2,'Feb');
        MAP_MONTHNO_MONTHNAME.put(3,'Mar');
        MAP_MONTHNO_MONTHNAME.put(4,'Apr');
        MAP_MONTHNO_MONTHNAME.put(5,'May');
        MAP_MONTHNO_MONTHNAME.put(6,'Jun');
        MAP_MONTHNO_MONTHNAME.put(7,'Jul');
        MAP_MONTHNO_MONTHNAME.put(8,'Aug');
        MAP_MONTHNO_MONTHNAME.put(9,'Sep');
        MAP_MONTHNO_MONTHNAME.put(10,'Oct');
        MAP_MONTHNO_MONTHNAME.put(11,'Nov');
        MAP_MONTHNO_MONTHNAME.put(12,'Dec');
        
        
        UserRole objRoleAccountOwner = [Select Id From UserRole where name = 'INDSU Account Owner']; 
        UserRole objRoleSalesRep = [Select Id From UserRole where name like : ( 'INDAES Sales Rep'+ '%') limit 1]; 
        
        Profile objProfileIntegrationUser = [SELECT Id FROM profile WHERE name='APACSU System Administrator']; 
     
        Profile objProfileSalesRep = [SELECT Id FROM profile WHERE name ='INDAES Sales Rep']; 
  
        User objUserIngetration = new User(alias = 'integra', email='integration@testorg.com', emailencodingkey='UTF-8',
                             lastname='Testing', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles',
                             username='integration@testorg.com', profileid = objProfileIntegrationUser.Id, userRoleId=objRoleAccountOwner.Id);
        
        User objUserSalesRep = new User(alias = 'salesrep', email='salesrep@testorg.com', emailencodingkey='UTF-8',
                         lastname='Testing', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles',
                         username='salesrep@testorg.com', profileid = objProfileSalesRep.Id, userRoleId=objRoleSalesRep.Id);

        List<User> list_User = new List<User>();
        list_User.add(objUserIngetration);
        list_User.add(objUserSalesRep);
        insert list_User;
        

        // Getting Id for recordTypes
        
        Id idDirectRecordType = [SELECT Id FROM RecordType 
                                        WHERE Name = 'INDSU Direct' AND SObjectType='Account'].Id;
        Id idRecordTypeCallPlan = [SELECT Id FROM RecordType 
                                        WHERE Name = 'INDSU Call Plan' AND SObjectType='Call_Plan__c'].Id;
        
        Id idRecordTypeCallPlanDetail = [SELECT Id FROM RecordType 
                                        WHERE Name = 'INDSU Call Plan Detail' AND SObjectType='Call_Plan_Detail__c'].Id;
        
        Id idRecordTypePhysicianVisit = [SELECT Id FROM RecordType 
                                        WHERE Name = 'INDSU Sales Planned' AND SObjectType='Physician_Visit__c'].Id;    
                                        
        Id idRecordTypeContact = [SELECT Id FROM RecordType 
                                        WHERE Name = 'INDSU Contact' AND SObjectType='Contact'].Id;


        // for inserting the list of accounts
        Account[] list_accounts = new List<Account>();
        Contact[] list_contacts = new List<Contact>();
        System.runAs(objUserIngetration) {
            Account objTestAccount1 = new Account();
            objTestAccount1.name = 'Test name';
            objTestAccount1.recordTypeId = idDirectRecordType;
            objTestAccount1.Status__c = 'A – Active';
            
            list_accounts.add(objTestAccount1);
            
            Account objTestAccount2 = new Account();
            objTestAccount2.name = 'Test name2';
            objTestAccount2.recordTypeId = idDirectRecordType;
            objTestAccount2.Status__c = 'A – Active';
            
            list_accounts.add(objTestAccount2);
            
            insert list_accounts;
            
            AccountTeamMember[] list_accountTeamMembers = new List<AccountTeamMember>();
            
            AccountTeamMember teamMember1 = new AccountTeamMember();
            teamMember1.UserId = objUserSalesRep.Id;
            teamMember1.AccountId = list_accounts[0].Id;
            list_accountTeamMembers.add(teamMember1);
            
            AccountTeamMember teamMember2 = new AccountTeamMember();
            teamMember2.UserId = objUserSalesRep.Id;
            teamMember2.AccountId = list_accounts[1].Id;
            list_accountTeamMembers.add(teamMember2);
            
            insert list_accountTeamMembers;
            
            Contact objTestContact1 = new Contact();
            objTestContact1.RecordTypeId = idRecordTypeContact;
            objTestContact1.Lastname = 'test Contact1';
            objTestContact1.AccountId = list_accounts[0].Id;
            list_contacts.add(objTestContact1);
            
            Contact objTestContact2 = new Contact();
            objTestContact2.RecordTypeId = idRecordTypeContact;
            objTestContact2.Lastname = 'test Contact2';
            objTestContact2.AccountId = list_accounts[0].Id;
            list_contacts.add(objTestContact2);
            
            Contact objTestContact3 = new Contact();
            objTestContact3.RecordTypeId = idRecordTypeContact;
            objTestContact3.Lastname = 'test Contact3';
            objTestContact3.AccountId = list_accounts[1].Id;
            list_contacts.add(objTestContact3);
            
            Contact objTestContact4 = new Contact();
            objTestContact4.RecordTypeId = idRecordTypeContact;
            objTestContact4.Lastname = 'test Contact4';
            objTestContact4.AccountId = list_accounts[1].Id;
            list_contacts.add(objTestContact4);
            
            insert list_contacts;
        }                   
        System.runAs(objUserSalesRep) {        
            // creating call plan 
            Call_Plan__c objnewCallPlan = new Call_Plan__c();
            Date datReference1 = Date.today();
            Date datReference2 = datReference1.addmonths(1);
            objnewCallPlan.RecordTypeId = idRecordTypeCallPlan;
            objnewCallPlan.Month__c = MAP_MONTHNO_MONTHNAME.get(datReference1.month()) ;
            objnewCallPlan.Status__c = 'Draft';
            objnewCallPlan.Manager_Comments__c = 'Test';
            objnewCallPlan.Executive_Comments__c = 'Test';
            objnewCallPlan.Year__c = String.valueof(datReference1.year());
            objnewCallPlan.OwnerId = objUserSalesRep.Id;

            
            try{
                insert objnewCallPlan;
            } catch(Exception e){}
            
            // for covering the validation trigger
            Call_Plan__c[] list_callPlanForTrigger = new List<Call_Plan__c>();
            
            Call_Plan__c objCallPlan1 = new Call_Plan__c();
            objCallPlan1.RecordTypeId = idRecordTypeCallPlan;
            objCallPlan1.Month__c = MAP_MONTHNO_MONTHNAME.get(datReference1.month()) ;
            objCallPlan1.Status__c = 'Draft';
            objCallPlan1.Manager_Comments__c = 'Test';
            objCallPlan1.Executive_Comments__c = 'Test';
            objCallPlan1.Year__c = String.valueof(datReference1.year());
            list_callPlanForTrigger.add(objCallPlan1);
            
            Call_Plan__c objCallPlan2 = new Call_Plan__c();
            objCallPlan2.RecordTypeId = idRecordTypeCallPlan;
            objCallPlan2.Month__c = MAP_MONTHNO_MONTHNAME.get(datReference1.month() + 1) ;
            objCallPlan2.Status__c = 'Submitted';
            objCallPlan2.Manager_Comments__c = 'Test';
            objCallPlan2.Executive_Comments__c = 'Test';
            objCallPlan2.Year__c = String.valueof(datReference1.year());
            list_callPlanForTrigger.add(objCallPlan2);
            
            Call_Plan__c objCallPlan3 = new Call_Plan__c();
            objCallPlan3.RecordTypeId = idRecordTypeCallPlan;
            objCallPlan3.Month__c = MAP_MONTHNO_MONTHNAME.get(datReference1.month() + 2) ;
            objCallPlan3.Status__c = 'Draft';
            objCallPlan3.Manager_Comments__c = 'Test';
            objCallPlan3.Executive_Comments__c = 'Test';
            objCallPlan3.Year__c = String.valueof(datReference1.year() + 1);
            list_callPlanForTrigger.add(objCallPlan3);
            
            try{
                insert list_callPlanForTrigger;
            } catch(Exception e){}
            
            
            Call_Plan__c objEditCallPlan = new Call_Plan__c();
            
            //if(objnewCallPlan.id!=null)
            //{
                
                Call_Plan_Detail__c[] callPlanDetailList = new List<Call_Plan_Detail__c>();
                
                Call_Plan_Detail__c cpd1 = new Call_Plan_Detail__c();
                cpd1.Call_Objective__c = 'testNeha';
                cpd1.RecordTypeId = idRecordTypeCallPlanDetail;
                cpd1.Call_Plan__c = objnewCallPlan.id;
                cpd1.Date__c = getMonthStartDate(datReference1.month(),datReference1) + 1;
                cpd1.Physician_Name__c = list_contacts[0].Id;
                cpd1.Call__c = true;
                cpd1.Product1__c='Test1';
                cpd1.Product2__c='Test1';
                callPlanDetailList.add(cpd1);
                
                
                Call_Plan_Detail__c cpd2 = new Call_Plan_Detail__c();
                cpd2.Call_Objective__c = 'testAvani';
                cpd2.RecordTypeId = idRecordTypeCallPlanDetail;
                cpd2.Call_Plan__c = objnewCallPlan.id;
                cpd2.Date__c = getMonthStartDate(datReference1.month(),datReference1) + 1;
                cpd2.Physician_Name__c = list_contacts[1].Id;
                cpd2.Call__c = true;
                cpd2.Product1__c='Test1';
                cpd2.Product2__c='Test1';
                callPlanDetailList.add(cpd2);
                
                Call_Plan_Detail__c cpd3 = new Call_Plan_Detail__c();
                cpd3.Call_Objective__c = 'test123';
                cpd3.RecordTypeId = idRecordTypeCallPlanDetail;
                cpd3.Call_Plan__c = objnewCallPlan.id;
                cpd3.Date__c = getMonthStartDate(datReference1.month(),datReference1) + 2;
                cpd3.Physician_Name__c = list_contacts[2].Id;
                cpd3.Call__c = true;
                
                callPlanDetailList.add(cpd3);
                
                Call_Plan_Detail__c cpd4 = new Call_Plan_Detail__c();
                cpd4.Call_Objective__c = '';
                cpd4.RecordTypeId = idRecordTypeCallPlanDetail;
                cpd4.Call_Plan__c = objnewCallPlan.id;
                cpd4.Date__c = getMonthStartDate(datReference1.month(),datReference1) + 3;
                cpd4.Physician_Name__c = list_contacts[3].Id;
                cpd4.Call__c = true;
                
                callPlanDetailList.add(cpd4);
                
                try{
                insert callPlanDetailList;
                system.debug('callPlanDetailList'+callPlanDetailList);
                } catch(Exception e){
                   system.debug('Error save new plan ###' + e);
                }
                
                // creating physician visit records
                //Date datLastMonthStartDate = getMonthStartDate((datReference1.month() - 1),datReference1);
                //Date datLastMonthEndDate = getMonthStartDate((datReference1.month() - 1),datReference1) + 30;
                Date datLastMonthStartDate = System.today().toStartOfMonth();
                Date datLastMonthEndDate = datLastMonthStartDate.addDays(Date.daysInMonth(datLastMonthStartDate.year(), datLastMonthStartDate.month()) - 1);
                System.debug('datLastMonthEndDate ' +datLastMonthStartDate );
                System.debug('datLastMonthStartDate ' +datLastMonthEndDate);
                // creating call plan for last month
                Call_Plan__c  objLastMonthCallPlan = new Call_Plan__c();
                objLastMonthCallPlan.RecordTypeId = idRecordTypeCallPlan;
                objLastMonthCallPlan.Month__c = MAP_MONTHNO_MONTHNAME.get(datReference1.month()+1) ;
                objLastMonthCallPlan.Status__c = 'Draft';
                objLastMonthCallPlan.Manager_Comments__c = 'Test';
                objLastMonthCallPlan.Executive_Comments__c = 'Test';
                objLastMonthCallPlan.Year__c = String.valueof(datReference1.year());
                
                try{
                    insert objLastMonthCallPlan;
                     
               } catch(Exception Err){
                    system.debug('Error save new plan last month ###' + Err);
               }
                Call_Plan_Detail__c[] list_callPlanDetail;
                 
                if(objLastMonthCallPlan.Id!= null)
                {
                    list_callPlanDetail = new List<Call_Plan_Detail__c>();
                
                    Call_Plan_Detail__c objCpd1 = new Call_Plan_Detail__c();
                    objCpd1.RecordTypeId = idRecordTypeCallPlanDetail;
                    objCpd1.Call_Plan__c = objLastMonthCallPlan.id;
                    objCpd1.Date__c = datLastMonthStartDate + 1;
                    objCpd1.Physician_Name__c = list_contacts[0].Id;
                    objCpd1.Call__c = true;
                    objCpd1.Call_Objective__c = 'test';
                    objCpd1.Product1__c='Test1';
                    objCpd1.Product2__c='Test1';
                    list_callPlanDetail.add(objCpd1);
                    
                    
                    Call_Plan_Detail__c objCpd2 = new Call_Plan_Detail__c();
                    objCpd2.Call_Objective__c = 'test';
                    objCpd2.RecordTypeId = idRecordTypeCallPlanDetail;
                    objCpd2.Call_Plan__c = objLastMonthCallPlan.id;
                    objCpd2.Date__c = datLastMonthStartDate + 2;
                    objCpd2.Physician_Name__c = list_contacts[0].Id;
                    objCpd2.Call__c = true;
                    /*objCpd2.Product1__c='Test1';
                    objCpd2.Product2__c='Test1';*/
                    list_callPlanDetail.add(objCpd2);
                    
                    
                    Call_Plan_Detail__c objCpd3 = new Call_Plan_Detail__c();
                    objCpd3.Call_Objective__c = '';
                    objCpd3.RecordTypeId = idRecordTypeCallPlanDetail;
                    objCpd3.Call_Plan__c = objLastMonthCallPlan.id;
                    objCpd3.Date__c = datLastMonthStartDate + 2;
                    objCpd3.Physician_Name__c = list_contacts[0].Id;
                    objCpd3.Call__c = true;                                 
                    list_callPlanDetail.add(objCpd3);
                    
                    insert list_callPlanDetail;
                    system.debug('CallPlanDetailList>>>>>>' + list_callPlanDetail);
                
                }
                
                Id conId;
                ApexPages.currentPage().getParameters().put('conId', 'objTestContact1.Id');
                Id idContact = conId;
                List<Physician_visit__c> list_physicianVist = new List<Physician_visit__c>();

                Physician_visit__c objPhysicianVisit1 = new Physician_visit__c();
                objPhysicianVisit1.RecordTypeId = idRecordTypePhysicianVisit;
                objPhysicianVisit1.Physician__c = callPlanDetailList[0].Physician_name__c;
                objPhysicianVisit1.Activity_Date__c = System.today()-1;
                objPhysicianVisit1.Status__c = 'Open';
                objPhysicianVisit1.Key_Driver_1__c = 'Akreos AO Micro Incision Lens';
                objPhysicianVisit1.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
                objPhysicianVisit1.Outcome_1__c = 'Accept product benefit';
                objPhysicianVisit1.Envista__c = 10;
                objPhysicianVisit1.Session__c = 'AM';
                insert objPhysicianVisit1;
                objPhysicianVisit1.Session__c = 'PM';
                objPhysicianVisit1.Status__c = 'Completed';
                objPhysicianVisit1.Key_Driver_1__c = 'Akreos AO Micro Incision Lens';
                objPhysicianVisit1.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
                objPhysicianVisit1.Outcome_1__c = 'Accept product benefit';
                update objPhysicianVisit1;
               // list_physicianVist.add(objPhysicianVisit1);

                Physician_visit__c objPhysicianVisit2 = new Physician_visit__c();
                objPhysicianVisit2.RecordTypeId = idRecordTypePhysicianVisit;
                objPhysicianVisit2.Physician__c = callPlanDetailList[0].Physician_name__c;
               // START -- Updated by SRIDHAR ALURU to satisfy Validation Rule implemented for INDIA Users
               // objPhysicianVisit2.Activity_Date__c = System.today()+1; // Commented By SRIDHAR ALURU
                objPhysicianVisit2.Activity_Date__c = System.today(); // Added By SRIDHAR ALURU
               // END -- Updated by SRIDHAR ALURU to satisfy Validation Rule implemented for INDIA Users
                objPhysicianVisit2.Status__c = 'Open';
                objPhysicianVisit2.Key_Driver_1__c = 'Akreos AO Micro Incision Lens';
                objPhysicianVisit2.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
                objPhysicianVisit2.Outcome_1__c = 'Accept product benefit';
                objPhysicianVisit2.Envista__c = 10;
                insert objPhysicianVisit2;
                objPhysicianVisit2.Status__c = 'Completed';
                update objPhysicianVisit2;
               // list_physicianVist.add(objPhysicianVisit2); 

              //  insert list_physicianVist;
                system.debug('list_physicianVist>>>>>>' + list_physicianVist);
                // for testing the other pages
                PageReference detailbyContact1 = Page.CtrlCallPlanDetails_detailByContact;
                Test.setCurrentPage(detailbyContact1);
                ApexPages.currentPage().getParameters().put('conId',callPlanDetailList[0].Physician_name__c);
                ApexPages.currentPage().getParameters().put('start',string.valueOf(datLastMonthStartDate));
                ApexPages.currentPage().getParameters().put('end',string.ValueOf(datLastMonthEndDate));
                CtrlCallPlanDetails ctrl0 = new CtrlCallPlanDetails();
                ctrl0.blnIsAllCallObjSelected=false;
                ctrl0.blnisManager=false;
                ctrl0.save();
                ctrl0.addErrorMessage('Error');
                
                
                PageReference detailbyContact = Page.CtrlCallPlanDetails_detailByContact;
                Test.setCurrentPage(detailbyContact);
                ApexPages.currentPage().getParameters().put('conId',callPlanDetailList[1].Physician_name__c);
                
                CtrlCallPlanDetails ctrl6 = new CtrlCallPlanDetails();
                ctrl6.save();
                
                // for testing the other pages
                PageReference detailbyContact2 = new PageReference('/apex/CtrlCallPlanDetails_detailByContact?id=' + objnewCallPlan.id + '&conId=' + callPlanDetailList[0].Id );
                Test.setCurrentPage(detailbyContact2);
                ApexPages.currentPage().getParameters().put('conId',callPlanDetailList[2].Physician_name__c);
                
                CtrlCallPlanDetails ctrl7 = new CtrlCallPlanDetails();
                ctrl7.submit();
                ctrl7.cancel();
                ctrl7.getObjectiveOptions(); 
                
                PageReference errorPage = new PageReference('/apex/CtrlCallPlanErrors_reportLastMonth?conId=' + callPlanDetailList[0].Physician_name__c + '&start=' + datLastMonthStartDate + '&end=' + datLastMonthEndDate);
                Test.setCurrentPage(errorPage);
                ApexPages.currentPage().getParameters().put('conId',callPlanDetailList[3].Physician_name__c);
                
                CtrlCallPlanErrors cpError = new CtrlCallPlanErrors();
                cpError.addErrorMessage('Error');
                
                // for testing the approve functionality
                PageReference approve = new PageReference('/apex/CtrlCallPlan_planDetail?id=' + objnewCallPlan.id  + '&mode=edit');
                Test.setCurrentPage(approve);
                ApexPages.currentPage().getParameters().put('conId',callPlanDetailList[3].Physician_name__c);
 system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ Am from Test class third method');                
               // CtrlCallPlan cntrl5 = new CtrlCallPlan();
                String strUserId = UserInfo.getUserId();
                
               // cntrl5.objUser =[Select Id,Name,userRoleId,email from User where id=:strUserId ];
               // cntrl5.blnisApproveFlag = true;
                //cntrl5.save();
                
                
            //}
        }
    }
}