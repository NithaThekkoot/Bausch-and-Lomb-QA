/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class testAccountContactSync {

 static testMethod void testAccountContactSyncTrigger() {
        //Test new Contact with Account
        Account a1 = new Account(name = 'Test Account1', Doorway_Id__c ='test1', Primary_Ship_To__c = '12345678');
        insert a1;
                     
        Contact c = new Contact(lastname = 'Test', AccountId = a1.id);
        insert c; //<-- Invoke Trigger
        
    	//Verify junction record was created
    	Account_Contact_Junction__c ac1 = [SELECT Account__c FROM Account_Contact_Junction__c
    									  WHERE Account__c = :a1.id and Contact__c = :c.id];
    	System.assertEquals(c.AccountId, ac1.Account__c); 
    	
    	
    	//Test Account update on Contact
        Account a2 = new Account(name = 'Test Account2', Doorway_Id__c ='test2', Primary_Ship_To__c = '12345679');
        insert a2; 
           	
        c.AccountId = a2.id;
        update c; //<-- Invoke Trigger
        
    	//Verify junction record was created
    	Account_Contact_Junction__c ac2 = [SELECT Account__c FROM Account_Contact_Junction__c
    									  WHERE Account__c = :a2.id and Contact__c = :c.id];
    	System.assertEquals(c.AccountId, ac2.Account__c);     	


		//Test Account update on contact where junction record already exists
		c.AccountId = a1.id;
        update c; //<-- Invoke Trigger
        
    	//Verify junction record was created 
    	Integer Count  = [SELECT count() FROM Account_Contact_Junction__c
    					  WHERE Account__c = :a1.id and Contact__c = :c.id];
    	System.assertEquals(1, count);     	
    	    		
    }
}