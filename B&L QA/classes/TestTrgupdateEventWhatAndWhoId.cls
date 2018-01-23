/*
   Credted by     Vijay Singh
   Email          vijay.singh@aequor.com    
*/
@isTest
private class TestTrgupdateEventWhatAndWhoId  {
  static testMethod void testupdateEventWhatAndWhoId() {
    
    Account acc = new Account(Name='test');
    insert acc;
        
    Contact c = new Contact(Accountid=acc.id,LastName='Singh');
    insert c;
    
    Account_Contact_Junction__c obj = new Account_Contact_Junction__c(Account__c=acc.Id,Contact__c=c.Id);
    insert obj ;
    
    Event oEvent1 = new Event();
       
    oEvent1.WhatId = obj.Id; 
    oEvent1.WhoId = c.Id;     
    oEvent1.ActivityDate = date.today();
    oEvent1.StartDateTime = System.now();
    oEvent1.EndDateTime = System.now();
    oEvent1.Type = 'Visit';
    oEvent1.IsReminderSet = false;        
    insert oEvent1;    
    updateEventInfo.updateEventWhatAndWhoId = true;
}
}