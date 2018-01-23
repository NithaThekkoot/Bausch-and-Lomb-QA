({
    primaryPartnerCheck : function(component,event,partnerList) {
        var record = component.get('v.record');
        if(record.apiName=='Opportunity'){
            
            //no partner exist
            if(partnerList==null || partnerList.length==0){
                component.find('partnerCreate').set('v.primaryOptionAvailableForOpportunity',true);
            }
            
            //some partners exist
            else{
                var primaryPartnerExist = partnerList.filter(function(a){
                    return (a.IsPrimary==true);
                });
                
                //primary exist
                if(primaryPartnerExist!=null && primaryPartnerExist.length!=0){
                    component.find('partnerCreate').set('v.primaryOptionAvailableForOpportunity',false);
                }
                
                //primary don't exist
                else{
                    component.find('partnerCreate').set('v.primaryOptionAvailableForOpportunity',true);
                }
                
            }
            
            
        }
        
    }
})