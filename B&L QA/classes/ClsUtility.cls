/**********************************************************************************************/
/* Jennie Burns - B&L - 10/27/2010 - Add methods for get getProfileIds() & getRecordTypeIds() */
/**********************************************************************************************/
public with sharing class ClsUtility {
    
    public List<ClsProductCache> list_products {get; set;}
    private static Map<String, Id> userProfiles = new Map<String, Id>();
    private static Map<String, Id> recordTypes = new Map<String, Id>();
    private static Map<String, Id> userroles = new Map<String, Id>();
    
    public ClsUtility(){
        this.list_products = new List<ClsProductCache>();
    }
    
     //get a set of specified user profile ids
    public static Set<Id> getProfileIds (String inName) {
        try {
            if (userProfiles.isEmpty()) {
                for (Profile p : [select Name, Id from Profile])
                    userProfiles.put(p.Name, p.Id);
            }
            Set<String> pNames = new Set<String>();
            Set<Id> setIds = new Set<Id>();
        
            //get the list of profiles by the specified name
            pNames = userProfiles.keySet();
            for (String str : pNames) {
                if (str.contains(inName)== true)
                    setIds.add(userProfiles.get(str));
            }           
            return setIds;
       }
       catch (Exception ex) {
           System.debug('Please contact your support people: ' + ex);
           return null;
       }
    }
    
    //get a single profile id 
    public static Id getProfileId (String prName) {
        try {
            if (userProfiles.isEmpty()) {
                for (Profile pr : [select Name, Id from Profile]){
                    String str = pr.Name;
                    userProfiles.put(str, pr.Id);
                }
            }
            return userProfiles.get(prName);
       }
       catch (Exception ex) {
           System.debug('Please contact your support people: ' + ex);
           return null;
       }        
    }

     //get a set of specified user role ids
    public static Set<Id> getUserRoleIds (String inName) {
        try {
            if (userRoles.isEmpty()) {
                for (UserRole p : [select Name, Id from UserRole])
                    userRoles.put(p.Name, p.Id);
            }
            Set<String> rNames = new Set<String>();
            Set<Id> setIds = new Set<Id>();
        
            //get the list of profiles by the specified name
            rNames = userProfiles.keySet();
            for (String str : rNames) {
                if (str.contains(inName)== true)
                    setIds.add(userRoles.get(str));
            }           
            return setIds;
       }
       catch (Exception ex) {
           System.debug('Please contact your support people: ' + ex);
           return null;
       }
    }
    
    //get a single user role id 
    public static Id getUserRoleId (String urName) {
        try {
            if (userroles.isEmpty()) {
                for (UserRole ur : [select Name, Id from UserRole]){
                    String str = ur.Name;
                    userroles.put(str, ur.Id);
                }
            }
            return userroles.get(urName);
       }
       catch (Exception ex) {
           System.debug('Please contact your support people: ' + ex);
           return null;
       }        
    }    
    //get a single record type id 
    public static Id getRecordTypeId (String objName, String rtName) {
        try {
            if (recordTypes.isEmpty()) {
                for (RecordType rt : [select Name, sObjectType, Id from RecordType]){
                    String str = rt.sObjectType + rt.Name;
                    recordTypes.put(str, rt.Id);
                }
            }
            
            //get one Id by the specified object type and name
            //Set<Id> recTypeID = new Set<Id>();
            //    recTypeId.add(recordTypes.get(objName+rtName));
            return recordTypes.get(objName+rtName);

       }
       catch (Exception ex) {
           System.debug('Please contact your support people: ' + ex);
           return null;
       }        
    }
    
    //get a List of record type ids 
    public static Set<Id> getRecordTypeId (String objName, List<String> rtName) {
        try {
            if (recordTypes.isEmpty()) {
                for (RecordType rt : [select Name, sObjectType, Id from RecordType]){
                    String str = rt.sObjectType + rt.Name;
                    recordTypes.put(str, rt.Id);
                }
            }         
                            
            //get the list of record types by the specified object type and name
            Set<Id> rtIds = new Set<Id>();
            for (String str : rtName) {
                rtIds.add(recordTypes.get(objName+str));
            }
            return rtIds;

       }
       catch (Exception ex) {
           System.debug('Please contact your support people: ' + ex);
           return null;
       }        
    }    

       public String splitChars(String str){
        System.debug('********** Splitting Chars **********');
        str.replace('\r', '|');
        str.replace('\n', '|');
        str.replace('\b', '|');
        str.replace('\t', '|');
        str.replace('\f', '|');
        str.replace('<br>', '|');
        for (Integer i = 0;i<str.length();i++){
            System.debug('--> ' + i + ': ' + str.substring(i,i+1));
        }
        return str;             
    }
    
    public void readProductCache(){
        //for (Attachment a : [Select Body from Attachment where Name = 'ProductInfo.txt' and ParentId = '001T000000F7raXIAR' limit 1000]){
         //   String inputTxt = a.Body.toString();
         //   System.debug('--> Length: ' + inputTxt.length());
         //  parseProductCache(inputTxt);
        //}
    }
    
    public void parseProductCache(String input){
        //List<String> list_records = input.split(';');
        ////each record
        //for (Integer i = 0; i < list_records.size(); i++){
            //ClsProductCache pCache = new ClsProductCache();
            //Product2 p = new Product2();
            
            //String record = list_records[i];
            ////remove first and last curly bracket
            //record = record.substring(1,record.length());
            
            //String invRecord = record.substring(record.indexOf('Inventory__r',0),record.length());
            
            //record = record.substring(1,record.indexOf('Inventory__r',0));
            
            //List<String> list_fieldsNvalues = record.split('\', ');
            ////for each pair
            //for (Integer j = 0; j < list_fieldsNvalues.size(); j++){
                //String fieldNValue = list_fieldsNvalues[j];
                //List<String> list_finalStrings = fieldNValue.split(':\'');
                //String fieldName = list_finalStrings[0]; 
                //String value = list_finalStrings[1];
                
                //if (fieldName == 'Name'){
                    //p.Name = value;         
                //} 
                //else if (fieldName == 'Family'){
                   // p.Family = value;
                //}
                //else if (fieldName == 'Description'){
                   // p.Description = value;
                //}
               // else if (fieldName == 'PS_Product_SKU__c'){
                   // p.PS_Product_SKU__c = value;
               // }
               // else if (fieldName == 'Unit_of_Measure__c'){
                   // p.Unit_of_Measure__c = value;
                //}
                //else if (fieldName == 'Maximum_Order_Qty__c'){
                    //p.Maximum_Order_Qty__c = Double.valueOf(value);
                //}
               // else if (fieldName == 'Multiple_Order_Qty__c'){
                   // p.Multiple_Order_Qty__c = Double.valueOf(value);
               // }
                /*
                else if (fieldName == 'Inventory__r'){
                    //String invRecord = list_invRecords[i];
                    //remove first and last curly bracket
                    invRecord = invRecord.substring(1,invRecord.length());
                    list_fieldsNvalues = invRecord.split('\', ');
                    //for each pair
                    for (Integer k = 0; k < list_fieldsNvalues.size(); k++){
                        fieldNValue = list_fieldsNvalues[k];
                        list_finalStrings = fieldNValue.split(':\'');
                        fieldName = list_finalStrings[0]; 
                        value = list_finalStrings[1];
                    }
                }
                */
            //} // end for product field and value information
            //pCache.product = p;
            //System.debug('# ' + i + ' Product: ' + p);
            
            //insert inv information
            //pCache.list_invs = list_invs;
            
            //this.list_products.add(pCache);
        //}//end for each product record
    }
    
    public void storeProductsTxt(){
        /*System.debug('********** Store Products in XML **********');        
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'Products', null);
        
        String output = '';
        
        for (Product2 p : [Select p.Description, p.Family, p.Id, p.IsActive, p.Name, p.PS_Product_SKU__c, p.Strategic_Value__c, p.Unit_of_Measure__c, 
            p.Maximum_Order_Qty__c, p.Multiple_Order_Qty__c, 
            (Select Name, Quantity_in_Stock__c, Ship_From__c From Inventory__r) 
            from Product2 p where isActive = true limit 10]){
                
            output = '<Product><Id>' + p.Id + '</Id><Name>' + p.Name + '</Name><Description>' + p.Description + '</Description><PSProductSKU>' + p.PS_Product_SKU__c + '</PS Product SKU><UOM>' + p.Unit_of_Measure__c + '</UOM><MAX>' + String.valueOf(p.Maximum_Order_Qty__c) + '</MAX><Multiple>' + String.valueOf(p.Multiple_Order_Qty__c) + '</Multiple><Inventories>';
            
            for (Inventory__c inv : p.Inventory__r){
                output += '<Inventory><WH>' + inv.Ship_From__c + '</WH><Stock>' + String.valueOf(inv.Quantity_In_Stock__c) + '</Stock></Inventory>';    
            }
            
            output += '</Inventories></Product>';
            
            w.writeCData(output);
            
            //System.debug('p: ' + p);
            //output = p + '\n';
            //b = Blob.valueOf(output); 
            
        }
        w.writeEndElement();
        w.writeEndDocument();
        
        String xmlOutput = w.getXmlString();
        System.debug('*** XML: ' + xmlOutput);
        w.close();
        //System.debug('--> output: ' + output);
        
        //Blob b = Blob.valueof(xmlOutput);
        Blob b = Blob.valueof('text');
        
        List<Attachment> list_attachments = [Select Body from Attachment where Name = 'ProductInfo.xml' and ParentId = '001T000000F7raXIAR' limit 1000];
        if (list_attachments.size() > 0){
            delete list_attachments;
        }
        
        Attachment a = new Attachment(); 
        a.Name = 'ProductInfo.xml';
        a.Body = b;
        a.ParentId = '001T000000F7raXIAR';
        a.ContentType = 'text/xml';
        a.IsPrivate = false;
        insert a;
     */   
    }
    
    public void storeProducts(){
        /*System.debug('********** Store Products in XML **********');
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'Products', null);
        
        for (Product2 p : [Select p.Description, p.Family, p.Id, p.IsActive, p.Name, p.PS_Product_SKU__c, p.Strategic_Value__c, p.Unit_of_Measure__c, 
            p.Maximum_Order_Qty__c, p.Multiple_Order_Qty__c, 
            (Select Name, Quantity_in_Stock__c, Ship_From__c From Inventory__r) 
            from Product2 p where isActive = true limit 5000]){
            
            w.writeStartElement(null, 'Product', null);
            w.writeStartElement(null, 'Id', null);
            w.writeCharacters(p.Id);
            w.writeEndElement();
            
            w.writeStartElement(null, 'Name', null);
            w.writeCharacters(p.Name);
            w.writeEndElement();
            
            w.writeStartElement(null, 'Description', null);
            w.writeCharacters(p.Description);
            w.writeEndElement();
            
            w.writeStartElement(null, 'PSProductSKU', null);
            w.writeCharacters(p.PS_Product_SKU__c);
            w.writeEndElement();
            
            w.writeStartElement(null, 'UOM', null);
            w.writeCharacters(p.Unit_of_Measure__c);
            w.writeEndElement();
            
            w.writeStartElement(null, 'MAX', null);
            w.writeCharacters(String.valueOf(p.Maximum_Order_Qty__c));
            w.writeEndElement();
            
            w.writeStartElement(null, 'Multiple', null);
            w.writeCharacters(String.valueOf(p.Multiple_Order_Qty__c));
            w.writeEndElement();
            
            w.writeStartElement(null, 'Inventories', null);         
            
            for (Inventory__c inv : p.Inventory__r){
                w.writeStartElement(null, 'Inventory', null);
                
                w.writeStartElement(null, 'WH', null);
                w.writeCharacters(inv.Ship_From__c);
                w.writeEndElement();
                
                w.writeStartElement(null, 'Stock', null);
                w.writeCharacters(String.valueOf(inv.Quantity_in_Stock__c));
                w.writeEndElement();
                
                w.writeEndElement(); //end Inventory    
            }           
            
            w.writeEndElement(); // end Inventories         
            w.writeEndElement(); //end Product
        }
        
        w.writeEndElement(); //end Products
        w.writeEndDocument();
        
        String xmlOutput = w.getXmlString();
        System.debug('*** XML: ' + xmlOutput);
        w.close();
        
        Blob b = Blob.valueof(xmlOutput);
        
        List<Attachment> list_attachments = [Select Body from Attachment where Name = 'ProductInfo.xml' and ParentId = '001T000000F7raXIAR' limit 1000];
        if (list_attachments.size() > 0){
            delete list_attachments;
        }
        
        Attachment a = new Attachment(); 
        a.Name = 'ProductInfo.xml';
        a.Body = b;
        a.ParentId = '001T000000F7raXIAR';
        a.ContentType = 'text/xml';
        a.IsPrivate = false;
        insert a;
        
        /* DML Operations not possible with SObject Static Resource !!!
        StaticResource sr = new StaticResource(); 
        sr.Name = 'ProductInfo';
        sr.CacheControl = 'Public';
        sr.Description = 'This XML File contains product information as well as according iventory information';
        sr.ContentType = 'text/xml';
        sr.Body = b;
        */
    }
    
    public void readProducts(){
        /*List<ClsProductCache> list_products = new List<ClsProductCache>();
        
        Attachment a = [Select Body from Attachment where Name = 'ProductInfo.xml' and ParentId = '001T000000F7raXIAR' limit 1]; 
        
        
        String xmlInput = a.Body.toString();
        
        XmlStreamReader r = new XmlStreamReader(xmlInput);
        
        while(r.hasNext()) {
            System.debug('--> LocalName: ' + r.getLocalName());
            System.debug('--> EventType: ' + r.getEventType());
            if (r.getEventType() == XmlTag.START_ELEMENT) {             
                if ('Product' == r.getLocalName()) {            
                    ClsProductCache clsProduct = new ClsProductCache();
                    Product2 p = new Product2();
                    //r.nextTag();                  
                    while(r.hasNext()) {
                        if (r.getEventType() == XmlTag.START_ELEMENT) {
                            if ('Name' == r.getLocalName()) {
                                r.next();                                       
                                p.Name = r.getText();
                                System.debug('--> p.Name: ' + p.Name);                              
                            }
                            if ('Description' == r.getLocalName()) {
                                r.next();                                       
                                p.Description = r.getText();
                                System.debug('--> p.Description: ' + p.Description);                                
                            }
                            if ('PSProductSKU' == r.getLocalName()) {
                                r.next();                                       
                                p.PS_Product_SKU__c = r.getText();
                                System.debug('--> p.PS_Product_SKU__c: ' + p.PS_Product_SKU__c);                                
                            }
                            if ('PSProductSKU' == r.getLocalName()) {
                                r.next();                                       
                                p.PS_Product_SKU__c = r.getText();
                                System.debug('--> p.PS_Product_SKU__c: ' + p.PS_Product_SKU__c);                                
                            }
                            if ('UOM' == r.getLocalName()) {
                                r.next();                                       
                                p.Unit_of_Measure__c = r.getText();
                                System.debug('--> p.Unit_of_Measure__c: ' + p.Unit_of_Measure__c);                              
                            }
                            if ('MAX' == r.getLocalName()) {
                                r.next();                                       
                                p.Maximum_Order_Qty__c = Double.valueOf(r.getText());
                                System.debug('--> p.Maximum_Order_Qty__c: ' + p.Maximum_Order_Qty__c);                              
                            }
                            if ('Multiple' == r.getLocalName()) {
                                r.next();                                       
                                p.Multiple_Order_Qty__c = Double.valueOf(r.getText());
                                System.debug('--> p.Multiple_Order_Qty__c: ' + p.Multiple_Order_Qty__c);                                
                            }
                            if ('Inventories' == r.getLocalName()) {
                                List<Inventory__c> list_invs = new List<Inventory__c>();
                                while(r.hasNext()) {
                                    if (r.getEventType() == XmlTag.START_ELEMENT) {
                                        if ('Inventory' == r.getLocalName()) {
                                            Inventory__c inv = new Inventory__c();
                                            while(r.hasNext()) {
                                                if (r.getEventType() == XmlTag.START_ELEMENT) {
                                                    if ('WH' == r.getLocalName()) {
                                                        r.next();                                       
                                                        inv.Ship_From__c = r.getText();
                                                        System.debug('--> inv.Ship_From__c: ' + inv.Ship_From__c);                              
                                                    }
                                                    if ('Stock' == r.getLocalName()) {
                                                        r.next();                                       
                                                        inv.Quantity_in_Stock__c = Double.valueOf(r.getText());
                                                        System.debug('--> inv.Quantity_in_Stock__c: ' + inv.Quantity_in_Stock__c);                              
                                                    }
                                                }
                                                if (r.getEventType() == XmlTag.END_ELEMENT && 'Inventory' == r.getLocalName()) {
                                                    list_invs.add(inv);
                                                    break;
                                                }
                                                r.next();                                                                           
                                            }                                                                           
                                        }
                                    }
                                    if (r.getEventType() == XmlTag.END_ELEMENT && 'Inventories' == r.getLocalName()) {
                                        clsProduct.list_invs = list_invs;                                       
                                        break;
                                    }
                                    r.next();                                                                           
                                }                               
                            }                           
                        }
                        if (r.getEventType() == XmlTag.END_ELEMENT && 'Product' == r.getLocalName()) {
                            clsProduct.product = p;
                            list_products.add(clsProduct);
                            break;
                        }
                        r.next();
                    }                   
                }
            }
            if (r.getEventType() != XmlTag.END_DOCUMENT){ 
                r.next();
            }   
        } 
    */
    }
}