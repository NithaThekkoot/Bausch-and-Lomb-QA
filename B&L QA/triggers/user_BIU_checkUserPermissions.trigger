/**
* 
*   Trigger to prevent user records being created or edited unless: a) the running user is a security team member, b) the calling class is a test class, c) it is a dev org
* 
*    Author         |Author-Email                   |Date       |Comment
*    ---------------|-------------------------------|-----------|--------------------------------------------------
*    S Cardinali    |samantha.cardinali@bausch.com  |01.04.2011 |First draft
*
*/

trigger user_BIU_checkUserPermissions on User (before insert, before update) {

    if(Test.isrunningtest()) {
        //allow user to be created/edited as this is coming from a test class and will be rolled back
        system.debug('IS RUNNING TEST: Allowing user create/edit.');
    } else {
        List<User> oRunningUser = [SELECT Id, Security_user__c, ProfileId, UserName FROM User WHERE Id = :System.UserInfo.getUserId() LIMIT 1];
        If(oRunningUser[0].UserName.endsWith('.dev1')){
            //allow user to be created/edited as this is coming from a development environment
            system.debug('IS DEV USER: Allowing user create/edit.');
        } else {
            Boolean isSecurityUser = oRunningUser[0].Security_user__c;
            if(isSecurityUser) {
                //allow user to be created/edited as this is a security team member
                system.debug('IS SECURITY USER: Allowing user create/edit.');
            } else {
                if(Trigger.isUpdate) {
                    List<Profile> list_pAdmin = [SELECT Id FROM Profile WHERE Name IN ('System Administrator','BL: System Administrator','BL: Sys Admin SSO','BL: Read Only Admin','BL: Read Only Admin Non SSO') LIMIT 5];
                    Set<String> set_pAdmin = new Set<String>();
                    for(Profile pAdmin : list_pAdmin) {
                        set_pAdmin.add(pAdmin.Id);
                    }
                    for(User oUserRec : Trigger.New) {
                        if((oUserRec.Id == System.UserInfo.getUserId()) && (!set_pAdmin.contains(oRunningUser[0].ProfileId))) {
                            system.debug('IS THE USERS OWN RECORD AND THEY ARE NOT A SYS ADMIN: Allowing user create/edit.');
                        } else {
                            system.debug('IS NOT A TEST, DEV ENVIRONMENT, A SECURITY USER OR THE USERS OWN RECORD: Forbidding user create/edit.');
                            oUserRec .addError('You do not have permission to create or edit user records!');
                        }
                    }
                } else {
                    for(User oUserRec : Trigger.New) {
                        system.debug('IS NOT A TEST, DEV ENVIRONMENT, A SECURITY USER OR THE USERS OWN RECORD: Forbidding user create/edit.');
                        oUserRec .addError('You do not have permission to create or edit user records!');
                    }
                }
            }
        }
    }

}