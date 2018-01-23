/**
* 
*   This trigger retrieves the Account Currency and populates the currency on the case. 
*   This is necessary because the Case is defaulting to the User currency which is not 
*   always correct and this will be misleading for credit. 
*   Please note that, at this time, case currency cannot be updated via a validation rule.
*
*    Author             |Author-Email                   |Date        |Comment
*    -------------------|--------------------------------|-----------|--------------------------------------------------
*    Samantha Cardinali |samantha.cardinali@bausch.com   |25.01.2013 |First draft
*
*
*/
trigger case_BIU_updateCurrency on Case (before Insert, before Update) {

    ID rtEMEAId = ClsUtility.getRecordTypeId('Case','EMEA Service Case');
    Set<ID> set_Accounts = new Set<ID>();
    for(Case oCase : Trigger.new) {
        if(oCase.RecordTypeId == rtEMEAId) {
            set_Accounts.add(oCase.AccountId);
        }
    }
    
    if(set_Accounts.size() > 0) {

        List<Account> list_Accounts = [SELECT Id, CurrencyISOCode FROM Account WHERE ID IN :set_Accounts];
        for(Account oAccount : list_Accounts) {
            for(Case oCase : Trigger.new) {
                If(oCase.RecordtypeId == rtEMEAId) {
                    if(oCase.AccountId == oAccount.Id) {
                        oCase.CurrencyISOCode = oAccount.CurrencyISOCode;
                    }
                }   
            }
        }
    }

}