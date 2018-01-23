/**     
    
    Developer       Email                       Date
    Vijay Singh     vijay.singh@aequor.com      28/03/2013
    
 */
@isTest
private class ClsWSPriceCalculation_Test {

    static testMethod void ClsWSPriceCalculation() {
    
    //Methods defined as TestMethod do not support Web service callouts Stack Trace: null start
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
    
    //end
    
    
        ClsWSPriceCalculation objClsWSPriceCalculation = new ClsWSPriceCalculation();
        ClsWSPriceCalculation.Price_element objobjClsWSPriceCalculation = new ClsWSPriceCalculation.Price_element();
        ClsWSPriceCalculation.OutputData_element objOutputData_element  = new ClsWSPriceCalculation.OutputData_element();
        ClsWSPriceCalculation.GetPSPriceSOAP  objGetPSPriceSOAP   = new ClsWSPriceCalculation.GetPSPriceSOAP ();        
        
        ClsWSPriceCalculation.InputData_element objInputData_element   = new ClsWSPriceCalculation.InputData_element();
        List<ClsWSPriceCalculation.InputData_element> lst = new List<ClsWSPriceCalculation.InputData_element>();
        lst.add(objInputData_element);
        objGetPSPriceSOAP.Price(lst);
        
        ClsWSPriceCalculation.PriceResponse_element  objPriceResponse_element = new ClsWSPriceCalculation.PriceResponse_element (); 
            
    }
}