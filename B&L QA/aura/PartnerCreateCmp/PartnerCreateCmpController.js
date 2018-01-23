({
    validateField : function(component, event, helper) {
        
        var auraId = event.getSource().getLocalId();
        var source = component.find(auraId);
        switch(auraId){
                
            case "partner" : {
                
                var value= event.getParam('textValue');
                if(value==''){
                    component.set('v.fieldError.partner','Please fill the partner value..');
                }
                else{
                    component.set('v.fieldError.partner','');
                }
                
                
                break;    
            }
                
            case "role" : {
                
                if(source.get('v.value')=='' || source.get('v.value')==null){
                    component.set('v.fieldError.role','Partner role is required..');
                }
                else{
                    component.set('v.fieldError.role','');
                }
                
                break;
            }
                
        }
        
    },
    fillLookup : function(component, event, helper) {
        
        var auraId = event.getSource().getLocalId();
        var source = component.find(auraId);
        switch(auraId){
            case "partner" : {
                
                var partnerRecord= event.getParam('selectedObject');
                component.set('v.partner.AccountToId',partnerRecord.Id);
                component.set('v.partner.AccountTo.Name',partnerRecord.Name);
                
                break;    
            }
        }
        
    },
    save : function(component, event, helper) {
        
        
        var allFieldsValidated = helper.validator(component,event);
        
        if(allFieldsValidated){
            
            var partner = component.get('v.partner');
            var partnerInsertable = JSON.parse(JSON.stringify(partner));
            
            var componentListToBeDisabled = ['partner','role','save','cancel'];
            
            //disable all fields on page
            helper.disableEnableComponents(component,event,componentListToBeDisabled,true);
            
            //show the spinner
            component.set('v.showSpinner',true);
            
            //fill the parent record
            if(component.get('v.record.apiName')=='Account'){
                component.set('v.partner.AccountFromId',component.get('v.recordId'));
                partnerInsertable['AccountFromId'] = component.get('v.recordId');
            }
            else{
                component.set('v.partner.OpportunityId',component.get('v.recordId'));
                partnerInsertable['OpportunityId'] = component.get('v.recordId');
            }
            
            //make insert call
            helper.insertRaw(component,event,helper,partnerInsertable,function(response){
                
                //hide the spinner
                component.set('v.showSpinner',false);
                if(response.sobjectsAndStatus[0].status == 'successful'){
                    
                    //fill the Id
                    partner['Id'] = response.sobjectsAndStatus[0]['sObject']['Id'];
                    
                    //get the event
                    var partnerCreatedEvent = component.getEvent("partnerCreated");
                    partnerCreatedEvent.setParams({ "partner" : partner });
                    partnerCreatedEvent.fire();
                                    
                    //close the modal
                    component.set('v.openModal',false);
                    
                }
                else{
                    
                    //fire the toast
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error Occurred..",
                        "message": "Partner cannot be created.. Please contact your administrator",
                        "mode":"dismissible",
                        "type" : "error",
                        "duration":"3000ms"
                    });
                    toastEvent.fire();
                    //enable all fields on page
            		helper.disableEnableComponents(component,event,componentListToBeDisabled,false);
                    
                }
                
                
                
                
                
            });
            
            
        }
        else{
            
            //fire the toast
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error Occurred..",
                "message": "Some fields are not valid, Kindly check..",
                "mode":"dismissible",
                "type" : "error",
                "duration":"3000ms"
            });
            toastEvent.fire();
            
        }
        
        
        
    },
    cancel : function(component, event, helper){
        
        component.set('v.openModal',false);
        
    },
    modalDisplayAction : function(component, event, helper){
        
        helper.modalDisplayHandler(component, event,component.get('v.openModal'));
        
    },
    
})