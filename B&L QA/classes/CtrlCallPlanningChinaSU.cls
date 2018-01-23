/**
* 
* This is the controller for the call planning page for China SU
* Test class name: Test_CtrlCallPlanningChinaSU
* Author                     |Author-Email                               |Date        |Comment
* ---------------------------|-------------------------------------------|------------|----------------------------------------------------
* Sourav Mitra               |sourav.mitra@listertechnologies.com        |18.08.2010  |First Draft for call plan page for China Surgical
* Saranya Sivakumar          |saranya.sivakumar@listertechnologies.com   |27.10.2010  |Changed the redirect of Details Button 
* Santosh Kumar S            |santosh.sriram@listertechnologies.com      |26.11.2010  |Changed the URL in redirection of Details Button to country = APACSU
* Santosh Kumar S            |santosh.sriram@listertechnologies.com      |27.01.2011  |Changes - Manager Creating a call plan.
* Santosh Kumar S            |santosh.sriram@listertechnologies.com      |14.02.2011  |Changes - To fix issues raised in Internal Testing.
* Sanjib Manahta             |sanjib.mahanta@bausch.com                  |19.08.2011  |Changes - To create the Physician Visit record for INDIA SU. 
* RavitejaKumar Vakity       |raviteja.vakity@bausch.com                 |15-Nov-2012 |Changes - Added the Area, Hospital Filter condition in the call plan page 
* RavitejaKumar Vakity       |raviteja.vakity@bausch.com                 |19.11.2013 | Checked User's Role to hide excecutive/manager comments for India User
*/
public class CtrlCallPlanningChinaSU
{    
    /*************************************************************************
    ** Variable Declerations
    *************************************************************************/
  
    //to populate the callPlan record information along with the detail  incase of new,edit or clone
    public CallPlan objCurrentCallPlan {get; set;}
    public CallPlan objCurrentCallPlandisplay { get; set;} 
    // current call plan record
    public Call_Plan__c  objCallPlan {get; set;}

    //instance of call plan detail records
    public Call_Plan_Detail__c objCallPlanDetail;
    //instance of a user
    public User objUser {get; set;}
    
    //for showing the detail button
    public Boolean blnisShowDetail { get; set;}
    
    //start date of a RBD month
    public date datWeekStartDate ;
    //end date of a RBD month
    public date datWeekEndDate ;
    //reference date
    public Date datRefDate;
    
    //id of the call plan
    public Id idCallPlan ;
    
    //filter of the call plan
    public string getHospital{get;set;}
    public string getArea{get;set;}
    public List<String> Hospitalname{get;set;}
    public set<string> areanames;  
    public string errormsg {get; set;}
    //temp list of dates            
    public List<Date> list_tempDates ;
    //list of user accounts
    public Set<Id> set_UserAccounts;
    // list of accounts pertainign to call plan detail
    public List<Call_Plan_Detail__c> list_contactsCallPlanDetail;
    //list of account team member accounts
    public List<AccountTeamMember> list_accountsForOwner;
    // list of account profiles
    public List<Account> list_userAccounts;
    //list of call plan detail records
    public List<Call_Plan_Detail__c> list_callPlanDetailRecords ;   
    // custom list of custom class clann plan detail    
    public List<CallPlanDetail> list_callPlanDetail;
    
    //list of physician visits
    public List<Physician_Visit__c> list_insertPhysicianVisit;
    
    // custom list of custom class call plan detail Tier 1
    public List<CallPlanDetail> list_tempCallPlanDetailTier1 = new List<CallPlanDetail>();
    
    // custom list of custom class call plan detail Tier 2
    public List<CallPlanDetail> list_tempCallPlanDetailTier2 = new List<CallPlanDetail>();
    
    // custom list of custom class call plan detail Tier 3
    public List<CallPlanDetail> list_tempCallPlanDetailTier3 = new List<CallPlanDetail>();
    
    // custom list of custom class call plan detail Tier 4
    public List<CallPlanDetail> list_tempCallPlanDetailTier4 = new List<CallPlanDetail>();
    
    // custom list of custom class call plan detail Tier 5
    public List<CallPlanDetail> list_tempCallPlanDetailTier5 = new List<CallPlanDetail>();
    
    // Map for Tier 1 type Accounts
    public Map<Id,Account> map_Tier1AccountId_Tier1AccountName;
    
    // Map for Tier 2 type Accounts
    public Map<Id,Account> map_Tier2AccountId_Tier2AccountName;
    
    // Map for Tier 3 type Accounts
    public Map<Id,Account> map_Tier3AccountId_Tier3AccountName;
    
    // Map for Tier 4 type Accounts
    public Map<Id,Account> map_Tier4AccountId_Tier4AccountName;
    
    // Map for Tier 5 type Accounts
    public Map<Id,Account> map_Tier5AccountId_Tier5AccountName;
    
    // list of call plan detail records to be inserted
    public List<CallPlanDetail> list_forInsert = new List<CallPlanDetail>();
    //list of custom class days
    public List<days> list_tempDays = new List<days>();

    // list of call plan detail records to be inserted
    public List<Call_Plan_Detail__c> list_callPlanDetailInsert;
    
    //map of account ids and list of call plan detail records
    public Map<Id,List<Call_Plan_Detail__c>> map_ContactId_ListOfCallPlanDetail;
    //map of contact id and map of date to call plan detail record
    public Map<Id,Map<Date,Call_Plan_Detail__c>> map_ContactId_MapOfDateAndCallPlanDetail;
    // map of date to call plan detail record
    public Map<Date,Call_Plan_Detail__c> map_Date_CallPlanDetail;
    // account map
    public Map<Id,Account> map_account = new Map<Id,Account>();
    // contact map
    public Map<Id,Contact> map_contact = new Map<Id,Contact>();
        
    public String strWeek {get; set;}
    
    // boolean for checking if save button pressed
    public Boolean blnisSaveFlag{ get; set;}
    // boolean for checking if submit button pressed
    public Boolean blnisSubmitFlag{ get; set;}
    // boolean for checking if approve button pressed
    public Boolean blnisApproveFlag{ get; set;}
    // boolean for checking if reject button pressed
    public Boolean blnisRejectFlag{ get; set;}
    
    //checking if namager profile
    public Boolean blnisManager { get ;set;}

    // checking id classification exists
    public Boolean blnisNoClassification;
    // disableing the input checkboxes
    public Boolean blnisDisable { get; set;}
    
    //added to check if the Users is India Sales Rep or Manager - to hide excecutive/manager comments 
    public Boolean blnCheckRole{get; set;}

    // for checking if exception occurs
    public Boolean blnisException = false;
    public Boolean blnAreaLabel = false;
    
    // record type ids for different record types
    public Id idRecordTypePhysicianVisit;
    
    public UserRole objUserRole;
    public Profile objUserProfile;
    
    /*************************************************************************
    ** Custom Classes : for storing callplan level information
    *************************************************************************/
    public class CallPlan
    {
        public Call_Plan__c objCallPln { get; set;}
        public List<CallPlanDetail> list_callPlanDetailTier1 {get; set;}
        public List<CallPlanDetail> list_callPlanDetailTier2 {get; set;}
        public List<CallPlanDetail> list_callPlanDetailTier3 {get; set;}
        public List<CallPlanDetail> list_callPlanDetailTier4 {get; set;}
        public List<CallPlanDetail> list_callPlanDetailTier5 {get; set;}
        public List<Date> list_RBDmonthDates {get; set;}
        
        public CallPlan()
        {
            objCallPln = new Call_Plan__c();
            list_callPlanDetailTier1 = new List<CallPlanDetail>();
            list_callPlanDetailTier2 = new List<CallPlanDetail>();
            list_callPlanDetailTier3 = new List<CallPlanDetail>();
            list_callPlanDetailTier4 = new List<CallPlanDetail>();
            list_callPlanDetailTier5 = new List<CallPlanDetail>();
            list_RBDmonthDates = new List<Date>();
        }
    }
    
    
    
    /*************************************************************************
    ** Custom Classes : for storing callplan Detail level information
    *************************************************************************/
    public class CallPlanDetail
    {
        public String strAccountName {get; set;}
        public String strContactName {get; set;}
        public Id idAccount {get; set;}
        public Id idContact {get; set;}
        public String strClassification {get; set;}
        public Account_Profile__c objAccProfile {get; set;}
        public List<days> list_objDays {get; set;} 
        public String strProvince {get; set;}
         public String strArea {get; set;}
        public CallPlanDetail()
        {
            strAccountName = '';
            list_objDays = new List<days>();
            strClassification = '';
            strProvince = '';
            strArea = '';
            objAccProfile = new Account_Profile__c();
        }
    }
    
    CallPlanDetail cpd = new CallPlanDetail();
    
    /*************************************************************************
    ** Custom Classes : for storing days checked 
    *************************************************************************/
    public class days
    {
        public boolean blnisbSelected {get; set;}
        
        public days()
        {
            blnisbSelected = false;
        }
    }
    
    days dd = new days();
    
    /*************************************************************************
    ** Constructor
    *************************************************************************/
    public CtrlCallPlanningChinaSU()
    {       
        // initilaizing values
        blnisShowDetail = false;
        blnisSaveFlag = false;
        blnisSubmitFlag= false;
        blnisApproveFlag= false;
        blnisRejectFlag = false;
        blnisManager = false;
        blnisDisable = false;
        //blnError = false;
        areanames = new set<string>();   
        errormsg = ''; 
        objCurrentCallPlan = new CallPlan();
        User objManager;
        //getting the parameters from the url
        idCallPlan =  ApexPages.currentPage().getParameters().get('id');
        blnCheckRole = true;
        System.debug(idCallPlan);
        
        //getting user information
        String strTypeOfUserId = UserInfo.getUserId();
        
        User objTypeOfUser = [Select Id,name,UserRoleId,ProfileId,ManagerId from User where id =:strTypeOfUserId ];
        
        
        if(objTypeOfUser.UserRoleId!=null){
            objUserRole = [Select Id,name from userRole where id=:objTypeOfUser.UserRoleId];
            objUserProfile = [SELECT Name, Id FROM Profile where id =: objTypeOfUser.ProfileId];
            //disable for India and thailand
            if(objUserRole.Name.Contains('INDSU') || objUserRole.Name.Contains('INDAES') || objUserRole.Name.Contains('THASU')){
                blnCheckRole = false;
            }
        
        }
            System.debug('RoleSU'+objUserRole);
            System.debug('ProfileSu=='+objUserProfile);  
        if(objUserProfile.Name.contains('THASU Sales')){
             idRecordTypePhysicianVisit = [SELECT Id FROM RecordType 
                                        WHERE Name = 'THASU Sales Planned'  AND SObjectType='Physician_Visit__c'].Id;
        }
        else if(objUserProfile.Name.contains('THASU Service')){
             idRecordTypePhysicianVisit = [SELECT Id FROM RecordType 
                                        WHERE Name = 'THASU Service Planned'  AND SObjectType='Physician_Visit__c'].Id;
        }
        else{   
        idRecordTypePhysicianVisit = [SELECT Id FROM RecordType 
                                        WHERE Name = 'APACSU Sales Planned'  AND SObjectType='Physician_Visit__c'].Id;
        }
            
        map_Tier1AccountId_Tier1AccountName = new Map<Id,Account>();
        map_Tier2AccountId_Tier2AccountName = new Map<Id,Account>();
        map_Tier3AccountId_Tier3AccountName = new Map<Id,Account>();
        map_Tier4AccountId_Tier4AccountName = new Map<Id,Account>();
        map_Tier5AccountId_Tier5AccountName = new Map<Id,Account>();
        
        // if the call plan id is not null then query the given call plan
        if(idCallPlan !=null)
        {
            //query the particular call plan record
            objCallPlan = [Select Id,
                                    Name,
                                    Status__c,
                                    Start_Date__c,
                                    End_Date__c,
                                    Manager_Comments__c,
                                    Executive_Comments__c,
                                    (SELECT Id FROM Call_Plan_Detail__r LIMIT 1),
                                    OwnerId From Call_Plan__c where id =:idCallPlan];
                                    
         //deciding if maanger or not
        if(objUserRole != null)
        {
            System.debug(objUserRole.name);
            System.debug(objCallPlan.ownerId);
            System.debug(UserInfo.getUserId());
            
            if((objUserProfile.Name.contains('Manager') || objUserRole.Name.contains('manager')) && objCallPlan.ownerId != UserInfo.getUserId() )
                blnisManager = true;
        }
        
        
         System.debug(objTypeOfUser.ManagerId);
           
            //querying all the accounteams to which this sales executive is a member
            // if the record exists query the related information
            if(objCallPlan !=null)
            {
                if(objCallPlan.OwnerId ==UserInfo.getUserId()){
                    List<User> managers = new List<User>();
                    managers = [Select Id, Name, Email From User where Id =: objTypeOfUser.ManagerId limit 1];
                    if(managers!=NULL && !managers.isEmpty())
                     objManager = managers[0];
                    else{
                        addErrorMessage(Label.APACSU_Manager_Is_Not_Available);
                        return ;               
                    }
                }
                
                    
                    
                if(objCallPlan.Call_Plan_Detail__r.size() > 0)
                    blnisShowDetail = true;
                    
                if(objCallPlan.status__c!=null)
                {
                    if((!blnisManager && objCallPlan.status__c == 'Submitted') ||
                    (blnisManager && objCallPlan.status__c =='Draft'&& objCallPlan.ownerId != UserInfo.getUserId()) ||
                    (objCallPlan.status__c =='Approved')|| 
                    (objCallPlan.status__c =='Rejected') ||
                    (blnisManager && objCallPlan.status__c =='Submitted'&& objCallPlan.ownerId == UserInfo.getUserId()))
                        blnisDisable = true;
                }
                
                // user pertaining to that record
                objUser = [Select Id,Name,userRoleId,email from User where id = :objCallPlan.OwnerId];
                list_accountsForOwner = [select Id,AccountId,UserId from AccountTeamMember where UserId =:objCallPlan.OwnerId];
                
                // accounts for that record                  
                if(list_accountsForOwner.size()>0)
                {
                    //creating a list of those account Ids
                    set_UserAccounts = new Set<Id>();
                    for(AccountTeamMember accMem : list_accountsForOwner)
                        set_UserAccounts.add(accMem.AccountId);
                        
                
                    // querying the Accounts for the strClassification information 
                    map_account = new Map<Id,Account>([SELECT Id,
                                            Name,
                                            BillingState,
                                            (SELECT Area__c,Region__c,Segmentation__c FROM Account_Profiles__r LIMIT 1), 
                                            (SELECT Id,Name,AccountId FROM Contacts ORDER BY Name)
                                            FROM Account WHERE Id IN :set_UserAccounts ORDER BY Name]);
                                                
                    list_userAccounts = map_account.values();
                    
                    system.debug('****list_userAccounts ' + list_userAccounts);
                    
                    if(list_userAccounts.size()>0)
                    {
                        
                        // for mapping the strClassification and respectve names of the accounts
                        for(Account accObj :list_userAccounts)
                        {
                            system.debug('***accObj.Account_Profiles__r.Segmentation__c --' + accObj.Account_Profiles__r[0].Segmentation__c);
                            if(accObj.Account_Profiles__r.size() > 0 && accObj.Account_Profiles__r[0].Segmentation__c !=null)
                            {
                                String strSegment = accObj.Account_Profiles__r[0].Segmentation__c;
                                if(accObj.Account_Profiles__r[0].Area__c != null){
                                    areanames.add(accObj.Account_Profiles__r[0].Area__c);}                                
                                if(strSegment == 'Tier 1')
                                    map_Tier1AccountId_Tier1AccountName.put(accObj.Id,accObj);
                                    
                                else if(strSegment == 'Tier 2')
                                    map_Tier2AccountId_Tier2AccountName.put(accObj.Id,accObj);
                                    
                                else if(strSegment == 'Tier 3')
                                    map_Tier3AccountId_Tier3AccountName.put(accObj.Id,accObj);
                                    
                                else if(strSegment == 'Tier 4')
                                    map_Tier4AccountId_Tier4AccountName.put(accObj.Id,accObj);
                                    
                                else if(strSegment == 'Tier 5')
                                    map_Tier5AccountId_Tier5AccountName.put(accObj.Id,accObj);
                                    
                                for(Contact conObj:accObj.Contacts)
                                    map_contact.put(conObj.Id,ConObj);
                            }
                        }
                        // for the given call plan having queryied all the necessary information in case of new /edit we now see if call plan detail information exists 
                        // for the call plan and if it does we map that information to the interface
                        
                        // getting the start and end dates for a particular call plan

                        datRefDate = objCallPlan.Start_Date__c;
                        datWeekStartDate = objCallPlan.Start_Date__c;
                        datWeekEndDate = objCallPlan.End_Date__c;
                        System.debug(' objCallPlan.Start_Date__c : '+objCallPlan.Start_Date__c );
                        System.debug(' objCallPlan.End_Date__c : '+objCallPlan.End_Date__c ); 
                        strWeek = ClsSingleMultiUtility.getDisplayWeek(objCallPlan.Start_Date__c, objCallPlan.End_Date__c); 
                        System.debug(' strWeek  : '+strWeek  ); 
                        createCallPlanRecords();       
                        objCurrentCallPlandisplay = objCurrentCallPlan;  
                    } 
                    
                    else
                        addErrorMessage('Account Profile information not available for the given user.');
                } 
                
                else
                    addErrorMessage('Given Sales Executive is not part of any Account teams');

            } 
            else
                addErrorMessage('No call Plan exsists for the given Id');

        } 
        else
            addErrorMessage('Invalid call plan selected');
    }
    

    /*************************************************************************
    ** Button Action Methods for the Save|Approve|Reject|Submit button
    *************************************************************************/
    public PageReference save()
    {
        // for saving the selected information
        if(objCurrentCallPlan.objCallPln!=null)
        {
            // the case to show error and not do save
            if(((objCurrentCallPlan.objCallPln.Status__c == 'Submitted') && (!blnisManager) ))
            {
                addErrorMessage('Cannot Save: call plan has already been saved');
                return null; 
            } 
            else
            {
                // try inserting records for different cases of button pressed
                try
                {
                    // for save
                    if(blnisSaveFlag)
                        update objCurrentCallPlan.objCallPln;
                        
                    else if(blnisSubmitFlag)
                    {
                        objCurrentCallPlan.objCallPln.status__c = 'Submitted';
                        update objCurrentCallPlan.objCallPln;
                    } 
                    else if(blnisApproveFlag)
                    {
                        objCurrentCallPlan.objCallPln.status__c = 'Approved';
                        update objCurrentCallPlan.objCallPln;
                    } 
                    else if(blnisRejectFlag)
                    {
                        /*
                        if(objUser!=null)
                        {
                            if(objUser.Email!=null)
                            {
                                //sending mail to user in case rejected
                                String[] list_email = new List<string>();
                                list_email.add(objUser.email);
                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                Messaging.SendEmailResult[] resultsatt=null;
                                mail.setToAddresses(list_email); // Email To Other Attendees and Acument/Partner Attendees
                                mail.setSubject('Call Plan Rejected');
                                mail.setHtmlBody('Your Call Plan : '  + objCurrentCallPlan.objCallPln.name  + ' , has been <b>Rejected</b>.');
                                Messaging.SendEmailResult[] resultConfirm =Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                            } 
                            else
                                addErrorMessage('Cannot Send Email to record owner : No email found');
                        } 
                        else
                            addErrorMessage('Error: No user found');
                        */
                        
                        objCurrentCallPlan.objCallPln.status__c = 'Rejected';
                        update objCurrentCallPlan.objCallPln;
                    }
                } 
                catch(Exception E)
                {
                    blnisException = true;
                    System.debug('exception caught is >>>>>>>>'+E);
                    addErrorMessage(E.getMessage());  
                }
                
                //inserting in case no exception
                if(!blnisException)
                {
                    list_forInsert = new List<CallPlanDetail>();
                    for(CallPlanDetail cpd :objCurrentCallPlan.list_callPlanDetailTier1)
                        list_forInsert.add(cpd);

                    for(CallPlanDetail cpd :objCurrentCallPlan.list_callPlanDetailTier2)
                        list_forInsert.add(cpd);

                    for(CallPlanDetail cpd :objCurrentCallPlan.list_callPlanDetailTier3)
                        list_forInsert.add(cpd);

                    for(CallPlanDetail cpd :objCurrentCallPlan.list_callPlanDetailTier4)
                        list_forInsert.add(cpd);
                        
                    for(CallPlanDetail cpd :objCurrentCallPlan.list_callPlanDetailTier5)
                        list_forInsert.add(cpd);

                    if(list_forInsert.size() >0)
                    {
                        list_callPlanDetailInsert = new List<Call_Plan_Detail__c>();
                        for(CallPlanDetail cpd: list_forInsert)
                        {
                            Integer intCount = 0;
                            for(days dd : cpd.list_objDays)
                            {
                                if(dd.blnisbSelected)
                                {
                                    objCallPlanDetail = new Call_Plan_Detail__c();
                                    objCallPlanDetail.Physician_Name__c = cpd.idContact;
                                    objCallPlanDetail.Call__c = true;
                                    objCallPlanDetail.Call_Plan__c = idCallPlan;
                                    objCallPlanDetail.Date__c = datWeekStartDate.addDays(intCount);

                                    if(blnisShowDetail)
                                    {
                                        if(map_ContactId_MapOfDateAndCallPlanDetail.containsKey(cpd.idContact) && map_ContactId_MapOfDateAndCallPlanDetail.get(cpd.idContact).containsKey(objCallPlanDetail.Date__c))
                                        {
                                            objCallPlanDetail.Call_Objective__c = map_ContactId_MapOfDateAndCallPlanDetail.get(cpd.idContact).get(objCallPlanDetail.Date__c).Call_Objective__c;
                                            objCallPlanDetail.Joint_Call__c = map_ContactId_MapOfDateAndCallPlanDetail.get(cpd.idContact).get(objCallPlanDetail.Date__c).Joint_Call__c;
                                             if(objUserRole.name.contains('INDAES'))
                                             {
                                                 // Added conditin for india Aesthetic
                                                objCallPlanDetail.AES_Product1__c = map_ContactId_MapOfDateAndCallPlanDetail.get(cpd.idContact).get(objCallPlanDetail.Date__c).AES_Product1__c;
                                                objCallPlanDetail.AES_Product2__c = map_ContactId_MapOfDateAndCallPlanDetail.get(cpd.idContact).get(objCallPlanDetail.Date__c).AES_Product2__c;                                            
                                             }
                                             else
                                             {
                                                //added to India Users
                                                objCallPlanDetail.Product1__c = map_ContactId_MapOfDateAndCallPlanDetail.get(cpd.idContact).get(objCallPlanDetail.Date__c).Product1__c;
                                                objCallPlanDetail.Product2__c = map_ContactId_MapOfDateAndCallPlanDetail.get(cpd.idContact).get(objCallPlanDetail.Date__c).Product2__c;
                                            }
                                            
                                            objCallPlanDetail.Remarks__c = map_ContactId_MapOfDateAndCallPlanDetail.get(cpd.idContact).get(objCallPlanDetail.Date__c).Remarks__c;
                                            objCallPlanDetail.OT_Hours__c = map_ContactId_MapOfDateAndCallPlanDetail.get(cpd.idContact).get(objCallPlanDetail.Date__c).OT_Hours__c;
                                        }
                                    }
                                    
                                    list_callPlanDetailInsert.add(objCallPlanDetail);
                                }
                                intCount++;
                            }
                            
                        }
                        
                        // deleting old records and inserting new ones
                        if(list_callPlanDetailInsert.size() > 0)
                        {
                            //delete old exsisting records
                            if(list_callPlanDetailRecords.size() >0)
                                delete list_callPlanDetailRecords;
                            
                            //insert new records
                            insert list_callPlanDetailInsert;  
                        }
                        
                        //approval process creating physician visit records
                        if(blnisApproveFlag)
                        {
                            Physician_Visit__c objPhyVisit;
                            list_insertPhysicianVisit = new List<Physician_Visit__c>();
                            Id RecordId = [SELECT Id FROM RecordType 
                                        WHERE Name = 'INDSU Sales Planned'  AND SObjectType='Physician_Visit__c'].Id;
                            
                            String strTypeOfUserId = UserInfo.getUserId();
        
                            User objTypeOfUser = [Select Id,name,UserRoleId,ManagerId from User where id =:strTypeOfUserId ];
        
        
                            if(objTypeOfUser.UserRoleId!=null)
                            objUserRole = [Select Id,name from userRole where id=:objTypeOfUser.UserRoleId];
            
                            System.debug('RoleSU'+objUserRole);
                            for(Call_Plan_Detail__c cpd:list_callPlanDetailInsert)
                            {
                                objPhyVisit = new Physician_Visit__c();
                                objPhyVisit.OwnerId =objCallPlan.OwnerId;
                                 
                                if(objUserRole != null)
                                {
                                    System.debug(objUserRole.name);
                                    System.debug(objCallPlan.ownerId);
                                    System.debug(UserInfo.getUserId());
                                    
                                    if((objUserRole.name.contains('INDSU') || objUserRole.name.contains('INDAES')) && objCallPlan.ownerId != UserInfo.getUserId() )
                                       { 
                                        System.debug('InsidetestRoleSU'+objUserRole.name);
                                        objPhyVisit.RecordTypeId = RecordId;
                                        System.debug('InsidetestRoleSU'+objPhyVisit.RecordTypeId);
                                        objPhyVisit.Physician__c = cpd.Physician_name__c;
                                        objPhyVisit.Activity_Date__c = cpd.Date__c;
                                        objPhyVisit.Status__c = 'Open';
                                        objPhyVisit.Planned_Call__c = TRUE;
                                        objPhyVisit.Joint_Call_With_ASM__c = cpd.Joint_Call__c;
                                        //objPhyVisit.Call_Objective__c = cpd.Call_Objective__c;
                                        objPhyVisit.Call_Ojective_CHN__c = cpd.Call_Objective__c;
                                        
                                        //Added to put Products and OT Hours Values 
                                        objPhyVisit.OT_Hours__c = cpd.OT_Hours__c;
                                        if(objUserRole.name.contains('INDAES'))
                                        {
                                        //Added condition for India Aesthetic--Tarun Solanki
                                        objPhyVisit.Product_1__c = cpd.AES_Product1__c;
                                        objPhyVisit.Product_2__c = cpd.AES_Product2__c;                                        
                                        }
                                        else
                                        {
                                        objPhyVisit.Product_1__c = cpd.Product1__c;
                                        objPhyVisit.Product_2__c = cpd.Product2__c;
                                        }
                                        
                                        objPhyVisit.Remarks__c = cpd.Remarks__c;                                       
                                        list_insertPhysicianVisit.add(objPhyVisit);
                                       }
                                       
                                       else{
                                        objPhyVisit.RecordTypeId = idRecordTypePhysicianVisit;
                                        objPhyVisit.Physician__c = cpd.Physician_name__c;
                                        objPhyVisit.Activity_Date__c = cpd.Date__c;
                                        objPhyVisit.Status__c = 'Open';
                                        objPhyVisit.Planned_Call__c = TRUE;
                                        objPhyVisit.Joint_Call_With_ASM__c = cpd.Joint_Call__c;
                                        //objPhyVisit.Call_Objective__c = cpd.Call_Objective__c;
                                        objPhyVisit.Call_Ojective_CHN__c = cpd.Call_Objective__c;
                                        list_insertPhysicianVisit.add(objPhyVisit);
                                               
                                       }
                                }
                                
                            }
                            if(list_insertPhysicianVisit.size() > 0)
                                insert list_insertPhysicianVisit;
                                
                        }
                    }
                    
                    blnisSaveFlag = false;
                    blnisSubmitFlag= false;
                    blnisApproveFlag= false;
                    blnisRejectFlag = false;
                    PageReference pg;

                    pg = new pageReference('/' + idCallPlan);

                    return pg;
                }
                
                else
                {
                    blnisSaveFlag = false;
                    blnisSubmitFlag= false;
                    blnisApproveFlag= false;
                    blnisRejectFlag = false;
                    return null;
                }
            }
        }
        else
            return null;
    }
    
    /*************************************************************************
    ** Method call for creating required records
    *************************************************************************/
    public void createCallPlanRecords()
    {
        //initializing call plan record
        objCurrentCallPlan = new CallPlan();

        objCurrentCallPlan.objCallPln = objCallPlan;
       
        list_tempDates = new List<Date>();
        for(Date d = datWeekStartDate; d <= datWeekEndDate ;)
        {
            list_tempDates.add(d);
            d = d.addDays(1);
        }
        
        // querying if call plan detauil records exists
        list_callPlanDetailRecords = new List<Call_Plan_Detail__c>();
        //Modified query for OT Hours, Product Details.
        list_callPlanDetailRecords = [Select Id,
                                        Physician_Name__c,
                                        Physician_Name__r.AccountId,
                                        Call_Plan__c,
                                        Joint_Call__c,
                                        Call_Objective__c,
                                        OT_Hours__c,
                                        Product1__c,
                                        Product2__c,
                                        AES_Product1__c,
                                        AES_Product2__c,
                                        Remarks__c,
                                        Date__c From Call_Plan_Detail__c where Call_Plan__c =:idCallPlan 
                                                                        AND Date__c >=  :datWeekStartDate
                                                                            AND Date__c <= :datWeekEndDate ORDER BY Physician_Name__r.Account.Name,Physician_Name__r.Name];
                                                                            
        //adding the list of dates
        objCurrentCallPlan.list_RBDmonthDates  = list_tempDates;
        
        if(list_callPlanDetailRecords.size() >0)
        {
            // mapping existing call plan detail records to contacts for which they exist
            map_ContactId_ListOfCallPlanDetail = new Map<Id,List<Call_Plan_Detail__c>>();
            map_ContactId_MapOfDateAndCallPlanDetail = new Map<Id,Map<Date,Call_Plan_Detail__c>>();
            // for all the accounts mapping the detail records with the respective accounts
            for(Account accObj :list_userAccounts)
            {
                for(Contact conObj : accObj.Contacts)
                {
                    list_contactsCallPlanDetail = new List<Call_Plan_Detail__c>();
                    for(Call_Plan_Detail__c cpd :list_callPlanDetailRecords)
                    {
                        if(cpd.Physician_Name__c == conObj.Id)
                            list_contactsCallPlanDetail.add(cpd);
                    }
                    
                    // creating a map of the accounts to a collection of the detail records which have been mapped to their dates
                    map_Date_CallPlanDetail = new Map<Date,Call_Plan_Detail__c>();
                    
                    for(Call_Plan_Detail__c cp : list_contactsCallPlanDetail)
                        map_Date_CallPlanDetail.put(cp.Date__c,cp);
                    
                    map_ContactId_ListOfCallPlanDetail.put(conObj.Id,list_contactsCallPlanDetail);  
                    map_ContactId_MapOfDateAndCallPlanDetail.put(conObj.Id,map_Date_CallPlanDetail);
                }
            }
            
            System.debug('<<<<<<<< map_ContactId_ListOfCallPlanDetail = ' + map_ContactId_ListOfCallPlanDetail);
            System.debug('<<<<<<<< map_ContactId_MapOfDateAndCallPlanDetail = ' + map_ContactId_MapOfDateAndCallPlanDetail);
            
            list_callPlanDetail = new List<CallPlanDetail>();
            // creating custom class records
            for(Id conId : map_ContactId_ListOfCallPlanDetail.keyset())
            {     
                //for(Call_Plan_Detail__c callDetailObj:map_ContactId_ListOfCallPlanDetail.get(conId))
                //{
                    cpd = new CallPlanDetail();
                    blnisNoClassification = false;
                    list_tempDays = new List<days>();
                    List<Date> list_refDates ;
                    
                    list_refDates = objCurrentCallPlan.list_RBDmonthDates;
                        
                     // for the List of rbd dates   
                    for(Date days : list_refDates)
                    {
                        dd = new days();
                        
                        if(map_ContactId_MapOfDateAndCallPlanDetail.get(conId).containsKey(days))
                            dd.blnisbSelected = true;
                            
                        else
                            dd.blnisbSelected = false;

                        list_tempDays.add(dd);
                    }    
                    
                    // mapping individual classification   
                    cpd.list_objDays = list_tempDays;
                    cpd.idContact = conId;
                    system.debug('-map_contact --'+map_contact );
                    if(map_contact.containsKey(conId))
                    {
                        Contact objCont = map_contact.get(conId);
                        cpd.strContactName = objCont.Name ;
                        system.debug('-objCont.AccountId --'+objCont.AccountId );
                        if(map_account.containsKey(objCont.AccountId) && map_account.get(objCont.AccountId).Account_Profiles__r.size() > 0)
                            cpd.objAccProfile = map_account.get(objCont.AccountId).Account_Profiles__r[0];
                            system.debug('-cpd.objAccProfile --'+cpd.objAccProfile );
                            
                        if(map_Tier1AccountId_Tier1AccountName.containsKey(objCont.AccountId))
                        {
                            Account temp_Account = map_Tier1AccountId_Tier1AccountName.get(objCont.AccountId);
                            cpd.idAccount = temp_Account.Id;
                            cpd.strAccountName = temp_Account.Name;
                            cpd.strProvince = temp_Account.BillingState;
                            cpd.strArea= cpd.objAccProfile.Area__C;
                            cpd.strClassification = 'Tier 1';                           
                        } 
                        else if(map_Tier2AccountId_Tier2AccountName.containsKey(objCont.AccountId))
                        {
                            Account temp_Account = map_Tier2AccountId_Tier2AccountName.get(objCont.AccountId);
                            cpd.idAccount = temp_Account.Id;
                            cpd.strAccountName = temp_Account.Name;
                            cpd.strProvince = temp_Account.BillingState;
                            cpd.strArea= cpd.objAccProfile.Area__C;
                            cpd.strClassification = 'Tier 2';
                        } 
                        else if(map_Tier3AccountId_Tier3AccountName.containsKey(objCont.AccountId))
                        {
                            Account temp_Account = map_Tier3AccountId_Tier3AccountName.get(objCont.AccountId);
                            cpd.idAccount = temp_Account.Id;
                            cpd.strAccountName = temp_Account.Name;
                            cpd.strProvince = temp_Account.BillingState;
                            cpd.strArea= cpd.objAccProfile.Area__C;
                            cpd.strClassification = 'Tier 3';
                        } 
                        else if(map_Tier4AccountId_Tier4AccountName.containsKey(objCont.AccountId))
                        {
                            Account temp_Account = map_Tier4AccountId_Tier4AccountName.get(objCont.AccountId);
                            cpd.idAccount = temp_Account.Id;
                            cpd.strAccountName = temp_Account.Name;
                            cpd.strProvince = temp_Account.BillingState;
                            cpd.strArea= cpd.objAccProfile.Area__C;
                            cpd.strClassification = 'Tier 4';
                        } 
                        else if(map_Tier5AccountId_Tier5AccountName.containsKey(objCont.AccountId))
                        {
                            Account temp_Account = map_Tier5AccountId_Tier5AccountName.get(objCont.AccountId);
                            cpd.idAccount = temp_Account.Id;
                            cpd.strAccountName = temp_Account.Name;
                            cpd.strProvince = temp_Account.BillingState;
                            cpd.strArea= cpd.objAccProfile.Area__C;
                            cpd.strClassification = 'Tier 5';
                        }
                        else
                        {
                            blnisNoClassification = true;
                        }
                    }
                    else
                        blnisNoClassification = true;
                    
                    
                    // if no strClassification then do not add that account
                    if(!blnisNoClassification)
                        list_callPlanDetail.add(cpd);
               // }
            }
            
            if(list_callPlanDetail.size() >0)
            {
                List<CallPlanDetail> list_tempCallPlanDetailTier1 = new List<CallPlanDetail>();
                List<CallPlanDetail> list_tempCallPlanDetailTier2 = new List<CallPlanDetail>();
                List<CallPlanDetail> list_tempCallPlanDetailTier3 = new List<CallPlanDetail>();
                List<CallPlanDetail> list_tempCallPlanDetailTier4 = new List<CallPlanDetail>();
                List<CallPlanDetail> list_tempCallPlanDetailTier5 = new List<CallPlanDetail>();
                for(CallPlanDetail cpd : list_callPlanDetail)
                {   
                    if(cpd.strClassification == 'Tier 1')
                        list_tempCallPlanDetailTier1.add(cpd);
                        
                    else if(cpd.strClassification == 'Tier 2')
                        list_tempCallPlanDetailTier2.add(cpd);
                        
                    else if(cpd.strClassification == 'Tier 3')
                        list_tempCallPlanDetailTier3.add(cpd);
                        
                    else if(cpd.strClassification == 'Tier 4')
                        list_tempCallPlanDetailTier4.add(cpd);
                        
                    else if(cpd.strClassification == 'Tier 5')
                        list_tempCallPlanDetailTier5.add(cpd);
                }
                objCurrentCallPlan.list_callPlanDetailTier1 = list_tempCallPlanDetailTier1;
                objCurrentCallPlan.list_callPlanDetailTier2 = list_tempCallPlanDetailTier2;
                objCurrentCallPlan.list_callPlanDetailTier3 = list_tempCallPlanDetailTier3;
                objCurrentCallPlan.list_callPlanDetailTier4 = list_tempCallPlanDetailTier4;
                objCurrentCallPlan.list_callPlanDetailTier5 = list_tempCallPlanDetailTier5;
            }

        } 
        else
        {
              // initialize all the records
            list_tempCallPlanDetailTier1 = new List<CallPlanDetail>();
            if(map_Tier1AccountId_Tier1AccountName.size() >0)
            {
                for(Id accId :map_Tier1AccountId_Tier1AccountName.keyset())
                {  System.debug(' map_account.get(accId).Account_Profiles__r[0].Area__c :'+map_account.get(accId).Account_Profiles__r[0].Area__c);
           
                    for(Contact conObj : map_Tier1AccountId_Tier1AccountName.get(accId).Contacts)
                    {
                        CallPlanDetail cpd = new CallPlanDetail();
                        cpd.idAccount = accId;
                        cpd.strAccountName = map_account.get(accId).Name;
                        cpd.strProvince = map_account.get(accId).BillingState;
                        cpd.strArea = map_account.get(accId).Account_Profiles__r[0].Area__c;
                        cpd.idContact = conObj.Id;
                        cpd.strContactName = map_contact.get(conObj.Id).Name;
                        System.debug('cpd.strArea1 : '+cpd.strArea);
                        if(map_account.get(accId).Account_Profiles__r.size() > 0)
                            cpd.objAccProfile = map_account.get(accId).Account_Profiles__r[0];
                            
                        list_tempDays = new List<Days>();
                        for(Integer i=0 ; i<objCurrentCallPlan.list_RBDmonthDates.size();i++ )
                        {
                            dd = new days();
                            dd.blnisbSelected = false;
                            list_tempDays.add(dd);
                            
                        }
                        cpd.list_objDays = list_tempDays;
                        list_tempCallPlanDetailTier1.add(cpd);
                    }
                }
            }
            
            list_tempCallPlanDetailTier2 = new List<CallPlanDetail>();
            if(map_Tier2AccountId_Tier2AccountName.size() >0)
            {
                for(Id accId :map_Tier2AccountId_Tier2AccountName.keyset())
                {
                    for(Contact conObj : map_Tier2AccountId_Tier2AccountName.get(accId).Contacts)
                    {
                        CallPlanDetail cpd = new CallPlanDetail();
                        cpd.idAccount = accId;
                        cpd.strAccountName = map_account.get(accId).Name;
                        cpd.strProvince = map_account.get(accId).BillingState;
                        cpd.strArea = map_account.get(accId).Account_Profiles__r[0].Area__c;
                        cpd.idContact = conObj.Id;
                        cpd.strContactName = map_contact.get(conObj.Id).Name;
                        
                        if(map_account.get(accId).Account_Profiles__r.size() > 0)
                            cpd.objAccProfile = map_account.get(accId).Account_Profiles__r[0];
                            
                        list_tempDays = new List<Days>();
                        for(Integer i=0 ; i<objCurrentCallPlan.list_RBDmonthDates.size();i++ )
                        {
                            dd = new days();
                            dd.blnisbSelected = false;
                            list_tempDays.add(dd);
                            
                        }
                        cpd.list_objDays = list_tempDays;
                        list_tempCallPlanDetailTier2.add(cpd);
                    }
                }
            }
            
            list_tempCallPlanDetailTier3 = new List<CallPlanDetail>();
            if(map_Tier3AccountId_Tier3AccountName.size() >0)
            {
                for(Id accId :map_Tier3AccountId_Tier3AccountName.keyset())
                {
                    for(Contact conObj : map_Tier3AccountId_Tier3AccountName.get(accId).Contacts)
                    {
                        CallPlanDetail cpd = new CallPlanDetail();
                        cpd.idAccount = accId;
                        cpd.strAccountName = map_account.get(accId).Name;
                        cpd.strProvince = map_account.get(accId).BillingState;
                        cpd.strArea = map_account.get(accId).Account_Profiles__r[0].Area__c;
                        cpd.idContact = conObj.Id;
                        cpd.strContactName = map_contact.get(conObj.Id).Name;
                        
                        if(map_account.get(accId).Account_Profiles__r.size() > 0)
                            cpd.objAccProfile = map_account.get(accId).Account_Profiles__r[0];
                            
                        list_tempDays = new List<Days>();
                        for(Integer i=0 ; i<objCurrentCallPlan.list_RBDmonthDates.size();i++ )
                        {
                            dd = new days();
                            dd.blnisbSelected = false;
                            list_tempDays.add(dd);
                            
                        }
                        cpd.list_objDays = list_tempDays;
                        list_tempCallPlanDetailTier3.add(cpd);
                    }   
                }
            }
            
            list_tempCallPlanDetailTier4 = new List<CallPlanDetail>();
            if(map_Tier4AccountId_Tier4AccountName.size() >0)
            {
                for(Id accId :map_Tier4AccountId_Tier4AccountName.keyset())
                {
                    for(Contact conObj : map_Tier4AccountId_Tier4AccountName.get(accId).Contacts)
                    {
                        CallPlanDetail cpd = new CallPlanDetail();
                        cpd.idAccount = accId;
                        cpd.strAccountName = map_account.get(accId).Name;
                        cpd.strProvince = map_account.get(accId).BillingState;
                        cpd.strArea = map_account.get(accId).Account_Profiles__r[0].Area__c;
                        cpd.idContact = conObj.Id;
                        cpd.strContactName = map_contact.get(conObj.Id).Name;
                        
                        if(map_account.get(accId).Account_Profiles__r.size() > 0)
                            cpd.objAccProfile = map_account.get(accId).Account_Profiles__r[0];
                            
                        list_tempDays = new List<Days>();
                        for(Integer i=0 ; i<objCurrentCallPlan.list_RBDmonthDates.size();i++ )
                        {
                            dd = new days();
                            dd.blnisbSelected = false;
                            list_tempDays.add(dd);
                            
                        }
                        cpd.list_objDays = list_tempDays;
                        list_tempCallPlanDetailTier4.add(cpd);
                    }
                    
                }
            }
            
            list_tempCallPlanDetailTier5 = new List<CallPlanDetail>();
            if(map_Tier5AccountId_Tier5AccountName.size() >0)
            {
                for(Id accId :map_Tier5AccountId_Tier5AccountName.keyset())
                {
                    for(Contact conObj : map_Tier5AccountId_Tier5AccountName.get(accId).Contacts)
                    {
                        CallPlanDetail cpd = new CallPlanDetail();
                        cpd.idAccount = accId;
                        cpd.strAccountName = map_account.get(accId).Name;
                        cpd.strProvince = map_account.get(accId).BillingState;
                        cpd.strArea = map_account.get(accId).Account_Profiles__r[0].Area__c;
                        cpd.idContact = conObj.Id;
                        cpd.strContactName = map_contact.get(conObj.Id).Name;
                        
                        if(map_account.get(accId).Account_Profiles__r.size() > 0)
                            cpd.objAccProfile = map_account.get(accId).Account_Profiles__r[0];
                            
                        list_tempDays = new List<Days>();
                        for(Integer i=0 ; i<objCurrentCallPlan.list_RBDmonthDates.size();i++ )
                        {
                            dd = new days();
                            dd.blnisbSelected = false;
                            list_tempDays.add(dd);
                            
                        }
                        cpd.list_objDays = list_tempDays;
                        list_tempCallPlanDetailTier5.add(cpd);
                    }
                    
                }
            }
            
            objCurrentCallPlan.list_callPlanDetailTier1 = list_tempCallPlanDetailTier1;
            objCurrentCallPlan.list_callPlanDetailTier2 = list_tempCallPlanDetailTier2;
            objCurrentCallPlan.list_callPlanDetailTier3 = list_tempCallPlanDetailTier3;
            objCurrentCallPlan.list_callPlanDetailTier4 = list_tempCallPlanDetailTier4;
            objCurrentCallPlan.list_callPlanDetailTier5 = list_tempCallPlanDetailTier5;

        }
    }
        
    /*************************************************************************
    ** Method for posting error message
    *************************************************************************/
    public PageReference addErrorMessage(String error)
    {
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, error);
        ApexPages.addMessage(msg);
        return null;
    }
    
    /*************************************************************************
    ** Method for redrecting to the Details Page on click of the Details button
    *************************************************************************/
    public PageReference details()
    {
        PageReference objPgRef = new PageReference('/apex/CtrlCallPlanDetails_detailByContact?country=APACSU&id=' + objCallPlan.Id);
        return objPgRef;
    }
    public void go()
    {   
        errormsg = '';
        getHospital();
        system.debug('------------'+getHospital+'---------'+getArea);
        CallPlan new_temp = new CallPlan();  
        
        if(getArea!=null && getArea!='')
        {  
          new_temp.objCallPln = objCurrentCallPlan.objCallPln;          
          new_temp.list_RBDmonthDates = objCurrentCallPlan.list_RBDmonthDates;
          list<CallPlanDetail> newlistTier1 = new list<CallPlanDetail>();
          list<CallPlanDetail> newlistTier2 = new list<CallPlanDetail>();
          list<CallPlanDetail> newlistTier3 = new list<CallPlanDetail>();    
          list<CallPlanDetail> newlistTier4 = new list<CallPlanDetail>();
          list<CallPlanDetail> newlistTier5 = new list<CallPlanDetail>();   
          CallPlanDetail aval;
          for(CallPlanDetail cp:objCurrentCallPlan.list_callPlanDetailTier1)
          { 
         // system.debug(' map_account.get(cp.idAccount).Account_Profiles__r[0].Area__c :'+map_account.get((cp.idAccount).Account_Profiles__r[0].Area__c));
          System.debug(' cp.strArea :'+cp.strArea);
          System.debug(' getArea :'+getArea);
            if(cp.strArea==getArea)
            {
              if(cp.strAccountName == getHospital){
              aval = new CallPlanDetail();
              aval = cp;
              newlistTier1.add(aval);
              }else
              if(getHospital == null || getHospital == ''){  
              aval = new CallPlanDetail();
              aval = cp;
              newlistTier1.add(aval); }                
            }
          }
          System.debug(' newlistTier1 :'+newlistTier1);
          new_temp.list_callPlanDetailTier1 = newlistTier1;
          for(CallPlanDetail cp:objCurrentCallPlan.list_callPlanDetailTier2)
          {
            if(cp.strArea==getArea)
            {               
              if(cp.strAccountName == getHospital){
              aval = new CallPlanDetail();
              aval = cp;
              newlistTier2.add(aval);
              }else
              if(getHospital == null || getHospital == ''){  
              aval = new CallPlanDetail();
              aval = cp;
              newlistTier2.add(aval); }              
            }
          }
          new_temp.list_callPlanDetailTier2 = newlistTier2;
          for(CallPlanDetail cp:objCurrentCallPlan.list_callPlanDetailTier3)
          {
            if(cp.strArea==getArea)
            {               
              if(cp.strAccountName == getHospital){
              aval = new CallPlanDetail();
              aval = cp;
              newlistTier3.add(aval);
              }else
              if(getHospital == null || getHospital == ''){  
              aval = new CallPlanDetail();
              aval = cp;
              newlistTier3.add(aval); }              
            }  
          }
          new_temp.list_callPlanDetailTier3 = newlistTier3;
          for(CallPlanDetail cp:objCurrentCallPlan.list_callPlanDetailTier4)
          {
            if(cp.strArea==getArea)
            {               
              if(cp.strAccountName == getHospital){
              aval = new CallPlanDetail();
              aval = cp;
              newlistTier4.add(aval);
              }else
              if(getHospital == null || getHospital == ''){  
              aval = new CallPlanDetail();
              aval = cp;
              newlistTier4.add(aval); }              
            } 
          }
          new_temp.list_callPlanDetailTier4 = newlistTier4;
          for(CallPlanDetail cp:objCurrentCallPlan.list_callPlanDetailTier5)
          {
            if(cp.strArea==getArea)
            {               
              if(cp.strAccountName == getHospital){
              aval = new CallPlanDetail();
              aval = cp;
              newlistTier5.add(aval);
              }else
              if(getHospital == null || getHospital == ''){  
              aval = new CallPlanDetail();
              aval = cp;
              newlistTier5.add(aval); }              
            }  
          }
          new_temp.list_callPlanDetailTier5 = newlistTier5;
          objCurrentCallPlandisplay = new_temp;
          System.debug('objCurrentCallPlandisplay : '+objCurrentCallPlandisplay);
        }
        else
        {
          if(getHospital!=null && getHospital!='')
          {
            new_temp.objCallPln = objCurrentCallPlan.objCallPln;            
            new_temp.list_RBDmonthDates = objCurrentCallPlan.list_RBDmonthDates;
            list<CallPlanDetail> newlistTier1 = new list<CallPlanDetail>();
            list<CallPlanDetail> newlistTier2 = new list<CallPlanDetail>();
            list<CallPlanDetail> newlistTier3 = new list<CallPlanDetail>();    
            list<CallPlanDetail> newlistTier4 = new list<CallPlanDetail>();
            list<CallPlanDetail> newlistTier5 = new list<CallPlanDetail>();         
            CallPlanDetail aval;
              
              for(CallPlanDetail cp:objCurrentCallPlan.list_callPlanDetailTier1)
              {
                if(cp.strAccountName==getHospital)
                {
                  aval = new CallPlanDetail();
                  aval = cp;
                  newlistTier1.add(aval);
                }
              }
              new_temp.list_callPlanDetailTier1 = newlistTier1;
              for(CallPlanDetail cp:objCurrentCallPlan.list_callPlanDetailTier2)
              {
                if(cp.strAccountName==getHospital)
                {
                  aval = new CallPlanDetail();
                  aval = cp;
                  newlistTier2.add(aval);
                }
              }
              new_temp.list_callPlanDetailTier2 = newlistTier2;
              for(CallPlanDetail cp:objCurrentCallPlan.list_callPlanDetailTier3)
              {
                if(cp.strAccountName==getHospital)
                {
                  aval = new CallPlanDetail();
                  aval = cp;
                  newlistTier3.add(aval);
                }
              }
              new_temp.list_callPlanDetailTier3 = newlistTier3; 
             for(CallPlanDetail cp:objCurrentCallPlan.list_callPlanDetailTier4)
              {
                if(cp.strAccountName==getHospital)
                {
                  aval = new CallPlanDetail();
                  aval = cp;
                  newlistTier4.add(aval);
                }
              }
              new_temp.list_callPlanDetailTier4 = newlistTier4;      
             for(CallPlanDetail cp:objCurrentCallPlan.list_callPlanDetailTier5)
              {
                if(cp.strAccountName==getHospital)
                {
                  aval = new CallPlanDetail();
                  aval = cp;
                  newlistTier5.add(aval);
                }
              }
              new_temp.list_callPlanDetailTier5 = newlistTier5;                  
              
            objCurrentCallPlandisplay = new_temp;
            
            System.debug('objCurrentCallPlandisplay2: '+objCurrentCallPlandisplay);
          }                              
            else
            objCurrentCallPlandisplay = objCurrentCallPlan;
            
          System.debug('objCurrentCallPlandisplay3: '+objCurrentCallPlandisplay);
        } 
        System.debug('Final objCurrentCallPlandisplay.list_callPlanDetailTier1: '+objCurrentCallPlandisplay.list_callPlanDetailTier1);
        System.debug('Final objCurrentCallPlandisplay : '+objCurrentCallPlandisplay );  
           
        if(objCurrentCallPlandisplay.list_callPlanDetailTier1.size() == 0 && objCurrentCallPlandisplay.list_callPlanDetailTier2.size() == 0 && objCurrentCallPlandisplay.list_callPlanDetailTier3.size() == 0 && objCurrentCallPlandisplay.list_callPlanDetailTier4.size() == 0 && objCurrentCallPlandisplay.list_callPlanDetailTier5.size() == 0){
            errormsg = Label.Call_Plan_Error;
        }
    } // go method End    
    public void clearAll()
    {
        getHospital = '';
        getArea = '';  
        objCurrentCallPlandisplay = objCurrentCallPlan;  
        errormsg = '';        
        
    }
    /*Public Void onChangeArea(){
        System.debug('Apex Pages : '+ApexPages.currentPage().getParameters().get('hosp'));
        getHospital();
    }*/
    /*************************************************************************
    ** Code written by Raviteja Kumar on 16 Nov 2012 for providing filter 
    *************************************************************************/     
     public SelectOption[] getHospital()
    {
        List<SelectOption> list_options = new List<SelectOption>();
        
        list_options.add(new SelectOption('','All'));  
        if(getHospital == null || getHospital == ''){
        System.debug('Hospitalname: '+Hospitalname);
      if(map_account.size()>0)
       {
           for(Account s:map_account.values())   
           {               
               system.debug('****Account---' + s);
               system.debug('****s.Account_profiles__r ---' + s.Account_profiles__r);
               if(s.Account_profiles__r[0].Area__c != null && s.Account_profiles__r[0].Area__c == getArea){
               System.debug('s.Account_profiles__r[0].Area__c : '+s.Account_profiles__r[0].Area__c + 'getArea : '+getArea);
               list_options.add(new SelectOption(String.valueOf(s.Name),String.valueOf(s.Name)));
               }
               else if(getArea == null || getArea == ''){            
               list_options.add(new SelectOption(String.valueOf(s.Name),String.valueOf(s.Name))); }
           }  
       }
       }else{
       list_options.add(new SelectOption(String.valueOf(getHospital),String.valueOf(getHospital)));
       }       
       list_options.sort();
       System.debug('list_options : '+list_options);
       return list_options;
    } // getHospital method End
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
           list_options.sort();
       }         
        return list_options;
    } // getArea method End
    
    /*******************************************************************************************************************************************
    ** Method for redrecting to the Details Page on click of the Details button - Does the save action before redirecting to the Details Page
    ******************************************************************************************************************************************/
    public PageReference saveAndDetails()
    {
        blnisSaveFlag = true;
        PageReference objPgRef = save();
        PageReference objRedirectPg  = new PageReference('/apex/CtrlCallPlanDetails_detailByContact?country=APACSU&id=' + objCallPlan.Id);
        return(objRedirectPg);
    }
}