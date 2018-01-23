/*
* Created By : Rohit Aggarwal
* Test Class Name : Test_Product_Complaint_Controller
* Used for Product object to make it dynamic
*
*/
/*
* Updated By : Jennie Burns - 03/06/2013 - GCM - 207356
* For Pharma - Adverse Event Complaints that dont go to CATSWeb - default required fields
*
*/
public class Product_Complaint_Product_Edit  {

      public Product_Complaint_Product__c PCP {get; set;}
      public boolean isReturned {get; set;}
      public boolean inputReturned{get; set;}
      public string objectID;
      public boolean valueExist {get;set;}
      public list<Product_Complaint_Product_Type__c> AllProdType ;
      public Set<String> AllLocalName;
      public Set<String> AllManufacturing_Site;
      public string LocalName {get; set;}
      public string SiteName {get; set;}
      public String one;
      public boolean isInit;
      public boolean isLot {get; set;}
      public boolean isAccount {get; set;}
      public boolean reason {get; set;}
      public boolean reasonPrior {get; set;}
      public boolean isResnRequire {get; set;}
      public boolean isEMEAorAPAC {get; set;}
      public boolean isClosed {get; set;}
      public boolean isNotClosed {get; set;}
      public boolean isNotReturned {get; set;}
      public boolean isFillSize  {get;set;}
      public boolean isPrimaryPackLotNum {get;set;}    
      public boolean quantityToBeReturned {get;set;}
      public boolean dateReceivedSubsidiary {get;set;}
      public boolean quantityReceivedOpen {get;set;}
      public boolean quantityReceivedSealed{get;set;}
      public boolean isReturnNotReqested{get;set;}
      public boolean isRequested{get;set;}
      public boolean isProductNumber {get;set;}
      public boolean isDisappearOutpanal {get;set;}
     
          
      public Product_Complaint_Product_Edit (ApexPages.StandardController controller)
      {
        this.objectID = ApexPages.currentPage().getParameters().get('Id');

       
        init();
      } 
         /*Get all  Local Names for product description*/
     public List<SelectOption> getLocalNames() 
     {
              List<SelectOption> localVal = new List<SelectOption>();
              localVal.add(new SelectOption('','--None--'));
              if(!AllLocalName.isEmpty())
              {
                list<String> AllLocVals = new list<String>();
                AllLocVals.addall(AllLocalName);
        
                for( integer i=0;i<AllLocVals.size();i++)
                localVal.add(new SelectOption(AllLocVals[i], AllLocVals[i]));
              }
              localVal = sortOptionList(localVal);    
              return localVal;
      }
           
          /*Get all Manufacturing sites*/
       public List<SelectOption> getManSites() 
       {
               List<SelectOption> manSite = new List<SelectOption>();
               if(!AllManufacturing_Site.isEmpty())
               {
                 list<String> AllSiteVals = new list<String>();
                 AllSiteVals.addall(AllManufacturing_Site); 
                 if(AllSiteVals.size()==1)
                 {
                    manSite.add(new SelectOption(AllSiteVals[0], AllSiteVals[0]));
                 }
                 else
                 {
                    manSite.add(new SelectOption('','--None--'));
                    for( integer i=0;i<AllSiteVals.size();i++)
                      manSite.add(new SelectOption(AllSiteVals[i], AllSiteVals[i]));
                 }               
               }
               return manSite;
         } 
                    
       
      public Pagereference init()
      {    
             this.reason = false;
             quantityToBeReturned=false;
            this.reasonPrior = false;
            this.isResnRequire = false;

            isReturned = false;
            this.isNotReturned = true;
            isLot = false;
            isAccount = false;

            valueExist = false;
            isInit = false;
            this.isEMEAorAPAC = false;
            this.isClosed = false;
            this.isNotClosed = false;
            isFillSize   = false;


            isProductNumber = false;
            isDisappearOutpanal = false;
        AllLocalName = new Set<String>();
        AllManufacturing_Site = new Set<String>();
        
            PCP = [select id,name,Product_Lot_Number__c,Product_Number__c ,Justification_for_No_Product_Return__c ,Peroxide_System_Lens_Case_Returned__c,Carton_Lot_Number__c,Initial_Request_for_Product__c ,Fill_Size__c ,Primary_and_Second_Lot__c,Lens_Type_Used__c,Product_Description__c,Private_Label_Account__c,
                          Case__c,Expiration_Date__c,Manufacturing_Site__c,Product_Type__c,Complaint_Quantity__c,Product_Availability__c,
                          Date_Received_Subsidiary__c,Time_in_Use__c,Quantity_Received__c,Quantity_to_be_Returned__c,Quantity_Received_Sealed__c,
                          Date_Received__c,Serial_Number__c,Quantity_Received_Open__c,Labeled_Base_Curve__c,Labeled_Power__c,Labeled_Cylinder__c,
                          Case__r.Contact_Type__c,Date_of_Manufacture__c,Reason_for_Edit__c,Reason_for_Edit_Prior_Value__c,Case__r.Send_to_CATSWeb__c,Local_Comments__c,
                          Labeled_Axis__c,Comments__c,Case__r.Product_Category__c,Case__r.Business_Unit__c,Case__r.Line_of_Business__c,
                          Case__r.RecordType.name,Case__r.RecordTypeid,Record_type__c,Recordtypeid,Case__r.Status  from Product_Complaint_Product__c where Id = :objectID];
                          
           if(PCP.Case__r.Status == 'Closed')
           { 
                 this.isClosed = true;
                 this.isNotClosed = false;    
                return null;
            }
            else{
                 this.isClosed = false;
                 this.isNotClosed = true; 
            }

            if(PCP.Product_Description__c!='' && PCP.Product_Description__c!=null)
            {
               isInit = true;
               one=PCP.Product_Description__c;
               LocalName =PCP.Product_Description__c;
            }
            
             if(PCP.Case__r.RecordType.name.contains('EMEA') || PCP.Case__r.RecordType.name.contains('APAC')){
                isEMEAorAPAC= true;
             }   
             if(PCP.Case__r.Send_to_CATSWeb__c=='Yes') {
                 reason = true;
                 reasonPrior = true;
             }           
             if(PCP.Case__r.Send_to_CATSWeb__c=='Yes' && isEMEAorAPAC == false){
                    isResnRequire = true;               
             }
             try{                 
              AllProdType = [select id,name,Business_Unit__c,Category__c,Local_Name__c,Global_Name__c 
                                                                                  from Product_Complaint_Product_Type__c 
                                                                       where Business_Unit__c =:PCP.Case__r.Business_Unit__c 
                                                                        and Category__c = :PCP.Case__r.Product_Category__c ];                
                
                 if(!AllProdType.isEmpty())
                 {
                    for(Product_Complaint_Product_Type__c pt : AllProdType)
                    {
                        AllLocalName.add(pt.Local_Name__c);
                    }
                 }
                  
                 if(PCP.Manufacturing_Site__c!=null && PCP.Manufacturing_Site__c!=''){
                    
                    getGlobalName();
                    valueExist = true;
                    SiteName = PCP.Manufacturing_Site__c;
                    
                 }
                 
         }catch(exception ex){
            
         }                          
                 return null;
            
                                
      }
   
    public Pagereference getGlobalName()
         {
            SiteName =null;
            if(!isInit)
            one = Apexpages.currentPage().getParameters().get('one');
            System.debug('Value of local one is--------------------->' + one);
            isInit = false;
            list<Product_Complaint_Product_Type__c>  AllManSites = [select id,Global_Name__c,Manufacturing_Site__c 
                                                         from Product_Complaint_Product_Type__c 
                                                         where Local_Name__c =:one and Business_Unit__c =:PCP.Case__r.Business_Unit__c 
                                                         and Category__c =:PCP.Case__r.Product_Category__c
                                                         and Line_of_Business__c =:PCP.Case__r.Line_of_Business__c]; 
           
            System.debug('Man site size is--------------->' +AllManSites.size());
            AllManufacturing_Site = new Set<String>();
            
            if(!AllManSites.isEmpty())
            {
                valueExist = true;
                for(Product_Complaint_Product_Type__c p1 :AllManSites)
                {
                    AllManufacturing_Site.add(p1.Manufacturing_Site__c);
                }
            } else{
                valueExist = false;
            }
            
            list<Product_Complaint_Product_Type__c>  AllGlobalName = [select id,Global_Name__c from Product_Complaint_Product_Type__c 
                                                         where Local_Name__c =:one and Business_Unit__c =:PCP.Case__r.Business_Unit__c]; 
            for(Product_Complaint_Product_Type__c pp :AllGlobalName)
            {
                if(pp.Global_Name__c!=null)
                {
                    PCP.Product_Type__c = pp.Global_Name__c;
                   
                    return null;
                }
            }
         PCP.Product_Type__c = one;
            return null;
         }      
     public Pagereference savemethod()
     {
        Date todayDate = System.today();
       try{
            PCP.Product_Description__c = LocalName;
            if(valueExist==true && SiteName==null){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Manufacturing Site: You must enter a value');
             ApexPages.addMessage(myMsg);
            return null;
            }
            if(PCP.Product_Description__c==null ||PCP.Product_Description__c==''){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Product Description: You must enter a value');
             ApexPages.addMessage(myMsg);
            return null;
            }            
    
             if(PCP.Product_Availability__c == 'returned' && (PCP.Date_Received__c ==null && PCP.Date_Received_Subsidiary__c ==null)){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'For Product Availability Returned: You must enter a value for Date Received or Date Received Subsidiary');
             ApexPages.addMessage(myMsg);
             return null;              
            } 
             if(PCP.Serial_Number__c ==null && PCP.Product_Lot_Number__c ==null){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'You must enter a value for Product Lot Number OR Serial Number ');
             ApexPages.addMessage(myMsg);
             return null;             
            } 
             if(PCP.Date_Received__c > todayDate || PCP.Date_Received_Subsidiary__c >todayDate){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Date Received or Date Received Subsidiary can not be greater than today');
             ApexPages.addMessage(myMsg);
             return null;             
            }            
            PCP.Manufacturing_Site__c = SiteName;  
                     
            if(PCP.Complaint_Quantity__c!=null)
            PCP.Complaint_Quantity_Int__c = String.valueOf(math.round(PCP.Complaint_Quantity__c));
            if(PCP.Quantity_Received__c!=null)
            PCP.Quantity_Received_Int__c = String.valueOf(math.round(PCP.Quantity_Received__c));
            if(PCP.Quantity_Received_Open__c!=null)
            PCP.Quantity_Received_Open_Int__c = String.valueOf(math.round(PCP.Quantity_Received_Open__c));
            if(PCP.Quantity_Received_Sealed__c!=null)
            PCP.Quantity_Received_Sealed_Int__c = String.valueOf(math.round(PCP.Quantity_Received_Sealed__c));
            if(PCP.Quantity_to_be_Returned__c!=null)
            PCP.Quantity_to_be_Returned_Int__c = String.valueOf(math.round(PCP.Quantity_to_be_Returned__c));
            
             /* Assign record type according to case record type*/
        /*
          if(cc[0].RecordTypeId!= null)
            {
                list<RecordType> AllprodRec = new list<RecordType>([select id,name from RecordType where id = :cc[0].RecordTypeId]);
                
                System.debug('---------AllprodRec ------------------------'+AllprodRec);
                
                if(AllprodRec[0].name=='NA SU Product Case' || AllprodRec[0].name=='NA SU Product Case Read Only')
                {
                    PCP.Record_Type__c ='NA SU Product';
                }
                else if(AllprodRec[0].name=='EMEA SU Product Case' || AllprodRec[0].name=='EMEA SU Product Case Read Only')
                {
                    PCP.Record_Type__c ='EMEA SU Product';
                }
            }
        
           if(PCP.RecordTypeId == null)
            {
                list<RecordType> AllprodRec1 = new list<RecordType>([select id,name from RecordType where name = :PCP.Record_Type__c and sobjecttype =:'Product_Complaint_Product__c']);
                PCP.RecordTypeid = AllprodRec1[0].id;
            }
        */
          update PCP;
         }catch(exception ex){

         }   
          Pagereference newpage = new Pagereference('/'+PCP.Case__c);
            newpage.setRedirect(true);
            return newpage;
      }
      
        
         public void requiredSwitch()
         {
            String one1 = Apexpages.currentPage().getParameters().get('first');
            system.debug('one1 one1 --->'+one1 );
         // System.debug('value is-------------------->' + Allprod );
            if(one1 =='Returned'){
                this.isReturned = true  ;
                this.isRequested= false;
                this.isNotReturned = false  ;
                this.isReturnNotReqested= false; 
                quantityToBeReturned=false; 
                inputReturned=true;              
            }
           
              else if(one1=='Requested'){
                     quantityToBeReturned=true;
                     inputReturned=false; 
                      isReturned = false;
                      isNotReturned = true ;
                     isReturnNotReqested  = false;                                          
                 }else if(one1 =='Return not Required'){
                     isReturned= false;
                     inputReturned=false;
                     isNotReturned = true ;
                     quantityToBeReturned=false;                                                           
                     isReturnNotReqested  = true  ;                      
                 }else if(one1=='Not Available'){
                     isReturned = false;
                     isNotReturned = true ;
                     inputReturned=false;
                     quantityToBeReturned=false;
                     isReturnNotReqested  = false;
                 }
                 else if(one1=='None'){
                     isReturned = false;
                     isNotReturned = false;
                     inputReturned=false;
                     quantityToBeReturned=false;
                     isReturnNotReqested  = false;
                 }                     
            
                              
             //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, one1);
             //ApexPages.addMessage(myMsg);           
             //return null;
         }
    // Sorting of select list
    public static List<SelectOption> sortOptionList(List<SelectOption> ListToSort)  {
        
        if(ListToSort == null || ListToSort.size() <= 1) {
            return ListToSort;                  
        }
        
        List<SelectOption> Less = new List<SelectOption>();     
        List<SelectOption> Greater = new List<SelectOption>();  
            
        integer pivot = 0;              
        // save the pivot and remove it from the list       
        SelectOption pivotValue = ListToSort[pivot];        
        ListToSort.remove(pivot);               
        for(SelectOption x : ListToSort) {          
            if(x.getLabel().compareTo(pivotValue.getLabel()) <= 0) {
                Less.add(x);
            } else if(x.getLabel().compareTo(pivotValue.getLabel()) > 0) {
                Greater.add(x);
            }   
        }       
        List<SelectOption> returnList = new List<SelectOption> ();      
        returnList.addAll(SortOptionList(Less));
        returnList.add(pivotValue); 
        returnList.addAll(SortOptionList(Greater)); 
        
        return returnList; 
    }                
 
}