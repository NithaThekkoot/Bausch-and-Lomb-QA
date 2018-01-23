/**
*  Class Name: CommonTestDataFactory  
*  Description: This is a TestDataUtil class for creating Object Records.
*  Company: Standav
*  CreatedDate:11/01/2018
*
*  Modification Log
*  -----------------------------------------------------------
*  Developer           Modification Date           Comments
*  -----------------------------------------------------------  
*  Nitha T S             11/01/2018              Original version
*/
public class CommonTestDataFactory {
    public static String PROFILE_SYSTEM_ADMINISTRATOR = 'System Administrator';
    public static String PROFILE_STANDARD_PLATFORM_USER = 'Standard Platform User';
    public static String PROFILE_STANDARD_PLATFORM_ONE_APP_USER = 'Standard Platform One App User';
    public static String PROFILE_STANDARD_USER = 'Standard User';
    public static String PROFILE_PARTNER_USER = 'Partner User';
    public static String PROFILE_HIGH_VOLUME_CUSTOMER_PORTAL = 'High Volume Customer Portal';
    public static String PROFILE_AUTHENTICATED_WEBSITE = 'Authenticated Website';
    public static String PROFILE_CUSTOMER_PORTAL_USER = 'Customer Portal User';
    public static String PROFILE_CUSTOMER_PORTAL_MANAGER = 'Customer Portal Manager';
    public static String PROFILE_SOLUTION_MANAGER = 'Solution Manager';
    public static String PROFILE_MARKETING_USER = 'Marketing User';
    public static String PROFILE_CONTRACT_MANAGER = 'Contract Manager';
    public static String PROFILE_SALES_BDR_SBDR = 'Sales BDR/SBDR';
    public static String PROFILE_SALES_REP = 'Sales Rep';
    public static String PROFILE_READ_ONLY = 'Read Only';
    public static String PROFILE_CHATTER_ONLY_USER = 'Chatter OnlyUser';
    public static String PROFILE_CHATTER_FREE_USER = 'Chatter FreeUser';
    public static String PROFILE_CHATTER_EXTERNAL_USER = 'Chatter External User';
    public static String PROFILE_CHATTERMODERATOR_USER = 'Chatter Moderator User';
    public static String PROFILE_SITE_COM_ONLY_USER = 'Site.com Only User';
    public static String PROFILE_GOLD_ADMIN = 'Gold Partner - Administrator';
    public static String PROFILE_GOLD_SALES = 'Gold Partner - Sales';
    public static String PROFILE_GOLD_MARKETING = 'Gold Partner - Marketing';
    public static String PROFILE_GOLD_CONTENT = 'Gold Partner - Content';
    public static String PROFILE_GOLD_MDF = 'Gold Partner - MDF';
    
    private static Integer usersCreated = 0;
    public static final String TEST_OPP_NAME = 'Test Opp';
    public static final String TEST_OPP_TYPE = 'Initial Business';
    public static final String TEST_OPP_STAGE = '1 - Partner Oppty';
    
    // create Contact records
    public static List < Contact > createContacts(Integer numToInsert, boolean doInsert, Id accountId) {
        List < Contact > cts = new List < Contact > ();
        for (Integer i = 0; i < numToInsert; i++) {
            Contact c = new Contact(
                LastName = 'Contact_' + i,
                Phone = '999-555-' + 1000 + i,
                Email = 'examplecontact_' + i + '@example.com',
                AccountId = accountId,
                Key_Decision_Maker__c = true
            );
            cts.add(c);
        }
        if (doInsert) {
            insert cts;
        }
        return cts;
    }
    
    // create Account records
    public static List < Account > createAccounts(Integer numToInsert, boolean doInsert) {
        List < Account > acnts = new List < Account > ();
        for (Integer i = 0; i < numToInsert; i++) {
            Account acnt = new Account(
                Name = 'Account_' + i,
                Phone = '999-999-' + (1000 + i),
                BillingCountry = 'United States',
                BillingPostalcode = 'LS1 3DD',
                BillingState = 'CA',
                BillingCity = 'San Francisco',
                BillingStreet = '111 Some Rd',
                Industry = 'High Technology'
            );
            acnts.add(acnt);
        }
        
        if (doInsert) {
            insert acnts;
        }
        return acnts;    
    }
    
    // create Opportunity records
    public static List < Opportunity > createOpportunities(Integer numToInsert, boolean doInsert, Id accountId) {
        List < Opportunity > oppList = new List < Opportunity > ();
        for (Integer i = 0; i < numToInsert; i++) {
            oppList.add(new Opportunity(
                Name = 'Opportunity_' + i,
                CloseDate = Date.today().addDays(7),
                StageName = '1 - Open Qualified',
                AccountId = accountId
            ));
        }
        if (doInsert) {
            insert oppList;
        }
        return oppList;
    }
    
    // create User records
    /*public static List < User > createUsers(Integer numToInsert, Boolean doInsert) {
        List < User > users = new List < User > ();
        for (Integer i = 0; i < numToInsert; i++) {
            User user = new User(
                LastName = 'LastName_' + i,
                Alias = ((usersCreated++) + 'User_' + i).left(8),
                Email = 'test_' + i + '@gmail.com',
                UserName = (usersCreated++) + 'testcaseuser_' + i + '@gmail.com',
                CommunityNickname = (usersCreated++) + 'NickName_' + i,
                Department = 'Some Department',
                EmailEncodingKey = 'ISO-8859-1',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
                IsActive = true);
            users.add(user);
        }
        if (doInsert) {
            insert users;
        }
        return users;
    }*/
    
    // create Account_Profile__c records
    public static List < Account_Profile__c > createAccountProfiles(Integer numToInsert, Boolean doInsert, Id accountId) {
        List < Account_Profile__c > accountProfiles = new List < Account_Profile__c > ();
        for (Integer i = 0; i < numToInsert; i++) {
            Account_Profile__c acctProf = new Account_Profile__c(
                Account__c = accountId,
                RecordTypeId = Schema.SObjectType.Account_Profile__c.getRecordTypeInfosByName().get('Cataract').getRecordTypeId()
            );
            accountProfiles.add(acctProf);
        }
        if (doInsert) {
            insert accountProfiles;
        }
        return accountProfiles;
    }
    
    // create BL_Product__c records
    public static List < BL_Product__c > createBLProducts(Integer numToInsert, Boolean doInsert, Id accountProfId) {
        List < BL_Product__c > blProducts = new List < BL_Product__c > ();
        for (Integer i = 0; i < numToInsert; i++) {
            BL_Product__c blProd = new BL_Product__c(
                Type__c = 'Equipment',
                Price__c = 54.00,
                Equipment_Age__c = 2,
                Annual_Volume__c = 300,
                Account_Profile__c = accountProfId,
                Product_Name__c = 'test Product Name'
            );
            blProducts.add(blProd);
        }
        if (doInsert) {
            insert blProducts;
        }
        return blProducts;
    }
    
    // create Account_Customer_Group__c records
    public static List < Account_Customer_Group__c > createAccountCustomerGroups(Integer numToInsert, Boolean doInsert, Id accountId) {
        List < Account_Customer_Group__c > acctCustGroups = new List < Account_Customer_Group__c > ();
        for (Integer i = 0; i < numToInsert; i++) {
            Account_Customer_Group__c acctCustGroup = new Account_Customer_Group__c(
                Customer_Group__c = 'test Customer Group',
                Customer_Group_Type__c = 'test Customer Group Type',
                Account__c = accountId
            );
            acctCustGroups.add(acctCustGroup);
        }
        if (doInsert) {
            insert acctCustGroups;
        }
        return acctCustGroups;
    }
    
    // create BL_Sales_History__c records
    public static List < BL_Sales_History__c > createBLSalesHistories(Integer numToInsert, Boolean doInsert, Id accountProfId) {
        List < BL_Sales_History__c > blSalesHistories = new List < BL_Sales_History__c > ();
        for (Integer i = 0; i < numToInsert; i++) {
            BL_Sales_History__c blSalesHistory = new BL_Sales_History__c(
                Sales_Date__c = system.today(),
                Sales_Type__c = 'Equipment',
                Total_Sales__c = 236.00,
                Account_Profile__c = accountProfId
            );
            blSalesHistories.add(blSalesHistory);
        }
        if (doInsert) {
            insert blSalesHistories;
        }
        return blSalesHistories;
    }
}