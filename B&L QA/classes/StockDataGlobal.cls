Global public class StockDataGlobal 
{
    public Class StockData 
    {
        public String stockType {get; set;}
        public String recorddate {get; set;}
        public List<ProductGroup> ProductGroupObj {get; set;}
    }
   
    public class ProductGroup 
    {
        public String productGroupName {get; set;}
        //new one
        public String productGroupID {get; set;}
        public List<Product> ProductObj {get; set;}
   
    }
      
    public class Product 
    {      
        public String skuName {get; set;}
        public String skuID {get; set;}
        public String Power {get; set;}
        public integer unitsAvailable {get; set;}
    }
    
    public webservice static String create(String requestXML) 
    {    
        
        try
        {
            // new xmls
            String requestXML2 = '<IDCStock name="IDC" recorddate="2009-01-24 10:10:10"><ProductGroup name="aa" id="bb"><Product><SKU>sku</SKU><SKUId>sku id 1</SKUId><Power>yXpower 1</Power><UnitsAvailable>1</UnitsAvailable></Product></ProductGroup><ProductGroup id="yXAPV"><Product><SKU>yXsku name 2</SKU><SKUId>yXnew sku id 2</SKUId><Power>yXpower 2</Power><UnitsAvailable>2</UnitsAvailable></Product><Product><SKU>yXsku name 3</SKU><SKUId></SKUId><Power>yXpower 3</Power><UnitsAvailable>3</UnitsAvailable></Product></ProductGroup></IDCStock>';
            //String requestXML3 = '<IDCStock type="IDC" recorddate="2009-01-24 10:10:10"><ProductGroup name="PV"><Product><SKU>sku name 1</SKU><SKUId>sku id 1</SKUId><Power>power 1</Power><UnitsAvailable>1</UnitsAvailable></Product><Product><SKU>sku name 4</SKU><SKUId>sku id 4</SKUId><Power>power 4</Power><UnitsAvailable>4</UnitsAvailable></Product></ProductGroup><ProductGroup name="APV"><Product><SKU>sku name 2</SKU><SKUId>sku id 2</SKUId><Power>power 2</Power><UnitsAvailable>2</UnitsAvailable></Product><Product><SKU>sku name 3</SKU><SKUId>sku id 3</SKUId><Power>power 3</Power><UnitsAvailable>3</UnitsAvailable></Product></ProductGroup></IDCStock>';

            StockData StockDataob = null;
        
            List<ProductGroup> ProductGroupObjList = null; 
            List<Product> ProductObjList = null; 
            
            ProductGroup ProductGroupob = null;
            Product Productob = null;
            
            Boolean isStockDataobj = false;
            Boolean isProductGroupobj = false; 
            Boolean isProductobj = false;
        
            XmlStreamReader reader = new XmlStreamReader(requestXML);
            
            while(reader.hasNext()) 
            {            
                if (reader.getEventType() == XmlTag.START_ELEMENT) 
                {        
                    if (reader.getLocalName() == 'IDCStock' ) 
                    {                       
                        StockDataob = new StockData();
                        ProductGroupObjList = new List<ProductGroup>();
                        
                        StockDataob.stockType = reader.getAttributeValue(null, 'name');
                        StockDataob.recorddate = reader.getAttributeValue(null, 'recorddate');                                      
                    }
                    if (reader.getLocalName() == 'ProductGroup' ) 
                    {                    
                        ProductObjList = new List<Product>();
                        ProductGroupob = new ProductGroup();
                    
                        ProductGroupob.productGroupName = reader.getAttributeValue(null, 'id');                     
                        ProductGroupob.productGroupID = reader.getAttributeValue(null, 'name');
                    }
                    if (reader.getLocalName() == 'Product' ) 
                    {                    
                        Productob = new Product();
                        parseStock(reader, Productob);                    
                    }
                }
            
            
                if (reader.getEventType() == XmlTag.END_ELEMENT) 
                {            
                    if (reader.getLocalName() == 'Product') 
                    {
                        ProductObjList.add(Productob);
                    }
                    if (reader.getLocalName() == 'ProductGroup') 
                    {          
                        ProductGroupob.ProductObj = ProductObjList;
                        ProductGroupObjList.add(ProductGroupob);               
                    }
                    if (reader.getLocalName() == 'IDCStock') 
                    {                
                        //do nothing
                    }           
                } 
                reader.next();
            }
        
            //List of data owners.
            List<String> list_Owner = new List<String>();
            list_Owner.add(Label.APASU_India_Data_Owner);
            list_Owner.add(Label.APASU_ANZ_Data_Owner);
            
            //Map of data owners and their Ids.
            Map<String, Id> map_Owner_Id = new Map<String, Id>();
            for (User u:[Select Id, Username from User where Username in :list_Owner]){
                map_Owner_Id.put(u.Username, u.Id);
            }
            
            //to get the owner based on the country.
            Id idOwner = null;
            if (StockDataob.stockType=='IDC'){
                idOwner = map_Owner_Id.get(Label.APASU_India_Data_Owner);
            }else if (StockDataob.stockType=='AU' || StockDataob.stockType=='NZ'){
                idOwner = map_Owner_Id.get(Label.APASU_ANZ_Data_Owner);
            }
            
            // Getting Id for recordType "INDSU Inventory Item Record Type"
			Id idRecordType = [SELECT Id FROM RecordType WHERE Name = 'INDSU Inventory Item Record Type' AND SObjectType='Inventory__c'].Id;
            
            System.debug('Owner is ' + idOwner);
            
            //code block for inserting in to custom objects         
            List<Inventory__c> customStockInventoryList = new List<Inventory__c>();         
            Inventory__c customStockInventoryToInsert = null;
            List<Product> productTempList = null;
        
            for(ProductGroup ProductGroupTemp : ProductGroupObjList)
            {                
                productTempList =  ProductGroupTemp.ProductObj;
                
                for(Product productTemp : productTempList)
                {  
                    customStockInventoryToInsert = new Inventory__c();
                    customStockInventoryToInsert.Product_Group_Id__c    = ProductGroupTemp.productGroupName;                                   
                    customStockInventoryToInsert.Product_Group__c = ProductGroupTemp.productGroupID;     
                    customStockInventoryToInsert.Record_Date__c = date.valueOf(StockDataob.recorddate);                    
                    customStockInventoryToInsert.SKU_Id__c = productTemp.skuID;                    
                    customStockInventoryToInsert.Name = productTemp.skuName;                    
                    customStockInventoryToInsert.Quantity_In_Stock__c = productTemp.unitsAvailable;                   
                    customStockInventoryToInsert.Name = productTemp.skuName;
                    customStockInventoryToInsert.Stock_Point__c = StockDataob.stockType;
                    customStockInventoryToInsert.Stock_Point_Name_SKU_ID__c = customStockInventoryToInsert.Stock_Point__c + '' + customStockInventoryToInsert.SKU_Id__c;
                    customStockInventoryToInsert.OwnerId = idOwner;
                    customStockInventoryToInsert.RecordTypeId = idRecordType;
                    customStockInventoryList.add(customStockInventoryToInsert);
                }
        
            }
        
            Database.upsertResult[] uResults = Database.upsert(customStockInventoryList, Inventory__c.Stock_Point_Name_SKU_ID__c, false);
            
            // code block for creating the response string 
            Integer count = 0;        
            Integer successCount = 0;
            Integer failureCount = 0;
            
            String responseString = '<IDCStock ResponseDateTime= "' + datetime.now() + '">';
            String productGroupName = '';
            String productGroupNameNew = '';
            
            for(Database.upsertResult result:uResults) 
            {
                if (result.isSuccess()) 
                {
                    System.debug('result.getId()' + result.getId()); 
                    Inventory__c stockObj = customStockInventoryList.get(count);
                    productGroupName = stockObj.Product_Group_Id__c;
                    
                    if (productGroupName != productGroupNameNew) 
                    {
                        if (productGroupNameNew != '') 
                            responseString = responseString + '</ProductGroup>';
                        responseString = responseString + '<ProductGroup id = "' + stockObj.Product_Group_Id__c + '">';
                    }
                    responseString = responseString + '<Product id="'+result.getId()+'"><SKUId>'+ stockObj.SKU_Id__c + '</SKUId><StatusFlag>SUCCESS</StatusFlag></Product>';
                     
                    System.debug('customStockInventoryList' + customStockInventoryList.get(count).SKU_Id__c);
                    successCount++;
                } 
                else 
                {                
                    Inventory__c stockObj = customStockInventoryList.get(count);
                    productGroupName = stockObj.Product_Group_Id__c;
                    
                    if (productGroupName != productGroupNameNew) 
                    {
                        if (productGroupNameNew != '') 
                            responseString = responseString + '</ProductGroup>';
                        responseString = responseString + '<ProductGroup id = "' + stockObj.Product_Group_Id__c + '">';
                    }
                    responseString = responseString + '<Product id=""><SKUId>'+ stockObj.SKU_Id__c + '</SKUId><StatusFlag>FAILURE</StatusFlag>';
                    responseString = responseString + '<Errors>';
                    
                    for (Database.Error errorObj : result.getErrors()) 
                    {                
                        responseString = responseString + '<Error><errorCode>' + errorObj.getStatusCode() + '</errorCode><message>' + errorObj.getMessage() + '</message></Error>';
                        System.debug(errorObj.getMessage() + 'errorObj.getMessage()');
                        System.debug(errorObj.getStatusCode() + 'errorObj.getStatusCode()');
                        System.debug('customStockInventoryList Error ' + customStockInventoryList.get(count).SKU_Id__c);
                    }
                    responseString = responseString + '</Errors></Product>';
                    failureCount++;
                }
                productGroupNameNew = productGroupName;
                count++;
            }
            responseString = responseString + '</ProductGroup>';
            responseString = responseString +  '<TotalNoOfRecords>' + count + '</TotalNoOfRecords>';
            responseString = responseString +  '<TotalNoOfRecordsSuccess>' + successCount + '</TotalNoOfRecordsSuccess>';
            responseString = responseString +  '<TotalNoOfRecordsFailure>' + failureCount + '</TotalNoOfRecordsFailure>';
            responseString = responseString + '</IDCStock>';
            System.debug('responseString is -->' + responseString);
            
            return responseString;
        }
        catch(Exception e)
        {
            String exceptionString = '<IDCStock><message>' + e.getMessage() + '</message></IDCStock>';
            System.debug('exceptionString is -->' + exceptionString);
            return exceptionString;
        }
        
    }
    
    
    
    
    //Parse Method to parse the product tag    
    public static void parseStock(XmlStreamReader reader, Product Productob)
    {
        String localName = '';
        
        while(reader.hasNext()) 
        {
            System.debug(reader.getLocalName() + '222' + reader.getEventType());  
            if (true) 
            {
                if (reader.getEventType() == XmlTag.END_ELEMENT) 
                {
                    if(reader.getLocalName() == 'Product')
                    break;
                } 
                else if (reader.getEventType() == XmlTag.CHARACTERS) 
                {
                    if (localName == 'SKU') 
                    { 
                        Productob.skuName = reader.getText(); 
                        System.debug('Sku name is' + Productob.skuName);
                    } 
                    else if (localName == 'SKUId') 
                    { 
                        Productob.skuID = reader.getText(); 
                        System.debug('Sku Id is' + Productob.skuID);
                    } 
                    else if (localName == 'Power') 
                    { 
                        Productob.Power = reader.getText(); 
                    }  
                    else if (localName == 'UnitsAvailable') 
                    { 
                        Productob.unitsAvailable = Integer.valueof(reader.getText()); 
                    }      
                    System.debug(reader.getLocalName()  + ' ==' + reader.getText());
                } 
                else if (reader.getEventType() == XmlTag.START_ELEMENT) 
                {
                    localName = reader.getLocalName();
                    System.debug('Local Name is ' + localName);
                }
            } 
            reader.next();
        }     
    }    
}