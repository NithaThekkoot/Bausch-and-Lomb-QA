/**
* 
*   This trigger retrieves the Order Entered By value from an associated Order and populates the corresponding field on the case. 
*   This is necessary because there is no relationship between Order and Case.
*
*    Author             |Author-Email                   |Date        |Comment
*    -------------------|--------------------------------|-----------|--------------------------------------------------
*    Samantha Cardinali |samantha.cardinali@bausch.com   |04.08.2010 |First draft
*    Dan Wood           |Dan.Wood@Bausch.com             |13.10.2014 | Copied to SU as per GCM 250029 / MyIT Help 00158705
*
*
*/trigger case_BIU_populateOrderEnteredBy on Case (before Insert, before Update) {

    Set<String> set_Order = new Set<String>();
    String sOrderNo = '';
    for(Case oCase : Trigger.new) {
        if(oCase.Order__c <> null) {
            sOrderNo = oCase.Order__c;
            if (sOrderNo.contains('-')) {
                sOrderNo = sOrderNo.replace('-','');
            }
            set_Order.add(sOrderNo);
        }
    }
    
    if(set_Order.size() > 0) {

        List<Order_Header__c> list_Orders = [SELECT Legacy_system_id__c, Order_Entered_By__c FROM Order_Header__c WHERE Legacy_system_id__c IN :set_Order];
        sOrderNo = '';
        for(Order_Header__c oOrder : list_Orders) {
            for(Case oCase : Trigger.new) {
                if(oCase.Order__c <> null) {
                    sOrderNo = oCase.Order__c;
                    if (sOrderNo.contains('-')) {
                        sOrderNo = sOrderNo.replace('-','');
                    }
                    if(sOrderNo == oOrder.Legacy_system_id__c) {
                        oCase.Order_Entered_By__c = oOrder.Order_Entered_By__c;
                    }   
                }
            }
        }
    }

}