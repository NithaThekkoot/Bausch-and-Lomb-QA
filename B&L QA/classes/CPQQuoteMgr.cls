public without sharing class CPQQuoteMgr  {
    /*
    /**
     * Service encapsulating all the logic triggered by the synchronization of the quote content to Salesforce (CPQQuoteContentOnAfterUpdate)
     */   
    public static void processAfterSyncUpdate(CameleonCPQ__QuoteContent__c content) 
    {
        CameleonCPQ__Quote__c quote = retrieveQuote(content);
        
        if (quote.CameleonCPQ__Status__c != 'ApprovalinProcess')
        {
            deletePreviousQuoteLineItems(quote.Id);
    
            // Parsing the quote
            Attachment[] att = [SELECT Id, Name, Body FROM Attachment WHERE parentId =: content.Id AND Name LIKE '%_content']; // Getting Cameleon quote content XML from Attachment (note '_content' suffix)
            system.debug('..attachmentid in cpqmgr...' + att[0].id);
            Blob quoContentXML = att[0].Body; 
            CPQParser quoteParser = new CPQParser(quoContentXML);
            CPQParser.Quote parsedQuote = quoteParser.getQuote();
            List<CPQParser.QuoteLine> allLines = parsedQuote.getallLines();
            
            if (quote.OpportunityId__c != null) 
            {
                handleProductMetaDataChanges(parsedQuote, quote);
                
                Opportunity opportunity = retrieveOpportunityAssociatedWithQuote(quote.OpportunityId__c);
                   
                // If there is no Pricebook, use the standard one 
                if(opportunity.Pricebook2Id == null)
                {
                    Pricebook2 stdpb = [SELECT Id FROM Pricebook2 WHERE Name = 'USSUR'];
                    opportunity.Pricebook2Id = stdpb.Id;
                }
                                    
                List<QuoteLineItem__c> quoteLineItems = getQuoteLineItems(allLines, quote.Id);
                Map<String, CPQBundalisedProductInformation> productInBundles = productInBundles(allLines);
                updateBundalisedQuoteLineItems(quoteLineItems, productInBundles);
                
                insert quoteLineItems; 
                update quote;
                
                if(quote.Primary_Quote__c)
                {
                    deletePreviousOpportunityLineItems(opportunity.Id);
                    insertOpportunityLineItems(opportunity, quoteLineItems, parsedQuote);
                    // quote.Product_MetaData_Changed__c = false; 
                    updateOpportunity(opportunity, quote);           
                } else
                {
                    update opportunity; // Commiting the update to the previous change on the Pricebook2Id field.
                }
            }
        } 
    }
    
    
    /**
     * Retrieves the Cameleon Quote related to the specified Quote Content object.
     * Retrieves all the fields needed to later update the opportunity.
     */
    public static CameleonCPQ__Quote__c retrieveQuote(CameleonCPQ__QuoteContent__c content)
    {
            return [SELECT Id, 
                           OpportunityId__c, 
                           OpportunityId__r.Pricebook2Id, 
                           CameleonCPQ__Status__c,
                           Primary_Quote__c,
                           TotalContractValue1__c, 
                           AnnualExtendedContractValue1__c,
                           CataractAnnualContractValue__c,
                           CataractOverallMarginPercentage__c,
                           CataractOverallMarginwithoutCrystalens__c,
                           CataractTotalContractValue__c,
                           CataractTotalEquipmentPhacoMargin__c,
                           RetinaAnnualContractValue__c,
                           RetinaOverallMarginPercentage__c,
                           RetinaOverallMarginwithoutCrystalens__c,
                           RetinaTotalContractValue__c,
                           RetinaTotalEquipmentPhacoMargin__c,
                           VictusAnnualContractValue__c,
                           VictusOverallMarginPercetnage__c,
                           VictusOverallMarginwithoutCrystalens__c,
                           VictusTotalContractValue__c,
                           VictusTotalEquipmentPhacoMargin__c,
                           OverallMarginPercentage__c,
                           OverallMarginwithoutCrysalens__c,
                           TotalEquipmentMargin__c,
                           AnnualRevenueforDisposables__c,
                           TotalMachineRevenue__c,
                           Type_of_Financing__c,
                           Quote_Contract_Type__c,
                           Contract_Term__c,
                           Product_MetaData_Changed__c,
                           Approval_Level__c
                    FROM CameleonCPQ__Quote__c
                    WHERE Id =: content.CameleonCPQ__QuoteId__c][0];
    }
    
    
    private static void deletePreviousQuoteLineItems(Id quoteLineItemId)
    {
        try{
            delete [SELECT id FROM QuoteLineItem__c WHERE Id__c =: quoteLineItemId];
        }catch(Exception e)
        {
            System.debug('Caught QuoteLineItem deletion exception.');
        }
    }   
    
    
    private static void handleProductMetaDataChanges(CPQParser.Quote parsedQuote, CameleonCPQ__Quote__c quote)
    {
        if (quote.Product_MetaData_Changed__c)
        {
            //String productMetaDataChanged = parsedQuote.getField('Product_MetaData_Changed');
            //if (productMetaDataChanged != null)
            {
                //if (!productMetaDataChanged.equals(''))
                {
                    quote.Product_MetaData_Changed__c = false;
                }
            }   
        }
    }
    
    /*
     * Retrieves the opportunity and all the fields that needs to be updated with the new primary quote fields.
     */
    public static Opportunity retrieveOpportunityAssociatedWithQuote(Id opportunityId)
    {
        return [SELECT Id, 
                       Pricebook2Id, 
                       CurrencyIsoCode, 
                       Amount, 
                       AccountId,
                       AnnualContractValue__c,
                       CataractAnnualContractValue__c,
                       CataractOverallMargin__c,
                       CataractOverallMarginWithoutCrystalens__c,
                       CataractTotalContractValue__c,
                       CataractTotalEquipmentMargin__c,
                       RetinaAnnualContractValue__c,
                       RetinaOverallMargin__c,
                       RetinaOverallMarginWithoutCrystalens__c,
                       RetinaTotalContractValue__c,
                       RetinaTotalEquipmentMargin__c,
                       VictusAnnualContractValue__c,
                       VictusOverallMargin__c,
                       VictusOverallMarginwithoutCrystalens__c,
                       VictusTotalContractValue__c,
                       VictusTotalEquipmentMargin__c,
                       OverallMargin__c,
                       OverallMarginWithoutCrystalens__c,
                       TotalEquipmentMargin__c,
                       Total_Contract_Value__c,
                       DisposablesAnnualRevenue__c,
                       EquipmentTotalRevenue__c,
                       Type_of_Financing__c,
                       QuoteType__c,
                       Contract_Term__c,
                       Cameleon_Quote_Id__c,
                       Approval_Level__c
                FROM Opportunity 
                WHERE Id =: opportunityId][0];
    }


    /*
     * Uses the parser's result
     */
    private static List<QuoteLineItem__c> getQuoteLineItems(List<CPQParser.QuoteLine> allLines, Id quoteId)
    {
        List<QuoteLineItem__c> quoteLineItems = new List<QuoteLineItem__c>();
        for (CPQParser.QuoteLine Line : allLines) 
        { 
            Map<String,String> m = Line.getColumns();
            if(Line.getLineType().equals('CT7'))
            {                         
                QuoteLineItem__c quoteLineItem = getQuoteLineItem(m, quoteId);
                quoteLineItems.add(quoteLineItem); 
            }
        }
        return quoteLineItems;
    }
    
    /* 
     * Parses all lines in cart XML to build a map keeping track of each bundle a product appears in.
     * 
     * @return a map <productCode - CPQBundalisedProductInformation object>
     */
    private static Map<String, CPQBundalisedProductInformation> productInBundles(List<CPQParser.QuoteLine> allLines)
    {
        Map<String, CPQBundalisedProductInformation> productInBundles = new Map<String, CPQBundalisedProductInformation>();
        for (CPQParser.QuoteLine line : allLines) // Iterating on all cart XML lines.
        { 
            Map<String,String> m = Line.getColumns();
            if(line.getLineType().equals('CP7') && line.hasSublines()) // Making sure we're at the bundle's parent line.
            {
                String bundleId = m.get('SynchforBundleID');
                String bundleDescription = m.get('SynchforBundleDesc');
                List<CPQParser.QuoteLine> sublines = line.getSublines();
                
                for (CPQParser.QuoteLine subline : sublines)
                {
                    String sublineProductCode = (String) subline.getColumns().get('SynchforBundleID');
                    CPQBundalisedProductInformation bundalisedProductInformation = productInBundles.get(sublineProductCode);
                    
                    if (bundalisedProductInformation == null) // First time this product appears in a bundle.
                    {
                        bundalisedProductInformation = new CPQBundalisedProductInformation(bundleId, bundleDescription);
                        productInBundles.put(sublineProductCode, bundalisedProductInformation);
                    } else // Product is already in at least one bundle.
                    {
                        bundalisedProductInformation.addBundleId(bundleId);
                        bundalisedProductInformation.addBundleDescription(bundleDescription);
                    }
                }
            }
        }
        return productInBundles;
    }
    
    /*
     * Updates Bundle_Id__c and BundleDescr__c fields of quote line items appearing in bundles. 
     * Mapping between quote line items and bundles sublines made through ProductCode__c field.
     *
     * @param: quoteLineItems: list of quote line items related to CT7 products
     * @param: productInBundles: map <productCode - CPQBundalisedProductInformation object>
     */
    private static void updateBundalisedQuoteLineItems(List<QuoteLineItem__c> quoteLineItems, Map<String, CPQBundalisedProductInformation> productInBundles)
    {
        for (String productCode : productInBundles.keyset())
        {
            for (QuoteLineItem__c quoteLineItem : quoteLineItems)
            {
                if (quoteLineItem.ProductCode__c == productCode)
                {
                    CPQBundalisedProductInformation bundalisedProductInformation = productInBundles.get(productCode);
                    quoteLineItem.Bundle_Id__c = bundalisedProductInformation.getBundleIds();
                    quoteLineItem.BundleDescr__c = bundalisedProductInformation.getBundleDescriptions();
                }
            }
        }
    }
    
    public static Integer parserFamiliarisation(List<CPQParser.QuoteLine> allLines)
    {
        Integer nbCP7lines = 0;
        for (CPQParser.QuoteLine Line : allLines) 
        { 
            Map<String,String> m = Line.getColumns();
            if(Line.getLineType().equals('CP7'))
            {
                nbCP7lines++;                         
            }
        }
        return nbCP7lines;
    }
    
    /*
     * Doesn't use the parser's result
     */
    public static List<QuoteLineItem__c> getQuoteLineItems(Id newQuoteId)
    {
        List<QuoteLineItem__c> quoteLineItems = [SELECT Id, 
                                                        Name,
                                                        Bundle_Id__c,
                                                        BundleDescr__c, 
                                                        Quantity__c, 
                                                        ContractedPrice__c, 
                                                        ContractTerm__c, 
                                                        Discount__c, 
                                                        ProductCode__c,
                                                        Product_Description__c,
                                                        ProductType__c,
                                                        TotalPrice__c,
                                                        Total_Cost__c,
                                                        UOM__c,
                                                        UnitsPerBox__c,
                                                        Non_Discounted_Floor_Price__c,
                                                        ProductFamily__c,
                                                        Id__c 
                                                  FROM QuoteLineItem__c WHERE Id__c =: newQuoteId];
        return quoteLineItems;
    }
    
    
    private static QuoteLineItem__c getQuoteLineItem(Map<String,String> m, Id quoteId) 
    {
        QuoteLineItem__c quoteLineItem = new QuoteLineItem__c();
        quoteLineItem.Id__c = quoteId;
        quoteLineItem.Bundle_Id__c = m.get('BundleName');
        quoteLineItem.ContractedPrice__c = Decimal.valueof(m.get('UnitProposedContractedPrice'));
        quoteLineItem.ContractTerm__c = 12 * Decimal.valueof(m.get('ContractTerminYrs')); // Contract terms expressed in years in the cart. Converting them to months.
        quoteLineItem.Discount__c = Decimal.valueof(m.get('Discount'));
        quoteLineItem.ProductCode__c = m.get('ProductName');
        //quoteLineItem.ProductCode__c = m.get('myLineItemID');
        quoteLineItem.Product_Description__c = m.get('ProductDescription');
        quoteLineItem.ProductType__c = m.get('ProductType');
        quoteLineItem.Quantity__c = Decimal.valueof(m.get('QtyVolume'));
        quoteLineItem.Total_cost__c = Decimal.valueof(m.get('TotalCost'));
        quoteLineItem.TotalPrice__c = Decimal.valueof(m.get('TotalNetPrice'));
        quoteLineItem.UOM__c = m.get('UnitofMeasure');
        quoteLineItem.UnitsPerBox__c = Decimal.valueof(m.get('UnitsofSell'));
        quoteLineItem.Line_Approval__c = m.get('LineApproval');
        quoteLineItem.Non_Discounted_Floor_Price__c = Decimal.valueof(m.get('UnitNonDiscountedFloorPrice'));
        quoteLineItem.ProductFamily__c = m.get('ProductFamily');
        
        return quoteLineItem;
    }
    
    
    public static void deletePreviousOpportunityLineItems(Id opportunityId)
    {
        try
        {
            delete [SELECT Id FROM OpportunityLineItem WHERE OpportunityId =: opportunityId];
        } catch(Exception e)
        {
            System.debug('Caught opportunity line deletion exception.');
        }
    }
    
    
    public static List<OpportunityLineItem> createOpportunityLineItems(Id opportunityId, List<QuoteLineItem__c> quoteLineItems, Map <String, PricebookEntry> pricebookEntries)
    {
        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
        
        for (QuoteLineItem__c quoteLineItem : quoteLineItems)
        {
            OpportunityLineItem opportunityLineItem = new OpportunityLineItem();
            opportunityLineItem.OpportunityId = opportunityId;
            opportunityLineItem.Quantity = quoteLineItem.Quantity__c;
            opportunityLineItem.ContractedPrice__c = quoteLineItem.ContractedPrice__c;
            opportunityLineItem.ContractTerm__c = quoteLineItem.ContractTerm__c;
            if (quoteLineItem.Discount__c < 0)
            {        
                opportunityLineItem.Discount = 0;   
            } else
            {
                    opportunityLineItem.Discount = quoteLineItem.Discount__c;
            }
            opportunityLineItem.ProductCode__c = quoteLineItem.ProductCode__c;
            opportunityLineItem.Description = quoteLineItem.Product_Description__c;
            opportunityLineItem.ProductType__c = quoteLineItem.ProductType__c;
            opportunityLineItem.TotalPrice = quoteLineItem.TotalPrice__c;
            opportunityLineItem.Total_Cost__c = quoteLineItem.Total_cost__c;
            opportunityLineItem.Non_Discounted_Floor_Price__c = quoteLineItem.Non_Discounted_Floor_Price__c;
            opportunityLineItem.ProductFamily__c = quoteLineItem.ProductFamily__c;
            // opportunityLineItem.UOM__c = quoteLineItem.UOM__c;
            // opportunityLineItem.UnitsPerBox__c = quoteLineItem.UnitsPerBox__c;
            opportunityLineItem.Bundle_Id__c = quoteLineItem.Bundle_Id__c;
            opportunityLineItem.BundleDescr__c = quoteLineItem.BundleDescr__c;
            opportunityLineItem.CameleonQuote__c = quoteLineItem.Id__c; 
            opportunityLineItem.CameleonQuoteLineItem__c = quoteLineItem.Id;
            opportunityLineItem.PricebookEntryId = pricebookEntries.get(quoteLineItem.ProductCode__c).Id;
              
            opportunityLineItems.add(opportunityLineItem);
         }
         return opportunityLineItems;
    }


    private static void insertOpportunityLineItems(Opportunity opportunity, List<QuoteLineItem__c> quoteLineItems, CPQParser.Quote parsedQuote)
    {
        Map<String, PricebookEntry> pricebookEntries = CPQQuoteMgr.getPricebookEntries(opportunity.Id, quoteLineItems); // TODO: decouple from CPQPrimaryQuoteUpdateTriggerHandler
        List<OpportunityLineItem> opportunityLineItems = createOpportunityLineItems(opportunity.Id, quoteLineItems, pricebookEntries);
       
        insert opportunityLineItems;
    }
    
    
    /*
     * Used by CPQQuoteContentAfterUpdate trigger.
     */
    private  static void updateApprovalLevel(CPQParser.Quote parsedQuote, Opportunity opportunity)
    {
        String quoStatus1 = parsedQuote.getField('ChangeAndControlTab.CurrentStatus');
        String recordType = parsedQuote.getField('CartInfoTab.Approval_Level');
              
        if(quoStatus1 == 'SubmittedforApproval')
        {
            // opportunity.Approval_Status__c = 'Submitted';
            opportunity.Approval_Level__c = Double.valueOf(recordType);
            update opportunity;
        }
    }

    
    /*
     * Used by CPQQuoteAfterInsertAfterUpdate trigger.
     */
    public static void updateApprovalLevel(CameleonCPQ__Quote__c quote, Opportunity opportunity)
    {
        String quoStatus1 = quote.CameleonCPQ__Status__c;
        Decimal recordType = quote.Approval_Level__c;
              
        if(quoStatus1 == 'SubmittedforApproval')
        {
            // opportunity.Approval_Status__c = 'Submitted';
            opportunity.Approval_Level__c = recordType;
            update opportunity;
        }
    }
    
    
    /**
     * @return pricebookEntriesMap: a map where the key is the ProductCode and the value is the PricebookEntry associated with it
     */
    public static Map<String, PricebookEntry> getPricebookEntries(Id opportunityId, List<QuoteLineItem__c> quoteLineItems)
    {
        // Retrieving the fields needed to retrieve the pricebooks entries
        Opportunity opportunity = [SELECT Id, Pricebook2Id, CurrencyIsoCode FROM Opportunity WHERE Id =: opportunityId][0];
        
        // Retrieveing the product codes
        Set<String> productCodes = new Set<String>();
        for (QuoteLineItem__c quoteLineItem : quoteLineItems)
        {
            system.debug('Single Product code is ' +quoteLineItem.ProductCode__c);
            productCodes.add(quoteLineItem.ProductCode__c); 
        }
        
        // Retrieving the pricebook entries
        List<PricebookEntry> pricebookEntries;
        system.debug('Product code is ' +productCodes);
        
        
        if (opportunity.Pricebook2Id != null) // If a pricebook is associated to the opportunity, we retrieve it
        {
            pricebookEntries = [SELECT Id, Product2.ProductCode FROM PricebookEntry
                                WHERE Pricebook2.Id =: opportunity.Pricebook2Id 
                                AND CurrencyIsoCode =: opportunity.CurrencyIsoCode
                                AND Product2.ProductCode IN: productCodes];
        } else // If no pricebook is associated to the opportunity, we get the pricebook entries from the default pricebook (USSUR)
        {
            Pricebook2 pricebook = [SELECT Id FROM Pricebook2 WHERE Name =: 'USSUR'];
            pricebookEntries = [SELECT Id, Product2.ProductCode FROM PricebookEntry
                                WHERE Pricebook2.Id =: pricebook.Id 
                                AND CurrencyIsoCode =: opportunity.CurrencyIsoCode];
        }
        
        Map<String, PricebookEntry> pricebookEntriesMap = new Map<String, PricebookEntry>();
        for (PricebookEntry pricebookEntry : pricebookEntries)
        {
            pricebookEntriesMap.put(pricebookEntry.Product2.ProductCode, pricebookEntry);
        }
        
        return pricebookEntriesMap;
    }
    
    
    public static void updateOpportunity(Opportunity opportunity, CameleonCPQ__Quote__c quote)
    {
        opportunity.Amount = quote.TotalContractValue1__c;
        opportunity.AnnualContractValue__c = quote.AnnualExtendedContractValue1__c;
        opportunity.CataractAnnualContractValue__c = quote.CataractAnnualContractValue__c;
        opportunity.CataractOverallMargin__c = quote.CataractOverallMarginPercentage__c; 
        opportunity.CataractOverallMarginWithoutCrystalens__c = quote.CataractOverallMarginwithoutCrystalens__c;
        opportunity.CataractTotalContractValue__c = quote.CataractTotalContractValue__c;
        opportunity.CataractTotalEquipmentMargin__c = quote.CataractTotalEquipmentPhacoMargin__c;
        opportunity.RetinaAnnualContractValue__c = quote.RetinaAnnualContractValue__c;
        opportunity.RetinaOverallMargin__c = quote.RetinaOverallMarginPercentage__c;
        opportunity.RetinaOverallMarginWithoutCrystalens__c = quote.RetinaOverallMarginwithoutCrystalens__c;
        opportunity.RetinaTotalContractValue__c = quote.RetinaTotalContractValue__c;
        opportunity.RetinaTotalEquipmentMargin__c = quote.RetinaTotalEquipmentPhacoMargin__c;
        opportunity.VictusAnnualContractValue__c = quote.VictusAnnualContractValue__c;
        opportunity.VictusOverallMargin__c = quote.VictusOverallMarginPercetnage__c;
        opportunity.VictusOverallMarginwithoutCrystalens__c = quote.VictusOverallMarginwithoutCrystalens__c;
        opportunity.VictusTotalContractValue__c = quote.VictusTotalContractValue__c;
        opportunity.VictusTotalEquipmentMargin__c = quote.VictusTotalEquipmentPhacoMargin__c;
        opportunity.OverallMargin__c = quote.OverallMarginPercentage__c;
        opportunity.OverallMarginWithoutCrystalens__c = quote.OverallMarginwithoutCrysalens__c;
        opportunity.TotalEquipmentMargin__c = quote.TotalEquipmentMargin__c;
        opportunity.DisposablesAnnualRevenue__c = quote.AnnualRevenueforDisposables__c;
        opportunity.EquipmentTotalRevenue__c = quote.TotalMachineRevenue__c;
        opportunity.Approval_Level__c = quote.Approval_Level__c;
        opportunity.Cameleon_Quote_Id__c=quote.Id;
        opportunity.Total_Contract_Value__c = quote.TotalContractValue1__c;
        opportunity.Type_of_Financing__c = quote.Type_of_Financing__c;
        opportunity.QuoteType__c = quote.quote_contract_type__c;
        if (quote.Type_of_Financing__c == 'Cash')
        {
            opportunity.Contract_Term__c = '1';
        } else
        {
            opportunity.Contract_Term__c = quote.Contract_Term__c;
        }
        
        
        update opportunity;
    }
    
    
    /**
     *  Unchecks previous primary quote if it exists, does nothing otherwise
     *  
     *  @param newQuoteid: Id of the quote to be marked primary; used to exclude from SELECT results
     *  @param opportunityId
     */
    public static void uncheckPreviousPrimaryQuote(Id newQuoteId, Id opportunityId)
    {
        CameleonCPQ__Quote__c previousPrimaryQuote = CPQQuoteMgr.retrievePreviousPrimaryQuote(newQuoteId, opportunityId);
            
        if(previousPrimaryQuote != null) // Case where another quote was marked as primary
        {
            previousPrimaryQuote.Primary_Quote__c = false;
            update previousPrimaryQuote;
            System.debug(Logginglevel.INFO, 'Quote ' + previousPrimaryQuote.Id + ' unmarked primary.'); 
        }
    }
    
    
    /**
     *  @param newQuoteid: Id of the quote to be marked primary; used to exclude from SELECT results
     *  @param opportunityId
     *  @return previous primary quote, or null if none
     */
    private static CameleonCPQ__Quote__c retrievePreviousPrimaryQuote(Id newQuoteId, Id opportunityId)
    {
        CameleonCPQ__Quote__c[] primaryQuotes = [SELECT Id FROM CameleonCPQ__Quote__c 
                                                 WHERE Primary_Quote__c = true 
                                                 AND Id !=: newQuoteId // Making sure that we're not including the quote we just checked
                                                 AND OpportunityId__c =: opportunityId];
        CameleonCPQ__Quote__c primaryQuote;
        if (primaryQuotes.size() > 0)
        {
            primaryQuote = primaryQuotes[0];
        }                                   
        return primaryQuote;             
    }
    
    
    public static void insertOpportunityLineItems(List<OpportunityLineItem> opportunityLineItems)
    {
        try 
        {
            insert opportunityLineItems;
            System.debug(Logginglevel.INFO, 'Number of opportunity line items inserted: ' + opportunityLineItems.size() + '.');
        } catch (Exception e)
        {
            System.debug('Caught OpportunityLineItem insertion exception.');
        }
    }
    
    public static void updateAccountIdOnQuote(CameleonCPQ__Quote__c quote, Opportunity opportunity)
    {
        if (opportunity.AccountId != null)
        {
            quote.CameleonCPQ__AccountId__c = opportunity.AccountId;
        }
    }

}