/** 
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 *
 *
 *    Author         |Author-Email                  |Date       |Comment
 *    ---------------|------------------------------|-----------|--------------------------------------------------
 *    Parag Sharma   |parag.sharma@rishabhsoft.com       |12.Apr.2013 |First draft
 *    Parag Sharma   |parag.sharma@bausch.com            |18.June.2013 |Custom Label added for Field days
 *    Tarun Solanki  |Tarun.Solanki@bausch.com     |02.10.2013 |Changes where User can extract the report with/without master data
 *   Neha Jain       |neha.jain@bausch.com          |12-03-2014| Modified the code for average calculation. Now Avg will be calculated 
                                                                 for 6 days in a week and not by field days
 */
 
// public with sharing class clsSFEPlanMatrixCustomReport {

   public class clsSFEPlanMatrixCustomReport {

    Public Id APACId {get;set;}
    Public List<Call_Summary__c> lstCallSumamry{get; set;}
    Public Call_Summary__c ObjCallSumamry {get; set;}
    Public List<CallSummary> lstCallSummary {get; set;}
    Public CallSummary ObjCallSummary {get; set;}
    Public CallSummary ObjTotalCallSummary {get; set;}
    Public String sDate {get; set;}
    Public String eDate {get; set;}
    Public Date StartDate {get; set;}
    Public Date EndDate {get; set;}
    Public String header{get; set;}
    Public String monthName {get; set;}
    Public String YearName {get; set;}
    Public String strSelectedMonth {get; set;}
    Public List<User> lstUser {get; set;}
    Public Set<String> setUserId {get; set;}
    Public Set<Id> setNotInUserID {get; set;}
    Public Map<String,Integer> MapUserAccount {get; set;}
    Public List<User> lstManager {get; set;}
    Public Map<ID,String> MapUsermanager {get; set;}
    
    
    Public Map<ID,ID> MapmanagerIdbyUserId {get; set;}

    Public String dayOfWeek {get; set;}
    Public Date WeekStartDate {get;set;}
    Public Date WeekEndDate {get;set;}

    Public String strGrandTotal {get; set;}
    
    //start date of a RBD month
    public date datMonthStartDate {get; set;}
    //end date of a RBD month
    public date datMonthEndDate {get; set;}
    //start date of a RBD month for clone case
    public date datClonedMonthStartDate {get; set;}
    //end date of a RBD month for clone case
    public date datClonedMonthEndDate {get; set;}
    //reference date
    public Date datRefDate {get; set;}
    private  final Integer intQuarterDays = 13 * 7;
    
    //Added by tarun
     //Public Variables
    public boolean blnIsMasterDataHidden {get; set;}    
    public String strValue {get; set;}
    public boolean blnIsUserSysAdminSSO {get; set;}
    private String strMyProflieName='';

    public clsSFEPlanMatrixCustomReport() {
         datMonthStartDate = null;
         datMonthEndDate = null;
         datRefDate = null;
         StartDate = null;
         EndDate = null;
         sDate = null;
         eDate = null;

         setUserId = New Set<String>();
         setNotInUserID = New Set<Id>();
         MapUserAccount = New Map<String,Integer>();
         lstUser = New List<User>();
         //IntCounter = 0;
         
         lstCallSumamry = New List<Call_Summary__c>(lstCallSumamry);
         ObjCallSumamry = New Call_Summary__c();
         lstCallSummary = New List<CallSummary>();
         ObjCallSummary = New CallSummary();
         ObjTotalCallSummary = New CallSummary();
           //Added by tarun
         blnIsMasterDataHidden = false;
         
         List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
         strMyProflieName = PROFILE[0].Name;
         if(strMyProflieName.Contains('System Admin SSO')){
             blnIsUserSysAdminSSO= true;
         }
         else{
             blnIsUserSysAdminSSO= false;
         }
         InitCurrentMonth();
    }


    public clsSFEPlanMatrixCustomReport(ApexPages.StandardController controller) {

         datMonthStartDate = null;
         datMonthEndDate = null;
         datRefDate = null;
         StartDate = null;
         EndDate = null;
         sDate = null;
         eDate = null;

         setUserId = New Set<String>();
         setNotInUserID = New Set<Id>();
         MapUserAccount = New Map<String,Integer>();
         lstUser = New List<User>();
         //IntCounter = 0;
         
         lstCallSumamry = New List<Call_Summary__c>(lstCallSumamry);
         ObjCallSumamry = New Call_Summary__c();
         lstCallSummary = New List<CallSummary>();
         ObjCallSummary = New CallSummary();
         ObjTotalCallSummary = New CallSummary();
           //Added by tarun
         blnIsMasterDataHidden = false;
         
         List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
         strMyProflieName = PROFILE[0].Name;
         if(strMyProflieName.Contains('System Admin SSO')){
             blnIsUserSysAdminSSO= true;
         }
         else{
             blnIsUserSysAdminSSO= false;
         }
         InitCurrentMonth();
    }

    Public String strMonth {get; set;}
    Public String strStartMonth {get; set;}
    Public String strEndMonth {get; set;}
    Public void InitCurrentMonth(){
        DateTime d = datetime.now();
        dayOfWeek=d.format('EEEE');
        WeekStartDate = WeekStartDate(dayOfWeek);
        WeekEndDate = WeekEndDate(dayOfWeek);
        
        System.debug('WeekStartDate = '+WeekStartDate);
        System.debug('WeekEndDate = '+WeekEndDate);
        monthName= d.format('MMMMM');        
        YearName= d.format('yyyy');
        strMonth = String.valueOf(monthName.substring(0,3));  
        
        System.debug('strMonth = '+strMonth);
        
        datMonthStartDate = WeekStartDate;
        datMonthEndDate = WeekEndDate;        
        strStartMonth = MonthName(String.valueOf(datMonthStartDate.month()));
        strEndMonth = MonthName(String.valueOf(datMonthEndDate.month()));
        System.debug('datMonthStartDate = '+datMonthStartDate);
        System.debug('datMonthEndDate = '+datMonthEndDate);          
        System.debug('strStartMonth = '+strStartMonth);
        System.debug('strEndMonth = '+strEndMonth);
        
        DisplayCallSummary();
    }    

    Public Integer IntCounter =0;
    Public void DisplayCallSummary(){
    
        strStartDate = WeekStartDate.day() + '-' + WeekStartDate.Month() + '-' + WeekStartDate.year();
        strEndDate = WeekEndDate.day() + '-' + WeekEndDate.Month() + '-' + WeekEndDate.year();
                
        String sProfile = 'INDSU Sales Rep';
        String sProfile1 = 'INDSU Service Rep';
        String strCountry = Label.Country_SFE_Custom_Report;
        String strProfileName = 'INDSU Sales Rep';
        String strProfileName1 = 'INDSU Service Rep';
                
        List<AggregateResult> lstCallPlan = New List<AggregateResult>();
        IF(strStartMonth == strEndMonth){
            /*lstCallPlan = [SELECT Id, OwnerId, Owner.Name, Month__c, City__c, Number_of_Contacts__c, Number_of_Contacts_of_A__c, Number_of_Contacts_of_B__c, Number_of_Contacts_of_C__c, Number_of_Contacts_of_Others__c, Region__c, Status__c, 
                                                 (SELECT Id, Call_Plan__c, Date__c FROM Call_Plan_Detail__r WHERE Date__c >=: datMonthStartDate  AND Date__c <=: datMonthEndDate)
                                                  FROM Call_Plan__c Where Year__c =: YearName AND Month__c =: strStartMonth AND Status__c != 'Rejected' AND Country__c =: strCountry ORDER BY Region__c, Owner.Name ASC LIMIT 800];*/
            /*lstCallPlan =  [SELECT Id, Call_Plan__r.OwnerId, Call_Plan__r.Owner.Name, Call_Plan__r.Month__c, Call_Plan__r.City__c, Call_Plan__r.Number_of_Contacts__c, Call_Plan__r.Number_of_Contacts_of_A__c, Call_Plan__r.Number_of_Contacts_of_B__c, Call_Plan__r.Number_of_Contacts_of_C__c, Call_Plan__r.Number_of_Contacts_of_Others__c, Call_Plan__r.Region__c, Call_Plan__r.Status__c, 
                                                  Call_Plan__c, Date__c FROM Call_Plan_Detail__c WHERE Date__c >=: datMonthStartDate  AND Date__c <=: datMonthEndDate
                                                  AND Call_Plan__r.Year__c =: YearName AND Call_Plan__r.Month__c =: strStartMonth AND Call_Plan__r.Status__c != 'Rejected' AND Call_Plan__r.Country__c =: strCountry ORDER BY Call_Plan__r.Region__c, Call_Plan__r.Owner.Name ASC LIMIT 800];*/
            lstCallPlan =  [SELECT Call_Plan__r.Region__c Reg, Call_Plan__r.OwnerId RId, Call_Plan__r.Owner.Name RName, COUNT(Id) CPDId,  MAX(Call_Plan__r.Number_of_Contacts__c) NoofCon, MAX(Call_Plan__r.Number_of_Contacts_of_A__c) NoofConA, MAX(Call_Plan__r.Number_of_Contacts_of_B__c) NoofConB, MAX(Call_Plan__r.Number_of_Contacts_of_C__c) NoofConC, MAX(Call_Plan__r.Number_of_Contacts_of_Others__c) NoofConOthers, COUNT_DISTINCT(Date__c) RDate, 
                            Call_Plan__r.City__c City, Call_Plan__r.Month__c Mon, Call_Plan__r.Status__c Status  FROM Call_Plan_Detail__c WHERE Date__c >=: datMonthStartDate  AND Date__c <=: datMonthEndDate
                            AND Call_Plan__r.Year__c =: YearName AND Call_Plan__r.Owner.Userrole.Name like '%INDSU%' AND Call_Plan__r.Month__c =: strStartMonth AND Call_Plan__r.Status__c != 'Rejected' AND Call_Plan__r.Country__c =: strCountry GROUP BY Call_Plan__r.OwnerId, Call_Plan__r.Region__c, Call_Plan__r.Owner.Name, Call_Plan__r.Month__c, Call_Plan__r.City__c, Call_Plan__r.Status__c ORDER BY Call_Plan__r.Region__c, Call_Plan__r.Owner.Name ASC LIMIT 800];
        } Else {
            /*lstCallPlan = [SELECT Id, OwnerId, Owner.Name, Month__c, City__c, Number_of_Contacts__c, Number_of_Contacts_of_A__c, Number_of_Contacts_of_B__c, Number_of_Contacts_of_C__c, Number_of_Contacts_of_Others__c, Region__c, Status__c, 
                                                 (SELECT Id, Call_Plan__c, Date__c FROM Call_Plan_Detail__r WHERE Date__c >=: datMonthStartDate  AND Date__c <=: datMonthEndDate)
                                                  FROM Call_Plan__c Where Year__c =: YearName AND (Month__c =: strStartMonth OR Month__c =: strEndMonth) AND Country__c =: strCountry ORDER BY Region__c, Owner.Name ASC LIMIT 800];*/
            lstCallPlan =  [SELECT Call_Plan__r.Region__c Reg, Call_Plan__r.OwnerId RId, Call_Plan__r.Owner.Name RName, COUNT(Id) CPDId,  MAX(Call_Plan__r.Number_of_Contacts__c) NoofCon, MAX(Call_Plan__r.Number_of_Contacts_of_A__c) NoofConA, MAX(Call_Plan__r.Number_of_Contacts_of_B__c) NoofConB, MAX(Call_Plan__r.Number_of_Contacts_of_C__c) NoofConC, MAX(Call_Plan__r.Number_of_Contacts_of_Others__c) NoofConOthers, COUNT_DISTINCT(Date__c) RDate, 
                            Call_Plan__r.City__c City, Call_Plan__r.Month__c Mon, Call_Plan__r.Status__c Status  FROM Call_Plan_Detail__c WHERE Date__c >=: datMonthStartDate  AND Date__c <=: datMonthEndDate
                            AND Call_Plan__r.Year__c =: YearName AND Call_Plan__r.Owner.Userrole.Name like '%INDSU%' AND (Call_Plan__r.Month__c =: strStartMonth OR Call_Plan__r.Month__c =: strEndMonth) AND Call_Plan__r.Status__c != 'Rejected' AND Call_Plan__r.Country__c =: strCountry GROUP BY Call_Plan__r.OwnerId, Call_Plan__r.Region__c, Call_Plan__r.Owner.Name, Call_Plan__r.Month__c, Call_Plan__r.City__c, Call_Plan__r.Status__c ORDER BY Call_Plan__r.Region__c, Call_Plan__r.Owner.Name ASC LIMIT 800];
        
        }
        System.debug('lstCallPlan = ' + lstCallPlan);  
        System.debug('Tarun** '+datMonthStartDate + ' * '+ datMonthEndDate +' * '+ YearName+ ' * ' +strStartMonth + ' endmonth' +strEndMonth +' Country '+strCountry); 
        
        setUserId = New Set<String>();
        MapUserAccount = New Map<String,Integer>();
        
        FOR(AggregateResult AP: lstCallPlan){
            setUserId.add(AP.get('RId')==null ? null : String.valueOf(AP.get('RId')));            
        }
         MapUsermanager = New Map<ID,String>();
         
         MapmanagerIdbyUserId= New Map<ID,String>();
        list<ID> ManagerIdlist =new list<ID>();
        //get manager list of listcallsummaryuser --Tarun Solanki
        lstManager =New List<User>();
        lstManager = [SELECT Id,manager.id,manager.name FROM User WHERE (Profile.Name =: strProfileName OR Profile.Name =: strProfileName1) AND Id IN : setUserId AND IsActive = TRUE  ORDER BY user.manager.name ASC]; 
       
        FOR(User lm: lstManager)
        {           
            if(MapUsermanager.get(lm.manager.id) == null){
                ManagerIdlist.add(lm.manager.id);
                MapUsermanager.put(lm.manager.id,lm.manager.name);
            }
            MapmanagerIdbyUserId.put(lm.id,lm.manager.id);
        }          
       
        lstUser = New List<User>();
        lstUser = [SELECT user.manager.name ,APAC_Region__c , Name, Profile.Name , APAC_Area__c, APAC_Country__c FROM User WHERE (Profile.Name =: strProfileName OR Profile.Name =: strProfileName1) AND Id NOT IN : setUserId AND IsActive = TRUE  ORDER BY user.manager.name];        
        System.debug('***lstUser = '+lstUser.size()+ ' '+ lstUser[0].manager.name +' ** '+lstUser);
        
        setNotInUserID = New Set<Id>();
        FOR(User lu: lstUser){
            setNotInUserID.add(lu.Id);
        }
        
        List<AggregateResult> AllAccountTeam = [select count(id) cntID, userId from AccountTeamMember 
                                                where UserId IN : setNotInUserID 
                                                group by userid];
        System.debug('AllAccountTeam = '+AllAccountTeam);
        
        FOR(AggregateResult AT: AllAccountTeam){
            //MapUserAccount.put(AT.userId,AllAccountTeam.size());
            MapUserAccount.put(String.valueOf(AT.get('userId')),Integer.valueOf(AT.get('cntID')));
        }
        System.debug('MapUserAccount = '+MapUserAccount);
                  
        lstCallSummary = New List<CallSummary>();
        //List<CallSummary> lstNewCallSummary = New List<CallSummary>();
        CallSummary ObjCallSummary;
        CallSummary ObjTotalCallSummary;

        ObjTotalCallSummary = New CallSummary();
        Integer i=0;
        ID IdUser;
        
        ID IdManagerbyUserId;
        
        Set<String> setDate = New Set<String>();
        Map<Id,List<CallSummary>> mapManagerCallSummary = new Map<Id,List<CallSummary>>();
        FOR(AggregateResult CPlan: lstCallPlan)
        {
        system.debug('**CPlan '+CPlan);
            ObjCallSummary = New CallSummary();
            //ObjTotalCallSummary = New CallSummary();            
            //ObjCallSummary.APID = CPId.OwnerId;
            ObjCallSummary.strName = String.valueOf(CPlan.get('RName'));        
            ObjCallSummary.strRegion = CPlan.get('Reg') ==null ? null : String.valueOf(CPlan.get('Reg'));           
            ObjCallSummary.strCity = CPlan.get('City') ==null ? null : String.valueOf(CPlan.get('City')); 
            ObjCallSummary.strStatus = CPlan.get('Status') ==null ? null : String.valueOf(CPlan.get('Status'));
            ObjCallSummary.strCurrMonth = CPlan.get('Mon') ==null ? null : String.valueOf(CPlan.get('Mon'));
              //By Tarun Solanki           
            
            IdUser=String.valueof(CPlan.get('RId'));           
            
            IdManagerbyUserId =  MapmanagerIdbyUserId.get(IdUser);
            
            ObjCallSummary.strManagerName=MapUsermanager.get(IdManagerbyUserId);
            
            ObjCallSummary.IntTotalAccounts = Integer.valueOf(CPlan.get('NoofCon'));
            ObjCallSummary.IntTotalAccountsofA = CPlan.get('NoofConA') == null ? 0 : Integer.valueOf(CPlan.get('NoofConA'));
            ObjCallSummary.IntTotalAccountsofB = CPlan.get('NoofConB') == null ? 0 : Integer.valueOf(CPlan.get('NoofConB'));
            ObjCallSummary.IntTotalAccountsofC = CPlan.get('NoofConC') == null ? 0 : Integer.valueOf(CPlan.get('NoofConC'));
            ObjCallSummary.IntTotalAccountsOthers = CPlan.get('NoofConOthers') == null ? 0 : Integer.valueOf(CPlan.get('NoofConOthers'));

            ObjTotalCallSummary.strTotal = 'Grand Total ';// + ObjCallSummary.strRegion; 
            ObjTotalCallSummary.IntTotTotalAccounts += ObjCallSummary.IntTotalAccounts; 
            ObjTotalCallSummary.IntTotTotalAccountsofA += ObjCallSummary.IntTotalAccountsofA;
            ObjTotalCallSummary.IntTotTotalAccountsofB += ObjCallSummary.IntTotalAccountsofB;
            ObjTotalCallSummary.IntTotTotalAccountsofC += ObjCallSummary.IntTotalAccountsofC;
            ObjTotalCallSummary.IntTotTotalAccountsOthers += ObjCallSummary.IntTotalAccountsOthers;  
                    
            setDate = New Set<String>();
            /*FOR(Call_Plan_Detail__c APD: CPlan.Call_Plan_Detail__r){                
                setDate.add(String.valueOf(APD.Date__c));
                System.debug('setDate.size() = ' + setDate);
                System.debug('APD.Call_Plan__c == CPlan.Id = ' + APD.Call_Plan__c + ' AND ' + CPlan.Id);                
                IF(APD.Call_Plan__c == CPlan.Id){                    
                    ObjCallSummary.IntSubmittedCallPlans = CPlan.Call_Plan_Detail__r.size();                    
                    System.debug('ObjCallSummary.IntSubmittedCallPlans = ' + ObjCallSummary.IntSubmittedCallPlans);
                    //break;
                }                
            }*/
            ObjCallSummary.IntSubmittedCallPlans = CPlan.get('CPDId') ==null ? null : Integer.valueOf(CPlan.get('CPDId'));
            ObjTotalCallSummary.IntTotalSubmittedCallPlans += ObjCallSummary.IntSubmittedCallPlans;
system.debug('##ObjTotalCallSummary.IntSubmittedCallPlans '+ObjCallSummary.IntSubmittedCallPlans);
            //System.debug('setDate.size() = ' + setDate.size());
            ObjCallSummary.IntFieldDays = CPlan.get('RDate') ==null ? null : Integer.valueOf(CPlan.get('RDate')); //setDate.size();
            ObjTotalCallSummary.IntTotalFieldDays += ObjCallSummary.IntFieldDays; 
            
            //Modified by Neha Jain, for changing the avg calculation for fix no. of field days in a week
            IF(Decimal.valueOf(ObjCallSummary.IntFieldDays) > 0) {           
                //ObjCallSummary.IntAvgCallDay = Decimal.valueOf(ObjCallSummary.IntSubmittedCallPlans) / Decimal.valueOf(ObjCallSummary.IntFieldDays);
               ObjCallSummary.IntAvgCallDay = Decimal.valueOf(ObjCallSummary.IntSubmittedCallPlans) /Decimal.valueOf(Label.SFE_Field_Days) ;
            } Else{
                ObjCallSummary.IntAvgCallDay = 0;
            }
            ObjCallSummary.IntAvgCallDay = ObjCallSummary.IntAvgCallDay.setscale(2);
            /*IF(Decimal.valueOf(ObjTotalCallSummary.IntTotalFieldDays) > 0){
                 //Modified by Neha Jain, for changing the avg calculation for fix no. of field days in a week
                //ObjTotalCallSummary.IntTotalAvgCallDay = Decimal.valueOf(ObjTotalCallSummary.IntTotalSubmittedCallPlans) / Decimal.valueOf(ObjTotalCallSummary.IntTotalFieldDays);
                ObjTotalCallSummary.IntTotalAvgCallDay = Decimal.valueOf(ObjTotalCallSummary.IntTotalSubmittedCallPlans)/Decimal.valueOf(Label.SFE_Field_Days) ;
                ObjTotalCallSummary.IntTotalAvgCallDay = ObjTotalCallSummary.IntTotalAvgCallDay.setscale(2);
            } Else {
                ObjTotalCallSummary.IntTotalAvgCallDay = 0;

            }*/
            System.debug('Test = '+ObjCallSummary.IntFieldDays);            
            //Intialize the list to add in map to sort for managers
            List<CallSummary> lstNewCallSummary = New List<CallSummary>();
            //if manager already exists in map, retrive its list
            if(mapManagerCallSummary.get(IdManagerbyUserId) != null){
                lstNewCallSummary = mapManagerCallSummary.get(IdManagerbyUserId);
            }
            //add new summary to the map.
            lstNewCallSummary.add(ObjCallSummary);
            //put the map with new values
            mapManagerCallSummary.put(IdManagerbyUserId,lstNewCallSummary);
                         

        }
        //iterate over map to get a sorted list as per manager
        system.debug('***Ids '+ManagerIdlist.size());
        IF(ManagerIdlist.size()>0)
        {
            for(integer j=0;j<ManagerIdlist.size();j++){
            
                lstCallSummary.addAll(mapManagerCallSummary.get(ManagerIdlist[j]));
            }
        }
      
        system.debug('* ttlstCallSummary *'+lstCallSummary);
        //lstCallSummary.add(ObjCallSummary);  
        FOR(User uu: lstUser)
        {
           ObjCallSummary = New CallSummary();   
           ObjCallSummary.strName = uu.Name; 
           ObjCallSummary.strCity = uu.APAC_Area__c;
           ObjCallSummary.strRegion = uu.APAC_Region__c;                             
            ObjCallSummary.strManagerName  = uu.Manager.Name; 
           ObjCallSummary.strStatus = 'Not Created';
           ObjCallSummary.IntTotalAccounts = MapUserAccount.get(uu.Id) == null ? 0 : Integer.valueOf(MapUserAccount.get(uu.Id)); 
          // ObjCallSummary.IntTotalAccounts = 0; 
           ObjCallSummary.IntAvgCallDay = ObjCallSummary.IntAvgCallDay.setScale(2);
            system.debug('##ObjCallSummary '+ObjCallSummary );
           lstCallSummary.add(ObjCallSummary);
            ObjTotalCallSummary.IntTotTotalAccounts += ObjCallSummary.IntTotalAccounts; 
        }
        system.debug('**total '+ObjTotalCallSummary.IntTotalSubmittedCallPlans);
        
        if(ObjTotalCallSummary.IntTotalAvgCallDay != 0){
            ObjTotalCallSummary.IntTotalAvgCallDay = Decimal.valueOf(ObjTotalCallSummary.IntTotalSubmittedCallPlans)/lstCallSummary.size() ;
            ObjTotalCallSummary.IntTotalAvgCallDay = ObjTotalCallSummary.IntTotalAvgCallDay.setscale(2);
        }
        
         IF(Decimal.valueOf(ObjTotalCallSummary.IntTotalFieldDays) > 0){
                 //Modified by Neha Jain, for changing the avg calculation for fix no. of field days in a week
                //ObjTotalCallSummary.IntTotalAvgCallDay = Decimal.valueOf(ObjTotalCallSummary.IntTotalSubmittedCallPlans) / Decimal.valueOf(ObjTotalCallSummary.IntTotalFieldDays);
                ObjTotalCallSummary.IntTotalAvgCallDay = Decimal.valueOf(ObjTotalCallSummary.IntTotalSubmittedCallPlans)/(lstCallSummary.size() * Decimal.valueOf(Label.SFE_Field_Days)) ;
                ObjTotalCallSummary.IntTotalAvgCallDay = ObjTotalCallSummary.IntTotalAvgCallDay.setscale(2);
            } Else {
                ObjTotalCallSummary.IntTotalAvgCallDay = 0;

          }
        
        lstCallSummary.add(ObjTotalCallSummary);
        system.debug('$$ lstCallSummary'+lstCallSummary);
        //lstCallSummary.add(lstNewCallSummary);
    }
    
    public pagereference exportToExcel(){          
          System.debug('strSelectedMonth = ' + strSelectedMonth);
          sendmail();
          return null;
         
    }
    Public String strStartDate {get; set;}
    Public String strEndDate {get; set;}
     //Add by Tarun    
    public void SendMailToUserOnly()
    {        
        //User objUser = [SELECT Id, Name FROM User WHERE Id =: UserInfo.getUserId()];
        String strSenderName = Label.EmailSenderName;
        User objUser = [SELECT Id, Name FROM User WHERE Name =: strSenderName];
       
        // First, need to obtain the ID of the email template we created.
        EmailTemplate et = new EmailTemplate();
        if(blnIsMasterDataHidden){
            //Hide master data in report to send
            et = [SELECT Id FROM EmailTemplate WHERE DeveloperName='SFE_Plan_Matrix_for_India_No_Master'];
        }
        else{
            //Show master data in report to send
            et = [SELECT Id FROM EmailTemplate WHERE DeveloperName='SFE_Plan_Matrix_for_India'];
        }
        //EmailTemplate et = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName='SFE_Calling_Matrix_for_India_No_Master'];
        System.debug('et = '+et);
        strStartDate = WeekStartDate.day() + '-' + WeekStartDate.Month() + '-' + WeekStartDate.year();
        strEndDate = WeekEndDate.day() + '-' + WeekEndDate.Month() + '-' + WeekEndDate.year();
        //String strEmailName = Label.EmailTo;  
        //String strEmailToCCName = Label.EmailCC;        
        // Strings to hold the email addresses to which you are sending the email.
        //String[] toAddresses = new String[] {strEmailName.split(',')}; 
                
        //String[] toAddresses = strEmailName.split(',');
        String strCurrentUserEmail = Userinfo.getUserEmail() + ',';
        
        String[] toAddresses = strCurrentUserEmail.split(',');    
        /*String[] ccAddresses;              
        FOR(String stradd: toAddresses){
            System.debug('stradd = '+stradd);
            IF(strEmailToCCName.contains(stradd)){                
                strEmailToCCName = strEmailToCCName.replace(stradd,'');
            }
            IF(strEmailToCCName.endsWith(',')){
                strEmailToCCName = strEmailToCCName.replace(',','');
            }
            IF(strEmailToCCName.startsWith(',')){
                strEmailToCCName = strEmailToCCName.replace(',','');
            }
        }
        
        IF(strEmailToCCName.contains(',')){
            ccAddresses = strEmailToCCName.split(',');
            System.debug('ccAddresses = '+ccAddresses);
        } Else { 
            strEmailToCCName = strEmailToCCName + ',';
            ccAddresses = strEmailToCCName.split(',');
            //ccAddresses[0] = strEmailToCCName;
            System.debug('ccAddresses 0= '+ccAddresses);
        }
        System.debug('ccAddresses 1 = '+ccAddresses);*/
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
        
        mail.setToAddresses(toAddresses);
        //mail.setCcAddresses(ccAddresses);
        //mail.setReplyTo('support@acme.com');
        //mail.setSenderDisplayName('Salesforce Support');        
        //mail.setSubject('New Case Created : ');        
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setSaveAsActivity(false);        
        //mail.setPlainTextBody('Your Case: ');        
        //mail.setHtmlBody('Your case:<b> ');
        mail.setTargetObjectId(objUser.Id); //email recipient id
        mail.setTemplateId(et.Id); //email template id
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        // Start Current Code which is Working
        /*Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        //PageReference csv =  new PageReference('/apex/CustomReportExportExcel?sMonth='+strSelectedMonth);
        PageReference csv =  Page.CustomReportExportExcel;
        //csv.setRedirect(true);
        Blob b;
        if(!Test.isRunningTest()) {
            b = blob.valueOf(String.valueOf(csv.getContent()));
        }Else {
            b = blob.valueOf('test');
        }
        System.debug('##'+b);
        
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('SFE Calling Matrix for India - VC.xls');
        efa.setContentType('application/vnd.ms-excel');
        efa.setBody(b);
        efa.setInline(false);
        efa.Body = b;
        
        email.setToAddresses(toAddresses);
        // Assign the addresses for the To and CC lists to the mail object.
        email.setToAddresses(toAddresses);
        email.setCcAddresses(ccAddresses);
        //email.setReplyTo('');
        email.setSenderDisplayName('Salesforce Vision Care');
        email.setSubject('SFE Calling Matrix for India - VC');
        
        email.setPlainTextBody('Hello, <br/><br/> Please find SFE Calling Matrix for India - VC Report for Week ' + strStartDate + ' to ' + strEndDate + '. <br/><br/> Thank you & Warm Regards <br/>(This is a system generated email sent you by the Bausch & Lomb Salesforce Vision Care Org, please do not reply to this email)');
        email.setHtmlBody('Hello, <br/><br/> Please find SFE Calling Matrix for India - VC Report for Week ' + strStartDate + ' to ' + strEndDate + '. <br/><br/> Thank you & Warm Regards <br/>(This is a system generated email sent you by the Bausch & Lomb Salesforce Vision Care Org, please do not reply to this email)');
        
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});*/
        // End Current Code which is Working
        //Done Tarun
        strValue='Report mailed to your email address. Please check.';
        blnIsMasterDataHidden = false;
    }
    public void sendmail()
    {
    
        //User objUser = [SELECT Id, Name FROM User WHERE Id =: UserInfo.getUserId()];
        String strSenderName = Label.EmailSenderName;
        User objUser = [SELECT Id, Name FROM User WHERE Name =: strSenderName];
        // First, need to obtain the ID of the email template we created.
        EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE DeveloperName='SFE_Plan_Matrix_for_India'];
        
        strStartDate = WeekStartDate.day() + '-' + WeekStartDate.Month() + '-' + WeekStartDate.year();
        strEndDate = WeekEndDate.day() + '-' + WeekEndDate.Month() + '-' + WeekEndDate.year();
        String strEmailName = Label.EmailTo;  
        String strEmailToCCName = Label.EmailCC;          
        // Strings to hold the email addresses to which you are sending the email.
        //String[] toAddresses = new String[] {strEmailName.split(',')};  
        
        String[] toAddresses = strEmailName.split(','); 
        String[] ccAddresses;              
        FOR(String stradd: toAddresses){
            System.debug('stradd = '+stradd);
            IF(strEmailToCCName.contains(stradd)){                
                strEmailToCCName = strEmailToCCName.replace(stradd,'');
            }
            IF(strEmailToCCName.endsWith(',')){
                strEmailToCCName = strEmailToCCName.replace(',','');
            }
            IF(strEmailToCCName.startsWith(',')){
                strEmailToCCName = strEmailToCCName.replace(',','');
            }
        }
        
        IF(strEmailToCCName.contains(',')){
            ccAddresses = strEmailToCCName.split(',');
            System.debug('ccAddresses = '+ccAddresses);
        }Else{
            strEmailToCCName = strEmailToCCName + ',';
            ccAddresses = strEmailToCCName.split(',');
            //ccAddresses[0] = strEmailToCCName;
            System.debug('ccAddresses 0= '+ccAddresses);
        }
        System.debug('ccAddresses 1 = '+ccAddresses);        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
        
        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);
        //mail.setReplyTo('support@acme.com');
        //mail.setSenderDisplayName('Salesforce Support');        
        //mail.setSubject('New Case Created : ');        
        mail.setBccSender(false);        
        mail.setUseSignature(false);
        mail.setsaveAsActivity(false);
        //mail.setPlainTextBody('Your Case: ');        
        //mail.setHtmlBody('Your case:<b> ');
        mail.setTargetObjectId(objUser.Id); //email recipient id
        mail.setTemplateId(et.Id); //email template id
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        /*Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        PageReference csv =  new PageReference('/apex/CallPlanCustomReportExportExcel');
        csv.setRedirect(true);
        Blob b;
        if(!Test.isRunningTest()) {
            b = csv.getContent();
        }Else {
            b = blob.valueOf('test');
        }
        System.debug('##'+b);

        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('SFE Plan Matrix for India - VC.xls');
        efa.setContentType('application/vnd.ms-excel');
        efa.setBody(b);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        // Assign the addresses for the To and CC lists to the mail object.
        email.setToAddresses(toAddresses);
        email.setCcAddresses(ccAddresses);
        //email.setReplyTo('');
        email.setSenderDisplayName('Salesforce Vision Care');
        email.setSubject('SFE Plan Matrix for India - VC');

        email.setPlainTextBody('Hello, <br/><br/> Please find SFE Plan Matrix for India - VC Report for Week ' + strStartDate + ' to ' + strEndDate + '. <br/><br/> Thank you & Warm Regards <br/>(This is a system generated email sent you by the Bausch & Lomb Salesforce Vision Care Org, please do not reply to this email)');
        email.setHtmlBody('Hello, <br/><br/> Please find SFE Plan Matrix for India - VC Report for Week ' + strStartDate + ' to ' + strEndDate + '. <br/><br/> Thank you & Warm Regards <br/>(This is a system generated email sent you by the Bausch & Lomb Salesforce Vision Care Org, please do not reply to this email)');

        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});*/ 
        blnIsMasterDataHidden = false;
    }
    
    /*************************************************************************
    ** Method for obtaining start date for the rbd month
    *************************************************************************/
    
    public  Date getMonthStartDate(String Month ,Date datRefDate){
        //Integer intMonthNo = ClsCallPlanUtil.MAP_MONTHNAME_MONTHNO.get(Month);
        Integer intMonthNo = MonthNumber(Month);
        //Date datYearStart = getYearStartDate(datRefDate);
        System.debug('intMonthNo :  '+intMonthNo);
        System.debug('Month :  '+Month );
        System.debug('datRefDate:  '+datRefDate);
        String callplanYear = String.valueOf(YearName);        
        List<FiscalYearSettings> lstFYS = [SELECT  StartDate, EndDate, Name FROM FiscalYearSettings WHERE Name =:callplanYear ORDER by Name desc limit 1];
        Date datYearStart = lstFYS[0].StartDate;      
        //Date datYearStart = ClsCallPlanUtil.MAP_YEAR_YEARSTARTDATE.get(datRefDate.year());
        System.debug('datYearStart :  '+datYearStart);
        if(datYearStart !=null){
            intMonthNo = intMonthNo - 1;
            if (intMonthNo == 0) return datYearStart;
            Integer intQuaters = intMonthNo/3;
            System.debug('intQuaters :  '+intQuaters);
            Integer intMonthsThisQuarter = Math.mod(intMonthNo, 3);
            System.debug('intMonthsThisQuarter :  '+intMonthsThisQuarter);
            Integer intDays = intQuaters * intQuarterDays;
            System.debug('intDays :  '+intDays);
            if (intMonthsThisQuarter==1) intDays+=28;
            else if (intMonthsThisQuarter==2) intDays+=56;
            return  datYearStart.addDays(intDays);
        } else{
            //addErrorMessage('Please select Year prior to 2013 , cannot plan for that year');
            return null;
        }
    }
    
    /*************************************************************************
    ** Method for obtaining no . of days in an RBD month
    *************************************************************************/    
    public Integer daysInMonths(Integer intMonthNo){
        Integer intDays;
        //Added by sanjib mahanta
        if(intMonthNo==12){           
           List<FiscalYearSettings> lstFYS = [SELECT  StartDate, EndDate, Name FROM FiscalYearSettings ORDER by Name desc limit 1];
           integer NoOfDaysInYear=0;
           Date YearStartDate = lstFYS[0].StartDate;
           System.debug('Period 121'+YearStartDate );
           Date YearEndDate = lstFYS[0].EndDate;
           
           integer NoOfDaysInQuarter = 91; //13*7
           
          // if(lstFYS.size()>0) 
               System.debug('LeapYear=='+Math.mod(Integer.valueof(lstFys[0].Name),4));
               if (Math.mod(Integer.valueof(lstFys[0].Name),4)==0){
               //if(isLeapYear(Integer.valueof(lstFys[0].Name))){
                   NoOfDaysInYear = 366;
               }
               else{
                   NoOfDaysInYear=365;
               }
               
               //Days to Add = (q1+q2+q3 days) + (period 10 days) + (period 11 days)
               integer DaysToAdd = (91 * 3) + (4 * 7) + (27);
               
               //Get end date of Period 11
               Date Period11EndDate = YearStartDate.addDays(DaysToAdd);
               System.debug('Period11EndDate=='+Period11EndDate);
               
               // Getting the no of days for last/11th Period
               integer LeftDaysInYear = Period11EndDate.daysBetween(YearEndDate);
               Integer days = Integer.valueof(LeftDaysInYear);
               System.debug('Days Left in Last Period:--'+days);
               
               if(days==42){                 
                   
                   return 42 ;
               }
               else{                   
                   
                   return 35 ;
               }
               
           }
      
       else{
       
             //if(intMonthNo==12) return 42;
            intDays = 28;
            if (Math.mod(intMonthNo,3)==0) intDays = 35;
            return intDays; 
        }
    } 
    
    Public Integer MonthNumber(String Month){
        
        Integer NoofMonth = 0;
        
        IF(Month == 'Jan'){
            NoofMonth = 1;
        } Else IF(Month == 'Feb'){
            NoofMonth = 2;
        } Else IF(Month == 'Mar'){
            NoofMonth = 3;
        } Else IF(Month == 'Apr'){
            NoofMonth = 4;
        } Else IF(Month == 'May'){
            NoofMonth = 5;
        } Else IF(Month == 'Jun'){
            NoofMonth = 6;
        } Else IF(Month == 'Jul'){
            NoofMonth = 7;
        } Else IF(Month == 'Aug'){
            NoofMonth = 8;
        } Else IF(Month == 'Sep'){
            NoofMonth = 9;
        }  Else IF(Month == 'Oct'){
            NoofMonth = 10;
        }  Else IF(Month == 'Nov'){
            NoofMonth = 11;
        }  Else IF(Month == 'Dec'){
            NoofMonth = 12;
        } 
        
        return NoofMonth;
    }
    
    Public String MonthName(String Month){
        
        String NoofMonth = '';
        
        IF(Month == '1'){
            NoofMonth = 'Jan';
        } Else IF(Month == '2'){
            NoofMonth = 'Feb';
        } Else IF(Month == '3'){
            NoofMonth = 'Mar';
        } Else IF(Month == '4'){
            NoofMonth = 'Apr';
        } Else IF(Month == '5'){
            NoofMonth = 'May';
        } Else IF(Month == '6'){
            NoofMonth = 'Jun';
        } Else IF(Month == '7'){
            NoofMonth = 'Jul';
        } Else IF(Month == '8'){
            NoofMonth = 'Aug';
        } Else IF(Month == '9'){
            NoofMonth = 'Sep';
        }  Else IF(Month == '10'){
            NoofMonth = 'Oct';
        }  Else IF(Month == '11'){
            NoofMonth = 'Nov';
        }  Else IF(Month == '12'){
            NoofMonth = 'Dec';
        } 
        
        return NoofMonth;
    }
    
    Public Date WeekStartDate(String DayofWeek){
        
        Date DayStartWeek = null;
        Date DayStart = null;
        IF(DayofWeek == 'Monday'){
            DayStart = Date.Today();
            DayStartWeek = DayStart; //.addDays(-7);
        } Else IF(DayofWeek == 'Tuesday'){
            DayStart = Date.Today().addDays(-1);
            DayStartWeek = DayStart;//.addDays(-7);
        } Else IF(DayofWeek == 'Wednesday'){
            DayStart = Date.Today().addDays(-2);
            DayStartWeek = DayStart;//.addDays(-7);
        } Else IF(DayofWeek == 'Thursday'){
            DayStart = Date.Today().addDays(-3);
            DayStartWeek = DayStart;//.addDays(-7);
        } Else IF(DayofWeek == 'Friday'){
            DayStart = Date.Today().addDays(-4);
            DayStartWeek = DayStart;//.addDays(-7);
        } Else IF(DayofWeek == 'Saturday'){
            DayStart = Date.Today().addDays(-5);
            DayStartWeek = DayStart;//.addDays(-7);
        } Else IF(DayofWeek == 'Sunday'){
            DayStart = Date.Today().addDays(-6);
            DayStartWeek = DayStart;//.addDays(-7);
        }
        
        return DayStartWeek;
    }
    
    Public Date WeekEndDate(String DayofWeek){
               
        Date DayEnd = null;
        IF(DayofWeek == 'Monday'){
            DayEnd = Date.Today().addDays(+6);            
        } Else IF(DayofWeek == 'Tuesday'){
            DayEnd = Date.Today().addDays(+5);            
        } Else IF(DayofWeek == 'Wednesday'){
            DayEnd = Date.Today().addDays(+4);            
        } Else IF(DayofWeek == 'Thursday'){
            DayEnd = Date.Today().addDays(+3);            
        } Else IF(DayofWeek == 'Friday'){
            DayEnd = Date.Today().addDays(+2);            
        } Else IF(DayofWeek == 'Saturday'){
            DayEnd = Date.Today().addDays(+1);            
        } Else IF(DayofWeek == 'Sunday'){
            DayEnd = Date.Today();//.addDays(-7);            
        }
        
        return DayEnd;
    }
    
    Public Class CallSummary{
        Public String APID {get; set;}
        Public String strName {get; set;}
        Public String strRegion {get; set;}
        Public String strManagerName {get; set;}
        Public String strCity {get; set;}
        Public String strCurrMonth {get; set;}
        
        Public String strCountry {get; set;} 
        Public String strStatus {get; set;}  
        Public String strTotal {get; set;}  
        Public Integer IntFieldDays {get; set;}

        Public Integer IntTotalAccounts{get; set;} 
        Public Integer IntTotalAccountsofA {get; set;}  
        Public Integer IntTotalAccountsofB {get; set;}  
        Public Integer IntTotalAccountsofC {get; set;}  
        Public Integer IntTotalAccountsOthers {get; set;}  
                     
        Public Integer IntSubmittedCallPlans {get; set;}        
        Public Decimal IntAvgCallDay {get; set;}
        Public Integer IntTotalFieldDays {get; set;}

        Public Integer IntTotTotalAccounts{get; set;}
        Public Integer IntTotTotalAccountsofA {get; set;}
        Public Integer IntTotTotalAccountsofB {get; set;}
        Public Integer IntTotTotalAccountsofC {get; set;}
        Public Integer IntTotTotalAccountsOthers {get; set;}
        
        Public Integer IntTotTotalAccountsNorth{get; set;}        
        Public Integer IntTotalSubmittedCallPlans {get; set;}        
        Public Decimal IntTotalAvgCallDay {get; set;}        
        
        Public CallSummary(){
            strName = '';
            strTotal = '';
            strCurrMonth = '';
            IntTotalAccounts = 0;
            IntTotalAccountsofA = 0;
            IntTotalAccountsofB = 0;
            IntTotalAccountsofC = 0;
            IntTotalAccountsOthers = 0;
            IntSubmittedCallPlans = 0;
            IntAvgCallDay = 0;
            IntFieldDays = 0;
            
            IntTotTotalAccounts = 0;
            IntTotTotalAccountsofA = 0;
            IntTotTotalAccountsofB = 0;
            IntTotTotalAccountsofC = 0;
            IntTotTotalAccountsOthers = 0;
            
            IntTotTotalAccountsNorth = 0;
            IntTotalSubmittedCallPlans = 0;
            IntTotalAvgCallDay = 0;
            IntTotalFieldDays = 0;
            IntTotalAvgCallDay = 0;
        }
    }

}