/**
* 
*   Test class for trigger "sampleRequest_BIU_setTerritoryManagerAcct"
* 
*    Author         |Author-Email                   |Date       |Comment
*    ---------------|-------------------------------|-----------|--------------------------------------------------
*    S Cardinali    |samantha.cardinali@bausch.com  |13.04.2010 |First draft
*
*/
@isTest
private class TrgSampleRequest_BIU_setTMAcct {
  static testMethod void testSampleRequest_BIU_setTerritoryManagerAcct() {
  
  RecordType rtAccount = [SELECT Id FROM RecordType WHERE Name = 'Ship To Account' AND SObjectType='Account' Limit 1];
  Profile pUserProfile = [SELECT Id From Profile Where Name = 'EMEASU Territory Manager' Limit 1];
  RecordType rtSampleRequest = [SELECT Id FROM RecordType WHERE DeveloperName = 'EMEA_SU_Sample_Request' AND SObjectType='Sample_Request__c' Limit 1];

  //create account
  Account oTestAccount = new Account(
    Name = 'SC Test Account 1',
    RecordTypeId = rtAccount.Id,
    Legacy_system_id__c = 'UNKGD12345678'  
  );
  try {
    insert oTestAccount;
  } catch(exception e) {
    system.debug('ERROR -- could not create test account.');
  }

  //create user -- with ref to account
  User oTestUser = new User(
    FirstName = 'SCTest',
    LastName = 'User1',
    Personal_account__c = oTestAccount.Legacy_system_id__c,
    ProfileId = pUserProfile.Id,
    Username = 'sctest@aplace.com.dev1',
    Email = 'samantha.cardinali@bausch.com',
    Alias = 'sctest1',
    CommunityNickname = 'sctestfromaplacedev1',
    TimeZoneSidKey = 'America/Los_Angeles',
    LocaleSidKey = 'en_US',
    LanguageLocaleKey = 'en_US',
    EmailEncodingKey = 'UTF-8'
  );
  try {
    insert oTestUser;
  } catch(exception e) {
    system.debug('ERROR -- could not create test user.');
  }
  
  system.runas(oTestUser) {
    //create sample request
    Sample_request__c oTestSampleRequest = new Sample_request__c(
      RecordTypeId = rtSampleRequest.Id,
      Frequency__c = 'Weekly',
      Request_status__c = 'New',
      Courier__c = 'ParcelForce',
      Submit_for_approval__c = False
    );
    try {
      insert oTestSampleRequest;
    } catch(exception e) {
      system.debug('ERROR -- could not create test sample request.');
    }
  
    //check that tm account is populated
    //Sample_request__c sInsertedSampleRequest = [Select Id, Territory_Manager_Account__c From Sample_request__c Where Id = :oTestSampleRequest.Id];
  }
  
  //remove the account reference
  oTestUser.Personal_account__c = '';
  try {
    update oTestUser;
  } catch(exception e) {
    system.debug('ERROR -- could not create test sample request.');
  }

  //generate the error for users without home account set
  system.runas(oTestUser) {
    //create sample request
    Sample_request__c oTestSampleRequest2 = new Sample_request__c(
      RecordTypeId = rtSampleRequest.Id,
      Frequency__c = 'Weekly',
      Request_status__c = 'New',
      Courier__c = 'ParcelForce',
      Submit_for_approval__c = False
    );
    try {
      insert oTestSampleRequest2;
    } catch(exception e) {
      system.debug('ERROR -- could not create test sample request.');
    }
  }
  
  }
}