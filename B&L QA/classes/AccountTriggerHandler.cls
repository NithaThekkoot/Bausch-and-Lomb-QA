// Author : Nidheesh
// Description : helper class for account trigger handler.
// Date :22-12-2017
public with sharing class AccountTriggerHandler {
    
    // Add Default Opportunity for an account for recordtype 'USSUR CPQ'
    
    public static void addRelatedOpp(List<Account> listAccount){
        List<Opportunity> oppList = new List<Opportunity>();

     

        // Get the related opportunities for the accounts in this trigger

        Map<Id,Account> acctsWithOpps = new Map<Id,Account>(

        [SELECT Id,(SELECT Id FROM Opportunities) FROM Account WHERE Id IN :listAccount]);

     

        // Add an opportunity for each account if it doesn't already have one.

        // Iterate through each account.
	    Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('USSUR CPQ').getRecordTypeId();
        
        for(Account a : listAccount) {

            System.debug('acctsWithOpps.get(a.Id).Opportunities.size()=' + acctsWithOpps.get(a.Id).Opportunities.size());
    
            // Check if the account already has a related opportunity.
    
            if (acctsWithOpps.get(a.Id).Opportunities.size() == 0) {
    
                // If it doesn't, add a default opportunity
    
                oppList.add(new Opportunity(Name=a.Name + ' Opportunity',
    
                                           StageName='Prospecting',
    
                                           CloseDate = System.today().addMonths(1),
    
                                           AccountId=a.Id,
                                           RecordTypeId = opportunityRecordTypeId
                                           ));
    
            }          
    
        }

 
	
        if (!oppList.isEmpty()) {

            try{
                insert oppList;
            }
            catch(Exception e){
                system.debug('ERROR OCCURRED WHILE INSERTING THE OPPORTUNITIES - '+e);
            }
        

        }

    }
}