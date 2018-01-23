({
    setShowList: function(component, event, helper) {
        //set the list showable triggers as afresh
        component.set('v.recordList', []);
        component.set('v.isSelected', false);

    },
    getObjects: function(component, event, helper) {
		//javascript initializations before query
        var textValue = event.getSource().get('v.value');
        var label = component.get('v.label');

        // if given search string is not null and not empty and its length is not less than 2, query the database
        var minCharacters = component.get('v.minCharacters');

        if (textValue != null && textValue != '' && textValue.length >= minCharacters) {

            // query maker variables
            var where = component.get('v.where');
            var fields = component.get('v.fields');
            var displayedIdentifier = component.get('v.objectType');

            // query making
            var query = null;
            if(component.get('v.doSearchStartsWith')){
                query = "select " + fields + " from " + displayedIdentifier + " where "+ component.get('v.searchableField') +
                " like '" + textValue + "%' " + where + ' order by '+ component.get("v.orderByField") +' asc' +' limit 50';
            }else{
                query = "select " + fields + " from " + displayedIdentifier + " where "+ component.get('v.searchableField') +
                " like '%" + textValue + "%' " + where + ' order by '+ component.get("v.orderByField") +' asc' +' limit 50';
            }


            // database search
            component.set("v.searchStarted",true);
            helper.readRaw(component, event, helper, query, function(response) {
				
                component.set("v.searchStarted",false);
                if (response !== null && response !== undefined) {

                    if (response["sObjectList"] != undefined && response["sObjectList"] != null) {

                        //set component list from response
                        component.set("v.recordList", []);

                        if(response["sObjectList"].length!==0){
                            var recordList = response["sObjectList"];
                            for(var i=0,len;i<recordList.length;i++){
                                var object = recordList[i];
                                object["listProperty"] =  helper.getFieldValueByHirarchy(component,object,component.get("v.displayableListField"));

                            }
                        }
                        component.set("v.recordList", response["sObjectList"]);

                        //this code fires if lookup search results equals to 1
                        if(response["sObjectList"].length==1){
                            var selectedObject = response["sObjectList"][0];

                            // set the name of that object in component
                            if(response["sObjectList"].length!==0){
                                var object = response["sObjectList"][0];
                                 object["listProperty"] =  helper.getFieldValueByHirarchy(component,object,component.get("v.displayableListField"));
                                 component.set('v.displayedIdentifier', object["listProperty"]);
                            }


                            //hide list
                            component.set('v.recordList', []);
                            component.set('v.isSelected', true);

                            // get the event and fire
                            var onLookupSelect = component.getEvent('onLookupSelect');
                            onLookupSelect.setParams({
                                selectedObject: selectedObject
                            });

                            onLookupSelect.fire();
                        }

                    } else {

                        //set component list from response
                        component.set("v.recordList", []);

                        // log the response object in case of error or exception
                        console.log(label + " lookup went wrong, sObjectList returned is undefined or null,please " +
                                    "check the returned response of lookup below->");
                        console.log(response);

                    }

                } else {

                    //set component list from response
                    component.set("v.recordList", []);

                    // log the response object in case of error or exception
                    console.log(label + " lookup went wrong, response object itself is undefined or null");

                }

            });
        } else {

            // set object list as empty array
            component.set("v.recordList", []);
        }

    },
    setObject: function(component, event, helper) {
		
        // get selected object
        var selectedObject = JSON.parse(JSON.stringify(event.getSource().get('v.class')));

        var displayedProperty = helper.getFieldValueByHirarchy(component,selectedObject,component.get("v.displayableField"));
        // set the name of that object in component
        component.set('v.displayedIdentifier', displayedProperty);

        //hide list
        component.set('v.recordList', []);
        component.set('v.isSelected', true);

        // get the event and fire
        var onLookupSelect = component.getEvent('onLookupSelect');
        onLookupSelect.setParams({
            selectedObject: selectedObject
        });

        onLookupSelect.fire();

    },
    throwBlur: function(component, event, helper) {

        var onBlur = component.getEvent('onBlur');
        var textValue = component.find('lookup-textbox').get('v.value');
        onBlur.setParams({
            textValue: textValue,
            isSelected : component.get('v.isSelected')
        });

        onBlur.fire();

    }
})