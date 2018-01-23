trigger priceAgreementProduct_BI_populateAcct on Price_Agreement_Product__c (before insert) {

ID prAPRT = ClsUtility.getRecordTypeId('Price_Agreement_Product__c','EMEASU Price Agreement Product');
Set<ID> set_priceAgreeProducts = new Set<ID>();
Set<ID> set_priceAgreements = new Set<ID>();
for(Price_Agreement_Product__c prAP : Trigger.New) {
    if(prAP.RecordTypeId == prAPRT) {
        set_priceAgreeProducts.add(prAP.Id);
        set_priceAgreements.add(prAP.Pricing_Agreement__c);
    }
}

List<Pricing_Agreement__c> list_priceAgreements = [SELECT Id, Account__c, Account__r.Bill_to__c, Account__r.Name FROM Pricing_Agreement__c WHERE Id IN :set_priceAgreements LIMIT 999];

for(Price_Agreement_Product__c prAP : Trigger.New) {
    if(set_priceAgreeProducts.contains(prAP.Id)) {
        for(Pricing_Agreement__c prAgrmts : list_priceAgreements) {
            if(prAgrmts.Id == prAP.Pricing_Agreement__c) {
                prAP.Related_Account__c = prAgrmts.Account__c;
                prAP.Search_Information__c = prAgrmts.Account__r.Name + ', ' + prAgrmts.Account__r.Bill_to__c;
                break;
            }
        }
    }
}

}