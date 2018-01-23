/**
 *   Test class for ClsSFECallingReportScheduler to test scheduler
 *
 *   Author             |Author-Email                            |Date       |Comment
 *   -------------------|--------------------------------------  |-----------|--------------------------------------------------
 *   Tarun Solanki      | Tarun.Solanki@bausch.com                    |18-June-2014|First Draft
 *
 */
@isTest
private class ClsSFECallingReportSchedulerAES_Test {

    static testMethod void myUnitTest() {
        UserRole objRoleSalesRep = [Select Id From UserRole where name = 'INDAES Sales Rep(West)']; 
        Profile objProfileSalesRep = [SELECT Id FROM profile WHERE name='INDAES Sales Rep']; 
        User objUserSalesRep = new User(alias = 'salesrep', email='salesrep@testorg.com', emailencodingkey='UTF-8',
                         lastname='Testing', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles',
                         username='salesrep@testorg.com', profileid = objProfileSalesRep.Id, userRoleId=objRoleSalesRep.Id);
        insert objUserSalesRep;

        ClsSFECallingReportSchedulerAES myScheduler = new ClsSFECallingReportSchedulerAES();
        myScheduler.execute(null);
        
        ClsINDSUdashboradSchedulerAES myScheduler1=new ClsINDSUdashboradSchedulerAES();
        myScheduler1.execute(null);
        
        clsNotifyOpenPhyMangersSchedulerAES myscheduler2=new clsNotifyOpenPhyMangersSchedulerAES();
        myscheduler2.execute(null);
    }
}