/**
  */
@isTest
private class AcctPricecheckTEST {
private static final String BUS_UNIT = 'BLUSA';
private static final String PRODUCT = 'E7593';
private static final String SHIPTO = '01051490';
private static final String BILLTO = '00051490';

    static testMethod void AcctPricecheckTEST() {
        Double oReturn_Price = AcctPricecheck.requestPrices(BUS_UNIT,PRODUCT,SHIPTO,BILLTO,0);
        	System.debug('Price ' + oReturn_Price);
    }
}