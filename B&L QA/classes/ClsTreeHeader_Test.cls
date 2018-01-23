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
private class ClsTreeHeader_Test {

    static testMethod void ClsTreeHeader_Test() {
        ClsTreeHeader clsTest = new ClsTreeHeader();
        ClsTreeItem clsItem = new ClsTreeItem();
        clsTest.list_items.add(clsItem);
        ClsTreeShipment clsShipment = new ClsTreeShipment();
        clsTest.list_shipments.add(clsShipment);
        Boolean hasChild = clsTest.gethasChild();                
        Boolean hasItemChild = clsTest.gethasItemChild();
        Boolean hasShipmentChild = clsTest.gethasShipmentChild();
        List<Order_Header__c> list_headers = clsTest.getheaderList();
        String orderDate = clsTest.getOrderDate();
        String accountId = clsTest.getAccountId();
        String freightAmount = clsTest.getcustFreightAmount();
        String CurrencyIsoCode =clsTest.getcustFreightAmount(); 
        clsTest.getOrderStatusColor();
    }
}