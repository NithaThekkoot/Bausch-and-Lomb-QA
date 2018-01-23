/**
* 
*   This trigger sets the account for an event, in case the event is related to a contact but not to an account.
*   This trigger populates Short_Description__c with the first 255 Chars of Description, for use in the related list on Account.
*   Also populates the custom Ship_To_ID__c field with the Account ship-to, for display in the mini page layout / calendar.
*
*  Testclass: Event_BIU_EMEAFunctions_Test --> Testcoverage: 100 %
*
*  Author            |Author-Email                   |Date       |Comment
*  ------------------|-------------------------------|-----------|------------------------------------------------------------------
*  Frederic Faisst   |frederic.faisst@itbconsult.com |26.11.2010 |First draft
*  Samantha Cardinali|samantha.cardinali@bausch.com  |01.02.2011 |Code was not updating shipto if also executing setting the account
*  Samantha Cardinali|samantha.cardinali@bausch.com  |22.01.2013 |Adding pharma recordtypes
*
*/

trigger Event_BIU_EMEAFunctions on Event (before insert, before update) {
  
  /**
  *  Define collections and variables
  */
  
    Id rtEMEASUEvent = clsUtility.getRecordTypeId('Event', 'EMEA SU Event'); 
    Id rtEMEAPHRXEvent = clsUtility.getRecordTypeId('Event', 'EMEA Pharma RX Event RT'); 
    Id rtEMEAPHOTCEvent = clsUtility.getRecordTypeId('Event', 'EMEA Pharma OTC Event RT'); 
    List<Event> list_accEvents = new List<Event>();
    List<Event> list_descEvents = new List<Event>();
    Set<Id> set_descAccountIds = new Set<Id>();
    Set<Id> set_accountContactIds = new Set<Id>();
    
    for (Event e : Trigger.new) {
      if(e.RecordTypeId == rtEMEASUEvent || e.RecordTypeId == rtEMEAPHRXEvent || e.RecordTypeId == rtEMEAPHOTCEvent) {
          //CHECK WHETHER TO EXECUTE ACCOUNT LOGIC
          if(e.WhatId == null && e.WhoId != null) {
              if (String.valueOf(e.WhoId).startsWith('003')){ //a contact is related to the event
                list_accEvents.add(e);
                set_accountContactIds.add(e.WhoId);            
              }
      }
            
          //CHECK WHETHER TO EXECUTE SHIPTO LOGIC
          if(e.WhatId != null) {
            list_descEvents.add(e);
            set_descAccountIds.add(e.WhatId);
          } else {
            if(e.WhoId != null) {
                list_descEvents.add(e);
            }
          }
              
          //EXECUTE SHORTDESC LOGIC IF DESCRIPTION POPULATED
        if(e.Description != null) {                        
          if(e.Description.length() > 255) {
              e.Short_Description__c = e.Description.substring(0,254);
            } 
            else{
                e.Short_Description__c = e.Description;
              }
            System.debug('--> Short Description set...' + e.short_description__c);
        } 
        else {
          System.debug('--> Description is null - unable to populate short desc.');
        }
    }
    }

  //EXECUTE ACCOUNT LOGIC
    if(set_accountContactIds.size() > 0) {
      
      Map<Id,Id> map_conId_accId = new Map<Id,Id>();
        
        for (Contact c : [Select Id, Name, AccountId from Contact where AccountId != null and Id in :set_accountContactIds]){         
          map_conId_accId.put(c.Id, c.AccountId);             
        }

        for (Event e : Trigger.new){        
          for(Event e1 : list_accEvents) {
              if(e.Id == e1.Id) {
              if(e.WhatId == null && e.WhoId != null) {
                  if (String.valueOf(e.WhoId).startsWith('003')){ //a contact is related to the event
                        if (map_conId_accId.containsKey(e.WhoId)){
                          e.WhatId = map_conId_accId.get(e.WhoId);
                          if(e.WhoId != null) {
                             set_descAccountIds.add(map_conId_accId.get(e.WhoId));
                          }
                        }                 
                    }   
                }
              }
          }
        }
  }

  //EXECUTE SHIPTO LOGIC
    if(set_descAccountIds.size() > 0) {
  
      Map<Id,Account> map_acctId_Account = new Map<Id,Account>();
        
    for (Account acc : [select Id, Ship_To_ID__c from Account where Id in :set_descAccountIds limit 1000]) {
          map_acctId_Account.put(acc.Id,acc);
        }

        for (Event e : Trigger.new) {
          for (Event e1 : list_descEvents) {
              if (e.Id == e1.Id) {
                  if(e.WhatId<> null) {
                      System.debug('--> Event AccountId is not null...');
                        if(map_acctId_Account.containsKey(e.WhatId)) {
                            System.debug('--> Account ID Key found... setting to ' + map_acctId_Account.get(e.WhatId).Ship_To_ID__c);
                            e.Ship_To_ID__c = map_acctId_Account.get(e.WhatId).Ship_To_ID__c;
                        } 
                      else{
                          System.debug('--> Ship To is null - unable to populate on event.');
                        }
                        System.debug('--> Ship To set...' + e.ship_to_id__c);
                  }
                }
          }
    }
  }
}