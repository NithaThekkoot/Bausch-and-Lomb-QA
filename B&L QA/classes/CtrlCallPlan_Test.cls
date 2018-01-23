/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * 
 *
 * This class covers the apex class :CtrlCallPlan.cls and the trigger:callPlan_BIU_validateCallPlan
 *
 *
 *      Author           |Author-Email                          |Date       |Comment
 *      -----------------|--------------------------------------|-----------|--------------------------------------------------
 *      Yash Agarwal     |yash.agarwal@listertechnologies.com   |20.05.2010 |First draft
 *      Santosh Kumar S     | santosh.sriram@listertechnologies.com   | 10.03.2011  | Changing INDSU to APACSU System Admin
  *     Rohit Kumar Verma |rohit.verma@bausch.com                |10.Jan.2013 |Resloved the Run Test issue 
 */

@isTest
public class CtrlCallPlan_Test {

    public static testMethod void callPlanUnitTest() {
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
        UserRole objRoleSalesRep = [Select Id From UserRole where name like : ('INDSU Sales Rep'+ '%') limit 1]; 
        UserRole objRoleManager = [Select Id From UserRole where name like : ('INDSU Area Sales Manager'+ '%') limit 1]; 
        
        Profile objProfileIntegrationUser = [SELECT Id FROM profile WHERE name='APACSU System Administrator']; 
        Profile objProfileSalesRep = [SELECT Id FROM profile WHERE name='INDSU Sales Rep']; 
        Profile objProfileManager = [SELECT Id FROM profile WHERE name='BL: System Admin SSO']; 
        
        User objUserIngetration = new User(alias = 'integra', email='integration@testorg.com', emailencodingkey='UTF-8',
                             lastname='Testing', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles',
                             username='integration@testorg.com', profileid = objProfileIntegrationUser.Id, userRoleId=objRoleAccountOwner.Id);
        
        User objUserSalesRep = new User(alias = 'salesrep', email='salesrep@testorg.com', emailencodingkey='UTF-8',
                         lastname='Testing', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles',
                         username='salesrep@testorg.com', profileid = objProfileSalesRep.Id, userRoleId=objRoleSalesRep.Id);
                         
        User objUserSalesManager = new User(alias = 'salesrep', email='salesmngr@testorg.com', emailencodingkey='UTF-8',
                         lastname='Testing', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles',
                         username='salesmanager@testorg.com', profileid = objProfileManager.Id); //, userRoleId=objRoleManager.Id

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
            Call_Plan__c objnewCallPlan = new Call_Plan__c();
        System.runAs(objUserSalesRep) {        
            // creating call plan 
           // Call_Plan__c objnewCallPlan = new Call_Plan__c();
            Date datReference1 = Date.today();
            Date datReference2 = datReference1.addmonths(1);
            objnewCallPlan.RecordTypeId = idRecordTypeCallPlan;
            objnewCallPlan.Month__c = MAP_MONTHNO_MONTHNAME.get(datReference1.month()) ;
            objnewCallPlan.Status__c = 'Draft';
            objnewCallPlan.Manager_Comments__c = 'Test';
            objnewCallPlan.Executive_Comments__c = 'Test';
            objnewCallPlan.Year__c = String.valueof(datReference1.year());
            
            
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
            
            Call_Plan__c objCallPlan2 = new Call_Plan__c();
            objCallPlan2.RecordTypeId = idRecordTypeCallPlan;
            objCallPlan2.Month__c = MAP_MONTHNO_MONTHNAME.get(datReference1.month() + 1) ;
            objCallPlan2.Status__c = 'Draft';
            objCallPlan2.Manager_Comments__c = 'Test';
            objCallPlan2.Executive_Comments__c = 'Test';
            objCallPlan2.Year__c = String.valueof(datReference1.year());
            
            Call_Plan__c objCallPlan3 = new Call_Plan__c();
            objCallPlan3.RecordTypeId = idRecordTypeCallPlan;
            objCallPlan3.Month__c = MAP_MONTHNO_MONTHNAME.get(datReference1.month()) ;
            objCallPlan3.Status__c = 'Draft';
            objCallPlan3.Manager_Comments__c = 'Test';
            objCallPlan3.Executive_Comments__c = 'Test';
            objCallPlan3.Year__c = String.valueof(datReference1.year() + 1);
            
            try{
                insert list_callPlanForTrigger;
            } catch(Exception e){}
            
            
            Call_Plan__c objEditCallPlan = new Call_Plan__c();
            
            if(objnewCallPlan.id!=null)
            {
                
                // for testing the new functionality
                PageReference pr = new PageReference('/apex/CtrlCallPlan_planDetail?id=' + objnewCallPlan.id  + '&mode=new');                
                Test.setCurrentPage(pr);
                
                //CtrlCallPlan cntrl1 = new CtrlCallPlan();
                //cntrl1.getMonthsSelected();
                
                // creating call plan details for the different classification
                Call_Plan_Detail__c[] callPlanDetailList = new List<Call_Plan_Detail__c>();
                
                Call_Plan_Detail__c cpd1 = new Call_Plan_Detail__c();
                cpd1.RecordTypeId = idRecordTypeCallPlanDetail;
                cpd1.Call_Plan__c = objnewCallPlan.id;
                cpd1.Date__c = getMonthStartDate(datReference1.month(),datReference1) + 1;
                cpd1.Physician_Name__c = list_contacts[0].Id;
                cpd1.Call__c = true;
                callPlanDetailList.add(cpd1);
                
                
                Call_Plan_Detail__c cpd2 = new Call_Plan_Detail__c();
                cpd2.RecordTypeId = idRecordTypeCallPlanDetail;
                cpd2.Call_Plan__c = objnewCallPlan.id;
                cpd2.Date__c = getMonthStartDate(datReference1.month(),datReference1) + 1;
                cpd2.Physician_Name__c = list_contacts[1].Id;
                cpd2.Call__c = true;
                callPlanDetailList.add(cpd2);
                
                Call_Plan_Detail__c cpd3 = new Call_Plan_Detail__c();
                cpd3.RecordTypeId = idRecordTypeCallPlanDetail;
                cpd3.Call_Plan__c = objnewCallPlan.id;
                cpd3.Date__c = getMonthStartDate(datReference1.month(),datReference1) + 2;
                cpd3.Physician_Name__c = list_contacts[2].Id;
                cpd3.Call__c = true;
                callPlanDetailList.add(cpd3);
                
                Call_Plan_Detail__c cpd4 = new Call_Plan_Detail__c();
                cpd4.RecordTypeId = idRecordTypeCallPlanDetail;
                cpd4.Call_Plan__c = objnewCallPlan.id;                
                cpd4.Date__c = getMonthStartDate(datReference1.month(),datReference1) + 3;
                cpd4.Physician_Name__c = list_contacts[3].Id;
                cpd4.Call__c = true;
                callPlanDetailList.add(cpd4);                
                
                
                try{
                insert callPlanDetailList;
                system.debug('CallList>>>' + callPlanDetailList);
                //cntrl1.blnisSaveFlag = true;
                //cntrl1.getYearStartDate(datReference1);
                //cntrl1.save();
                
                } catch(Exception e){
                    system.debug('Error save new plan ###' + e);
                }
                
                /*
                // creating physician visit records
                List<Physician_visit__c> list_physicianVist = new List<Physician_visit__c>();

                Physician_visit__c objPhysicianVisit1 = new Physician_visit__c();
                objPhysicianVisit1.RecordTypeId = idRecordTypePhysicianVisit;
                objPhysicianVisit1.Physician__c = callPlanDetailList[0].Physician_name__c;
                //objPhysicianVisit1.Activity_Date__c = getMonthStartDate((datReference1.month() - 1),datReference1) + 1;
                objPhysicianVisit1.Activity_Date__c = Date.today().addDays(3);
                objPhysicianVisit1.Status__c = 'Open';
                list_physicianVist.add(objPhysicianVisit1);

                
                Physician_visit__c objPhysicianVisit2 = new Physician_visit__c();
                objPhysicianVisit2.RecordTypeId = idRecordTypePhysicianVisit;
                objPhysicianVisit2.Physician__c = callPlanDetailList[1].Physician_name__c;
                objPhysicianVisit2.Activity_Date__c = getMonthStartDate((datReference1.month() - 1),datReference1) + 1;
                objPhysicianVisit2.Status__c = 'Open';
                list_physicianVist.add(objPhysicianVisit2); 
                 
                insert list_physicianVist;
                 */
                 
                // for testing the edit functionality
                PageReference page = new PageReference('/apex/CtrlCallPlan_planDetail?id=' + objnewCallPlan.id  + '&mode=edit');
                Test.setCurrentPage(page);
                Test.startTest();
                //CtrlCallPlan cntrl2 = new CtrlCallPlan();
                //cntrl2.getMonthsSelected();
                //cntrl2.blnisSaveFlag = true;
              //  cntrl2.blnisApproveFlag = true;
                //cntrl2.save();
                
                // for testing the clone functionality
                PageReference Clonepage = new PageReference('/apex/CtrlCallPlan_planDetail?id=' + objnewCallPlan.id  + '&mode=edit&clone=1');
              //  PageReference Clonepage = new PageReference('/apex/CtrlCallPlan_planDetail?id=' + objnewCallPlan.id  + 'e?&clone=1');
                Test.setCurrentPage(Clonepage);
                //CtrlCallPlan cntrl3 = new CtrlCallPlan();
                //cntrl3.getMonthsSelected();
                
                
                //cntrl3.blnisSaveFlag = true;
                //cntrl3.save();
                
                try{
                
                //cntrl3.strSelectedMonth = MAP_MONTHNO_MONTHNAME.get(datReference2.month()) ;
                //cntrl3.doCloneAfterChoosingMonth();
                
                } catch(exception e){
                
                }
            
                // for testing the reject functionality
                PageReference reject = new PageReference('/apex/CtrlCallPlan_planDetail?id=' + objnewCallPlan.id  + '&mode=edit');
                Test.setCurrentPage(reject);
                
                //CtrlCallPlan cntrl4 = new CtrlCallPlan();
                String strUserId = UserInfo.getUserId();
                User objUserTest = [Select Id,Name,userRoleId,email from User where id=:strUserId ] ;
                //cntrl4.objUser = objUserTest;
                //cntrl4.blnisRejectFlag = true;
                //cntrl4.save();

                // for testing the approve functionality
                PageReference approve = new PageReference('/apex/CtrlCallPlan_planDetail?id=' + objnewCallPlan.id  + '&mode=edit');
                Test.setCurrentPage(approve);
                
                //CtrlCallPlan cntrl5 = new CtrlCallPlan();
                //String strUserId = UserInfo.getUserId();
                //cntrl5.objUser =objUserTest;
                //cntrl5.blnisApproveFlag = true;
                //cntrl5.save();
                
                Test.stopTest();
                
                
            }
        }
        System.runAs(objUserSalesManager) {    
        
                PageReference page = new PageReference('/apex/CtrlCallPlan_planDetail?id=' + objnewCallPlan.id  + '&mode=edit');
                Test.setCurrentPage(page);             
                //CtrlCallPlan cntr45 = new CtrlCallPlan();
                //cntr45.getMonthsSelected();
                //cntr45.blnisSaveFlag = true;
                //cntr45.blnisApproveFlag = true;
                //cntr45.save();
                //cntr45.blnisClone = true;             
                
           
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
    
    static testmethod void test3()
    {
        Account objTestAccount1 = new Account();
        objTestAccount1.name = 'Test name';
        //objTestAccount1.recordTypeId = idDirectRecordType;
        objTestAccount1.Status__c = 'A – Active';
        insert objTestAccount1;
        
        Contact objTestContact1 = new Contact();
        //objTestContact1.RecordTypeId = idRecordTypeContact;
        objTestContact1.Lastname = 'test Contact1';
        objTestContact1.AccountId = objTestAccount1.Id;
        insert objTestContact1;
        
        Physician_visit__c objPhysicianVisit1 = new Physician_visit__c();
        objPhysicianVisit1.RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Physician_visit__c' AND Name = 'INDSU Sales Planned'].Id;
        objPhysicianVisit1.Physician__c = objTestContact1.Id;
        //objPhysicianVisit1.Activity_Date__c = getMonthStartDate((datReference1.month() - 1),datReference1) + 1;
        
       // START -- Updated by SRIDHAR ALURU to satisfy Validation Rule implemented for INDIA Users
       // objPhysicianVisit1.Activity_Date__c = Date.today().addDays(3); // Commented By SRIDHAR ALURU
        objPhysicianVisit1.Activity_Date__c = Date.today();  // Added by SRIDHAR ALURU
        // END -- Updated by SRIDHAR ALURU to satisfy Validation Rule implemented for INDIA Users
        objPhysicianVisit1.Status__c = 'Open';
        objPhysicianVisit1.Key_Driver_1__c = 'Akreos AO Micro Incision Lens';
        objPhysicianVisit1.Key_Message_1_CHN__c = 'Exceptional Vision Quality';
        objPhysicianVisit1.Outcome_1__c = 'Accept product benefit';
        objPhysicianVisit1.Envista__c = 10;
        insert objPhysicianVisit1;
    }
}