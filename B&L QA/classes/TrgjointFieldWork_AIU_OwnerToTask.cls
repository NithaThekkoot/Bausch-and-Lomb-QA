/**
 * 
 *   Test class for trigger "jointFieldWork_AIUOwnerToTask"
 * 
 *    Author         |Author-Email                           |Date       |Comment
 *    ---------------|---------------------------------------|-----------|--------------------------------------------------
 *    Harvin         |harvin.vincent@listertechnologies.com  |23.03.2010 |First draft
 *Santosh Kumar S     | santosh.sriram@listertechnologies.com   | 10.03.2011  | Changing INDSU to APACSU System Admin
 */
@isTest
private class TrgjointFieldWork_AIU_OwnerToTask {

    static testMethod void testCase_AIU_ownerToTask() {
        Profile oProfile = [SELECT Id 
                           FROM profile 
                           WHERE name='APACSU System Administrator']; 
        User oUserManager = new User(alias = 'standt1', 
                             email='standarduser1@testorg.com', 
                             emailencodingkey='UTF-8',
                             lastname='Testing1',
                             languagelocalekey='en_US', 
                             localesidkey='en_US', 
                             profileid = oProfile.Id, 
                             timezonesidkey='America/Los_Angeles',
                             username='standarduser101@testorg.com');     
        insert oUserManager;                                       
        User oUser = new User(alias = 'standt', 
                             email='standarduser@testorg.com1', 
                             emailencodingkey='UTF-8',
                             lastname='Testing',
                             languagelocalekey='en_US', 
                             localesidkey='en_US', 
                             profileid = oProfile.Id,
                             managerId = oUserManager.Id,  
                             timezonesidkey='America/Los_Angeles',
                             username='standarduser210@testorg.com');
        insert oUser;
        System.runAs(oUser) {
            List<RecordType> list_recordType = new List<RecordType>();
            list_recordType = [SELECT Id
                              FROM RecordType
                              WHERE Name IN ('INDSU') 
                              AND SObjectType='Joint_Field_Work__c'];
            if (list_recordType.size() == 0) return;
            // Testing for Insert                  
            Joint_Field_Work__c oJointFieldWork = new Joint_Field_Work__c (
                    Due_Date_Goal2__c = Date.today(),
                    Demo_products_effictivily_used__c = 'None',
                    Demo_Products_Comments__c = 'testing',
                    Call_Objective__c = 'Testing',
                    //Due_Date_Goal1__c = Date.today() + 5, 
                    Due_Date_Goal1__c = System.today().addDays(5),
                    RecordTypeId = list_recordType.get(0).Id,
                    OwnerId = oUser.Id
                    );// Setting values for Joint Field Work
            insert oJointFieldWork;
            
            List<Task> list_task = [SELECT Id, Subject
                                    FROM Task
                                    WHERE WhatId =:oJointFieldWork.Id];
            //System.assertEquals(4, list_task.size());
            
            // Test for Bulk Insert 
            List<Joint_Field_Work__c> list_jointFieldWork = new List<Joint_Field_Work__c>();                        
            for ( Integer j = 0; j < 25; j++ ) {
                if ( j < 10 ) {
                    oJointFieldWork = new Joint_Field_Work__c (
                        Due_Date_Goal2__c = Date.today(),
                        Demo_products_effictivily_used__c = 'None',
                        Demo_Products_Comments__c = 'testing',
                        Call_Objective__c = 'Testing',
                        Due_Date_Goal1__c = Date.today() + j, 
                        RecordTypeId = list_recordType.get(0).Id,
                        OwnerId = oUser.Id
                        ); // creating Joint Field Work with Due_Date_Goal1 && Due_Date_Goal1 != null 
               } else if (j > 9 && j < 15) {
                  oJointFieldWork = new Joint_Field_Work__c (
                        Demo_products_effictivily_used__c = 'None',
                        Demo_Products_Comments__c = 'testing',
                        Call_Objective__c = 'Testing',
                        Due_Date_Goal1__c = Date.today() + j, 
                        RecordTypeId = list_recordType.get(0).Id,
                        OwnerId = oUser.Id
                        ); // creating Joint Field Work with Due_Date_Goal2 != null
               } else {
                  oJointFieldWork = new Joint_Field_Work__c (
                        Demo_products_effictivily_used__c = 'None',
                        Demo_Products_Comments__c = 'testing',
                        Call_Objective__c = 'Testing',
                        RecordTypeId = list_recordType.get(0).Id,
                        OwnerId = oUser.Id
                        ); // creating Joint Field Work with both Due_Date_Goal1, Due_Date_Goal2 == null 
               }
               list_jointFieldWork.add(oJointFieldWork);     
            }                       
            insert list_jointFieldWork;
            Set<Id> set_jointFieldId = new Set<Id>();
            for (Joint_Field_Work__c oJointWork :list_jointFieldWork) {
                set_jointFieldId.add(oJointWork.Id);
            } 
            
            list_task = [SELECT Id, Subject
                                    FROM Task
                                    WHERE WhatId IN:set_jointFieldId];
            //System.assertEquals(list_task.size(), 50);
            // Test for bulk update
            //list_jointFieldWork = new List<Joint_Field_Work__c>();
            Integer int_counter = 0;
            for (Joint_Field_Work__c oJointWork :list_jointFieldWork) {
                if (oJointWork.Due_Date_Goal1__c != null &&
                                        oJointWork.Due_Date_Goal2__c != null) {
                    if (int_counter < 2) {
                        oJointWork.Due_Date_Goal1__c = Date.today() + 50;
                        int_counter++;
                    }       
                } else if (oJointWork.Due_Date_Goal1__c != null) {
                    if (int_counter < 4) {
                        oJointWork.Due_Date_Goal2__c = Date.today() + 50;
                        int_counter++;
                    }                                 
                }   
                //list_jointFieldWork.add(oJointWork);  
            }
            update list_jointFieldWork; 
            list_task = [SELECT Id, 
                                Subject,WhatId, RecordTypeId,
                                Priority,Status,ActivityDate
                        FROM Task
                        WHERE WhatId IN:set_jointFieldId];
            //System.assertEquals(list_task.size(), 58);
            // Task record checking
            RecordType oTaskRecordType = [SELECT Id
                                          FROM RecordType
                                          WHERE Name IN ('INDSU Task') 
                                          AND SObjectType='Task'];
            for (Task oTask : list_task) {
                Joint_Field_Work__c oJointWork = list_jointFieldWork.get(0);
                if (oTask.WhatId == oJointWork.Id) {
                    System.assertEquals(oTask.recordTypeId,oTaskRecordType.Id);
                    if (oTask.Subject.contains('Goal 1')) {
                        System.assertEquals(oTask.Subject, 'Goal 1_Due Date');
                        System.assertEquals(oTask.Priority, 'Normal');
                        System.assertEquals(oTask.Status, 'Not Started');
                        if (oTask.ActivityDate > Date.today()) {
                            System.assertEquals(oTask.ActivityDate,Date.today() + 50);
                        } else {
                            System.assertEquals(oTask.ActivityDate,Date.today());
                        }   
                    } else {
                        System.assertEquals(oTask.Subject, 'Goal 2 Due Date');
                        System.assertEquals(oTask.Priority, 'Normal');
                        System.assertEquals(oTask.Status, 'Not Started');
                        if (oTask.ActivityDate > Date.today()) {
                            System.assertEquals(oTask.ActivityDate,Date.today() + 50);
                        } else {
                            System.assertEquals(oTask.ActivityDate,Date.today());
                        }
                    } // Testing for Task Details
                }
            }   
            //jointFieldWork_AIUOwnerToTask.setTaskDetails()                    
        }                                          
    }
}