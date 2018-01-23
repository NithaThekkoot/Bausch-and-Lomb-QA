/**
* 
* 	This class acts as a extension for the standard Order_Header__c controller. It contains all the functionalities that
*	are needed when entering an order.
*
*  	Author		     |Author-Email			   	     	|Date		|Comment
*  	-----------------|----------------------------------|-----------|--------------------------------------------------
*  	Dennis Flüchter  |dennis.fluechter@itbconsult.com 	|31.08.2009 |First draft
*
*
*/ 

public class CtrlOrderEntry {
	
	/*************************************************************************
  	* Varibales and Properties
  	*************************************************************************/
	private Order_Header__c header; //holds controller record
	
	private Order_Header__c cloneHeader; //holds controller record from which the record should be cloned
	
	public Account account {get;set;}
	
	private Boolean isClone;
	private Boolean isNew;
	
	private Boolean isPageLoad;
	private Boolean isSaveAndSubmit;
	
	private String clonedShipToId;
	private String clonedBU;
	private Boolean skipValidation;		
	
	private final ApexPages.Standardcontroller theController;
	
	private final Integer maxAddedItems = 10; //maximum number of items that are added at once
	
	public Boolean editMode {get; set;} //variable to differ between edit (true) and view mode (false)	
	
	public Order_Header__c billToDetails {get; set;} //is a shadow record for just storing BillToDetails
	
	public List<Order_Line_Item__c> list_olis {get; set;} //holds a list of Order Line Items belonging to the Order Header
	
	public List<ClsOrderLineItem> list_clsOlis {get; set;} //List of Classes to display all Line Item information
	
	//not used any more because we transferred the according logic to a JavaScript in VF page
	//public List<ClsProductCache> list_products {get; set;} //list to store product an dinventory related information in the memory
	//public Map<String, ClsProductCache> map_SKU_productCache {get;set;} //Map to store Product Cache Info
	
	public String actualItem {get; set;} //holds the LineItem Number of the item the user actually interacts with
	public String actualLineItem {get; set;} //holds the LineItem Number of the item the user actually interacts with
	
	public List<SelectOption> list_BusinessUnits {get; set;} //holds a list of selectable Business Units for a select list
	public Map<String, String> map_businessUnit_setId {get; set;} //holds a map with queried BusinessUnit and according SetId
	public List<SelectOption> list_selectableShipToIds {get; set;} //holds a list of select options when entered shipToId is not unique
	public Boolean renderShipToOptions {get; set;} //states if select list for multiple shipToIds should be rendered
	public String selectedShipToId {get; set;} //holds the selected shipToId from the select list
	
	public Boolean validShipToId {get; set;} //states if the entered shipToId is valid
	public Boolean jumpBackToSKU {get; set;}
	private Boolean showFirstValidShipToIdMessage;
	
	private Boolean firstMaxValidation = true; //Maximum validation should only be done for first time trying to save
	
	public Double orderValue {get;set;} //holds the order value to be referencd when querying freight amounts
	
	/*Variables for Adress Override Validation*/
	private Boolean addressOverride;
	private String homeDelivery;
	//private String address1;
	private String deliveryName;
	private String address1;
	private String address2;
	private String postCode;
	private String city;
	
	/*Variables for tab order control */
	public String fieldInFocus {get; set;}
	
	private String previousShipToId;
	
	/*Variables to test SKU lookup functionality*/
	public String SKU_lkid {get; set;}
	public String SKU_lkold {get; set;}
	public String SKU_lktp {get; set;} //a0K
	public String SKU_lspf {get; set;} //0
	public String SKU_mod {get; set;} //0
	public string SKU_field {get; set;}
	
	/*Variables for hidden fields related to Account*/
	public String accountDescription;
	public String accountCurrency;
	public String accountSetId;
	public String accountShipToId;
	public String accountBusinessUnit;
	
	/*Variables to show AccountNames without hyperlink*/
	public String shipToAccountName {get; set;}
	public String billToAccountName {get; set;}
	
	/*************************************************************************
  	* Constructor
  	*************************************************************************/
	public CtrlOrderEntry(ApexPages.StandardController headerController){
		System.debug('********** Constructor **********');
		this.theController = headerController;
		
		Id recordId = ApexPages.currentPage().getParameters().get('id');
		System.debug('--> Record Id: ' + recordId);
		
		this.isPageLoad = true;
		this.isSaveAndSubmit = false;
		
		if (ApexPages.currentPage().getParameters().get('clone') == '1'){
			isClone = true;			
		} else {
			isClone = false;			
		}
		if (recordId == null || ApexPages.currentPage().getParameters().get('save_new') == '1'){
			isNew = true;
		} else {
			isNew = false;	
		}
		
		/*if (isClone) {
			//this.header = (Order_Header__c)headerController.getRecord();
			System.debug('--> Clone Order');
			cloneHeader = (Order_Header__c)headerController.getRecord();
			System.debug('*** Begin CloneHeader ***');
			System.debug('--> Account: ' + cloneHeader.Account__c);
			System.debug('--> ShipToId: ' + cloneHeader.Ship_To_Id__c);
			System.debug('*** End CloneHeader ***');
			this.header = cloneHeader.clone(false,true);
			System.debug('*** Begin Header ***');
			System.debug('--> Account: ' + header.Account__c);
			System.debug('--> ShipToId: ' + header.Ship_To_Id__c);
			System.debug('*** End Header ***');
		} else {
			System.debug('--> New Order');
			this.header = (Order_Header__c)headerController.getRecord();
		}*/

		this.header = (Order_Header__c)headerController.getRecord();				
		
		this.billToDetails = new Order_Header__c();
		
		this.account = new Account();
		
		this.list_clsOlis = new List<ClsOrderLineItem>();
		
		//not used any more because we transferred the according logic to a JavaScript in VF page
		//this.list_products = new List<ClsProductCache>();
		//this.map_SKU_productCache = new Map<String, ClsProductCache>();
		
		this.map_businessUnit_setId = new Map<String, String>();
		this.list_BusinessUnits = new List<SelectOption>();
		
		//Set variables that will control ShipToId functionality in the header
		this.validShipToId = false;
		this.showFirstValidShipToIdMessage = false;
		this.renderShipToOptions = false;
		this.list_selectableShipToIds = new List<SelectOption>();
		
		//Check if Account LookUp is alreday filled (e.g. when Order was initiated from Account detail page)
		System.debug('--> Account LookUp filled with: ' + header.Account__c);
		//if Account is known, prepolate fields for ShipToId functionality
		
		//header.Carrier__c = acc.Preferred_Carrier__c;
 		//header.Ship_Via__c = acc.Preferred_Ship_Via__c;
				
		if(header.Account__c != null){
			this.account = [Select a.Name, Bill_To_Name__c, a.CurrencyIsoCode, a.Description, a.SETID__c, a.Ship_To_Id__c from Account a 
 			where Id = :header.Account__c limit 1];
 			
 			/*[Select a.Bill_To__c, a.Bill_To_Address_1__c, a.Bill_To_Address_2__c, a.Bill_To_Credit_Hold__c, 
			a.Bill_To_Credit_Hold_Flag__c, a.Bill_To_Name__c, a.Bill_To_SETID_CUSTID__c, a.BillingCity, a.BillingCountry, 
			a.BillingPostalCode, a.BillingState, a.BillingStreet, a.Business_Unit__c, a.CurrencyIsoCode, a.Description, a.Fax, 
			a.Id, a.Name, a.Phone, a.Preferred_Carrier__c, a.Preferred_Ship_Via__c, a.Primary_Ship_To__c, a.RecordTypeId, 
			a.RecordType.Name, a.SETID__c, a.Ship_To_Address_1__c, a.Ship_To_Address_2__c, a.Ship_To_Id__c, a.ShippingCity, 
			a.ShippingCountry, a.ShippingPostalCode, a.ShippingState, a.ShippingStreet from Account a 
 			where Id = :header.Account__c limit 1];*/
 			
			/*if(isClone){
				this.clonedShipToId = this.header.Ship_To_ID__c;
				this.clonedBU = this.header.Business_Unit__c;
				this.skipValidation = true;				
			}*/
			
			//to avoid the hyperlink around accountNames
			this.shipToAccountName = this.account.Name;
			this.billToAccountName = this.account.Bill_To_Name__c;
			
			//this.header.CurrencyIsoCode = this.header.Account__r.CurrencyIsoCode;
			this.header.CurrencyIsoCode = this.account.CurrencyIsoCode;
			this.validShipToId = true;				 		
			//this.header.Ship_To_ID__c = queryShipToId();			
			queryShipToIdBU();
			System.debug('--> header Value for SETID__c: ' + this.header.SETID__c);
			System.debug('--> Set this.header.Ship_To_ID__c = ' + this.header.Ship_To_ID__c);
			System.debug('--> this.header.Account__r.SETID__c: ' + this.account.SETID__c);						
			if (this.account.SETID__c != null){
				this.header.SETID__c = this.account.SETID__c;
			}	
			//queryBusinessUnits(this.header.SETID__c, this.header.Business_Unit__c);								
			displayAccountDescriptionMessage(this.account.Description);
			storeAdressfields();
			if (isNew){ //only call, when record is New
				System.debug('***** Query ShipToDetails *****');
				/*if(this.header.Business_Unit__c == null){
					this.header.Business_Unit__c = 'NORSE';
				}*/
				queryShipToDetails();
			}
			if (isClone){
				queryBusinessUnits(null, null);
			} else {
				queryBusinessUnits(this.header.SETID__c, this.header.Business_Unit__c);
			}					
		} /*else {
			this.header.Business_Unit__c = 'NORSE';
		}*/		
		
		//editMode = false;
		
		//Default values
		if(isNew) {
			/*this.header.Order_Source__c = 'PHONE';
			if (this.header.Order_Source__c == 'PHONE') {
				this.header.Caller_Name__c = '';
			}
			this.header.Address_Override__c = false;
			this.header.Home_delivery__c = 'No';
			
			this.header.Freight_Amount__c = 0;
			this.header.Charge_Freight__c = 'Yes';
			
			this.header.Ship_Via__c = 'Ground';
			//this.header.Ship_From__c = 'EURLC';
			this.header.Order_Group__c = 'STD';
			this.header.Partial_Order__c ='Yes';
			this.header.Partials__c = 'Yes';
			this.header.Cancel_Back_Order__c = 'No';
			this.header.Order_Date__c = Date.today();
			this.header.Scheduled_Ship_Date__c = Date.today();*/
			String mode = 'ALL';						
			 
			if (this.header.Account__c != null){
				mode = 'WITHOUT_ACCOUNT';
			} else{
				queryBusinessUnits(null, null);
			}
			defaultValues(mode);			
		}				
		
		//Adding first initial Line Items
		//addItems();
		if(isNew){
			//Check if SetId has been passed to page
			String transferredSetId = ApexPages.currentPage().getParameters().get('setId');
			if (transferredSetId != '' && transferredSetId != null && this.header.Account__c == null) {
				this.header.Ship_To_Id__c = transferredSetId;
				//List<Account> list_account = [Select SETID__c from Account where Ship_To_Id__c = :this.header.Ship_To_Id__c limit 10];
				//if (list_account.size == 1){
				//}
				showFirstValidShipToIdMessage = true;
			}
			addClsItems();			
		} else {
			//this.header.Name = 'auto';
			queryExistingItems();
			queryAllInventory();
			colorQuantities();
			calculateOrderValue();
			//calculateFreightAmount();
		}
		
		if (!isClone && !isNew){
			calculateFreightAmount();
		}
		calculateTotalValue();
		
		if (isClone || isNew){
			this.header.Name = 'auto';
		}
		
		if(this.header.SF_Order_Status__c == '' || this.header.SF_Order_Status__c == null){
			this.header.SF_Order_Status__c = 'Saved'; //default value for SF_Status
		}
		this.previousShipToId = this.header.Ship_To_Id__c;
		this.isPageLoad = false;
	}
	
	/*************************************************************************
  	* Button Action Methods
  	*************************************************************************/
	
	public PageReference save(){
		System.debug('********** Saving Order **********');
		System.debug('--> Inserting/Updating Order Header');
		System.debug('--> Header Account__c: ' + this.header.Account__c);
		System.debug('--> Header Id: ' + this.header.Id);
		
		Boolean validationErrors = validateOrderEntry();
		System.debug('--> Validation Errors encountered: ' + validationErrors);				
				
		if (!validationErrors){
			Id headerId; // = this.header.Id;
			if(isNew) {
				//System.debug('--> Header Id: ' + this.header.Id);			
				System.debug('--> Inserting Order Header');
				insert this.header;
				headerId = this.header.Id;
			} else if (isClone){
				System.debug('--> Cloning Header Record');
				cloneHeader = this.header.clone(false,true);
				System.debug('--> CloneHeader Id: ' + this.cloneHeader.Id);
				System.debug('--> Inserting Cloned Order Header');
				insert this.cloneHeader;
				System.debug('--> CloneHeader Id: ' + this.cloneHeader.Id);
				headerId = this.cloneHeader.Id;
			} else {
				update this.header;
				headerId = this.header.Id;		
			}
					
			System.debug('--> Order Header saved');
			System.debug('--> Order Header Id after saving: ' + headerId);
			
			
			/*
			PageReference pageRef = this.theController.save();
			Order_Header__c localHeader = (Order_Header__c)theController.getRecord();
			Id localId = pageRef.getParameters().get('id');
			Id headerId = this.header.Id;
			System.debug('--> Header Id: ' + this.header.Id);
			System.debug('--> Local Header Id: ' + localHeader.Id);
			System.debug('--> Id from PageRef: ' + localId);
			System.debug('--> URL from PageRef: ' + pageRef.getUrl());		
			//saveOrderLineItems(localId);*/
			
			saveOrderLineItems(headerId);
			
			//if (!isClone) {
				//return this.theController.save();
				//PageReference pageRef = new PageReference('/' + headerId);
				//PageReference pageRef = new PageReference('/apex/CtrlOrderEntry_OrderEntry?retURL=%252Fa0H%252Fo&save_new=1');
				String URL = '/apex/CtrlOrderTracking_Search?sfdc.tabName=01rT00000004ZHJ';
  				
  				//commented out on 3rd of Nov because of new requirement from user tests
  				//if (this.header.Ship_To_Id__c != null && this.isSaveAndSubmit == false){
  				//	URL += '&setid=' + this.header.Ship_To_Id__c;
  				//}
  				
  				PageReference pageRef = new PageReference(URL);
				//return pageRef;
			/*} else {
				PageReference pageRef = new PageReference('/' + headerId);
				return (pageRef);
			}*/	
			
			
			return pageRef;
			
		} else {
			//Validation Errors
			return null;
		}
		
		//return this.theController.view();
	}
	 
	private void saveOrderLineItems(Id orderId){
		System.debug('********** Saving Order LineItems **********');
		System.debug('--> Order Header Id passed to this method: ' + orderId);
		if (orderId != null){			
			System.debug('--> Inserting/Updating Order Lines');
			//System.debug('--> Setting relation to Order Header with Id: ' + orderId);
			
			List<Order_Line_Item__c> list_olis2Insert = new List<Order_Line_Item__c>(); 	
			List<Order_Line_Item__c> list_olis2Update = new List<Order_Line_Item__c>();
			
			Integer i = 0;
			for (ClsOrderLineItem clsOli :list_clsOlis){
				Order_Line_Item__c oli;
				if (isClone){
					System.debug('--> Cloning Line Item');
					oli = clsOli.oli.clone(false,true);
					oli.Order__c = null;
				} else {				
					oli = clsOli.oli;
				}								
				if (clsOli.validSKU && clsOli.oli.Quantity__c != null){
					System.debug('--> i = ' + i + '  --> Product Id: ' + oli.Product_SKU__c);
					System.debug('--> Item belongs to OrderHeader Id: ' + oli.Order__c);
					oli.Item__c = i + 1;
					if (oli.Order__c == null) {											
						oli.Order__c = orderId;
						System.debug('--> Line Item belongs to Order Id: ' + oli.Order__c);
						list_olis2Insert.add(oli);
					} else {
						list_olis2Update.add(oli);
					}
				}
				i += 1;
			}			
			if (list_olis2Insert.size() > 0){
				System.debug('--> #Inserting Order Line Items: ' + list_olis2Insert.size());
				insert list_olis2Insert;
				System.debug('--> Order Line Items inserted');	
			}								
			if (list_olis2Update.size() > 0){
				System.debug('--> #Updating Order Line Items: ' + list_olis2Update.size());
				update list_olis2Update;
				System.debug('--> Order Line Items updated');	
			}
			
		}
	}
	
	public PageReference saveAndSubmit(){
		System.debug('********** Saving and Submitting Order **********');
		//set synch flag to sign that record should be polled from PS integration process
		this.header.SF_Order_Status__c = 'Ready';		
		this.isSaveAndSubmit = true;
		return save();
	}
	
	public PageReference cancel(){ 
		System.debug('********** Canceling Order **********');
		String URL = '/apex/CtrlOrderTracking_Search?sfdc.tabName=01rT00000004ZHJ';
  		//if (this.header.Ship_To_Id__c != null){
  		//	URL += '&setid=' + this.header.Ship_To_Id__c;
  		//}
  		PageReference pageRef = new PageReference(URL);
		//return this.theController.cancel();
		pageRef.setRedirect(true);
		return pageRef;
	}
	
	public pageReference cloneOrder(){
		String URL = '/apex/CtrlOrderEntry_OrderEntry?clone=1&retURL=%2Fa0HT0000000A9U8&scontrolCaching=1&sfdc.override=1&id=' + this.header.Id;
		PageReference pageRef = new PageReference(URL);
		pageRef.setRedirect(true);
		return pageRef;
	}
	
	/*************************************************************************
  	* All Methods Except Getter and Setter Methods
  	*************************************************************************/
	
	private Boolean validateOrderEntry(){		
		/*This method will validate all entries for the form before actually saving the records */
		Boolean returnValue = false; //will be true if there are ERRORs, false if there are NO ERRORs
		
		System.debug('********** validateOrderEntry **********');
		
		//validation for CallerName if OrderSource is Phone
		/*if (this.header.Order_Source__c == 'PHONE' && this.header.Caller_Name__c == null){
			ApexPages.Message msgCallerNameMissing = new ApexPages.Message(ApexPages.Severity.ERROR, 
        		'You have chosen PHONE as the order source. Please ensure to enter a caller name.');
  			ApexPages.addMessage(msgCallerNameMissing);
  			returnValue = true;
		}*/
		
		//validate if order contains validLines
		Boolean hasValidItems = false;
		Set<Integer> set_LineItemNumbers = new Set<Integer>();
		for (Integer itemNumber = 0; itemNumber < list_clsOlis.size(); itemNumber++){					
	  		System.debug('--> itemNumber = ' + itemNumber);
	  		Order_Line_Item__c oli = list_clsOlis[itemNumber].oli;
	  		System.debug('--> oli.Quantity__c: ' + oli.Quantity__c);
	  		System.debug('--> list_clsOlis[itemNumber].validSKU: ' + list_clsOlis[itemNumber].validSKU);
	  		System.debug('--> list_clsOlis[itemNumber].SKU_field: ' + list_clsOlis[itemNumber].SKU_field);
	  		if(list_clsOlis[itemNumber].validSKU && list_clsOlis[itemNumber].SKU_field != '' && oli.Quantity__c != null){
	  			System.debug('--> Valid Line Item found');
	  			hasValidItems = true;
	  		}
	  		if(list_clsOlis[itemNumber].validSKU && list_clsOlis[itemNumber].SKU_field != '' && oli.Quantity__c == null){
	  			set_LineItemNumbers.add(list_clsOlis[itemNumber].oli.Item__c.intValue());
	  		}
		}
		if (!hasValidItems){
			System.debug('--> NO valid Line Items found');
			ApexPages.Message msgValidItemsMissing = new ApexPages.Message(ApexPages.Severity.ERROR, 
        		'You cannot save an order without any valid line items. Please ensure to enter valid line items having a valid SKU and a certain quantity.');
  			ApexPages.addMessage(msgValidItemsMissing);
  			returnValue = true;
		}
		
		//validating max quantity
		System.debug('--> checking if max is exceeded');
		System.debug('--> hasValidItems: ' + hasValidItems);
		if(hasValidItems){
			Boolean maximumExceeded = false;
			for (Integer itemNumber = 0; itemNumber < list_clsOlis.size(); itemNumber++){					
		  		System.debug('--> itemNumber = ' + itemNumber);
		  		Order_Line_Item__c oli = list_clsOlis[itemNumber].oli;
		  		Product2 pc = list_clsOlis[itemNumber].pc;
		  		if (oli.Quantity__c != null && pc.Maximum_Order_Qty__c != null){
			  		if(oli.Quantity__c > pc.Maximum_Order_Qty__c){
			  			System.debug('--> Line Item found where Qty exceeds Max');
			  			maximumExceeded = true;
			  		}
		  		}
			}
			if(maximumExceeded){
				System.debug('--> Lines found that exceed the according max qty');
				ApexPages.Message msgMaxExceeded = new ApexPages.Message(ApexPages.Severity.WARNING, 
	        		'Some quantities exceed the according max order quantity. Please queck on the entered quantities for the line items. This order has not been saved. To save please click on the Draft or Save & New button again');
	  			ApexPages.addMessage(msgMaxExceeded);
	  			if (firstMaxValidation) {
	  				returnValue = true;
	  				firstMaxValidation = false;
	  			}
			}
		}		
		
		//validate if Address1/2 and delivery Name are filles in case of home delivery = yes
		if(this.header.Home_Delivery__c == 'Yes'){
			System.debug('--> this.header.Ship_To_Address_1__c: ' + this.header.Ship_To_Address_1__c);
			System.debug('--> this.header.Ship_To_Address_2__c: ' + this.header.Ship_To_Address_2__c);
			System.debug('--> this.header.Delivery_Name__c: ' + this.header.Delivery_Name__c);
			if (this.header.Ship_To_Address_1__c == null || this.header.Ship_To_Address_2__c == null || this.header.Delivery_Name__c == null){
				System.debug('--> Add1, Add2 or DeliveryName not filled for HomeDelivery');
				ApexPages.Message msgValidHomeDeliveryFields = new ApexPages.Message(ApexPages.Severity.ERROR, 
	        		'Delivery Name, ShipToAddress1 and ShipToAddress2 cannot be empty for a Home Delivery Order.');
	  			ApexPages.addMessage(msgValidHomeDeliveryFields);
	  			returnValue = true;
			}
		}
		
		//check if there are lines with valid SKU but without qty
		String invalidLineNumbers = '';
		for (Integer j : set_LineItemNumbers){
			if (invalidLineNumbers != ''){
				invalidLineNumbers += ', ';
			}
			invalidLineNumbers += j;	
		}
		if (set_LineItemNumbers.size() > 0){
			System.debug('--> Add1, Add2 or DeliveryName not filled for HomeDelivery');
			ApexPages.Message msgInvalidQuantitiesWithValidSKU = new ApexPages.Message(ApexPages.Severity.ERROR, 
        		'You cannot save order lines without specifying a quantitty. Please enter a valid quantity or remove the according SKU from that line. Please check the following OrderLines: ' + invalidLineNumbers);
  			ApexPages.addMessage(msgInvalidQuantitiesWithValidSKU);
  			returnValue = true;
		}
		
		//return validation result
		return returnValue;
	}
	
	
	/*public string getControlToFocus() {
		System.debug('********** getControlToFocus **********');
		System.debug('--> Field In Focus ID: ' + fieldInFocus);
		if(actualItem != '' && actualItem != null) {
			System.debug('--> Return Funtion Call: ' + 'moveFocus(\'' + getItemNumber() + '\');');
			return 'moveFocus(\'' + getItemNumber() + '\');';
		} else {
			return '';
		}
		//return '';		
	}*/
	
	public PageReference dummyAction(){
		System.debug('********** DUMMY ACTION **********');
		return null;
	}		
	
	/*public void addItems() {
		//initialisize local variables
		Integer beginLoop = 0;
		Integer endLoop = 0;
		
		//initialize collection if not already done
		if(this.list_olis == null) {
			this.list_olis = new List<Order_Line_Item__c>();
		}
		
		beginLoop = this.list_olis.size() + 1;
		endLoop =  beginLoop + this.maxAddedItems -1;
		
		//add Line Items
		if (this.list_olis.size() < (1000 - this.maxAddedItems)) {			
			for (Integer i = beginLoop; i<=endLoop; i++) {
				Order_Line_Item__c oli = new Order_Line_Item__c();
				oli.Item__c=i;
				oli.CurrencyIsoCode = this.header.CurrencyIsoCode;
				this.list_olis.add(oli);
			}
		}
				
		//Overriding added Order Line Item information accordingly to Order Header information
		overrideItems(beginLoop-1, endLoop-1);		
  	}*/
  	
  	public void addClsItems() {
		//initialisize local variables
		Integer beginLoop = 0;
		Integer endLoop = 0;
		
		//initialize collection if not already done
		/*if(this.list_clsOlis == null) {
			this.list_clsOlis = new List<ClsOrderLineItem>();
		}*/
		
		beginLoop = this.list_clsOlis.size() + 1;
		endLoop =  beginLoop + this.maxAddedItems -1;
		
		//add Line Items
		if (this.list_clsOlis.size() < (1000 - this.maxAddedItems)) {			
			for (Integer i = beginLoop; i<=endLoop; i++) {
				ClsOrderLineItem clsOli = new clsOrderLineItem();
				clsOli.oli.Item__c = i;
				clsOli.oli.Ship_From__c = 'EURLC';
				clsOli.oli.CurrencyIsoCode = this.header.CurrencyIsoCode;
				
				/*TEST
				clsOli.pc.Unit_of_Measure__c = '';
				clsOli.pc.Description = '';
				clsOli.inv.Quantity_In_Stock__c = 0;
				clsOli.pc.Maximum_Order_Qty__c = 0;
				clsOli.pc.Multiple_Order_Qty__c = 0;
				//END TEST*/
				
				this.list_clsOlis.add(clsOli);
			}
		}
		
		//override new added Items
		//overrideClsItems(beginLoop-1, endLoop-1);
		overrideOrderGroup(beginLoop-1, endLoop-1);
		/*overrideShipFrom(beginLoop-1, endLoop-1);*/
  	}
  	
  	private void setItemCurrency(){
  		for (Integer itemNumber = 0; itemNumber<list_clsOlis.size();itemNumber++){
  			list_clsOlis[itemNumber].oli.CurrencyIsoCode = this.header.CurrencyIsoCode;
  		}
  	}
  	
  	/*public void overrideAllItems(){
		//call overrideItems Method
		overrideItems(0, 0);
  	}*/

	/*public void overrideClsAllItems(){
		//call overrideItems Method
		overrideClsItems(0, 0);
  	}*/
  	
  	public void overrideAllOrderGroups(){
		//call overrideItems Method
		overrideOrderGroup(0, 0);
  	}
  	
  	/*public void overrideAllShipFrom(){
  		//call overrideShipFrom Method
		overrideShipFrom(0, 0);
  	}*/
  	
  	/*public void overrideItems(Integer beginLoop, Integer endLoop) {
  		//Override LineItem information with information from OrderHeader
  		if(this.header.Override_Value__c != null){
	  		
	  		//set endLoop to list's size, if zero value has been passed over to method
	  		if(endLoop == 0) {
	  			endLoop = list_olis.size();
	  		}
	  		
	  		//override certain Items
	  		Integer i = 0;
	  		for (Order_Line_Item__c oli : list_olis) {
	  			if (i>= beginLoop && i<=endLoop) {
	  				oli.Overriden_Value__c = header.Override_Value__c;
	  			}
	  			i=i+1;
	  		}
  		}
  	}*/
  	
	/*public void overrideClsItems(Integer beginLoop, Integer endLoop) {
  		//Override LineItem information with information from OrderHeader
  		if(this.header.Override_Value__c != null){
	  		
	  		//set endLoop to list's size, if zero value has been passed over to method
	  		if(endLoop == 0) {
	  			endLoop = list_clsOlis.size();
	  		}
	  		
	  		//override certain Items
	  		Integer i = 0;
	  		for (ClsOrderLineItem clsOli : list_clsOlis) {
	  			if (i>= beginLoop && i<=endLoop) {
	  				clsOli.oli.Overriden_Value__c = header.Override_Value__c;
	  			}
	  			i=i+1;
	  		}
  		}
  	}*/
  	
  	public void overrideOrderGroup(Integer beginLoop, Integer endLoop) {
  		//Override LineItem information with information from OrderHeader
  		if(this.header.Order_Group__c != null){
	  		
	  		//set endLoop to list's size, if zero value has been passed over to method
	  		if(endLoop == 0) {
	  			endLoop = list_clsOlis.size();
	  		}
	  		
	  		//override certain Items
	  		Integer i = 0;
	  		for (ClsOrderLineItem clsOli : list_clsOlis) {
	  			if (i>= beginLoop && i<=endLoop) {
	  				clsOli.oli.Order_Group__c = header.Order_Group__c;
	  				if (clsOli.oli.Order_Group__c == 'FOC' || clsOli.oli.Order_Group__c == 'FOCRPL'){
	  					clsOli.oli.Override_Price__c = 0;	
	  				} else {
						clsOli.oli.Override_Price__c = null;
				  	}	  				
	  			}
	  			i += 1;
	  		}
  		}
  		calculateExtendedPrices();
  		calculateFreightAmount();
  	}
  	
  	/*public void overrideShipFrom(Integer beginLoop, Integer endLoop) {
  		//Override LineItem information with information from OrderHeader
  		if(this.header.Ship_From__c != null){
	  		
	  		//set endLoop to list's size, if zero value has been passed over to method
	  		if(endLoop == 0) {
	  			endLoop = list_clsOlis.size();
	  		}
	  		
	  		//override certain Items
	  		Integer i = 0;
	  		for (ClsOrderLineItem clsOli : list_clsOlis) {
	  			if (i>= beginLoop && i<=endLoop) {
	  				clsOli.oli.Ship_From__c = header.Ship_From__c;
	  			}
	  			i=i+1;
	  		}
  		}
  	}*/ 
  	 
  	private void queryExistingItems() {
  		//query existing line items for existing order 
  		System.debug('********** Query Existing Items **********');
  		System.debug('--> Header ID passed to the function: ' + this.header.Id);
  		for(Order_Line_Item__c oli : [Select o.CreatedById, o.CreatedDate, o.CurrencyIsoCode, o.Customer_PO_No__c, o.Extended_Price__c, o.Id, o.IsDeleted, o.Item__c, 
  			o.LastModifiedById, o.LastModifiedDate, o.Legacy_System_ID__c, o.Name, o.Order__c, o.Order_Group__c, 
  			o.Override_Price__c, o.Patient_Ref_No__c, Ship_From__c,  
  			o.Product_SKU__c, o.Product_SKU__r.Name, o.Product_SKU__r.Description, o.PS_Product_SKU__c, o.Product_SKU__r.Unit_of_Measure__c, 
  			o.Product_SKU__r.Maximum_Order_Qty__c, o.Product_SKU__r.Multiple_Order_Qty__c, o.Product_SKU__r.Family,
  			o.Lookup_Quantity__c, o.Lookup_Quantity__r.Ship_From__c, o.Lookup_Quantity__r.Quantity_in_Stock__c, o.Lookup_Quantity__r.Name, 
  			o.Quantity__c, o.SystemModstamp, o.Unit_Price__c from Order_Line_Item__c o
  			where o.Order__c = :header.Id order by o.Item__c]) {
  		
  			ClsOrderLineItem clsOli = new clsOrderLineItem();			
						
			clsOli.SKU_field = oli.Product_SKU__r.Name;
			clsOli.validSKU = true;
			
			clsOli.oli = oli;
			clsOli.pc = oli.Product_SKU__r;
			//clsOli.inv = oli.Lookup_Quantity__r;
			this.list_clsOlis.add(clsOli);
  		}
  		//colorQuantities();
  		//queryAllProductCatalog();
  		
  	}
  	
  	public PageReference queryLineItemData() {
   		System.debug('********** queryLineItemData **********');
  		Integer itemNumber = getItemNumber();
  		System.debug('-> PARAM: ' + ApexPages.currentPage().getParameters().get('itemNo'));
  		System.debug('--> returned itemNumber: ' + itemNumber);
  		System.debug('--> list_clsOlis[itemNumber].SKU_mod: ' + list_clsOlis[itemNumber].SKU_mod);
  		System.debug('--> list_clsOlis[itemNumber].SKU_lkid: ' + list_clsOlis[itemNumber].SKU_lkid);
  		System.debug('--> list_clsOlis[itemNumber].SKU_lkold: ' + list_clsOlis[itemNumber].SKU_lkold);
  		System.debug('--> list_clsOlis[itemNumber].oli.Product_SKU__c: ' + list_clsOlis[itemNumber].oli.Product_SKU__c);
  		System.debug('--> list_clsOlis[itemNumber].SKU_oldId: ' + list_clsOlis[itemNumber].SKU_oldId);
  		if (list_clsOlis[itemNumber].SKU_mod == '1' || list_clsOlis[itemNumber].SKU_lkold == '' || 
  			list_clsOlis[itemNumber].SKU_field == list_clsOlis[itemNumber].SKU_lkold && list_clsOlis[itemNumber].SKU_field != ''){
  			//list_clsOlis[itemNumber].SKU_field != list_clsOlis[itemNumber].SKU_lkold
  			//list_clsOlis[itemNumber].SKU_lkid != '' && 
  			
  			System.debug('--> Changes in SKU field detected');
  			list_clsOlis[itemNumber].SKU_oldId = list_clsOlis[itemNumber].oli.Product_SKU__c;
  			
  			//System.debug('--> lkid has content');
  			
  			Id productId = getProductId(itemNumber); //add PARAM
  			if (productId != null){
  				System.debug('--> ProductId is NULL - Setting SKU_mod = 0');
  				list_clsOlis[itemNumber].SKU_mod = '0';
  				//list_clsOlis[itemNumber].validSKU = true;  				
  			} 
  			
  			System.debug('--> Setting ProductId');
  			list_clsOlis[itemNumber].oli.Product_SKU__c = productId;
  			System.debug('--> productId received! productId: ' + productId);
  			
	  		
	  		//if (list_clsOlis[itemNumber].SKU_oldId != list_clsOlis[itemNumber].oli.Product_SKU__c && list_clsOlis[itemNumber].SKU_oldId != null){
	  		if (list_clsOlis[itemNumber].validSKU){
	  			System.debug('--> SKU has changed. Querying for Inventory and ProductData.');
	  			queryInventory(itemNumber); //add PARAM
	  			queryProductCatalog(itemNumber); //add PARAM
	  		}
	  		jumpBackToSKU = !list_clsOlis[itemNumber].validSKU;
  		}  		  		
  		
  		return null; 		
  	}
  	
  	/*public PageReference storeProductId(){
  		System.debug('********** storeProductId **********');
  		System.debug('--> getItemNumber: ' + getItemNumber());
  		if (list_clsOlis[getItemNumber()].SKU_lkid != ''){
  			list_clsOlis[getItemNumber()].oli.Product_SKU__c = list_clsOlis[getItemNumber()].SKU_lkid; 
  		}
  		
  		return null;
  	}*/
  	
  	/*private String queryShipToId(){
  		String returnValue;
  		if (header.Account__c != null){
	  		Account a = [Select Id, Ship_To_Id__c, Business_Unit__c from Account where Id = :header.Account__c limit 1];
	  		this.header.Business_Unit__c = a.Business_Unit__c;
  			returnValue = a.Ship_To_Id__c;
  		}
  		return returnValue;
  	}*/
  	
  	private void queryShipToIdBU(){
  		System.debug('********** queryShipToIdBU **********');
  		if (header.Account__c != null){
	  		Account a = [Select Id, Ship_To_Id__c, Business_Unit__c, SETID__c from Account where Id = :header.Account__c limit 1];
	  		System.debug('--> Setting SetID and Business Unit');
	  		//this.header.Business_Unit__c = a.Business_Unit__c;
	  		
	  		//only for NORDICs pilot
	 		this.header.Business_Unit__c = a.SETID__c;
  			
  			this.header.Ship_To_ID__c = a.Ship_To_Id__c;
  			this.previousShipToId = this.header.Ship_To_Id__c;
  			
  		}
  	}
  	
  	public void queryProductCatalog(Integer itemNumber) {
  		System.debug('********** queryProductCatalog **********');
  		//Integer itemNumber = getItemNumber(); //replace by PARAM
  		
  		Order_Line_Item__c oli = list_clsOlis[itemNumber].oli;
  		//ProductCatalog__c pc = list_clsOlis[getItemNumber].pc;
  		System.debug('--> oli.Product_SKU__c: ' + oli.Product_SKU__c);
  		//List<ProductCatalog__c> list_pcs = [Select Name, Maximum_Order_Qty__c, Multiple_Order_Qty__c, Product_Category__c, Product_Description__c, PS_Product_SKU__c, Unit_of_Measure__c from ProductCatalog__c where Id =: oli.Product_SKU__c limit 1];
  		List<Product2> list_pcs = [Select Name, Maximum_Order_Qty__c, Multiple_Order_Qty__c, Family, Description, PS_Product_SKU__c, Unit_of_Measure__c from Product2 where Id =: oli.Product_SKU__c limit 1];
  		if (list_pcs.size()>0) {
  			list_clsOlis[itemNumber].pc = list_pcs[0];
  			list_clsOlis[itemNumber].productDescription = list_pcs[0].Description;
  			list_clsOlis[itemNumber].UOM = list_pcs[0].Unit_of_Measure__c;
  			list_clsOlis[itemNumber].max = list_pcs[0].Maximum_Order_Qty__c;
  			list_clsOlis[itemNumber].mult = list_pcs[0].Multiple_Order_Qty__c;
  		}
  	}

	/*public void queryAllProductCatalog() {
  		Set<Id> set_productIds = new Set<Id>();
		Set<String> set_SKUs = new Set<String>();
		Map<Id, String> map_productId_SKU = new Map<Id, String>();
		Map<Id,ProductCatalog__c> map_productId_product = new Map<Id,ProductCatalog__c>();
		
		
		//prepare further queries with set from product Id
		for (Integer i=0; i<list_clsOlis.size();i++){					
	  		System.debug('--> i = ' + i);
	  		Order_Line_Item__c oli = list_clsOlis[i].oli;
	  		if(oli.Product_SKU__c != null){
	  			set_productIds.add(list_clsOlis[i].oli.Product_SKU__c);
	  		}
		}
		
		for (ProductCatalog__c pc : [Select Name, Maximum_Order_Qty__c, Multiple_Order_Qty__c, Product_Category__c, Product_Description__c from ProductCatalog__c where Id IN : set_productIds]){				
	  		String SKU = pc.Name;
	  		if(SKU != null) {
	  			System.debug('--> SKU: ' + SKU);		  					  		
			  	map_productId_SKU.put(pc.Id, SKU);
			  	map_productId_product.put(pc.Id, pc);
			  	set_SKUs.add(SKU);
	  		}
		}
		
		for (Integer itemNumber = 0; itemNumber < list_clsOlis.size(); itemNumber++){					
	  		System.debug('--> itemNumber = ' + itemNumber);
	  		Order_Line_Item__c oli = list_clsOlis[itemNumber].oli;
	  		if(oli.Product_SKU__c != null){ 
				System.debug('--> oli.Product_SKU__c: ' + oli.Product_SKU__c);
				list_clsOlis[itemNumber].pc = map_productId_product.get(oli.Product_SKU__c);
	  		}
		}
  	}*/
	  	
  	private Integer getItemNumber() {
  		System.debug('********** getItemNumber **********');
  		//cast passed value from apex:param from String to Integer
  		system.debug('--> ActualItem: ' + this.actualItem);
  		Integer itemNumber;
  		try{
  			itemNumber = Double.valueOf(this.actualItem).intValue();
  		} catch (Exception e) {
  			System.debug('Double Value: ' + Double.valueOf(this.actualItem));
  			itemNumber = Integer.valueOf(this.actualItem);
  		}  	
  		system.debug('--> itemNumber: ' + itemNumber);
  		
  		return itemNumber;	
  	}
  	
  	private Integer getActualLineItemValue() {
  		System.debug('********** getActualLineItemValue **********');
  		//cast passed value from apex:param from String to Integer
  		system.debug('--> ActualItem: ' + this.actualLineItem);
  		Integer itemNumber;
  		try{
  			itemNumber = Double.valueOf(this.actualLineItem).intValue();
  		} catch (Exception e) {
  			System.debug('Double Value: ' + Double.valueOf(this.actualLineItem));
  			itemNumber = Integer.valueOf(this.actualLineItem);
  		}  	
  		system.debug('--> itemNumber: ' + itemNumber);
  		
  		return itemNumber;	
  	}
  	
  	private Id getProductId(Integer itemNumber){
  		System.debug('********** getting Product ID **********');
  		//Integer itemNumber = getItemNumber(); //replaced by PARAM  		
  		Order_Line_Item__c oli = list_clsOlis[itemNumber].oli;
  		//list_clsOlis[itemNumber].SKU_field == list_clsOlis[itemNumber].SKU_lkold
  		//querying product catalogue information
  		//String SOQL = 'Select Id, Name, PS_Product_SKU__c, Unit_of_Measure__c from ProductCatalog__c where ';
  		String SOQL = 'Select Name, Maximum_Order_Qty__c, Multiple_Order_Qty__c, Family, Description, PS_Product_SKU__c, Unit_of_Measure__c from Product2 where ';
  		if (list_clsOlis[itemNumber].SKU_lkid != '') {
  			System.debug('--> lkid found');
  			SOQL += 'Id = \'' + list_clsOlis[itemNumber].SKU_lkid + '\'';
  		} else {
  			System.debug('--> search for Name with LIKE');
  			if (list_clsOlis[itemNumber].SKU_field == list_clsOlis[itemNumber].SKU_lkold){
  				SOQL += 'Name = \'' + list_clsOlis[itemNumber].SKU_field + '\'';
  			} else {
  				SOQL += 'Name like \'' + list_clsOlis[itemNumber].SKU_field + '%\'';
  			}
  			//SOQL += 'Name = \'' + list_clsOlis[itemNumber].SKU_field + '\'';
  		}
  		
  		SOQL += ' limit 2'; //is does not matter how much records are really in there, it just matters if it one or more records that matches
  		
  		System.debug('--> SOQL: ' + SOQL);
  		//List<ProductCatalog__c> list_pcs = Database.query(SOQL);
  		List<Product2> list_pcs = Database.query(SOQL);
  		
  		if (list_pcs.size()== 1) {
  			System.debug('--> Returning Product.Id: ' + list_pcs[0].Id);
  			list_clsOlis[itemNumber].SKU_field = list_pcs[0].Name;
  			list_clsOlis[itemNumber].oli.PS_Product_SKU__c = list_pcs[0].PS_Product_SKU__c;
  			list_clsOlis[itemNumber].validSKU = true;
  			return list_pcs[0].Id;
  		} else {
  			Boolean foundExactMatch = false;
  			Id returnValue;
  			for (Product2 p : list_pcs){
  				if(list_clsOlis[itemNumber].SKU_field == p.Name){
  					foundExactMatch = true;
  					System.debug('--> Returning Product.Id: ' + list_pcs[0].Id);
		  			list_clsOlis[itemNumber].SKU_field = p.Name;
		  			list_clsOlis[itemNumber].oli.PS_Product_SKU__c = p.PS_Product_SKU__c;
		  			list_clsOlis[itemNumber].validSKU = true;
  					returnValue = p.Id;
  					break;
  				}
  			}
  			if (foundExactMatch == false){
	  			list_clsOlis[itemNumber].SKU_lkid = '';
  				list_clsOlis[itemNumber].validSKU = false;
  				return null;
  			}  else {
  				return returnValue;
  			}
  		}  		
  	}
  	
  	private String getSKU(){
  		Order_Line_Item__c oli = list_clsOlis[getItemNumber()].oli; //replace by PARAM
  		//querying product catalogue information
  		//List<ProductCatalog__c> list_pcs = [Select Name from ProductCatalog__c where Id =: oli.Product_SKU__c limit 1];
  		List<Product2> list_pcs = [Select Name, PS_Product_SKU__c from Product2 where Id =: oli.Product_SKU__c limit 1];
  		if (list_pcs.size()>0) {
  			System.debug('--> Product.SKU: ' + list_pcs[0].PS_Product_SKU__c );
  			return list_pcs[0].PS_Product_SKU__c;
  		} else {
  			return null;
  		}  		
  	}
  	
  	public void checkQuantities() {  		
  		System.debug('********** Check All Quantities **********');
		//TODO: optimize SOQL query by adding a concatenated field on Inverntory__c (Name & ShipFrom) 
		//TODO: optimize SOQL for SKU
		Set<Id> set_productIds = new Set<Id>();
		Set<String> set_SKUs = new Set<String>();
		Map<Id, String> map_productId_SKU = new Map<Id, String>();
		
		//Map<Id,ProductCatalog__c> map_productId_product = new Map<Id,ProductCatalog__c>();
		Map<Id,Product2> map_productId_product = new Map<Id,Product2>();
		
		
		//prepare further queries with set from product Id
		for (Integer i=0; i<list_clsOlis.size();i++){					
	  		System.debug('--> i = ' + i);
	  		Order_Line_Item__c oli = list_clsOlis[i].oli;
	  		if(list_clsOlis[i].validSKU){
	  			String shipFrom = list_clsOlis[i].oli.Ship_From__c; 
	  			System.debug('--> ProductId: ' + list_clsOlis[i].oli.Product_SKU__c);
	  			set_productIds.add(list_clsOlis[i].oli.Product_SKU__c);
	  		}
		}
		
		//for (ProductCatalog__c pc : [Select Id, Name, Maximum_Order_Qty__c, Multiple_Order_Qty__c, Product_Category__c, Product_Description__c, PS_Product_SKU__c, Unit_of_Measure__c from ProductCatalog__c where Id IN : set_productIds]){
		for (Product2 pc : [Select Id, Name, Maximum_Order_Qty__c, Multiple_Order_Qty__c, Family, Description, PS_Product_SKU__c, Unit_of_Measure__c from Product2 where Id IN : set_productIds]){
	  		String SKU = pc.Name;
	  		if(SKU != null) {
	  			System.debug('--> SKU: ' + SKU);		  					  		
			  	map_productId_SKU.put(pc.Id, SKU);
			  	map_productId_product.put(pc.Id, pc);
			  	set_SKUs.add(SKU);
	  		}
		}
		
		for (Integer itemNumber = 0; itemNumber < list_clsOlis.size(); itemNumber++){					
	  		System.debug('--> itemNumber = ' + itemNumber);
	  		Order_Line_Item__c oli = list_clsOlis[itemNumber].oli;
	  		if(list_clsOlis[itemNumber].validSKU){ 
				System.debug('--> oli.Product_SKU__c: ' + oli.Product_SKU__c);
				list_clsOlis[itemNumber].pc = map_productId_product.get(oli.Product_SKU__c);
				
				System.debug('--> Setting PC and INV');
				//ProductCatalog__c pc = list_clsOlis[itemNumber].pc;				
				Product2 pc = list_clsOlis[itemNumber].pc;
				Inventory__c inv = list_clsOlis[itemNumber].inv;
				
				System.debug('--> Setting FontColor to BLACK');
				list_clsOlis[itemNumber].quantityColor='black';
				list_clsOlis[itemNumber].maxColor='black';
				list_clsOlis[itemNumber].stockColor='black';
				list_clsOlis[itemNumber].multipleColor='black';
				
				if (oli.Quantity__c != null){
					Integer qty = oli.Quantity__c.intValue();
					if (pc != null){
						System.debug('--> Setting PC data');
						Integer max = 0;
						if (pc.Maximum_Order_Qty__c != null){
							max = pc.Maximum_Order_Qty__c.intValue();
						}
						
						Integer multiple = 0;
						if (pc.Multiple_Order_Qty__c != null && pc.Multiple_Order_Qty__c > 0){
							multiple = pc.Multiple_Order_Qty__c.intValue();
							if(math.mod(qty,multiple) != 0) {
								list_clsOlis[itemNumber].quantityColor='red';
								list_clsOlis[itemNumber].multipleColor='red';
							}
						}
					
						if(qty > max){
							list_clsOlis[itemNumber].quantityColor='red';
							list_clsOlis[itemNumber].maxColor='red';
						}						
					}
					
					
					if(inv != null){
						System.debug('--> Setting INV data');
						Integer stock = 0;
						if (inv.Quantity_in_Stock__c != null){
							stock = inv.Quantity_in_Stock__c.intValue();
						}
					
						if(qty>stock){
							list_clsOlis[itemNumber].quantityColor='red';
							list_clsOlis[itemNumber].stockColor='red';
						}
					}
									
					if(qty == 0){
						list_clsOlis[itemNumber].quantityColor='red';
					}
				}	
			}
		}							  
	
  	}
  	
  	public void colorQuantities(){
  		for (Integer itemNumber = 0; itemNumber < list_clsOlis.size(); itemNumber++){					
	  		System.debug('--> itemNumber = ' + itemNumber);
	  		Order_Line_Item__c oli = list_clsOlis[itemNumber].oli;
	  		if(list_clsOlis[itemNumber].validSKU){ 
				System.debug('--> oli.Product_SKU__c: ' + oli.Product_SKU__c);								
				System.debug('--> Setting PC and INV');
				//ProductCatalog__c pc = list_clsOlis[itemNumber].pc;
				Product2 pc = list_clsOlis[itemNumber].pc;				
				Inventory__c inv = list_clsOlis[itemNumber].inv;
				
				System.debug('--> Setting FontColor to BLACK');
				list_clsOlis[itemNumber].quantityColor='black';
				list_clsOlis[itemNumber].maxColor='black';
				list_clsOlis[itemNumber].stockColor='black';
				list_clsOlis[itemNumber].multipleColor='black';
				
				if (oli.Quantity__c != null){
					Integer qty = oli.Quantity__c.intValue();
					if (pc != null){
						System.debug('--> Setting PC data');
						Integer max = 0;
						if (pc.Maximum_Order_Qty__c != null){
							max = pc.Maximum_Order_Qty__c.intValue();
						}
						
						Integer multiple = 0;
						if (pc.Multiple_Order_Qty__c != null){
							multiple = pc.Multiple_Order_Qty__c.intValue();
							if(math.mod(qty,multiple) != 0) {
								list_clsOlis[itemNumber].quantityColor='red';
								list_clsOlis[itemNumber].multipleColor='red';
							}
						}
					
						if(qty > max){
							list_clsOlis[itemNumber].quantityColor='red';
							list_clsOlis[itemNumber].maxColor='red';
						}						
					}
					
					
					if(inv != null){
						System.debug('--> Setting INV data');
						Integer stock = 0;
						if (inv.Quantity_in_Stock__c != null){
							stock = inv.Quantity_in_Stock__c.intValue();
						}
					
						if(qty>stock){
							list_clsOlis[itemNumber].quantityColor='red';
							list_clsOlis[itemNumber].stockColor='red';
						}
					}
									
					if(qty == 0){
						list_clsOlis[itemNumber].quantityColor='red';
					}
				}	
			}
		}
  	}
  	
  	public void queryInventory(Integer itemNumber) {  		
  		System.debug('********** Query Inventory **********');
		
		//Integer itemNumber = getItemNumber(); //replace by PARAM
		System.debug('--> ItemNumber : ' + itemNumber);
  		String SKU = getSKU(); //add PARAM
  		String shipFrom = list_clsOlis[itemNumber].oli.Ship_From__c;
  		if(SKU != null) {
  			System.debug('--> SKU: ' + SKU);
	  		
		  		//Inventory__c inv = list_clsOlis[getItemNumber()].inv;
		  		
		  		List<Inventory__c> list_invs = [Select Quantity_in_Stock__c, Ship_From__c from Inventory__c 
		  			where Name = :SKU and Ship_From__c = :shipFrom limit 1];		  		
		  		
		  		Integer stock = 0;
		  		if (list_invs.size() > 0){
		  			stock = list_invs[0].Quantity_in_Stock__c.intValue();
		  		}
		  		
		  		System.debug('--> Inventory.Quantity_in_Stock__c: ' + stock);		  		
		  		list_clsOlis[itemNumber].inv.Quantity_in_Stock__c = stock;
		  		list_clsOlis[itemNumber].stock = stock;
  		
  		} else {
  			System.debug('--> SKU: null');
  		}
  	}
  	
  	private void queryAllInventory() {  		
  		System.debug('********** Query ALL Inventory **********');
		// get ProductSKU and ShipFrom
		Set<String> set_matchKey = new Set<String>();
		Map<String, Double> map_matchKey_stock = new Map<String, Double>();
		
		for (Integer itemNumber = 0; itemNumber < list_clsOlis.size(); itemNumber++){					
	  		System.debug('--> itemNumber = ' + itemNumber);
	  		String SKU;
	  		String shipFrom;
	  		if (list_clsOlis[itemNumber].validSKU){
	  			System.debug('--> valid SKU, prepare Set for Inventory query');
	  			//SKU = list_clsOlis[itemNumber].SKU_field;
	  			SKU = list_clsOlis[itemNumber].oli.PS_Product_SKU__c;
	  			shipFrom = list_clsOlis[itemNumber].oli.Ship_From__c;	  			
	  			String matchKey = SKU + '||' + shipFrom; 
	  			System.debug('--> adding MatchKey to Set: ' + matchKey);
	  			set_matchKey.add(matchKey); 	
	  		}
		}
		
		for (Inventory__c inv : [Select Quantity_in_Stock__c, Ship_From__c, Name_ShipFrom__c from Inventory__c 
			where Name_ShipFrom__c in : set_matchKey]){	
	  		
	  		map_matchKey_stock.put(inv.Name_ShipFrom__c, inv.Quantity_in_Stock__c);
		}
	  		
	  	for (Integer itemNumber = 0; itemNumber < list_clsOlis.size(); itemNumber++){					
	  		System.debug('--> itemNumber = ' + itemNumber);
	  		String SKU;
	  		String shipFrom;
	  		String matchKey;
	  		
	  		if (list_clsOlis[itemNumber].validSKU){
	  			SKU = list_clsOlis[itemNumber].SKU_field;
	  			shipFrom = list_clsOlis[itemNumber].oli.Ship_From__c;
	  			matchKey = SKU + '||' + shipFrom; 		  			
	  			System.debug('--> MatchKey: ' + matchKey);
	  			if (map_matchKey_stock.containsKey(matchKey)){
		  			Integer stock = map_matchKey_stock.get(matchKey).intValue();
		  			System.debug('--> Stock: ' + stock);
		  			list_clsOlis[itemNumber].inv.Quantity_in_Stock__c = stock;
	  			}
	  		}	
	  	}	
	  		
  	}
 
 	private void queryBusinessUnits(String setId, String BU){
 		System.debug('********** queryBusinessUnit **********');
 		System.debug('--> setId: ' + setId);
 		System.debug('--> BU: ' + BU);
 		if (BU == null){	 		
	 		String SOQL = 'Select Id, Order_Entry__c, Business_Unit__c, SetID__c from SetIDBusinessUnit__c where Order_Entry__c = true ';
	 		if (setId != null){
	 			SOQL += 'and SetID__c = \'' + this.header.SetID__c + '\' ';
	 		}
	 		//SOQL += 'limit 1000';
	 		Integer i = 0;
	 		this.list_BusinessUnits.clear();
	 		this.map_businessUnit_setId.clear();
	 		for (SetIDBusinessUnit__c match : database.query(SOQL)){
	 			i += 1;
	 			SelectOption option = new SelectOption(match.Business_Unit__c,match.Business_Unit__c);
	 			this.list_BusinessUnits.add(option);
	 			this.map_businessUnit_setId.put(match.Business_Unit__c,match.SetID__c);
	 			if (i == 1){
	 				this.header.SETID__c = match.SetID__c;
	 			}
	 		}
 		} else {
 			SelectOption option = new SelectOption(BU, BU);
	 		this.list_BusinessUnits.add(option);
 		}
 	}
 	
 	public PageReference changeBusinessUnit(){ 		
 		String BU = this.header.Business_Unit__c;
 		//this.header = new Order_Header__c();
 		this.header.SETID__c = this.map_businessUnit_setId.get(BU); 		
 		
 		this.header.Ship_To_ID__c = this.previousShiptoId;
 		this.validShipToId = false;
		this.renderShipToOptions = false;
		
		defaultValues('ALL');
		
 		return null;
 	}
 	
 	public PageReference queryShipToDetails(){ 			
 		System.debug('********** Querying ShipToDetails **********');
 		String shipToId = header.Ship_To_Id__c + '%';
 		System.debug('--> ShipToId found in header: ' + shipToId);
 		System.debug('--> this.header.Business_Unit__c:' + this.header.Business_Unit__c);
 		System.debug('--> this.previousShipToId: ' + this.previousShipToId);
 		System.debug('--> this.validShipToId: ' + this.validShipToId);
 		//if (cloneHeader != null){
 		//	System.debug('--> ShipToId found in cloneHeader: ' + cloneHeader.Ship_To_Id__c);
 		//}
 		
 		if((this.isPageLoad) || (this.previousShipToId != this.header.Ship_To_Id__c) || (this.previousShipToId == this.header.Ship_To_Id__c && this.validShipToId == false)){
 		
	 		/*Select a.Account_Address_Notes__c, a.Account_Name_Doorway_Id__c, a.AnnualRevenue, a.Bill_To__c, 
	 			a.Bill_To_Credit_Hold__c, a.Bill_To_Credit_Hold_Flag__c, a.Bill_To_Name__c, a.Bill_To_SETID_CUSTID__c, a.BillingCity, 
	 			a.BillingCountry, a.BillingPostalCode, a.BillingState, a.BillingStreet, a.Business_Unit__c, a.City_and_Street_Address__c, a.CreatedById, 
	 			a.CreatedDate, a.CurrencyIsoCode, a.Customer_Segment_1__c,  a.Customer_Type__c, a.Description, a.Doorway_Id__c, 
	 			a.Doorway_Rollup_Prior_Year_QTD__c, a.Doorway_Rollup_Prior_Year_YTD__c, a.Doorway_Rollup_QTD__c, a.Doorway_Rollup_YTD__c, 
	 			a.Fax, a.Id, a.Industry, a.IsDeleted, a.LastActivityDate, a.LastModifiedById, a.LastModifiedDate, a.Legacy_System_Id__c, 
	 			a.Legacy_System_Name__c, a.MasterRecordId, a.Name, a.Name_of_Account__c, a.Name_on_the_Door__c, a.NumberOfEmployees, a.OwnerId, 
	 			a.Parent_Id__c, a.Parent_Name__c, a.ParentId, a.Phone, a.Practitioner_Rewards__c, a.Preferred_Ship_Via__c, a.Preferred_Carrier__c, a.Primary_Ship_To__c, a.Primary_Ship_To_Name__c, 
	 			a.Primary_Ship_To_SETID_CUSTID__c, a.RecordTypeId, a.RecordType.Name, a.Routing_Day__c, a.Routing_Zone__c, a.SETID__c,  
	 			a.Ship_To_Rollup_Prior_Year_QTD__c, a.Ship_To_Rollup_Prior_Year_YTD__c, a.Ship_To_Rollup_QTD__c, a.Ship_To_Rollup_YTD__c, 
	 			a.ShippingCity, a.ShippingCountry, a.ShippingPostalCode, a.ShippingState, a.ShippingStreet, a.SystemModstamp, a.Type,
	 			a.Ship_To_Address_1__c, a.Ship_To_Address_2__c, a.Bill_To_Address_1__c, a.Bill_To_Address_2__c, 
	 			a.US_ITM_Worked__c, a.Website, a.Worked__c, a.Ship_To_Id__c from Account a
	 		*/
	 		
	 		//a.Customer_Segment_2__c,
	 		List<Account> list_accs = [Select a.Bill_To__c, a.Bill_To_Address_1__c, a.Bill_To_Address_2__c, a.Bill_To_Credit_Hold__c, 
				a.Bill_To_Credit_Hold_Flag__c, a.Bill_To_Name__c, a.Bill_To_SETID_CUSTID__c, a.BillingCity, a.BillingCountry, 
				a.BillingPostalCode, a.BillingState, a.BillingStreet, a.Business_Unit__c, a.CurrencyIsoCode, a.Description, a.Fax, 
				a.Id, a.Name, a.Phone, a.Preferred_Carrier__c, a.Preferred_Ship_Via__c, a.Primary_Ship_To__c, a.RecordTypeId, 
				a.RecordType.Name, a.SETID__c, a.Ship_To_Address_1__c, a.Ship_To_Address_2__c, a.Ship_To_Id__c, a.ShippingCity, 
				a.ShippingCountry, a.ShippingPostalCode, a.ShippingState, a.ShippingStreet from Account a 
	 			where a.RecordType.Name = 'Ship To Account' and a.Ship_To_Id__c like :shipToId 
	 			and (a.SETID__c = 'NORSE' OR a.SETID__c = 'NORNO' OR a.SETID__c = 'NORDK' OR a.SETID__c = 'NORFI') 
	 			order by a.Ship_To_Id__c ASC limit 10];
	 			//and a.Business_Unit__c = :this.header.Business_Unit__c
	 		
	 		//a.RecordType.Name = 'Nordic CSS Accounts'	
	 		list_selectableShipToIds.clear();  		
	 		System.debug('--> Analysing query results');
	 		System.debug('--> # of query results: ' + list_accs.size());
	 		if (list_accs.size() == 1){
	 			System.debug('--> One record matching');
	 			Account acc = list_accs[0];
	 			account = acc;
	 			System.debug('--> Account found with Id: ' + acc.Id + '  --> ShipToId: ' + acc.Ship_To_Id__c);
	 			
	 			System.debug('--> default Values');
	 			defaultValues('WITHOUT_ACCOUNT');
	 			
	 			this.header.CurrencyIsoCode = acc.CurrencyIsoCode;
	 			setItemCurrency();
	 			
	 			this.header.Ship_To_ID__c = acc.Ship_To_Id__c;
	 			this.previousShipToId = this.header.Ship_To_Id__c;
	 			
	 			this.header.Account__c = acc.Id;
	 			this.shipToAccountName = acc.Name;
	 			this.header.SETID__c = acc.SETID__c; //added during UAT
	 			this.header.Delivery_Name__c = acc.Name; 			
	 			this.header.Ship_To_Address_1__c = acc.Ship_To_Address_1__c; //acc.ShippingStreet; //
	 			this.header.Ship_To_Address_2__c = acc.Ship_To_Address_2__c; //ShippingStreet
	 			this.header.Ship_To_City__c = acc.ShippingCity;
	 			this.header.Ship_To_Postcode__c = acc.ShippingPostalCode;
	 			this.header.Address_Override__c = false;
	 			
	 			this.header.Bill_To_ID__c = acc.Bill_To__c; 
	 			//this.billToDetails.Ship_To_ID__c = acc.Bill_To__c;	 				 			
	 			//this.billToDetails.Account__c = acc.Id;
	 			//this.billToDetails.Account__c = acc.Id;
	 			this.billToAccountName = acc.Bill_To_Name__c;
	 			this.header.Bill_To_Account_Name__c = acc.Bill_To_Name__c;
	 			//this.billToDetails.Ship_To_Address_1__c = acc.Bill_To_Address_1__c; //BillingStreet
	 			this.header.Bill_To_Address_1__c = acc.Bill_To_Address_1__c; //BillingStreet
	 			//this.billToDetails.Ship_To_Address_2__c = acc.Bill_To_Address_2__c; //BillingStreet
	 			this.header.Bill_To_Address_2__c = acc.Bill_To_Address_2__c; //BillingStreet
	 			//this.billToDetails.Ship_To_City__c = acc.BillingCity;
	 			this.header.Bill_To_City__c = acc.BillingCity;
	 			//this.billToDetails.Ship_To_Postcode__c = acc.BillingPostalCode;
	 			this.header.Bill_To_Postcode__c = acc.BillingPostalCode;
	 			

	 			//only for NORDICs pilot
	 			this.header.Business_Unit__c = acc.SETID__c;
	 			
	 			this.renderShipToOptions = false;
	 			this.validShipToId = true;
	 			
	 			displayAccountDescriptionMessage(acc.Description);
	 			storeAdressfields(); 
	 			
	 			if(acc.Bill_To_Credit_Hold_Flag__c == 'Yes') {
	 				displayCreditOnHoldMessage();
	 			}
	 			
	 			//TODO: 
	 			//predefault BU for Account...
	 			header.Telephone__c = acc.Phone;
	 			header.Fax__c = acc.Fax;
	 			header.Carrier__c = acc.Preferred_Carrier__c;
	 			if (acc.Preferred_Ship_Via__c != null){
	 				header.Ship_Via__c = acc.Preferred_Ship_Via__c.toUpperCase();
	 			} else {
	 				header.Ship_Via__c = acc.Preferred_Ship_Via__c;
	 			}
	 			
	 			/*this.header.Partial_Order__c ='Yes';
				this.header.Partials__c = 'Yes';
				this.header.Cancel_Back_Order__c = 'No';
				
				this.header.Home_delivery__c = 'No';
				this.header.Freight_Amount__c = 0;
				this.header.Charge_Freight__c = 'Yes';
				//calculateFreightAmount();*/
				calculateFreightAmount();
	 			
	 		} else if (list_accs.size() > 1) {
	 			System.debug('--> # of similar ShipToIds found: ' + list_accs.size());
	 			SelectOption noneOption = new SelectOption('', '-- Multiple records found, please chose one from list below --');
	 			this.list_selectableShipToIds.add(noneOption);
	 			for (Account acc : list_accs) {
	 				SelectOption option = new SelectOption(acc.Ship_To_Id__c, acc.Ship_To_Id__c + ' (' + acc.Name + ')');
	 				System.debug('--> Adding SelectOption');
	 				this.list_selectableShipToIds.add(option);
	 			}
	 			this.renderShipToOptions = true;
	 			this.validShipToId = false;
	 					
	 		} else {
	 			this.validShipToId = false;
	 		}
 		}
 		return null;
 	}
 	
 	private void displayCreditOnHoldMessage(){
 		ApexPages.Message msgOnHold = new ApexPages.Message(ApexPages.Severity.INFO, 
        	'The chosen account is actually on CREDIT HOLD.');
  		ApexPages.addMessage(msgOnHold);
 	}
 	
 	private void displayAccountDescriptionMessage(String content){
 		if (content != null) {
	 		//content = content.replace('\n', '<br>');	 		
	 		ApexPages.Message msgAccountDesc = new ApexPages.Message(ApexPages.Severity.INFO, 
	        	'ACCOUNT INFORMATION: ' + content);
	  		ApexPages.addMessage(msgAccountDesc);
 		}
 	}
 	
 	public pageReference processSelectedShipToId() {
 		if(selectedShipToId != ''){
	 		this.renderShipToOptions = false;
	 		this.header.Ship_To_ID__c = selectedShipToId;
	 		this.previousShipToId = this.header.Ship_To_ID__c;
	 		selectedShipToId = '';
	 		queryShipToDetails(); //perhaps optimizable because in that method a SOQL query is done
 		}
 		return null;
 	}
 	
	public void calculatePrices(){
		for (Integer i = 0; i<list_clsOlis.size();i++){
			Order_Line_Item__c oli = list_clsOlis[i].oli;
			if(list_clsOlis[i].validSKU){
				oli.Unit_Price__c = oli.Item__c * 10 + (oli.Item__c + 1) * 3 * oli.Item__c;
			}	
		}
		calculateOrderValue();		
	}
	
	public void overrideAdressFields(){
		String oldHomeDelivery = this.header.Home_delivery__c;
		if(checkChangeInAdressfields()){
			this.header.Address_Override__c = true;
			this.header.Home_delivery__c = 'Yes';
			changeShippingFlagsToNo();
			calculateFreightAmount();
		} else {
			this.header.Address_Override__c = addressOverride;
			this.header.Home_delivery__c = homeDelivery;			
		}
		if(this.header.Home_delivery__c == 'Yes' && this.header.Home_delivery__c != oldHomeDelivery){
			List<Carrier__c> list_carriers= [Select Id, Name from Carrier__c where Name = 'IPT' LIMIT 1];
			if (list_carriers.size() > 0){
				this.header.Carrier__c = list_carriers[0].Id;
			} 
			this.header.Ship_Via__c = 'HOME_DEL';
		}		
	}
	
	public void changeHomeDelivery(){
		if (this.header.Home_delivery__c == 'No'){
			changeShippingFlagsToNo();
			this.header.Carrier__c = null;
			this.header.Ship_Via__c = 'GROUND';
			
			this.header.Partial_Order__c ='Yes';
			this.header.Partials__c = 'Yes';
			this.header.Cancel_Back_Order__c = 'No';
			
			calculateFreightAmount();
		}
	}
	
	private void storeAdressfields(){
		//address1 = this.header.Ship_To_Address_1__c;
		deliveryName = this.header.Delivery_Name__c;
		address1 = this.header.Ship_To_Address_1__c;
		address2 = this.header.Ship_To_Address_2__c;
		city = this.header.Ship_To_City__c;
		postCode = this.header.Ship_To_Postcode__c;
		addressOverride = this.header.Address_Override__c;
		homeDelivery = this.header.Home_Delivery__c;	
	}
	
	private Boolean checkChangeInAdressfields(){
		Boolean returnValue = true;
		//address1 == this.header.Ship_To_Address_1__c
		if(deliveryName == this.header.Delivery_Name__c && address1 == this.header.Ship_To_Address_1__c &&
			address2 == this.header.Ship_To_Address_2__c && city == this.header.Ship_To_City__c && postCode == this.header.Ship_To_Postcode__c){
			
			returnValue = false;
		} 	
		
		return returnValue;
	}
	
	public void changeShippingFlags(String value) {
		//change ShippingFlags to "VALUE"
		this.header.Partial_Order__c = value;
		this.header.Partials__c = value;
		this.header.Cancel_Back_Order__c = value;	
	}
	
	public void changeShippingFlagsToNo(){
		//change ShippingFlags to "No" because ShipToAddress has been overridden
		changeShippingFlags('No');
	}
	
	public PageReference changeShipFrom(){
		//add ItemNumber
		Integer itemNumber = getItemNumber();
		queryInventory(itemNumber);
		changeItemQuantityColor(itemNumber);
		return null;
	}
	
	public PageReference changeItemOrderGroup(){
		System.debug('********** changeItemOrderGroup **********');
		Integer itemNumber = getItemNumber();
		if (list_clsOlis[itemNumber].oli.Order_Group__c == 'FOC' || list_clsOlis[itemNumber].oli.Order_Group__c == 'FOCRPL'){
	  		list_clsOlis[itemNumber].oli.Override_Price__c = 0;	
	  	} else {
			list_clsOlis[itemNumber].oli.Override_Price__c = null;
	  	}		
		changeOverridePrice();
		return null;
	}
	
	public PageReference changeQuantity(){
		//this.actualItem = ApexPages.currentPage().getParameters().get('item');
		Integer itemNumber = getItemNumber(); //getActualLineItemValue(); //
		changeItemQuantityColor(itemNumber);
		calculateExtendedPrice(itemNumber);
		calculateFreightAmount();
		return null;
	}
	
	public PageReference changeOverridePrice(){
		System.debug('********** change Override Price **********'); 
		Integer itemNumber = getItemNumber();
		calculateExtendedPrice(itemNumber);
		calculateFreightAmount();
		return null;
	}
	
	private void calculateExtendedPrice(Integer itemNumber){
		System.debug('********** calculate Extended Price **********');
		//Integer itemNumber = getItemNumber(); //replace by PARAM
		
		System.debug('--> list_clsOlis[itemNumber].oli.Quantity__c: ' + list_clsOlis[itemNumber].oli.Quantity__c);
		System.debug('--> list_clsOlis[itemNumber].oli.Override_Price__c: ' + list_clsOlis[itemNumber].oli.Override_Price__c);
		if(list_clsOlis[itemNumber].oli.Quantity__c != null && list_clsOlis[itemNumber].validSKU){
			if(list_clsOlis[itemNumber].oli.Override_Price__c != null){
				list_clsOlis[itemNumber].oli.Extended_Price__c = list_clsOlis[itemNumber].oli.Quantity__c * list_clsOlis[itemNumber].oli.Override_Price__c;
			} else if (list_clsOlis[itemNumber].oli.Unit_Price__c != null){
				list_clsOlis[itemNumber].oli.Extended_Price__c = list_clsOlis[itemNumber].oli.Quantity__c * list_clsOlis[itemNumber].oli.Unit_Price__c;
			}
		}
	}
	
	private void calculateExtendedPrices(){
		System.debug('********** calculate EXTENDED PRICES **********');
		for (Integer itemNumber = 0; itemNumber<list_clsOlis.size();itemNumber++){
			System.debug('--> ItemNumber: ' + itemNumber);
			System.debug('--> list_clsOlis[itemNumber].oli.Quantity__c: ' + list_clsOlis[itemNumber].oli.Quantity__c);
			System.debug('--> list_clsOlis[itemNumber].oli.Override_Price__c: ' + list_clsOlis[itemNumber].oli.Override_Price__c);
			Order_Line_Item__c oli = list_clsOlis[itemNumber].oli;
			if(list_clsOlis[itemNumber].oli.Quantity__c != null && list_clsOlis[itemNumber].validSKU){
				if(list_clsOlis[itemNumber].oli.Override_Price__c != null){
					list_clsOlis[itemNumber].oli.Extended_Price__c = list_clsOlis[itemNumber].oli.Quantity__c * list_clsOlis[itemNumber].oli.Override_Price__c;
				} else if (list_clsOlis[itemNumber].oli.Unit_Price__c != null){
					list_clsOlis[itemNumber].oli.Extended_Price__c = list_clsOlis[itemNumber].oli.Quantity__c * list_clsOlis[itemNumber].oli.Unit_Price__c;
				}
			}
		}
	}
	
	public PageReference changeFreightOverride(){
		this.header.Freight_Override__c = true;
		return null;
	}
	
	public void calculateOrderValue(){
		System.debug('********** calculateOrderValue **********');
		this.orderValue = 0;
		for (Integer i = 0; i<list_clsOlis.size();i++){
			Order_Line_Item__c oli = list_clsOlis[i].oli;
			System.debug('--> i: ' + i + '; oli.Product_SKU__c: ' + oli.Product_SKU__c);
			if(list_clsOlis[i].validSKU && oli.Extended_Price__c != null){
				System.debug('--> ProductSKU != empty String');
				Double price = 0;
				//if (oli.Unit_Price__c != null && oli.Quantity__c != null) {
				//	price = oli.Unit_Price__c * oli.Quantity__c;
				//}
				this.orderValue += oli.Extended_Price__c;
			}	
		}
		System.debug('--> this.orderValue : ' + this.orderValue);
		this.header.Order_Amount__c = this.orderValue;
	}
	
	private void calculateTotalValue(){
		this.header.Total_Value__c = 0;
		if (this.header.Freight_Amount__c != null && this.header.Order_Amount__c != null){
			this.header.Total_Value__c = this.header.Freight_Amount__c + this.header.Order_Amount__c;
		}
	}
	
	public void calculateFreightAmount(){
		System.debug('********** calculate Freight Amount **********');
		calculateOrderValue();
		this.header.Freight_Override__c = false;
		//if (this.header.Charge_Freight__c == 'Yes'){
			String freightCode = 'Standard';
			
			//If HomeDelivery == YES
			if (this.header.Home_Delivery__c == 'Yes'){
				freightCode ='Home Delivery';
			}
			
			System.debug('--> FreightCode: ' + freightCode);
			System.debug('--> this.header.Order_Amount__c: ' + this.header.Order_Amount__c);		
			Freight_Set__c relevantFreight = new Freight_Set__c();
			Boolean freightAmountFound = false; 
			//if (this.header.Freight_Amount__c == null){
				this.header.Freight_Amount__c = 0;
			//}
			for (Freight_Set__c f : [Select f.Valid_To__c, f.Valid_From__c, f.Ship_To_ID__c, f.SETID__c, f.Min_Order_Amount__c, f.Max_Order_Amount__c, f.Id, 
				f.Freight_Code__c, f.Freight_Charge__c 
				From Freight_Set__c f
				Where (Freight_Code__c = : freightCode OR (Freight_Code__c = 'Special' AND Ship_To_ID__c = : this.header.ship_To_ID__c)) AND Valid_To__c >= :Date.today() AND Valid_From__c <= :Date.today() AND 
				Min_Order_Amount__c <= : this.header.Order_Amount__c AND Max_Order_Amount__c >= : this.header.Order_Amount__c AND SETID__c = : this.header.SETID__c]) {
				System.debug('--> Freight Terms Found: ' + f.Freight_Charge__c);
				System.debug('--> relevant Freight: ' + relevantFreight);
				if(!freightAmountFound || (freightAmountFound && f.Freight_Code__c == 'Special')){
				//if (relevantFreight == null || (relevantFreight != null && f.Freight_Code__c == 'Special')){
					System.debug('--> relevant Freight found');
					freightAmountFound = true;
					relevantFreight = f;
					if ((this.header.Charge_Freight__c == 'Yes' && f.Freight_Code__c != 'Special') || f.Freight_Code__c == 'Special'){
						this.header.Freight_Amount__c = f.Freight_Charge__c;
					}					
				}							
			}
		//} else {
		//	this.header.Freight_Amount__c = 0;
		//}
		calculateTotalValue();
		
	}
	
	/*public void OLDcheckQuantities(){
		System.debug('********** changeQuantityColor **********');
		//queryAllInventory();
		for (Integer itemNumber = 0; itemNumber<list_clsOlis.size();itemNumber++){
			System.debug('--> ItemNumber: ' + itemNumber);
			Order_Line_Item__c oli = list_clsOlis[itemNumber].oli;
			if(list_clsOlis[itemNumber].validSKU){ 
				//ProductCatalog__c pc = list_clsOlis[itemNumber].pc;				
				Product2 pc = list_clsOlis[itemNumber].pc;
				Inventory__c inv = list_clsOlis[itemNumber].inv;
				
				list_clsOlis[itemNumber].quantityColor='black';
				list_clsOlis[itemNumber].maxColor='black';
				list_clsOlis[itemNumber].stockColor='black';
				list_clsOlis[itemNumber].multipleColor='black';
				
				Integer qty = oli.Quantity__c.intValue();
				if (pc != null){
					Integer max =  pc.Maximum_Order_Qty__c.intValue();
					Integer multiple = pc.Multiple_Order_Qty__c.intValue();
				
					if(qty > max){
						list_clsOlis[itemNumber].quantityColor='red';
						list_clsOlis[itemNumber].maxColor='red';
					}
					if(math.mod(qty,multiple) != 0) {
						list_clsOlis[itemNumber].quantityColor='red';
						list_clsOlis[itemNumber].multipleColor='red';
					}
				}
				
				if(inv != null){
					Integer stock = inv.Quantity_in_Stock__c.intValue();
				
					if(qty>stock){
						list_clsOlis[itemNumber].quantityColor='red';
						list_clsOlis[itemNumber].stockColor='red';
					}
				}
								
				if(qty == 0){
					list_clsOlis[itemNumber].quantityColor='red';
				}	
			}	
		}
	}*/
	
	public void changeItemQuantityColorPage(){
		Integer itemNumber = getItemNumber();
		changeItemQuantityColor(itemNumber);
	}
	public void changeItemQuantityColor(Integer itemNumber){		
		System.debug('********** changeItemQuantityColor **********');
		//Integer itemNumber = getActualLineItemValue();
		//Integer itemNumber = getItemNumber();
		System.debug('--> ItemNumber: ' + itemNumber);
		
		if (itemNumber >= 0){
			//ProductCatalog__c pc = list_clsOlis[itemNumber].pc;
			Product2 pc = list_clsOlis[itemNumber].pc;
			Order_Line_Item__c oli = list_clsOlis[itemNumber].oli;
			Inventory__c inv = list_clsOlis[itemNumber].inv;
			
			System.debug('--> pc.Maximum_Order_Qty__c: ' + pc.Maximum_Order_Qty__c);
			
			
			
			list_clsOlis[itemNumber].quantityColor='black';
			list_clsOlis[itemNumber].maxColor='black';
			list_clsOlis[itemNumber].stockColor='black';
			list_clsOlis[itemNumber].multipleColor='black';
			
			if (oli.Quantity__c != null){
				Integer qty = oli.Quantity__c.intValue();
				if (pc != null){
					Integer max = 0;
					if (pc.Maximum_Order_Qty__c != null){
						max = pc.Maximum_Order_Qty__c.intValue();
					}
					
					Integer multiple = 0;
					if (pc.Multiple_Order_Qty__c != null && pc.Multiple_Order_Qty__c > 0){
						multiple = pc.Multiple_Order_Qty__c.intValue();
						if(math.mod(qty,multiple) != 0) {
							list_clsOlis[itemNumber].quantityColor='red';
							list_clsOlis[itemNumber].multipleColor='red';
						}
					}
								
					if(qty > max){
						list_clsOlis[itemNumber].quantityColor='red';
						list_clsOlis[itemNumber].maxColor='red';
					}
					/*if(math.mod(qty,multiple) != 0) {
						list_clsOlis[itemNumber].quantityColor='red';
						list_clsOlis[itemNumber].multipleColor='red';
					}*/
				}
				
				if(inv != null){
					System.debug('--> inv != null');
					Integer stock = 0;
					if (inv.Quantity_in_Stock__c != null){
						stock = inv.Quantity_in_Stock__c.intValue();
					}
				
					if(qty>stock){
						list_clsOlis[itemNumber].quantityColor='red';
						list_clsOlis[itemNumber].stockColor='red';
					}
				}
								
				if(qty == 0){
					list_clsOlis[itemNumber].quantityColor='red';
				}
			}
						
		}
	}	
	
	private void defaultValues(String mode){
		System.debug('********** defaultValues **********');
		System.debug('--> mode: ' + mode);
		this.header.Name = 'auto';
		
		this.header.Order_Source__c = 'PHONE';
		this.header.Caller_Name__c = '';
		/*if (this.header.Order_Source__c == 'PHONE') {
			this.header.Caller_Name__c = '';
		}*/
		
		this.header.Address_Override__c = false;
		this.header.Home_delivery__c = 'No';
		
		this.header.Freight_Amount__c = 0;
		this.header.Charge_Freight__c = 'Yes';
		this.header.Freight_Override__c = false;
		
		
		/*this.header.Ship_From__c = 'EURLC';*/ //not used amymore
		this.header.Order_Group__c = 'STD';
		this.header.Partial_Order__c ='Yes';
		this.header.Partials__c = 'Yes';
		this.header.Cancel_Back_Order__c = 'No';
		this.header.Order_Date__c = Date.today();
		this.header.Scheduled_Ship_Date__c = Date.today();
		
		//**********
		if (mode == 'ALL'){
			System.debug('--> mode = ALL');
			header.Ship_To_ID__c = '';
			header.Ship_To_ID__c = this.previousShipToId;
	 		header.Account__c = null; 			
	 		header.Ship_To_Address_1__c = '';
	 		header.Ship_To_Address_2__c = '';
	 		header.Ship_To_City__c = '';
	 		header.Ship_To_Postcode__c = '';
	 		header.Address_Override__c = false;
	 			
	 		billToDetails.Ship_To_ID__c = '';
	 		billToDetails.Account__c = null;
	 		billToDetails.Ship_To_Address_1__c = '';
	 		billToDetails.Ship_To_Address_2__c = '';
	 		billToDetails.Ship_To_City__c = '';
	 		billToDetails.Ship_To_Postcode__c = '';
	 				
	 		this.renderShipToOptions = false;
	 		this.validShipToId = false;
	 		
	 		this.header.Ship_Via__c = 'GROUND'; //'Ground';
		}
		//**********
	}
	
	public void requestPrices(){
		System.debug('********** requestPrices **********');
		
		Map<String, Double> map_PSSKU_price = new Map<String, Double>(); 
		
		//Declare Webservice Varibales
		ClsWSPriceCalculation.GetPSPriceSOAP WS = new ClsWSPriceCalculation.GetPSPriceSOAP();
		List<ClsWSPriceCalculation.InputData_element> list_WSInput = new List<ClsWSPriceCalculation.InputData_element>();
		List<ClsWSPriceCalculation.OutputData_element> list_WSOutput = new List<ClsWSPriceCalculation.OutputData_element>(); 
		
		
		//Increase Webservice callout timeout limit
		WS.timeout_x = 20000;
		
		//prepare input parameters for the webservice call
		System.debug('--> Preparing Input parameters');
		for (Integer itemNumber = 0; itemNumber<list_clsOlis.size();itemNumber++){
			System.debug('--> list_clsOlis[itemNumber].oli.PS_Product_SKU__c: ' + list_clsOlis[itemNumber].oli.PS_Product_SKU__c);
			System.debug('--> this.billToDetails.Ship_To_ID__c: ' + this.billToDetails.Ship_To_ID__c);
			System.debug('--> list_clsOlis[itemNumber].pc.Unit_of_Measure__c: ' + list_clsOlis[itemNumber].pc.Unit_of_Measure__c);
			
			if(list_clsOlis[itemNumber].validSKU && list_clsOlis[itemNumber].oli.Quantity__c != null && list_clsOlis[itemNumber].oli.PS_Product_SKU__c != '' 
				&& this.header.Ship_To_ID__c != null && this.header.Bill_To_ID__c != null && list_clsOlis[itemNumber].pc.Unit_of_Measure__c != null){
				ClsWSPriceCalculation.InputData_element input = new ClsWSPriceCalculation.InputData_element();
				Order_Line_Item__c oli = list_clsOlis[itemNumber].oli;
				
				System.debug('--> ItemNumber: ' + itemNumber);
				
				list_clsOlis[itemNumber].validPriceFromWS = true;
				
				//map_PSSKU_price.put(oli.PS_Product_SKU__c, oli.Unit_Price__c);
				
				input.BUSINESS_UNIT = this.header.Business_Unit__c; //'NORSE';
				input.ORDER_DATE = DateTime.now(); //date.today().day + '/' + date.today().month + '/' + date.today().year();
				System.debug('--> input.ORDER_DATE: ' + input.ORDER_DATE);
				input.PPRC_APP_CD = 'SO';
				System.debug('--> input.PPRC_APP_CD: ' + input.PPRC_APP_CD);
				input.PRODUCT_ID = oli.PS_Product_SKU__c; // 'SDD-020030PKR';
				System.debug('--> input.PRODUCT_ID: ' + input.PRODUCT_ID);
				input.QTY_ORDERED = oli.Quantity__c.intValue(); //1
				System.debug('--> input.QTY_ORDERED: ' + input.QTY_ORDERED);
				input.SHIP_TO_CUST_ID = this.header.Ship_To_ID__c; //'11700910';
				System.debug('--> input.SHIP_TO_CUST_ID: ' + input.SHIP_TO_CUST_ID);				
				input.SOLD_TO_CUST_ID = this.header.Bill_To_ID__c; //'11700910';
				System.debug('--> this.billToDetails.Ship_To_ID__c: ' + this.header.Bill_To_ID__c);
				input.UNIT_OF_MEASURE = list_clsOlis[itemNumber].pc.Unit_of_Measure__c; //'EA'
				System.debug('--> input.UNIT_OF_MEASURE: ' + input.UNIT_OF_MEASURE);
			
				//add input paramters to input parameter structured list		
				System.debug('--> Adding input parameters to input list: ' + input);
				list_WSInput.add(input);				
			}

		}
		
		try{
			//call webservice
			System.debug('--> Try to call WEBSERVICE');
			System.debug('--> list_WSInput.size(): ' + list_WSInput.size());			
			if(list_WSInput.size() != 0){
				list_WSOutput = WS.Price(list_WSInput);
			}
			//list_WSOutput = WS.Price(list_WSInput);
			
			System.debug('--> ***** SUCCESS *****');
			if (list_WSOutput != null){
				System.debug('--> #Items received: ' + list_WSOutput.size());
				
				//parse the response in case of success
				for (ClsWSPriceCalculation.OutputData_element out : list_WSOutput){
					System.debug('*** --> PS PRODUCT ID: ' + out.PRODUCT_ID);
					System.debug('*** --> PRICE: ' + out.NET_UNIT_PRICE);
					Double price;
					if (out.NET_UNIT_PRICE != null && out.NET_UNIT_PRICE != ''){
						System.debug('--> Price received');
						price = Double.valueOf(out.NET_UNIT_PRICE);
						map_PSSKU_price.put(out.PRODUCT_ID, price);
					}
					//map_PSSKU_price.put(out.PRODUCT_ID, out.NET_UNIT_PRICE);
					
				}
				
				//populkate the webservice results into according fields on line item level
				for (Integer itemNumber = 0; itemNumber<list_clsOlis.size();itemNumber++){
					System.debug('--> ItemNumber: ' + itemNumber);
					Order_Line_Item__c oli = list_clsOlis[itemNumber].oli;
					if(list_clsOlis[itemNumber].validSKU){ 
						//oli.PS_Product_SKU__c
						//map_PSSKU_price.containsKey(oli.PS_Product_SKU__c)
						if (map_PSSKU_price.containsKey(oli.PS_Product_SKU__c)){
							Double price = map_PSSKU_price.get(oli.PS_Product_SKU__c);
							System.debug('--> Setting price to: ' + price);
							oli.Unit_Price__c = price;
						} else {
							list_clsOlis[itemNumber].validPriceFromWS = false;
						}
					}
					System.debug('--> validPriceFromWS: ' + list_clsOlis[itemNumber].validPriceFromWS);
				}
				
				//calculating extended price and order amount
				calculateExtendedPrices();
				calculateFreightAmount();
			} else {
				System.debug('--> WS Output is NULL');
			}
			
		} catch (Exception e){
			//an error occurred during the webservice callout, display error message in debug log
			System.debug('--> ERROR: ' + e.getMessage());
		}
	}
	
	/*************************************************************************
  	* Getter and Setter Methods
  	*************************************************************************/
	
	public Boolean getshowEditButton(){
		Boolean returnValue = false;
		if (this.header.SF_Order_Status__c == 'Saved'){
			returnValue = true;
		}
		return returnValue;
	}
	
	public String getValidShipToMessage(){
		String returnValue = 'No valid ShipTo Account found. Please enter a valid ShipTo Id!';
		if (showFirstValidShipToIdMessage){
			returnValue = 'ShipTo Id needs validation. Please validate!';
			showFirstValidShipToIdMessage = false;
		}
		return returnValue;
	}
	
	public String getcustOrderAmount(){
		if (this.header.Order_Amount__c != null && this.header.CurrencyIsoCode != null){			
			Double dvalue = this.header.Order_Amount__c;
			Decimal value = dvalue;
			value = value.divide(1,2);
			String curr = this.header.CurrencyIsoCode;
			String zeroes = '';
			for (Integer i = 0; i < 2 - value.scale(); i++){
				zeroes += '0';
			}
			return curr + ' ' + String.valueOf(value) + zeroes;
		} else {
			return '';
		} 	
	}
	
	public String getcustFreightAmount(){
		if (this.header.Freight_Amount__c != null && this.header.CurrencyIsoCode != null){			
			Double dvalue = this.header.Freight_Amount__c;
			Decimal value = dvalue;
			value = value.divide(1,2);
			String curr = this.header.CurrencyIsoCode;
			String zeroes = '';
			for (Integer i = 0; i < 2 - value.scale(); i++){
				zeroes += '0';
			}
			return curr + ' ' + String.valueOf(value) + zeroes;
		} else {
			return '';
		} 	
	}
	
	public String getcustTotalValue(){
		System.debug('********** getCustTotalValue **********');
		System.debug('--> this.header.Total_Value__c: ' + this.header.Total_Value__c);
		System.debug('--> this.header.CurrencyIsoCode : ' + this.header.CurrencyIsoCode);
		if (this.header.Total_Value__c != null && this.header.CurrencyIsoCode != null){
			Double dvalue = this.header.Total_Value__c;
			Decimal value = dvalue;
			value = value.divide(1,2);
			String curr = this.header.CurrencyIsoCode;
			String zeroes = '';
			for (Integer i = 0; i < 2 - value.scale(); i++){
				zeroes += '0';
			}
			return curr + ' ' + String.valueOf(value) + zeroes;
		} else {
			return '';
		} 	
	}
	
	/*public String getaccountDescription(){
		return this.header.Account__r.Description;	
	}
	
	public void setaccountDescription(String accountDescription){
		this.accountDescription = accountDescription;
	}
	
	public String getaccountCurrency(){
		return this.header.Account__r.CurrencyIsoCode;
	}
	
	public void setaccountCurrency(String accountCurrency){
		this.accountCurrency = accountCurrency; 
	}
	
	public String getaccountSetId(){
		return this.header.Account__r.SETID__c;
	}
	
	public void setaccountSetId(String accountSetId){
		this.accountSetId = accountSetId;
	}
	
	public String getaccountShipToId(){
		return this.header.Account__r.Ship_To_Id__c;
	}
	
	public void setaccountShipToId(String accountShipToId){
		this.accountShipToId = accountShipToId;
	}
	
	public String getaccountBusinessUnit(){
		return this.header.Account__r.Business_Unit__c;
	}	
	
	public void setaccountBusinessUnit(String accountBusinessUnit){
		this.accountBusinessUnit = accountBusinessUnit;
	}*/

	/*
	//not used any more because we transferred the according logic to a JavaScript in VF page
	//Testing Storing Products
	public void readProductCache(){
		System.debug('********** Reading ProductCache **********');
		for (Attachment a : [Select Body from Attachment where Name = 'ProductInfo.txt' and ParentId = '001T000000F7raXIAR' limit 1000]){
			String inputTxt = a.Body.toString();
			System.debug('--> Length: ' + inputTxt.length());
			parseProductCache(inputTxt);
		}
	}
	
	public void parseProductCache(String input){
		System.debug('********** Parse ProductCache **********');
		List<String> list_records = input.split(';');
		//each record
		for (Integer i = 0; i < list_records.size(); i++){
			ClsProductCache pCache = new ClsProductCache();
			Product2 p = new Product2();
			Id productId;
			String record = list_records[i];
			//remove first and last curly bracket
			record = record.substring(1,record.length());
			
			String invRecord = record.substring(record.indexOf('Inventory__r',0),record.length());
			
			record = record.substring(1,record.indexOf('Inventory__r',0));
			
			List<String> list_fieldsNvalues = record.split('\', ');
			//for each pair
			for (Integer j = 0; j < list_fieldsNvalues.size(); j++){
				String fieldNValue = list_fieldsNvalues[j];
				List<String> list_finalStrings = fieldNValue.split(':\'');
				String fieldName = list_finalStrings[0]; 
				String value = list_finalStrings[1];
				
				if (fieldName == 'Name'){
					p.Name = value;			
				} 
				else if (fieldName == 'Id'){
					productId = value;
				}
				else if (fieldName == 'Family'){
					p.Family = value;
				}
				else if (fieldName == 'Description'){
					p.Description = value;
				}
				else if (fieldName == 'PS_Product_SKU__c'){
					p.PS_Product_SKU__c = value;
				}
				else if (fieldName == 'Unit_of_Measure__c'){
					p.Unit_of_Measure__c = value;
				}
				else if (fieldName == 'Maximum_Order_Qty__c'){
					p.Maximum_Order_Qty__c = Double.valueOf(value);
				}
				else if (fieldName == 'Multiple_Order_Qty__c'){
					p.Multiple_Order_Qty__c = Double.valueOf(value);
				}
				/*
				else if (fieldName == 'Inventory__r'){
					//String invRecord = list_invRecords[i];
					//remove first and last curly bracket
					invRecord = invRecord.substring(1,invRecord.length());
					list_fieldsNvalues = invRecord.split('\', ');
					//for each pair
					for (Integer k = 0; k < list_fieldsNvalues.size(); k++){
						fieldNValue = list_fieldsNvalues[k];
						list_finalStrings = fieldNValue.split(':\'');
						fieldName = list_finalStrings[0]; 
						value = list_finalStrings[1];
					}
				}
				
			} // end for product field and value information
			pCache.product = p;
			pCache.productId = productId;
			
			System.debug('# ' + i + ' Product: ' + p);
			
			//insert inv information
			//pCache.list_invs = list_invs;
			
			this.map_SKU_productCache.put(p.Name, pCache);
			this.list_products.add(pCache);
		}//end for each product record
	}
		
	public void queryLineItemDataCache() {
   		System.debug('********** queryLineItemData **********');
  		System.debug('--> Size of CacheMap: ' + this.map_SKU_productCache.size());
  		
  		Integer itemNumber = getItemNumber();
  		System.debug('-> PARAM: ' + ApexPages.currentPage().getParameters().get('itemNo'));
  		System.debug('--> returned itemNumber: ' + itemNumber);
  		System.debug('--> list_clsOlis[itemNumber].SKU_mod: ' + list_clsOlis[itemNumber].SKU_mod);
  		System.debug('--> list_clsOlis[itemNumber].SKU_lkid: ' + list_clsOlis[itemNumber].SKU_lkid);
  		System.debug('--> list_clsOlis[itemNumber].SKU_lkold: ' + list_clsOlis[itemNumber].SKU_lkold);
  		System.debug('--> list_clsOlis[itemNumber].oli.Product_SKU__c: ' + list_clsOlis[itemNumber].oli.Product_SKU__c);
  		System.debug('--> list_clsOlis[itemNumber].SKU_oldId: ' + list_clsOlis[itemNumber].SKU_oldId);
  		if (list_clsOlis[itemNumber].SKU_mod == '1' || list_clsOlis[itemNumber].SKU_lkold == '' || 
  			list_clsOlis[itemNumber].SKU_field == list_clsOlis[itemNumber].SKU_lkold && list_clsOlis[itemNumber].SKU_field != ''){
  			//list_clsOlis[itemNumber].SKU_field != list_clsOlis[itemNumber].SKU_lkold
  			//list_clsOlis[itemNumber].SKU_lkid != '' && 
  			
  			System.debug('--> Changes in SKU field detected');
  			list_clsOlis[itemNumber].SKU_oldId = list_clsOlis[itemNumber].oli.Product_SKU__c;
  			
  			//System.debug('--> lkid has content');
  			String SKU = list_clsOlis[itemNumber].SKU_field.toUpperCase();
  			list_clsOlis[itemNumber].SKU_field = SKU;
  			
  			System.debug('--> SKU: ' + SKU);
  			if (this.map_SKU_productCache.containsKey(SKU)){
	  			System.debug('--> Map contains SKU');
	  			ClsProductCache pCache = this.map_SKU_productCache.get(SKU);
	  			
	  			list_clsOlis[itemNumber].validSKU = true;
	  			Id productId = pCache.productId;
	  			if (productId != null){
	  				System.debug('--> ProductId is NULL - Setting SKU_mod = 0');
	  				list_clsOlis[itemNumber].SKU_mod = '0';
	  				//list_clsOlis[itemNumber].validSKU = true;  				
	  			} 
	  			
	  			System.debug('--> Setting ProductId');
	  			list_clsOlis[itemNumber].oli.Product_SKU__c = productId;
	  			System.debug('--> productId received! productId: ' + productId);
	  			
	  			Product2 p = pCache.product;
		  		list_clsOlis[itemNumber].pc = p;
	  			list_clsOlis[itemNumber].productDescription = p.Description;
	  			list_clsOlis[itemNumber].UOM = p.Unit_of_Measure__c;
	  			list_clsOlis[itemNumber].max = p.Maximum_Order_Qty__c;
	  			list_clsOlis[itemNumber].mult = p.Multiple_Order_Qty__c;
	  			
	  			if (list_clsOlis[itemNumber].oli.Quantity__c != null){
	  				System.debug('--> *** QTY is filled');
	  				changeItemQuantityColor(itemNumber);
	  			} 
				
		  		jumpBackToSKU = !list_clsOlis[itemNumber].validSKU;
  			}
  		}  		  		
  		
  		//return null; 		
  	}
  	*/
}