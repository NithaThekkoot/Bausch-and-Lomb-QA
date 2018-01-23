/**
* 
*   Test class for trigger "shippingHistory_BIU_populateMatchKey"
* 
*    Author         |Author-Email                   |Date       |Comment
*    ---------------|-------------------------------|-----------|--------------------------------------------------
*    S Cardinali    |samantha.cardinali@bausch.com  |21.10.2009 |First draft
*
*/@isTest
private class TrgShippingHistory_BIU_populateMatchKey {
    static testMethod void testShippingHistory_BIU_populateMatchKey() {
        //Select an order
        //Order_Header__c sampleOrder = [SELECT o.Id, o.Business_Unit__c, o.Ship_To_ID__c From Order_Header__c o Limit 1];
        //Select a line
        //Order_Line_Item__c sampleOrderLine = [SELECT Id From Order_Line_Item__c Where Order__c = :sampleOrder.Id Limit 1];
        
        RecordType ShipToRC = [SELECT Id From RecordType Where Name = 'Ship To Account'];
        //Insert Account
        Account testAC = new Account (
            Name = 'SCTEST123',
            RecordType = ShipToRC
            );
        insert testAC;
        
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
        //Select Order ID
        //Order_Header__c testOH1 = [Select Id, Name From Order_Header__c Where Customer_PO_No__c = 'TestLineItemNoTrigger-OH12345' Limit 1];
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
        //Insert dummy ship history record
        Shipping_History__c testShipHist = new Shipping_History__c (
            Shipment_Date__c = System.today(),
            Signed_for_By__c = 'SCTestMatchKeyTrigger12345',
            Legacy_System_ID__c = testOH.Business_Unit__c + testOH.Ship_To_ID__c,
            Shipment_Status__c = 'On Hold',
            Quantity_Allocated__c = 2,
            Quantity_Backordered__c = 0,
            Quantity_Shipped__c = 0,
            Order__c = testOH.Id,
            Order_Line_Item__c = testOL.Id
            );
        insert testShipHist;
        //Test Matchkey populated
        Shipping_History__c testShipHist2 = [SELECT Id, MatchKey__c FROM Shipping_History__c WHERE Signed_for_By__c = 'SCTestMatchKeyTrigger12345'];
        System.assertEquals(testShipHist2.MatchKey__c, (testShipHist.Order__c + '||' + testShipHist.Order_Line_Item__c));    
        //Insert 2nd dummy ship history record
        Shipping_History__c testShipHist3 = new Shipping_History__c (
            Shipment_Date__c = System.today(),
            Signed_for_By__c = 'SCTestValidationMatchKeyTrigger12345',
            Legacy_System_ID__c = testOH.Business_Unit__c + testOH.Ship_To_ID__c,
            Shipment_Status__c = 'On Hold',
            Quantity_Allocated__c = 2,
            Quantity_Backordered__c = 0,
            Quantity_Shipped__c = 0
            );
        //Test Validation Error Produced
        try {
            insert testShipHist3;
        } catch (DMLException e) {
            System.assert(e.getMessage().contains('Order and/or Order_Line_Item references are empty.'),'Validation message test failed. Msg: ' + e.getMessage());
        }
    }
}