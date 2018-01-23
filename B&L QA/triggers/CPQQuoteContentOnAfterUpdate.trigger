/**
 * Processes all tasks required after CPQ sync update.
 */
trigger CPQQuoteContentOnAfterUpdate on CameleonCPQ__QuoteContent__c (after update) {

	for (CameleonCPQ__QuoteContent__c content : [SELECT CameleonCPQ__QuoteId__c FROM CameleonCPQ__QuoteContent__c WHERE Id IN: Trigger.newMap.keySet()]) 
	{
        CPQQuoteMgr.processAfterSyncUpdate(content);
    }
}