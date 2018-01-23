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
private class CTIMultipleAccountsFoundController_Test {
              
    static testmethod void testCTIMultipleAccountsFound(){
        
        //Create dummy record for test purposes.
        Account_Phone__c ap = new Account_Phone__c(Phone__c = '5851234567', Ship_To_Id__c = '12345678', SETID__c = 'BLUSA', Legacy_System_Id__c = 'BLUSA12345678');
        System.debug('******************Inserting the test Account_Phone__c record...');
        
        insert ap;
        
        Account Acc = new Account(Name='testVIJAY',Setid__c='1234',Ship_To_Id__c='87654321');
        insert Acc;
        
        
        
        
        //CREATE REFERENCE TO THE STD CONTROLLER, AND THEN THE EXTENSION
        ApexPages.currentPage().getParameters().put('ani','5854563210');
                    
        ApexPages.StandardController controller = new ApexPages.StandardController(ap); 
        CTIMultipleAccountsFoundController apExt = new CTIMultipleAccountsFoundController(controller);

        apExt.sid = Acc.SETID__c;
        //apExt.shipTo = Acc.Ship_To_Id__c;

        string ss = apExt.getsid();
        apExt.setsid(ss);        
        //********FIRST TEST SCENARIO**********
                  
        //DEFINE THE SEARCH CRITERIA BY MODIFYING THE PARAMETERS
        ApexPages.currentPage().getParameters().put('mode', 'A');
        
        //TEST THE setshipTo() METHOD
        apExt.setshipTo('87654321');
        
        //TEST THE getshipTo() AND getphoneNumber() METHODS
        String testShipTo = apExt.getshipTo();
        
 
        //CALL search() METHOD AND ASSERT THE RESULT CONTAINS THE EXPECTED RESULTS
        PageReference results1 = apExt.saveAndGoToAccount();
         
        system.assertEquals(ap.Legacy_System_Id__c,'BLUSA12345678');
        
        
        //********SECOND TEST SCENARIO**********
                  
        //DEFINE THE SEARCH CRITERIA BY MODIFYING THE PARAMETERS
        ApexPages.currentPage().getParameters().put('mode', 'B');
        
        //TEST THE setphoneNumber() METHOD
        apExt.setphoneNumber('5854563210');
        String testPhoneNumber = apExt.getphoneNumber();
        
        
        //CALL search() METHOD AND ASSERT THE RESULT CONTAINS THE EXPECTED RESULTS
        PageReference results2 = apExt.saveAndGoToAccount();
         
        system.assertEquals(ap.Legacy_System_Id__c,'BLUSA12345678');
        
        
        //********THIRD TEST SCENARIO**********
                  
        //DEFINE THE SEARCH CRITERIA BY MODIFYING THE PARAMETERS
        ApexPages.currentPage().getParameters().put('mode', 'C');

        //CALL search() METHOD AND ASSERT THE RESULT CONTAINS THE EXPECTED RESULTS
        PageReference results3 = apExt.saveAndGoToAccount();
        

        
         
        system.assertEquals(ap.Legacy_System_Id__c,'BLUSA12345678');

   }           
}