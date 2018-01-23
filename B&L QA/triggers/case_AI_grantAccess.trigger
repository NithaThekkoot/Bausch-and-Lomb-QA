/**
 * 
 *   Shares Cases created by All BU users with the appropriate CS centre. The use of real BUD role users was agreed during design;  
 *   the CaseShare requires a real user record and we could not justify using up licenses for this purpose. The user needed to be  
 *   below each individual CoE but above the active Sales organisation. The BUD users were chosen becuase the roles have a low turnover 
 *   and should always be assigned to someone. If a BUD is replaced, new Cases will be made visible via the new BUD, old Cases may need 
 *   manual updating. If no BUD exists the Case will not be accessible to specific CoE agents, only to All BU agents. Only Cases raised  
 *   by CS agents in an All BUs role require a CaseShare record to be created by this logic. This could not be accomplished using
 *   criteria based sharing as the key field, SETID__c, is not available as it is a formula field. Role based sharing does not work on
 *   two levels: the sharing of records to users below the owner on the hierarchy didn't work, plus we did not want to share all cases
 *   owned by All BUs users with every CoE and it is not possible to be selective about which records get shared with whom using role alone.
 *   Author             |Author-Email                 |Date       |Comment
 *   -------------------|-----------------------------|-----------|--------------------------------------------------
 *   Samantha Cardinali |samantha.cardinali@bausch.com|06.08.2010 |First Draft
 *   Samantha Cardinali |samantha.cardinali@bausch.com|14.06.2011 |Updating to use the SETID__c field, which is populated regardless of whether an account is associated
 *   Samantha Cardinali |samantha.cardinali@bausch.com|29.06.2011 |Adding BUMs as backup users
 *   Samantha Cardinali |samantha.cardinali@bausch.com|01.08.2012 |Adding IRLCM
 *   Amanda Purdy       |Amanda.purdy@bausch.com      |06.03.2013 |Adding new UK/Nordic BUD Role
 *   Amanda Purdy       |Amanda.purdy@bausch.com      |07.03.2013 |Executing for new North CS role and cleaning SETIDs
 *
 */
trigger case_AI_grantAccess on Case (after insert) {

    //logic to prevent the trigger from running if there are no EMEA cases in the dataset
    Boolean bExecute = false;
    ID rtEMEAId = ClsUtility.getRecordTypeId('Case','EMEA Service Case');
    for(Case oCase : Trigger.New) {
      if(oCase.RecordTypeId == rtEMEAId) {
        bExecute = true;
      }
    }    

    if(bExecute) {
      List<UserRole> list_CSRoles = [SELECT Id, Name From UserRole WHERE Name IN ('EMEA SU CSS - All BUs','EMEA SU CSS - North','DAS SU BUD','DAS SU BUM','EMkt BUD','EMkt BUM','UK/Nordic SU BUD','Nordic BUD','Nordic BUM','UK SU BUD','UK SU BUM','FRA BENELUX SU BUD','FRA BENELUX SU BUM','IBERIA SU BUD','IBERIA SU BUM','IT SU BUD','IT SU BUM') Limit 50];
      UserRole urAllBUs = new UserRole();
      UserRole urNorth = new UserRole();
      Map<String,ID> map_roleIDName = new Map<String,ID>();
      for(UserRole oRole : list_CSRoles) {
        if(oRole.Name == 'EMEA SU CSS - All BUs') {
            urAllBUs = oRole;
        } else if(oRole.Name == 'EMEA SU CSS - North') {
            urNorth = oRole;
        } else {
            map_roleIDName.put(oRole.Name,oRole.ID);
        }
      }

      Set<ID> set_caseOwners = new Set<ID>();
      for(Case oCase : Trigger.New) {
        if(oCase.RecordTypeId == rtEMEAId) {
          set_caseOwners.add(oCase.OwnerId);
        }
      }
      List<User> list_Owners = [SELECT Id, UserRoleId FROM User WHERE Id IN :set_caseOwners];
      Map<ID,ID> map_CaseWithOwnerRole = new Map<ID,ID>();
      for(Case oCase : Trigger.New) {
        for(User oUser : list_Owners) {
          if(oCase.OwnerId == oUser.Id) {
              map_CaseWithOwnerRole.put(oCase.Id,oUser.UserRoleId);
          }
      }
     }    
      system.debug('map_CaseWithOwnerRole: ' + map_CaseWithOwnerRole);
      List<Case> list_allBUAndNorthCases = new List<Case>();
      for(Case oCase : Trigger.New) {
        if(map_CaseWithOwnerRole.get(oCase.Id) == urAllBUs.Id || map_CaseWithOwnerRole.get(oCase.Id) == urNorth.Id) {
          list_allBUAndNorthCases.add(oCase);
        }
      }

      if(list_allBUAndNorthCases<> null) {

        Set<String> set_CSSKIN = new Set<String>{'UNKGD','NORSE','NORNO','NORDK','NORFI','POLND','IRLCM'};
        Set<String> set_CSSMPL = new Set<String>{'FRANC','BELGM','ITALY','SPAIN','SPACM','PORTU','NETPR'};
        Set<String> set_CSSBER = new Set<String>{'DMBLV','SWICM','AUSTR'};
        Set<String> set_CSSEM = new Set<String>{'RUSSIA','CZECH','UKRAI','SAFRI','TURKEY','GREECE','ALGER','EGYPT','MOROC','TUNIS','SAUDI','LEBNN','JRDAN','ARABE','HUNGA','BULGA','ROMAN','SLOVA','SLOVEN','XPORT','MAURI'};

        Map<String,ID> map_caseCSCentre = new Map<String,ID>();        
        String sCSUser = '';        
        String sCSBackupUser = '';  
        String sCSBackupUser2 = '';      
        List<CaseShare> list_caseShare = new List<CaseShare>();         
        Set<ID> set_CSUserRoleIds = new Set<ID>();        
        for(Case oCase : list_allBUAndNorthCases) {            
            system.debug('oCase.SETID__c: ' + oCase.SETID__c);            
            system.debug('oCase.SETID_Manual__c: ' + oCase.SETID_Manual__c);            
            if(set_CSSKIN.contains(oCase.SETID__c)) { 
                if(oCase.SETID__c == 'UNKGD' || oCase.SETID__c == 'POLND' || oCase.SETID__c == 'IRLCM') {               
                    sCSUser = 'UK/Nordic SU BUD';            
                    sCSBackupUser = 'UK SU BUD';
                    sCSBackupUser2 = 'UK SU BUM';            
                } else {
                    sCSUser = 'Nordic BUD';
                    sCSBackupUser = 'Nordic BUM';
                    sCSBackupUser = 'UK/Nordic SU BUD';            
                }
            } else if (set_CSSMPL.contains(oCase.SETID__c)) {
                if (oCase.SETID__c == 'ITALY') {                            
                    sCSUser = 'IT SU BUD';                        
                    sCSBackupUser = 'IT SU BUM';            
                } else if (oCase.SETID__c == 'FRANC' || oCase.SETID__c == 'BELGM' || oCase.SETID__c == 'NETPR') {                            
                    sCSUser = 'FRA BENELUX SU BUD';                        
                    sCSBackupUser = 'FRA BENELUX SU BUM';            
                } else if (oCase.SETID__c == 'SPAIN' || oCase.SETID__c == 'SPACM' || oCase.SETID__c == 'PORTU') {                            
                    sCSUser = 'IBERIA SU BUD';                        
                    sCSBackupUser = 'IBERIA SU BUM';            
                }            
            } else if (set_CSSBER.contains(oCase.SETID__c)) {                        
                sCSUser = 'DAS SU BUD';            
                sCSBackupUser = 'DAS SU BUM';            
            } else {                
                //If the SETID is outside of the above defined lists, it is most likely to be in an Emerging Market, which is why this is the default                
                sCSUser = 'EMkt BUD';            
                sCSBackupUser = 'EMkt BUM';            
            }                           
            map_caseCSCentre.put(map_roleIDName.get(sCSUser),oCase.Id);            
            map_caseCSCentre.put(map_roleIDName.get(sCSBackupUser),oCase.Id); 
            map_caseCSCentre.put(map_roleIDName.get(sCSBackupUser2),oCase.Id);          
            system.debug('map_roleIDName.get(sCSUser): ' +  map_roleIDName.get(sCSUser));            
            set_CSUserRoleIds.add(map_roleIDName.get(sCSUser));        
            set_CSUserRoleIds.add(map_roleIDName.get(sCSBackupUser));
            set_CSUserRoleIds.add(map_roleIDName.get(sCSBackupUser2));        
        }        
        
        List<User> list_users = [SELECT Id, UserRoleId FROM User WHERE IsActive = True AND UserRoleId <> Null AND UserRoleId IN :set_CSUserRoleIds];        
        for(Case oCase : Trigger.New) {                
            for(User oUser : list_users) {            
                system.debug('map_caseCSCentre.get(oUser.UserRoleId): ' + map_caseCSCentre.get(oUser.UserRoleId));                
                system.debug('oCase.Id: ' + oCase.Id);                
                if(map_caseCSCentre.get(oUser.UserRoleId) == oCase.Id) {                    
                    CaseShare oCaseShare = new CaseShare(CaseId = oCase.Id,UserOrGroupId = oUser.Id ,CaseAccessLevel = 'Edit');                    
                    list_caseShare.add(oCaseShare);   
                    break;               
                }            
            }
        }     
        
        if (list_caseShare.size() > 0){
            upsert list_caseShare;
        }
    }
  }
}