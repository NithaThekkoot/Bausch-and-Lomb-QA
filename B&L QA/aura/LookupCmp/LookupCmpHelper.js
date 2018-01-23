({
    readChaching : true,
    getFieldValueByHirarchy : function(component,objectConstruct,displayableFieldHirarchy) {
        
        displayableFieldHirarchy = displayableFieldHirarchy.split('.');
        var indexValue = objectConstruct;
        
        if(displayableFieldHirarchy.length==1){
            
            indexValue = objectConstruct[displayableFieldHirarchy[0]];
            
        }else{
            
            for(var i=0,len=displayableFieldHirarchy.length;i<len;i++){
                
                if(indexValue!==null && indexValue!==undefined){
                    indexValue = indexValue[displayableFieldHirarchy[i]];    
                }else{
                    break;
                }
                
            }
            
        }
        
        return indexValue;
    }
})