/**
 * @author: Amjad El Kashef
 */
trigger CPQQuoteAfterInsertAfterUpdate on CameleonCPQ__Quote__c (after insert, after update) {

    for (Id id : Trigger.newMap.keySet())
    {
        CameleonCPQ__Quote__c newQuote = Trigger.newMap.get(id);
        System.debug(Logginglevel.INFO, 'Quote Id: ' + newQuote.Id + '.');
        
        if (newQuote.OpportunityId__c != null)
        {
            Opportunity opportunity = CPQQuoteMgr.retrieveOpportunityAssociatedWithQuote(newQuote.OpportunityId__c);
            
            if (newQuote.Primary_Quote__c)
            {
                if (Trigger.oldMap !=  null) // instructions specific to update case
                {
                    CameleonCPQ__Quote__c oldQuote = Trigger.oldMap.get(id);
                    CPQQuoteMgr.uncheckPreviousPrimaryQuote(newQuote.Id, newQuote.OpportunityId__c); 
                }
                
                CPQQuoteMgr.deletePreviousOpportunityLineItems(newQuote.OpportunityId__c);
                List<QuoteLineItem__c> quoteLineItems = CPQQuoteMgr.getQuoteLineItems(newQuote.Id);
                Map<String, PricebookEntry> pricebookEntries = CPQQuoteMgr.getPricebookEntries(newQuote.OpportunityId__c, quoteLineItems);
                List<OpportunityLineItem> opportunityLineItems = CPQQuoteMgr.createOpportunityLineItems(newQuote.OpportunityId__c, quoteLineItems, pricebookEntries);
                CPQQuoteMgr.insertOpportunityLineItems(opportunityLineItems);
                CPQQuoteMgr.updateApprovalLevel(newQuote, opportunity);
                CPQQuoteMgr.updateOpportunity(opportunity, newQuote);
            }
        }
    }
    
}