/*******************************************************************************
 *  The Util is help TrgOtherCallActivity to preventing more than one activity in a half date
 *  copyright (c) 2011 breakingpoint.com C, Ltd. 
 *  Apex Class      : UtilOtherCallActivity.cls
 *  Summary         : There should be no more than one activity in a half date
 *  Refer Object    : Other_Call_Activity__c
 *  Author          : Mouse.liu(mouse.liu@ibreakingpoint.com)　       
 *  CreatedDate     : 2011/09/26
 *  Change Log      : 
 ******************************************************************************/
public with sharing class CHNSU_UtilOtherCallActivity {
    
    public static void addError(List<Other_Call_Activity__c> context, Other_Call_Activity__c n) {
        
        context[0].addError(System.label.CHNSU_Other_Call_Activity_Error_Msg_1 +
                            ' <a href = "/' + n.Id + '" > [' + n.Name +']</a>' + 
                            System.label.CHNSU_Other_Call_Activity_Error_Msg_2 + 
                            n.Start_Date__c.format() + 
                          //  (n.Start_Session__c == 'AM' ? '上午' : '下午') +
                            (n.Start_Session__c == 'AM' ? System.label.AM : System.label.PM) +
                            System.label.CHNSU_Other_Call_Activity_Error_Msg_3 + 
                            n.End_Date__c.format() + 
                            (n.End_Session__c == 'AM' ? System.label.AM : System.label.PM));
                            
    }
    
    //Gmt is standard datetime, Shanghai is (UTC+08:00)北京，重庆，香港特别行政区，乌鲁木齐
    public static Datetime parseDatetime(String session, Date sDate, Boolean isStart) {
        
        if(session == 'AM' && isStart) {
            return Datetime.newInstanceGmt(sDate, Time.newInstance(09,00, 0, 0)).addHours(-8);
        }
        else if(session == 'PM' && isStart) {
            return Datetime.newInstanceGmt(sDate, Time.newInstance(13,00, 0, 0)).addHours(-8);
        }
        else if(session == 'AM' && !isStart){
            return Datetime.newInstanceGmt(sDate, Time.newInstance(12,00, 0, 0)).addHours(-8);
        }
        
        return Datetime.newInstanceGmt(sDate, Time.newInstance(18,00, 0, 0)).addHours(-8);
    }

    //Gmt is standard datetime, India  is (GMT+05:30)SandeepKumar.Gaddam
    public static Datetime parseDatetime_Ind(String session, Date sDate, Boolean isStart) {
        
        if(session == 'AM' && isStart) {
            return Datetime.newInstanceGmt(sDate, Time.newInstance(09,30, 0, 0)).addHours(-6);
        }
        else if(session == 'PM' && isStart) {
            return Datetime.newInstanceGmt(sDate, Time.newInstance(13,30, 0, 0)).addHours(-6);
        }
        else if(session == 'AM' && !isStart){
            return Datetime.newInstanceGmt(sDate, Time.newInstance(12,30, 0, 0)).addHours(-6);
        }
        
        return Datetime.newInstanceGmt(sDate, Time.newInstance(18,30, 0, 0)).addHours(-6);
    }    
}