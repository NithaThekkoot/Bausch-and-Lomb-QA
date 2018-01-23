/**
 * 
 *   This classs queries RecordTypes for Physican Visit and keeps in along with request   
 *
 *    Author         |Author-Email                           |Date       |Comment
 *    ---------------|-------------------------------------- |-----------|--------------------------------------------------
 *    Harvin         |harvin.vincent@listertechnologies.com  |04.10.2010 |First draft (This class createed to avoid TOO Many SOQL Queries error 
 *
 */
public class ClsPhysicanVisit {
    public static Map<String, String> map_staticRecordType = new Map<String, String>();
    public static Map<String, RecordType> map_staticRecordTypeObj = new Map<String, RecordType>();
    
    public static void getPhysicanVisitRecordTypes() {
    if (map_staticRecordType != null && map_staticRecordType.size() < 1) {
       for (RecordType oRecordType : [SELECT 
                        Id,
                        Name,
                        Sobjecttype
                       FROM 
                        RecordType
                       WHERE
                        Sobjecttype 
                       IN   
                            ('Joint_Field_Work__c', 'Event', 'Task', 'Physician_Visit__c',
                         'Monthly_Implantation_Detail__c')
                       AND
                        Name
                       IN
                        ('INDSU', 'APACSU', 'INDSU Task','INDSU Sales Planned', 'INDSU Sales Unplanned',
                        'THASU Sales Planned', 'THASU Sales Unplanned',
                        'THASU Service Planned', 'THASU Service Unplanned',
                        'APACSU Sales Planned','APACSU Sales Unplanned',
                        'INDSU Monthly Implantation Detail','APACSU Monthly Implantation Detail',
                        'APACSU Joint Field Work','APACSU Service Engineer','APACSU Technical Service')//Add 2 New Record Type of Physician visit   Gordon 2012-8-7 
                       ORDER BY Sobjecttype]) {
        map_staticRecordType.put(oRecordType.Sobjecttype + '-' + oRecordType.Name, oRecordType.Id);
        map_staticRecordTypeObj.put(oRecordType.Sobjecttype + '-' + oRecordType.Name, oRecordType);
        
    }
     }
   }    

}