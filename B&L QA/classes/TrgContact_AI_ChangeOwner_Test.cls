/**
 * 
 *   Test class for trigger "contact_AI_ChangeOwner"
 * 
 *    Author         |Author-Email                              |Date       |Comment
 *    ---------------|------------------------------------------|-----------|--------------------------------------------------
 *    Balaji         |balaji.prabakaran@listertechnologies.com  |30.03.2010 |First draft
 *    Santosh Kumar  |santosh.sriram@listertechnologies.com     |10.03.2011 |Changing INDSU System Admin To APACSU Admin
 *
 */
@isTest
private class TrgContact_AI_ChangeOwner_Test {

    static testMethod void myUnitTest() {
                // Getting Profile for INDSU System Administrator and creating User for that Profile    
       Profile oProfile = [SELECT Id 
                           FROM profile 
                           WHERE name='APACSU System Administrator']; 
       User oUser = new User(alias = 'standt', 
                             email='standarduser3@testorg.com', 
                             emailencodingkey='UTF-8',
                             lastname='Testing3',
                             languagelocalekey='en_US', 
                             localesidkey='en_US', 
                             profileid = oProfile.Id, 
                             timezonesidkey='America/Los_Angeles',
                             username='standarduser653@testorg.com');
       insert oUser;                      
       System.runAs(oUser) {
           List<RecordType> list_recordType = new List<RecordType>();
           
           // Getting Id for recordType INDSU Direct, INDSU Indirect  
           list_recordType = [SELECT Id
                              FROM RecordType
                              WHERE Name IN ('INDSU Direct','INDSU Indirect') 
                              AND SObjectType='Account'];
           List<Account> list_accountList = new List<Account>();
           System.Debug('User Id='+oUser.Id);
           // Testing 25 Accounts 
           for (Integer j = 0; j < 25; j++) {
                Account oAccount = new Account();
                oAccount.Name = 'Test'+ j;
                oAccount.OwnerId = oUser.Id;
                if (j > 15) {
                   oAccount.recordTypeId = list_recordType[0].Id;
                } else {
                   oAccount.recordTypeId = list_recordType[1].Id;
                }
                list_accountList.add(oAccount);
           } 
           insert list_accountList;
           System.Debug('list_accountList='+list_accountList);
           
           //User oAccountOwner = [Select Id from User where Profile.Name = 'INDSU Sales Administrator' limit 1];
           
           list_recordType = [SELECT Id
                              FROM RecordType
                              WHERE Name IN ('INDSU Contact') 
                              AND SObjectType='Contact'];

           List<Contact> list_contact = new List<Contact>();
           Integer j=0;

           
           for (Account oAccount:list_accountList) {
                Contact oContact = new Contact();
                oContact.AccountId = oAccount.Id;
                oContact.RecordTypeId = list_recordType.get(0).id;
                //oContact.OwnerId = oUser.Id ;
                oContact.LastName = 'Test Contact' + j;
                list_contact.add(oContact);
                j++;
           } 
           insert list_contact;
           
           Set<Id> set_accountId = new Set<Id>();
           
           // Setting AccountId in a Set 
           for(Account oAccount : list_accountList) {
                set_accountId.add(oAccount.Id);
           } 
           
           // Querying the Account 
            List<String> list_username = new List<String>();
            list_username.add('standarduser653@testorg.com');            
            
            Set<Id> set_userId = new Set<Id>();
            // Getting Id based on the username given
            for (User dataUser : [SELECT Id, username
                                  FROM User
                                   WHERE username IN:list_username]) {
                  set_userId.add(dataUser.Id);               
            }
                
           List<Contact> list_contactRead = 
                                        [SELECT
                                            OwnerId
                                         FROM Contact
                                         WHERE Account.Id IN:set_accountId and OwnerId IN:set_userId];
           // Checking the account.size is correct                               
           System.assertEquals(list_contactRead.size(), 25);
       }
    }
}