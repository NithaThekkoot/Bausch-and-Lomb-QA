({
    recordLoadAction: function(component, event, helper) {
       
        var account = component.get('v.fields');
        
        //close the base component
        $A.get("e.force:closeQuickAction").fire();
        
        //call opportunity create
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Contact",
            "defaultFieldValues": {
                "AccountId" : account.Id
            }
        });
        createRecordEvent.fire();
        
    }
   
})