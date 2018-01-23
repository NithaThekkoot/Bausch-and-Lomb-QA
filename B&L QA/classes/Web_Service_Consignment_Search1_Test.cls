/**     
    
    Developer       Email                       Date
    Vijay Singh     vijay.singh@aequor.com      10/26/2012
    
 */
@isTest
private class Web_Service_Consignment_Search1_Test {

    static testMethod void Web_Service_Consignment_Search1() { 
   
  if (!Test.isRunningTest()){
           
            Account acc = new Account();
            acc.Name = 'test';
            acc.Consignment_Inventory_BU__c = 'CLRCG';
            acc.Ship_To_Id__c  = '01051070';
            acc.SETID__c  = 'BLUSA';
            insert acc;
            Web_Service_Consignment_Search1  obj = new Web_Service_Consignment_Search1 ();
            Web_Service_Consignment_Search1.OutputData_element  outputDateElement = new Web_Service_Consignment_Search1.OutputData_element();
            Web_Service_Consignment_Search1.GetConsignmentSOAP  GetConsignmentSOAP = new Web_Service_Consignment_Search1.GetConsignmentSOAP();
            Web_Service_Consignment_Search1.InputData_element inputElement =  new Web_Service_Consignment_Search1.InputData_element();
            inputElement.SHIP_TO_CUST_ID = acc.Ship_To_Id__c;
            inputElement.PRODUCT_GROUP = 'All';
            inputElement.PRODUCT_ID = '123';
            inputElement.SERIAL_NUMBER ='123';
            inputElement.EXPIRATION_DATE = system.today();
            inputElement.EXPIRATION_DATE_END= system.today();
            inputElement.CONSIGNMENT_INVENTORY_BUSINESS_UNIT = acc.Consignment_Inventory_BU__c ;
            inputElement.USER_ID = UserInfo.getUserId();
            inputElement.SEARCH_ID = '1234';
            inputElement.SET_ID = acc.SETID__c;
            inputElement.CONSIGNMENT_LOCATION = 'xyz';
            inputElement.SEARCH_TYPE = 'ABC';
                          
            List<Web_Service_Consignment_Search1.InputData_element> lstInputData = new List<Web_Service_Consignment_Search1.InputData_element>();            
            lstInputData.add(inputElement);
            Web_Service_Consignment_Search1.SearchConsignmentResponse_element SearchConsignmentResponse_element = new Web_Service_Consignment_Search1.SearchConsignmentResponse_element();                        
            GetConsignmentSOAP.Consignment(lstInputData);
              } 
            
    }
}