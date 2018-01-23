trigger CPQQuoteAfterInsert on CameleonCPQ__Quote__c (after insert) {
    List<CameleonCPQ__Quote__c> allQuotes = [SELECT  OpportunityId__c, CameleonCPQ__AccountId__c,CameleonCPQ__PrimaryContactId__c FROM CameleonCPQ__Quote__c WHERE Id IN: Trigger.newMap.keySet()];
      for (CameleonCPQ__Quote__c quote : allQuotes) {
    //for (CameleonCPQ__Quote__c quote : trigger.new) {
    // Assign parent opportunity account
     Opportunity[] quoteOpportunities = [SELECT Id,Pricebook2Id, AccountId,Owner.Name,CurrencyIsoCode FROM Opportunity where Id =: quote.OpportunityId__c];
     if (quoteOpportunities.size() > 0) {
     
       if(quoteOpportunities[0].AccountId != null){
                quote.CameleonCPQ__AccountId__c = quoteOpportunities[0].AccountId;
                update quote;
            }
//in the cameleon quote create trigger
        if(quoteOpportunities[0].Pricebook2Id != null)
        {
            //get id for default pricebook for all CPQ opportuniities
            Pricebook2 cpqPb = [SELECT Id FROM Pricebook2 WHERE Name = 'USSUR'];
            Id cpqpbId = cpqPb.Id;
            quoteOpportunities[0].Pricebook2Id = cpqpbId;
        }
     }
    }

}