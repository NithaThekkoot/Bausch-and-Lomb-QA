trigger surveyScores_BI_setCSSpecialist on Survey_Score__c (before insert) {

 ID rtEMEASurvey = clsUtility.getRecordTypeId('Survey_score__c','EMEA Survey Record');
 for(Survey_Score__c s : Trigger.New) {
    if(s.RecordType.Id == rtEMEASurvey) {
        if(s.Survey_Source__c == 'Manual') {
            s.CS_Specialist__c = UserInfo.getUserId();
        }
    }
 }

}