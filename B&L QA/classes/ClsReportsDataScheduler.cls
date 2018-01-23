/**
 * 
 *   INDSU Scheduler to call the method to populate empty Call Summary records for all Sales and Service Executives. 
 *
 *   Author             |Author-Email                            |Date       |Comment
 *   -------------------|--------------------------------------  |-----------|--------------------------------------------------
 *   Balaji             |balaji.prabakaran@listertechnologies.com|30.04.2010 |Reuse of this class from ClsReportsDataScheduler
 *
 */
global class ClsReportsDataScheduler implements Schedulable{ 
  global void execute(SchedulableContext SC) {
    ClsPopulateCallSummary populateCallSummary = new ClsPopulateCallSummary();
        populateCallSummary.Populate();
  }
}