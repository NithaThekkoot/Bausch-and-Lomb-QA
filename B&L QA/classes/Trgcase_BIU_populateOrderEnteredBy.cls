/**
* 
*   Test class for trigger "case_BIU_populateOrderEnteredBy"
* 
*    Author         |Author-Email                   |Date       |Comment
*    ---------------|-------------------------------|-----------|--------------------------------------------------
*    S Cardinali    |samantha.cardinali@bausch.com  |04.08.2010 |First draft
*
*/
@isTest
private class Trgcase_BIU_populateOrderEnteredBy {
  static testMethod void testcase_BIU_populateOrderEnteredBy() {

    RecordType rtShipTo = [SELECT Id From RecordType Where Name = 'Ship To Account' And SObjectType = 'Account' limit 1];
    RecordType rtEMEA = [Select Id, Name From RecordType Where Name = 'EMEA Service Case' And SObjectType = 'Case' limit 1];
    
    //Insert Account
    Account testACC = new Account (
        Name = 'SCTEST123',
        RecordType = rtShipTo,
        Ship_To_Id__c = '12345678',
        ShippingCity = 'London',
        ShippingPostalCode = '12345'
        );
    insert testACC;
        
    Account testAccSelect = [Select Id, Name, OwnerId, Owner.Name from Account where Id =: testAcc.Id];
        
    //Insert Order_Header__c
      Order_Header__c testOH = new Order_Header__c (
        Account__c = testACC.Id,
        Ship_To_ID__c = '12345678',
        SETID__c = 'NORSE',
        Business_Unit__c = 'NORSE',
        Order_Date__c = System.today(),
        Caller_Name__c = 'SCTest',
        Order_Source__c = 'PHONE',
        Order_Group__c = 'STD',
        Home_Delivery__c = 'No',
        Freight_Override__c = false,
        Order_Status__c = 'Open',
        SF_Order_Status__c = 'Saved',
        order_entered_by__c = 'CARDINS',
        Name = 'NORSE-000000010',
        legacy_system_id__c = 'NORSE000000010'
        );
      insert testOH;
      
      //Insert Case
      Case testCase = new Case (
          Origin = 'Web', 
          RecordTypeId = rtEMEA.id, 
          AccountId = testACC.id, 
          Contact_Name__c = 'EMEA Tester', 
          Domestic_or_International_Order__c = 'Domestic', 
          Solved_on_First_Call__c = 'Yes', 
          Category__c = 'Customer Service', 
          Reason__c = 'Account Change', 
          Status = 'Open',
          Order__c = 'NORSE-0000000010'
      );
      insert testCase;
      
    }
}