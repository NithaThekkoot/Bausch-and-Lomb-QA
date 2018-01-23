/**
 * 
 *   To test the webservice ClsWSIntegrationSKUInventory.
 *
 *   Author             |Author-Email                            |Date       |Comment
 *   -------------------|--------------------------------------  |-----------|--------------------------------------------------
 *   Balaji             |balaji.prabakaran@listertechnologies.com|07.02.2010 |To assert the response.
 *
 */
@isTest
private class ClsWSIntegrationInventory_Test {

    static testMethod void myUnitTest() {
    	//The request string to send as input for the webservice.
        String strRequestXML = '<IDCStock name="IN" recorddate="2009-01-24 10:10:10">'
        						+ '<ProductGroup id="">'
        							+ '<Product>'
        								+ '<SKU></SKU>'
        								+ '<SKUId>sku id</SKUId>'
        								+ '<Power>yXpower 1</Power>'
        								+ '<UnitsAvailable>1</UnitsAvailable>'
        							+ '</Product>'
        						+ '</ProductGroup>'
        						+ '<ProductGroup id="yXAPV">'
        							+ '<Product>'
        								+ '<SKU>yXsku name 2</SKU>'
        								+ '<SKUId>yXnew sku id 2</SKUId>'
        								+ '<Power>yXpower 2</Power>'
        								+ '<UnitsAvailable>2</UnitsAvailable>'
        							+ '</Product>'
        							+ '<Product>'
        								+ '<SKU>yXsku name 3</SKU>'
        								+ '<SKUId></SKUId>'
        								+ '<Power>yXpower 3</Power>'
        								+ '<UnitsAvailable>3</UnitsAvailable>'
        							+ '</Product>'
        						+ '</ProductGroup>'
        					+ '</IDCStock>';
        					
		//To get the response from the webservice call.
		String strResponseXML = ClsWSIntegrationInventory.create(strRequestXML);

		//Parsing the response and asserting if the no. of successful records equals the no. of records in the input.
		String strKey = '<TotalNoOfRecordsSuccess>';
		Integer intPos = strResponseXML.indexOf(strKey) + strKey.length();
		String strSuccessRecords = strResponseXML.substring(intPos, intPos + 1);
		System.assertEquals(strSuccessRecords,'3');
    }

}