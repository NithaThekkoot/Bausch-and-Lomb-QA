/**
 * Controller Class to Send Mail for Notifications to Sales Reps and Managers for Open Physician Visit
 *
 *   Author             |Author-Email                                      |Date       |Comment
 *   -------------------|--------------------------------------------------|-----------|--------------------------------------------------
 *   Tarun Solanki      |tarun.solanki@bausch.com                          |18.12.2013 |First Draft 
 *
 * Test Class -- Test_AdminNotifyVisits
 * 
 */
public Class CtrlAdminNotifyVisits {

    public CtrlAdminNotifyVisits(){
        
    }
    
    //Mail to Managers
    public void SendMailManagers(){
        //instance for sending open physician visits to managers.
        CtrlNotifyPhysicianVisitsManagers controllerObject = new CtrlNotifyPhysicianVisitsManagers();
        controllerObject.sendMail();
    }
    //Mail to Sales rep
    public void SendMailSalesReps(){
        //instance of batch class for sending open physician visits to sales reps.
       Batch_NotifyPhysicianVisits controller = new Batch_NotifyPhysicianVisits() ;  
       Integer batchSize = 1;  
       database.executebatch(controller , batchSize);  
    }
}