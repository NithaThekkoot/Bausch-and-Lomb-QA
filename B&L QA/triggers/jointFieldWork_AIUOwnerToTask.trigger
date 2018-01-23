/**
 * 
 *   This trigger creates Task for both owner and owner manager if Due_Date_Goal1__c, Due_Date_Goal2__c != null   
 *
 *    Author           |Author-Email                                   |Date       |Comment
 *    -----------------|-----------------------------------------------|-----------|--------------------------------------------------
 *    Harvin           |harvin.vincent@listertechnologies.com          |23.03.2010 |First draft
 *    Harvin           |harvin.vincent@listertechnologies.com          |05.10.2010 |First draft
 *   Saranya Sivakumar |saranya.sivakumar@listertechnologies.com       |20.10.2010 |Included the name field - deactivated workflow field update to reduce SOQL queries
 *   Sourav Mitra      |sourav.mitra@listertechnologies.com            |29.10.2010 |Added query instead of Trigger.new
 *
 */
trigger jointFieldWork_AIUOwnerToTask on Joint_Field_Work__c (after insert, after update) {
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate) && !clsPhysicianVisitUpdate.blnIsTriggerJTFieldOwnerToTask ) {
        Set<Id> set_recordTypeId = new Set<Id>();
        Set<Id> set_ownerId = new Set<Id>();
        RecordType oTaskRecordType = null;
        ClsPhysicanVisit.getPhysicanVisitRecordTypes();

        for (String key : ClsPhysicanVisit.map_staticRecordType.keySet()) {
            System.debug('key' + key);
            if (key == 'Joint_Field_Work__c-INDSU') {
                set_recordTypeId.add(ClsPhysicanVisit.map_staticRecordType.get(key));
            }
            if (key == 'Task-INDSU Task') {
                oTaskRecordType = ClsPhysicanVisit.map_staticRecordTypeObj.get(key);
            }
        }

        //Getting Record Type for Task & JointFieldWork
        /*for (RecordType oRecordType : [SELECT Id, Name
                                       FROM RecordType
                                       WHERE NAME IN('INDSU','INDSU Task')
                                       AND SObjectType IN ('Joint_Field_Work__c', 'Task')] ) {
          if (oRecordType.Name == 'INDSU Task') oTaskRecordType = oRecordType;
          if (oRecordType.Name == 'INDSU') set_recordTypeId.add(oRecordType.Id);                                    
        }*/ 
        System.debug('set_recordTypeId' + set_recordTypeId);
        System.debug('oTaskRecordType' + oTaskRecordType);
        List<Joint_Field_Work__c> list_jointFieldWork = new List<Joint_Field_Work__c>();
        // Adding JointFieldWork object whether it has recordType INDSU 
        for (Joint_Field_Work__c oJointFieldWork : [SELECT Id,Name,Due_Date_Goal1__c,Due_Date_Goal2__c,RecordTypeId,OwnerId,Activity_Date__c FROM Joint_Field_Work__c WHERE Id IN :Trigger.new]) 
        {
            System.debug(set_recordTypeId + '<<< >>>>' + oJointFieldWork.recordTypeId);
            if (set_recordTypeId.contains(oJointFieldWork.recordTypeId)) 
            {
                set_ownerId.add(oJointFieldWork.OwnerId);
                list_jointFieldWork.add(oJointFieldWork);
            }
        }
        
        //Addded by Saranya - Name field
        for(Joint_Field_Work__c objJntFldWrk : list_jointFieldWork)
        {
            objJntFldWrk.Name = 'Joint Field Work' + '-' + String.valueOf(objJntFldWrk.Activity_Date__c);
        }
        if(list_jointFieldWork.size()>0)
        {
            clsPhysicianVisitUpdate.blnIsTriggerJTFieldOwnerToTask = true;
            update list_jointFieldWork; 
        }
        
        System.debug(list_jointFieldWork + 'list_jointFieldWork');
        // Checking whether joint Field Work object available  
        if (list_jointFieldWork.size() > 0) {
            Map<Id,Id> map_IdUserId = new Map<Id,Id>();
            // Getting user , manager details
            for (User oUser : [SELECT Id, ManagerId
                               FROM User 
                               WHERE Id IN :set_ownerId]) {
                    map_IdUserId.put(oUser.Id, oUser.ManagerId);            
            }
            List<Task> list_task = new List<Task>();
            // Iterating JointFieldWork List
            // Verifying Due Date_Goal1__c , Due Date_Goal2__c != null
            for (Joint_Field_Work__c oJointFieldWork : list_jointFieldWork) {
                System.debug('oJointFieldWork.Due_Date_Goal1__c' + oJointFieldWork.Due_Date_Goal1__c);
                if (oJointFieldWork.Due_Date_Goal1__c != null) {
                    // Checking oJointFieldWork.Due_Date_Goal1__c for insert & update
                    if ((Trigger.isInsert && oJointFieldWork.Due_Date_Goal1__c != null) 
                        || (Trigger.isUpdate && oJointFieldWork.Due_Date_Goal1__c <> 
                            Trigger.oldMap.get(oJointFieldWork.Id).Due_Date_Goal1__c)) {
                         // Getting Task Details for Owner          
                         Task oTask = setTaskDetails('Goal 1_Due Date',oTaskRecordType,oJointFieldWork,
                                                     map_IdUserId,false);
                         if (oTask != null) list_task.add(oTask);
                         // Getting Task Details for Owner Manager
                         oTask = setTaskDetails('Goal 1_Due Date',oTaskRecordType,oJointFieldWork,
                                                map_IdUserId,true);
                         if (oTask != null) list_task.add(oTask);
                    }    
                }
                if (oJointFieldWork.Due_Date_Goal2__c != null) {
                    // Checking oJointFieldWork.Due_Date_Goal2__c for insert & update
                    if ((Trigger.isInsert && oJointFieldWork.Due_Date_Goal2__c != null) 
                        || (Trigger.isUpdate && oJointFieldWork.Due_Date_Goal2__c <> 
                            Trigger.oldMap.get(oJointFieldWork.Id).Due_Date_Goal2__c)) {
                         // Getting Task Details for Owner      
                         Task oTask = setTaskDetails('Goal 2 Due Date',oTaskRecordType,oJointFieldWork,
                                                     map_IdUserId,false);
                         if (oTask != null) list_task.add(oTask);
                         // Getting Task Details for Owner Manager
                         oTask = setTaskDetails('Goal 2 Due Date',oTaskRecordType,oJointFieldWork,
                                                map_IdUserId,true);
                         if (oTask != null) list_task.add(oTask);
                    }
                }  
            }
            if (list_task.size() > 0) insert list_task;
             
        } 
    }
    // method for setting task details  
    public Task setTaskDetails(String str_subject, 
            RecordType oRecordType, Joint_Field_Work__c oJointFieldWork, 
            Map<Id,Id> map_IdUserId, Boolean isManagerTask) {
        // Verifying this method called for creating task for manager but manager is not available      
        if (isManagerTask && map_IdUserId.get(oJointFieldWork.ownerId) == null) return null;    
        Task oTask = new Task();
        oTask.Subject = str_subject;
        oTask.Priority = 'Normal';
        oTask.Status = 'Not Started';
        // Setting Due Date for Task
        if (str_subject.contains('Goal 1')) {
            oTask.ActivityDate = oJointFieldWork.Due_Date_Goal1__c;
        } else {
            oTask.ActivityDate = oJointFieldWork.Due_Date_Goal2__c; 
        }
        // Setting ownerId
        if (isManagerTask) {
            oTask.OwnerId = map_IdUserId.get(oJointFieldWork.ownerId);
        } else { 
            oTask.OwnerId = oJointFieldWork.ownerId;
        }
        oTask.WhatId = oJointFieldWork.Id;
        oTask.recordTypeId = oRecordType.Id; 
        return oTask;
    }                                 
}