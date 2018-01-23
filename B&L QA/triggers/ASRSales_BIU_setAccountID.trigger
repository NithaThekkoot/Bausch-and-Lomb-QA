/**
* 
*   This trigger populates the Account lookup field on ASR Sales records. Used by EMEA SU.
*
*    Author         |Author-Email                   |Date       |Comment
*    ---------------|-------------------------------|-----------|--------------------------------------------------
*    S Cardinali    |samantha.cardinali@bausch.com  |11.03.2010 |First draft
*
*/
trigger ASRSales_BIU_setAccountID on ASR_Sales__c (before insert, before update) {

  Set<String> set_legacyIDs = new Set<String>();
  Map<String,Account> map_legacyId_Account = new Map<String,Account>();

  for (ASR_Sales__c s : Trigger.new) {
    if(s.Legacy_System_ID__c <> null) {
      set_legacyIDs.add(s.Legacy_System_ID__c);
    }
  }

  if(set_legacyIDs.size() > 0) {
    for (Account acc : [select Id, Legacy_System_ID__c from Account where Legacy_System_ID__c in : set_legacyIDs Limit 1000]) {
      map_legacyId_Account.put(acc.Legacy_System_ID__c,acc);
    }
  }

  for (ASR_Sales__c s : Trigger.new) {
    if(s.Legacy_System_ID__c <> null) {
      if(map_legacyId_Account.containsKey(s.Legacy_System_ID__c)) {
        System.debug('--> Account found.');
        s.Account__c = map_legacyId_Account.get(s.Legacy_System_ID__c).ID;
      } else {
        System.debug('--> Legacy ID is null - unable to populate Account on ASR record.');
      }
    }
  }
 
}