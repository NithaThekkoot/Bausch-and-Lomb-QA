/*
* First Draft : Kuldeep Singh Rathore
* Date:1/11/2013
* Modified By : 
*Test Class :
*
*/
trigger AccountContractSync on Contract (after insert, after update) {
    //
    //Check if there is a new Account on Contact
    //
    Map<String,Account_Contract_Junction__c> ACJs = new Map<String,Account_Contract_Junction__c>();
    
    for (Contract c : Trigger.new) {
        if((Trigger.isInsert && c.AccountId <> null) 
           || (Trigger.isUpdate && c.AccountId <> Trigger.oldMap.get(c.Id).AccountId)){
            Account_Contract_Junction__c acj = new Account_Contract_Junction__c(Account__c = c.AccountId, Contract__c = c.Id);
            acj.AccountContractIdPairTxt__c = ((String)c.AccountId).substring(0,15) + ((String) c.Id).substring(0,15); 
            ACJs.put(((String)c.AccountId).substring(0,15) + ((String) c.Id).substring(0,15), acj);
        }                       
    }
    System.debug('>>>>>Account Contract Junction List: '+ACJs);
    if (ACJs.isEmpty()) {return;}
    
    //Eliminate existing account-contact relationships from being inserted
    for(Account_Contract_Junction__c acj : [SELECT Account__c,Contract__c ,AccountContractIdPairTxt__c 
                                           FROM Account_Contract_Junction__c 
                                           WHERE AccountContractIdPairTxt__c IN :ACJs.keySet()]) {
        ACJs.remove(acj.AccountContractIdPairTxt__c );                  
    }  
    System.debug('>>>>>Account Contract Junction List after dupe removal: '+ACJs);
    
    //Convert Map to List for DML
    List<Account_Contract_Junction__c > insertACJs = new List<Account_Contract_Junction__c >();
    for(String keypair : ACJs.keySet()) {
        insertACJs.add(ACJs.get(keypair));
    }

    //  
    //Insert Account-Contact junction records in batch
    //  
    if (insertACJs.size()>0) {
        try {
            insert insertACJs;
        } catch (Exception e){

        }
    }
}