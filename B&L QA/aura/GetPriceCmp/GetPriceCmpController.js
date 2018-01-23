({
    recordLoadAction: function(component, event, helper) {
       
        var account = component.get('v.fields');
       
        //check for the essential fields
        if(account.PS_PRODUCT_SKU__c==null || account.Business_Unit__c==null || 
           account.Ship_To_Id__c==null || account.Bill_To__c==null){
            
            //show the price returned
            var alertBoxParams = {
                message: 'Must have a PS Product SKU to get a Price - click edit to select Product',
                heading: 'Cannot Fetch Price',
                class: 'slds-theme--info',
                callableFunction: component.getReference("c.closeAlert"),
                buttonHeading: 'Close Alert',
                onlyMessage: false
            };
            
            helper.showAlert(component, event, alertBoxParams);
            
        }
        
        //if fields are not empty or null
        else{
            
            //show the spinner
            component.set('v.showSpinner', true);
            var priceCheckAction = component.get('c.requestPrices');
            priceCheckAction.setParams({
                iBusiness_unit: component.get('v.fields.Business_Unit__c'),
                iProduct: component.get('v.fields.PS_PRODUCT_SKU__c'),
                iShip_To_ID: component.get('v.fields.Ship_To_Id__c'),
                iBill_to_id: component.get('v.fields.Bill_To__c'),
                oReturn_Price: 0
            });
            priceCheckAction.setCallback(this, function(response) {
                
                if (response.getState() == 'SUCCESS') {
                    
                    //hide the spinner
                    component.set('v.showSpinner',false);
                    
                    //show the price returned
                    var alertBoxParams = {
                        message: 'Price returned is  : ' + response.getReturnValue(),
                        heading: 'Price Fetch Successful',
                        class: 'slds-theme--success',
                        callableFunction: component.getReference("c.accountUpdateAction"),
                        buttonHeading: 'Okay',
                        secondaryButtonHeading: 'Cancel',
                        secondaryCallableFunction : component.getReference("c.closeAlert"),
                        onlyMessage: false
                    };
                    
                    helper.showAlert(component, event, alertBoxParams);
                    
                    
                }
                
                else {
                    
                    //show the price returned
                    var alertBoxParams = {
                        message: 'Some Error Occurred',
                        heading: 'Price Fetch Failed',
                        class: 'slds-theme--error',
                        callableFunction: component.getReference("c.closeAlert"),
                        buttonHeading: 'Close Alert',
                        onlyMessage: false
                    };
                    
                    helper.showAlert(component, event, alertBoxParams);
                }
                
            }); $A.enqueueAction(priceCheckAction);
            
            
        }
        
    },
    closeAlert: function(component, event, helper) {
        
        component.set('v.body', []);
        $A.get("e.force:closeQuickAction").fire();
    },
    accountUpdateAction : function(component,event,helper){
        
        //update the account record with product as null
        component.set('v.fields.Product__c', null);
        
        //show the spinner
        component.set('v.showSpinner',true);
        
        //make update call
        component.find('recordHandler').saveRecord($A.getCallback(function(saveResult){
            
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                
                $A.get("e.force:closeQuickAction").fire();
                
            } 
            
            else if (saveResult.state === "INCOMPLETE") {
                
                //show the price returned
                var alertBoxParams = {
                    message: "User is offline, device doesn't support drafts.",
                    heading: 'Page Says...',
                    class: 'slds-theme--info',
                    callableFunction: component.getReference("c.closeAlert"),
                    buttonHeading: 'Close Alert',
                    onlyMessage: false
                };
                
                helper.showAlert(component, event, alertBoxParams);
                
                console.log("User is offline, device doesn't support drafts.");
                
            } 
            
                else{
                    
                    //show the price returned
                    var alertBoxParams = {
                        message: "Kindly contact adminstrator.",
                        heading: 'Some Error Occurred',
                        class: 'slds-theme--error',
                        callableFunction: component.getReference("c.closeAlert"),
                        buttonHeading: 'Close Alert',
                        onlyMessage: false
                    };
                    
                    helper.showAlert(component, event, alertBoxParams);
                    
                }
        }));
    }
    
    
    
})