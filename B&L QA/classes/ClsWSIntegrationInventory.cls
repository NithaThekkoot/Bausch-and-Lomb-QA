/**
 * 
 *   APAC VC webservice to accept SKU Inventory data from ERP.
 *
 *   Author             |Author-Email                            |Date       |Comment
 *   -------------------|----------------------------------------|-----------|----------------------------------------------------
 *   Balaji             |balaji.prabakaran@listertechnologies.com|22.04.2010 |First Draft
 *   Balaji             |balaji.prabakaran@listertechnologies.com|13.05.2010 |Changes to handle data for Australia and NewZealand
 *   Balaji             |balaji.prabakaran@listertechnologies.com|14.06.2010 |Changed the StockPointName for India from IDC to IN
 *
 */

Global public class ClsWSIntegrationInventory {

  //A class to temporarily hold the data sent as XML.  
    public Class StockData {
        public String stockType {get; set;}
        public String recorddate {get; set;}
        public List<ProductGroup> lstProductGroups {get; set;}
    }
   
    //A class to temporarily hold the data sent as XML.  
    public class ProductGroup {
        public String name {get; set;}
        //new one
        public String id {get; set;}
        public List<Product> lstProducts {get; set;}
    }
      
    //A class to temporarily hold the data sent as XML.  
    public class Product {  
        public String skuName {get; set;}
        public String skuId {get; set;}
        public String power {get; set;}
        public String unitsAvailable {get; set;}
    }
    
  /**
   *  The main method. 
   *  Input Parameter
   *  requestXML - string containing the XML data
   *  Output - response string.
   */    
  public webservice static String create(String requestXML) {
    //XML Element representing the collection of data sent.
    ClsUtilXMLElement xmlIDCStock = new ClsUtilXMLParser().parse(requestXML);
    
    /**
     *  Code block to read the data and assigning to temporary objects.
     */
    StockData oStockData = new StockData();
    oStockData.stockType = xmlIDCStock.getAttrs().get('name');
    if (oStockData.stockType==null || oStockData.stockType=='') oStockData.stockType = 'IN'; //India Distribution Center is the default.
    oStockData.recordDate = xmlIDCStock.getAttrs().get('recorddate');
    
    List<ProductGroup> lstProductGroups = new List<ProductGroup>();
    for(ClsUtilXMLElement xmlProductGroup:xmlIDCStock.getElements()){
      ProductGroup oProductGroup = new ProductGroup();
      oProductGroup.name = xmlProductGroup.getAttrs().get('name');
      oProductGroup.id = xmlProductGroup.getAttrs().get('id');
      List<Product> lstProducts = new List<Product>();
      for(ClsUtilXMLElement xmlProduct:xmlProductGroup.getElements()){
        Product oProduct = new Product();
        oProduct.skuId = xmlProduct.getAttrs().get('SKUId');
        oProduct.skuName = xmlProduct.getAttrs().get('SKU');
        oProduct.power = xmlProduct.getAttrs().get('Power');
        oProduct.unitsAvailable = xmlProduct.getAttrs().get('UnitsAvailable');
        lstProducts.add(oProduct);
      }
      oProductGroup.lstProducts = lstProducts;
      lstProductGroups.add(oProductGroup);
    } 
    oStockData.lstProductGroups = lstProductGroups;
    
        //code block for inserting in to custom objects.
        //List of SKUInventories to create.
        List<Inventory__c> list_SKUInventory = new List<Inventory__c>();
        Inventory__c objInventory = null;
        
        //List of data owners.
        List<String> list_Owner = new List<String>();
        list_Owner.add(Label.APASU_India_Data_Owner);
        list_Owner.add(Label.APASU_ANZ_Data_Owner);
        list_Owner.add(Label.APACSU_China_Data_Owner);

        
        //Map of data owners and their Ids.
        Map<String, Id> map_Owner_Id = new Map<String, Id>();
        for (User u:[Select Id, Username from User where Username in :list_Owner]){
          map_Owner_Id.put(u.Username, u.Id);
        }
        
        //to get the owner based on the country.
        Id idOwner = null;
        if (oStockData.stockType=='IN'){
          idOwner = map_Owner_Id.get(Label.APASU_India_Data_Owner);
        }else if (oStockData.stockType=='AU' || oStockData.stockType=='NZ'){
          idOwner = map_Owner_Id.get(Label.APASU_ANZ_Data_Owner);
        }
        else if(oStockData.stockType == 'CH')
        {
            idOwner = map_Owner_Id.get(Label.APACSU_China_Data_Owner);
        }
        
        //Map of SKU Inventory records against the unique value.
        Map<String, Inventory__c> map_Unique_SKUInventory = new Map<String, Inventory__c>();
        
        //For-loop: Loop through each record sent and create SKU Inventory.
        for(ProductGroup oProductGroup : oStockData.lstProductGroups){
            for(Product oProduct : oProductGroup.lstProducts){
                objInventory = new Inventory__c();
                objInventory.Stock_Point__c = oStockData.stockType;
                objInventory.Record_Date__c = Date.valueOf(oStockData.recorddate);
                objInventory.Product_Group_Id__c = oProductGroup.id;
                objInventory.Product_Group__c = oProductGroup.name;
                objInventory.SKU_Id__c = oProduct.skuId;
                objInventory.Name = oProduct.skuName;
                objInventory.Quantity_In_Stock__c = Integer.valueOf(oProduct.unitsAvailable);
                objInventory.OwnerId = idOwner;   
                System.debug('objInventory.Stock_Point_Name__c -->' + objInventory.Name);
                String strUnique = objInventory.Stock_Point__c + objInventory.SKU_Id__c;
                objInventory.Stock_Point_Name_SKU_ID__c = strUnique;
                map_Unique_SKUInventory.put(strUnique, objInventory);
            }
        }
        //assiging the values from the map to the list.
    list_SKUInventory = map_Unique_SKUInventory.values();
        
        Database.upsertResult[] uResults = Database.upsert(list_SKUInventory, Inventory__c.Stock_Point_Name_SKU_ID__c, false);
    
        // code block for creating the response string 
        Integer intRowNum = 0;//the serial number
        Integer intSuccess = 0;//count of successful inserts/updates.
        Integer intFailure = 0;//count of failures.
        
        //XML Element to form the response string.
        String responseString = '<IDCStock ResponseDateTime= "' + datetime.now() + '">';
        ClsUtilXMLElement xmlResponse = new ClsUtilXMLElement('IDCStock');
        xmlResponse.addAttribute('ResponseDateTime', String.valueOf(System.now()));
        
        Map<String, ClsUtilXMLElement> mapProductGroups = new Map<String, ClsUtilXMLElement>();
        //For-loop: Loop through each result and form the response.
        for(Database.upsertResult result:uResults) {
            objInventory = list_SKUInventory.get(intRowNum);
            String productGroupId = objInventory.Product_Group_Id__c;
            
            ClsUtilXMLElement xmlProductGroup = new ClsUtilXMLElement('Product Group');
            if (mapProductGroups.containsKey(productGroupId)){
              xmlProductGroup = mapProductGroups.get(productGroupId);
            } else {
              xmlProductGroup.addAttribute('id', objInventory.Product_Group_Id__c);
              mapProductGroups.put(productGroupId, xmlProductGroup);
            }
          
          ClsUtilXMLElement xmlProduct = new ClsUtilXMLElement('Product');
            System.debug('result.getId()' + result.getId()); 
          xmlProduct.addAttribute('id', result.getId());
          xmlProduct.addParameter('SKUId', objInventory.SKU_Id__c);
            if (result.isSuccess()) {
            xmlProduct.addParameter('StatusFlag', 'SUCCESS');
                System.debug('objInventory' + objInventory.SKU_Id__c);
                intSuccess++;
            } else {
                xmlProduct.addParameter('StatusFlag', 'FAILURE');
                ClsUtilXMLElement xmlErrors = new ClsUtilXMLElement('Errors');
                for (Database.Error oError : result.getErrors()) {
                  ClsUtilXMLElement xmlError = new ClsUtilXMLElement('Error');
                  xmlError.addParameter('errorCode', String.valueOf(oError.getStatusCode()));
                  xmlError.addParameter('message', oError.getMessage());
                  xmlErrors.addElement(xmlError);
                    System.debug(oError.getMessage() + 'oError.getMessage()');
                    System.debug(oError.getStatusCode() + 'oError.getStatusCode()');
                }
                xmlProduct.addElement(xmlErrors);
                System.debug('objInventory Error ' + objInventory.SKU_Id__c);
                intFailure++;
            }
            xmlProductGroup.addElement(xmlProduct);
            intRowNum++;
        }
        xmlResponse.setElements(mapProductGroups.values());
        xmlResponse.addParameter('TotalNoOfRecords',String.valueOf(intRowNum));
        xmlResponse.addParameter('TotalNoOfRecordsSuccess',String.valueOf(intSuccess));
        xmlResponse.addParameter('TotalNoOfRecordsFailure',String.valueOf(intFailure));
        System.debug('responseString is -->' + xmlResponse.toXML());
        
        return xmlResponse.toXML();
  }

}