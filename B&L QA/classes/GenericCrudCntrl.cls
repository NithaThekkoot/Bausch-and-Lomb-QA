public with sharing class GenericCrudCntrl{
    
    
	//To read records with query
	@AuraEnabled
    public static OutputWrapper ReadSObjects(String query){
        OutputWrapper wrapObj = new OutputWrapper();
        String sObjectApiName='';
        String sObjectLabel='';
        Boolean success = false;
        List<SObject> sObjList = new List<SObject>();
        
        try{
            sObjList = Database.query(query);
            if(!sObjList.isEmpty()){
                SObjectType type=sObjList[0].getSObjectType();
                Schema.DescribeSObjectResult sobjectDescribe=type.getDescribe();
                sObjectApiName=String.valueof(sObjList[0].getSObjectType());
                sObjectLabel=sobjectDescribe.label;
                success = true;
            }
            wrapObj.sObjList = sObjList;
            wrapObj.sObjectLabel = sObjectLabel;
            wrapObj.sObjectApiName=sObjectApiName;
            wrapObj.success = success;
            
        }Catch(Exception e){
            wrapObj.sObjList = null;
            wrapObj.sObjectLabel = null;
            wrapObj.sObjectApiName=null;
            wrapObj.success = success;
		}
        return wrapObj;
    }
    
    
	//To insert records with sObject list
	@AuraEnabled
    public static List<DMLOutputWrapper> InsertSObjects( List<SObject> inputSObjectList){
        
        List<DMLOutputWrapper> wrapDMLObjList = new List<DMLOutputWrapper>();
        Boolean success = null;
        Id sObjID = null ;
       
        Database.SaveResult[] srList = Database.insert(inputSObjectList, false);
        for(Database.SaveResult sr : srList){
            DMLOutputWrapper wrapDMLObj = new DMLOutputWrapper();
            List<String> errorCodeList = new List<String>();
            success = sr.isSuccess();
            if(success){
                sObjID = sr.getId();
            }
            else{
                sObjID = null;
                for(Database.Error err : sr.getErrors()){
                    errorCodeList.add(err.getMessage());
                }
            }
            wrapDMLObj.sObjID = sObjID;
            wrapDMLObj.success = success;
            wrapDMLObj.errorCodeList =errorCodeList;
            wrapDMLObjList.add(wrapDMLObj);
            
        }
        
        return wrapDMLObjList;
    }
    
    
	//To update records with sObject list
	@AuraEnabled
    public static List<DMLOutputWrapper> UpdateSObjects( List<SObject> inputSObjectList){
        List<DMLOutputWrapper> wrapDMLObjList = new List<DMLOutputWrapper>();
        Boolean success = null;
        Id sObjID = null  ;
        
        Database.SaveResult[] srList = Database.update(inputSObjectList, false);
        
        for(Database.SaveResult sr : srList){
            DMLOutputWrapper wrapDMLObj = new DMLOutputWrapper();
            List<String> errorCodeList = new List<String>();
            success = sr.isSuccess();
            if(success){
                sObjID = sr.getId();
            }
            else{
                sObjID = null;
                for(Database.Error err : sr.getErrors()){
                    errorCodeList.add(err.getMessage());
                }
            }
            wrapDMLObj.sObjID = sObjID;
            wrapDMLObj.success = success;
            wrapDMLObj.errorCodeList =errorCodeList;
            wrapDMLObjList.add(wrapDMLObj);
        }
        return wrapDMLObjList;
    }
    
    
	//To delete records with Id list
	@AuraEnabled
    public static List<DMLOutputWrapper> DeleteSObjects( List<SObject> inputSObjectList){
        List<DMLOutputWrapper> wrapDMLObjList = new List<DMLOutputWrapper>();
        List<String> errorCodeList = new List<String>();
        Boolean success = null;
        Id sObjID = null  ;
        Database.DeleteResult[] srList = Database.delete(inputSObjectList,false);
        
        for(Database.DeleteResult sr : srList){
            errorCodeList = new List<String>();
            DMLOutputWrapper wrapDMLObj = new DMLOutputWrapper();
            success = sr.isSuccess();
            
            if(success){
                sObjID = sr.getId();
            }
            else{
                for(Database.Error err : sr.getErrors()){
                    errorCodeList.add(err.getMessage());
                }
            }
            wrapDMLObj.sObjID = sObjID;
            wrapDMLObj.success = success;
            wrapDMLObj.errorCodeList =errorCodeList;
            wrapDMLObjList.add(wrapDMLObj);
        }
        return wrapDMLObjList;
    }
    
    
    //To delete records with Id list
	@AuraEnabled
    public static User getCurrentUser(){
        
        User userInfoX = new User();
        userInfoX.FirstName = UserInfo.getFirstName();
        userInfoX.LastName = UserInfo.getLastName();
        userInfoX.profileId = UserInfo.getProfileId();
        userInfoX.Email = UserInfo.getUserEmail();
        
        return userInfoX;
        
    }
    
    public class OutputWrapper{
        @AuraEnabled
        public List<SObject> sObjList;
        @AuraEnabled
        public String sObjectLabel;
        @AuraEnabled
        public String sObjectApiName;
        @AuraEnabled
        public Boolean success;
        
    }
    
    public class DMLOutputWrapper{
        
        @AuraEnabled
        public Id sObjID;
        @AuraEnabled
        public Boolean success;
        @AuraEnabled
        public List<String> errorCodeList ;
        @AuraEnabled
        public sObject record ;
    }
    
}