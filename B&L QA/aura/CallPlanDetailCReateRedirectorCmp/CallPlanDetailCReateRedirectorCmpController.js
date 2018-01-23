({
    recordLoadAction: function(component, event, helper) {
        
        var account = component.get('v.fields');
        
        helper.getCurrentUserDetails(component,event,helper,function(response){
            var urlEvent = $A.get("e.force:navigateToURL");
            var url = "";
            if(response.userRole=='KOR'){
                url = "/apex/CallPlan_KOR_SOLTA?id="+component.get('v.recordId')+"&mode=new";
            }
            else{
                url = "/apex/CtrlCallPlan_planDetail?id="+component.get('v.recordId')+"&mode=new";
            }
            urlEvent.setParams({
                "url": url
            });
            urlEvent.fire();
         });
  
    }
})