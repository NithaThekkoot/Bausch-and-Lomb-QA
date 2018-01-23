/**
* 
*   This trigger prevents Chatter posts from being deleted if they are associated with an EMEA Service Case.
*
*    Author         |Author-Email                   |Date       |Comment
*    ---------------|-------------------------------|-----------|--------------------------------------------------
*    S Cardinali    |samantha.cardinali@bausch.com  |09.04.2013 |First Draft
*
*/
trigger chatter_bd_preventEMEACaseDelete on FeedItem (before Delete) {

    String sCaseKeyPrefix = Case.sObjectType.getDescribe().getKeyPrefix();
    ID idEMEACaseRT = ClsUtility.getRecordTypeId('Case','EMEA Service Case');
    ID idSysAdminSSO = ClsUtility.getProfileId('BL: System Admin SSO');
    
    If(UserInfo.getProfileId() != idSysAdminSSO || Test.isRunningTest()) {

    Set<ID> set_CaseIds = new Set<ID>();
   
    for (FeedItem f: trigger.old) {
        String sParentId = f.parentId;
        if (sParentId.startsWith(sCaseKeyPrefix) && f.Type == 'TextPost') {
            set_CaseIds.add(f.ParentId);
        }
    }

    if(set_CaseIds.size() > 0) {
        List<Case> list_Cases = [SELECT Id FROM Case WHERE Id IN :set_CaseIds AND RecordTypeId = :idEMEACaseRT LIMIT 999];
        for (FeedItem f: trigger.old) {
            for (Case c : list_Cases) {
                if(f.ParentId == c.Id) {
                    f.addError('You cannot delete Chatter posts from EMEA Service Cases, as these are used for Credit Approvals.');
                }
            }
        }
    }
    }
}