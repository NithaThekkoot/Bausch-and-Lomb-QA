/**
* 
*   Test class for trigger "orderLineItem_BI_setLineItemNumber"
* 
*    Author         |Author-Email                   |Date       |Comment
*    ---------------|-------------------------------|-----------|--------------------------------------------------
*    S Cardinali    |samantha.cardinali@bausch.com  |21.10.2009 |First draft
*
*/@isTest
private class TrgOrderLineItem_BI_setLineItemNumber {
    static testMethod void testOrderLineItem_BI_setLineItemNumber() {
        RecordType ShipToRC = [SELECT Id From RecordType Where Name = 'Ship To Account'];
        //Insert Account
        Account testAC = new Account (
            Name = 'SCTEST123',
            RecordType = ShipToRC
            );
        insert testAC;
        //Insert Order_Header__c
        Order_Header__c testOH = new Order_Header__c (
            Account__c = testAC.Id,
            SETID__c = 'NORSE',
            Business_Unit__c = 'NORSE',
            Order_Date__c = System.today(),
            Caller_Name__c = 'SCTest',
            Order_Source__c = 'PHONE',
            Order_Group__c = 'STD',
            Customer_PO_No__c = 'TestLineItemNoTrigger-OH12345',
            Home_Delivery__c = 'No',
            Freight_Override__c = false,
            Order_Status__c = 'Open',
            SF_Order_Status__c = 'Saved'
            );
        insert testOH;
        //Insert Order_Line_Item_c
        Order_Line_Item__c testOL = new Order_Line_Item__c (
            Order__c = testOH.Id,
            PS_Product_SKU__c = 'SDD+020090PKR',
            Quantity__c = 1,
            Item__c = 1,
            Ship_From__c = 'EURLC',
            Patient_Ref_No__c = 'TestLineItemNoTrigger-OL12345'
            );
        insert testOL;
        //Select Order ID
        Order_Header__c testOH1 = [Select Id, Name From Order_Header__c Where Customer_PO_No__c = 'TestLineItemNoTrigger-OH12345' Limit 1];
        //Select OrderLine
        Order_Line_Item__c testOL1 = [SELECT Order_Line_Number__c, Item__c From Order_Line_Item__c Where Patient_Ref_No__c = 'TestLineItemNoTrigger-OL12345' Limit 1];
        //Check Order_Line_Number__c = Order No + Line No
        System.assertEquals(testOL1.Order_Line_Number__c, testOH1.Name + '-' + String.valueOf(testOL1.Item__c));
    }
}