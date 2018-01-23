/**
 * 
 *   This trigger changes the owner to the Data Integration users.
 *   For Record Type INDSU Direct, the owner is changed to dtintg_dir_insu
 *   For Record Type INDSU Indirect, the owner is change to dtintg_indir_insu
 *
 *    Author         |Author-Email                            |Date       |Comment
 *    ---------------|--------------------------------------  |-----------|--------------------------------------------------
 *    Balaji         |balaji.prabakaran@listertechnologies.com|27.03.2010 |First Draft 
 *    Sourav         |sourav.mitra@listertechnologies.com     |31.08.2010 |Changes to incorporate China
 *
 */
 
trigger accountProfile_AI_ChangeOwner on Account_Profile__c (after insert) 
{
        // Getting recordType Id for recordType INDSU Direct, INDSU Indirect
        Set<Id> set_recordTypeId = new Set<Id>();
        for (RecordType oRecordType : [SELECT Id
                                       FROM RecordType
                                       WHERE NAME IN('INDSU Direct','INDSU Indirect','APACSU Direct','APACSU Indirect')
                                       AND SObjectType='Account_Profile__c'] ) {
              set_recordTypeId.add(oRecordType.Id);                         
        }
        
        // Getting only the Account Profiles for the selected RecordTypes                                    
        Set<Id> set_accountProfileId = new Set<Id>();
        if (set_recordTypeId.size() > 0) 
        {
            for (Account_Profile__c oAccountProfile : Trigger.new) 
            {
                if (set_recordTypeId.contains(oAccountProfile.RecordTypeId)) 
                {
                    set_accountProfileId.add(oAccountProfile.Id);
                } 
            }
        }

        // Getting the Ids of the data integration users.
        List<String> list_username = new List<String>();
        list_username.add(Label.INDSU_Data_Integration_User_Direct_Account);
        list_username.add(Label.INDSU_Data_Integration_User_Indirect_Account);
        list_username.add(Label.CHNSU_Data_Integration_User_Direct_Account);
        list_username.add(Label.CHNSU_Data_Integration_User_Indirect_Account);
        
        Map<String, Id> map_username = new Map<String, Id>();
        if (set_accountProfileId.size()>0)
        {
            for (User oUser : [SELECT Id, username
                               FROM User
                               WHERE username IN:list_username]) {
                  map_username.put(oUser.username, oUser.Id);               
            }
        }
                
        // Setting Account Profile Owner for the integration user
        List<Account_Profile__c> list_updateAccountProfile = new List<Account_Profile__c>();
        for (Account_Profile__c oAccountProfile : [SELECT Id, recordType.Name
                                 FROM Account_Profile__c 
                                 WHERE Id IN : set_accountProfileId ]) {
            if (oAccountProfile.recordType.Name == 'INDSU Direct') {
                //oAccountProfile.OwnerId = map_username.get(Label.INDSU_Data_Integration_User_Direct_Account);   
            } else if (oAccountProfile.recordType.Name == 'INDSU Indirect') {
                //oAccountProfile.OwnerId = map_username.get(Label.INDSU_Data_Integration_User_Indirect_Account);
            }                       
            list_updateAccountProfile.add(oAccountProfile);
        }
        update list_updateAccountProfile;
}