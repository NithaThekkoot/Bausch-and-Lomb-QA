/**
* 
* This is the controller for showing the details of the call planning for every contact

* Author                     |Author-Email                               |Date        |Comment
* ---------------------------|-------------------------------------------|------------|----------------------------------------------------
* Yash Agarwal               |yash.agarwal@listertechnologies.com        |20.05.2010  |First Draft for CtrlCallPlanDetails_detailByContact
* Sourav Mitra               |sourav.mitra@listertechnologies.com        |08.09.2010  |Changes to incorporate China SU
* Sourav Mitra               |sourav.mitra@listertechnologies.com        |08.09.2010  |Face lift to improve aesthetics
* Saranya Sivakumar          |saranya.sivakumar@listertechnologies.com   |27.10.2010  |Changed the redirect of Save and Cancel Buttons 
* Saranya Sivakumar          |saranya.sivakumar@listertechnologies.com   |28.10.2010  |Validations for the Call objective field and addition of Submit button
* Santosh Kumar S            |santosh.sriram@listertechnologies.com      |27.01.2011  |Changes - Manager Creating a call plan.
* Rajesh Sriramulu           |rajesh.sriramulu@rishabhsoft.com           |27.06.2012 | added Code for KORSU to display call objective default value
* Raviteja Vakity            |raviteja.vakity@baucsh.com                 |19.11.2013 | Modified code to Validate Call Plan Details
*/

public class CtrlCallPlanDetails
{
    
    /*************************************************************************
    ** Variable Declerations
    *************************************************************************/
    //instance of a user
    public User objUser { get; set;}
    
    //id of the call plan
    public String idCallPlan { get; set;}

    //public Id idRecordTypeCallPlanDetail;
    public List<RecordType> list_recordTypes;
    
    public List<Call_Plan_Detail__c> objCallPlanDetail{ get; set;}
    public Boolean blnisManager { get ;set;}
    //checking to display lower section or not
    
    //public Boolean blnDisableObjective { get; set;}
    Public UserRole objUserRole;
    public String strStatus { get; set;}
    
     //added to check if the Users is India Sales Rep or Manager - to hide excecutive/manager comments 
    public Boolean blnCheckRole{get; set;}
    //added to check if the Users from India Aesthetic BU
    public Boolean blnCheckRoleAES{get; set;}
     public Boolean blnHideCallObj{get; set;}
    
    //Boolean to check if all the call objectives are set
    public Boolean blnIsAllCallObjSelected {get; set;}
    public String executiveComments;
    public String ManagerComments;
    
    public CtrlCallPlanDetails(){
        blnCheckRole = true;
        blnCheckRoleAES=false;
        blnHideCallObj=true;
        objCallPlanDetail = new List<Call_Plan_Detail__c>(); 
        //blnDisableObjective = false;
        blnisManager = false;
        blnIsAllCallObjSelected = true;
        
        //getting the record type id
        list_recordTypes = [SELECT Id FROM RecordType 
                                    WHERE Name IN ('INDSU Call Plan Detail','APACSU Call Plan Detail') AND SObjectType='Call_Plan_Detail__c'];
        
        //getting the parameters from the url
        idCallPlan =  ApexPages.currentPage().getParameters().get('id');
        //getting user information
        String strTypeOfUserId = UserInfo.getUserId();
        User objTypeOfUser = [Select Id,name,UserRoleId from User where id =:strTypeOfUserId ];
        
        if(objTypeOfUser.UserRoleId!=null)
        {
            objUserRole = [Select Id,name from userRole where id=:objTypeOfUser.UserRoleId];
            system.debug('INDAESTARUN '+ objUserRole );
            if(objUserRole.Name.contains('INDSU'))
            {
                blnCheckRole = false;
                blnHideCallObj=false;
            }
            if(objUserRole.Name.contains('INDAES'))
            {
                blnCheckRoleAES= true; 
                blnHideCallObj=false;
            }
        }               
        
        // if the call plan id is nto null query the given call plan
        if(idCallPlan !=null && idCallPlan != '')
        {
            try
            {
                objCallPlanDetail = [Select Id,
                                            Physician_Name__c,
                                            Physician_Name__r.Name,
                                            Physician_Name__r.Account.name,
                                            Physician_Name__r.AccountId,
                                        Call_Plan__c,
                                        Date__c,
                                        Call__c,
                                        Joint_Call__c,
                                        Call_Plan__r.Status__c,
                                        Call_Plan__r.ownerId,
                                        Call_Plan__r.Executive_Comments__c,
                                        Call_Plan__r.Manager_Comments__c,
                                        OT_Hours__c,
                                        Product1__c,
                                        Product2__c,
                                        Remarks__c,
                                        AES_Product1__c,
                                        AES_Product2__c,
                                        Call_Objective__c From Call_Plan_Detail__c where Call_Plan__c =:idCallPlan
                                                                                    AND RecordTypeId IN :list_recordTypes
                                                                                    AND Call__c = true];
                                                                                    
                
                         //deciding if manager or not
                if(objUserRole!=null)
                {
                    if((objUserRole.name.contains('Manager') || objUserRole.name.contains('manager'))&& objCallPlanDetail[0].Call_Plan__r.ownerId !=UserInfo.getUserId()){
                        blnisManager = true;
                    }
                }
                if(objCallPlanDetail.size() > 0)
                {
                    strStatus = objCallPlanDetail[0].Call_Plan__r.Status__c;
                    //if(strStatus == 'Submitted' || strStatus == 'Approved' || strStatus == 'Rejected')
                       // blnDisableObjective = true;
                       executiveComments = objCallPlanDetail[0].Call_Plan__r.Executive_Comments__c;
                         System.debug('>>>>'+ executiveComments);
                ManagerComments = objCallPlanDetail[0].Call_Plan__r.Manager_Comments__c;
                  System.debug('>>>>'+ ManagerComments);
                }
            }
            catch(Exception e)
            {
                addErrorMessage('Invalid call plan selected');
            }   

        } 
        
        else
            addErrorMessage('Invalid call plan selected');
 
    }
    
    /*************************************************************************
    ** Button Action Methods for the Save Button
    *************************************************************************/
    public PageReference save(){
        String strRetUrl = '';
        system.debug('objCallPlanDetail>>>'+objCallPlanDetail);
        
        //Validate only if the Users belongs to INDSU
        //Tarun solanki --add condition for IND Aesthetics
        if(!blnCheckRole || blnCheckRoleAES)
            if(!ValidateDetails())
              return null;
        
        if(objCallPlanDetail.size() >0)
        {
            //added to check if its a INDSU User
             //Tarun solanki --add condition for IND Aesthetics
            if(blnCheckRole && !blnCheckRoleAES){
                blnIsAllCallObjSelected = true;       
                for(Call_Plan_Detail__c objCPD : objCallPlanDetail)
                {                
                    system.debug('objCPD.Call_Objective__c>>>'+objCPD.Call_Objective__c);
                    if(objCPD.Call_Objective__c == '' || objCPD.Call_Objective__c == null)
                    {
                        blnIsAllCallObjSelected = false;                    
                    }
                }
                
                if(!blnIsAllCallObjSelected)
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Call_Obj_Mandatory);
                    ApexPages.addMessage(myMsg);
                    return null;
                }
                else
               {
                    update objCallPlanDetail;   
                    strRetUrl = '/apex/CtrlCallPlanningChinaSU_CallPlan?id='+idCallPlan;
                    //return  objPgRef;           
                }
            }
            else
            {
                update objCallPlanDetail;   
                strRetUrl = '/apex/CtrlCallPlanningChinaSU_CallPlan?id='+idCallPlan;
            }
            
        }
        system.debug('strRetUrl>>>'+strRetUrl);
        return new PageReference(strRetUrl);
        /*if(objCallPlanDetail.size() >0)
         update objCallPlanDetail;           
        {
            try{
                update objCallPlanDetail;
            } catch(Exception E){
                //catching exception
                String strError = '';
                strError += E;
                addErrorMessage(strError);
            }
        }*/
        
    }
    
    /*************************************************************************
    ** Method for submit button
    *************************************************************************/
    public PageReference submit()
    {
    system.debug('Start');
        String strRetUrl = '';
         //Validate only if the Users belongs to INDSU
        if(!blnCheckRole || blnCheckRoleAES)
        {
            system.debug('coming here--' + blnCheckRole + ' '+ blnCheckRoleAES);
            if(!ValidateDetails())
            {
             system.debug('coming here 2--' + blnCheckRole + ' '+ blnCheckRoleAES);
              return null;
           }
        }
        system.debug('coming here out--' + blnCheckRole + ' '+ blnCheckRoleAES);
        if(((objCallPlanDetail[0].Call_Plan__r.Status__c == 'Submitted') && (!blnisManager) ))
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Call_Submitted_Already);
            ApexPages.addMessage(myMsg);
            return null; 
        }         
        else 
        {
            if(objCallPlanDetail.size() >0)
            {
            system.debug('coming here in ELSE--');
                if(blnCheckRole && !blnCheckRoleAES){
                    blnIsAllCallObjSelected = true;       
                    for(Call_Plan_Detail__c objCPD : objCallPlanDetail)
                    {                
                        system.debug('objCPD.Call_Objective__c>>>'+objCPD.Call_Objective__c);
                        if(objCPD.Call_Objective__c == '' || objCPD.Call_Objective__c == null)
                        {
                            blnIsAllCallObjSelected = false;                    
                        }
                    }
                    
                    if(!blnIsAllCallObjSelected)
                    {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Call_Obj_Mandatory);
                        ApexPages.addMessage(myMsg);
                        return null;
                    }
                   else
                   {
                       System.debug('>>>>'+ executiveComments);
                        objCallPlanDetail[0].Call_Plan__r.Status__c = 'Submitted';
                        strRetUrl = '/'+idCallPlan;
                        system.debug('strRetUrl>>>'+strRetUrl);
                        try
                        {
                         System.debug('>>>>'+ executiveComments);
                            update objCallPlanDetail[0].Call_Plan__r;
                            if(objCallPlanDetail.size()>0)
                                update objCallPlanDetail;                
                        }
                        catch(DMLException ex)
                        {
                            system.debug('***exception--' + ex);
                        }           
                    }
               }
               else
                   {
                       System.debug('>>>>'+ executiveComments);
                        objCallPlanDetail[0].Call_Plan__r.Status__c = 'Submitted';
                        strRetUrl = '/'+idCallPlan;
                        system.debug('strRetUrl>>>'+strRetUrl);
                        try
                        {
                         System.debug('>>>>'+ executiveComments);
                            update objCallPlanDetail[0].Call_Plan__r;
                            
                            if(objCallPlanDetail.size()>0)
                                update objCallPlanDetail;                
                        }
                        catch(DMLException ex)
                        {
                        
                        }           
                    }
            }            
        }       
        system.debug('strRetUrl>>>'+strRetUrl);
        return new PageReference(strRetUrl);
    }
    
    /*************************************************************************
    ** Method for cancel button
    *************************************************************************/
    public PageReference cancel()
    {
        PageReference objPgRef = new PageReference('/apex/CtrlCallPlanningChinaSU_CallPlan?id='+idCallPlan);
        return objPgRef;
    }
    
    /*************************************************************************
    ** Method for psoting error message
    *************************************************************************/
    public void addErrorMessage(String error){
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, error);
        ApexPages.addMessage(msg);        
    }
    
    public List<SelectOption> getObjectiveOptions()
    {
     //Added code by Rajesh Sriramulu to display the call objective default picklist value for Korea Users     
          
   List <Profile>  prof=[select Name from profile where id = : userinfo.getProfileId()];
         List<SelectOption> list_options = new List<SelectOption>();
          if(prof[0].name.Contains('KOR'))
          { 
           Schema.DescribeFieldResult objDecsribe = Physician_Visit__c.Call_Ojective_CHN__c.getDescribe();
        List<Schema.PicklistEntry> list_picklistValues = objDecsribe.getPicklistValues();           
         
           for(Schema.PicklistEntry obj : list_picklistValues)
          {
            list_options.add(new SelectOption(obj.getLabel(),obj.getLabel())) ;
          }
       return list_options;
            }
                   
           
         else {
          
        Schema.DescribeFieldResult objDecsribe = Physician_Visit__c.Call_Ojective_CHN__c.getDescribe();
        List<Schema.PicklistEntry> list_picklistValues = objDecsribe.getPicklistValues();
       
        list_options.add(new SelectOption('',Label.None));
        for(Schema.PicklistEntry obj : list_picklistValues)
        {
            list_options.add(new SelectOption(obj.getLabel(),obj.getLabel())) ;
        }
        return list_options;
              
    }
    }
    
    /*Validates Call Plan Details for Product and OT hours.
    */
    private boolean ValidateDetails(){
       //variable to check if an error is there.
       boolean blnIsError = false;
        //iterate over all the Call Plan Details
        for(Call_Plan_Detail__c objCPD : objCallPlanDetail){
         system.debug('___*** objCPD.Product1__c' + objCPD.Product1__c + '---objCPD.Product2__c ' + objCPD.Product2__c + objCPD.OT_Hours__c);
            //if OT hours is not checked, Products are mandatory
            if(!objCPD.OT_Hours__c){
           if(objUserRole.Name.contains('INDAES'))
           {
              if((objCPD.AES_Product1__c == null) && (objCPD.AES_Product2__c == null)){
                    //Set Message
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select atlease one Product for Hospital ' + objCPD.Physician_Name__r.Account.Name  + ' Physcian - ' + objCPD.Physician_Name__r.Name + ' Date - ' + String.valueOf(objCPD.Date__c)); 
                    ApexPages.addMessage(myMsg);   
                    //set error cehecking variable true
                    blnIsError = true;
                    
                }
                //Check Products Value, should not be same
                if((objCPD.AES_Product1__c != null) && (objCPD.AES_Product2__c != null) && (objCPD.AES_Product1__c == objCPD.AES_Product2__c)){
                if(!objCPD.AES_Product1__c.Contains('None')){
                    //set message
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Product 1 and Product 2 can not have same value for Hospital ' + objCPD.Physician_Name__r.Account.Name  + '- Physcian ' + objCPD.Physician_Name__r.Name + ' Date - ' + String.valueOf(objCPD.Date__c)); 
                    ApexPages.addMessage(myMsg);                    
                     //set error cehecking variable true
                    blnIsError = true;
                }
            }
           }
             else
             {
                if((objCPD.Product1__c == null) && (objCPD.Product2__c == null)){
                    //Set Message
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select atlease one Product for Hospital ' + objCPD.Physician_Name__r.Account.Name  + ' Physcian - ' + objCPD.Physician_Name__r.Name + ' Date - ' + String.valueOf(objCPD.Date__c)); 
                    ApexPages.addMessage(myMsg);   
                    //set error cehecking variable true
                    blnIsError = true;
                    
                }
                //Check Products Value, should not be same
            if((objCPD.Product1__c != null) && (objCPD.Product2__c != null) && (objCPD.Product1__c == objCPD.Product2__c)){
                if(!objCPD.Product1__c.Contains('None')){
                    //set message
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Product 1 and Product 2 can not have same value for Hospital ' + objCPD.Physician_Name__r.Account.Name  + '- Physcian ' + objCPD.Physician_Name__r.Name + ' Date - ' + String.valueOf(objCPD.Date__c)); 
                    ApexPages.addMessage(myMsg);                    
                     //set error cehecking variable true
                    blnIsError = true;
                }
            }
              }
            }
            
            
        }
        if(blnIsError)
            return false;
        return true;
            
    }
}