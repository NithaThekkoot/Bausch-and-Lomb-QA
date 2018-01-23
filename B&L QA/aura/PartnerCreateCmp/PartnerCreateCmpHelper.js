({
    disableEnableComponents : function(component,event,componentList,disable) {
        
        if(componentList!=null && Array.isArray(componentList)){
            
            for(let i=0;i<componentList.length;i++){
                component.find(componentList[i]).set('v.disabled',disable);
            }
            
        }
        
    },
    modalDisplayHandler : function(component, event,showModal){
        
        var helper = this;
        
        var modal = component.find('createPartnerModal');
        var backdrop = component.find('createPartnerModal-backdrop');
        
        if(showModal){
            if(!$A.util.hasClass(modal,'slds-fade-in-open')){
                $A.util.addClass(modal,'slds-fade-in-open');
                $A.util.addClass(backdrop,'slds-backdrop_open');
            }
            
            //reset all variables
            component.set('v.partner',{
                sobjectType : 'Partner',
                Id : null,
                Role : null,
                AccountFromId : (component.get('v.record.apiName')=='Account'?component.get('v.recordId'):null),
                OpportunityId : (component.get('v.record.apiName')=='Opportunity'?component.get('v.recordId'):null),              
                AccountToId : null,
                IsPrimary: false
            });
            component.set('v.fieldError' , {
                
                partner : '',
                role : ''
                
            });
            
            //set the dom values
            component.find('partner').set('v.displayedIdentifier','');
            component.set('v.partner.Role','');
            component.set('v.partner.IsPrimary',false);
            
            //enable all buttons
            var componentListToBeDisabled = ['partner','role','save','cancel'];
            
            //enable all fields on page
            helper.disableEnableComponents(component,event,componentListToBeDisabled,false);
            
            
        }
        else{
            
            if($A.util.hasClass(modal,'slds-fade-in-open')){
                $A.util.removeClass(modal,'slds-fade-in-open');
                $A.util.removeClass(backdrop,'slds-backdrop_open');
            }
            
        }
        component.set('v.openModal',showModal);
        
        
    },
    validator : function(component, event){
        
        var validated = true;
        var errorCheckList = ['partner','role'];
        
        //individually check all fields for error
        if(component.get('v.partner.Role')=='' || component.get('v.partner.Role')==null){
            component.set('v.fieldError.role','Partner role is required..');
        }
        else{
            component.set('v.fieldError.role','');
        }
        if(component.get('v.partner.AccountToId')=='' || component.get('v.partner.AccountToId')==null){
            component.set('v.fieldError.partner','Please fill the partner value..');
        }
        else{
            component.set('v.fieldError.partner','');
        }
        //calculate all errors in total
        for(var i=0,len=errorCheckList.length;i<len;i++){
            
            if(component.get('v.fieldError.'+errorCheckList[i])!=''){
                
                validated = false;
                break;
                
            }
            
        }
        
        return validated;
        
    }
    
    
})