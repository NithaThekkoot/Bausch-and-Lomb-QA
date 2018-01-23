/*
* 
*   Test class for trigger "ASRSales_BIU_setAccountID"
* 
*    Author         |Author-Email                   |Date       |Comment
*    ---------------|-------------------------------|-----------|--------------------------------------------------
*    S Cardinali    |samantha.cardinali@bausch.com  |11.03.2010 |First draft
*
*/

@isTest
private class TrgASRSales_BIU_setAccountID{
  static testMethod void testASRSales_BIU_setAccountID() {

      //Insert Account
      RecordType rtShipTo = [SELECT Id From RecordType Where Name = 'Ship To Account' Limit 1];
      Account testAccount = new Account (
        Name = 'SCTEST123',
        RecordType = rtShipTo,
        Legacy_System_ID__c = 'UNKGD00123456'
      );
      try{
        insert testAccount;
      } catch(Exception e) {
        System.debug('Error adding Account: ' + e.getMessage());
      }

      //Insert ASR Sales Record
      ASR_Sales__c testSales = new ASR_Sales__c (
        Year__c = '2010',
        Product_Level_Id__c = 'ABC12345',
        Legacy_System_ID__c = 'UNKGD00123456'
      );
      try{
        insert testSales;
      } catch(Exception e) {
        System.debug('Error adding testSales: ' + e.getMessage());
      }

      //Check AccountID populated correctly
      ASR_Sales__c sInsertedSales = [Select Id, Account__c From ASR_Sales__c Where Id = :testSales.Id];
      System.assertEquals(testAccount.Id, sInsertedSales.Account__c);
    
   }
}