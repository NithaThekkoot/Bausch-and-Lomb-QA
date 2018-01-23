({
    recordLoadAction: function(component, event, helper) {
       
        var opportunity = component.get('v.fields');
        
        //close the base component
        $A.get("e.force:closeQuickAction").fire();
        
        //call opportunity create
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Opportunity",
            "defaultFieldValues": {
                "AccountId" : opportunity.AccountId,
                "Program_Opp_Type__c" : opportunity.Program_Opp_Type__c
            },
            recordTypeId : $A.get('$Label.c.USSUR_CPQ_Opportunity_Record_Type')
        });
        createRecordEvent.fire();
        
    }
   
})