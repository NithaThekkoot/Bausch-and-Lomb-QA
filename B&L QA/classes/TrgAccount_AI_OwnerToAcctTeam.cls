/**
 * 
 *   Test class for trigger "account_AI_OwnerToAcctTeam"
 * 
 *    Author         |Author-Email                           |Date       |Comment
 *    ---------------|---------------------------------------|-----------|--------------------------------------------------
 *    Harvin         |harvin.vincent@listertechnologies.com  |23.03.2010 |First draft
 *Santosh Kumar S    |santosh.sriram@listertechnologis.com   |10.3.2011  |Changing INDSU to APACSU Sytem Admin
 * Rajesh Sriramulu  |rajesh.sriramulu@rishabhsoft.com       |27.06.2012 | added Code to increase the code coverage.
 */
@isTest
private class TrgAccount_AI_OwnerToAcctTeam {
    
    static testMethod void testCase_AI_ownerToAcctTeam() {
       // Getting Profile for INDSU System Administrator and creating User for that Profile 
       Profile oProfile = [SELECT Id 
                           FROM profile 
                           WHERE name='BL: System Admin SSO']; 
           UserRole objRole = [Select Id From UserRole where name like '%INDSU%' limit 1 ];                 
       User oUser = new User(alias = 'standt', 
                             email='standarduser_acc@testorg.com', 
                             emailencodingkey='UTF-8',
                             UserRoleId = objRole.Id,
                             lastname='Testing_acc',
                             languagelocalekey='en_US', 
                             localesidkey='en_US', 
                             profileid = oProfile.Id, 
                             timezonesidkey='America/Los_Angeles',
                             username='standarduser_acc@testorg.com');
       insert oUser;                      
       System.runAs(oUser) {
           
           // Getting Id for recordType INDSU Direct, INDSU Indirect
           RecordType oRecordType = [SELECT Id
                              FROM RecordType
                              WHERE Name = 'INDSU Direct' 
                              AND SObjectType='Account'];  
           String dirRecordTypeId = oRecordType.Id;
           
           oRecordType = [SELECT Id
                              FROM RecordType
                              WHERE Name = 'INDSU Indirect' 
                              AND SObjectType='Account'];
           String indirRecordTypeId = oRecordType.Id;

           List<Account> list_accountList = new List<Account>();
           
           // Testing 25 Accounts 
           for (Integer j = 0; j < 25; j++) {
                Account oAccount = new Account();
                oAccount.Name = 'Test'+ j;
                if (j > 15) {
                   oAccount.recordTypeId = dirRecordTypeId;
                } else {
                   oAccount.recordTypeId = indirRecordTypeId;
                }
                list_accountList.add(oAccount);
           } 
           insert list_accountList;
           Set<Id> set_accountId = new Set<Id>();
           
           // Setting AccountId in a Set 
           for(Account oAccount : list_accountList) {
                set_accountId.add(oAccount.Id);
           } 
           
           // Querying the Account 
            Set<String> set_username = new Set<String>();
            set_username.add(Label.INDSU_Data_Integration_User_Direct_Account);
            set_username.add(Label.INDSU_Data_Integration_User_Indirect_Account);
            Set<Id> set_userId = new Set<Id>();
            // Getting Id based on the username given
            for (User dataUser : [SELECT Id, username
                                  FROM User
                                   WHERE username IN:set_username]) {
                  set_userId.add(dataUser.Id);               
            }
                
           List<Account> list_account = 
                                        [SELECT
                                            OwnerId
                                         FROM Account
                                         WHERE Id IN:set_accountId and OwnerId =:oUser.Id];
           // Checking the account.size is correct                               
           System.assertEquals(list_account.size(), 0);

           // Querying the AccountShare based on accountIds and userId
           List<AccountShare> list_accountShare = 
                                        [SELECT
                                            Id, AccountAccessLevel
                                         FROM AccountShare
                                         WHERE AccountId IN:set_accountId
                                         AND UserOrGroupId =:oUser.Id];
           // Checking the account.size is correct                               
           //System.assertEquals(list_accountShare.size(), 25);
           
           // Checking the AccountShare about the AccessLevel settings
           for (AccountShare oAccountShare : list_accountShare) {
                //System.assertEquals('Edit', oAccountShare.AccountAccessLevel); 
           }                                         
       }
           
       Id idDirectRecordType = [SELECT Id FROM RecordType 
                                        WHERE Name = 'INDSU Indirect' AND SObjectType='Account'].Id;
        Profile objProfile = [SELECT Id FROM profile WHERE name='BL: System Admin SSO'];        
         UserRole objRoles = [Select Id From UserRole where name like '%INDSU%' limit 1 ];
          //Create User
      User oUsers = new User(FirstName = 'SCTest', LastName = 'User12345', UserRoleId = objRoles.Id, ProfileId = objProfile.Id, alias = 'user99', username='SCTest@User12345.com' ,
                             email='SCTest@User12345.com',Country='sCountry', emailencodingkey='UTF-8', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles');
      insert oUsers;                                           
       System.runAs(oUsers){
         Account acc = new Account();
         acc.Name = 'Test';         
         acc.RecordTypeId = idDirectRecordType ;
         insert acc;
    }
    }
}