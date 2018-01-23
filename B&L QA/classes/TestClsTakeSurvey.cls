/*
 * 
 *   The following is the Test class for ClsTakeSurvey.
 *
 *   Author             |Author-Email                        |   Date      |   Comment
 *   -------------------|------------------------------------|------------- |--------------------------------------------------
 *   Sanjib Mahanta       |Sanjib.Mahanta@bausch.com          | 01/07/2011  |  Final Version
*/
 
@isTest
private class TestClsTakeSurvey {

    static testMethod void myUnitTest() {
        
          Id idDirectRecordType = [SELECT Id FROM RecordType 
                                        WHERE Name = 'APACSU Direct' AND SObjectType='Account'].Id;
        RecordType LeadRecordType=[select id from RecordType where name='INDSU CS' limit 1];
        
         UserRole objRole = [Select Id From UserRole where name like '%INDSU%' limit 1 ];
        UserRole objSalesRepRole = [Select Id From UserRole where name like '%INDSU Sales Rep%' limit 1 ];  
        Profile objProfile = [SELECT Id FROM profile WHERE name='BL: System Admin SSO']; 
            
            //Create User
      User oUser = new User(FirstName = 'SCTest', LastName = 'User12345', UserRoleId = objRole.Id, ProfileId = objProfile.Id, alias = 'user99', username='SCTest@User12345.com' ,
                             email='SCTest@User12345.com',Country='sCountry', emailencodingkey='UTF-8', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles');
       System.runAs(oUser){
         Account acc = new Account();
         acc.Name = 'Test';
         acc.RecordTypeId = idDirectRecordType ;
         insert acc;
         
         Lead l1 = new Lead();
         l1.LastName='Test';
         l1.status = 'Open';
         l1.City= 'testcity';
         l1.RecordTypeId = LeadRecordType.id;
         l1.Existing_Account__c = acc.Id;
         l1.Company = 'Test Company';
         insert l1;
         
         APACSU_Survey__c s = new APACSU_Survey__c();
         s.Survey_Date_taken__c=System.today();         
         s.Link_to_the_Survery__c = 'www.test.com';          
         insert s;
                  
         List<Lead> listLead = new List <Lead>();
         listLead = [select LastName,Existing_Account__c ,status from Lead where Id =:l1.Id];  
         
         listLead[0].Status = 'Survey Taken';
         update listLead;      
         
         
         string str = listLead[0].LastName;
         string str1 = listLead[0].Existing_Account__c;   
         
         ApexPages.currentPage().getParameters().put('id', l1.id);
         PageReference pageRef1 = new PageReference(Label.Test_Survey+'?AccountId='+str1+'&ContactName='+str+'&RecordTypeID=012T00000004mG5');       
         Test.setCurrentPage(pageRef1);
         PageReference pageRef = Page.TakeSurvey;
         Test.setCurrentPage(pageRef);
         pageRef.getParameters().put('id',l1.id);
         ClsTakeSurvey controller = new ClsTakeSurvey(new ApexPages.standardController(l1));  
         controller.insupLeadSurvey();
         }
           }
}