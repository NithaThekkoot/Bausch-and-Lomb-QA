/* Test Class for the below class is CtrlINDSUPhysicianVisiting_Test
Tarun Solanki       | 26-05-2014 |Tarun.Solanki@bausch.com        |Modified to add a variable set to avoid errors related to issue of duplicate pv in list

*/

public class CtrlINDAESPhysicianVisiting 
{

    Public list<Physician_Visit__c> list_PhysicianVisitDetails {get;set;}
    Public List<Physician_Visit__c> list_UdatePhysicianVisitDetails = new list<Physician_Visit__c>();
    
    //errMsg
    Public Set<Physician_Visit__c> set_UdatePhysicianVisitDetails = new Set<Physician_Visit__c>();
    Public Id currentUerId;
    Public boolean isIndiaUser {get;set;}
    public Integer intSelectedDays;//Value selected for View picklist  
    Public Date weekStartDate;
    Public Date weekEndDate;
    public String strMessage {get; set; }
      public Integer getintSelectedDays(){    
          return intSelectedDays;   
           }  
      public void setintSelectedDays(Integer intSelectedDays){   
                this.intSelectedDays = intSelectedDays; 
           }
    
       public CtrlINDAESPhysicianVisiting (Apexpages.StandardController c){
           // controller = c;
        }
   public CtrlINDAESPhysicianVisiting (){ 
       date myDate = date.today();
       date weekStart = myDate.toStartofWeek();         
       weekStartDate= weekStart.addDays(1);
       weekEndDate=weekStart.addDays(6);
       
       intSelectedDays = 3;
       getExistingPhysicianVisitMTD();          
       //For get user profile
       String uProfileId = UserInfo.getProfileId();
       Profile userProfile=[Select name from profile where id=:uProfileId limit 1];
                  
       BindDataTableforIndia();     
      

   }

   //Created by Tarun Solanki , 25th Apr, 2014 for India AES Physician visit for Today only
   public void BindDataTableforIndia()
   {
       list_PhysicianVisitDetails = [select Visit_Call__c,Activity_Date__c,Planned_Call__c,Status__c, Hospital_Name__c,Physician_Name__c,Remarks__c,
                                          Owner.Name, Product_1__c, Product_2__c,Hours_in_Surgery__c,OT_Hours__c from Physician_Visit__c
                                         Where RecordType.Name IN ('INDSU Sales Planned') AND                                          
                                         Activity_Date__c >= : weekStartDate AND Activity_Date__c <= : weekEndDate AND Status__c ='Open' AND
                                         OwnerId = :Userinfo.getUserId()];
    
    }       
   /*public void BindDataTable(){
    //Modified by Neha Jain , 17th Feb, 2014 for Thailand SU Physician Visits Record Types
    if(intSelectedDays == 0 || intSelectedDays==null){
         list_PhysicianVisitDetails = [select Visit_Call__c,Activity_Date__c,Planned_Call__c,Status__c, Hospital_Name__c,Physician_Name__c,Remarks__c,
                                          Owner.Name, Product_1__c, Product_2__c from Physician_Visit__c
                                         Where RecordType.Name IN ('INDSU Sales Planned') AND                                        
                                         Activity_Date__c = LAST_N_DAYS:0 AND Status__c ='Open' AND
                                         OwnerId = :Userinfo.getUserId()];
    }
    else if(intSelectedDays == 7){
         list_PhysicianVisitDetails = [select Visit_Call__c,Activity_Date__c,Planned_Call__c,Status__c, Hospital_Name__c,Physician_Name__c,Remarks__c,
                                          Owner.Name, Product_1__c, Product_2__c from Physician_Visit__c
                                         Where RecordType.Name IN ('INDSU Sales Planned') AND 
                                         Activity_Date__c >= : weekStartDate AND Activity_Date__c <= : weekEndDate AND Status__c ='Open' AND
                                         OwnerId = :Userinfo.getUserId() ORDER BY Activity_Date__c DESC ];
    }
    system.debug('***list_PhysicianVisitDetails --' + list_PhysicianVisitDetails);
    }*/
    public List<SelectOption> getViewOptions()    {     
          List<SelectOption> options = new List<SelectOption>();              
          options.add(new SelectOption('7','Current Week'));
          return options;  
    }
         
    public PageReference getPhysicianVisitDetails() {            
         //Fetch the Store Visit details for logged in user  
         BindDataTableforIndia(); 
         return null; 
        }
        
    //invoke standard Save method
     public PageReference save() {
                  
      for(Integer i=0; i< list_PhysicianVisitDetails.size();i++ ){
           
      
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
      
      if(list_PhysicianVisitDetails[i].Visit_Call__c == True && list_PhysicianVisitDetails[i].Status__c == 'Open')
      {
          
            Physician_Visit__c updatepv = new Physician_Visit__c();
           
            updatepv.Id = list_PhysicianVisitDetails[i].Id ;
            updatepv.Visit_Call__c = list_PhysicianVisitDetails[i].Visit_Call__c;         
            updatepv.Remarks__c = list_PhysicianVisitDetails[i].Remarks__c ;
           updatepv.Hours_in_Surgery__c = list_PhysicianVisitDetails[i].Hours_in_Surgery__c ;
            updatepv.Product_1__c = list_PhysicianVisitDetails[i].Product_1__c ;
            updatepv.Product_2__c  = list_PhysicianVisitDetails[i].Product_2__c ;
           updatepv.OT_Hours__c = list_PhysicianVisitDetails[i].OT_Hours__c;
            updatepv.Status__c = 'Completed' ;
            //added on 10-12-2013 to check Activirt_date__c
            updatepv.Activity_Date__c = list_PhysicianVisitDetails[i].Activity_Date__c;
            system.debug('**before updatepv.Activity_Date__c ' + updatepv.Activity_Date__c);
            /*if(updatepv.Activity_Date__c > System.today()){
                updatepv.Activity_Date__c = System.today();
            } */         
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
        PageReference pg = new PageReference('/apex/INDAES_Unplanned_Physician_Visit');
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