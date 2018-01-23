/**
*  @Class Name:    AccountProfileCntrl_Test
*  @Description:   This is a test class for AccountProfileCntrl
*  @Company:       Standav
*  CreatedDate:    11/01/2018
*
*  Modification Log
*  -----------------------------------------------------------
*  Developer           Modification Date           Comments
*  -----------------------------------------------------------
*  Nitha T S           11/01/2018                  Original Version
*/

@isTest
public class AccountProfileCntrl_Test {
    /**
* Description: This method is to creating Data.
*/
    @testSetup
    static void createData(){
        
        List < Account > acctList = CommonTestDataFactory.createAccounts(1, true);
        
        List < Contact > cntList = CommonTestDataFactory.createContacts(1, true, acctList[0].Id);
        
        List < Opportunity > oppList = CommonTestDataFactory.createOpportunities(1, true, acctList[0].Id);
        
        List < Account_Profile__c > acctProfList = CommonTestDataFactory.createAccountProfiles(1, true, acctList[0].Id);
        
        List < BL_Product__c > blProdList = CommonTestDataFactory.createBLProducts(1, true, acctProfList[0].Id);
        
        List < Account_Customer_Group__c > acctCustGroupList = CommonTestDataFactory.createAccountCustomerGroups(1, true, acctProfList[0].Account__c);
        
        List < BL_Sales_History__c > blSalesHistoryList = CommonTestDataFactory.createBLSalesHistories(1, true, acctProfList[0].Id);
    }
    
    @isTest
    private static void testAccountProfile(){
        Account account = [Select Id, Name From Account where Name = 'Account_0'];
        Account_Profile__c accountProfile = [Select Id, Name, Account__c, RecordTypeId From Account_Profile__c where Account__c = :account.Id];
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(accountProfile);
        AccountProfileCntrl testAccPlan = new AccountProfileCntrl(sc);
        Test.stopTest();
    }
}