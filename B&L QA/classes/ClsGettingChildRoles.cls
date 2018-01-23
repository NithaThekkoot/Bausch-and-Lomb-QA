/*
* 
* This class is used to check the hierarchies
*
* Author                        |Author-Email                                                |Date        |Comment
* ------------------------------|----------------------------------------------------------- |------------|-------------------------------------------------------------
* Raja B.,                      |rajamaruthu.balasubramanian@listertechnologies.com          |15.12.2010  |First Draft
*
* Test Class: Test_coachingReport_BIU_CalculateScores
*/
public with sharing class ClsGettingChildRoles {
	
	public static Set<Id> listofChild = new Set<Id>();
    public static Map<Id,Set<ID>> mapParentRolewithChild = new Map<Id,Set<ID>>();
   
   //Get child for the given role id and the profile name
    public static Set<Id> getChild(Id roleId, String profileName){
    	
        listofChild = new Set<Id>();
        mapParentRolewithChild = new Map<Id,Set<ID>>();
        
        Set<Id> TempList = new Set<Id>();
        String sSQL = 'Select Id,name,parentroleId from userrole where name like \'' + profileName + '%\'';

		//Get the user role
        for(UserRole ur : Database.query(sSQL)){
        	
            if(ur.parentRoleId != null){
            	
                tempList = new Set<Id>();
                if(!mapParentRolewithChild.containsKey(ur.parentRoleId)){
                    templist.add(ur.Id);
                    mapParentRolewithChild.put(ur.parentRoleId,tempList);
                }
                else{
                    tempList = mapParentRolewithChild.get(ur.parentRoleId);
                    templist.add(ur.Id);
                    mapParentRolewithChild.put(ur.parentRoleId,tempList);
                }
            
            
            }
        }
       
        Set<Id> prnt = new Set<Id>();
        prnt.add(roleId);
        
       return getChildRoles(prnt);
    }
    
    //Get the child roles
    public static Set<Id> getChildRoles(Set<Id> parentList){
    	
        for(Id parentId : parentList){
        	
            if(mapParentRolewithChild.containsKey(parentId)){
            	
                listofChild.addAll(mapParentRolewithChild.get(parentId));
                getCHildRoles(mapParentRolewithChild.get(parentId));
            }
        }
        
        return listofChild;
    }

}