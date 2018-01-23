({
	recordLoadAction: function(component, event, helper) {
       
        var account = component.get('v.fields');
        
        //close the base component
        $A.get("e.force:closeQuickAction").fire();
        
        //call opportunity create
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Medical_Inquiry__c",
            "defaultFieldValues": {
                "Inquiry_Type__c" : "Consultant Request",
                "CurrencyIsoCode" : 'USD',
                "Delivery_Method__c" : "Phone"
            },
            recordTypeId : null
        });
        createRecordEvent.fire();
        
    }
   
})