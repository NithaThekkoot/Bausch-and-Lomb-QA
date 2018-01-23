public class exportExcel {
    
    public string header{get;set;}       
    public List<wrapper> lstwrapper {get; set;}    
    public class wrapper{
        public string shipTo {get; set;} 
        public string searchNumber{get; set;}
        public string accountName{get; set;}
        public string businessUnit{get; set;}
        public string dateval{get; set;}

        public string expirationDate{get; set;}
        public string expirationEndDate{get; set;}
        public string expirationStartDate{get; set;}
        public string groupval{get; set;}
        public string implantDate {get; set;} 
        public string invoiceDate{get; set;}
        public string invoiceNumber{get; set;}
        
        public string Location{get; set;}
        public string ToLocation{get; set;}
        public string OrderNumber{get; set;}
        public string PhysicianID{get; set;}
        public string PONumber{get; set;}
        public string ProductGroup{get; set;}
        public string ProductID{get; set;}
        public string SearchID{get; set;}
        public string SerialNumber{get; set;}
        public string Type{get; set;}
        public string UserID {get;set;}
        public string UserName {get;set;}
                  
    }
    

    public boolean isExcel {get;set;}
    public boolean isCsv {get;set;}     
    public string headerValue {get;set;}
    public exportExcel(){
            header = '';
            Consignment_Data_Header__c objConsignmentHeader = new Consignment_Data_Header__c();
            headerValue = ApexPages.currentPage().getParameters().get('Header');
            if(headerValue == 'SearchConsignmentResult'){                
                objConsignmentHeader = Consignment_Data_Header__c.getValues('Search Consignment Result');
            }else if(headerValue == 'SearchBilledConsignmentResult'){
                objConsignmentHeader = Consignment_Data_Header__c.getValues('Search Billed Consignment Result');
            }else if(headerValue == 'SearchTransactionHistoryResult'){
                objConsignmentHeader = Consignment_Data_Header__c.getValues('Search TR History Result');
            }else if(headerValue == 'SearchUnbilledConsignmentResult'){
                objConsignmentHeader = Consignment_Data_Header__c.getValues('Search Unbilled CON Result');
            }
            system.debug('Check Custom Setting Value:)'+objConsignmentHeader);
            string[] headerList = objConsignmentHeader.Search_Consignment_Results__c.split(',');            
            for(integer i=0 ;i<headerList.size();i++){                                  
                header = header + headerList[i]+',';
            }                                       
            header = header.substring(0,header.length()-1);
            system.debug('headerheader:'+header); 
            lstwrapper = new List<wrapper>();
                                 
    }
    
    public void exportToExcel(){
          string queryString = 'Select c.Account_Name__c, c.Business_Unit__c, c.Date__c, c.Expiration_Date__c,c.Expiration_End_Date__c, c.Expiration_Start_Date__c, c.Group__c, c.Id, c.Implant_Date__c, c.Invoice_Date__c, c.Invoice_Number__c, c.Location__c,c.To_Location__c,c.Name, c.Order_Number__c, c.OwnerId, c.Physician_ID__c, c.PO_Number__c, c.Product_Group__c, c.Product_ID__c, c.Search_ID__c, c.Serial_Number__c, c.Ship_To__c, c.Type__c, c.User_ID__c, c.User_Name__c from Consignment_Search_Data__c c where User_ID__c=\''+UserInfo.getUserId()+'\'';  
          List<Consignment_Search_Data__c> lstConsignmentSearchData = DataBase.Query(queryString);
          system.debug('lstConsignmentSearchData :'+lstConsignmentSearchData.size());
          if(lstConsignmentSearchData.size()>0){
              for(Consignment_Search_Data__c csd :lstConsignmentSearchData){                  
                  wrapper w = new wrapper();
                  w.shipTo = csd.Ship_To__c ;
                  w.searchNumber = csd.Search_ID__c;
                  w.accountName = csd.Account_Name__c;
                  w.businessUnit = csd.Business_Unit__c ;
                  w.dateval = string.valueof(csd.Date__c);
                  w.expirationDate = string.valueOf(csd.Expiration_Date__c);
                  w.expirationEndDate = string.valueOf(csd.Expiration_End_Date__c);
                  w.expirationStartDate = string.valueOf(csd.Expiration_Start_Date__c);
                  w.groupval = csd.Group__c;
                  w.implantDate = string.valueOf(csd.Implant_Date__c);
                  w.invoiceDate = string.valueOf(csd.Invoice_Date__c) ;
                  w.invoiceNumber = string.valueOf(csd.Invoice_Number__c);
                  
                  w.Location = csd.Location__c;
                  w.ToLocation = csd.To_Location__c;
                  w.OrderNumber = csd.Order_Number__c;
                  if(csd.Physician_ID__c!=null){
                      w.PhysicianID = csd.Physician_ID__c;
                  }else
                  w.PhysicianID = '';
                  
                  w.PONumber = csd.PO_Number__c;
                  w.ProductGroup = csd.Product_Group__c;
                  w.ProductID = csd.Product_ID__c;
                  w.SearchID = csd.Search_ID__c;
                  w.SerialNumber = csd.Serial_Number__c;
                  w.type = csd.Type__c;
                  w.UserID = csd.User_ID__c;
                  w.UserName = csd.User_Name__c;                  
                  lstwrapper.add(w);                
              }              
          }
          system.debug('lstwrapper :'+lstwrapper.size());
    }
    
}