/**
 * Test Class to test Send Mail for Notifications to Sales Reps and Managers for Open Physician Visit
 *
 *   Author             |Author-Email                                      |Date       |Comment
 *   -------------------|--------------------------------------------------|-----------|--------------------------------------------------
 *   Tarun Solanki      |tarun.solanki@bausch.com                          |18.12.2013 |First Draft 
 *
 * Class -- CtrlAdminNotifyVisits
 * 
 */
@isTest
private class Test_AdminNotifyVisits{
    public static testmethod void testAdminNotifyVisits() {
       Test_ScheduleNotifyPhysicianVisits.FetchPhysicians();
       CtrlAdminNotifyVisits controller = new CtrlAdminNotifyVisits();
       controller.SendMailManagers();
       controller.SendMailSalesReps();
       
   }
}