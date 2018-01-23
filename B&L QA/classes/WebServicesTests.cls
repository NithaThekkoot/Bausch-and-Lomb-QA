@isTest
class WebServicesTests{
    public static testMethod void StockDataGlobalTest(){
        //StockDataGlobal stockData = new StockDataGlobal();
        String requestXML = '<IDCStock name="IDC" recorddate="2009-01-24 10:10:10"><ProductGroup id=""><Product><SKU></SKU><SKUId>sku id</SKUId><Power>yXpower 1</Power><UnitsAvailable>1</UnitsAvailable></Product></ProductGroup><ProductGroup id="yXAPV"><Product><SKU>yXsku name 2</SKU><SKUId>yXnew sku id 2</SKUId><Power>yXpower 2</Power><UnitsAvailable>2</UnitsAvailable></Product><Product><SKU>yXsku name 3</SKU><SKUId></SKUId><Power>yXpower 3</Power><UnitsAvailable>3</UnitsAvailable></Product></ProductGroup></IDCStock>';
        StockDataGlobal.create(requestXML);
    }
    
    public static testMethod void PrimarySaleGlobalTest(){
        //StockDataGlobal stockData = new StockDataGlobal();
        //String requestXML = '<PrimarySale year="2009" month="1" recorddate="01-09-2009 10:20:12"><MonthlySale><UserId>userid 1</UserId><Revenue>100</Revenue><LYRevenue>1000</LYRevenue><RevenueUSD>100</RevenueUSD><LYRevenueUSD>1000</LYRevenueUSD></MonthlySale><MonthlySale><UserId>userid 2</UserId><Revenue>200</Revenue><LYRevenue>2000</LYRevenue><RevenueUSD>100</RevenueUSD><LYRevenueUSD>1000</LYRevenueUSD></MonthlySale></PrimarySale>';
        String requestXML = '<PrimarySale countrycode="IN" year="2009" month="1" recorddate="2009-01-01 10:20:12" CurrentYearStartDate="2009-01-01 10:20:12" CurrentYearEndDate="2009-01-01 10:20:12" LastYearStartDate="2009-01-01 10:20:12" LastYearEndDate="2009-01-01 10:20:12"><MonthlySale><UserId> userid 22 </UserId><Revenue>100</Revenue><LYRevenue>1000</LYRevenue><RevenueUSD>100</RevenueUSD><LYRevenueUSD>1000</LYRevenueUSD><DBIdatERP>100</DBIdatERP></MonthlySale><MonthlySale><UserId> userid 33 </UserId><Revenue>200</Revenue><LYRevenue>2000</LYRevenue><RevenueUSD>100</RevenueUSD><LYRevenueUSD>1000</LYRevenueUSD><DBIdatERP>200</DBIdatERP></MonthlySale></PrimarySale>';

        PrimarySaleGlobal.create(requestXML);
        
        requestXML = '<PrimarySale countrycode="AU" year="2009" month="1" recorddate="2009-01-01 10:20:12" CurrentYearStartDate="2009-01-01 10:20:12" CurrentYearEndDate="2009-01-01 10:20:12" LastYearStartDate="2009-01-01 10:20:12" LastYearEndDate="2009-01-01 10:20:12"><MonthlySale><UserId> userid 22 </UserId><Revenue></Revenue><LYRevenue></LYRevenue><RevenueUSD></RevenueUSD><LYRevenueUSD></LYRevenueUSD><DBIdatERP>100</DBIdatERP></MonthlySale><MonthlySale><UserId> userid 33 </UserId><Revenue>200</Revenue><LYRevenue>2000</LYRevenue><RevenueUSD>100</RevenueUSD><LYRevenueUSD>1000</LYRevenueUSD><DBIdatERP>200</DBIdatERP></MonthlySale></PrimarySale>';

        PrimarySaleGlobal.create(requestXML);
    }

}