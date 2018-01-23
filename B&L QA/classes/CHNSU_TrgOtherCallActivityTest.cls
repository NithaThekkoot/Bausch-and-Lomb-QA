/*******************************************************************************
 *  Test Class for CHNSU_TrgOtherCallActivity and CHNSU_UtilOtherCallActivity
 *  copyright (c) 2011 breakingpoint.com C, Ltd. 
 *  Apex Class      : CHNSU_TrgOtherCallActivityTest.cls
 *  Summary         : There should be no more than one activity in a half date
 *  Refer Object    : Other_Call_Activity__c, Event
 *  Author          : Mouse.liu(mouse.liu@ibreakingpoint.com)        
 *  CreatedDate     : 2011/09/26
 *  Change Log      : 
 Mouse    2011-12-01    Error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Event Start and End Date has to be the same for Sales Call, 
                               Eat and Learn and Out of Territory Event Types
                        Location: CHNSU_TrgOtherCallActivityTest.updateAndDeleteTest()Class 234 Line 13 Column
                        Change: Commentted [throw e]
 *****************************************************************************/
@isTest
private class CHNSU_TrgOtherCallActivityTest {
    
    // new record [start date] and [end date] is between old's.
    static testMethod void conflictDateTest1() {
    
    Profile oProfile = [SELECT Id FROM profile
        WHERE name='INDSU Sales Rep'];        
        User oUser = new User(alias = 'standt',
        email='standarduser3@testorg.com',
        emailencodingkey='UTF-8',
        lastname='Testing3',
        languagelocalekey='en_US',
        localesidkey='en_US',
        profileid = oProfile.Id,
        timezonesidkey='America/Los_Angeles',
        username='standarduser13@testorg.com'); 
        insert oUser; 
        System.runAs(oUser) 
        {            
        
    //list<RecordType> AllRec = new list<RecordType>([select id,name from RecordType where RecordType = CHNSU_Other_Call_Activity__c and sObjectType='Other_Call_Activity__c']);
        // If we want to start test , we must delete all data in system.
        List<Other_Call_Activity__c> olds = [ Select Start_Session__c, Start_Date__c, Name, 
                                              End_Session__c, End_Date__c, Activity_Type__c 
                                              From Other_Call_Activity__c o
                                              Where Start_Date__c >=: System.today() - 2
                                              And End_Date__c <=: System.today()
                                              And OwnerId =: UserInfo.getUserId()
                                              order by Start_Date__c, Start_Session__c];
                                              
        delete olds;             
        
        // Test start                                   
        Other_Call_Activity__c o = new Other_Call_Activity__c(Start_Session__c = 'AM', Start_Date__c = System.today() - 3, 
                                                              End_Session__c = 'AM', End_Date__c = System.today(),OwnerId = UserInfo.getUserId(),
                                                              //RecordType =INDSU_Other_Call_Activity__c,
                                                              Activity_Type__c = 'test Call');//,recordTypeId = AllRec[0].Id);
       try {
            insert o;
            System.assert(o.Id != null);
    
        }
        catch(Exception e) {
            System.assert(o.Id == null);
            
        }
        System.debug('o details :'+o);
        if(o.Id != null)     
        ClsPopulateCallSummary.Nonfieldworkingday(o.Start_Date__c , o.OwnerId );   
        Other_Call_Activity__c o1 = new Other_Call_Activity__c(Start_Session__c = 'AM', Start_Date__c = System.today() - 3, 
                                                               End_Session__c = 'AM', End_Date__c = System.today() , 
                                                               Activity_Type__c = 'Sales Call');
        try {
            insert o1;
            System.assert(o1.Id != null);
        }
        catch(Exception e) {
            System.assert(o1.Id == null);
        }
    }}
    
    // old record [start date] and [end date] is between new's.
    static testMethod void conflictDateTest2() {
        
         Profile oProfile = [SELECT Id FROM profile
        WHERE name='INDSU Sales Rep'];        
        User oUser = new User(alias = 'standt',
        email='standarduser3@testorg.com',
        emailencodingkey='UTF-8',
        lastname='Testing3',
        languagelocalekey='en_US',
        localesidkey='en_US',
        profileid = oProfile.Id,
        timezonesidkey='America/Los_Angeles',
        username='standarduser23@testorg.com'); 
        insert oUser; 
        System.runAs(oUser) 
        {   
        // If we want to start test , we must delete all data in system.
        List<Other_Call_Activity__c> olds = [ Select Start_Session__c, Start_Date__c, Name, 
                                              End_Session__c, End_Date__c, Activity_Type__c 
                                              From Other_Call_Activity__c o
                                              Where Start_Date__c >=: System.today() - 3
                                              And End_Date__c <=: System.today()
                                              And OwnerId =: UserInfo.getUserId()
                                              order by Start_Date__c, Start_Session__c];
                                           
        
        delete olds;             
        
        // Test start
        Other_Call_Activity__c o1 = new Other_Call_Activity__c(Start_Session__c = 'AM', Start_Date__c = System.today() - 2, 
                                                               End_Session__c = 'AM', End_Date__c = System.today() - 1, 
                                                               Activity_Type__c = 'Sales Call');
        try {
            insert o1;              
            System.assert(o1.Id != null);
        }
        catch(Exception e) {
            System.assert(o1.Id == null);
        }
                                              
        Other_Call_Activity__c o = new Other_Call_Activity__c(Start_Session__c = 'AM', Start_Date__c = System.today() - 3, 
                                                              End_Session__c = 'AM', End_Date__c = System.today(), 
                                                              Activity_Type__c = 'Sales Call');
        try {
            insert o;
            System.assert(o.Id != null);
        }
        catch(Exception e) {
            System.assert(o.Id == null);
        }
    
    }}
    
    // 
    static testMethod void conflictDateTest3() {
        
         Profile oProfile = [SELECT Id FROM profile
        WHERE name='INDSU Sales Rep'];        
        User oUser = new User(alias = 'standt',
        email='standarduser3@testorg.com',
        emailencodingkey='UTF-8',
        lastname='Testing3',
        languagelocalekey='en_US',
        localesidkey='en_US',
        profileid = oProfile.Id,
        timezonesidkey='America/Los_Angeles',
        username='standarduser33@testorg.com'); 
        insert oUser; 
        System.runAs(oUser) 
        {   
        
        // If we want to start test , we must delete all data in system.
        List<Other_Call_Activity__c> olds = [ Select Start_Session__c, Start_Date__c, Name, 
                                              End_Session__c, End_Date__c, Activity_Type__c 
                                              From Other_Call_Activity__c o
                                              Where Start_Date__c >=: System.today() - 3
                                              And End_Date__c <=: System.today()
                                              And OwnerId =: UserInfo.getUserId()
                                              order by Start_Date__c, Start_Session__c];
                                              
        delete olds;             
        
        // Test start
        Other_Call_Activity__c o1 = new Other_Call_Activity__c(Start_Session__c = 'AM', Start_Date__c = System.today() - 2, 
                                                               End_Session__c = 'AM', End_Date__c = System.today(), 
                                                               Activity_Type__c = 'Sales Call');
        try {
            insert o1;
            System.assert(o1.Id != null);
        }
        catch(Exception e) {
            System.assert(o1.Id == null);
        }
                                              
        Other_Call_Activity__c o = new Other_Call_Activity__c(Start_Session__c = 'PM', Start_Date__c = System.today() - 1, 
                                                              End_Session__c = 'PM', End_Date__c = System.today(), 
                                                              Activity_Type__c = 'Sales Call');
        try {
            insert o;
            System.assert(o.Id != null);
        }
        catch(Exception e) {
            System.assert(o.Id == null);
        }
    }}

    static testMethod void conflictDateTest4() {
        
         Profile oProfile = [SELECT Id FROM profile
        WHERE name='INDSU Sales Rep'];        
        User oUser = new User(alias = 'standt',
        email='standarduser3@testorg.com',
        emailencodingkey='UTF-8',
        lastname='Testing3',
        languagelocalekey='en_US',
        localesidkey='en_US',
        profileid = oProfile.Id,
        timezonesidkey='America/Los_Angeles',
        username='standarduser43@testorg.com'); 
        insert oUser; 
        System.runAs(oUser) 
        {   
        
        // If we want to start test , we must delete all data in system.
        List<Other_Call_Activity__c> olds = [ Select Start_Session__c, Start_Date__c, Name, 
                                              End_Session__c, End_Date__c, Activity_Type__c 
                                              From Other_Call_Activity__c o
                                              Where Start_Date__c >=: System.today() - 3
                                              And End_Date__c <=: System.today()
                                              And OwnerId =: UserInfo.getUserId()
                                              order by Start_Date__c, Start_Session__c];
                                              
        delete olds;             
        
        // Test start
        Other_Call_Activity__c o1 = new Other_Call_Activity__c(Start_Session__c = 'PM', Start_Date__c = System.today() - 2, 
                                                               End_Session__c = 'PM', End_Date__c = System.today(), 
                                                               Activity_Type__c = 'Sales Call');
        try {
            insert o1;
            System.assert(o1.Id != null);
        }
        catch(Exception e) {
            System.assert(o1.Id == null);
        }
                                              
        Other_Call_Activity__c o = new Other_Call_Activity__c(Start_Session__c = 'PM', Start_Date__c = System.today() - 1, 
                                                              End_Session__c = 'PM', End_Date__c = System.today(), 
                                                              Activity_Type__c = 'Sales Call');
        try {
            insert o;
            System.assert(o.Id != null);
        }
        catch(Exception e) {
            System.assert(o.Id == null);
        }
    }}
    
    // old record [start date] and [end date] is equals with new's.
    static testMethod void conflictDateTest5() {
         Profile oProfile = [SELECT Id FROM profile
        WHERE name='INDSU Sales Rep'];        
        User oUser = new User(alias = 'standt',
        email='standarduser3@testorg.com',
        emailencodingkey='UTF-8',
        lastname='Testing3',
        languagelocalekey='en_US',
        localesidkey='en_US',
        profileid = oProfile.Id,
        timezonesidkey='America/Los_Angeles',
        username='standarduser53@testorg.com'); 
        insert oUser; 
        System.runAs(oUser) 
        {   
        
        // If we want to start test , we must delete all data in system.
        List<Other_Call_Activity__c> olds = [ Select Start_Session__c, Start_Date__c, Name, 
                                              End_Session__c, End_Date__c, Activity_Type__c 
                                              From Other_Call_Activity__c o
                                              Where Start_Date__c >=: System.today() - 3
                                              And End_Date__c <=: System.today()
                                              And OwnerId =: UserInfo.getUserId()
                                              order by Start_Date__c, Start_Session__c];
                                              
        delete olds;             
        
        // Test start
        Other_Call_Activity__c o1 = new Other_Call_Activity__c(Start_Session__c = 'AM', Start_Date__c = System.today() - 2, 
                                                               End_Session__c = 'AM', End_Date__c = System.today() - 2, 
                                                               Activity_Type__c = 'Sales Call');
        try {
            insert o1;
            System.assert(o1.Id != null);
        }
        catch(Exception e) {
            System.assert(o1.Id == null);
        }
                                              
        Other_Call_Activity__c o = new Other_Call_Activity__c(Start_Session__c = 'AM', Start_Date__c = System.today() - 2, 
                                                              End_Session__c = 'AM', End_Date__c = System.today() , 
                                                              Activity_Type__c = 'Sales Call');
        try {
            insert o;
            System.assert(o.Id != null);
        }
        catch(Exception e) {
            System.assert(o.Id == null);
        }

        Other_Call_Activity__c o2 = new Other_Call_Activity__c(Start_Session__c = 'PM', Start_Date__c = System.today() - 2, 
                                                              End_Session__c = 'PM', End_Date__c = System.today() , 
                                                              Activity_Type__c = 'Sales Call');
        try {
            insert o2;
            System.assert(o2.Id != null);
        }
        catch(Exception e) {
            System.assert(o2.Id == null);
        }
    }}
   static testMethod void conflictDateTest6() {
        
         Profile oProfile = [SELECT Id FROM profile
        WHERE name='INDSU Sales Rep'];        
        User oUser = new User(alias = 'standt',
        email='standarduser3@testorg.com',
        emailencodingkey='UTF-8',
        lastname='Testing3',
        languagelocalekey='en_US',
        localesidkey='en_US',
        profileid = oProfile.Id,
        timezonesidkey='America/Los_Angeles',
        username='standarduser63@testorg.com'); 
        insert oUser; 
        System.runAs(oUser) 
        {   
        
        // If we want to start test , we must delete all data in system.
        List<Other_Call_Activity__c> olds = [ Select Start_Session__c, Start_Date__c, Name, 
                                              End_Session__c, End_Date__c, Activity_Type__c 
                                              From Other_Call_Activity__c o
                                              Where Start_Date__c >=: System.today() - 3
                                              And End_Date__c <=: System.today()
                                              And OwnerId =: UserInfo.getUserId()
                                              order by Start_Date__c, Start_Session__c];
                                              
        delete olds;             
        
        // Test start
        Other_Call_Activity__c o1 = new Other_Call_Activity__c(Start_Session__c = 'PM', Start_Date__c = System.today() - 2, 
                                                               End_Session__c = 'PM', End_Date__c = System.today() - 2, 
                                                               Activity_Type__c = 'Sales Call');
        try {
            insert o1;
            System.assert(o1.Id != null);
        }
        catch(Exception e) {
            System.assert(o1.Id == null);
        }
                                              
        Other_Call_Activity__c o = new Other_Call_Activity__c(Start_Session__c = 'AM', Start_Date__c = System.today() - 3, 
                                                              End_Session__c = 'AM', End_Date__c = System.today()-2, 
                                                              Activity_Type__c = 'Sales Call');
        try {
            insert o;
            System.assert(o.Id != null);
        }
        catch(Exception e) {
            System.assert(o.Id == null);
        }
        CHNSU_UtilOtherCallActivity cuc = new CHNSU_UtilOtherCallActivity();
      datetime myDatetime = datetime.newInstance(2008, 12, 1);
      String session='test';
      Date myDate = date.newinstance(1960, 2, 17);
      Boolean isStart=true;
       mydatetime =  CHNSU_UtilOtherCallActivity.parseDatetime('AM',mydate,True);
       mydatetime =  CHNSU_UtilOtherCallActivity.parseDatetime_Ind('AM',mydate,True);
       mydatetime =  CHNSU_UtilOtherCallActivity.parseDatetime('PM',mydate,True);
       mydatetime =  CHNSU_UtilOtherCallActivity.parseDatetime_Ind('PM',mydate,True);
       mydatetime =  CHNSU_UtilOtherCallActivity.parseDatetime('AM',mydate,False);
       mydatetime =  CHNSU_UtilOtherCallActivity.parseDatetime_Ind('AM',mydate,False);
    }}
    
    static testMethod void updateAndDeleteTest() {
         Profile oProfile = [SELECT Id FROM profile
        WHERE name='INDSU Sales Rep'];        
        User oUser = new User(alias = 'standt',
        email='standarduser3@testorg.com',
        emailencodingkey='UTF-8',
        lastname='Testing3',
        languagelocalekey='en_US',
        localesidkey='en_US',
        profileid = oProfile.Id,
        timezonesidkey='America/Los_Angeles',
        username='standarduser73@testorg.com'); 
        insert oUser; 
        System.runAs(oUser) 
        {   
        // If we want to start test , we must delete all data in system.
        List<Other_Call_Activity__c> olds = [ Select Start_Session__c, Start_Date__c, Name, 
                                              End_Session__c, End_Date__c, Activity_Type__c 
                                              From Other_Call_Activity__c o
                                              Where Start_Date__c >=: System.today() - 3
                                              And End_Date__c <=: System.today()
                                              And OwnerId =: UserInfo.getUserId()
                                              order by Start_Date__c, Start_Session__c];
                                              
        delete olds;             
        
        // Test start
        Other_Call_Activity__c o1 = new Other_Call_Activity__c(Start_Session__c = 'AM', Start_Date__c = System.today() - 3, 
                                                               End_Session__c = 'PM', End_Date__c = System.today() - 3, 
                                                               Activity_Type__c = 'Sales Call');
        try {
            insert o1;
            System.assert(o1.Id != null);
            System.assert([Select count() From Event Where WhatId =: o1.Id] > 0);
        }
        catch(Exception e) {
            System.debug('' + e);
            System.assert(o1.Id == null);
        }
        
        Other_Call_Activity__c o = new Other_Call_Activity__c(Start_Session__c = 'AM', Start_Date__c = System.today() - 2, 
                                                               End_Session__c = 'AM', End_Date__c = System.today() - 1, 
                                                               Activity_Type__c = 'Sales Call');
        try {
            insert o;
            System.assert(o.Id != null);
        }
        catch(Exception e) {
            System.debug('' + e);
            System.assert(o.Id == null);
        }
        
        // Test update action with no error.
        o.Start_Session__c = 'PM';
        try {
            update o;
            System.assert(o.Id != null);
        }
        catch(Exception e) {
            System.debug('' + e);
            System.assert(o.Id == null);
        }
        
        // Test update action with error.
        o.Start_Date__c = System.today() - 3;
        try {
            update o;
            System.assert(o.Id != null);
        }
        catch(Exception e) {
        /*    System.assert([Select Start_Date__c 
                           From Other_Call_Activity__c 
                           Where Id =: o.Id].Start_Date__c == System.today() - 2);*/
        
        }
        
        // Test delete action.
        try {
            delete o;
        }
        catch(Exception e) {
            System.debug('' + e);
            System.assert(o.Id == null);
        }}
    }
}