/*
* 
* This trigger fires on the update of Coach reporting and performs validations.
* if yes, changes the status and also calculates the total score.
* Author                        |Author-Email                                                |Date        |Comment
* ------------------------------|----------------------------------------------------------- |------------|-------------------------------------------------------------
* Raja B.,                      |rajamaruthu.balasubramanian@listertechnologies.com          |15.12.2010  |First Draft
*
* Test Class: Test_coachingReport_BIU_CalculateScores
*/
trigger coachingReport_BIU_CalculateScores on Coaching_Report__c (before insert, before update) {
	
	//Get settlement date
	Integer intSettlement = (CHNSU_CallReporting_Days__c.getValues('Current').Settlement_Date_Number__c).intValue();
    Date dtSettlement = Date.newInstance(Date.today().year(),Date.today().month(),intSettlement);
    
    //Valid calls per day
    Integer int_validCoachingCalls = (CHNSU_CallReporting_Days__c.getValues('Current').Valid_Coaching_Calls__c).intValue();
    
    //Variables
    Integer nTimeMgmtScore		= 0;
    Integer nPdtCallScore 		= 0;
    Integer nSalesCallPlanScore = 0;
    Integer nCustCallPlanScore 	= 0;
    Integer nSuitableCustScore 	= 0;
    Integer nCustRelnScore 		= 0;
    Integer nCommSkillScore 	= 0;
    Integer nHospFamiScore 		= 0;
    
    Integer nBiZResAnalScore 	= 0;
    Integer nSalesOppFindScore 	= 0;
    Integer nPushOppPdtScore 	= 0;
    
    Integer nOurPdtScore 		= 0;
    Integer nCompPdtScore 		= 0;
    
    Integer nOpeningScore 		= 0;
    Integer nInqAndLizScore 	= 0;
    Integer nPdtIntroScore 		= 0;
    Integer nConvOFFeatScore 	= 0;
    Integer nHandleObjScore 	= 0;
    Integer nDealScore 			= 0;
    Integer nUsePromMatScore 	= 0;
    
    Integer nLecSlidesScore 	= 0;
    
    Date dtFirstDate 			= Trigger.new[0].Date__c;
    Date dtSecondDate 			= Trigger.new[0].Date2__c;
    String strFirstSession 		= Trigger.new[0].Session__c;
    String strSecondSession 	= Trigger.new[0].Session1__c;
    
    //This execution will be done for single record only
    if(trigger.new.size() == 1){
    	
    	//Get the coaching report record type id
        RecordType objRecordType = [Select Id,name,sobjecttype from RecordType where sobjecttype='Coaching_Report__c' and Id = :trigger.New[0].RecordTypeId Limit 1];
               
        if(objRecordType != null){
        	
            String recordTypeName = objRecordType.Name;
            
            //execute for the specified record type only
            if(recordTypeName == 'CHNSU Coaching Report'){
            	                
                Set<Id> set_Id = ClsGettingChildRoles.getChild(userInfo.getUserRoleId(), 'CHNSU');
                
                User oUser = [Select Id, UserRoleId from User Where Id =: Trigger.new[0].Sales_Rep__c];
                
                Boolean isError = false;
                
                //The selected rep must reported to the logged in user
                if (set_Id != NULL && !set_Id.contains(oUser.UserRoleId)) {
                    isError = true;
                    Trigger.new[0].addError(Label.APAC_SU_Coaching_Report_Reporting);
                    return;
                }
                
                if(dtFirstDate==NULL){
                	isError = true;
                    Trigger.new[0].addError(Label.APAC_SU_Coaching_Report_Date1_should_not_be_empty);
                    return;
                }
                
                if(strFirstSession==NULL){
                	isError = true;
                    Trigger.new[0].addError(Label.APAC_SU_Coaching_Report_Date1_session_should_not_be_empty);
                    return;
                }
                
                //Date2 + Session2 should be larger than Date1 + Session1 validation
                if (dtFirstDate!=NULL && dtSecondDate!=NULL){
                	
                    if(dtFirstDate > dtSecondDate){
                        isError = true;
                        Trigger.new[0].addError(Label.APAC_SU_Coaching_Report_Date_2_Greater_Than_Date_1);
                        return;
                    }
                    if (dtSecondDate > Date.today()){
                        isError = true;
                        Trigger.new[0].addError(Label.APAC_SU_Coaching_Report_No_Future_Date);
                        return;
                    }
                    if (strSecondSession == NULL){
                        isError = true;
                        Trigger.new[0].addError(Label.APAC_SU_Coaching_Report_No_Future_Date);
                        return;
                    }

                    if (dtFirstDate == dtSecondDate){
                        if (strFirstSession == strSecondSession){
                            isError = true;
                            Trigger.new[0].addError(Label.APAC_SU_Coaching_Report_Session_Must_Be_Valid);
                            return;
                        }
                        if (strFirstSession == 'AM'){
                            if (strSecondSession == 'AM'){
                                isError = true;
                                Trigger.new[0].addError(Label.APAC_SU_Coaching_Report_Session_Must_Be_Valid);
                                return;
                            }
                        }
                        if (strFirstSession == 'PM'){
                            isError = true;
                            Trigger.new[0].addError(Label.APAC_SU_Coaching_Report_Session_Must_Be_Valid);
                            return;
                        }
                    }
                }
                
               	//If no error, check for the visited count for the given rep and date
                if (!isError) {
                    
                    //Check for visited date for Date1
                    /*Integer integer_date1count = [Select count() From Physician_Visit__c Where OwnerId =: Trigger.new[0].Sales_Rep__c 
                                                          And Activity_Date__c =: Trigger.new[0].Date__c
                                                          //And Coach__c =: UserInfo.getUserId()
                                                          //And Session__c =: strFirstSession
                                                          And Status__c = 'Completed'];
                                                          //AND Joint_Call_With_ASM__c = :true];

                    System.Debug('Date Count: ' + integer_date1count);
                    System.Debug('ValidCoachingCalls: ' + int_validCoachingCalls);
                    
                    if (integer_date1count < int_validCoachingCalls) {
                            Trigger.new[0].addError(Label.APAC_SU_Coaching_Report_No_Joint_Call_Date1);
                            return;
                    }
                    
                    //Check for visited date for Date2
                    if (dtSecondDate != NULL){
                       Integer integer_date2count = [Select count() From Physician_Visit__c Where OwnerId =: Trigger.new[0].Sales_Rep__c 
                                                          And Activity_Date__c =: Trigger.new[0].Date2__c
                                                          //And Coach__c =: UserInfo.getUserId()
                                                          //And Session__c =: strSecondSession
                                                          And Status__c =: 'Completed'];
                                                          //AND Joint_Call_With_ASM__c = :true];
                        
                        if (integer_date2count != int_validCoachingCalls && integer_date2count < int_validCoachingCalls) {
                            Trigger.new[0].addError(Label.APAC_SU_Coaching_Report_No_Joint_Call_Date2);
                            return;
                        }
                    }*/ 
                    
                     Trigger.new[0].Status__c = 'Completed';
                    
                     //Do the calculation for 'Sales Call Management' section
                     if(Trigger.new[0].A_1__c != NULL)
                        nTimeMgmtScore = Integer.ValueOf(Trigger.new[0].A_1__c);
                     if(Trigger.new[0].A_2__c != NULL)
                        nPdtCallScore = Integer.ValueOf(Trigger.new[0].A_2__c);
                     if(Trigger.new[0].A_3__c != NULL)
                        nSalesCallPlanScore = Integer.ValueOf(Trigger.new[0].A_3__c);
                     if(Trigger.new[0].A_4__c != NULL)
                        nCustCallPlanScore = Integer.ValueOf(Trigger.new[0].A_4__c);
                     if(Trigger.new[0].A_5__c != NULL)
                        nSuitableCustScore = Integer.ValueOf(Trigger.new[0].A_5__c);
                     if(Trigger.new[0].A_6__c != NULL)
                        nCustRelnScore = Integer.ValueOf(Trigger.new[0].A_6__c);
                     if(Trigger.new[0].A_7__c != NULL)
                        nCommSkillScore = Integer.ValueOf(Trigger.new[0].A_7__c);
                     if(Trigger.new[0].A_8__c != NULL)
                        nHospFamiScore = Integer.ValueOf(Trigger.new[0].A_8__c);
                    
                     //Do the calculation for 'Marketing Sensitivity' section
                     if(Trigger.new[0].B_1__c != NULL)
                        nBiZResAnalScore = Integer.ValueOf(Trigger.new[0].B_1__c);
                     if(Trigger.new[0].B_2__c != NULL)
                        nSalesOppFindScore = Integer.ValueOf(Trigger.new[0].B_2__c);
                     if(Trigger.new[0].B_3__c != NULL)
                        nPushOppPdtScore = Integer.ValueOf(Trigger.new[0].B_3__c);
                    
                     //Do the calculation for 'Product Knowledge' section
                     if(Trigger.new[0].C_1__c != NULL)
                        nOurPdtScore = Integer.ValueOf(Trigger.new[0].C_1__c);
                     if(Trigger.new[0].C_2__c != NULL)
                        nCompPdtScore = Integer.ValueOf(Trigger.new[0].C_2__c);
                    
                     //Do the calculation for 'Selling Skill' section
                     if(Trigger.new[0].D_1__c != NULL)
                        nOpeningScore = Integer.ValueOf(Trigger.new[0].D_1__c);
                     if(Trigger.new[0].D_2__c != NULL)
                        nInqAndLizScore = Integer.ValueOf(Trigger.new[0].D_2__c);
                     if(Trigger.new[0].D_3__c != NULL)
                        nPdtIntroScore = Integer.ValueOf(Trigger.new[0].D_3__c);
                     if(Trigger.new[0].D_4__c != NULL)
                        nConvOFFeatScore = Integer.ValueOf(Trigger.new[0].D_4__c);
                     if(Trigger.new[0].D_5__c != NULL)
                        nHandleObjScore = Integer.ValueOf(Trigger.new[0].D_5__c);
                     if(Trigger.new[0].D_6__c != NULL)
                        nDealScore = Integer.ValueOf(Trigger.new[0].D_6__c);
                     if(Trigger.new[0].D_7__c != NULL)
                        nUsePromMatScore = Integer.ValueOf(Trigger.new[0].D_7__c);
                        
                 	//Do the calculation for 'Lecture Slides Skill (if has)' section
                 	if(Trigger.new[0].E_1__c != NULL)
                    	nLecSlidesScore = Integer.ValueOf(Trigger.new[0].E_1__c);
                    	
                    //Calculate Total Score
                    Trigger.new[0].Total_Score__c = Integer.ValueOf(nTimeMgmtScore)+
                                                    	Integer.ValueOf(nPdtCallScore)+
                                                    	Integer.ValueOf(nSalesCallPlanScore)+
                                                    	Integer.ValueOf(nCustCallPlanScore)+
                                                    	Integer.ValueOf(nSuitableCustScore)+
                                                    	Integer.ValueOf(nCustRelnScore)+
                                                    	Integer.ValueOf(nCommSkillScore)+
                                                    	Integer.ValueOf(nHospFamiScore)+
                                                    	Integer.ValueOf(nBiZResAnalScore)+
                                                    	Integer.ValueOf(nSalesOppFindScore)+
                                                    	Integer.ValueOf(nPushOppPdtScore)+
                                                    	Integer.ValueOf(nOurPdtScore)+
                                                    	Integer.ValueOf(nCompPdtScore)+
                                                    	Integer.ValueOf(nOpeningScore)+
                                                    	Integer.ValueOf(nInqAndLizScore)+
                                                    	Integer.ValueOf(nPdtIntroScore)+
                                                    	Integer.ValueOf(nConvOFFeatScore)+
                                                    	Integer.ValueOf(nHandleObjScore)+
                                                    	Integer.ValueOf(nDealScore)+
                                                    	Integer.ValueOf(nUsePromMatScore)+
                                                    	Integer.ValueOf(nLecSlidesScore);
             		Trigger.new[0].OwnerId =   Trigger.new[0].Sales_Rep__c;
             		Trigger.new[0].Coach__c =  userInfo.getUserId();       
                  
                }
        	}
                
            
        }
    }

}