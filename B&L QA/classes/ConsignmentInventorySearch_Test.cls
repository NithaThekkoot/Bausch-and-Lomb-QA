/**     
    
    Developer       Email                       Date
    Vijay Singh     vijay.singh@aequor.com      10/19/2012
    
 */
@isTest
private class ConsignmentInventorySearch_Test {

    static testMethod void consignmentInventory() {
            Consignment_Search_Data__c objCon = new Consignment_Search_Data__c();
            objCon.User_ID__c = '005Q0000000ibFbIAI';
            insert objCon;
            List<Consignment_Search_Data__c> lst = new List<Consignment_Search_Data__c>();
            lst.add(objCon);
            
            Account acc = new Account();
            acc.Name = 'test';
            acc.Consignment_Inventory_BU__c = 'CLRCG';
            acc.Ship_To_Id__c  = '01051070';
            acc.SETID__c  = 'BLUSA';
            insert acc;
            
            ApexPages.currentPage().getParameters().put('accId',acc.id); 
            ApexPages.currentPage().getParameters().put('serialNumber','22044402022');
            ApexPages.currentPage().getParameters().put('productgroup','All');
            ApexPages.currentPage().getParameters().put('productId','8T060');
            ApexPages.currentPage().getParameters().put('expirationStDate','12/09/2012');
            ApexPages.currentPage().getParameters().put('expirationEndDate','12/09/2012');
            
            
                                                
            ApexPages.StandardSetController controller = new ApexPages.StandardSetController(lst);
            ConsignmentInventorySearch objConsignmentSearch = new ConsignmentInventorySearch(controller);            
            objConsignmentSearch.accountName();
            objConsignmentSearch.pageMessage('Error','StringMessage');
            objConsignmentSearch.type ='Equal';
            objConsignmentSearch.serialNumber ='22044402022';
            objConsignmentSearch.shipToIdBlank();
            objConsignmentSearch.shipToIdNotBlank();
            objConsignmentSearch.repopulateType();
            objConsignmentSearch.checkShipToLength('abcd');
            objConsignmentSearch.checkCriteriaForAllFieldChanginValue();
            objConsignmentSearch.changeType();
            objConsignmentSearch.enableSeachTransactionHistory();
            objConsignmentSearch.cancelSearch();
            objConsignmentSearch.disableAllBtnsOnErrorMsg();
            objConsignmentSearch.modifySearch();
            objConsignmentSearch.showSearchButtons();
            objConsignmentSearch.TogetListViewIds('Search Billed Consignment Result','Search Billed Consignment Results');
            objConsignmentSearch.isNotNullDate();
            ApexPages.currentPage().getParameters().put('expirationStDate','12/09/2012');
            ApexPages.currentPage().getParameters().put('expirationEndDate',null);
            objConsignmentSearch.isNotNullDate();
            objConsignmentSearch.objectConsignementSearchDate.Expiration_End_Date__c = system.today();
            objConsignmentSearch.objectConsignementSearchDate.Expiration_Start_Date__c = null;                        
            objConsignmentSearch.isNotNullDate();
            objConsignmentSearch.objectConsignementSearchDate.Expiration_End_Date__c = null;
            objConsignmentSearch.objectConsignementSearchDate.Expiration_Start_Date__c = system.today();
            objConsignmentSearch.isNotNullDate();
            objConsignmentSearch.makeprogressMessage();                        
            objConsignmentSearch.deleteAllConsignmentDataAndpopulateProductGroupOnLoad();
            objConsignmentSearch.shipTo = '1';
            objConsignmentSearch.accountName();
            objConsignmentSearch.type = 'Contains';
            objConsignmentSearch.serialNumber = '22044402022';
            objConsignmentSearch.changeType();
            objConsignmentSearch.objectConsignementSearchDate.Expiration_End_Date__c = system.today();
            objConsignmentSearch.objectConsignementSearchDate.Expiration_Start_Date__c = system.today();
            objConsignmentSearch.searchConsignment();            
            objConsignmentSearch.searchBilledConsignment();
            objConsignmentSearch.searchTransactionHistory();
            objConsignmentSearch.searchUnbilledConsignment();
            
                                                   
    }
}