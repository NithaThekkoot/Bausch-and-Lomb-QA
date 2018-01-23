/**
 * Fetch all the Open Store Visits for the Users with profile APAVC IND Sales Executive, to notify users 
 * regarding open store visits above a criteria specified at different levels of Managers.
 *  
 *
 *   Author             |Author-Email                                      |Date       |Comment
 *   -------------------|--------------------------------------------------|-----------|--------------------------------------------------
 *   Tarun Solanki      |tarun.solanki@bausch.com                          |17.12.2013 |First Draft 
 *
 * Test Class -- Test_ScheduleNotifyPhysicianVisits
 * Scheduler Class -- clsNotifyOpenPhysicianMangersScheduler
 */
 

 
 public Class CtrlNotifyPhysicianVisitsManagers{
    List<AggregateResult> listPhysicianVisits;
    Map<Id,User> mapSalesRepsDetails;
    List<String> listEmails;
    Date startDate;
    
    //List to display on component to send email
    public static List<UserPhysicianVisits> listUserPhysicianVisits{get;set;}
    
    public CtrlNotifyPhysicianVisitsManagers(){
        //listStoreVisits = new List<AggregateResult>();
        listPhysicianVisits = new List<AggregateResult>();
        listUserPhysicianVisits = new List<UserPhysicianVisits>(); 
        //Date to consider -- first day of month
        startDate = Date.Valueof(System.today().Year() + '-1' + '-1');
        //getFiscalMonthDates();
        getUsersPhysicianVisits();
        getManagersList();
        system.debug('***startDate ' + startDate);
    }
    
    private void getUsersPhysicianVisits(){
        integer daysNotify = Integer.ValueOf(System.Label.ManagersNotifyDays);
         //Fetch all the open store visits grouped by their owners for open visits for a owner
         listPhysicianVisits = new List<AggregateResult>([SELECT COUNT(Id) countStore, ownerId, Owner.Name, Owner.Email FROM Physician_Visit__c 
                                                      where Status__c = 'Open' 
                                                      and 
                                                      Owner.UserRole.Name  like '%INDSU%' 
                                                      and Activity_Date__c >=: startDate 
                                                      and Activity_Date__c <=: System.today().addDays(daysNotify)
                                                      and Owner.IsActive = true  
                                                      group by 
                                                      ownerId, Owner.Name , Owner.Email
                                                      order by 
                                                      COUNT(Id) desc]); 
                  
        system.debug('***listPhysicianVisits --' + listPhysicianVisits );                
    }
    
    private void getManagersList(){
        //fetch all the managers to email
        if(listPhysicianVisits.size() == 0)
            return;
        //List<User> listUsers = [Select id, name, email from user where (UserRole.name  like '%INDSU Sales Manager%' or UserRole.name  like '%INDSU Regional Manager%') and user.isactive = true];
        
        //Modified to consider profile instead of role
        List<User> listUsers = [Select id, name, email from user where (Profile.name  like '%INDSU Sales Manager%') and user.isactive = true];
        
        //arrange their email address of Managers to Mail
        listEmails = new List<String>();
       /* for(User objUser : listUsers){
            listEmails.add(objUser.Email);
        }*/
        //Managers to Notify from the Label defined
        string emailsManagers = String.valueOf(System.label.ManagersToNotify);
        List<String> listEmailsManagers = emailsManagers.split(',');
        
        listEmails.addAll(listEmailsManagers); //Email address of Managers
        
        List<Id> listUserIds = new List<id>();
        
        for(AggregateResult result: listPhysicianVisits){
            String strOwnerId = String.ValueOf(result.get('ownerId'));
            Id OwnerId = Id.valueof(strOwnerId);
            listUserIds.add(OwnerId);
        }
        
        mapSalesRepsDetails = new Map<Id, User>([Select Id, Name, APAC_Region__c, Manager.Name, Email from user where Id IN: listUserIds]);
        arrangeListForNotification();
    }
     
     /* Iterate a loop over all the open store visits and then send a mail to each for their open store visits.
     */
     private void arrangeListForNotification(){
       //iterate over List of Store Visits.
        integer count = 1;
        for(AggregateResult result :listPhysicianVisits){
                integer openStoreVisit = integer.valueOf(result.get('countStore'));
                string strExcecutiveName = String.ValueOf(result.get('Name'));
                string strEmail = String.ValueOf(result.get('Email'));
                String strOwnerId = String.ValueOf(result.get('ownerId'));
                Id userId = Id.valueof(strOwnerId);
            
                //create instance and bind them to List
                UserPhysicianVisits instanceVisits = new UserPhysicianVisits();
                instanceVisits.serialNum = count++;
                instanceVisits.userName = strExcecutiveName;
                instanceVisits.region = mapSalesRepsDetails.get(userId).APAC_Region__c;
                instanceVisits.managerName = mapSalesRepsDetails.get(userId).Manager.Name;
                instanceVisits.storeVisitsCount = openStoreVisit;
                         
                listUserPhysicianVisits.add(instanceVisits);
                 
                
        } 
        system.debug('listUserPhysicianVisits -- ' + listUserPhysicianVisits );
        //sendMail(strEmail, openStoreVisit, strExcecutiveName,count);       
     }
     
     //Method to sendMail
     public void sendMail(){        
           if(listUserPhysicianVisits.size() == 0){
                system.debug('******No Data to send Mail************');
               return;
           }
           system.debug('***Send Mail---');
           
           // First, need to obtain the ID of the email template we created.
           EmailTemplate emailTemplates = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName='NotifyOpenPhysicianVisits' limit 1];
            
           //create an instance of SingleEmailMessage to send mail
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();            
           mail.setTargetObjectId(UserInfo.getUserId());
           mail.setToAddresses(listEmails); //EMAIL ADDRESS of Sales Excecutive
           mail.saveAsActivity = false; 
           mail.setTemplateId(emailTemplates.Id); 
           //mail.setSubject('Report - INDVC Open Store Visits - Could Not be Completed');
           
            
           system.debug('**mail ---' + '-' + mail);
           //send mail and trap results
           try{
                 List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
                 system.debug('***results---'   + results  + '***results.get(0).isSuccess()---' + results.get(0).isSuccess());
                 if (!results.get(0).isSuccess()) {
                    System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
                    String errorMessage = results.get(0).getErrors()[0].getMessage();
                    system.debug('***statusCode---' + statusCode + '***errorMessage---' + errorMessage);
                }
            }
            catch(Exception ex){
                 
                 system.debug('***Exception sending mail -----' + ex);
            }
     }
     
     /*private void getFiscalMonthDates(){
         List<Period> listPeriod =  [SELECT EndDate, StartDate, Id FROM Period where 
                                     FiscalYearSettings.Name =: String.ValueOf(System.today().Year())
                                     and Type='Month' 
                                     and endDate >=: System.today() 
                                     and startdate<=: System.today()];
        
        if(listPeriod <> null && listPeriod.size() >0)
            startDate =  listPeriod[0].StartDate;
                                       
        system.debug('***listPeriod  '+ listPeriod);                                     
     
     }*/
    
     //Inner Class for binding Store Visits Data 
    public Class UserPhysicianVisits{
        public integer serialNum{get;set;}
        public string userName{get;set;}
        public string region{get;set;}
        public string managerName{get;set;}
        public integer storeVisitsCount{get;set;}
        public string managersManager{get;set;}
        public UserPhysicianVisits(){
            
        }        
    }

     
     
 }