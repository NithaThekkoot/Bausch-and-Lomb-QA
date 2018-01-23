@isTest
private class CtrlDashboardRouter_Test {

    static testMethod void myUnitTest() {
    	//To insert a record in dashboard router object.
    	Dashboard_Router__c objDashboardRouter = new Dashboard_Router__c();
    	objDashboardRouter.Chart_Name__c = 'Test_Chart_001';
    	objDashboardRouter.Dashboard_Id_To_Open__c = '111111111';
    	objDashboardRouter.Col_To_Point_To__c = 0;
    	objDashboardRouter.Row_To_Point_To__c = 0;
    	insert objDashboardRouter;
    	
    	//PageReference testPg = new PageReference();
		Test.setCurrentPage(new PageReference('/apex/DashboardRouter?chartName='+objDashboardRouter.Chart_Name__c));
		ctrlDashboardRouter obj = new ctrlDashboardRouter();
		obj.route();
		
		/*pr.getParameters().put('chartName', 'Test_Chart_001');
		try{
			Test.invokePage(pr);
		}catch(Exception ex){
			System.debug(ex);
		}*/
    }
}