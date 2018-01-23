/*
* 
* Controller of UnPlanned Calls Page 
* Allows to create UnPlanned Calls
* Lists all Open UnPlanned Calls for the Physicians under the Logged in User
* This class test class name: CtrlINDSUPhysicianVisiting_Test
* Author              |Author-Email                                    |Date        |Comment
* --------------------|----------------------------------------------- |------------|------------
* Tarun Solanki       | 25-Apr-14 | CR from Suresh                     |25-Apr-2014 | India Sales rep can do physician visit for Today Only  
*/
public with sharing class CtrlINDAESUnplannedPhysicianVisit{

    public List<Physician_Visit__c> list_Physicianvisit = new List<Physician_Visit__c>();//List of Unplanned Open calls for the logged in User
    public Physician_Visit__c objPhysicianvisit2 = new Physician_Visit__c();  //call Activity object
    public Physician_Visit__c objPhysicianvisit = new Physician_Visit__c();
    public final Apexpages.Standardcontroller controller;
    public List<Physician_Visit__c> list_Physicianvisitcapture {get;set;}
    public PageReference pg;
    public String strErrMsg = '';
    public String Currentuserprofile= '';
    public boolean isservicerep{get; set;}
    public boolean isIndiaUser {get; set;}
    private string errorDueTo = '';
    
    public CtrlINDAESUnplannedPhysicianVisit(ApexPages.StandardController controller) {
      
      List<Physician_Visit__c> list_Physicianvisitcapture1 = new List<Physician_Visit__c>();
      ID recTypeINDAESSalesPlanned = GetRecordTypeId('Physician_Visit__c','INDSU Sales Planned');      
      
      User curretnuser = [SELECT Name, UserRole.Name, Profile.Name FROM User where id=: UserInfo.getUserId() limit 1 ];
      Currentuserprofile = curretnuser.Profile.Name;
     
      
        for(integer i=0;i<8;i++){  
          
          Physician_Visit__c objPhysicianvisittemp = new Physician_Visit__c();       
          objPhysicianvisittemp.OwnerId= UserInfo.getUserId();
          
          //objPhysicianvisittemp.Visit_Call__c = False;
          objPhysicianvisittemp.Status__c = 'Open';
          objPhysicianvisittemp.Planned_Call__c= False;
                    
          objPhysicianvisittemp.RecordTypeID = recTypeINDAESSalesPlanned; 
             

          list_Physicianvisitcapture1.add(objPhysicianvisittemp);
         } 
            list_Physicianvisitcapture = list_Physicianvisitcapture1;
    }

   
    
    Public Physician_Visit__c getObjPhysicianvisit(){
        return objPhysicianvisit;
    }
    public void setObjPhysicianvisit(Physician_Visit__c ObjPhysicianvisit){
        this.ObjPhysicianvisit= ObjPhysicianvisit;
    }   
    
       
    /*************************************************************************
    * cancel Button click
    *************************************************************************/
    public PageReference Cancel() {
        return (new PageReference('/apex/INDAES_Physician_Visiting'));
    }
    
    public PageReference Save() {
       /**
       *Logic:
       *1) Validation on Date selected --DONE
       *2) Validation - Physician, date and session to be selected if visit call selected - DONE 
       *3) Insert Physician Visit - DONE
       **/
       System.debug('Ravi - In Save()');
      
        if(!IsDateInRange())
        {
           System.debug('PAge not proper 1...');
           String msg = 'Visit Date should be of the current week only. You have selected incorrect visit dates for some record(s).';
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,msg));
           return null;
        }
       
                        
        if(!IsValidDataProvided()){
            if(errorDueTo == 'No data'){
                String msg = 'Please provide Doctor and Session to create Unplanned Physician Visit or click Cancel button to go back.';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,msg));
                return null;
            }
            if(errorDueTo == 'Physician'){
                String msg = 'Please input Physician.';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,msg));
                return null;

            }
            else if(errorDueTo == 'Activity_Date'){
                String msg = 'Please input Visit Date if you have inputed Physician.';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,msg));
                return null;

            }
            else if(errorDueTo == 'Session'){
                String msg = 'Please input Session.';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,msg));
                return null;
            }
            else if(errorDueTo == 'Physician_Activity_Date'){
                String msg = 'Please input Phyiscian if you have inputed Session .';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,msg));
                return null;

            }
        }
        try{
         
          List<Physician_Visit__c > lstToInsertPV = new List<Physician_Visit__c >();
         
          for(Physician_Visit__c pv : list_Physicianvisitcapture)
          {

                    if((pv.Activity_Date__c != null) && (pv.Physician__c != null))
                    {
                      Physician_Visit__c tempPV = new Physician_Visit__c ();                        
                      tempPV.OwnerId= UserInfo.getUserId();
                      tempPV.RecordTypeID = pv.RecordTypeID;
                      tempPV.Visit_Call__c = false;
                      tempPV.Status__c = 'Open';
                      tempPV.Planned_Call__c= false;              
                      tempPV.Physician__c = pv.Physician__c;
                      tempPV.Activity_Date__c = pv.Activity_Date__c;       
                      tempPV.Session__c = pv.Session__c;
                      
                      System.debug('tempPV : ' + tempPV );
                      
                      lstToInsertPV.add(tempPV);
                  }
              }         

          System.debug('List of PV to insert: ' + lstToInsertPV);
          insert lstToInsertPV;
        }
        catch(Exception e){
        
            String msg = e.getMessage();                        
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,msg));
            return null;
        }
        
          pg = new PageReference('/apex/INDAES_Physician_Visiting');
          System.debug('objPhysicianvisit : '+objPhysicianvisit );
          pg.setRedirect(true); 
          return pg;
                  
    }
    
    
    public static id GetRecordTypeId(string objectAPIName, string recordTypeName){
        if(objectAPIName =='' || recordTypeName ==''){
            return null;
        }        
        
        Map<String, Schema.SObjectType> sobjectSchemaMap = Schema.getGlobalDescribe();

        Schema.SObjectType sObjType = sobjectSchemaMap.get(objectAPIName) ;
        Schema.DescribeSObjectResult cfrSchema = sObjType.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id recordTypeId = RecordTypeInfo.get(recordTypeName).getRecordTypeId();
        return recordTypeId;
    }
        
    //Function to check the activity date inputed by user is in allowed range
    public boolean  IsDateInRange(){
        boolean blnOutput = true;
        Date weekStartDate;
        Date weekEndDate;
       date myDate = date.today();
       date weekStart = myDate.toStartofWeek();         
       weekStartDate= weekStart.addDays(1);
       weekEndDate=weekStart.addDays(6);
       
        System.debug('list_Physicianvisitcapture size: ' + list_Physicianvisitcapture.size());
        for(Physician_Visit__c pv : list_Physicianvisitcapture )
        {                
                if((pv.Activity_Date__c < weekStartDate) || (pv.Activity_Date__c > weekEndDate)){
                    blnOutput = false;
                    break;
                }

        }
        System.debug('Ravi: blnOutput: ' + blnOutput);
        return blnOutput;
    }

    
    public boolean IsValidDataProvided(){
        integer count = 0;
        boolean isAllowed = true;
        errorDueTo = '';
       
        for(Physician_Visit__c pv : list_Physicianvisitcapture){
            if((pv.Activity_Date__c == null) && (pv.Physician__c == null) && (pv.Session__c == null)){
                count++;                
                isAllowed = false;
            }

            if((pv.Activity_Date__c != null) && (pv.Physician__c == null)){
                errorDueTo = 'Physician';
                isAllowed = false;
                break;
            }
            if((pv.Activity_Date__c == null) && (pv.Physician__c != null)){
                errorDueTo = 'Activity_Date';
                isAllowed = false;
                break;
            }
            if((pv.Activity_Date__c != null) && (pv.Physician__c != null) && (pv.Session__c == null)){
                errorDueTo = 'Session';
                isAllowed = false;
                break;
            }
            if((pv.Activity_Date__c == null) && (pv.Physician__c == null) && (pv.Session__c != null)){
                errorDueTo = 'Physician_Activity_Date';
                isAllowed = false;
                break;
            }
            if(count == 8){
                errorDueTo = 'No data';
                isAllowed = false;
                break;

            }
        }
        
        System.debug('isAllowed : ' + isAllowed);
        return isAllowed;
    }

    //Raviteja Kumar| 3-Dec-13 | CR from Suresh | END
}