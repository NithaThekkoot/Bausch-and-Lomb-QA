@isTest
public class ConProf_AIAU_SetSpecialityonContactTest {
    Static testmethod void contactfieldupdate(){
       
        RecordType rec = [Select ID, Name from RecordType where Name = 'KOR SOLTA ContactProfile' AND SObjectType='Contact_Profile__c'];
        
        Contact c = new Contact(lastname='bajaj',Speciality__c='');
        insert c;
         
        Contact con = [select ID,Speciality__c from Contact where ID=:c.ID];
         
        Contact_Profile__c cp =new Contact_Profile__c(Speciality__c='DM',Contact__c=con.ID,RecordTypeID=rec.ID);
        insert cp;
        
        con.Speciality__c=cp.Speciality__c;
        update con;
        
        cp.Speciality__c='SM';
        update cp;
    }
}