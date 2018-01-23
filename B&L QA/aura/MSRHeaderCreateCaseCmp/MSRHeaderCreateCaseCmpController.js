({
    recordLoadAction: function(component, event, helper) {
       
        var msrHeader = component.get('v.fields');
        
        //close the base component
        $A.get("e.force:closeQuickAction").fire();
        
        //call opportunity create
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Case",
            "defaultFieldValues": {
                "AccountId" : msrHeader.Account__c,
                "Origin" : "Phone",
                "Priority" : 'Severity 2 (24 hour SLA)',
                "Order__c" : msrHeader.Name,
                "Domestic_or_International_Order__c" : 'Domestic',
                "Order_Date__c":msrHeader.Order_Date__c              
            },
            recordTypeId : $A.get('$Label.c.EMEA_Service_Case_Record_Type')
        });
        createRecordEvent.fire();
        
    }
   
})