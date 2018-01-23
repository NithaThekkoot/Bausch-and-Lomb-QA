/**
* 
* 	This trigger concatenates the order number field form the Order Header and the Order Line Item field Item__c.
*
*  	Author		     |Author-Email			   	     	|Date		|Comment
*  	-----------------|----------------------------------|-----------|--------------------------------------------------
*  	Dennis Flüchter  |dennis.fluechter@itbconsult.com 	|18.09.2009 |First draft
*
*
*/ 
trigger orderLineItem_BI_setLineItemNumber on Order_Line_Item__c (before insert) {
	
	/* Variables */
	Set<Id> set_orderIds = new Set<Id>(); //holds a set of OrderHeader Ids, to query for according OrderHeaders for all Line Items
	Map<Id, String> map_orderHeaderId_orderName = new Map<Id, String>(); //holds Id and according name for relevant OrderHeaders
	
	//create set to query for according OrderHeader data
	for(Order_Line_Item__c oli : trigger.new){
		if (oli.Order__c != null){
			set_orderIds.add(oli.Order__c);
		}		
	}
	
	//query OrderHeader information for relevant OrderLines
	for(Order_Header__c header : [Select Id, Name from Order_Header__c where Id in : set_orderIds limit 1000]) {
		map_orderHeaderId_orderName.put(header.Id, header.Name);
	}
	
	//add concatenated value for OrderLineItem Number
	for(Order_Line_Item__c oli : trigger.new){
		if(oli.Order__c != null && oli.Item__c != null){
			oli.Order_Line_Number__c = map_orderHeaderId_orderName.get(oli.Order__c) + '-' + oli.Item__c.intValue();
		}		
	}
	
}