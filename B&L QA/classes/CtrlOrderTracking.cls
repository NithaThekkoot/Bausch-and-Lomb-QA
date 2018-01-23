/**
* 
*   This class acts as a controller for several Visualforce pages that are connected and part of the Order Tracking. 
*
*   Author           |Author-Email                      |Date       |Comment
*   -----------------|----------------------------------|-----------|--------------------------------------------------
*   Dennis Flüchter  |dennis.fluechter@itbconsult.com   |09.09.2009 |First draft
*   Dennis Flüchter  |dennis.fluechter@itbconsult.com   |09.12.2009 |Adjustments after avoiding apex heap error and new sorting function
*   Dennis Flüchter  |dennis.fluechter@itbconsult.com   |11.05.2010 |Adding new search fields, item 56 of requirement list
*   Dennis Flüchter  |dennis.fluechter@itbconsult.com   |28.06.2010 |Adding logic to display lines without shipments even if others have shipments
*   Dennis Flüchter  |dennis.fluechter@itbconsult.com   |05.07.2010 |Ignoring order date when order number entered
*   Frederic Faisst  |frederic.faisst@itbconsult.com    |24.11.2010 |Adding functionality to populate MSR No. in Order Management search results.
*   Frederic Faisst  |frederic.faisst@itbconsult.com    |25.11.2010 |Adding functionality to get search results directly by click on Order View Link
*   Craig Stanton    |craig.stanton@bausch.com          |02.02.2011 |Changing default From Date to 30 days from today (from 14 days)
*   Dan Wood         |dan.wood@bausch.com               |08.02.2011 |Simply show SKU and SKU description from Order_Line_Item__c instead of SFDC product info.
*   Dan Wood         |dan.wood@bausch.com               |25.05.2011 |Re-instate SKU search using PS_Product_SKU__c instead of Product_SKU__r.Name
*   Dan Wood         |dan.wood@bausch.com               |15.06.2011 |Check if user has blanked date search fields and put defaults back in if they have.
*   Craig Stanton    |craig.stanton@bausch.com          |27.06.2011 |Add back code for the Optum button
*   Dan Wood         |dan.wood@bausch.com               |03.08.2011 |Add PHMUS business unit
*   Dan Wood         |dan.wood@bausch.com               |03.08.2011 |Shipping box enhancement GCM165954
*   Dan Wood         |dan.wood@bausch.com               |12.03.2013 |Add Bill_To_Account__c for Link to bill to account in order tracking
*   Dan Wood         |dan.wood@bausch.com               |17.04.2013 |Create Case link - add Invoice and CarrierID GCM210636
*
*/

public with sharing class CtrlOrderTracking {
    //with sharing
    
    /*************************************************************************
    * Define Varibales and Properties
    *************************************************************************/
    
    public Boolean displaySearch {get; set;}
    
    /*  BEGIN define varibales for OrderTracking search functionaliy */
    // each variable represents a possible search field     
    
    private String roleName;
    
    private Account transferredAccount;
    
    public String searchField {get;set;}
    public List<Account> list_accs {get;set;}
    public Boolean displayAccountList {get;set;}
    private Boolean stopWithCriteriaMessages {get;set;}
    private Boolean newStopWithCriteriaMessages {get;set;}
    
    // variables to search in OrderHeader   
    public String shipToId {get;set;}
    public String shipToAccountName {get;set;} 
    public String shipToCity {get;set;}
    public String shipToPostCode {get;set;} //*1*   
    public String customerPO {get;set;}
    public String orderNo {get;set;} 
    public String businessUnit {get;set;}   
    public String refOrderNumber {get;set;} //*1*       
    public String enteredBy {get;set;}
    
    //Added 24.11.2010 by Frederic Faisst, ITBconsult - MSR No. Enhancement
    public Boolean showMSRNumber {get;set;} //Used to display or hide the "MSR No" field on the search results according to whether Switch in Custom Setting "Functionality Management" is flagged or not.
    public Boolean showShippingBox {get;set;} //Used to display or hide the "View Boxes" link on the search results according to whether Switch in Custom Setting "Functionality Management" is flagged or not.    public Boolean showSerialLotID {get;set;} //Used to display or hide the serial/lot id order line column
    public Boolean showSerialLotID {get;set;} //Used to display or hide the serial/lot id order line column
    public String linkToMsrRecord {get;set;} //Link to MSR Record to open MSR Record from search results
    public String msrNumber {get;set;} //Name of MSR Record to show in search results
    public String msrHeaderObject = '';
    public Boolean calcAlreadyDone = false; //Check if MSR No. is already retrieved or not
    
    //variables to search for Order_Date__c; we need dummyContainer to reach standard date picker funtionality in VF page
    public Order_Header__c dummyHeaderTo {get;set;} //as dummyContainer for storing the toOrderDate
    public Order_Header__c dummyHeaderFrom {get;set;} //as dummyContainer for storing the FromOrderDate
    //public Order_Header__c dummyEnteredBy {get;set;} //as dummyContainer for storing the toOrderDate
    
    // variables to search in OrderLineItem
    public String SKU {get;set;}
    public String patientReference {get;set;}
    public String customerPoLine {get;set;}
    
    //variables to search in Shipping History
    public String invoiceNumber {get;set;}
    public String packListNo {get;set;}
    
    //Added 04-Mar-2011 by CLS - COUNTER FOR MSR AND ORDER NUMBER
    public Integer cnt {get;set;}
    public String firstMsrNumber {get;set;}
    public String firstOrderNumber {get;set;}
    public String useForOptumButton {get;set;} //If there is no firstMsrNumber, use the firstOrderNumber
    //END
    
    
    /* END define varibales for OrderTracking search functionaliy */
    
    /*  BEGIN define varibales for OrderTracking TreeView functionaliy */   
    
    public List<ClsTreeHeader> list_clsHeaders {get;set;}
    
    public Integer noRecords {get; set;} // Number of customer records selected
    public Integer startRecord {get; set;} // Indicates the first record to be shown in table list when using pagination
    public Integer endRecord {get; set;} // Indicates last record to be shown in table when using pagination
    
    final Integer maxRecords = 10; // Constant that defines maximum number of records shown in the customer list    
    
    public Boolean expandAll {get; set;}
    public String expandAllButtonLabel {get; set;}
    
    /* END define varibales for OrderTracking TreeView functionaliy */
    
    /*************************************************************************
    * Constructor
    *************************************************************************/
    
    private Integer runs = 0;
    
    public CtrlOrderTracking(){                 
        runs += 1;
        System.debug('RUNS: ' + runs);
        
        // default class variables
        defaultSearchFields();
        String transferredSetId = ApexPages.currentPage().getParameters().get('setId');
        if (transferredSetId != '' && transferredSetId != null) {
            this.shipToId = transferredSetId;
            //add query for billTo and others
        }
        String transferredBU = ApexPages.currentPage().getParameters().get('bu');
        if (transferredBU != '' && transferredBU != null) {
            this.businessUnit = transferredBU;
        }
        String transferredOrderNo = ApexPages.currentPage().getParameters().get('orderNo');
        if (transferredOrderNo != '' && transferredOrderNo != null) {
            this.orderNo = transferredOrderNo;
        }
        
        this.startRecord = 0;
        this.endRecord = 0;
        this.noRecords = 0;
        
        //Set Boolean from Custom Setting "Functionality Management". It decides if MSR No. is shown in search results or not
        this.showMSRNumber = Functionality_Management__c.getInstance('MSR').Switch__c;
        this.msrHeaderObject = Functionality_Management__c.getInstance('MSR').Object__c;
        //Set Boolean from Custom Setting "Functionality Management". It decides if View Box link is shown in search results or not
        this.showShippingBox = Functionality_Management__c.getInstance('Shipping_Boxes').Switch__c;
        //Calculation of MSR Header Id by Consignment Sales Order No. to create Link by click on it in search results MSR Header records opens
        if(this.businessUnit != '' && this.orderNo != ''){
            String consignmentSalesOrderNo = '';
            Integer padlen = 10;
            Id msrHeaderId;
            
            //CLS
            cnt = 0;
            //END
            
            /* Add PHMUS business unit
            if (businessUnit == 'BLUSA' || businessUnit == 'VCUCM' || businessUnit == 'CANAD'){
                padlen = 9;
            }*/
            if (businessUnit == 'BLUSA' || businessUnit == 'VCUCM' || businessUnit == 'CANAD' || businessUnit == 'PHMUS'){
                padlen = 9;
            }
            
            consignmentSalesOrderNo = this.businessUnit + '-' + lpad(this.orderNo, padlen, '0');
            
            /*String query = 'Select Id, Name From MSR_Header__c Where Consignment_Sales_Order_No__c = \'' + consignmentSalesOrderNo + '\'';
            
            List<Sobject> list_msrs = Database.query(query);
                                
            if(list_msrs.size() > 0){
                for(Sobject msr : list_msrs) {
                    msrHeaderId = msr.Id;
                    msrNumber = msr.Name;
                }
            }*/
        
            List<MSR_Header__c> list_msrs = [Select Id, Name From MSR_Header__c Where Consignment_Sales_Order_No__c = :consignmentSalesOrderNo];
            
            for(MSR_Header__c msr : list_msrs){
                msrHeaderId = msr.Id;
                msrNumber = msr.Name;
                
                //CLS - GET THE FIRST MSR NUMBER IN THE LIST AND CAPTURE IT FOR OPTUM BUTTON
                cnt = cnt + 1;
                if(cnt == 1 && msrNumber != null) {
                    
                    //MSR HAS BU PLUS A DASH AS PREFIX - GET JUST THE NUMBER FOR THE OPTUM BUTTON
                    firstMsrNumber = msrNumber.substring(6, msrNumber.length());
                    
                    system.debug('********************* FIRST MSR NUMBER: ' + firstMsrNumber + '*************************');          
                }
                //END
            }
            
            linkToMsrRecord = '/'+ msrHeaderId;
            calcAlreadyDone = true;
        }
        
        expandAll = false;
        this.expandAllButtonLabel = 'Expand All';
        
        //first();                  
        
        this.searchField = '';
        this.list_accs = new List<Account>();
        this.displayAccountList = false;
        this.roleName = getUserRoleName();
        
         if(this.businessUnit != '' && this.orderNo != ''){         
            search();
        }
    }
    
    /*************************************************************************
    * Button Action Methods
    *************************************************************************/
    
    public PageReference search(){
        System.debug('********** Searching **********');
        this.list_clsHeaders.clear();
        //fillTreeStructure(buildSQOLForSearch());
        Boolean criteriaCorrect = checkSearchCriteria(); 
        
        System.debug('BOOLEAN SEARCH CRITERIA CORRECT: ' + criteriaCorrect);
        
        if (criteriaCorrect || (criteriaCorrect == false && this.stopWithCriteriaMessages == false)) {
            queryTreeStructure(buildSQOLForSearch());
            System.debug('--> Size of TreeHeader List: ' + this.list_clsHeaders.size());
            displaySearch = false;
        }
        
        return null;
    }
    
    public PageReference modifySearch(){
        displaySearch = true;
        return null;
    }
    
    public PageReference clearSearchFields(){
        defaultSearchFields();
        return null;
    }
        
    public PageReference directToOrderCreation(){
        //PageReference pr = new PageReference('/apex/CtrlOrderEntry_OrderEntry?retURL=%2Fa0H%2Fo&save_new=1&sfdc.override=1&setid=' + this.shipToId);
        //PageReference pr = new PageReference('http://pf84qa.bausch.com:21160/psp/ps/EMPLOYEE/ERP/c/MAINTAIN_SALES_ORDERS.ORDENT_FORM.GBL?FolderPath=PORTAL_ROOT_OBJECT.CO_ORDER_MANAGEMENT.EPCO_SALES_ORDERS_QUOTES.EP_ORDENT_FORM_GBL&IsFolder=false&IgnoreParamTempl=FolderPath%2cIsFolder&SHIP_TO_CUST_ID=' + this.shipToId);
        //pr.setRedirect(true);
        //return pr;
        return null;
    }
            
    public String getPSRMAWorksheetLink(){
        String returnValue = getParameter('OT_PSRMA_WorkSheet') + getPSLinkEnhancement();
        System.debug('PSRMAWorksheetLink: ' + returnValue);                         
        return returnValue;                  
        //return 'http://pf84qa.bausch.com:21160/psp/ps/EMPLOYEE/ERP/c/MAINTAIN_SALES_ORDERS.ORDENT_FORM.GBL?FolderPath=PORTAL_ROOT_OBJECT.CO_ORDER_MANAGEMENT.EPCO_SALES_ORDERS_QUOTES.EP_ORDENT_FORM_GBL&IsFolder=false&IgnoreParamTempl=FolderPath%2cIsFolder&SHIP_TO_CUST_ID=' + this.shipToId;
    }   
    
    public String getPSOrderCreationLink(){
        String returnValue = getParameter('OT_PSOrderCreation') + getPSLinkEnhancement();                       
        return returnValue;                  
        //return 'http://pf84qa.bausch.com:21160/psp/ps/EMPLOYEE/ERP/c/MAINTAIN_SALES_ORDERS.ORDENT_FORM.GBL?FolderPath=PORTAL_ROOT_OBJECT.CO_ORDER_MANAGEMENT.EPCO_SALES_ORDERS_QUOTES.EP_ORDENT_FORM_GBL&IsFolder=false&IgnoreParamTempl=FolderPath%2cIsFolder&SHIP_TO_CUST_ID=' + this.shipToId;
    }
    
    public String getPSConsignmentLink(){
        String returnValue = getParameter('OT_PSConsignment') + getPSLinkEnhancement();                       
        return returnValue;                  
    }    
    
    private String getPSLinkEnhancement(){
        String returnValue = '';
        
        if (this.shipToId != null && this.shipToId != ''){
            if (this.transferredAccount == null){
                List<Account> list_transferredAccounts = [Select Ship_To_Id__c, Bill_To__c, SETID__c From Account Where Ship_To_Id__c = :this.shipToId limit 1];
                if (list_transferredAccounts.size() == 1){                  
                    this.transferredAccount = list_transferredAccounts[0];
                }
            }
            if (this.transferredAccount != null){
                returnValue += '&SHIP_TO_CUST_ID=' + this.transferredAccount.Ship_To_Id__c;
                returnValue += '&SOLD_TO_CUST_ID=' + this.transferredAccount.Bill_To__c;
                returnValue += '&BUSINESS_UNIT=' + getInterpretedBU(this.transferredAccount.SETID__c);
            }
        }        
        return returnValue;
    }
    
    private String getInterpretedBU(String str){
        String returnValue = '';
        
        if(str == 'ITALY') {
            returnValue = 'ITACM';
        }
        else if(str == 'XPORT') {
            returnValue = 'DISPR';
        }
        else{
            returnValue = str;
        }
        
        return returnValue;
    }
    
    public String getPSRMALink(){
        String returnValue = getParameter('OT_PSRMA') + getPSLinkEnhancement();
        return returnValue;
    }
    
    public String getWMSLink(){
        //add custom settings
        return getParameter('OT_OptumWMS');
        //return 'http://blaprocrdc122/default.asp';
    }
    
    public PageReference expandAll(){
        this.expandAll = !this.expandAll;
        if (this.expandAll){
            this.expandAllButtonLabel = 'Collapse All';
        } else {
            this.expandAllButtonLabel = 'Expand All';
        }
        return null;
    }
    
    public pageReference SOSLsearch(){
        System.debug('********** SOSL search **********');
        this.list_accs.clear();
        System.debug('--> this.searchField: ' + this.searchField);
        if(this.searchField.length() > 2){
            List<List<SObject>> searchList = [FIND :this.searchField IN ALL FIELDS RETURNING Account (Id, Name, ShippingCity, ShippingStreet, Ship_To_Id__c, Phone)];
            this.list_accs = ((List<Account>)searchList[0]);
        }
        System.debug('--> Size of found Accounts: ' + this.list_accs.size());
        if(this.list_accs.size() > 0){
            this.displayAccountList = true;
        }
        return null;    
        
    }
            
    
    /*************************************************************************
    * All Methods Except Getter and Setter Methods
    *************************************************************************/
    
    private void defaultSearchFields(){                 
        //variables to search for Order_Date__c; we need dummyContainer to reach standard date picker funtionality in VF page
        dummyHeaderTo = new Order_Header__c();
        dummyHeaderFrom = new Order_Header__c();
        //dummyEnteredBy = new Order_Header__c();
        
        // variables to search in OrderHeader   
        shipToId = '';
        shipToAccountName = ''; 
        shipToCity = '';    
        shipToPostCode = '';
        customerPO ='';
        orderNo = '';
        businessUnit = '';      
        refOrderNumber = '';        
        enteredBy = '';
        
        // variables to search in OrderLineItem
        SKU ='';
        patientReference ='';
        customerPoLine = '';
        
        // variables to search in Shipping History
        invoiceNumber = '';
        packListNo = '';
                
        // default Order Date search criteria 
        dummyHeaderFrom.Order_Date__c = Date.newInstance(Date.today().year(), Date.today().month(), Date.today().day()- 30);
        dummyHeaderTo.Order_Date__c = Date.newInstance(Date.today().year(), Date.today().month(), Date.today().day());          
        //dummyEnteredBy.OwnerId = null;
        
        if(this.list_clsHeaders == null){
            this.list_clsHeaders =  new List<ClsTreeHeader>();
        }   
        
        displaySearch = true;
        
        this.searchField = '';
        this.displayAccountList = false;
        this.newStopWithCriteriaMessages = true;
    }
    
    public pageReference RowClicked(){
        //this.shipToId = '12345';
        System.debug('********** RowClicked **********');
        return null;
    }
    
    private Boolean checkSearchCriteria(){
        Boolean returnValue = true;
        
        /*
        if (this.stopWithCriteriaMessages == null){
            this.stopWithCriteriaMessages = true;
        }
        */
        
        
        //DW 15-June-11 - Add Date fields check - Start
        if ((dummyHeaderFrom.Order_Date__c == null) || (dummyHeaderTo.Order_Date__c == null)){
        // default Order Date search criteria 
        dummyHeaderFrom.Order_Date__c = Date.newInstance(Date.today().year(), Date.today().month(), Date.today().day()- 30);
        dummyHeaderTo.Order_Date__c = Date.newInstance(Date.today().year(), Date.today().month(), Date.today().day());          
        }
        //DW 15-June-11 - Add Date fields check - End
        
        this.stopWithCriteriaMessages = this.newStopWithCriteriaMessages;
        
        //CLS 02-Feb-11 - Changed date range from > 14 days to > 30 days
        if (dummyHeaderFrom.Order_Date__c.daysBetween(dummyHeaderTo.Order_Date__c) > 30 || dummyHeaderFrom.Order_Date__c.daysBetween(dummyHeaderTo.Order_Date__c) < - 30){
            returnValue = false;
            if (this.stopWithCriteriaMessages == true){
                this.newStopWithCriteriaMessages = false;
            }
            //this.stopWithCriteriaMessages = !this.stopWithCriteriaMessages;
            ApexPages.Message msgDateRange = new ApexPages.Message(ApexPages.Severity.INFO, 
                'You are searching on a date range greater than 30 days, this could result in slow performance. Please confirm by clicking the search button again.');
            ApexPages.addMessage(msgDateRange);
        }
        
        //check if one other field is filled
        if (shipToId != '' ||
            shipToAccountName != '' ||
            shipToCity != '' || 
            shipToPostCode != '' ||
            customerPO != '' ||
            orderNo != '' ||    
            refOrderNumber != '' ||     
            //enteredBy != '' ||
            
            // variables to search in OrderLineItem
            //SKU != '' ||
            patientReference != '' ||
            
            // variables to search in Shipping History
            invoiceNumber != '' ||
            packListNo != ''){
        } else {
            returnValue = false;
            this.stopWithCriteriaMessages = true;           
            ApexPages.Message msgOneFieldCriteria = new ApexPages.Message(ApexPages.Severity.ERROR, 
                'You must search on at least one other field in addition to the order date range. Note: SKU and Order Entered By are not counted.');
            ApexPages.addMessage(msgOneFieldCriteria);
                
        }
        
        /*if (returnValue == false || oneFieldEntered == false){
            this.stopWithCriteriaMessages = !this.stopWithCriteriaMessages;
        }
        */
        
        return returnValue;
    }
    
    private String buildSQOLForSearch(){
        System.debug('********** Building SOQL Statement **********');
        Boolean avoidOrderQuery = false;
        Boolean avoidItemQuery = false;
        
        Boolean queryLines = false;
        Boolean queryShipments = false;
        
        Boolean orderNoEntered = false;
        
        String fromOrderDate = String.valueOf(dummyHeaderFrom.Order_Date__c);
        String toOrderDate = String.valueOf(dummyHeaderTo.Order_Date__c);
        String BU = businessUnit; //dummyHeaderFrom.Business_Unit__c;
        //String enteredBy = ent//String.valueOf(dummyEnteredBy.OwnerId);
    
        String SOQL = ''; //local string that holds a dynamic SOQL statement
        String SOQL_items = ''; //local string that holds a dynamic SOQL statement          
        
        String subSOQL = ''; //local string that holds a dynamic SOQL statement
        String SOQLcondition = ''; //local string that hols the SQOL where clause
        String subSOQLcondition = ''; //local string that hols the SQOL where clause
        
        String SOQL_shipments = ''; //local string that holds a dynamic SOQL statement
        String SOQLcondition_shipments = ''; //local string that hols the SQOL where clause
        
        System.debug('--> shipToId: ' + shipToId);
        if(shipToId != '' && shipToId != null){
            shipToId = shipToId.trim();
            System.debug('--> add ShipToId to where clause');
            System.debug('--> SOQL condition: ' + SOQLcondition);
            SOQLcondition += extendWhereClause(SOQLcondition) + 'Account__r.Ship_To_Id__c = \'' + shipToId + '\'';
        }   
                
        System.debug('--> shipToAccountName: ' + shipToAccountName);
        if(shipToAccountName != '' && shipToAccountName != null){
            shipToAccountName = shipToAccountName.trim();
            System.debug('--> add AccountName to where clause');
            System.debug('--> SOQL condition: ' + SOQLcondition);
            //SOQLcondition += extendWhereClause(SOQLcondition) + 'Account__r.Name = \'' + shipToAccountName + '\'';
            SOQLcondition += extendWhereClause(SOQLcondition) + 'Account__r.Name LIKE \'%' + shipToAccountName + '%\'';
        }
                
        System.debug('--> shipToCity: ' + shipToCity);
        if(shipToCity != '' && shipToCity != null){
            shipToCity = shipToCity.trim();
            System.debug('--> add ShipTo City to where clause');
            System.debug('--> SOQL condition: ' + SOQLcondition);
            //SOQLcondition += extendWhereClause(SOQLcondition) + 'Account__r.ShippingCity = \'' + shipToCity + '\'';
            SOQLcondition += extendWhereClause(SOQLcondition) + 'Account__r.ShippingCity LIKE \'%' + shipToCity + '%\'';
        }
                
        System.debug('--> shipToPostCode: ' + shipToPostCode);
        if(shipToPostCode != '' && shipToPostCode != null){
            shipToPostCode = shipToPostCode.trim();
            System.debug('--> add shipTo PostCode to where clause');
            System.debug('--> SOQL condition: ' + SOQLcondition);
            //SOQLcondition += extendWhereClause(SOQLcondition) + 'Account__r.ShippingPostalCode = \'' + shipToPostCode + '\'';
            SOQLcondition += extendWhereClause(SOQLcondition) + 'Account__r.ShippingPostalCode LIKE \'%' + shipToPostCode + '%\'';
        }
                
        System.debug('--> customerPo: ' + customerPO);
        if(customerPo != '' && customerPo != null){
            customerPO = customerPO.trim();
            System.debug('--> add customerPO to where clause');
            System.debug('--> SOQL condition: ' + SOQLcondition);
            //SOQLcondition += extendWhereClause(SOQLcondition) + 'Customer_PO_No__c = \'' + customerPo + '\'';
            SOQLcondition += extendWhereClause(SOQLcondition) + 'Customer_PO_No__c LIKE \'%' + String.escapeSingleQuotes(customerPo) + '%\'';
        }
        
        //Calculation of MSR Header Id by Consignment Sales Order No. to create Link by click on it in search results MSR Header records opens
        if(calcAlreadyDone == false){
            String consignmentSalesOrderNo = '';
            Integer padlen = 10;
            Id msrHeaderId;
            
            /* Add PHMUS business unit
            if (businessUnit == 'BLUSA' || businessUnit == 'VCUCM' || businessUnit == 'CANAD'){
                padlen = 9;
            }*/
            if (businessUnit == 'BLUSA' || businessUnit == 'VCUCM' || businessUnit == 'CANAD' || businessUnit == 'PHMUS'){
                padlen = 9;
            }
            
            consignmentSalesOrderNo = BU + '-' + lpad(orderNo, padlen, '0');
            
            List<MSR_Header__c> list_msrs = [Select Id, Name From MSR_Header__c Where Consignment_Sales_Order_No__c = :consignmentSalesOrderNo];
            
            for(MSR_Header__c msr : list_msrs){
                msrHeaderId = msr.Id;
                msrNumber = msr.Name;
            }
            
            linkToMsrRecord = '/'+ msrHeaderId;
        }
                        
        System.debug('--> orderNo: ' + orderNo);
        System.debug('--> BU: ' + BU);
        String orderNoSearch = '';
        if(orderNo != '' && orderNo != null){
            orderNo = orderNo.trim();
            if (BU == null){
                BU = '';
            }           
            orderNoEntered = true;
            orderNo = orderNo.toUpperCase();
            Integer padlen = 10;
            //if (dummyHeaderFrom.Business_Unit__c == 'BLUSA' || dummyHeaderFrom.Business_Unit__c == 'VCUCM' || dummyHeaderFrom.Business_Unit__c == 'CANAD'){
            /* Add PHMUS business unit
            if (businessUnit == 'BLUSA' || businessUnit == 'VCUCM' || businessUnit == 'CANAD'){
                padlen = 9;
            }*/
            if (businessUnit == 'BLUSA' || businessUnit == 'VCUCM' || businessUnit == 'CANAD' || businessUnit == 'PHMUS'){
                padlen = 9;
            }
            orderNoSearch = BU + '-' + lpad(orderNo, padlen, '0');
            System.debug('--> orderNoSearch: '  + orderNoSearch);
            System.debug('--> add orderNo to where clause');
            System.debug('--> SOQL condition: ' + SOQLcondition);
            SOQLcondition += extendWhereClause(SOQLcondition) + 'Name = \'' + orderNoSearch + '\'';
            System.debug('--> SOQL condition AFTER: ' + SOQLcondition);
        }
                
        System.debug('--> refOrderNumber: ' + refOrderNumber);
        if(refOrderNumber != '' && refOrderNumber != null){
            refOrderNumber = refOrderNumber.trim();
            refOrderNumber = refOrderNumber.toUpperCase();
            System.debug('--> add orderNo to where clause');
            System.debug('--> SOQL condition: ' + SOQLcondition);
            SOQLcondition += extendWhereClause(SOQLcondition) + 'Ref_Order_Number__c = \'' + refOrderNumber + '\'';
        }
                
        System.debug('--> fromOrderDate: ' + fromOrderDate);
        if(fromOrderDate != '' && !orderNoEntered){
            fromOrderDate = fromOrderDate.trim();
            System.debug('--> add fromOrderDate to where clause');
            System.debug('--> SOQL condition: ' + SOQLcondition);
            SOQLcondition += extendWhereClause(SOQLcondition) + 'Order_Date__c >= ' + fromOrderDate;
        }
                
        System.debug('--> toOrderDate: ' + toOrderDate);
        if(toOrderDate != '' && !orderNoEntered){
            toOrderDate = toOrderDate.trim();
            System.debug('--> add toOrderDate to where clause');
            System.debug('--> SOQL condition: ' + SOQLcondition);
            SOQLcondition += extendWhereClause(SOQLcondition) + 'Order_Date__c <= ' + toOrderDate;
        }
        
        System.debug('--> enteredBy: ' + enteredBy);
        if(enteredBy != '' && enteredBy != null){
            enteredBy = enteredBy.trim();
            System.debug('--> add enteredBy to where clause');
            System.debug('--> SOQL condition: ' + SOQLcondition);
            SOQLcondition += extendWhereClause(SOQLcondition) + 'order_entered_by__c LIKE \'%' + enteredBy + '%\'';
        }               
        
        //OrderLineItems        
        System.debug('--> patientReference: ' + patientReference);
        if(patientReference != '' && patientReference != null){
            queryLines = true;
            patientReference = patientReference.trim();
            System.debug('--> add patientReference to where clause');
            System.debug('--> Sub SOQL condition: ' + subSOQLcondition);            
            //subSOQLcondition += extendWhereClause(subSOQLcondition) + 'Patient_Ref_No__c = \'' + patientReference + '\'';
            //Patient_Ref_No__c = old Field!!! changed 16/06/2010 //Customer_po_no__c
            subSOQLcondition += extendWhereClause(subSOQLcondition) + 'Patient_Ref_No__c LIKE \'%' + String.escapeSingleQuotes(patientReference) + '%\'';
        }
        
        System.debug('--> customerPoLine: ' + customerPoLine);
        if(customerPoLine != '' && customerPoLine != null){
            queryLines = true;
            customerPoLine = customerPoLine.trim();
            System.debug('--> add customerPoLine to where clause');
            System.debug('--> Sub SOQL condition: ' + subSOQLcondition);            
            //subSOQLcondition += extendWhereClause(subSOQLcondition) + 'Customer_po_no__c = \'' + customerPoLine + '\'';
            //Patient_Ref_No__c = old Field!!! changed 16/06/2010 //Customer_po_no__c
            subSOQLcondition += extendWhereClause(subSOQLcondition) + 'Customer_po_no__c LIKE \'%' + String.escapeSingleQuotes(customerPoLine) + '%\'';
        }
          /* **Change 08.02.2011** - Removed code     
        System.debug('--> SKU: ' + SKU);
        if(SKU != '' && SKU != null){
            queryLines = true;
            SKU = SKU.trim();
            SKU = SKU.toUpperCase();
            System.debug('--> add SKU to where clause');
            System.debug('--> Sub SOQL condition: ' + subSOQLcondition);            
            //subSOQLcondition += extendWhereClause(subSOQLcondition) + 'Product_SKU__r.Name = \'' + SKU + '\'';
            subSOQLcondition += extendWhereClause(subSOQLcondition) + 'Product_SKU__r.Name LIKE \'%' + SKU + '%\'';
        } 
        **Change 08.02.2011** - Removed code - End 
        */
    /* **Change 25.05.2011** - Re-instated code - Begin */
        System.debug('--> SKU: ' + SKU);
        if(SKU != '' && SKU != null){
            queryLines = true;
            SKU = SKU.trim();
            SKU = SKU.toUpperCase();
            System.debug('--> add SKU to where clause');
            System.debug('--> Sub SOQL condition: ' + subSOQLcondition);            
            subSOQLcondition += extendWhereClause(subSOQLcondition) + 'PS_Product_SKU__c LIKE \'%' + SKU + '%\'';
        } 
    /* **Change 25.05.2011** - Re-instated code - End */    
    
    
    
    
    
        //Invoice and PackListNo commented because they should be at shipment level now. 02/10/09
        //Have to rethink the logic for that.       
        System.debug('--> invoiceNumber: ' + invoiceNumber);
        if(invoiceNumber != '' && invoiceNumber != null){
            queryShipments = true;
            invoiceNumber = invoiceNumber.trim();
            System.debug('--> add invoiceNumber to where clause');
            System.debug('--> Sub SOQL condition: ' + SOQLcondition_shipments);             
            SOQLcondition_shipments += extendWhereClause(SOQLcondition_shipments) + 'Invoice_No__c = \'' + invoiceNumber + '\'';
        }       
        
        
        System.debug('--> packListNo: ' + packListNo);
        if(packListNo != '' && packListNo != null){             
            queryShipments = true;
            packListNo = packListNo.trim();
            System.debug('--> add packListNo to where clause');
            System.debug('--> Sub SOQL condition: ' + SOQLcondition_shipments);             
            SOQLcondition_shipments += extendWhereClause(SOQLcondition_shipments) + 'Pack_List_No__c = \'' + packListNo + '\'';
        } 
                
        //if user entered search criteria for Shipment level, prevent SOQL to do outer join
        if(queryShipments){
            System.debug('--> Query Shipments');
            Set<Id> set_orderIds = new Set<Id>();
            Set<Id> set_orderLineIds = new Set<Id>();
//            SOQL_shipments = 'Select Id, shipment_status__c, Invoice_No__c, MatchKey__c, Order__c, Order_Line_Item__c, Pack_List_No__c, Shipment_Date__c, Carrier__c, Carrier__r.Website__c from Shipping_History__c ';
            SOQL_shipments = 'Select Id, shipment_status__c, Invoice_No__c, MatchKey__c, Order__c, Order_Line_Item__c, Pack_List_No__c, Shipment_Date__c, Carrier__c, Carrier__r.Website__c, Carrier__r.name from Shipping_History__c ';
            SOQL_shipments += SOQLcondition_shipments;
            SOQL_shipments += ' ORDER BY Shipment_Date__c DESC';
            for (Shipping_History__c sh: Database.query(SOQL_shipments)){
                //if shipments found by criteria > 1000 then create a list of sets
                System.debug('--> Shipments found');
                System.debug('--> sh.Order__c: ' + sh.Order__c);
                System.debug('--> sh.Order_Line_Item__c: ' + sh.Order_Line_Item__c);
                if (set_orderIds.size() < 1000){
                    set_orderIds.add(sh.Order__c);
                }
                if(set_orderLineIds.size() < 1000){
                    set_orderLineIds.add(sh.Order_Line_Item__c);
                }
            }
            if (set_orderIds.size() > 0){
                SOQLcondition += extendWhereClause(SOQLcondition) + 'Id IN ' + createSOQLCollectionFromSet(set_orderIds);
            } else {
                avoidOrderQuery = true;
            }
            if (set_orderLineIds.size() > 0){
                subSOQLcondition += extendWhereClause(subSOQLcondition) + 'Id IN ' + createSOQLCollectionFromSet(set_orderLineIds);
            } else {
                avoidItemQuery = true;
            }
        }
        
        
        // setting initial SOQL_items statement
        // **Change 08.02.2011** - Remove SOQL_items = 'Select Id, Name, CurrencyIsoCode, Order__c, Order__r.Id, Order_Group__c, Order_Line_Status__c, Invoice_No__c, Patient_Ref_No__c, Customer_PO_No__c, Unit_Price__c, Extended_Price__c, Item__c, Ship_From__c, Quantity__c, Product_SKU__r.Name, Product_SKU__r.PS_Product_SKU__c, Product_SKU__r.Description, Lot_Serial_ID__c ';
        // **Change 08.02.2011** - Add
        SOQL_items = 'Select Id, Name, CurrencyIsoCode, Order__c, Order__r.Id, Order_Group__c, Order_Line_Status__c, Invoice_No__c, Patient_Ref_No__c, Customer_PO_No__c, Unit_Price__c, Extended_Price__c, Item__c, Ship_From__c, Quantity__c, Product_SKU__c, PS_Product_SKU__c, Product_Description__c, Lot_Serial_ID__c ';
        // **Change 08.02.2011** - End
        SOQL_items += 'From Order_Line_Item__c';
        
        // add subSOQL where clause to subSOQL
        SOQL_items += subSOQLcondition;
        
        //add order by clause
        SOQL_items += ' ORDER BY Item__c ASC';
        
        //add limit clause because of list limitations
        SOQL_items += ' LIMIT 1000';
        System.debug('SOQL ITEMS: ' + SOQL_items);
        
        // setting initial subSOQL statement
        subSOQL += '(';
        //subSOQL += 'Select Id, Name, Patient_Ref_No__c, Product_SKU__c ';
        // **Change 08.02.2011** - Remove subSOQL += 'Select Id, Name, CurrencyIsoCode, Order__c, Order__r.Id, Order_Group__c, Order_Line_Status__c, Invoice_No__c, Patient_Ref_No__c, Customer_PO_No__c, Unit_Price__c, Extended_Price__c, Item__c, Ship_From__c, Quantity__c,  Product_SKU__c, Product_SKU__r.Name, Product_SKU__r.PS_Product_SKU__c, Product_SKU__r.Description, Lot_Serial_ID__c ';         
        // **Change 08.02.2011** - Add
        subSOQL += 'Select Id, Name, CurrencyIsoCode, Order__c, Order__r.Id, Order_Group__c, Order_Line_Status__c, Invoice_No__c, Patient_Ref_No__c, Customer_PO_No__c, Unit_Price__c, Extended_Price__c, Item__c, Ship_From__c, Quantity__c,  Product_SKU__c, PS_Product_SKU__c, Product_Description__c, Lot_Serial_ID__c ';         
        // **Change 08.02.2011** - End
        subSOQL += 'From Order_Line_Items__r';
        
        // add subSOQL where clause to subSOQL
        subSOQL += subSOQLcondition;
        
        //add order by clause
        subSOQL += ' ORDER BY Item__c ASC';
        
        //add limit clause because of list limitations
        subSOQL += ' LIMIT 1000';
        
        // close subSOQL statement with bracket
        subSOQL += ')';
        System.debug('--> full subSOQL: ' + subSOQL);
        
        // setting initial SOQL statement       
        SOQL = 'Select '; 
        SOQL+= 'o.Account__c, o.Account__r.Id, o.Account__r.Name, o.Account__r.Ship_To_Id__c, o.Account__r.ShippingCity, o.Bill_To_ID__c, '; 
        SOQL+= 'o.Carrier__c, o.Carrier__r.Name, o.CreatedById, o.Ref_Order_Number__c, order_entered_by__c, msr_no__c, '; 
        SOQL+= 'o.Id, o.CurrencyIsoCode, o.Order_Status__c, o.Business_Unit__c, o.Ship_To_ID__c, o.Order_Source__c, o.Order_Group__c, o.Freight_Amount__c, o.Name, o.Customer_PO_No__c, o.Order_Date__c ';                          
        
        // Add Bill_To_Account__c for Link to bill to account in order tracking
        SOQL+= ',o.Account__r.Bill_To_Account__c'; 
        
        //if user entered search criteria for OrderLineItem level, prevent SOQL to do outer join
        if(queryLines){
            System.debug('--> Query Lines');
            Set<Id> set_orderIds = new Set<Id>();
            Integer i = 0;
            for (Order_Line_Item__c oli: Database.query(SOQL_items)){
                i ++;
                set_orderIds.add(oli.Order__r.Id);
            }
            System.debug('--> #Lines found: ' + i);
            System.debug('--> Size of set_orderIds: ' + set_orderIds.size());
            if (set_orderIds.size() > 0){
                SOQLcondition += extendWhereClause(SOQLcondition) + 'Id IN ' + createSOQLCollectionFromSet(set_orderIds);
            } else {
                avoidOrderQuery = true;
            }
        }
        
        // add subSQOL to SOQL
        SOQL += ', ' + subSOQL;
        
        // add from statement to SOQL
        SOQL+= 'from Order_Header__c o ';  
        
        // add SOQL where clause to SOQL        
        SOQL+= SOQLcondition;
        
        //add order by clause
        SOQL += ' ORDER BY Order_Date__c DESC limit 200';
        
        System.debug('--> full SOQL: ' + SOQL);
        
        //List<Order_Header__c> list_headers = Database.query(SOQL);
        //System.debug('--> # Orders found: ' + list_headers.size());
        
        //Add additional Order Header query
        if (orderNoSearch != ''){
            List<Order_Header__c> list_checkHeaders = [Select Id, Name from Order_Header__c where Name = : orderNoSearch];
            System.debug('LIST CHECK HEADERS: ' + list_checkHeaders);
            if (list_checkHeaders.size() == 0){
                return '';
            }
        }
        
        System.debug('--> avoidOrderQuery: ' + avoidOrderQuery);
        System.debug('--> avoidItemQuery: ' + avoidItemQuery);
        if(!avoidOrderQuery && !avoidItemQuery){
            return SOQL;
        } else {
            return '';
        }
        
    }
    
    private String createSOQLCollectionFromSet(Set<Id> set_strings){
        String returnValue = '(';
        for (String s : set_strings){
            if(returnValue!= '('){
                returnValue += ', ';    
            }
            returnValue += '\'';
            returnValue += s;
            returnValue += '\'';
        }
        returnValue += ')';
        
        return returnValue;
    }
    
    private String createSOQLCollectionFromSetOfStrings(Set<String> set_strings){
        String returnValue = '(';
        for (String s : set_strings){
            if(returnValue!= '('){
                returnValue += ', ';    
            }
            returnValue += '\'';
            returnValue += s;
            returnValue += '\'';
        }
        returnValue += ')';
        
        return returnValue; 
    }
    
    private void queryTreeStructure(String SOQL){
        System.debug('********** queryTreeStructure **********');
        
        Map<Id, ClsTreeHeader> map_orderId_treeHeader = new Map<Id, ClsTreeHeader>();
        Map<Id, List<ClsTreeItem>> map_orderId_listTreeItems = new Map<Id, List<ClsTreeItem>>();
        Map<Id, List<ClsTreeShipment>> map_orderLineId_listTreeShipments = new Map<Id, List<ClsTreeShipment>>();
        Map<Id, Set<String>> map_orderId_setMatchKeys = new Map<Id, Set<String>>();
        
        Integer i = 0; // # of headers found
        Integer m = 0; //# total of all according items found for all headers
        System.debug('654, SQL: ' + SOQL);
        if (SOQL != ''){
            for(Order_Header__c header : Database.query(SOQL)){
                i++;
                
                //CLS ADDING FIRST ORDER NUMBER SO WE CAN PASS THAT TO THE OPTUM BUTTON IF NEEDED
                if (i == 1) {
                    
                    firstOrderNumber = header.Name;
                    firstOrderNumber = firstOrderNumber.substring(6, firstOrderNumber.length());
                    
                    system.debug('************************** FIRST ORDER NUMBER: ' + firstOrderNumber + '*****************************');
                    
                    if (firstMsrNumber == '' || firstMsrNumber == null) {
                        useForOptumButton = firstOrderNumber;
                    }
                    else {
                        useForOptumButton = firstMsrNumber;
                    }
                    
                    system.debug('************************* VALUE FOR OPTUM BUTTON: ' + useForOptumButton + '**************************');
                }
                //CLS END FIRST ORDER NUMBER              
                
                System.debug('--> # HEADER: ' + i);
                System.debug('--> # used Bytes for Apex Heap Size [before clsHeader Constr. 466]: ' + Limits.getHeapSize() + ' / ' + Limits.getLimitHeapSize());
                
                ClsTreeHeader clsHeader = new ClsTreeHeader();
                clsHeader.header = header;
                
                System.debug('--> # used Bytes for Apex Heap Size [before clsHeader Constr. 471]: ' + Limits.getHeapSize() + ' / ' + Limits.getLimitHeapSize()); 
                
                Set<String> set_matchKeys = new Set<String>();
                Integer k = 0;
                showSerialLotID = false;
                for (Order_Line_Item__c item : header.Order_Line_Items__r){
                    k++;
                    if(item.lot_serial_id__c != null) {
                        showSerialLotID = true;
                    }
                    System.debug('--> # According ITEM: ' + k);
                    System.debug('--> # used Bytes for Apex Heap Size [476]: ' + Limits.getHeapSize() + ' / ' + Limits.getLimitHeapSize());
                    ClsTreeItem clsItem = new ClsTreeItem();
                    clsItem.item = item;
                    clsHeader.list_items.add(clsItem);
                    
                    //String matchKey = String.valueOf(header.Id).substring(0,15) + '||' + String.valueOf(item.Id).substring(0,15);
                    String matchKey = String.valueOf(header.Id) + '||' + String.valueOf(item.Id);
                    set_matchKeys.add(matchKey);
                }
                System.debug('--> # according ITEMs: ' + clsHeader.list_items.size());
                System.debug('--> # of loops for Line Items: ' + k);
                m += k;
                
                System.debug('--> # used Bytes for Apex Heap Size [Before HEADER maps 488]: ' + Limits.getHeapSize() + ' / ' + Limits.getLimitHeapSize());
                map_orderId_treeHeader.put(header.Id, clsHeader);
                map_orderId_listTreeItems.put(header.Id, clsHeader.list_items.clone());
                //map_orderId_listTreeItems.put(header.Id, clsHeader.list_items);
                map_orderId_setMatchKeys.put(header.Id, set_matchKeys);
                System.debug('--> # used Bytes for Apex Heap Size [After HEADER maps 493]: ' + Limits.getHeapSize() + ' / ' + Limits.getLimitHeapSize());
            }
            System.debug('--> # Order Headers found: ' + map_orderId_treeHeader.size());
            System.debug('--> # of loops for Order Headers: ' + i);
            System.debug('--> # of loops for all according ITEMs: ' + m);
            System.debug('--> # used Bytes for Apex Heap Size: ' + Limits.getHeapSize() + ' / ' + Limits.getLimitHeapSize());
            
            //String SOQL_shipments = 'Select Carrier__c, Carrier__r.Website__c, Id, Invoice_No__c, MatchKey__c, Name, Order__c, Order_Line_Item__c, Pack_List_No__c, Quantity_Allocated__c, Quantity_Backordered__c, Quantity_Shipped__c, Shipment_Date__c, Shipment_Status__c, Signed_for_By__c, Tracking_No__c from Shipping_History__c ';
            String SOQL_shipments = 'Select Carrier__c, Carrier__r.name, Carrier__r.Website__c, Id, Invoice_No__c, MatchKey__c, Name, Order__c, Order_Line_Item__c, Pack_List_No__c, Quantity_Allocated__c, Quantity_Backordered__c, Quantity_Shipped__c, Shipment_Date__c, Shipment_Status__c, Signed_for_By__c, Tracking_No__c from Shipping_History__c ';
            String SOQL_conditionShipments = '';
            
            Boolean executeShipmentQuery = false;   
            for(String orderId : map_orderId_setMatchKeys.keySet()){
                Set<String> set_matchKeys = map_orderId_setMatchKeys.get(orderId);
                if (set_matchKeys.size() > 0){
                    executeShipmentQuery = true;
                    //SOQL_conditionShipments += extendWhereClauseWithOR(SOQL_conditionShipments) + 'MatchKey__c IN ' + createSOQLCollectionFromSetOfStrings(set_matchKeys);
                    SOQL_conditionShipments += extendWhereClauseWithOR(SOQL_conditionShipments) + 'MatchKey__c IN ' + createSOQLCollectionFromSetOfStrings(set_matchKeys);
                    System.debug('--> SOQL_conditionShipments: ' + SOQL_conditionShipments);
                }
            }   
            System.debug('--> # used Bytes for Apex Heap Size [after Shipment SOQL Condition 515]: ' + Limits.getHeapSize() + ' / ' + Limits.getLimitHeapSize());
            
            SOQL_conditionShipments += ' LIMIT 9000 ';
            SOQL_shipments += SOQL_conditionShipments;          
            System.debug('--> Shipment SQOl query: ' + SOQL_shipments);
            
            Integer j = 0;
            if (executeShipmentQuery){
                for(Shipping_History__c shipment: Database.query(SOQL_shipments)){
                    j++;
                    System.debug('--> # SHIPMENT LOOP: ' + j);
                    System.debug('--> # used Bytes for Apex Heap Size: ' + Limits.getHeapSize() + ' / ' + Limits.getLimitHeapSize());
                    ClsTreeShipment clsShipment = new ClsTreeShipment();
                    List<ClsTreeShipment> list_clsShipments = new List<ClsTreeShipment>();
                    clsShipment.shipment = shipment;                    
                    if (map_orderLineId_listTreeShipments.containsKey(shipment.Order_Line_Item__c)){
                        list_clsShipments = map_orderLineId_listTreeShipments.get(shipment.Order_Line_Item__c).clone();
                        //list_clsShipments = map_orderLineId_listTreeShipments.get(shipment.Order_Line_Item__c);
                    }
                    //if (list_clsShipments.size() < 1000){
                        list_clsShipments.add(clsShipment);
                    //}         
                    //if (map_orderLineId_listTreeShipments.size() < 1000){
                        map_orderLineId_listTreeShipments.put(shipment.Order_Line_Item__c, list_clsShipments);
                    //}          
                }
            } else {
                map_orderId_treeHeader.clear();
            }
            System.debug('--> # of loops for Shipping History: ' + j);
            
            // Fill TreeStructure, add Shipment information
            for(ClsTreeHeader clsHeader : map_orderId_treeHeader.values()){
                System.debug('--> # used Bytes for Apex Heap Size [LOOP clsHeader 534]: ' + Limits.getHeapSize() + ' / ' + Limits.getLimitHeapSize());
                Map<Id, Set<Id>> map_shipId_SetItemIds = new Map<Id, Set<Id>>();
                
                //CODE CHANGE 29/06/2010
                Set<Id> set_handledItemIds = new Set<Id>();
                //END CODE CHANGE
                
                Map<String, Set<Id>> map_matchKey_SetItemIds = new Map<String, Set<Id>>();
                Map<String, Id> map_matchKey_shipId = new Map<String, Id>();
                //Map<Id, Set<Id>> map_itemId_SetShipIds = new Map<Id, Set<Id>>();
                
                Map<Id, ClsTreeItem> map_itemId_clsTreeItem = new Map<Id, ClsTreeItem>();
                Map<Id, ClsTreeShipment> map_shipId_clsTreeShipment = new Map<Id, ClsTreeShipment>();
                
                Id orderId = clsHeader.header.Id;
                clsHeader.list_items.clear();
                
                if(map_orderId_listTreeItems.containsKey(orderId)){
                    for (ClsTreeItem clsItem : map_orderId_listTreeItems.get(orderId)){
                        Id itemId = clsItem.item.Id;
                        map_itemId_clsTreeItem.put(itemId, clsItem);
                                        
                        if(map_orderLineId_listTreeShipments.containsKey(itemId)){
                            System.debug('map_orderLineId_listTreeShipments.size(): ' + map_orderLineId_listTreeShipments.size());
                            for(ClsTreeShipment clsShipment : map_orderLineId_listTreeShipments.get(itemId)){                   
                                System.debug('--> # used Bytes for Apex Heap Size [LOOP clsShipment 553]: ' + Limits.getHeapSize() + ' / ' + Limits.getLimitHeapSize());
                                Id shipId = clsShipment.shipment.Id;
                                if (clsShipment.shipment.Pack_List_No__c != null){
                                    String matchKey = clsShipment.shipment.Pack_List_No__c;
                                    
                                    //clsItem.list_shipments.add(clsShipment);
                                    
                                    map_shipId_clsTreeShipment.put(shipId, clsShipment);
                                    map_matchKey_shipId.put(matchKey, shipId);                                                                                                          
                                    
                                    Set<Id> set_itemIds = new Set<Id>();
                                    /*if (map_shipId_SetItemIds.containsKey(shipId)){
                                        set_itemIds = map_shipId_SetItemIds.get(shipId);
                                    }
                                    set_itemIds.add(itemId);                                
                                    map_shipId_SetItemIds.put(shipId, set_itemIds);*/
                                    if (map_matchKey_SetItemIds.containsKey(matchKey)){
                                        set_itemIds = map_matchKey_SetItemIds.get(matchKey);
                                    }
                                    set_itemIds.add(itemId);
                                    map_matchKey_SetItemIds.put(matchKey, set_itemIds);
                                    
                                    //Set<Id> set_shipIds = new Set<Id>();
                                    //if (map_itemId_SetShipIds.containsKey(itemId)){
                                    //  set_shipIds = map_itemId_SetShipIds.get(itemId);
                                    //}
                                    //set_shipIds.add(shipId);                              
                                    //map_itemId_SetShipIds.put(itemId, set_shipIds);
                                
                                }                                                                       
                            }
                        }                       
                        //clsHeader.list_items.add(clsItem);
                    }
                }
                
                //code to decide if shipment list oder item list will be added to order
                
                //for(Id shipId : map_shipId_SetItemIds.keySet()){
                if(map_matchKey_SetItemIds.size() > 0){
                System.debug('--> MatchKey Map has elements.'); 
                    for(String matchKey : map_matchKey_SetItemIds.keySet()){
                        System.debug('--> # used Bytes for Apex Heap Size [LOOP MatchKey 594]: ' + Limits.getHeapSize() + ' / ' + Limits.getLimitHeapSize());
                        System.debug('--> MatchKey: ' + matchKey);
                        Id shipId = map_matchKey_shipId.get(matchKey);
                        System.debug('--> shipId: ' + shipId);
                        ClsTreeShipment clsShipment = map_shipId_clsTreeShipment.get(shipId);                   
                        Set<Id> set_itemIds = map_matchKey_SetItemIds.get(matchKey);
                        
                        //CODE CHANGE 29/06/2010
                        set_handledItemIds.addAll(set_itemIds); 
                        //END CODE CHANGE
                        
                        if (set_itemIds.size() > 1){ //Grouping needed
                            System.debug('--> Shipment has multiple itemIds');
                            Integer qtyShipped = 0;
                            for(Id itemId : set_itemIds){
                                //map_itemId_SetShipIds.remove(itemId);
                                 
                                ClsTreeItem itemQty = map_itemId_clsTreeItem.get(itemId);
                                qtyShipped += itemQty.item.Quantity__c.intValue(); 
                                                                                                
                                clsShipment.list_items.add(map_itemId_clsTreeItem.get(itemId));
                                //map_itemId_clsTreeItem.remove(itemId); //added on 3rd Nov
                            }
                            clsShipment.shipment.Quantity_Shipped__c = qtyShipped;
                            clsHeader.list_shipments.add(clsShipment);
                        } else {
                            //map_ShipId_SetItemIds.remove(shipId);
                            System.debug('--> Shipment is ordered below Item');
                            for(Id itemId : set_itemIds){
                                if (map_itemId_clsTreeItem.containsKey(itemId)){
                                    System.debug('--> Map contains itemId');
                                }                               
                                ClsTreeItem clsItem = map_itemId_clsTreeItem.get(itemId);
                                System.debug('--> before removing itemId from Map');
                                //map_itemId_clsTreeItem.remove(itemId); //added on 3rd Nov
                                System.debug('--> before adding clsSHipment to item.shipmentList');
                                /*if (clsItem.list_shipments == null){
                                    System.debug('--> clsItem.ListShips empty');
                                }
                                if (clsShipment == null){
                                    System.debug('--> clsShipment empty');
                                }*/
                                clsItem.list_shipments.add(clsShipment);
                                if (clsItem.list_shipments.size() == map_orderLineId_listTreeShipments.get(itemId).size() || clsItem.list_shipments.size() == set_itemIds.size()){
                                    clsHeader.list_items.add(clsItem);
                                }
                            }
                            
                        }
                        //map_shipId_clsTreeShipment.remove(shipId);//added on 3rd Nov
                    }
                } else {
                    System.debug('--> no Shipments found for this order.');
                    for(Id itemId: map_itemId_clsTreeItem.keySet()){
                        ClsTreeItem clsItem = map_itemId_clsTreeItem.get(itemId);                       
                        
                        if(map_orderLineId_listTreeShipments.containsKey(itemId)){
                            for(ClsTreeShipment clsShipment : map_orderLineId_listTreeShipments.get(itemId)){
                                clsItem.list_shipments.add(clsShipment);
                            }
                            //map_orderLineId_listTreeShipments.remove(itemId);//added on 3rd Nov
                        }
                        clsHeader.list_items.add(clsItem);
                    }
                    //map_itemId_clsTreeItem.get(itemId);//added on 3rd Nov
                }                                       
 
                //CODE CHANGE 28/06/2010
                System.debug('map_itemId_clsTreeItem.keySet().size(): ' + map_itemId_clsTreeItem.keySet().size());
                System.debug('set_handledItemIds.size(): ' + set_handledItemIds.size());
                if (map_itemId_clsTreeItem.keySet().size() != set_handledItemIds.size() && set_handledItemIds.size() > 0){
                    for(Id itemId: map_itemId_clsTreeItem.keySet()){
                        if (!set_handledItemIds.contains(itemId)){
                            ClsTreeItem clsItem = map_itemId_clsTreeItem.get(itemId);                       
                            
                            if(map_orderLineId_listTreeShipments.containsKey(itemId)){
                                for(ClsTreeShipment clsShipment : map_orderLineId_listTreeShipments.get(itemId)){
                                    clsItem.list_shipments.add(clsShipment);
                                }
                                //map_orderLineId_listTreeShipments.remove(itemId);//added on 3rd Nov
                            }
                            clsHeader.list_items.add(clsItem);
                        }
                    }
                }
                //END CODE CHANGE
                
                System.debug('--> #Shipments in Header: ' + clsHeader.list_shipments.size());
                System.debug('--> #Items in Header: ' + clsHeader.list_items.size());
                this.list_clsHeaders.add(clsHeader);
            }
            
            this.noRecords = this.list_clsHeaders.size();
            System.debug('--> this.noRecords: ' + this.noRecords);
            doSort();
            first();
        } else {
            this.noRecords = 0;
            first();
        }        
    }
    
    private void doSort(){
        System.debug('********** doSort: Sort result Lists **********');
        List<ClsTreeHeader> list2sort = this.list_clsHeaders;
        System.debug('--> this.list_clsHeaders.size(): ' + this.list_clsHeaders.size());
        for (Integer o=0; o<list2sort.size(); o++) {            
            System.debug('--> Entered first loop: ');
            ClsTreeHeader temp = list2sort[o];    // store the value that will be compared
            Integer i = o;          // start shifting at out
            
            if(i > 0) {
                while(i > 0 && list2sort[i-1].header.Order_Date__c.daysBetween(temp.header.Order_Date__c) >= 0) {
                    list2sort[i] = list2sort[i-1];     // shift item to the right
                    i--;          // go left one position
                }
                list2sort[i] = temp;        // insert marked item
            }
            
            //sort according lines
            List<ClsTreeItem> list2sortItem = temp.list_items;
            for (Integer j=0; j<list2sortItem.size(); j++) {
                System.debug('--> Entered nested item loop: ');
                ClsTreeItem tempItem = list2sortItem[j];    // store the value that will be compared
                Integer k = j;          // start shifting at out
                if(k > 0) {
                    while(k > 0 && list2sortItem[k-1].item.Item__c > tempItem.item.Item__c) {
                        list2sortItem[k] = list2sortItem[k-1];     // shift item to the right
                        k--;          // go left one position
                    }
                    list2sortItem[k] = tempItem;        // insert marked item
                }
                
                //sort according shipments
                List<ClsTreeShipment> list2sortShip = tempItem.list_shipments;
                for (Integer m=0; m<list2sortShip.size(); m++) {
                    System.debug('--> Entered nested Ship loop: ');
                    ClsTreeShipment tempShip = list2sortShip[m];    // store the value that will be compared
                    Integer n = m;          // start shifting at out
                    
                    Integer days = 0; 
                
                    if(n > 0) { 
                        if (list2sortShip[n-1].shipment.Shipment_Date__c != null && tempShip.shipment.Shipment_Date__c != null){
                            days = list2sortShip[n-1].shipment.Shipment_Date__c.daysBetween(tempShip.shipment.Shipment_Date__c);
                        } else if (list2sortShip[n-1].shipment.Shipment_Date__c != null && tempShip.shipment.Shipment_Date__c == null){
                            days = 1;
                        } else {
                            days = -1;
                        }
                        
                        while(n > 0 && days >= 0) {
                            list2sortShip[n] = list2sortShip[n-1];     // shift item to the right
                            n--;          // go left one position
                            
                            //set days
                            if (n>0){    
                                if (list2sortShip[n-1].shipment.Shipment_Date__c != null && tempShip.shipment.Shipment_Date__c != null){
                                    days = list2sortShip[n-1].shipment.Shipment_Date__c.daysBetween(tempShip.shipment.Shipment_Date__c);
                                } else if (list2sortShip[n-1].shipment.Shipment_Date__c != null && tempShip.shipment.Shipment_Date__c == null){
                                    days = 1;
                                } else {
                                    days = -1;
                                }
                            }
                        }
                        
                        list2sortShip[n] = tempShip;        // insert marked item
                    }
                    
                    /*
                    if(n > 0 && list2sortShip[n-1].shipment.Shipment_Date__c != null && tempShip.shipment.Shipment_Date__c != null) {   
                        while(n > 0 && list2sortShip[n-1].shipment.Shipment_Date__c.daysBetween(tempShip.shipment.Shipment_Date__c) >= 0) {
                            list2sortShip[n] = list2sortShip[n-1];     // shift item to the right
                            n--;          // go left one position
                        }
                        list2sortShip[n] = tempShip;        // insert marked item
                    }
                    */
                }
            
            } // end for items
            
            //sort according shipments
            List<ClsTreeShipment> list2sortShip = temp.list_shipments;
            for (Integer m=0; m<list2sortShip.size(); m++) {
                System.debug('--> Entered Shipment loop: ');
                ClsTreeShipment tempShip = list2sortShip[m];    // store the value that will be compared
                Integer n = m;          // start shifting at out
                
                Integer days = 0; 
                
                if(n > 0) { 
                    if (list2sortShip[n-1].shipment.Shipment_Date__c != null && tempShip.shipment.Shipment_Date__c != null){
                        days = list2sortShip[n-1].shipment.Shipment_Date__c.daysBetween(tempShip.shipment.Shipment_Date__c);
                    } else if (list2sortShip[n-1].shipment.Shipment_Date__c != null && tempShip.shipment.Shipment_Date__c == null){
                        days = 1;
                    } else {
                        days = -1;
                    }
                    
                    while(n > 0 && days >= 0) {
                        list2sortShip[n] = list2sortShip[n-1];     // shift item to the right
                        n--;          // go left one position
                        
                        //set days
                        if (n>0){    
                            if (list2sortShip[n-1].shipment.Shipment_Date__c != null && tempShip.shipment.Shipment_Date__c != null){
                                days = list2sortShip[n-1].shipment.Shipment_Date__c.daysBetween(tempShip.shipment.Shipment_Date__c);
                            } else if (list2sortShip[n-1].shipment.Shipment_Date__c != null && tempShip.shipment.Shipment_Date__c == null){
                                days = 1;
                            } else {
                                days = -1;
                            }
                        }
                    }
                }
                //list2sortShip[n] = tempShip;        // insert marked item
            
                //sort according lines
                List<ClsTreeItem> list2sortShipItem = tempShip.list_items;
                for (Integer j=0; j<list2sortShipItem.size(); j++) {
                    System.debug('--> Entered nested Item loop: ');
                    ClsTreeItem tempItem = list2sortShipItem[j];    // store the value that will be compared
                    Integer k = j;          // start shifting at out
                    
                    if(k > 0) {     
                        while(k > 0 && list2sortShipItem[k-1].item.Item__c > tempItem.item.Item__c) {
                            list2sortShipItem[k] = list2sortShipItem[k-1];     // shift item to the right
                            k--;          // go left one position
                        }
                        list2sortShipItem[k] = tempItem;        // insert marked item
                    }
                }
                tempShip.list_items = list2sortShipItem;
                list2sortShip[n] = tempShip;
            }  // end for shipments
            
            
        } // end for header
    }
    
    /*private void fillTreeStructure(String SOQL){
        //List<Order_Header__c> list_headers
        
        Integer i = 0;
        for(Order_Header__c header : Database.query(SOQL)){
            i += 1;
            System.debug('--> # HEADER: ' + i);
            
            ClsTreeHeader clsHeader = new ClsTreeHeader();
            clsHeader.header = header;
            
            for (Order_Line_Item__c item : header.Order_Line_Items__r){
                ClsTreeItem clsItem = new ClsTreeItem();
                clsItem.item = item;
                
                for(Shipping_History__c shipment : [Select s.Carrier__c, s.Carrier__r.Website__c, s.Id, s.Invoice_No__c, s.MatchKey__c, s.Name, s.Order__c, 
                    s.Order_Line_Item__c, s.Pack_List_No__c, s.Quantity_Allocated__c, s.Quantity_Backordered__c, s.Quantity_Shipped__c, 
                    s.Shipment_Date__c, s.Shipment_Status__c, s.Signed_for_By__c, s.Tracking_No__c
                    from Shipping_History__c s where Order__c = :header.Id and Order_Line_Item__c = :item.Id]){
                    
                    ClsTreeShipment clsShipment = new ClsTreeShipment();
                    clsShipment.shipment = shipment;                    
                    clsItem.list_shipments.add(clsShipment);                            
                }
                
                clsHeader.list_items.add(clsItem);
            }
            System.debug('--> # according ITEMs: ' + clsHeader.list_items.size());
            
            System.debug('--> Adding clsHeader to List at Index: ' + i);
            this.list_clsHeaders.add(clsHeader);
        }
        
        //for(Order_Header__c header : this.list_clsHeaders
        //for(Shipping_History__c shipment : [Select Id, Name, Order__c, Order_Line_Item__c, Shipment_Date__c, 
        //  Shipment_Status__c, Quantity_Shipped__c, Quantity_Backordered__c, Tracking_No__c from Shipping_History__c where Order__c = :header.Id and Order_Line_Item__c = :item.Id]){
                    
        //  ClsTreeShipment clsShipment = new ClsTreeShipment();
        //  clsShipment.shipment = shipment;                    
        //  clsItem.list_shipments.add(clsShipment);                            
        //}
    }*/
    
    private String extendWhereClause(String value){
        /* extend SOQL Where Clause with AND or WHERE dependent on actual content */
        String returnValue = '';
        
        if (value != ''){
            returnValue += ' AND ';
        }else {
            returnValue += ' WHERE ';
        }
        return returnValue; 
    }
    
    private String extendWhereClauseWithOR(String value){
        /* extend SOQL Where Clause with AND or WHERE dependent on actual content */
        String returnValue = '';
        
        if (value != ''){
            returnValue += ' OR ';
        }else {
            returnValue += ' WHERE ';
        }
        return returnValue; 
    }
    
    /*private void queryAll(){
        
        List<Order_Header__c> list_headers = 
            [Select 
            o.Account__c, o.Account__r.Id, o.Account__r.Name, o.Account__r.Ship_To_Id__c, 
            o.Carrier__c, o.Carrier__r.Name, 
            o.Id, o.Name, o.Customer_PO_No__c, o.Order_Date__c, 
                (Select Id, Patient_Ref_No__c, Product_SKU__c 
                 From Order_Line_Items__r
                 Where 
                 Patient_Ref_No__c = :patientReference
                ) 
            from Order_Header__c o  
            where 
            o.Account__r.Ship_To_ID__c = :shipToId and o.Account__r.Name = :shipToAccountName
            //and
            //o.Order_Date__c >= :Date.valueOf(fromOrderDate) and o.Order_Date__c <= :Date.valueOf(toOrderDate)
            and
            o.Customer_PO_No__c = :customerPO
            ]; 
    }*/
    
    public PageReference next() {
        System.debug('********** Next records **********');
        // If current last shown record (endRecord) is not yet the last record available
        System.debug('--> this.endRecord: ' + this.endRecord);
        System.debug('--> this.noRecord: ' + this.noRecords);
        System.debug('--> this.startRecord: ' + this.startRecord);
        if (this.endRecord < this.noRecords) {
            // Move to the next set of maxRecords
            this.startRecord = this.endRecord + 1;
            this.endRecord += this.maxRecords;
        }
        
        // If we now calculated and endRecord that does not exist, correct it to max available records (noRecords)
        if (this.endRecord > this.noRecords) {
            this.endRecord = this.noRecords;
        }
        
        System.debug('--> Result after NEXT records:');
        System.debug('--> this.endRecord: ' + this.endRecord);
        System.debug('--> this.noRecord: ' + this.noRecords);
        System.debug('--> this.startRecord: ' + this.startRecord);
        return null;
    }
    
    /**
    * Selects the previous maxRecords records to show. Used to jump to the previous records on the page. Remember the command link is not shown when the first records are shown.
    */
    
    public void previous() {
        
        // If we are at the end already
        if (this.endRecord == this.noRecords)
            // move one batch back by current start by 1 record, as the last batch might have less than maxRecords
            this.endRecord = this.startRecord - 1;
        else
            // otherwise we can substract a full batch of maxRecords
            this.endRecord -= this.maxRecords;
        
        // for the start we can simple substract maxRecords
        this.startRecord -= this.maxRecords;
        
    }
    
    /**
    * Sets the record selectors to the last page batch. Used to jump to the last maxRecords group on the page. Remember the command link is not shown when the last records are shown.
    */
    
    public void last() {
        // Go to the end which is endRecord equals number of records available
        this.endRecord = noRecords;
        
        // start might be noRecords - maxRecords if the last batch has exaclty maxRecords, in general startRecord >= noRecords - maxRecords
        // To calculate this we divide Integers noRecords and maxRecords. Note: Apex will floor the number, i.e. 5.1 - 5.9 => 5.
        this.startRecord = (this.noRecords/this.maxRecords) * this.maxRecords + 1;
        
    }
    
    /**
    * Sets the record selectors to the first page batch. Used to jump to the first maxRecords group on the page. Remember the command link is not shown when the first records are shown.
    */
    
    public void first() {
        System.debug('********** First **********');
        
        // Move to first record
        this.startRecord = 1;
        System.debug('START RECORD: ' + this.startRecord);
        if (this.noRecords == 0){
            this.startRecord = 0;
        }       
        
        System.debug('--> this.endRecord: ' + this.endRecord);
        System.debug('--> this.noRecord: ' + this.noRecords);
        System.debug('--> this.startRecord: ' + this.startRecord);
        
        // For endRecord we have to check if noRecords greater than maxRecords. If so we can only display maxRecords in first batch    
        if (this.noRecords >= this.maxRecords) {
            this.endRecord = this.maxRecords;
        }
        else { // Otherwise we'll show all records
            this.endRecord = this.noRecords;
        }
        
        System.debug('--> Result after FIRST:');
        System.debug('--> this.endRecord: ' + this.endRecord);
        System.debug('--> this.noRecord: ' + this.noRecords);
        System.debug('--> this.startRecord: ' + this.startRecord);
    }
    
    /*************************************************************************
    * Getter and Setter Methods
    *************************************************************************/
    
    public List<ClsTreeHeader> getAccordingHeaderList() {
        System.debug('********** getHeaderList **********');
        List<ClsTreeHeader> list_headerList = new List<ClsTreeHeader>();
        if (this.list_clsHeaders.size() > 0){   
            if (this.endrecord == 0){
                first();
            }
            //List<ClsTreeHeader> list_headerList = new List<ClsTreeHeader>();
            System.debug('--> startRecord: ' + this.startRecord);
            System.debug('--> endRecord: ' + this.endRecord);
            for (Integer i=this.startRecord - 1; i<this.endRecord; i++) {
                System.debug('--> adding Item to List. #Item: ' + i);
                list_headerList.add(this.list_clsHeaders[i]);
            }
            System.debug('--> Size of list_headerList: ' + list_headerList.size());
        }
        return list_headerList;
    }
    
    public String getRecordStatus () {
        System.debug('********** getRecordStatus **********');
        System.debug('--> this.endRecord: ' + this.endRecord);
        System.debug('--> this.noRecord: ' + this.noRecords);
        System.debug('--> this.startRecord: ' + this.startRecord);
        return this.startRecord + '-' + this.endRecord + ' of ' + this.noRecords;
    }
    
    public List<String> getTreeHeadline(){
        List<String> list_return = new List<String>();
        list_return.add('1');
        return list_return;
    }
    
    public List<ClsTreeHeader> getTree(){
        return this.list_clsHeaders;
    }
    
    public String getListSize(){
        return String.valueOf(this.list_clsHeaders.size());
    }
    
    public String getSFDCUrl(){
        return ApexPages.currentPage().getUrl();
    }
    
    public String getexpandStyle(){
        System.debug('********** getExpandStyle ***********');
        String returnValue = 'none';
        if(this.list_clsHeaders.size() == 1 || this.expandAll){
            returnValue = 'block';
            this.expandAllButtonLabel = 'Collapse All';
        }
        System.debug('returnValue: ' + returnValue);
        return returnValue;
    }
    
    public String getstartPic(){        
        String returnValue = '/img/setup_plus.gif';
        if(this.list_clsHeaders.size() == 1 || this.expandAll){
            returnValue = '/img/setup_minus.gif';
        }
        
        return returnValue;
    }
    
    private static String getParameter(String paramName){
        String returnValue = '';
        Link_Management__c param =  Link_Management__c.getInstance(paramName);
        if (param != null){     
            returnValue = param.Value__c;
            if (param.Extended_Value__c != null && param.Extended_Value__c != ''){
                returnValue += param.Extended_Value__c; 
            }
        } 
        
        return returnValue;
    }
           
    public String getShippingBoxReport()
    {
        return getParameter('OT_ShippingBoxes_Report');     
    }
        
    public String getCaseLinkAccount(){
        return getParameter('OT_Case_Account');     
    }
    
    public String getCaseLinkOrder(){
        return getParameter('OT_Case_Order').substring(0,15);       
    }
    
    public String getCaseLinkProduct(){
        return getParameter('OT_Case_Product').substring(0,15);     
    }
    
    public String getCaseLinkShipment(){
        return getParameter('OT_Case_Shipment').substring(0,15);        
    }
    
    public String getCaseLinkShippedFrom(){
        return getParameter('OT_Case_ShippedFrom').substring(0,15);     
    }
    
    public String getCaseLinkOrderDate(){
        return getParameter('OT_Case_OrderDate').substring(0,15);       
    }
    
    public String getCaseLinkSerialLotID(){
        return getParameter('OT_Case_LotSerialID').substring(0,15);       
    }

    public String getCaseLinkInvoice(){
        return getParameter('OT_Case_Invoice').substring(0,15);       
    }

    public String getCaseLinkCarrierID(){
        return getParameter('OT_Case_CarrierID').substring(0,15);       
    }


    
    public String lpad (String input, Integer len, String padChar) {
        String paddedString = input;
        for (Integer i = input.length() + 1;i <= len;i++) {
            paddedString = padChar + paddedString;
        }
        return paddedString;
    }
    
     public List<SelectOption> getPossibleBusinessUnits() {
            List<SelectOption> options = new List<SelectOption>();
            String values = '';
            String defaultValues = '';
            List<Picklist_Management__c> list_pms = [Select Name, Values__c, Context__c from Picklist_Management__c where (Context__c = : roleName AND Name like 'OT_BU%') OR Name = 'OT_BU_Default'];
             
            for (Picklist_Management__c pm : list_pms){
                if (list_pms.size() > 1 && pm.Context__c == roleName){
                    if (values != ''){
                        values += ';';
                    }
                    values += pm.Values__c.trim();
                } 
                if (list_pms.size() == 1){
                    if (values != ''){
                        values += ';';
                    }
                    values += pm.Values__c.trim();
                }
            }
            
            /*
            if (values == ''){
                options.add(new SelectOption('n/a','n/a'));
                businessUnit = 'n/a';
            } else {
                for (String str : values.split(';',-1)){
                    options.add(new SelectOption(str,str)); 
                }
            }*/
            
            //add picklist values
            for (String str : values.split(';',-1)){
                options.add(new SelectOption(str,str)); 
            }            
            return options;
    }
    
    private static String getUserRoleName(){
        System.debug('UserInfo RoleId: ' + UserInfo.getUserRoleId());
        Id roleId = UserInfo.getUserRoleId();
        if (roleId != null){
            return [Select Id, Name from UserRole where Id =: roleId].Name;
        } else {
            return '';
        }       
    }   
}