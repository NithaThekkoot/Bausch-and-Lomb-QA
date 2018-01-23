/**
* 
*   Apex Class called using Future mode to calls a Web Service to retrieve prices from PeopleSoft to store on QuoteLineItem__c
*
*    Author         |Author-Email                   |Date          |Comment
*    ---------------|-------------------------------|--------------|--------------------------------------------------
*    Jennie Burns   |jennie.burns@bausch.com        |19-Nov-2014   |Initial release
*
*/
public with sharing class futureGetPrice {
@future(callout=true)
public static void GetPrice(list<string> QuoteLineItemIdList) {
  list<QuoteLineItem__c> LineItemsToUpdate = new list<QuoteLineItem__c>();
  list<Product2> PS_Product = new list<Product2>();
  Map<String, Double> map_PSSKU_price = new Map<String, Double>(); 
   //Declare Webservice Varibales
    ClsWSPriceCalculation.GetPSPriceSOAP WS = new ClsWSPriceCalculation.GetPSPriceSOAP();
    List<ClsWSPriceCalculation.InputData_element> list_WSInput = new List<ClsWSPriceCalculation.InputData_element>();
    List<ClsWSPriceCalculation.OutputData_element> list_WSOutput = new List<ClsWSPriceCalculation.OutputData_element>(); 
     
    
    //Increase Webservice callout timeout limit
    WS.timeout_x = 20000;
    
 for (QuoteLineItem__c Q : [select Id, ProductCode__c, Quantity__c, UnitsPerBox__c, Current_PeopleSoft_Price__c,Current_PeopleSoft_Price_per_Unit__c, Id__r.Bill_To_ID__c,Id__r.Ship_To_ID__c from QuoteLineItem__c where Id IN :QuoteLineItemIdList]){
 if(Q.Quantity__c != null && Q.ProductCode__c != '' 
        && Q.Id__r.Ship_To_ID__c != null && Q.Id__r.Bill_To_ID__c != null){
        ClsWSPriceCalculation.InputData_element input = new ClsWSPriceCalculation.InputData_element();
  //      map_PSSKU_price.put(Q.ProductCode__c, Q.Current_PeopleSoft_Price__c);
           input.BUSINESS_UNIT = 'BLUSA';
        input.ORDER_DATE = DateTime.now(); //date.today().day + '/' + date.today().month + '/' + date.today().year();
        System.debug('--> input.ORDER_DATE: ' + input.ORDER_DATE);
        input.PPRC_APP_CD = 'SO';
        System.debug('--> input.PPRC_APP_CD: ' + input.PPRC_APP_CD);
        input.PRODUCT_ID = Q.ProductCode__c; // 'SDD-020030PKR';
        PS_Product = [select PS_Product_SKU__c from Product2 where name = :Q.ProductCode__c limit 1];
        if (PS_Product.size() > 0) {
            If (PS_Product[0].PS_Product_SKU__c != null) { 
             input.PRODUCT_ID = PS_Product[0].PS_Product_SKU__c;
             }             
             }
        System.debug('--> input.PRODUCT_ID: ' + input.PRODUCT_ID);
        input.QTY_ORDERED = 1;
        System.debug('--> input.QTY_ORDERED: ' + input.QTY_ORDERED);
        input.SHIP_TO_CUST_ID = Q.Id__r.Ship_To_ID__c; //'11700910';
    //    System.debug('--> input.SHIP_TO_CUST_ID: ' + input.SHIP_TO_CUST_ID);        
        input.SOLD_TO_CUST_ID = Q.Id__r.Bill_To_ID__c; //'11700910';
    //    System.debug('--> this.billToDetails.Ship_To_ID__c: ' + this.header.Bill_To_ID__c);
        input.UNIT_OF_MEASURE = 'EA';
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
        
  for (QuoteLineItem__c Q : [select Id, ProductCode__c, UnitsPerBox__c, Current_PeopleSoft_Price__c,Current_PeopleSoft_Price_per_Unit__c, Id__r.Bill_To_ID__c,Id__r.Ship_To_ID__c from QuoteLineItem__c where Id IN :QuoteLineItemIdList]){
   if(Q.ProductCode__c != '' ){    
   String Priced_ProductCode = Q.ProductCode__c;
    PS_Product = [select PS_Product_SKU__c from Product2 where name = :Q.ProductCode__c limit 1];
        if (PS_Product.size() > 0) {
            If (PS_Product[0].PS_Product_SKU__c != null) { 
             Priced_ProductCode = PS_Product[0].PS_Product_SKU__c;
             }             
             } 
     if (map_PSSKU_price.containsKey(Priced_ProductCode)){
          Double price = map_PSSKU_price.get(Priced_ProductCode);
              System.debug('--> Setting price to: ' + price);
             Q.PeopleSoft_Price_As_Of_Date__c = DateTime.now();
              Q.Current_PeopleSoft_Price__c = price;
              if (Q.UnitsPerBox__c > 0) {
              Q.Current_PeopleSoft_Price_per_Unit__c = price/Q.UnitsPerBox__c; 
              }
             else {
              Q.Current_PeopleSoft_Price_per_Unit__c = price;
              }
              Q.PeopleSoft_Price_Success_Flag__c = true;
              LineItemsToUpdate.add(Q);
              
            } else {
             Q.PeopleSoft_Price_Success_Flag__c = false;
           }
              
           
       }
 //        System.debug('--> validPriceFromWS: ' + list_clsOlis[itemNumber].validPriceFromWS);
      }
   if(LineItemsToUpdate.size() > 0){ 
   try { 
   futureGetPriceHelper.isFromThisClass(true);
   update LineItemsToUpdate;       
   } catch (system.DmlException e) {
   system.debug(e.getDmlMessage(0));
   }
   }
        //calculating extended price and order amount
//        calculateExtendedPrices();
//        calculateFreightAmount();
      } else {
        System.debug('--> WS Output is NULL');
     }
      
    } 
    catch (Exception e){
      //an error occurred during the webservice callout, display error message in debug log
      System.debug('--> ERROR: ' + e.getMessage());
    }
  }              
}