/*
 *    Author            |Author-Email                      |Date       |Comment
 *    ------------------|----------------------------------|-----------|--------------------------------------------------
 *    Samantha Cardinali|samantha.cardinali@bausch.com     |22.11.2010 |First draft
 *
 */
 
@isTest
private class CtrlRedirectOrderPageController_Test {
  static testMethod void testCtrlRedirectOrderPageController() {

    RecordType rtShipTo = [SELECT Id, Name FROM RecordType Where SObjectType = 'Account' and Name = 'Ship To Account' LIMIT 1]; 

    //Insert Account
    Account testACC = new Account (
            Name = 'SCTEST123',
            RecordTypeId = rtShipTo.Id,
            Ship_To_Id__c = 'SC345678',
            ShippingCity = 'Rochester',
            ShippingPostalCode = '12345',
            SetID__c = 'BLUSA',
            Legacy_system_id__c = 'BLUSASC345678'
    );
    insert testACC;
       
    //Insert Order_Header__c
    Order_Header__c testOH = new Order_Header__c (
            Account__c = testACC.Id,
            Ship_To_ID__c = 'SC345678',
            SETID__c = 'BLUSA',
            Business_Unit__c = 'VCLSU',
            Order_Date__c = System.today(),
            Caller_Name__c = 'SCTest',
            Order_Source__c = 'PHONE',
            Order_Group__c = 'STD',
            Customer_PO_No__c = 'Test-OH12345',
            Home_Delivery__c = 'No',
            Freight_Override__c = false,
            Order_Status__c = 'Open',
            SF_Order_Status__c = 'Saved',
            order_entered_by__c = 'CARDINS',
            Name = 'VCUCM-000000010',
            Ref_Order_Number__c = '1230a'
            );
    insert testOH;
          
    //Insert Order_Line_Item_c
    Order_Line_Item__c testOL = new Order_Line_Item__c (
            Order__c = testOH.Id,
            PS_Product_SKU__c = 'SDD+020090PKR',
            Quantity__c = 1,
            Item__c = 1,
            Ship_From__c = 'VCLSU',
            Patient_Ref_No__c = 'Test-OL12345',
            Customer_PO_No__c = 'Test-OL12345'
    );
    insert testOL;
          
    ApexPages.StandardController sc = new ApexPages.StandardController(testOH);
    CtrlRedirectOrderPageController ext = new CtrlRedirectOrderPageController(sc);
    ApexPages.currentPage().getParameters().put('id',testOH.id);
        ext.getRedir();
   } 
}