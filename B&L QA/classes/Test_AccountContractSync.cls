@isTest
private class Test_AccountContractSync {

 static testMethod void testAccountContractSyncTrigger() {
        //Test new Contact with Account
        Account a1 = new Account(name = 'Test Account1', Doorway_Id__c ='test1', Primary_Ship_To__c = '12345678');
        insert a1;
                     
        Contract c = new Contract (Status = 'Draft',ContractTerm=12,StartDate=System.today(), AccountId = a1.id,CurrencyIsoCode='USD');
        insert c; //<-- Invoke Trigger
        
      //Verify junction record was created
      Account_Contract_Junction__c ac1 = [SELECT Account__c FROM Account_Contract_Junction__c
                        WHERE Account__c = :a1.id and Contract__c = :c.id];
      System.assertEquals(c.AccountId, ac1.Account__c); 
      
      
      //Test Account update on Contact
        Account a2 = new Account(name = 'Test Account2', Doorway_Id__c ='test2', Primary_Ship_To__c = '12345679');
        insert a2; 
             
        c.AccountId = a2.id;
        update c; //<-- Invoke Trigger
        
      //Verify junction record was created
      Account_Contract_Junction__c ac2 = [SELECT Account__c FROM Account_Contract_Junction__c
                        WHERE Account__c = :a2.id and Contract__c = :c.id];
      System.assertEquals(c.AccountId, ac2.Account__c);       


    //Test Account update on contact where junction record already exists
    c.AccountId = a1.id;
        update c; //<-- Invoke Trigger
        
      //Verify junction record was created 
      Integer Count  = [SELECT count() FROM Account_Contract_Junction__c
                WHERE Account__c = :a1.id and Contract__c = :c.id];
      System.assertEquals(1, count);       
              
    }
}