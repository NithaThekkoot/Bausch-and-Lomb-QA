/**
* 
*   Test class for trigger "case_AI_grantAccess"
* 
*    Author         |Author-Email                   |Date       |Comment
*    ---------------|-------------------------------|-----------|--------------------------------------------------
*    S Cardinali    |samantha.cardinali@bausch.com  |13.04.2010 |First draft
*    S Cardinali    |samantha.cardinali@bausch.com  |03.11.2010 |Updating to test new BUD case share assignment
*    S Cardinali    |samantha.cardinali@bausch.com  |13.01.2011 |Migrating from VC to SU
*    S Cardinali    |samantha.cardinali@bausch.com  |05.05.2011 |Increase test coverage
*
*/
@isTest
private class TrgCase_AI_grantAccess {
//  static testMethod void testCase_AI_grantAccess() {
//        
//        List<Profile> list_Profiles = [SELECT Id, Name FROM profile WHERE name IN ('EMEACSS: Customer Service Rep','EMEASU Territory Manager') Limit 2]; 
//        Profile upCSSRep = new Profile();
//        Profile upTM = new Profile();
//        for(Profile p : list_Profiles) {
//            if(p.Name == 'EMEACSS: Customer Service Rep') {
//                upCSSRep = p;
//            } else {
//                upTM = p;
//            }
//        }
//        List<User> list_users = new List<User>();
//        User userAllBUs = new User();
//        
//        List<UserRole> list_Roles = [SELECT Id, Name FROM UserRole WHERE Name IN ('EMEA SU CSS - All BUs','UK SU BUD','UK SU TM','FRA SU BUD','FRA SU TM RG01','IBERIA SU TM - 1','GERMANY Nth SU RSM','EM RUSSIA TM','IT SU TM - 1','Sweden SU TM')];
//        Map<String,Id> map_Roles = new Map<String,Id>();
//        for(UserRole ur : list_Roles) {
//            map_Roles.put(ur.Name,ur.Id);
//        }
//        
//        //create All BUs user
//        User uAllBU = new User(alias = 'allbus', 
//                                 email='allbus@testorg.com', 
//                                 emailencodingkey='UTF-8',
//                                 lastname='Testing',
//                                 languagelocalekey='en_US', 
//                                 localesidkey='en_US', 
//                                 profileid = upCSSRep.Id, 
//                                 userroleid = map_Roles.get('EMEA SU CSS - ALL BUs'),
//                                 timezonesidkey='America/Los_Angeles',
//                                 username='allbus@testorg.com');
//        list_users.add(uAllBU);
//        
//        //create UK BUD user
//        User uKIN = new User(alias = 'csskin', 
//                             email='csskin@testorg.com', 
//                             emailencodingkey='UTF-8',
//                             lastname='Testing',
//                             languagelocalekey='en_US', 
//                             localesidkey='en_US', 
//                             profileid = upCSSRep.Id, 
//                             userroleid = map_Roles.get('UK SU BUD'),
//                             timezonesidkey='America/Los_Angeles',
//                             username='csskin@testorg.com');
//        list_users.add(uKIN);
//
//        Id rtShipToId = ClsUtility.getRecordTypeId('Account','Ship To Account');
//        List<Account> list_accounts = new List<Account>();
//        
//        //create UK sales rep user
//        User uUKTM = new User(alias = 'ukvctm', 
//                             email='frvctm@testorg.com', 
//                             emailencodingkey='UTF-8',
//                             lastname='Testing',
//                             languagelocalekey='en_US', 
//                             localesidkey='en_US', 
//                             profileid = upTM.Id, 
//                             userroleid = map_Roles.get('UK SU TM'),
//                             timezonesidkey='America/Los_Angeles',
//                             username='ukvctm@testorg.com');
//        list_users.add(uUKTM);
//        //create account
//        Account oUKAccount = new Account(Name = 'SCUKTestAcct12345', recordtypeid = rtShipToId, SETID__c = 'UNKGD');
//        list_accounts.add(oUKAccount);
//
//        //create French BUD user
//        User uMPL = new User(alias = 'cssmpl', 
//                             email='cssmpl@testorg.com', 
//                             emailencodingkey='UTF-8',
//                             lastname='Testing',
//                             languagelocalekey='en_US', 
//                             localesidkey='en_US', 
//                             profileid = upCSSRep.Id, 
//                             userroleid = map_Roles.get('FRA SU BUD'),
//                             timezonesidkey='America/Los_Angeles',
//                             username='cssmpl@testorg.com');
//        list_users.add(uMPL);
//        
//        //create French sales rep user
//        User uFRTM = new User(alias = 'frvctm', 
//                             email='frvctm@testorg.com', 
//                             emailencodingkey='UTF-8',
//                             lastname='Testing',
//                             languagelocalekey='en_US', 
//                             localesidkey='en_US', 
//                             profileid = upTM.Id, 
//                             userroleid = map_Roles.get('FRA SU TM RG01'),
//                             timezonesidkey='America/Los_Angeles',
//                             username='frvctm@testorg.com');
//        list_users.add(uFRTM);
//        //create account
//        Account oFRAccount = new Account(Name = 'SCFRTestAcct12345', recordtypeid = rtShipToId, SETID__c = 'FRANC');
//        list_accounts.add(oFRAccount);
//        
//        //create Spanish sales rep user
//        User uESTM = new User(alias = 'esvctm', 
//                             email='esvctm@testorg.com', 
//                             emailencodingkey='UTF-8',
//                             lastname='Testing',
//                             languagelocalekey='en_US', 
//                             localesidkey='en_US', 
//                             profileid = upTM.Id, 
//                             userroleid = map_Roles.get('IBERIA SU TM - 1'),
//                             timezonesidkey='America/Los_Angeles',
//                             username='esvctm@testorg.com');
//        list_users.add(uESTM);
//        //create account
//        Account oESAccount = new Account(Name = 'SCESTestAcct12345', recordtypeid = rtShipToId, SETID__c = 'SPACM', Ship_to_id__c = '94725651', legacy_system_id__c = 'SPACM94725651');
//        list_accounts.add(oESAccount);
//
//        //create German sales rep user
//        User uDETM = new User(alias = 'devctm', 
//                             email='devctm@testorg.com', 
//                             emailencodingkey='UTF-8',
//                             lastname='Testing',
//                             languagelocalekey='en_US', 
//                             localesidkey='en_US', 
//                             profileid = upTM.Id, 
//                             userroleid = map_Roles.get('GERMANY Nth SU RSM'),
//                             timezonesidkey='America/Los_Angeles',
//                             username='devctm@testorg.com');
//        list_users.add(uDETM);
//        //create account
//        Account oDEAccount = new Account(Name = 'SCDETestAcct12345', recordtypeid = rtShipToId, SETID__c = 'DMBLV');
//        list_accounts.add(oDEAccount);
//
//        //create Emerging Markets sales rep user
//        User uEMTM = new User(alias = 'emvctm', 
//                             email='emvctm@testorg.com', 
//                             emailencodingkey='UTF-8',
//                             lastname='Testing',
//                             languagelocalekey='en_US', 
//                             localesidkey='en_US', 
//                             profileid = upTM.Id, 
//                             userroleid = map_Roles.get('EM RUSSIA TM'),
//                             timezonesidkey='America/Los_Angeles',
//                             username='emvctm@testorg.com');
//        list_users.add(uEMTM);
//        //create account
//        Account oEMAccount = new Account(Name = 'SCEMTestAcct12345', recordtypeid = rtShipToId, SETID__c = 'RUSSIA');
//        list_accounts.add(oEMAccount);       
//
//        //create Emerging Markets sales rep user
//        User uITTM = new User(alias = 'itvctm', 
//                             email='itvctm@testorg.com', 
//                             emailencodingkey='UTF-8',
//                             lastname='Testing',
//                             languagelocalekey='en_US', 
//                             localesidkey='en_US', 
//                             profileid = upTM.Id, 
//                             userroleid = map_Roles.get('IT SU TM - 1'),
//                             timezonesidkey='America/Los_Angeles',
//                             username='itvctm@testorg.com');
//        list_users.add(uITTM);
//        //create account
//        Account oITAccount = new Account(Name = 'SCITTestAcct12345', recordtypeid = rtShipToId, SETID__c = 'ITALY');
//        list_accounts.add(oITAccount); 
//
//        //create Nordic sales rep user
//        User uNOTM = new User(alias = 'novctm', 
//                             email='novctm@testorg.com', 
//                             emailencodingkey='UTF-8',
//                             lastname='Testing',
//                             languagelocalekey='en_US', 
//                             localesidkey='en_US', 
//                             profileid = upTM.Id, 
//                             userroleid = map_Roles.get('Sweden SU TM'),
//                             timezonesidkey='America/Los_Angeles',
//                             username='novctm@testorg.com');
//        list_users.add(uNOTM);
//        //create account
//        Account oNOAccount = new Account(Name = 'SCNOTestAcct12345', recordtypeid = rtShipToId, SETID__c = 'NORSE');
//        list_accounts.add(oNOAccount); 
//        
//        insert list_users;
//        Set<ID> set_userIds = new Set<ID>();
//        for(User oUser : list_users){
//            set_userIds.add(oUser.Id);
//        }
//        List<User> list_insertedUsers = [SELECT Id, UserRoleId FROM User WHERE Id IN :set_userIds LIMIT 999];
//        Map<String,ID> map_SetIdUser = new Map<String,ID>();
//        for(User oUser : list_insertedUsers) {
//            system.debug('oUser.UserRoleId:' + oUser.UserRoleId);
//            if(oUser.UserRoleId == map_Roles.get('UK SU TM')){
//                map_SetIdUser.put('UNKGD',oUser.Id);
//            } else if(oUser.UserRoleId == map_Roles.get('FRA SU TM RG01')){
//                map_SetIdUser.put('FRANC',oUser.Id);
//            } else if(oUser.UserRoleId == map_Roles.get('GERMANY Nth SU RSM')){
//                map_SetIdUser.put('DMBLV',oUser.Id);
//            } else if(oUser.UserRoleId == map_Roles.get('IBERIA SU TM - 1')){
//                map_SetIdUser.put('SPACM',oUser.Id);
//            } else if(oUser.UserRoleId == map_Roles.get('EMkt RUS TM')){
//                map_SetIdUser.put('RUSSIA',oUser.Id);
//            } else if(oUser.UserRoleId == map_Roles.get('IT SU TM - 1')){
//                map_SetIdUser.put('ITALY',oUser.Id);
//            } else if(oUser.UserRoleId == map_Roles.get('Sweden SU TM')){
//                map_SetIdUser.put('NORSE',oUser.Id);
//            } else if(oUser.UserRoleId == map_Roles.get('EMEA SU CSS - ALL BUs')){
//                userAllBUs = oUser;
//            }            
//        }
//        system.debug('map_SetIdUser: ' + map_SetIdUser);
//        
//        system.runAs(userAllBUs) {
//     
//            Id rtEMEACaseId = ClsUtility.getRecordTypeId('Case','EMEA Service Case');
//            List<AccountTeamMember> list_acctTeamMbr = new List<AccountTeamMember>();
//            List<AccountShare> list_acctShare = new List<AccountShare>();
//            List<Case> list_cases = new List<Case>();
//
//            //insert accounts
//            insert list_accounts;
//            Set<ID> set_accountIds = new Set<ID>();
//            for(Account oAccts : list_accounts){
//                set_accountIds.add(oAccts.Id);
//            }
//            List<Account> list_insertedAccts = [SELECT Id, SETID__c FROM Account WHERE Id IN :set_accountIds LIMIT 999];
//                
//            for(Account eachAcct : list_insertedAccts) {
//               
//                Map<ID,ID> map_AcctUser = new Map<ID,ID>();
//                if(eachAcct.SETID__c == 'UNKGD'){
//                    map_AcctUser.put(eachAcct.Id,map_SetIdUser.get('UNKGD'));
//                } else if(eachAcct.SETID__c == 'FRANC') {
//                    map_AcctUser.put(eachAcct.Id,map_SetIdUser.get('FRANC'));
//                } else if(eachAcct.SETID__c == 'DMBLV') {
//                    map_AcctUser.put(eachAcct.Id,map_SetIdUser.get('DMBLV'));
//                } else if(eachAcct.SETID__c == 'SPACM') {
//                    map_AcctUser.put(eachAcct.Id,map_SetIdUser.get('SPACM'));
//                } else if(eachAcct.SETID__c == 'RUSSIA') {
//                    map_AcctUser.put(eachAcct.Id,map_SetIdUser.get('RUSSIA'));
//                } else if(eachAcct.SETID__c == 'ITALY') {
//                    map_AcctUser.put(eachAcct.Id,map_SetIdUser.get('ITALY'));
//                } else if(eachAcct.SETID__c == 'NORSE') {
//                    map_AcctUser.put(eachAcct.Id,map_SetIdUser.get('NORSE'));
//                }
//                //add account team
//                if(map_AcctUser.get(eachAcct.Id) <> Null) {
//                    AccountTeamMember oAcctTeam = new AccountTeamMember(UserId = map_AcctUser.get(eachAcct.Id),AccountId = eachAcct.Id,TeamMemberRole='Surgical Sales Rep');
//                    list_acctTeamMbr.add(oAcctTeam);
//                    AccountShare oAcctShare = new AccountShare(UserOrGroupId = map_AcctUser.get(eachAcct.Id),AccountId = eachAcct.Id,AccountAccessLevel='EDIT',CaseAccessLevel='None',OpportunityAccessLevel='None');
//                    list_acctShare.add(oAcctshare);
//                }
//        
//                //create cases
//                system.debug('OwnerId (userAllBUs.Id): ' + userAllBUs.Id);
//                Case oCase = new Case(AccountId = eachAcct.Id,
//                                        OwnerId = userAllBUs.Id,
//                                        Origin = 'Web', 
//                                        RecordTypeId = rtEMEACaseId, 
//                                        Contact_Name__c = 'EMEA Tester', 
//                                        Domestic_or_International_Order__c = 'Domestic', 
//                                        Solved_on_First_Call__c = 'Yes', 
//                                        Category__c = 'Customer Service', 
//                                        Reason__c = 'Account Change', 
//                                        Status = 'Closed');
//                list_cases.add(oCase);
//            }
//            insert list_acctTeamMbr;
//            insert list_acctShare;
//            insert list_cases;
//            
//        }
//    }
}