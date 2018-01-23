trigger priceAgreement_BIU_populateSearchInfo on Pricing_Agreement__c (before insert, before update) {

ID prART = ClsUtility.getRecordTypeId('Pricing_Agreement__c','EMEASU Price Agreement');

Set<ID> set_Accounts= new Set<ID>();
Set<ID> set_AgreementsForUpdate = new Set<ID>();
for(Pricing_Agreement__c prAP : Trigger.New) {
    if(prAP.RecordTypeId == prART) {
        set_Accounts.add(prAp.Account__c);
        if(Trigger.isUpdate) {
            Pricing_Agreement__c beforeUpdate = Trigger.oldMap.get(prAp.Id);
            if(beforeUpdate.Account__c <> prAP.Account__c) {
                set_AgreementsForUpdate.add(prAP.ID);
            }
        }
    }
}
System.debug('set_Accounts: ' + set_Accounts);
System.debug('set_AgreementsForUpdate: ' + set_AgreementsForUpdate);

List<Account> list_Accounts = [SELECT Id, Name, Bill_to__c FROM Account WHERE Id IN :set_Accounts LIMIT 999];
List<Price_Agreement_Product__c> list_products = [SELECT Id, Pricing_Agreement__c, Related_Account__c, Search_Information__c FROM Price_Agreement_Product__c WHERE Pricing_Agreement__c IN :set_AgreementsForUpdate LIMIT 999];
System.debug('list_products: ' + list_products);
List<Price_Agreement_Product__c> list_prodsForUpdate = New List<Price_Agreement_Product__c>();

for(Pricing_Agreement__c prAP : Trigger.New) {
    if(prAP.Account__c == null) {
        prAP.Search_Information__c = '';
        for(Price_Agreement_Product__c rPFU : list_products) {
            if(rPFU.Pricing_Agreement__c == prAP.Id) {
                rPFU.Related_Account__c = Null;
                rPFU.Search_Information__c = '';
                list_prodsForUpdate.add(rPFU);
            }
        }    
    } else {
        for(Account relatedAccount : list_Accounts) {
            if(relatedAccount.Id == prAP.Account__c) {
                //Populate account search info
                prAP.Search_Information__c = relatedAccount.Name + ', ' + relatedAccount.Bill_to__c;
                System.debug('relatedAccount.ID: ' + relatedAccount.ID);
                System.debug('prAP.Search_Information__c: ' + prAP.Search_Information__c);
                //Update any related price_agreement_products
                for(Price_Agreement_Product__c rPFU : list_products) {
                    if(rPFU.Pricing_Agreement__c == prAP.Id) {
                        rPFU.Related_Account__c = relatedAccount.Id;
                        rPFU.Search_Information__c = relatedAccount.Name + ', ' + relatedAccount.Bill_to__c;
                        System.debug('rPFU.Related_Account__c: ' + rPFU.Related_Account__c);
                        list_prodsForUpdate.add(rPFU);
                    }
                }
            }
        }
    }
}
Update list_prodsForUpdate;

}