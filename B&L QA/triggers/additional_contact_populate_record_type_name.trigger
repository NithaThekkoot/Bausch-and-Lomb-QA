/*
* First Draft : Kuldeep Rathore
*  Trigger used to populate Record Type name based on recordtype id. 
*
*   Test Class:Test_additional_contact_populate_record
*/
trigger additional_contact_populate_record_type_name on Additional_Product_Complaint_Contact__c (before insert)
{
    set<string> set_id = new set<string>();
    
    for(Additional_Product_Complaint_Contact__c cnn:trigger.new)
    {    
        if(cnn.recordtypeid !=null)
            set_id.add(cnn.recordtypeid);
    }
   IF(!set_id.isempty())
   { 
        map<id,recordtype> map_record_type_id =new map<id,recordtype>([select id,name  from recordtype where id IN :set_id ]);
        for(Additional_Product_Complaint_Contact__c cn:trigger.new)
        {
            if(cn.recordtypeid !=null)
                cn.Record_Type__c=map_record_type_id.get(cn.recordtypeid).name ;
        }
   }
}