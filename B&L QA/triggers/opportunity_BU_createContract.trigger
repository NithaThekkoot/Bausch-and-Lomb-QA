/**
* 
*   This trigger creates a contracts from a closed won tender.
*
*
*  Author                          |Author-Email                                        |Date              |Comment
*  ----------------------------|------------------------------------------------|-----------------|------------------------------------------------------------------
*  Samantha Cardinali | samantha.cardinali@bausch.com | 15/12/2011 | First Draft
*  Samantha Cardinali | samantha.cardinali@bausch.com | 16/05/2013 | Updates for France rework
*
*/

trigger opportunity_BU_createContract on Opportunity (After Update) {

ID rtOpenTenderID = ClsUtility.getRecordTypeId('Opportunity','EMEASU Tender');
ID rtClosedWonID = ClsUtility.getRecordTypeId('Opportunity','EMEASU Closed-Won Tender');
ID rtContract = ClsUtility.getRecordTypeId('Contract','EMEASU Contract');

List<Contract> list_NewContracts = new List<Contract>();

for(Opportunity Opty : Trigger.New) {
    Opportunity beforeUpdate = System.Trigger.oldMap.get(Opty.Id);
    System.debug('Old Opportunity RcType:' + beforeUpdate.RecordTypeId);
    System.debug('New Opportunity RcType:' + Opty.RecordTypeId);
    //if the opp was previously EMEA Tenders and has been updated to EMEA Closed Won... 
    If(beforeUpdate.RecordTypeId == rtOpenTenderID && Opty.RecordTypeId == rtClosedWonID) {

        //create Contract
        Contract newContract = new Contract(RecordTypeId = rtContract,
                                            Name = Opty.Name,
                                            CurrencyISOCode = Opty.CurrencyISOCode,
                                            AccountId = Opty.AccountId,
                                            Existing_B_L_Account__c = Opty.Existing_B_L_Account__c,
                                            Competitor_Account__c = Opty.Competitor_Account__c,
                                            OwnerId = Opty.OwnerId,
                                            Description = Opty.Description,
                                            Opportunity__c = Opty.Id,
                                            Territory__c = Opty.Territory__c,
                                            Contract_Scope__c = Opty.Opportunity_Scope__c,
                                            Contract_Type__c = Opty.Opportunity_Type__c,
                                            No_of_Hand_Pieces__c = Opty.No_of_Hand_Pieces__c,
                                            Type_of_Financing__c = Opty.Type_of_Financing__c,
                                            Procurement_Agency__c = Opty.Procurement_Agency__c,
                                            Procurement_Agency_Name__c = Opty.Procurement_Agency_Name__c,
                                            Volume_Type__c = Opty.Volume_Type__c,
                                            Annual_Volume__c = Opty.Annual_Volume__c,
                                            Anterior_Equipment_Qty__c = Opty.Stellaris_Qty__c,
                                            Posterior_Equipment_Qty__c = Opty.Stellaris_PC_Qty__c,
                                            Amount__c = Opty.Amount,
                                            Stellaris_Unit_Price__c = Opty.Stellaris_Unit_Price__c,
                                            Stellaris_PC_Unit_Price__c = Opty.Stellaris_PC_Unit_Price__c,
                                            Stellaris_Total_Offer_Price__c = Opty.Stellaris_Total_Offer_Price__c,
                                            Stellaris_PC_Total_Offer_Price__c = Opty.Stellaris_PC_Total_Offer_Price__c,                                            
                                            Stellaris_Monthly_Procedure_Qty__c = Opty.Stellaris_Monthly_Procedure_Qty__c,
                                            Stellaris_Procedure_Unit_Price__c = Opty.Stellaris_Procedure_Unit_Price__c,
                                            Stellaris_PC_Monthly_Procedure_Qty__c = Opty.Stellaris_PC_Monthly_Procedure_Qty__c,
                                            Stellaris_PC_Procedure_Unit_Price__c = Opty.Stellaris_PC_Procedure_Unit_Price__c
                                            );
        
        list_NewContracts.add(newContract);
    }    
}

if(list_NewContracts.size() > 0){
    insert list_NewContracts;
}

}