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
 *
 *
 *      Author           |Author-Email                      |Date       |Comment
 *      -----------------|----------------------------------|-----------|--------------------------------------------------
 *      Dennis Flüchter  |dennis.fluechter@itbconsult.com   |21.10.2009 |First draft
 *      Dennis Flüchter  |dennis.fluechter@itbconsult.com   |09.08.2010 |Modifications for BU picklist, CustomerPO/PatientRef
 *      Dan Wood         |Dan.Wood@Bausch.com               |18.04.2013 |Create Case link - add Invoice and CarrierID GCM210636
 *
 */
 
@isTest 
private class CtrlOrderTracking_Test {

    static testMethod void CtrlOrderTracking_TestNew() {
        System.debug('TEST NEW');
        
        //RecordType ShipToRC = [SELECT Id From RecordType Where Name = 'Ship To Account' limit 1];
        Id ShipToRC = ClsUtility.getRecordTypeId('Account','Ship To Account');
        
        //Insert Account
        Account testACC = new Account (
            Name = 'DFTEST123',
            RecordTypeId = ShipToRC,
            Ship_To_Id__c = 'DF12345',
            ShippingCity = 'London',
            ShippingPostalCode = '12345'
            );
        insert testACC;
        
        Account testAccSelect = [Select Id, Name, OwnerId, Owner.Name from Account where Id =: testAcc.Id];
        System.debug('OWNER: ' + testAccSelect.Owner.Name);
        
        //Insert Order_Header__c
            Order_Header__c testOH = new Order_Header__c (
            Account__c = testACC.Id,
            Ship_To_ID__c = 'DF12345',
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
            SF_Order_Status__c = 'Saved',
            order_entered_by__c = 'DENNIS',
            Name = 'VCUCM-000000010',
            Ref_Order_Number__c = '1230a'
            );
            insert testOH;
            
            Order_Header__c testOHSelect = [Select Id, Name, OwnerId, Owner.Name from Order_Header__c where Id =: testOH.Id];
            System.debug('ORDER NAME: ' + testOHSelect.Name);
            
            
            //Insert Order_Line_Item_c
            Order_Line_Item__c testOL = new Order_Line_Item__c (
            Order__c = testOH.Id,
            PS_Product_SKU__c = 'SDD+020090PKR',
            Lot_Serial_ID__c = 'ABC123',
            Quantity__c = 1,
            Item__c = 1,
            Ship_From__c = 'EURLC',
            Patient_Ref_No__c = 'TestLineItemNoTrigger-OL12345',
            Customer_PO_No__c = 'TestLineItemNoTrigger-OL12345'
            );
            insert testOL;
            
            Order_Line_Item__c testOlSelect = [Select Id, Name from Order_Line_Item__c where Id =: testOL.Id];
            System.debug('OLI NAME: ' + testOLSelect.Name);
                    
    }
    
    
    static testMethod void CtrlOrderTracking_Test() {
        
        //RecordType ShipToRC = [SELECT Id From RecordType Where Name = 'Ship To Account' limit 1];
        Id ShipToRC = ClsUtility.getRecordTypeId('Account','Ship To Account');
        
        List<Shipping_History__c> list_shipments = new List<Shipping_History__c>();
        
        Profile pUserProfile = [SELECT Id From Profile Where Name = 'BL: System Administrator' Limit 1];  
        //Create a test user
        User testUser = new User (
            Alias = 'testus',
            Email = 'testuser123@bausch.com',
            Emailencodingkey = 'UTF-8',
            Lastname = 'User',
            Firstname = 'Test',
            Languagelocalekey = 'de',
            Localesidkey = 'de',
            Profileid = pUserProfile.Id,
            isActive = true,
            Timezonesidkey = 'America/New_York',
            Username = 'testuser123@bausch.com'
        );
        
        insert testUser;
        
        List<Product2> list_products = [Select Id, Name from Product2 where isActive = true limit 10];      
        
        //Insert Account
        Account testACC = new Account (
            Name = 'DFTEST123',
            RecordTypeId = ShipToRC,
            Ship_To_Id__c = 'DF12345',
            ShippingCity = 'London',
            ShippingPostalCode = '12345'
            );
        insert testACC;
        
        //System.runAs(testUser) {        
            //Insert Order_Header__c
            Order_Header__c testOH = new Order_Header__c (
                Account__c = testACC.Id,
                Ship_To_ID__c = 'DF12345',
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
                SF_Order_Status__c = 'Saved',
                order_entered_by__c = 'DENNIS',
                Name = 'VCUCM-000000001',
                Ref_Order_Number__c = '1231a'
                );
            insert testOH;
            
            Order_Header__c OH = [Select Id, OwnerId, Owner.Name from Order_Header__c where Id =: testOH.Id];
            System.debug('OWNER: ' + OH.Owner.Name);
            
            
            //Insert Order_Line_Item_c
            Order_Line_Item__c testOL = new Order_Line_Item__c (
                Order__c = testOH.Id,
                PS_Product_SKU__c = list_products[0].Id,                
                Quantity__c = 1,
                Item__c = 1,
                Ship_From__c = 'EURLC',
                Patient_Ref_No__c = 'TestLineItemNoTrigger-OL12345',
                Customer_PO_No__c = 'TestLineItemNoTrigger-OL12345'
                );
            insert testOL;
            
            Order_Line_Item__c testOL2 = new Order_Line_Item__c (
                Order__c = testOH.Id,
                PS_Product_SKU__c = list_products[1].Id,
                //PS_Product_SKU__c = 'SDD+020030PKR',
                Quantity__c = 1,
                Item__c = 1,
                Ship_From__c = 'EURLC',
                Patient_Ref_No__c = 'TestLineItemNoTrigger-OL12345',
                Customer_PO_No__c = 'TestLineItemNoTrigger-OL12345'
                );
            insert testOL2;
            
            Order_Line_Item__c testOL3 = new Order_Line_Item__c (
                Order__c = testOH.Id,
                PS_Product_SKU__c = list_products[2].Id,
                //PS_Product_SKU__c = 'SDD+020010PKR',
                Quantity__c = 1,
                Item__c = 1,
                Ship_From__c = 'EURLC',
                Patient_Ref_No__c = 'TestLineItemNoTrigger-OL12345',
                Customer_PO_No__c = 'TestLineItemNoTrigger-OL12345'
                );
            insert testOL3;
            
            Shipping_History__c testSH = new Shipping_History__c (
                Shipment_Date__c = System.today(),
                Signed_for_By__c = 'SCTestMatchKeyTrigger12345',
                Legacy_System_ID__c = testOH.Business_Unit__c + testOH.Ship_To_ID__c + '1',
                Shipment_Status__c = 'On Hold',
                Pack_List_No__c = 'DF1234',
                Invoice_No__c = 'IDF1234',
                Quantity_Allocated__c = 2,
                Quantity_Backordered__c = 0,
                Quantity_Shipped__c = 0,
                Order__c = testOH.Id,
                Order_Line_Item__c = testOL.Id
                );
            
            insert testSH;
            list_shipments.add(testSH);
            
            Shipping_History__c testSH2 = new Shipping_History__c (
                Shipment_Date__c = System.today(),
                Signed_for_By__c = 'SCTestMatchKeyTrigger12345',
                Legacy_System_ID__c = testOH.Business_Unit__c + testOH.Ship_To_ID__c + '2',
                Shipment_Status__c = 'On Hold', 
                Pack_List_No__c = 'DF1234',
                Invoice_No__c = 'IDF1234',
                Quantity_Allocated__c = 2,
                Quantity_Backordered__c = 0,
                Quantity_Shipped__c = 0,
                Order__c = testOH.Id,
                Order_Line_Item__c = testOL2.Id
                );
            
            insert testSH2;
            list_shipments.add(testSH2);
            
            Shipping_History__c testSH3 = new Shipping_History__c (
                Shipment_Date__c = System.today(),
                Signed_for_By__c = 'SCTestMatchKeyTrigger12345',
                Legacy_System_ID__c = testOH.Business_Unit__c + testOH.Ship_To_ID__c + '3',
                Shipment_Status__c = 'On Hold',
                Pack_List_No__c = 'DF1235',
                Invoice_No__c = 'IDF1235',
                Quantity_Allocated__c = 2,
                Quantity_Backordered__c = 0,
                Quantity_Shipped__c = 0,
                Order__c = testOH.Id,
                Order_Line_Item__c = testOL3.Id
                );
            
            insert testSH3;
            list_shipments.add(testSH3);
            
            Shipping_History__c testSH4 = new Shipping_History__c (
                Shipment_Date__c = System.today(),
                Signed_for_By__c = 'SCTestMatchKeyTrigger12345',
                Legacy_System_ID__c = testOH.Business_Unit__c + testOH.Ship_To_ID__c + '4',
                Shipment_Status__c = 'On Hold',
                Pack_List_No__c = 'DF1236',
                Invoice_No__c = 'IDF1236',
                Quantity_Allocated__c = 2,
                Quantity_Backordered__c = 0,
                Quantity_Shipped__c = 0,
                Order__c = testOH.Id,
                Order_Line_Item__c = testOL3.Id
                );
            
            insert testSH4;
            list_shipments.add(testSH4);
            
            //second sequence
            Order_Header__c testOH2 = new Order_Header__c (
                Account__c = testACC.Id,
                Ship_To_ID__c = 'DF12345',
                SETID__c = 'NORSE',
                Business_Unit__c = 'NORSE',
                Order_Date__c = System.today() - 1,
                Caller_Name__c = 'SCTest',
                Order_Source__c = 'PHONE',
                Order_Group__c = 'STD',
                Customer_PO_No__c = 'TestLineItemNoTrigger-OH12345',
                Home_Delivery__c = 'No',
                Freight_Override__c = false,
                Order_Status__c = 'Open',
                SF_Order_Status__c = 'Saved',
                order_entered_by__c = 'DENNIS',
                Name = 'VCUCM-000000002',
                Ref_Order_Number__c = '1232a'
                );
            insert testOH2;
            //Insert Order_Line_Item_c
            Order_Line_Item__c testOL4 = new Order_Line_Item__c (
                Order__c = testOH2.Id,
                PS_Product_SKU__c = list_products[0].Id,
                //PS_Product_SKU__c = 'SDD+020090PKR',
                Quantity__c = 1,
                Item__c = 1,
                Ship_From__c = 'EURLC',
                Patient_Ref_No__c = 'TestLineItemNoTrigger-OL12345',
                Customer_PO_No__c = 'TestLineItemNoTrigger-OL12345'
                );
            insert testOL4;
            
            Order_Line_Item__c testOL5 = new Order_Line_Item__c (
                Order__c = testOH2.Id,
                PS_Product_SKU__c = list_products[1].Id,
                //PS_Product_SKU__c = 'SDD+020030PKR',
                Quantity__c = 1,
                Item__c = 1,
                Ship_From__c = 'EURLC',
                Patient_Ref_No__c = 'TestLineItemNoTrigger-OL12345',
                Customer_PO_No__c = 'TestLineItemNoTrigger-OL12345'
                );
            insert testOL5;
            
            Order_Line_Item__c testOL6 = new Order_Line_Item__c (
                Order__c = testOH2.Id,
                PS_Product_SKU__c = list_products[2].Id,
                //PS_Product_SKU__c = 'SDD+020010PKR',
                Quantity__c = 1,
                Item__c = 1,
                Ship_From__c = 'EURLC',
                Patient_Ref_No__c = 'TestLineItemNoTrigger-OL12345',
                Customer_PO_No__c = 'TestLineItemNoTrigger-OL12345'
                );
            insert testOL6;
            
            Shipping_History__c testSH5 = new Shipping_History__c (
                Shipment_Date__c = System.today(),
                Signed_for_By__c = 'SCTestMatchKeyTrigger12345',
                Legacy_System_ID__c = testOH.Business_Unit__c + testOH.Ship_To_ID__c + '5',
                Shipment_Status__c = 'On Hold',
                Pack_List_No__c = 'DF1237',
                Invoice_No__c = 'IDF1237',
                Quantity_Allocated__c = 2,
                Quantity_Backordered__c = 0,
                Quantity_Shipped__c = 0,
                Order__c = testOH2.Id,
                Order_Line_Item__c = testOL4.Id
                );
            
            insert testSH5;
            list_shipments.add(testSH5);
            
            Shipping_History__c testSH6 = new Shipping_History__c (
                Shipment_Date__c = System.today(),
                Signed_for_By__c = 'SCTestMatchKeyTrigger12345',
                Legacy_System_ID__c = testOH.Business_Unit__c + testOH.Ship_To_ID__c + '6',
                Shipment_Status__c = 'On Hold', 
                Pack_List_No__c = 'DF1237',
                Invoice_No__c = 'IDF1237',
                Quantity_Allocated__c = 2,
                Quantity_Backordered__c = 0,
                Quantity_Shipped__c = 0,
                Order__c = testOH2.Id,
                Order_Line_Item__c = testOL5.Id
                );
            
            insert testSH6;
            list_shipments.add(testSH6);
            
            Shipping_History__c testSH7 = new Shipping_History__c (
                Shipment_Date__c = System.today(),
                Signed_for_By__c = 'SCTestMatchKeyTrigger12345',
                Legacy_System_ID__c = testOH.Business_Unit__c + testOH.Ship_To_ID__c + '7',
                Shipment_Status__c = 'On Hold',
                Pack_List_No__c = 'DF1238',
                Invoice_No__c = 'IDF1238',
                Quantity_Allocated__c = 2,
                Quantity_Backordered__c = 0,
                Quantity_Shipped__c = 0,
                Order__c = testOH2.Id,
                Order_Line_Item__c = testOL6.Id
                );
            
            insert testSH7;
            list_shipments.add(testSH7);
            
            Shipping_History__c testSH8 = new Shipping_History__c (
                Shipment_Date__c = System.today(),
                Signed_for_By__c = 'SCTestMatchKeyTrigger12345',
                Legacy_System_ID__c = testOH.Business_Unit__c + testOH.Ship_To_ID__c + '8',
                Shipment_Status__c = 'On Hold',
                Pack_List_No__c = 'DF1238', 
                Invoice_No__c = 'IDF1238',           
                Quantity_Allocated__c = 2,
                Quantity_Backordered__c = 0,
                Quantity_Shipped__c = 0,
                Order__c = testOH2.Id,
                Order_Line_Item__c = testOL6.Id
                );
            
            insert testSH8;
            list_shipments.add(testSH8);
            
            Shipping_History__c testSH9 = new Shipping_History__c (
                Shipment_Date__c = System.today(),
                Signed_for_By__c = 'SCTestMatchKeyTrigger12345',
                Legacy_System_ID__c = testOH.Business_Unit__c + testOH.Ship_To_ID__c + '9',
                Shipment_Status__c = 'On Hold',
                Pack_List_No__c = 'DF1230', 
                Invoice_No__c = 'IDF1230',           
                Quantity_Allocated__c = 2,
                Quantity_Backordered__c = 0,
                Quantity_Shipped__c = 0,
                Order__c = testOH2.Id,
                Order_Line_Item__c = testOL6.Id
                );
            
            insert testSH9;
            list_shipments.add(testSH9);
            
            //second sequence
            Order_Header__c testOH3 = new Order_Header__c (
                Account__c = testACC.Id,
                Ship_To_ID__c = 'DF12345',
                SETID__c = 'NORSE',
                Business_Unit__c = 'VCUCM',
                Order_Date__c = System.today() - 2,
                Caller_Name__c = 'SCTest',
                Order_Source__c = 'PHONE',
                Order_Group__c = 'STD',
                Customer_PO_No__c = 'TestLineItemNoTrigger-OH12345',
                Home_Delivery__c = 'No',
                Freight_Override__c = false,
                Order_Status__c = 'Open',
                SF_Order_Status__c = 'Saved',
                order_entered_by__c = 'DENNIS',
                Name = 'VCUCM-000000003',
                Ref_Order_Number__c = '123b'
                );
            insert testOH3;
            
            //Insert Order_Line_Item_c
            Order_Line_Item__c testOL10 = new Order_Line_Item__c (
                Order__c = testOH3.Id,
                PS_Product_SKU__c = list_products[3].Id,
                //PS_Product_SKU__c = 'SDD+020090PKR',
                Quantity__c = 1,
                Item__c = 1,
                Ship_From__c = 'EURLC',
                Patient_Ref_No__c = 'TestLineItemNoTrigger-OL12345',
                Customer_PO_No__c = 'TestLineItemNoTrigger-OL12345'
                );
            insert testOL10;
            
            /*query records for order search*/
            /*List<Shipping_History__c> list_shipments = [Select s.Id, s.Invoice_No__c, s.Order__c, s.Order_Line_Item__c, s.Pack_List_No__c, 
                s.Tracking_No__c, s.Order__r.Ship_To_ID__c from Shipping_History__c s 
                where Pack_List_No__c != null limit 5];
            System.debug('--> Shipments found: ' + list_shipments.size());
            */
            
            /*query Account data*/
            /*
            Account acc = [Select a.Bill_To__c, a.Bill_To_Address_1__c, a.Bill_To_Address_2__c, a.Bill_To_Credit_Hold__c, 
                a.Bill_To_Credit_Hold_Flag__c, a.Bill_To_Name__c, a.Bill_To_SETID_CUSTID__c, a.BillingCity, a.BillingCountry, 
                a.BillingPostalCode, a.BillingState, a.BillingStreet, a.Business_Unit__c, a.CurrencyIsoCode, a.Description, a.Fax, 
                a.Id, a.Name, a.Phone, a.Preferred_Carrier__c, a.Preferred_Ship_Via__c, a.Primary_Ship_To__c, a.RecordTypeId, 
                a.RecordType.Name, a.SETID__c, a.Ship_To_Address_1__c, a.Ship_To_Address_2__c, a.Ship_To_Id__c, a.ShippingCity, 
                a.ShippingCountry, a.ShippingPostalCode, a.ShippingState, a.ShippingStreet from Account a 
                where a.Ship_To_Id__c = : list_shipments[0].Order__r.Ship_To_ID__c limit 1];
            //a.RecordType.Name = 'Ship To Account' and a.SETID__c = 'NORSE' 
            System.debug('--> Account found: ' + acc.Name);
            System.debug('--> If of Account found: ' + acc.Id);
            */
            
            PageReference pageRef = new PageReference('/apex/CtrlOrderTracking_Search');
            //?retURL=%2Fa0H%2Fo&save_new=1&setid=&sfdc.override=1'
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('setId', testACC.Ship_To_Id__c);
                    
            //define Controller     
            //ApexPages.StandardController Controller = new ApexPages.StandardController();
            
            CtrlOrderTracking clsTest = new CtrlOrderTracking();                
            
            /*simulate FindAccount*/
            clsTest.searchField = testACC.Name;
            clsTest.SOSLsearch();
            clsTest.RowClicked();
            
            /*simulate search without search criteria and too huge date range*/
            clsTest.clearSearchFields();
            clsTest.dummyHeaderFrom.Order_Date__c = Date.today().addDays(-30);
            clsTest.search();
            clsTest.clearSearchFields();
            clsTest.search();

            /*simulate customerpoline search*/            
            clsTest.clearSearchFields();            
            clsTest.shipToId = testACC.Ship_To_Id__c;            
            clsTest.customerPoLine = 'TestLineItemNoTrigger-OL12345';            
            clsTest.dummyHeaderFrom.Order_Date__c = Date.today().addDays(7);            
            clsTest.dummyHeaderTo.Order_Date__c = Date.today();            
            clsTest.search();
            
            clsTest.shipToId = testACC.Ship_To_Id__c;
            /*simulate to create a new order*/
            clsTest.directToOrderCreation();
            
            Integer i = -1; //count variable for forLoop
            //for (Shipping_History__c ship : list_shipments){
            System.debug('--> before shipment for loop');
            for (Shipping_History__c ship : list_shipments){
                i++;
                System.debug('--> # Ship i: ' + i);
                
                /*set search fields for order header*/
                System.debug('QUERY OH for SH');
                Order_Header__c header = [Select Id, Name, Customer_PO_No__c, Order_Entered_By__c, Ref_Order_Number__c from Order_Header__c where Id = : ship.Order__c];
                
                clsTest.dummyHeaderFrom.Order_Date__c = Date.today() - 1; //Date.newInstance(2000, 1, 1);           
                clsTest.shipToAccountName = testACC.Name;
                clsTest.shipToId = testACC.Ship_To_Id__c;
                clsTest.shipToCity = testACC.ShippingCity;
                clstest.shipToPostCode = testACC.ShippingPostalCode;
                
                clsTest.dummyHeaderFrom.Business_Unit__c = 'VCUCM';
                
                clsTest.businessUnit = 'VCUCM'; //added 9th Aug 2010
                clsTest.orderNo = header.Name.replace('VCUCM-', '');                
                System.debug('Header Name: ' + header.Name);
                
                            
                clsTest.invoiceNumber = ship.Invoice_No__c;
                clsTest.packListNo = ship.Pack_List_No__c;
                
                clsTest.refOrderNumber = header.Ref_Order_Number__c;
                
                /*query according line item and set line item search fields*/
                Order_Line_Item__c oli = [Select o.Customer_PO_No__c, o.Id, o.Patient_Ref_No__c, o.Product_SKU__c, 
                    o.Product_SKU__r.Name from Order_Line_Item__c o where Id = :ship.Order_Line_Item__c limit 1];
                
                clsTest.SKU = oli.Product_SKU__r.Name;
                
                System.debug('oli.Customer_PO_No__c: ' + oli.Customer_PO_No__c);
                clsTest.customerPO = header.Customer_PO_No__c;
                
                clstest.patientReference = oli.Customer_PO_No__c; //oli.Patient_Ref_No__c;
                
                clsTest.enteredBy = header.Order_Entered_By__c;
                            
                //if (i > 0 && math.mod(i, 3) == 0){
                    clsTest.search();
                //}
                
                clsTest.expandAll();
                clsTest.next();
                clsTest.previous();
                clsTest.last();
                clsTest.first();
                clsTest.expandAll();
                clsTest.modifySearch();
                clsTest.clearSearchFields(); 
                clsTest.directToOrderCreation(); 
                clsTest.getAccordingHeaderList();
                clsTest.getCaseLinkAccount();
                clsTest.getCaseLinkOrder();
                clsTest.getCaseLinkProduct();
                clsTest.getCaseLinkShipment();
                clsTest.getCaseLinkShippedFrom();
                clsTest.getCaseLinkOrderDate();
                clsTest.getCaseLinkSerialLotID();
                clsTest.getCaseLinkInvoice();
                clsTest.getCaseLinkCarrierID();
                clsTest.getPossibleBusinessUnits();
                clsTest.getTreeHeadline();
                clsTest.getTree();
                clsTest.getRecordStatus();
                clsTest.getListSize();
                clsTest.getSFDCUrl();
                clsTest.getexpandStyle();
                clsTest.getstartPic();
                clsTest.getPSConsignmentLink();
                clsTest.getShippingBoxReport();
                String testStr = clsTest.getPSOrderCreationLink();
                testStr = clsTest.getPSRMALink();   
                
                //Modified after 9th Aug 2010
                testStr = clsTest.getWMSLink();
                testStr = clsTest.getPSRMAWorksheetLink();
                
                //createSOQLCollectionFromSetOfStrings
                Set<String> set_strs = new Set<String>();
                set_strs.add('test1');
                set_strs.add('test2');
                //testStr = clsTest.createSOQLCollectionFromSetOfStrings(set_strs);                     
                
                
            }
        //} // run as testuser         
    }
}