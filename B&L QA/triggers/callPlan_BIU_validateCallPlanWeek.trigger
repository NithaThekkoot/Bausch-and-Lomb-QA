/**
* 
* This trigger restrictes the Call Plan for duplication in the same week
* Author               |Author-Email                       |Date        |Comment
* ---------------------|---------------------------------- |------------|----------------------------------------------------
* Sourav Mitra         |sourav.mitra@listertechnologies.com|12.10.2010  |First Draft
*/
trigger callPlan_BIU_validateCallPlanWeek on Call_plan__c (before insert, before update)
{
    If(Trigger.new.size() == 1)
    {
        Id idRecordTypeCallPlan = [SELECT Id FROM RecordType 
                                        WHERE Name = 'APACSU Call Plan' AND SObjectType='Call_Plan__c'].Id;
       User objUser = [Select Id, Name,UserRoleId,UserRole.Name, Profile.Name From User Where Id=:Userinfo.getUserId()];
            System.debug('TRIGGER NAME:callPlan_BIU_validateCallPlanWeek objUser : ' + objUser); 
                      
        if(idRecordTypeCallPlan != null)
        {
            if(trigger.new[0].RecordTypeId == idRecordTypeCallPlan)
            {
               //added by cvsr
                  system.debug('@@@@@@@@@@@@@@@@@trigger record typeID------------->'+trigger.new[0].RecordTypeId);  
                List<Call_Plan__c> list_callPlan = new List<Call_Plan__c>();
                if(Trigger.New[0].Id != null)
                {
                    list_callPlan = [Select Id,
                                            name,
                                            Start_Date__c ,
                                            End_Date__c,
                                            OwnerId,
                                            RecordTypeId From Call_Plan__c where  RecordTypeId = :Trigger.New[0].RecordTypeId
                                                                        AND Start_Date__c = :Trigger.New[0].Start_Date__c
                                                                        AND End_Date__c = :Trigger.New[0].End_Date__c
                                                                        AND OwnerId = :Trigger.New[0].OwnerId
                                                                        AND Id != :Trigger.New[0].Id];
                                    
                
                }
                else
                {
                    list_callPlan = [Select Id,
                                            name,
                                            Start_Date__c ,
                                            End_Date__c,
                                            OwnerId,
                                            RecordTypeId From Call_Plan__c where  RecordTypeId = :Trigger.New[0].RecordTypeId
                                                                        AND Start_Date__c = :Trigger.New[0].Start_Date__c
                                                                        AND End_Date__c = :Trigger.New[0].End_Date__c
                                                                        AND OwnerId = :Trigger.New[0].OwnerId];
                }
                
                if(list_callPlan.size() > 0 && (ClsSingleMultiUtility.blnIsUpdateFromApproveReject == false))
                    Trigger.New[0].addError(Label.Duplicate_CallPlan_Error);               
                  
            }else{
            system.debug('@@@@@@@@@@@@@@@@@------->Based on Record type am not a Korea user---------------->');
            }
        }//18 line
      /* *******************************************************************************************************
      Added by Venkateswara Reddy Date:11/10/2015
      Call Plan for duplication in the same week for KOREA SOLTA Users
      ********************************************************************************************************** */
      
    if(objUser.UserRole.Name.contains('KOR SOLTA')){
    system.debug('@@@@@@@@@@@@@@@@@@------>T2 Based on Profile name am a KOREA USER--------------->');
      List<Call_Plan__c> list_callPlan = new List<Call_Plan__c>();
            //Check for any existing call plan excluding the current plan    
            if(Trigger.New[0].Id != null)
             {
                list_callPlan = [Select Id,
                                        name,
                                        Start_Date__c,
                                        End_Date__c,
                                        OwnerId 
                                        From Call_Plan__c where  
                                                                    Start_Date__c = :Trigger.New[0].Start_Date__c
                                                                    AND End_Date__c = :Trigger.New[0].End_Date__c
                                                                    AND OwnerId = :Trigger.New[0].OwnerId
                                                                    AND Id != :Trigger.New[0].Id];
                                
            
            } 
        //Check for any existing call plan
            else
            {
                list_callPlan = [Select Id,
                                        name,
                                        Start_Date__c,
                                        End_Date__c,
                                        OwnerId 
                                        From Call_Plan__c where  
                                                                    Start_Date__c = :Trigger.New[0].Start_Date__c
                                                                    AND End_Date__c = :Trigger.New[0].End_Date__c
                                                                    
                                                                    AND OwnerId = :Trigger.New[0].OwnerId];
            }//else block 
      
       //If any weekly call plan already available in the system for the given week, throw the error.
            if(list_callPlan.size() > 0 && (ClsSingleMultiUtility.blnIsUpdateFromApproveReject == false))
                Trigger.New[0].addError(Label.Duplicate_CallPlan_Error);    
        }//If  ProfileName
      
     }
     
   } //trigger