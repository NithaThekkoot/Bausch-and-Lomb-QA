/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 *
 *
 *  	Author		     |Author-Email			   	     	|Date		|Comment
 *  	-----------------|----------------------------------|-----------|--------------------------------------------------
 *  	Dennis Flüchter  |dennis.fluechter@itbconsult.com 	|20.10.2009 |First draft
 *
 */
 
@isTest
private class ClsOrderLineItem_Test {

    static testMethod void ClsOrderLineItem_Test() {
			
    	ClsOrderLineItem clsTest = new ClsOrderLineItem();
    	
    	clsTest.oli.CurrencyIsoCode = 'USD';
    	
    	clsTest.oli.Unit_Price__c = 1;
    	String unitPrice = clsTest.getcustUnitPrice();
    	clsTest.oli.Unit_Price__c = null;
    	unitPrice = clsTest.getcustUnitPrice();
    	
    	clstest.oli.Extended_Price__c = 1;
    	String extendedPrice = clsTest.getcustExtendedPrice();
    	clstest.oli.Extended_Price__c = null;
    	extendedPrice = clsTest.getcustExtendedPrice();
    	
    	clstest.oli.Override_Price__c = 1;
    	String overridePrice = clsTest.getcustOverridePrice();
    	clstest.oli.Override_Price__c = null;
    	overridePrice = clsTest.getcustOverridePrice();

    	Boolean showWarningIcon = clsTest.getshowWarningIcon();
    	
    	String productDescription = clsTest.getproductDescription();
    	clsTest.setproductDescription('Description');
    	
    	String UOM = clsTest.getUOM();
    	clsTest.setUOM('EA');
    	
    	Double stock = clsTest.getstock();
    	clsTest.setstock(1);
    	
    	Double max = clsTest.getmax();
    	clsTest.setmax(1);
    	
    	Double mult = clsTest.getmult();
    	clsTest.setmult(1);
    	
    	clsTest.changeValidPriceFromWS();	
    	
    }
}