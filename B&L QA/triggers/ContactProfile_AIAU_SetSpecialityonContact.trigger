/**
* 
*   Test Class : ConProf_AIAU_SetSpecialityonContactTest
*   This trigger updates "Speciality" field in Contact record when a Contact Profile is created for that Contact and "Speciality" must be filled (Works only for Record Type:'KOR SOLTA ContactProfile' 
*   The field will be updated on subsequent update of Speciality Field in Contact Profile.
*   
*   Author            |Author-Email                                   |Date       |Comment
*   ---------------   |-----------------------------------------------|-----------|--------------------------------------------------------------------------- 
*   Sridhar Aluru     |sridhar.aluru@bausch.com                       |26.11.2015 |First Draft  
*/

trigger ContactProfile_AIAU_SetSpecialityonContact on Contact_Profile__c (after insert,after update) {
    List<contact> con = new List<contact>();
    Set<Id> set_idRecTypes = new Set<Id>();
    for(RecordType rt:[SELECT Id FROM RecordType WHERE NAME='KOR SOLTA ContactProfile' AND SObjectType='Contact_Profile__c'])
         set_idRecTypes.add(rt.Id);
             
    if(set_idRecTypes.contains(Trigger.New[0].RecordTypeId)){  
    // WHEN THE CONTACT PROFILE RECORD INSERTED
       if(Trigger.isInsert && Trigger.new[0].Speciality__c!=null){
            System.debug('Entered in INSERT-------------------------------------------->');
            for(Contact_Profile__c  cp: Trigger.new){
                System.debug('Entered in FOR LOOP inside INSERT-------------------------------------------->');
                Contact conrecords=[select ID,Speciality__c from Contact where id=:cp.Contact__c];
                conrecords.Speciality__c =cp.Speciality__c;
                con.add(conrecords);
            }
         update con;     
        }  
        
    //  WHEN THE CONTACT PROFILE RECORD UPDATED   
        if(Trigger.isUpdate && Trigger.old[0].Speciality__c<>Trigger.new[0].Speciality__c){
            System.debug('Entered in UPDATE-------------------------------------------->');
            for(Contact_Profile__c  cp: Trigger.new){
                System.debug('Entered in FOR LOOP inside UPDATE-------------------------------------------->');
                Contact conrecords=[select ID,Speciality__c from Contact where id=:cp.Contact__c];
                conrecords.Speciality__c =cp.Speciality__c;
                con.add(conrecords);
            }
         update con;     
        }      
    }  
}