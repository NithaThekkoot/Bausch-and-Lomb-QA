public with sharing class ConsignmentInventorySearch {

    // Declaration global variable
    public Consignment_Search_Data__c objectConsignementSearchDate {get;set;} 
    public string type {get;set;}
    public string productName {get;set;}
    public string shipTo {get;set;}
    public string serialNumber {get;set;}
    public string ProductId {get;set;}
    public string AccountName {get;set;}
    public boolean serchSection {get;set;}
    public boolean showSearchResult {get;set;}
    public boolean isShowBlanklist {get;set;}
    public string divVisibility {get;set;}
    public string isShowRequiredFieldMessage {get;set;}
    public boolean isShowRequiredField {get;set;}
    // To create picklist using Salesforce Schemas .
    
    public string inputHiddenserialNumber {get;set;}
    public string inputHiddenProductGroup {get;set;}
    public string inputHiddenpProductId {get;set;}
    public string inputHiddenExpirationStartDate {get;set;}
    public string inputHiddenExpirationEndDate {get;set;}
    
    public List<selectoption> lstProductGroup {get;set;}
    
    
    public string pageHeaderValue {get;set;}    
        
    // Boolean varible to show and hide controlls !
    //public boolean isClearSearchFieldBtn {get;set;}
    public boolean isModifySearchFieldBtn {get;set;}
    public boolean isClearSearchFieldRenderBtn {get;set;}
    public boolean isModifySearchFieldRenderBtn {get;set;}   
    public boolean isSearchConsignmmentBtn {get;set;}
    public boolean isSearchConsignmmentRenderBtn {get;set;}
    public boolean isSearchBillConsignmentBtn {get;set;}
    public boolean isSearchBillConsignmentRenderBtn {get;set;}
    public boolean isSearchTransactionSearchBtn {get;set;}
    public boolean isSearchTransactionSearchRenderBtn {get;set;}
    public boolean isSearchunbilledConsignmentBtn {get;set;}
    public boolean isSearchunbilledConsignmentRenderBtn {get;set;}
    public boolean isCancelSearchRenderBtn {get;set;}     
    public string msgAccountNotFound {get;set;}
    public boolean isAccountNull {get;set;}
    public boolean isAccountName {get;set;}    
    public boolean disableField {get;set;}
    public boolean isExport {get;set;}    
    public boolean isSerialNumberRequired {get;set;}
    public boolean isShowSearchBtn {get;set;}
    
    public boolean pageBolckSectionEditable {get;set;}
    public boolean pageBolckSectionReadOnly {get;set;}
    public boolean isworking {get;set;}
    
    public string accountId {get;set;}
    public string consignmentLocation ;
    public string setId ;
    Account objectAccount ;
    
    
    public string listViewId {get;set;}
    public string listViewBlankId {get;set;}
    List<selectOption> lstSelectOption = new List<selectOption>();
    
    public ConsignmentInventorySearch(ApexPages.StandardSetController controller) {
        
        try{
        isworking = false;      
        lstProductGroup = new List<selectOption>();   
        lstSelectOption = controller.getListViewOptions();               
        system.debug('lstSelectOption'+lstSelectOption);
        for(selectOption level :lstSelectOption){
            if(level.getLabel() == 'Search Result'){
                string Char15Id = level.getvalue();
                listViewId = Char15Id.substring(0,15);
            }
            if(level.getLabel() == 'Search Results'){
                string Char15Id = level.getvalue();
                listViewBlankId = Char15Id.substring(0,15);
            }
        }
        system.debug('listViewId :-> '+listViewId);
        system.debug('listViewBlankId :-> '+listViewBlankId ); 
        init(); 
        init1ByParameterList();
        accountName();          
      }Catch(Exception e){}
                
    }
    
    public void TogetListViewIds(string listViewName,string listviewBlank){
        system.debug('&&&&&&&&&&&&&&&&&&&&&lstSelectOption'+lstSelectOption);
        for(selectOption level :lstSelectOption){
            if(level.getLabel() == listViewName){
                string Char15Id = level.getvalue();
                listViewId = Char15Id.substring(0,15);
            }
            if(level.getLabel() == listviewBlank){
                string Char15Id = level.getvalue();
                listViewBlankId = Char15Id.substring(0,15);
            }
        }
        system.debug('listViewId :-> '+listViewId);
        system.debug('listViewBlankId :-> '+listViewBlankId ); 
    }
    
    public void disableAllBtnOnLoad(){
        isShowSearchBtn = false ;
        isModifySearchFieldBtn = true;
        isSearchConsignmmentBtn = true;
        isSearchBillConsignmentBtn = true;
        isSearchTransactionSearchBtn = true;
        isSearchunbilledConsignmentBtn = true;
        isCancelSearchRenderBtn = true; 
    }   
    
    public void showSearchButtons(){
        string val = isNotNullDate();
        if(val != ''){
             pageMessage('error',val);
             return;
        } 
           
        isShowSearchBtn = true;
        isModifySearchFieldBtn = false;
        isCancelSearchRenderBtn = false;
        if(shipTo  != null && shipTo  != ''){ 
            shipToIdNotBlank();           
        }else{
            shipToIdBlank();    
        }
        changeType();
        if(shipTo!='' && productName!='All'){
              checkCriteriaForAllFieldChanginValue();
         }
        if(shipTo!='' && ProductId!=''){
                checkCriteriaForAllFieldChanginValue();                
        }
        if(shipTo!='' && objectConsignementSearchDate.Expiration_Start_Date__c!=null){
                checkCriteriaForAllFieldChanginValue();
        }
        if(shipTo!='' && objectConsignementSearchDate.Expiration_End_Date__c!=null){
                checkCriteriaForAllFieldChanginValue();
        }
        system.debug('&&&&&&&&&&&'+ProductId);
        system.debug('&&&&&&&&&&&'+serialNumber);
        
        /*
        if(serialNumber=='' && ProductId=='' && objectConsignementSearchDate.Expiration_Start_Date__c==NULL && objectConsignementSearchDate.Expiration_End_Date__c==NULL){
            isSearchTransactionSearchBtn = true;
        }else{
            isSearchTransactionSearchBtn = false;
        }                
        if(shipTo!='' && ProductId!='' && serialNumber=='' && objectConsignementSearchDate.Expiration_Start_Date__c==NULL && objectConsignementSearchDate.Expiration_End_Date__c==NULL){
                checkCriteriaForAllFieldChanginValue();                
        }
        if(shipTo=='' && ProductId!='' && serialNumber=='' && objectConsignementSearchDate.Expiration_Start_Date__c==NULL && objectConsignementSearchDate.Expiration_End_Date__c==NULL){
                checkCriteriaForAllFieldChanginValue();
                isSearchConsignmmentBtn = true;                
        }
        if(shipTo!='' && ProductId=='' && serialNumber=='' && objectConsignementSearchDate.Expiration_Start_Date__c==NULL && objectConsignementSearchDate.Expiration_End_Date__c!=NULL){
                checkCriteriaForAllFieldChanginValue();
                isSearchTransactionSearchBtn = true;                
        }
        */                
    }
     
    public void init(){
        try{
        pageBolckSectionReadOnly = false;
        pageBolckSectionEditable = true;
        disableAllBtnOnLoad();        
        isShowBlanklist  = true ;
        divVisibility = 'hidden';
        serialNumber = '';
        ProductId = '';
        system.debug('lstSelectOption :'+listViewId);                        
        objectConsignementSearchDate  = new Consignment_Search_Data__c();
        
        accountId = ApexPages.currentPage().getParameters().get('accId');                
        objectAccount = [Select Id,Name,Consignment_Inventory_BU__c,Ship_To_Id__c,Consignment_Location__c,SETID__c from Account where Id=:accountId];
        consignmentLocation  = objectAccount.Consignment_Location__c ;
        setId = objectAccount.SETID__c ;
        shipTo =  objectAccount.Ship_To_Id__c ;
        system.debug('objectAccount :'+objectAccount);
        AccountName = objectAccount.Name ;       
        createSelectList();     
        }
        Catch(Exception e){
                
        }
    } 
    
    public void init1ByParameterList(){
        
        if(ApexPages.CurrentPage().getParameters().get('accid')!='' && ApexPages.CurrentPage().getParameters().get('accid')!=null){
                accountId = ApexPages.currentPage().getParameters().get('accId');
        }
        if(ApexPages.CurrentPage().getParameters().get('serialNumber')!='' && ApexPages.CurrentPage().getParameters().get('serialNumber')!=null){
                serialNumber = ApexPages.CurrentPage().getParameters().get('serialNumber');
        }
        if(ApexPages.CurrentPage().getParameters().get('productgroup')!='' && ApexPages.CurrentPage().getParameters().get('productgroup')!=null){
                productName = ApexPages.CurrentPage().getParameters().get('productgroup');
        }
        if(ApexPages.CurrentPage().getParameters().get('productId')!='' && ApexPages.CurrentPage().getParameters().get('productId')!=null){
                ProductId = ApexPages.CurrentPage().getParameters().get('productId');
        }
        if(ApexPages.CurrentPage().getParameters().get('expirationStDate')!='' && ApexPages.CurrentPage().getParameters().get('expirationStDate')!=null){
                system.debug('&&&&&&&&&:'+ApexPages.CurrentPage().getParameters().get('expirationStDate'));
                string[] ss = ApexPages.CurrentPage().getParameters().get('expirationStDate').split('/');
                Date startDate = date.newInstance(integer.valueOf(ss[2]),integer.valueOf(ss[0]), integer.valueOf(ss[1]));
                objectConsignementSearchDate.Expiration_Start_Date__c = startDate ;//date.valueOf(ApexPages.CurrentPage().getParameters().get('expirationStDate'));
        }
        if(ApexPages.CurrentPage().getParameters().get('expirationEndDate')!='' && ApexPages.CurrentPage().getParameters().get('expirationEndDate')!=null){
                system.debug('&&&&&&&&&:'+ApexPages.CurrentPage().getParameters().get('expirationEndDate'));
                string[] ss = ApexPages.CurrentPage().getParameters().get('expirationEndDate').split('/');
                Date EndDate = date.newInstance(integer.valueOf(ss[2]),integer.valueOf(ss[0]), integer.valueOf(ss[1]));
                objectConsignementSearchDate.Expiration_End_Date__c = EndDate;
        }
    }
    
    public void shipToIdBlank(){
        if(type=='Equal' && serialNumber!=''){
                isSearchConsignmmentBtn = false;
                isSearchBillConsignmentBtn = false;
                isSearchunbilledConsignmentBtn = false;
                isSearchTransactionSearchBtn = false;
                isSerialNumberRequired = true;           
                disableField  = true ;
                isAccountName = false;
        }
    } 
    
    public void shipToIdNotBlank(){
        system.debug('yes its inside the condition');
        isSearchBillConsignmentBtn = true;
        isSearchConsignmmentBtn = false;
        isSearchunbilledConsignmentBtn = false;
        isSerialNumberRequired = false ;
        isSearchTransactionSearchBtn = true;                    
        disableField = false ;
        isAccountName = true ;
    } 
   
   // Create select list for Serial Number type Equal and contains !
   public List<selectOption> op {get;set;}
   public void createSelectList(){
    op  = new List<selectOption>();
    if(objectAccount != null){    
        if(objectAccount.Ship_To_Id__c != null){
            op.add(new SelectOption('Equal','Equal'));
            op.add(new SelectOption('Contains','Contains'));
        }else{
            op.add(new SelectOption('Equal','Equal'));
        }  
       }   
   }
   
   // Repopulate Serial Number type when changing ship to ! 
   public void repopulateType(){
        op  = new List<selectOption>();
        op.add(new SelectOption('Equal','Equal'));
        op.add(new SelectOption('Contains','Contains'));
   }
       
   // To check the ship To character length !
   public integer checkShipToLength(string ShipToLength){           
        return ShipToLength.length();
   }    
   
   /*
   public void onChangeProductGroup(){
         if(shipTo!='' && productName!='All'){
              checkCriteriaForAllFieldChanginValue();
         }
   }
   
   public void changeProductId(){
         if(shipTo!='' && ProductId!=''){
                checkCriteriaForAllFieldChanginValue();
         }
   }
   
   public void onChangeStartDate(){
         if(shipTo!='' && objectConsignementSearchDate.Expiration_Start_Date__c!=null){
                checkCriteriaForAllFieldChanginValue();
         }
   }
   
   public void onChangeEndDate(){
         if(shipTo!='' && objectConsignementSearchDate.Expiration_End_Date__c!=null){
                checkCriteriaForAllFieldChanginValue();
         }
   }
   */
      
   public void checkCriteriaForAllFieldChanginValue(){
                if(type=='Equal' && serialNumber!=''){
                        isSearchBillConsignmentBtn = false;
                        isSearchConsignmmentBtn = false;
                        isSearchunbilledConsignmentBtn = false;
                        isSearchTransactionSearchBtn = false;
                }else{
                        isSearchBillConsignmentBtn = true;
                        isSearchConsignmmentBtn = false;
                        isSearchunbilledConsignmentBtn = true;
                        isSearchTransactionSearchBtn = true;            
                 }
   }
   
   // Popopate accound name based on the sarch ship to !     
   public pagereference accountName(){
        try{
          disableAllBtnOnLoad();
          checkShipToLength(shipTo); 
          system.debug('shipTo '+shipTo);          
          searchConsignmentInvokeCallout objsearchConsignmentInvokeCallout = new searchConsignmentInvokeCallout();
          if(objectAccount!=null){ 
                  IF(!TEST.isRunningTest()){
                    web_Service_Consignment_Search_ProductG.OutputData_element[] outPutElementProductGroup =   objsearchConsignmentInvokeCallout.searchConsignmentProductGroup(shipTo, objectAccount.Consignment_Inventory_BU__c) ;
                      system.debug('outPutElementProductGroup'+outPutElementProductGroup);
                      lstProductGroup = new List<selectoption>();
                      lstProductGroup.add(new SelectOption('All','All'));
                      if(outPutElementProductGroup != null){            
                        for(web_Service_Consignment_Search_ProductG.OutputData_element ss :outPutElementProductGroup){                      
                            lstProductGroup.add(new SelectOption(ss.PRODUCT_GROUP,ss.DESCR));
                        }
                      }
                  }                  
          }
           
          if(shipTo != null && shipTo != ''){                         
              List<Account> lstAccount = [select id,Name from Account where Ship_To_Id__c=:shipTo Limit 1];
              integer shipToLength = checkShipToLength(shipTo);
              if(shipToLength != 8){
                    //shipToIdNotBlank();
                    pageMessage('error','Ship To should be an 8-digit number !');
                    AccountName ='Invalid Ship To';                    
                    disableAllBtnsOnErrorMsg();
                    return null;
              }

              if(lstAccount.size()>0){
                  repopulateType();
                  //shipToIdNotBlank();
                  AccountName = lstAccount[0].Name ; 
                  isAccountName = true ;
                  isAccountNull = false ;             
              }else{
                  //shipToIdBlank();
                  //msgAccountNotFound = 'Ship To not found';
                  disableAllBtnsOnErrorMsg();
                  pageMessage('error','Ship To not found !');
                  AccountName = '';
                  isAccountNull = true ;
                  isAccountName = false;
              }                                  
          }else {
                op = new List<selectOption>();              //put value only Equal if ship to blank 
                op.add(new SelectOption('Equal','Equal'));
                //shipToIdBlank();               
                isAccountNull = false;
                isAccountName = false;
          }
        }Catch(exception ee){
            pageMessage('Error',ee.getMessage());
        } 
              return null;
   }
   
   // Make button enable disable based on the selected Searil Number Type 
   public pagereference changeType(){
       if(type == 'Contains' && serialNumber!=''){           
           isSearchConsignmmentBtn = false;
           isSearchBillConsignmentBtn = true;           
           isSearchunbilledConsignmentBtn = true;
           isSerialNumberRequired = true;
           isSearchTransactionSearchBtn = true;                  
       }else if(type == 'Equal' && serialNumber!=''){           
           isSearchConsignmmentBtn = false;
           isSearchBillConsignmentBtn = false;           
           isSearchunbilledConsignmentBtn = false;
           isSerialNumberRequired = false;        
           isSearchTransactionSearchBtn = false;        
       }else if(type == 'Equal' && serialNumber==''){           
           isSearchBillConsignmentBtn = true ;
           isSearchTransactionSearchBtn = true ;        
       }
       return null; 
   } 
        
   // Disable Enable search transaction button ! 
   public void enableSeachTransactionHistory(){
        changeType();                      
   }
     
   // Delete all consignment data !
   public void deleteAllConsignmentData(){
        List<Consignment_Search_Data__c> lstConsignmentSearchData = [select id from Consignment_Search_Data__c where User_ID__c =:UserInfo.getUserId() limit 10000];
        if(lstConsignmentSearchData.size()>0){
            delete lstConsignmentSearchData;
        }                     
   }
   
   // Delete All consignment data and invoke product group service to populate all products on page Load !
   public void deleteAllConsignmentDataAndpopulateProductGroupOnLoad(){
        try{
        system.debug('Check method invoke');
        searchConsignmentInvokeCallout objsearchConsignmentInvokeCallout = new searchConsignmentInvokeCallout();
        if(objectAccount!=null){
                if(!test.isRunningTest()){
                    web_Service_Consignment_Search_ProductG.OutputData_element[] outPutElementProductGroup =   objsearchConsignmentInvokeCallout.searchConsignmentProductGroup(shipTo, objectAccount.Consignment_Inventory_BU__c) ;
                    system.debug('outPutElementProductGroup Onload'+outPutElementProductGroup);
                    lstProductGroup = new List<selectoption>();
                    lstProductGroup.add(new SelectOption('All','All'));
                    if(outPutElementProductGroup != null){  
                        for(web_Service_Consignment_Search_ProductG.OutputData_element ss :outPutElementProductGroup){
                            lstProductGroup.add(new SelectOption(ss.PRODUCT_GROUP,ss.DESCR));
                        }
                    }
                }                                        
                system.debug('lstProductGroup Onload'+lstProductGroup);
                List<Consignment_Search_Data__c> lstConsignmentSearchData = [select id from Consignment_Search_Data__c where User_ID__c =:UserInfo.getUserId() limit 10000];
                system.debug('lstConsignmentSearchData'+lstConsignmentSearchData.size());
                if(lstConsignmentSearchData.size()>0){
                    delete lstConsignmentSearchData;
                }
        }
       }Catch(Exception ee){
        pageMessage('Error',ee.getMessage());
       }           
   }      
   
  
  public void cancelSearch(){
       isCancelSearchRenderBtn = false;
       isShowBlanklist = false; 
       showSearchResult = false; 
       isExport = false;  
       //isworking = false;    
  }     
   
   
   // Disble all button if any error occured !
   public void disableAllBtnsOnErrorMsg(){
        isSearchConsignmmentBtn = true ;
        isSearchBillConsignmentBtn = true;
        isSearchTransactionSearchBtn = true;
        isSearchunbilledConsignmentBtn = true;
   }
   
   
   // Delete consignment data and and make visibility read only list !
   public void modifySearch(){
       isworking = false;          
       deleteAllConsignmentData();                                      
       disableAllBtnOnLoad();       
       hideEnhanceListOnModifyAndClearSearch();       
       repopulateType();
       //serialNumber = '';
       type = 'equal';
       system.debug('opopopopop :'+op);
       pageBolckSectionEditable = true;
       pageBolckSectionReadOnly = false;
       //changeType();
       
   }
   
 
   
   // Show hide read only and editable enhance list !
   public void hideEnhanceListOnModifyAndClearSearch(){
       isShowBlanklist = false; 
       showSearchResult = false; 
       isExport = false; 
   }
   
   
   public void makeprogressMessage(){
         isworking = true ;      
   }
   
   public pagereference searchConsignment(){
           pageHeaderValue = 'SearchConsignmentResult';  
           string val = isNotNullDate();
           if(val != ''){
                pageMessage('error',val);
                return null;
           }                            
           TogetListViewIds('Search Consignment Result','Search Consignment Results');             
           system.debug('inputHiddenserialNumber :->'+inputHiddenserialNumber);
           if(inputHiddenserialNumber!=''){serialNumber = inputHiddenserialNumber ;}
           system.debug('serialNumber :->'+serialNumber);            
           try{
           if(type == 'Contains' && serialNumber==''){
                pageMessage('info','Required field missing !');
                return null;
           }else{   
               isCancelSearchRenderBtn = false;                                                                             
               DateTime d = Datetime.now();
               string formatedDate = string.valueOf(d.day()+'-'+ d.Month()+'-'+ d.year());
               string formatedTime = string.valueOf(d.hour()+':'+ d.minute() +':'+ d.second()); 
               string searchId = UserInfo.getUserId()+'_'+formatedDate+' '+formatedTime ;            
               system.debug('formatedDate :'+UserInfo.getUserId()+'_'+formatedDate+' '+formatedTime);  
               searchConsignmentInvokeCallout objsearchConsignmentInvokeCallout = new searchConsignmentInvokeCallout();
               Web_Service_Consignment_Search1.OutputData_element[] outPutElement ;
               if(ProductId!='' && ProductId!=null){
                ProductId = ProductId.toUpperCase();
               }
               system.debug('Check productId is upper case:>>>>>>'+ProductId);
               if(productName == 'All'){                  
                  outPutElement = objsearchConsignmentInvokeCallout.searchConsignment(shipTo,'',ProductId,serialNumber,objectConsignementSearchDate.Expiration_Start_Date__c,objectConsignementSearchDate.Expiration_End_Date__c,objectAccount.Consignment_Inventory_BU__c,UserInfo.getUserId(),searchId,'Search Consignment',setId,consignmentLocation);              
               }else {
                   system.debug('Expiration_Start_Date__c:->'+objectConsignementSearchDate.Expiration_Start_Date__c+'   Expiration_End_Date__c:->'+objectConsignementSearchDate.Expiration_End_Date__c);          
                   outPutElement = objsearchConsignmentInvokeCallout.searchConsignment(shipTo,productName,ProductId,serialNumber,objectConsignementSearchDate.Expiration_Start_Date__c,objectConsignementSearchDate.Expiration_End_Date__c,objectAccount.Consignment_Inventory_BU__c,UserInfo.getUserId(),searchId,'Search Consignment',setId,consignmentLocation);                                  
               }                  
               system.debug('RECORD_COUNT'+outPutElement[0].RECORD_COUNT); 
                   if(outPutElement[0].RECORD_COUNT > 0){
                           pageBolckSectionReadOnly = true;
                           pageBolckSectionEditable = false;    
                       system.debug('Record Greater Than Zero !');                     
                       isShowBlanklist  = false ;
                       showSearchResult  = true;
                       isExport  = true;
                   }else{
                       system.debug('Record Less Than Zero !');        
                       isShowBlanklist = true;
                       isExport = false;
                       divVisibility = 'visible';                              
                   }                          
             }
           }Catch(Exception e){
                          pageMessage('Error',e.getMessage());  
           }
           isworking = false ;
           isModifySearchFieldBtn = false;                  
           return null;
   }
  
  public pagereference searchBilledConsignment(){
           pageHeaderValue = 'SearchBilledConsignmentResult';
           string val = isNotNullDate();
           if(val != ''){
                        pageMessage('error',val);
                        return null;
           }                        
           TogetListViewIds('Search Billed Consignment Result','Search Billed Consignment Results');
           try{
           if(serialNumber == ''){
                pageMessage('error','Serial Number is required !');
                return null;
           }else { 
               isCancelSearchRenderBtn = false;     
               isworking = true ; 
               pageBolckSectionReadOnly = true;
               pageBolckSectionEditable = false;                             
               DateTime d = Datetime.now();
               string formatedDate = string.valueOf(d.day()+'-'+ d.Month()+'-'+ d.year());
               string formatedTime = string.valueOf(d.hour()+':'+ d.minute() +':'+ d.second()); 
               string searchId = UserInfo.getUserId()+'_'+formatedDate+' '+formatedTime ;            
               system.debug('formatedDate :'+UserInfo.getUserId()+'_'+formatedDate+' '+formatedTime);  
               searchConsignmentInvokeCallout objsearchConsignmentInvokeCallout = new searchConsignmentInvokeCallout();
               Web_Service_Consignment_Search1.OutputData_element[] outPutElement ;
               if(ProductId!='' && ProductId!=null){
                ProductId = ProductId.toUpperCase();
               } 
               if(productName == 'All'){                            
                   outPutElement = objsearchConsignmentInvokeCallout.searchConsignment(shipTo,'',ProductId,serialNumber,objectConsignementSearchDate.Expiration_Start_Date__c,objectConsignementSearchDate.Expiration_End_Date__c,objectAccount.Consignment_Inventory_BU__c,UserInfo.getUserId(),searchId,'Search Billed Consignment',setId,consignmentLocation);              
               }else{
                   system.debug('Expiration_Start_Date__c:->'+objectConsignementSearchDate.Expiration_Start_Date__c+'   Expiration_End_Date__c:->'+objectConsignementSearchDate.Expiration_End_Date__c);  
                   outPutElement = objsearchConsignmentInvokeCallout.searchConsignment(shipTo,productName,ProductId,serialNumber,objectConsignementSearchDate.Expiration_Start_Date__c,objectConsignementSearchDate.Expiration_End_Date__c,objectAccount.Consignment_Inventory_BU__c,UserInfo.getUserId(),searchId,'Search Billed Consignment',setId,consignmentLocation);              
               }                          
               if(outPutElement[0].RECORD_COUNT > 0){
                   showSearchResult  = true;
                   isShowBlanklist  = false ;
                   isExport  = true;
               }else{
                   isExport = false;
                   isShowBlanklist = true;
                   showSearchResult  = false;
                   divVisibility = 'visible';                              
               }
           }
           }Catch(Exception e){
               pageMessage('Error',e.getMessage());
           }
           isworking = false ; 
           isModifySearchFieldBtn = false;                  
           return null;
   } 
   
    public pagereference searchTransactionHistory(){
           pageHeaderValue = 'SearchTransactionHistoryResult';
           string val = isNotNullDate();
           if(val != ''){
                pageMessage('error',val);
                return null;
           }                   
           TogetListViewIds('Search Transaction History Result','Search Transaction History Results');  
           try{
           //if(shipTo == ''){
           //     pageMessage('error','Ship to is required !');
           //     return null;
           //}else {
                   isCancelSearchRenderBtn = false;     
               isworking = true ;   
               pageBolckSectionReadOnly = true;
               pageBolckSectionEditable = false;                                
               DateTime d = Datetime.now();
               string formatedDate = string.valueOf(d.day()+'-'+ d.Month()+'-'+ d.year());
               string formatedTime = string.valueOf(d.hour()+':'+ d.minute() +':'+ d.second()); 
               string searchId = UserInfo.getUserId()+'_'+formatedDate+' '+formatedTime ;            
               system.debug('formatedDate :'+UserInfo.getUserId()+'_'+formatedDate+' '+formatedTime);  
               searchConsignmentInvokeCallout objsearchConsignmentInvokeCallout = new searchConsignmentInvokeCallout();
               Web_Service_Consignment_Search1.OutputData_element[] outPutElement ;
               if(ProductId!='' && ProductId!=null){
                ProductId = ProductId.toUpperCase();
               }
               if(productName == 'All'){            
                   outPutElement = objsearchConsignmentInvokeCallout.searchConsignment(shipTo,'',ProductId,serialNumber,objectConsignementSearchDate.Expiration_Start_Date__c,objectConsignementSearchDate.Expiration_End_Date__c,objectAccount.Consignment_Inventory_BU__c,UserInfo.getUserId(),searchId,'Search Transaction History',setId,consignmentLocation);              
               }else{
                   system.debug('Expiration_Start_Date__c:->'+objectConsignementSearchDate.Expiration_Start_Date__c+'   Expiration_End_Date__c:->'+objectConsignementSearchDate.Expiration_End_Date__c);
                   outPutElement = objsearchConsignmentInvokeCallout.searchConsignment(shipTo,productName,ProductId,serialNumber,objectConsignementSearchDate.Expiration_Start_Date__c,objectConsignementSearchDate.Expiration_End_Date__c,objectAccount.Consignment_Inventory_BU__c,UserInfo.getUserId(),searchId,'Search Transaction History',setId,consignmentLocation);                                  
               }
               system.debug('outPutElement--------------->'+outPutElement);           
               if(outPutElement[0].RECORD_COUNT > 0){
                   showSearchResult  = true;
                   isShowBlanklist  = false ;
                   isExport  = true;
               }else{
                   isShowBlanklist = true;
                   showSearchResult  = false;
                   isExport = false;
                   divVisibility = 'visible';                              
               }
           //}
           }Catch(Exception e){
               pageMessage('Error',e.getMessage());
           } 
           isworking = false ;
           isModifySearchFieldBtn = false;
           system.debug('Check this debug');       
           return null;
   } 
  
  public pagereference searchUnbilledConsignment(){
           pageHeaderValue = 'SearchUnbilledConsignmentResult';
           string val = isNotNullDate();
           if(val != ''){
                pageMessage('error',val);
                return null;
           }                   
           TogetListViewIds('Search Unbilled Consignment Result','Search Unbilled Consignment Results');        
           try{
           //if(shipTo == ''){
           //    pageMessage('error','Ship to is required !');
           //     return null;
           //}else {
               isCancelSearchRenderBtn = false;
               isworking = true ;                  
               pageBolckSectionReadOnly = true;
               pageBolckSectionEditable = false;                                
               DateTime d = Datetime.now();
               string formatedDate = string.valueOf(d.day()+'-'+ d.Month()+'-'+ d.year());
               string formatedTime = string.valueOf(d.hour()+':'+ d.minute() +':'+ d.second()); 
               string searchId = UserInfo.getUserId()+'_'+formatedDate+' '+formatedTime ;            
               system.debug('formatedDate :'+UserInfo.getUserId()+'_'+formatedDate+' '+formatedTime);  
               searchConsignmentInvokeCallout objsearchConsignmentInvokeCallout = new searchConsignmentInvokeCallout();
               Web_Service_Consignment_Search1.OutputData_element[] outPutElement ;
               if(ProductId!='' && ProductId!=null){
                ProductId = ProductId.toUpperCase();
               }
               if(productName == 'All'){             
                   outPutElement = objsearchConsignmentInvokeCallout.searchConsignment(shipTo,'',ProductId,serialNumber,objectConsignementSearchDate.Expiration_Start_Date__c,objectConsignementSearchDate.Expiration_End_Date__c,objectAccount.Consignment_Inventory_BU__c,UserInfo.getUserId(),searchId,'Search Unbilled Consignment',setId,consignmentLocation);              
               }else{
                   system.debug('Expiration_Start_Date__c:->'+objectConsignementSearchDate.Expiration_Start_Date__c+'   Expiration_End_Date__c:->'+objectConsignementSearchDate.Expiration_End_Date__c);
                   outPutElement = objsearchConsignmentInvokeCallout.searchConsignment(shipTo,productName,ProductId,serialNumber,objectConsignementSearchDate.Expiration_Start_Date__c,objectConsignementSearchDate.Expiration_End_Date__c,objectAccount.Consignment_Inventory_BU__c,UserInfo.getUserId(),searchId,'Search Unbilled Consignment',setId,consignmentLocation);              
               }
               system.debug('outPutElement:)------------------'+outPutElement);           
               if(outPutElement[0].RECORD_COUNT > 0){
                   showSearchResult  = true;
                   isShowBlanklist  = false ;
                   isExport  = true;
               }else{
                   isShowBlanklist = true;
                   showSearchResult  = false; 
                   isExport = false;                   
                   divVisibility = 'visible';                              
               }
           //}
           }Catch(Exception e){
               pageMessage('Error',e.getMessage());
           } 
           isworking = false ;
           isModifySearchFieldBtn = false;       
           return null;
   }
  
  public string isNotNullDate(){
                if(objectConsignementSearchDate.Expiration_Start_Date__c !=null && objectConsignementSearchDate.Expiration_End_Date__c==null){
                        return 'Please enter an Expiration End Date.'; 
                }
                if(objectConsignementSearchDate.Expiration_Start_Date__c ==null && objectConsignementSearchDate.Expiration_End_Date__c!=null){
                        return 'Please enter an Expiration Start Date.'; 
                }else {
                        return '';
                }
  }
  
  public void pageMessage(string ERROR,string message){
     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,message);
     ApexPages.addMessage(myMsg);
  }
    
}