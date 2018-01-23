/*
* First Draft : Kuldeep 
* 
* Test Class  : Test_Campaign_update_Sales_rep_info
*
*/

trigger Campaign_update_Sales_rep_info on Campaign (before update) 
{
    private string RECORD_TYPE_NAME_USSUR = 'USSUR Dr Dinners';
//private string Salesinfo; 
RecordType rt = [select id from recordtype where name =: RECORD_TYPE_NAME_USSUR and sobjecttype ='Campaign'];
set <id> cmp_owner_id = new set<id>();

    for (campaign cm : trigger.new)
    {
        if (cm.RecordTypeId == rt.id)
        {
            if (cm.OwnerId != trigger.oldmap.get(cm.id).ownerid)
                {
                    cmp_owner_id.add(cm.ownerid);
                }
        
        }
    }
    
    map <id, user> map_user_info = new map <id, user> ([select id , Firstname,LastName,mobilephone,email from user where id In: cmp_owner_id ]);
    
    for (campaign ccc : trigger.new)
    {
        if (ccc.OwnerId != trigger.oldmap.get(ccc.id).ownerid)
        
        {
            if (map_user_info.containsKey(ccc.ownerid))
            {
                String mobile =map_user_info.get(ccc.ownerid).MobilePhone;
                if (mobile ==null){
                    mobile=' ';
                }
                String email=map_user_info.get(ccc.ownerid).Email;
                if (email==null){
                    email=' ';
                }
                
                ccc.Sales_Rep__c = map_user_info.get(ccc.ownerid).Firstname +' '+ map_user_info.get(ccc.ownerid).LastName + ' Cell Phone: '+mobile+' '+email+'.';
            }
        }   
    }
       
 
    

}