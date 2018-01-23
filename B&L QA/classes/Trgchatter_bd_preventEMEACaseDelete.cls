/**
* 
*   Test class for trigger "chatter_bd_preventEMEACaseDelete"
* 
*    Author         |Author-Email                   |Date       |Comment
*    ---------------|-------------------------------|-----------|--------------------------------------------------
*    S Cardinali    |samantha.cardinali@bausch.com  |09.04.2013 |First draft
*
*/
@isTest
private class Trgchatter_bd_preventEMEACaseDelete {
  static testMethod void testChatter_bd_preventEMEACaseDelete() {
     
    Id rtEMEACaseId = ClsUtility.getRecordTypeId('Case','EMEA Service Case');
    Id rtNACaseId = ClsUtility.getRecordTypeId('Case','NA Service Case');
    List<Case> list_cases = new List<Case>();
    Case oCase = new Case();
    oCase = new Case(RecordTypeId = rtEMEACaseId, Contact_Name__c = 'Trgchatter_bd_preventEMEACaseDelete', Domestic_or_International_Order__c = 'Domestic', 
                                        Solved_on_First_Call__c = 'Yes', Category__c = 'Customer Service', Reason__c = 'Account Change', 
                                        Status = 'Closed', SETID_Manual__c = 'UNKGD', Resolution__c = 'Test');
    list_cases.add(oCase);
    oCase = new Case(RecordTypeId = rtNACaseId, Contact_Name__c = 'Trgchatter_bd_preventEMEACaseDelete', Domestic_or_International_Order__c = 'Domestic', 
                                        Solved_on_First_Call__c = 'Yes', Category__c = 'Customer Service', Reason__c = 'Account Change', 
                                        Status = 'Closed', SETID_Manual__c = 'BLUSA', Resolution__c = 'Test');
    list_cases.add(oCase);
    insert list_cases;

    List<FeedItem> list_posts = new List<FeedItem>();
    for (Case c : list_cases) {
        FeedItem oPost = new FeedItem(ParentId = c.Id, Type = 'TextPost', Body = 'Approved');
        list_posts.add(oPost);
    }
    insert list_posts;

    try{
        delete list_posts.get(0);        
        delete list_posts.get(1);        
    } catch (Exception e) {
        if (e.getMessage() == 'You cannot delete Chatter posts from EMEA Service Cases, as these are used for Credit Approvals.') {
            //passed
        }
    }


  }
}