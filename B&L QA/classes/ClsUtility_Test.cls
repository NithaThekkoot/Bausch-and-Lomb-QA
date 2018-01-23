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
 *      Author            |Author-Email                      |Date       |Comment
 *      ------------------|----------------------------------|-----------|--------------------------------------------------
 *      Dennis Flüchter   |dennis.fluechter@itbconsult.com   |21.10.2009 |First draft
 *      Samantha Cardinali|samantha.cardinali@bausch.com     |25.05.2012 |Some extra test methods
 *
 */

@isTest
private class ClsUtility_Test {

    static testMethod void ClsUtility_Test() {
        ClsUtility clsTest = new ClsUtility();
        String testStr = 'Test String';
        testStr = clsTest.splitChars(testStr);
        clsTest.readProductCache();
        clsTest.parseProductCache('test');
        clsTest.storeProductsTxt();
        clsTest.storeProducts();
        clsTest.readProducts();
        ID profile = ClsUtility.getProfileId('EMEASU Territory Manager');
        Set<ID> set_profile = ClsUtility.getProfileIds('EMEASU Territory Manager');
        List<String> list_recordtypes = New List<String>{'Ship To Account','Bill To Account'};
        Set<ID> set_recordtypes = ClsUtility.getRecordTypeId('Account',list_recordtypes);
        ID rt = ClsUtility.getRecordTypeId('Account','Ship To Account');
        Set<ID> set_userroles = ClsUtility.getUserRoleIds('EMEASU Regional Director');
        ID urid = ClsUtility.getUserRoleId('EMEASU Regional Director');
    }
}