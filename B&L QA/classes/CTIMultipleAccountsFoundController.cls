/**
* 
* Controller for the Account Phones page and object, which are used with the phone system (CTI) for NA Customer Service
* 
* Author              |Author-Email                    |Date        |Comment
* --------------------|------------------------------- |------------|----------------------------------------------------
* Craig Stanton       |craig.stanton@bausch.com        |05-May-2011 |Initial release 
* Craig Stanton       |craig.stanton@bausch.com        |14-Jun-2011 |Adding ability to select SETID 
* Craig Stanton       |craig.stanton@bausch.com        |29-Sep-2011 |Adding ability to get input IDs from Custom Settings to pass values
*
*/

public with sharing class CTIMultipleAccountsFoundController { 
            
    public ApexPages.StandardController controller {get; set;}
    public List<Account_Phone__c> searchResults {get;set;}
    public List<Account_Phone__c> stSearchResults {get;set;}
    public String ani {get;set;}         //this will come from the url!!
    public String st {get;set;}          //this is the ship to, and will come from the url!!
    public String sid {get;set;}          //this is the setid, and will come from the url!!
    public String mode {get;set;}        //this will control which mode the VF page has
    public List<SelectOption> sidValues {get; set;}
    
    //2011-09-09 - CLS - NEW VARIABLES TO GET THE VALUE OF THE ID OF THE PHONE FIELD FROM CUSTOM SETTING
    public String phoneId {get;set;}                //this will come from the Custom Setting!!
    
    String shipTo;
    String phoneNumber;
    Account_Phone__c acctPhone;
    Account acct;
    PageReference acctPage;    
 
    // standard controller
    public CTIMultipleAccountsFoundController(ApexPages.StandardController controller) { 
        
        ani = ApexPages.currentPage().getParameters().get('ani');
        st = ApexPages.currentPage().getParameters().get('st');
        sid = ApexPages.currentPage().getParameters().get('sid');
        mode = ApexPages.currentPage().getParameters().get('mode');
        phoneNumber = ani;
        
        //NEED TO GET THE PHONE NUMBER ID FROM THE CUSTOM SETTING        
        //CATSWeb_Resources__c cwVars = CATSWeb_Resources__c.getInstance();
        //phoneId = cwVars.Phone_Number_Field_ID__c;
        
        //system.debug('*********************************Got phoneID: ' + phoneId + '******************************');
        
        //Populate the picklist
        sidValues = new List<SelectOption>();
        sidvalues.add(new SelectOption('BLUSA','BLUSA'));
        sidvalues.add(new SelectOption('CANAD','CANAD'));
        
        //sidValues = new List<String>();
        //sidValues.add('BLUSA');
        //sidValues.add('CANAD');
        
        //IF ANI IS IN THE URL, THEN USE IT AND SEARCH FOR NUMBER
        String qry = 'select id, setid__c, ship_to_id__c, phone__c, account__c, Address_1__c, Address_2__c, City__c, State__c, Zip_Code__c, account_name__c ';
        qry += 'from Account_Phone__c ';
        qry += 'where Phone__c like \'%' + phoneNumber + '%\' ';
        qry += 'limit 500';
        
        //System.debug('************SOQL: ' + qry);
                
        //POPULATE searchResults
        searchResults = Database.query(qry);
    }
    
    /* Getter and setter methods for getting the user input from the UI */
    public String getshipTo(){
        return st;
    }
        
    public void setshipTo(String shipTo){
        this.shipTo = shipTo;
    }
    
    public String getsid(){
        return sid;
    }
        
    public void setsid(String sid){
        this.sid = sid;
    }
        
    public String getphoneNumber(){
        return phoneNumber;
    }
        
    public void setphoneNumber(String phoneNumber){
        this.phoneNumber = phoneNumber;
    }
    
    //Does this get the ID??
    public String getPhoneId() {
        return phoneId;
    }
    
    
        
    //public void setphoneId(String phoneId){
    //    this.phoneId = phoneId;
    //}
       
    /*End of Getter and Setter methods */
     
 
    //public String saveAndGoToAccount() {
    public PageReference saveAndGoToAccount() {
       
       //if(shipTo == null) {
       //    //system.debug('*******************ship to is null*********************');
       //}
       
       //if(sid == null) {
       //    //system.debug('*******************sid is null*********************');
       //}
       //else {
       //    //system.debug('*******************setid: ' + sid + '********************');
       //}
   
       //if(phoneNumber == null) {
       //    //system.debug('*******************phone number is null******************');
       //}
       
        
       try {
            //FIND ACCOUNT THAT PHONE NUMBER IS BEING ADDED TO AND GET THE ID        
            String acctQry = 'select id from Account where Setid__c = \'' + sid + '\' and Ship_To_Id__c = \'' + shipTo + '\' and Ship_To_Id__c != \'\' limit 1';
            acct = Database.query(acctQry);
                      
            //System.debug('****************Query: ' + acctQry + '*********************');
            //System.debug('****************Account ID: ' + acct.id + '********************');
            //System.debug('****************Ship To: ' + shipTo + '************************');
            //System.debug('****************Phone: ' + phoneNumber + '************************');
            //System.debug('****************Setid: ' + sid + '************************');
        
            //PUT THE ID INTO THE DATA BEING STORED IN ACCOUNT_PHONE__C AND ADD THE RECORD
            acctPhone = new Account_Phone__c();
            acctPhone.Account__c = acct.id;
            acctPhone.Ship_To_Id__c = shipTo;
            acctPhone.Phone__c = phoneNumber;
            acctPhone.Legacy_System_Id__c = sid + shipTo;
            acctPhone.SetId__c = sid;

            insert acctPhone;
        
            //USE ACCOUNT ID TO THEN SEND THE PATH TO THE ACCOUNT BACK
            PageReference acctPage = new ApexPages.StandardController(acct).view();
            acctPage.setRedirect(true);
            
            return acctPage;  
                  
        }
        
        catch(Exception ex){            
            //THIS MESSAGING NOT NEEDED, SINCE IT IS HANDLED WITH FIELD LEVEL MESSAGING (FIELDS ARE MARKED AS REQUIRED)
            //ApexPages.addMessages(ex);
            
            if (acct == null) {
                //system.debug('************************** acct is null - in catch block ********************************');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Account number not found. Please try again.'));
            }
            
            return null;
        }
    }
}