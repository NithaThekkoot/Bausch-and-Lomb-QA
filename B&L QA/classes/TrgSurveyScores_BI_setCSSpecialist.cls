/**
* 
*   Test class for trigger "surveyScores_BI_setCSSpecialist"
* 
*    Author         |Author-Email                   |Date       |Comment
*    ---------------|-------------------------------|-----------|--------------------------------------------------
*    S Cardinali    |samantha.cardinali@bausch.com  |13.07.2011 |First draft
*
*/
@isTest
private class TrgSurveyScores_BI_setCSSpecialist {
  static testMethod void testSurveyScores_BI_setCSSpecialist() {
  
  ID rtShipToAcct = ClsUtility.getRecordTypeId('Account','Ship To Account');
  RecordType rtEMEASurvey = [SELECT Id FROM RecordType WHERE SObjectType = 'Survey_score__c' AND Name = 'EMEA Survey Record'];
  Profile upCSSRep = [SELECT Id FROM profile WHERE name ='EMEACSS: Customer Service Rep' Limit 1];
  //Create account
  Account oAccount = new Account(Name = 'SCTestAcct12345', recordtypeid = rtShipToAcct, SETID__c = 'UNKGD', Ship_to_id__c='13245678', Legacy_system_id__c = 'UNKGD13245678');
  insert oAccount;
  //Create user
  User uCS = new User(alias = 'allbus', 
                             email='allbus@testorg.com', 
                             emailencodingkey='UTF-8',
                             lastname='Testing',
                             languagelocalekey='en_US', 
                             localesidkey='en_US', 
                             profileid = upCSSRep.Id, 
                             timezonesidkey='America/Los_Angeles',
                             username='allbus@testorg.com');  
   insert uCS;
   //Add CS user to account team
   AccountTeamMember oActMbr = new AccountTeamMember(UserId=uCS.Id,AccountId=oAccount.Id,TeamMemberRole='CS Specialist');
   insert oActMbr;
   AccountShare oActShr = new AccountShare(UserOrGroupId=uCS.Id,AccountId=oAccount.Id,AccountAccessLevel='EDIT',CaseAccessLevel='Edit',OpportunityAccessLevel='None');
   insert oActShr;
   //Run as
   System.runAs(uCS) {
       //Insert Survey Score  
       Survey_score__c newSS = new Survey_score__c(Account_Name__c=oAccount.Id,
                                                   Survey_date__c=System.Today(),
                                                   Survey_question__c='Q1-CS Performance',
                                                   Survey_reason__c='Test text',
                                                   Survey_score__c='5',
                                                   Survey_source__c='Manual',
                                                   RecordType = rtEMEASurvey);
       insert newSS; 
   }
  
  }
 }