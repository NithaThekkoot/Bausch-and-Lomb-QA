({
    recordLoadAction: function(component, event, helper) {
        
        var msrShipment = component.get('v.record.fields');
        var msrHeader = msrShipment.MSR_Order__r.value.fields;
        
        //close the base component
        $A.get("e.force:closeQuickAction").fire();
        
        console.log(msrShipment);
        
        //call opportunity create
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Case",
            "defaultFieldValues": {
                "AccountId" : msrHeader.Account__c.value,
				"Order__c" : msrShipment.MSR_Order__c.value,
                "Shipment__c":msrShipment.Shipping_ID__c.value,
                "Bill_To_ID__c":msrHeader.Inventory_Business_Unit__c.value
            }
        });
        createRecordEvent.fire();
        
    }
    
})