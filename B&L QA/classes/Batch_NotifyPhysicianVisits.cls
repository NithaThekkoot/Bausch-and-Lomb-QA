/**
 * Notification to Sales Reps for Completing their Physician Visits.
 *
 * Fetch all the Open Physician Visits for the Users with profile INDSU Sales Rep, to notify users 
 * regarding open Physician visits for the last day for which they can complete the Physician visit, 
 * considering here a Sales Rep can compelte a visit today upto last 3 days.  
 *
 * Batch Class is used here to avoid - limit of only 10 emails can be send in a process/context
 *
 *   Author             |Author-Email                                      |Date       |Comment
 *   -------------------|--------------------------------------------------|-----------|--------------------------------------------------
 *   Raviteja Vakity    |raviteja.vakity@bausch.com                        |17.12.2013 |First Draft 
 *
 * Test Class -- Test_ScheduleNotifyPhysicianVisits
 * Scheduler Class -- clsNotifyOpenPhysicianScheduler
 */

global class Batch_NotifyPhysicianVisits implements Database.Batchable<sObject>,Database.Stateful
{
    List<AggregateResult> listPhysicianVisits;
    Date dateNotify;
     //Kandarp Shah | 11-Apr-14 | CR by Suresh
    Datetime dtDateForMailBodyText;
    String strDateForMailBodyText = '';
    //Declare a map for Users and its open Store Visits Count
    Map<Id,Integer> mapUserOpenStoreVisits; 
    Set<ID> setIDs;
    public string strLimit;
     
   global Batch_NotifyPhysicianVisits()
   {
        listPhysicianVisits= new List<AggregateResult>();
        Integer daysConsidered = Integer.ValueOf(System.Label.DaystoComplete);
        //Date dateNotify2 = System.today().addDays(daysConsidered);
        
        dateNotify = System.today().addDays(daysConsidered);    
        
         //Kandarp Shah | 11-Apr-14 | CR by Suresh | Start
        dtDateForMailBodyText = System.today().addDays(daysConsidered);
        strDateForMailBodyText = dtDateForMailBodyText.format('dd-MMM-yyyy');
        //Kandarp Shah | 11-Apr-14 | CR by Suresh | END
        
        setIDs = new Set<ID>();        
        strLimit = '';
        if(Test.isRunningTest())
            strLimit = ' Limit 1';
        
        
   }

   /* Start of Batch : Fetch User for which Physician Visit is open for the Activity Date as last business day to compelete it.
    */
   global Database.QueryLocator start(Database.BatchableContext BC)
   {
       //converted date to string as in querying data with getQueryLocator only this format is allowed.
       String Strmonth=String.ValueOf(dateNotify.Month());
       String Strday=String.ValueOf(dateNotify.Day());
       if(Strmonth.length()==1)
       {
           Strmonth='0'+dateNotify.Month();
       }
       if(Strday.length()==1)
       {
           Strday='0'+dateNotify.Day();
       }
       string dateNotification = dateNotify.Year() + '-' + Strmonth + '-' + Strday;
        
       string query = 'SELECT ownerId FROM Physician_Visit__c'; 
       query += ' where Status__c = \'Open\' and Owner.UserRole.Name  like \'%INDSU%\' and Activity_Date__c =' + dateNotification ;
       query += ' and Owner.IsActive = true' + strLimit;
        
       system.debug('***query --- ' + query);
        
       return Database.getQueryLocator(query);     //send the User to excecute the business logic.   
    }

   global void execute(Database.BatchableContext BC, List<sObject> scope)
   {
       system.debug('***scope--- ' + scope.size() + '--' + scope);
       
       List<Physician_Visit__c> lstPhysician = (List<Physician_Visit__c>)scope;
       
       System.debug('lstPhysician : ' + lstPhysician);

       // Add the user to set to avoid repeatative mails.
       if(!setIDs.contains(lstPhysician[0].OwnerId)){
           setIDs.add(lstPhysician[0].OwnerId);
       }
       else{
           return;
       }
       
        /*fetch all the Physician Visits for the User for  Status__c = 'Open', Owner.UserRole.Name  like '%INDSU%'  
         * Activity date as last specified business day.
        */
        listPhysicianVisits = [SELECT COUNT(Id) countStore, ownerId, Owner.Name, Owner.Email FROM Physician_Visit__c 
                                                      where Status__c = 'Open' 
                                                      and 
                                                      Owner.UserRole.Name  like '%INDSU%' 
                                                      and 
                                                      Activity_Date__c =: dateNotify
                                                      and 
                                                      Owner.IsActive = true  
                                                      and
                                                      OwnerID =: lstPhysician[0].OwnerId
                                                      group by 
                                                      ownerId, Owner.Name , Owner.Email];  
       
       system.debug('***listPhysicianVisits --- ' + listPhysicianVisits.size() + '--' + listPhysicianVisits );
       
       arrangeListForNotification();
   }
   
   // Iterate a loop over all the open store visits and then send a mail to each for their open store visits.
    
     public void arrangeListForNotification(){
       //iterate over List of Store Visits.
        integer count = 0;
        //fetch all the details and send mail for a User.
        for(AggregateResult result :listPhysicianVisits){
                integer openStoreVisit = integer.valueOf(result.get('countStore'));
                string strExcecutiveName = String.ValueOf(result.get('Name'));
                string strEmail = String.ValueOf(result.get('Email'));
                
                system.debug('***openStoreVisit --' + openStoreVisit + '--strExcecutiveName ' + strExcecutiveName + strEmail);
                if(openStoreVisit > 0){
                    count = count + 1; 
                    sendMail(strEmail, openStoreVisit, strExcecutiveName,count);
                }
                
        }        
     }
     
     //Method to sendMail
     private void sendMail(string strEmail,integer openStoreVisit, string excecutiveName, integer count){        
           system.debug('***Send Mail---' + count);
           //list of every excecutive to send mail individually
           List<String> listEmails = new List<String>();
           listEmails.add(strEmail);       
            //listEmails.add('Tarun.Solanki@bausch.com');
            //listEmails.add('Kandarp.shah@bausch.com');
             
           List<String> listCCEmails = new List<String>();
           listCCEmails.add(System.Label.Support_Email);
           
           
           //create an instance of SingleEmailMessage to send mail
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();            
            
            mail.setToAddresses(listEmails); //EMAIL ADDRESS of Sales Excecutive
            mail.setCCAddresses(listCCEmails);
            mail.saveAsActivity = false; 
            
            string strMailBody = '<html> Hi ' + excecutiveName + ',' + '<br/><br/>' + 'This is an alert mail to you.' + '<br/><br/>'; 
          //strMailBody = strMailBody + 'Today is the last day to report ' + openStoreVisit +' Physician Visits assigned to you for ' + dateNotify.format() + '. Request you to do the needful.';
          //CR by Suresh-Tarun Solanki-28-4-2014
          //strMailBody = strMailBody + 'Today is the last day to report ' + openStoreVisit +' Physician Visits assigned to you for ' + strDateForMailBodyText + '. Request you to do the needful.';
            strMailBody = strMailBody + 'There are ' + openStoreVisit +' Physician Visits assigned to you for ' + strDateForMailBodyText + '. Request you to do the needful.';
            strMailBody = strMailBody + '<br/><br/><br/>' + 'Thank you & Warm Regards' + '<br/>' + '(This is a system generated email sent you by the Bausch & Lomb Salesforce Surgical Care Org, please do not reply to this email)</html>';
            
            mail.setSubject('Reminder : Last Day to Report Physician Visits : India SU');
            mail.setHtmlBody(strMailBody);
            
            system.debug('**mail ---' + '-' + count + mail);
            //send mail and trap results
            try
            {
                 List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
                 system.debug('***results---' + '--' + count + results  + '***results.get(0).isSuccess()---' + results.get(0).isSuccess());
                 if (!results.get(0).isSuccess()) 
                 {
                    System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
                    String errorMessage = results.get(0).getErrors()[0].getMessage();
                    system.debug('***statusCode---' + statusCode + '***errorMessage---' + errorMessage);
                }
            }
            catch(Exception ex){
                 
                 system.debug('***Exception sending mail -----' + ex);
            }
     }

   global void finish(Database.BatchableContext BC)
   {
   }

}