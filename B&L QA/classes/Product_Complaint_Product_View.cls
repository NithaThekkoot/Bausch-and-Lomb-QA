/*
* Created By : Rohit Aggarwal
* Test Class Name : Test_Product_Complaint_Product_View
* Used for Product View Page
*
*/
public class Product_Complaint_Product_View {
      public Product_Complaint_Product__c PCP {get; set;}
        public boolean isPharma {get;set;}  
        public string objectID;
        public boolean VCOnly {get;set;}
        public boolean valueExist {get;set;}
        public boolean isClosed {get;set;}
        public boolean isEMEAorAPAC {get; set;}               
        public boolean isLencTypeUsed {get;set;}        
        public boolean isPrimaryPackLotNum {get;set;}    
        public boolean isReturned {get;set;}
        public boolean isNotReturned{get;set;}        
        public boolean isRequested{get;set;}         
        public boolean isPrroxideSystem {get;set;}
        
        
        public boolean quantityToBeReturned {get;set;}
        public boolean dateReceivedSubsidiary {get;set;}
        public boolean quantityReceivedOpen {get;set;}
        public boolean quantityReceivedSealed{get;set;}
        public boolean isReturnNotReqested{get;set;}
        public boolean isManufacturingSite {get;set;}
        
        public boolean isVC {get;set;}
          
        public Product_Complaint_Product_View (ApexPages.StandardController controller){
      //    PCP = (Product_Complaint_Product__c) controller.getRecord();
      //    System.debug('Case value is-------------------->' + PCP.Case__c);
        this.objectID = ApexPages.currentPage().getParameters().get('Id');
        VCOnly = false;
        quantityToBeReturned  = false;
        valueExist = false;
        this.isClosed = true;
        this.isEMEAorAPAC = false;
        this.isPharma  = false;
        this.isPrroxideSystem = false;
        isLencTypeUsed   = false;
        isVC  = false;
        isManufacturingSite  = false;
        init();
        }
        
        public Pagereference init()
        {
            PCP = [select id,name,Delete_Trigger__c,Product_Lot_Number__c,Justification_for_No_Product_Return__c,Primary_and_Second_Lot__c,Lens_Type_Used__c,Peroxide_System_Lens_Case_Returned__c ,Carton_Lot_Number__c,Product_Description__c,Private_Label_Account__c,
                          Case__c,Expiration_Date__c,Manufacturing_Site__c,Product_Type__c,Complaint_Quantity__c,Product_Availability__c,
                          Date_Received_Subsidiary__c,Time_in_Use__c,Quantity_Received__c,Quantity_to_be_Returned__c,Quantity_Received_Sealed__c,
                          Date_Received__c,Serial_Number__c ,Quantity_Received_Open__c,Product_Number__c,Fill_Size__c,Initial_Request_for_Product__c,Labeled_Base_Curve__c,Labeled_Power__c,Labeled_Cylinder__c,Date_of_Manufacture__c,Record_Type__c,
                          Labeled_Axis__c,Comments__c,Case__r.Product_Category__c,Case__r.Status,Case__r.Line_of_Business__c,Case__r.Send_to_CATSWeb__c,Local_Comments__c,Case__r.RecordType.name,Case__r.RecordTypeid
                          from Product_Complaint_Product__c where Id = :objectID];
       
          
           if(PCP.Manufacturing_Site__c!=null && PCP.Manufacturing_Site__c!=''){
               isManufacturingSite  = true;
           }else
           {
               isManufacturingSite   = false;
           }
          
          if(PCP.Product_Description__c!='' && PCP.Product_Description__c!=null)
          valueExist = true;
 
          if(PCP.Case__r.RecordType.name.contains('EMEA') || PCP.Case__r.RecordType.name.contains('APAC'))
          {
            isEMEAorAPAC= true;
          } 
          if(PCP.Case__r.Status == 'Closed') 
            this.isClosed = false;    
            
        return null;
        }
           
      
      public pagereference DeleteRecord(){          
            if(PCP.Case__r.status !='Open'){
                if(!test.isRunningTest())                    
                ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Once a Product Complaint has been closed, no additional changes may be made. The Product Complaint can be reopened in CATSWeb.'));
                return null;
            }
            else{
                if(PCP.Case__r.Send_to_CATSWeb__c == 'Yes'){
                    if(!test.isRunningTest())  
                    Delete_from_CATSWeb_Batch.sendRequest(PCP.id,'Product_Complaint_Product__c',PCP.Record_Type__c);                                                  
                }
                PCP.Delete_Trigger__c = true;
                try{
                    update PCP;
                    system.debug('Update :'+PCP);
                    delete PCP;
                }Catch(Exception e){
                }
                    
            }           
            pagereference page = new pagereference('/'+PCP.Case__c);
            page.setRedirect(true);
            return page;                                            
      }       
}