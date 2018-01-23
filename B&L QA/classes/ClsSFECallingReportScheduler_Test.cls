/**
 * 
 *   Test class for ClsSFECallingReportScheduler to test scheduler
 *
 *   Author             |Author-Email                            |Date       |Comment
 *   -------------------|--------------------------------------  |-----------|--------------------------------------------------
 *   Neha Jain          |neha.jain@bausch.com                    |13-Mar-2014|First Draft
 *
 */
@isTest
private class ClsSFECallingReportScheduler_Test {

    static testMethod void myUnitTest() {
        UserRole objRoleSalesRep = [Select Id From UserRole where name = 'INDSU Sales Rep (East 2)']; 
        Profile objProfileSalesRep = [SELECT Id FROM profile WHERE name='INDSU Sales Rep']; 
        User objUserSalesRep = new User(alias = 'salesrep', email='salesrep@testorg.com', emailencodingkey='UTF-8',
                         lastname='Testing', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles',
                         username='salesrep@testorg.com', profileid = objProfileSalesRep.Id, userRoleId=objRoleSalesRep.Id);
        insert objUserSalesRep;

        ClsSFECallingReportScheduler myScheduler = new ClsSFECallingReportScheduler();
        myScheduler.execute(null);
    }
}