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
                "Origin" : "Phone",
                "Priority" : 'Severity 2 (24 hour SLA)',
                "Order__c" : msrShipment.MSR_Order__c.value,
                "Domestic_or_International_Order__c" : 'Domestic',
                "Order_Date__c":msrHeader.Order_Date__c.value,
                "Lot_Serial_Number__c":msrShipment.Lot_Serial_ID__c.value,
                "Shipment__c":msrShipment.Shipping_ID__c.value,
                "Product__c":msrShipment.PS_Product_SKU__c.value,
                "Bill_To_ID__c":msrHeader.Inventory_Business_Unit__c.value
            }
        });
        createRecordEvent.fire();
        
    }
   
})