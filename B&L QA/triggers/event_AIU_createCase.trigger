/**
* 
*   This trigger creates a Case from the Event if it is a Customer Complaint.
*
*    Author         |Author-Email                   |Date       |Comment
*    ---------------|-------------------------------|-----------|--------------------------------------------------
*    S Cardinali    |samantha.cardinali@bausch.com  |14.09.2010 |First draft
*    S Cardinali    |samantha.cardinali@bausch.com  |05.11.2010 |Set case.routeTo
*    S Cardinali    |samantha.cardinali@bausch.com  |11.04.2011 |Migrating to surgical
*    S Cardinali    |samantha.cardinali@bausch.com  |23.10.2012 |Adding second extended value custom setting field
*    A Purdy        |amanda.purdy@bausch.com        |23.10.2012 |Adding third extended value custom setting field
*    S Cardinali    |samantha.cardinali@bausch.com  |06.03.2013 |Streamlining / bugfixing
*
*/
trigger event_AIU_createCase on Event (after insert, after update) {
    
    Id rtEMEACase = clsUtility.getRecordTypeId('Case', 'EMEA Service Case');        
    Id rtEMEAEvent = clsUtility.getRecordTypeId('Event', 'EMEA SU Event');        
    
    List<Event> list_Events = new List<Event>();
    Map<Id,Id> map_EventUser = new Map<Id,Id>();
    Map<Id,Id> map_EventAccount= new Map<Id,Id>();
    List<Id> list_Userids= new List<ID>();
    List<Id> list_AccountIds= new List<ID>();
    Set<ID> set_ContactIds = new Set<ID>();
    Map<ID,Contact> map_IDContact = new Map<ID,Contact>();

    String sContactName = '';
    String sContactEmail = '';
    String sContactPhone = '';
    
    for (Event e : Trigger.new) {
        if(e.RecordTypeId == rtEMEAEvent) {
            System.debug('Is an EMEA Event. Customer complaint?' + e.Customer_Complaint__c);
            if(e.Customer_Complaint__c == true) {
                System.debug('isInsert: ' + Trigger.isInsert + ', isUpdate: ' + Trigger.isUpdate);
                if(Trigger.isInsert) {
                    System.debug('Is an Insert with customer complaint = true');
                    list_Events.add(e);
                    map_EventAccount.put(e.AccountId,e.Id);
                    list_AccountIds.add(e.AccountId);
                    map_EventUser.put(e.OwnerId,e.Id);
                    list_Userids.add(e.OwnerId);
                    if(e.WhoId <> Null) {
                        set_ContactIds.add(e.WhoId);
                    }
                } else {
                    System.debug('Trigger.oldMap.get(e.Id).Customer_Complaint__c: ' + Trigger.oldMap.get(e.Id).Customer_Complaint__c);
                    if(Trigger.oldMap.get(e.Id).Customer_Complaint__c == false) {
                        System.debug('Is an Update and customer complaint has been changed to true');
                        list_Events.add(e);
                        map_EventAccount.put(e.AccountId,e.Id);
                        list_AccountIds.add(e.AccountId);
                        map_EventUser.put(e.OwnerId,e.Id);
                        list_Userids.add(e.OwnerId);
                        if(e.WhoId <> Null) {
                            set_ContactIds.add(e.WhoId);
                        }
                    }                               
                }
            }
        }
    }

    System.debug('list_Events: ' + list_Events);
    
    if(list_Events.isEmpty() == false) {
      
      system.debug('set_contactids: ' + set_ContactIds + ', Size: ' + set_ContactIds.size());
    
      if(set_ContactIds.size() > 0) {
          List<Contact> list_Contacts = [SELECT Id, Name, Phone, Email FROM Contact WHERE Id IN :set_ContactIds Limit 999];
          for (Event e : list_Events) {
              for (Contact c : list_Contacts) {
                  if(e.WhoId == c.Id) {
                      map_IDContact.put(e.Id,c);
                  }
              }
          }
      }
      
      List<Account> list_Accounts = [SELECT Id, SETID__c FROM Account WHERE Id IN :list_AccountIds];
      Map<Id,String> map_EventSETID = New Map<Id,String>();
      for (Account a : list_Accounts) {
          map_EventSETID.put(map_EventAccount.get(a.Id),a.SETID__c);
      }
      
      Set<String> set_KINBUs = new Set<String>();
      Set<String> set_BERBUs = new Set<String>();
      Set<String> set_MPLBUs = new Set<String>();
      Set<String> set_EMBUs = new Set<String>();

      Grouping_Management__c csGrouping = Grouping_Management__c.getValues('E2C_UR_KINCoE');
      String sKINBUs = csGrouping.Values__c + csGrouping.Extended_values__c + csGrouping.Extended_Values_2__c + csGrouping.Extended_Values_3__c ;
      for (String str : sKINBUs.split(';',-1)){
          set_KINBUs.add(str);
      }
      System.debug('sKINBUs: ' + sKINBUs);
      csGrouping = Grouping_Management__c.getValues('E2C_UR_BERCoE');
      String sBERBUs = csGrouping.Values__c + csGrouping.Extended_values__c + csGrouping.Extended_Values_2__c + csGrouping.Extended_Values_3__c ;
      for (String str : sBERBUs.split(';',-1)){
          set_BERBUs.add(str);
      }           
      System.debug('sBERBUs: ' + sBERBUs);
      csGrouping = Grouping_Management__c.getValues('E2C_UR_MPLCoE');
      String sMPLBUs = csGrouping.Values__c + csGrouping.Extended_values__c + csGrouping.Extended_Values_2__c + csGrouping.Extended_Values_3__c;
      for (String str : sMPLBUs.split(';',-1)){
          set_MPLBUs.add(str);
      }           
      System.debug('sMPLBUs: ' + sMPLBUs);
      csGrouping = Grouping_Management__c.getValues('E2C_UR_EMCoE');
      String sEMBUs = csGrouping.Values__c + csGrouping.Extended_values__c + csGrouping.Extended_Values_2__c + csGrouping.Extended_Values_3__c;
      for (String str : sEMBUs.split(';',-1)){
          set_EMBUs.add(str);
      }           
      System.debug('sEMBUs: ' + sEMBUs);
              
      List<Case> list_Cases = new List<Case>();
      for (Event e : list_Events) {
      
            System.debug('Building list of Cases...');
            if(set_ContactIds.size() > 0) {
                sContactName = map_IDContact.get(e.Id).Name;
                sContactEmail = map_IDContact.get(e.Id).Email;
                sContactPhone = map_IDContact.get(e.Id).Phone;
            }
            
            String sRouteTo = '';
            if(set_BERBUs.contains(map_EventSETID.get(e.Id))) {
                sRouteTo = 'CS COE - Berlin';
            }else if(set_MPLBUs.contains(map_EventSETID.get(e.Id))) {
                sRouteTo = 'CS COE - Montpellier';
            }else if(set_EMBUs.contains(map_EventSETID.get(e.Id))) {
                sRouteTo = 'EMCS MTP';
            } else {
                sRouteTo = 'CS COE - Kingston';
            }
            
            Case newCase = new Case(
                RecordTypeId = rtEmeaCase,
                OwnerId = e.OwnerId,
                Origin = 'Sales Call',
                AccountId = e.AccountId,
                Contact_Name__c = sContactName,
                Contact_Email__c = sContactEmail,
                Contact_Phone__c = sContactPhone,
                Priority = 'Severity 2 (24 hour SLA)',
                Status = 'Open',
                Reason_Description__c = e.Complaint_description__c,
                Solved_on_First_Call__c = 'Forwarded',
                Route_to__c = sRouteTo,
                EventId__c = e.Id
            );
            System.debug('CASE: ' + newCase);
            list_Cases.add(newCase);
    
        }
        
        System.debug('Inserting Cases...');
        insert list_Cases;
        System.debug('Cases Inserted.');
    }        
}