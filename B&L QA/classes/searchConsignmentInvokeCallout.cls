public class searchConsignmentInvokeCallout{

  public Web_Service_Consignment_Search1.OutputData_element[] searchConsignment(string shipTo,
                       string productName,
                       string ProductId,
                       string serialNumber,
                       Date Expiration_Start_Date,
                       Date Expiration_End_Date,
                       string Consignment_Inventory_BU, 
                       string USER_ID,
                       string searchId,
                       string type,
                       string setId, 
                       string consignmentLocation
                       ){                                        
       Web_Service_Consignment_Search1.GetConsignmentSOAP webServicegetConsignmentObject = new Web_Service_Consignment_Search1.GetConsignmentSOAP(); 
       webServicegetConsignmentObject.endpoint_x  = Label.Blcipprod_Bausch_sfdc_Consignment;
       webServicegetConsignmentObject.timeout_x = 120000;      
       List<Web_Service_Consignment_Search1.InputData_element> listinputElement = new List<Web_Service_Consignment_Search1.InputData_element>();
       Web_Service_Consignment_Search1.InputData_element inputElements = new  Web_Service_Consignment_Search1.InputData_element(); 
       
       if(shipTo != null){inputElements.SHIP_TO_CUST_ID = shipTo ;}
       if(productName != null){inputElements.PRODUCT_GROUP= productName;}
       if(ProductId != null){inputElements.PRODUCT_ID = ProductId;}
       if(serialNumber != null){inputElements.SERIAL_NUMBER = serialNumber;}
       if(Expiration_Start_Date != null){inputElements.EXPIRATION_DATE= Expiration_Start_Date ;}
       if(Expiration_End_Date!= null){inputElements.EXPIRATION_DATE_END = Expiration_End_Date;} 
       if(Consignment_Inventory_BU != null){inputElements.CONSIGNMENT_INVENTORY_BUSINESS_UNIT = Consignment_Inventory_BU;}       
       inputElements.USER_ID = UserInfo.getUserId() ;       
       if(searchId != null){inputElements.SEARCH_ID = searchId;}
       if(type != null){inputElements.SEARCH_TYPE = type;}
       if(setId != null){inputElements.SET_ID = setId;}
       if(consignmentLocation != null){inputElements.CONSIGNMENT_LOCATION = consignmentLocation;}
       
       listinputElement.add(inputElements);              
       Web_Service_Consignment_Search1.OutputData_element[] outPutElement = webServicegetConsignmentObject.Consignment(listinputElement);
       system.debug('outPutElement :-> '+outPutElement);                        
       return outPutElement ;
       
    
  }
  
   public web_Service_Consignment_Search_ProductG.OutputData_element[] searchConsignmentProductGroup(string shiptoCustId,string consignmentInventoryBusinessUnit){        
    web_Service_Consignment_Search_ProductG.GetConsignmentProdGroupSOAP  webServiceConsignmentProdcutGroup = new web_Service_Consignment_Search_ProductG.GetConsignmentProdGroupSOAP();     
    webServiceConsignmentProdcutGroup.timeout_x = 60000;
    List<web_Service_Consignment_Search_ProductG.InputData_element> listinputElement = new List<web_Service_Consignment_Search_ProductG.InputData_element>();
    web_Service_Consignment_Search_ProductG.InputData_element inputElements = new  web_Service_Consignment_Search_ProductG.InputData_element();
    if(shiptoCustId !=null){inputElements.SHIP_TO_CUST_ID = shiptoCustId ;}
    if(consignmentInventoryBusinessUnit!=null){inputElements.CONSIGNMENT_INVENTORY_BUSINESS_UNIT=consignmentInventoryBusinessUnit ;}         
    listinputElement.add(inputElements);     
    system.debug('listinputElement'+listinputElement);
    web_Service_Consignment_Search_ProductG.OutputData_element[] outPutElement =webServiceConsignmentProdcutGroup.Consignment(listinputElement);
    //system.debug('outPutElement :-> For Product Group'+outPutElement.size());
    system.debug('outPutElement :->  For Product Group List'+outPutElement);       
    return outPutElement ;  
  }
  
}