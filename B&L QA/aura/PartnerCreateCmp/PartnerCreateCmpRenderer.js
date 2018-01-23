({
    render : function(component,event){
        
        var renderer = this.superRender();
        
        component.set('v.partner',{
            sobjectType : 'Partner',
            Id : null,
            Role : null,
            AccountFromId : null,
            OpportunityId : null,
            AccountToId : null,
            IsPrimary : false
        });
        component.set('v.fieldError' , {
            
            partner : '',
            role: ''
             
        });
        
        return renderer;
        
    }
})