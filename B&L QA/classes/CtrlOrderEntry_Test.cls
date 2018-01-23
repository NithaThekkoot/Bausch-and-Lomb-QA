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
 *  	Author		     |Author-Email			   	     	|Date		|Comment
 *  	-----------------|----------------------------------|-----------|--------------------------------------------------
 *  	Dennis Flüchter  |dennis.fluechter@itbconsult.com 	|20.10.2009 |First draft
 *
 */
@isTest
private class CtrlOrderEntry_Test {

    static testMethod void CtrlOrderEntry_Test() {
        /*System.debug('********** BEGIN TEST METHOD **********');
        System.debug('--> getLimitAggregateQueries: ' + Limits.getLimitAggregateQueries());
        System.debug('--> getLimitQueries: ' + Limits.getLimitQueries());
        System.debug('--> BEGIN getAggregateQueries: ' + Limits.getAggregateQueries());
        System.debug('--> BEGIN getQueries: ' + Limits.getQueries());*/
        
        //Select an Account as a reference for the order creation process
		Account acc = [Select a.Bill_To__c, a.Bill_To_Address_1__c, a.Bill_To_Address_2__c, a.Bill_To_Credit_Hold__c, 
			a.Bill_To_Credit_Hold_Flag__c, a.Bill_To_Name__c, a.Bill_To_SETID_CUSTID__c, a.BillingCity, a.BillingCountry, 
			a.BillingPostalCode, a.BillingState, a.BillingStreet, a.Business_Unit__c, a.CurrencyIsoCode, a.Description, a.Fax, 
			a.Id, a.Name, a.Phone, a.Preferred_Carrier__c, a.Preferred_Ship_Via__c, a.Primary_Ship_To__c, a.RecordTypeId, 
			a.RecordType.Name, a.SETID__c, a.Ship_To_Address_1__c, a.Ship_To_Address_2__c, a.Ship_To_Id__c, a.ShippingCity, 
			a.ShippingCountry, a.ShippingPostalCode, a.ShippingState, a.ShippingStreet from Account a 
 			where a.RecordType.Name = 'Ship To Account' and a.SETID__c = 'NORSE' limit 1];
        
        //preparing visualforce page test variables
        System.debug('--> Run ORDER 1 of order creation');
        PageReference pageRef = new PageReference('/apex/CtrlOrderEntry_OrderEntry');
        //?retURL=%2Fa0H%2Fo&save_new=1&setid=&sfdc.override=1'
		Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('save_new', '1');
		ApexPages.currentPage().getParameters().put('sfdc.override', '1');
		ApexPages.currentPage().getParameters().put('setId', acc.Ship_To_Id__c);
		
		//Create new OrderHeader
		Order_Header__c header = new Order_Header__c();
		
		//define Controller		
		ApexPages.StandardController ExtController = new ApexPages.StandardController(header);
		
		//Open Extension Class
		CtrlOrderEntry order = new CtrlOrderEntry(ExtController);				
		
		//Change a.Bill_To_Credit_Hold_Flag__c = 'Yes' to simulate a message about customer is on credit hold
		 acc.Bill_To_Credit_Hold_Flag__c = 'Yes'; 
		
		/*simulate to enter a wrong ShipToId*/
		header.Business_Unit__c = 'NORSE';
		header.Ship_To_ID__c = acc.Ship_To_Id__c + 'X';		
		order.queryShipToDetails(); //tabbing out of ShipToId field
		
		/*simulate to enter a wrong combination of BusinessUnit and ShipToId*/
		header.Business_Unit__c = 'NORDK';
		order.changeBusinessUnit(); //simulate a change of the BusinessUnit in the select list
		header.Ship_To_ID__c = acc.Ship_To_Id__c;		
		order.queryShipToDetails(); //tabbing out of ShipToId field
		
		/*simulate to enter a ShipToId where the query returns multiple rows*/
		header.Business_Unit__c = 'NORSE';
		order.changeBusinessUnit();
		header.Ship_To_ID__c = String.valueOf(acc.Ship_To_Id__c).substring(0,3);		
		order.queryShipToDetails(); //tabbing out of ShipToId field -> multiple accounts found		
		order.selectedShipToId = acc.Ship_To_Id__c; //simulate chosing from select list
		order.processSelectedShipToId();//tabbing out of ShipToId picklist field
		
		/*simulate to enter a right combination of BusinessUnit and ShipToId*/
		header.Business_Unit__c = 'NORSE';
		header.Ship_To_ID__c = acc.Ship_To_Id__c;		
		order.queryShipToDetails(); //tabbing out of ShipToId field
		
		/*simulate Address Override*/
		String shipToAddress2 = header.Ship_To_Address_2__c; //store original value 
		header.Ship_To_Address_2__c = header.Ship_To_Address_2__c;
		order.overrideAdressFields(); //changing one address field
		//TO DO:check if AdressOverride is checked now
		//TO DO:check if Home Delivery is checked now
		//TO DO:check if Carrier = IPT
		//TO DO:check Shipping Flags is checked now
		
		/*simulate change OrderGroup to FOC*/
		header.Order_Group__c = 'FOC';
		order.overrideAllOrderGroups(); //tabbing out of field after selecting another picklist value		
		//TO DO: check all OrderGroup fields on line item level
		//TO DO: check all OverridePrices fields on line item level, if equal to zero
		
		/*query products to simulate entry of line items*/
		List<Product2> list_products = [Select p.Description, p.Family, p.Id, p.IsActive, p.Name, p.PS_Product_SKU__c, 
			p.Strategic_Value__c, p.Unit_of_Measure__c, p.Maximum_Order_Qty__c, p.Multiple_Order_Qty__c, 
			(Select Name, Quantity_in_Stock__c, Ship_From__c From Inventory__r) from Product2 p 
			where isActive = true and Strategic_Value__c = 'High' and Name like 'SDD%' limit 5];
		
		list_products.addAll([Select p.Description, p.Family, p.Id, p.IsActive, p.Name, p.PS_Product_SKU__c, 
			p.Strategic_Value__c, p.Unit_of_Measure__c, p.Maximum_Order_Qty__c, p.Multiple_Order_Qty__c, 
			(Select Name, Quantity_in_Stock__c, Ship_From__c From Inventory__r) from Product2 p 
			where isActive = true and Strategic_Value__c = 'High' and Name like 'P%' limit 5]);
			
		list_products.addAll([Select p.Description, p.Family, p.Id, p.IsActive, p.Name, p.PS_Product_SKU__c, 
			p.Strategic_Value__c, p.Unit_of_Measure__c, p.Maximum_Order_Qty__c, p.Multiple_Order_Qty__c, 
			(Select Name, Quantity_in_Stock__c, Ship_From__c From Inventory__r) from Product2 p 
			where isActive = true and Strategic_Value__c = 'Medium' limit 5]);	
		
		list_products.addAll([Select p.Description, p.Family, p.Id, p.IsActive, p.Name, p.PS_Product_SKU__c, 
			p.Strategic_Value__c, p.Unit_of_Measure__c, p.Maximum_Order_Qty__c, p.Multiple_Order_Qty__c, 
			(Select Name, Quantity_in_Stock__c, Ship_From__c From Inventory__r) from Product2 p 
			where isActive = true and Strategic_Value__c = 'Low' limit 5]);
				
		/*simulate entry of 20 line items*/
		Integer i; //count variable for forLoop
		i = -1; 		
		for (Product2 p : list_products){
			i++;						
			
			//add items after the first ten lines are filled
			if (i == 10){
				//simulate to press command link to add further line items
				order.addClsItems();
			}
			
			if (i <= 5){
			ClsOrderLineItem clsOli = order.list_clsOlis[i];
			Order_Line_Item__c oli = order.list_clsOlis[i].oli;
			Product2 pc = order.list_clsOlis[i].pc;
			Inventory__c inv = order.list_clsOlis[i].inv;
			
			/*simulate to enter a valid SKU*/
			clsOli.SKU_field = p.Name;
			order.actualItem = String.valueOf(i); //simulate to pass over the row number
			System.debug('--> getAggregateQueries: ' + Limits.getAggregateQueries());
			System.debug('--> getQueries: ' + Limits.getQueries());
			order.queryLineItemData(); //simulate tabbing of SKU field
						
			
			/*simulate to set quantity*/
			oli.Quantity__c = i + 1;
			order.changeQuantity(); //simulate tabbing out of quantity field
			
			/*simulate to set a patientRef*/
			oli.Patient_Ref_No__c = 'patientRef - ' + (i + 1);
			
			/*simulate some entries for only some of the entered order line items*/
			if (i > 0 && math.mod(i, 3) == 0){
				/*simulate to change ShipFrom field*/
				oli.Ship_From__c = 'NORDC';
				order.changeShipFrom(); //simulate to tab out the ShipFrom field after selecting a picklist value
				
				/*simulate to change OrderGroup*/
				oli.Order_Group__c = 'STD';
				order.changeItemOrderGroup(); //simulate to tab out the OrderGroup field after selecting a picklist value
				
				/*simulate to set OverridePrice to NULL*/
				oli.Override_Price__c = null;
				order.changeOverridePrice(); //simulate tabbing out of OverridePrice field
			}
			}
		}
		
		/*simulate to call webservice with wrong input parameters*/
		//String billToId = header.Bill_To_ID__c;
		//header.Bill_To_ID__c = 'ABCXYZ';
		header.Ship_To_ID__c = acc.Ship_To_Id__c + 'X';
		order.requestPrices(); //simulate to do WS callout
		
		/*simulate to call webservice with right input parameters*/
		//header.Bill_To_ID__c = billToId;
		header.Ship_To_ID__c = acc.Ship_To_Id__c;
		order.requestPrices(); //simulate to do WS callout
				
		/*simulate getter methods*/
		Boolean showEditButton = order.getshowEditButton();
		String validShipToMessage = order.getValidShipToMessage();
		String orderAmount = order.getcustOrderAmount();
		String totalValue = order.getcustTotalValue();
		
		/*Simulate Save and Submit Order*/
		order.saveAndSubmit();
		System.debug('Header Id: ' + header.Id);
		
		header.SF_Order_Status__c = 'Saved'; //set Status back to saved, so it can be editable
		
		
		//preparing visualforce page test variables
        System.debug('--> Run ORDER 2 of order creation');
        PageReference pageRef2 = new PageReference('/apex/CtrlOrderEntry_OrderEntry');
        //?retURL=%2Fa0H%2Fo&save_new=1&setid=&sfdc.override=1'
		Test.setCurrentPage(pageRef2);
		ApexPages.currentPage().getParameters().put('save_new', '1');
		ApexPages.currentPage().getParameters().put('sfdc.override', '1');
		
		System.debug('Header Id: ' + header.Id);
		
		ApexPages.currentPage().getParameters().put('id', header.Id);		
		
		
		//Create new OrderHeader
		//Order_Header__c header = new Order_Header__c();
		
		//define Controller		
		ApexPages.StandardController ExtController2 = new ApexPages.StandardController(header);
		
		//Open Extension Class
		CtrlOrderEntry order2 = new CtrlOrderEntry(ExtController2);
		
		/*simulate cancel*/
		order2.cancel();
		
		 
		//preparing visualforce page test variables
        System.debug('--> Run ORDER 3 of order creation');
        PageReference pageRef3 = new PageReference('/apex/CtrlOrderEntry_OrderEntry');
        //?retURL=%2Fa0H%2Fo&save_new=1&setid=&sfdc.override=1'
		Test.setCurrentPage(pageRef3);
		ApexPages.currentPage().getParameters().put('sfdc.override', '1');
		System.debug('Header Id: ' + header.Id);
		ApexPages.currentPage().getParameters().put('id', header.Id);				
		
		//Create new OrderHeader
		Order_Header__c header3 = header;
		
		//define Controller		
		ApexPages.StandardController ExtController3 = new ApexPages.StandardController(header3);
		
		//Open Extension Class
		CtrlOrderEntry order3 = new CtrlOrderEntry(ExtController3);
		
		/*simulate Save and Submit*/
		order3.saveAndSubmit();
		
		/*simulate cloneOrder*/
		order3.cloneOrder();
		
		//preparing visualforce page test variables
        System.debug('--> Run ORDER 4 of order creation');
        PageReference pageRef4 = new PageReference('/apex/CtrlOrderEntry_OrderEntry');
        //?retURL=%2Fa0H%2Fo&save_new=1&setid=&sfdc.override=1'
		Test.setCurrentPage(pageRef4);		
		ApexPages.currentPage().getParameters().put('sfdc.override', '1');
		ApexPages.currentPage().getParameters().put('clone', '1');
		ApexPages.currentPage().getParameters().put('setid', acc.Ship_To_Id__c);
		
		System.debug('Header Id: ' + header.Id);
		ApexPages.currentPage().getParameters().put('id', header.Id);			
		
		//Create new OrderHeader
		Order_Header__c header4 = header;
		
		//define Controller		
		ApexPages.StandardController ExtController4 = new ApexPages.StandardController(header4);
		
		//Open Extension Class
		CtrlOrderEntry order4 = new CtrlOrderEntry(ExtController4);
		
		/*simulate entry of 20 line items*/		
		i = -1; 		
		for (Product2 p : list_products){
			i++;						
			
			//add items after the first ten lines are filled
			if (i == 10){
				//simulate to press command link to add further line items
				order4.addClsItems();
			}
			
			if (i <= 1){
			ClsOrderLineItem clsOli = order4.list_clsOlis[i];
			
			/*simulate to enter a valid SKU*/
			clsOli.SKU_field = p.Name;
			order4.actualItem = String.valueOf(i); //simulate to pass over the row number
			System.debug('--> getAggregateQueries: ' + Limits.getAggregateQueries());
			System.debug('--> getQueries: ' + Limits.getQueries());
			order4.queryLineItemData(); //simulate tabbing of SKU field
			
			Order_Line_Item__c oli = order4.list_clsOlis[i].oli;
			Product2 pc = order4.list_clsOlis[i].pc;
			Inventory__c inv = order4.list_clsOlis[i].inv;			
			
			/*simulate to set quantity*/			
			pc.Multiple_Order_Qty__c = 4; //set Multiple, so Qty will not be a multiple of it
			oli.Quantity__c = 99999; //simulate a quantity that exceeds stock, max, multiple
			order4.changeQuantity(); //simulate tabbing out of quantity field
			
			/*simulate to set a patientRef*/
			oli.Patient_Ref_No__c = 'patientRef - ' + (i + 1);
			
			/*simulate some entries for only some of the entered order line items*/
			if (i > 0 && math.mod(i, 3) == 0){
				/*simulate to change ShipFrom field*/
				oli.Ship_From__c = 'NORDC';
				order4.changeShipFrom(); //simulate to tab out the ShipFrom field after selecting a picklist value
				
				/*simulate to change OrderGroup*/
				oli.Order_Group__c = 'STD';
				order4.changeItemOrderGroup(); //simulate to tab out the OrderGroup field after selecting a picklist value
				
				/*simulate to set OverridePrice to NULL*/
				oli.Override_Price__c = null;
				order4.changeOverridePrice(); //simulate tabbing out of OverridePrice field
			}
			}
		}
		
		/*simulate Save and Submit*/
		order4.saveAndSubmit(); 
		
		/*simulate the button click for a second time, after maximum validation shows up*/
		order4.saveAndSubmit();
		
		order4.checkQuantities();
		order4.changeFreightOverride(); 
				                
    }
           
}