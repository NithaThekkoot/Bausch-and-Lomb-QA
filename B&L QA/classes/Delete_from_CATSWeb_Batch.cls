/*
* Created By : Rohit Aggarwal (rohit.aggarwal@bausch.com)
*  
*This class is used to deleted the record form CATSWeb which has been deleted from SFDC 
*/
public class Delete_from_CATSWeb_Batch {

 public static string objectName;
 @future(callout = true)
    public static void sendRequest(string RecordsToDelete ,string ObjName,string RecType){  
         //String endpointUrl = 'https://catsweb.bausch.com/asxApps/asxSFDC.aspx'; 
         // String endpointUrl = 'https://blciprod.bausch.com/SFDCTEST'; 
          //JMM - Updated endpoint for updated Catsweb endpoint
           String endpointUrl = 'https://catsweb.bausch.com/asxSFDC_2013/asxSFDC.aspx';
          
         objectName = ObjName;
         HttpRequest req = new HttpRequest();  
         req.setMethod('POST');  
         req.setEndpoint(endpointUrl);  
         req.setHeader('Content-Type', 'text/xml');  
         
         req.setBody(getSoapEnvelope(RecordsToDelete,RecType));  

         Http http = new Http();  
         if(!test.isrunningtest()){   
             HttpResponse res = http.send(req);  
             System.debug('Response body is---------------->' +res.getBody());
             System.debug('Response code is---------------->' +res.getStatusCode());
         }
      
    }  
 
    public static String getSoapEnvelope(String recordId,String RecordTyp){  
      
    
    /* Get the values from custom setting */
    
    CATSWeb_Resources__c CC  = CATSWeb_Resources__c.getInstance();   
    
    /*build the soap envelope*/
    
    String envelope = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
           envelope +='<soapenv:Body><notifications xmlns="http://soap.sforce.com/2005/09/outbound"><OrganizationId>'+Userinfo.getOrganizationId()+'</OrganizationId>';
           envelope +='<SessionId xsi:nil="true"/><EnterpriseUrl>'+CC.SOAP_Message_Enterprise_URL__c+'</EnterpriseUrl>';
           envelope +='<PartnerUrl>'+cc.SOAP_Message_Partner_URL__c+'</PartnerUrl><Notification>';
           envelope +='<Id>abcd1234</Id><sObject xsi:type="sf:'+ObjectName+'" xmlns:sf="urn:sobject.enterprise.soap.sforce.com">';
           envelope +='<sf:ID_18__c>'+recordId+'</sf:ID_18__c><sf:Record_Type__c>'+RecordTyp+'</sf:Record_Type__c><sf:Last_Modified_By_Email__c>julie.marletta@bausch.com</sf:Last_Modified_By_Email__c>';
           envelope +='<sf:Mark_for_Delete__c>-1</sf:Mark_for_Delete__c> <sf:Reason_for_Edit_Prior_Value__c>Record deleted in Salesforce.com</sf:Reason_for_Edit_Prior_Value__c>';
           envelope +='</sObject></Notification></notifications></soapenv:Body></soapenv:Envelope>';

    return envelope ;
    
    }          
}