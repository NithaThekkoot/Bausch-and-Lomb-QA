/*
Methods defined as TestMethod do not support Web service callouts: searchConsignmentInvokeCallout

*/

@isTest
global class WebServiceMockImpl implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
       ClsWSPriceCalculation.PriceResponse_element respElement = 
           new ClsWSPriceCalculation.PriceResponse_element();      
          // respElement.EchoStringResult = 'Mock response';
       response.put('response_x', respElement); 
   }
}