({
    showAlert: function(component, event, alertboxContent) {
        
        // create dynamic alert box with some initializations
        var self = this;
        var test;
        $A.createComponent(
            "c:AlertboxCmp", {
                message: alertboxContent.message,
                heading: alertboxContent.heading,
                class: alertboxContent.class,
                onOkay: alertboxContent.callableFunction,
                onSecondaryOkay: alertboxContent.secondaryCallableFunction,
                buttonHeading: alertboxContent.buttonHeading,
                secondaryButtonHeading: alertboxContent.secondaryButtonHeading,
                svgPath: alertboxContent.svgPath,
                onlyMessage : alertboxContent.onlyMessage
            },
            function(alertbox) {
                
                
                if (alertbox != null && alertbox.isValid()) {
                    
                    /*if(alertboxContent.callableFunction!=null){
                        alertbox.addEventHandler("c:AlertboxOkayEvent", alertboxContent.callableFunction);
                    }
                    
                    if(alertboxContent.secondaryCallableFunction!=null){
                       alertbox.addEventHandler("c:AlertboxSecondaryOkayEvent", alertboxContent.secondaryCallableFunction); 
                    }*/
                    var body = [];
                    body.push(alertbox);
                    if (!alertbox.isInstanceOf("c:AlertboxCmp")) {
                        component.set("v.body", []);
                    } else {
                        component.set("v.body", body);
                    }
                    
                }
            }
            
        );
        
    },
})