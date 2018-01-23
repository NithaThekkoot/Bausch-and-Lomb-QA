/**
 * 
 *   Account trigger to create the default team and share record when a new BILL TO account is integrated from PS 
 *
 *   Author             |Author-Email                 |Date       |Comment
 *   -------------------|-----------------------------|-----------|--------------------------------------------------
 *   Samantha Cardinali |samantha.cardinali@bausch.com|20.05.2011 |First Draft
 *   Samantha Cardinali |samantha.cardinali@bausch.com|06.09.2011 |Implement for Surgical
 *   Samantha Cardinali |samantha.cardinali@bausch.com|08.01.2012 |Add IRLCM
 *
 */
trigger account_AI_addTeamAndShare on Account (after insert) {

    ID rtBillToAcct = ClsUtility.getRecordTypeId('Account','Bill To Account');
    Set<String> set_UserNames = new Set<String>();
    Set<String> set_SETIDs = new Set<String>{'IRLCM','UNKGD','FRANC','DMBLV','AUSTR','SWICM','BELGM','NETPR','NORSE','NORDK','NORFI','NORNO','SPACM','PORTU','ITALY','POLND'};
    Map<String,String> map_UserNameSETID = new Map<String,String>{'IRLCM'=>'Open UKSU','UNKGD'=>'Open UKSU','FRANC'=>'Open FRANCSU','DMBLV'=>'Open DMBLVSU','AUSTR'=>'Open AUSTRSU','SWICM'=>'Open SWICMSU','BELGM'=>'Open BELGMSU','NETPR'=>'Open NETPRSU','NORDK'=>'Open NORDKSU','NORNO'=>'Open NORNOSU','NORSE'=>'Open NORSESU','NORFI'=>'Open NORFISU','SPACM'=>'Open SPACMSU','PORTU'=>'Open PORTUSU','ITALY'=>'Open ITALYSU','POLND'=>'Open POLNDSU'};
    Set<String> set_XTreeSETIDs = new Set<String>{'BELGM','NETPR','POLND'};
    Map<String,String> map_XTreeUserNameSETID = new Map<String,String>{'BELGM'=>'CS BELGMSU','NETPR'=>'CS NETPRSU','POLND'=>'CS POLNDSU'};
    Map<ID,String> map_AccountUserName = new Map<ID,String>();
    Map<ID,String> map_XTreeAccountUserName = new Map<ID,String>();
    Set<Account> set_BillToAccts = new Set<Account>();

    for(Account a : Trigger.New) {
        if(a.RecordTypeId == rtBillToAcct && set_SETIDs.contains(a.SETID__c)) {
            set_BillToAccts.add(a);
            set_UserNames.add(map_UserNameSETID.get(a.SETID__c));
            map_AccountUsername.put(a.Id,map_UserNameSETID.get(a.SETID__c));
            if(set_XTreeSETIDs.contains(a.SETID__c)) {
                set_UserNames.add(map_XTreeUserNameSETID.get(a.SETID__c));
                map_XTreeAccountUserName.put(a.Id,map_XTreeUserNameSETID.get(a.SETID__c));
            }
        }
    }
    system.debug('set_UserNames: ' + set_UserNames);
    system.debug('map_AccountUsername: ' + map_AccountUsername);
    system.debug('map_XTreeAccountUserName: ' + map_XTreeAccountUserName);
    
    if(set_BillToAccts.size() > 0) {
    
        //get Open users
        List<User> list_Users = [SELECT Id, Name FROM User Where Name IN :set_UserNames And IsActive = True LIMIT 20];
        
        List<AccountTeamMember> list_Team = new List<AccountTeamMember>();
        List<AccountShare> list_Share = new List<AccountShare>();
        String sTeamMemberRole = '';
        AccountTeamMember oTeam = null;
        AccountShare oShare = null;
        for(Account a : set_BillToAccts) {
            for(User u : list_Users) {
                system.debug('Id=' + a.Id + ', UserName=' + u.Name);
                system.debug('map_AccountUsername.get(a.Id): ' + map_AccountUsername.get(a.Id));
                if(map_AccountUsername.get(a.Id) == u.Name || map_XTreeAccountUserName.get(a.Id) == u.Name) {
                    if(u.Name.startsWith('CS')) {
                        sTeamMemberRole = 'CS Visibility User';
                    } else {
                        sTeamMemberRole = 'Dummy Visibility User';
                    }
                    oTeam = new AccountTeamMember(AccountId=a.Id,UserId=u.Id,TeamMemberRole=sTeamMemberRole);
                    oShare = new Accountshare(AccountId=a.Id,UserOrGroupId=u.Id,AccountAccessLevel='EDIT',CaseAccessLevel='Read',OpportunityAccessLevel='None');
                    list_Team.add(oTeam);
                    list_Share.add(oShare);
                }
            }
        }
        insert list_Team;
        insert list_Share;
    }
}