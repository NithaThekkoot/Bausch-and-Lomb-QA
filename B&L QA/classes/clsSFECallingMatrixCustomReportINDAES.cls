/** 
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 *
 *
 *    Author         |Author-Email                  |Date       |Comment
 *    Tarun Solanki  |Tarun.Solanki@bausch.com      |09.6.2014 |First Draft
  Test Class--clsSFECallingMatrixCRINDAES_Test
 */

//public with sharing class clsSFECallingMatrixCustomReportINDAES {

public class clsSFECallingMatrixCustomReportINDAES {
    //boolean variable used by scheduler class for SFE Calling Report
    Public boolean callingReport{get;set;}
    Public Id APACId {get;set;}
    Public List<Call_Summary__c> lstCallSumamry{get; set;}
    Public List<Call_Summary__c> lstTemp{get; set;}
    Public Call_Summary__c ObjCallSumamry {get; set;}
    Public List<CallSummary> lstCallSummary {get; set;}
    Public CallSummary ObjCallSummary {get; set;}
    Public CallSummary ObjUserCallSummary {get; set;}
    Public CallSummary ObjTotalCallSummary {get; set;}
    Public String sDate {get; set;}
    Public String eDate {get; set;}
    Public Date StartDate {get; set;}
    Public Date EndDate {get; set;}
    Public String header{get; set;}
    Public String monthName {get; set;}
    Public String YearName {get; set;}
    Public String dayOfWeek {get; set;}
    Public Date WeekStartDate {get;set;}
    Public Date WeekEndDate {get;set;}
    Public String strSelectedMonth {get; set;}
    Public String strGrandTotal {get; set;}
        //Added by tarun
    Public List<User> lstManager {get; set;}
    Public Map<ID,String> MapUsermanager {get; set;}
    Public Map<ID,ID> MapmanagerIdbyUserId {get; set;}
    Public String strCountry {get; set;}
    Public String strProfileName {get; set;}
    Public String strProfileName1 {get; set;}
    Public List<User> lstUser {get; set;}
    Public Set<String> setUserId {get; set;}
    Public Set<Id> setNotInUserID {get; set;}
    Public Map<String,Integer> MapUserAccount {get; set;}
    
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

    public clsSFECallingMatrixCustomReportINDAES() {
        
         header = 'Region,City,SE/SCRM,Accounts,Field Days,Planned Calls,Actual Planned Calls,Unplanned Calls,Total Calls,Call% to planned,Avg Calls/day\r\n';   
         datMonthStartDate = null;
         datMonthEndDate = null;
         datRefDate = null;
         StartDate = null;
         EndDate = null;
         sDate = null;
         eDate = null;
         strGrandTotal = 'Grand Total';
         strCountry = null;
         strProfileName = null;
         strProfileName1 = null;
         setUserId = New Set<String>();
         setNotInUserID = New Set<Id>();
         MapUserAccount = New Map<String,Integer>();
         callingReport = false;
         lstUser = New List<User>();
         lstCallSumamry = New List<Call_Summary__c>(lstCallSumamry);
         lstTemp = New List<Call_Summary__c>(lstTemp);
         ObjCallSumamry = New Call_Summary__c();
         lstCallSummary = New List<CallSummary>();
         ObjCallSummary = New CallSummary();
         ObjUserCallSummary = New CallSummary();
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
         // Start Logic for Display data at Page Level          
         InitCurrentMonth();
         // End Logic for Display data at Page Level      
           
    }    
    
    public clsSFECallingMatrixCustomReportINDAES(ApexPages.StandardController controller) {
        
         header = 'Region,City,SE/SCRM,Accounts,Field Days,Planned Calls,Actual Planned Calls,Unplanned Calls,Total Calls,Call% to planned,Avg Calls/day\r\n';   
         datMonthStartDate = null;
         datMonthEndDate = null;
         datRefDate = null;
         StartDate = null;
         EndDate = null;
         sDate = null;
         eDate = null;
         strGrandTotal = 'Grand Total';
         strCountry = null;
         strProfileName = null;
         setUserId = New Set<String>();
         setNotInUserID = New Set<Id>();
         MapUserAccount = New Map<String,Integer>();
         callingReport = false;
         lstUser = New List<User>();
         lstCallSumamry = New List<Call_Summary__c>(lstCallSumamry);
         lstTemp = New List<Call_Summary__c>(lstTemp);
         ObjCallSumamry = New Call_Summary__c();
         lstCallSummary = New List<CallSummary>();
         ObjCallSummary = New CallSummary();
         ObjUserCallSummary = New CallSummary();
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
         // Start Logic for Display data at Page Level          
         InitCurrentMonth();
         // End Logic for Display data at Page Level        
    }
    
    Public void InitCurrentMonth(){
        DateTime d = datetime.now();
        dayOfWeek=d.format('EEEE');
        WeekStartDate = WeekStartDate(dayOfWeek);
        WeekEndDate = WeekEndDate(dayOfWeek);        
        System.debug('WeekStartDate = '+WeekStartDate);
        System.debug('WeekEndDate = '+WeekEndDate);
        monthName= d.format('MMMMM');        
        YearName= d.format('yyyy');
        String strMonth = String.valueOf(monthName.substring(0,3));
        strSelectedMonth = strMonth;        
        
        datMonthStartDate = WeekStartDate;
        datMonthEndDate = WeekEndDate;
        System.debug('datMonthStartDate = '+datMonthStartDate);
        System.debug('datMonthEndDate = '+datMonthEndDate);          
        
        DisplayCallSummary();
    }    
    
    Public void DisplayCallSummary(){
    
        strStartDate = WeekStartDate.day() + '-' + WeekStartDate.Month() + '-' + WeekStartDate.year();
        strEndDate = WeekEndDate.day() + '-' + WeekEndDate.Month() + '-' + WeekEndDate.year();
        
        strCountry = Label.Country_SFE_Custom_Report;
        strProfileName = 'INDAES Sales Rep';

        
        system.debug('***datMonthStartDate --' + datMonthStartDate + '***datMonthEndDate ' + datMonthEndDate);
        List<AggregateResult> lstCallSumamry1 = [SELECT OwnerId uId, Owner.Name Name, Area__c City, RegionINDSU__c Reg, COUNT(Field_Days__c) BD, SUM(Unplanned_Calls__c) UP, SUM(Unplanned_Calls_of_A__c) UPUA, SUM(Unplanned_Calls_of_B__c) UPUB, SUM(Unplanned_Calls_of_C__c) UPUC, 
                                                      SUM(Unplanned_Calls_Others__c) UPUOthers, SUM(Planned_Calls__c) PL, SUM(Planned_Calls_of_A__c) PLA, SUM(Planned_Calls_of_B__c) PLB, SUM(Planned_Calls_of_C__c) PLC, SUM(Planned_Calls_Others__c) PLOthers, SUM(Actual_Calls__c) UP1,
                                                      MAX(Total_Customers__c)UP2, MAX(Total_Customers_of_A__c) UPA, MAX(Total_Customers_of_B__c) UPB, MAX(Total_Customers_of_C__c) UPC, MAX(Total_Customers_of_Others__c) UPOthers, SUM(OT_Hours__c) OTHours, 
                                                      SUM(Targeted_Calls__c) TC, SUM(Targeted_Calls_of_A__c) TCA, SUM(Targeted_Calls_of_B__c) TCB, SUM(Targeted_Calls_of_C__c) TCC, SUM(Targeted_Calls_Others__c) TCOthers  
                                                      FROM Call_Summary__c WHERE Date__c >=: datMonthStartDate AND Date__c <=: datMonthEndDate AND Country__c =: strCountry AND owner.profile.name like '%INDAES%' GROUP BY RegionINDSU__c, Area__c, Owner.Name, OwnerId ORDER BY RegionINDSU__c ASC];
        //Kandarp Shah | 8-Aug-13 | Bug in OT Hours | End
                                                   
        System.debug('lstCallSumamry1 = ' + lstCallSumamry1+' datMonthStartDate  '+datMonthStartDate +' datMonthEndDate  '+datMonthEndDate );
        setUserId = New Set<String>();
        MapUserAccount = New Map<String,Integer>();
        
        FOR(AggregateResult AP: lstCallSumamry1){
            setUserId.add(String.valueOf(AP.get('uId')));            
        }
        System.debug('setUserId = ' + setUserId);
        
        //get manager list of listcallsummaryuser --Tarun Solanki
         MapUsermanager = New Map<ID,String>(); 
        list<ID> ManagerIdlist =new list<ID>();
        MapmanagerIdbyUserId= New Map<ID,String>();     
        lstManager =New List<User>();
        
        lstManager = [SELECT Id,manager.name FROM User WHERE (Profile.Name =: strProfileName) AND Id IN : setUserId AND IsActive = TRUE  ORDER BY user.manager.name]; 
        
        FOR(User lm: lstManager){
        if(MapUsermanager.get(lm.manager.id) == null){
            ManagerIdlist.add(lm.manager.id);
            MapUsermanager.put(lm.manager.id,lm.manager.name);
            }
            MapmanagerIdbyUserId.put(lm.id,lm.manager.id);
        }     
        
        lstUser = New List<User>();
               lstUser = [SELECT user.manager.name,managerid ,APAC_Region__c , Name, Profile.Name , APAC_Area__c, APAC_Country__c FROM User WHERE (Profile.Name =: strProfileName) AND Id NOT IN : setUserId AND IsActive = TRUE  ORDER BY user.manager.name];        
        System.debug('lstUser = '+lstUser.size());
        
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
        // system.debug('**currentpage --1' + Apexpages.currentPage().getUrl()); 
        ID IdUser;
        ID IdManagerbyUserId;
        lstCallSummary = New List<CallSummary>();
        CallSummary ObjCallSummary;
        CallSummary ObjTotalCallSummary;
        CallSummary ObjUserCallSummary;
        ObjTotalCallSummary = New CallSummary(); 
        ObjUserCallSummary = New CallSummary();  
        Map<Id,List<CallSummary>> mapManagerCallSummary = new Map<Id,List<CallSummary>>();      
        FOR(AggregateResult AR: lstCallSumamry1)
        {
            ObjCallSummary = New CallSummary();            
            ObjCallSummary.strName = String.valueOf(AR.get('Name'));             
            ObjCallSummary.strCity = AR.get('City') ==null ? null : String.valueOf(AR.get('City')); 
            ObjCallSummary.strRegion = AR.get('Reg') ==null ? null : String.valueOf(AR.get('Reg')).trim();                               
            //By Tarun Solanki                              
           
            IdUser=String.valueof(AR.get('uId'));           
            
            IdManagerbyUserId =  MapmanagerIdbyUserId.get(IdUser);
            
            ObjCallSummary.strManagerName=MapUsermanager.get(IdManagerbyUserId);
            
            
            ObjTotalCallSummary.strTotalRegion = 'Grand Total ';  //+ ObjCallSummary.strRegion;              
            ObjCallSummary.IntUnplannedCalls = AR.get('UP') ==null ? 0 : Integer.valueOf(AR.get('UP'));
            ObjCallSummary.IntUnplannedCallsofA = AR.get('UPUA') ==null ? 0 : Integer.valueOf(AR.get('UPUA'));
            ObjCallSummary.IntUnplannedCallsofB = AR.get('UPUB') ==null ? 0 : Integer.valueOf(AR.get('UPUB'));
            ObjCallSummary.IntUnplannedCallsofC = AR.get('UPUC') ==null ? 0 : Integer.valueOf(AR.get('UPUC'));
            ObjCallSummary.IntUnplannedCallsOthers = AR.get('UPUOthers') ==null ? 0 : Integer.valueOf(AR.get('UPUOthers'));
            
            ObjCallSummary.IntActualCalls = Integer.valueOf(AR.get('UP1'));
            
            ObjCallSummary.IntTotalAccounts = AR.get('UP2') ==null ? 0 : Integer.valueOf(AR.get('UP2'));
            ObjCallSummary.IntTotalAccountsofA = AR.get('UPA') ==null ? 0 : Integer.valueOf(AR.get('UPA'));  
            ObjCallSummary.IntTotalAccountsofB = AR.get('UPB') ==null ? 0 : Integer.valueOf(AR.get('UPB'));
            ObjCallSummary.IntTotalAccountsofC = AR.get('UPC') ==null ? 0 : Integer.valueOf(AR.get('UPC'));
            ObjCallSummary.IntTotalAccountsOthers = AR.get('UPOthers') ==null ? 0 : Integer.valueOf(AR.get('UPOthers')); 
            
            ObjCallSummary.IntPlannedCalls = AR.get('PL') ==null ? 0 : Integer.valueOf(AR.get('PL'));
            ObjCallSummary.IntPlannedCallsofA = AR.get('PLA') ==null ? 0 : Integer.valueOf(AR.get('PLA'));
            ObjCallSummary.IntPlannedCallsofB = AR.get('PLB') ==null ? 0 : Integer.valueOf(AR.get('PLB'));
            ObjCallSummary.IntPlannedCallsofC = AR.get('PLC') ==null ? 0 : Integer.valueOf(AR.get('PLC'));
            ObjCallSummary.IntPlannedCallsOthers = AR.get('PLOthers') ==null ? 0 : Integer.valueOf(AR.get('PLOthers'));
            
            ObjCallSummary.IntTargetCalls = AR.get('TC') ==null ? 0 : Integer.valueOf(AR.get('TC'));
            ObjCallSummary.IntTargetCallsofA = AR.get('TCA') ==null ? 0 : Integer.valueOf(AR.get('TCA'));
            ObjCallSummary.IntTargetCallsofB = AR.get('TCB') ==null ? 0 : Integer.valueOf(AR.get('TCB'));
            ObjCallSummary.IntTargetCallsofC = AR.get('TCC') ==null ? 0 : Integer.valueOf(AR.get('TCC'));
            ObjCallSummary.IntTargetCallsOthers = AR.get('TCOthers') ==null ? 0 : Integer.valueOf(AR.get('TCOthers'));
            
            ObjCallSummary.IntOTHours = AR.get('OTHours') ==null ? 0 : Decimal.valueOf(String.valueOf(AR.get('OTHOurs')));
            
            ObjCallSummary.IntFieldDays = Integer.valueOf(AR.get('BD'));    
            
            IF(Decimal.valueOf(ObjCallSummary.IntPlannedCalls) > 0 ){
                Decimal strCallstoPlan = Decimal.valueOf(ObjCallSummary.IntTargetCalls) / Decimal.valueOf(ObjCallSummary.IntPlannedCalls) * 100;
                ObjCallSummary.IntCallstoPlan = strCallstoPlan;
            }Else {
                ObjCallSummary.IntCallstoPlan = 0;
            }  
            ObjCallSummary.IntCallstoPlan = ObjCallSummary.IntCallstoPlan.setScale(2);
                        
            IF(Decimal.valueOf(ObjCallSummary.IntFieldDays) > 0){
                //Modified by Neha Jain, for changing the avg calculation for fix no. of field days in a week
                //Decimal strAvgCallPerDay = Decimal.valueOf(ObjCallSummary.IntActualCalls) / Decimal.valueOf(ObjCallSummary.IntFieldDays);
                Decimal strAvgCallPerDay = Decimal.valueOf(ObjCallSummary.IntActualCalls) / Decimal.valueOf(Label.SFE_Field_Days) ;
                ObjCallSummary.IntAvgCallPerDay = strAvgCallPerDay;  
            } Else {
                ObjCallSummary.IntAvgCallPerDay = 0;
            }  
            ObjCallSummary.IntAvgCallPerDay = ObjCallSummary.IntAvgCallPerDay.setScale(2);
                        
            ObjTotalCallSummary.IntTotalUnplannedCalls += ObjCallSummary.IntUnplannedCalls;
            ObjTotalCallSummary.IntTotalUnplannedCallsofA += ObjCallSummary.IntUnplannedCallsofA;
            ObjTotalCallSummary.IntTotalUnplannedCallsofB += ObjCallSummary.IntUnplannedCallsofB;
            ObjTotalCallSummary.IntTotalUnplannedCallsofC += ObjCallSummary.IntUnplannedCallsofC;
            ObjTotalCallSummary.IntTotalUnplannedCallsOthers += ObjCallSummary.IntUnplannedCallsOthers;
            
            ObjTotalCallSummary.IntTotalOTHours += ObjCallSummary.IntOTHours;
            
            ObjTotalCallSummary.IntTotalTotAccounts += ObjCallSummary.IntTotalAccounts;
            ObjTotalCallSummary.IntTotalTotAccountsofA += ObjCallSummary.IntTotalAccountsofA;
            ObjTotalCallSummary.IntTotalTotAccountsofB += ObjCallSummary.IntTotalAccountsofB;
            ObjTotalCallSummary.IntTotalTotAccountsofC += ObjCallSummary.IntTotalAccountsofC;
            ObjTotalCallSummary.IntTotalTotAccountsOthers += ObjCallSummary.IntTotalAccountsOthers;
                        
            ObjTotalCallSummary.IntTotalFieldDays += ObjCallSummary.IntFieldDays;
            
            ObjTotalCallSummary.IntTotalPlannedCalls += ObjCallSummary.IntPlannedCalls;
            ObjTotalCallSummary.IntTotalPlannedCallsofA += ObjCallSummary.IntPlannedCallsofA;
            ObjTotalCallSummary.IntTotalPlannedCallsofB += ObjCallSummary.IntPlannedCallsofB;
            ObjTotalCallSummary.IntTotalPlannedCallsofC += ObjCallSummary.IntPlannedCallsofC;
            ObjTotalCallSummary.IntTotalPlannedCallsOthers += ObjCallSummary.IntPlannedCallsOthers;
            
            ObjTotalCallSummary.IntTotalActualCalls += ObjCallSummary.IntActualCalls;
            ObjTotalCallSummary.IntTotalActualCallsofA += ObjCallSummary.IntActualCallsofA;
            ObjTotalCallSummary.IntTotalActualCallsofB += ObjCallSummary.IntActualCallsofB;
            ObjTotalCallSummary.IntTotalActualCallsofC += ObjCallSummary.IntActualCallsofC;
            ObjTotalCallSummary.IntTotalActualCallsOthers += ObjCallSummary.IntActualCallsOthers;
            
            ObjTotalCallSummary.IntTotalTargetCalls += ObjCallSummary.IntTargetCalls;
            ObjTotalCallSummary.IntTotalTargetCallsofA += ObjCallSummary.IntTargetCallsofA;
            ObjTotalCallSummary.IntTotalTargetCallsofB += ObjCallSummary.IntTargetCallsofB;
            ObjTotalCallSummary.IntTotalTargetCallsofC += ObjCallSummary.IntTargetCallsofC;
            ObjTotalCallSummary.IntTotalTargetCallsOthers += ObjCallSummary.IntTargetCallsOthers;
            
            IF(Decimal.valueOf(ObjTotalCallSummary.IntTotalPlannedCalls)> 0){
                ObjTotalCallSummary.IntTotalCallstoPlan = Decimal.valueOf(ObjTotalCallSummary.IntTotalTargetCalls) / Decimal.valueOf(ObjTotalCallSummary.IntTotalPlannedCalls) * 100;
                ObjTotalCallSummary.IntTotalCallstoPlan = ObjTotalCallSummary.IntTotalCallstoPlan.setScale(2);
            } Else {
                ObjTotalCallSummary.IntTotalCallstoPlan = 0;
            } 
            
            
               
            IF(Decimal.valueOf(ObjTotalCallSummary.IntTotalFieldDays) > 0){
                //Modified by Neha Jain, for changing the avg calculation for fix no. of field days in a week
                //ObjTotalCallSummary.IntTotalAvgCallPerDay = Decimal.valueOf(ObjTotalCallSummary.IntTotalActualCalls) / Decimal.valueOf(ObjTotalCallSummary.IntTotalFieldDays);
                ObjTotalCallSummary.IntTotalAvgCallPerDay = Decimal.valueOf(ObjTotalCallSummary.IntTotalActualCalls) / Decimal.valueOf(Label.SFE_Field_Days) ;
                ObjTotalCallSummary.IntTotalAvgCallPerDay = ObjTotalCallSummary.IntTotalAvgCallPerDay.setScale(2);

            } Else {
                ObjTotalCallSummary.IntTotalAvgCallPerDay = 0;
            }
            
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
            
            //lstCallSummary.add(ObjCallSummary);               
        }
         //iterate over map to get a sorted list as per manager
         
        IF(ManagerIdlist.size()>0)
        {
            for(integer j=0;j<ManagerIdlist.size();j++){
            
                lstCallSummary.addAll(mapManagerCallSummary.get(ManagerIdlist[j]));
            }
        }                
      
        FOR(User uu: lstUser){
           ObjCallSummary = New CallSummary();   
           ObjCallSummary.strName = uu.Name; 
           ObjCallSummary.strCity = uu.APAC_Area__c;
           ObjCallSummary.strRegion = uu.APAC_Region__c;                             
           ObjCallSummary.IntTotalAccounts = 0;
           ObjCallSummary.strManagerName  = uu.Manager.Name; 
           ObjCallSummary.IntTotalAccounts = MapUserAccount.get(uu.Id) == null ? 0 : Integer.valueOf(MapUserAccount.get(uu.Id)); 
          // ObjCallSummary.IntTotalAccounts = 0;
           
           ObjTotalCallSummary.IntTotalTotAccounts += ObjCallSummary.IntTotalAccounts;
           ObjTotalCallSummary.IntTotalTotAccountsofA += ObjCallSummary.IntTotalAccountsofA;
           ObjTotalCallSummary.IntTotalTotAccountsofB += ObjCallSummary.IntTotalAccountsofB;
           ObjTotalCallSummary.IntTotalTotAccountsofC += ObjCallSummary.IntTotalAccountsofC;
           ObjTotalCallSummary.IntTotalTotAccountsOthers += ObjCallSummary.IntTotalAccountsOthers;
           
                
            
           lstCallSummary.add(ObjCallSummary);                 
           
        }
       
        
        IF(Decimal.valueOf(ObjTotalCallSummary.IntTotalPlannedCalls)> 0)
        {
                ObjTotalCallSummary.IntTotalCallstoPlan = Decimal.valueOf(ObjTotalCallSummary.IntTotalTargetCalls) / Decimal.valueOf(ObjTotalCallSummary.IntTotalPlannedCalls) * 100;
                ObjTotalCallSummary.IntTotalCallstoPlan = ObjTotalCallSummary.IntTotalCallstoPlan.setScale(2);
            } Else 
            {
                ObjTotalCallSummary.IntTotalCallstoPlan = 0;
            }  
            IF(Decimal.valueOf(ObjTotalCallSummary.IntTotalFieldDays) > 0)
            {
                //Modified by Neha Jain, for changing the avg calculation for fix no. of field days in a week
                //ObjTotalCallSummary.IntTotalAvgCallPerDay = Decimal.valueOf(ObjTotalCallSummary.IntTotalActualCalls) / Decimal.valueOf(ObjTotalCallSummary.IntTotalFieldDays);
                ObjTotalCallSummary.IntTotalAvgCallPerDay = Decimal.valueOf(ObjTotalCallSummary.IntTotalActualCalls) / (lstCallSummary.size() * Decimal.valueOf(Label.SFE_Field_Days));
                ObjTotalCallSummary.IntTotalAvgCallPerDay = ObjTotalCallSummary.IntTotalAvgCallPerDay.setScale(2);
            } Else {
                ObjTotalCallSummary.IntTotalAvgCallPerDay = 0;
            }
            
           lstCallSummary.add(ObjTotalCallSummary); 
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
        String strSenderName = Label.INDAESEmailSenderName;
        User objUser = [SELECT Id, Name FROM User WHERE Name =: strSenderName];
       
        // First, need to obtain the ID of the email template we created.
        EmailTemplate et;
        //Added by Neha Jain for a new report, containing only few main fields from the report
        if(callingReport == true){
            et = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName='SFE_Calling_Report_for_India_Aesthetic'];
        }
        else if(Apexpages.currentPage() != null){
            if(Apexpages.currentPage().getUrl() == null){
                et = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName='SFE_Calling_Report_for_India_Aesthetic'];
            }
            else{
                if(Apexpages.currentPage().getUrl().contains('SFECallingReport')){
                    et = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName='SFE_Calling_Report_for_India_Aesthetic'];
                }
                 else{
                        if(blnIsMasterDataHidden){
                            //Hide master data in report to send
                            et = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName='SFE_Calling_Matrix_INDAES_No_Master'];
                        }
                        else{
                            //Show master data in report to send
                            et = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName='SFE_Calling_Matrix_for_India_Aesthetic'];
                        }
                }
            }
        }
       
        //EmailTemplate et = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName='SFE_Calling_Matrix_for_India_No_Master'];
        System.debug('et = '+et);
        strStartDate = WeekStartDate.day() + '-' + WeekStartDate.Month() + '-' + WeekStartDate.year();
        strEndDate = WeekEndDate.day() + '-' + WeekEndDate.Month() + '-' + WeekEndDate.year();

        String strCurrentUserEmail = Userinfo.getUserEmail() + ',';
        
        String[] toAddresses = strCurrentUserEmail.split(',');    
     
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
        
        mail.setToAddresses(toAddresses);
      
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setSaveAsActivity(false);        
     
        mail.setTargetObjectId(objUser.Id); //email recipient id
        mail.setTemplateId(et.Id); //email template id
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        
        strValue='Report mailed to your email address. Please check.';
        blnIsMasterDataHidden = false;
    }
    public void sendmail()
    {        
        //User objUser = [SELECT Id, Name FROM User WHERE Id =: UserInfo.getUserId()];
        String strSenderName = Label.INDAESEmailSenderName;
        User objUser = [SELECT Id, Name FROM User WHERE Name =: strSenderName];
        // First, need to obtain the ID of the email template we created.
        
        EmailTemplate et;
        //Added by Neha Jain for a new report, containing only few main fields from the report
         if(callingReport == true){
            et = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName='SFE_Calling_Report_for_India_Aesthetic'];
        }
        else if(Apexpages.currentPage() != null){
            if(Apexpages.currentPage().getUrl() == null){
                et = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName='SFE_Calling_Report_for_India_Aesthetic'];
            }
            else{
                if(Apexpages.currentPage().getUrl().contains('SFECallingReport')){
                    et = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName='SFE_Calling_Report_for_India_Aesthetic'];
                }
                 else{
                        if(blnIsMasterDataHidden){
                            //Hide master data in report to send
                            et = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName='SFE_Calling_Matrix_INDAES_No_Master'];
                        }
                        else{
                            //Show master data in report to send
                            et = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName='SFE_Calling_Matrix_for_India_Aesthetic'];
                        }
                }
            }
        }
       
        
        System.debug('et = '+et);
        strStartDate = WeekStartDate.day() + '-' + WeekStartDate.Month() + '-' + WeekStartDate.year();
        strEndDate = WeekEndDate.day() + '-' + WeekEndDate.Month() + '-' + WeekEndDate.year();
        String strEmailName = Label.EmailTo_AES;  
        String strEmailToCCName = Label.EmailCC_AES;        
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
        } Else { 
            strEmailToCCName = strEmailToCCName + ',';
            ccAddresses = strEmailToCCName.split(',');
            //ccAddresses[0] = strEmailToCCName;
            System.debug('ccAddresses 0= '+ccAddresses);
        }
        System.debug('ccAddresses 1 = '+ccAddresses);
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
        
        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);
          
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setSaveAsActivity(false);        
   
        mail.setTargetObjectId(objUser.Id); //email recipient id
        mail.setTemplateId(et.Id); //email template id
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
         blnIsMasterDataHidden = false;
    }
    
    Public List<selectoption> getSelectedMonth(){
        List<SelectOption> objFields = new List<SelectOption>();
        objFields.add(new SelectOption('None','--None--'));
        Schema.DescribeFieldResult fieldResult = Call_Plan__c.Month__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();            
        for( Schema.PicklistEntry f : ple) {
           objFields.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        return objFields;
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
    
    Public Date WeekStartDate(String DayofWeek){
        
        Date DayStartWeek = null;
        Date DayStart = null;
        IF(DayofWeek == 'Monday'){
            DayStart = Date.Today();
            DayStartWeek = DayStart.addDays(-7);
        } Else IF(DayofWeek == 'Tuesday'){
            DayStart = Date.Today().addDays(-1);
            DayStartWeek = DayStart.addDays(-7);
        } Else IF(DayofWeek == 'Wednesday'){
            DayStart = Date.Today().addDays(-2);
            DayStartWeek = DayStart.addDays(-7);
        } Else IF(DayofWeek == 'Thursday'){
            DayStart = Date.Today().addDays(-3);
            DayStartWeek = DayStart.addDays(-7);
        } Else IF(DayofWeek == 'Friday'){
            DayStart = Date.Today().addDays(-4);
            DayStartWeek = DayStart.addDays(-7);
        } Else IF(DayofWeek == 'Saturday'){
            DayStart = Date.Today().addDays(-5);
            DayStartWeek = DayStart.addDays(-7);
        } Else IF(DayofWeek == 'Sunday'){
            DayStart = Date.Today().addDays(-6);
            DayStartWeek = DayStart.addDays(-7);
        }
        
        return DayStartWeek;
    }
    
    Public Date WeekEndDate(String DayofWeek){
               
        Date DayEnd = null;
        IF(DayofWeek == 'Monday'){
            DayEnd = Date.Today().addDays(-1);            
        } Else IF(DayofWeek == 'Tuesday'){
            DayEnd = Date.Today().addDays(-2);            
        } Else IF(DayofWeek == 'Wednesday'){
            DayEnd = Date.Today().addDays(-3);            
        } Else IF(DayofWeek == 'Thursday'){
            DayEnd = Date.Today().addDays(-4);            
        } Else IF(DayofWeek == 'Friday'){
            DayEnd = Date.Today().addDays(-5);            
        } Else IF(DayofWeek == 'Saturday'){
            DayEnd = Date.Today().addDays(-6);            
        } Else IF(DayofWeek == 'Sunday'){
            DayEnd = Date.Today().addDays(-7);            
        }
        
        return DayEnd;
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
    
    Public Class CallSummary{
        Public Id APID {get; set;}
        Public String strName {get; set;}
        Public String strRegion {get; set;}
        Public String strCity {get; set;}
        Public String strCountry {get; set;}
         Public String strManagerName {get; set;}
        Public Integer IntUnplannedCalls{get; set;}
        Public Integer IntUnplannedCallsofA{get; set;}
        Public Integer IntUnplannedCallsofB{get; set;}
        Public Integer IntUnplannedCallsofC{get; set;}
        Public Integer IntUnplannedCallsOthers{get; set;}
        
        Public Integer IntActualCalls {get; set;}
        Public Integer IntActualCallsofA {get; set;}
        Public Integer IntActualCallsofB {get; set;}
        Public Integer IntActualCallsofC {get; set;}
        Public Integer IntActualCallsOthers {get; set;}
                            
        Public Date strDate {get; set;}
        
        Public Integer IntTotalAccounts {get; set;}  
        Public Integer IntTotalAccountsofA {get; set;}  
        Public Integer IntTotalAccountsofB {get; set;}  
        Public Integer IntTotalAccountsofC {get; set;}  
        Public Integer IntTotalAccountsOthers {get; set;}  
        
        Public Integer IntPlannedCalls {get; set;}
        Public Integer IntPlannedCallsofA {get; set;}
        Public Integer IntPlannedCallsofB {get; set;}
        Public Integer IntPlannedCallsofC {get; set;}
        Public Integer IntPlannedCallsOthers {get; set;}
        
        Public Integer IntTargetCalls {get; set;}
        Public Integer IntTargetCallsofA {get; set;}
        Public Integer IntTargetCallsofB {get; set;}
        Public Integer IntTargetCallsofC {get; set;}
        Public Integer IntTargetCallsOthers {get; set;}
        
        Public Integer IntFieldDays {get; set;}
        Public Decimal IntCallstoPlan {get; set;}
        Public Decimal IntAvgCallPerDay {get; set;}
        
        Public Decimal IntOTHours {get; set;}
        
        Public String strTotalRegion {get; set;}
        
        Public Integer IntTotalUnplannedCalls {get; set;}
        Public Integer IntTotalUnplannedCallsofA {get; set;}
        Public Integer IntTotalUnplannedCallsofB {get; set;}
        Public Integer IntTotalUnplannedCallsofC {get; set;}
        Public Integer IntTotalUnplannedCallsOthers {get; set;}
        
        Public Integer IntTotalActualCalls {get; set;}
        Public Integer IntTotalActualCallsofA {get; set;}
        Public Integer IntTotalActualCallsofB {get; set;}
        Public Integer IntTotalActualCallsofC {get; set;}
        Public Integer IntTotalActualCallsOthers {get; set;}
        
        Public Integer IntTotalTotAccounts {get; set;}
        Public Integer IntTotalTotAccountsofA {get; set;}
        Public Integer IntTotalTotAccountsofB {get; set;}
        Public Integer IntTotalTotAccountsofC {get; set;}
        Public Integer IntTotalTotAccountsOthers {get; set;}
        
        Public Integer IntTotalPlannedCalls {get; set;}
        Public Integer IntTotalPlannedCallsofA {get; set;}
        Public Integer IntTotalPlannedCallsofB {get; set;}
        Public Integer IntTotalPlannedCallsofC {get; set;}
        Public Integer IntTotalPlannedCallsOthers {get; set;}
        
        Public Integer IntTotalTargetCalls {get; set;}
        Public Integer IntTotalTargetCallsofA {get; set;}
        Public Integer IntTotalTargetCallsofB {get; set;}
        Public Integer IntTotalTargetCallsofC {get; set;}
        Public Integer IntTotalTargetCallsOthers {get; set;}
        
        Public Integer IntTotalFieldDays {get; set;}        
        Public Decimal IntTotalCallstoPlan {get; set;}
        Public Decimal IntTotalAvgCallPerDay {get; set;}
        Public Decimal IntTotalOTHours {get; set;}
        
        Public CallSummary(){
            strName = '';
            strDate = null;
            
            IntTotalUnplannedCalls = 0;
            IntTotalUnplannedCallsofA = 0;
            IntTotalUnplannedCallsofB = 0;
            IntTotalUnplannedCallsofC = 0;
            IntTotalUnplannedCallsOthers = 0;
            
            IntTotalActualCalls = 0;
            IntTotalActualCallsofA = 0;
            IntTotalActualCallsofB = 0;
            IntTotalActualCallsofC = 0;
            IntTotalActualCallsOthers = 0;
            
            IntTotalTotAccounts = 0;
            IntTotalTotAccountsofA = 0;
            IntTotalTotAccountsofB = 0;
            IntTotalTotAccountsofC = 0;
            IntTotalTotAccountsOthers = 0;
            
            IntTotalPlannedCalls = 0;
            IntTotalPlannedCallsofA = 0;
            IntTotalPlannedCallsofB = 0;
            IntTotalPlannedCallsofC = 0;
            IntTotalPlannedCallsOthers = 0;
            
            IntTotalTargetCalls = 0;
            IntTotalTargetCallsofA = 0;
            IntTotalTargetCallsofB = 0;
            IntTotalTargetCallsofC = 0;
            IntTotalTargetCallsOthers = 0;
            
            IntTotalFieldDays = 0;
            IntTotalCallstoPlan = 0;
            IntTotalAvgCallPerDay = 0;
            
            IntUnplannedCalls = 0;
            IntUnplannedCallsofA = 0;
            IntUnplannedCallsofB = 0;
            IntUnplannedCallsofC = 0;
            IntUnplannedCallsOthers = 0;
            
            IntTotalAccounts = 0;
            IntTotalAccountsofA = 0;
            IntTotalAccountsofB = 0;
            IntTotalAccountsofC = 0;
            IntTotalAccountsOthers = 0;
            
            IntActualCalls = 0;
            IntActualCallsofA = 0;
            IntActualCallsofB = 0;
            IntActualCallsofC = 0;
            IntActualCallsOthers = 0;
            
            IntPlannedCalls = 0;
            IntPlannedCallsofA = 0;
            IntPlannedCallsofB = 0;
            IntPlannedCallsofC = 0;
            IntPlannedCallsOthers = 0;
            
            IntTargetCalls = 0;
            IntTargetCallsofA = 0;
            IntTargetCallsofB = 0;
            IntTargetCallsofC = 0;
            IntTargetCallsOthers = 0;
            
            IntFieldDays = 0;
            IntCallstoPlan = 0;
            IntAvgCallPerDay = 0;
            
              IntOTHours = 0;
            IntTotalOTHours = 0;
        }
    }

}