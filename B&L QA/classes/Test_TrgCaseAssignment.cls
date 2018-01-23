/*
 * 
 *   The following is the Test class for TrgCaseAssignment.
 *
 *   Author             |Author-Email                        |   Date       |   Comment
 *   -------------------|------------------------------------|------------- |--------------------------------------------------
 *   Sanjib Mahanta     |Sanjib.Mahanta@bausch.com           | 09/01/2012   |  Final Version
 *  
 */

 
@isTest(seeAllData=true)

private class Test_TrgCaseAssignment{

static testMethod void testUpdateCase(){
        RecordType caseRecordType=[select id from RecordType where name='INDSU CS Case'];        
               
        
          Id idDirectRecordType = [SELECT Id FROM RecordType 
                                        WHERE Name = 'APACSU Indirect' AND SObjectType='Account'].Id; 
        System.debug(idDirectRecordType );       
        UserRole objRole = [Select Id From UserRole where name like '%INDSU%' limit 1 ];
        UserRole objSalesRepRole = [Select Id From UserRole where name like '%INDSU Sales Rep%' limit 1 ];  
        Profile objProfile = [SELECT Id FROM profile WHERE name='BL: System Admin SSO']; 
            
            //Create User
      User oUser = new User(FirstName = 'SCTest', LastName = 'User12345', UserRoleId = objRole.Id, ProfileId = objProfile.Id, alias = 'user99', username='SCTest@User12345.com' ,
                             email='SCTest@User12345.com',Country='sCountry', emailencodingkey='UTF-8', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles');
      
      User oUser1 = new User(FirstName = 'SUTest', LastName = 'User', UserRoleId = objSalesRepRole.Id, ProfileId = objProfile.Id, alias = 'user99', username='SUTest@User12345.com' ,
                             email='SCTest@User12345.com',Country='sCountry', emailencodingkey='UTF-8', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles');
         insert oUser1;         
        System.runAs(oUser){               
        Account acc = new Account();
        acc.Name = 'Test';
         acc.RecordTypeId = idDirectRecordType ;
         acc.OwnerId = oUser.Id;
         insert acc;
         
         Account acc1 = new Account();
         acc1.Name ='Test1';
         acc1.RecordTypeId = idDirectRecordType ;
         acc1.OwnerId = oUser.Id;
         insert acc1;
         
                 
         AccountTeamMember atm = new AccountTeamMember();
         atm.AccountId = acc.Id;
         atm.UserId = oUser.Id;
         atm.TeamMemberRole= 'Sales Rep';
         insert atm;
         
         AccountTeamMember atm1 = new AccountTeamMember();
         atm1.AccountId = acc.Id;
         atm1.UserId = oUser1.Id;
         atm1.TeamMemberRole = 'Sales Rep';
         insert atm1;
        
        AccountTeamMember atm2 = new AccountTeamMember();
         atm2.AccountId = acc.Id;
         atm2.UserId = oUser.Id;
         atm2.TeamMemberRole = 'Area Manager';
         insert atm2;
        
        List<Account> lacc  = [select Id,OwnerId from Account where Id =: acc.Id];      
        Contact con=new Contact();
        con.LastName='test123';
        con.Phone = '7878154110';
        con.OwnerId = lacc[0].OwnerId;
        con.AccountId = lacc[0].Id;
        insert con;
               
        Case c = new Case();
        c.RecordTypeId = caseRecordType.Id;
        c.Category__c = 'Medical Complaint';            
        c.Status = 'Open';
        c.AccountId= acc.Id;
        c.ContactId = con.Id;
        insert c;
        
        Case c2 = new Case();
        c2.RecordTypeId = caseRecordType.Id;
        c2.Category__c = 'Commercial Complaint';            
        c2.Status = 'Open';
        c2.AccountId= acc.Id;
        c2.ContactId = con.Id;        
        insert c2;
                
        Case c3 = new Case();
        c3.RecordTypeId = caseRecordType.Id;
        c3.Category__c = 'Merchandising Complaint';            
        c3.Status = 'Open';
        c3.AccountId= acc.Id;
        c3.ContactId = con.Id;
        insert c3;
          
        Case c4 = new Case();
        c4.RecordTypeId = caseRecordType.Id;
        c4.Category__c = 'Merchandising Complaint';            
        c4.Status = 'Open';
        c4.AccountId= acc.Id;
        c4.ContactId = con.Id;
        c4.Corrective_Action__c = 'Account Contact';
        insert c4; 
           
        Case c5 = new Case();
        c5.RecordTypeId = caseRecordType.Id;
        c5.Category__c = 'Commercial Complaint';
        c5.Status = 'Open';
        c5.AccountId= acc.Id;
        c5.ContactId = con.Id;
        c5.Corrective_Action__c = 'Account Contact';
        insert c5;
        
        Case c6 = new Case();
        c6.RecordTypeId = caseRecordType.Id;
        c6.Category__c = 'Medical Complaint';            
        c6.Status = 'Open';
        c6.AccountId= acc1.Id;
        c6.ContactId = con.Id;
        insert c6;

                           
        List<AccountTeamMember> us = [select Id,UserId,TeamMemberRole from AccountTeamMember where AccountTeamMember.AccountId =:acc.Id];
        List<User> us1 = [select Id,Name,User_Role__c from User where Id=:us[0].Id]; 
                                                         
        List<Case> c1 = [select OwnerId,Id,Category__c,Corrective_Action__c,Status from Case where Id =:c.Id];
        
        if(c1[0].Category__c == 'Merchendising Complaint'){        
        c1[0].Status = 'Closed';        
        c1[0].OwnerId = us1[0].Id; 
        
        update c1; 
        if(c1[0].Category__c =='MedicalComplaint'){        
        c1[0].status = 'Closed';        
        c1[0].OwnerId = us1[0].Id;   
        Test.startTest();     
        update c1;                        
        Test.stopTest();  
        } 
        
       if(c1[0].Category__c == 'Commercial Complaint'){
        c1[0].status = 'Closed';
        c1[0].OwnerId = us1[0].Id;
        update c1;                          
        }       
    } 

 

  } 
  }
}