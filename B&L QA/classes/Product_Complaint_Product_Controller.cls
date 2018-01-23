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
public with sharing class Product_Complaint_Product_Controller {

          public Product_Complaint_Product__c PCP {get; set;}

          public string Bunit {get;set;}
          public list<Product_Complaint_Product_Type__c> AllProdType ;
          public Set<String> AllLocalName;
          public Set<String> AllManufacturing_Site;
          public list<Case> cc;
          public String one;
          public boolean isInit;
          public string LocalName {get; set;}
          public string SiteName {get; set;}
          public boolean valueExist {get; set;}
          public boolean isReturned {get; set;}
          public boolean inputReturned{get; set;}
            
          public boolean isAccount {get; set;}

          public boolean isEMEAorAPAC {get; set;}
          public boolean isNotReturned {get; set;}
          
          // Added by vijay
          public boolean isCartonLotNumber {get;set;}
          public boolean isRequested {get;set;}
          public boolean timeInUse {get;set;}
          public boolean quantityToBeReturned {get;set;}
          public boolean dateReceivedSubsidiary {get;set;}
          public boolean quantityReceivedOpen {get;set;}
          public boolean quantityReceivedSealed {get;set;}
          public boolean isProductNumber {get;set;}


          public boolean isPrimaryPackLotNum {get;set;}
          public boolean isFillSize {get;set;}
          public boolean isDisappearOutpanal {get;set;}
          public boolean isReturnNotReqested {get;set;}
                    
          String one1;                              
          
          public Product_Complaint_Product_Controller (ApexPages.StandardController controller){

                PCP = (Product_Complaint_Product__c) controller.getRecord();
                System.debug('Case value is-------------------->' + PCP.Case__c);
                System.debug('Case value is-------------------->' + PCP.RecordTypeId);
            //    System.debug('Record type is-------------------->' + PCP.Record_Type__c);
           //       this.isReq = true;
                init();            
           }
        
         /*Get all  Local Names for product description*/
         public List<SelectOption> getLocalNames() {
              List<SelectOption> localVal = new List<SelectOption>();
              localVal.add(new SelectOption('','--None--'));
              System.debug('AllLocalName'+AllLocalName);
              if(!AllLocalName.isEmpty())
              {
                list<String> AllLocVals = new list<String>();
                System.debug('AllLocalName'+AllLocalName);
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
               system.debug('AllManufacturing_Site'+AllManufacturing_Site);
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
            isCartonLotNumber = true;           

            isReturned = false;
            this.isNotReturned = true;
            this.isRequested  = false;
            timeInUse = true;
            quantityToBeReturned = false;
            dateReceivedSubsidiary = true;
            quantityReceivedOpen = true;
            quantityReceivedSealed = true;
            isProductNumber = false;

           
            isPrimaryPackLotNum = false;
            isFillSize = false;

            isDisappearOutpanal = false;
            isReturnNotReqested = false;
            isAccount = false;

            valueExist = true;
            isInit = false;
            this.isEMEAorAPAC = false;
             AllLocalName = new Set<String>();
             AllManufacturing_Site = new Set<String>();
            
              cc = [select id ,CaseNumber,Business_Unit__c,Product_Category__c ,Line_of_Business__c,Contact_Type__c,Complaint_Type__c,RecordTypeId ,
                               RecordType.name  from Case where Id = :PCP.Case__c];
                               System.debug('ddddddddddd'+cc);
         //try{ 
              list<Product_Complaint_Product__c> Allprod = [select id,Justification_for_No_Product_Return__c, name,Product_Description__c,Manufacturing_Site__c,Product_Type__c,Local_Comments__c,Record_Type__c
                                                    from Product_Complaint_Product__c where Case__c =:PCP.Case__c ORDER BY CreatedDate  DESC limit 1];
               System.debug('Product_Complaint_Product__c'+Product_Complaint_Product__c.Case__c);
                System.debug('Product_Complaint_Product__c'+PCP.Case__c);
             System.debug('result------------------->' + Allprod);
             System.debug('cc[0].Business_Unit__c'+cc[0].Business_Unit__c);



              //System.debug('Allprod Manufacturing Site'+Allprod[0].Manufacturing_Site__c);
              Bunit = cc[0].Business_Unit__c;
                                             
                
                
                
                                                   
                 if(cc[0].Contact_Type__c == 'Private Label Account'){
                    isAccount = true;
                 }
                                                                                
                 if(cc[0].RecordType.name.contains('EMEA') || cc[0].RecordType.name.contains('APAC')){
                    isEMEAorAPAC= true;
                 }
                 
                 AllProdType = [select id,name,Business_Unit__c,Category__c,Local_Name__c,Global_Name__c 
                                                                                  from Product_Complaint_Product_Type__c 
                                                                       where Business_Unit__c =:cc[0].Business_Unit__c 
                                                                        and Category__c = :cc[0].Product_Category__c ];
                 
                                                 
                 if(!AllProdType.isEmpty())
                 {
                    for(Product_Complaint_Product_Type__c pt : AllProdType)
                    {
                        AllLocalName.add(pt.Local_Name__c);
                    }
                 }
                                                                
            
             if(!Allprod.isEmpty())
             {
                if(Allprod[0].Product_Description__c!='' && Allprod[0].Product_Description__c!=null)
                {
                    isInit = true;
                    one = Allprod[0].Product_Description__c;
                    LocalName =Allprod[0].Product_Description__c;

                }
                 if(Allprod[0].Manufacturing_Site__c!=null && Allprod[0].Manufacturing_Site__c!='')
                 {                  
                    getGlobalName();
                    valueExist = true;
                    SiteName = Allprod[0].Manufacturing_Site__c;
                    
                 }                  
             }
                    
         //}catch(exception ex){
            
         //}                          
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
                                                         where Local_Name__c =:one and Business_Unit__c =:Bunit and Category__c =:cc[0].Product_Category__c
                                                         and Line_of_Business__c =:cc[0].Line_of_Business__c]; 
           
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
            system.debug('&&&&&&&&&&&&Bunit'+Bunit);
            list<Product_Complaint_Product_Type__c>  AllGlobalName = [select id,Global_Name__c from Product_Complaint_Product_Type__c 
                                                         where Local_Name__c =:one and Business_Unit__c =:Bunit]; 
            system.debug('&&&&&&&&&&&&'+AllGlobalName);

            
            for(Product_Complaint_Product_Type__c pp :AllGlobalName)
            {
                if(pp.Global_Name__c!=null)
                {
                    PCP.Product_Type__c = pp.Global_Name__c; 
                    return null;
                }
            }
            
         system.debug('&&&&&&&&&&&&one'+one);   
         PCP.Product_Type__c = one;
            return null;
         } 
         
         public Pagereference cancelmethod()
         {
            Pagereference newpage = new Pagereference('/'+cc[0].Id);
            newpage.setRedirect(false);
            return newpage;
         }
         
      public Boolean InsertRecord()
      {
        Date todayDate = System.today();
       try{
              PCP.Product_Description__c = LocalName;
            if(valueExist==true && SiteName==null){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Manufacturing Site: You must enter a value');
             ApexPages.addMessage(myMsg);
             return false;
            }
            if(PCP.Product_Description__c==null ||PCP.Product_Description__c==''){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Product Description: You must enter a value');
             ApexPages.addMessage(myMsg);
             return false;
            }            
    
             if(PCP.Product_Availability__c == 'returned' && (PCP.Date_Received__c ==null && PCP.Date_Received_Subsidiary__c ==null)){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'For Product Availability Returned: You must enter a value for Date Received or Date Received Subsidiary');
             ApexPages.addMessage(myMsg);
             return false;              
            } 
             if(PCP.Serial_Number__c ==null && PCP.Product_Lot_Number__c ==null){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'You must enter a value for Product Lot Number OR Serial Number ');
             ApexPages.addMessage(myMsg);
             return false;              
            } 
             if(PCP.Date_Received__c > todayDate || PCP.Date_Received_Subsidiary__c >todayDate){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Date Received or Date Received Subsidiary can not be greater than today');
             ApexPages.addMessage(myMsg);
             return false;              
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
      
            
       insert PCP;
       
       }catch(exception ex){

       }   
       return true;     
      }
         public Pagereference savemethod()
         {                        
           
              /*  if(one1=='Requested'){
                    if(PCP.Initial_Request_for_Product__c > system.today()){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Initial Request for Product should not be greater than today date.'));  
                        return null;
                    }    
                }
                if(PCP.Primary_and_Second_Lot__c==null && PCP.Product_Availability__c=='Returned'){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Primary and Secondary Pkg - Same Lot # is required.'));  
                    return null;
                }
            */
                                    
            system.debug('Text is for checkign execution---'); 
            Boolean pp = InsertRecord();
            if(pp)
           {          
                Pagereference newpage = new Pagereference('/'+cc[0].Id);
                newpage.setRedirect(true);
                return newpage;
            }
            else 
            return null;
            
         }
     
       public Pagereference SaveAndNewMethod()
       {
          Boolean pp = InsertRecord();
          if(PP)
          {
              //NEED TO GET THE PHONE NUMBER ID FROM THE CUSTOM SETTING   
              String caseFieldId;     
              CATSWeb_Resources__c cwVars = CATSWeb_Resources__c.getInstance();
              caseFieldId = cwVars.Product_Case_Number_Field_ID__c;
              
              //system.debug('****************** Case Number Field ID: ' + caseFieldId + '*******************');
        
              String aa = cc[0].Id;
              aa= aa.subString(0,15);
              String pageUrl = '/apex/Product_Complaint_Product_New?CF' + caseFieldId + '=' + cc[0].CaseNumber;
              pageUrl = pageUrl + '&CF' + caseFieldId + '_lkid='+ aa+'&RecordType='+PCP.RecordTypeId +'&scontrolCaching=1&retURL=%2F'+aa +  '&sfdc.override=1';
                                                                 
              Pagereference newPage = new Pagereference(pageUrl);
              newpage.setRedirect(true);
              return newpage;           
          }
          else 
          {
            return null;
          }

          
       }
         
         public void requiredSwitch()
         {
            one1 = Apexpages.currentPage().getParameters().get('first');
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
 /*
    public RecordType Product_RecordTypeId(string Case_RecordType_Name)
    {
        string query = 'select id,name from recordType where sObjectType =\'' +'Product_Complaint_Product__c'+ '\' and name =\'';
        if(Case_RecordType_Name =='NA VC Product Case'){
            query += 'NA VC Product\'';
        }
        if(Case_RecordType_Name =='NA PH Product Case'){
            query += 'NA PH Product\'';
        }
        if(Case_RecordType_Name =='EMEA VC Product Case'){
            query += 'EMEA VC Product\'';
        }
        if(Case_RecordType_Name =='APAC VC Product Case'){
            query += 'APAC VC Product\'';
        }
        if(Case_RecordType_Name =='APAC PH Product Case'){
            query += 'APAC PH Product\'';
        }
        if(Case_RecordType_Name =='APAC SU Product Case'){
            query += 'APAC SU Product\'';
        }
        query += ' limit 1';                                    
        list<RecordType> CaseRecordType = Database.query(query);
        System.debug('Result is ------>' +CaseRecordType); 
        
        return CaseRecordType[0];
    }        
*/
}