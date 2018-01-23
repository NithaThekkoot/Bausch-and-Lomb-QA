/**
* 
*   This trigger populates Short_Description__c with the first 255 Chars of Description, for use in the related list on Account.
*   Also populates the custom Ship_To_ID__c field with the Account ship-to, for display in the mini page layout / calendar.
*
*    Author         |Author-Email                   |Date       |Comment
*    ---------------|-------------------------------|-----------|--------------------------------------------------
*    S Cardinali    |samantha.cardinali@bausch.com  |04.01.2010 |First draft
*    S Cardinali    |samantha.cardinali@bausch.com  |15.02.2010 |Applying the trigger for EMEA VC & renaming
*    S Cardinali    |samantha.cardinali@bausch.com  |12.04.2010 |Applying the trigger for EMEA SU and removing VC references
*
*/
trigger event_BIU_setShortDescAndShipTo on Event (before insert, before update) {
 
     Set<Id> set_accIds = new Set<Id>();
    Map<Id,Account> map_acctId_Account = new Map<Id,Account>();
    
      Id rtUSCDSEvent = clsUtility.getRecordTypeId('Event', 'USSUR Clinical Development Specialist'); 
      
    
    for (Event e : Trigger.new) {
      if(e.RecordTypeId == rtUSCDSEvent) {
        if(e.WhatId != null) {
          set_accIds.add(e.WhatId);
        }
      }
    }
        
    if(set_accIds.size() > 0) {
      for (Account acc : [select Id, Ship_To_ID__c,Name from Account where Id in : set_accIds Limit 1000]) {
        map_acctId_Account.put(acc.Id,acc);
      }
    }

    for (Event e : Trigger.new) {
       if(e.RecordTypeId == rtUSCDSEvent) {
               if(e.WhatId<> null) {
         System.debug('--> Event AccountId is not null...');
         if(map_acctId_Account.containsKey(e.WhatId)) {
            System.debug('--> Account ID Key found... setting to ' + map_acctId_Account.get(e.WhatId).Ship_To_ID__c);
            e.Ship_To_ID__c = map_acctId_Account.get(e.WhatId).Ship_To_ID__c;
if(e.location == null) {
            e.location = map_acctId_Account.get(e.WhatId).Name;
}
          } else {
            System.debug('--> Ship To is null - unable to populate on event.');
          }
          System.debug('--> Ship To set...' + e.ship_to_id__c);
        }
      }
    }
 
}