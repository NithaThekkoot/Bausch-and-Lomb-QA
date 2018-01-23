/** 
 *
 * Controller class for displaying Accounts, Contacts with their team
 * This can be achieved by a Standard report, but as in SU we are having a sharing rule in Accounts for India 
 * users are not able to view only their associated accounts.
 * This page works as report for the same and restricts the visblity of accounts to its team only and this is 
 * the real reason for the generation of this.
 *
 * Test class : Test_CtrlHospitalsPhysiciansWithTeam
 *
 *    Author         |Author-Email                  |Date       |Comment
 *    ---------------|------------------------------|-----------|--------------------------------------------------
 *   Neha Jain       |neha.jain@bausch.com          |16-04-2014 |First draft 
 */
public class CtrlHospitalsPhysiciansWithTeam {
    // variables
    
    //list maintaing users who are managers
    Set<Id> setUserId;
    //list for all the accounts for users
    Set<Id> accountId;
    //list of users who are excecutives.
    Set<Id> setExcecutivesId;
    
    Map<Id,List<AccountTeamMember>> mapAccountUsers;
    
    Map<Id,Account_Profile__c> mapAccountProfile;
    
    boolean blnRedirect;
    
    integer recordsDisplayed;
    
    // properties
    public Transient List<HospitalsPhysiciansWithTeam> listHospitalWithTeam1 {get;set;}
    public Transient List<HospitalsPhysiciansWithTeam> listHospitalWithTeam2 {get;set;}
    public Transient List<HospitalsPhysiciansWithTeam> listHospitalWithTeam3 {get;set;}
    public Transient List<HospitalsPhysiciansWithTeam> listHospitalWithTeam4 {get;set;}
    public Transient List<HospitalsPhysiciansWithTeam> listHospitalWithTeam5 {get;set;}
    public Transient List<HospitalsPhysiciansWithTeam> listHospitalWithTeam6 {get;set;}
    public Transient boolean list1ContainsData {get;set;}
    public Transient boolean list2ContainsData {get;set;}
    public Transient boolean list3ContainsData {get;set;}
    public Transient boolean list4ContainsData {get;set;}
    public Transient boolean list5ContainsData {get;set;}
    public Transient boolean list6ContainsData {get;set;}
    public string strMessageRecords {get;set;} 
    public integer totalRecords{get;set;}
    // constructor
    public CtrlHospitalsPhysiciansWithTeam(){
         //system.debug('***currentpage' + ApexPages.CurrentPage().getUrl());
         IntializeData(); 
         
    }
    
    public void IntializeData(){
        //intialize all the variables
           //listHospitalWithTeam = new List<HospitalsPhysiciansWithTeam>();
           listHospitalWithTeam1 = new List<HospitalsPhysiciansWithTeam>();
           listHospitalWithTeam2 = new List<HospitalsPhysiciansWithTeam>();
           listHospitalWithTeam3 = new List<HospitalsPhysiciansWithTeam>();
           listHospitalWithTeam4 = new List<HospitalsPhysiciansWithTeam>();
           listHospitalWithTeam5 = new List<HospitalsPhysiciansWithTeam>();
           listHospitalWithTeam6 = new List<HospitalsPhysiciansWithTeam>();
          
           
           setUserId = new Set<Id>();          
           accountId = new Set<id>(); 
           setExcecutivesId = new Set<Id>();
           mapAccountUsers = new Map<Id,List<AccountTeamMember>>();
           mapAccountProfile = new  Map<Id,Account_Profile__c>();
           
           list1ContainsData = true;
           list2ContainsData = true;
           list3ContainsData = true;
           list4ContainsData = true;
           list5ContainsData = true;
           list6ContainsData = true;
           blnRedirect = false;
           
           //add current user to the set
           setUserId.add(UserInfo.getUserId());
           setExcecutivesId.add(UserInfo.getUserId());
           
           //fetch user details for which report needs to be generated.
           fetchUserDetails();
           if(!blnRedirect){
               //fetch all the associated accounts for users
               fetchAssociatedAccounts();
               
               //fetch all the details for Accounts, Contacts.
               fetchAccountsContactsWithDetails();
           }
           totalRecords = 0;
           recordsDisplayed = 0;
                  
           if(listHospitalWithTeam1.size() > 0){
               totalRecords = listHospitalWithTeam1.size();
               recordsDisplayed = listHospitalWithTeam1.size();
           }
           else{
                 list1ContainsData = false;
           }
          
           if(listHospitalWithTeam2.size() > 0){
               totalRecords += listHospitalWithTeam2.size();
               list2ContainsData = true; 
           }
            else{
                  list2ContainsData = false;
           }
           
           if(listHospitalWithTeam3.size() > 0){
               totalRecords += listHospitalWithTeam3.size();
               list3ContainsData = true;
           }
            else{
                  list3ContainsData = false;
           }
           
            if(listHospitalWithTeam4.size() > 0){
               totalRecords += listHospitalWithTeam4.size();
               list4ContainsData = true;
           }
            else{
                  list4ContainsData = false;
           }
           if(listHospitalWithTeam5.size() > 0){
               totalRecords += listHospitalWithTeam5.size();
               list5ContainsData = true;
           }
            else{
               list5ContainsData = false;
           }
           
           if(listHospitalWithTeam6.size() > 0){
               totalRecords += listHospitalWithTeam6.size();
               list6ContainsData = true;
           }
            else{
                  list6ContainsData = false;
           }
           
           strMessageRecords = recordsDisplayed + ' of ' + totalRecords  + ' records are displayed below. (Click on Export Details to get your/your\'s team entire MCL report)';
           
           if(blnRedirect){
             strMessageRecords = 'Click on Export Details to get your/your\'s team entire MCL report.';
           }
           
    }
    
    //methods
    /* Fetch details for users: 
     *   1. Fetch details for the logged in user, if the user is an excecutive retrun to fetch accounts.
     *   2. If the logged in user is a manager, then call a recursive method to get the list of all the reporting excecutives.
     */
     
    private void fetchUserDetails(){
        List<User> lstUserDetails = [Select Userrole.Name, Profile.Name from User where Id = : UserInfo.getUserId()];
        
        string strBLSystemAdmin = 'BL: System Admin SSO';
        string strBLReadAdmin = 'BL: Read Only Admin';
        string strNationalManagerRole = 'INDSU National Sales Manager';
        //For Admin users.
        if(lstUserDetails[0].Profile.Name == strBLSystemAdmin || lstUserDetails[0].Profile.Name == strBLReadAdmin || lstUserDetails[0].UserRole.Name == strNationalManagerRole){
            blnRedirect = true;
            if(ApexPages.CurrentPage().getUrl()!=null)
            {
            if(ApexPages.CurrentPage().getUrl().contains('MCLData')){
                blnRedirect = false;
                // As Admin users does not have any subordinates with Accounts, run the report as National Manager
                List<User> listActiveUsers = [Select Id from User where Profile.Name IN ('INDSU Sales Rep', 'INDSU Service Rep') and isactive = true];
                //Add all the users to Set of Excecutives
                for(User objUser : listActiveUsers){
                    setExcecutivesId.add(objUser.Id);
                }
            }
           }
            
        }
        //if the user is a Manager, get the list of reporting users
        else if(lstUserDetails[0].Userrole.Name != '' || lstUserDetails[0].Userrole.Name != null){
            if(lstUserDetails[0].Userrole.Name.contains('Manager')){
                getListofExecutives(setUserId);            
            }
        }
    }
    
    /* Recursive method : Fetch the reporting excecutives for the manager, if the reporting user is also a manager call the
     * method again, till list of all the excecutives reporting to the logged in user is fetched.
     */
    private void getListofExecutives(Set<Id> managerId){
        Map<Id,User> mapUserDetails = new  Map<Id,User>([Select Id, Userrole.Name, Profile.Name from User where ManagerId = : managerId and isactive = true]);
            
        List<User> listfetchedUsers = mapUserDetails.Values();
        setUserId = mapUserDetails.KeySet();
        
        for(User objUser : listfetchedUsers){
            if(objUser.UserRole.Name !=  '' || objUser.UserRole.Name != null){
                if(!objUser.UserRole.Name.contains('Manager')){
                    //set user id to the set of excecutives. 
                    setExcecutivesId.add(objUser.Id);
                    //remove it from the set of managers.
                    setUserId.remove(objUser.Id);
                }
            }
        }
        
        //-------will create an another set for excecutives       
        if(setUserId.size() > 0){
            //recursive call - get list of excecutives
            getListofExecutives(setUserId);
        }
    }
    
    //fetch all the associated account for the list of excecutives
    private void fetchAssociatedAccounts(){
        //fetch accounts for team members
        List<AccountTeamMember> listaccountTM = [Select AccountId, UserId, User.Name, User.ManagerId, User.Manager.Name from AccountTeamMember where UserId =: setExcecutivesId];
        
        //iterate over the team members list
        for(AccountTeamMember accountTeam : listaccountTM){
            //add Accounts' Id to the set
            accountId.add(accountTeam.AccountId);
            // create a new list for the map, to track an account  associaited with multiple users
            List<AccountTeamMember> listaccountTeam = new List<AccountTeamMember>();
            //check if the accountId already exsits in the Map
            if(mapAccountUsers.containsKey(accountTeam.AccountId)){
                //if yes, get the already exsiting users team
                listaccountTeam = mapAccountUsers.get(accountTeam.AccountId);
            }
            // add the another user as a team to account in the map
            listaccountTeam.add(accountTeam);
            //put the values in map.
            mapAccountUsers.put(accountTeam.AccountId,listaccountTeam);
        }
        fetchAssociatedAccountsProfiles();
    }
    
    //fetch all the associated account for the list of excecutives
    private void fetchAssociatedAccountsProfiles(){
        //fetch accounts for team members
        List<Account_Profile__c> listAccountProfiles = [Select Id, Area__c, Segmentation__c, Region__c, Account__c from Account_Profile__c where Account__c IN: accountId];
        
        //iterate over the team members list
        for(Account_Profile__c accountProfile : listAccountProfiles){
           //put the values in map.
            mapAccountProfile.put(accountProfile.Account__c,accountProfile);
        }
    }
    
    // Fetch all the contacts for the associated accounts, with accounts and doctors details
    private void fetchAccountsContactsWithDetails(){
       try{
           system.debug('**accountId' + accountId.size());
           
           List<Contact> listPhysicians = [Select Id, Name, MailingCity, MailingCountry, MailingState, MailingStreet, MailingPostalCode, MobilePhone, 
                                            Email, Account.Id, Account.Name, Account.Legacy_System_Id__c, Account.DASRX_ABC_Classification__c, Account.Customer_Segment_1__c, 
                                            (SELECT Id, Contact__c,Gender__c,PHYSICIAN_SPECIALITY__c,Doctor_Segmentation__c FROM Contact_Profiles__r) 
                                            from Contact where AccountId IN: accountId];
                                            
                  system.debug('***go and bind data**' + listPhysicians.size());
                  fillData(listPhysicians);              
                                            
           
        }
        catch(Exception ex){
            system.debug('***exception in fetchAccounts..' + ex);
        }
        
    
    
    }
    
    
    // This method iterate over all the contacts and team members to create list of Accounts, Contacts with their team members.
    private void fillData(List<Contact> listPhysicians){
         system.debug('***bind data**' + listPhysicians.size());
         try{
         for(Contact physician : listPhysicians){
           
                 //if the contacts and account id in the Map matches, then proceed to create an instance of inner class
                 
                     //get team members for the account
                     List<AccountTeamMember> accountsTeam = mapAccountUsers.get(physician.Account.Id);
                     //iterate over all the team members for the account
                     for(AccountTeamMember atm : accountsTeam){
                             //instance of inner class to bind the data
                             HospitalsPhysiciansWithTeam hospitalWithTeam = new HospitalsPhysiciansWithTeam();
                             hospitalWithTeam.accountName  = physician.Account;
                             hospitalWithTeam.physicianName = physician;
                             hospitalWithTeam.strLegacyId = physician.Account.Legacy_System_Id__c;
                             if(mapAccountProfile.get(physician.Account.Id) != null){
                                 hospitalWithTeam.accountSegmentation = mapAccountProfile.get(physician.Account.Id).Segmentation__c;
                                 hospitalWithTeam.strAccountArea = mapAccountProfile.get(physician.Account.Id).Area__c;
                                 hospitalWithTeam.strAccountRegion = mapAccountProfile.get(physician.Account.Id).Region__c;
                             }
                             hospitalWithTeam.strEmail = physician.Email;
                             hospitalWithTeam.strPhone = physician.MobilePhone;
                             hospitalWithTeam.strMailingCity = physician.MailingCity;
                             hospitalWithTeam.strMailingState = physician.MailingState;
                             hospitalWithTeam.strMailingStreet = physician.MailingStreet;
                             hospitalWithTeam.strMailingPostalCode = physician.MailingPostalCode;
                             hospitalWithTeam.strMailingCountry = physician.MailingCountry; 
                             if(physician.Contact_Profiles__r.size() > 0){
                                 hospitalWithTeam.strPhysicianSpeciality  = physician.Contact_Profiles__r[0].PHYSICIAN_SPECIALITY__c;
                                 hospitalWithTeam.strPhysicianGender  = physician.Contact_Profiles__r[0].Gender__c;      
                                 hospitalWithTeam.doctorSegmentation = physician.Contact_Profiles__r[0].Doctor_Segmentation__c ;
                             }
                             hospitalWithTeam.strTeamMember = atm.User.Name;
                             hospitalWithTeam.strManagerName =  atm.User.Manager.Name;
                            
                             integer dataPermitted = 900;
                             
                             if(ApexPages.CurrentPage().getUrl().contains('MCLData')){
                                 system.debug('***MCLData');
                                 dataPermitted = 1000;
                             }
                             if(listHospitalWithTeam1.size() < dataPermitted){
                                 listHospitalWithTeam1.add(hospitalWithTeam);
                             }
                             else if(listHospitalWithTeam2.size() < dataPermitted){
                                 listHospitalWithTeam2.add(hospitalWithTeam);
                             }
                             else if(listHospitalWithTeam3.size() < dataPermitted){
                                 listHospitalWithTeam3.add(hospitalWithTeam);
                             }
                             else if(listHospitalWithTeam4.size() < dataPermitted){
                                 listHospitalWithTeam4.add(hospitalWithTeam);
                             }
                             else if(listHospitalWithTeam5.size() < dataPermitted){
                                 listHospitalWithTeam5.add(hospitalWithTeam);
                             }
                             else if(listHospitalWithTeam6.size() < dataPermitted){
                                 listHospitalWithTeam6.add(hospitalWithTeam);
                             }
                             else
                                  return;
                             
                     }             
                 }               
             }
              catch(Exception ex){
                system.debug('***exception in bindata..' + ex);
            }
    }
    
    
    
    public PageReference SendMailToUserOnly()
    {        
        system.debug('***send mail');
        PageReference pageRef = new PageReference('/apex/MCLData');
        pageRef.setRedirect(true);
        return pageRef;        
    }
    
    //Inner class : to bind the values from all the objects in one class 
    private class HospitalsPhysiciansWithTeam{
        public account accountName {get; set;}
        public contact physicianName {get; set;}
        public string strLegacyId {get;set;}
        public string accountSegmentation {get; set;}
        public string doctorSegmentation {get; set;}
        public String strEmail{get; set;}
        public String strPhone{get; set;}
        public String strMailingCity{get; set;}
        public String strMailingState{get; set;}
        public String strMailingStreet{get; set;}
        public String strMailingPostalCode{get; set;}
        public String strMailingCountry{get; set;}               
        public String strTeamMember {get; set;}
        public String strManagerName {get; set;}
        public String strPhysicianSpeciality {get; set;}
        public String strPhysicianGender {get; set;}
        public string strAccountArea {get; set;}
        public string strAccountRegion {get; set;}        
    }    
    
}