/**
* 
*   When a new sample request is created or edited, and the submit tickbox is checked, don't allow the submit untill at least one product is associated
*
*    Author         |Author-Email                   |Date       |Comment
*    ---------------|-------------------------------|-----------|--------------------------------------------------
*    S Cardinali    |samantha.cardinali@bausch.com  |03.08.2010 |First draft
*
*/trigger sampleRequest_BIU_validateSubmit on Sample_Request__c (before Insert, before Update) {

    RecordType rtEMEA = [SELECT Id From RecordType WHERE Name = 'EMEA SU Sample Request' Limit 1];

    //if this is a new sample request, the submit checkbox should never be ticked
    if(Trigger.IsInsert) {
        for(Sample_Request__c oSR : Trigger.New) {
            if(oSR.RecordTypeId == rtEMEA.Id && oSR.Submit_for_Approval__c == True) {
                oSR.Submit_for_Approval__c = False;
                oSR.addError('You cannot submit a sample request to Customer Services without defining any products!');
            }
        }
    } else {  //this is an update, need to check for associated products
            
        //bulid set of sample requests that are for EMEA SU and have the submit checked
        List<Sample_Request__c> list_sampleRequests = new List<Sample_Request__c>();
        for(Sample_Request__c oSR : Trigger.New) {
            if(oSR.RecordTypeId == rtEMEA.Id && oSR.Submit_for_Approval__c == True) {
                list_sampleRequests.add(oSR);
            }
        }

        //only execute for EMEA SU sample requests that have the submit checked
        if(list_sampleRequests.size() > 0) {
        
            //retrieve all products associated with these sample requests
            List<Sample_Product__c> list_products = new List<Sample_Product__c>();
            list_products = [SELECT Id, Sample_Request__c From Sample_Product__c Where Sample_Request__c IN :list_sampleRequests Limit 999];

            //map sample requests with true or false, depending on whether products were found
            Map<ID, Boolean> map_SRhasSP = new Map<ID, Boolean>();
            for(Sample_Request__c oSR : list_sampleRequests) {
                //for each sample request, loop through the returned product records
                for(Sample_Product__c oSP : list_products) {
                    //if any of the products are associated with this sample request, and if this request has not already been added to the map, then add it now
                    if(oSP.Sample_Request__c == oSR.ID) {
                        if(!map_SRhasSP.containsKey(oSR.ID)) {
                            map_SRhasSP.put(oSR.ID, True);
                        }
                    }
                }
                //if no products were associated with this sample request, then map false
                if(!map_SRhasSP.containsKey(oSR.ID)) {
                    map_SRhasSP.put(oSR.ID, False);
                }
            }

            //if a request has no products, then display an error
            for(Sample_Request__c oSR : Trigger.New) {
                if(map_SRhasSP.containsKey(oSR.ID)) {
                    if(map_SRhasSP.get(oSR.ID) == False && oSR.Submit_for_Approval__c == True) {
                      oSR.Submit_for_Approval__c = False;
                      oSR.addError('You cannot submit a sample request to Customer Services without defining any products!');
                    }
                }
            }

        }
    }
}