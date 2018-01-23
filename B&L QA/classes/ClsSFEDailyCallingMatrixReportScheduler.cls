/**
 * 
 *   Call SUmmary Scheduler to call the method to Send SFE Daily Calling Matrix Report for the Past Week.
 *
 *   Author             |Author-Email                            |Date       |Comment
 *   -------------------|--------------------------------------  |-----------|--------------------------------------------------
 *   Parag Sharma       |parag.sharma@rishabhsoft.com            |08-Apr-2013|First Draft
 *
 */
global class ClsSFEDailyCallingMatrixReportScheduler implements Schedulable{ 
    global void execute(SchedulableContext SC) {        
        
        clsSFEDailyCallingMatrixCustomReport DailyPlanMatrixReport = new clsSFEDailyCallingMatrixCustomReport();
        DailyPlanMatrixReport.exportToExcel();
        
    }
    
    static testMethod void myUnitTest() {
        UserRole objRoleSalesRep = [Select Id From UserRole where name = 'INDSU Sales Rep (East 2)']; 
        Profile objProfileSalesRep = [SELECT Id FROM profile WHERE name='INDSU Sales Rep']; 
        User objUserSalesRep = new User(alias = 'salesrep', email='salesrep@testorg.com', emailencodingkey='UTF-8',
                         lastname='Testing', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles',
                         username='salesrep@testorg.com', profileid = objProfileSalesRep.Id, userRoleId=objRoleSalesRep.Id);
        insert objUserSalesRep;

        ClsSFEDailyCallingMatrixReportScheduler myScheduler = new ClsSFEDailyCallingMatrixReportScheduler();
        myScheduler.execute(null);
    }

}