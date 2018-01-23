/*
* 
*   Test class for triggers "priceAgreementProduct_BI_populateAcct" and "priceAgreement_BIU_populateSearchInfo"
* 
*    Author         |Author-Email                   |Date       |Comment
*    ---------------|-------------------------------|-----------|--------------------------------------------------
*    S Cardinali    |samantha.cardinali@bausch.com  |14.12.2012 |First draft
*
*/

@isTest
private class TrgPriceAgreements_setAccountAndSearch{
  static testMethod void TrgPriceAgreementTriggers_setAccountAndSearch() {

      //Insert Account
      ID rtShipTo = ClsUtility.getRecordTypeId('Account','Ship To Account');
      List<Account> list_Accounts = new List<Account>();
      Account testAccount1 = new Account(Name = 'SCTESTAccount123543',RecordTypeId = rtShipTo,Legacy_System_ID__c = 'UNKGD001234560');
      list_Accounts.add(testAccount1);
      Account testAccount2 = new Account(Name = 'SCTESTAccount543123',RecordTypeId = rtShipTo,Legacy_System_ID__c = 'UNKGD901234561');
      list_Accounts.add(testAccount2);
      try{
        insert list_Accounts;
      } catch(Exception e) {
        System.debug('Error adding Account: ' + e.getMessage());
      }

      //Insert Price Agreement
      Pricing_Agreement__c testPA = new Pricing_Agreement__c (
        Name = 'ABC123DEF456',
        Account__c = list_Accounts.get(0).Id
      );
      try{
        insert testPA;
      } catch(Exception e) {
        System.debug('Error adding testPA: ' + e.getMessage());
      }
      //Insert Price Agreement Product
      Price_Agreement_Product__c testPAP = new Price_Agreement_Product__c (
        Name = 'PAP123ABC345',
        Pricing_Agreement__c = testPA.Id
      );
      try{
        insert testPAP;
      } catch(Exception e) {
        System.debug('Error adding testPAP: ' + e.getMessage());
      }
      //Update PA account
      Pricing_Agreement__c updatePA = [SELECT Id, Account__c FROM Pricing_Agreement__c WHERE Id = :testPA.Id];
      updatePA.Account__c = list_Accounts.get(1).Id;
      Update updatePA;
      //Update PA account to none
      Pricing_Agreement__c updatePAAgain = [SELECT Id, Account__c FROM Pricing_Agreement__c WHERE Id = :testPA.Id];
      updatePAAgain.Account__c = Null;
      Update updatePAAgain;
    }
}