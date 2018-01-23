/**
* 
* This trigger restrictes the month of a call plan record to the current or next month and the year to the current year , by validating both.
* It also checks if record for the choosden month year combination already exists .
* Author               |Author-Email                       |Date        |Comment
* ---------------------|---------------------------------- |------------|----------------------------------------------------
* Yash Agarwal         |yash.agarwal@listertechnologies.com|13.05.2010  |First Draft
* Sourav Mitra         |sourav.mitra@listertechnologies.com|01.09.2010  |Changes to incorporate China
* Sourav Mitra         |sourav.mitra@listertechnologies.com|12.10.2010  |Changes to make China SU call plan weekly
* Parag Sharma         |Parag.Sharma@rishabhsoft.com       |12.04.2013  |Added code for SFE Custom Report 
*/
trigger callPlan_BIU_validateCallPlan on Call_plan__c (before insert, before update)
{
    If(Trigger.new.size() == 1)
    {
            /* Start Logic for Custom Report by Parag Sharma */
            //Get the user values.
            User objUser = [Select Id, Name, APAC_Country__c, APAC_Region__c, APAC_Area__c, UserRoleId,UserRole.Name, Profile.Name From User Where Id=:Userinfo.getUserId()];
            System.debug('objUser : ' + objUser); 
            //Addedy cvsr stsrt
            system.debug('@@@@@@@@@@@@@@user profile name------------>'+objUser.Profile.Name);
            
            //added by cvsr end        
            List<Call_Plan__c> objTriggerNew = new List<Call_Plan__c>();
            objTriggerNew = Trigger.New;
            System.debug('objTriggerNew : ' + objTriggerNew);
            DateTime d = datetime.now();
            String YearName= d.format('yyyy');
            String monthName= d.format('MMMMM');
            String strMonth = String.valueOf(monthName.substring(0,3));  
            String strINDProfile = '';
            IF(objUser.Profile.Name == 'INDSU Sales Rep' || objUser.Profile.Name=='INDAES Sales Rep' || objUser.Profile.Name == 'INDSU Service Rep'){
                strINDProfile = objUser.Profile.Name;
                trigger.new[0].City__c = objUser.APAC_Area__c;
                trigger.new[0].Region__c = objUser.APAC_Region__c;
                trigger.new[0].Country__c = objUser.APAC_Country__c;
          system.debug('User profile name------->'+objUser.Profile.Name+'@@@@@@@@@@@BL SYSTEM ADMIN SSO city-->'+trigger.new[0].City__c+'-----REGION---->'+trigger.new[0].Region__c+'----Countrty----->'+trigger.new[0].Country__c);
            }
           
             
            trigger.new[0].Year__c = YearName;
            trigger.new[0].Month__c = strMonth;
            system.debug('Current year----->'+trigger.new[0].Year__c+'---And current mnth--->'+trigger.new[0].Month__c);
             integer noOfContactsOfSalesRep  = 0;
             integer noOfContactsOfSalesRepofA  = 0;
             integer noOfContactsOfSalesRepofB  = 0;
             integer noOfContactsOfSalesRepofC  = 0;         
             integer noOfContactsOfSalesRepOthers  = 0;
             
             
             
             
             //other than KOREA users start
             IF(objUser.Profile.Name.startsWith('INDSU') == true || objUser.Profile.Name.startsWith('INDAES') == true) {
                 //IF(!Test.isRunningTest()){             
                     //Get the list of accounts where the found user is an account team member
                     
                     //added by cvsr
                      system.debug('@@@@@@@@@@@@@@In if condition checking for user and set the user details to call plan obj----->');
                     List<AccountTeamMember> lstATM = [Select id, accountId FROM AccountTeamMember where userId =: objTriggerNew[0].OwnerId];
                    Set<Id> setATM = New Set<Id>();
                    FOR(AccountTeamMember ATM: lstATM){
                        setATM.add(ATM.accountId);
                    }
                    System.debug('Test = '+setATM.size());
                    List<Contact_Profile__c> lstConProfile = [Select Id, Name, Doctor_Segmentation__c FROM Contact_Profile__c WHERE Contact__r.AccountId IN : setATM];
                    System.debug('Contact.size() = '+lstConProfile.size()); 
                    noOfContactsOfSalesRep = lstConProfile.size();
                    IF(lstConProfile.size() > 0){
                        FOR(Contact_Profile__c CPP: lstConProfile){
                            IF(CPP.Doctor_Segmentation__c == 'A'){
                                noOfContactsOfSalesRepofA = noOfContactsOfSalesRepofA + 1;
                            }
                            IF(CPP.Doctor_Segmentation__c == 'B'){
                                noOfContactsOfSalesRepofB = noOfContactsOfSalesRepofB + 1;
                            }
                            IF(CPP.Doctor_Segmentation__c == 'C'){
                                noOfContactsOfSalesRepofC = noOfContactsOfSalesRepofC + 1;
                            }
                            IF(CPP.Doctor_Segmentation__c != 'A' && CPP.Doctor_Segmentation__c != 'B' && CPP.Doctor_Segmentation__c != 'C'){
                                noOfContactsOfSalesRepOthers = noOfContactsOfSalesRepOthers + 1;
                            }
                        }
                     }
                    trigger.new[0].Number_of_Contacts_of_A__c = noOfContactsOfSalesRepofA;
                    trigger.new[0].Number_of_Contacts_of_B__c = noOfContactsOfSalesRepofB;
                    trigger.new[0].Number_of_Contacts_of_C__c = noOfContactsOfSalesRepofC;
                    trigger.new[0].Number_of_Contacts_of_Others__c = noOfContactsOfSalesRepOthers;
                    trigger.new[0].Number_of_Contacts__c = trigger.new[0].Number_of_Contacts_of_A__c + trigger.new[0].Number_of_Contacts_of_B__c + trigger.new[0].Number_of_Contacts_of_C__c + trigger.new[0].Number_of_Contacts_of_Others__c;
                 //} 
                 
            }//IF other than KOREA users start
            
            /* End Logic for Custom Report by Parag Sharma */
            
        /*************************************************************************
        ** Variable Declerations
        *************************************************************************/
        Date datCurrentDate = Date.today(); //  todays date to evaluate current mont ha dn year
        String strValidYear =  String.valueOf(datCurrentDate.year()); // valid year
        Id idCurrentUser ;
        if(Trigger.isInsert)
            idCurrentUser= UserInfo.getUserId(); // id of the current user
        else
            idCurrentUser = Trigger.new[0].OwnerId;
            
        //Id idRecordTypeCallPlan = [SELECT Id FROM RecordType 
                                       // WHERE Name IN ('INDSU Call Plan','APACSU Call Plan') AND SObjectType='Call_Plan__c'].Id;
        
        Set<Id> set_idRecTypes = new Set<Id>();
        /*
        for(RecordType rt:[SELECT Id FROM RecordType WHERE Name IN ('INDSU Call Plan','APACSU Call Plan') AND SObjectType='Call_Plan__c'])
            set_idRecTypes.add(rt.Id);
        */
        for(RecordType rt:[SELECT Id FROM RecordType WHERE Name IN ('INDSU Call Plan') AND SObjectType='Call_Plan__c'])
            set_idRecTypes.add(rt.Id);
        
        // Perform year and month validations only for India SU 
        if(set_idRecTypes.contains(Trigger.New[0].RecordTypeId) || objUser.Profile.Name == 'BL: System Admin SSO' )
        {
            Map<Integer,String> MAP_MONTHNO_MONTHNAME = new Map<Integer,String>(); // map for obtaining the month names as in the picklist from Month nos
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
            
            String[] list_ValidMonths = new List<String>(); // string containing valid months
            list_validMonths.add(MAP_MONTHNO_MONTHNAME.get(datCurrentDate.month()));
            if(datCurrentDate.month() != 12)
                list_validMonths.add(MAP_MONTHNO_MONTHNAME.get(datCurrentDate.month() + 1));
                
            
            
            /*************************************************************************
            **Validating the different conditons
            *************************************************************************/
            
            if(list_validMonths.size() >1)
            {
                if(!(Trigger.New[0].Month__c == list_validMonths[0] || Trigger.New[0].Month__c == list_validMonths[1]))
                {
                    Trigger.New[0].addError('Call can be planned only for current or next month');
                }
            }
            else
            {
                if(Trigger.New[0].Month__c != list_validMonths[0])
                {
                    Trigger.New[0].addError('Call can be planned only for current month');
                }
            }
            
            if(Trigger.New[0].year__c != strValidYear)
            {
                Trigger.New[0].addError('Call can be planned only for the current year');
            }
            
            
            Call_Plan__c[] list_existingCallPlans;
            
            if(Trigger.New[0].Id == null)
            {
                list_existingCallPlans = [Select Id,
                                            name,
                                            Year__c,
                                            Status__c,
                                            Month__c,
                                            Manager_Comments__c,
                                            Executive_Comments__c,
                                            OwnerId From Call_Plan__c where Month__c = :Trigger.New[0].Month__c
                                                                        AND year__c = :Trigger.New[0].Year__c
                                                                        AND OwnerId = :idCurrentUser
                                                                        AND Status__c!= 'Rejected'
                                                                        AND RecordTypeId IN :set_idRecTypes];
            }
            else
            {
                list_existingCallPlans = [Select Id,
                                            name,
                                            Year__c,
                                            Status__c,
                                            Month__c,
                                            Manager_Comments__c,
                                            Executive_Comments__c,
                                            OwnerId From Call_Plan__c where Month__c = :Trigger.New[0].Month__c
                                                                        AND year__c = :Trigger.New[0].Year__c
                                                                        AND OwnerId = :idCurrentUser
                                                                        AND Id != :Trigger.New[0].Id
                                                                        AND Status__c!= 'Rejected'
                                                                        AND RecordTypeId IN :set_idRecTypes];
            }
            
            if(list_existingCallPlans.size()>0)
            {
                Trigger.New[0].addError('Call Plan record for the choosen Month - Year combination already exists');
            }else{
        system.debug('MY KOREA ERROR MSGS NOT DISP');
        }
        }//line 170
        
        
    }//line 15
}