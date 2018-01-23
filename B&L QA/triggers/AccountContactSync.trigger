trigger AccountContactSync on Contact (after insert, after update) {
    //
    //Check if there is a new Account on Contact
    //
    Map<String,Account_Contact_Junction__c> ACJs = new Map<String,Account_Contact_Junction__c>();
    
    for (Contact c : Trigger.new) {
        if((Trigger.isInsert && c.AccountId <> null) 
           || (Trigger.isUpdate && c.AccountId <> Trigger.oldMap.get(c.Id).AccountId)){
            Account_Contact_Junction__c acj = new Account_Contact_Junction__c(Account__c = c.AccountId, contact__c = c.Id);
            acj.AccountContactIdPairTxt__c = ((String)c.AccountId).substring(0,15) + ((String) c.Id).substring(0,15); 
            ACJs.put(((String)c.AccountId).substring(0,15) + ((String) c.Id).substring(0,15), acj);
        }                       
    }
    System.debug('>>>>>Account Contact Junction List: '+ACJs);
    if (ACJs.isEmpty()) {return;}
    
    //Eliminate existing account-contact relationships from being inserted
    for(Account_Contact_Junction__c acj : [SELECT Account__c,Contact__c,AccountContactIdPairTxt__c 
                                           FROM Account_Contact_Junction__c 
                                           WHERE AccountContactIdPairTxt__c IN :ACJs.keySet()]) {
        ACJs.remove(acj.AccountContactIdPairTxt__c);                  
    }  
    System.debug('>>>>>Account Contact Junction List after dupe removal: '+ACJs);
    
    //Convert Map to List for DML
    List<Account_Contact_Junction__c> insertACJs = new List<Account_Contact_Junction__c>();
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