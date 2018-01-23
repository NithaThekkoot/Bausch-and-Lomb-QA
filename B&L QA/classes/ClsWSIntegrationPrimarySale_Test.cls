/**
 * 
 *   To test the webservice ClsWSIntegrationPrimarySale.
 *
 *   Author             |Author-Email                            |Date       |Comment
 *   -------------------|--------------------------------------  |-----------|--------------------------------------------------
 *   Balaji             |balaji.prabakaran@listertechnologies.com|07.02.2010 |To generate the test data and assert the response.
 *Santosh Kumar S     | santosh.sriram@listertechnologies.com   | 10.03.2011  | Changing INDSU to APACSU System Admin
 */

@isTest
private class ClsWSIntegrationPrimarySale_Test {

    static testMethod void myUnitTest() {
        //To get the role for the sales rep.
        UserRole objRoleSalesRep = [Select Id From UserRole where name like :('INDSU Sales Rep' + '%') limit 1];

        //To get the profile for the sales rep. 
        Profile objProfileSalesRep = [SELECT Id FROM profile WHERE name='APACSU System Administrator']; 

        //Sales rep user for testing.
        User objUserSalesRep = new User(alias = 'salesrep', email='salesrep@testorg.com', emailencodingkey='UTF-8',
                         lastname='Testing', languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles',
                         username='salesrep@testorg.com', profileid = objProfileSalesRep.Id, userRoleId=objRoleSalesRep.Id, Legacy_System_Id__c = 'userid22');

        insert objUserSalesRep;
     System.runAs(objUserSalesRep) {
        //To get the Id for recordType KORRX Direct  
        Id idDirectRecordType = [SELECT Id FROM RecordType 
                                        WHERE Name = 'INDSU Direct' AND SObjectType='Account'].Id;

        //Accounts for testing pupose.
        Account objDirectAccount1 = new Account(Name = 'Test APAVC Direct Account 1', RecordTypeId = idDirectRecordType, OwnerId = objUserSalesRep.Id, Legacy_System_Id__c = 'BPCSSIN10011_');
        Account objDirectAccount2 = new Account(Name = 'Test APAVC Direct Account 2', RecordTypeId = idDirectRecordType, OwnerId = objUserSalesRep.Id, Legacy_System_Id__c = 'BPCSSIN200_010');

        //To create the accounts for testing
        List<Account> list_Account = new List<Account>();
        list_Account.add(objDirectAccount1);
        list_Account.add(objDirectAccount2);
    System.Debug('Account Added');
    System.Debug('list_Account='+list_Account);
        insert list_Account;

        //The request string to send as input for the webservice.
        
        String strRequestXML = '<PrimarySale countrycode="IN" year="2010" month="6" recorddate="2009-01-01 10:20:12" CurrentYearStartDate="2009-01-01 10:20:12" CurrentYearEndDate="2009-01-01 10:20:12" LastYearStartDate="2009-01-01 10:20:12" LastYearEndDate="2009-01-01 10:20:12">'
                                 + '<MonthlySale>'
                                     + '<UserId>userid22</UserId>'
                                     + '<Revenue></Revenue><LYRevenue>1000</LYRevenue><RevenueUSD>100</RevenueUSD><LYRevenueUSD>1000</LYRevenueUSD>'
                                     + '<DBIdatERP>10011</DBIdatERP>'
                                     + '<ShipToId></ShipToId>'
                                 + '</MonthlySale>'
                                 + '<MonthlySale>'
                                     + '<UserId>userid22</UserId>'
                                     + '<Revenue>200</Revenue><LYRevenue>2000</LYRevenue><RevenueUSD>100</RevenueUSD><LYRevenueUSD>1000</LYRevenueUSD>'
                                     + '<DBIdatERP>200</DBIdatERP>'
                                     + '<ShipToId>010</ShipToId>'
                                 + '</MonthlySale>'
                             + '</PrimarySale>';
         
         /*
        String strRequestXML = '- <PrimarySale countrycode="CN" year="2010" month="01" recorddate="2010-01-21 00:00:00" CurrentYearStartDate="2009-12-25 00:00:00" CurrentYearEndDate="2010-01-21 00:00:00" LastYearStartDate="2008-12-26 00:00:00" LastYearEndDate="2009-01-22 00:00:00">'
         + '<MonthlySale><UserId>880030</UserId> <Revenue>0.00</Revenue> <LYRevenue>12820.51</LYRevenue> <RevenueUSD>0.00</RevenueUSD>'
        + '<LYRevenueUSD>1891.03</LYRevenueUSD>  <DBIdatERP>886331</DBIdatERP> <LENS_REVENUE>0.00</LENS_REVENUE>'
       + '<LENS_LY_REVENUE>12820.51</LENS_LY_REVENUE> <LENSCARE_REVENUE>0.00</LENSCARE_REVENUE> <LENSCARE_LY_REVENUE>12820.51</LENSCARE_LY_REVENUE>'
  + '<ShipToId>0</ShipToId> </MonthlySale><MonthlySale><UserId>880002</UserId> <Revenue>348298.29</Revenue> <LYRevenue>0.00</LYRevenue> <RevenueUSD>51374.01</RevenueUSD>'
  + '<LYRevenueUSD>0.00</LYRevenueUSD> <DBIdatERP>887134</DBIdatERP> <LENS_REVENUE>348298.29</LENS_REVENUE'
  + '<LENS_LY_REVENUE>0.00</LENS_LY_REVENUE> <LENSCARE_REVENUE>348298.29</LENSCARE_REVENUE>'
  + '<LENSCARE_LY_REVENUE>0.00</LENSCARE_LY_REVENUE> <ShipToId>0</ShipToId> </MonthlySale></PrimarySale>';
     */                
        //To get the response from the webservice call.
        String strResponseXML = ClsWSIntegrationPrimarySale.create(strRequestXML);
        
        //Parsing the response and asserting if the no. of successful records equals the no. of records in the input.
        ClsUtilXMLParser parser = new ClsUtilXMLParser();
        ClsUtilXMLElement element = parser.parse(strResponseXML);
        String successRecords = element.getAttrs().get('TotalNoOfRecordsSuccess');
        System.assertEquals(successRecords,'2');
    }
    }
}