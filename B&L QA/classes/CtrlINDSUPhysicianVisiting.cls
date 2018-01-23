/* Test Class for the below class is CtrlINDSUPhysicianVisiting_Test
Neha Jain        | 26-05-2014 |neha.jain@bausch.com        |Modified to add a variable set to avoid errors related to issue of duplicate pv in list
Sridhar Aluru    | 27-05-2015 |sridhar.aluru@bausch.com    |Modified to allow to report Physician Visit upto T+2 Days.
Sridhar Aluru    | 28-08-2015 |sridhar.aluru@bausch.com    |Add 2 Fields-Active User, Lens Usage for the Week (for India Users).
*/

public class CtrlINDSUPhysicianVisiting 
{

    Public list<Physician_Visit__c> list_PhysicianVisitDetails {get;set;}
    Public List<Physician_Visit__c> list_UdatePhysicianVisitDetails = new list<Physician_Visit__c>();
    
    //errMsg
    Public Set<Physician_Visit__c> set_UdatePhysicianVisitDetails = new Set<Physician_Visit__c>();
    Public Id currentUerId;
    Public boolean isIndiaUser {get;set;}
    public Integer intSelectedDays;//Value selected for View picklist  
    public String strMessage {get; set; }
    Public Profile userProfile;
      public Integer getintSelectedDays(){    
          return intSelectedDays;   
           }  
      public void setintSelectedDays(Integer intSelectedDays){   
                this.intSelectedDays = intSelectedDays; 
           }
    
       public CtrlINDSUPhysicianVisiting (Apexpages.StandardController c){
           // controller = c;
        }
   public CtrlINDSUPhysicianVisiting (){           
       intSelectedDays = 3;
       getExistingPhysicianVisitMTD();          
       //For get user profile
       String uProfileId = UserInfo.getProfileId();
       userProfile=[Select name from profile where id=:uProfileId limit 1];
       if(userProfile.name.contains('INDSU'))
       {
           isIndiaUser=True;
           BindDataTableforIndia();     
       }
       else
       {
           isIndiaUser=False;
           BindDataTable();
       }
   }

   //Created by Tarun Solanki , 25th Apr, 2014 for India SU Physician visit for Today only
   // Updated by SRIDHAR ALURU, 27th May, 2015 to allow India Physician Visit for T+2 Days (Commented Line "Activity_Date__c = LAST_N_DAYS:0 AND Status__c ='Open' AND" and Uncomment Line "Activity_Date__c = LAST_N_DAYS:2 AND Status__c ='Open' AND"
   // Updated by SRIDHAR ALURU, 28th Aug, 2015 to add the fields 'Active_User_IND__c','Lens_usage_for_the_Week_IND__c'
   public void BindDataTableforIndia()
   {
       list_PhysicianVisitDetails = [select Visit_Call__c,Activity_Date__c,Planned_Call__c,Status__c, Hospital_Name__c,Physician_Name__c,
                                         Active_User_IND__c,Lens_usage_for_the_Week_IND__c,Hours_in_Surgery__c,
                                         Akreos_AO__c,Akreos_Adapt__c,Akreos_MIL__c,Role_Name__c,Envista__c,Crystalens__c,Acrysof_Single_piece__c,
                                         Acrysof_IQ__c,Acrysof_ReStor__c,Acrysof_Toric__c,Hoya__c,Tecnis__c,Tecnis_Multifocal__c,Remarks__c,
                                         Implant_Competition_Remarks__c, Owner.Name, Product_1__c, Product_2__c,OT_Hours__c
                                         from Physician_Visit__c
                                         Where RecordType.Name IN ('INDSU Sales Planned','INDSU Service Planned') AND 
                                         //Activity_Date__c = LAST_N_DAYS:0 AND Status__c ='Open' AND  
                                         Activity_Date__c = LAST_N_DAYS:2 AND Status__c ='Open' AND
                                         OwnerId = :Userinfo.getUserId()];
         //For INDSU-Default set zero value                                
       for(Physician_Visit__c pv : list_PhysicianVisitDetails)
       {
           pv.Active_User_IND__c='No';
           pv.Lens_usage_for_the_Week_IND__c = 0;
           pv.Akreos_AO__c=0;
           pv.Akreos_Adapt__c=0;
           pv.Akreos_MIL__c=0;
           pv.Envista__c=0;
           pv.Crystalens__c=0;
           pv.Acrysof_IQ__c=0;
           
       }
    
    }       
   public void BindDataTable(){
    //Modified by Neha Jain , 17th Feb, 2014 for Thailand SU Physician Visits Record Types
    // Updated by SRIDHAR ALURU, 28th Aug, 2015 to add the fields 'Active_User_IND__c','Lens_usage_for_the_Week_IND__c'
    if(intSelectedDays == 0 || intSelectedDays==null){
         list_PhysicianVisitDetails = [select Visit_Call__c,Activity_Date__c,Planned_Call__c,Status__c, Hospital_Name__c,Physician_Name__c,
                                         Active_User_IND__c,Lens_usage_for_the_Week_IND__c,Hours_in_Surgery__c,
                                         Akreos_AO__c,Akreos_Adapt__c,Akreos_MIL__c,Role_Name__c,Envista__c,Crystalens__c,Acrysof_Single_piece__c,
                                         Acrysof_IQ__c,Acrysof_ReStor__c,Acrysof_Toric__c,Hoya__c,Tecnis__c,Tecnis_Multifocal__c,Remarks__c,
                                         Implant_Competition_Remarks__c, Owner.Name, Product_1__c, Product_2__c,OT_Hours__c
                                         from Physician_Visit__c
                                         Where RecordType.Name IN ('INDSU Sales Planned', 'INDSU Service Planned','THASU Sales Planned', 'THASU Service Planned') AND 
                                         //Activity_Date__c = LAST_N_DAYS:0 AND Status__c ='Open' AND
                                         Activity_Date__c = LAST_N_DAYS:0 AND Status__c ='Open' AND
                                         OwnerId = :Userinfo.getUserId()];
    }
    else if(intSelectedDays == 3){
    // Updated by SRIDHAR ALURU, 28th Aug, 2015 to add the fields 'Active_User_IND__c','Lens_usage_for_the_Week_IND__c'
         list_PhysicianVisitDetails = [select Visit_Call__c,Activity_Date__c,Planned_Call__c,Status__c, Hospital_Name__c,Physician_Name__c,
                                         Active_User_IND__c,Lens_usage_for_the_Week_IND__c,Hours_in_Surgery__c,
                                         Akreos_AO__c,Akreos_Adapt__c,Akreos_MIL__c,Role_Name__c,Envista__c,Crystalens__c,Acrysof_Single_piece__c,
                                         Acrysof_IQ__c,Acrysof_ReStor__c,Acrysof_Toric__c,Hoya__c,Tecnis__c,Tecnis_Multifocal__c,Remarks__c,
                                         Implant_Competition_Remarks__c, Owner.Name, Product_1__c, Product_2__c,OT_Hours__c
                                         from Physician_Visit__c
                                         Where RecordType.Name IN ('INDSU Sales Planned', 'INDSU Service Planned','THASU Sales Planned', 'THASU Service Planned') AND 
                                         Activity_Date__c = LAST_N_DAYS:3 AND Status__c ='Open' AND
                                         OwnerId = :Userinfo.getUserId() ORDER BY Activity_Date__c DESC ];
    }
    else if(intSelectedDays == 7){
    // Updated by SRIDHAR ALURU, 28th Aug, 2015 to add the fields 'Active_User_IND__c','Lens_usage_for_the_Week_IND__c'
         list_PhysicianVisitDetails = [select Visit_Call__c,Activity_Date__c,Planned_Call__c,Status__c, Hospital_Name__c,Physician_Name__c,
                                         Active_User_IND__c,Lens_usage_for_the_Week_IND__c,Hours_in_Surgery__c,
                                         Akreos_AO__c,Akreos_Adapt__c,Akreos_MIL__c,Role_Name__c,Envista__c,Crystalens__c,Acrysof_Single_piece__c,
                                         Acrysof_IQ__c,Acrysof_ReStor__c,Acrysof_Toric__c,Hoya__c,Tecnis__c,Tecnis_Multifocal__c,Remarks__c,
                                         Implant_Competition_Remarks__c, Owner.Name, Product_1__c, Product_2__c,OT_Hours__c
                                         from Physician_Visit__c
                                         Where RecordType.Name IN ('INDSU Sales Planned', 'INDSU Service Planned','THASU Sales Planned', 'THASU Service Planned') AND 
                                         Activity_Date__c = This_Week AND Status__c ='Open' AND
                                         OwnerId = :Userinfo.getUserId() ORDER BY Activity_Date__c DESC];
    }
    system.debug('***list_PhysicianVisitDetails --' + list_PhysicianVisitDetails);
    }
    public List<SelectOption> getViewOptions()    {     
          List<SelectOption> options = new List<SelectOption>();  
          options.add(new SelectOption('3','Last 3 Days'));  
          options.add(new SelectOption('0','Today'));            
          options.add(new SelectOption('7','Current Week'));
          return options;  
    }
         
    public PageReference getPhysicianVisitDetails() {            
         //Fetch the Store Visit details for logged in user  
         BindDataTable(); 
         return null; 
        }
        
    //invoke standard Save method
     public PageReference save() {
      //  controller.save();
      System.debug('list_PhysicianVisitDetails size: '+list_PhysicianVisitDetails.size());
      for(Integer i=0; i< list_PhysicianVisitDetails.size();i++ ){
      
      System.debug('list_PhysicianVisitDetails[i].Visit_Call__c : '+list_PhysicianVisitDetails[i].Visit_Call__c);
      System.debug('list_PhysicianVisitDetails[i].OT_Hours__c : '+list_PhysicianVisitDetails[i].OT_Hours__c );
      System.debug('list_PhysicianVisitDetails[i].Hours_in_Surgery__c : '+list_PhysicianVisitDetails[i].Hours_in_Surgery__c );
      //for check null value
      if(list_PhysicianVisitDetails[i].Hours_in_Surgery__c ==null)
      {
       list_PhysicianVisitDetails[i].Hours_in_Surgery__c='0.0';
      }
      
      if(list_PhysicianVisitDetails[i].Visit_Call__c == True && list_PhysicianVisitDetails[i].OT_Hours__c == True && list_PhysicianVisitDetails[i].Hours_in_Surgery__c == '0.0'){           
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Select Hours in Surgery'));
           return null;            
      }
      if(list_PhysicianVisitDetails[i].Visit_Call__c == True && list_PhysicianVisitDetails[i].OT_Hours__c == False && (list_PhysicianVisitDetails[i].Hours_in_Surgery__c !='0.0') ){           
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Select OT Hours'));
           return null;            
      }
      
      //Added for INDSU -Check value is not blank
      if(userProfile.name.contains('INDSU'))
      {
             // START - Updated by SRIDHAR ALURU, 28th Aug, 2015 to add the fields 'Active_User_IND__c','Lens_usage_for_the_Week_IND__c' 
             
              if(list_PhysicianVisitDetails[i].Active_User_IND__c ==null)
              {
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Active User cannot be blank, please select "Yes" or "No"'));
                   return null;  
              }
              
              if(list_PhysicianVisitDetails[i].Active_User_IND__c =='Yes' && (String.valueOf(list_PhysicianVisitDetails[i].Lens_usage_for_the_Week_IND__c) == null || 
              String.valueOf(list_PhysicianVisitDetails[i].Lens_usage_for_the_Week_IND__c)=='' || String.valueOf(list_PhysicianVisitDetails[i].Lens_usage_for_the_Week_IND__c)== '0'))
              {
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'"Lens Used for the Week" must be > 0 if "Active User" is "Yes"'));
                   return null;  
              }
              
              if(list_PhysicianVisitDetails[i].Active_User_IND__c =='No' && (String.valueOf(list_PhysicianVisitDetails[i].Lens_usage_for_the_Week_IND__c) == null || 
              String.valueOf(list_PhysicianVisitDetails[i].Lens_usage_for_the_Week_IND__c)=='' || String.valueOf(list_PhysicianVisitDetails[i].Lens_usage_for_the_Week_IND__c) > '0'))
              {
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'"Lens Used for the Week" must be 0 if "Active User" is "No"'));
                   return null;  
              }
              
              // END - Updated by SRIDHAR ALURU, 28th Aug, 2015 to add the fields 'Active_User_IND__c','Lens_usage_for_the_Week_IND__c'
              
              if(String.valueOf(list_PhysicianVisitDetails[i].Akreos_AO__c) == null || String.valueOf(list_PhysicianVisitDetails[i].Akreos_AO__c) == '')
              {           
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Akreos Ao cannot be blank please put zero or greater value'));
                   return null;            
              }
              if(String.valueOf(list_PhysicianVisitDetails[i].Akreos_Adapt__c) == null || String.valueOf(list_PhysicianVisitDetails[i].Akreos_Adapt__c) == '')
              {           
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Akreos Adapt cannot be blank please put zero or greater value'));
                   return null;            
              }
              if(String.valueOf(list_PhysicianVisitDetails[i].Akreos_MIL__c) == null || String.valueOf(list_PhysicianVisitDetails[i].Akreos_MIL__c) == '')
              {           
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Akreos MIL cannot be blank please put zero or greater value'));
                   return null;            
              }
              if(String.valueOf(list_PhysicianVisitDetails[i].Envista__c) == null || String.valueOf(list_PhysicianVisitDetails[i].Envista__c) == '')
              {           
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Envista cannot be blank please put zero or greater value'));
                   return null;            
              }
              if(String.valueOf(list_PhysicianVisitDetails[i].Crystalens__c) == null || String.valueOf(list_PhysicianVisitDetails[i].Crystalens__c) == '')
              {           
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Crystalens cannot be blank please put zero or greater value'));
                   return null;            
              }
              if(String.valueOf(list_PhysicianVisitDetails[i].Acrysof_IQ__c) == null || String.valueOf(list_PhysicianVisitDetails[i].Acrysof_IQ__c) == '')
              {           
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'enVista Toric cannot be blank please put zero or greater value'));
                   return null;            
              }
           
          //Validate for product value cannot more than 3 digit
           if(String.valueOf(list_PhysicianVisitDetails[i].Akreos_AO__c).length()>3 )
              {           
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Error: Akreos AO Number is too large.It cannot be more than 3 digit'));
                   return null;            
              }
               if(String.valueOf(list_PhysicianVisitDetails[i].Akreos_Adapt__c).length()>3)
              {           
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Error: Akreos Adapt Number is too large.It cannot be more than 3 digit'));
                   return null;            
              }
              if(String.valueOf(list_PhysicianVisitDetails[i].Akreos_MIL__c).length()>3)
              {           
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Error: Akreos MIL Number is too large.It cannot be more than 3 digit'));
                   return null;            
              }
              if(String.valueOf(list_PhysicianVisitDetails[i].Envista__c).length()>3)
              {           
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Error: Envista Number is too large.It cannot be more than 3 digit'));
                   return null;            
              }
              if(String.valueOf(list_PhysicianVisitDetails[i].Crystalens__c).length()>3)
              {           
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Error: Crystalens Number is too large.It cannot be more than 3 digit'));
                   return null;            
              }
              if(String.valueOf(list_PhysicianVisitDetails[i].Acrysof_IQ__c).length()>3)
              {           
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Error: enVista Toric Number is too large.It cannot be more than 3 digit'));
                   return null;            
              }
       }
     
      System.debug('i: '+i);
      System.debug(list_PhysicianVisitDetails[i].id + ' : Visit_Call__c : '+list_PhysicianVisitDetails[i].Visit_Call__c);
      
      if(list_PhysicianVisitDetails[i].Visit_Call__c == True && list_PhysicianVisitDetails[i].Status__c == 'Open')
      {
          
            Physician_Visit__c updatepv = new Physician_Visit__c();
           
            updatepv.Id = list_PhysicianVisitDetails[i].Id ;
            updatepv.Visit_Call__c = list_PhysicianVisitDetails[i].Visit_Call__c;
            
            // START - Updated by SRIDHAR ALURU, 28th Aug, 2015 to add the fields 'Active_User_IND__c','Lens_usage_for_the_Week_IND__c'
            updatepv.Active_User_IND__c = list_PhysicianVisitDetails[i].Active_User_IND__c;
            updatepv.Lens_usage_for_the_Week_IND__c = list_PhysicianVisitDetails[i].Lens_usage_for_the_Week_IND__c;
            // END - Updated by SRIDHAR ALURU, 28th Aug, 2015 to add the fields 'Active_User_IND__c','Lens_usage_for_the_Week_IND__c'
            
            updatepv.Hours_in_Surgery__c = list_PhysicianVisitDetails[i].Hours_in_Surgery__c ;
            updatepv.Akreos_AO__c = list_PhysicianVisitDetails[i].Akreos_AO__c ;
            updatepv.Akreos_Adapt__c = list_PhysicianVisitDetails[i].Akreos_Adapt__c ;
            updatepv.Akreos_MIL__c = list_PhysicianVisitDetails[i].Akreos_MIL__c ;
            updatepv.Acrysof_Single_piece__c = list_PhysicianVisitDetails[i].Acrysof_Single_piece__c ;
            updatepv.Envista__c = list_PhysicianVisitDetails[i].Envista__c ;
            updatepv.Crystalens__c = list_PhysicianVisitDetails[i].Crystalens__c  ;
            updatepv.Acrysof_Single_piece__c = list_PhysicianVisitDetails[i].Acrysof_Single_piece__c ;
            updatepv.Acrysof_IQ__c = list_PhysicianVisitDetails[i].Acrysof_IQ__c ;
            updatepv.Acrysof_ReStor__c = list_PhysicianVisitDetails[i].Acrysof_ReStor__c ;
            updatepv.Acrysof_Toric__c = list_PhysicianVisitDetails[i].Acrysof_Toric__c ;
            updatepv.Hoya__c = list_PhysicianVisitDetails[i].Hoya__c ;
            updatepv.Tecnis__c = list_PhysicianVisitDetails[i].Tecnis__c ;
            updatepv.Tecnis_Multifocal__c = list_PhysicianVisitDetails[i].Tecnis_Multifocal__c ;
            updatepv.Remarks__c = list_PhysicianVisitDetails[i].Remarks__c ;
            updatepv.Implant_Competition_Remarks__c = list_PhysicianVisitDetails[i].Implant_Competition_Remarks__c ;
            updatepv.Product_1__c = list_PhysicianVisitDetails[i].Product_1__c ;
            updatepv.Product_2__c  = list_PhysicianVisitDetails[i].Product_2__c ;
            updatepv.OT_Hours__c = list_PhysicianVisitDetails[i].OT_Hours__c;
            updatepv.Status__c = 'Completed' ;
            //added on 10-12-2013 to check Activirt_date__c
            updatepv.Activity_Date__c = list_PhysicianVisitDetails[i].Activity_Date__c;
            system.debug('**before updatepv.Activity_Date__c ' + updatepv.Activity_Date__c);
           /* if(updatepv.Activity_Date__c > System.today()){
                updatepv.Activity_Date__c = System.today();
            }*/          
            system.debug('**after updatepv.Activity_Date__c ' + updatepv.Activity_Date__c);
            set_UdatePhysicianVisitDetails.add(updatepv);
          }
      }
      list_UdatePhysicianVisitDetails.addAll(set_UdatePhysicianVisitDetails);
      System.debug('Before update '+ list_UdatePhysicianVisitDetails);  
      String error;
      update list_UdatePhysicianVisitDetails;  
     /* try{
      update list_UdatePhysicianVisitDetails;      
      }
      catch(DmlException e){
        error = String.valueOf(e);
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,error ));
      } */
      
     
      PageReference pageRef = ApexPages.currentPage();
      pageRef.setRedirect(true);
      return pageRef;
    }
    public PageReference newUnplannedvisit()
    {
        PageReference pg = new PageReference('/apex/INDSU_Unplanned_Physician_Visit');
        pg.setRedirect(true);
        return pg;
    }
    
    public String getExistingPhysicianVisitMTD(){
        
        String sreUserName = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
        List<Physician_Visit__c> lstPVOfUserMTD = new List<Physician_Visit__c>();
        Integer noOfOpenPV = 0;
        
        lstPVOfUserMTD = [SELECT ID from Physician_Visit__c 
                            WHERE Status__c = 'Open'
                            AND OwnerID =: UserInfo.getUserID()//uncomment when in qa or running by user
                            AND Activity_Date__c = THIS_MONTH];
        
        System.debug('lstPVOfUserMTD size: ' + lstPVOfUserMTD.size());
        
        if(lstPVOfUserMTD.size()> 0){
            noOfOpenPV = lstPVOfUserMTD.size();
        }
        
        if(noOfOpenPV > 0){
            strMessage = 'Hello ' + sreUserName + '. You have ' + noOfOpenPV + ' open physician visits for this month. Please do the needful.' ;
        }
        else{
            strMessage = 'Hello ' + sreUserName + '. You have no open physician visits for this month. Please click on New to create an unplanned physician visit.' ;
        }
        
        return strMessage;
    }
}