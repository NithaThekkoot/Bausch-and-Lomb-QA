/**
* 
*   This trigger concatenates the order number field form the Order Header and the Order Line Item field Item__c.
*
*    Author         |Author-Email                   |Date       |Comment
*    ---------------|-------------------------------|-----------|--------------------------------------------------
*    S Cardinali    |samantha.cardinali@bausch.com  |16.10.2009 |First draft
*
*
*/
trigger shippingHistory_BIU_populateMatchKey on Shipping_History__c (before insert, before update) {
    for (Shipping_History__c oShipHist : Trigger.new) {
      if (oShipHist.Order__c != null && oShipHist.Order_Line_Item__c != null) {
        oShipHist.MatchKey__c = oShipHist.Order__c + '||' + oShipHist.Order_Line_Item__c;
        System.debug('--> oShipHist.MatchKey__c: ' + oShipHist.MatchKey__c);
      } else {
        oShipHist.addError('Order and/or Order_Line_Item references are empty. Failed to populate MatchKey.');
      }
    }
}