/** 
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 *
 *
 *    Author         |Author-Email                  |Date       |Comment
 *    ---------------|------------------------------|-----------|--------------------------------------------------
 *    Parag Sharma   |parag.sharma@bausch.com       |22.Apr.2013 |First draft
 *    Parag Sharma   |parag.sharma@bausch.com       |18.June.2013 |Custom Label added for Field days
 *    Neha Jain      |neha.jain@bausch.com          |26-Feb-2014 | Done the changes for displaying data for last 13 months including the current month.
 *   Neha Jain       |neha.jain@bausch.com          |12-03-2014| Modified the code for average calculation. Now Avg will be calculated 
                                                                 for 6 working days in a week and not by field days
 *   Neha Jain       |neha.jain@bausch.com          |26-05-2014| Modified the code for average calculation for total. Values for total will be divided by the list size and not by fields days again.                                   
 */

//public with sharing class clsSFEMonthlyAvgCustomReport {
public class clsSFEMonthlyAvgCustomReport {

    Public Id APACId {get;set;}
    Public List<Call_Summary__c> lstAPACCallSumamry{get; set;}
    Public List<Call_Summary__c> lstAPACTemp{get; set;}
    Public Call_Summary__c ObjAPACCallSumamry {get; set;}
    Public List<APACCallSummary> lstAPACCallSummary {get; set;}
    Public APACCallSummary ObjAPACCallSummary {get; set;}
    Public APACCallSummary ObjUserAPACCallSummary {get; set;}
    Public APACCallSummary ObjTotalAPACCallSummary {get; set;}
    /*Public String sDate {get; set;}
    Public String eDate {get; set;}
    Public Date StartDate {get; set;}
    Public Date EndDate {get; set;}
    Public String header{get; set;}
    Public String monthName {get; set;}
    
    Public Boolean blnIsMonth {get; set;}
    
    Public Integer IntYearName {get; set;}
    Public String dayOfWeek {get; set;}
    Public Date WeekStartDate {get;set;}
    Public Date WeekEndDate {get;set;}
    Public String strSelectedMonth {get; set;}*/
    Public Integer monthNumber {get; set;}
    Public String strGrandTotal {get; set;}
    //Added by tarun
    Public List<User> lstManager {get; set;}
    Public Map<ID,ID> MapmanagerIdbyUserId {get; set;}
    Public Map<ID,String> MapUsermanager {get; set;}
    Public String strCountry {get; set;}
    Public String strProfileName {get; set;}
    Public string strProfileNameProfServiceRep {get; set;}
    Public List<User> lstUser {get; set;}
    Public Set<String> setUserId {get; set;}
    Public Set<Id> setNotInUserID {get; set;}
    Public Map<String,Integer> MapUserAccount {get; set;}
    Public String YearName {get; set;}
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
    public boolean blnIsUserSysAdminSSO {get; set;}
    private String strMyProflieName='';
    //Added new variables and properties by Neha Jain on 26th Feb, 2014 to show 13 months average data
    public Map<Integer,String> mapMonthName; 
    public List<String> monthNames{get;set;}
    public String currentMonthName{get;set;}
    public Integer intYearNumber{get;set;}
    
    public clsSFEMonthlyAvgCustomReport() {
         /*datMonthStartDate = null;
         datMonthEndDate = null;
        
         blnIsMonth = false;
         IntYearName = 0;
         datRefDate = null;
         StartDate = null;
         EndDate = null;
         sDate = null;
         eDate = null;*/
         strProfileNameProfServiceRep = null;
         monthNumber = 0;
         strGrandTotal = 'Grand Total';
         strCountry = null;
         strProfileName = null;
         setUserId = New Set<String>();
         setNotInUserID = New Set<Id>();
         MapUserAccount = New Map<String,Integer>();
         getLastMonthsName();
         lstUser = New List<User>();
         lstAPACCallSumamry = New List<Call_Summary__c>(lstAPACCallSumamry);
         lstAPACTemp = New List<Call_Summary__c>(lstAPACTemp);
         ObjAPACCallSumamry = New Call_Summary__c();
         lstAPACCallSummary = New List<APACCallSummary>();
         //Modified by Neha Jain, 26th Feb, 2014 for passing parameters as MAP
         ObjAPACCallSummary = New APACCallSummary(mapMonthName);
         ObjUserAPACCallSummary = New APACCallSummary(mapMonthName);
         ObjTotalAPACCallSummary = New APACCallSummary(mapMonthName);
         
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
    
    public clsSFEMonthlyAvgCustomReport(ApexPages.StandardController controller) {
         try{
         /*datMonthStartDate = null;
         datMonthEndDate = null;
         strProfileNameProfServiceRep = null;
         monthNumber = 0;
         blnIsMonth = false;
         IntYearName = 0;
         datRefDate = null;
         StartDate = null;
         EndDate = null;
         sDate = null;
         eDate = null;*/
         strProfileNameProfServiceRep = null;
         monthNumber = 0;
         strGrandTotal = 'Grand Total';
         strCountry = null;
         strProfileName = null;
         setUserId = New Set<String>();
         setNotInUserID = New Set<Id>();
         MapUserAccount = New Map<String,Integer>();
         getLastMonthsName();
         lstUser = New List<User>();
         lstAPACCallSumamry = New List<Call_Summary__c>(lstAPACCallSumamry);
         lstAPACTemp = New List<Call_Summary__c>(lstAPACTemp);
         ObjAPACCallSumamry = New Call_Summary__c();
         lstAPACCallSummary = New List<APACCallSummary>();
         system.debug('****intializing objects');
         ObjAPACCallSummary = New APACCallSummary(mapMonthName);
         system.debug('****intialized--1 objects');
         ObjUserAPACCallSummary = New APACCallSummary(mapMonthName);
         ObjTotalAPACCallSummary = New APACCallSummary(mapMonthName);
          system.debug('****intialized objects');
         List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
         strMyProflieName = PROFILE[0].Name;
         if(strMyProflieName.Contains('System Admin SSO')){
             blnIsUserSysAdminSSO= true;
         }
         else{
             blnIsUserSysAdminSSO= false;
         }
         system.debug('****InitCurrentMonth**');
         // Start Logic for Display data at Page Level          
         InitCurrentMonth();
         // End Logic for Display data at Page Level          
         }
         catch(Exception ex){
             System.debug('***Exception -- ' + ex);
         }
    }
    
    Public void InitCurrentMonth(){
        DateTime d = datetime.now();
        monthNumber = Integer.valueOf(d.Month());
        YearName= d.format('yyyy');
        /*dayOfWeek=d.format('EEEE');
        WeekStartDate = WeekStartDate(dayOfWeek);
        WeekEndDate = WeekEndDate(dayOfWeek);        
        System.debug('WeekStartDate = '+WeekStartDate);
        System.debug('WeekEndDate = '+WeekEndDate);
        monthName= d.format('MMMMM');
        monthNumber = Integer.valueOf(d.Month());
        
        //IntYearName = Integer.valueOf(d.format('yyyy'));
        String strMonth = String.valueOf(monthName.substring(0,3));
        strSelectedMonth = strMonth;   */     
        /*datRefDate = Date.newInstance(Integer.valueOf(YearName),ClsCallPlanUtil.MAP_MONTHNAME_MONTHNO.get(strMonth),1);        
        datMonthStartDate = getMonthStartDate(strMonth,datRefDate);                                 
        datMonthEndDate = datMonthStartDate.addDays(ClsCallPlanUtil.daysInMonths(ClsCallPlanUtil.MAP_MONTHNAME_MONTHNO.get(strMonth)));*/
        /*datMonthStartDate = WeekStartDate;
        datMonthEndDate = WeekEndDate;
        system.debug('**Tarun '+ d.addMonths(-12));
        System.debug('datMonthStartDate = '+datMonthStartDate);
        System.debug('datMonthEndDate = '+datMonthEndDate);          
        System.debug('monthNumber = '+monthNumber); */
        
        DisplayAPACCallSummary();
    }    
    
    Public void DisplayAPACCallSummary(){
    
        //strStartDate = WeekStartDate.day() + '-' + WeekStartDate.Month() + '-' + WeekStartDate.year();
        //strEndDate = WeekEndDate.day() + '-' + WeekEndDate.Month() + '-' + WeekEndDate.year();
        
        Date considerStartDate = Date.Today().toStartOfMonth().addMonths(-1).addYears(-1);        
        Date considerEndDate = Date.Today().addMonths(1).toStartOfMonth();
        
        System.debug('~~~~~~~~~considerStartDate : ' + considerStartDate + '~~~~~~~~~considerEndDate : ' + considerEndDate);
        
        strCountry = Label.Country_SFE_Custom_Report;
        strProfileName = 'INDSU Sales Rep';
        strProfileNameProfServiceRep = 'INDSU Service Rep';
        
        List<AggregateResult> lstAPACCallSumamry1 = [SELECT CALENDAR_MONTH(Date__c) Monthly, CALENDAR_YEAR(Date__c) Yearly, OwnerId uId, Owner.Name Name, Area__c City, RegionINDSU__c Reg, COUNT(Field_Days__c) BD, SUM(Actual_Calls__c) UP1                                                      
                                                    // FROM Call_Summary__c WHERE Date__c>= LAST_N_DAYS:365 AND Country__c =: strCountry GROUP BY CALENDAR_MONTH(Date__c), RegionINDSU__c, Area__c, Owner.Name, OwnerId ORDER BY RegionINDSU__c, Owner.Name ASC];                                                     
                                                    FROM Call_Summary__c 
                                                    WHERE 
                                                    //CALENDAR_YEAR(Date__c) =: IntYearName 
                                                    Date__c >: considerStartDate and Date__c <: considerEndDate  //Added by Neha Jain on 26th Feb, 2014 for showing 13 months data
                                                    AND Country__c =: strCountry AND owner.profile.name like '%INDSU%' GROUP BY CALENDAR_MONTH(Date__c), CALENDAR_YEAR(Date__c), RegionINDSU__c, Area__c, Owner.Name, OwnerId ORDER BY RegionINDSU__c, Owner.Name ASC];                                                     
                                                     
                                                         
        System.debug('lstAPACCallSumamry1 = ' + lstAPACCallSumamry1);
        setUserId = New Set<String>();
        MapUserAccount = New Map<String,Integer>();
        
        FOR(AggregateResult AP: lstAPACCallSumamry1){
            setUserId.add(String.valueOf(AP.get('uId')));            
        }
        //get manager list of listcallsummaryuser --Tarun Solanki
          MapUsermanager = New Map<ID,String>();         
         MapmanagerIdbyUserId= New Map<ID,String>();
        list<ID> ManagerIdlist =new list<ID>();    
        lstManager =New List<User>();
        lstManager = [SELECT Id,manager.name FROM User WHERE (Profile.Name =: strProfileName OR Profile.Name =: strProfileNameProfServiceRep) AND Id IN : setUserId AND IsActive = TRUE  ORDER BY user.manager.name]; 
        FOR(User lm: lstManager){
         if(MapUsermanager.get(lm.manager.id) == null){
             ManagerIdlist.add(lm.manager.id);
            MapUsermanager.put(lm.manager.id,lm.manager.name);
            }
            MapmanagerIdbyUserId.put(lm.id,lm.manager.id);
            
        }            
        lstUser = New List<User>();
        lstUser = [SELECT user.manager.name ,Id, Name, Profile.Name, APAC_Area__c, APAC_Country__c, APAC_Region__c FROM User WHERE (Profile.Name =: strProfileName OR Profile.Name =: strProfileNameProfServiceRep) AND Id NOT IN : setUserId AND IsActive = TRUE  ORDER BY user.manager.name];        
        //lstUser = [SELECT Id, Name, Profile.Name, APAC_Area__c, APAC_Country__c, APAC_Region__c FROM User WHERE (Profile.Name =: strProfileName OR Profile.Name =: strProfileNameProfServiceRep) AND Id NOT IN : setUserId AND IsActive = TRUE ORDER BY APAC_Region__c, Name];        
        //lstUser = [SELECT Id, Name, Profile.Name, APAC_Area__c, APAC_Country__c, APAC_Region__c User WHERE (Profile.Name =: strProfileName OR Profile.Name =: strProfileNameProfServiceRep) AND IsActive = TRUE ORDER BY APAC_Region__c];
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
        
        lstAPACCallSummary = New List<APACCallSummary>();
        List<APACCallSummary> lstAPACCallSummaryNew = New List<APACCallSummary>();
        APACCallSummary ObjAPACCallSummary;              
        APACCallSummary ObjTotalAPACCallSummary;
        APACCallSummary ObjUserAPACCallSummary;
        ObjTotalAPACCallSummary = New APACCallSummary(mapMonthName); 
        ObjUserAPACCallSummary = New APACCallSummary(mapMonthName); 
        Map<Id,List<APACCallSummary>> mapManagerCallSummary = new Map<Id,List<APACCallSummary>>();           
        set<String> setTempUserIdFirst = New Set<String>(); 
        set<String> setTempUserIdSecond = New Set<String>();
        ID IdUser;        
        ID IdManagerbyUserId;  
         //today's month -- Added by Neha Jain
        integer intMonthNumber = Integer.valueOf(Date.today().Month());        
        FOR(String US: setUserId){
            ObjAPACCallSummary = New APACCallSummary(mapMonthName);
            FOR(AggregateResult AR: lstAPACCallSumamry1) {
                
                /*IF(String.valueOf(AR.get('uId')) == US && AR.get('Reg') != null && AR.get('City') != null && AR.get('Name') != null)*/
                IF(String.valueOf(AR.get('uId')) == US){                  
                    ObjAPACCallSummary.APID = String.valueOf(AR.get('uId'));
                    ObjAPACCallSummary.strName = String.valueOf(AR.get('Name')); 
                    System.debug('ObjAPACCallSummary.strName = ' + ObjAPACCallSummary.strName);
                    ObjAPACCallSummary.strCity = AR.get('City') ==null ? null : String.valueOf(AR.get('City')); 
                    ObjAPACCallSummary.strRegion = AR.get('Reg') ==null ? null : String.valueOf(AR.get('Reg')).trim();
                    //By Tarun Solanki                                                  
                    
                    IdUser=String.valueof(AR.get('uId'));           
            
                    IdManagerbyUserId =  MapmanagerIdbyUserId.get(IdUser);
            
                    ObjAPACCallSummary.strManagerName=MapUsermanager.get(IdManagerbyUserId);
            
            
                    ObjTotalAPACCallSummary.strTotalRegion = 'Grand Total ';  //+ ObjAPACCallSummary.strRegion;
                    
                    
                    //System.debug('AR.get = '+ AR.get('Monthly'));
                    IF(AR.get('Monthly') != null){
                         //added below code by Neha Jain on 26th Feb, 2014 for adding an extra month for current month of last year.
                        //extract today's year to get previous year data 
                        intYearNumber = Integer.valueOf(Date.today().Year()) - 1;
                        //to extract current month in string 
                        Datetime todaysTime = DateTime.Now();
                        currentMonthName = todaysTime.format('MMM');
                        
                        //Added new code block for adding an extra month for current month of last year.
                        IF(String.valueOf(AR.get('Monthly')) == String.ValueOf(intMonthNumber) && String.valueOf(AR.get('Yearly')) == String.ValueOf(intYearNumber)){  
                           
                            //Decimal AvgCurrentMonth = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / Decimal.valueOf(String.valueOf(AR.get('BD')));
                            decimal noOfdays = CalenderDaysInMonth(String.ValueOf(intMonthNumber))/7;
                            //Decimal AvgDaysCurrentMonth = Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth(String.ValueOf(intMonthNumber))) / 7);
                            decimal AvgDaysCurrentMonth = decimal.valueOf(Label.SFE_Field_Days) * noOfdays ;
                            decimal AvgCurrentMonth = decimal.valueOf(String.valueOf(AR.get('UP1'))) / AvgDaysCurrentMonth ;
                            ObjAPACCallSummary.DecAvgCurrentMonthPY += AvgCurrentMonth;
                            ObjAPACCallSummary.DecAvgCurrentMonthPY = ObjAPACCallSummary.DecAvgCurrentMonthPY.setScale(2);                        
                            ObjAPACCallSummary.DecAvgRowTotal += ObjAPACCallSummary.DecAvgCurrentMonthPY;
                            // to avoid the month repetation again for the previous year
                            continue;                        
                        }                       
                        
                        
                        IF(String.valueOf(AR.get('Monthly')) == '1'){                        
                            Decimal AvgDaysJan = Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('1')) / 7);
                            //Decimal AvgJan = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / Decimal.valueOf(String.valueOf(AR.get('BD')));
                            Decimal AvgJan = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / AvgDaysJan;
                            ObjAPACCallSummary.DecAvgJan += AvgJan;
                            ObjAPACCallSummary.DecAvgJan = ObjAPACCallSummary.DecAvgJan.setScale(2);                        
                            ObjAPACCallSummary.DecAvgRowTotal += ObjAPACCallSummary.DecAvgJan;
                            
                            //ObjTotalAPACCallSummary.DecAvgJanColTotal += ObjAPACCallSummary.DecAvgJan;
                            //ObjTotalAPACCallSummary.DecAvgMonthRowTotal += ObjTotalAPACCallSummary.DecAvgJanColTotal;
                            //System.debug('ObjAPACCallSummary.DecAvgJan = '+ ObjAPACCallSummary.DecAvgJan); 
                            
                            //Added code to display data as per last 12 months, Neha Jain, 26th Feb, 2014
                            ObjAPACCallSummary.mapMonthAvgValues.put(mapMonthName.get(1), ObjAPACCallSummary.DecAvgJan);                                              
                        }                        
                        
                        IF(String.valueOf(AR.get('Monthly')) == '2'){                                
                            Decimal AvgDaysFeb = Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('2')) / 7);
                            IF(Integer.valueOf(AR.get('Monthly')) >= MonthNumber) {
                                ObjAPACCallSummary.blnAvgFeb = true;
                            }
                            //Decimal AvgFeb = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / Decimal.valueOf(String.valueOf(AR.get('BD')));
                            Decimal AvgFeb = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / AvgDaysFeb;
                            ObjAPACCallSummary.DecAvgFeb += AvgFeb;
                            ObjAPACCallSummary.DecAvgFeb = ObjAPACCallSummary.DecAvgFeb.setScale(2);                        
                            ObjAPACCallSummary.DecAvgRowTotal += ObjAPACCallSummary.DecAvgFeb;
                            
                            //ObjTotalAPACCallSummary.DecAvgFebColTotal += ObjAPACCallSummary.DecAvgFeb;
                            //ObjTotalAPACCallSummary.DecAvgMonthRowTotal += ObjTotalAPACCallSummary.DecAvgFebColTotal;
                            //System.debug('ObjAPACCallSummary.DecAvgFeb = '+ ObjAPACCallSummary.DecAvgFeb);
                            
                            //Added code to display data as per last 12 months, Neha Jain, 26th Feb, 2014                  
                            ObjAPACCallSummary.mapMonthAvgValues.put(mapMonthName.get(2), ObjAPACCallSummary.DecAvgFeb);                            
                        }
                        IF(String.valueOf(AR.get('Monthly')) == '3'){
                            IF(Integer.valueOf(AR.get('Monthly')) >= MonthNumber) {
                                ObjAPACCallSummary.blnAvgMar = true;
                            }
                            Decimal AvgDaysMar = Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('3')) / 7);
                            //Decimal AvgMar = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / Decimal.valueOf(String.valueOf(AR.get('BD')));
                            Decimal AvgMar = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / AvgDaysMar;
                            ObjAPACCallSummary.DecAvgMar += AvgMar;
                            ObjAPACCallSummary.DecAvgMar = ObjAPACCallSummary.DecAvgMar.setScale(2);
                            ObjAPACCallSummary.DecAvgRowTotal += ObjAPACCallSummary.DecAvgMar;
                            
                            //ObjTotalAPACCallSummary.DecAvgMarColTotal += ObjAPACCallSummary.DecAvgMar;
                            //ObjTotalAPACCallSummary.DecAvgMonthRowTotal += ObjTotalAPACCallSummary.DecAvgMarColTotal;
                            //System.debug('ObjAPACCallSummary.DecAvgMar = '+ ObjAPACCallSummary.DecAvgMar); 
                            //Added code to display data as per last 12 months, Neha Jain, 26th Feb, 2014
                            ObjAPACCallSummary.mapMonthAvgValues.put(mapMonthName.get(3), ObjAPACCallSummary.DecAvgMar);                                                      
                        }
                        IF(String.valueOf(AR.get('Monthly')) == '4'){
                            IF(MonthNumber >= Integer.valueOf(AR.get('Monthly'))) {
                                ObjAPACCallSummary.blnAvgApr = true;
                            }
                            Decimal AvgDaysApr = Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('4')) / 7);
                            //Decimal AvgApr = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / Decimal.valueOf(String.valueOf(AR.get('BD')));
                            Decimal AvgApr = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / AvgDaysApr;
                            ObjAPACCallSummary.DecAvgApr += AvgApr;
                            ObjAPACCallSummary.DecAvgApr = ObjAPACCallSummary.DecAvgApr.setScale(2);
                            ObjAPACCallSummary.DecAvgRowTotal += ObjAPACCallSummary.DecAvgApr;
                            
                            //ObjTotalAPACCallSummary.DecAvgAprColTotal += ObjAPACCallSummary.DecAvgApr;
                            //ObjTotalAPACCallSummary.DecAvgMonthRowTotal += ObjTotalAPACCallSummary.DecAvgAprColTotal;
                            //System.debug('ObjAPACCallSummary.DecAvgApr = '+ ObjAPACCallSummary.DecAvgApr);  
                            
                             //Added code to display data as per last 12 months, Neha Jain, 26th Feb, 2014
                            ObjAPACCallSummary.mapMonthAvgValues.put(mapMonthName.get(4), ObjAPACCallSummary.DecAvgApr);                                              
                        }
                        IF(String.valueOf(AR.get('Monthly')) == '5'){
                            IF(Integer.valueOf(AR.get('Monthly')) >= MonthNumber) {
                                ObjAPACCallSummary.blnAvgMay = true;
                            }
                            //Decimal AvgMay = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / Decimal.valueOf(String.valueOf(AR.get('BD')));
                            Decimal AvgDaysMay = Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('5')) / 7);
                            Decimal AvgMay = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / AvgDaysMay;
                            ObjAPACCallSummary.DecAvgMay += AvgMay;
                            ObjAPACCallSummary.DecAvgMay = ObjAPACCallSummary.DecAvgMay.setScale(2);
                            ObjAPACCallSummary.DecAvgRowTotal += ObjAPACCallSummary.DecAvgMay;
                            
                            //ObjTotalAPACCallSummary.DecAvgMayColTotal += ObjAPACCallSummary.DecAvgMay;
                            //ObjTotalAPACCallSummary.DecAvgMonthRowTotal += ObjTotalAPACCallSummary.DecAvgMayColTotal;
                            //System.debug('ObjAPACCallSummary.DecAvgMay = '+ ObjAPACCallSummary.DecAvgMay);  
                            
                            //Added code to display data as per last 12 months, Neha Jain, 26th Feb, 2014
                            ObjAPACCallSummary.mapMonthAvgValues.put(mapMonthName.get(5), ObjAPACCallSummary.DecAvgMay);                                                     
                        }
                        IF(String.valueOf(AR.get('Monthly')) == '6'){
                            IF(Integer.valueOf(AR.get('Monthly')) >= MonthNumber) {
                                ObjAPACCallSummary.blnAvgJune = true;
                            }
                            //Decimal AvgJune = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / Decimal.valueOf(String.valueOf(AR.get('BD')));
                            Decimal AvgDaysJun = Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('6')) / 7);
                            Decimal AvgJune = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / AvgDaysJun;
                            ObjAPACCallSummary.DecAvgJune += AvgJune;
                            ObjAPACCallSummary.DecAvgJune = ObjAPACCallSummary.DecAvgJune.setScale(2);
                            ObjAPACCallSummary.DecAvgRowTotal += ObjAPACCallSummary.DecAvgJune;
                            
                            //Added code to display data as per last 12 months, Neha Jain, 26th Feb, 2014
                            ObjAPACCallSummary.mapMonthAvgValues.put(mapMonthName.get(6), ObjAPACCallSummary.DecAvgJune);      
                        }
                        IF(String.valueOf(AR.get('Monthly')) == '7'){
                            IF(Integer.valueOf(AR.get('Monthly')) >= MonthNumber) {
                                ObjAPACCallSummary.blnAvgJuly = true;
                            }
                            Decimal AvgDaysJul = Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('7')) / 7);
                            //Decimal AvgJuly = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / Decimal.valueOf(String.valueOf(AR.get('BD')));
                            Decimal AvgJuly = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / AvgDaysJul;
                            ObjAPACCallSummary.DecAvgJuly += AvgJuly;
                            ObjAPACCallSummary.DecAvgJuly = ObjAPACCallSummary.DecAvgJuly.setScale(2);
                            ObjAPACCallSummary.DecAvgRowTotal += ObjAPACCallSummary.DecAvgJuly;
                            
                             //Added code to display data as per last 12 months, Neha Jain, 26th Feb, 2014
                            ObjAPACCallSummary.mapMonthAvgValues.put(mapMonthName.get(7), ObjAPACCallSummary.DecAvgJuly);                                                
                        }
                        IF(String.valueOf(AR.get('Monthly')) == '8'){
                            IF(Integer.valueOf(AR.get('Monthly')) >= MonthNumber) {
                                ObjAPACCallSummary.blnAvgAug = true;
                            }
                            //Decimal AvgAug = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / Decimal.valueOf(String.valueOf(AR.get('BD')));
                            Decimal AvgDaysAug = Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('8')) / 7);
                            Decimal AvgAug = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / AvgDaysAug;
                            ObjAPACCallSummary.DecAvgAug += AvgAug;
                            ObjAPACCallSummary.DecAvgAug = ObjAPACCallSummary.DecAvgAug.setScale(2);
                            ObjAPACCallSummary.DecAvgRowTotal += ObjAPACCallSummary.DecAvgAug;
                            
                            //Added code to display data as per last 12 months, Neha Jain, 26th Feb, 2014
                            ObjAPACCallSummary.mapMonthAvgValues.put(mapMonthName.get(8), ObjAPACCallSummary.DecAvgAug);                              
                        }                    
                        IF(String.valueOf(AR.get('Monthly')) == '9'){
                            IF(Integer.valueOf(AR.get('Monthly')) >= MonthNumber) {
                                ObjAPACCallSummary.blnAvgSep = true;
                            }
                            //Decimal AvgSep = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / Decimal.valueOf(String.valueOf(AR.get('BD')));
                            Decimal AvgDaysSep = Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('9')) / 7);
                            Decimal AvgSep = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / AvgDaysSep;
                            ObjAPACCallSummary.DecAvgSep += AvgSep;
                            ObjAPACCallSummary.DecAvgSep = ObjAPACCallSummary.DecAvgSep.setScale(2);
                            ObjAPACCallSummary.DecAvgRowTotal += ObjAPACCallSummary.DecAvgSep;
                            
                          //Added code to display data as per last 12 months, Neha Jain, 26th Feb, 2014
                            ObjAPACCallSummary.mapMonthAvgValues.put(mapMonthName.get(9), ObjAPACCallSummary.DecAvgSep);                                                                                                   
                        }
                        IF(String.valueOf(AR.get('Monthly')) == '10'){
                            IF(Integer.valueOf(AR.get('Monthly')) >= MonthNumber) {
                                ObjAPACCallSummary.blnAvgOct = true;
                            }
                            //Decimal AvgOct = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / Decimal.valueOf(String.valueOf(AR.get('BD')));
                            Decimal AvgDaysOct = Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('10')) / 7);
                            Decimal AvgOct = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / AvgDaysOct;
                            ObjAPACCallSummary.DecAvgOct += AvgOct;
                            ObjAPACCallSummary.DecAvgOct = ObjAPACCallSummary.DecAvgOct.setScale(2);
                            ObjAPACCallSummary.DecAvgRowTotal += ObjAPACCallSummary.DecAvgOct;
                            
                           //Added code to display data as per last 12 months, Neha Jain, 26th Feb, 2014
                            ObjAPACCallSummary.mapMonthAvgValues.put(mapMonthName.get(10), ObjAPACCallSummary.DecAvgOct);                                                                      
                        }
                        IF(String.valueOf(AR.get('Monthly')) == '11'){
                            IF(Integer.valueOf(AR.get('Monthly')) >= MonthNumber) {
                                ObjAPACCallSummary.blnAvgNov = true;
                            }
                            //Decimal AvgNov = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / Decimal.valueOf(String.valueOf(AR.get('BD')));
                            Decimal AvgDaysNov = Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('11')) / 7);
                            Decimal AvgNov = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / AvgDaysNov;
                            ObjAPACCallSummary.DecAvgNov += AvgNov;
                            ObjAPACCallSummary.DecAvgNov = ObjAPACCallSummary.DecAvgNov.setScale(2);
                            ObjAPACCallSummary.DecAvgRowTotal += ObjAPACCallSummary.DecAvgNov;
                            
                            //Added code to display data as per last 12 months, Neha Jain, 26th Feb, 2014
                            ObjAPACCallSummary.mapMonthAvgValues.put(mapMonthName.get(11), ObjAPACCallSummary.DecAvgNov);                                                     
                        }
                        IF(String.valueOf(AR.get('Monthly')) == '12'){
                            IF(Integer.valueOf(AR.get('Monthly')) >= MonthNumber) {
                                ObjAPACCallSummary.blnAvgDec = true;
                            }
                            //Decimal AvgDec = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / Decimal.valueOf(String.valueOf(AR.get('BD')));
                            Decimal AvgDaysDec = Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('12')) / 7);
                            Decimal AvgDec = Decimal.valueOf(String.valueOf(AR.get('UP1'))) / AvgDaysDec;
                            ObjAPACCallSummary.DecAvgDec += AvgDec;
                            ObjAPACCallSummary.DecAvgDec = ObjAPACCallSummary.DecAvgDec.setScale(2);
                            ObjAPACCallSummary.DecAvgRowTotal += ObjAPACCallSummary.DecAvgDec;
                            
                            //Added code to display data as per last 12 months, Neha Jain, 26th Feb, 2014
                            ObjAPACCallSummary.mapMonthAvgValues.put(mapMonthName.get(12), ObjAPACCallSummary.DecAvgDec);                                  
                        }
                    }                    
                    //lstAPACCallSummaryNew.add(ObjAPACCallSummary);
                }                
            }
            ObjTotalAPACCallSummary.DecAvgMonthRowTotal += ObjAPACCallSummary.DecAvgRowTotal;
            ObjTotalAPACCallSummary.DecAvgJanColTotal += ObjAPACCallSummary.DecAvgJan;
            ObjTotalAPACCallSummary.DecAvgFebColTotal += ObjAPACCallSummary.DecAvgFeb;
            ObjTotalAPACCallSummary.DecAvgMarColTotal += ObjAPACCallSummary.DecAvgMar;
            ObjTotalAPACCallSummary.DecAvgAprColTotal += ObjAPACCallSummary.DecAvgApr;
            ObjTotalAPACCallSummary.DecAvgMayColTotal += ObjAPACCallSummary.DecAvgMay;
            ObjTotalAPACCallSummary.DecAvgJuneColTotal += ObjAPACCallSummary.DecAvgJune;
            ObjTotalAPACCallSummary.DecAvgJulyColTotal += ObjAPACCallSummary.DecAvgJuly;
            ObjTotalAPACCallSummary.DecAvgAugColTotal += ObjAPACCallSummary.DecAvgAug;
            ObjTotalAPACCallSummary.DecAvgSepColTotal += ObjAPACCallSummary.DecAvgSep;
            ObjTotalAPACCallSummary.DecAvgOctColTotal += ObjAPACCallSummary.DecAvgOct;
            ObjTotalAPACCallSummary.DecAvgNovColTotal += ObjAPACCallSummary.DecAvgNov;
            ObjTotalAPACCallSummary.DecAvgDecColTotal += ObjAPACCallSummary.DecAvgDec;
            ObjTotalAPACCallSummary.DecAvgCurrentMonthPYColTotal += ObjAPACCallSummary.DecAvgCurrentMonthPY;
            
             //Added code to display data as per last 12 months, Neha Jain, 26th Feb, 2014
            /*ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(1), ObjTotalAPACCallSummary.DecAvgJanColTotal);
            ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(2), ObjTotalAPACCallSummary.DecAvgFebColTotal);
            ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(3), ObjTotalAPACCallSummary.DecAvgMarColTotal);
            ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(4), ObjTotalAPACCallSummary.DecAvgAprColTotal);
            ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(5), ObjTotalAPACCallSummary.DecAvgMayColTotal);
            ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(6), ObjTotalAPACCallSummary.DecAvgJuneColTotal);
            ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(7), ObjTotalAPACCallSummary.DecAvgJulyColTotal);
            ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(8), ObjTotalAPACCallSummary.DecAvgAugColTotal);
            ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(9), ObjTotalAPACCallSummary.DecAvgSepColTotal);
            ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(10), ObjTotalAPACCallSummary.DecAvgOctColTotal);
            ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(11), ObjTotalAPACCallSummary.DecAvgNovColTotal);
            ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(12), ObjTotalAPACCallSummary.DecAvgDecColTotal);*/
            
            
             //Intialize the list to add in map to sort for managers
            List<APACCallSummary> lstNewAPACCallSummary = New List<APACCallSummary>();
            //if manager already exists in map, retrive its list
            if(mapManagerCallSummary.get(IdManagerbyUserId) != null){
                lstNewAPACCallSummary = mapManagerCallSummary.get(IdManagerbyUserId);
            }
            //add new summary to the map.
            lstNewAPACCallSummary.add(ObjAPACCallSummary);
            //put the map with new values
            mapManagerCallSummary.put(IdManagerbyUserId,lstNewAPACCallSummary);
                                
        }
        //iterate over map to get a sorted list as per manager
       
        IF(ManagerIdlist.size()>0)
        {
            for(integer j=0;j<ManagerIdlist.size();j++){
            
            lstAPACCallSummary.addAll(mapManagerCallSummary.get(ManagerIdlist[j]));
            lstAPACCallSummaryNew.addAll(mapManagerCallSummary.get(ManagerIdlist[j]));              
            }
        }
            
            //lstAPACCallSummaryNew.add(ObjAPACCallSummary);
            //lstAPACCallSummary.add(ObjAPACCallSummary);
               
        FOR(User uu: lstUser){
           ObjAPACCallSummary = New APACCallSummary(mapMonthName);
           ObjAPACCallSummary.strName = uu.Name; 
           ObjAPACCallSummary.strCity = uu.APAC_Area__c;
           ObjAPACCallSummary.strRegion = uu.APAC_Region__c;
            ObjAPACCallSummary.strManagerName  = uu.Manager.Name; 
           lstAPACCallSummaryNew.add(ObjAPACCallSummary);
           lstAPACCallSummary.add(ObjAPACCallSummary);
           
        }
        
        
        ObjTotalAPACCallSummary.DecAvgJanColTotal = ObjTotalAPACCallSummary.DecAvgJanColTotal / lstAPACCallSummaryNew.Size();
        ObjTotalAPACCallSummary.DecAvgJanColTotal = ObjTotalAPACCallSummary.DecAvgJanColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgFebColTotal = ObjTotalAPACCallSummary.DecAvgFebColTotal / lstAPACCallSummaryNew.Size();
        ObjTotalAPACCallSummary.DecAvgFebColTotal = ObjTotalAPACCallSummary.DecAvgFebColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgMarColTotal = ObjTotalAPACCallSummary.DecAvgMarColTotal / lstAPACCallSummaryNew.Size();
        ObjTotalAPACCallSummary.DecAvgMarColTotal = ObjTotalAPACCallSummary.DecAvgMarColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgAprColTotal = ObjTotalAPACCallSummary.DecAvgAprColTotal / lstAPACCallSummaryNew.Size();
        ObjTotalAPACCallSummary.DecAvgAprColTotal = ObjTotalAPACCallSummary.DecAvgAprColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgMayColTotal = ObjTotalAPACCallSummary.DecAvgMayColTotal / lstAPACCallSummaryNew.Size();
        ObjTotalAPACCallSummary.DecAvgMayColTotal = ObjTotalAPACCallSummary.DecAvgMayColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgJuneColTotal = ObjTotalAPACCallSummary.DecAvgJuneColTotal / lstAPACCallSummaryNew.Size();
        ObjTotalAPACCallSummary.DecAvgJuneColTotal = ObjTotalAPACCallSummary.DecAvgJuneColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgJulyColTotal = ObjTotalAPACCallSummary.DecAvgJulyColTotal / lstAPACCallSummaryNew.Size();
        ObjTotalAPACCallSummary.DecAvgJulyColTotal = ObjTotalAPACCallSummary.DecAvgJulyColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgAugColTotal = ObjTotalAPACCallSummary.DecAvgAugColTotal / lstAPACCallSummaryNew.Size();
        ObjTotalAPACCallSummary.DecAvgAugColTotal = ObjTotalAPACCallSummary.DecAvgAugColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgSepColTotal = ObjTotalAPACCallSummary.DecAvgSepColTotal / lstAPACCallSummaryNew.Size();
        ObjTotalAPACCallSummary.DecAvgSepColTotal = ObjTotalAPACCallSummary.DecAvgSepColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgOctColTotal = ObjTotalAPACCallSummary.DecAvgOctColTotal / lstAPACCallSummaryNew.Size();
        ObjTotalAPACCallSummary.DecAvgOctColTotal = ObjTotalAPACCallSummary.DecAvgOctColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgNovColTotal = ObjTotalAPACCallSummary.DecAvgNovColTotal / lstAPACCallSummaryNew.Size();
        ObjTotalAPACCallSummary.DecAvgNovColTotal = ObjTotalAPACCallSummary.DecAvgNovColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgDecColTotal = ObjTotalAPACCallSummary.DecAvgDecColTotal / lstAPACCallSummaryNew.Size();
        ObjTotalAPACCallSummary.DecAvgDecColTotal = ObjTotalAPACCallSummary.DecAvgDecColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgCurrentMonthPYColTotal = ObjTotalAPACCallSummary.DecAvgCurrentMonthPYColTotal/lstAPACCallSummaryNew.Size();
        ObjTotalAPACCallSummary.DecAvgCurrentMonthPYColTotal = ObjTotalAPACCallSummary.DecAvgCurrentMonthPYColTotal.setScale(2);
        
        /* Commented by Neha Jain to modify the logic of Average calculation for total.
        ObjTotalAPACCallSummary.DecAvgJanColTotal = ObjTotalAPACCallSummary.DecAvgJanColTotal / (Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('1')) / 7) * lstAPACCallSummaryNew.Size());
        ObjTotalAPACCallSummary.DecAvgJanColTotal = ObjTotalAPACCallSummary.DecAvgJanColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgFebColTotal = ObjTotalAPACCallSummary.DecAvgFebColTotal / (Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('2')) / 7)* lstAPACCallSummaryNew.Size());
        ObjTotalAPACCallSummary.DecAvgFebColTotal = ObjTotalAPACCallSummary.DecAvgFebColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgMarColTotal = ObjTotalAPACCallSummary.DecAvgMarColTotal / (Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('3')) / 7)* lstAPACCallSummaryNew.Size());
        ObjTotalAPACCallSummary.DecAvgMarColTotal = ObjTotalAPACCallSummary.DecAvgMarColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgAprColTotal = ObjTotalAPACCallSummary.DecAvgAprColTotal / (Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('4')) / 7)* lstAPACCallSummaryNew.Size());
        ObjTotalAPACCallSummary.DecAvgAprColTotal = ObjTotalAPACCallSummary.DecAvgAprColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgMayColTotal = ObjTotalAPACCallSummary.DecAvgMayColTotal / (Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('5')) / 7)* lstAPACCallSummaryNew.Size());
        ObjTotalAPACCallSummary.DecAvgMayColTotal = ObjTotalAPACCallSummary.DecAvgMayColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgJuneColTotal = ObjTotalAPACCallSummary.DecAvgJuneColTotal / (Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('6')) / 7)* lstAPACCallSummaryNew.Size());
        ObjTotalAPACCallSummary.DecAvgJuneColTotal = ObjTotalAPACCallSummary.DecAvgJuneColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgJulyColTotal = ObjTotalAPACCallSummary.DecAvgJulyColTotal / (Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('7')) / 7)* lstAPACCallSummaryNew.Size());
        ObjTotalAPACCallSummary.DecAvgJulyColTotal = ObjTotalAPACCallSummary.DecAvgJulyColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgAugColTotal = ObjTotalAPACCallSummary.DecAvgAugColTotal / (Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('8')) / 7)* lstAPACCallSummaryNew.Size());
        ObjTotalAPACCallSummary.DecAvgAugColTotal = ObjTotalAPACCallSummary.DecAvgAugColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgSepColTotal = ObjTotalAPACCallSummary.DecAvgSepColTotal / (Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('9')) / 7)* lstAPACCallSummaryNew.Size());
        ObjTotalAPACCallSummary.DecAvgSepColTotal = ObjTotalAPACCallSummary.DecAvgSepColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgOctColTotal = ObjTotalAPACCallSummary.DecAvgOctColTotal / (Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('10')) / 7)* lstAPACCallSummaryNew.Size());
        ObjTotalAPACCallSummary.DecAvgOctColTotal = ObjTotalAPACCallSummary.DecAvgOctColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgNovColTotal = ObjTotalAPACCallSummary.DecAvgNovColTotal / (Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('11')) / 7)* lstAPACCallSummaryNew.Size());
        ObjTotalAPACCallSummary.DecAvgNovColTotal = ObjTotalAPACCallSummary.DecAvgNovColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgDecColTotal = ObjTotalAPACCallSummary.DecAvgDecColTotal / (Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth('12')) / 7)* lstAPACCallSummaryNew.Size());
        ObjTotalAPACCallSummary.DecAvgDecColTotal = ObjTotalAPACCallSummary.DecAvgDecColTotal.setScale(2);
        
        ObjTotalAPACCallSummary.DecAvgCurrentMonthPYColTotal = ObjTotalAPACCallSummary.DecAvgCurrentMonthPYColTotal / (Decimal.valueOf(Label.SFE_Field_Days) * (Decimal.valueOf(CalenderDaysInMonth(String.valueOf(intMonthNumber))) / 7)* lstAPACCallSummaryNew.Size());
        ObjTotalAPACCallSummary.DecAvgCurrentMonthPYColTotal = ObjTotalAPACCallSummary.DecAvgCurrentMonthPYColTotal.setScale(2);*/
        
        
        
        //Added code to display data as per last 12 months, Neha Jain, 26th Feb, 2014
        ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(1), ObjTotalAPACCallSummary.DecAvgJanColTotal);
        ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(2), ObjTotalAPACCallSummary.DecAvgFebColTotal);
        ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(3), ObjTotalAPACCallSummary.DecAvgMarColTotal);
        ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(4), ObjTotalAPACCallSummary.DecAvgAprColTotal);
        ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(5), ObjTotalAPACCallSummary.DecAvgMayColTotal);
        ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(6), ObjTotalAPACCallSummary.DecAvgJuneColTotal);
        ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(7), ObjTotalAPACCallSummary.DecAvgJulyColTotal);
        ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(8), ObjTotalAPACCallSummary.DecAvgAugColTotal);
        ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(9), ObjTotalAPACCallSummary.DecAvgSepColTotal);
        ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(10), ObjTotalAPACCallSummary.DecAvgOctColTotal);
        ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(11), ObjTotalAPACCallSummary.DecAvgNovColTotal);
        ObjTotalAPACCallSummary.mapMonthAvgTotalValues.put(mapMonthName.get(12), ObjTotalAPACCallSummary.DecAvgDecColTotal);
        
        lstAPACCallSummary.add(ObjTotalAPACCallSummary);
        //sortList(lstAPACCallSummary, 'strRegion', 'asc');
        lstAPACCallSummaryNew = New List<APACCallSummary>();
    }
                
    public pagereference exportToExcel(){          
          //System.debug('strSelectedMonth = ' + strSelectedMonth);
          sendmail();
          return null;
         
    }
    Public String strStartDate {get; set;}
    Public String strEndDate {get; set;}
     public void SendMailToUserOnly()
    {        
        //User objUser = [SELECT Id, Name FROM User WHERE Id =: UserInfo.getUserId()];
        String strSenderName = Label.EmailSenderName;
        User objUser = [SELECT Id, Name FROM User WHERE Name =: strSenderName];
       
        // First, need to obtain the ID of the email template we created.
        EmailTemplate et;
       
            //Show master data in report to send
            et = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName='SFE_Monthly_Avg_Matrix_for_India'];
       
        //EmailTemplate et = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName='SFE_Calling_Matrix_for_India_No_Master'];
        System.debug('et = '+et);
        //strStartDate = WeekStartDate.day() + '-' + WeekStartDate.Month() + '-' + WeekStartDate.year();
        //strEndDate = WeekEndDate.day() + '-' + WeekEndDate.Month() + '-' + WeekEndDate.year();
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
        //strValue='Report mailed to your email address. Please check.';
       // blnIsMasterDataHidden = false;
    }
    public void sendmail()
    {        
        //User objUser = [SELECT Id, Name FROM User WHERE Id =: UserInfo.getUserId()];
        String strSenderName = Label.EmailSenderName;
        User objUser = [SELECT Id, Name FROM User WHERE Name =: strSenderName];
        // First, need to obtain the ID of the email template we created.
        EmailTemplate et = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName='SFE_Monthly_Avg_Matrix_for_India'];
        
        System.debug('et = '+et);
        //strStartDate = WeekStartDate.day() + '-' + WeekStartDate.Month() + '-' + WeekStartDate.year();
        //strEndDate = WeekEndDate.day() + '-' + WeekEndDate.Month() + '-' + WeekEndDate.year();
        String strEmailName = Label.EmailToMonthlyAvg;  
        String strEmailToCCName = Label.EmailToCCMonthlyAvg;        
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
    
    Public Integer CalenderDaysInMonth(String Month){
        
        Integer NoofDays = 0;
        
        IF(Month == '1'){
            NoofDays = 31;
        } Else IF(Month == '2'){
            IF ((Math.mod(Integer.valueof(System.Today().year()),4)==0 && Math.mod(Integer.valueof(System.Today().year()),100) != 0) || Math.mod(Integer.valueof(System.Today().year()),400) == 0){
                NoofDays = 29;
            } Else {
                NoofDays = 28;
            }
        } Else IF(Month == '3'){
            NoofDays = 31;
        } Else IF(Month == '4'){
            NoofDays = 30;
        } Else IF(Month == '5'){
            NoofDays = 31;
        } Else IF(Month == '6'){
            NoofDays = 30;
        } Else IF(Month == '7'){
            NoofDays = 31;
        } Else IF(Month == '8'){
            NoofDays = 31;
        } Else IF(Month == '9'){
            NoofDays = 30;
        }  Else IF(Month == '10'){
            NoofDays = 31;
        }  Else IF(Month == '11'){
            NoofDays = 30;
        }  Else IF(Month == '12'){
            NoofDays = 31;
        } 
        
        return NoofDays;
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
    
    /*public static void sortList(List<APACCallSummary> items, APACCallSummary sortField, String order){


       List<APACCallSummary> resultList = new List<APACCallSummary>();
   
        //Create a map that can be used for sorting 
       Map<object, List<APACCallSummary>> objectMap = new Map<object, List<APACCallSummary>>();
           
       for(APACCallSummary ob : items){
                if(objectMap.get(ob.get(sortField)) == null){  // For non Sobject use obj.ProperyName
                    objectMap.put(ob.get(sortField), new List<APACCallSummary>()); 
                }
                objectMap.get(ob.get(sortField)).add(ob);
        }       
        //Sort the keys
        List<object> keys = new List<object>(objectMap.keySet());
        keys.sort();
       
        for(object key : keys){ 
            resultList.addAll(objectMap.get(key)); 
        }
       
        //Apply the sorted values to the source list
        items.clear();
        if(order.toLowerCase() == 'asc'){
            for(APACCallSummary ob : resultList){
                items.add(ob); 
            }
        }else if(order.toLowerCase() == 'desc'){
            for(integer i = resultList.size()-1; i >= 0; i--){
                items.add(resultList[i]);  
            }
        }
    }*/
    /* Functionality : This method intialize a map mapMonthName for each Month in the year with its respective month number
     * After that it rearrange the month with the year based on below logic, to further identidy the months for which data
     * is represented more specifically.
     * Author : Neha Jain, 26th Feb, 2014
    */
    private void getLastMonthsName(){
        system.debug('***intiate months');
        //consider todays date as reference
        Date dateToday = Date.Today();
        //fetch todays month for current month
        integer todaysMonth = dateToday.month();
        //fetch last eleven months date to fetch month for last 11 months
        date prevTwelveMonthsDate = dateToday.addMonths(-11);
        //Last 11th Month to be considered
        integer twelvithMonth = prevTwelveMonthsDate.month();
        system.debug('****todaysMonth ' + string.valueOf(todaysMonth) + '***prevMonths ' + string.valueOf(twelvithMonth));
        
        mapMonthName = new Map<Integer,String>();
        mapMonthName.put(1, 'Jan');
        mapMonthName.put(2, 'Feb');
        mapMonthName.put(3, 'Mar');
        mapMonthName.put(4, 'Apr');
        mapMonthName.put(5, 'May');
        mapMonthName.put(6, 'Jun');
        mapMonthName.put(7, 'Jul');
        mapMonthName.put(8, 'Aug');
        mapMonthName.put(9, 'Sep');
        mapMonthName.put(10, 'Oct');
        mapMonthName.put(11, 'Nov');
        mapMonthName.put(12, 'Dec');
        
        monthNames = new List<String>();
        
        integer monthCount = twelvithMonth;
        
        //As we have to show data from the last previous months, evaluate last year by today's year.
        integer intYear = Date.Today().year() -1 ;
        
        string yearNum = string.valueOf(intYear) ;
        // As a year have only 12 months, so considering that : Loop will iterate 12 times, and as the monthcount 
        // i.e month number will be 12, year will change to get a better mapping. 
        while(monthNames.size() != 12){
        
             if(monthCount > 12){
                monthCount = 1;
                intYear = intYear + 1; 
                yearNum = string.valueOf(intYear) ;
             }
          
            monthNames.add(mapMonthName.get(monthCount) + '-' + yearNum);
            mapMonthName.put(monthCount, mapMonthName.get(monthCount) + '-' + yearNum);
            // increase the month count with each iterate.
            monthCount = monthCount + 1;
        }
        
    }
    
    Public Class APACCallSummary{
        Public String APID {get; set;}
        Public String strName {get; set;}
        Public String strRegion {get; set;}
        Public String strCity {get; set;}
        Public String strCountry {get; set;}
         Public String strManagerName {get; set;}
        Public Decimal DecAvgJan {get; set;}
        Public Decimal DecAvgFeb {get; set;}
        Public Decimal DecAvgMar {get; set;}
        Public Decimal DecAvgApr {get; set;}
        Public Decimal DecAvgMay {get; set;}
        Public Decimal DecAvgJune {get; set;}
        Public Decimal DecAvgJuly {get; set;}
        Public Decimal DecAvgAug {get; set;}
        Public Decimal DecAvgSep {get; set;}
        Public Decimal DecAvgOct {get; set;}
        Public Decimal DecAvgNov {get; set;}
        Public Decimal DecAvgDec {get; set;}
        
       
        Public Decimal DecAvgJanColTotal {get; set;}
        Public Decimal DecAvgFebColTotal {get; set;}
        Public Decimal DecAvgMarColTotal {get; set;}
        Public Decimal DecAvgAprcolTotal {get; set;}
        Public Decimal DecAvgMayColTotal {get; set;}
        Public Decimal DecAvgJuneColTotal {get; set;}
        Public Decimal DecAvgJulyColTotal {get; set;}
        Public Decimal DecAvgAugColTotal {get; set;}
        Public Decimal DecAvgSepColTotal {get; set;}
        Public Decimal DecAvgOctColTotal {get; set;}
        Public Decimal DecAvgNovColTotal {get; set;}
        Public Decimal DecAvgDecColTotal {get; set;}
        
        Public Decimal DecAvgRowTotal {get; set;}
        Public Decimal DecAvgMonthRowTotal {get; set;}
        
        Public Boolean blnAvgJan {get; set;}
        Public Boolean blnAvgFeb {get; set;}
        Public Boolean blnAvgMar {get; set;}
        Public Boolean blnAvgApr {get; set;}        
        Public Boolean blnAvgMay {get; set;}
        Public Boolean blnAvgJune {get; set;}
        Public Boolean blnAvgJuly {get; set;}
        Public Boolean blnAvgAug {get; set;}
        Public Boolean blnAvgSep {get; set;}
        Public Boolean blnAvgOct {get; set;}
        Public Boolean blnAvgNov {get; set;}
        Public Boolean blnAvgDec {get; set;}
        
        Public Date strDate {get; set;}
        Public String strTotalRegion {get; set;}
        
        //Neha Jain, 26th Feb, 2014 : Maps for having values for showing 12 months data from next month previous year to current month this year
        public Map<String,Decimal> mapMonthAvgTotalValues{get;set;}
        public Map<String,Decimal> mapMonthAvgValues{get;set;}
        
        //Neha Jain, 26th Feb, 2014 : Added to add an extra current month for previous year
        Public Decimal DecAvgCurrentMonthPY {get; set;}
        
        //Neha Jain, 26th Feb, 2014 : Added to add an extra current month for total for previous year
        Public Decimal DecAvgCurrentMonthPYColTotal {get; set;}
        
        Public APACCallSummary(Map<Integer,String> mapInnerMonthNames){
            
            APID = null;
            strName = '';
            strRegion = null;
            strDate = null;
            
            blnAvgJan = false;
            blnAvgFeb = false;
            blnAvgMar = false;
            blnAvgApr = false;
            blnAvgMay = false;
            blnAvgJune = false;
            blnAvgJuly = false;
            blnAvgAug = false;
            blnAvgSep = false;
            blnAvgOct = false;
            blnAvgNov = false;
            blnAvgDec = false;
            
            DecAvgJan = 0.00;
            DecAvgFeb = 0.00;
            DecAvgMar = 0.00;
            DecAvgApr = 0.00;
            DecAvgMay = 0.00;
            DecAvgJune = 0.00;
            DecAvgJuly = 0.00;
            DecAvgAug = 0.00;
            DecAvgSep = 0.00;
            DecAvgOct = 0.00;
            DecAvgNov = 0.00;
            DecAvgDec = 0.00;
            
            DecAvgRowTotal = 0.00;
            DecAvgMonthRowTotal = 0.00;
            
            DecAvgJanColTotal = 0.00; 
            DecAvgFebColTotal = 0.00; 
            DecAvgMarColTotal = 0.00; 
            DecAvgAprColTotal = 0.00; 
            DecAvgMayColTotal = 0.00; 
            DecAvgJuneColTotal = 0.00; 
            DecAvgJulyColTotal = 0.00; 
            DecAvgAugColTotal = 0.00; 
            DecAvgSepColTotal = 0.00; 
            DecAvgOctColTotal = 0.00; 
            DecAvgNovColTotal = 0.00; 
            DecAvgDecColTotal = 0.00; 
            
            DecAvgCurrentMonthPY = 0.0;
            DecAvgCurrentMonthPYColTotal = 0.0;
            
             //Intialize Month average values wrt to month map created in outer class.
            mapMonthAvgValues = new Map<String,Decimal>();
            mapMonthAvgTotalValues = new Map<String,Decimal>();
            
            for(string strMonthName : mapInnerMonthNames.values()){
                mapMonthAvgValues.put(strMonthName, 0.0);
                mapMonthAvgTotalValues.put(strMonthName, 0.0); 
            }
            
            
        }
    }

}