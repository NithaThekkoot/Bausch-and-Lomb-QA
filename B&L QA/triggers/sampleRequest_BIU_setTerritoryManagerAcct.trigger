/**
* 
*    This trigger populates the Account lookup field with the Territory Manager Accountid. 
*
*    Author             |Author-Email                   |Date        |Comment
*    -------------------|--------------------------------|-----------|--------------------------------------------------
*    Samantha Cardinali |samantha.cardinali@bausch.com   |18.05.2010 |First draft
*
*
*/
trigger sampleRequest_BIU_setTerritoryManagerAcct on Sample_Request__c (before insert, before update) {

  // Getting recordType Id for recordType EMEA_SU_Sample_Request
  RecordType oRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'EMEA_SU_Sample_Request' AND SObjectType='Sample_Request__c' Limit 1];

  // Getting only the Sample Requests for the selected RecordType
  Set<Id> set_sampleRequestId = new Set<Id>();
  Set<Id> set_userId = new Set<Id>();
  for (Sample_Request__c oSampleRequest : Trigger.new) {
    if (oRecordType.Id == oSampleRequest.RecordTypeId) {
      set_sampleRequestId.add(oSampleRequest.Id);
      set_userId.add(oSampleRequest.OwnerId);
      System.debug('Owner: ' + oSampleRequest.OwnerId);
    } 
  }

  //Do not execute unless requests are of the EMEAVC recordtype
  if (set_sampleRequestId.size()>0){
  
    // Get the TM account legacy system ids
    Map<String,Id> map_UserIdPersonalAccount = new Map<String,Id>();
    Set<String> set_personalAccount = new Set<String>();
    for(User oUser : [SELECT Id, Username, Personal_Account__c FROM User WHERE Id IN :set_userId Limit 999]) {
      if (oUser.Personal_Account__c <> null) {
        map_UserIdPersonalAccount.put(oUser.Personal_Account__c, oUser.Id);
        set_personalAccount.add(oUser.Personal_Account__c);
      }
    }
    
    if (set_personalAccount.size()>0) {
      // Get the TM account accountids
      Map<Id,Id> map_UserIdTMAccountId = new Map<Id,Id>();
      for(Account oTMAccount : [SELECT Id, Legacy_System_Id__c FROM Account WHERE Legacy_System_Id__c IN :set_PersonalAccount Limit 999]){
        map_UserIdTMAccountId.put(map_UserIdPersonalAccount.get(oTMAccount.Legacy_System_Id__c),oTMAccount.Id);      
      }

      for (Sample_Request__c oSampleRequest : Trigger.new) {
        if(set_sampleRequestId.contains(oSampleRequest.Id)){
          if(map_UserIdTMAccountId.get(oSampleRequest.OwnerId) <> null) {
            oSampleRequest.Territory_Manager_Account__c = map_UserIdTMAccountId.get(oSampleRequest.OwnerId);
          }
        }  
      }
    }else{
        for (Sample_Request__c oSampleRequest : Trigger.new) {
          oSampleRequest.addError('Your Home Account has not been associated with you yet. Please contact security to get this information added.');
        }
    }
  }

}