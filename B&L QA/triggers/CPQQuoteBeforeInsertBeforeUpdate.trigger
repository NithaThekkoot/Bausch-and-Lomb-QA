trigger CPQQuoteBeforeInsertBeforeUpdate on CameleonCPQ__Quote__c (before insert, before update) 
{
    for (CameleonCPQ__Quote__c quote : Trigger.new)
    {
        System.debug(Logginglevel.INFO, 'Quote Id: ' + quote.Id + '.');
    
        Opportunity opportunity = CPQQuoteMgr.retrieveOpportunityAssociatedWithQuote(quote.OpportunityId__c);
        CPQQuoteMgr.updateAccountIdOnQuote(quote, opportunity);
    }
}