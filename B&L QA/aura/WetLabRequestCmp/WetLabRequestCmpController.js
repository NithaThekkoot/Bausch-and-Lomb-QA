({
    recordLoadAction: function(component, event, helper) {
       
        var account = component.get('v.fields');
        
        //close the base component
        $A.get("e.force:closeQuickAction").fire();
        
        //call opportunity create
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Opportunity",
            "defaultFieldValues": {
                "Name" : account.Name +"-Wet Lab Request",
                "AccountId" : account.Id,
                "StageName" : "Needs Analysis",
                "Deliver_To_Street__c" : account.ShippingStreet,
                "Deliver_To_Zip__c" : account.ShippingPostalCode,
                "Deliver_To_State__c" : account.ShippingState,
                "Deliver_To_City__c" : account.ShippingCity,
                "Pig_Eye_Delivery_Street__c" : account.ShippingStreet,
                "Pig_Eye_Delivery_Zip__c" : account.ShippingPostalCode,
                "Pig_Eye_Delivery_State__c" : account.ShippingState,
                "Pig_Eye_Delivery_City__c" : account.ShippingCity,
                "Pick_Up_From_Address__c" : account.ShippingStreet,
                "Pick_Up_From_Zip__c" : account.ShippingPostalCode,
                "Pick_Up_From_State__c" : account.ShippingState,
                "Pick_Up_From_City__c" : account.ShippingCity,
                "CloseDate" : new Date()
            },
            recordTypeId : $A.get('$Label.c.USSUR_Wet_Lab_Request_Opportunity_Record_Type')
        });
        createRecordEvent.fire();
        
    }
   
})