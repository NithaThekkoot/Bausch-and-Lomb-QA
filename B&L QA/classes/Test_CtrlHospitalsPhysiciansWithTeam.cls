/**
 * Test Class for custom implementation on report generation for assigned accounts and contacts for logged in user/his team
 *
 *   Author             |Author-Email                                      |Date       |Comment
 *   -------------------|--------------------------------------------------|-----------|--------------------------------------------------
 *   Neha Jain          |neha.jain@bausch.com                              |22.04.2014 |First Draft 
 *
 * Class -- CtrlHospitalsPhysiciansWithTeam
 * 
 */
@isTest
private class Test_CtrlHospitalsPhysiciansWithTeam{

    public static testmethod void testHospitalsPhysiciansWithTeam() {
      List<User> listUser = [Select Id, ManagerId from user where Profile.Name = 'INDSU Sales Rep' and isactive = true and Manager.isactive = true limit 1];
      
      List<User> listIntegrationUser = [Select id from user where Profile.Name = 'BL: Integration User' and isactive = true limit 1] ;

      if(listIntegrationUser.size() > 0){
              system.runAs(listIntegrationUser[0]){
            
              Account newAccount = new Account(Name = 'TestAccount');
              insert newAccount;
              
              Account_Profile__c newAccountProfile = new Account_Profile__c();
              newAccountProfile.Account__c = newAccount.Id;
              insert newAccountProfile;
              
              Contact newContact = new Contact();
              newContact.FirstName = 'Maharana';
              newContact.LastName = 'Pratap';
              newContact.AccountId = newAccount.Id;
              insert newContact; 
              
              Contact_Profile__c cp = new Contact_Profile__c();
              cp.Contact__c = newContact.Id;
              insert cp; 
              
        
              AccountTeamMember atm = new AccountTeamMember();
              atm.AccountId = newAccount.Id;
              atm.UserId = listUser[0].Id; 
              insert atm;
          }
      
     }
      // run as default user
      CtrlHospitalsPhysiciansWithTeam controller = new CtrlHospitalsPhysiciansWithTeam();
      
      if(listUser.size() > 0){
          //run as a sales/service rep, a manager with profile INDSU Sales Manager
          system.runAs(listUser[0]){
          
           PageReference pr = new PageReference('apex/MCLData');
           Test.setCurrentPage(pr);
            
              controller = new CtrlHospitalsPhysiciansWithTeam();
              controller.SendMailToUserOnly();
          }
          
          User manager = new User(Id = listUser[0].ManagerId);
          
          system.runAs(manager){
              controller = new CtrlHospitalsPhysiciansWithTeam();
              controller.SendMailToUserOnly();
          }
      }
       
   }
   
}