@isTest
private class ClsSFECallingMatrixReportScheduler_Test {

    static testMethod void myUnitTest() {
        UserRole objRoleSalesRep = [Select Id From UserRole where name = 'INDSU Sales Rep (East 2)']; 
        Profile objProfileSalesRep = [SELECT Id FROM profile WHERE name='INDSU Sales Rep']; 
        User objUserSalesRep = new User(alias = 'salesrep', email='salesrep@testorg.com', emailencodingkey='UTF-8',
                         lastname='Testing', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles',
                         username='salesrep@testorg.com', profileid = objProfileSalesRep.Id, userRoleId=objRoleSalesRep.Id);
        insert objUserSalesRep;

        ClsSFECallingMatrixReportScheduler myScheduler = new ClsSFECallingMatrixReportScheduler();
        myScheduler.execute(null);
    }
}