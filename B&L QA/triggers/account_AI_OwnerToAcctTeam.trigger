/**
 * 
 *   This trigger checks modifies the owner and creates account team member and account share record.
 *
 *    Author         |Author-Email                            |Date       |Comment
 *    ---------------|--------------------------------------  |-----------|--------------------------------------------------
 *    Harvin         |harvin.vincent@listertechnologies.com   |23.03.2010 |First draft
 *    Balaji         |balaji.prabakaran@listertechnologies.com|27.03.2010 |Changes 
 *    Sourav         |sourav.mitra@listertechnologies.com     |31.08.2010 |Changes 
 *    Jennie Burns   |jennie.burns@bausch.com                 |10/29/2010 |Add Logic for Brazil Indirect    
 *    Santosh Kumar S|santosh.sriram@listertechnologies.com   |11/23/2010 |Add Logic for ANZ Direct  
 *    Santosh Kumar S|santosh.sriram@listertechnologies.com   |11/24/2010 |Add logic for SIN, MYS and HKG Direct
 *    Rajesh Sriramulu|rajesh.sriramulu@rishabhsoft.com       |27.06.2012 | added Custom Label for KORSU
 *    David van Pels |davidvanpels@vedere-group.com           |29/11/2012 |Add Logic for ANZ Indirect
 */
trigger account_AI_OwnerToAcctTeam on Account (after insert) 
{
       if (ClsUtility.getProfileIds('Integration').contains(UserInfo.getProfileId())                
        || ClsUtility.getProfileIds('System Administrator').contains(UserInfo.getProfileId()))                
        return;
 if (Trigger.isAfter && Trigger.isInsert) 
    {
        // Setting variables
        List<AccountTeamMember> list_accountTeamMember = new List<AccountTeamMember>();
        List<Account> list_account = new List<Account>();
        List<AccountShare> list_accountShare = new List<AccountShare>(); 
        Set<Id> set_accountId = new Set<Id>();
        Set<Id> set_userId = new Set<Id>();
        Set<Id> set_recordTypeId = new Set<Id>();
        Map<Id, String> map_recordTypeName = new Map<Id, String>();
        Map<Id,String> map_User = new Map<Id,String>();
        
        // Getting recordType Id for recordType INDSU Direct, INDSU Indirect
        for (RecordType oRecordType : [SELECT Id, Name
                                       FROM RecordType
                                       WHERE NAME IN('INDSU Direct','INDSU Indirect','APACSU Direct','APACSU Indirect','Brazil Indirect')
                                       AND SObjectType='Account'] ) 
        {
              set_recordTypeId.add(oRecordType.Id);
              map_recordTypeName.put(oRecordType.Id, oRecordType.Name);                  
        }
        
        // Getting Account for the selected RecordType                                    
        if (set_recordTypeId.size() > 0) 
        {
            for (Account oAccount : Trigger.new) 
            {
                if (set_recordTypeId.contains(oAccount.RecordTypeId)) {
                    list_account.add(oAccount);
                } 
            }
            if (list_account.size() > 0) 
            {
                List<String> list_username = new List<String>();
                
                //Populating the list with the data integration user name fetched from custom labels.
                list_username.add(Label.APASU_India_Data_Owner);
                list_username.add(Label.APACSU_China_Data_Owner);
                list_username.add(Label.LAD_Data_Integration_Owner_Brazil);
                list_username.add(Label.APASU_ANZ_Data_Owner);
                list_username.add(Label.APACSU_Hong_Kong_Data_Owner);
                list_username.add(Label.APACSU_Malaysia_Data_Owner);
                list_username.add(Label.APACSU_Korea_Data_Owner);
                list_username.add(Label.APACSU_Singapore_Data_Owner);
                
                Map<String, Id> map_username = new Map<String, Id>();
                
                // Getting Id based on the username given
                for (User oUser : [SELECT Id, username
                                   FROM User
                                   WHERE username IN:list_username]) 
                {
                      map_username.put(oUser.username, oUser.Id);               
                }
                
                System.debug('User Name=' +Label.APASU_India_Data_Owner);
                System.debug('User ID=' + map_username.get(Label.APASU_India_Data_Owner));
                
                // Setting Account Member Information record type INDSU Direct
                for (Account oAccount : list_account) 
                {
                    String RecordTypeName = map_recordTypeName.get(oAccount.RecordTypeId);
                    System.debug('Account record type=' + RecordTypeName);
                    if (RecordTypeName == 'INDSU Direct' || RecordTypeName == 'APACSU Direct' || RecordTypeName == 'Brazil Indirect') 
                    {
                        AccountTeamMember oAccountTeamMember = new AccountTeamMember();
                        oAccountTeamMember.AccountId = oAccount.Id;
                        oAccountTeamMember.UserId = oAccount.OwnerId;
                        oAccountTeamMember.TeamMemberRole = 'Sales Rep';
                        list_accountTeamMember.add(oAccountTeamMember);
                    }
                    set_accountId.add(oAccount.Id);
                    set_userId.add(oAccount.OwnerId);
                }
                
                if (list_accountTeamMember.size() > 0){
                    insert list_accountTeamMember;
                }

                //Map of Role Ids and Role Names
                Map<Id, String> map_AccountId_RoleName = new Map<Id, String>();
                
                //List of accounts to change the owner for.
                List<Account> list_accountUpdate = new List<Account>();
                String strRoleName;
                //For-loop: Setting the data integration user as the account owner
                for (Account oAccount : [SELECT Id, recordType.Name, Owner.UserRole.Name,OwnerId FROM Account WHERE Id IN : set_AccountId ]) 
                {
                    //Getting the logged-in user role info.
                    strRoleName = oAccount.Owner.UserRole.Name;
                    if (strRoleName==null) 
                        strRoleName = '';
                    
                    else
                        map_User.put(oAccount.OwnerId,strRoleName);
                        
                    //To populate the Role map.
                    map_AccountId_RoleName.put(oAccount.Id, strRoleName);
                    
                    
                    System.debug('strRoleName=' + strRoleName);
                    System.debug('strRoleName starts with=' + strRoleName.startsWith('INDSU'));
                    //If the logged-in user is from India, set the owner as India data integration user.
                    if (strRoleName.startsWith('INDSU')){
                        oAccount.OwnerId = map_username.get(Label.APASU_India_Data_Owner);
                    }
                    else if(strRoleName.startsWith('KORSU'))
                        oAccount.OwnerId = map_username.get(Label.APACSU_Korea_Data_Owner);
                    //If the logged-in user is from China, set the owner as China data integration user.
                    else if(strRoleName.startsWith('CHNSU'))
                        oAccount.OwnerId = map_username.get(Label.APACSU_China_Data_Owner);
                    //If the logged-in user is from Brazil, set the owner to Brazil data integration user.
                    else if(strRoleName.startsWith('BRZSU'))
                        oAccount.OwnerId = map_username.get(Label.LAD_Data_Integration_Owner_Brazil);
                    //If the logged-in user is from Australia & New Zealand, set the owner to ANZ data integration user.
                    else if(strRoleName.startsWith('ANZSU'))
                        oAccount.OwnerId = map_username.get(Label.APASU_ANZ_Data_Owner);
                    //If the logged-in user is from Singapore, set the owner to SIN data integration user.
                    else if(strRoleName.startsWith('SINSU'))
                        oAccount.OwnerId = map_username.get(Label.APACSU_Singapore_Data_Owner);
                    //If the logged-in user is from Malaysia, set the owner to MYS data integration user.
                    else if(strRoleName.startsWith('MYSSU'))
                        oAccount.OwnerId = map_username.get(Label.APACSU_Malaysia_Data_Owner);  
                     //If the logged-in user is from Hong Kong, set the owner to HKG data integration user.
                    else if(strRoleName.startsWith('HKGSU'))
                        oAccount.OwnerId = map_username.get(Label.APACSU_Hong_Kong_Data_Owner);      
                  //further country addition to be added in else if condition later here.
                    list_accountUpdate.add(oAccount);
                }
                update list_accountUpdate;

                Map<String,AccountShare> map_AccountShare = new Map<String,AccountShare>();
                for(AccountShare oAccountShare : [SELECT Id, AccountAccessLevel, OpportunityAccessLevel , AccountId, UserOrGroupId
                                                    FROM AccountShare 
                                                   WHERE AccountId IN :set_accountId AND UserOrGroupId IN :set_userId])
                {
                    map_AccountShare.put(String.valueOf(oAccountShare.AccountId) + String.valueOf(oAccountShare.UserOrGroupId) , oAccountShare);
                }
                
                for (Account oAccount : list_account) 
                {
                    String RecordTypeName = map_recordTypeName.get(oAccount.RecordTypeId);
                    strRoleName = map_User.get(oAccount.OwnerId);
                    System.debug('Account record type=' + RecordTypeName);
                    // To provide Read/Write account access to account team member for record type INDSU Direct
                    if(strRoleName != null)
                    {
                        if ((RecordTypeName == 'INDSU Direct' && strRoleName.startsWith('INDSU')) ||
                            (RecordTypeName == 'APACSU Direct' && strRoleName.startsWith('KORSU'))||
                            (RecordTypeName == 'APACSU Direct' && strRoleName.startsWith('CHNSU'))||
                            (RecordTypeName == 'APACSU Direct' && strRoleName.startsWith('ANZSU'))||
                              (RecordTypeName == 'APACSU Indirect' && strRoleName.startsWith('ANZSU'))||
                            (RecordTypeName == 'APACSU Direct' && strRoleName.startsWith('SINSU'))||
                            (RecordTypeName == 'APACSU Direct' && strRoleName.startsWith('MYSSU'))||
                            (RecordTypeName == 'APACSU Direct' && strRoleName.startsWith('HKGSU'))) 
                        {
                            //AccountShare oAccountShare = [Select id, AccountAccessLevel, OpportunityAccessLevel from AccountShare where AccountId=:oAccount.Id and UserOrGroupId=:oAccount.OwnerId];
                            if(map_AccountShare.containsKey(String.valueOf(oAccount.Id) + String.valueOf(oAccount.OwnerId)))
                            {
                                AccountShare oAccountShare = map_AccountShare.get(String.valueOf(oAccount.Id) + String.valueOf(oAccount.OwnerId));
                                //if(RecordTypeName == 'INDSU Direct' && strRoleName.startsWith('INDSU'))
                                    oAccountShare.AccountAccessLevel = 'Edit';
                                //else
                                    //oAccountShare.AccountAccessLevel = 'Read';
                                    
                                oAccountShare.OpportunityAccessLevel = 'None';
                                oAccountShare.CaseAccessLevel = 'None';
                                list_accountShare.add(oAccountShare); 
                            }                       
                        }
                   if (RecordTypeName == 'Brazil Indirect' && strRoleName.startsWith('BRZSU')) {
                            //AccountShare oAccountShare = [Select id, AccountAccessLevel, OpportunityAccessLevel from AccountShare where AccountId=:oAccount.Id and UserOrGroupId=:oAccount.OwnerId];
                            if(map_AccountShare.containsKey(String.valueOf(oAccount.Id) + String.valueOf(oAccount.OwnerId)))
                            {
                                AccountShare oAccountShare = map_AccountShare.get(String.valueOf(oAccount.Id) + String.valueOf(oAccount.OwnerId));
                                //if(RecordTypeName == 'INDSU Direct' && strRoleName.startsWith('INDSU'))
                                    oAccountShare.AccountAccessLevel = 'Edit';
                                //else
                                    //oAccountShare.AccountAccessLevel = 'Read';
                                    
                                oAccountShare.OpportunityAccessLevel = 'Edit';
                                oAccountShare.CaseAccessLevel = 'None';
                                list_accountShare.add(oAccountShare); 
                            }                       
                        }
 }
                }
                if (list_accountShare.size() > 0){
                    update list_accountShare;
                }
            }
        }   
    }    
}