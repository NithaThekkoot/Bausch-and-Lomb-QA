/**     
    
    Developer       Email                       Date
    Vijay Singh     vijay.singh@aequor.com      10/26/2012
    
 */
@isTest
private class webServiceConsignmentSearchProductG_Test {

    static testMethod void web_Service_Consignment() {    
       
               if (!Test.isRunningTest()){
            
            Account acc = new Account();
            acc.Name = 'test';
            acc.Consignment_Inventory_BU__c = 'CLRCG';
            acc.Ship_To_Id__c  = '01051070';
            acc.SETID__c  = 'BLUSA';
            insert acc;
            
            
            web_Service_Consignment_Search_ProductG  obj = new  web_Service_Consignment_Search_ProductG ();
            
            web_Service_Consignment_Search_ProductG.OutputData_element ouputDataElement = new web_Service_Consignment_Search_ProductG.OutputData_element ();
            web_Service_Consignment_Search_ProductG.SearchConsignmentProdGroupResponse_element  SearchConsignmentProdGroupResponse_element = new web_Service_Consignment_Search_ProductG.SearchConsignmentProdGroupResponse_element();
            web_Service_Consignment_Search_ProductG.SearchConsignmentProdGroup_element  SearchConsignmentProdGroup_element  = new web_Service_Consignment_Search_ProductG.SearchConsignmentProdGroup_element();                        
            
            
            web_Service_Consignment_Search_ProductG.InputData_element InputData_element   = new web_Service_Consignment_Search_ProductG.InputData_element ();                        
            InputData_element.SHIP_TO_CUST_ID = acc.Ship_To_Id__c;
            InputData_element.CONSIGNMENT_INVENTORY_BUSINESS_UNIT = acc.Consignment_Inventory_BU__c;
            List<web_Service_Consignment_Search_ProductG.InputData_element> InputData = new List<web_Service_Consignment_Search_ProductG.InputData_element>();            
            InputData.add(InputData_element);
            
            web_Service_Consignment_Search_ProductG.GetConsignmentProdGroupSOAP objInnerClass = new web_Service_Consignment_Search_ProductG.GetConsignmentProdGroupSOAP();            
            objInnerClass.Consignment(InputData);
            
            }
            
    }
}