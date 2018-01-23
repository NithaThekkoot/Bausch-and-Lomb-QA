/**
* 
* This is the controller for the call planning page , which covers the creation , editing and clone of call plan detail records
* for a given RBD month
* Author               |Author-Email                       |Date        |Comment
* ---------------------|---------------------------------- |------------|----------------------------------------------------
* Yash Agarwal         |yash.agarwal@listertechnologies.com|30.05.2010  |First Draft for CtrlCallPlanning_planDetail page
*
* Rohit Kumar Verma    |rohit.verma@bausch.com             |10.Jan.2013 |Resloved the Run Test issue 
*/
public class CtrlCallPlan
{
    
    /*************************************************************************
    ** Variable Declerations
    *************************************************************************/
    private  final Integer intQuarterDays = 13 * 7;
    
    //to populate the callPlan record information along with the detail  incase of new,edit or clone
    public Call_Plan__c objCurrentCallPlan { get; set;}
    // current call plan record
    public Call_Plan__c  objCallPlan{ get; set;}
    // clonecd call plan record
    public Call_Plan__c  objClonedCallPlan = new Call_Plan__c();
    //instance of call plan detail records
    public Call_Plan_Detail__c objCallPlanDetail;
    //instance of a user
    public User objUser { get; set;}
    
    // record type ids for different record types
    public Id idRecordTypeCallPlan;
    public Id idRecordTypeCallPlanDetail;
    public Id idRecordTypePhysicianVisit ;
    public Id idRecordTypeContact;
    
    //start date of a RBD month
    public date datMonthStartDate ;
    //end date of a RBD month  
    public date datMonthEndDate ;
    //start date of a RBD month for clone case
    public date datClonedMonthStartDate ;
    //end date of a RBD month for clone case
    public date datClonedMonthEndDate;
    // for the last month
    public date datLastMonthStartDate ;
    //end date of a RBD month for last month
    public date datLastMonthEndDate;
    //reference date
    public Date datRefDate;
    //reference date for last month 
    public Date datLastMonth;
    public string strMode = '';
    //selected month while cloning
    public String strSelectedMonth{ get; set;}
    //id of the call plan
    public Id idCallPlan ;
    // for the last month
    public String strLastMonthStartDate { get; set;}
    //end date of a RBD month for last month
    public String strLastMonthEndDate { get; set;}
    
    
    //temp list of dates            
    public List<Date> list_tempDates ;
    // list of dates            
    public List<Date> list_RBDmonthDates{ get; set;}

    //list of user accounts
    public List<Id> list_UserAccounts;
    // list of active account ids
    public List<Id> list_activeAccounts;
    // list of contact ids
    public List<Id> list_contactId;
    // list of accounts pertainign to call plan detail
    public List<Call_Plan_Detail__c> list_contactsCallPlanDetail;
    //list of account team member accounts
    public List<AccountTeamMember> list_accountsForOwner;
    // list of account profiles
    public List<Contact> list_userContact;
    //list of call plan detail records
    public List<Call_Plan_Detail__c> list_callPlanDetailRecords ;   
    // custom list of custom class clann plan detail    
    public List<CallPlanDetail> list_callPlanDetailRecord { get; set;}
    // list of call plan detail records to be inserted
    //list of custom class days
    public List<days> list_tempDays = new List<days>();
    //list of backup dates for the cloned case
    public List<Date> list_backupDates;
    // list of call plan detail records to be inserted
    public List<Call_Plan_Detail__c> list_callPlanDetailInsert;
    //list of physician visits
    public List<Physician_Visit__c> list_insertPhysicianVisit;
    // temporary list of contacts
    public List<Contact> list_tempContact;
    // for mapping contact ids to physician visit
    public Map<Id,List<Physician_Visit__c>> map_ContactId_PhysicianVisit;
    
    //map of account ids and list of call plan detail records
    public Map<Id,List<Call_Plan_Detail__c>> map_ContactId_listOfCallPlanDetailRecords ;
    //map of account ids and map of date to call plan detail record
    public Map<Id,Map<Date,Call_Plan_Detail__c>> map_ContactId_MapOfDateAndCallPlanDetail;
    // map of date to call plan detail record
    public Map<Date,Call_Plan_Detail__c> map_Date_CallPlanDetail;
    // constants for obatining month nos
    //map contact ids to contact
    public Map<Id,Contact> map_ContactId_Contact;
    
    public Map<String,Integer> MAP_MONTHNAME_MONTHNO = new Map<String,Integer>();
    public Map<Integer,String> MAP_MONTHNO_MONTHNAME = new Map<Integer,String>();
    public Map<Integer,Date> MAP_YEAR_YEARSTARTDATE = new Map<Integer,Date>();
    
    // map for account Names 
    public Map<Id,Account> map_AccId_AccName;
    
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
    //for showing the detail button
    public Boolean blnisShowDetail { get; set;}
    //for hidding all buttons
    public Boolean blnisDisableAllButtons { get; set;} 
    // for checking if exception occurs
    public Boolean blnisException = false;
    // boolean for checking if call plan is in error at all or not
    public Boolean blnisNoError = false;
    
    /*************************************************************************
    ** Custom Classes : for storing callplan Detail level information
    *************************************************************************/
    public class CallPlanDetail{
        public Account objAccount{ get; set;}
        public Contact objContact { get; set;}
        public String strLink { get; set;}
        public List<days> list_objDays{ get; set;} 
        public Integer errorNo { get; set;}
        public Boolean blnisInError { get; set;}
        public CallPlanDetail(){
            objAccount = new Account();
            objContact = new Contact();
            strLink = '';
            list_objDays = new List<days>();
            errorNo = 0;
            blnisInError = false;
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
    public CtrlCallPlan(){
        // making map for obtaining month no. from selected month
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
        
        // for calculating year startdate
        MAP_YEAR_YEARSTARTDATE.put(2009, Date.newInstance(2008, 12, 22));
        MAP_YEAR_YEARSTARTDATE.put(2010, Date.newInstance(2009, 12, 21));
        MAP_YEAR_YEARSTARTDATE.put(2011, Date.newInstance(2010, 12, 20));
        MAP_YEAR_YEARSTARTDATE.put(2012, Date.newInstance(2011, 12, 19));
        MAP_YEAR_YEARSTARTDATE.put(2013, Date.newInstance(2012, 12, 19));  // By Tarun Solanki      
        MAP_YEAR_YEARSTARTDATE.put(System.Today().Year(), Date.newInstance(System.Today().Year() - 1, 12, 19));   // By Rohit Kumar Verma  
        // initilaizing values
        blnisSaveFlag = false;
        blnisSubmitFlag= false;
        blnisApproveFlag= false;
        blnisRejectFlag = false;
        blnisManager = false;
        blnisDisable = false;
        blnisShowGo = true;
        blnisShowDetail = false;
        blnisDisplayCallPlanDetail = false;
    blnisDisableAllButtons = false;
        strLastMonthStartDate = '';
        strLastMonthEndDate = '';
        objCurrentCallPlan = new Call_Plan__c();
        //getting the different record type ids
        idRecordTypeCallPlan = [SELECT Id FROM RecordType 
                                        WHERE Name = 'INDSU Call Plan' AND SObjectType='Call_Plan__c'].Id;
        
        idRecordTypeCallPlanDetail = [SELECT Id FROM RecordType 
                                        WHERE Name = 'INDSU Call Plan Detail' AND SObjectType='Call_Plan_Detail__c'].Id;
        
        idRecordTypePhysicianVisit = [SELECT Id FROM RecordType 
                                        WHERE (Name = 'INDSU Sales Planned') AND SObjectType='Physician_Visit__c' limit 1].Id;    
                                        
        idRecordTypeContact = [SELECT Id FROM RecordType 
                                        WHERE Name = 'INDSU Contact' AND SObjectType='Contact'].Id;

                                            
        //getting the parameters from the url
        idCallPlan =  ApexPages.currentPage().getParameters().get('id');
        strMode =  ApexPages.currentPage().getParameters().get('mode');
        //getting user information
        String strTypeOfUserId = UserInfo.getUserId();
        User objTypeOfUser = [Select Id,name,UserRoleId from User where id =:strTypeOfUserId ];
        system.debug('check1>>' + objTypeOfUser);
        UserRole objUserRole;
        if(objTypeOfUser.UserRoleId!=null)
            objUserRole = [Select Id,name from userRole where id=:objTypeOfUser.UserRoleId];
        
        system.debug('check2>>' + objUserRole);
        //deciding if maanger or not
        if(objUserRole!=null){
            if(objUserRole.name.contains('Manager') || objUserRole.name.contains('manager')){
                blnisManager = true;
            }
        }
        
        //checking if clone is required or not
        if(ApexPages.currentPage().getParameters().get('clone') == '1')
            blnisClone = true;
        else
            blnisClone = false;
            
            
        system.debug('check3>>' + blnisClone + 'Manager=' + blnisManager);
        // if the call plan id is nto null query the given call plan
        system.debug('check4>>' + idCallPlan);
        system.debug('check5>>' + strMode);
        if(idCallPlan !=null){
            //query the particular call plan record
            objCallPlan = new Call_plan__c();
            objCallPlan = [Select Id,
                                    name,
                                    Year__c,
                                    Status__c,
                                    Month__c,
                                    Manager_Comments__c,
                                    Executive_Comments__c,
                                    OwnerId From Call_Plan__c where id =:idCallPlan
                                                                AND RecordTypeId = :idRecordTypeCallPlan];
            system.debug('check6>>' + objCallPlan);                        
            //querying all the accounteams to which this sales executive is a member
            // if teh record exists query the related information
            if(objCallPlan.Id !=null){
                if(objCallPlan.status__c!=null){
                    if(((!blnisManager && objCallPlan.status__c !='Draft') || (objCallPlan.status__c =='Approved')|| (objCallPlan.status__c =='Rejected')) && (!blnisClone)){
                        blnisDisable = true;
                    }
          if(objCallPlan.status__c == 'Approved' || objCallPlan.status__c == 'Rejected'){
            blnisDisableAllButtons = true;
          }
                }
                
            system.debug('check7>>' + blnisDisable);                        
                // user pertaining to that record
                objUser = [Select Id,Name,userRoleId,email from User where id = :objCallPlan.OwnerId];
                system.debug('check8>>' + objUser);                        
                list_accountsForOwner = [select Id,AccountId,UserId from AccountTeamMember where UserId =:objCallPlan.OwnerId];
                system.debug('check9>>' + list_accountsForOwner);                        
                // accounts for that record                  
                if(list_accountsForOwner.size()>0){
                    //creating a list of those account Ids
                    list_UserAccounts = new List<Id>();
                    for(AccountTeamMember accMem : list_accountsForOwner){
                        list_UserAccounts.add(accMem.AccountId);
                    }
                    
                    system.debug('check10>>' + list_UserAccounts);
                    //getting the active accounts
                    map_AccId_AccName = new Map<Id,Account>();
                    list_activeAccounts = new List<Id>();
                    for(Account acc :[Select Id,Name,Status__c From Account where Id in : list_UserAccounts AND Status__c!='I - Inactive'])
                    {
                        map_AccId_AccName.put(acc.Id,acc);
                        list_activeAccounts.add(acc.Id);
                    }
                     // querying the profiles for the strClassification information 
                    list_userContact = new List<Contact>();
                    list_userContact = [Select Id,
                                                name,
                                                AccountId From Contact where AccountId in : list_activeAccounts
                                                                        AND AccountId != null
                                                                        AND RecordTypeId =:idRecordTypeContact];
                    
                    system.debug('check11>>' + list_userContact);
                    // for getting the names of the individual accounts
                    
                    system.debug('check12>>' + map_AccId_AccName);
                    if(list_userContact.size()>0){
                    
                        // for mapping the list of contacts to individual accounts
                        map_ContactId_Contact = new Map<Id,Contact>();
                        list_contactId = new List<Id>();        
                        for(Contact con : list_userContact)
                        {
                            list_contactId.add(con.Id);
                            map_ContactId_Contact.put(con.Id,con);
                        }
                        
                        
                        // for the given call plan having queryied all the necessary information in case of new /edit /clone we now see if call plan detail information exists 
                        // for the call plan and if it does we map that information to the interface
                        
                        // getting the start and end dates for a particular call plan
                        system.debug('check13>>');
                        if(objCallPlan.Month__c !=null){
                        
                            //calculating errors in call planning for each contact in the last month
                            if(objCallPlan.Month__c != 'Jan')
                                datLastMonth = Date.newInstance(Integer.valueof(objCallPlan.Year__c),(MAP_MONTHNAME_MONTHNO.get(objCallPlan.Month__c) - 1),1);
                            else
                                datLastMonth = Date.newInstance((Integer.valueof(objCallPlan.Year__c) - 1),12,1);
                            
                            
                            if(datLastMonth!=null)
                            {
                                datLastMonthStartDate = getMonthStartDate(MAP_MONTHNO_MONTHNAME.get(datLastMonth.month()),datLastMonth);
                                strLastMonthStartDate = string.valueOf(datLastMonthStartDate);
                                datLastMonthEndDate = datLastMonthStartDate.addDays(daysInMonths(datLastMonth.month()));
                                strLastMonthEndDate = string.valueOf(datLastMonthEndDate);
                                Physician_Visit__c[] list_physicianVist = [Select Id,
                                                                                    Activity_Date__c,
                                                                                    Physician__c,
                                                                                    Status__c From Physician_Visit__c Where Physician__c in : list_contactId 
                                                                                                                    AND Activity_Date__c >=  :datLastMonthStartDate
                                                                                                                    AND Activity_Date__c <= :datLastMonthEndDate
                                                                                                                    AND Status__c = 'Open'
                                                                                                                    AND RecordTypeId = :idRecordTypePhysicianVisit];
                                                                                                                    
                                system.debug('Phys>>>' + list_physicianVist);
                                                                                                            
                                if(list_physicianVist.size()>0)
                                {
                                    map_ContactId_PhysicianVisit = new Map<Id,List<Physician_Visit__c>>();
                                    for(Id conid:list_contactId){
                                        List<Physician_Visit__c> list_tempPhysicianVisit = new List<Physician_Visit__c>();
                                        for(Physician_Visit__c phy :list_physicianVist){
                                        
                                            if(phy.Physician__c == conid){
                                                list_tempPhysicianVisit.add(phy);
                                            }
                                            
                                            map_ContactId_PhysicianVisit.put(conid,list_tempPhysicianVisit);
                                        }
                                    }
                                } else{
                                    blnisNoError = true;
                                }
                            }
                            
                            datRefDate = Date.newInstance(Integer.valueof(objCallPlan.Year__c),MAP_MONTHNAME_MONTHNO.get(objCallPlan.Month__c),1);
                            system.debug('check14>>' + datRefDate);
                            if(datRefDate!=null)
                            {
                                
                                datMonthStartDate = getMonthStartDate(objCallPlan.Month__c,datRefDate);
                                datMonthEndDate = datMonthStartDate.addDays(daysInMonths(MAP_MONTHNAME_MONTHNO.get(objCallPlan.Month__c)));
                                system.debug('check15>>' + datMonthStartDate + 'Dates =' + datMonthEndDate);
                            
                                // in case of clone show info and call method
                                if(!blnisClone){
                                    system.debug('check16>>Not Clone = ');
                                    createCallPlanRecords();
                                } else{
                                    blnisDisplayCallPlanDetail = false;
                                }
                            } else{
                                addErrorMessage('Error could not find month starting date');
                            }
                        } else{
                            addErrorMessage('No Month Selected for the call plan');
                        }
                    } else{
                        addErrorMessage('No contacts available for the given user.');
                    }
                } else{
                    addErrorMessage('Given Sales Executive is not part of any Account teams');
                }
            } else{
                addErrorMessage('No call Plan exsists for the given Id');
            }
        } else{
            addErrorMessage('Invalid call plan selected');
        }
    }
    
    /*************************************************************************
    ** Button Action Methods for the Go button
    *************************************************************************/
    
    public PageReference doCloneAfterChoosingMonth(){
        
        //creating cloned records
        objClonedCallPlan = new Call_Plan__c();
        objClonedCallPlan.Month__c = strSelectedMonth;
        objClonedCallPlan.Status__c = 'Draft';
        objClonedCallPlan.Manager_Comments__c = objCallPlan.Manager_Comments__c;
        objClonedCallPlan.Executive_Comments__c = objCallPlan.Executive_Comments__c;
        Date todayDate = Date.today();
        objClonedCallPlan.Year__c = String.valueof(todayDate.year());
        objClonedCallPlan.RecordTypeId = idRecordTypeCallPlan;
        insert objClonedCallPlan;
        blnisDisplayCallPlanDetail = true;
        createCallPlanRecords();
        
       
        return null;
    }
    
    /*************************************************************************
    ** Method call for creating required records
    *************************************************************************/
    public void createCallPlanRecords(){
        system.debug('check17>>Not Clone = ');
        //initializing call plan record
        objCurrentCallPlan = new Call_Plan__c();
        //adding the call plan to the custom class in any case
        if(!blnisClone)
            objCurrentCallPlan = objCallPlan;
        else
            objCurrentCallPlan = objClonedCallPlan;
        
        system.debug('check17>> = ' + objCurrentCallPlan);
        // for teh clone case
        if(blnisClone){
            // mapping rbd dates
            datRefDate = Date.newInstance(Integer.valueof(objClonedCallPlan.Year__c),MAP_MONTHNAME_MONTHNO.get(objClonedCallPlan.Month__c),1);
            datClonedMonthStartDate = getMonthStartDate(objClonedCallPlan.Month__c,datRefDate);
            datClonedMonthEndDate = datClonedMonthStartDate.addDays(daysInMonths(MAP_MONTHNAME_MONTHNO.get(objClonedCallPlan.Month__c)));
            Integer intMonthDays = datMonthStartDate.daysBetween(datMonthEndDate);
            Integer intClonedMonthDays = datClonedMonthStartDate.daysBetween(datClonedMonthEndDate);
        
            if(intClonedMonthDays < intMonthDays){
                datMonthEndDate = datMonthEndDate - 7;
            } else if(intClonedMonthDays > intMonthDays){
                blnisCloneMore = true;
            }
        }
        list_tempDates = new List<Date>();
        for(Date d = datMonthStartDate; d < datMonthEndDate ;){
            list_tempDates.add(d);
            d = d.addDays(1);
        }
        
        // querying if call plan detail records exists
        list_callPlanDetailRecords = new List<Call_Plan_Detail__c>();
        list_callPlanDetailRecords = [Select Id,
                                        Physician_Name__c,
                                        Physician_Name__r.AccountId,
                                        Call_Plan__c,
                                        Date__c,
                                        Call__c,
                                        Joint_Call__c,
                                        Call_Objective__c From Call_Plan_Detail__c where Call_Plan__c =:idCallPlan 
                                                                        AND Date__c >=  :datMonthStartDate
                                                                        AND Date__c <= :datMonthEndDate
                                                                        AND Call__c = true
                                                                        AND RecordTypeId =:idRecordTypeCallPlanDetail];
                                                                            
        system.debug('check18>> = ' + list_callPlanDetailRecords);
        if(blnisClone){
            list_backupDates = list_tempDates;
            list_tempDates = new List<Date>();
            for(Date d = datClonedMonthStartDate; d < datClonedMonthEndDate ;){
                list_tempDates.add(d);
                d = d.addDays(1);
            }
        }
        //adding the list of dates
        list_RBDmonthDates  = list_tempDates;
        system.debug('check19>> = ' + list_RBDmonthDates);
        if(list_callPlanDetailRecords.size() >0){
            if(strMode == 'new'){
                system.debug('display>>' + blnisDisplayCallPlanDetail);
                // if button clicked is new and records exist
                addErrorMessage('Cannot Create new Call Plans for the given month , call plan detail records already exists');
            } else{
                blnisDisplayCallPlanDetail = true;
                blnisShowDetail = true;
                    
                // mapping existing call plan detail records to accounts for which they exist
                map_ContactId_listOfCallPlanDetailRecords = new Map<Id,List<Call_Plan_Detail__c>>();
                map_ContactId_MapOfDateAndCallPlanDetail= new Map<Id,Map<Date,Call_Plan_Detail__c>>();
                
                // for all the accounts mapping the detail records with the respective accounts
                for(Contact con :list_userContact){
                
                    
                        
                    system.debug('Contact Check>>' + con);
                    system.debug('Contact Check>>' + list_callPlanDetailRecords);
                    system.debug('Contact Check>>' + list_callPlanDetailRecords[0].Physician_Name__c);
                    list_contactsCallPlanDetail = new List<Call_Plan_Detail__c>();
                    for(Call_Plan_Detail__c cpd :list_callPlanDetailRecords){
                        if(cpd.Physician_Name__c == con.Id){
                            system.debug('Contact Check2>>' + cpd.Physician_Name__c);
                            list_contactsCallPlanDetail.add(cpd);
                        }
                    }
                    system.debug('Contact Check3>>' + list_contactsCallPlanDetail);
                    // creating a map of the accounts to a collection of the detail records which have been mapped to their dates
                    map_Date_CallPlanDetail = new Map<Date,Call_Plan_Detail__c>();
                    if(list_contactsCallPlanDetail.size() >0)
                    {
                        system.debug('test' + list_contactsCallPlanDetail);
                        for(Call_Plan_Detail__c cp : list_contactsCallPlanDetail){
                        map_Date_CallPlanDetail.put(cp.Date__c,cp);
                        }
                        system.debug('Contact Check3>>' + map_Date_CallPlanDetail);
                        map_ContactId_listOfCallPlanDetailRecords.put(con.Id,list_contactsCallPlanDetail);
                        map_ContactId_MapOfDateAndCallPlanDetail.put(con.Id,map_Date_CallPlanDetail);
                        
                    }
                }
                system.debug('check>> = ' + map_ContactId_listOfCallPlanDetailRecords);
                
                
                
                list_callPlanDetailRecord = new List<CallPlanDetail>();
                // creating custom class records
                for(Id conId : map_ContactId_listOfCallPlanDetailRecords.keyset()){   
                    CallPlanDetail callPlanDetailRecord = new CallPlanDetail();
                    //blnisNoClassification = false;
                    list_tempDays = new List<days>();
                    List<Date> list_refDates ;
                    
                    if(blnisClone)
                        list_refDates = list_backupDates;
                    else
                        list_refDates = list_RBDmonthDates;
                        
                     // for the List of rbd dates   
                    for(Date days : list_refDates){
                        dd = new days();
                        if(map_ContactId_MapOfDateAndCallPlanDetail.get(conId).containsKey(days)){
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
                    // mapping individual classification   
                    callPlanDetailRecord.list_objDays = list_tempDays;
                    callPlanDetailRecord.objAccount = map_AccId_AccName.get(map_ContactId_Contact.get(conId).AccountId);
                    callPlanDetailRecord.objContact = map_ContactId_Contact.get(conId);
                    callPlanDetailRecord.strLink = '';
                    
                    // marking the no. of records in the error in the previous month the particular record
                    if(!blnisNoError){
                        if(map_ContactId_PhysicianVisit.containsKey(conId)){
                            callPlanDetailRecord.errorNo = map_ContactId_PhysicianVisit.get(conId).size();
                        } else{
                            callPlanDetailRecord.errorNo = 0;
                        }
                    } else{
                        callPlanDetailRecord.errorNo = 0;
                    }
                    
                    if(callPlanDetailRecord.errorNo == 0 || blnisClone)
                        callPlanDetailRecord.blnisInError = false;
                    else
                        callPlanDetailRecord.blnisInError = true;
                    
                    system.debug('detail>>' + callPlanDetailRecord);
                    // for creating a sorted list
                    if(list_callPlanDetailRecord.size() > 0){
                        for(Integer i=0;i < list_callPlanDetailRecord.size(); i++){
                            if(list_callPlanDetailRecord[i].errorNo != 0){
                                if(callPlanDetailRecord.errorNo < list_callPlanDetailRecord[i].errorNo){
                                    List<CallPlanDetail> list_tempCpd1 = new List<CallPlanDetail>();
                                    List<CallPlanDetail> list_tempCpd2 = new List<CallPlanDetail>();
                                    for( integer x = i ; x < list_callPlanDetailRecord.size() ; x++){
                                        list_tempCpd1.add(list_callPlanDetailRecord[x]);
                                    }
                                    for( integer x = 0 ; x < i; x++){
                                        list_tempCpd2.add(list_callPlanDetailRecord[x]);
                                    }
                                    list_callPlanDetailRecord =new List<CallPlanDetail>();
                                    list_callPlanDetailRecord.addAll(list_tempCpd2);
                                    list_callPlanDetailRecord.add(callPlanDetailRecord);
                                    list_callPlanDetailRecord.addAll(list_tempCpd1);
                                    break;
                                }
                            }
                            if(i == (list_callPlanDetailRecord.size() - 1)){
                                list_callPlanDetailRecord.add(callPlanDetailRecord);
                                break;
                            }
                        }
                    } else{
                        list_callPlanDetailRecord.add(callPlanDetailRecord);
                    }   
                }
                system.debug('SOrt1>>' + list_callPlanDetailRecord);
                //inverting the list to be sorted in descending no. of records in error.
                if(list_callPlanDetailRecord.size() > 0 ){
                    List<CallPlanDetail> list_tempCallPlanDetail = new List<CallPlanDetail>();
                    for(Integer i= (list_callPlanDetailRecord.size() - 1);i >=0 ;i-- ){
                        list_tempCallPlanDetail.add(list_callPlanDetailRecord[i]);
                    }
                    list_callPlanDetailRecord = new List<CallPlanDetail>();
                    for(CallPlanDetail cpdTemp : list_tempCallPlanDetail){
                        list_callPlanDetailRecord.add(cpdTemp);
                    }
                }
                system.debug('SOrt2>>' + list_callPlanDetailRecord);
            }
        } else{
            // if records do not exist and new is not hit show diff error messages
            if(strMode != 'new'){
                blnisDisplayCallPlanDetail = false;
                system.debug('display>>' + blnisDisplayCallPlanDetail);
                if(blnisClone)
                    addErrorMessage('Cannot clone Call Plans for the given month ,call plan detail records do not  exists');
                else
                    addErrorMessage('Cannot edit Call Plans for the given month , call plan detail records do not  exists');
            } else{   
                
                blnisDisplayCallPlanDetail = true;
                                
                system.debug('check20>>isnew');
                // initialize all the records
                list_callPlanDetailRecord = new List<CallPlanDetail>();
                if(list_userContact.size() >0){
                    system.debug('check21>>' + list_userContact.size());
                    Integer count =0;
                    for(Contact con :list_userContact){
                        
                        system.debug('counts>>' + count++);
                        system.debug('C>>>0>>' + list_callPlanDetailRecord.size());
                        cpd = new CallPlanDetail();
                        cpd.objAccount = map_AccId_AccName.get(map_ContactId_Contact.get(con.Id).AccountId);
                        cpd.objContact = map_ContactId_Contact.get(con.Id);
                        cpd.strLink = '';
                        
                        list_tempDays = new List<Days>();
                        for(Integer i=0 ; i<list_RBDmonthDates.size();i++ ){
                            dd = new days();
                            dd.blnisbSelected = false;
                            list_tempDays.add(dd);
                            
                        }
                        cpd.list_objDays = list_tempDays;
                        
                        // marking the no. of records in the error in the previous month the particular record
                        if(!blnisNoError){
                            if(map_ContactId_PhysicianVisit.containsKey(con.Id)){
                                cpd.errorNo = map_ContactId_PhysicianVisit.get(con.Id).size();
                            } else{
                                cpd.errorNo = 0;
                            }
                        } else{
                            cpd.errorNo = 0;
                        }
                        system.debug('CheckError>>' + cpd.errorNo);
                        if(cpd.errorNo == 0 || blnisClone)
                            cpd.blnisInError = false;
                        else
                            cpd.blnisInError = true;
                        
                        // for creating a sorted list
                        if(list_callPlanDetailRecord.size() > 0){
                            for(Integer i=0;i < list_callPlanDetailRecord.size(); i++){
                                if(list_callPlanDetailRecord[i].errorNo != 0){
                                    if(cpd.errorNo < list_callPlanDetailRecord[i].errorNo){
                                        List<CallPlanDetail> list_tempCpd1 = new List<CallPlanDetail>();
                                        List<CallPlanDetail> list_tempCpd2 = new List<CallPlanDetail>();
                                        for( integer x = i ; x < list_callPlanDetailRecord.size() ; x++){
                                            list_tempCpd1.add(list_callPlanDetailRecord[x]);
                                        }
                                        for( integer x = 0 ; x < i; x++){
                                            list_tempCpd2.add(list_callPlanDetailRecord[x]);
                                        }
                                        list_callPlanDetailRecord =new List<CallPlanDetail>();
                                        list_callPlanDetailRecord.addAll(list_tempCpd2);
                                        list_callPlanDetailRecord.add(cpd);
                                        list_callPlanDetailRecord.addAll(list_tempCpd1);
                                        break;
                                    }
                                }
                                if(i == (list_callPlanDetailRecord.size() - 1)){
                                    list_callPlanDetailRecord.add(cpd);
                                    break;
                                }
                            }
                        } else{
                            list_callPlanDetailRecord.add(cpd);
                        }
                        
                        system.debug('check22>>' + cpd);
                        
                    }
                    system.debug('SOrt1>>' + list_callPlanDetailRecord);
                    //inverting the list to be sorted in descending no. of records in error.
                    if(list_callPlanDetailRecord.size() > 0 ){
                        List<CallPlanDetail> list_tempCallPlanDetail = new List<CallPlanDetail>();
                        for(Integer i= (list_callPlanDetailRecord.size() - 1);i >=0 ;i-- ){
                            list_tempCallPlanDetail.add(list_callPlanDetailRecord[i]);
                        }
                        list_callPlanDetailRecord = new List<CallPlanDetail>();
                        for(CallPlanDetail cpdTemp : list_tempCallPlanDetail){
                            list_callPlanDetailRecord.add(cpdTemp);
                        }
                    }
                    system.debug('SOrt2>>' + list_callPlanDetailRecord);
                }
            }
        }
    }
    
    
    /*************************************************************************
    ** Button Action Methods for the Save|Approve|Reject|Submit button
    *************************************************************************/
    public PageReference save(){
        // for saving teh selected information
        if(objCurrentCallPlan !=null){
            // the case to show error and not do save
            if(((objCurrentCallPlan.Status__c == 'Submitted') && (!blnisManager) )&& (!blnisClone)){
                addErrorMessage('Cannot Save: call plan has already been saved');
                return null; 
            } else{
                // try inserting records for different cases of button pressed
                try{
                    // for save
                    if(blnisSaveFlag){
                        update objCurrentCallPlan;
                    } else if(blnisSubmitFlag){
                        objCurrentCallPlan.status__c = 'Submitted';
                        update objCurrentCallPlan;
                    } else if(blnisApproveFlag){
                        if(objUser!=null){
                            if(objUser.Email!=null){
                                //sending mail to user in case rejected
                                String[] list_email = new List<string>();
                                list_email.add(objUser.email);
                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                Messaging.SendEmailResult[] resultsatt=null;
                                mail.setToAddresses(list_email); // Email To Other Attendees and Acument/Partner Attendees
                                mail.setSubject('Call Plan Approved');
                                mail.setHtmlBody('Your Call Plan : '  + objCurrentCallPlan.name  + ' , has been <b>Approved</b>.');
                                Messaging.SendEmailResult[] resultConfirm =Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                            } else{
                                addErrorMessage('Cannot Send Email to record owner : No email found');
                            }
                        } else{
                            addErrorMessage('Error: No user found');
                        }
                        objCurrentCallPlan.status__c = 'Approved';
                        update objCurrentCallPlan;
                    } else if(blnisRejectFlag){
                        if(objUser!=null){
                            if(objUser.Email!=null){
                                //sending mail to user in case rejected
                                String[] list_email = new List<string>();
                                list_email.add(objUser.email);
                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                Messaging.SendEmailResult[] resultsatt=null;
                                mail.setToAddresses(list_email); // Email To Other Attendees and Acument/Partner Attendees
                                mail.setSubject('Call Plan Rejected');
                                mail.setHtmlBody('Your Call Plan : '  + objCurrentCallPlan.name  + ' , has been <b>Rejected</b>.');
                                Messaging.SendEmailResult[] resultConfirm =Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                            } else{
                                addErrorMessage('Cannot Send Email to record owner : No email found');
                            }
                        } else{
                            addErrorMessage('Error: No user found');
                        }
                        objCurrentCallPlan.status__c = 'Rejected';
                        update objCurrentCallPlan;
                    }
                } catch(Exception E){
                
                    //catching exception
                    blnisException = true;
                    String strError = '';
                    strError += E;
                    addErrorMessage(strError);
                    
                }
                //insertin gin case no exception
                if(!blnisException){
                    if(list_callPlanDetailRecord!=null){
                        if(list_callPlanDetailRecord.size() >0){
                            list_callPlanDetailInsert = new List<Call_Plan_Detail__c>();
                            for(CallPlanDetail cpd: list_callPlanDetailRecord){
                                Integer intCount = 0;
                                for(days dd : cpd.list_objDays){
                                    if(dd.blnisbSelected){
                                        objCallPlanDetail = new Call_Plan_Detail__c();
                                        objCallPlanDetail.RecordTypeId = idRecordTypeCallPlanDetail;
                                        objCallPlanDetail.Physician_Name__c = cpd.objContact.Id;
                                        objCallPlanDetail.Call__c = true;
                                        objCallPlanDetail.Call_Plan__c = objCurrentCallPlan.Id;
                                        if(blnisClone)
                                            objCallPlanDetail.Date__c = datClonedMonthStartDate.addDays(intCount);
                                        else
                                            objCallPlanDetail.Date__c = datMonthStartDate.addDays(intCount);
                                            
                                        if(map_ContactId_MapOfDateAndCallPlanDetail != null){
                                            if(map_ContactId_MapOfDateAndCallPlanDetail.size() >0){
                                                if(map_ContactId_MapOfDateAndCallPlanDetail.containsKey(objCallPlanDetail.Physician_Name__c)){
                                                    if(map_ContactId_MapOfDateAndCallPlanDetail.get(objCallPlanDetail.Physician_Name__c).containsKey(objCallPlanDetail.Date__c)){
                                                        
                                                        if(map_ContactId_MapOfDateAndCallPlanDetail.get(objCallPlanDetail.Physician_Name__c).get(objCallPlanDetail.Date__c).Joint_Call__c != null)
                                                            objCallPlanDetail.Joint_Call__c = map_ContactId_MapOfDateAndCallPlanDetail.get(objCallPlanDetail.Physician_Name__c).get(objCallPlanDetail.Date__c).Joint_Call__c;
                                                            
                                                        if(map_ContactId_MapOfDateAndCallPlanDetail.get(objCallPlanDetail.Physician_Name__c).get(objCallPlanDetail.Date__c).Call_Objective__c != null)
                                                            objCallPlanDetail.Call_Objective__c = map_ContactId_MapOfDateAndCallPlanDetail.get(objCallPlanDetail.Physician_Name__c).get(objCallPlanDetail.Date__c).Call_Objective__c;
                                                    }
                                                }
                                                
                                            }
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
                                //approval process creating physician visit records
                                if(blnisApproveFlag)
                                {
                                    Physician_Visit__c objPhyVisit;
                                    list_insertPhysicianVisit = new List<Physician_Visit__c>();
                                    for(Call_Plan_Detail__c cpd:list_callPlanDetailInsert)
                                    {
                                        objPhyVisit = new Physician_Visit__c();
                                        objPhyVisit.OwnerId =objCallPlan.OwnerId;
                                        objPhyVisit.RecordTypeId = idRecordTypePhysicianVisit;
                                        objPhyVisit.Physician__c = cpd.Physician_name__c;
                                        objPhyVisit.Activity_Date__c = cpd.Date__c;
                                        objPhyVisit.Status__c = 'Open';
                                        objPhyVisit.Planned_Call__c = TRUE;
                                        objPhyVisit.Joint_Call_With_ASM__c = cpd.Joint_Call__c;
                                        objPhyVisit.Call_Objective__c = cpd.Call_Objective__c;
                                        
                                        list_insertPhysicianVisit.add(objPhyVisit);
                                    }
                                    if(list_insertPhysicianVisit.size() > 0)
                                        insert list_insertPhysicianVisit;
                                        
                                }
                            }
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
    ** Method for psoting error message
    *************************************************************************/
    public PageReference addErrorMessage(String error){
        blnisShowGo = false;
        blnisDisplayCallPlanDetail = false;
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
        String strMonth1 = MAP_MONTHNO_MONTHNAME.get(datReferenceDate1.month());
        String strMonth2;
        if(datReferenceDate1.month() != 12)
                strMonth2 = MAP_MONTHNO_MONTHNAME.get(datReferenceDate2.month());
        
        if(strMonth1 != null)      
            list_options.add(new selectOption(strMonth1,strMonth1));
        
        if(strMonth2 != null)      
            list_options.add(new selectOption(strMonth2,strMonth2));
            
        return list_options;
    }
    
    /*************************************************************************************
    ** Method for obtaining start date for specified year, currently not used , hardcoded
    *************************************************************************************/
    public  Date getYearStartDate(Date datRefDate){
        Date datReturnDate = null;
        Map<Integer, Date> map_number_yearStartDate = new Map<Integer, Date>();
        
        List<FiscalYearSettings> list_yearSettings = [Select f.EndDate, f.Name, f.StartDate from FiscalYearSettings f order by f.name];
        
        Integer j=1;
        for (FiscalYearSettings yearSetting : list_yearSettings){
            map_number_yearStartDate.put(j, yearSetting.StartDate);
            j++;
        }
        
        //map_number_yearStartDate.put(1, Date.newInstance(2008, 12, 22));
        //map_number_yearStartDate.put(2, Date.newInstance(2009, 12, 21));
        //map_number_yearStartDate.put(3, Date.newInstance(2010, 12, 20));
        //map_number_yearStartDate.put(4, Date.newInstance(2011, 12, 19));
        
        
        for (Integer i=1; i<=map_number_yearStartDate.size(); i++){
            Date datStartDate = map_number_yearStartDate.get(i);
            //if (startDate.daysBetween(System.today())<364){
            if (datStartDate.daysBetween(datRefDate)<364){
                datReturnDate = datStartDate;
                break;
            }
        }   
        return datReturnDate;
    }
    /*************************************************************************
    ** Method for obtaining start date for the rbd month
    *************************************************************************/
    
    public  Date getMonthStartDate(String Month ,Date datRefDate){
        Integer intMonthNo = MAP_MONTHNAME_MONTHNO.get(Month);
        //Date datYearStart = getYearStartDate(datRefDate);
        Date datYearStart = MAP_YEAR_YEARSTARTDATE.get(datRefDate.year());
        if(datYearStart !=null){
            intMonthNo = intMonthNo - 1;
            if (intMonthNo == 0) return datYearStart;
            Integer intQuaters = intMonthNo/3;
            Integer intMonthsThisQuarter = Math.mod(intMonthNo, 3);
            Integer intDays = intQuaters * intQuarterDays;
            if (intMonthsThisQuarter==1) intDays+=28;
            else if (intMonthsThisQuarter==2) intDays+=56;
            return  datYearStart.addDays(intDays);
        } else{
            addErrorMessage('Please select Year prior to 2013 , cannot plan for that year');
            return null;
        }
    }
    
    /*************************************************************************
    ** Method for obtaining no . of days in an RBD month
    *************************************************************************/
    
    public  Integer daysInMonths(Integer intMonthNo){
        Integer intDays = 28;
        if (Math.mod(intMonthNo,3)==0) intDays = 35;
        return intDays; 
    }
}