/**
* 
*   Test class for trigger user_BIU_checkUserPermissions
* 
*    Author         |Author-Email                   |Date       |Comment
*    ---------------|-------------------------------|-----------|--------------------------------------------------
*    S Cardinali    |samantha.cardinali@bausch.com  |01.04.2011 |First draft
*
*/
@isTest
private class Trguser_BIU_checkUserPermissions{
  static testMethod void Trguser_BIU_checkUserPermissions() {

    //Select profile
    Profile pUserProfile = [SELECT Id From Profile Where Name = 'EMEASU Territory Manager' Limit 1];  
    //Create a test user
    User testUser = new User (
      Alias = 'testus',
      Email = 'testuser123@bausch.com',
      Emailencodingkey = 'UTF-8',
      Lastname = 'User',
      Firstname = 'Test',
      Languagelocalekey = 'de',
      Localesidkey = 'de',
      Profileid = pUserProfile.Id,
      isActive = true,
      Timezonesidkey = 'America/New_York',
      Username = 'testuser123@bausch.com'
    );
    try{
      insert testUser;
    } catch(Exception e) {
      System.debug('Error adding User: ' + e.getMessage());
    }

  }
}