/*
* 
* Controller of UnPlanned Calls Page 
* Allows to create UnPlanned Calls
* Lists all Open UnPlanned Calls for the Physicians under the Logged in User
* This class test class name: CtrlINDSUPhysicianVisiting_Test
* Author              |Author-Email                                    |Date        |Comment
* --------------------|----------------------------------------------- |------------|------------
* Raviteja Kumar      |raviteja.vakity@bausch.com                      |15.Nov.2012 | First Draft
* Raviteja Kumar      |raviteja.vakity@bausch.com                      |19.Nov.2012 | Implemented the unplanned call planning for India Sales Execs
* Tarun Solanki       | 25-Apr-14 | CR from Suresh                     |25-Apr-2014 | India Sales rep can do physician visit for Today Only  
* Sridhar Aluru       | CR from Tanvir                                 |27-May-2015 | India Sales rep can do Unplanned Physician Visit for T+2 Days 
* Sridhar Aluru       |sridhar.aluru@bausch.com                        |28-Aug-2015 | Add 2 Fields-Active User, Lens Usage for the Week (for India Users).
*/
public with sharing class CtrlINDSUUnplannedPhysicianVisit {

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
    
    public CtrlINDSUUnplannedPhysicianVisit(ApexPages.StandardController controller) {
      
      List<Physician_Visit__c> list_Physicianvisitcapture1 = new List<Physician_Visit__c>();
      ID recTypeINDSUSalesPlanned = GetRecordTypeId('Physician_Visit__c','INDSU Sales Planned');  
      ID recTypeINDSUServicePlanned = GetRecordTypeId('Physician_Visit__c','INDSU Service Planned'); 
      
      //Added by Neha Jain for Thailand SU 
      ID recTypeTHASUSalesPlanned = GetRecordTypeId('Physician_Visit__c','THASU Sales Planned');  
      ID recTypeTHASUServicePlanned = GetRecordTypeId('Physician_Visit__c','THASU Service Planned'); 
      
      
      User curretnuser = [SELECT Name, UserRole.Name, Profile.Name FROM User where id=: UserInfo.getUserId() limit 1 ];
      Currentuserprofile = curretnuser.Profile.Name;
      //Modified by neha jain on 17-02-2014 to check for the Service Reps of Thailand
       if(Currentuserprofile.equals('INDSU Service Rep') || Currentuserprofile.equals('THASU Service Rep')){
          isservicerep = false;
       }
       else { isservicerep= True; }  
       
       if(Currentuserprofile.contains('INDSU'))
       {
           isIndiaUser =true;
       }else
       {
           isIndiaUser =false;
       }  
      
      System.debug('Currentuserprofile : '+Currentuserprofile);
      
        for(integer i=0;i<8;i++){  
          
          Physician_Visit__c objPhysicianvisittemp = new Physician_Visit__c();       
          objPhysicianvisittemp.OwnerId= UserInfo.getUserId();
          
          //objPhysicianvisittemp.Visit_Call__c = False;
          objPhysicianvisittemp.Status__c = 'Open';
          objPhysicianvisittemp.Planned_Call__c= False;
          objPhysicianvisittemp.Active_User_IND__c = 'No';
          objPhysicianvisittemp.Lens_usage_for_the_Week_IND__c = 0;
          
          //Modified by Neha Jain on 17th feb, 2014 for Thailand SU 
          if(Currentuserprofile.equals('INDSU Service Rep')){
              objPhysicianvisittemp.RecordTypeID = recTypeINDSUServicePlanned ;
          }
          else if(Currentuserprofile.equals('THASU Sales Rep')){
               objPhysicianvisittemp.RecordTypeID = recTypeTHASUServicePlanned ;
          }
          else if(Currentuserprofile.equals('THASU Service Rep')){
               objPhysicianvisittemp.RecordTypeID = recTypeTHASUServicePlanned ;
          }
          else{ 
              objPhysicianvisittemp.RecordTypeID = recTypeINDSUSalesPlanned ; 
          }    
          
          System.debug('tmp 2 : '+objPhysicianvisittemp);
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
        return (new PageReference('/apex/INDSU_Physician_Visiting'));
    }
    
    public PageReference Save() {
       /**
       *Logic:
       *1) Validation on Date selected --DONE
       *2) Validation - Physician, date and session to be selected if visit call selected - DONE 
       *3) Insert Physician Visit - DONE
       **/
       System.debug('Ravi - In Save()');
       if(!isIndiaUser)
       {
        if(!IsDateInRange())
        {
           System.debug('PAge not proper 1...');
           String msg = 'Visit Date cannot be less than 3 or more than today. You have selected incorrect visit dates for some record(s).';
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,msg));
           return null;
        }
       }
       //Raviteja Kumar| 3-Dec-13 | CR from Suresh | Start

       /*if(!IsValuesInputedForSelectedCheckbox()){               
           System.debug('PAge not proper 2...');
           String msg;
            if(Currentuserprofile.equals('INDSU Service Rep')){   
               msg = 'Please input Activity Date and Physician if Visit Call is selected.';
               } else {
                 msg = 'Please input Activity Date, Physician and Session if Visit Call is selected.';
               }
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,msg));
           return null;
       }*/
      //Raviteja Kumar| 3-Dec-13 | CR from Suresh | END

                        
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
            
            // START of Code added by SRIDHAR ALURU    
            
            else if(errorDueTo == 'Active_User'){
               String msg = 'Active User cannot be blank, please select "Yes" or "No"';
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,msg));
               return null; 
            } 
            else if(errorDueTo == 'Lens Used for the Week'){
               String msg = '"Lens Used for the Week" must be > 0 if "Active User" is "Yes"';
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,msg));
               return null; 
            } 
            else if(errorDueTo == 'Active User and Lens Used for the Week'){
               String msg = '"Lens Used for the Week" must be 0 if "Active User" is "No"';
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,msg));
               return null; 
            } 
            
            // END of Code added by SRIDHAR ALURU 
                       
        }
        try{
         
          List<Physician_Visit__c > lstToInsertPV = new List<Physician_Visit__c >();
          //ID recTypeINDSUSalesPlanned = GetRecordTypeId('Physician_Visit__c ','INDSU Sales Planned');
         
          for(Physician_Visit__c pv : list_Physicianvisitcapture)
          {
                  
                   //Raviteja Kumar| 3-Dec-13 | CR by Suresh | Start
                    //Commented the below condition and added a new condition
                    //if(pv.Visit_Call__c  == true)
                    //Raviteja Kumar| 3-Dec-13 | CR by Suresh | END
                    //Tarun Solanki| 25-Apr-14 | CR from Suresh | Start //Sales rep can do physician visit for Today
                    if(isIndiaUser)
                    {
                     if((pv.Physician__c != null))
                     {                                       
                      Physician_Visit__c tempPV = new Physician_Visit__c ();                        
                      tempPV.OwnerId= UserInfo.getUserId();
                      tempPV.RecordTypeID = pv.RecordTypeID;
                      tempPV.Visit_Call__c = false;
                      tempPV.Status__c = 'Open';
                      tempPV.Planned_Call__c= false;              
                      tempPV.Physician__c = pv.Physician__c;
                 // Updated by SRIDHAR ALURU - Commented Line # 192 (tempPV.Activity_Date__c=System.today();) and Uncomment Line # 190 (tempPV.Activity_Date__c = pv.Activity_Date__c;)                 
                      tempPV.Activity_Date__c = pv.Activity_Date__c;
                      //P visit for Today only
                 //   tempPV.Activity_Date__c=System.today();
                 
                 // START - Updated by SRIDHAR ALURU Date: 28/08/2015
                     // Set default Value as 'NO'
                    // pv.Active_User_IND__c = 'No';
                     tempPV.Active_User_IND__c=pv.Active_User_IND__c;                     
                     tempPV.Lens_usage_for_the_Week_IND__c=pv.Lens_usage_for_the_Week_IND__c;
                                      
                 // END - Updated by SRIDHAR ALURU Date: 28/08/2015
                 
                      tempPV.Session__c = pv.Session__c;
                      
                      System.debug('tempPV : ' + tempPV );
                      
                      lstToInsertPV.add(tempPV);                      
                     }
              }
          else
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
          }

          System.debug('List of PV to insert: ' + lstToInsertPV);
          insert lstToInsertPV;
        }
        catch(Exception e){
        
            String msg = e.getMessage();                        
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,msg));
            return null;
        }
        
          pg = new PageReference('/apex/INDSU_Physician_Visiting');
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
        
        System.debug('list_Physicianvisitcapture size: ' + list_Physicianvisitcapture.size());
        for(Physician_Visit__c pv : list_Physicianvisitcapture ){
        System.debug('pv.Visit_Call__c: ' + pv.Visit_Call__c);
            //Commented to remove visit call condition
            //if(pv.Visit_Call__c == true){
                
                System.debug('pv.Activity_Date__c: ' + pv.Activity_Date__c);
                System.debug('System.today().addDays(-3): ' + System.today().addDays(-3));
                System.debug('System.today().addDays(7): ' + System.today().addDays(7));
                System.debug('Condition 1: ' + (pv.Activity_Date__c < System.today().addDays(-3)));
                System.debug('Condition 2: ' + (pv.Activity_Date__c > System.today().addDays(7)));
                if((pv.Activity_Date__c < System.today().addDays(-3)) || (pv.Activity_Date__c > System.today())){
                    blnOutput = false;
                    break;
                }
            //}
        }
        System.debug('Ravi: blnOutput: ' + blnOutput);
        return blnOutput;
    }

     //Raviteja Kumar       | 3-Dec-13 | CR from Suresh | Start
    //Commented the below function
    /*
    //Please input Activity Date, Physician and Session if Visit Call is selected.
    public boolean IsValuesInputedForSelectedCheckbox(){       
        boolean isAllowed = true;        
        for(Physician_Visit__c pv : list_Physicianvisitcapture ){
            if(pv.Visit_Call__c == true){     
            
                if(Currentuserprofile.equals('INDSU Service Rep')){      
                if((pv.Activity_Date__c == null) || (pv.Physician__c == null) ){
                    isAllowed = false;
                    break;
                }
                }else{
                     if((pv.Activity_Date__c == null) || (pv.Physician__c == null) || (pv.Session__c== null)){
                    isAllowed = false;
                    break;
                }
                }
            }
        }
        System.debug('isAllowed : ' + isAllowed);
        return isAllowed;
    }
    */
    //Raviteja Kumar      | 3-Dec-13 | CR from Suresh | END
    
    //Raviteja Kumar      | 3-Dec-13 | CR from Suresh | Start
    
    //Tarun Solanki| 25-Apr-14 | CR from Suresh | Start
    //Sales rep can do physician visit for Today
      
    //VALIDATE Date, Doctor and Session for Visit
    public boolean IsValidDataProvided(){
        integer count = 0;
        boolean isAllowed = true;
        errorDueTo = '';
        if(isIndiaUser)
        {
        for(Physician_Visit__c pv : list_Physicianvisitcapture){
        
            // START - Updated by SRIDHAR ALURU Date: 28/08/2015
            
             if(pv.Active_User_IND__c ==null)
              {
                  errorDueTo = 'Active_User';
                  isAllowed = false;
                  break;
              }
              
              if(pv.Active_User_IND__c =='Yes' && (String.valueOf(pv.Lens_usage_for_the_week_IND__c) == null || 
              String.valueOf(pv.Lens_usage_for_the_Week_IND__c)=='' || pv.Lens_usage_for_the_Week_IND__c == 0))
              {
                   errorDueTo = 'Lens Used for the Week';
                   isAllowed = false;
                   break;
              }
                                   
              if(pv.Active_User_IND__c =='No' && (String.valueOf(pv.Lens_usage_for_the_Week_IND__c) == null || String.valueOf(pv.Lens_usage_for_the_Week_IND__c) == '' || pv.Lens_usage_for_the_Week_IND__c >= 1))
              {    
                   System.debug('--------------------------------ENTERED INTO THE LOOP WHERE ACTIVE USER= NO CONDITION SATISFIES----------------------------');
                   errorDueTo = 'Active User and Lens Used for the Week';
                   isAllowed = false;
                   break;
              }
              
              // END - Updated by SRIDHAR ALURU Date: 28/08/2015
              
            if( /*(pv.Activity_Date__c == null) && */ (pv.Physician__c == null) && (pv.Session__c == null)){
                count++;                
                isAllowed = false;
            }

           /* if((pv.Activity_Date__c != null) && (pv.Physician__c == null)){
                errorDueTo = 'Physician';
                isAllowed = false;
                break;
            }
            if((pv.Activity_Date__c == null) && (pv.Physician__c != null)){
                errorDueTo = 'Activity_Date';
                isAllowed = false;
                break;
            }*/
            if( /*(pv.Activity_Date__c != null) &&*/ (pv.Physician__c != null) && (pv.Session__c == null)){
                errorDueTo = 'Session';
                isAllowed = false;
                break;
            }
            if( /*(pv.Activity_Date__c == null) &&*/ (pv.Physician__c == null) && (pv.Session__c != null)){
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
        }
        else
        {
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
        }
        System.debug('isAllowed : ' + isAllowed);
        return isAllowed;
    }

    //Raviteja Kumar| 3-Dec-13 | CR from Suresh | END
}