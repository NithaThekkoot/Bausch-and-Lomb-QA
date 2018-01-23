/*
 * 
 *  Below class is for survey record creation whenever a call center agent have done some survey on account from lead object.
 *
 *   Author             |Author-Email                        |   Date      |   Comment
 *   -------------------|------------------------------------|------------- |--------------------------------------------------
 *   Sanjib Mahanta       |Sanjib.Mahanta@bausch.com          | 31/08/2011  |  Final Version
 */

public class ClsTakeSurvey{
    
    List<Lead> listLead = new list<Lead>();
    List<Lead> listLead1 = new list<Lead>();
    List<User> listName = new List<User>();
    
    String url,conName;
    Id accId,LeadId;
    //PageReference Page = null;
    String strTypeOfUserId = UserInfo.getUserId();
    
    
    public ClsTakeSurvey(ApexPages.StandardController controller) {
    LeadId = ApexPages.currentPage().getParameters().get('id');        
    listLead=[Select Name,status,OwnerID,Existing_Account__c,ConvertedAccountId,MobilePhone,Email from Lead where id=:LeadId limit 1];
    listName = [select name from User where id=:strTypeOfUserId];
    system.debug('listName'+strTypeOfUserId);
    }
    
    public PageReference insupLeadSurvey(){
    List<Zoomerang_Survey_Link__c> mcs1 = Zoomerang_Survey_Link__c.getall().values();
        
        APACSU_Survey__c r1=new APACSU_Survey__c();
        r1.Survey_Date_taken__c=System.today();
        date dt = date.today();
        r1.Next_Due_Date__c = dt.addDays(90);
        system.debug('date4'+ r1.Next_Due_Date__c );
        r1.Previous_Due_Date__c = r1.Survey_Date_taken__c;
        r1.Survey_Taken_By__c=listName[0].Name;
        system.debug(r1);
        insert r1;
        
        for (Lead l : listLead){            
            l.Status='Survey Taken';
            l.APACSU_Survey_Number__c = r1.Id;            
            listLead1.add(l);
        }update listLead1; 
        
        accId=listLead[0].Existing_Account__c;
        System.debug('accId'+accId);
        conName=listLead[0].Name;
        System.debug('conName'+conName);
        
       // List<Zoomerang_Survey_Link__c> mcs1 = Zoomerang_Survey_Link__c.getall().values();
        //String surveyId= mcs1[0].Survery_Id__c;
        //system.debug('surveyId from custom settings='+surveyId);
        
        Id apacId = r1.Id; 
        String surveyId= mcs1[0].Survey_Id__c;
        system.debug('surveyId from custom settings='+surveyId);
        String recordTypeId= mcs1[0].RecordTypeId__c;
        system.debug('record Type Id from custom settings='+recordTypeId);
        
        
       // http://www.zoomerang.com/Survey/WEB22CKC6WPDT4?AccountID=[AccountID_value]&ContactName=[ContactName_value]&RecordTypeID=[RecordTypeID_value]
      // http://www.zoomerang.com/Survey/WEB22CKQLRWYQ7?AccountName=[AccountName_value]&ContactName=[ContactName_value]&RecordTypeID=[Value]
      // http://www.zoomerang.com/Survey/WEB22CM6M3T3ND?AccountID=[AccountID_value]&ContactName=[ContactName_value]&Category=[Category_value]
       
        
        //PageReference pageRef = new PageReference('http://www.zoomerang.com/Survey/'+surveyId+'?AccountID='+accId+'&ContactName='+conName+'&RecordTypeID='+recordTypeId+'&SurveryId='+apacId);    
        PageReference pageRef = new PageReference( Label.Zoomerang_Survey +surveyId+'?AccountID='+accId+'&ContactName='+conName+'&RecordTypeID='+recordTypeId+'&SurveryId='+apacId);    
        pageRef.setRedirect(true);
        return pageRef;     
    
    } 
    
    
}