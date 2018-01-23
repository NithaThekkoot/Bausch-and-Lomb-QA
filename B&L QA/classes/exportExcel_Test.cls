/**     
    
    Developer       Email                       Date
    Vijay Singh     vijay.singh@aequor.com      10/26/2012
    
 */
@isTest
private class exportExcel_Test {

    static testMethod void exportExcel(){
      
      Consignment_Search_Data__c objConnsignment = new Consignment_Search_Data__c();      
      objConnsignment.User_ID__c = UserInfo.getUserId();
      insert objConnsignment;      
      
      Consignment_Data_Header__c objConsignmentHeader = new Consignment_Data_Header__c();
      objConsignmentHeader.Name = 'Search Consignment Result';
      objConsignmentHeader.Search_Consignment_Results__c = 'Ship To,Account Name,Location,Product Id,Serial Number,Expiration Date,Implant Date,Physician ID';
      insert  objConsignmentHeader;
      
      ApexPages.currentPage().getParameters().put('Header','SearchConsignmentResult');                  
      exportExcel  obj = new exportExcel ();
      exportExcel.wrapper wrap = new exportExcel.wrapper();
      obj.exportToExcel();
      
      Consignment_Data_Header__c objConsignmentHeader1 = new Consignment_Data_Header__c();    
      objConsignmentHeader1.Search_Consignment_Results__c = 'Ship To,Invoice Number,Invoice Date,PO Number,Order Number,Product ID,Serial Number,Implant Date,Physician ID';    
      objConsignmentHeader1.Name = 'Search Billed Consignment Result';
      insert objConsignmentHeader1;
      
      ApexPages.currentPage().getParameters().put('Header','SearchBilledConsignmentResult');
      exportExcel  obj1 = new exportExcel ();
      exportExcel.wrapper wrap1 = new exportExcel.wrapper();
      obj1.exportToExcel();                  
      
      Consignment_Data_Header__c objConsignmentHeader2 = new Consignment_Data_Header__c();    
      objConsignmentHeader2.Search_Consignment_Results__c = 'Ship To,Invoice Number,Invoice Date,PO Number,Order Number,Product ID,Serial Number,Implant Date,Physician ID';    
      objConsignmentHeader2.Name = 'Search TR History Result';
      insert objConsignmentHeader2;
      ApexPages.currentPage().getParameters().put('Header','SearchTransactionHistoryResult');      
      exportExcel  obj2 = new exportExcel ();
        
      Consignment_Data_Header__c objConsignmentHeader3 = new Consignment_Data_Header__c();    
      objConsignmentHeader3.Search_Consignment_Results__c = 'Ship To,Account Name,Location,Product ID,Serial Number,Expiration Date,Implant Date,Physician ID';    
      objConsignmentHeader3.Name = 'Search Unbilled CON Result';
      insert objConsignmentHeader3;
      
      ApexPages.currentPage().getParameters().put('Header','SearchUnbilledConsignmentResult');      
      exportExcel  obj3 = new exportExcel ();
        
    }
}