/**
* 
*   This trigger calls a Web Service to retrieve prices from PeopleSoft to store on QuoteLineItem__c
*
*    Author         |Author-Email                   |Date          |Comment
*    ---------------|-------------------------------|--------------|--------------------------------------------------
*    Jennie Burns   |jennie.burns@bausch.com        |19-Nov-2014   |Initial release
*
*/
trigger QuoteLineItem_AIU_GetPrice on QuoteLineItem__c (after insert, after update) {

if (!futureGetPriceHelper.returnFromClass()){
      
      list<string> QuoteLineItemIdList = new list<string>();
      
      for (QuoteLineItem__c Q:Trigger.new) {
                if (Q.PeopleSoft_Price_Success_Flag__c != true){
                    QuoteLineItemIdList.add(Q.Id);
                }
            }
            
           futureGetPrice.GetPrice(QuoteLineItemIdList);
    }
    }