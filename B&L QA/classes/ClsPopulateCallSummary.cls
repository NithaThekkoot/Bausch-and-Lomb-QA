/**
 * 
 *   INDSU class to populate empty Call Summary records for all Sales and Service Executives in the begin of the day. 
 *
 *   Author             |Author-Email                            |Date        |Comment
 *   -------------------|--------------------------------------  |------------|--------------------------------------------------
 *   Balaji             |balaji.prabakaran@listertechnologies.com|30.04.2010  |Reuse of this class from APAC VC ClssPopulateCallSummary 
 *   Sourav Mitra       |sourav.mitra@listertechnologies.com     |08.09.2010  |Changes to incorporate China SU
 *   Rajesh Sriramulu   |rajesh.sriramulu@rishabhsoft.com        |27.06.2012  |added Profiles for KORSU
 *   BP Shibin          |jojo.shi@ibreakingpoint.com             |14.08.2012  |added Profiles for Engineer and Technical Service
 *   Raviteja Vakity    |Raviteja.vakity@bausch.com              |30-Nov-2012 |Update the logic for INDSU as work days for India is 6 Days a week  
 *   Raviteja Vakity    |Raviteja.vakity@bausch.com              |30-Nov-2012 |Update the logic for Calculating the Non-field working days  
 */
public with sharing class ClsPopulateCallSummary {
  
  public void Populate(){
    //Set of profile ids of INDSU Sales Executive and Service Executive. 
    Set<Id> set_ProfileId = new Set<Id>();    
    //Map of profile Ids and names of INDSU Sales Executive and Service Executive.
    Map<Id, String> map_ProfileId_Name = new Map<Id, String>();    
    //For-loop: To fetch and populate the above set and map 
    for(Profile p:[Select Id, Name From Profile Where Name in ('INDSU Sales Rep','APACSU KOR Sales Rep','APACSU KOR Service Rep', 'INDSU Service Rep','APACSU Sales Rep','APACSU Service Rep','APACSU Service Engineer','APACSU Technical Service')]){
      set_ProfileId.add(p.Id);
      map_ProfileId_Name.put(p.Id, p.Name);
    }                  
    //Set of users who don't have a entry in Call Summary for today.                  
    Set<Id> set_UserId = new Set<Id>();
    for (Call_Summary__c cs:[Select OwnerId From Call_Summary__c Where Date__c = today]){
      set_UserId.add(cs.OwnerId);
    } 
    //List of users for whom to create call summary entries.    
    List<User> list_User = [Select Id, APAC_Country__c, APAC_Region__c, APAC_Area__c, ProfileId, UserRole.Name From User
                Where ProfileId in :set_ProfileId And Id not in :set_UserId And IsActive=True]; 
    //Business_Day_or_not__c is '0' on Weekends and '1' on Weekdays
    Datetime dtmVisitDate = Datetime.newInstance(System.today(), Time.newInstance(0,0,0,0));
    String strWeekday = dtmVisitDate.format('E');
    Boolean blnBusinessDay = TRUE;
    /* if(strWeekday == 'Sat' || strWeekday == 'Sun'){
            blnBusinessDay = FALSE;
        }   */ // commented by Raviteja for Update the logic for INDSU as work days for India is 6 Days a week 
        
    //List of Call Summary records to create.
    List<Call_Summary__c> list_CallSummary = new List<Call_Summary__c>();
    for (User u:list_User){ 
      //Unique value to represent a call summary record.
      String strUnique = String.valueOf(u.Id)+String.valueOf(System.today());
      if(strWeekday == 'Sat' || strWeekday == 'Sun'){ // Update the logic for INDSU as work days for India is 6 Days a week
            if(u.UserRole.Name != null && u.UserRole.Name.contains('INDSU') && strWeekday == 'Sat'){
                        blnBusinessDay = TRUE;
                        }
                    else{
                        blnBusinessDay = FALSE;
                        }
      }          
      Call_Summary__c objCallSummary = new Call_Summary__c();
      objCallSummary.Country__c = u.APAC_Country__c;
      objCallSummary.RegionINDSU__c = String.valueOf(u.APAC_Region__c);
      objCallSummary.Area__c = u.APAC_Area__c;
      objCallSummary.Date__c = System.today();
      objCallSummary.Business_Day_or_not__c = blnBusinessDay;
      objCallSummary.Actual_Calls__c = 0;
      objCallSummary.Planned_Calls__c = 0;
      objCallSummary.Targeted_Calls__c = 0; 
      if(U.UserRole.Name != null && U.Userrole.name.contains('INDSU') && !Test.isRunningTest()){ // Raviteja -- Calculating the Non-field working days for INDSU users
          objCallSummary.Non_field_working_days__c = Nonfieldworkingday(objCallSummary.Date__c,u.Id);
      }      
        /***************
        //Modified By : Rohit Kumar Verma on <Date : 19/09/2012> <Requirement : To Display the Total Number of Contacts Associated with User and Profile "Sales Rep">.  -- Start        
        **************/         
        integer totalContact = 0;
        List<Contact> conList = [select name from contact where accountId in (select accountId from accountTeamMember where userId =:u.Id)];
        totalContact = conList.Size();
        system.debug('Finally Total Customers : ' + conList +'\n Size : '+totalContact);    
        objCallSummary.Total_Customers__c = totalContact;   
        /***************
        //Modified By : Rohit Kumar Verma on <Date : 19/09/2012> <Requirement : To Display the Total Number of Contacts Associated with User and Profile "Sales Rep">.  -- End      
        **************/ 
       String strProfile = map_ProfileId_Name.get(u.ProfileId);
          if (strProfile.contains('Service')){
            strProfile = 'Service';
          }else{
            strProfile = 'Sales';
          }
      objCallSummary.Profile__c = strProfile;
      objCallSummary.OwnerId = u.Id;
      objCallSummary.Unique__c = strUnique;   
      list_CallSummary.add(objCallSummary);
    }
    system.debug('Call Summary ' + list_CallSummary +'\n Size : '+list_CallSummary.Size());
    //To update the call summary.
    if (list_CallSummary.Size()>0){
      Database.upsert(list_CallSummary,Call_Summary__c.Unique__c,false);
    }
  }
     // Raviteja -- Calculating the Non-field working days
     Public static double Nonfieldworkingday(date visitdate, String PvownerId){         
        double Nonfieldworkdays = 0;
        System.debug ('visit date: '+visitdate+'PvownerId: '+PvownerId);           
        List<Other_Call_Activity__c> list_OCA = [select OwnerId, End_Date__c, Start_Date__c, Start_Session__c, End_Session__c from Other_Call_Activity__c where OwnerId = : PvownerId AND  (((Start_Date__c = :visitdate) OR (End_Date__c = :visitdate)) OR ((Start_Date__c > :visitdate) AND (End_Date__c < :visitdate))) order by Start_Date__c limit 5];        
        System.debug ('list_OCA: '+list_OCA );
        if(list_OCA.size() > 0){
            for(Other_Call_Activity__c oca : list_OCA){
                if(visitdate == oca.Start_Date__c && visitdate == oca.End_Date__c){  // If other call activity for single day
                    if(oca.Start_Session__c == oca.End_Session__c){
                        Nonfieldworkdays += 0.5;
                    }else {
                        Nonfieldworkdays += 1;
                        }                
                }
                else{                
                    System.debug('oca.Start_Date__c.daysBetween(oca.End_Date__c):'+oca.Start_Date__c.daysBetween(oca.End_Date__c));
                    if(oca.Start_Date__c.daysBetween(oca.End_Date__c) > 0){ // If other call activity for multiple days
                        Nonfieldworkdays += 1;  
                    }
                
                }
            }
        
        }
        return Nonfieldworkdays;
    } // Nonfieldworkingday() End
}