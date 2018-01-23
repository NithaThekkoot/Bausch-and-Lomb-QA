/**
 * Creates Salesforce assets and contract from related CPQ Quote when Opportunity is 'Closed Won'.
 * 
 * @author: Amjad El Kashef
 * 
 */
trigger CPQAssetsAndContractCreations on Opportunity (after update) 
{
    System.debug(LoggingLevel.DEBUG,'*** Salesforce assets and contract creations -- Context Starts -- SOQL Queries : '  + Limits.getQueries()  + '/' + + Limits.getLimitQueries());
               
    for (Integer i = 0; i < Trigger.new.size(); i++)    
    {
        Opportunity opportunity = Trigger.new[i];
        
        // Retrieving the record types ids
        Set<String> developerNames = new Set<String>();
        developerNames.add('USSUR_STM');
        developerNames.add('USSUR_CPQ');        
        Set<Id> recordTypesIds = CPQAssetsAndContractCreationsManager.getRecordTypesIds(developerNames);
        
        if (opportunity.StageName != Trigger.old[i].StageName 
            && opportunity.StageName == 'CLOSED WON' 
            && opportunity.AccountId != null 
            && recordTypesIds.contains(opportunity.RecordTypeId)) 
        {
            List<OpportunityLineItem> opportunityLineItems = CPQAssetsAndContractCreationsManager.getOpportunityLineItems(opportunity.Id);
            Contract contract = CPQAssetsAndContractCreationsManager.createContract(opportunity);
            upsert contract;
            
            List<Asset> assets = CPQAssetsAndContractCreationsManager.createAssets(opportunity, opportunityLineItems, contract);
            upsert assets;
        }
    }
    
    System.debug(LoggingLevel.DEBUG,'*** Salesforce assets and contract creations -- Context Starts -- SOQL Queries : '  + Limits.getQueries()  + '/' + + Limits.getLimitQueries());
}