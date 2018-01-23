({
    redirect : function(component, event, helper) {
        var nav=event.getParam('name');
        var urlEvent = $A.get("e.force:navigateToURL");
        var url = '';
        
        switch(nav){
                
            case 'Complemar':{
                url='http://bauschsurgical.complemar.com';
                break;
            }
                
            case 'B+L App Store':{
                url='http://blapps.bausch.com/';
                break;
            }    
                
        }
        urlEvent.setParams({
            "url": url
        });
        urlEvent.fire();
    }
})