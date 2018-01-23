/**
 * 
 *   IND SU controller for the DashboardRouter Visualforce page. 
 *
 *   Author             |Author-Email                            |Date       |Comment
 *   -------------------|----------------------------------------|-----------|--------------------------------------------------
 *   Balaji             |balaji.prabakaran@listertechnologies.com|05.21.2010 |Copied from VC
 *
 */
 
public with sharing class CtrlDashboardRouter {

	/*
	 *  To redirect to the dashboard corresponding to the chart specified in the query parameter.
	 *	The dashboard details is fetched from the Dashboard Configuration object. 
	 *
	 */
	public PageReference route(){

		//To get the chart name from the query parameter.		
		String strChartName = ApexPages.currentPage().getParameters().get('chartName');
		
		System.debug(strChartName);
		
		//Fetches the dashboard details for the given chart.
		Dashboard_Router__c objDashboardConfig = [Select Dashboard_Id_To_Open__c, Row_To_Point_To__c, Col_To_Point_To__c from Dashboard_Router__c where Chart_Name__c=:strChartName];
		
		//The Id of the dashboard to redirect to.
		String strDashboardId = objDashboardConfig.Dashboard_Id_To_Open__c;
		
		//The row no. to show
		Integer intRowNo = objDashboardConfig.Row_To_Point_To__c.intValue();
		
		//The column no. to show
		Integer intColNo = objDashboardConfig.Col_To_Point_To__c.intValue();
		
		//Forming the url based on the above values.
		String strDashboardURL = '/'+ strDashboardId + '#Dashboard_' + intColNo + '_' + intRowNo;
		
		//Redirecting to the respective dashboard.
  		PageReference prDashboard = new PageReference(strDashboardURL);
  		prDashboard.setRedirect(true);
  		return prDashboard;
	}

}