/**
* 
* This is the controller for the call planning page - Weekly call plan for KOREA SOLTA alone
*
* Author              |Author-Email                                       |Date        |Comment
* ------------------- |---------------------------------------------------|------------|----------------------------------------------------
* Venkateswara Reddy.C|venkateswara.reddy2@bausch.com                      13.Nov.2015   Firsr draft     
* Test Class: TEst_CtrlCallPlanning_KOR_SOLTA    
*/
public class CtrlCallPlanning_KOR_SOLTA
{
    
    /*************************************************************************
    ** Variable Declerations
    *************************************************************************/
    private  final Integer intQuarterDays = 13 * 7;
    
    //to populate the callPlan record information along with the detail  incase of new,edit or clone
    public CallPlan objCurrentCallPlan { get; set;}
    public CallPlan objCurrentCallPlandisplay { get; set;}
    // current call plan record
    public Call_Plan__c  objCallPlan{ get; set;}
    // clonecd call plan record
    public Call_Plan__c  objClonedCallPlan = new Call_Plan__c();
    //instance of call plan detail records
    public Call_Plan_Detail__c objCallPlanDetail;
    //instance of a user
    public User objUser { get; set;}
    
    //start date of a RBD month
    public date datMonthStartDate ;
    //end date of a RBD month
    public date datMonthEndDate ;
    //start date of a RBD month for clone case
    public date datClonedWeekStartDate ;
    //end date of a RBD month for clone case
    public date datClonedWeekEndDate;
    
    //start date of a RBD month
    public date datWeekStartDate ;
    //end date of a RBD month
    public date datWeekEndDate ;
    //reference date
    public Date datRefDate;
    
    //Week selected
    public String strWeek { get; set; } 
    public String strDispMonth { get; set; }
    public String strDispYear { get; set; }
    
    public string strMode = '';
    //selected month while cloning
    public String strSelectedMonth{ get; set;}
    //id of the call plan
    public Id idCallPlan ;
    
    public Id idUser;
    public UserRole objUserRole;
    public User objManager;
    public User objTypeOfUser;
    
    //temp list of dates            
    public List<Date> list_tempDates ;
    //list of user accounts
    public List<Id> list_UserAccounts;
    // list of accounts pertainign to call plan detail
    public List<Call_Plan_Detail__c> list_accountsCallPlanDetail;
    //list of account team member accounts
    public List<AccountTeamMember> list_accountsForOwner;
    // list of account profiles
    public List<Account_Profile__c> list_userAccountProfiles;
    //list of call plan detail records
    public List<Call_Plan_Detail__c> list_callPlanDetailRecords ;   
    // custom list of custom class clann plan detail    
    public List<CallPlanDetail> list_callPlanDetail;
    // custom list of custom class clann plan detail class A
    public List<CallPlanDetail> list_tempCallPlanDetailClassA = new List<CallPlanDetail>();
    // custom list of custom class clann plan detail class B
    public List<CallPlanDetail> list_tempCallPlanDetailClassB = new List<CallPlanDetail>();
    // custom list of custom class clann plan detail class C
    public List<CallPlanDetail> list_tempCallPlanDetailClassC = new List<CallPlanDetail>();
    // custom list of custom class clann plan detail class D
    public List<CallPlanDetail> list_tempCallPlanDetailClassD = new List<CallPlanDetail>();
    // custom list of custom class clann plan detail class N
    public List<CallPlanDetail> list_tempCallPlanDetailClassN = new List<CallPlanDetail>();
    // custom list of custom class clann plan detail class Z
    public List<CallPlanDetail> list_tempCallPlanDetailClassZ = new List<CallPlanDetail>();
    // list of call plan detail records to be inserted
    public List<CallPlanDetail> list_forInsert = new List<CallPlanDetail>();
    //list of custom class days
    public List<days> list_tempDays = new List<days>();
    //list of backup dates for the cloned case
    public List<Date> list_backupDates;
    // list of call plan detail records to be inserted
    public List<Call_Plan_Detail__c> list_callPlanDetailInsert;
    
    // Map for class A type Accounts
    public Map<Id,string> map_ATypeAccountId_ATypeAccountName;
    // Map for class B type Accounts
    public Map<Id,string> map_BTypeAccountId_BTypeAccountName;
    // Map for class C type Accounts
    public Map<Id,string> map_CTypeAccountId_CTypeAccountName;
    // Map for class D type Accounts
    public Map<Id,string> map_DTypeAccountId_DTypeAccountName;
    // Map for class N type Accounts
    public Map<Id,string> map_NTypeAccountId_NTypeAccountName;
     // Map for class Z type Accounts
    public Map<Id,string> map_ZTypeAccountId_ZTypeAccountName;
    //map of account ids and list of call plan detail records
    public Map<Id,List<Call_Plan_Detail__c>> map_AccountId_listOfCallPlanDetailRecords ;
    //map of account ids and map of date to call plan detail record
    public Map<Id,Map<Date,Call_Plan_Detail__c>> map_AccountId_MapOfDateAndCallPlanDetail;
    // map of date to call plan detail record
    public Map<Date,Call_Plan_Detail__c> map_Date_CallPlanDetail;
    // constants for obatining month nos
    public Map<String,Integer> MAP_MONTHNAME_MONTHNO = new Map<String,Integer>();
    public Map<Integer,String> MAP_MONTHNO_MONTHNAME = new Map<Integer,String>();
    public Map<Integer,Date> MAP_YEAR_YEARSTARTDATE = new Map<Integer,Date>();
  
    public Map<Id,Decimal> map_AccountId_NoOfVisits = new Map<Id,Decimal>();
    public Map<Id,Integer> map_AccountId_VisitCount = new Map<Id,Integer>();
    public Map<Id,Integer> map_AccountId_MaxDays = new Map<Id,Integer>();
    public Map<Id,Date> map_AccountId_LastVisitDate = new Map<Id,Date>();
    public Map<Id, Integer> map_AccountId_MTDCalls = new Map<Id, Integer>();
    
    // boolean for checking if save button pressed
    public Boolean blnisSaveFlag{ get; set;}
    // boolean for checking if submit button pressed
    public Boolean blnisSubmitFlag{ get; set;}
    // boolean for checking if approve button pressed
    public Boolean blnisApproveFlag{ get; set;}
    // boolean for checking if reject button pressed
    public Boolean blnisRejectFlag{ get; set;}
    //checking if clone is required
    public Boolean blnisClone{ get; set;}
    //checking if namager profile
    public Boolean blnisManager { get ;set;}
    //checking to display lower section or not
    public Boolean blnisDisplayCallPlanDetail { get ;set;}
    // chekcing if have to clone more
    public Boolean blnisCloneMore = false;
    // checking id classification exists
    public Boolean blnisNoClassification;
    // disableing the input checkboxes
    public Boolean blnisDisable { get; set;}
    // for sgowing the go button
    public Boolean blnisShowGo { get; set;}
    // for checking if exception occurs
    public Boolean blnisException = false;
    //for displaying approve/reject buttons
    public Boolean bShowApprovalFunctions{get; private set;}
    //for diaplaying save and submit buttons
    public Boolean blnShowSave { get; set;}
    //for display cancel button
    public Boolean blnError{get;set;}
    //for Korea User
    public Boolean blnKoruser{get;set;}
    
    // Done by Sandeep Kumar Gaddam on 05 Sept 2012    
    public map<string,string> legid{get;set;}
    public map<string,string> Areanameid{get;set;}
    public map<string,string> Accountnameid{get;set;} 
    public map<string,string> AccountSegmtionid{set;get;}
    public string getarea{get;set;}
    public string getAcct{get;set;}
    public string getClass{get;set;}
    public string getSegm{set;get;}    
    public boolean issearch{get;set;}
    public set<string> areanames;
    public set<string> accnames;
    public set<String> accSegm;

    /*************************************************************************
    ** Custom Classes : for storing callplan level information
    *************************************************************************/
    public class CallPlan{
        public Call_Plan__c objCallPln { get; set;}
        public List<CallPlanDetail> list_callPlanDetailClassA{ get; set;}
        public List<CallPlanDetail> list_callPlanDetailClassB{ get; set;}
        public List<CallPlanDetail> list_callPlanDetailClassC{ get; set;}
        public List<CallPlanDetail> list_callPlanDetailClassD{ get; set;}
        public List<CallPlanDetail> list_callPlanDetailClassN{ get; set;}
        public List<CallPlanDetail> list_callPlanDetailClassZ{ get; set;}
        public List<Date> list_RBDmonthDates{ get; set;}
        
        public CallPlan(){
            objCallPln = new Call_Plan__c();
            list_callPlanDetailClassA = new List<CallPlanDetail>();
            list_callPlanDetailClassB = new List<CallPlanDetail>();
            list_callPlanDetailClassC = new List<CallPlanDetail>();
            list_callPlanDetailClassD = new List<CallPlanDetail>();
            list_callPlanDetailClassN = new List<CallPlanDetail>();
            list_callPlanDetailClassZ = new List<CallPlanDetail>();
            list_RBDmonthDates = new List<Date>();
        }
    }
    
    
    
    /*************************************************************************
    ** Custom Classes : for storing callplan Detail level information
    *************************************************************************/
    public class CallPlanDetail{
        public String strStoreName{ get; set;}
        public string legacyid{get;set;}    
        public string Areaname{get;set;}   
        public string SegName{set;get;} 
        public Id idAccount { get; set;}
        public String strClassification { get; set;}
        public List<days> list_objDays{ get; set;} 
        public Physician_Visit__c objStoreVisit { get; set;}
        public Decimal dcmNoOfVisitsPerMonth { get; set;}
        public Boolean blnHighLightVisitsColumn { get; set;}
        public Boolean blnHighLightStoreInfoColumn { get; set;}
        public Integer intMTDCalls { get; set; }
        
        public CallPlanDetail(){
            strStoreName = '';
            legacyid = '';
            Areaname = '';
            SegName = '';
            list_objDays = new List<days>();
            strClassification = '';
            objStoreVisit = new Physician_Visit__c(); 
            blnHighLightVisitsColumn = blnHighLightStoreInfoColumn  = false;    
            intMTDCalls = 0;
        }
    }
    
    CallPlanDetail cpd = new CallPlanDetail();
    
    /*************************************************************************
    ** Custom Classes : for storing days checked 
    *************************************************************************/
    public class days{
        public boolean blnisbSelected { get; set;}
        
        public days(){
            blnisbSelected = false;
        }
    }
    
    days dd = new days();
    
    /*************************************************************************
    ** Constructor
    *************************************************************************/
    public CtrlCallPlanning_KOR_SOLTA(){
          
         areanames = new set<string>();
         accnames = new set<string>();  
         accSegm = new set<string>(); 
         MAP_MONTHNAME_MONTHNO.put('Jan',1);
        MAP_MONTHNAME_MONTHNO.put('Feb',2);
        MAP_MONTHNAME_MONTHNO.put('Mar',3);
        MAP_MONTHNAME_MONTHNO.put('Apr',4);
        MAP_MONTHNAME_MONTHNO.put('May',5);
        MAP_MONTHNAME_MONTHNO.put('Jun',6);
        MAP_MONTHNAME_MONTHNO.put('Jul',7);
        MAP_MONTHNAME_MONTHNO.put('Aug',8);
        MAP_MONTHNAME_MONTHNO.put('Sep',9);
        MAP_MONTHNAME_MONTHNO.put('Oct',10);
        MAP_MONTHNAME_MONTHNO.put('Nov',11);
        MAP_MONTHNAME_MONTHNO.put('Dec',12);
        
        // making map for obtaining month from month no.
        MAP_MONTHNO_MONTHNAME.put(1,'Jan');
        MAP_MONTHNO_MONTHNAME.put(2,'Feb');
        MAP_MONTHNO_MONTHNAME.put(3,'Mar');
        MAP_MONTHNO_MONTHNAME.put(4,'Apr');
        MAP_MONTHNO_MONTHNAME.put(5,'May');
        MAP_MONTHNO_MONTHNAME.put(6,'Jun');
        MAP_MONTHNO_MONTHNAME.put(7,'Jul');
        MAP_MONTHNO_MONTHNAME.put(8,'Aug');
        MAP_MONTHNO_MONTHNAME.put(9,'Sep');
        MAP_MONTHNO_MONTHNAME.put(10,'Oct');
        MAP_MONTHNO_MONTHNAME.put(11,'Nov');
        MAP_MONTHNO_MONTHNAME.put(12,'Dec');
        

        // initilaizing values
        blnisSaveFlag = false;
        blnisSubmitFlag= false;
        blnisApproveFlag= false;
        blnisRejectFlag = false;
        blnisManager = false;
        blnisDisable = false;
        blnisShowGo = true;
        blnisDisplayCallPlanDetail = false;
        bShowApprovalFunctions = false;  
        blnShowSave = false;
        blnError = false;
        objCurrentCallPlan = new CallPlan();       
        //getting the parameters from the url
        idCallPlan =  ApexPages.currentPage().getParameters().get('id');
        
        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@ idCallPlan--------------------->'+ idCallPlan);
        strMode =  ApexPages.currentPage().getParameters().get('mode');
     
        system.debug('@@@@@@@@@@@@@@@@@@@STR MODE-------------->'+strMode );
        //getting user information
        String strTypeOfUserId = UserInfo.getUserId();
        objTypeOfUser = [Select Id,name,UserRoleId, ManagerId from User where id =:strTypeOfUserId ];       
        
        objUser = null;
        
        if(objTypeOfUser.UserRoleId!=null)
            objUserRole = [Select Id,name from userRole where id=:objTypeOfUser.UserRoleId];       
       
               
        Profile objProfile = [SELECT Id, Name FROM Profile WHERE Id = : userInfo.getProfileId() LIMIT 1];
            
     
      if(objProfile.Name != null && objProfile.Name.contains(Label.manager_label)){
            blnisManager = true;
            system.debug('@@@@@@@YES AM THE MANAGER------->'+blnisManager );
            }
        else{
            blnisManager = false;
         system.debug('@@@@@@@NO AM NOT  MANAGER------->'+blnisManager );  
            }
       
        
        //checking if clone is required or not
        if(ApexPages.currentPage().getParameters().get('clone') == '1')
           { blnisClone = true;
            system.debug('@@@@@@@@@@@@@@@@@@@@NO ACCOUNT NAME-------------------->'+blnisClone);}
        else{
            blnisClone = false;
            system.debug('@@@@@@@@@@@@@@@@@@@@ ACCOUNT NAME THERE-------------------->'+blnisClone);  
        map_ATypeAccountId_ATypeAccountName = new Map<Id,string>();
        map_BTypeAccountId_BTypeAccountName = new Map<Id,string>();
        map_CTypeAccountId_CTypeAccountName = new Map<Id,string>();
        map_DTypeAccountId_DTypeAccountName = new Map<Id,string>();
        map_NTypeAccountId_NTypeAccountName = new Map<Id,string>();
        map_ZTypeAccountId_ZTypeAccountName = new Map<Id,string>();}
        
        // if the call plan id is nto null query the given call plan
        if(idCallPlan !=null)
        {
            //query the particular call plan record
            objCallPlan = [Select Id,
                                    name,
                                    Year__c,
                                    Status__c,
                                    Month__c,
                                    Manager_Comments__c,
                                    Executive_Comments__c,
                                    Start_Date__c,
                                    End_Date__c,
                                    Manager_s_Email_ID__c,
                                    Week__c,
                                    Current_Status__c, 
                                    OwnerId From Call_Plan__c where id =:idCallPlan];
                                    
            //querying all the accounteams to which this sales executive is a member
            // if teh record exists query the related information
            if(objCallPlan !=null){
                
                if(objCallPlan.OwnerId == UserInfo.getUserId()){
                    List<User> managers = new List<User>();
                    managers = [Select Id, Name, Email From User where Id =: objTypeOfUser.ManagerId limit 1];
                    if(managers!=NULL && !managers.isEmpty())
                     objManager = managers[0];
                    else{
                        addErrorMessage(Label.APASU_Manager_Is_Not_Available);
                        blnError = true;                
                    }
                }
                //Return the execution if the manager is not available for the current user
                if(blnError)
                    return;
                    
                if(objCallPlan.status__c!=null)
                {
                    
                    if(blnisManager && (objCallPlan.OwnerId != UserInfo.getUserId())){
                        blnisDisable = true;
                        system.debug('@@@@@@@@blnisDisable --1st cond---->'+blnisDisable );
                        }
                    else if((objCallPlan.status__c !='Draft' && objCallPlan.status__c !='Rejected') || ((objCallPlan.status__c =='Approved') || (objCallPlan.status__c =='Submitted')) && (!blnisClone))
                    {
                        blnisDisable = true;
                         system.debug('@@@@@@@@blnisDisable --2nd else if cond---->'+blnisDisable );
                    }
                    //To show approval and reject buttons
                    if(blnisManager && objCallPlan.status__c=='Submitted' && (objCallPlan.OwnerId != UserInfo.getUserId()))
                        bShowApprovalFunctions = true;
                    //if(!blnisManager && (objCallPlan.status__c=='Draft'))
                    if((objCallPlan.status__c=='Draft' || objCallPlan.status__c=='Rejected')&& (objCallPlan.OwnerId == UserInfo.getUserId()))
                        blnShowSave = true;
                }
                
                
                // user pertaining to that record
                objUser = [Select Id,Name,userRoleId,UserRole.Name,email from User where id = :objCallPlan.OwnerId];
                // Populating RBD start dates for different countries 
                createStartDateMap();
                
                
                list_accountsForOwner = [select Id,AccountId,UserId from AccountTeamMember where UserId =:objCallPlan.OwnerId];
                // accounts for that record                  
                if(list_accountsForOwner.size()>0)
                {                    
                    //*********************
                    // getting the start and end dates for previous RBD month
                    Date datPrevStartDate;
                    Date datPrevEndDate;
                    
                    if(objCallPlan.Start_Date__c !=null)
                    {                        
                        datRefDate = objCallPlan.Start_Date__c;
                        
                        if(datRefDate!=null)
                            datPrevStartDate = Date.newInstance((objCallPlan.Start_Date__c).year(),(objCallPlan.Start_Date__c).month(),1);
                            
                        datPrevEndDate = datPrevStartDate.addDays(Date.daysInMonth((objCallPlan.Start_Date__c).year(),(objCallPlan.Start_Date__c).month()));
                    } 
                    System.debug('$$$$$$$$$ datPrevStartDate = ' + datPrevStartDate);
                    System.debug('$$$$$$$$$ datPrevEndDate = ' + datPrevEndDate);
                    //*************************
                    
                    
                    // getting the start and end dates for a particular call plan
                    datWeekStartDate = objCallPlan.Start_Date__c;
                    datWeekEndDate = objCallPlan.End_Date__c;
                    
                    strWeek = ClsSingleMultiUtility.getDisplayWeekInDifferentFormat(objCallPlan.Start_Date__c, objCallPlan.End_Date__c, ClsSingleMultiUtility.getWeekFormat(UserInfo.getUserRoleId())); //12.Jan.2010
                    
                    //To display the month in the top part of call plan page
                                      
                    strDispMonth = MAP_MONTHNO_MONTHNAME.get(objCallPlan.Start_Date__c.month());
                    System.debug('$$$$$$$$$ strDispMonth = ' + strDispMonth);
                    
                    //To display the year in the top part of the call plan page
                    if(objCallPlan.Start_Date__c.year() == objCallPlan.End_Date__c.year())
                        strDispYear = String.valueOf(objCallPlan.Start_Date__c.year());
                    else
                        strDispYear = String.valueOf(objCallPlan.Start_Date__c.year()) + ' - ' + String.valueOf(objCallPlan.End_Date__c.year());
                    
                    //creating a list of those account Ids
                    list_UserAccounts = new List<Id>();
                    for(AccountTeamMember accMem : list_accountsForOwner){
                        list_UserAccounts.add(accMem.AccountId);
                    }
                        
                    // querying the profiles for the strClassification information 
                    list_userAccountProfiles = new List<Account_Profile__c>();
                  
                    list_userAccountProfiles = [Select Id,
                                                DASRX_ABC_Classification__c,
                                                Account__c,Area__c,
                                                Account__r.SL_Code__c,
                                                No_Of_Visits_Per_Month__c,
                                                Maximum_days_from_last_visit__c,
                                                Segmentation__c,
                                                Account__r.name From Account_Profile__c where Account__c in : list_UserAccounts AND Account__c != null];
                 
                     legid = new map<string,string>();
                     Areanameid = new map<string,string>();
                     Accountnameid = new map<string,string>();  
                     AccountSegmtionid = new map<string,string>();                         
                    // Constructing map of Account Id to Store Info
                    for(Account_Profile__c accProfile : list_userAccountProfiles)
                    {
                       
                       legid.put(accProfile.Account__c,accProfile.Account__r.SL_Code__c);
                                         
                        if(accProfile.Area__c!=null)
                        {
                            areanames.add(accProfile.Area__c);
                            Areanameid.put(accProfile.Account__c,accProfile.Area__c);      
                        }
                        // Change the account Id to name / legacy ID
                        if(accProfile.Account__r.name!=null)
                        {
                            accnames.add(accProfile.Account__r.name);
                            Accountnameid.put(accProfile.Account__c,accProfile.Account__r.name);      
                        }
                   //display the segmentation list start
                        if(accProfile.Segmentation__c != Null){
                        accSegm.add(accProfile.Segmentation__c);
                       AccountSegmtionid.put(accProfile.Account__c,accProfile.Segmentation__c);
                        }
                   //display the segmentation list end     
                        if(accProfile.No_Of_Visits_Per_Month__c != null)
                            map_AccountId_NoOfVisits.put(accProfile.Account__c,accProfile.No_Of_Visits_Per_Month__c);
                        
                        if(accProfile.Maximum_days_from_last_visit__c != null)
                            map_AccountId_MaxDays.put(accProfile.Account__c,Math.round(accProfile.Maximum_days_from_last_visit__c));
                    }
                    system.debug('--------areanames-----'+areanames+'-----Areanameid---'+Areanameid+'Segmentation list-------->'+AccountSegmtionid);
                 //   System.Debug('<<<<<<<<< map_AccountId_StoreInfo = ' + map_AccountId_StoreInfo);
                    
                    for(Physician_Visit__c objVisit : [SELECT Id,Hospital__c,Visit_Date__c FROM Physician_Visit__c WHERE //Hospital__cIN :map_AccountId_StoreInfo.keySet() AND
                                                     Status__c = 'Completed' AND Visit_Date__c >= :datPrevStartDate AND Visit_Date__c < :datPrevEndDate ORDER BY Visit_Date__c])
                    {
                        if(map_AccountId_VisitCount.containsKey(objVisit.Hospital__c))
                            map_AccountId_VisitCount.put(objVisit.Hospital__c,map_AccountId_VisitCount.get(objVisit.Hospital__c) + 1);
                        
                        else
                            map_AccountId_VisitCount.put(objVisit.Hospital__c,1);
                            
                        map_AccountId_LastVisitDate.put(objVisit.Hospital__c,objVisit.Visit_Date__c);
                    }
                    
                    //Map of store Id and the number of MTD completed calls for that store
                    Date dtMonthStart = Date.Today().toStartOfMonth();
                    
                    for(Physician_Visit__c objVisit : [SELECT Id, Hospital__c, Name, Start_Time__c, Status__c, End_Time__c, Visit_Date__c  
                                                    FROM Physician_Visit__c 
                                                  //skip store info  WHERE Hospital__c IN :map_AccountId_StoreInfo.keySet() AND
                                                         where Status__c = 'Completed' AND
                                                          Visit_Date__c >= : dtMonthStart AND
                                                          Visit_Date__c <= : Date.Today()])
                    {                       
                        if(map_AccountId_MTDCalls.containsKey(objVisit.Hospital__c))
                            map_AccountId_MTDCalls.put(objVisit.Hospital__c,map_AccountId_MTDCalls.get(objVisit.Hospital__c) + 1);
                        
                        else
                            map_AccountId_MTDCalls.put(objVisit.Hospital__c,1);
                    }
                    system.debug('map_AccountId_MTDCalls>>>'+map_AccountId_MTDCalls);
                    
                    if(list_userAccountProfiles.size()>0){
                        
                        // for mapping the strClassification and respectve names of the accounts
                        for(Account_Profile__c accPro :list_userAccountProfiles){
                            if(accPro.DASRX_ABC_Classification__c !=null){
                                if(accPro.DASRX_ABC_Classification__c == 'A'){
                                    map_ATypeAccountId_ATypeAccountName.put(accPro.Account__c,accPro.Account__r.name);
                                    system.debug('@@@@@@@@@@@@@@@@@ACCOUNT NAME---------------->'+map_ATypeAccountId_ATypeAccountName);
                                } else if(accPro.DASRX_ABC_Classification__c == 'B'){
                                    map_BTypeAccountId_BTypeAccountName.put(accPro.Account__c,accPro.Account__r.name);
                                     system.debug('@@@@@@@@@@@@@@@@@ACCOUNT NAME---------------->'+map_ATypeAccountId_ATypeAccountName);
                                } else if(accPro.DASRX_ABC_Classification__c == 'C'){
                                    map_CTypeAccountId_CTypeAccountName.put(accPro.Account__c,accPro.Account__r.name);
                                     system.debug('@@@@@@@@@@@@@@@@@ACCOUNT NAME---------------->'+map_ATypeAccountId_ATypeAccountName);
                                } else if(accPro.DASRX_ABC_Classification__c == 'D'){
                                    map_DTypeAccountId_DTypeAccountName.put(accPro.Account__c,accPro.Account__r.name);
                                     system.debug('@@@@@@@@@@@@@@@@@ACCOUNT NAME---------------->'+map_ATypeAccountId_ATypeAccountName);
                                }else if(accPro.DASRX_ABC_Classification__c == 'N'){
                                    map_NTypeAccountId_NTypeAccountName.put(accPro.Account__c,accPro.Account__r.name);
                                     system.debug('@@@@@@@@@@@@@@@@@ACCOUNT NAME---------------->'+map_ATypeAccountId_ATypeAccountName);
                                }else if(accPro.DASRX_ABC_Classification__c == 'Z'){
                                    map_ZTypeAccountId_ZTypeAccountName.put(accPro.Account__c,accPro.Account__r.name);
                                     system.debug('@@@@@@@@@@@@@@@@@ACCOUNT NAME---------------->'+map_ATypeAccountId_ATypeAccountName);
                                }
                            }
                        }
 
                   
               // for mapping the strClassification and respectve names of the accounts
                      /*  for(Account_Profile__c accPro :list_userAccountProfiles){
                            if(accPro.Segmentation__c!=null){
                                if(accPro.Segmentation__c== 'Tier 1'){
                                    map_ATypeAccountId_ATypeAccountName.put(accPro.Account__c,accPro.Segmentation__c);
                                    system.debug('@@@@@@@@@@@@@@@@@ACCOUNT NAME---------------->'+map_ATypeAccountId_ATypeAccountName);
                                } else if(accPro.Segmentation__c== 'Tier 2'){
                                    map_BTypeAccountId_BTypeAccountName.put(accPro.Account__c,accPro.Segmentation__c);
                                     system.debug('@@@@@@@@@@@@@@@@@ACCOUNT NAME---------------->'+map_ATypeAccountId_ATypeAccountName);
                                } else if(accPro.Segmentation__c== 'Tier 3'){
                                    map_CTypeAccountId_CTypeAccountName.put(accPro.Account__c,accPro.Segmentation__c);
                                     system.debug('@@@@@@@@@@@@@@@@@ACCOUNT NAME---------------->'+map_ATypeAccountId_ATypeAccountName);
                                } else if(accPro.Segmentation__c== 'Tier 4'){
                                    map_DTypeAccountId_DTypeAccountName.put(accPro.Account__c,accPro.Segmentation__c);
                                     system.debug('@@@@@@@@@@@@@@@@@ACCOUNT NAME---------------->'+map_ATypeAccountId_ATypeAccountName);
                                }else if(accPro.Segmentation__c== 'Tier 5'){
                                    map_NTypeAccountId_NTypeAccountName.put(accPro.Account__c,accPro.Segmentation__c);
                                     system.debug('@@@@@@@@@@@@@@@@@ACCOUNT NAME---------------->'+map_ATypeAccountId_ATypeAccountName);
                                }
                            }
                        } */        
                        
                        if(!blnisClone)
                        {
                            createCallPlanRecords();
                            blnisDisplayCallPlanDetail = true;
                            objCurrentCallPlandisplay = objCurrentCallPlan;
                        } 
                        else
                        {
                            blnisDisplayCallPlanDetail = false;
                        }
                        
                    } 
                    else
                    {
                        addErrorMessage(Label.APASU_Account_Profile_Not_Available);
                    }
                } 
                else
                {
                    addErrorMessage(Label.APASU_Rep_Not_Part_Of_Account_Team);
                }
            } 
            else
            {
                addErrorMessage(Label.APASU_No_Call_Plan_Exists);
            }
        }
        else
        {
            addErrorMessage(Label.APASU_No_Call_Plan_Exists);
        }
     }
    // Identify the Korea User
    Public boolean isKoruser(User callplanuser){    
    String ownerRolename = callplanuser.UserRole.Name;
    System.debug('ownerRolename: '+ownerRolename);
   // Boolean blnKORUser = ownerRolename.startsWith('APAC');
    Boolean blnKORUser = ownerRolename.startsWith('KOR SOLTA');
    System.debug('blnKORUser: '+blnKORUser);
    return blnKORUser;
    }
    
     public SelectOption[] getAcct()
    {
        List<SelectOption> list_options = new List<SelectOption>();
        list_options.add(new SelectOption('','All'));
            
  
      if(!accnames.isempty())
       {
           for(string s : accnames)   
           {
               list_options.add(new SelectOption(s,s));
           }  
       }
        return list_options;
    }
    
    public SelectOption[] getArea()
    {
        List<SelectOption> list_options = new List<SelectOption>();
        list_options.add(new SelectOption('','All'));
            
     if(!areanames.isempty())
       {
           for(string s:areanames)   
           {
               list_options.add(new SelectOption(s,s));
           }  
       }
        return list_options;
    }
    
 //method for display the Segmentation.Currently no need of displying the segmentation on VF Page. 
 
   /* public SelectOption[] getSegmtion()
    {
        List<SelectOption> list_options = new List<SelectOption>();
        list_options.add(new SelectOption('','All'));
        System.debug('Korea call paln: ' +blnKoruser); 
       Schema.DescribeFieldResult fieldResult = Account_Profile__c.Segmentation__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple)
       {      if(f.getLabel().contains('Tier')){
          list_options.add(new SelectOption(f.getLabel(), f.getValue()));
          }
       }     
       // No Use of N and Z for korea cvsr
       //if(blnKoruser == True){       
       //list_options.add(new SelectOption('N','N'));
       //list_options.add(new SelectOption('Z','Z'));
       //} 

        return list_options;
    }  */
    
    public SelectOption[] getClassifictn()
    {
        List<SelectOption> list_options = new List<SelectOption>();
        list_options.add(new SelectOption('','All'));
        System.debug('Korea call paln: ' +blnKoruser); 
       Schema.DescribeFieldResult fieldResult = Account_Profile__c.DASRX_ABC_Classification__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple)
       {
          list_options.add(new SelectOption(f.getLabel(), f.getValue()));
       }     
     
        return list_options;
    }
    
    public void go()
    {
         system.debug('------------'+getacct+'---------'+getClass);
        CallPlan new_temp = new CallPlan();        
        
        if(getClass!=null && getClass!='')
        {   
            new_temp.objCallPln = objCurrentCallPlan.objCallPln;
            new_temp.list_RBDmonthDates = objCurrentCallPlan.list_RBDmonthDates;
            list<CallPlanDetail> newlist = new list<CallPlanDetail>();
            CallPlanDetail aval;
            if(getClass=='A')
            {
                
                if(getacct!=null && getacct!='')
                {
                    for(CallPlanDetail cp:objCurrentCallPlan.list_callPlanDetailClassA)
                    {
                    
                        if(cp.strstorename==getacct)
                        {
                 
                            aval = new CallPlanDetail();
                            aval = cp;
                            newlist.add(aval);
                        }
                    }
                    new_temp.list_callPlanDetailClassA = newlist;
                }
                else
                {
                    new_temp.list_callPlanDetailClassA = objCurrentCallPlan.list_callPlanDetailClassA;
                }   
            
            }
            if(getClass=='B')
            {
                
                if(getacct!=null && getacct!='')
                {
                    for(CallPlanDetail cp:objCurrentCallPlan.list_callPlanDetailClassB)
                    {
                    
                        if(cp.strstorename==getacct)
                        {
                            aval = new CallPlanDetail();
                            aval = cp;
                            newlist.add(aval);
                        }
                    }
                    new_temp.list_callPlanDetailClassB = newlist;
                }
                else
                {
                    new_temp.list_callPlanDetailClassB = objCurrentCallPlan.list_callPlanDetailClassB;
                }   
            
            }
            if(getClass=='C')
            {
                
                if(getacct!=null && getacct!='')
                {
                    for(CallPlanDetail cp:objCurrentCallPlan.list_callPlanDetailClassC)
                    {
                        if(cp.strstorename==getacct)
                        {
                            aval = new CallPlanDetail();
                            aval = cp;
                            newlist.add(aval);
                        }
                    }
                    new_temp.list_callPlanDetailClassC = newlist;
                }
                else
                {
                    new_temp.list_callPlanDetailClassC = objCurrentCallPlan.list_callPlanDetailClassC;
                }   
            
            }
            if(getClass=='D')
            {
                
                if(getacct!=null && getacct!='')
                {
                    for(CallPlanDetail cp:objCurrentCallPlan.list_callPlanDetailClassD)
                    {
                        if(cp.strstorename==getacct)
                        {
                            aval = new CallPlanDetail();
                            aval = cp;
                            newlist.add(aval);
                        }
                    }
                    new_temp.list_callPlanDetailClassD = newlist;
                }
                else
                {
                    new_temp.list_callPlanDetailClassD = objCurrentCallPlan.list_callPlanDetailClassD;
                }   
            
            }
                         if(getClass=='N')
            {
                
                if(getacct!=null && getacct!='')
                {
                    for(CallPlanDetail cp:objCurrentCallPlan.list_callPlanDetailClassN)
                    {
                        if(cp.strstorename==getacct)
                        {
                            aval = new CallPlanDetail();
                            aval = cp;
                            newlist.add(aval);
                        }
                    }
                    new_temp.list_callPlanDetailClassN = newlist;
                }
                else
                {
                    new_temp.list_callPlanDetailClassN = objCurrentCallPlan.list_callPlanDetailClassN;
                }   
            
            }
             if(getClass=='Z')
            {
                
                if(getacct!=null && getacct!='')
                {
                    for(CallPlanDetail cp:objCurrentCallPlan.list_callPlanDetailClassZ)
                    {
                        if(cp.strstorename==getacct)
                        {
                            aval = new CallPlanDetail();
                            aval = cp;
                            newlist.add(aval);
                        }
                    }
                    new_temp.list_callPlanDetailClassZ = newlist;
                }
                else
                {
                    new_temp.list_callPlanDetailClassZ = objCurrentCallPlan.list_callPlanDetailClassZ;
                }   
            
            }
            objCurrentCallPlandisplay = new_temp;
        
        }//getclass
        else
        {
            if(getacct!=null && getacct!='')
            {
                new_temp.objCallPln = objCurrentCallPlan.objCallPln;
                new_temp.list_RBDmonthDates = objCurrentCallPlan.list_RBDmonthDates;
                list<CallPlanDetail> newlistA = new list<CallPlanDetail>();
                list<CallPlanDetail> newlistB = new list<CallPlanDetail>();
                list<CallPlanDetail> newlistC = new list<CallPlanDetail>();
                list<CallPlanDetail> newlistD = new list<CallPlanDetail>();
                list<CallPlanDetail> newlistN = new list<CallPlanDetail>();
                list<CallPlanDetail> newlistZ = new list<CallPlanDetail>();
                CallPlanDetail aval;
                    
                    for(CallPlanDetail cp:objCurrentCallPlan.list_callPlanDetailClassA)
                    {
                        if(cp.strstorename==getacct)
                        {
                            aval = new CallPlanDetail();
                            aval = cp;
                            newlistA.add(aval);
                        }
                    }
                    new_temp.list_callPlanDetailClassA = newlistA;
                    for(CallPlanDetail cp:objCurrentCallPlan.list_callPlanDetailClassB)
                    {
                        if(cp.strstorename==getacct)
                        {
                            aval = new CallPlanDetail();
                            aval = cp;
                            newlistB.add(aval);
                        }
                    }
                    new_temp.list_callPlanDetailClassB= newlistB;
                    for(CallPlanDetail cp:objCurrentCallPlan.list_callPlanDetailClassC)
                    {
                        if(cp.strstorename==getacct)
                        {
                            aval = new CallPlanDetail();
                            aval = cp;
                            newlistC.add(aval);
                        }
                    }
                    new_temp.list_callPlanDetailClassC = newlistC;
                    for(CallPlanDetail cp:objCurrentCallPlan.list_callPlanDetailClassD)
                    {
                        if(cp.strstorename==getacct)
                        {
                            aval = new CallPlanDetail();
                            aval = cp;
                            newlistD.add(aval);
                        }
                    }
                    new_temp.list_callPlanDetailClassD = newlistD;
                    for(CallPlanDetail cp:objCurrentCallPlan.list_callPlanDetailClassN)
                    {
                        if(cp.strstorename==getacct)
                        {
                            aval = new CallPlanDetail();
                            aval = cp;
                            newlistN.add(aval);
                        }
                    }
                    new_temp.list_callPlanDetailClassN = newlistN;
                    for(CallPlanDetail cp:objCurrentCallPlan.list_callPlanDetailClassZ)
                    {
                        if(cp.strstorename==getacct)
                        {
                            aval = new CallPlanDetail();
                            aval = cp;
                            newlistZ.add(aval);
                        }
                    }
                    new_temp.list_callPlanDetailClassZ = newlistZ;
                objCurrentCallPlandisplay = new_temp;
            }                                 
            else
            objCurrentCallPlandisplay = objCurrentCallPlan;
          
        }  //getArea  
        
          
    }//method
    public void clearAll()
    {
        getarea = '';
        getClass = '';  
        getSegm = '';
        getAcct = '';
        objCurrentCallPlandisplay = objCurrentCallPlan;
       // init();      
        
    }
    
    /*************************************************************************
    ** Code End 
    *************************************************************************/
    /*************************************************************************
    ** Button Action Methods for the Go button
    *************************************************************************/
    
    public PageReference doCloneAfterChoosingMonth(){
        //creating cloned records
        objClonedCallPlan = new Call_Plan__c();
        objClonedCallPlan.Start_Date__c = objCallPlan.Start_Date__c;
        objClonedCallPlan.End_Date__c= objCallPlan.End_Date__c;
        objClonedCallPlan.Month__c = MAP_MONTHNO_MONTHNAME.get(objCallPlan.Start_Date__c.month());
        objClonedCallPlan.Status__c = 'Draft';
        objClonedCallPlan.Manager_Comments__c = objCallPlan.Manager_Comments__c;
        objClonedCallPlan.Executive_Comments__c = objCallPlan.Executive_Comments__c;
        Date todayDate = Date.today();
        objClonedCallPlan.Year__c = String.valueof(objCallPlan.Start_Date__c.year());
        insert objClonedCallPlan;
        blnisDisplayCallPlanDetail = true;
        createCallPlanRecords();
        
       
        return null;
    }
    
    /*************************************************************************
    ** Button Action Methods for the Save|Approve|Reject|Submit button
    *************************************************************************/
    public PageReference save(){
        // for saving teh selected information
        if(objCurrentCallPlan.objCallPln!=null){
            // the case to show error and not do save
            if(((objCurrentCallPlan.objCallPln.Status__c == 'Submitted') && (!blnisManager) )&& (!blnisClone)){
                addErrorMessage(Label.APASU_Call_Plan_Saved);
                return null; 
            } else{
                // try inserting records for different cases of button pressed
                try{
                    // for save
                    if(blnisSaveFlag){
                        objCurrentCallPlan.objCallPln.Month__c = MAP_MONTHNO_MONTHNAME.get((objCallPlan.Start_Date__c).month());
                        objCurrentCallPlan.objCallPln.Year__c = String.valueOf((objCallPlan.Start_Date__c).year());
                        objCurrentCallPlan.objCallPln.Manager_s_Email_ID__c= objManager.Email; 
                        objCurrentCallPlan.objCallPln.Week__c = strWeek;
                        update objCurrentCallPlan.objCallPln;
                    } else if(blnisSubmitFlag){
                        objCurrentCallPlan.objCallPln.Month__c = MAP_MONTHNO_MONTHNAME.get((objCallPlan.Start_Date__c).month());
                        objCurrentCallPlan.objCallPln.Year__c = String.valueOf((objCallPlan.Start_Date__c).year());
                        objCurrentCallPlan.objCallPln.Manager_s_Email_ID__c= objManager.Email; 
                        objCurrentCallPlan.objCallPln.status__c = 'Submitted';
                        objCurrentCallPlan.objCallPln.Week__c = strWeek;
                        system.debug('objCurrentCallPlan.objCallPln.Manager_Email_ID__c>>'+objCurrentCallPlan.objCallPln.Manager_s_Email_ID__c);
                        update objCurrentCallPlan.objCallPln;
                    } else if(blnisApproveFlag){
                        ClsSingleMultiUtility.blnIsUpdateFromApproveReject = true;                         
                        objCurrentCallPlan.objCallPln.status__c = 'Approved';
                        update objCurrentCallPlan.objCallPln;
                    } else if(blnisRejectFlag){
                        
                        if(objCurrentCallPlan.objCallPln.Manager_Comments__c == NULL || objCurrentCallPlan.objCallPln.Manager_Comments__c == ''){
                            addErrorMessage('Manager Comments is mandatory for rejection.');
                            return NULL;
                        }
                        ClsSingleMultiUtility.blnIsUpdateFromApproveReject = true;                        
                        objCurrentCallPlan.objCallPln.status__c = 'Rejected'; 
                        objCurrentCallPlan.objCallPln.IsRejected__c = true;
                        update objCurrentCallPlan.objCallPln;
                    }
                } catch(Exception E){
                
                    //catching exception
                    blnisException = true;
                    String strError = '';
                    strError += E;
                    addErrorMessage(strError);
                    
                }
                //inserting in case no exception
                if(!blnisException){
                    list_forInsert = new List<CallPlanDetail>();
                    for(CallPlanDetail cpd :objCurrentCallPlan.list_callPlanDetailClassA){
                        list_forInsert.add(cpd);
                    }
                    for(CallPlanDetail cpd :objCurrentCallPlan.list_callPlanDetailClassB){
                        list_forInsert.add(cpd);
                    }
                    for(CallPlanDetail cpd :objCurrentCallPlan.list_callPlanDetailClassC){
                        list_forInsert.add(cpd);
                    }
                    for(CallPlanDetail cpd :objCurrentCallPlan.list_callPlanDetailClassD){
                        list_forInsert.add(cpd);
                    }
                    for(CallPlanDetail cpd :objCurrentCallPlan.list_callPlanDetailClassN){
                        list_forInsert.add(cpd);
                    }
                    for(CallPlanDetail cpd :objCurrentCallPlan.list_callPlanDetailClassZ){
                        list_forInsert.add(cpd);
                    }
                    if(list_forInsert.size() >0){
                        list_callPlanDetailInsert = new List<Call_Plan_Detail__c>();
                        for(CallPlanDetail cpd: list_forInsert){
                            Integer intCount = 0;
                            for(days dd : cpd.list_objDays){
                                if(dd.blnisbSelected){
                                    objCallPlanDetail = new Call_Plan_Detail__c();
                                    objCallPlanDetail.Account__c = cpd.idAccount;
                                    if(blnisClone){
                                        objCallPlanDetail.Call_Plan__c = objClonedCallPlan.Id;
                                        objCallPlanDetail.Date__c = datClonedWeekStartDate.addDays(intCount);
                                    } else{
                                        objCallPlanDetail.Call_Plan__c = idCallPlan;
                                        objCallPlanDetail.Date__c = datWeekStartDate.addDays(intCount);
                                    }
                                    list_callPlanDetailInsert.add(objCallPlanDetail);
                                }
                                intCount++;
                            }
                            
                        }
                        // deleting old records and inserting new ones
                        if(list_callPlanDetailInsert.size() > 0){
                            //delete old exsisting records
                            if(list_callPlanDetailRecords.size() >0 && (!blnisClone))
                                delete list_callPlanDetailRecords;
                                
                            
                            //insert new records
                            insert list_callPlanDetailInsert;
                            
                        }
                    }
                    blnisSaveFlag = false;
                    blnisSubmitFlag= false;
                    blnisApproveFlag= false;
                    blnisRejectFlag = false;
                    PageReference pg;
                    if(blnisClone){
                        if(objClonedCallPlan.Id !=null)
                            pg = new pageReference('/' + objClonedCallPlan.Id);
                    } else{
                        pg = new pageReference('/' + idCallPlan);
                    }
                    return pg;
                } else{
                    blnisSaveFlag = false;
                    blnisSubmitFlag= false;
                    blnisApproveFlag= false;
                    blnisRejectFlag = false;
                    return null;
                }
            }
                       
        } else{
            return null;
        }
    }
    
    /*************************************************************************
    ** Method call for creating required records
    *************************************************************************/
    public void createCallPlanRecords()
    {
        //initializing call plan record
        objCurrentCallPlan = new CallPlan();
        //adding the call plan to the custom class in any case
        if(!blnisClone)
            objCurrentCallPlan.objCallPln = objCallPlan;
        else
            objCurrentCallPlan.objCallPln = objClonedCallPlan;
        
        // for teh clone case
        if(blnisClone){
            // mapping rbd dates
            datRefDate = Date.newInstance(Integer.valueOf(objClonedCallPlan.Year__c),MAP_MONTHNAME_MONTHNO.get(objClonedCallPlan.Month__c),1);
            //datClonedStartDate = getMonthStartDate(objClonedCallPlan.Month__c,datRefDate);
            //datClonedMonthEndDate = datClonedMonthStartDate.addDays(daysInMonths(MAP_MONTHNAME_MONTHNO.get(objClonedCallPlan.Month__c)));
            datClonedWeekStartDate = objClonedCallPlan.Start_Date__c;
            datClonedWeekEndDate = objClonedCallPlan.End_Date__c;
            Integer intWeekDays = datWeekStartDate.daysBetween(datWeekEndDate);
            Integer intClonedMonthDays = datClonedWeekStartDate.daysBetween(datClonedWeekEndDate);
        
                    }
        list_tempDates = new List<Date>();
        for(Date d = datWeekStartDate; d <= datWeekEndDate ;)
        {
            list_tempDates.add(d);
            d = d.addDays(1);
        }
        
        // querying if call plan detauil records exists
        list_callPlanDetailRecords = new List<Call_Plan_Detail__c>();
        list_callPlanDetailRecords = [Select Id,
                                        Account__c,
                                        Account__r.Name,
                                        Call_Plan__c,
                                        Date__c From Call_Plan_Detail__c where Call_Plan__c =:idCallPlan 
                                                                        AND Date__c >=  :datWeekStartDate
                                                                            AND Date__c <= :datWeekEndDate];
                                                                            
        if(blnisClone){
            list_backupDates = list_tempDates;
            list_tempDates = new List<Date>();
            for(Date d = datClonedWeekStartDate; d < datClonedWeekEndDate ;){
                list_tempDates.add(d);
                d = d.addDays(1);
            }
        }
        //adding the list of dates
        objCurrentCallPlan.list_RBDmonthDates  = list_tempDates;
        
        if(list_callPlanDetailRecords.size() >0)
        {
            // mapping existing call plan detail records to accounts for which they exist
            map_AccountId_listOfCallPlanDetailRecords = new Map<Id,List<Call_Plan_Detail__c>>();
            map_AccountId_MapOfDateAndCallPlanDetail= new Map<Id,Map<Date,Call_Plan_Detail__c>>();
            // for all the accounts mapping the detail records with the respective accounts
            for(Id accId :list_UserAccounts){
                list_accountsCallPlanDetail = new List<Call_Plan_Detail__c>();
                for(Call_Plan_Detail__c cpd :list_callPlanDetailRecords){
                    if(cpd.Account__c == accId){
                        list_accountsCallPlanDetail.add(cpd);
                    }
                }
                
                // creating a map of the accounts to a collection of the detail records which have been mapped to their dates
                map_Date_CallPlanDetail = new Map<Date,Call_Plan_Detail__c>();
                for(Call_Plan_Detail__c cp : list_accountsCallPlanDetail){
                    map_Date_CallPlanDetail.put(cp.Date__c,cp);
                }
                
                map_AccountId_listOfCallPlanDetailRecords.put(accId,list_accountsCallPlanDetail);
                map_AccountId_MapOfDateAndCallPlanDetail.put(accId,map_Date_CallPlanDetail);
            }
            
            
            list_callPlanDetail = new List<CallPlanDetail>();
            // creating custom class records
            for(Id accId : map_AccountId_listOfCallPlanDetailRecords.keyset()){   
                cpd = new CallPlanDetail();
                
                if(map_AccountId_NoOfVisits.containsKey(accId))
                    cpd.dcmNoOfVisitsPerMonth = map_AccountId_NoOfVisits.get(accId);
                    
                if(map_AccountId_NoOfVisits.containsKey(accId) && 
                    ((map_AccountId_VisitCount.containsKey(accId) && Math.floor(map_AccountId_NoOfVisits.get(accId)) > map_AccountId_VisitCount.get(accId)) || 
                    !map_AccountId_VisitCount.containsKey(accId)))
                {
                    cpd.blnHighLightVisitsColumn = true;
                }
                
                if( map_AccountId_MaxDays.containsKey(accId) &&
                    (!map_AccountId_LastVisitDate.containsKey(accId) || map_AccountId_LastVisitDate.get(accId).daysBetween(Date.today()) >= map_AccountId_MaxDays.get(accId) ) )
                {
                    cpd.blnHighLightStoreInfoColumn = true;
                }
                              blnisNoClassification = false;
                list_tempDays = new List<days>();
                List<Date> list_refDates ;
                
                if(blnisClone)
                    list_refDates = list_backupDates;
                else
                    list_refDates = objCurrentCallPlan.list_RBDmonthDates;
                 // for the List of rbd dates   
                for(Date days : list_refDates){
                    dd = new days();
                    if(map_AccountId_MapOfDateAndCallPlanDetail.get(accId).containsKey(days)){
                        dd.blnisbSelected = true;
                    } else{
                        dd.blnisbSelected = false;
                    }
                    list_tempDays.add(dd);
                }    
                //if more days in the selected month then created empty records.
                if(blnisCloneMore){
                    for(Integer i=0 ; i < 7 ; i++){
                        dd = new days();
                        dd.blnisbSelected = false;
                        list_tempDays.add(dd);
                    }
                }
                
                system.debug('accId>>'+accId);
                if(map_AccountId_MTDCalls.containsKey(accId))
                {
                    cpd.intMTDCalls = map_AccountId_MTDCalls.get(accId);
                    system.debug('Inside map A');
                }
                system.debug('cpd.intMTDCalls>>'+cpd.intMTDCalls);  
                
                // mapping individual classification   
                cpd.list_objDays = list_tempDays;
                if(map_ATypeAccountId_ATypeAccountName.containsKey(accId)){
                    cpd.idAccount = accId;
                    cpd.strStoreName = map_ATypeAccountId_ATypeAccountName.get(accId);
                    cpd.strClassification = 'A';
                    cpd.legacyid = legid.get(accId);
                    string aname = Areanameid.get(accId);
                    string acname = Accountnameid.get(accId);
                    string accsegname = AccountSegmtionid.get(accId);
                    if(aname!=null && aname!='')
                    cpd.Areaname = aname;
                    else
                    cpd.Areaname = '';
                } else if(map_BTypeAccountId_BTypeAccountName.containsKey(accId)){
                    cpd.idAccount = accId;
                    cpd.strStoreName = map_BTypeAccountId_BTypeAccountName.get(accId);
                    cpd.strClassification = 'B';
                    cpd.legacyid = legid.get(accId);
                    string aname = Areanameid.get(accId);
                    string acname = Accountnameid.get(accId);
                     string accsegname = AccountSegmtionid.get(accId);
                    if(aname!=null && aname!='')
                    cpd.Areaname = aname;
                    else
                    cpd.Areaname = '';
                } else if(map_CTypeAccountId_CTypeAccountName.containsKey(accId)){
                    cpd.idAccount = accId;
                    cpd.strStoreName = map_CTypeAccountId_CTypeAccountName.get(accId);
                    cpd.strClassification = 'C';
                    cpd.legacyid = legid.get(accId);
                    string aname = Areanameid.get(accId);
                    string acname = Accountnameid.get(accId);
                     string accsegname = AccountSegmtionid.get(accId);
                    if(aname!=null && aname!='')
                    cpd.Areaname = aname;
                    else
                    cpd.Areaname = '';
                } else if(map_DTypeAccountId_DTypeAccountName.containsKey(accId)){
                    cpd.idAccount = accId;
                    cpd.strStoreName = map_DTypeAccountId_DTypeAccountName.get(accId);
                    cpd.strClassification = 'D';
                    cpd.legacyid = legid.get(accId);
                    string aname = Areanameid.get(accId);
                    string acname = Accountnameid.get(accId);
                     string accsegname = AccountSegmtionid.get(accId);
                    if(aname!=null && aname!='')
                    cpd.Areaname = aname;
                    else
                    cpd.Areaname = '';
                } else if(map_NTypeAccountId_NTypeAccountName.containsKey(accId)){
                    cpd.idAccount = accId;
                    cpd.strStoreName = map_NTypeAccountId_NTypeAccountName.get(accId);
                    cpd.strClassification = 'N';
                    cpd.legacyid = legid.get(accId);
                    string aname = Areanameid.get(accId);
                    string acname = Accountnameid.get(accId);
                     string accsegname = AccountSegmtionid.get(accId);
                    if(aname!=null && aname!='')
                    cpd.Areaname = aname;
                    else
                    cpd.Areaname = '';
                } else if(map_ZTypeAccountId_ZTypeAccountName.containsKey(accId)){
                    cpd.idAccount = accId;
                    cpd.strStoreName = map_ZTypeAccountId_ZTypeAccountName.get(accId);
                    cpd.strClassification = 'Z';
                    cpd.legacyid = legid.get(accId);
                    string aname = Areanameid.get(accId);
                    string acname = Accountnameid.get(accId);
                     string accsegname = AccountSegmtionid.get(accId);
                    if(aname!=null && aname!='')
                    cpd.Areaname = aname;
                    else
                    cpd.Areaname = '';
                } else{
                    blnisNoClassification = true;
                }
                
                // if no strClassification then do not add that account
                if(!blnisNoClassification)
                    list_callPlanDetail.add(cpd);
                system.debug('cpd.intMTDCalls>>'+cpd.intMTDCalls);  
            }
            if(list_callPlanDetail.size() >0){
                List<CallPlanDetail> list_tempCallPlanDetailClassA = new List<CallPlanDetail>();
                List<CallPlanDetail> list_tempCallPlanDetailClassB = new List<CallPlanDetail>();
                List<CallPlanDetail> list_tempCallPlanDetailClassC = new List<CallPlanDetail>();
                List<CallPlanDetail> list_tempCallPlanDetailClassD = new List<CallPlanDetail>();
                List<CallPlanDetail> list_tempCallPlanDetailClassN = new List<CallPlanDetail>();
                List<CallPlanDetail> list_tempCallPlanDetailClassZ = new List<CallPlanDetail>();
                for(CallPlanDetail cpd : list_callPlanDetail){   
                    if(cpd.strClassification == 'A'){
                        list_tempCallPlanDetailClassA.add(cpd);
                    } else if(cpd.strClassification == 'B'){
                        list_tempCallPlanDetailClassB.add(cpd);
                    } else if(cpd.strClassification == 'C'){
                        list_tempCallPlanDetailClassC.add(cpd);
                    } else if(cpd.strClassification == 'D'){
                        list_tempCallPlanDetailClassD.add(cpd);
                    } else if(cpd.strClassification == 'N'){
                        list_tempCallPlanDetailClassN.add(cpd);
                    } else if(cpd.strClassification == 'Z'){
                        list_tempCallPlanDetailClassZ.add(cpd);
                    }
                }
                system.debug('list_tempCallPlanDetailClassA>>'+list_tempCallPlanDetailClassA);
                system.debug('list_tempCallPlanDetailClassB>>'+list_tempCallPlanDetailClassB);
                system.debug('list_tempCallPlanDetailClassC>>'+list_tempCallPlanDetailClassC);
                system.debug('list_tempCallPlanDetailClassD>>'+list_tempCallPlanDetailClassD);
                system.debug('list_tempCallPlanDetailClassN>>'+list_tempCallPlanDetailClassN);
                system.debug('list_tempCallPlanDetailClassZ>>'+list_tempCallPlanDetailClassZ);
                
                objCurrentCallPlan.list_callPlanDetailClassA = sortCallPlan(list_tempCallPlanDetailClassA);
                objCurrentCallPlan.list_callPlanDetailClassB = sortCallPlan(list_tempCallPlanDetailClassB);
                objCurrentCallPlan.list_callPlanDetailClassC = sortCallPlan(list_tempCallPlanDetailClassC);
                objCurrentCallPlan.list_callPlanDetailClassD = sortCallPlan(list_tempCallPlanDetailClassD);
                objCurrentCallPlan.list_callPlanDetailClassN = sortCallPlan(list_tempCallPlanDetailClassN);
                objCurrentCallPlan.list_callPlanDetailClassZ = sortCallPlan(list_tempCallPlanDetailClassZ);
                
               
            }
            
        } 
        else
        {
             
            // initialize all the records
            list_tempCallPlanDetailClassA = new List<CallPlanDetail>();
            if(map_ATypeAccountId_ATypeAccountName.size() >0){
                for(Id accId :map_ATypeAccountId_ATypeAccountName.keyset()){
                    CallPlanDetail cpd = new CallPlanDetail();
                    cpd.idAccount = accId;
                    cpd.strStoreName = map_ATypeAccountId_ATypeAccountName.get(accId);
                    cpd.legacyid = legid.get(accId);
                    string aname = Areanameid.get(accId);
                    if(aname!=null && aname!='')
                    cpd.Areaname = aname;
                    else
                    cpd.Areaname = '';
                    if(map_AccountId_NoOfVisits.containsKey(accId))
                        cpd.dcmNoOfVisitsPerMonth = map_AccountId_NoOfVisits.get(accId);
                    
                    if(map_AccountId_NoOfVisits.containsKey(accId) && 
                        ((map_AccountId_VisitCount.containsKey(accId) && Math.floor(map_AccountId_NoOfVisits.get(accId)) > map_AccountId_VisitCount.get(accId)) || 
                        !map_AccountId_VisitCount.containsKey(accId)))
                    {
                        cpd.blnHighLightVisitsColumn = true;
                    }
                    
                    if( map_AccountId_MaxDays.containsKey(accId) &&
                    (!map_AccountId_LastVisitDate.containsKey(accId) || map_AccountId_LastVisitDate.get(accId).daysBetween(Date.today()) >= map_AccountId_MaxDays.get(accId) ) )
                    {
                        cpd.blnHighLightStoreInfoColumn = true;
                    }
                    
           
                    list_tempDays = new List<Days>();
                    for(Integer i=0 ; i<objCurrentCallPlan.list_RBDmonthDates.size();i++ ){
                        dd = new days();
                        dd.blnisbSelected = false;
                        list_tempDays.add(dd);
                        
                    }
                    cpd.list_objDays = list_tempDays;
                    
                    //Setting the MTD Calls field
                    system.debug('accId>>'+accId);
                    if(map_AccountId_MTDCalls.containsKey(accId))
                    {
                        cpd.intMTDCalls = map_AccountId_MTDCalls.get(accId);
                        system.debug('Inside map A');
                    }   
                    list_tempCallPlanDetailClassA.add(cpd);
                }
            }
                
            list_tempCallPlanDetailClassB = new List<CallPlanDetail>();
            if(map_BTypeAccountId_BTypeAccountName.size() >0){
                for(Id accId :map_BTypeAccountId_BTypeAccountName.keyset()){
                    CallPlanDetail cpd = new CallPlanDetail();
                    cpd.idAccount = accId;
                    cpd.strStoreName = map_BTypeAccountId_BTypeAccountName.get(accId);
                    cpd.legacyid = legid.get(accId);
                    string aname = Areanameid.get(accId);
                    if(aname!=null && aname!='')
                    cpd.Areaname = aname;
                    else
                    cpd.Areaname = '';
                    if(map_AccountId_NoOfVisits.containsKey(accId))
                        cpd.dcmNoOfVisitsPerMonth = map_AccountId_NoOfVisits.get(accId);
                        
                    if(map_AccountId_NoOfVisits.containsKey(accId) && 
                    ((map_AccountId_VisitCount.containsKey(accId) && Math.floor(map_AccountId_NoOfVisits.get(accId)) > map_AccountId_VisitCount.get(accId)) || 
                    !map_AccountId_VisitCount.containsKey(accId)))
                    {
                        cpd.blnHighLightVisitsColumn = true;
                    }
                    
                    if( map_AccountId_MaxDays.containsKey(accId) &&
                    (!map_AccountId_LastVisitDate.containsKey(accId) || map_AccountId_LastVisitDate.get(accId).daysBetween(Date.today()) >= map_AccountId_MaxDays.get(accId) ) )
                    {
                        cpd.blnHighLightStoreInfoColumn = true;
                    }
                    
                  
                    list_tempDays = new List<Days>();
                    for(Integer i=0 ; i<objCurrentCallPlan.list_RBDmonthDates.size();i++ ){
                        dd = new days();
                        dd.blnisbSelected = false;
                        list_tempDays.add(dd);
                        
                    }
                    cpd.list_objDays = list_tempDays;
                    
                    //Setting the MTD Calls field
                    if(map_AccountId_MTDCalls.containsKey(accId))
                        cpd.intMTDCalls = map_AccountId_MTDCalls.get(accId);
                        
                    list_tempCallPlanDetailClassB.add(cpd);
                }
            }
            
            list_tempCallPlanDetailClassC = new List<CallPlanDetail>();
            if(map_CTypeAccountId_CTypeAccountName.size() >0){
                for(Id accId :map_CTypeAccountId_CTypeAccountName.keyset()){
                    CallPlanDetail cpd = new CallPlanDetail();
                    cpd.idAccount = accId;
                    cpd.strStoreName = map_CTypeAccountId_CTypeAccountName.get(accId);
                    cpd.legacyid = legid.get(accId);
                    string aname = Areanameid.get(accId);
                    if(aname!=null && aname!='')
                    cpd.Areaname = aname;
                    else
                    cpd.Areaname = '';
                    if(map_AccountId_NoOfVisits.containsKey(accId))
                        cpd.dcmNoOfVisitsPerMonth = map_AccountId_NoOfVisits.get(accId);
                        
                    if(map_AccountId_NoOfVisits.containsKey(accId) && 
                        ((map_AccountId_VisitCount.containsKey(accId) && Math.floor(map_AccountId_NoOfVisits.get(accId)) > map_AccountId_VisitCount.get(accId)) || 
                        !map_AccountId_VisitCount.containsKey(accId)))                      
                    {
                        cpd.blnHighLightVisitsColumn = true;
                    }
                    
                    if( map_AccountId_MaxDays.containsKey(accId) &&
                    (!map_AccountId_LastVisitDate.containsKey(accId) || map_AccountId_LastVisitDate.get(accId).daysBetween(Date.today()) >= map_AccountId_MaxDays.get(accId) ) )
                    {
                        cpd.blnHighLightStoreInfoColumn = true;
                    }
                    
                 
                    list_tempDays = new List<Days>();
                    for(Integer i=0 ; i<objCurrentCallPlan.list_RBDmonthDates.size();i++ ){
                        dd = new days();
                        dd.blnisbSelected = false;
                        list_tempDays.add(dd);
                        
                    }
                    cpd.list_objDays = list_tempDays;
                    
                    //Setting the MTD Calls field
                    if(map_AccountId_MTDCalls.containsKey(accId))
                        cpd.intMTDCalls = map_AccountId_MTDCalls.get(accId);
                        
                    list_tempCallPlanDetailClassC.add(cpd);
                    
                }
            }
            
            list_tempCallPlanDetailClassD = new List<CallPlanDetail>();
            if(map_DTypeAccountId_DTypeAccountName.size() >0){
                for(Id accId :map_DTypeAccountId_DTypeAccountName.keyset()){
                    CallPlanDetail cpd = new CallPlanDetail();
                    cpd.idAccount = accId;
                    cpd.strStoreName = map_DTypeAccountId_DTypeAccountName.get(accId);
                    cpd.legacyid = legid.get(accId);
                    string aname = Areanameid.get(accId);
                    if(aname!=null && aname!='')
                    cpd.Areaname = aname;
                    else
                    cpd.Areaname = '';
                    if(map_AccountId_NoOfVisits.containsKey(accId))
                        cpd.dcmNoOfVisitsPerMonth = map_AccountId_NoOfVisits.get(accId);
                        
                    if(map_AccountId_NoOfVisits.containsKey(accId) && 
                    ((map_AccountId_VisitCount.containsKey(accId) && Math.floor(map_AccountId_NoOfVisits.get(accId)) > map_AccountId_VisitCount.get(accId)) || 
                    !map_AccountId_VisitCount.containsKey(accId)))
                    {
                        cpd.blnHighLightVisitsColumn = true;
                    }
                    
                    if( map_AccountId_MaxDays.containsKey(accId) &&
                    (!map_AccountId_LastVisitDate.containsKey(accId) || map_AccountId_LastVisitDate.get(accId).daysBetween(Date.today()) >= map_AccountId_MaxDays.get(accId) ) )
                    {
                        cpd.blnHighLightStoreInfoColumn = true;
                    }
                    
                    list_tempDays = new List<Days>();
                    for(Integer i=0 ; i<objCurrentCallPlan.list_RBDmonthDates.size();i++ ){
                        dd = new days();
                        dd.blnisbSelected = false;
                        list_tempDays.add(dd);
                        
                    }
                    cpd.list_objDays = list_tempDays;
                    
                    //Setting the MTD Calls field
                    if(map_AccountId_MTDCalls.containsKey(accId))
                        cpd.intMTDCalls = map_AccountId_MTDCalls.get(accId);
                    list_tempCallPlanDetailClassD.add(cpd);
                    
                }
            }
            list_tempCallPlanDetailClassN = new List<CallPlanDetail>();
            if(map_NTypeAccountId_NTypeAccountName.size() >0){
                for(Id accId :map_NTypeAccountId_NTypeAccountName.keyset()){
                    CallPlanDetail cpd = new CallPlanDetail();
                    cpd.idAccount = accId;
                    cpd.strStoreName = map_NTypeAccountId_NTypeAccountName.get(accId);
                    cpd.legacyid = legid.get(accId);
                    string aname = Areanameid.get(accId);
                    if(aname!=null && aname!='')
                    cpd.Areaname = aname;
                    else
                    cpd.Areaname = '';
                    if(map_AccountId_NoOfVisits.containsKey(accId))
                        cpd.dcmNoOfVisitsPerMonth = map_AccountId_NoOfVisits.get(accId);
                        
                    if(map_AccountId_NoOfVisits.containsKey(accId) && 
                    ((map_AccountId_VisitCount.containsKey(accId) && Math.floor(map_AccountId_NoOfVisits.get(accId)) > map_AccountId_VisitCount.get(accId)) || 
                    !map_AccountId_VisitCount.containsKey(accId)))
                    {
                        cpd.blnHighLightVisitsColumn = true;
                    }
                    
                    if( map_AccountId_MaxDays.containsKey(accId) &&
                    (!map_AccountId_LastVisitDate.containsKey(accId) || map_AccountId_LastVisitDate.get(accId).daysBetween(Date.today()) >= map_AccountId_MaxDays.get(accId) ) )
                    {
                        cpd.blnHighLightStoreInfoColumn = true;
                    }
                    
                    list_tempDays = new List<Days>();
                    for(Integer i=0 ; i<objCurrentCallPlan.list_RBDmonthDates.size();i++ ){
                        dd = new days();
                        dd.blnisbSelected = false;
                        list_tempDays.add(dd);
                        
                    }
                    cpd.list_objDays = list_tempDays;
                    
                    //Setting the MTD Calls field
                    if(map_AccountId_MTDCalls.containsKey(accId))
                        cpd.intMTDCalls = map_AccountId_MTDCalls.get(accId);
                    list_tempCallPlanDetailClassN.add(cpd);
                    
                }
           list_tempCallPlanDetailClassZ = new List<CallPlanDetail>();
            if(map_ZTypeAccountId_ZTypeAccountName.size() >0){
                for(Id accId :map_ZTypeAccountId_ZTypeAccountName.keyset()){
                    CallPlanDetail cpd = new CallPlanDetail();
                    cpd.idAccount = accId;
                    cpd.strStoreName = map_ZTypeAccountId_ZTypeAccountName.get(accId);
                    cpd.legacyid = legid.get(accId);
                    string aname = Areanameid.get(accId);
                    if(aname!=null && aname!='')
                    cpd.Areaname = aname;
                    else
                    cpd.Areaname = '';
                    if(map_AccountId_NoOfVisits.containsKey(accId))
                        cpd.dcmNoOfVisitsPerMonth = map_AccountId_NoOfVisits.get(accId);
                        
                    if(map_AccountId_NoOfVisits.containsKey(accId) && 
                    ((map_AccountId_VisitCount.containsKey(accId) && Math.floor(map_AccountId_NoOfVisits.get(accId)) > map_AccountId_VisitCount.get(accId)) || 
                    !map_AccountId_VisitCount.containsKey(accId)))
                    {
                        cpd.blnHighLightVisitsColumn = true;
                    }
                    
                    if( map_AccountId_MaxDays.containsKey(accId) &&
                    (!map_AccountId_LastVisitDate.containsKey(accId) || map_AccountId_LastVisitDate.get(accId).daysBetween(Date.today()) >= map_AccountId_MaxDays.get(accId) ) )
                    {
                        cpd.blnHighLightStoreInfoColumn = true;
                    }
                    
                    list_tempDays = new List<Days>();
                    for(Integer i=0 ; i<objCurrentCallPlan.list_RBDmonthDates.size();i++ ){
                        dd = new days();
                        dd.blnisbSelected = false;
                        list_tempDays.add(dd);
                        
                    }
                    cpd.list_objDays = list_tempDays;
                    
                    //Setting the MTD Calls field
                    if(map_AccountId_MTDCalls.containsKey(accId))
                        cpd.intMTDCalls = map_AccountId_MTDCalls.get(accId);
                    list_tempCallPlanDetailClassZ.add(cpd);
                    
                }
            }
            }
                objCurrentCallPlan.list_callPlanDetailClassA = sortCallPlan(list_tempCallPlanDetailClassA);
                objCurrentCallPlan.list_callPlanDetailClassB = sortCallPlan(list_tempCallPlanDetailClassB);
                objCurrentCallPlan.list_callPlanDetailClassC = sortCallPlan(list_tempCallPlanDetailClassC);
                objCurrentCallPlan.list_callPlanDetailClassD = sortCallPlan(list_tempCallPlanDetailClassD);
                objCurrentCallPlan.list_callPlanDetailClassN = sortCallPlan(list_tempCallPlanDetailClassN);
                objCurrentCallPlan.list_callPlanDetailClassZ = sortCallPlan(list_tempCallPlanDetailClassZ);
                
                
        }        
    }
    
    
    /*************************************************************************
    ** Method for psoting error message
    *************************************************************************/
    public PageReference addErrorMessage(String error){
        blnisShowGo = false;
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, error);
        ApexPages.addMessage(msg);
        return null;
    }
    
    /*************************************************************************
    ** Method for displaying the select list
    *************************************************************************/
    public List<selectOption> getMonthsSelected(){
        List<selectOption> list_options=new List<selectOption>();
        Date datReferenceDate1 = date.Today();
        Date datReferenceDate2 = datReferenceDate1.addMonths(1);
        Date datReferenceDate3 = datReferenceDate1.addMonths(2);
        String strMonth1 = MAP_MONTHNO_MONTHNAME.get(datReferenceDate1.month());
        String strMonth2;
        if(datReferenceDate1.month() != 12)
                strMonth2 = MAP_MONTHNO_MONTHNAME.get(datReferenceDate2.month());
                
                
         String strMonth3;
        if(datReferenceDate2.month() != 12)
                strMonth3 = MAP_MONTHNO_MONTHNAME.get(datReferenceDate3.month());       
        
        if(strMonth1 != null)      
            list_options.add(new selectOption(strMonth1,strMonth1));
        
        if(strMonth2 != null)      
            list_options.add(new selectOption(strMonth2,strMonth2));
            
        if(strMonth3 != null)      
            list_options.add(new selectOption(strMonth3,strMonth3));
            
        return list_options;
    }
      
    public void createStartDateMap()
    {
        // for calculating year startdate
        MAP_YEAR_YEARSTARTDATE.put(2009, Date.newInstance(2008, 12, 22));
        MAP_YEAR_YEARSTARTDATE.put(2010, Date.newInstance(2009, 12, 21));
        MAP_YEAR_YEARSTARTDATE.put(2011, Date.newInstance(2010, 12, 20));
        MAP_YEAR_YEARSTARTDATE.put(2012, Date.newInstance(2011, 12, 19));
    }
    
    public PageReference cancel()
    {
        return(new PageReference('/'+objCallPlan.Id));
    }
    
    //Sorting the call plan based on the store name
    private List<CallPlanDetail> sortCallPlan(List<CallPlanDetail> sourceList){
        
        List<CallPlanDetail> sortedList = new List<CallPlanDetail>();
        
        Map<String, List<CallPlanDetail>> mapOfSource = new Map<String, List<CallPlanDetail>>();
        
        //Iterate through the list and construct map to sort
        for( CallPlanDetail sourceObject : sourceList ){
            
            //If the store name already exists add the new store to the existing store
            if(mapOfSource.containsKey(sourceObject.strStoreName)){
                
                List<CallPlanDetail> callDetail = mapOfSource.get(sourceObject.strStoreName);
                callDetail.add(sourceObject);
                mapOfSource.put(sourceObject.strStoreName, callDetail);
                
            }
            //If the store name doesn't exist add the new store
            else{
                List<CallPlanDetail> callDetail = new List<CallPlanDetail>();
                callDetail.add(sourceObject);
                mapOfSource.put(sourceObject.strStoreName, callDetail);             
            }
            
            
        }
        
        //Get all the store names
        Set<String> sourceStoresKeys = new Set<String>();
        sourceStoresKeys = mapOfSource.keySet();
        //Sort the store name
        List<String> sortedStores = new List<String>();
        sortedStores.addAll(sourceStoresKeys);
        sortedStores.sort();
        
        //Iterate through the sorted store names and construct call plan details
        for(String sourceStore : sortedStores){
            List<CallPlanDetail> callDetail = mapOfSource.get(sourceStore);
            for(CallPlanDetail cpDetail : callDetail){
                sortedList.add(cpDetail);
            }
        } 
        
        return sortedList;
        
    }
}