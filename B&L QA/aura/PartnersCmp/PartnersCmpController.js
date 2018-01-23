({
    doInit : function(component, event, helper) {
        
        var record = component.get('v.record');
        var query = '';
        var partnerFilter='';
        if(record.apiName=='Account'){
            
			 query = "select Id,AccountTo.Name,OpportunityId,IsPrimary,Role from Partner where AccountFromId='"+component.get('v.recordId')+"'";
             partnerFilter = "AND Id Not In ('"+component.get('v.recordId')+"')";
            
        }
        
        else{
          
             query = "select Id,AccountTo.Name,OpportunityId,IsPrimary,Role from Partner where OpportunityId='"+component.get('v.recordId')+"'";
             partnerFilter = "AND Id Not In ('"+component.get('v.fields.AccountId')+"')";
            
        }
        
        //filter for partner lookup
        component.find('partnerCreate').set('v.partnerFilter',partnerFilter);
          
        helper.readRaw(component,event,helper,query,function(response){
            
            var partnerList = ((response.sObjectList==null || response.sObjectList.length==0) ? []:response.sObjectList);
            component.set("v.partnerList",partnerList);
            
            //logic for primmary partner in opportunity
            helper.primaryPartnerCheck(component,event,partnerList);
         
            
        }) ;
        
    },
    createNewPartner : function(component, event, helper){
        
        //logic for primary partner in opportunity
        helper.primaryPartnerCheck(component,event,component.get('v.partnerList'));
        component.find('partnerCreate').set('v.openModal',true);
        
    },
    updatePartnerListAction : function(component, event, helper){
        
        var partner = event.getParam('partner');
        var partnerList = component.get('v.partnerList');
        partnerList.push(partner);
        component.set('v.partnerList',partnerList);
        
    },
    deletePartnerAction : function(component, event, helper){
        
        var partnerId = event.getSource().get('v.value');
        helper.deleteRaw(component, event, helper,partnerId,function(response){
            
            if(response.statusArray[0]==true){
                
                var partnerList = component.get('v.partnerList');
                partnerList = partnerList.filter(function(a){
                    return (a['Id']!=partnerId);
                });
                component.set('v.partnerList',partnerList);
                
            }
            
        });
        
        
    }
    
})