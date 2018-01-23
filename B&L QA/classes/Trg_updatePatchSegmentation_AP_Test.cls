/**
 * 
 *   Test class for trigger "accountProfile_AI_ChangeOwner"
 * 
 *    Author         |Author-Email                              |Date       |Comment
 *    ---------------|------------------------------------------|-----------|--------------------------------------------------
 *    Neha Jain      |neha.jain@bausch.com                      |25.03.2014 |First draft
 
 */
@isTest
private class Trg_updatePatchSegmentation_AP_Test {

    static testMethod void myUnitTest() {
        // Getting Profile for INDSU System Administrator and creating User for that Profile    
       Profile oProfile = [SELECT Id 
                           FROM profile 
                           WHERE name = 'THASU Sales Administrator']; 
       User oUser = new User(alias = 'standt', 
                             email='standarduser3@testorg.com', 
                             emailencodingkey='UTF-8',
                             lastname='Testing2',
                             languagelocalekey='en_US', 
                             localesidkey='en_US', 
                             profileid = oProfile.Id, 
                             timezonesidkey='Asia/Bangkok',
                             username='standarduser893@testorg.com');
       insert oUser;                      
       System.runAs(oUser) {
           List<RecordType> list_recordType = new List<RecordType>();
           
           // Getting Id for recordType INDSU Direct, INDSU Indirect  
           list_recordType = [SELECT Id
                              FROM RecordType
                              WHERE Name IN ('INDSU Direct','INDSU Indirect') 
                              AND SObjectType='Account'];
           List<Account> list_accountList = new List<Account>();
           
           // Testing 25 Accounts 
           for (Integer j = 0; j < 25; j++) {
                Account oAccount = new Account();
                oAccount.Name = 'Test'+ j;
                if (j > 15) {
                   oAccount.recordTypeId = list_recordType[0].Id;
                } else {
                   oAccount.recordTypeId = list_recordType[1].Id;
                }
                list_accountList.add(oAccount);
           } 
           insert list_accountList;
           
           // Getting Id for recordType INDSU Direct, INDSU Indirect  
           list_recordType = [SELECT Id
                              FROM RecordType
                              WHERE Name IN ('INDSU Direct','INDSU Indirect') 
                              AND SObjectType='Account_Profile__c'];

           List<Account_Profile__c> list_accountProfile = new List<Account_Profile__c>();
           Integer j=0;
           for (Account oAccount:list_accountList) {
                Account_Profile__c oAccountProfile = new Account_Profile__c();
                oAccountProfile.Account__c = oAccount.Id;
                if (j > 15) {
                   oAccountProfile.recordTypeId = list_recordType[0].Id;
                } else {
                   oAccountProfile.recordTypeId = list_recordType[1].Id;
                }
                list_accountProfile.add(oAccountProfile);
                j++;
           } 
           insert list_accountProfile;
           
           Set<Id> set_accountId = new Set<Id>();
           
           // Setting AccountId in a Set 
           for(Account oAccount : list_accountList) {
                set_accountId.add(oAccount.Id);
           } 
           
           // Querying the Account 
            List<String> list_username = new List<String>();
            // list_username.add(Label.INDSU_Data_Integration_User_Direct_Account);
            // list_username.add(Label.INDSU_Data_Integration_User_Indirect_Account);

            list_username.add(Label.APASU_Data_Integration_User_Oracle);
            list_username.add(Label.APASU_India_Data_Owner);


            Set<Id> set_userId = new Set<Id>();
            // Getting Id based on the username given
            for (User dataUser : [SELECT Id, username
                                  FROM User
                                   WHERE username IN:list_username]) {
                  set_userId.add(dataUser.Id);               
            }
                
       }
    }
}