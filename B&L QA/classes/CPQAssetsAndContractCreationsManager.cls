/**
 * Manager class for CPQAssetsAndContractCreations trigger. Contains all services.
 * 
 * @author: Amjad El Kashef
 * 
 */
 public without sharing class CPQAssetsAndContractCreationsManager 
{
   
    public static Set<Id> getRecordTypesIds(Set<String> developerNames)
    {
        List<RecordType> recordTypes = [SELECT Id FROM RecordType 
                                        WHERE DeveloperName IN: developerNames 
                                        AND SobjectType = 'Opportunity'];
        Set<Id> recordTypesIds = new Set<Id>();
        for (RecordType recordType : recordTypes)
        {
            recordTypesIds.add(recordType.Id);
        }
        return recordTypesIds;      
    }
    
    public static List<OpportunityLineItem> getOpportunityLineItems(Id opportunityId)
    {
        return [SELECT PricebookEntry.Product2Id,
                        PricebookEntry.ProductCode,
                        ProductCode__c, 
                        Description, 
                        UnitPrice,
                        Quantity,
                        ProductType__c,
                        ContractedPrice__c,
                        ProductFamily__c,
                        Bundle_Id__c,
                        BundleDescr__c,
                        PricebookEntry.Name,
                        Non_Discounted_Floor_Price__c,
                        CameleonQuoteLineItem__c,
                        ContractTerm__c 
                FROM OpportunityLineItem 
                WHERE OpportunityId =: opportunityId];
    }
    
    public static Contract createContract(Opportunity opportunity)
    {
        return new Contract(
                            AccountId = opportunity.AccountId,
                            StartDate = opportunity.ContractEffectiveDate__c,
                            ContractTerm = Integer.ValueOf(opportunity.Contract_Term__c),
                            Opportunity__c = opportunity.Id,
                            Type_of_Financing__c = opportunity.Type_of_Financing__c, 
                            Total_Contract_Value__c = Integer.ValueOf(opportunity.Total_Contract_Value__c)                       
                            );
    }
    
    public static List<Asset> createAssets(Opportunity opportunity, List<OpportunityLineItem> opportunityLineItems, Contract contract)
    {
        List<Asset> assets = new List<Asset>();
        for (OpportunityLineItem opportunityLineItem : opportunityLineItems)
        {
            Asset asset = createAsset(opportunity, opportunityLineItem , contract);
            assets.add(asset);   
        }
        return assets;
    }
    
    private static Asset createAsset(Opportunity opportunity, OpportunityLineItem opportunityLineItem, Contract contract) 
    {
        Asset asset = new Asset();
            
        asset.CurrencyIsoCode = opportunity.CurrencyIsoCode;  
        asset.Name = opportunityLineItem.PricebookEntry.Name;
        asset.AccountId = opportunity.AccountId;
        asset.Description = opportunityLineItem.Description;
        asset.Quantity = opportunityLineItem.Quantity;            
        asset.Product2Id = opportunityLineItem.PricebookEntry.Product2Id;            
        asset.ContractTerm__c = opportunityLineItem.ContractTerm__c;
        asset.StartDate__c = opportunity.ContractEffectiveDate__c;
        asset.ContractedPrice__c = opportunityLineItem.ContractedPrice__c;
        asset.Active__c = true;
        asset.Related_to_Contract__c = contract.Id;
        asset.Status = 'Purchased';
        asset.ProductFamily__c = opportunityLineItem.ProductFamily__c;
        asset.ProductType__c = opportunityLineItem.ProductType__c;
        asset.Price = opportunityLineItem.ContractedPrice__c;
        asset.BundleId__c = opportunityLineItem.Bundle_Id__c;
        asset.Non_Discounted_Floor_Price__c = opportunityLineItem.Non_Discounted_Floor_Price__c;
        asset.BundleDescr__c = opportunityLineItem.BundleDescr__c;
        asset.Opportunity_Product_ID__c = opportunityLineItem.CameleonQuoteLineItem__c;
        
        return asset;
    }
   
}