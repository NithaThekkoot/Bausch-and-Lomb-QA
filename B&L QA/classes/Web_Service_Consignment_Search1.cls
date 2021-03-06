//Generated by wsdl2apex

public class Web_Service_Consignment_Search1 {
    public class SearchConsignment_element {
        public Web_Service_Consignment_Search1.InputData_element[] InputData;
        private String[] InputData_type_info = new String[]{'InputData',Label.Blcipprod_Bausch_sfdc_Consignment,'InputData_element','1','-1','false'};
        private String[] apex_schema_type_info = new String[]{Label.Blcipprod_Bausch_sfdc_Consignment,'false','false'};
        private String[] field_order_type_info = new String[]{'InputData'};
    }
    public class OutputData_element {
        public String STATUS;
        public Double RECORD_COUNT;
        private String[] STATUS_type_info = new String[]{'STATUS',Label.W3_Xml_Schema,'string','1','1','false'};
        private String[] RECORD_COUNT_type_info = new String[]{'RECORD_COUNT',Label.W3_Xml_Schema,'float','1','1','false'};
        private String[] apex_schema_type_info = new String[]{Label.Blcipprod_Bausch_sfdc_Consignment,'false','false'};
        private String[] field_order_type_info = new String[]{'STATUS','RECORD_COUNT'};
    }
    public class GetConsignmentSOAP {
        public String endpoint_x = Label.Example_Org;
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x ;
        private String[] ns_map_type_info = new String[]{Label.Blcipprod_Bausch_sfdc_Consignment, 'Web_Service_Consignment_Search1'};
        public Web_Service_Consignment_Search1.OutputData_element[] Consignment(Web_Service_Consignment_Search1.InputData_element[] InputData) {
            Web_Service_Consignment_Search1.SearchConsignment_element request_x = new Web_Service_Consignment_Search1.SearchConsignment_element();
            Web_Service_Consignment_Search1.SearchConsignmentResponse_element response_x;
            request_x.InputData = InputData;
            Map<String, Web_Service_Consignment_Search1.SearchConsignmentResponse_element> response_map_x = new Map<String, Web_Service_Consignment_Search1.SearchConsignmentResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              Label.Blcipprod_Bausch_sfdc_Consignment,
              Label.Blcipprod_Bausch_sfdc_Consignment,
              'SearchConsignment',
              Label.Blcipprod_Bausch_sfdc_Consignment,
              'SearchConsignmentResponse',
              'Web_Service_Consignment_Search1.SearchConsignmentResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.OutputData;
        }
    }
    public class InputData_element {
        public String SHIP_TO_CUST_ID;
        public String PRODUCT_GROUP;
        public String PRODUCT_ID;
        public String SERIAL_NUMBER;
        public DateTime EXPIRATION_DATE;
        public DateTime EXPIRATION_DATE_END;
        public String CONSIGNMENT_INVENTORY_BUSINESS_UNIT;
        public String USER_ID;
        public String SEARCH_ID;
        public String SET_ID;
        public String CONSIGNMENT_LOCATION;
        public String SEARCH_TYPE;
        private String[] SHIP_TO_CUST_ID_type_info = new String[]{'SHIP_TO_CUST_ID',Label.W3_Xml_Schema,'string','1','1','false'};
        private String[] PRODUCT_GROUP_type_info = new String[]{'PRODUCT_GROUP',Label.W3_Xml_Schema,'string','1','1','false'};
        private String[] PRODUCT_ID_type_info = new String[]{'PRODUCT_ID',Label.W3_Xml_Schema,'string','1','1','false'};
        private String[] SERIAL_NUMBER_type_info = new String[]{'SERIAL_NUMBER',Label.W3_Xml_Schema,'string','1','1','false'};
        private String[] EXPIRATION_DATE_type_info = new String[]{'EXPIRATION_DATE',Label.W3_Xml_Schema,'dateTime','1','1','false'};
        private String[] EXPIRATION_DATE_END_type_info = new String[]{'EXPIRATION_DATE_END',Label.W3_Xml_Schema,'dateTime','1','1','false'};
        private String[] CONSIGNMENT_INVENTORY_BUSINESS_UNIT_type_info = new String[]{'CONSIGNMENT_INVENTORY_BUSINESS_UNIT',Label.W3_Xml_Schema,'string','1','1','false'};
        private String[] USER_ID_type_info = new String[]{'USER_ID',Label.W3_Xml_Schema,'string','1','1','false'};
        private String[] SEARCH_ID_type_info = new String[]{'SEARCH_ID',Label.W3_Xml_Schema,'string','1','1','false'};
        private String[] SET_ID_type_info = new String[]{'SET_ID',Label.W3_Xml_Schema,'string','1','1','false'};
        private String[] CONSIGNMENT_LOCATION_type_info = new String[]{'CONSIGNMENT_LOCATION',Label.W3_Xml_Schema,'string','1','1','false'};
        private String[] SEARCH_TYPE_type_info = new String[]{'SEARCH_TYPE',Label.W3_Xml_Schema,'string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{Label.Blcipprod_Bausch_sfdc_Consignment,'false','false'};
        private String[] field_order_type_info = new String[]{'SHIP_TO_CUST_ID','PRODUCT_GROUP','PRODUCT_ID','SERIAL_NUMBER','EXPIRATION_DATE','EXPIRATION_DATE_END','CONSIGNMENT_INVENTORY_BUSINESS_UNIT','USER_ID','SEARCH_ID','SET_ID','CONSIGNMENT_LOCATION','SEARCH_TYPE'};
    }
    public class SearchConsignmentResponse_element {
        public Web_Service_Consignment_Search1.OutputData_element[] OutputData;
        private String[] OutputData_type_info = new String[]{'OutputData',Label.Blcipprod_Bausch_sfdc_Consignment,'OutputData_element','1','-1','false'};
        private String[] apex_schema_type_info = new String[]{Label.Blcipprod_Bausch_sfdc_Consignment,'false','false'};
        private String[] field_order_type_info = new String[]{'OutputData'};
    }
}