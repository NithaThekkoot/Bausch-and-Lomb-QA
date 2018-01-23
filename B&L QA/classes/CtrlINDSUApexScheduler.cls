/**
 * 
 *   INDSU controller for the Scheduler page. 
 *
 *   Author             |Author-Email                            |Date       |Comment
 *   -------------------|----------------------------------------|-----------|--------------------------------------------------
 *   Balaji             |balaji.prabakaran@listertechnologies.com|17.04.2010 |Reuse of CtrlAPACApexScheduler
 *
 */
public with sharing class CtrlINDSUApexScheduler {

  public void populateCallSummary(){
    ClsReportsDataScheduler scheduler = new ClsReportsDataScheduler();
    String strSchedule = '0 0 1 * * ?';
    system.schedule('INDSU Populate Call Summary', strSchedule, scheduler);
  }
}