/**     
    
    Developer       Email                       Date
    Vijay Singh     vijay.singh@aequor.com      04/4/2013
    Kuldeep         kuldeep.rathore@bausch.com  01/31/2014  
    
 */
@isTest
private class user_BIU_checkUserPermissions_Test {

    static testMethod void user_BIU_checkUserPermissions() {        
        user u = [select id,Name from User where Profile.Name = 'BL: System Administrator' Limit 1];        
        system.runas(u){
            Profile p = [select id from profile where name='BL: System Admin SSO'];
            User user = new User(alias = 'test0123', email='test1234_Test@noemail.com',
            emailencodingkey='UTF-8', lastname='Testing123_test', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='test1234_Test@noemail.com');
            insert user;
            update user;
            user.isactive=false;
            update user;    
        }
        

    }
}