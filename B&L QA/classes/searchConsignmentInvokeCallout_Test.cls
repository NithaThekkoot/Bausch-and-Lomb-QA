/**     
    
    Developer       Email                       Date
    Vijay Singh     vijay.singh@aequor.com      10/26/2012
    
 */
@isTest
private class searchConsignmentInvokeCallout_Test {

             

    static testMethod void searchConsignmentInvokeCallout() { 
     if (!Test.isRunningTest()){
            
            Account acc = new Account();
            acc.Name = 'test';
            acc.Consignment_Inventory_BU__c = 'CLRCG';
            acc.Ship_To_Id__c  = '01051070';
            acc.SETID__c  = 'BLUSA';
            insert acc;
            
            Id usrId = [select Id from user where isActive=true limit 1].Id; 
            searchConsignmentInvokeCallout obj = new searchConsignmentInvokeCallout();
            obj.searchConsignment(
                acc.Ship_To_Id__c,
                'All',
                '12345',
                '23456789',
                system.today(),
                system.today(),
                acc.Consignment_Inventory_BU__c,
                string.valueOf(usrId),
                '2345',
                'xyz',
                acc.SETID__c,
                'location');
 
            obj.searchConsignmentProductGroup(acc.Ship_To_Id__c,acc.Consignment_Inventory_BU__c);  
           
           
                        
   } }
    static testMethod void searchConsignmentInvokeCallout1() {  
      if (!Test.isRunningTest()){
            
            Account acc = new Account();
            acc.Name = 'test';
            acc.Consignment_Inventory_BU__c = 'CLRCG';
            acc.Ship_To_Id__c  = '01051070';
            acc.SETID__c  = 'BLUSA';
            insert acc;
            searchConsignmentInvokeCallout obj = new searchConsignmentInvokeCallout();
 
            obj.searchConsignmentProductGroup(acc.Ship_To_Id__c,acc.Consignment_Inventory_BU__c);                 
           
                        
   } }

}